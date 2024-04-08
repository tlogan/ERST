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

def raise_guide(guides : list[analyzer.Guidance]):
    for guide in guides:
        if isinstance(guide, Exception):
            raise guide

def analyze(pieces : list[str], debug = False):
    async def _mk_task():

        connection = language.launch()

        guides = []
        for piece in pieces + [language.Kill()]:
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
        return (ctx.models if ctx else None, typ_var, guides, connection.to_string_tree(ctx) if ctx else None)

    (models, typ_var, guides, parsetree) = asyncio.run(_mk_task())
    if debug:
        raise_guide(guides)

    return (models, typ_var, guides, parsetree)

def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

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

def query_weak_side(a : str, b : str, k : str):
    x = p(a)
    y = p(b)
    q = p(k)
    models = solver.solve_composition(x, y) 
    return analyzer.concretize_typ(analyzer.simplify_typ(solver.decode_with_polarity(False, models, q)))

def query_strong_side(a : str, b : str, k : str):
    x = p(a)
    y = p(b)
    q = p(k)
    models = solver.solve_composition(x, y) 
    return analyzer.concretize_typ(analyzer.simplify_typ(solver.decode_with_polarity(True, models, q)))


def decode(models, typ_var):
    return (analyzer.simplify_typ(solver.decode_with_polarity(True, models, typ_var)))

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
    | EXI [Y Z ; (Y, Z) <: ({nat_equal})] (x : ~zero @ & y : Y & z : Z) 
    | EXI [X Y Z ; (x : X & y : Y & z : Z) <: AR] (x : ~succ X & y : Y & z : ~succ Z) 
''')



def test_zero_subs_nat():
    zero = ('''
~zero @ 
    ''')
    models = solve(zero, nat)
    # print(f'len(models): {len(models)}')
    assert(models)

def test_two_subs_nat():
    two = ('''
~succ ~succ ~zero @ 
    ''')
    models = solve(two, nat)
    print(f'len(models): {len(models)}')
    assert models

def test_bad_tag_subs_nat():
    bad = ('''
~bad ~succ ~zero @ 
    ''')
    models = solve(bad, nat)
    # print(f'len(models): {len(models)}')
    assert not models

def test_two_nat_subs_nat():
    two_nat = (f'''
~succ ~succ ({nat})
    ''')
    models = solve(two_nat, nat)
    # print(f'len(models): {len(models)}')
    assert models


def test_even_subs_nat():
    models = solve(even, nat)
    assert models

def test_nat_subs_even():
    models = solve(nat, even)
    # print(f'len(models): {len(models)}')
    assert not models

def test_subs_idx_unio():
    idx_unio = ('''
EXI [N ; N <: TOP] (~thing N)  
    ''')
    thing = ('''
(~thing @)
    ''')

    models = solve(thing, idx_unio)
    for model in models:
        print(f'model: {analyzer.concretize_constraints(tuple(model.constraints))}')
    assert(models)


def test_zero_nil_subs_nat_list():
    global p
    zero_nil = ('''
(~zero @, ~nil @)
    ''')

    models = solve(zero_nil, nat_list)
    # print(f'len(models): {len(models)}')
    assert models

def test_one_single_subs_nat_list():
    one_single = ('''
(~succ ~zero @, ~cons ~nil @) 
    ''')
    models = solve(one_single, nat_list)
    print(f'len(models): {len(models)}')
    assert models

def test_two_single_subs_nat_list():
    two_single = ('''
(~succ ~succ ~zero @, ~cons ~nil @)
    ''')
    models = solve(two_single, nat_list)
    print(f'len(models): {len(models)}')
    assert not models

def test_one_query_subs_nat_list():
    one_query = ('''
(~succ ~zero @, X)
    ''')
    answer = query_weak_side(one_query, nat_list, "X") 
    print("answer: " + answer)
    assert answer == "~cons ~nil @"

def test_one_cons_query_subs_nat_list():
    global p
    one_cons_query = ('''
