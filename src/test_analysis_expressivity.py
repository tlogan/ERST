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

def test_inf_loop():
    code = f"""
loop([self => 
    [x => self(x)]
])
    """
    assert infer_typ(code) 


def test_succ_stream():
    ######################
    # expected: GFP[F] T -> ALL(F <: <succ> T -> Z) : @ -> <pair> (T * Z)    
    ######################
    # expected: GFP[F] ALL(F <: <succ> T -> Z) : T -> @ -> <pair> (T * Z)    
    ######################
    # ...
    ######################
    # expected: T ->  LFP[R] @ -> <pair> ((LFP[W] EXI[U](<succ> U <: W): U) * R)    
    # TODO: what is the rationale for why it's save to flip around the constraint into an LFP?
    # does (LFP[W] EXI[](<succ> T <: W): T) <: (LFP[W] T | <succ> W) ?
    # does (LFP[W] T | <succ> W) <: (LFP[W] EXI[](<succ> T <: W): T) ?
    ######
    # does (T | <succ> (LFP[W] EXI[](<succ> T <: W): T)) <: (LFP[W] EXI[](<succ> T <: W): T) ?
    ######################
    # expected: T ->  LFP[R] @ -> <pair> ((LFP[W] T | <succ> W) * R)    
    ######################
    # expected: T -> @ -> LFP[R] <pair> ((LFP[W] T | <succ> W) * @ -> R)    
    ######################
    # consider if relational type should be retained for single case streams 
    # Note how the label is added to the input variable, rather than removed   
    code = f"""
loop([self => [seed => 
    [@ =>
        (seed, self(succ;seed))
    ]
]])
    """
    assert infer_typ(code) 

def test_single_case_loop():
    code = f"""
loop([ self => 
    [ cons;(x,xs) => succ;(self(xs)) ]
]) 
    """
    assert infer_typ(code) 


def test_free_var_annotation():
    code = f"""
def x : X = uno;@ in
[dos;@ => @](x)
    """
    assert not infer_typ(code) 

def test_lted():
    assert infer_typ(el.lted) 

def test_max():
    assert infer_typ(el.max) 

def test_subtyping_unrolling():
    assert solve_subtyping(f"""
<true> @
    """, f"""
(LFP[R] ((EXI[] <true> @) | ((EXI[X] (X <: R)  : X) | ((EXI[] <false> @) | BOT))))
    """
    )

def test_max_app():
    code = f"""
def max = {el.max} in
max(zero;@,zero;@)
    """
    assert infer_typ(code) 


def test_intersection_arrow_subtypes_lfp_arrow():
    assert solve_subtyping(f"""
(<true> @ -> @) & (<false> @ -> @)
    """, """
(LFP [R] (<true> @) | ( <false> @) | (R)) -> @
    """
    )

def test_intersection_arrow_single_selection():
    worlds = solve_subtyping(f"""
(<true> X -> @) & (<false> X -> @)
    """, """
(<true> @) -> @
    """
    )
    assert worlds

    for i, world in enumerate(worlds):
        print(f"""
=========================
world {i}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constraints:
{analyzer.concretize_constraints(world.constraints)}
=========================
        """)



def test_length():
    length = (f"""
    loop([ self => 
        [ nil;@ => zero;@  ]
        [ cons;(x,xs) => succ;(self(xs)) ]
    ]) 
    """.strip())
    assert infer_typ(length)
    # assert infer_typ(el.length)

def test_length_eta_expansion():
    length = (f"""
    loop([ self => 
        [ nil;@ => zero;@  ]
        [ cons;(x,xs) => succ;(self(xs)) ]
    ]) 
    """.strip())
    code = f"""
def length = {length} in
[ x => length(x) ]
    """
    assert infer_typ(code)
    # assert infer_typ(el.length)

def test_recursive_pair():
    assert infer_typ(f"""
loop([ self => 
    [ nil;@ => nil;@ , zero;@  ]
    [ cons;(x,xs) => cons;(x,xs) , succ;(self(xs)) ]
]) 
    """)

def test_induction_even_is_nat():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """, f"""
LFP [R] (<zero> @) | (<succ> R)
    """
    )
    assert bool(worlds)

def test_induction_even_is_nat_not_three():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """, f"""
(LFP [R] (<zero> @) | (<succ> R)) \\ (<succ> <succ> <succ> <zero> @)
    """
    )
    assert bool(worlds)

