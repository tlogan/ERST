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
# TODO: type concrete syntax
# TField ==> :uno : typ :dos : typ 
# TTag   ==> :tag? :tag? :tag? typ 

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


@dataclass(frozen=True, eq=True)
class ECombo:
    descrip : Typ    




"""
Pat data types
"""

@dataclass(frozen=True, eq=True)
class PVar:
    id : str

@dataclass(frozen=True, eq=True)
class PUnit:
    pass

Expr = Union[PVar, PUnit]

@dataclass(frozen=True, eq=True)
class PCombo:
    enviro : PMap[str, Typ]
    descrip : Typ    


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
    prescrip : Typ

Guidance = Union[Symbol, Terminal, Plate]

plate_default = Plate(m(), m(), Top())

class Solver:
    _type_id : int = 0 

    # def __init__(self, type_id : int):
    #     self._type_id = type_id

    def fresh_type_var(self) -> Typ:
        self._type_id += 1
        return TVar(f"_{self._type_id}")

    # TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    # TODO: encode problem into Z3; decode back to Slim. 
    def unify(self, interp : Interp, lower : Typ, upper : Typ) -> Interp:
        return interp 

class Attr:
    def __init__(self, solver : Solver, plate : Plate):
        self.solver = solver
        self.plate = plate 


