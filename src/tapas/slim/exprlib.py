from __future__ import annotations

from typing import *
from dataclasses import dataclass

ltd = ('''
fix(case self => (
    case (~zero @, ~succ x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (x, ~zero @) => ~false @ 
))
''')


lted = (f"""
fix(case self => (
    case (~zero @, n) => ~true @ 
    case (~succ m, ~succ n) => self(m,n) 
    case (~succ m, ~zero @) => ~false @ 
))
""".strip())



max = (f'''
let lted = {lted} in
case (x, y) => (
    if lted(x, y) then
        y
    else
        x
)
''')


simple = (f'''
case x => (
    (
    case ~true @ => ~true @
    case ~false @ => ~false @ 
    )(x)
)
''')

simple = (f'''
let id = case x => x in
let f =
    case ~true @ => ~true @
    case ~false @ => ~false @ 
in
case x => id(f(x))
''')


# uno -> X [A <: X] [B <: X]
# uno -> A | uno -> B if (X is foreign)    
# uno -> A & B if (X is local) X is always foreign for records
##########################
# uno -> A | B <: uno -> A | B | C
# uno -> A /\ uno -> B <: uno -> A <: uno -> A | B 
# uno -> A /\ uno -> B <: uno -> B <: uno -> A | B
#####################################
# uno -> A /\ uno -> B /\ dos -> TOP <: (uno -> A, dos -> TOP) | (uno -> B, dos -> TOP)
#####################################
# uno -> A | B .. uno -> A /\ uno -> B 
# uno -> X where [X <: A] or [X <: B]
# uno -> A or uno -> B
# uno -> X,  dos -> Y where X <: A | B, Y <: C | D
# uno -> X,  dos -> Y where [X <: A, Y <: C],..., [X <: B, Y <: D]
# (A + B) * (C + D) == (A * C) + .... + (B * D)
# uno -> A /\ uno -> B  /\ dos -> C /\ dos -> D <: (uno -> A /\ dos -> C) ... (uno -> B /\ dos -> D)


# (A + B) * (T) == (A * T) + (B * T)
# uno -> A | B, dos -> T == (uno -> A, dos -> T) + (uno -> B, dos -> T)
# uno -> A /\ uno -> B /\ dos -> T == (uno -> A, dos -> T) + (uno -> B, dos -> T)

# TODO: need to think carefully about how results are flattened
# the number of multiresults returned should equal the number of prompts inputted 

# x : X 
# y : Y 
# lted(x, y) : CLOSED Z 
# TRUE -> Y  where (X, Y, Z) <: R 
# FALSE -> X  where (X, Y, Z) <: R
#
# EXI Z . ALL X Y . if (X, Y, Z) <: R  then f : TRUE -> Y
# ALL X Y . arg : TRUE -> f(arg) : EXI Z . [(X, Y, Z) <: R] Y 
# ---skolemization---
# EXI Z . [(X, Y, Z) <: R] ALL Y' [Y' <: Y] TRUE -> Y'
# VS
# EXI Z [(X, Y, Z) <: R], TRUE ->  Y -- this is correct; no need for extrusion
#---------------------------------------------
# EXI Z . (X, Y, Z) <: R,  (ALL Y' . (Y' <: Y,  arg : TRUE) ->  f(arg) : Y')
# VS
# EXI Z . (X, Y, Z) <: R,  (arg : TRUE ->  f(arg) : Y) -- this is correct; no need for extrusion
#
# outer constraints: all variables are either foreign or closed 
# and there is at least one closed variable
#
# inner constraints: there is a variable that is open and local
# 

# IMPORTANT NOTE: closed variables can be influenced by open variables
# as new information on X and Y arrives, the constraint on Z is specialized.
# as opposed to Z being strict and preventing learning constraints on X and Y.



length = (f"""
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons (x, xs) => ~succ (self(xs)) 
)) 
""".strip())

add = (f"""
fix (case self => ( 
    case (~zero @, n) => n 
    case (~succ m, n) => ~succ (self(m, n))
))
""".strip())


mult = (f"""
let add = {add} in 
fix (case self => ( 
    case (~zero @, n) => ~zero 
    case (~succ m, n) => (add)(n, (self)(m, n))
))
""".strip())

concat_lists = (f"""
fix (case self => ( 
    case (~nil @, ys) => ys 
    case (~cons (x, xs), ys) => ~cons (x, (self)(xs, ys))
))
""".strip())

reverse = (f"""
let concat = ({concat_lists}) in
fix (case self => ( 
    case (~nil @) => ~nil @ 
    case (~cons (x, xs)) => 
        concat((self)(xs), ~cons(x, ~nil @))
))
""".strip())

tail_reverse = (f"""
let f = fix (case self => ( 
    case (result, ~nil @) => result 
    case (result, ~cons (x, xs)) => 
        self(~cons(x, result), xs)
)) in
case xs => f(~nil @, xs)
""".strip())

stepped_tail_reverse = (f"""
let f = fix (case self => case (result, l) => ( 
    l |> (
    case (~nil @) => result 
    case (~cons (x, xs)) => 
        self(~cons(x, result), xs)
    )
)) in
case xs => f(~nil @, xs)
""".strip())

curried_tail_reverse = (f"""
let f = fix (case self => case result => ( 
    case (~nil @) => result 
    case (~cons (x, xs)) => 
        self(~cons(x, result))(xs)
)) in
f(~nil @)
""".strip())


suml = (f"""
let add = {add} in
fix (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => self(xs, (add)(b, x))
))
""".strip())

