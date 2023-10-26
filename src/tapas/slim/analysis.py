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
from pyrsistent import m 

from contextlib import contextmanager



"""
Typ data types
"""

@dataclass(frozen=True, eq=True)
class TVar:
    id : str

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

@dataclass(frozen=True, eq=True)
class TField:
    label : str
    body : Typ 

@dataclass(frozen=True, eq=True)
class Inter:
    left : Typ 
    right : Typ 

@dataclass(frozen=True, eq=True)
class Imp:
    antec : Typ 
    consq : Typ 

@dataclass(frozen=True, eq=True)
class Induc:
    body : Typ 


Typ = Union[TVar, Top, TUnit, TTag, TField, Inter, Imp, Induc]

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

# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
Interp = PMap[str, Typ]
Enviro = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class ExprGuide: 
    interp : Interp
    enviro : Enviro 
    typ : Typ 

Guidance = Union[SymbolGuide, TerminalGuide, ExprGuide]

init_guidance = ExprGuide(m(), m(), Top())


class Analyzer:

    _type_id : int = 0 

    # def __init__(self, type_id : int):
    #     self._type_id = type_id

    """
    State 
    """

    def fresh_type_var(self) -> Typ:
        self._type_id += 1
        return TVar(f"_{self._type_id}")


    """
    Combination 
    """

    def combine_expr_id(self, guide : ExprGuide, text : str) -> Optional[Typ]:
        return guide.enviro[text]

    def combine_expr_unit(self, guide : ExprGuide) -> Optional[Typ]:
        return TUnit() 

    def combine_expr_tag(self, guide : ExprGuide, label : str, body : Typ) -> Optional[Typ]:
        return TTag(label, body) 

    def combine_record_single(self, guide : ExprGuide, label : str, body : Typ) -> Optional[Typ]:
        return TField(label, body) 

    def combine_record_cons(self, guide : ExprGuide, label : str, body : Typ, cons : Typ) -> Optional[Typ]:
        return Inter(TField(label, body), cons)  

    def combine_expr_function(self, guide : ExprGuide, param : str, op_body : Optional[Typ]) -> Optional[Typ]:
        antec = guide.enviro[param]
        return unbox(
            Imp(antec, consq)
            for consq in box(op_body)
        )

    def combine_expr_fix(self, guide : ExprGuide, op_body) -> Optional[Typ]:
        return unbox(
            Induc(body)
            for body in box(op_body) 
        )

    """
    Distillation 
    """

    def distill_expr_function_body(self, guide : ExprGuide, param : str) -> Guidance:
        '''
        TODO: decompose guide.typ into expected typ of the body
        '''
        typ_in = self.fresh_type_var()
        typ_out = self.fresh_type_var()
        """
        TODO: unify to the consequent of the expected type: unify(guide.typ, Imp(typ_in, typ_out))
        can basically move antecedent into qualifier of consequent 
        e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
        """
        interp = self.unify(guide.interp, guide.typ, Imp(typ_in, typ_out)) 
        enviro = guide.enviro.set(param, typ_in)

        return ExprGuide(interp, enviro, typ_out)

    def distill_expr_let_body(self, guide : ExprGuide, id : str, target : Typ) -> Guidance:
        interp = guide.interp
        enviro = guide.enviro.set(id, target)
        return ExprGuide(interp, enviro, guide.typ)

    def distill_expr_fix_body(self, guide : ExprGuide) -> Guidance:
        return ExprGuide(guide.interp, guide.enviro, Top())


    """
    Unification 
    """

    # TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    # TODO: encode problem into Z3; decode back to Slim. 
    def unify(self, interp : Interp, lower : Typ, upper : Typ) -> PMap[str, Typ]:
        return m()