class ExprAttr(Attr):

    def combine_id(self, text : str) -> ECombo:
        return ECombo(self.plate.enviro[text])

    def combine_unit(self) -> ECombo:
        return ECombo(TUnit())

    def combine_tag(self, label : str, body : ECombo) -> ECombo:
        return ECombo(TTag(label, body.descrip))

    def combine_projection(self, record : Typ, key : str) -> Typ: 
        answr = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, record, TField(key, answr))
        return Exis(answr, interp)

    def distill_projmulti_cator(self) -> Plate:
        return Plate(self.plate.interp, self.plate.enviro, Top())

    def distill_projmulti_keychain(self, record : Typ) -> Plate: 
        return Plate(self.plate.interp, self.plate.enviro, record)


    def combine_projmulti(self, record : ECombo, keys : list[str]) -> ECombo: 
        interp_i = self.plate.interp
        answr_i = record.descrip 
        for key in keys:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.unify(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_idprojmulti_keychain(self, id : str) -> Plate: 
        return self.distill_projmulti_keychain(self.plate.enviro[id])

    def combine_idprojmulti(self, id : str, keys : list[str]) -> ECombo: 
        return self.combine_projmulti(ECombo(self.plate.enviro[id]), keys)

    def distill_appmulti_cator(self) -> Plate: 
        return Plate(self.plate.interp, self.plate.enviro, Imp(Bot(), Top()))

    def distill_appmulti_argchain(self, function : ECombo) -> Plate: 
        return Plate(self.plate.interp, self.plate.enviro, function.descrip)

    def combine_appmulti(self, function : ECombo, arguments : list[ECombo]) -> ECombo: 
        interp_i = self.plate.interp
        answr_i = function.descrip 
        for argument in arguments:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.unify(interp_i, answr_i, Imp(argument.descrip, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_idappmulti_argchain(self, id : str) -> Plate: 
        function = ECombo(self.plate.enviro[id])
        return self.distill_appmulti_argchain(function)

    def combine_idappmulti(self, id : str, arguments : list[ECombo]) -> ECombo: 
        function = ECombo(self.plate.enviro[id])
        return self.combine_appmulti(function, arguments)

    def distill_fix_body(self) -> Plate:
        return Plate(self.plate.interp, self.plate.enviro, Top())

    def combine_fix(self, body : ECombo) -> ECombo:
        return ECombo(Induc(body.descrip))
    

    def distill_let_body(self, id : str, target : Typ) -> Plate:
        interp = self.plate.interp
        enviro = self.plate.enviro.set(id, target)
        return Plate(interp, enviro, self.plate.prescrip)


class RecordAttr(Attr):

    def combine_single(self, label : str, body : ECombo) -> ECombo:
        return ECombo(TField(label, body.descrip)) 

    def combine_cons(self, label : str, body : ECombo, cons : ECombo) -> ECombo:
        return ECombo(Inter(TField(label, body.descrip), cons.descrip))

    #####################
class FunctionAttr(Attr):

    def distill_single_pattern(self) -> Plate:
        antec = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, Imp(antec, Top()))
        return Plate(interp, self.plate.enviro, antec)


    def distill_single_body(self, pattern : PCombo) -> Plate:
        conclusion = self.solver.fresh_type_var() 

        """
        TODO: unify to the consequent of the prescriped type: unify(guide.typ, Imp(typ_in, typ_out))
        can basically move antecedent into qualifier of consequent 
        e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
        """
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, Imp(pattern.descrip, conclusion)) 
        enviro = self.plate.enviro + pattern.enviro
        return Plate(interp, enviro, conclusion)

    def combine_single(self, pattern : PCombo, body : ECombo) -> ECombo:
        return ECombo(Imp(pattern.descrip, body.descrip))

    def combine_cons(self, pattern : PCombo, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(Imp(pattern.descrip, body.descrip), tail.descrip))

    #####################

    # def distill_function_body(self, param : str) -> Plate:
    #     '''
    #     TODO: decompose guide.typ into prescribed typ of the body
    #     '''
    #     typ_in = self.fresh_type_var()
    #     typ_out = self.fresh_type_var()
    #     """
    #     TODO: unify to the consequent of the prescriped type: unify(guide.typ, Imp(typ_in, typ_out))
    #     can basically move antecedent into qualifier of consequent 
    #     e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
    #     """
    #     interp = self.unify(plate.interp, plate.prescrip, Imp(typ_in, typ_out)) 
    #     enviro = plate.enviro.set(param, typ_in)

    #     return Plate(interp, enviro, typ_out)


    # def combine_function(self, param : str, body : ECombo) -> ECombo:
    #     antec = plate.enviro[param]
    #     consq = body.descrip
    #     return ECombo(Imp(antec, consq))

    #####################

class PatternAttr(Attr):

    def combine_id(self, id : str) -> PCombo:
        descrip = self.solver.fresh_type_var()
        enviro = m().set(id, descrip)
        interp = self.solver.unify(self.plate.interp, descrip, self.plate.prescrip)
        return PCombo(enviro, descrip)

    def combine_unit(self) -> PCombo:
        descrip = TUnit()
        interp = self.solver.unify(self.plate.interp, descrip, self.plate.prescrip)
        return PCombo(m(), descrip)

    def combine_tag(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TTag(label, body.descrip))

class RecpatAttr(Attr):

    def combine_single(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TField(label, body.descrip))

    def combine_cons(self, label : str, body : PCombo, tail : PCombo) -> PCombo:
        return PCombo(body.enviro + tail.enviro, Inter(TField(label, body.descrip), tail.descrip))

class KeychainAttr(Attr):

    def combine_single(self, key : str) -> list[str]:
        # self.solver.unify(plate.enviro, plate.prescrip, TField(key, Top())) 
        return [key]

    '''
    return the plate with the prescription as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, key : str):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, TField(key, prescrip))
        return Plate(interp, self.plate.enviro, prescrip)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainAttr(Attr):

    def distill_single_content(self):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, Imp(prescrip, Top()))
        return Plate(interp, self.plate.enviro, prescrip)


    def distill_cons_head(self):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, Imp(prescrip, Top()))
        return Plate(interp, self.plate.enviro, prescrip)

    '''
    return the plate with the prescripation as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, head : Typ):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.unify(self.plate.interp, self.plate.prescrip, Imp(head, prescrip))
        return Plate(interp, self.plate.enviro, prescrip)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.unify(plate.enviro, plate.prescrip, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail