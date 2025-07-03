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
    assert infer_typ(el.max) 



def test_length():
    #TODO: why is cons distributed across the pair?
    assert infer_typ(el.length)

def test_lengthy():
    # TODO: is this type due to lack of consolidation?  
    assert infer_typ(el.lengthy)


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
EXI[N L] ((N * L) <: @) : (<succ> N) * (<cons> L)  
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
ALL[N L] ((N * L) <: @) : (<succ> N) -> (<cons> L)  
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
{{ x => {{ y => y }} }}
    """)

def test_typing_A2():
    code =f"""
choose(id)
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "id"]))

def test_typing_A3():
    code = f"""
choose(nil)(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "nil", "ids"]))

def test_typing_A4():
    assert infer_typ("{ x => x(x) }")

def test_typing_A5():
    code = f"""
id(auto)
    """
    print(code)
    assert infer_typ(code, ctx(["id", "auto"]))

def test_typing_A6():
    code = f"""
id(auto_prime)
    """
    print(code)
    assert infer_typ(code, ctx(["id", "auto_prime"]))

def test_typing_A7():
    code = f"""
choose(id)(auto)
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "id", "auto"]))

def test_typing_A8():
    code = f"""
choose(id)(auto_prime)
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "id", "auto_prime"]))

def test_typing_A9():
    code = f"""
foo(choose(id))(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["foo", "choose", "ids", "id"]))

def test_typing_A10():
    code = f"""
poly(id)
    """
    print(code)
    assert infer_typ(code, ctx(["poly", "id"]))

def test_typing_A11():
    code = f"""
poly({{ x => x }})
    """
    print(code)
    assert infer_typ(code, ctx(["poly"]))

def test_typing_A12():
    code = f"""
id(poly)({{ x => x }})
    """
    print(code)
    assert infer_typ(code, ctx(["id", "poly"]))

###############################################################
##### Typing B. Inference with polymorphic arguments
###############################################################
def test_typing_B1():
    assert infer_typ(f"""
{{ f => (f(<succ> <zero> @)), (f(<true> @)) }}
    """)

def test_typing_B2():
    code = f"""
{{ xs => poly((head)(xs)) }}
    """
    print(code)
    assert infer_typ(code, ctx(["poly", "head"]))

###############################################################
##### Typing C. Function on polymorphic lists 
###############################################################

def test_typing_C1():
    code = f"""
length(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["length", "ids"]))

def test_typing_C2():
    code =f"""
tail(ids)
    """
    print(code)
    assert infer_typ(code,  ctx(["tail", "ids"]))

def test_typing_C3():
    code = f"""
head(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["head", "ids"]))

def test_typing_C4():
    code = f"""
single(id)
    """
    print(code)
    assert infer_typ(code, ctx(["single", "id"]))

def test_typing_C5():
    code = f"""
cons(id)(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["cons", "id", "ids"]))

def test_typing_C6():
    code = f"""
cons({{ x => x }})(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["cons", "ids"]))

def test_typing_C7():
    code = f"""
append(single(inc))(single(id))
    """
    print(code)
    assert infer_typ(code, ctx(["append", "single", "inc", "id"]))

def test_typing_C8():
    code = f"""
g(single(id))(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["g", "single", "id", "ids"]))

def test_typing_C9():
    code = f"""
map(poly)(single(id))
    """
    print(code)
    assert infer_typ(code, ctx(["map", "poly", "single", "id"]))

def test_typing_C10():
    code = f"""
map(head)(single(ids))
    """
#     code = f"""
# single(ids)
#     """

# #     code = f"""
# # map(head)(cons;(ids,(nil;@))) 
# #     """

#     code = f"""
# map(head)(cons;(ids,(nil;@))) 
#     """
    print(code)
    assert infer_typ(code, ctx(["map", "head", "single", "ids"]))

###############################################################
##### Typing D. Application functions 
###############################################################

def test_typing_D1():
    code = f"""
app(poly)(id)
    """
    print(code)
    assert infer_typ(code, ctx(["app", "poly", "id"]))

def test_typing_D2():
    code = f"""
revapp(id)(poly)
    """
    print(code)
    assert infer_typ(code, ctx(["revapp", "poly", "id"]))

def test_typing_D3():
    code = f"""
runState(argState)
    """
    print(code)
    assert infer_typ(code, ctx(["runState", "argState"]))

def test_typing_D4():
    code = f"""
app(runState)(argState)
    """
    print(code)
    assert infer_typ(code, ctx(["app", "runState", "argState"]))

def test_typing_D5():
    code = f"""
revapp(argState)(runState)
    """
    print(code)
    assert infer_typ(code, ctx(["revapp", "runState", "argState"]))

###############################################################
##### Typing E. Eta expansion 
###############################################################

