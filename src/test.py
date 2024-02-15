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

    # pieces = [

    #     "fix (self =>", " (", "\n",
    #     "    fun ~nil . => ~zero () ", "\n",
    #     "    fun ~cons x ", "=>", "~succ", "(self(", "x))", "\n",
    #     ")", ")"
    # ]

    # pieces = [
    #     "hello"
    # ]

    # pieces = [
    #     ":hello ()"
    # ]

    # pieces = [
# """
# (~uno = @ ~dos = @).uno
# """,
###############
# """
# let rec = ~uno = @ ~dos = @ ;
# rec.uno
# """,
###############
# """
# ((~uno = (:one = @)).uno).one
# """,
###############
# """
# (~uno = (:one = @)).uno.one
# """,
###############
# """
# let rec = ~uno = (:one = @) ~dos = @ ;
# ((rec).uno).one
# """,
###############
# """
# let rec = ~uno = (:one = @) ~dos = @ ;
# rec.uno.one
# """,
###############
# """
# x => :ooga :booga x 
# """,
###############
# """
# (x => :ooga :booga x)
# """,
##################
# """
# (x => :ooga :booga x)(@)
# """,
###############
# """
# let foo = x => :ooga :booga x 
# foo(@)
# """,
###############
# """
# x => y => :ooga :booga (.uno = x .dos = y) 
# """,
###############
# """
# (x => y => :ooga :booga (.uno = x .dos = y)) (:one @) (:two @) 
# """,
###############
# """
# let foo = (x => y => :ooga :booga (~uno = x ~dos = y)) ;
# foo(:one @)(:two @)
# """,
###############
# "let x = :boo @ ;",
# '''
# let y = :foo x ;
# ''',
# "~uno = y ~dos = @", 
################
# "~uno = @ ~dos = @",
################
# "fix (", "@", ")",
################
# "fix", "(",
################
# server.Kill()
    # ] 

# pieces = [
# f'''
# fun ~nil () => ~zero () 
# fun ~cons () => ~succ (self(x))
# '''
# ]

def raise_guide(guides : list[analyzer.Guidance]):
    for guide in guides:
        if isinstance(guide, Exception):
            raise guide

def analyze(pieces : list[str]):
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

    return asyncio.run(_mk_task())

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



def test_typ_induc():
    d = ('''
induc self ~nil @ | ~cons self
    ''')
    assert u(p(d)) == "induc self (~nil @ | ~cons self)"
    # print(u(t))


nat = ('''
induc N bot 
    | ~zero @  
    | ~succ N 
''')

even = ('''
induc E bot 
    | ~zero @ 
    | ~succ ~succ E
''')

nat_list = ('''
induc NL bot 
    | (~zero @, ~nil @) 
    | [| N L . (N, L) <: NL ] (~succ N, ~cons L)  
''')

even_list = ('''
induc NL bot 
    | (~zero @, ~nil @) 
    | [| N L . (N, L) <: NL ] (~succ ~succ N, ~cons ~cons L)  
''')



nat_equal = ('''
induc SELF bot
    | (~zero @, ~zero @) 
    | [| A B . (A, B) <: SELF ] (~succ A, ~succ B)  
''')




