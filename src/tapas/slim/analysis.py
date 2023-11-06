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

class Analyzer:

    _type_id : int = 0 

    # def __init__(self, type_id : int):
    #     self._type_id = type_id

    def fresh_type_var(self) -> Typ:
        self._type_id += 1
        return TVar(f"_{self._type_id}")


    def combine_expr_id(self, plate : Plate, text : str) -> ECombo:
        return ECombo(plate.enviro[text])

    def combine_expr_unit(self, plate : Plate) -> ECombo:
        return ECombo(TUnit())

    def combine_expr_tag(self, plate : Plate, label : str, body : ECombo) -> ECombo:
        return ECombo(TTag(label, body.descrip))

    def combine_record_single(self, plate : Plate, label : str, body : ECombo) -> ECombo:
        return ECombo(TField(label, body.descrip)) 

    def combine_record_cons(self, plate : Plate, label : str, body : ECombo, cons : ECombo) -> ECombo:
        return ECombo(Inter(TField(label, body.descrip), cons.descrip))

    def combine_expr_projection(self, plate : Plate, record : Typ, key : str) -> Typ: 
        answr = self.fresh_type_var()
        interp = self.unify(plate.interp, record, TField(key, answr))
        return Exis(answr, interp)

    #####################

    def distill_function_single_pattern(self, plate : Plate) -> Plate:
        antec = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.prescrip, Imp(antec, Top()))
        return Plate(interp, plate.enviro, antec)


    def distill_function_single_body(self, plate : Plate, pattern : PCombo) -> Plate:
        conclusion = self.fresh_type_var() 

        """
        TODO: unify to the consequent of the prescriped type: unify(guide.typ, Imp(typ_in, typ_out))
        can basically move antecedent into qualifier of consequent 
        e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
        """
        interp = self.unify(plate.interp, plate.prescrip, Imp(pattern.descrip, conclusion)) 
        enviro = plate.enviro + pattern.enviro
        return Plate(interp, enviro, conclusion)

    def combine_function_single(self, plate : Plate, pattern : PCombo, body : ECombo) -> ECombo:
        return ECombo(Imp(pattern.descrip, body.descrip))

    def combine_function_cons(self, plate : Plate, pattern : PCombo, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(Imp(pattern.descrip, body.descrip), tail.descrip))

    #####################

    # def distill_expr_function_body(self, plate : Plate, param : str) -> Plate:
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


    # def combine_expr_function(self, plate : Plate, param : str, body : ECombo) -> ECombo:
    #     antec = plate.enviro[param]
    #     consq = body.descrip
    #     return ECombo(Imp(antec, consq))

    #####################

    def combine_pattern_id(self, plate : Plate, id : str) -> PCombo:
        descrip = self.fresh_type_var()
        enviro = m().set(id, descrip)
        interp = self.unify(plate.interp, descrip, plate.prescrip)
        return PCombo(enviro, descrip)

    def combine_pattern_unit(self, plate : Plate) -> PCombo:
        descrip = TUnit()
        interp = self.unify(plate.interp, descrip, plate.prescrip)
        return PCombo(m(), descrip)

    def combine_pattern_tag(self, plate : Plate, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TTag(label, body.descrip))

    #####################

    def combine_recpat_single(self, plate : Plate, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TField(label, body.descrip))

    def combine_recpat_cons(self, plate : Plate, label : str, body : PCombo, tail : PCombo) -> PCombo:
        return PCombo(body.enviro + tail.enviro, Inter(TField(label, body.descrip), tail.descrip))

    #####################

    def distill_expr_projmulti_cator(self, plate : Plate) -> Plate:
        return Plate(plate.interp, plate.enviro, Top())

    def distill_expr_projmulti_keychain(self, plate : Plate, record : Typ) -> Plate: 
        return Plate(plate.interp, plate.enviro, record)


    def combine_expr_projmulti(self, plate : Plate, record : ECombo, keys : list[str]) -> ECombo: 
        interp_i = plate.interp
        answr_i = record.descrip 
        for key in keys:
            answr = self.fresh_type_var()
            interp_i = self.unify(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_expr_idprojmulti_keychain(self, plate : Plate, id : str) -> Plate: 
        return self.distill_expr_projmulti_keychain(plate, plate.enviro[id])

    def combine_expr_idprojmulti(self, plate : Plate, id : str, keys : list[str]) -> ECombo: 
        return self.combine_expr_projmulti(plate, ECombo(plate.enviro[id]), keys)


    def combine_keychain_single(self, plate : Plate, key : str) -> list[str]:
        # self.unify(plate.enviro, plate.prescrip, TField(key, Top())) 
        return [key]

    '''
    return the plate with the prescription as the type that the next element in tail cuts
    '''
    def distill_keychain_cons_tail(self, plate : Plate, key : str):
        prescrip = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.prescrip, TField(key, prescrip))
        return Plate(interp, plate.enviro, prescrip)

    def combine_keychain_cons(self, plate : Plate, key : str, keys : list[str]) -> list[str]:
        return self.combine_keychain_single(plate, key) + keys

    def distill_expr_appmulti_cator(self, plate : Plate) -> Plate: 
        return Plate(plate.interp, plate.enviro, Imp(Bot(), Top()))

    def distill_expr_appmulti_argchain(self, plate : Plate, function : ECombo) -> Plate: 
        return Plate(plate.interp, plate.enviro, function.descrip)

    def combine_expr_appmulti(self, plate : Plate, function : ECombo, arguments : list[ECombo]) -> ECombo: 
        interp_i = plate.interp
        answr_i = function.descrip 
        for argument in arguments:
            answr = self.fresh_type_var()
            interp_i = self.unify(interp_i, answr_i, Imp(argument.descrip, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_argchain_single_content(self, plate : Plate):
        prescrip = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.prescrip, Imp(prescrip, Top()))
        return Plate(interp, plate.enviro, prescrip)


    def distill_argchain_cons_head(self, plate : Plate):
        prescrip = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.prescrip, Imp(prescrip, Top()))
        return Plate(interp, plate.enviro, prescrip)

    '''
    return the plate with the prescripation as the type that the next element in tail cuts
    '''
    def distill_argchain_cons_tail(self, plate : Plate, head : Typ):
        prescrip = self.fresh_type_var()
        interp = self.unify(plate.interp, plate.prescrip, Imp(head, prescrip))
        return Plate(interp, plate.enviro, prescrip)

    def combine_argchain_single(self, plate : Plate, content : Typ) -> list[Typ]:
        # self.unify(plate.enviro, plate.prescrip, Imp(content, Top()))
        return [content]

    def combine_argchain_cons(self, plate : Plate, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_argchain_single(plate, head) + tail

    def distill_expr_idappmulti_argchain(self, plate : Plate, id : str) -> Plate: 
        function = ECombo(plate.enviro[id])
        return self.distill_expr_appmulti_argchain(plate, function)



    def combine_expr_idappmulti(self, plate : Plate, id : str, arguments : list[ECombo]) -> ECombo: 
        function = ECombo(plate.enviro[id])
        return self.combine_expr_appmulti(plate, function, arguments)

    def distill_expr_fix_body(self, plate : Plate) -> Plate:
        return Plate(plate.interp, plate.enviro, Top())

    def combine_expr_fix(self, plate : Plate, body : ECombo) -> ECombo:
        return ECombo(Induc(body.descrip))
    

    def distill_expr_let_body(self, plate : Plate, id : str, target : Typ) -> Plate:
        interp = plate.interp
        enviro = plate.enviro.set(id, target)
        return Plate(interp, enviro, plate.prescrip)


    """
    Unification 
    """

    # TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    # TODO: encode problem into Z3; decode back to Slim. 
    def unify(self, interp : Interp, lower : Typ, upper : Typ) -> Interp:
        return interp 