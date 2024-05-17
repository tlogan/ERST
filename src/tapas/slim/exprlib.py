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


fib = (f"""
let add = {add} in
fix (case self => ( 
    case (~zero @) => ~zero @
    case (~succ ~zero @) => ~succ ~zero @
    case (~succ ~succ n) => ({add})((self)(~succ n), (self)(n))
))
""".strip())

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

#TODO: divide, split, merge, sort, reverse, append/concat