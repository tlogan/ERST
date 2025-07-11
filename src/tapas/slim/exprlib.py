from __future__ import annotations

from typing import *
from dataclasses import dataclass
from tapas.slim.typlib import *

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset


############################################################
#### Context ####
############################################################


context_map = {
"head" : f"ALL[A] {List_('A')} -> A",
"tail" : f"ALL[A] {List_('A')} -> {List_('A')}",
"nil" : f"ALL[A] {List_('A')}",
"cons" : f"ALL[A] A -> {List_('A')} -> {List_('A')}",
"single" : f"ALL[A] A -> {List_('A')}",
"append" : f"ALL[A] {List_('A')} -> {List_('A')} -> {List_('A')}",
"length" : f"ALL[A] {List_('A')} -> {Nat}",
"const" : f"ALL[A B] A -> B -> A",
"id" : f"ALL[A] A -> A",
"ids" : List_(f"ALL[A] A -> A"),
"inc" : f"{Nat} -> {Nat}",
"choose" : f"ALL[A] A -> A -> A",
"poly" : f"(ALL[A] A -> A) -> ({Nat} * {Bool})",
"fst" : f"ALL[A B] (A * B) -> A",
"auto" : f"(ALL[A] A -> A) -> (ALL [A] A -> A)",
"auto_prime" : f"ALL[B] (ALL[A] A -> A) -> B -> B",
"map" : f"ALL[A B] (A -> B) -> {List_('A')} -> {List_('B')}",
"app" : f"ALL[A B] (A -> B) -> A -> B",
"revapp" : f"ALL[A B] A -> (A -> B) -> B",
"runState" : f"ALL[A B] (ALL[S] {State('S', 'A')}) -> B",
"argState" : f"ALL[S] {State('S', Nat)}",
"zero" : Church,
"succ" : f"{Church} -> {Church}",
"foo" : f"ALL[A] (A -> A) -> ({List_('A')} -> A)",
"g" : f"ALL[A] {List_('A')} -> {List_('A')} -> A",
"k" : f"ALL[A] A -> {List_('A')} -> A",
"h" : f"{Nat} -> ALL[A] A -> A",
"l" : List_(f"ALL[A] {Nat} -> A -> A"),
"r" : f"(ALL[A] A -> ALL[B] B -> B) -> {Nat}",
"sort" : f"(ALL[A] ((A * A) -> {Bool}) -> {List_('A')} -> {List_('A')})",
"scalarCmp" : f"({Nat} * {Nat}) -> ({Bool})",
"lexicoCmp" : f"({List_(Nat)} * {List_(Nat)}) -> ({Bool})",
"hof" : f"ALL[A B C] ((A * B) -> C) -> (<thing> A) -> (<thing> B)",
"mkpath" : f"ALL[A C] (A -> C) -> (A) -> (C)",
"mkpair" : f"ALL[A B] (A -> B) -> (A * B)",
}

def ctx(names : list[str]) -> PMap[str, str]:
    return pmap({
        n : context_map[n]
        for n in names
    })
# def ctx(names : list[str], code : str):
#     base = code
#     for name in (names):
#         base = (f"""
# def zzz_{name} : ({context_map.get(name)}) -> TOP = 
# [ {name} => {base} ] 
# in zzz_{name} 
#         """.strip())
#     return base


############################################################
#### Basics ####
############################################################

church_zero = (f"""
[ f => [ x => x ] ]
""".strip())

church_succ = (f"""
[ n => [ f => [ x => f(n(f)(x)) ] ] ]
""".strip())

church_one = (f"""
{church_succ}({church_zero})
""".strip())

church_two = (f"""
{church_succ}({church_one})
""".strip())

church_three = (f"""
{church_succ}({church_two})
""".strip())

to_church = (f"""
loop([ self => 
    [ zero;@ => {church_zero} ]
    [ succ;n => {church_succ}(self(n)) ]
])
""".strip())


head = (f"""
    case (cons;(x,xs)) [ x ]
""".strip())

    # case (cons;(x,xs)) { x }