sumr = (f"""
let add = {add} in
fix (case self => ( 
    case (b, ~nil @) => b
    case (b, ~cons (x, xs)) => (add)((self)(b, xs), x)
))
""".strip())

curried_sumr = (f"""
let add = {add} in
fix (case self => case b => ( 
    case (~nil @) => b
    case (~cons (x, xs)) => (add)((self)(b)(xs), x)
))
""".strip())

foldr = (f'''
fix (case self => ( 
    case (f, b, ~nil @) => b
    case (f, b, ~cons (x, xs)) => f((self)(f, b, xs), x)
))
'''.strip())

foldl = (f'''
fix (case self => ( 
    case (f, b, ~nil @) => b
    case (f, b, ~cons (x, xs)) => self(f, (f)(b, x), xs)
))
'''.strip())

curried_foldl = (f'''
fix (case self => case (f, b) => ( 
    case ~nil @ => b
    case ~cons (x, xs) => self(f, f(b, x))(xs)
))
'''.strip())


fib = (f"""
let add = {add} in
fix (case self => ( 
    case (~zero @) => ~zero @
    case (~succ ~zero @) => ~succ ~zero @
    case (~succ ~succ n) => ({add})((self)(~succ n), (self)(n))
))
""".strip())

curried_tail_fib = (f"""
let add = {add} in
let f = fix (case self => (case (result, next) =>( 
    case (~zero @) => result 
    case (~succ n) => 
        let new_result = next in
        let new_next = ({add})(result, next) in
        (self)(new_result, new_next)(n)
))) in
f(~zero @, ~succ ~zero @)
""".strip())
# | prev | curr | input 
# | 0    | 1    | 2     
# | 1    | 1    | 1     
# | 1    | 2    | 0 => answer: 1     

# | prev | curr |input 
# | 0    | 1    | 3     
# | 1    | 1    | 2     
# | 1    | 2    | 1
# | 2    | 3    | 0 => answer: 2     

# | prev | curr |input 
# | 0    | 1    | 4     
# | 1    | 1    | 3     
# | 1    | 2    | 2 
# | 2    | 3    | 1     
# | 3    | 5    | 0 => answer: 3

# 0, 1, 1, 2, 3, 5, 8

fact = (f"""
let mult = {mult}
fix (case self => ( 
    case (~zero @) => ~succ ~zero @
    case (~succ n) => (mult)((self)(n), ~succ n)
))
""".strip())


max = (f"""
let lted = {lted} in
case (x, y) => (
    if (lted)(x, y) then
        y
    else
        x
)
""".strip())

# NOTE: an example demonstrating refinement abilities
refiner : Callable[[str, str], str] = (lambda f, g : (f"""

let f : T0 = (case (;uno = x) => x) in
let g : T1 = (case (;dos = x) => x) in
case x => (
    (({f})(x), ({g})(x))
)
""").strip())

# NOTE: an example demonstrating expansion abilities
expander = (f"""
let length = {length} in 
(case (b, l) => (
    (if b then
        ((length)(l), l)
    else
        (length)(l)
    )
))
""".strip())



halve_list = (f"""
fix(case self => (
    case ~nil @ => (~nil @, ~nil @) 
    case ~cons (x, ~nil @) => (~cons (x, ~nil @), ~nil @) 
    case ~cons (x, ~cons(y, zs)) => 
        (self)(zs) |> (case (ls, rs) => (
            (~cons (x, ls), ~cons (y, rs))
        ))   
))
""".strip())

merge_lists = (f"""
let lted = ({lted}) in
fix(case self => (
    case (xs, ~nil @) => xs 
    case (~cons (x, xs), ~cons (y, ys)) => 
        if lted(x, y) then
            ~cons (x, self(xs, ~cons (y, ys)))
        else
            ~cons (y, self(~cons (x, xs), ys))
))
""".strip())


merge_sort = (f"""
let halve = ({halve_list}) in
let merge = ({merge_lists}) in
fix(case self => (
    case ~nil @ => ~nil @
    case ~cons(x, ~nil @) => ~cons(x, ~nil @)
    case xs =>
        (halve)(xs) |> (case (ys, zs) =>
            merge((self)(ys), (self)(zs))
        )
))
""".strip())

is_member = (f"""
let lt = {ltd} in
fix(case self => (
    case (x, ~empty @) => ~false @
    case (x, ~tree (c, l, y, r)) => 
        if lt(x, y) then 
            self(x, l)
        else if lt(y, x) then
            self(x, r)
        else
            ~true @ 
))
""".strip())

balance = (f"""
fix(self =>
    case (~black @,~tree(~red @,~tree(~red @,a,x,b),y,c),z,d) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,~tree(~red @,a,x,~tree(~red @,b,y,c)),z,d) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,a,x,~tree(~red @,~tree(~red @,b,y,c),z,d)) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,a,x,~tree(~red @,b,y,~tree(~red @,c,z,d))) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case body => ~tree body 
)

""".strip())

insert = (f"""
let balance = {balance} in
let lt = {ltd} in
case (x, t) => (
    let f = fix(case self => (
        case (~empty @) => ~tree (~red @, ~empty @, x, ~empty @) 
        case (~tree (color, l, y, r)) => (
            (if lt(x,y) then
                balance(color, (self)(l), y, r)
            else if lt(y,x) then
                balance(color, l, y, (self)(r))
            else
                ~tree (color, l, y, r) in 
            )
        )
    )) in
    f(t) |> (case ~tree (color, l, y, r) =>
        ~tree (~black @, l, y, r)
    )
)
""".strip())