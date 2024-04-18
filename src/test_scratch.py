from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 

@dataclass(frozen=True, eq=True)
class Cons: 
    head : int
    tail : MyList 

@dataclass(frozen=True, eq=True)
class Nil(): 
    pass

MyList = Union[Cons, Nil]

def foldr(f, l : MyList, b):
    if isinstance(l, Nil):
      return b
    elif isinstance(l, Cons):
      x = l.head
      xs = l.tail
      return f(foldr(f, xs, b), x)

def sumr(l : MyList, b):
    if isinstance(l, Nil):
      return b
    elif isinstance(l, Cons):
      x = l.head
      xs = l.tail
      return sumr(xs, b) + x



def foldl(f, l : MyList, b):
    if isinstance(l, Nil):
      return b
    elif isinstance(l, Cons):
      x = l.head
      xs = l.tail
      return foldl(f, xs, f(b,x))

def suml(l : MyList, b):
    if isinstance(l, Nil):
      return b
    elif isinstance(l, Cons):
      x = l.head
      xs = l.tail
      return suml(xs, b + x)



def mine(xs : list) -> MyList:
    result = Nil()
    for x in reversed(xs):
      result = Cons(x, result)
    return result


# print(foldr(lambda acc, x : acc + x, mine([1,2, 3]), 0))
# print(foldr(lambda acc, x : acc / x, mine([1,2]), 6))
# print(f"-------------------------")
# print(foldl(lambda acc, x : acc + x, mine([1,2,3]), 0))
# print(foldl(lambda acc, x : acc / x, mine([2, 1]), 6))

print(sumr(mine([1,2,3]), 0))
print(f"-------------------------")
print(suml(mine([1,2,3]), 0))