tail = (f"""
    case (cons;(x, xs)) => xs
""".strip())

single = (f"""
    case x => (cons;(x, <nil> @)) 
""".strip())

double = (f"""
loop([ self => 
    [ zero;@ => zero;@ ]
    [ succ;n => succ;succ;(self(n)) ]
])
""".strip())

halve = (f"""
loop([ self => 
    [ zero;@ => zero;@ ]
    [ succ;succ;n => succ;(self(n)) ]
])
""".strip())


both = (f"""
(
[ (true;@),(true;@) => true;@  ]
[ (false;@),(true;@) => false;@  ]
[ (false;@),(false;@) => false;@  ]
[ (true;@),(false;@) => false;@  ]
)
""".strip())

stdCmp = (f"""
([a,b =>
    a |> (
        [zero;@ => scalarCmp(a,b)]
        [succ;n => scalarCmp(a,b)]
        [nil;@ => lexicoCmp(a,b)]
        [cons;(x,xs) => lexicoCmp(a,b)]
    )
])
""".strip())

############################################################
############################################################

ltd = ('''
loop(case self => (
    case (~zero @, ~succ x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (x, ~zero @) => ~false @ 
))
''')


lted = (f"""
loop([ self =>
    [ (zero;@), n => true;@ ]
    [ (succ;m), (succ;n) => self(m,n) ]
    [ (succ;m), (zero;@) => false;@  ]
])

""".strip())

max = (f'''
def lted = {lted} in
[ (x, y) =>
    if lted(x, y) then
        y
    else
        x
]
''')

# max = (f'''
# def lted = {lted} in
# case (x, y) => (
#     lted(x, y)
# )
# ''')
# max = (f'''
# def f = case (~uno y) => y in 
# case x => f(x)
# ''')

# max = (f'''
# {lted}
# ''')

length = (f"""
loop([ self => 
    [ nil;@ => zero;@  ]
    [ cons;(x,xs) => succ;(self(xs)) ]
]) 
""".strip())

lengthy = (f"""
def id = [x => x] in
loop(id([ self => 
    [ nil;@ => zero;@  ]
    [ cons;(x,xs) => succ;(self(xs)) ]
])) 
""".strip())

add = (f"""
loop (case self => ( 
    case (~zero @, n) => n 
    case (~succ m, n) => ~succ (self(m, n))
))
""".strip())


mult = (f"""
def add = {add} in 
loop (case self => ( 
    case (~zero @, n) => ~zero 
    case (~succ m, n) => (add)(n, (self)(m, n))
))
""".strip())

concat_lists = (f"""
loop (case self => ( 
    case (~nil @, ys) => ys 
    case (~cons (x, xs), ys) => ~cons (x, (self)(xs, ys))
))
""".strip())

reverse = (f"""
def concat = ({concat_lists}) in
loop (case self => ( 
    case (~nil @) => ~nil @ 
    case (~cons (x, xs)) => 
        concat((self)(xs), ~cons(x, ~nil @))
))
""".strip())

tail_reverse = (f"""
def f = loop (case self => ( 
    case (result, ~nil @) => result 
    case (result, ~cons (x, xs)) => 
        self(~cons(x, result), xs)
)) in
case xs => f(~nil @, xs)
""".strip())

stepped_tail_reverse = (f"""
def f = loop (case self => case (result, l) => ( 
    l |> (
    case (~nil @) => result 
    case (~cons (x, xs)) => 
        self(~cons(x, result), xs)
    )
)) in
case xs => f(~nil @, xs)
""".strip())

curried_tail_reverse = (f"""
def f = loop (case self => case result => ( 
    case (~nil @) => result 
    case (~cons (x, xs)) => 
        self(~cons(x, result))(xs)
)) in
f(~nil @)
""".strip())


suml = (f"""
def add = {add} in
loop (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => self(xs, (add)(b, x))
))
""".strip())

sumr = (f"""
def add = {add} in
loop (case self => ( 
    case (b, ~nil @) => b
    case (b, ~cons (x, xs)) => (add)((self)(b, xs), x)
))
""".strip())