(~succ ~zero @, ~cons X)
    ''')
    answer = query_weak_side(one_cons_query, nat_list, "X")
    print(f"""
answer: {answer}
    """)
    assert answer == "~nil @"


def test_two_cons_query_subs_nat_list():
    two_cons_query = ('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    answer = query_weak_side(two_cons_query, nat_list, "X")
    print(f"""
answr: {answer}
    """)
    assert answer == "~cons ~nil @"

def test_even_list_subs_nat_list():
    models = solve(even_list, nat_list)
    print(f"len(models): {len(models)}")
    assert models

def test_nat_list_subs_even_list():
    models = solve(nat_list, even_list)
    print(f"len(models): {len(models)}")
    assert not models


def test_one_plus_one_equals_two():
    print("==================")
    print(addition_rel)
    print("==================")
    one_plus_one_equals_two = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @)
    ''')
    models = solve(one_plus_one_equals_two, addition_rel)
    print(f'len(models): {len(models)}')
    # assert len(models) == 1
    for model in models:
        print(f'''
    model: {analyzer.concretize_constraints(tuple(model.constraints))}
        ''')

def test_one_plus_one_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : Z)
    ''')
    answer = query_weak_side(one_plus_one_query, addition_rel, "Z")
    assert answer == "~succ ~succ ~zero @"
#     print(f'''
# answer: {answer}
#     ''')

def test_one_plus_equals_two_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : Y & z : ~succ ~succ ~zero @ )
    ''')
    answer = query_weak_side(one_plus_one_query, addition_rel, "Y")
    assert answer == "~succ ~zero @"
    print(f'''
answer: {answer}
    ''')

def test_zero_plus_one_equals_two():
    zero_plus_one_equals_two = ('''
