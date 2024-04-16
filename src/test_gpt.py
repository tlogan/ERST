from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 


# client = OpenAI()

# completion = client.chat.completions.create(
#   model="gpt-3.5-turbo",
#   messages=[
#     {"role": "system", "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."},
#     {"role": "user", "content": "Compose a poem that explains the concept of recursion in programming."}
#   ]
# )

# print(completion.choices[0].message)




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

print(make_prompt("""
let foo : T1 =
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons (x, xs) => ~succ (self(xs)) 
)) 
;
foo
"""))