from __future__ import annotations
from dataclasses import dataclass
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

# from tapas.util_system import unbox, box  

from pyrsistent.typing import PMap 
from pyrsistent import m 

from contextlib import contextmanager


Op = Optional

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
class Exis:
    body : Typ 
    qualifiers : Interp 

@dataclass(frozen=True, eq=True)
class Induc:
    body : Typ 


Typ = Union[TVar, Top, TUnit, TTag, TField, Inter, Imp, Exis, Induc]

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


# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
Interp = PMap[str, Typ]
Enviro = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class Plate: 
    interp : Interp
    enviro : Enviro 
    expect : Typ

Guidance = Union[Symbol, Terminal, Plate]

plate_default = Plate(m(), m(), Top())

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

    def combine_expr_id(self, plate : Plate, text : str) -> Op[Typ]:
        return plate.enviro[text]

    def combine_expr_unit(self, plate : Plate) -> Op[Typ]:
        return TUnit() 

    def combine_expr_tag(self, plate : Plate, label : str, body : Typ) -> Op[Typ]:
        return TTag(label, body) 

    def combine_record_single(self, plate : Plate, label : str, body : Typ) -> Op[Typ]:
        return TField(label, body) 

    def combine_record_cons(self, plate : Plate, label : str, body : Typ, cons : Typ) -> Op[Typ]:
        return Inter(TField(label, body), cons)  

    def combine_expr_projection(self, plate : Plate, record : Typ, key : str) -> Op[Typ]: 
        answr = self.fresh_type_var()
        interp = self.unify(plate.interp, record, TField(key, answr))
        return Exis(answr, interp)

    def combine_expr_function(self, plate : Plate, param : str, body : Typ) -> Op[Typ]:
        antec = plate.enviro[param]
        return Imp(antec, body)

    def combine_expr_application(self, plate : Plate, applicator : Typ, applicand : Typ) -> Op[Typ]: 
        answr = self.fresh_type_var()
        interp = self.unify(plate.interp, applicator, Imp(applicand, answr))
        return Exis(answr, interp)

    def combine_expr_call(self, plate : Plate, id : str, applicand : Typ) -> Op[Typ]: 
        applicator = plate.enviro[id]
        return self.combine_expr_application(plate, applicator, applicand)

    def combine_expr_fix(self, plate : Plate, body : Typ) -> Op[Typ]:
        return Induc(body)

    """
    Distillation 
    """

    def distill_expr_function_body(self, plate : Plate, param : str) -> Plate:
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
        interp = self.unify(plate.interp, plate.expect, Imp(typ_in, typ_out)) 
        enviro = plate.enviro.set(param, typ_in)

        return Plate(interp, enviro, typ_out)

    def distill_expr_application_applicand(self, plate : Plate, applicator : Typ) -> Plate: 
        applicand = self.fresh_type_var()
        interp = self.unify(plate.interp, applicator, Imp(applicand, plate.expect))
        return Plate(interp, plate.enviro, applicand)

    def distill_expr_call_applicand(self, plate : Plate, id : str) -> Plate: 
        applicator = plate.enviro[id]
        return self.distill_expr_application_applicand(plate, applicator)

    def distill_expr_let_body(self, plate : Plate, id : str, target : Typ) -> Plate:
        interp = plate.interp
        enviro = plate.enviro.set(id, target)
        return Plate(interp, enviro, plate.expect)

    def distill_expr_fix_body(self, plate : Plate) -> Plate:
        return Plate(plate.interp, plate.enviro, Top())


    """
    Unification 
    """

    # TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    # TODO: encode problem into Z3; decode back to Slim. 
    def unify(self, interp : Interp, lower : Typ, upper : Typ) -> Interp:
        return interp 