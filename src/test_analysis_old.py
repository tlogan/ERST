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

from tapas.slim import exprlib as el, typlib as tl

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
        return (ctx.results if ctx else None, guides, connection.to_string_tree(ctx) if ctx else None, connection.get_solver())

    (result, guides, parsetree, solver) = asyncio.run(_mk_task())
    if debug:
        raise_guide(guides)

    return (result, guides, parsetree, solver)

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
world.freezer: {world.closedids}

world.constraints: 
{constraints_str}

world.relids: {world.relids}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)


def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 


def solve(solver : analyzer.Solver, a : str, b : str) -> list[analyzer.World]:
    x = p(a)
    y = p(b)
    try:
        return solver.solve_composition(x, y)
    except RecursionError:
        print("!!!!!!!!!!!!!!!")
        print("RECURSION ERROR")
        print("!!!!!!!!!!!!!!!")
        return []
    # except:
    #     return []

def check(a : str, b : str) -> bool:
    solver = analyzer.Solver(m()) 
    worlds = solve(solver, a, b)
    return len(worlds) > 0

def equiv(a : str, b : str) -> bool:
    solver = analyzer.Solver(m()) 
    x = p(a)
    y = p(b)
    return (
        len(solver.solve_composition(x, y)) > 0 and 
        len(solver.solve_composition(y, x)) > 0
    )

def decode_polarity(solver : analyzer.Solver, results, polarity):
    return analyzer.concretize_typ(
        solver.decode_polarity_typ(results, polarity)
    )

# def decode_negative(solver : analyzer.Solver, results):
#     return analyzer.concretize_typ(
#         solver.decode_negative_typ(results)
#     )

# def decode_positive(solver : analyzer.Solver, results):
#     return analyzer.concretize_typ(solver.to_aliasing_typ(
#         solver.decode_positive_typ(results)
#     ))

# def roundtrip(ss : list[str]) -> str:
#     return analyzer.concretize_typ(analyzer.simplify_typ(analyzer.make_unio([
#         p(s) for s in ss
#     ])))


"""
tests
"""

def test_typ_implication():

    p = language.parse_typ("X -> Y -> Z")
    assert p 
    c = analyzer.concretize_typ(p) 
    print(c)
    assert c == "(X -> (Y -> Z))"



def test_typ_FX():
    d = ('''
FX self | ~nil @ | ~cons self
    ''')
    assert u(p(d)) == "FX self | (~nil @ | ~cons self)"
    # print(u(t))



def test_zero_subs_nat():
    zero = ('''
~zero @ 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, zero, tl.nat)
    # print(f'len(worlds): {len(worlds)}')
    assert(worlds)

def test_two_subs_nat():
    two = ('''
~succ ~succ ~zero @ 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, two, tl.nat)
    print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_bad_tag_subs_nat():
    bad = ('''
~bad ~succ ~zero @ 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, bad, tl.nat)
    # print(f'len(worlds): {len(worlds)}')
    assert not worlds

def test_two_nat_subs_nat():
    two_nat = (f'''
~succ ~succ ({tl.nat})
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, two_nat, tl.nat)
    # print(f'len(worlds): {len(worlds)}')
    assert worlds