addition_rel = (f'''
induc AR bot
    | [| Y Z .  (Y, Z) <: ({nat_equal}) ] (x : ~zero @ & y : Y & z : Z) 
    | [| X Y Z . (x : X & y : Y & z : Z) <: AR ] (x : ~succ X & y : Y & z : ~succ Z) 
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
    # print(f'len(models): {len(models)}')
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
{ N . N <: top} (~thing N)  
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
#     one_single = ('''
# (~succ ~zero @, ~cons ~nil @)
#     ''')
    # TODO: yeah, this is sound 
    one_single = ('''
(~succ ~zero @, ~cons bot) 
    ''')
    models = solve(one_single, nat_list)
    # print(f'len(models): {len(models)}')
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
    assert answer == "~nil @"
    print(f"""
model: {analyzer.concretize_constraints(tuple(model.constraints))}
answr: {answer}
    """)


def test_two_cons_query_subs_nat_list():
    two_cons_query = ('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    models = solve(two_cons_query, nat_list)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_weakest(model, p("X"))
    assert answer == "~cons ~nil @"
    print(f"""
model: {analyzer.concretize_constraints(tuple(model.constraints))}
answr: {answer}
    """)

def test_even_list_subs_nat_list():
    models = solve(even_list, nat_list)
    print(f"len(models): {len(models)}")
    # assert models

def test_nat_list_subs_even_list():
    models = solve(nat_list, even_list)
    print(f"len(models): {len(models)}")
    # assert not models


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
    assert answers == [
        "(~zero @, ~succ ~succ ~zero @)",
        "(~succ ~zero @, ~succ ~zero @)",
        "(~succ ~succ ~zero @, ~zero @)",
    ]

#     print(f'''
# len(models): {len(models)}
# answer: {answers}
#     ''')

def test_nil_query_subs_list_nat_diff():
    list_nat_diff = ('''
induc SELF ((~nil @, ~zero @) | (([| N L . (L, N) <: SELF ] ((~cons L \ ~nil @), ~succ N)) | bot))
    ''')

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

#     print(f'''
# len(models): {len(models)}
# answer: {answers}
#     ''')

def test_list_nat_imp_subs_nil_query_imp():
    rel = ('''
(induc SELF (
    (~nil @, ~zero @) | 
    ([| L N . (L, N) <: SELF ] ((~cons L \\ ~nil @), ~succ N))
))
    ''')


    list_nat_imp = (f'''
([& X <: (induc SELF (~nil @ | (~cons SELF \\ ~nil @)))] (X -> 
    ([| Y . (X, Y) <: ({rel})] Y)
))) 
    ''')

    nil_query_imp = ('''
(~nil @ -> Y)
    ''')
    models = solve(list_nat_imp, nil_query_imp)
    assert len(models) == 1
    model = models[0]
    # answer = analyzer.prettify_weakest(model, p("Y"))
    # answer = analyzer.prettify_strongest(model, p("Y"))
    # assert answer == "~zero @" 
    # TODO: consider freeing bound variables before variable rule
    for model in models:

        print(f'''
::::::
model: 
::::::
{analyzer.concretize_constraints(tuple(model.constraints))}
        ''')
        pass

#     print(f'''
# len(models): {len(models)}
# answer: {answer}
#     ''')



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
    assert parsetree == "(expr (base ~ uno (expr (base @))))"

def test_tuple():
    pieces = ['''
@, @, @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base @) , (base @))"

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
    assert parsetree == "(expr (base (function case (pattern (pattern_base ~ nil (pattern (pattern_base @)))) => (expr (base @)))))"
    assert u(simp(combo)) == "(~nil @ -> @)"
    print("combo: " + u(simp(combo)))

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
(_.uno = @ _.dos = @).uno
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base ( (expr (base (record _. uno = (expr (base @)) (record _. dos = (expr (base @)))))) )) (keychain . uno))"

def test_projection_chain():
    pieces = ['''
(_.uno = (~dos @) _.one = @).uno.dos
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)
    assert parsetree == "(expr (base ( (expr (base (record _. uno = (expr (base ( (expr (base ~ dos (expr (base @)))) ))) (record _. one = (expr (base @)))))) )) (keychain . uno (keychain . dos)))"

def test_application():
    pieces = ['''
(
case ~nil @ => @ 
case ~cons x => x 
)(~nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

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

def test_funnel_nil_fix():
    pieces = ['''
~nil @ |> fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons x => ~succ (self(x)) 
))
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert combo
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

max = (f'''
let less_equal = {less_equal} ;
case (x, y) => (
    if less_equal(x, y) then
        y
    else
        x
)
''')

if_else = (f'''
if ~true @ then
    ~uno @
else
    ~dos @
''')

def test_if_then_else():
    pieces = [if_else]
    (combo, guides, parsetree) = analyze(pieces)
    raise_guide(guides)
    assert combo
    print("combo: " + u(combo))
    print(parsetree)

def test_max():
    # TODO
    pieces = []
    (combo, guides, parsetree) = analyze(pieces)
    # raise_guide(guides)
    # print(parsetree)
    # assert combo
    # print("combo: " + u(combo))


if __name__ == '__main__':
    # test_fix()
    # test_funnel_nil_fix()
    test_list_nat_imp_subs_nil_query_imp()
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
