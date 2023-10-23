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
class SymbolGuide:
    content : str

@dataclass(frozen=True, eq=True)
class TerminalGuide:
    content : str

@dataclass(frozen=True, eq=True)
class ExprGuide: 
    env : PMap[str, Typ]
    typ : Typ 

Guidance = Union[SymbolGuide, TerminalGuide, ExprGuide]



"""
Gathering
"""

def gather_expr_id(guide : ExprGuide, text : str) -> Optional[Typ]:
    return guide.env[text]

def gather_expr_unit(guide : ExprGuide) -> Optional[Typ]:
    return TUnit() 

def gather_expr_tag(guide : ExprGuide, label : str, body : Typ) -> Optional[Typ]:
    return TTag(label, body) 

def gather_expr_let(guide : ExprGuide, op_body) -> Optional[Typ]:
    return unbox(
        Induc(body)
        for body in box(op_body) 
    )

def gather_expr_fix(guide : ExprGuide, op_body) -> Optional[Typ]:
    return unbox(
        Induc(body)
        for body in box(op_body) 
    )

"""
Guiding
"""

def guide_expr_let_body(guide : ExprGuide, id : str, target : Typ) -> Guidance:
    env = guide.env.set(id, target)
    return ExprGuide(env, Top())
