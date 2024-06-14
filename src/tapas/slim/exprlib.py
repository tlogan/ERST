from __future__ import annotations

from typing import *
from dataclasses import dataclass

lted = ('''
fix(case self => (
    case (~zero @, x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (~succ x, ~zero @) => ~false @ 
))
''')

max = (f'''
let lted = {lted} in
case (x, y) => (
    if lted(x, y) then
        y
    else
        x
)
''')


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
    case (~nil @, b) => b
    case (~cons (x, xs), b) => (add)((self)(xs, b), x)
))
""".strip())

curried_sumr = (f"""
let add = {add} in
fix (case self => b => ( 
    case (~nil @) => b
    case (~cons (x, xs)) => (add)((self)(xs, b), x)
))
""".strip())

foldr = (f'''
fix (case self => ( 
    case (f, ~nil @, b) => b
    case (f, ~cons (x, xs), b) => f((self)(f, xs, b), x)
))
'''.strip())

foldl = (f'''
fix (case self => ( 
    case (f, ~nil @, b) => b
    case (f, ~cons (x, xs), b) => self(f, xs, (f)(b, x))
))
'''.strip())

curried_foldl = (f'''
fix (case self => b => ( 
    case (f, ~nil @) => b
    case (f, ~cons (x, xs)) => self(f, xs, (f)(b, x))
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

tail_fib = (f"""
let add = {add} in
let f = fix (case self => ((prev, curr) =>( 
    case (~zero @) => prev 
    case (~succ n) => 
        let new_prev = curr in
        let new_curr = ({add})(prev, curr) in
        (self)(new_prev, new_curr)(n)
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

lted = (f"""
fix(case self => (
    case (~zero @, n) => ~true @ 
    case (~succ m, ~succ n) => self(m,n) 
    case (~succ m, ~zero @) => ~false @ 
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
        self(zs) |> (case (ls, rs) => (
            (~cons (x, ls), ~cons (y, rs))
        )   
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
        halve(xs) |> (case (ys, zs) =>
            merge(self(ys), self(zs))
        )
))
""".strip())

#TODO: reverse, append/concat