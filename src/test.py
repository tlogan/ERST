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
        return (ctx.combo if ctx else None, guides, connection.to_string_tree(ctx) if ctx else None)

    (combo, guides, parsetree) = asyncio.run(_mk_task())
    if debug:
        raise_guide(guides)

    return (combo, guides, parsetree)

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
    # print(f'len(models): {len(models)}')
    assert not models

def test_one_query_subs_nat_list():
    one_query = ('''
(~succ ~zero @, X)
    ''')
    models = solve(one_query, nat_list)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("X"))
    # print("answr: " + answer)
    assert answer == "~cons ~nil @"

def test_one_cons_query_subs_nat_list():
    global p
    one_cons_query = ('''
(~succ ~zero @, ~cons X)
    ''')
    models = solve(one_cons_query, nat_list)
    assert len(models) == 1
    model = models[0]
    # TODO
    answer = analyzer.prettify_weakest(model, p("X"))
    print(f"""
model: {analyzer.concretize_constraints(tuple(model.constraints))}
answr: {answer}
    """)
    assert answer == "~nil @"


def test_two_cons_query_subs_nat_list():
    two_cons_query = ('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    models = solve(two_cons_query, nat_list)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("X"))
    print(f"""
freezer: {model.freezer}
constraints: {analyzer.concretize_constraints(tuple(model.constraints))}
answr: {answer}
    """)
    assert answer == "~cons ~nil @"

def test_even_list_subs_nat_list():
    models = solve(even_list, nat_list)
    print(f"len(models): {len(models)}")
    # assert models

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
    models = solve(one_plus_one_query, addition_rel)
    # print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("Z"))
    assert answer == "~succ ~succ ~zero @"
#     print(f'''
# model: {analyzer.concretize_constraints(tuple(model))}
# answr: {answer}
#     ''')

def test_one_plus_equals_two_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : Y & z : ~succ ~succ ~zero @ )
    ''')
    models = solve(one_plus_one_query, addition_rel)
    # print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("Y"))
    assert answer == "~succ ~zero @"
    print(f'''
model: {analyzer.concretize_constraints(tuple(model.constraints))}
answr: {answer}
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
    models = solve(plus_one_equals_two_query, addition_rel)
    # print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("X"))
    assert answer == "~succ ~zero @"
#     print(f'''
# model: {analyzer.concretize_constraints(tuple(model))}
# answr: {answer}
#     ''')

def test_plus_equals_two_query():
    print("==================")
    print(addition_rel)
    print("==================")
    plus_equals_two_query = ('''
(x : X & y : Y & z : ~succ ~succ ~zero @)
    ''')
    models = solve(plus_equals_two_query, addition_rel)
    assert len(models) == 3
    answers = [
        analyzer.prettify_weakest(model, p("(X, Y)"))
        for model in models
    ]
#     print(f'''
# len(models): {len(models)}
# answers: {answers}
#     ''')
    assert answers == [
        "(~zero @, ~succ ~succ ~zero @)",
        "(~succ ~zero @, ~succ ~zero @)",
        "(~succ ~succ ~zero @, ~zero @)",
    ]



list_nat_diff = ('''
(LFP self (
    (~nil @, ~zero @) | 
    (EXI [l n ; (l, n) <: self] ((~cons l \\ ~nil @), ~succ n))
))
''')

# list_nat_diff = "((~nil @, ~zero @) | ([| L N . (L, N) <: LFP SELF ((~nil @, ~zero @) | ([| L N . (L, N) <: SELF ] ((~cons L \ ~nil @), ~succ N))) ] ((~cons L \ ~nil @), ~succ N)))"