def test_two_not_three():
    worlds = solve_subtyping(f"""
(<succ> <succ> <zero> @)
    """, f"""
TOP \\ (<succ> <succ> <succ> <zero> @)
    """
    )
    assert bool(worlds)


def test_induction_even_is_not_one():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """, f"""
TOP \\ (<succ> <zero> @)
    """
    )
    assert bool(worlds)

def test_induction_even_is_not_three():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """, f"""
TOP \\ (<succ> <succ> <succ> <zero> @)
    """
    )
    assert bool(worlds)

def test_variable_subtypes_tag_pair():
    worlds = solve_subtyping(f"""
X
    """, f"""
<cons> (Y * Z) 
    """
    )
    assert len(worlds) == 1
    assert len(worlds[0].constraints) == 1

def test_weaker_than_lfp():
    worlds = solve_subtyping(f"""
EXI [X] (<succ> X) | (<zero> @) | X
    """, f"""
LFP [R] (<succ> R) | (<zero> @)
    """
    )
    assert not bool(worlds)

def test_recursive_relational_factorization_learning_in_subtyping():
    worlds = solve_subtyping(f"""
(LFP[R]
    (<nil> @ * <zero> @) | 
    (EXI[XS N] (XS * N <: R)  : (<cons> XS * <succ> N))
)
    """, f"""
 <head> X 
    """
    )
    for i, world in enumerate(worlds):
        print(f"""
=========================
world {i}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constraints:
{analyzer.concretize_constraints(world.constraints)}
=========================
        """)

def test_recursive_relational_factorization_learning_in_typing():
    assert infer_typ(f"""
def f = loop([ self => 
    [ nil;@ => nil;@ , zero;@  ]
    [ cons;(x,xs) => cons;(x,xs) , succ;(self(xs)) ]
]) in
def extract = [ a, b => b ] in
[ x => extract(f(x)) ]
    """)

def test_recursive_relational_factorization_checking():
    worlds = solve_subtyping(f"""
LFP [R]
(<nil> @ * <zero> @) |
(EXI[A B] (A * B <: R) : (<cons> A * <succ> B))
    """, f"""
(LFP[R] <nil> @ | <cons> R)
*
(LFP[R] <zero> @ | <succ> R)
    """
    )
    assert worlds
#     for i, world in enumerate(worlds):
#         print(f"""
# =========================
# world {i}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# constraints:
# {analyzer.concretize_constraints(world.constraints)}
# =========================
#         """)

def test_entry_rewriting():
    worlds = solve_subtyping(f"""
(<cons> (<head> <uno>@)) & (<cons> <tail> <dos>@)) 
    """, f"""
<cons> ((<uno>@) * (<dos>@)) 
    """
    )
    assert worlds

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
[ x => [ y => y ] ]
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
    assert infer_typ("[x => x(x)]")

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

######### DEBUG 
def test_subtyping_debug():

#     lower = (f"""
# (ALL[G004] ((ALL[A] (A -> A)) <: G004)  : ((LFP[R] (<nil> @ | <cons> (G004 * R))) -> G004))
#     """)

#     upper = (f"""
# (LFP[R] (<nil> @ | <cons> ((ALL[A] (A -> A)) * R))) -> Z
#     """)

    lower = (f"""
(ALL[A] (A <: @ -> @): (A -> (A -> A)))
    """)
# TODO: how can I argue that it's safe to strengthen the upper bound of A when instantiating with a lower bound?

    upper = (f"""
(ALL[A] (A -> A)) -> Z
    """)

    worlds = solve_subtyping(lower, upper)
    for i, world in enumerate(worlds):
        print(f"""
=========================
world {i}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constraints:
{analyzer.concretize_constraints(world.constraints)}
=========================
        """)

def test_typing_A9():
    code = f"""
foo(choose(id))(ids)
    """

    code = f"""
choose(id)
    """
    assert infer_typ(code, ctx(["foo", "choose", "ids", "id"]))

def test_typing_A10():
    code = f"""
poly(id)
    """
    print(code)
    assert infer_typ(code, ctx(["poly", "id"]))

def test_typing_A11():
    code = f"""
poly([ x => x ])
    """
    print(code)
    assert infer_typ(code, ctx(["poly"]))