def test_typing_E1():
    code = f"""
k(h)(l)
    """
    print(code)
    assert infer_typ(code, ctx(["k", "h", "l"]))

def test_typing_E2():
    code = f"""
k({{ x => h(x) }})(l)
    """
    print(code)
    assert infer_typ(code, ctx(["k", "h", "l"]))

def test_typing_E3():
    code = f"""
r({{ x => {{ y => y }} }})
    """
    print(code)
    assert infer_typ(code, ctx(["r"]))

###############################################################
##### Typing F. FreezeML paper additions 
###############################################################
def test_typing_F5():
    code = f"""
auto(id)
    """
    print(code)
    assert infer_typ(code, ctx(["auto", "id"]))

def test_typing_F6():
    code = f"""
cons (head(ids))(ids)
    """
    print(code)
    assert infer_typ(code, ctx(["cons", "head", "ids", "id"]))

def test_typing_F7():
    code = f"""
head(ids)(succ;succ;succ;zero;@)
    """
#     code = f"""
# head(ids)
#     """
    print(code)
    assert infer_typ(code, ctx(["head", "ids"]))

def test_typing_F8():
    code =f"""
choose(head(ids))
    """
    print(code)
    assert infer_typ(code,  ctx(["choose", "head", "ids"]))

def test_typing_F9():
    code = f"""
let f = revapp(id) in
f(poly)
    """
    print(code)
    assert infer_typ(code, ctx(["revapp", "id", "poly"]))

def test_typing_F10():
    code = f"""
choose(id)({{ x => auto_prime(x) }})
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "id", "auto_prime"]))

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
    code = (f"""