def test_nil_query_subs_list_nat_diff():
    nil_query = ('''
(~nil @, X)
    ''')
    models = solve(nil_query, list_nat_diff)
    assert len(models) == 1
    answer = analyzer.prettify_weakest(models[0], p("X"))
    assert answer == "~zero @" 
    # for model in models:

    #     pretty = analyzer.prettify_weakest(model, p("X"))
    #     print(f'model: {analyzer.concretize_constraints(tuple(model))}')
    #     print(f'pretty: {pretty}')
    # assert len(models) == 3
    # answers = [
    #     analyzer.prettify_weakest(model, p("(X, Y)"))
    #     for model in models
    # ]
    # assert answers == [
    #     "(~zero @, ~succ ~succ ~zero @)",
    #     "(~succ ~zero @, ~succ ~zero @)",
    #     "(~succ ~succ ~zero @, ~zero @)",
    # ]



def test_cons_nil_query_subs_list_nat_diff():
    cons_nil_query = ('''
((~cons ~nil @), X)
    ''')
    models = solve(cons_nil_query, list_nat_diff)
    assert len(models) == 1
    answer = analyzer.prettify_weakest(models[0], p("X"))
    assert answer == "~succ ~zero @" 
    # for model in models:

    #     pretty = analyzer.prettify_weakest(model, p("X"))
    #     print(f'model: {analyzer.concretize_constraints(tuple(model))}')
    #     print(f'pretty: {pretty}')
    # assert len(models) == 3
    # answers = [
    #     analyzer.prettify_weakest(model, p("(X, Y)"))
    #     for model in models
    # ]
    # assert answers == [
    #     "(~zero @, ~succ ~succ ~zero @)",
    #     "(~succ ~zero @, ~succ ~zero @)",
    #     "(~succ ~succ ~zero @, ~zero @)",
    # ]

    print(f'''
len(models): {len(models)}
answer: {answer}
    ''')

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
(ALL [X <: ({list_diff})] (X -> 
    (EXI [Y ; (X, Y) <: ({list_nat_diff})] Y)
))) 
''')

def test_list_imp_nat_subs_nil_imp_query():

    nil_imp_query = ('''
(~nil @ -> Q)
    ''')
    models = solve(list_imp_nat, nil_imp_query)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest(model, p("Q"))
    assert answer == "~zero @" 
#     print(f'''
# len(models): {len(models)}
# answer: {answer}
#     ''')

def test_list_imp_nat_subs_cons_nil_imp_query():

    nil_imp_query = ('''
((~cons ~nil @) -> Q)
    ''')
    models = solve(list_imp_nat, nil_imp_query)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest(model, p("Q"))
    assert answer == "~succ ~zero @"
#     print(f'''
# len(models): {len(models)}
# answer: {answer}
#     ''')


def test_list_imp_nat_subs_cons_cons_nil_imp_query():
    cons_cons_nil_imp_query = ('''
((~cons ~cons ~nil @) -> Q)
    ''')
    models = solve(list_imp_nat, cons_cons_nil_imp_query)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest(model, p("Q"))
    assert answer == "~succ ~succ ~zero @"
    print(f'''
len(models): {len(models)}
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
    (combo, guides, parsetree) = analyze(pieces)

    assert isinstance(guides[0], KeyError)
    assert guides[0].args[0] == 'x'
    assert guides[-1] == language.Killed()
    assert not combo
    assert not parsetree 


def test_unit():
    pieces = ['''
@
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base @))"
    assert u(combo) == "@"
    # print("parsetree: " + str(parsetree))
    # print("combo: " + u(combo))

def test_tag():
    pieces = ['''
~uno @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    assert parsetree == "(expr (base ~ uno (base @)))"

def test_tuple():
    pieces = ['''
@, @, @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    # print(parsetree)
    # print(f"u(combo): {u(combo)}")
    assert u(combo) == "(@, (@, @))"

def test_record():
    pieces = ['''
_.uno = @ 
_.dos = @
    ''']
# uno:= @  dos:= @
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base (record _. uno = (expr (base @)) (record _. dos = (expr (base @))))))"


