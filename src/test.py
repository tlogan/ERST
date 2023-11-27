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
from tapas.slim import server, analysis
from tapas.slim.analysis import *

from tapas.util_system import box, unbox

from pyrsistent import m, pmap, v

import pytest

    # pieces = [

    #     "fix (self =>", " (", "\n",
    #     "    fun :nil . => :zero () ", "\n",
    #     "    fun :cons x ", "=>", ":succ", "(self(", "x))", "\n",
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
# (:uno = @ :dos = @).uno
# """,
###############
# """
# let rec = :uno = @ :dos = @ ;
# rec.uno
# """,
###############
# """
# ((:uno = (:one = @)).uno).one
# """,
###############
# """
# (:uno = (:one = @)).uno.one
# """,
###############
# """
# let rec = :uno = (:one = @) :dos = @ ;
# ((rec).uno).one
# """,
###############
# """
# let rec = :uno = (:one = @) :dos = @ ;
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
# let foo = (x => y => :ooga :booga (:uno = x :dos = y)) ;
# foo(:one @)(:two @)
# """,
###############
# "let x = :boo @ ;",
# '''
# let y = :foo x ;
# ''',
# ":uno = y :dos = @", 
################
# ":uno = @ :dos = @",
################
# "fix (", "@", ")",
################
# "fix", "(",
################
# server.Kill()
    # ] 

# pieces = [
# f'''
# fun :nil () => :zero () 
# fun :cons () => :succ (self(x))
# '''
# ]

def raise_guide(guides : list[analysis.Guidance]):
    for guide in guides:
        if isinstance(guide, Exception):
            raise guide

def analyze(pieces : list[str]):
    async def _mk_task():

        connection = server.launch()

        guides = []
        for piece in pieces + [server.Kill()]:
            g = await connection.mk_caller(piece)
            guides.append(g)
            print()
            print(f"--------------------------")
            print(f"--- client's guidance: << {g} >>")
            print(f"--------------------------")
            print()
            if isinstance(g, server.Done):
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
    assert guides[-1] == server.Killed()
    assert not combo
    assert not parsetree 

def test_unit():
    pieces = ['''
@
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    # raise_guide(guides)
    assert parsetree == "(expr (base @))"

def test_tag():
    pieces = ['''
:uno @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base : uno (expr (base @))))"

def test_tuple():
    pieces = ['''
@, @, @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base @) , (base @))"

def test_record():
    pieces = ['''
:uno = @ :dos = @
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base (record : uno = (expr (base @)) (record : dos = (expr (base @))))))"


def test_function():
    pieces = ['''
case :nil @ => @ 
case :cons x => x 
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base (function case (pattern (pattern_base : nil (pattern (pattern_base @)))) => (expr (base @)) (function case (pattern (pattern_base : cons (pattern (pattern_base x)))) => (expr (base x))))))"

def test_projection():
    pieces = ['''
(:uno = @ :dos = @).uno
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base ( (expr (base (record : uno = (expr (base @)) (record : dos = (expr (base @)))))) )) (keychain . uno))"

def test_projection_chain():
    pieces = ['''
(:uno = (:dos @) :one = @).uno.dos
    ''']
    (combo, guides, parsetree) = analyze(pieces)
    assert parsetree == "(expr (base ( (expr (base (record : uno = (expr (base ( (expr (base : dos (expr (base @)))) ))) (record : one = (expr (base @)))))) )) (keychain . uno (keychain . dos)))"

def test_application():
    pieces = ['''
(
case :nil @ => @ 
case :cons x => x 
)(:nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_application_chain():
    pieces = ['''
(case :nil @ => case :nil @ => @)(:nil @)(:nil @)
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
let r = (:uno = @ :dos = @) ;
r.uno
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idprojection_chain():
    pieces = ['''
let r = (:uno = (:dos @) :one = @) ;
r.uno.dos
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idapplication():
    pieces = ['''
let f = (
case :nil @ => @ 
case :cons x => x 
) ;
f(:nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_idapplication_chain():
    pieces = ['''
let f = (case :nil @ => case :nil @ => @) ;
f(:nil @)(:nil @)
    ''']
    (combo, guides, parsetree) = analyze(pieces)

def test_fix():
    pieces = ['''
fix(case self => (
case :nil @ => :zero @ 
case :cons x => :succ (self(x)) 
))
    ''']
    (combo, guides, parsetree) = analyze(pieces)


def test_type_implication():
    typ = Imp(Imp(TVar('X'), TVar('Y')), TVar('Z'))
    concrete = concretize_type(typ)
    assert concrete == "((X -> Y) -> Z)"
    # print(f'<<< {concrete} >>>')

if __name__ == '__main__':
    pass

#######################################################################
    # main(sys.argv)
####################
    # interact()
####################

#     test_parse_tree_serialize(f'''
# fix (self => (
#     fun :nil () => :zero () 
#     fun :cons x => :succ (self(x)) 
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
