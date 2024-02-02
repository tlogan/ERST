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

"""
tests
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
case ~cons x => ~succ (self(x)) 
))
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_ite():
    pieces = ['''
if :true @ then 
    :one @
else
    :two @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    # print(parsetree)

def test_funnel():
    pieces = ['''
~nil @ |> fix(case self => (
case ~nil @ => ~zero @ 
case ~cons x => ~succ (self(x)) 
))
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_funnel_pipeline():
    pieces = ['''
~nil @ |> (case ~nil @ => @) |> (case ~nil @ => @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    print(parsetree)


def test_typ_implication():

    p = language.parse_typ("X -> Y -> Z")
    assert p 
    c = analyzer.concretize_typ(p) 
    print(c)
    assert c == "(X -> (Y -> Z))"



def test_typ_least():
    p = language.parse_typ('''
least self with ~nil @ | ~cons self
    ''')
    assert p 
    c = analyzer.concretize_typ(p) 
    assert c == "least self with (~nil @ | ~cons self)"


def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 

solver = analyzer.Solver() 
nat = p('''
least N with bot | ~zero @  | ~succ N 
''')

even = p('''
least E with bot | ~zero @ | ~succ ~succ E
''')

nat_list = p('''
least NL with
    bot |
    (~zero @, ~nil @) |
    { N L . (N, L) <: NL} (~succ N, ~cons L)  
''')

even_list = p('''
least NL with
    bot |
    (~zero @, ~nil @) |
    { N L . (N, L) <: NL} (~succ ~succ N, ~cons ~cons L)  
''')

addition_rel = p('''
least AR with
    {Y . Y <: top} (x : ~zero @ & y : Y & z : Y) |
    {X Y Z . (x : X & y : Y & z : Z) <: AR} (x : ~succ X & y : Y & z : ~succ Z) 
''')



def test_zero_subtyping_nat():
    zero = p('''
~zero @ 
    ''')
    models = solver.solve_composition(zero, nat)
    # print(f'len(models): {len(models)}')
    assert(models)

def test_two_subtyping_nat():
    two = p('''
~succ ~succ ~zero @ 
    ''')
    models = solver.solve_composition(two, nat)
    # print(f'len(models): {len(models)}')
    assert models

def test_bad_tag_subtyping_nat():
    bad = p('''
~bad ~succ ~zero @ 
    ''')
    models = solver.solve_composition(bad, nat)
    # print(f'len(models): {len(models)}')
    assert not models

def test_two_nat_subtyping_nat():
    two_nat = p(f'''
~succ ~succ ({u(nat)})
    ''')
    models = solver.solve_composition(two_nat, nat)
    # print(f'len(models): {len(models)}')
    assert models


def test_even_subtyping_nat():
    models = solver.solve_composition(even, nat)
    assert models

def test_nat_subtyping_even():
    models = solver.solve_composition(nat, even)
    # print(f'len(models): {len(models)}')
    assert not models

def test_subtyping_idx_unio():
    idx_unio = p('''
{ N . N <: top} (~thing N)  
    ''')
    thing = p('''
(~thing @)
    ''')

    models = solver.solve_composition(thing, idx_unio)
    for model in models:
        print(f'model: {analyzer.concretize_constraints(list(model))}')
    assert(models)


def test_zero_nil_subtyping_nat_list():
    global p
    zero_nil = p('''
(~zero @, ~nil @)
    ''')

    models = solver.solve_composition(zero_nil, nat_list)
    # print(f'len(models): {len(models)}')
    assert models

def test_one_single_subtyping_nat_list():
#     one_single = p('''
# (~succ ~zero @, ~cons ~nil @)
#     ''')
    # TODO: yeah, this is sound 
    one_single = p('''
(~succ ~zero @, ~cons bot) 
    ''')
    models = solver.solve_composition(one_single, nat_list)
    # print(f'len(models): {len(models)}')
    assert models

def test_two_single_subtyping_nat_list():
    two_single = p('''
(~succ ~succ ~zero @, ~cons ~nil @)
    ''')
    models = solver.solve_composition(two_single, nat_list)
    # print(f'len(models): {len(models)}')
    assert not models

def test_one_query_subtyping_nat_list():
    one_query = p('''
(~succ ~zero @, X)
    ''')
    models = solver.solve_composition(one_query, nat_list)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest_influence(model, p("X"))
    # print("answr: " + answer)
    assert answer == "~cons ~nil @"

def test_one_cons_query_subtyping_nat_list():
    global p
    one_cons_query = p('''
(~succ ~zero @, ~cons X)
    ''')
    models = solver.solve_composition(one_cons_query, nat_list)
    assert len(models) == 1
    model = models[0]
    # TODO
    answer = analyzer.prettify_strongest_influence(model, p("X"))
    assert answer == "~nil @"
    print(f"""
model: {analyzer.concretize_constraints(list(model))}
answr: {answer}
    """)


def test_two_cons_query_subtyping_nat_list():
    two_cons_query = p('''
(~succ ~succ ~zero @, ~cons X)
    ''')
    models = solver.solve_composition(two_cons_query, nat_list)
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest_influence(model, p("X"))
    assert answer == "~cons ~nil @"
    print(f"""
model: {analyzer.concretize_constraints(list(model))}
answr: {answer}
    """)

def test_even_list_subtyping_nat_list():
    models = solver.solve_composition(even_list, nat_list)
    print(f"len(models): {len(models)}")
    # assert models

def test_nat_list_subtyping_even_list():
    models = solver.solve_composition(nat_list, even_list)
    print(f"len(models): {len(models)}")
    # assert not models


def test_one_plus_one_equals_two():
#     one_plus_one_equals_two = p('''
# (x : ~succ ~zero @ & y : ~succ ~zero @ & z : ~succ ~succ ~zero @)
#     ''')
    # TODO: DEBUG. should (~succ bot) fail?
    # NOTE: the base case of addition_rel allows anything to be used
    one_plus_one_equals_two = p('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : ~succ bot)
    ''')
    models = solver.solve_composition(one_plus_one_equals_two, addition_rel)
    print(f'len(models): {len(models)}')
    assert len(models) == 1

def test_zero_plus_query():
    zero_plus_query = p('''
(x : (~zero @) & y : (~succ ~zero @) & z : Z)
    ''')
    base_case = p('''
{Y . Y <: top} (x : ~zero @ & y : Y & z : Y)
    ''')
    models = solver.solve_composition(zero_plus_query, base_case)
    # print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest_influence(model, analyzer.TVar("Z"))
    assert answer == "~succ ~zero @"
    print(f'''
model: {analyzer.concretize_constraints(list(model))}
answr: {answer}
    ''')

def test_one_plus_one_query():
    one_plus_one_query = p('''
(x : ~succ ~zero @ & y : ~succ ~zero @ & z : Z)
    ''')
    models = solver.solve_composition(one_plus_one_query, addition_rel)
    print(f'len(models): {len(models)}')
    assert len(models) == 1
    model = models[0]
    answer = analyzer.prettify_strongest_influence(model, analyzer.TVar("Z"))
    assert answer == "~succ ~succ ~zero @"
    print(f'''
model: {analyzer.concretize_constraints(list(model))}
answr: {answer}
    ''')



if __name__ == '__main__':
    test_two_cons_query_subtyping_nat_list()
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
