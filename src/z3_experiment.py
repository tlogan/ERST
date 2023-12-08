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

######################################################

# Expr = Datatype('Expr')
# Expr.declare('Max')
# Expr.declare('f')
# Expr.declare('I', ('i', IntSort()))
# Expr.declare('App', ('fn',Expr),('arg',Expr))
# Expr = Expr.create()
# Max  = Expr.Max
# I    = Expr.I
# App  = Expr.App
# f    = Expr.f
# Eval = Function('Eval',Expr,Expr,Expr,BoolSort())

# x   = Const('x',Expr)
# y   = Const('y',Expr)
# z   = Const('z',Expr)
# r1  = Const('r1',Expr)
# r2  = Const('r2',Expr)
# max = Const('max',Expr)
# xi  = Const('xi',IntSort())
# yi  = Const('yi',IntSort())

# fp = Fixedpoint()
# fp.register_relation(Eval)
# fp.declare_var(x,y,z,r1,r2,max,xi,yi)

# # Max max x y z = max (max x y) z
# fp.rule(Eval(App(App(App(Max,max),x),y), z, r2),
# 	[Eval(App(max,x),y,r1),
# 	 Eval(App(max,r1),z,r2)])

# # f x y = x if x >= y
# # f x y = y if x < y
# fp.rule(Eval(App(f,I(xi)),I(yi),I(xi)),xi >= yi)
# fp.rule(Eval(App(f,I(xi)),I(yi),I(yi)),xi < yi)

# print(fp.query(And(Eval(App(App(App(Max,f),x),y),z,r1), Eval(App(f,x),r1,r2), r1 != r2)))

# print (fp.get_answer())
# print (fp.get_ground_sat_answer())

######################################################

'''
least self with
    :zero @ |
    :succ self |
bot

<:

least self with
    :zero @ |
    :succ :succ self |
bot

Typ ::=
| Nat 
| Even
| Tag (str * Typ)
| Unit



Subtype(Zero(Unit), Nat)
Subtype(Succ(n), Nat) :- Subtype(n, Nat)



'''

Typ = Datatype('Typ')
Typ.declare('Nat')
Typ.declare('Even')
Typ.declare('Zero', ('body', Typ))
Typ.declare('Succ', ('body', Typ))
Typ.declare('Unit')

Typ = Typ.create()

Nat = Typ.Nat
Even = Typ.Even
Zero = Typ.Zero
Succ = Typ.Succ
Unit = Typ.Unit

n = Const('n', Typ)
m = Const('m', Typ)
l = Const('l', Typ)

Subtyping = Function('Subtyping', Typ, Typ, BoolSort())

# set_option(dl_engine=1)
# set_option(dl_pdr_use_farkas=True)
fp = Fixedpoint()
# fp.set(engine='datalog')
fp.register_relation(Subtyping)
fp.declare_var(n, m, l)

'''
Nat 
'''
fp.rule(
    Subtyping(Zero(Unit), Nat), [
    ]
)
fp.rule(
    Subtyping(Succ(n), Nat), [
        Subtyping(n, Nat)
    ]
)

'''
Even 
'''
fp.rule(
    Subtyping(Zero(Unit), Even)
)
fp.rule(
    Subtyping(Succ(Succ(n)), Even), [
        Subtyping(n, Even)
    ]
)

'''
Refl
'''
fp.rule(
    Subtyping(n, n)
)

'''
Implies
'''
fp.rule(
    Subtyping(n, m), [
        Implies(Subtyping(l, n), Subtyping(l, m))
    ]
)

print('------------------')

print('Query: Zero(n) <: Nat')
print(fp.query(
    Subtyping((Zero(n), Nat))
))
print('')
print('Answer:')
print(fp.get_answer().arg(0).arg(2).arg(0))
print('')

print('------------------')

print('Query: Nat <: Nat')
print(fp.query(
    Subtyping(Nat, Nat)
))
print('')
print('Answer:')
print(fp.get_answer())
print('')

print('------------------')

print('Query: Nat <: Even')
print(fp.query(
    Subtyping(Nat, Even)
))
print('')
print('Answer:')
print(fp.get_answer())
print('')

print('------------------')

# print('Query:')
# print(fp.query(
#     Not(And(
#         Subtyping(n, Nat),
#         Not(Subtyping(n, Even))
#     ))
# ))
# print('')
# print('Answer:')
# print(fp.get_answer())
# print('')

# print('------------------')

#####################################3
# fp = Fixedpoint()

# a, b, c = Bools('a b c')

# fp.register_relation(a.decl(), b.decl(), c.decl())
# fp.rule(a,b)
# fp.rule(b,c)
# fp.fact(c)
# # fp.set(generate_explanations=True, engine='datalog')
# # fp.set(engine='datalog')
# print (fp.query(a))
# print (fp.get_answer())


'''
NOTE: 
Syntactic encoding: horn clause represents the subtyping semantics: M |= t1 <: t2 is defined by rules: t1 <: t2 :- body 
Semantic encoding option 1: horn clause represents the meaning of types: M |= T is defined by rules T(x) :- body(x)     
Semantic encoding option 2: horn clause represents the meaning of types: M |= t <: T is defined by rules t <: T :- body(t)   
'''

'''
The example encoding of program verification is sort of semantic: function Max is encoded as a horn-clause relation over application
Likewise, a type can be defined by a horn-clause over subtyping/typing with a placeholder variable   
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