(x : ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    models = solve(zero_plus_one_equals_two, addition_rel)
    assert not models


def test_plus_one_equals_two_query():
    plus_one_equals_two_query = ('''
(x : X & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    answer = query_weak_side(plus_one_equals_two_query, addition_rel, "X")
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
    answer = query_weak_side(plus_equals_two_query, addition_rel, "(X, Y)")
#     print(f'''
# answer: {answer}
#     ''')
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
    answer = query_weak_side(nil_query, list_nat_diff, "X")
    assert answer == "~zero @" 

def test_cons_nil_query_subs_list_nat_diff():
    cons_nil_query = ('''
((~cons ~nil @), X)
    ''')
    answer = query_weak_side(cons_nil_query, list_nat_diff, "X")
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
    models = solve(cons_nil, list_diff)
    print(f'len(models): {len(models)}')
    assert models


list_imp_nat = (f'''
(ALL [X ; X <: ({list_diff})] (X -> 
    (EXI [Y ; (X, Y) <: ({list_nat_diff})] Y)
))) 
''')

def test_list_imp_nat_subs_nil_imp_query():

    nil_imp_query = ('''
(~nil @ -> Q)
    ''')
    answer = query_strong_side(list_imp_nat, nil_imp_query, "Q")
    print(f'''
answer: {answer}
    ''')
    assert answer == "~zero @" 

def test_list_imp_nat_subs_cons_nil_imp_query():
    nil_imp_query = ('''
((~cons ~nil @) -> Q)
    ''')
    answer = query_strong_side(list_imp_nat, nil_imp_query, "Q")
    print(f'''
answer: {answer}
    ''')
    assert answer == "~succ ~zero @"


def test_list_imp_nat_subs_cons_cons_nil_imp_query():
    cons_cons_nil_imp_query = ('''
((~cons ~cons ~nil @) -> Q)
    ''')
    answer = query_strong_side(list_imp_nat, cons_cons_nil_imp_query, "Q")
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
    models = solve(bot, cons_nil_diff)
    assert len(models) == 1
    print(f'''
len(models): {len(models)}
    ''')


"""
Type inference
"""

def test_var():
    pieces = ['''
x
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)

    assert isinstance(guides[0], KeyError)
    assert guides[0].args[0] == 'x'
    assert guides[-1] == language.Killed()
    assert not models 
    assert not parsetree 


def test_unit():
    pieces = ['''
@
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base @))"
    # print("parsetree: " + str(parsetree))
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_tag():
    pieces = ['''
~uno @
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # assert parsetree == "(expr (base ~ uno (base @)))"
    # print(parsetree)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~uno @"

def test_tuple():
    pieces = ['''
@, @, @
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print(parsetree)
    print(u(decode(models, typ_var)))
    # assert u(decode(models, typ_var)) == "(@, (@, @))"

def test_record():
    pieces = ['''
_.uno = @ 
_.dos = @
    ''']
# uno:= @  dos:= @
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # assert parsetree == "(expr (base (record _. uno = (expr (base @)) (record _. dos = (expr (base @))))))"
    print("answer: " + u(decode(models, typ_var)))
    # assert u(decode(models, typ_var)) == "(uno : @ & dos : @)"


def test_function():
    pieces = ['''
case ~nil @ => @ 
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print(parsetree)
    print(f"answer: {u(decode(models, typ_var))}")
    assert u(decode(models, typ_var)) == "(~nil @ -> @)"

def test_function_cases_disjoint():
    pieces = ['''
case ~uno @ => ~one @ 
case ~dos @ => ~two @ 
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    print("answer: " + u(decode(models, typ_var)))
    # assert u(decode(models, typ_var)) == "((~uno @ -> ~one @) & (~dos @ -> ~two @))"
    # TODO: update once diffs are enabled 
    # assert u(decode(models, typ_var)) == "(~uno @ -> ~one @) & (~dos @ \ ~uno @ -> ~two @)"

def test_function_cases_overlap():
    pieces = ['''
case ~uno @ => ~one @ 
case x => ~two @ 
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    print("answer: " + u(decode(models, typ_var)))
    # TODO: use type_equiv, instead of syntax equiv.
    # there is some non-determinism in variable names
    # assert u(decode(models, typ_var)) == "(EXI [ ; _7 <: _6] ((~uno @ -> ~one @) & (ALL [_10 ; _10 <: _7] (_10 -> ~two @))))"

def test_projection():
    pieces = ['''
(_.uno = ~one @ _.dos = ~two @).uno
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~one @"

def test_projection_chain():
    pieces = ['''
(_.uno = (_.dos = ~onetwo @) _.one = @).uno.dos
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~onetwo @"

def test_app_identity_unit():
    pieces = ['''
(case x => x)(@)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, debug=True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_app_pattern_match_nil():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~nil @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_app_pattern_match_cons():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~cons @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_app_pattern_match_fail():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~fail @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert u(decode(models, typ_var)) == "BOT"
    # print("answer: " + u(decode(models, typ_var)))

def test_application_chain():
    pieces = ['''
(case ~nil @ => case ~nil @ => @)(~nil @)(~nil @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_let():
    pieces = ['''
let x = @ ;
x
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # assert parsetree == "(expr let x (target = (expr (base @))) ; (expr (base x)))"
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_idprojection():
    pieces = ['''
let r = (_.uno = @ _.dos = @) ;
r.uno
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_idprojection_chain():
    pieces = ['''
let r = (_.uno = (_.dos = @) _.one = @) ;
r.uno.dos
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_idapplication():
    pieces = ['''
let f = (
    case ~nil @ => @ 
    case ~cons x => x 
) ;
f(~nil @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_idapplication_chain():
    pieces = ['''
let f = (case ~nil @ => case ~nil @ => @) ;
f(~nil @)(~nil @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    assert u(decode(models, typ_var)) == "@"
    # print("answer: " + u(decode(models, typ_var)))

def test_functional():
    pieces = ['''
(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    ''']
    # TODO: how should we package the constraints on X where x : X 
    # does it need to collect all the constraints on X, before generalizing?
    (models, typ_var, guides, parsetree) = analyze(pieces, debug=True)
    print("answer: " + u(decode(models, typ_var)))
    # assert u(decode(models, typ_var)) == "@"

def test_fix():
    pieces = ['''
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces, debug=True)
    print("answer: " + u(decode(models, typ_var)))
    # assert u(decode(models, typ_var)) == "@"

def test_identity_function():
    pieces = ['''
(case x => x)
    ''']

    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "ALL [_2 ; _2 <: _1] _1 -> _1"

def test_unit_funnel_identity():
    pieces = ['''
@ |> (case x => x)
    ''']

    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_nil_funnel_fix():
    pieces = ['''
~nil @ |> (fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~zero @"

def test_app_fix_nil():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~nil @) 
    ''']

    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~zero @"

def test_app_fix_cons():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~nil @) 
    ''']

    (models, typ_var, guides, parsetree) = analyze(pieces, True)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~succ ~zero @"

def test_app_fix_cons_cons():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~cons ~nil @) 
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~succ ~succ ~zero @"


def test_funnel_pipeline():
    pieces = ['''
~nil @ |> (case ~nil @ => @) |> (case @ => ~uno @)
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~uno @"


# fix(case self => (
# case ~nil @ => ~zero @ 
# case ~cons x => ~succ (self(x)) 
# ))

def test_pattern_tuple():
    pieces = ['''
case (~zero @, @) => @
    ''']
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "((~zero @, @) -> @)"

if_true_then_else = (f'''
if ~true @ then
    ~uno @
else
    ~dos @
''')

if_false_then_else = (f'''
if ~false @ then
    ~uno @
else
    ~dos @
''')

function_if_then_else = (f'''
case x => (
    if x then
        ~uno @
    else
        ~dos @
)
''')

# function_if_then_else = (f'''
# case x => (
#     (
#     case ~true @ => ~uno @
#     case ~false @ => ~dos @
#     )(x)
# )
# ''')

def test_if_true_then_else():
    pieces = [if_true_then_else]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~uno @"

def test_if_false_then_else():
    pieces = [if_false_then_else]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~dos @"

def test_function_if_then_else():
    pieces = [function_if_then_else]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "(_2 -> (~uno @ | ~dos @))"


less_equal = ('''
fix(case self => (
    case (~zero @, x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (~succ x, ~zero @) => ~false @ 
))
''')

def test_less_equal():
    pieces = [less_equal]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

def test_let_less_equal():
    let_less = (f'''
let less_equal = {less_equal} ;
less_equal
    ''')
    pieces = [let_less]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

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
    answer = query_weak_side(two_less_equal_one_query, less_equal_rel, "Z")
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
    answer = query_strong_side(left, right, "W")
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
    answer = query_strong_side(left, right, "W")
    print(f"answer: {answer}")
    # assert answer == "(~succ ~succ ~zero @, ~succ ~zero @)" 
    assert answer == "~zero @" 


def test_less_equal_imp_subs_two_one_imp_query():
    two_one_imp_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @) -> Q)
    ''')
    answer = query_strong_side(less_equal_imp, two_one_imp_query, "Q")
    print(f"answer: {answer}")
    assert answer == "~false @" 


def test_app_less_equal_zero_one():
    app_less = (f'''
({less_equal})(~zero @, ~succ ~zero @)
    ''')
    pieces = [app_less]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~true @"


def test_app_less_equal_two_one():
    app_less = (f'''
({less_equal})(~succ ~succ ~zero @, ~succ ~zero @)
    ''')
    pieces = [app_less]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~false @"

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

# arg_specialization = (f'''
# let cmp = (
#     case (~uno @, ~dos @) => ~true @
#     case (~dos @, ~uno @) => ~false @ 
# ) ;
# case (x, y) => cmp(x, y)
# ''')

def test_arg_specialization():
    ########################################
    # TODO: this may require a major refactor of rules to return a list of models with a type; instead of just a type 
    '''
; X <: ~uno @ ; Y <: ~dos @ |-
((~true @ -> X) & (~false @ -> Y)) <: ~true @ -> Q

<< OR >>

; X <: ~dos @ ; Y <: ~uno @ |- 
((~true @ -> X) & (~false @ -> Y)) <: ~false @ -> Q
    '''
    pieces = [arg_specialization]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "~uno @"

max = (f'''
let less_equal = {less_equal} ;
case (x, y) => (
    if less_equal(x, y) then
        y
    else
        x
)
''')

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
case (x, y) => (
    (
    case (~true @) => y 
    case (~false @) => x 
    )(({less_equal})(x, y))
)
''')


def test_max():
    # TODO

    pieces = [max]
    (models, typ_var, guides, parsetree) = analyze(pieces)
    # print("answer: " + u(decode(models, typ_var)))
    assert u(decode(models, typ_var)) == "@"

'''
~~~ cator: ((~true @ -> _5) & (~false @ -> _3)) 
LOOK!! (_3 and _5) should not be bound. they are the same variables as the return of max 
TODO: consider existential extrusion
 -- Q: what's the benefit of extrusion over simply using free variable in relation constraint
    -- A: existential extrusion allows specialization on the outside, but using the weaker type on the inside. 
    -- A: opposite of universal extrusion: allows specialized view on the inside with generalized view on the outside
 -- should existential extrusion be used in return type of application too?
e.g. EXI [_73 _4 _6 ; _3 <: _4; _4 <: 6; ((_4, _6), _73) <: LFP _59
~~~ arguments: (EXI [_73 _3 _5 ; ((_3, _5), _73) <: LFP _59 ((EXI [_61 ; _61 <: _24] ((~zero @, _61), ~true @)) | ((EXI [_62 _40 _63 ; ((_63, _62), _40) <: _59] ((~succ _63, ~succ _62), _40)) | (EXI [_64 ; _64 <: _46] ((~succ _64, ~zero @), ~false @)))) ; _72 <: LFP _59 ((EXI [_61 ; _61 <: _24] (~zero @, _61)) | ((EXI [_62 _63 ; (_63, _62) <: _59] (~succ _63, ~succ _62)) | (EXI [_64 ; _64 <: _46] (~succ _64, ~zero @))))] _73)
'''

'''
LFP _32 (
    (~nil @, ~zero @) | 
    (EXI [N L 
        ; _42 <: (_44 -> N) 
        ; _41 <: (_44 -> N) 
        ; L <: _44 ; _40 <: _16 ; _34 <: _16 
        ; L <: _12 ; _33 <: _12 ; _40 <: N 
        ; (_29 | _41) <: _2 ; _38 <: _2
    ] (~cons L, ~succ N))
)
'''

'''
LFP _29 (
    (~nil @, ~zero @) | 
    (EXI [ L N 
        ; _33 <: _12 
        ; _36 <: (L -> N) 
        ; N <: _16 ; (_26 | _36) <: _2 
        ; _31 <: _2 ; _32 <: _16 
        ; L <: _12
    ] (~cons L, ~succ N))
)
'''

'''
LFP _22 (
    (~nil @, ~zero @) | 
    (EXI [N L ; (L, N) <: _22] (~cons L, ~succ N))
)
'''


if __name__ == '__main__':

    ########################
    ## Post refactor tests
    ########################
    test_function_cases_disjoint()
    # test_function()
    # test_functional()
    # test_fix()
    ########################
    # test_two_less_equal_one_query()
    # test_app_less_equal_two_one()
    #
    # TODO
    # test_arg_specialization()
    # test_all_imp_exi_subs_union_imp()
    # test_if_true_then_else()
    # test_function_if_then_else()
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
