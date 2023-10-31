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
class Bot:
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


Typ = Union[TVar, Top, Bot, TUnit, TTag, TField, Inter, Imp, Exis, Induc]

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

    def combine_expr_id(self, plate : Plate, text : str) -> Typ:
        return plate.enviro[text]

    def combine_expr_unit(self, plate : Plate) -> Typ:
        return TUnit() 

    def combine_expr_tag(self, plate : Plate, label : str, body : Typ) -> Typ:
        return TTag(label, body) 

    def combine_record_single(self, plate : Plate, label : str, body : Typ) -> Typ:
        return TField(label, body) 

    def combine_record_cons(self, plate : Plate, label : str, body : Typ, cons : Typ) -> Typ:
        return Inter(TField(label, body), cons)  

    def combine_expr_projection(self, plate : Plate, record : Typ, key : str) -> Typ: 
        answr = self.fresh_type_var()
        interp = self.unify(plate.interp, record, TField(key, answr))
        return Exis(answr, interp)

    def combine_expr_function(self, plate : Plate, param : str, body : Typ) -> Typ:
        antec = plate.enviro[param]
        return Imp(antec, body)

    def combine_expr_projmulti(self, plate : Plate, record : Typ, keys : list[str]) -> Typ: 
        interp_i = plate.interp
        answr_i = record 
        for key in keys:
            answr = self.fresh_type_var()
            interp_i = self.unify(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return Exis(answr_i, interp_i)

    def combine_expr_idprojmulti(self, plate : Plate, id : str, keys : list[str]) -> Typ: 
        return self.combine_expr_projmulti(plate, plate.enviro[id], keys)

    def combine_keychain_single(self, plate : Plate, key : str) -> list[str]:
        # self.unify(plate.enviro, plate.expect, TField(key, Top())) 
        return [key]

    def combine_keychain_cons(self, plate : Plate, key : str, keys : list[str]) -> list[str]:
        return self.combine_keychain_single(plate, key) + keys

    def combine_expr_appmulti(self, plate : Plate, function : Typ, arguments : list[Typ]) -> Typ: 
        interp_i = plate.interp
        answr_i = function 
        for argument in arguments:
            answr = self.fresh_type_var()
            interp_i = self.unify(interp_i, answr_i, Imp(argument, answr))
            answr_i = answr

        return Exis(answr_i, interp_i)

    def combine_argchain_single(self, plate : Plate, content : Typ) -> list[Typ]:
        # self.unify(plate.enviro, plate.expect, Imp(content, Top()))
        return [content]

    def combine_argchain_cons(self, plate : Plate, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_argchain_single(plate, head) + tail

    def combine_expr_callmulti(self, plate : Plate, id : str, arguments : list[Typ]) -> Typ: 
        function = plate.enviro[id]
        return self.combine_expr_appmulti(plate, function, arguments)


    def combine_expr_fix(self, plate : Plate, body : Typ) -> Typ:
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

    def distill_expr_projmulti_cator(self, plate : Plate) -> Plate:
        return Plate(plate.interp, plate.enviro, Top())

    def distill_expr_projmulti_keychain(self, plate : Plate, record : Typ) -> Plate: 
        return Plate(plate.interp, plate.enviro, record)

    def distill_expr_idprojmulti_keychain(self, plate : Plate, id : str) -> Plate: 
        return self.distill_expr_projmulti_keychain(plate, plate.enviro[id])

    '''
    return the plate with the expectation as the type that the next element in tail cuts
    '''
    def distill_keychain_cons_tail(self, plate : Plate, key : str):
        expect = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.expect, TField(key, expect))
        return Plate(interp, plate.enviro, expect)

    
    def distill_expr_appmulti_cator(self, plate : Plate) -> Plate: 
        return Plate(plate.interp, plate.enviro, Imp(Bot(), Top()))

    def distill_expr_appmulti_argchain(self, plate : Plate, function : Typ) -> Plate: 
        return Plate(plate.interp, plate.enviro, function)

    def distill_expr_callmulti_argchain(self, plate : Plate, id : str) -> Plate: 
        function = plate.enviro[id]
        return self.distill_expr_appmulti_argchain(plate, function)

    def distill_argchain_single_content(self, plate : Plate):
        expect = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.expect, Imp(expect, Top()))
        return Plate(interp, plate.enviro, expect)


    def distill_argchain_cons_head(self, plate : Plate):
        expect = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.expect, Imp(expect, Top()))
        return Plate(interp, plate.enviro, expect)


    '''
    return the plate with the expectation as the type that the next element in tail cuts
    '''
    def distill_argchain_cons_tail(self, plate : Plate, head : Typ):
        expect = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.expect, Imp(head, expect))
        return Plate(interp, plate.enviro, expect)


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