def test_function():
    pieces = ['''
case ~nil @ => @ 
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    print("combo: " + u(simp(combo)))
    assert u(simp(combo)) == "(~nil @ -> @)"

def test_function_cases_disjoint():
    pieces = ['''
case ~uno @ => ~one @ 
case ~dos @ => ~two @ 
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    # assert u(simp(combo)) == "(~nil @ -> @)"
    print("combo: " + u(simp(combo)))

def test_function_cases_overlap():
    pieces = ['''
case ~uno @ => ~one @ 
case x => ~two @ 
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    # assert u(simp(combo)) == "(~nil @ -> @)"
    print("combo: " + u(simp(combo)))

def test_projection():
    pieces = ['''
(_.uno = ~one @ _.dos = ~two @).uno
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print("combo: " + u(simp(combo)))
    assert u(simp(combo)) == "~one @"

def test_projection_chain():
    pieces = ['''
(_.uno = (_.dos = ~onetwo @) _.one = @).uno.dos
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    print("combo: " + u(simp(combo)))
    assert u(simp(combo)) == "~onetwo @"

def test_app_identity_unit():
    pieces = ['''
(case x => x)(@)
    ''']
    (combo, guides, parsetree) = analyze(pieces, debug=True)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "@" 
    print("combo: " + u(combo))

def test_app_pattern_match_nil():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "@"
    print("combo: " + u(combo))

def test_app_pattern_match_cons():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~cons @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "@"
    print("combo: " + u(combo))

def test_app_pattern_match_fail():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~fail @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "BOT"
    print("combo: " + u(combo))

def test_application_chain():
    pieces = ['''
(case ~nil @ => case ~nil @ => @)(~nil @)(~nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_let():
    pieces = ['''
let x = @ ;
x
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr let x (target = (expr (base @))) ; (expr (base x)))"
    print("combo: " + u(combo))
    assert u(combo) == "@"

def test_idprojection():
    pieces = ['''
let r = (~uno = @ ~dos = @) ;
r.uno
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idprojection_chain():
    pieces = ['''
let r = (~uno = (~dos @) :one = @) ;
r.uno.dos
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idapplication():
    pieces = ['''
let f = (
    case ~nil @ => @ 
    case ~cons x => x 
) ;
f(~nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idapplication_chain():
    pieces = ['''
let f = (case ~nil @ => case ~nil @ => @) ;
f(~nil @)(~nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_fix():
    pieces = ['''
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert combo
    print("combo: " + u(combo))

def test_identity_function():
    pieces = ['''
(case x => x)
    ''']

    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    print("combo: " + u(combo))

def test_unit_funnel_identity():
    pieces = ['''
@ |> (case x => x)
    ''']

    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    print("combo: " + u(combo))

def test_nil_funnel_fix():
    pieces = ['''
~nil @ |> (fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))
    ''']

    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "~zero @"
    print("combo: " + u(combo))

def test_app_fix_nil():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~nil @) 
    ''']

    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    print("combo: " + u(combo))
    assert u(combo) == "~zero @"

def test_app_fix_cons():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~nil @) 
    ''']

    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree
    print("parsetree: " + parsetree)
    assert combo
    assert u(combo) == "~succ ~zero @"
    print("combo: " + u(combo))

def test_app_fix_cons_cons():
    pieces = ['''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~cons ~nil @) 
    ''']

    (combo, guides, parsetree) = analyze(pieces, True)
    assert parsetree
    assert combo
    assert u(combo) == "~succ ~succ ~zero @"
    print("combo: " + u(combo))


def test_funnel_pipeline():
    pieces = ['''
~nil @ |> (case ~nil @ => @) |> (case ~nil @ => @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)


# fix(case self => (
# case ~nil @ => ~zero @ 
# case ~cons x => ~succ (self(x)) 
# ))

def test_pattern_tuple():
    tup = ('''
case (~zero @, @) => @
    ''')
    pieces = [tup]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    assert u(combo) == "((~zero @, @) -> @)"
    print("combo: " + u(combo))
    # print("parsetree: " + str(parsetree))

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

def test_if_true_then_else():
    pieces = [if_true_then_else]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    assert u(combo) == "~uno @"
    print("combo: " + u(combo))
    print(parsetree)

def test_if_false_then_else():
    pieces = [if_false_then_else]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    assert u(combo) == "~dos @"
    print("combo: " + u(combo))
    print(parsetree)

def test_function_if_then_else():
    pieces = [function_if_then_else]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    assert u(combo) == "(_2 -> (~uno @ | ~dos @))"

    print("combo: " + u(combo))
    print(parsetree)


less_equal = ('''
fix(case self => (
    case (~zero @, x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (~succ x, ~zero @) => ~false @ 
))
''')

def test_less_equal():
    pieces = [less_equal]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    print("combo: " + u(combo))
    # print("parsetree: " + str(parsetree))

def test_let_less_equal():
    let_less = (f'''
let less_equal = {less_equal} ;
less_equal
    ''')
    pieces = [let_less]
    (combo, guides, parsetree) = analyze(pieces)
    # print(parsetree)
    assert combo
    print("combo: " + u(combo))
    # print("parsetree: " + str(parsetree))

nat_pair_rel = (f'''
LFP self BOT 
    | (EXI [x ; x <: ({nat})] (~zero @, x))
    | (EXI [a b ; (a, b) <: self] (~succ a, ~succ b))
    | (EXI [x ; x <: ({nat})] (~succ x, ~zero @))
''')

less_equal_rel = (f'''
LFP self BOT 
    | (EXI [x ; x <: ({nat})] ((~zero @, x), ~true @))
    | (EXI [a b c ; ((a,b),c) <: self] ((~succ a, ~succ b), c))
    | (EXI [x ; x <: ({nat})] ((~succ x, ~zero @), ~false @))
''')

def test_two_less_equal_one_query():
    two_less_equal_one_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @), Z)
    ''')
    models = solve(two_less_equal_one_query, less_equal_rel)
    # print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("Z"))
#     print(f'''
# model: {analyzer.concretize_constraints(tuple(model.constraints))}
# answr: {answer}
#     ''')
    assert answer == "~false @"

less_equal_imp = (f'''
(ALL [XY <: ({nat_pair_rel})] (XY -> 
    (EXI [Z ; (XY, Z) <: ({less_equal_rel})] Z)
))) 
''')

def test_less_equal_imp_subs_two_one_imp_query():
    two_one_imp_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @) -> Q)
    ''')
    models = solve(less_equal_imp, two_one_imp_query)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest(model, p("Q"))

#     print(f'''
# len(models): {len(models)}
# model freezer: {model.freezer}
# model constraints: {analyzer.concretize_constraints(tuple(model.constraints))}
# answer: {answer}
#     ''')
    assert answer == "~false @" 


def test_app_less_equal_zero_one():
    app_less = (f'''
({less_equal})(~zero @, ~succ ~zero @)
    ''')
    pieces = [app_less]
    (combo, guides, parsetree) = analyze(pieces)
    # print(parsetree)
    assert combo
    print("combo: " + u(combo))
    assert u(combo) == "~true @"

def test_app_less_equal_two_one():
    app_less = (f'''
({less_equal})(~succ ~succ ~zero @, ~succ ~zero @)
    ''')
    pieces = [app_less]
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    assert combo
    print("combo: " + u(combo))
    assert u(combo) == "~false @"

max = (f'''
let less_equal = {less_equal} ;
case (x, y) => (
    if less_equal(x, y) then
        y
    else
        x
)
''')

def test_max():
    # TODO

#     max = (f'''
# let less_equal = {less_equal} ;
# case (x, y) => less_equal(x, y)
#     ''')

    max = (f'''
let less_equal = {less_equal} ;
less_equal(~zero @, ~succ ~zero @)
    ''')
    pieces = [max]
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    # raise_guide(guides)
    # assert combo
    # print("combo: " + u(combo))


if __name__ == '__main__':
    # test_less_equal_imp_subs_two_one_imp_query()
    # test_even_list_subs_nat_list()
    # test_two_cons_query_subs_nat_list()
    test_app_less_equal_two_one()
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
