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



# program_data = generate_program_examples(3)
# # examples = random.sample(program_data, 1)
# examples = init_program_examples
# for example in examples:
#     sample = json.loads(example) 
#     print(f"""
# <<<<<<<<
# description:

# {sample['description']}

# ***

# grammar:

# {sample['grammar']}

# ***

# program:

# {sample['program']}
# >>>>>>>>
#     """)



write(project_path("res"), "init_program_examples.jsonl", "\n".join(init_program_examples))
write(project_path("res"), "pretty_init_program_examples.txt", "\n".join([
    prettify_program_example(ex)
    for ex in init_program_examples
]))

init_programs = [
    json.loads(ex)['program']
    for ex in init_program_examples
]
init_annotation_examples = [
    make_annotation_example(program)
    for program in init_programs
]

write(project_path("res"), "init_annotation_examples.jsonl", "\n".join(init_annotation_examples))

write(project_path("res"), "pretty_init_annotation_examples.txt", "\n".join([
    prettify_annotation_example(ex)
    for ex in init_annotation_examples 
]))

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