let n3 : {tl.Church} = {el.church_three} in
n3
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G4A():
    code = (f"""
let c : @ -> {tl.Church} = ({{ @ => {el.church_three}({el.church_three}) }}) in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G5():
    code = f"""
fst(fst(fst({el.church_three}({{ x => x }},(<zero>@))(<succ><zero>@))))
    """
    print(code)
    assert infer_typ(code, ctx(["fst"]))

def test_typing_G6():
    code = f"""
(succ(succ(zero)))(succ(succ(zero)))
    """
    print(code)
    assert infer_typ(code, ctx(["succ", "zero"]))

def test_typing_G7():
    code = (f"""
({el.church_two})({el.church_two})
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G8():
    code = (f"""
{el.to_church}
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G8A():
    code = (f"""
let c : {tl.Nat} -> {tl.Church} = {el.to_church} in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G9():
    #TODO: fail
    code = (f"""
loop({{ self =>
    {{ x =>
        if <true> @ then
            x
        else 
            self(self)(x)
    }}
}})
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G10():
    code = (f"""
({{ x => x }})({{ x => x }})
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G11():
    code = f"""
auto(auto_prime(id))
    """
    print(code)
    assert infer_typ(code, ctx(["auto", "auto_prime", "id"]))

def test_typing_G12():
    code = f"""
({{ y =>
    (let tmp = y(id) in y(const))({{ x => x }})
}})
    """
    print(code)
    assert infer_typ(code, ctx(["const"]))

def test_typing_G13():
    code = f"""
({{ k => 
    ((k)({{ x => x }}), (k)({{ x => single(x) }}))
}}) ({{ f => ((f)(<succ><zero>@)), (f)(<true>@) }})
    """
    print(code)
    assert infer_typ(code, ctx(["single"]))

def test_typing_G14():
    code = f"""
({{ f =>
    let a : @ -> {tl.Nat} -> (ALL[B] B -> B) = ({{ @ => f(id) }}) in
    (a(@))(const(const(id)))
}})
    """
    print(code)
    assert infer_typ(code, ctx(["const", "id"]))


###############################################################
##### Typing Sanity 
###############################################################

def test_typing_sanity_1():
    code = (f"""
succ;succ;succ;succ;succ;succ;zero;@
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_inter_nesting_constraint():
    # NOTE: extrusion isn't necessary
    # because we keep inner variables locally bound 
    # instead of lifting them to the outer binding
    # basically, we maintain the same abstraction hierarchy
    # of the expression
    code = (f"""
let foo = {{f =>
    (f(zero;@)), f(true;@)  
}} in 
{{ x => foo({{y => x(y,y) }}) }}
    """)
    print(code)
    assert infer_typ(code)


def test_typing_sanity_branch_error():
    code = (f"""
(
{{zero;@ => {{zero;@ => @}}(@)}}
{{one;@ => one;@}}
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_trivial_application():
    # TODO: why is the result just a variable?
    # need to interpret and/or pack before printing
    code = (f"""
(
({{one;@ => @}})(one;@)
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_binding_annotation_1():
    code = (f"""
let x : <two> @ = y 
in @
    """)
    print(code)
    assert not infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_2():
    code = (f"""
let f = (
    {{ one;@ => uno;@ }}
    {{ two;@ => dos;@ }}
) in
let x : <dos> @  = f(y) 
in @
    """)
    print(code)
    assert not infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_3():
    code = (f"""
let f = (
    {{ one;@ => uno;@ }}
    {{ two;@ => dos;@ }}
) in
f(y) 
    """)
    print(code)
    assert infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_4():
    # this is admitted by strengthening the type of y
    code = (f"""
{{ y =>
let f = (
    {{ one;@ => uno;@ }}
    {{ two;@ => dos;@ }}
) in
let x : <uno> @ = f(y) in
x
}}
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_application_5():
    # this is admitted by strengthening the type of y
    code = (f"""
{{ y =>
let f = (
    {{ one;@ => uno;@ }}
    {{ two;@ => dos;@ }}
) in
({{ uno;@ => @ }})(f(y))
}}
    """)
    print(code)
    result = infer_typ(code)
    assert result and result != "TOP"

def test_typing_sanity_application_6():
    # This is admitted with a useless type
    code = (f"""
{{ y =>
let f = (
    {{ one;@ => uno;@ }}
    {{ two;@ => dos;@ }}
) in
({{ tres;@ => @ }})(f(y))
}}
    """)
    print(code)
    assert not infer_typ(code)


###############################################################
##### Subtyping Sanity 
###############################################################

# def test_subtyping_sanity_debug():

#     lower = (f"""
#     """)

#     upper = (f"""
#     """)

#     assert solve_subtyping(lower, upper)

###############################################################
##### Structural Typing 
###############################################################


def test_typing_structures_1():
    #TODO: find way to speed up; parsing might be slow
    code = f"""
{el.stdCmp}
    """
    print(code)
    assert infer_typ(code, ctx(["scalarCmp", "lexicoCmp"]))



def test_typing_structures_sanity():
    #TODO: find way to speed up; parsing might be slow
    code = f"""
let f = {{ ((one;@), (two;@)) => three;@ }} in
let g = {{ ((uno;@), (dos;@)) => tres;@ }} in
let h = {{(a,b) => 
    (
    {{one;@ => f(a,b)}}
    {{uno;@ => g(a,b)}}
    ) (a)
}} in
h
    """
    print(code)
    assert infer_typ(code, ctx(["hof"]))

def test_typing_structures_sanity_path():
    code = f"""
let h = (
    {{one;@ => three;@}}
    {{uno;@ => tres;@}}
)
in
let result : (
    ((<uno> @) -> (<tres> @)) &
    ((<one> @) -> (<three> @))
) = mkpath(h) in
result
    """
    print(code)
    assert infer_typ(code, ctx(["mkpath"]))

def test_identity_application():
    # TODO: why is there so much extra clutter?
    code = f"""
let h = ({{self =>
    {{zero;@ => nil;@}}
    {{succ;n => cons;n}}
}}
) in
h
{{x => x }}(h)
    """
    print(code)
    assert infer_typ(code, ctx(["mkpath"]))



def test_typing_structures_2():
    code = f"""
let stdCmp = {el.stdCmp} in
let stdSort : (
    ({tl.List_(tl.Nat)} -> {tl.List_(tl.Nat)}) &
    ({tl.List_(tl.List_(tl.Nat))} -> {tl.List_(tl.List_(tl.Nat))})
) = sort(stdCmp) in stdSort 
    """

#     code = f"""
# let stdCmp = {el.stdCmp} in
# let stdSort = sort(stdCmp) in @
#     """
    print(code)
    assert infer_typ(code, ctx(["scalarCmp", "lexicoCmp", "sort"]))


def test_typing_structures_3():
    code = (f"""
let double : (
   {tl.Nat} -> {tl.Even} 
) = loop({{self => (
    {{ (zero;@) => zero;@ }}
    {{ (succ;n) => succ;succ;((self)(n)) }}
)}}) in double)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_structures_4():
    code = (f"""
let halve : (
    {tl.Even} -> {tl.Nat} 
) = loop({{self => (
    {{ (zero;@) => zero;@ }}
    {{ (succ;succ;n) => succ;((self)(n)) }}
)}}) in halve)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_structures_5():
    code = (f"""
(
{{zero;@ => {{zero;@ => @}}(@)}}
{{nil;@ => nil;@}}
)
    """)
    print(code)
    assert infer_typ(code)

###############################################################
###############################################################

if __name__ == '__main__':
    pass
    ##########################
    # test_typing_A9()
    # test_typing_structures_sanity() #assertion error
    # test_typing_structures_sanity_path()
    # test_typing_structures_1() #assertion error
    # test_typing_structures_2() #assertion error
    # test_max()
    # test_length()
    # test_lengthy()
    # test_max()
    test_identity_application()


#######################################################################
