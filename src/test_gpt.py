from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 
from tapas.slim.datamunger import * 
import random
from tapas.util_system import *



gpt_examples = [
    make_gpt_example('''
A function that takes a list and returns its length
        ''', """
let foo : T1 =
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons (x, xs) => ~succ (self(xs)) 
)) 
;
foo
    """)
]


print(gpt_examples)
gpt_data = generate_gpt_examples()
write(project_path("res"), "gpt_examples.jsonl", "\n".join(gpt_data))

# @dataclass(frozen=True, eq=True)
# class Cons: 
#     head : int
#     tail : MyList 

# @dataclass(frozen=True, eq=True)
# class Nil(): 
#     pass

# MyList = Union[Cons, Nil]

# def foldr(f, l : MyList, b):
#     if isinstance(l, Nil):
#       return b
#     elif isinstance(l, Cons):
#       x = l.head
#       xs = l.tail
#       return f(foldr(f, xs, b), x)



# def mine(xs : list) -> MyList:
#     result = Nil()
#     for x in reversed(xs):
#       result = Cons(x, result)
#     return result




# print(foldr(lambda acc, x : acc + x, mine([1,2, 3]), 0))
# print(foldr(lambda acc, x : acc / x, mine([1,2]), 6))
