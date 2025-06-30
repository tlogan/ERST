from __future__ import annotations

from typing import *
from dataclasses import dataclass
from tapas.slim.typlib import *


############################################################
#### Context ####
############################################################

def ctx(names : list[str], code : str):
    base = code
    for name in (names):
        base = (f"""
let zzz_{name} : ({context_map.get(name)}) -> TOP = 
{{ {name} => {base} }} 
in zzz_{name} 
        """.strip())
    return base

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
"sort" : f"(ALL[A] (A * A -> {Bool}) -> {List_('A')} -> {List_('A')})",
"scalarCmp" : f"{Nat} * {Nat} -> {Bool}",
"lexicoCmp" : f"{List_(Nat)} * {List_(Nat)} -> {Bool}",
}


############################################################
#### Basics ####
############################################################

church_zero = (f"""
{{ f => {{ x => x }} }}
""".strip())

church_succ = (f"""
{{ n => {{ f => {{ x => f(n(f)(x)) }} }} }}
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
fix({{ self => 
    {{ zero;@ => {church_zero} }}
    {{ succ;n => {church_succ}(self(n)) }}
}})
""".strip())


head = (f"""
    case (cons;(x,xs)) {{ x }}
""".strip())

    # case (cons;(x,xs)) { x }

tail = (f"""
    case (cons;(x, xs)) => xs
""".strip())

single = (f"""
    case x => (cons;(x, <nil> @)) 
""".strip())

double = (f"""
fix({{ self => 
    {{ zero;@ => zero;@ }}
    {{ succ;n => succ;succ;(self(n)) }}
}})
""".strip())

halve = (f"""
fix({{ self => 
    {{ zero;@ => zero;@ }}
    {{ succ;succ;n => succ;(self(n)) }}
}})
""".strip())


both = (f"""
(
{{ (true;@),(true;@) => true;@  }}
{{ (false;@),(true;@) => false;@  }}
{{ (false;@),(false;@) => false;@  }}
{{ (true;@),(false;@) => false;@  }}
)
""".strip())

isNat = (f"""
fix({{ self => 
    {{ zero;@ => true;@ }}
    {{ succ;n => self(n) }}
    {{ ignore => false;@ }}
}})
""".strip())

isNatList = (f"""
fix({{ self => 
    {{ nil;@ => true;@ }}
    {{ cons;(n, xs) => both(({isNat}(n)), self(xs)) }}
    {{ ignore => false;@ }}
}})
""".strip())

stdCmp = (f"""
({{a,b =>
    if both(({isNat})(a), ({isNat})(b)) then
        scalarCmp(a,b)
    else (both(({isNatList})(a), ({isNatList})(b))) |> ({{true;@ =>
        lexicoCmp(a,b)
    }})
}})
""".strip())

############################################################
############################################################

ltd = ('''
fix(case self => (
    case (~zero @, ~succ x) => ~true @ 
    case (~succ a, ~succ b) => self(a,b) 
    case (x, ~zero @) => ~false @ 
))
''')


lted = (f"""
fix({{ self =>
    {{ (zero;@), n => true;@ }}
    {{ (succ;m), (succ;n) => self(m,n) }}
    {{ (succ;m), (zero;@) => false;@  }}
}})

""".strip())

max = (f'''
let lted = {lted} in
{{ (x, y) =>
    if lted(x, y) then
        y
    else
        x
}}
''')

# max = (f'''
# let lted = {lted} in
# case (x, y) => (
#     lted(x, y)
# )
# ''')
# max = (f'''
# let f = case (~uno y) => y in 
# case x => f(x)
# ''')

# max = (f'''
# {lted}
# ''')

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


# max = (f"""
# let lted = {lted} in
# case (x, y) => (
#     if (lted)(x, y) then
#         y
#     else
#         x
# )
# """.strip())

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