curried_sumr = (f"""
def add = {add} in
loop (case self => case b => ( 
    case (~nil @) => b
    case (~cons (x, xs)) => (add)((self)(b)(xs), x)
))
""".strip())

foldr = (f'''
loop (case self => ( 
    case (f, b, ~nil @) => b
    case (f, b, ~cons (x, xs)) => f((self)(f, b, xs), x)
))
'''.strip())

foldl = (f'''
loop (case self => ( 
    case (f, b, ~nil @) => b
    case (f, b, ~cons (x, xs)) => self(f, (f)(b, x), xs)
))
'''.strip())

curried_foldl = (f'''
loop (case self => case (f, b) => ( 
    case ~nil @ => b
    case ~cons (x, xs) => self(f, f(b, x))(xs)
))
'''.strip())


fib = (f"""
def add = {add} in
loop (case self => ( 
    case (~zero @) => ~zero @
    case (~succ ~zero @) => ~succ ~zero @
    case (~succ ~succ n) => ({add})((self)(~succ n), (self)(n))
))
""".strip())

curried_tail_fib = (f"""
def add = {add} in
def f = loop (case self => (case (result, next) =>( 
    case (~zero @) => result 
    case (~succ n) => 
        def new_result = next in
        def new_next = ({add})(result, next) in
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
def mult = {mult}
loop (case self => ( 
    case (~zero @) => ~succ ~zero @
    case (~succ n) => (mult)((self)(n), ~succ n)
))
""".strip())


# max = (f"""
# def lted = {lted} in
# case (x, y) => (
#     if (lted)(x, y) then
#         y
#     else
#         x
# )
# """.strip())

# NOTE: an example demonstrating refinement abilities
refiner : Callable[[str, str], str] = (lambda f, g : (f"""

def f : T0 = (case (;uno = x) => x) in
def g : T1 = (case (;dos = x) => x) in
case x => (
    (({f})(x), ({g})(x))
)
""").strip())

# NOTE: an example demonstrating expansion abilities
expander = (f"""
def length = {length} in 
(case (b, l) => (
    (if b then
        ((length)(l), l)
    else
        (length)(l)
    )
))
""".strip())



halve_list = (f"""
loop(case self => (
    case ~nil @ => (~nil @, ~nil @) 
    case ~cons (x, ~nil @) => (~cons (x, ~nil @), ~nil @) 
    case ~cons (x, ~cons(y, zs)) => 
        (self)(zs) |> (case (ls, rs) => (
            (~cons (x, ls), ~cons (y, rs))
        ))   
))
""".strip())

merge_lists = (f"""
def lted = ({lted}) in
loop(case self => (
    case (xs, ~nil @) => xs 
    case (~cons (x, xs), ~cons (y, ys)) => 
        if lted(x, y) then
            ~cons (x, self(xs, ~cons (y, ys)))
        else
            ~cons (y, self(~cons (x, xs), ys))
))
""".strip())


merge_sort = (f"""
def halve = ({halve_list}) in
def merge = ({merge_lists}) in
loop(case self => (
    case ~nil @ => ~nil @
    case ~cons(x, ~nil @) => ~cons(x, ~nil @)
    case xs =>
        (halve)(xs) |> (case (ys, zs) =>
            merge((self)(ys), (self)(zs))
        )
))
""".strip())

is_member = (f"""
def lt = {ltd} in
loop(case self => (
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
loop(self =>
    case (~black @,~tree(~red @,~tree(~red @,a,x,b),y,c),z,d) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,~tree(~red @,a,x,~tree(~red @,b,y,c)),z,d) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,a,x,~tree(~red @,~tree(~red @,b,y,c),z,d)) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case (~black @,a,x,~tree(~red @,b,y,~tree(~red @,c,z,d))) => ~tree(~red@,~tree(~black@,a,x,b),y,~tree(~black@,c,z,d))
    case body => ~tree body 
)

""".strip())

insert = (f"""
def balance = {balance} in
def lt = {ltd} in
case (x, t) => (
    def f = loop(case self => (
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