def test_typing_A12():
    code = f"""
id(poly)([ x => x ])
    """
    print(code)
    assert infer_typ(code, ctx(["id", "poly"]))

###############################################################
##### Typing B. Inference with polymorphic arguments
###############################################################
def test_typing_B1():
    assert infer_typ(f"""
[ f => (f(<succ> <zero> @)), (f(<true> @)) ]
    """)

def test_typing_B2():
    code = f"""
[ xs => poly((head)(xs)) ]
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
cons([ x => x ])(ids)
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
k([ x => h(x) ])(l)
    """
    print(code)
    assert infer_typ(code, ctx(["k", "h", "l"]))

def test_typing_E3():
    code = f"""
r([ x => [ y => y ] ])
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
def f = revapp(id) in
f(poly)
    """
    print(code)
    assert infer_typ(code, ctx(["revapp", "id", "poly"]))

def test_typing_F10():
    code = f"""
choose(id)([ x => auto_prime(x) ])
    """
    print(code)
    assert infer_typ(code, ctx(["choose", "id", "auto_prime"]))

###############################################################
##### Typing G. SuperF paper additions 
###############################################################
def test_typing_G1A():
    code = (f"""
def z : {tl.Church} = ({el.church_zero}) in
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
def s : {tl.Church} -> {tl.Church} = {el.church_succ} in
s
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G3A():
    code = (f"""
def n3 : {tl.Church} = {el.church_three} in
n3
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G4A():
    code = (f"""
def c : @ -> {tl.Church} = ([ @ => {el.church_three}({el.church_three}) ]) in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G5():
    code = f"""
fst(fst(fst({el.church_three}([ x => x ],(<zero>@))(<succ><zero>@))))
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
def c : {tl.Nat} -> {tl.Church} = {el.to_church} in
c
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G9():
    #TODO: fail
    code = (f"""
loop([ self =>
    [ x =>
        if <true> @ then
            x
        else 
            self(self)(x)
    ]
])
    """)
    print(code)
    assert infer_typ(code)

def test_typing_G10():
    code = (f"""
([ x => x ])([ x => x ])
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
([ y =>
    (def tmp = y(id) in y(const))([ x => x ])
])
    """
    print(code)
    assert infer_typ(code, ctx(["const"]))

def test_typing_G13():
    code = f"""
([ k => 
    ((k)([ x => x ]), (k)([ x => single(x) ]))
]) ([ f => ((f)(<succ><zero>@)), (f)(<true>@) ])
    """
    print(code)
    assert infer_typ(code, ctx(["single"]))

def test_typing_G14():
    code = f"""
([ f =>
    def a : @ -> {tl.Nat} -> (ALL[B] B -> B) = ([ @ => f(id) ]) in
    (a(@))(const(const(id)))
])
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
def foo = [f =>
    (f(zero;@)), f(true;@)  
] in 
[ x => foo([y => x(y,y) ]) ]
    """)
    print(code)
    assert infer_typ(code)


def test_typing_sanity_branch_error():
    code = (f"""
(
[zero;@ => [zero;@ => @](@)]
[one;@ => one;@]
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_trivial_application():
    # TODO: why is the result just a variable?
    # need to interpret and/or pack before printing
    code = (f"""
(
([one;@ => @])(one;@)
)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_binding_annotation_1():
    code = (f"""
def x : <two> @ = y 
in @
    """)
    print(code)
    assert not infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_2():
    code = (f"""
def f = (
    [ one;@ => uno;@ ]
    [ two;@ => dos;@ ]
) in
def x : <dos> @  = f(y) 
in @
    """)
    print(code)
    assert not infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_3():
    code = (f"""
def f = (
    [ one;@ => uno;@ ]
    [ two;@ => dos;@ ]
) in
f(y) 
    """)
    print(code)
    assert infer_typ(code, {"y" : "(<one> @) | (<two> @)"})

def test_typing_sanity_binding_annotation_4():
    # this is admitted by strengthening the type of y
    code = (f"""
[ y =>
def f = (
    [ one;@ => uno;@ ]
    [ two;@ => dos;@ ]
) in
def x : <uno> @ = f(y) in
x
]
    """)
    print(code)
    assert infer_typ(code)

def test_typing_sanity_application_5():
    # this is admitted by strengthening the type of y
    code = (f"""
[ y =>
def f = (
    [ one;@ => uno;@ ]
    [ two;@ => dos;@ ]
) in
([ uno;@ => @ ])(f(y))
]
    """)
    print(code)
    result = infer_typ(code)
    assert result and result != "TOP"

def test_typing_sanity_application_6():
    # This is admitted with a useless type
    code = (f"""
[ y =>
def f = (
    [ one;@ => uno;@ ]
    [ two;@ => dos;@ ]
) in
([ tres;@ => @ ])(f(y))
]
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
def f = [ ((one;@), (two;@)) => three;@ ] in
def g = [ ((uno;@), (dos;@)) => tres;@ ] in
def h = [(a,b) => 
    (
    [one;@ => f(a,b)]
    [uno;@ => g(a,b)]
    ) (a)
] in
h
    """
    print(code)
    assert infer_typ(code, ctx(["hof"]))

def test_typing_structures_sanity_path():
    code = f"""
def h = (
    [one;@ => three;@]
    [uno;@ => tres;@]
)
in
def result : (
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
def h = ([self =>
    [zero;@ => nil;@]
    [succ;n => cons;n]
]
) in
h
[x => x ](h)
    """
    print(code)
    assert infer_typ(code, ctx(["mkpath"]))



def test_typing_structures_2():
    code = f"""
def stdCmp = {el.stdCmp} in
def stdSort : (
    ({tl.List_(tl.Nat)} -> {tl.List_(tl.Nat)}) &
    ({tl.List_(tl.List_(tl.Nat))} -> {tl.List_(tl.List_(tl.Nat))})
) = sort(stdCmp) in stdSort 
    """

#     code = f"""
# def stdCmp = {el.stdCmp} in
# def stdSort = sort(stdCmp) in @
#     """
    print(code)
    assert infer_typ(code, ctx(["scalarCmp", "lexicoCmp", "sort"]))


def test_typing_structures_3():
    code = (f"""
def double : (
   {tl.Nat} -> {tl.Even} 
) = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;n) => succ;succ;((self)(n)) ]
)]) in double)
    """)
    print(code)
    assert infer_typ(code)

def test_typing_structures_4():
    code = (f"""
def halve : (
    {tl.Even} -> {tl.Nat} 
) = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;succ;n) => succ;((self)(n)) ]
)]) in halve
    """)
    print(code)
    assert infer_typ(code)

def test_typing_structures_5():
    code = (f"""
def double = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;n) => succ;succ;((self)(n)) ]
)]) in 
def halve = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;succ;n) => succ;((self)(n)) ]
)]) in 
[x => halve(double(x))]
    """)
    print(code)
    assert infer_typ(code)

def test_typing_halve_halve_false():
    code = (f"""
def double = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;n) => succ;succ;((self)(n)) ]
)]) in 
def halve = loop([self => (
    [ (zero;@) => zero;@ ]
    [ (succ;succ;n) => succ;((self)(n)) ]
)]) in 
[x => halve(halve(x))]
    """)
    print(code)
    assert not infer_typ(code)

def test_typing_structures_6():
    code = (f"""
(
[zero;@ => [zero;@ => @](@)]
[nil;@ => nil;@]
)
    """)
    print(code)
    assert infer_typ(code)


def test_subtyping_increasing_recursion():
    # INCOMPLETENESS
    # the subtyping never halts with a contradiction, so should be accepted
    # since this is actually rejected, but should be accepted,
    # this form must NOT be allowed in negations of subtyping.
    worlds = solve_subtyping(f"""
@ 
    """, f"""
LFP [R] EXI [T] (<succ> T <: R) : T 
    """
    )
    assert bool(worlds)

def test_subtyping_decreasing_recursion():
    worlds = solve_subtyping(f"""
<succ> <nil> @ 
    """, f"""
LFP [R] <nil> @ | <succ> R 
    """
    )
    assert bool(worlds)

###############################################################
###############################################################

if __name__ == '__main__':
    pass
    ##########################
    # test_max()
    # test_max_app()
    # test_succ_stream()
    # test_single_case_loop()
    # test_typing_G8A()
    # test_something_subtypes_non_decreasing_lfp()
    # test_something_subtypes_increasing_lfp()
    # test_two_not_three()
    # test_succ_stream()
    # test_inf_loop()
    test_succ_stream()


#######################################################################
