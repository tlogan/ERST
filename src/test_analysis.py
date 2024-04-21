from __future__ import annotations

from typing import *
from dataclasses import dataclass

import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser
from tapas.slim import analyzer, language

from tapas.util_system import box, unbox

from pyrsistent import m, s, pmap, pset
from pyrsistent.typing import PMap, PSet 

import pytest
from tapas.slim.language import analyze 

def raise_guide(guides : list[analyzer.Guidance]):
    for guide in guides:
        if isinstance(guide, Exception):
            raise guide

def analyze_stream(code : list[str], debug = False):
    async def _mk_task():

        connection = language.launch()

        guides = []
        for piece in code + [language.Kill()]:
            g = await connection.mk_caller(piece)
            guides.append(g)
            print()
            print(f"--------------------------")
            print(f"--- client's guidance: << {g} >>")
            print(f"--------------------------")
            print()
            if isinstance(g, language.Done):
                break


        ctx = await connection.mk_getter()
        typ_var = analyzer.default_nonterm.typ_var
        return (ctx.worlds if ctx else None, typ_var, guides, connection.to_string_tree(ctx) if ctx else None)

    (worlds, typ_var, guides, parsetree) = asyncio.run(_mk_task())
    if debug:
        raise_guide(guides)

    return (worlds, typ_var, guides, parsetree)

def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

def print_worlds(worlds : Iterable[analyzer.World]):
    for i, world in enumerate(worlds):
        constraints_str = "".join([ 
            f"---{analyzer.concretize_constraints(tuple([st]))}" + "\n"
            for st in world.constraints
        ])
        
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG WORLD {i}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
world.freezer: {world.freezer}

world.constraints: 
{constraints_str}

world.relids: {world.relids}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)


def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 

def simp(t):
    return analyzer.simplify_typ(t)


solver = analyzer.Solver() 

def solve(a : str, b : str):
    x = p(a)
    y = p(b)
    return solver.solve_composition(x, y)

def decode_negative(worlds, t):
    return analyzer.concretize_typ((analyzer.simplify_typ(solver.decode_with_polarity(False, worlds, t))))

def decode_positive(worlds, t):
    return analyzer.concretize_typ((analyzer.simplify_typ(solver.decode_with_polarity(True, worlds, t))))

def roundtrip(ss : list[str]) -> str:
    return analyzer.concretize_typ(analyzer.simplify_typ(analyzer.make_unio([
        p(s) for s in ss
    ])))


"""
tests
"""

def test_typ_implication():

    p = language.parse_typ("X -> Y -> Z")
    assert p 
    c = analyzer.concretize_typ(p) 
    print(c)
    assert c == "(X -> (Y -> Z))"



def test_typ_LFP():
    d = ('''
LFP self ~nil @ | ~cons self
    ''')
    assert u(p(d)) == "LFP self (~nil @ | ~cons self)"
    # print(u(t))


nat = ('''
LFP N BOT 
    | ~zero @  
    | ~succ N 
''')

even = ('''
LFP E BOT 
    | ~zero @ 
    | ~succ ~succ E
''')

nat_list = ('''
LFP NL BOT 
    | (~zero @, ~nil @) 
    | EXI [N L ; (N, L) <: NL] (~succ N, ~cons L)  
''')

even_list = ('''
LFP NL BOT 
    | (~zero @, ~nil @) 
    | EXI [N L ; (N, L) <: NL] (~succ ~succ N, ~cons ~cons L)  
''')



nat_equal = ('''
LFP SELF BOT 
    | (~zero @, ~zero @) 
    | EXI [A B ; (A, B) <: SELF] (~succ A, ~succ B)  
''')




addition_rel = (f'''
LFP AR BOT 
    | (EXI [Y Z ; (Y, Z) <: ({nat_equal})] (x : ~zero @ & y : Y & z : Z))
    | (EXI [X Y Z ; (x : X & y : Y & z : Z) <: AR] (x : ~succ X & y : Y & z : ~succ Z))
''')



def test_zero_subs_nat():
    zero = ('''
~zero @ 
    ''')
    worlds = solve(zero, nat)
    # print(f'len(worlds): {len(worlds)}')
    assert(worlds)

def test_two_subs_nat():
    two = ('''
~succ ~succ ~zero @ 
    ''')
    worlds = solve(two, nat)
    print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_bad_tag_subs_nat():
    bad = ('''
~bad ~succ ~zero @ 
    ''')
    worlds = solve(bad, nat)
    # print(f'len(worlds): {len(worlds)}')
    assert not worlds

