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

from pyrsistent import m, pmap, v

import pytest

from z3 import *

Expr = Datatype('Expr')
Expr.declare('Max')
Expr.declare('f')
Expr.declare('I', ('i', IntSort()))
Expr.declare('App', ('fn',Expr),('arg',Expr))
Expr = Expr.create()
Max  = Expr.Max
I    = Expr.I
App  = Expr.App
f    = Expr.f
Eval = Function('Eval',Expr,Expr,Expr,BoolSort())

x   = Const('x',Expr)
y   = Const('y',Expr)
z   = Const('z',Expr)
r1  = Const('r1',Expr)
r2  = Const('r2',Expr)
max = Const('max',Expr)
xi  = Const('xi',IntSort())
yi  = Const('yi',IntSort())

fp = Fixedpoint()
fp.register_relation(Eval)
fp.declare_var(x,y,z,r1,r2,max,xi,yi)

# Max max x y z = max (max x y) z
fp.rule(Eval(App(App(App(Max,max),x),y), z, r2),
	[Eval(App(max,x),y,r1),
	 Eval(App(max,r1),z,r2)])

# f x y = x if x >= y
# f x y = y if x < y
fp.rule(Eval(App(f,I(xi)),I(yi),I(xi)),xi >= yi)
fp.rule(Eval(App(f,I(xi)),I(yi),I(yi)),xi < yi)

print(fp.query(And(Eval(App(App(App(Max,f),x),y),z,r1), Eval(App(f,x),r1,r2), r1 != r2)))

print (fp.get_answer())
# print (fp.get_ground_sat_answer())

'''
NOTE: 
Syntactic encoding: horn clause represents the subtyping semantics: M |= T1 <: T2 is defined by rules: T1 <: T2 :- body 
    - type inference would then be encoded as the query: solve(T1 <: T2) is sat  
Semantic encoding: horn clause represents the meaning of types: M |= T is defined by rules T(x) :- body(x)     
    - a record type could be encoded as an uninterpreted function over their payload
    - e.g. maybe `P = {m1 : T1, m2 : T2}` could become `P(x) :- T1(m1(x)), T2(m2(x))`
    - the solution represents set of all possible inhabitants of type P.        
    - type verification (M |= T1 <: T2) would then be encoded as the query:  solve(T1(x) and not T2(x)) is unsat  
    - the semantic embedding does not offer a method for updating the meaning of types  
'''

'''
We can also verify some properties of functional programs using Z3's generalized PDR. 
Let us here consider an example from Predicate Abstraction and CEGAR for Higher-Order Model Checking, Kobayashi et.al. PLDI 2011. 

https://www-kb.is.s.u-tokyo.ac.jp/~koba/papers/pldi11.pdf

We encode functional programs by taking a suitable operational semantics and encoding an evaluator that is 
***specialized*** to the program being verified 
(we **don't encode a general purpose evaluator**, you should partial evaluate it to help verification). 
We use algebraic data-types to encode the current closure that is being evaluated.
'''


'''
TODO: construct a type language in z3, and define subtyping as a relation
'''