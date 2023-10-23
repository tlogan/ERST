from __future__ import annotations
from dataclasses import dataclass
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.util_system import unbox, box  

from pyrsistent.typing import PMap 

from contextlib import contextmanager



"""
Typ data types
"""

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class TUnit:
    pass

@dataclass(frozen=True, eq=True)
class TTag:
    label : str
    body : Typ 
    pass

@dataclass(frozen=True, eq=True)
class Induc:
    body : Typ 
    pass


Typ = Union[Top, TUnit, TTag, Induc]

"""
Expr data types
"""

@dataclass(frozen=True, eq=True)
class Unit:
    pass


"""
Guidance
"""

@dataclass(frozen=True, eq=True)
class Symbol:
    content : str

@dataclass(frozen=True, eq=True)
class Terminal:
    content : str

@dataclass(frozen=True, eq=True)
class NontermExpr: 
    env : PMap[str, Typ] 
    typ : Typ 

Guidance = Union[Symbol, Terminal, NontermExpr]



"""
Gathering
"""

def gather_expr_id(env : PMap[str, Typ], text : str) -> Optional[Typ]:
    return env[text]

def gather_expr_unit() -> Optional[Typ]:
    return TUnit() 

def gather_expr_tag(env : PMap[str, Typ], label : str, body : Typ) -> Optional[Typ]:
    return TTag(label, body) 

def gather_expr_let(env : PMap[str, Typ], op_body) -> Optional[Typ]:
    return unbox(
        Induc(body)
        for body in box(op_body) 
    )

def gather_expr_fix(op_body) -> Optional[Typ]:
    return unbox(
        Induc(body)
        for body in box(op_body) 
    )

"""
Guiding
"""

def guide_expr_let_body(env : PMap[str, Typ], id : str, target : Typ) -> Guidance:
    env = env.set(id, target)
    return NontermExpr(env, Top())