def test_two_nat_subs_nat():
    two_nat = (f'''
~succ ~succ ({nat})
    ''')
    worlds = solve(two_nat, nat)
    # print(f'len(worlds): {len(worlds)}')
    assert worlds


def test_even_subs_nat():
    worlds = solve(even, nat)
    assert worlds

def test_nat_subs_even():
    worlds = solve(nat, even)
    # print(f'len(worlds): {len(worlds)}')
    assert not worlds

def test_subs_idx_unio():
    idx_unio = ('''
EXI [N ; N <: TOP] (~thing N)  
    ''')
    thing = ('''
(~thing @)
    ''')

    worlds = solve(thing, idx_unio)
    for world in worlds:
        print(f'world: {analyzer.concretize_constraints(tuple(world.constraints))}')
    assert(worlds)


def test_zero_nil_subs_nat_list():
    global p
    zero_nil = ('''
(~zero @, ~nil @)
    ''')

    worlds = solve(zero_nil, nat_list)
    # print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_one_single_subs_nat_list():
    one_single = ('''
(~succ ~zero @, ~cons ~nil @) 
    ''')
    worlds = solve(one_single, nat_list)
    print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_two_single_subs_nat_list():
    two_single = ('''
(~succ ~succ ~zero @, ~cons ~nil @)
    ''')
    worlds = solve(two_single, nat_list)
    print(f'len(worlds): {len(worlds)}')
    assert not worlds

def test_one_query_subs_nat_list():
    one_query = ('''
(~succ ~zero @, X)
    ''')
    worlds = solve(one_query, nat_list)
    answer = decode_negative(worlds, p("X")) 
    print("answer: " + answer)
    assert answer == "~cons ~nil @"

def test_one_cons_query_subs_nat_list():
    global p
    one_cons_query = ('''
(~succ ~zero @, ~cons X)
    ''')
    worlds = solve(one_cons_query, nat_list)
    answer = decode_negative(worlds, p("X"))
    print(f"""
answer: {answer}
    """)
    assert answer == "~nil @"


def test_two_cons_query_subs_nat_list():
    two_cons_query = ('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    worlds = solve(two_cons_query, nat_list)
    answer = decode_negative(worlds, p("X"))
    print(f"""
answr: {answer}
    """)
    assert answer == "~cons ~nil @"

def test_even_list_subs_nat_list():
    try:
        worlds = solve(even_list, nat_list)
        print(f"len(worlds): {len(worlds)}")
        # assert worlds
    except RecursionError:
        print("RECURSION ERROR")

def test_nat_list_subs_even_list():
    worlds = solve(nat_list, even_list)
    print(f"len(worlds): {len(worlds)}")
    assert not worlds


def test_one_plus_one_equals_two():
    print("==================")
    print(addition_rel)
    print("==================")
    one_plus_one_equals_two = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @)
    ''')
    worlds = solve(one_plus_one_equals_two, addition_rel)
    print(f'len(worlds): {len(worlds)}')
    # assert len(worlds) == 1
    for world in worlds:
        print(f'''
    world: {analyzer.concretize_constraints(tuple(world.constraints))}
        ''')

def test_plus_one_equals_query():
    # NOTE: potential infinite loop
    print("==================")
    print(addition_rel)
    print("==================")
    query = ('''