def test_coinduction_malformed():
    # TODO
    lower = (f"""
(FX E | E)
    """.strip())
    upper = (f"""
(FX E | ~zero @ | ~succ ~succ E)
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_top_subs_relational_constraint_false():
    # TODO: make sure subtyping terminates with false
    list = (f"""
(FX N | ~nil @  | ~cons N )
    """.strip())
    lower = (f"""
({tl.nat}, {list})
TOP
    """.strip())
    upper = (f"""
(FX NL 
    | (~zero @, ~nil @) 
    | EXI [N L ; (N, L) <: NL] (~succ N, ~cons L)  
)
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_existential_fixpoint_subs_false():
    # TODO: make sure subtyping terminates with false
    # TODO: add check to prevent learning recursive types
    # TODO: modify rewriting to avoid infinitely rewriting
    fp = (f"""
(FX N | ~nil @ | ~cons N)
    """.strip())
    lower = (f"""
(EXI [X ; X <: {fp}] X)
    """.strip())
    upper = (f"""
~nil @
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_fixpoint_subs_false():
    # TODO: make sure subtyping terminates with false
    # TODO: add check to prevent learning recursive types
    lower = (f"""
(FX N | ~nil @ | ~cons N)
    """.strip())
    upper = (f"""
~nil @
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_pair_subs_relational_constraint_false():
    # TODO: make sure subtyping terminates with false
    # TODO: add check to prevent learning recursive types
    list = (f"""
(FX N | ~nil @  | ~cons N )
    """.strip())
    lower = (f"""
(({tl.nat}), {list})
    """.strip())
    upper = (f"""
(FX NL 
    | (~zero @, ~nil @) 
    | EXI [N L ; (N, L) <: NL] (~succ N, ~cons L)  
)
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_even_subs_nat():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.even, tl.nat)
    assert worlds

def test_nat_subs_even():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.nat, tl.even)
    # print(f'len(worlds): {len(worlds)}')
    assert not worlds

def test_subs_idx_unio():
    idx_unio = ('''
EXI [N ; N <: TOP] (~thing N)  
    ''')
    thing = ('''
(~thing @)
    ''')

    solver = analyzer.Solver(m())
    worlds = solve(solver, thing, idx_unio)
    for world in worlds:
        print(f'world: {analyzer.concretize_constraints(tuple(world.constraints))}')
    assert(worlds)


def test_zero_nil_subs_nat_list():
    global p
    zero_nil = ('''
(~zero @, ~nil @)
    ''')

    solver = analyzer.Solver(m())
    worlds = solve(solver, zero_nil, tl.nat_list)
    # print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_one_single_subs_nat_list():
    one_single = ('''
(~succ ~zero @, ~cons ~nil @) 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, one_single, tl.nat_list)
    print(f'len(worlds): {len(worlds)}')
    assert worlds

def test_two_single_subs_nat_list():
    two_single = ('''
(~succ ~succ ~zero @, ~cons ~nil @)
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, two_single, tl.nat_list)
    print(f'len(worlds): {len(worlds)}')
    assert not worlds

def solve_decode(solver, a, b, t, polarity):
    worlds = solve(solver, a, b)
    results = [
        analyzer.WorldTyp(world, t)
        for world in worlds
    ]
    answer = decode_polarity(solver, results, polarity) 
    return answer

def test_one_query_subs_nat_list():
    one_query = ('''
(~succ ~zero @, X)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, one_query, tl.nat_list, p("X"), False)
    print("answer:\n" + answer)
    assert answer == "~cons ~nil @"

def test_one_cons_query_subs_nat_list():
    global p
    one_cons_query = ('''
(~succ ~zero @, ~cons X)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, one_cons_query, tl.nat_list, p("X"), False)
    print(f"""
~~~~~~~~~~~
RESULT
~~~~~~~~~~~
{answer}
~~~~~~~~~~~
    """)
    # assert answer == "~nil @"


def test_two_cons_query_subs_nat_list():
    two_cons_query = ('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, two_cons_query, tl.nat_list, p("X"), False)
    print(f"""
~~~~~~~~~~~~~~
RESULT
~~~~~~~~~~~~~~
{answer}
~~~~~~~~~~~~~~
    """)
    assert answer == "~cons ~nil @"


def test_even_subs_nat_pass():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.even, tl.nat)
    print(f"len(worlds): {len(worlds)}")
    assert bool(worlds)

def test_nat_subs_even_fail():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.nat, tl.even)
    print(f"len(worlds): {len(worlds)}")
    assert not worlds


def test_even_list_subs_nat_list_pass():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.even_list, tl.nat_list)
    print(f"len(worlds): {len(worlds)}")
    assert bool(worlds)

def test_nat_list_subs_even_list_fail():
    solver = analyzer.Solver(m())
    worlds = solve(solver, tl.nat_list, tl.even_list)
    print(f"len(worlds): {len(worlds)}")
    assert not worlds


def test_existential_elimination_fail():

    lower = (f"""
(EXI [X ; X <: (~uno @) | (~dos @)] X)
    """.strip())

    upper = (f"""
(~uno @)
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    print(f"len(worlds): {len(worlds)}")
    assert not worlds


def test_existential_elimination_pass():

    lower = (f"""
(EXI [X ; X <: (~uno @) | (~dos @)] X)
    """.strip())

    upper = (f"""
(~uno @) | (~dos @)
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    print(f"len(worlds): {len(worlds)}")
    assert worlds



def test_addition_subs_lte():

    strong = tl.addition

    weak = (f"""
EXI [X Y Z ; (X,Z) <: {tl.lte}] (x : X & y : Y & z : Z)
    """) 
    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1

def test_one_plus_one_equals_two():
    one_plus_one_equals_two = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @)
    ''')

#     one_plus_one_equals_two = ('''
# (<x> <succ> <zero> @ & <y> <succ> <zero> @ & <z> <succ> <succ> <zero> @)
#     ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, one_plus_one_equals_two, tl.addition)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1

def test_plus_one_equals_query():
    query = ('''
(x : X & y : ~succ ~zero @ & z : Z)
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, query, tl.addition)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1

def test_one_plus_one_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : Z)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, one_plus_one_query, tl.addition, p("Z"), False)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~succ ~succ ~zero @"

def test_one_plus_equals_two_query():
    one_plus_one_query = ('''
(x : ~succ ~zero @ & y : Y & z : ~succ ~succ ~zero @ )
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, one_plus_one_query, tl.addition, p("Y"), False)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~succ ~zero @"

def test_zero_plus_one_equals_two():
    zero_plus_one_equals_two = ('''
(x : ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, zero_plus_one_equals_two, tl.addition)
    assert not worlds


def test_plus_one_equals_two_query():
    plus_one_equals_two_query = ('''
(x : X & y : ~succ ~zero @ & z : ~succ ~succ ~zero @ )
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, plus_one_equals_two_query, tl.addition, p("X"), False)
    assert answer == "~succ ~zero @"
#     print(f'''
# answer:\n{answer}
#     ''')


def test_plus_equals_two_query():
    plus_equals_two_query = ('''
(x : X & y : Y & z : ~succ ~succ ~zero @)
#     ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, plus_equals_two_query, tl.addition, p("(X, Y)"), False)
#     oracle = f"""
# BOT
# | (~zero @, ~succ ~succ ~zero @)
# | (~succ ~zero @, ~succ ~zero @)
# | (~succ ~succ ~zero @, ~zero @)
#     """
#     assert equiv(typ, oracle)

def test_plus_equals_two_union_existential():
    plus_equals_two_query = ('''
(x : X & y : Y & z : ~succ ~succ ~zero @)
#     ''')
    solver = analyzer.Solver(m())
    strong = (f"""
BOT
| (~zero @, ~succ ~succ ~zero @)
| (~succ ~zero @, ~succ ~zero @)
| (~succ ~succ ~zero @, ~zero @)
    """)
    weak = (f"""
(EXI [X Y ; {plus_equals_two_query} <: {tl.addition}] (X, Y))
    """)
    worlds = solve(solver, strong, weak)
    print(len(worlds))
    assert worlds



list_nat_diff = ('''
(FX self
    | (~nil @, ~zero @)
    | (EXI [l n ; (l, n) <: self] ((~cons l \\ ~nil @), ~succ n))
)
''')

# list_nat_diff = "((~nil @, ~zero @) | ([| L N . (L, N) <: FX SELF ((~nil @, ~zero @) | ([| L N . (L, N) <: SELF ] ((~cons L \ ~nil @), ~succ N))) ] ((~cons L \ ~nil @), ~succ N)))"

# (~nil @, _2) <: ((~nil @, ~zero @) | (EXI [l n ; (l, n) <: FX self ((~nil @, ~zero @) | (EXI [l n ; (l, n) <: self] ((~cons l \ ~nil @), ~succ n)))] ((~cons l \ ~nil @), ~succ n)))

def test_nil_query_subs_list_nat_diff():
    nil_query = ('''
(~nil @, X)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, nil_query, list_nat_diff, p("X"), False)
    assert answer == "~zero @" 

def test_cons_nil_query_subs_list_nat_diff():
    cons_nil_query = ('''
((~cons ~nil @), X)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, cons_nil_query, list_nat_diff, p("X"), False)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~succ ~zero @" 

list_diff = ('''
(FX SELF | ~nil @ | (~cons SELF \\ ~nil @))
''')

def test_cons_nil_subs_list_diff():
    cons_nil = ('''
(~cons ~nil @) 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, cons_nil, list_diff)
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
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, list_imp_nat, nil_imp_query, p("Q"), True)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~zero @" 

def test_list_imp_nat_subs_cons_nil_imp_query():
    nil_imp_query = ('''
((~cons ~nil @) -> Q)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, list_imp_nat, nil_imp_query, p("Q"), True)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~succ ~zero @"


def test_list_imp_nat_subs_cons_cons_nil_imp_query():
    cons_cons_nil_imp_query = ('''
((~cons ~cons ~nil @) -> Q)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, list_imp_nat, cons_cons_nil_imp_query, p("Q"), True)
    assert answer == "~succ ~succ ~zero @"
    print(f'''
answer:\n{answer}
    ''')

def test_bot_subs_cons_nil_diff():

    cons_nil_diff = ('''
((~cons L) \ ~nil @)
    ''')

    bot = ('''
(BOT)
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, bot, cons_nil_diff)
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
    (result, parsetree, solver) = analyze(code)
    assert analyzer.concretize_typ(result) == "BOT"
    print("answer:\n" + analyzer.concretize_typ(result))
    assert not parsetree 


def test_unit():
    code = '''
@
    '''
    (result, parsetree, solver) = analyze(code)
    assert parsetree == "(expr (base @))"
    # print("parsetree: " + str(parsetree))
    assert analyzer.concretize_typ(result) == "@"
    print("answer:\n" + analyzer.concretize_typ(result))
    # print("answer:\n" + decode_positive(solver, results))

def test_tag():
    code = '''
~uno @
    '''
    (result, parsetree, solver) = analyze(code)
    # assert parsetree == "(expr (base ~ uno (base @)))"
    # print(parsetree)
    # print("answer:\n" + decode_positive(solver, results))
    assert analyzer.concretize_typ(result) == "~uno @"
    print("answer:\n" + analyzer.concretize_typ(result))

def test_tuple():
    code = '''
@, @, @
    '''
    (result, parsetree, solver) = analyze(code)
    # print(parsetree)
    assert analyzer.concretize_typ(result) == "(@, (@, @))"
    print("answer:\n" + analyzer.concretize_typ(result))

def test_record():
    code = '''
;uno = @ 
;dos = @
    '''
# uno:= @  dos:= @
    (result, parsetree, solver) = analyze(code)
    assert analyzer.concretize_typ(result) == "(uno : @ & dos : @)"
    print("answer:\n" + analyzer.concretize_typ(result))


def test_function():
    code = '''
case ~nil @ => @ 
    '''
    (result, parsetree, solver) = analyze(code)
    assert analyzer.concretize_typ(result) == "(~nil @ -> @)"
    print("answer:\n" + analyzer.concretize_typ(result))

def test_function_cases_disjoint():
    code = '''
case ~uno @ => ~one @ 
case ~dos @ => ~two @ 
    '''
    (result, parsetree, solver) = analyze(code)
    assert analyzer.concretize_typ(result) == "(~uno @ -> ~one @) & (~dos @ \ ~uno @ -> ~two @)"
    print("answer:\n" + analyzer.concretize_typ(result))


def test_function_cases_overlap():
    code = '''
case ~uno @ => ~one @ 
case x => ~two @ 
    '''
    (result, parsetree, solver) = analyze(code)
    # TODO: use type_equiv, instead of syntax equiv.
    # there is some non-determinism in variable names
    expected = "(EXI [ ; _7 <: _6] ((~uno @ -> ~one @) & (ALL [_10 ; _10 <: _7] (_10 -> ~two @))))"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_projection():
    code = '''
(;uno = ~one @ ;dos = ~two @).uno
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "~one @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_projection_chain():
    code = '''
(;uno = (;dos = ~onetwo @) ;one = @).uno.dos
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~onetwo @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_identity_unit():
    code = '''
(case x => x)(@)
    '''
    (result, parsetree, solver) = analyze(code)
    expected= "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_pattern_match_nil():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~nil @)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_pattern_match_cons():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~cons @)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_pattern_match_fail():
    code = '''
(
case ~nil @ => @ 
case ~cons x => x 
)(~fail @)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "BOT"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_application_chain():
    code = '''
(case ~nil @ => case ~nil @ => @)(~nil @)(~nil @)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_let():
    code = '''
let x = @ in
x
    '''
    (result, parsetree, solver) = analyze(code)
    # assert parsetree == "(expr let x (target = (expr (base @))) in (expr (base x)))"
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_idprojection():
    code = '''
let r = (;uno = @ ;dos = @) in 
r.uno
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_idprojection_chain():
    code = '''
let r = (;uno = (;dos = @) ;one = @) in 
r.uno.dos
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_idapplication():
    code = '''
let f = (
    case ~nil @ => @ 
    case ~cons x => x 
) in 
f(~nil @)
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_idapplication_chain():
    code = '''
let f = (case ~nil @ => case ~nil @ => @) in
f(~nil @)(~nil @)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_function_with_var():
    code = '''
case ~nil @ => ~zero @ 
case ~cons x => (~succ x) 
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_functional():
    code = '''
(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fix_solving():
    body = ('''
(ALL [G007] (G007 -> ((ALL [G005 G006
    ; G007 <: (G005 -> G006)
] (~cons G005 -> ~succ G006)) & (~nil @ -> ~zero @))))
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, body, "A -> (B -> C)")
    for i, world in enumerate(worlds):
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~
RESULT WORLD {i}
~~~~~~~~~~~~~~~~~~~~~~~~
constraints:
{analyzer.concretize_constraints(world.constraints)}
~~~~~~~~~~~~~~~~~~~~~~~~
        """)

def test_relational_implication_subtyping_pass_A():
    f = ('''
    ALL[X] X -> 
    EXI[Y ; (X, Y) <: (FX R 
        | (~zero @, ~nil @)
        | (EXI [N L ; (N,L)<:R] (~succ N, ~cons L))
    )] Y
    ''')
    # io = ('''
    #     ALL [X; X <: (FX N | ~zero @ | ~succ N)] X -> Z 
    # ''')
    io = ('''
        (FX N | ~zero @ | ~succ N) -> Z 
    ''')
    # TODO: handle LFP consequent
    # consistent
    # X <: ~zero @ |-  (X, Y) <: (FX R ...)

    # consistent
    # X <: (FX N | ~zero @ | ~succ N) |-  (X, Y) <: (FX R ...)

    # inconsistent
    # X <: ~err @ |-  (X, Y) <: (FX R ...)

    # inconsistent
    # X <: (FX N | ~zero @ | ~succ N | ~err @) |-  (X, Y) <: (FX R ...)

    solver = analyzer.Solver(m())
    worlds = solve(solver, f, io)
    print(f"""
DEBUG test_relational_implication_subtyping_pass_A
len(worlds): {len(worlds)}
    """)
    assert worlds

def test_relational_implication_subtyping_pass_B():
    f = ('''
    ALL[X] X -> 
    EXI[Y ; (X, Y) <: (FX R 
        | (~zero @, ~nil @)
        | (EXI [N L ; (N,L)<:R] (~succ N, ~cons L))
    )] Y
    ''')
    # io = ('''
    #     ALL [X; X <: (FX N | ~zero @ | ~succ ~succ N)] X -> Z 
    # ''')
    io = ('''
        (FX N | ~zero @ | ~succ ~succ N) -> Z 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, f, io)
    print(f"""
DEBUG test_relational_implication_subtyping_pass_B
len(worlds): {len(worlds)}
    """)
    assert worlds


def test_relational_implication_subtyping_fail():
    f = ('''
    ALL[X] X -> 
    EXI[Y ; (X, Y) <: (FX R 
        | (~zero @, ~nil @)
        | (EXI [N L ; (N,L)<:R] (~succ N, ~cons L))
    )] Y
    ''')
    # io = ('''
    #     ALL [X ; X <: (FX N | ~zero @ | ~succ N | ~err N)] -> Z
    # ''')
    io = ('''
        (FX N | ~zero @ | ~succ N | ~err N) -> Z
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, f, io)
    print(f"""
DEBUG test_relational_implication_subtyping_fail
len(worlds): {len(worlds)}
    """)
    assert not worlds

def test_relational_implication_subtyping_pass_C():
    f = ('''
    ALL[X] X -> 
    EXI[Y ; (X, Y) <: (FX R 
        | (~zero @, ~nil @)
        | (EXI [N L ; (N,L)<:R] (~succ N, ~cons L))
    )] Y
    ''')
    # io = ('''
    #     ALL [X; X <: (FX N | ~zero @ | ~succ N)] X -> (FX L | ~nil @ | ~cons L) 
    # ''')
    io = ('''
        (FX N | ~zero @ | ~succ N) -> (FX L | ~nil @ | ~cons L) 
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, f, io)
    print(f"""
DEBUG test_relational_implication_subtyping_pass_C
len(worlds): {len(worlds)}
    """)
    assert worlds

def test_inter_subtypes_union_antec_pass():
    l = ('''
        (~A @ -> @) & (~B @ -> @)
    ''')
    r = ('''
        (~A @ | ~B @) -> @
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, l, r) 
    print(f"""
len(worlds): {len(worlds)}
    """)
    assert worlds

def test_inter_subtypes_inter_consq_pass():
    l = ('''
        (@ -> ~A @) & (@ -> ~B @)
    ''')
    r = ('''
        @ -> (~A @ & ~B @)
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, l, r) 
    print(f"""
len(worlds): {len(worlds)}
    """)
    assert worlds

def test_inter_subtypes_inter_record_pass():
    l = ('''
        (foo : ~A @) & (foo : ~B @)
    ''')
    r = ('''
        foo : (~A @ & ~B @)
    ''')
    solver = analyzer.Solver(m())
    worlds = solve(solver, l, r) 
    print(f"""
len(worlds): {len(worlds)}
    """)
    assert worlds



def test_fix_body():
    code = '''
(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fix():

    # TODO: update negative and positive interpretation to remove constraints
    code = '''
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => 
        ~succ (self(x))
))
    '''

    # TODO: update interpretation to get transitive interpretations 

    code = '''
let f = (case ~cons x => x) in
fix(case self => (
    case ~nil @ => ~zero @ 
    case y => 
        ~succ (self(f(y)))
))
    '''

#     code = '''
# let f = (case a => a) in
# (case self => (
#     case ~cons x => 
#         f(~succ (self(x))) 
# ))
#     '''

#     code = '''
# let f = (case a => a) in
# (case self => (
#     case ~cons x => 
#         (~succ (f(self(x)))) 
# ))
#     '''
    (result, parsetree, solver) = analyze(code)
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fix_aliased():
    code = '''
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => (~succ (self(x))) 
))
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_identity_function():
    code = '''
(case x => x)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "ALL [_2 ; _2 <: _1] _1 -> _1"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_unit_funnel_identity():
    code = '''
@ |> (case x => x)
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_nil_funnel_fix():
    code = '''
~nil @ |> (fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))
    '''
    (result, parsetree, solver) = analyze(code)
    expected = "~zero @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_fix_nil():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~nil @) 
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~zero @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_fix_cons():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~nil @) 
    '''

    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~succ ~zero @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_app_fix_cons_cons():
    code = '''
(fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
)))(~cons ~cons ~nil @) 
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~succ ~succ ~zero @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_funnel_pipeline():
    code = '''
~nil @ |> (case ~nil @ => @) |> (case @ => ~uno @)
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~uno @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


# fix(case self => (
# case ~nil @ => ~zero @ 
# case ~cons x => ~succ (self(x)) 
# ))

def test_pattern_tuple():
    code = '''
case (~zero @, @) => @
    '''
    (result, parsetree, solver) = analyze(code)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "((~zero @, @) -> @)"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

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

    (result, parsetree, solver) = analyze(if_true_then_else)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~uno @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_if_false_then_else():
    if_false_then_else = (f'''
    if ~false @ then
        ~uno @
    else
        ~dos @
    ''')

    (result, parsetree, solver) = analyze(if_false_then_else)
    # print("answer:\n" + decode_positive(solver, results))
    expected = "~dos @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_function_if_then_else():
    function_if_then_else = (f'''
    case x => (
        if x then
            ~uno @
        else
            ~dos @
    )
    ''')
    (result, parsetree, solver) = analyze(function_if_then_else)
    expected = "(_2 -> (~uno @ | ~dos @))"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_lted_expr():
    code = f"""
alias R = (FX SELF
    | (EXI [N] ((~zero @, N), ~true @))
    | (EXI [B M N ; ((M, N), B) <: SELF ] ((~succ M, ~succ N), B))
    | (EXI [M] ((~succ M, ~zero @), ~false @))
)
{el.lted}
    """.strip()
    (result, parsetree, solver) = analyze(code)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_let_lted_expr():
    let_lted = (f'''
let lted = {el.lted} in
lted
    ''')
    (result, parsetree, solver) = analyze(let_lted)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_lted_normalization():
    strong = p("(x : X & y : Y & z : Z)")
    weak = p(tl.lted_xyz)
#     print(f"""
# ~~~~~~~~~~~~~~~~~~~
# Normalize Test
# ~~~~~~~~~~~~~~~~~~~
# strong: 
# {analyzer.concretize_typ(strong)}

# weak: 
# {analyzer.concretize_typ(weak)}
# ~~~~~~~~~~~~~~~~~~~
#           """)
    assert isinstance(weak, analyzer.LeastFP)


    ordered_path_target_pairs = analyzer.extract_ordered_path_target_pairs(strong)
    norm_strong = analyzer.make_tuple_typ([v for (k,v) in ordered_path_target_pairs])
    ordered_paths = [k for (k,v) in ordered_path_target_pairs]
    norm_weak = analyzer.normalize_least_fp(weak, ordered_paths)
    print(f"""
~~~~~~~~~~~~~~~~~~~
Normalize Test
~~~~~~~~~~~~~~~~~~~
norm_strong: 
{analyzer.concretize_typ(norm_strong)}

norm_weak: 
{analyzer.concretize_typ(norm_weak)}
~~~~~~~~~~~~~~~~~~~
          """)

def test_existential_lted_normalized_subs_lted_xyz():
    R = (f"""
(FX self
| (EXI [x ; x <: (FX N | (~zero @ | ~succ N)) ] ((~zero @, x), ~true @))
| (EXI [a b c ; ((a, b), c) <: self ] ((~succ a, ~succ b), c))
| (EXI [x ; x <: (FX N | (~zero @ | ~succ N)) ] ((~succ x, ~zero @), ~false @))
)
    """.strip())
    strong = (f""" 
(EXI [X Y Z ; ((X, Y), Z) <: {R} ] ((X, Y), Z))
    """.strip())
    weak = (f"""
EXI [X Y Z ; (x : X & y : Y & z : Z) <: {tl.lted_xyz}] ((X, Y), Z)
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    assert worlds

def test_fixpoint_subs_existential():
    # TODO: figure out wat to verify without rewriting LHS into existential
    lower = tl.even_list
    upper = (f"""
EXI [X Y ; (X, Y) <: {tl.even_list}] (X, Y) 
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    print(f"len(worlds): {len(worlds)}")
    assert worlds

def test_lted_normalized_subs_lted_xyz():
    # TODO: figure out wat to verify without rewriting LHS into existential
    strong = tl.lted
    weak = (f"""
EXI [X Y Z ; (x : X & y : Y & z : Z) <: {tl.lted_xyz}] ((X, Y), Z)
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    assert worlds

def test_nat_subs_exi():
    strong = tl.nat
    weak = (f"""
EXI [X ;  X <: {tl.nat}] X 
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    assert worlds

def test_lted_two_one_query():
    query = ('''
((~succ ~succ ~zero @, ~succ ~zero @), Z)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, query, tl.lted, p("Z"), False)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "~false @"

def test_weak_diff():
    left = ('''
(~succ ~zero @)
    ''')
    right = ('''
(~succ W) \\ (EXI [x] (~zero @, x))
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, left, right, p("W"), True)
    print(f"answer:\n{answer}")
    # assert answer == "(~succ ~succ ~zero @, ~succ ~zero @)" 
    assert answer == "~zero @" 

def test_weak_diff_in_pair():
    left = ('''
((~succ ~zero @), @)
    ''')
    right = ('''
(((~succ W) \\ (EXI [x] (~zero @, x))), @)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, left, right, p("W"), True)
    print(f"answer:\n{answer}")
    # assert answer == "(~succ ~succ ~zero @, ~succ ~zero @)" 
    assert answer == "~zero @" 


def test_less_equal_imp_subs_one_two_imp_query():
    two_one_imp_query = ('''
((~succ ~zero @, ~succ ~succ ~zero @) -> Q)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, tl.lted_imp, two_one_imp_query, p("Q"), True)
    print(f"answer:\n{answer}")
    assert answer == "~true @" 

def test_less_equal_imp_subs_two_one_imp_query():
    two_one_imp_query = ('''
((~succ ~succ ~zero @, ~succ ~zero @) -> Q)
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, tl.lted_imp, two_one_imp_query, p("Q"), True)
    print(f"answer:\n{answer}")
    assert answer == "~false @" 


def test_app_lted_zero_one():
    app_less = (f'''
({el.lted})(~zero @, ~succ ~zero @)
    ''')
    (result, parsetree, solver) = analyze(app_less)
    expected = "~true @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_app_lted_two_one():
    app_less = (f'''
({el.lted})(~succ ~succ ~zero @, ~succ ~zero @)
    ''')
    (result, parsetree, solver) = analyze(app_less)
    expected = "~false @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_nested_fun():
    nested_fun = (f'''
    case x => (
        (
        case (~true @) => ~uno @ 
        case (~false @) => ~dos @ 
        )(x)
    )
    ''')
    (result, parsetree, solver) = analyze(nested_fun)
    expected = "((~true @ -> ~uno @) & (~false @ -> ~dos @))"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_pattern_match_wrap():
    pattern_match_wrap = (f'''
    let cmp = (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    ) in
    case (x, y) => (cmp(x, y))
    ''')

    (result, parsetree, solver) = analyze(pattern_match_wrap)
    # expected typ: ((ALL [ ; _9 <: ~dos @] ((~uno @, _9) -> _9)) & (ALL [ ; _8 <: ~dos @] ((_8, ~uno @) -> _8)))
    expected = "(X, Y) -> ~dos @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_arg_specialization():
    arg_specialization = (f'''
    let cmp = (
        case (~uno @, ~dos @) => ~true @
        case (~dos @, ~uno @) => ~false @ 
    ) in
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
    ) in
    case (x, y) => (cmp(x, y))
    ''')

    # arg_specialization = (f'''
    # let cmp = (
    #     case (~uno @, ~dos @) => ~true @
    #     case (~dos @, ~uno @) => ~false @ 
    # ) in 
    # case (x, y) => (
    #     (
    #     case ~true @ => y
    #     case ~false @ => x
    #     ) (cmp(x, y)) 
    # )
    # ''')

    (result, parsetree, solver) = analyze(arg_specialization)
    # expected typ: ((ALL [ ; _9 <: ~dos @] ((~uno @, _9) -> _9)) & (ALL [ ; _8 <: ~dos @] ((_8, ~uno @) -> _8)))
    expected = "(X, Y) -> ~dos @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_passing_pattern_matching():
    # program = (f'''
    # let cmp = (
    #     case (~uno @, ~dos @) => ~true @
    #     case (~dos @, ~uno @) => ~false @ 
    # ) in

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

    (result, parsetree, solver) = analyze(program)
    # expected = "..."
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_recursion_wrapper():

    program = (f'''
    case (x, y) => (
        ({el.lted})(x, y)
    )
    ''')

    # try:
    (result, parsetree, solver) = analyze(program)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))
    # except Exception:
    #     print("exception raised")


def test_implication_unification():
    # TODO: why is constraint of (I, J) <: X missing?
    strong = (f"""
(X -> (EXI [Y ; (X, Y) <: (FX SELF 
    | (EXI [B] ((~zero @, B), ~true @))
    | (EXI [A C B ; ((A, B), C) <: SELF ] ((~succ A, ~succ B), C))
    | (EXI [A] ((~succ A, ~zero @), ~false @))
)] Y))
    """)
    weak = (f"""
((I, J) -> K)
    """)
    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
#     print(f"len(worlds): {len(worlds)}")
#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG test_implication_unification
# ~~~~~~~~~~~~~~~~~~~~~~~~~
# worlds[0].constraints:
# {analyzer.concretize_constraints(worlds[0].constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)
    assert len(worlds) == 1
    assert analyzer.Subtyping(p("(I, J)"), p("X")) in worlds[0].constraints

def test_lted_wrapper():
    # TODO: the constraint on the antecedent is disconnected
    # - is it the connection being interpreted away in application?
    wrapper = (f"""
let lted = {el.lted} in
case (x, y) => (
    (lted)(x, y)
)
""".strip())
    (result, parsetree, solver) = analyze(wrapper)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_max_parts_disjoint():
    lower = ('''
(EXI [G029
    ; G029 <: ~false @
] (ALL [G025 G026 G030
    ; ((G025, G026), G029) <: (FX G016
        | ((EXI [G018] ((~succ G018, ~zero @), ~false @))
            | ((EXI [G019 G020 G021
                ; ((G019, G020), G021) <: G016
            ] ((~succ G019, ~succ G020), G021))
                | (EXI [G022] ((~zero @, G022), ~true @)))))
    ; G025 <: G030
] ((G025, G026) -> G030)))
    ''')

    upper = ('''
(EXI [G029
    ; G029 <: ~true @
] (ALL [G025 G026 G030
    ; ((G025, G026), G029) <: (FX G016
        | ((EXI [G018] ((~succ G018, ~zero @), ~false @))
            | ((EXI [G019 G020 G021
                ; ((G019, G020), G021) <: G016
            ] ((~succ G019, ~succ G020), G021))
                | (EXI [G022] ((~zero @, G022), ~true @)))))
    ; G026 <: G030
] ((G025, G026) -> G030)))
    ''')

    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    print(f'len(worlds): {len(worlds)}')
    # assert not worlds

def test_if_else():
    # TODO: remove decoding; expression typing should already package types and combine together 

    code = (f"""
case (x, y) => (
    if ~true @ then
        y
    else
        x
)
    """.strip())
    (result, parsetree, solver) = analyze(code)
    print("answer:\n" + analyzer.concretize_typ(result))


def test_max():
    # TODO: remove decoding; expression typing should already package types and combine together 
    (result, parsetree, solver) = analyze(el.max)
    print("answer:\n" + analyzer.concretize_typ(result))

def test_relationally_constrained_existential_subtyping_fail():
    solver = analyzer.Solver(m())
    strong = (f'''
EXI [A B] (A, B)
    ''')
    weak = (f'''
EXI [X Y ; (X,Y) <: {tl.nat_list}] (X, Y)
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    for world in worlds:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG RESULT WORLD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
world.constraints:
{analyzer.concretize_constraints(world.constraints)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
    #end for
    assert not bool(worlds)


def test_constrained_universal_subtyping_fail():
    # TODO: this should pass; inhabitability check should move to typing rules
    solver = analyzer.Solver(m())
    strong = (f'''
ALL [Q; Q <: ~alpha @] Q -> Q 
    ''')
    weak = (f'''
 X -> EXI [Y ; Y <: ~beta @] Y 
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
#     for world in worlds:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG RESULT WORLD
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# world.constraints:
# {analyzer.concretize_constraints(world.constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
    assert not worlds 

def test_constrained_universal_subtyping_record_pass():
    solver = analyzer.Solver(m())
    strong = (f'''
ALL [Q; Q <: (q : ~alpha @)] Q -> Q 
    ''')
    weak = (f'''
 X -> EXI [Y ; Y <: (y : ~beta @)] Y 
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    for world in worlds:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG RESULT WORLD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
world.constraints:
{analyzer.concretize_constraints(world.constraints)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
    assert worlds 

def test_constrained_universal_subtyping_record_fail():
    solver = analyzer.Solver(m())
    strong = (f'''
ALL [Q; Q <: (l : ~alpha @)] Q -> Q 
    ''')
    weak = (f'''
 X -> EXI [Y ; Y <: (l : ~beta @)] Y 
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
#     for world in worlds:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG RESULT WORLD
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# world.constraints:
# {analyzer.concretize_constraints(world.constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
    assert not worlds 

def test_constrained_universal_subtyping_function_fail():
    solver = analyzer.Solver(m())
    strong = (f'''
ALL [Q; Q <: (@ -> ~alpha @)] Q -> Q 
    ''')
    weak = (f'''
 X -> EXI [Y ; Y <: (@ -> ~beta @)] Y 
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    for world in worlds:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG RESULT WORLD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
world.constraints:
{analyzer.concretize_constraints(world.constraints)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)

def test_constrained_universal_subtyping_function_diff_pass():
    solver = analyzer.Solver(m())
    strong = (f'''
ALL [Q; Q <: (~alpha @ -> ~alpha @)] Q -> Q 
    ''')
    weak = (f'''
 X -> EXI [Y ; Y <: ((I \\ (~alpha @)) -> ~beta @)] Y 
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    for world in worlds:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG RESULT WORLD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
world.constraints:
{analyzer.concretize_constraints(world.constraints)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)


def test_max_subtyping():
    solver = analyzer.Solver(m())
    strong = tl.max 
    weak = (f'''
(A, B) -> (EXI [Y ; (A, Y) <: ({tl.open_lte})] Y)
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    assert bool(worlds)

def test_max_subtyping_fail():
    solver = analyzer.Solver(m())

    crummy = (f"""
(FX SELF 
    | (EXI [x] (~zero @, ~succ ~zero @))
    | (EXI [a b ; (a,b) <: SELF] (~succ a, ~zero @))
)
    """)


    strong = tl.max 
    weak = (f'''
(A, B) -> (EXI [Y ; (A, Y) <: ({crummy})] Y)
    ''')
    worlds = solve(solver, strong, weak)
    print(f"len(worlds): {len(worlds)}")
    assert not bool(worlds)

def test_max_annotated():
    code = (f'''
let max : (A, B) -> (EXI [Y ; (A, Y) <: ({tl.open_lte})] Y) = {el.max} in
@
    ''')
    (result, parsetree, solver) = analyze(code)
    print("answer:\n" + analyzer.concretize_typ(result))


def test_single_shape():

    lower = f'''
~true @
    '''
# PROBLEM: unguarded self reference
    upper = ('''
(FX SELF
    | (EXI [G43] ~true @)
    | (EXI [G45 G17 G44 ; G17 <: SELF ] G17)
    | (EXI [G46] ~false @) 
    | BOT
)
    ''')

    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1


def test_add():
    (result, parsetree, solver) = analyze(el.add)
    # expected == "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_exi_add_rel_subs_query():
    exi_add = '''
(EXI [Y ; (~zero @, ~zero @) <: X ; (X, Y) <: (FX self | ((EXI [B] ((~zero @, B), B)) | (EXI [B A] ((~succ A, B), B))))] Y)
    '''
    query = ('''
Q
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, exi_add, query, p("Q"), True)
    print(f"answer:\n{answer}")
    assert answer == "~zero @" 


def test_add_imp_subs_zero_zero_imp_query():

    add_imp = '''
(ALL [X ; X <: (FX self | ((EXI [B] (~zero @, B)) | (EXI [B A] (~succ A, B))))] (X -> (
    EXI [Y ; (X, Y) <: (FX self | ((EXI [B] ((~zero @, B), B)) | (EXI [B A] ((~succ A, B), B))))] Y
))) 
    '''
    zero_zero_imp_query = ('''
((~zero @, ~zero @) -> Q)
    ''')

    solver = analyzer.Solver(m())
    answer = solve_decode(solver, add_imp, zero_zero_imp_query, p("Q"), True)
    print(f"answer:\n{answer}")
    assert answer == "~zero @" 


def test_add_zero_and_zero_equals_zero():
    code = f"""
({el.add})(~zero @, ~zero @)
    """
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_add_one_and_two_equals_three():
    code = f"""
({el.add})(~succ ~zero @, ~succ ~succ ~zero @)
    """
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_existential_with_extrusion():
    strong = ("""
(EXI [X ; X <: A ] ~thing X)
    """)

    weak = ("""
(EXI [Q] ~thing Q)
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1


def test_existential_with_upper_bound():
    strong = ("""
(EXI [X] ~thing X)
    """)

    weak = ("""
(EXI [Q ; Q <: @ ] ~thing Q)
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 0

def test_existential_with_upper_bound_unguarded():
    # TODO: use substitution for existential witness to avoid F <: L circular problem.
    strong = ("""
(EXI [X] X)
    """)

    weak = ("""
(EXI [Q ; Q <: @ ] Q)
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 0

def test_relation_factorized_subs():
    strong = tl.nat_list

    list = ('''
(FX L | ~nil @ | ~cons L)
    ''')

    weak = (f"""
({tl.nat}, {list})
    """)

    solver = analyzer.Solver(m())
    worlds = solve(solver, strong, weak)
    print(f'len(worlds): {len(worlds)}')
    assert len(worlds) == 1 

def test_add_annotated():

    # lte = (f'''
    # (FX SELF 
    #     | (EXI [N ; N <: {tl.nat}] (~zero @, N))
    #     | (EXI [A B ; (A,B) <: SELF] (~succ A, ~succ B))
    # )
    # ''')
    lte = (f'''
    (FX SELF 
        | (EXI [N] (~zero @, N))
        | (EXI [A B ; (A,B) <: SELF] (~succ A, ~succ B))
    )
    ''')

    code = (f'''
let add : (A, B) -> (EXI [Y ; (A, Y) <: ({lte})] Y) = {el.add} in
@
    ''')
    (result, parsetree, solver) = analyze(code)
    # expected = "..."
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_fib():
    (result, parsetree, solver) = analyze(el.fib)
    # expected = "..."
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fib_annotated():
    # TODO: come up with a feasible annotation
    anno_fib = (f'''
let fib : X -> Y = {el.fib} in
@
    ''')

    (result, parsetree, solver) = analyze(anno_fib)
    # expected = "..."
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fib_zero_equals_zero():
    code = f"""
({el.fib})(~zero @)
    """
    (result, parsetree, solver) = analyze(code)
    # expected = "..."
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_fib_two_equals_one():
    code = f"""
({el.fib})(~succ ~succ ~zero @)
    """
    (result, parsetree, solver) = analyze(code)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_application_in_tuple():

    code = (f'''
    let f = (case x => x) in
    let g = (case x => x) in
    (f)(@), (g)(@)
    ''')

    (result, parsetree, solver) = analyze(code)
    expected = "(@, @)"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_generalized_application_in_tuple():
    # TODO: this requires add generalization in the combine_function rule
    code = (f'''
    let f = (case x => x) in
    (f)(@), (f)(@)
    ''')

    (result, parsetree, solver) = analyze(code)
    expected = "(@, @)"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_sumr():
    (result, parsetree, solver) = analyze(el.sumr)
    # TODO: decode is very slow; make it faster somehow
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_suml():
    (result, parsetree, solver) = analyze(el.suml)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_foldr():
    (result, parsetree, solver) = analyze(el.foldr)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_foldl():
    (result, parsetree, solver) = analyze(el.foldl)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))


def test_antecedent_union():
    strong = ('''
(~uno @ -> ~one @) & (~dos @ -> ~two @) 
    ''')

    weak = ('''
((~uno @ | ~dos @) -> Q) 
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, strong, weak, p("Q"), True)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "(~two @ | ~one @)" 

def test_consequent_intersection():
    strong = ('''
(@ -> (uno : ~one @)) & (@ -> (dos : ~two @)) 
    ''')

    weak = ('''
(Q -> (uno : ~one @) & (dos : ~two @)) 
    ''')
    solver = analyzer.Solver(m())
    answer = solve_decode(solver, strong, weak, p("Q"), False)
    print(f'''
answer:\n{answer}
    ''')
    assert answer == "@" 


def test_preamble_pass():
    code = (f'''
alias T = ~uno @
alias U = ~dos @
let x : T = ~uno @ in
x
    ''')

    (result, parsetree, solver) = analyze(code)
    expected = "~uno @"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_preamble_fail():
    code = (f'''
alias T = ~uno @
alias U = ~dos @
let x : U = ~uno @ in
x
    ''')

    (result, parsetree, solver) = analyze(code)
    expected = "BOT"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_annotated_let():
    code = (f'''
alias Z = @
let x : ~uno B = ~uno @ in
let ident : T0 = (case x => x) in
let add : T1 = fix (case self => ( 
    case (~zero @, b) => b 
    case (~succ a, b) => ~succ (self(a, b))
)) in
@
    ''')

    code = (f'''
let y : T = (~dos @) in
@
    ''')
    (result, parsetree, solver) = analyze(code)
    expected = "@"
    assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))



def test_concat_lists():
    (result, parsetree, solver) = analyze(el.concat_lists)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_reverse():
    code = f"""
alias CTREL = (FX SELF
    | (EXI [l] ((~nil @, l), l))
    | (EXI [YS X XS l ; ((XS, l), YS) <: SELF ] ((~cons (X, XS), l), ~cons (X, YS)))
)
{el.reverse}
    """.strip()
    (result, parsetree, solver) = analyze(code)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_tail_reverse():
    # TODO: compare curried vs non-curried version
    (result, parsetree, solver) = analyze(el.tail_reverse)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_stepped_tail_reverse():
    # TODO: compare curried vs non-curried version
    (result, parsetree, solver) = analyze(el.stepped_tail_reverse)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_curried_tail_reverse():
    # TODO: compare curried vs non-curried version
    (result, parsetree, solver) = analyze(el.curried_tail_reverse)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_halve_list():
    code = f"""
alias R = (FX SELF
    | (~nil @, (~nil @, ~nil @))
    | (EXI [X] (~cons (X, ~nil @), (~cons (X, ~nil @), ~nil @)))
    | (EXI [YS ZS Y GZ XS ; (XS, (YS, ZS)) <: SELF ] 
        (~cons (Y, ~cons (GZ, XS)), (~cons (Y, YS), ~cons (GZ, ZS)))
    )
)
{el.halve_list}
    """.strip()
    (result, parsetree, solver) = analyze(code)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_merge_lists():
    code = f"""
alias LTEDR = (FX SELF
    | (EXI [N] ((~zero @, N), ~true @))
    | (EXI [B M N ; ((M, N), B) <: SELF ] ((~succ M, ~succ N), B))
    | (EXI [M] ((~succ M, ~zero @), ~false @))
)
{el.merge_lists}
    """.strip()
    (result, parsetree, solver) = analyze(code)
    # expected = "@"
    # assert analyzer.concretize_typ(result) == expected 
    print("answer:\n" + analyzer.concretize_typ(result))

def test_merge_sort():
    code = f"""
alias LTEDR = (FX SELF
    | (EXI [N] ((~zero @, N), ~true @))
    | (EXI [B M N ; ((M, N), B) <: SELF ] ((~succ M, ~succ N), B))
    | (EXI [M] ((~succ M, ~zero @), ~false @))
)

{el.merge_sort}
    """.strip()
    (result, parsetree, solver) = analyze(code)
    print("answer:\n" + analyzer.concretize_typ(result))
    # assert decode_positive(solver, results) == "@"

def test_skolem_subtyping_A():
    lower = (f"""
BOT -> TOP 
    """.strip())

#     lower = (f"""
# @ -> @
#     """.strip())

    upper = (f"""
ALL[X] X -> X
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert not worlds

def test_skolem_subtyping_B():
    lower = (f"""
TOP -> BOT 
    """.strip())

    upper = (f"""
ALL[X] X -> X
    """.strip())

#     upper = (f"""
# @ -> @
#     """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert worlds

def test_skolem_subtyping_C():
    lower = (f"""
(~uno @ | ~dos @) -> ~uno @ 
    """.strip())

    upper = (f"""
ALL[X ; ~uno @ <: X ; X <: ~uno @ | ~dos @] X -> X
    """.strip())
    solver = analyzer.Solver(m())
    worlds = solve(solver, lower, upper)
    assert worlds

if __name__ == '__main__':
    # test_skolem_subtyping_C()
    # test_zero_subs_nat()
    # test_one_cons_query_subs_nat_list()
    # test_two_cons_query_subs_nat_list()
    # test_plus_equals_two_query()
    #####################################
    # test_even_list_subs_nat_list_pass()
    # test_nat_list_subs_even_list_fail()
    # #####################################
    # test_even_subs_nat_pass()
    # test_nat_subs_even_fail()
    #####################################
    # test_one_plus_equals_two_query()
    #####################################
    # test_single_shape()
    # test_implication_unification()
    # test_lted_wrapper()
    # test_max_parts_disjoint()
    ######## TODO: update type construction to replace skolems and variables in payload and in relational constraints. 
    test_max()

    # test_fix()
    # test_max_annotated()
    # test_max_subtyping()
    # test_max_subtyping_fail()
    # test_constrained_universal_subtyping_fail()
    # test_constrained_universal_subtyping_record_pass()
    # test_constrained_universal_subtyping_record_fail()
    # test_constrained_universal_subtyping_function_fail()
    # test_constrained_universal_subtyping_function_diff_pass()
    # test_plus_equals_two_query()
    #####################################
    # test_identity_function()
    # test_fix_solving()
    # test_fix_body()
    # test_fix()
    # test_add()
    #####################################
    # test_existential_with_extrusion()
    # test_existential_with_upper_bound()
    # test_existential_with_upper_bound_unguarded()
    # test_existential_lted_normalized_subs_lted_xyz()
    # test_fixpoint_subs_existential()
    # test_lted_normalized_subs_lted_xyz()
    # test_nat_subs_exi()
    # test_relation_factorized_subs()
    # test_add_annotated()
    # test_even_list_subs_nat_list()
    # test_nat_list_subs_even_list()
    # test_relationally_constrained_existential_subtyping_fail()
    #####################################
    # test_fib()
    #####################################
    # test_concat_lists()
    # test_reverse()
    # test_tail_reverse()
    # test_stepped_tail_reverse()
    # test_curried_tail_reverse()
    #####################################
    # test_halve_list()
    # test_lted_expr()
    # test_merge_lists()
    # test_merge_sort()
    #####################################
    # test_coinduction_malformed()
    # test_existential_fixpoint_subs_false()
    # test_fixpoint_subs_false()
    # test_pair_subs_relational_constraint_false()
    # test_top_subs_relational_constraint_false()
    #####################################
    # test_relational_implication_subtyping_pass_A()
    # test_relational_implication_subtyping_pass_B()
    # test_relational_implication_subtyping_pass_C()
    # test_relational_implication_subtyping_fail()
    #####################################
    # test_inter_subtypes_union_antec_pass()
    # test_inter_subtypes_inter_consq_pass()
    # test_inter_subtypes_inter_record_pass()
    #####################################
    # test_existential_elimination_pass()
    # test_existential_elimination_fail()
    #####################################
    pass

#######################################################################
