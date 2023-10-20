from __future__ import annotations
from dataclasses import dataclass
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.util_system import unbox, box  

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
    typ : Typ 

Guidance = Union[Symbol, Terminal, NontermExpr]

"""
Gathering
"""

def gather_expr_unit() -> Optional[Typ]:
    return TUnit() 

def gather_expr_fix(op_body) -> Optional[Typ]:
    return unbox(
        Induc(body)
        for body in box(op_body) 
    )