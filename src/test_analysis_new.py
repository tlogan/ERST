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
from tapas.slim.language import analyze, infer_typ, parse_typ

from tapas.slim import exprlib as el, typlib as tl
from tapas.slim.exprlib import ctx 

def test_max():
    assert infer_typ(el.max) != "" 

###############################################################
##### Typ Parsing 
###############################################################

def test_typ_parsing_1():
    assert parse_typ(f"""
<zero> @
    """)

def test_typ_parsing_2():
    assert parse_typ(f"""
(LFP[E] <zero> @ | <succ> <succ> E)
    """)

def test_typ_parsing_3():
    assert  parse_typ(f"""
(<succ> @) * (<cons> @)  
    """)

def test_typ_parsing_4():
    assert  parse_typ(f"""
EXI[N L] ((N * L) <: @) ; (<succ> N) * (<cons> L)  
    """)

def test_typ_parsing_5():
    assert  parse_typ(f"""
EXI[N L] ; (<succ> N) * (<cons> L)  
    """)

def test_typ_parsing_6():
    assert  parse_typ(f"""
EXI[N L] (<succ> N) * (<cons> L)  
    """)

def test_typ_parsing_7():
    assert  parse_typ(f"""
ALL[N L] ((N * L) <: @) ; (<succ> N) -> (<cons> L)  
    """)

def test_typ_parsing_8():
    assert  parse_typ(f"""
ALL[N L] ; (<succ> N) -> (<cons> L)  
    """)

def test_typ_parsing_9():
    assert  parse_typ(f"""
ALL[N L] (<succ> N) -> (<cons> L)  
    """)

###############################################################
##### Typing A. Polymorphic instantiation
###############################################################
def test_typing_A1():
    assert infer_typ(f"""
case x => case y => y
    """)

def test_typing_A2():
    code = ctx(["choose", "id"], f"""
choose(id)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A3():
    code = ctx(["choose", "nil", "ids"], f"""
choose(nil)(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A4():
    assert infer_typ("case x => x(x)")

def test_typing_A5():
    code = ctx(["id", "auto"], f"""
id(auto)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A6():
    code = ctx(["id", "auto_prime"], f"""
id(auto_prime)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A7():
    code = ctx(["choose", "id", "auto"], f"""
choose(id)(auto)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A8():
    code = ctx(["choose", "id", "auto_prime"], f"""
choose(id)(auto_prime)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A9():
    code = ctx(["foo", "choose", "id", "ids"], f"""
foo(choose(id))(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A10():
    code = ctx(["poly", "id"], f"""
poly(id)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A11():
    code = ctx(["poly"], f"""
poly(case x => x)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_A12():
    code = ctx(["id", "poly"], f"""
id(poly)(case x => x)
    """)
    print(code)
    assert infer_typ(code)

###############################################################
##### Typing B. Inference with polymorphic arguments
###############################################################
def test_typing_B1():
    assert infer_typ(f"""
case f => (f(<succ> <zero> @)), (f(<true> @))
    """)

def test_typing_B2():
    code = ctx(["poly", "head"], f"""
case xs => poly(head)(xs)
    """)
    print(code)
    assert infer_typ(code)


###############################################################
##### Subtyping 
###############################################################

if __name__ == '__main__':
    pass
    # SCRATCH WORK
    test_typing_B2()

#######################################################################
