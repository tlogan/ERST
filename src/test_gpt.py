from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 
from tapas.slim.datamunger import * 
import random
from tapas.util_system import *
import json



# gpt_data = generate_gpt_examples(3)
# examples = random.sample(gpt_data, 1)
examples = init_gpt_examples
for example in examples:
    sample = json.loads(example) 
    print(f"""
<<<<<<<<
description:

{sample['description']}

***

grammar:

{sample['grammar']}

***

program:

{sample['program']}
>>>>>>>>
    """)




# print(len(init_gpt_examples))
# print(len(gpt_data))
# write(project_path("res"), "gpt_examples.jsonl", "\n".join(gpt_data))

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