(x : X & y : ~succ ~zero @ & z : Z)
    ''')
    worlds = solve(query, addition_rel)
    print(f'len(worlds): {len(worlds)}')
    # assert len(worlds) == 1
    for world in worlds:
        print(f'''
    world: {analyzer.concretize_constraints(tuple(world.constraints))}
        ''')

def test_one_plus_one_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : Z)
    ''')
    worlds = solve(one_plus_one_query, addition_rel)
    answer = decode_negative(worlds, p("Z"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "~succ ~succ ~zero @"

def test_one_plus_equals_two_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : Y & z : ~succ ~succ ~zero @ )
    ''')
    worlds = solve(one_plus_one_query, addition_rel)
    answer = decode_negative(worlds, p("Y"))
    assert answer == "~succ ~zero @"
    print(f'''
answer: {answer}
    ''')

def test_zero_plus_one_equals_two():
    zero_plus_one_equals_two = ('''
(x : ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    worlds = solve(zero_plus_one_equals_two, addition_rel)
    assert not worlds


def test_plus_one_equals_two_query():
    plus_one_equals_two_query = ('''
(x : X & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    worlds = solve(plus_one_equals_two_query, addition_rel)
    answer = decode_negative(worlds, p("X"))
    assert answer == "~succ ~zero @"
#     print(f'''
# answer: {answer}
#     ''')

def test_plus_equals_two_query():
    print("==================")
    print(addition_rel)
    print("==================")
    plus_equals_two_query = ('''
(x : X & y : Y & z : ~succ ~succ ~zero @)
    ''')
    worlds = solve(plus_equals_two_query, addition_rel)
    answer = decode_negative(worlds, p("(X, Y)"))
    print(f'''
answer: {answer}
    ''')
    assert answer == roundtrip([
        "(~zero @, ~succ ~succ ~zero @)",
        "(~succ ~zero @, ~succ ~zero @)",
        "(~succ ~succ ~zero @, ~zero @)",
    ])



list_nat_diff = ('''
(LFP self (
    (~nil @, ~zero @) | 
    (EXI [l n ; (l, n) <: self] ((~cons l \\ ~nil @), ~succ n))
))
''')

# list_nat_diff = "((~nil @, ~zero @) | ([| L N . (L, N) <: LFP SELF ((~nil @, ~zero @) | ([| L N . (L, N) <: SELF ] ((~cons L \ ~nil @), ~succ N))) ] ((~cons L \ ~nil @), ~succ N)))"

# (~nil @, _2) <: ((~nil @, ~zero @) | (EXI [l n ; (l, n) <: LFP self ((~nil @, ~zero @) | (EXI [l n ; (l, n) <: self] ((~cons l \ ~nil @), ~succ n)))] ((~cons l \ ~nil @), ~succ n)))

def test_nil_query_subs_list_nat_diff():
    nil_query = ('''
(~nil @, X)
    ''')
    worlds = solve(nil_query, list_nat_diff)
    answer = decode_negative(worlds, p("X"))
    assert answer == "~zero @" 

def test_cons_nil_query_subs_list_nat_diff():
    cons_nil_query = ('''
((~cons ~nil @), X)
    ''')
    worlds = solve(cons_nil_query, list_nat_diff)
    answer = decode_negative(worlds, p("X"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "~succ ~zero @" 

list_diff = ('''
LFP SELF (~nil @ | (~cons SELF \\ ~nil @))
''')

def test_cons_nil_subs_list_diff():
    cons_nil = ('''
(~cons ~nil @) 
    ''')
    worlds = solve(cons_nil, list_diff)
    print(f'len(worlds): {len(worlds)}')
    assert worlds


list_imp_nat = (f'''
(ALL [X ; X <: ({list_diff})] (X -> 
    (EXI [Y ; (X, Y) <: ({list_nat_diff})] Y)
))) 
''')

def test_list_imp_nat_subs_nil_imp_query():

    nil_imp_query = ('''
(~nil @ -> Q)
    ''')
    worlds = solve(list_imp_nat, nil_imp_query)
    answer = decode_positive(worlds, p("Q"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "~zero @" 

def test_list_imp_nat_subs_cons_nil_imp_query():
    nil_imp_query = ('''
((~cons ~nil @) -> Q)
    ''')
    worlds = solve(list_imp_nat, nil_imp_query)
    answer = decode_positive(worlds, p("Q"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "~succ ~zero @"


def test_list_imp_nat_subs_cons_cons_nil_imp_query():
    cons_cons_nil_imp_query = ('''
((~cons ~cons ~nil @) -> Q)
    ''')
    worlds = solve(list_imp_nat, cons_cons_nil_imp_query)
    answer = decode_positive(worlds, p("Q"))
    assert answer == "~succ ~succ ~zero @"
    print(f'''
answer: {answer}
    ''')

def test_bot_subs_cons_nil_diff():

    cons_nil_diff = ('''
((~cons L) \ ~nil @)
    ''')

    bot = ('''
(BOT)
    ''')
    worlds = solve(bot, cons_nil_diff)
    assert len(worlds) == 1
    print(f'''
len(worlds): {len(worlds)}
    ''')


"""
Type inference
"""

def test_var():
    code = '''
x
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert not worlds 
    assert not parsetree 


def test_unit():
    code = '''
@
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert parsetree == "(expr (base @))"
    # print("parsetree: " + str(parsetree))
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_tag():
    code = '''
~uno @
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # assert parsetree == "(expr (base ~ uno (base @)))"
    # print(parsetree)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~uno @"

def test_tuple():
    code = '''
@, @, @
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print(parsetree)
    print(decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "(@, (@, @))"

def test_record():
    code = '''
_.uno = @ 
_.dos = @
    '''
# uno:= @  dos:= @
    (worlds, typ_var, parsetree) = analyze(code)
    # assert parsetree == "(expr (base (record _. uno = (expr (base @)) (record _. dos = (expr (base @))))))"
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "(uno : @ & dos : @)"


def test_function():
    code = '''
case ~nil @ => @ 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print(parsetree)
    print(f"answer: {decode_positive(worlds, typ_var)}")
    assert decode_positive(worlds, typ_var) == "(~nil @ -> @)"

def test_function_cases_disjoint():
    code = '''
case ~uno @ => ~one @ 
case ~dos @ => ~two @ 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "((~uno @ -> ~one @) & (~dos @ -> ~two @))"
    # TODO: update once diffs are enabled 
    # assert decode_positive(worlds, typ_var) == "(~uno @ -> ~one @) & (~dos @ \ ~uno @ -> ~two @)"

def test_function_cases_overlap():
    code = '''
case ~uno @ => ~one @ 
case x => ~two @ 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # TODO: use type_equiv, instead of syntax equiv.
    # there is some non-determinism in variable names
    # assert decode_positive(worlds, typ_var) == "(EXI [ ; _7 <: _6] ((~uno @ -> ~one @) & (ALL [_10 ; _10 <: _7] (_10 -> ~two @))))"

def test_projection():
    code = '''
(_.uno = ~one @ _.dos = ~two @).uno
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~one @"

def test_projection_chain():
    code = '''
(_.uno = (_.dos = ~onetwo @) _.one = @).uno.dos
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~onetwo @"

def test_app_identity_unit():
    code = '''
(case x => x)(@)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_app_pattern_match_nil():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~nil @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_app_pattern_match_cons():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~cons @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_app_pattern_match_fail():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~fail @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert decode_positive(worlds, typ_var) == "BOT"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_application_chain():
    code = '''
(case ~nil @ => case ~nil @ => @)(~nil @)(~nil @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_let():
    code = '''
let x = @ ;
x
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # assert parsetree == "(expr let x (target = (expr (base @))) ; (expr (base x)))"
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_idprojection():
    code = '''
let r = (_.uno = @ _.dos = @) ;
r.uno
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_idprojection_chain():
    code = '''
let r = (_.uno = (_.dos = @) _.one = @) ;
r.uno.dos
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_idapplication():
    code = '''
let f = (
    case ~nil @ => @ 
    case ~cons x => x 
) ;
f(~nil @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_idapplication_chain():
    code = '''
let f = (case ~nil @ => case ~nil @ => @) ;
f(~nil @)(~nil @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    assert decode_positive(worlds, typ_var) == "@"
    # print("answer: " + decode_positive(worlds, typ_var))

def test_function_with_var():
    code = '''
case ~nil @ => ~zero @ 
case ~cons x => (~succ x) 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_functional():
    code = '''
(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_fix():
    code = '''
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    '''
# (_8 -> _11) -> ((~nil @ -> ~zero @) & (~cons _15 -> ~succ _16)))
# expect: _15 <: _8 // _11 <: _16
# actual: _8 <: 15 // _16 <: _11


# given: _8 <: 15 // _16 <: _11
# expect: (15 -> 16) -> (~cons _8 -> ~succ _11) 

    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_identity_function():
    code = '''
(case x => x)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "ALL [_2 ; _2 <: _1] _1 -> _1"

def test_unit_funnel_identity():
    code = '''
@ |> (case x => x)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_nil_funnel_fix():
    code = '''
~nil @ |> (fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~zero @"

def test_app_fix_nil():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~nil @) 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~zero @"

def test_app_fix_cons():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~nil @) 
    '''

    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~succ ~zero @"

def test_app_fix_cons_cons():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~cons ~nil @) 
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~succ ~succ ~zero @"


def test_funnel_pipeline():
    code = '''
~nil @ |> (case ~nil @ => @) |> (case @ => ~uno @)
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~uno @"


# fix(case self => (
# case ~nil @ => ~zero @ 
# case ~cons x => ~succ (self(x)) 
# ))

def test_pattern_tuple():
    code = '''
case (~zero @, @) => @
    '''
    (worlds, typ_var, parsetree) = analyze(code)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "((~zero @, @) -> @)"

# function_if_then_else = (f'''
# case x => (
#     (
#     case ~true @ => ~uno @
#     case ~false @ => ~dos @
#     )(x)
# )
# ''')

def test_if_true_then_else():
    if_true_then_else = (f'''
    if ~true @ then
        ~uno @
    else
        ~dos @
    ''')

    (worlds, typ_var, parsetree) = analyze(if_true_then_else)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~uno @"

def test_if_false_then_else():
    if_false_then_else = (f'''
    if ~false @ then
        ~uno @
    else
        ~dos @
    ''')

    (worlds, typ_var, parsetree) = analyze(if_false_then_else)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~dos @"

def test_function_if_then_else():
    function_if_then_else = (f'''
    case x => (
        if x then
            ~uno @
        else
            ~dos @
    )
    ''')
    (worlds, typ_var, parsetree) = analyze(function_if_then_else)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "(_2 -> (~uno @ | ~dos @))"


less_equal = ('''
fix(case self => (
    case (~zero @, x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (~succ x, ~zero @) => ~false @ 
))
''')

def test_less_equal():
    (worlds, typ_var, parsetree) = analyze(less_equal)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

def test_let_less_equal():
    let_less = (f'''
let less_equal = {less_equal} ;
less_equal
    ''')
    (worlds, typ_var, parsetree) = analyze(let_less)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "@"

nat_pair_rel = (f'''
LFP self BOT 
    | (EXI [x ; x <: ({nat})] (~zero @, x))
    | (EXI [a b ; (a, b) <: self] (~succ a, ~succ b))
    | (EXI [x ; x <: ({nat})] (~succ x, ~zero @))
''')


less_equal_rel = (f"""
LFP self  BOT 
    | (EXI [x ; x <: ({nat})] ((~zero @, x), ~true @))
    | (EXI [a b c ; ((a,b),c) <: self] ((~succ a, ~succ b), c))
    | (EXI [x ; x <: ({nat})] ((~succ x, ~zero @), ~false @))
""")

def test_two_less_equal_one_query():
    two_less_equal_one_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @), Z)
    ''')
    worlds = solve(two_less_equal_one_query, less_equal_rel)
    answer = decode_negative(worlds, p("Z"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "~false @"

less_equal_imp = (f'''
(ALL [XY ; XY <: ({nat_pair_rel})] (XY -> 
    (EXI [Z ; (XY, Z) <: ({less_equal_rel})] Z)
))) 
''')

def test_weak_diff():
    left = ('''
(~succ ~zero @)
    ''')
    right = ('''
(~succ W) \\ (EXI [x] (~zero @, x))
    ''')
    worlds = solve(left, right)
    answer = decode_positive(worlds, p("W"))
    print(f"answer: {answer}")
    # assert answer == "(~succ ~succ ~zero @, ~succ ~zero @)" 
    assert answer == "~zero @" 

def test_weak_diff_in_pair():
    left = ('''
((~succ ~zero @), @)
    ''')
    right = ('''
(((~succ W) \\ (EXI [x] (~zero @, x))), @)
    ''')
    worlds = solve(left, right)
    answer = decode_positive(worlds, p("W"))
    print(f"answer: {answer}")
    # assert answer == "(~succ ~succ ~zero @, ~succ ~zero @)" 
    assert answer == "~zero @" 


def test_less_equal_imp_subs_one_two_imp_query():
    two_one_imp_query = ('''
((~succ ~zero @, ~succ ~succ ~zero @) -> Q)
    ''')
    worlds = solve(less_equal_imp, two_one_imp_query)
    answer = decode_positive(worlds, p("Q"))
    print(f"answer: {answer}")
    assert answer == "~true @" 

def test_less_equal_imp_subs_two_one_imp_query():
    two_one_imp_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @) -> Q)
    ''')
    worlds = solve(less_equal_imp, two_one_imp_query)
    answer = decode_positive(worlds, p("Q"))
    print(f"answer: {answer}")
    assert answer == "~false @" 


def test_app_less_equal_zero_one():
    app_less = (f'''
({less_equal})(~zero @, ~succ ~zero @)
    ''')
    (worlds, typ_var, parsetree) = analyze(app_less)
    # print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~true @"


def test_app_less_equal_two_one():
    app_less = (f'''
({less_equal})(~succ ~succ ~zero @, ~succ ~zero @)
    ''')
    (worlds, typ_var, parsetree) = analyze(app_less)
    print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "~false @"


def test_nested_fun():
    nested_fun = (f'''
    case x => (
        (
        case (~true @) => ~uno @ 
        case (~false @) => ~dos @ 
        )(x)
    )
    ''')
    (worlds, typ_var, parsetree) = analyze(nested_fun)
    print("answer: " + decode_positive(worlds, typ_var))
    assert decode_positive(worlds, typ_var) == "((~true @ -> ~uno @) & (~false @ -> ~dos @))"

def test_pattern_match_wrap():
    pattern_match_wrap = (f'''
    let cmp = (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    ) ;
    case (x, y) => (cmp(x, y))
    ''')

    (worlds, typ_var, parsetree) = analyze(pattern_match_wrap)
    print("answer: " + decode_positive(worlds, typ_var))
    # expected typ: ((ALL [ ; _9 <: ~dos @] ((~uno @, _9) -> _9)) & (ALL [ ; _8 <: ~dos @] ((_8, ~uno @) -> _8)))
    # assert decode_positive(worlds, typ_var) == "(X, Y) -> ~dos @"

def test_arg_specialization():
    arg_specialization = (f'''
    let cmp = (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    ) ;
    case (x, y) => (
        if cmp(x, y) then
            y
        else
            x
    )
    ''')

    arg_specialization = (f'''
    let cmp = (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    ) ;
    case (x, y) => (cmp(x, y))
    ''')

    # arg_specialization = (f'''
    # let cmp = (
    #     case (~uno @, ~dos @) => ~true @
    #     case (~dos @, ~uno @) => ~false @ 
    # ) ;
    # case (x, y) => (
    #     (
    #     case ~true @ => y
    #     case ~false @ => x
    #     ) (cmp(x, y)) 
    # )
    # ''')

    (worlds, typ_var, parsetree) = analyze(arg_specialization)
    print("answer: " + decode_positive(worlds, typ_var))
    # expected typ: ((ALL [ ; _9 <: ~dos @] ((~uno @, _9) -> _9)) & (ALL [ ; _8 <: ~dos @] ((_8, ~uno @) -> _8)))
    # assert decode_positive(worlds, typ_var) == "(X, Y) -> ~dos @"

def test_passing_pattern_matching():
    # program = (f'''
    # let cmp = (
    #     case (~uno @, ~dos @) => ~true @
    #     case (~dos @, ~uno @) => ~false @ 
    # ) ;

    # case (x, y) => cmp(x, y)
    # ''')


    # program = (f'''
    # (
    #     case (~uno @, ~dos @) => ~true @
    #     case (~dos @, ~uno @) => ~false @ 
    # ) |> (case cmp => 
    # case (x, y) => cmp(x, y)
    # )
    # ''')

    program = (f'''
    (case cmp => (case (x, y) => cmp(x, y))) (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    )
    ''')

    (worlds, typ_var, parsetree) = analyze(program)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "..."


max = (f'''
let less_equal = {less_equal} ;
case (x, y) => (
    if less_equal(x, y) then
        y
    else
        x
)
''')

def test_recursion_wrapper():

    program = (f'''
    case (x, y) => (
        ({less_equal})(x, y)
    )
    ''')

    # try:
    (worlds, typ_var, parsetree) = analyze(program)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"
    # except Exception:
    #     print("exception raised")



def test_max():

    max = (f'''
    let less_equal = {less_equal} ;
    case (x, y) => (
        (
        case (~true @) => y 
        case (~false @) => x 
        )(less_equal(x, y))
    )
    ''')

    max = (f'''
    let less_equal = {less_equal} ;
    case (x, y) => (
        if less_equal(x, y) then
            y
        else
            x
    )
    ''')


    # max = less_equal

    # try:
    (worlds, typ_var, parsetree) = analyze(max)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"
    # except Exception:
    #     print("exception raised")


add = (f'''
fix (case self => ( 
    case (~zero @, b) => b 
    case (~succ a, c) => ~succ (self(a, c))
))
''')

######## DEBUG #######
add = (f'''
fix (case self => ( 
    case (~zero @, b) => b 
    case (~succ a, c) => c 
))
''')
#######################

def test_add():
    (worlds, typ_var, parsetree) = analyze(add)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_exi_add_rel_subs_query():
    exi_add = '''
(EXI [Y ; (~zero @, ~zero @) <: X ; (X, Y) <: (LFP self ((EXI [B] ((~zero @, B), B)) | (EXI [B A] ((~succ A, B), B))))] Y)
    '''
    query = ('''
Q
    ''')
    worlds = solve(exi_add, query)
    answer = decode_positive(worlds, p("Q"))
    print(f"answer: {answer}")
    # assert answer == "~zero @" 


def test_add_imp_subs_zero_zero_imp_query():

    add_imp = '''
(ALL [X ; X <: (LFP self ((EXI [B] (~zero @, B)) | (EXI [B A] (~succ A, B))))] (X -> (
    EXI [Y ; (X, Y) <: (LFP self ((EXI [B] ((~zero @, B), B)) | (EXI [B A] ((~succ A, B), B))))] Y
))) 
    '''
    zero_zero_imp_query = ('''
((~zero @, ~zero @) -> Q)
    ''')

    worlds = solve(add_imp, zero_zero_imp_query)
    answer = decode_positive(worlds, p("Q"))
    print(f"answer: {answer}")
    # assert answer == "~zero @" 


def test_add_zero_and_zero_equals_zero():
    # TODO: need to generate an equality constraint when the same variable is used
    # NOTE: would extrusion work for this?
    # Either 34 should not be frozen; or the subtyping should be in the opposite direction _34 <: ~zero
    code = f"""
({add})(~zero @, ~zero @)
    """
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_add_one_and_two_equals_three():
    code = f"""
({add})(~succ ~zero @, ~succ ~succ ~zero @)
    """
    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"


fib = (f'''
let add = {add} ;
fix (case self => ( 
    case (~zero @) => ~zero @
    case (~succ ~zero @) => ~succ ~zero @
    case (~succ ~succ n) => add((self)(~succ n), (self)(n))
))
''')

def test_fib():
    (worlds, typ_var, parsetree) = analyze(fib)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"


def test_application_in_tuple():

    code = (f'''
    let f = (case x => x) ;
    let g = (case x => x) ;
    (f)(@), (g)(@)
    ''')

    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "(@, @)"

def test_generalized_application_in_tuple():
    # TODO: this requires add generalization in the combine_function rule
    code = (f'''
    let f = (case x => x) ;
    (f)(@), (f)(@)
    ''')

    (worlds, typ_var, parsetree) = analyze(code)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "(@, @)"

def test_sumr():
    sumr = (f'''
let add = ({add}) ; 
fix (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => add((self)(xs, b), x)
))
    ''')

    (worlds, typ_var, parsetree) = analyze(sumr)
    assert worlds
    print_worlds(worlds)
    # TODO: decode is very slow; make it faster somehow
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_suml():
    suml = (f'''
let add = {add} ; 
fix (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => self(xs, (add)(b, x))
))
    ''')

    (worlds, typ_var, parsetree) = analyze(suml)
    assert worlds
    print_worlds(worlds)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_foldr():
    foldr = (f'''
fix (case self => ( 
    case (f, ~nil @, b) => b
    case (f, ~cons (x, xs), b) => f((self)(f, xs, b), x)
))
    ''')

    (worlds, typ_var, parsetree) = analyze(foldr)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == "@"

def test_foldl():
    foldl = (f'''
fix (case self => ( 
    case (f, ~nil @, b) => b
    case (f, ~cons (x, xs), b) => self(f, xs, (f)(b, x))
))
    ''')

    (worlds, typ_var, parsetree) = analyze(foldl)
    print("answer: " + decode_positive(worlds, typ_var))
    # assert decode_positive(worlds, typ_var) == @"




def test_antecedent_union():
    strong = ('''
(~uno @ -> ~one @) & (~dos @ -> ~two @) 
    ''')

    weak = ('''
((~uno @ | ~dos @) -> Q) 
    ''')
    worlds = solve(strong, weak)
    answer = decode_positive(worlds, p("Q"))
    print(f'''
answer: {answer}
    ''')
    assert answer == "(~two @ | ~one @)" 

def test_consequent_intersection():
    strong = ('''
(@ -> (uno : ~one @)) & (@ -> (dos : ~two @)) 
    ''')

    weak = ('''
(Q -> (uno : ~one @) & (dos : ~two @)) 
    ''')
    worlds = solve(strong, weak)
    answer = decode_negative(worlds, p("Q"))
    print(f'''
answer: {answer}
    ''')
    # assert answer == "@" 

def test_extra_exi():
    strong = ('''
~true @
    ''')
    weak = ('''
(((EXI [X] ~true @) | (EXI [X Y Z ; Z <: LFP self (((EXI [X] ~true @) | (EXI [X Y Z ; Z <: self] Z)) | (EXI [X] ~false @))] Z)) | (EXI [X] ~false @))
    ''')
    worlds = solve(strong, weak)
    print(f"len(worlds): {len(worlds)}")


if __name__ == '__main__':
    # test_application_in_tuple()
    # test_generalized_application_in_tuple()
    # test_add()
    # test_one_plus_one_equals_two()
    # test_one_plus_one_query()

    # test_exi_add_rel_subs_query()
    # test_add_imp_subs_zero_zero_imp_query()
    # test_add_zero_and_zero_equals_zero()
    # test_add_one_and_two_equals_three()
    # test_fib()

    # test_sumr()
    # test_suml()
    # test_foldr()
    # test_foldl()

    #############################
    # test_plus_equals_two_query()
    # test_plus_one_equals_query()
    # test_antecedent_union()
    # test_consequent_intersection()

    ########################
    ## Post refactor tests
    ########################
    # test_function_cases_disjoint()
    # test_function()
    # test_function_with_var()
    # test_functional()
    # test_fix()
    # test_app_identity_unit()
    # test_app_pattern_match_nil()
    ########################
    # test_two_less_equal_one_query()
    # test_app_less_equal_zero_one()
    # test_app_less_equal_two_one()
    # test_less_equal_imp_subs_one_two_imp_query()
    # test_less_equal_imp_subs_two_one_imp_query()
    ########################
    #
    # test_nested_fun()
    # test_all_imp_exi_subs_union_imp()
    # test_if_true_then_else()
    # test_function_if_then_else()
    # TODO
    # test_extra_exi()
    # test_pattern_match_wrap()
    # test_arg_specialization()
    # test_recursion_wrapper()
    # test_max()

    ########################
    # p(less_equal_rel)
    # test_less_equal_imp_subs_two_one_imp_query()
    # test_weak_diff()
    # test_weak_diff_in_pair()
    #########################
    # test_less_equal()
    #
    # TODO
    # test_fix()
    # test_nil_query_subs_list_nat_diff()
    # test_cons_nil_query_subs_list_nat_diff()
    # test_list_imp_nat_subs_nil_imp_query()
    # test_list_imp_nat_subs_cons_nil_imp_query()
    
    ###############
    # test_app_fix_nil()
    # test_app_fix_cons()

    #####################
    # test_zero_nil_subs_nat_list()
    # test_one_single_subs_nat_list()
    # test_two_single_subs_nat_list()
    #####################
    # test_even_list_subs_nat_list()
    # test_nat_list_subs_even_list()
    # test_one_query_subs_nat_list()
    pass

#######################################################################
    # main(sys.argv)
####################
    # interact()
####################

#     test_parse_tree_serialize(f'''
# fix (self => (
#     fun ~nil () => ~zero () 
#     fun ~cons x => ~succ (self(x)) 
# ))
#     ''')

####################

#     test_parse_tree_serialize(f'''
# .hello = ()
# .bye = ()
#     ''')




##############################
 

# _guidance : Union[Symbol, Terminal, Nonterm]
# @property
# def guidance(self) -> Union[Symbol, Terminal, Nonterm]:
#     return self._guidance
# 
# @guidance.setter
# def guidance(self, value : Union[Symbol, Terminal, Nonterm]):
#     self._guidance = value

#def getAllText(self):  # include hidden channel
#    # token_stream = ctx.parser.getTokenStream()
#    token_stream = self.getTokenStream()
#    lexer = token_stream.tokenSource
#    input_stream = lexer.inputStream
#    # start = ctx.start.start
#    start = 0
#    # stop = ctx.stop.stop
#
#    # TODO: increment token position in attributes
#    # TODO: map token position to result 
#    # TODO: figure out a way to get the current position of the parser
#    stop = self.getRuleIndex()
#    # return input_stream.getText(start, stop)
#    print(f"start: {start}")
#    print(f"stoppy poop: {stop}")
#    return "<<not yet implemented>>"
#    # return input_stream.getText(start, stop)[start:stop]

# @contextmanager
# def manage_guidance(self):
#     if not self.overflow():
#         yield
#     self.updateOverflow()
