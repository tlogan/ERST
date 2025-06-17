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
from tapas.slim.language import analyze, infer_typ, parse_typ, solve_subtyping

from tapas.slim import exprlib as el, typlib as tl
from tapas.slim.exprlib import ctx 

def test_max():
    assert infer_typ(el.max) != "" 


###############################################################
##### Subtyping 
###############################################################

def test_subtyping():
    solve_subtyping(f"""
ALL[A](LFP[Self] (<nil> @) | (<cons> (A * Self)))
    """, f"""
EXI[B](LFP[Self] (<nil> @) | (<cons> (B * Self)))
    """
    )

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
##### Typing C. Function on polymorphic lists 
###############################################################

def test_typing_C1():
    code = ctx(["length", "ids"], f"""
length(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C2():
    code = ctx(["tail", "ids"], f"""
tail(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C3():
    code = ctx(["head", "ids"], f"""
head(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C4():
    code = ctx(["single", "id"], f"""
single(id)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C5():
    code = ctx(["cons", "id", "ids"], f"""
cons(id)(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C6():
    code = ctx(["cons", "ids"], f"""
cons(case x => x)(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C7():
    code = ctx(["append", "single", "inc", "id"], f"""
append(single(inc))(single(id))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C8():
    code = ctx(["g", "single", "id", "ids"], f"""
g(single(id))(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C9():
    code = ctx(["map", "poly", "single", "id"], f"""
map(poly)(single(id))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_C10():
    code = ctx(["map", "head", "single", "ids"], f"""
map(head)(single(ids))
    """)
    print(code)
    assert infer_typ(code)

###############################################################
##### Typing D. Application functions 
###############################################################

def test_typing_D1():
    code = ctx(["app", "poly", "id"], f"""
app(poly)(id)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_D2():
    code = ctx(["revapp", "poly", "id"], f"""
revapp(id)(poly)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_D3():
    code = ctx(["runST", "argST"], f"""
runST(argST)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_D4():
    code = ctx(["app", "runST", "argST"], f"""
app(runST)(argST)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_D5():
    code = ctx(["revapp", "runST", "argST"], f"""
revapp(argST)(runST)
    """)
    print(code)
    assert infer_typ(code)

###############################################################
##### Typing E. Eta expansion 
###############################################################

def test_typing_E1():
    code = ctx(["k", "h", "l"], f"""
k(h)(l)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_E2():
    code = ctx(["k", "h", "l"], f"""
k(case x => h(x))(l)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_E3():
    code = ctx(["r"], f"""
r(case x => case y => y)
    """)
    print(code)
    assert infer_typ(code)

###############################################################
##### Typing F. FreezeML paper additions 
###############################################################
def test_typing_F5():
    code = ctx(["auto", "id"], f"""
auto(id)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_F6():
    code = ctx(["cons", "head", "ids", "id"], f"""
cons (head(ids))(ids)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_F7():
    code = ctx(["head", "ids"], f"""
head(ids)(succ;succ;succ;zero;@)
    """)
    print(code)
    #TODO: why is this so slow??? 
    assert infer_typ(code)

def test_typing_F8():
    code = ctx(["choose", "head", "ids"], f"""
choose(head(ids))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_F9():
    code = ctx(["revapp", "id", "poly"], f"""
let f = revapp(id) in
f(poly)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_F10():
    code = ctx(["choose", "id", "auto_prime"], f"""
choose(id)(case x => auto_prime(x))
    """)
    print(code)
    assert infer_typ(code)

###############################################################
##### Typing G. SuperF paper additions 
###############################################################
def test_typing_G1A():
    code = (f"""
let z : {tl.Church} = ({el.church_zero}) in
z
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G2():
    code = (f"""
{el.church_succ}
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G2A():
    code = (f"""
let s : {tl.Church} -> {tl.Church} = {el.church_succ} in
s
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G3A():
    #TODO: this is very slow
    code = (f"""
let n3 : {tl.Church} = {el.church_three} in
n3
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G4A():
    #TODO: this is very slow; 
    code = (f"""
let c : @ -> {tl.Church} = (case @ => {el.church_three}({el.church_three})) in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G5():
    #TODO: this is very slow; 
    code = ctx(["fst"], f"""
fst(fst(fst({el.church_three}(case x => x,(<zero>@))(<succ><zero>@))))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G6():
    code = ctx(["succ", "zero"], f"""
(succ(succ(zero)))(succ(succ(zero)))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G7():
    #TODO: very slow
    code = (f"""
({el.church_two})({el.church_two})
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G8():
    #TODO: a little bit slow
    code = (f"""
{el.to_church}
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G8A():
    #TODO: FAILS 
    code = (f"""
let c : {tl.Nat} -> {tl.Church} = {el.to_church} in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G9():
    #TODO: fail
    code = (f"""
fix(case loop =>
    case x =>
        if <true> @ then
            x
        else 
            loop(loop)(x)
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G10():
    code = (f"""
(case x => x)(case x => x)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G11():
    code = ctx(["auto", "auto_prime", "id"], f"""
auto(auto_prime(id))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G12():
    code = ctx(["const"], f"""
(case y =>
    (let tmp = y(id) in y(const))(case x => x)
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G13():
    code = ctx(["single"], f"""
(case k => 
    ((k)(case x => x), (k)(case x => single(x)))
) (case f => ((f)(<succ><zero>@)), (f)(<true>@))
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G14():
    #TODO: fail
    code = ctx(["const", "id"], f"""
(case f =>
    let a : @ -> {tl.Nat} -> (ALL[B] B -> B) = (case @ => f(id)) in
    (a(@))(const(const(id)))
)
    """)
    print(code)
    assert infer_typ(code)


###############################################################
##### Typing Sanity 
###############################################################

def test_typing_sanity_1():
    import time
    start = time.time()
#     code = (f"""
# (<succ> (<succ> (<succ> (<zero> @))))
#     """)

    code = (f"""
succ;succ;succ;succ;succ;succ;zero;@
    """)
    print(code)
    #TODO: why is this so slow??? 
    assert infer_typ(code)
    end = time.time()
    print(f"TIME: {end - start}")

def test_typing_sanity_2():
    import time
    start = time.time()

    code = ctx(["head", "ids"], f"""
<succ> <succ> <zero> @
    """)
    print(code)
    #TODO: why is this so slow??? 
    assert infer_typ(code)
    end = time.time()
    print(f"TIME: {end - start}")


###############################################################
##### Subtyping Sanity 
###############################################################

###############################################################
###############################################################

if __name__ == '__main__':
    pass
    # SCRATCH WORK
    test_typing_F7()

#######################################################################
