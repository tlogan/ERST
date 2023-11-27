from __future__ import annotations
from dataclasses import dataclass
from typing import *
from typing import Callable 
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

# from tapas.util_system import unbox, box  

from pyrsistent.typing import PMap 
from pyrsistent import m 

from contextlib import contextmanager


T = TypeVar('T')
R = TypeVar('R')


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

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Inter, Imp, Exis, Induc, Top, Bot]


@dataclass(frozen=True, eq=True)
class ECombo:
    descrip : Typ    

def mk_stack_machine(
    mk_plate : Callable[[T], tuple[list[T], Callable, list[R]]], 
) -> Callable[[T], R] :
    def run(start : T):
        result = None 
        stack : list[tuple[list[T], Callable, list[R]]]= [([start], (lambda x : x), [])]

        while len(stack) > 0 :
            (controls, combine, args) = stack.pop()

            if result:
                args.append(result)

            if len(controls) == 0:
                result = combine(*args)
            else:
                result = None 
                control = controls.pop(0)
                plate = mk_plate(control)
                stack.append((controls, combine, args))
                stack.append(plate)

            pass

        assert result
        return result
    return run


def concretize_type(typ : Typ) -> str:
    def mk_plate (control : Typ):
        if isinstance(control, TUnit):
            plate = ([], lambda: "unit", [])  
        if isinstance(control, TVar):
            plate = ([], lambda: control.id, [])  
        elif isinstance(control, Imp):
            plate = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})", [])  
        # Typ = Union[TVar, TUnit, TTag, TField, Inter, Imp, Exis, Induc, Top, Bot]
        else:
            assert False
        return plate

    return mk_stack_machine(mk_plate)(typ)





# """
# Pat data types
# """

# @dataclass(frozen=True, eq=True)
# class PVar:
#     id : str

# @dataclass(frozen=True, eq=True)
# class PUnit:
#     pass

# Expr = Union[PVar, PUnit]

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

@dataclass(frozen=True, eq=True)
class Nonterm:
    id : str 
    distillation : Distillation


# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
Interp = PMap[str, Typ]
Enviro = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class Distillation: 
    interp : Interp
    enviro : Enviro 
    prescrip : Typ

Guidance = Union[Symbol, Terminal, Nonterm]

distillation_default = Distillation(m(), m(), Top())

class Solver:
    _type_id : int = 0 

    # def __init__(self, type_id : int):
    #     self._type_id = type_id

    def fresh_type_var(self) -> Typ:
        self._type_id += 1
        return TVar(f"_{self._type_id}")

    # TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    # TODO: encode problem into Z3; decode back to Slim. 
    def solve(self, interp : Interp, lower : Typ, upper : Typ) -> Interp:
        '''
        TODO
        '''
        return interp 

class Attr:
    def __init__(self, solver : Solver, plate : Distillation):
        self.solver = solver
        self.plate = plate 



class BaseAttr(Attr):

    def combine_var(self, id : str) -> ECombo:
        return ECombo(self.plate.enviro[id])

    def combine_unit(self) -> ECombo:
        return ECombo(TUnit())

    def distill_tag_body(self, id : str) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, TTag(id, prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip)

    def combine_tag(self, label : str, body : ECombo) -> ECombo:
        return ECombo(TTag(label, body.descrip))

class ExprAttr(Attr):

    def distill_tuple_left(self) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField('left', prescrip), TField('right', Bot())), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def distill_tuple_right(self, left : ECombo) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField('left', left.descrip), TField('right', prescrip)), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_tuple(self, left : ECombo, right : ECombo) -> ECombo:
        return ECombo(Inter(TField('left', left.descrip), TField('right', right.descrip)))

    # TODO: remove
    # def combine_projection(self, record : Typ, key : str) -> Typ: 
    #     answr = self.solver.fresh_type_var()
    #     interp = self.solver.solve(self.plate.interp, record, TField(key, answr))
    #     return Exis(answr, interp)

    def distill_projection_cator(self) -> Distillation:
        return Distillation(self.plate.interp, self.plate.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Distillation: 
        return Distillation(self.plate.interp, self.plate.enviro, record)


    def combine_projection(self, record : ECombo, keys : list[str]) -> ECombo: 
        interp_i = self.plate.interp
        answr_i = record.descrip 
        for key in keys:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_application_cator(self) -> Distillation: 
        return Distillation(self.plate.interp, self.plate.enviro, Imp(Bot(), Top()))

    def distill_application_argchain(self, function : ECombo) -> Distillation: 
        return Distillation(self.plate.interp, self.plate.enviro, function.descrip)

    def combine_application(self, function : ECombo, arguments : list[ECombo]) -> ECombo: 
        interp_i = self.plate.interp
        answr_i = function.descrip 
        for argument in arguments:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, Imp(argument.descrip, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    def distill_fix_body(self) -> Distillation:
        return Distillation(self.plate.interp, self.plate.enviro, Top())

    def combine_fix(self, body : ECombo) -> ECombo:
        return ECombo(Induc(body.descrip))
    
    def distill_let_target(self, id : str) -> Distillation:
        return Distillation(self.plate.interp, self.plate.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Distillation:
        interp = self.plate.interp
        '''
        TODO: generalize target
        - avoid overgeneralizing by not abstracting variables introduced before target
        '''
        enviro = self.plate.enviro.set(id, target)
        return Distillation(interp, enviro, self.plate.prescrip)
'''
end ExprAttr
'''


class RecordAttr(Attr):

    def distill_single_body(self, id : str) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, TField(id, prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_single(self, id : str, body : ECombo) -> ECombo:
        return ECombo(TField(id, body.descrip)) 

    def distill_cons_body(self, id : str) -> Distillation:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : ECombo) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField(id, body.descrip), prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_cons(self, id : str, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(TField(id, body.descrip), tail.descrip))

class FunctionAttr(Attr):

    def distill_single_pattern(self) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, Imp(prescrip, Top()))
        return Distillation(interp, self.plate.enviro, prescrip)

    def distill_single_body(self, pattern : PCombo) -> Distillation:
        conclusion = self.solver.fresh_type_var() 

        """
        TODO: solve to the consequent of the prescriped type: solve(guide.typ, Imp(typ_in, typ_out))
        can basically move antecedent into qualifier of consequent 
        e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
        """
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, Imp(pattern.descrip, conclusion)) 
        enviro = self.plate.enviro + pattern.enviro
        return Distillation(interp, enviro, conclusion)

    def combine_single(self, pattern : PCombo, body : ECombo) -> ECombo:
        return ECombo(Imp(pattern.descrip, body.descrip))

    def distill_cons_pattern(self) -> Distillation:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PCombo) -> Distillation:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PCombo, body : ECombo) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(Imp(pattern.descrip, body.descrip), prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip)

    def combine_cons(self, pattern : PCombo, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(Imp(pattern.descrip, body.descrip), tail.descrip))

    #####################

    # def distill_function_body(self, param : str) -> Distillation:
    #     '''
    #     TODO: decompose guide.typ into prescribed typ of the body
    #     '''
    #     typ_in = self.fresh_type_var()
    #     typ_out = self.fresh_type_var()
    #     """
    #     TODO: solve to the consequent of the prescriped type: solve(guide.typ, Imp(typ_in, typ_out))
    #     can basically move antecedent into qualifier of consequent 
    #     e.g. A -> B & C -> D becomes X -> ({B with X <: A} | {D with X <: C} ) 
    #     """
    #     interp = self.solve(plate.interp, plate.prescrip, Imp(typ_in, typ_out)) 
    #     enviro = plate.enviro.set(param, typ_in)

    #     return Distillation(interp, enviro, typ_out)


    # def combine_function(self, param : str, body : ECombo) -> ECombo:
    #     antec = plate.enviro[param]
    #     consq = body.descrip
    #     return ECombo(Imp(antec, consq))

    #####################


class KeychainAttr(Attr):

    def combine_single(self, key : str) -> list[str]:
        # self.solver.solve(plate.enviro, plate.prescrip, TField(key, Top())) 
        return [key]

    '''
    return the plate with the prescription as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, key : str):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, TField(key, prescrip))
        return Distillation(interp, self.plate.enviro, prescrip)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainAttr(Attr):

    def distill_single_content(self):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, Imp(prescrip, Top()))
        return Distillation(interp, self.plate.enviro, prescrip)


    def distill_cons_head(self):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, Imp(prescrip, Top()))
        return Distillation(interp, self.plate.enviro, prescrip)

    '''
    return the plate with the prescripation as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, head : Typ):
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, self.plate.prescrip, Imp(head, prescrip))
        return Distillation(interp, self.plate.enviro, prescrip)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.prescrip, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail


'''
start Pattern Attributes
'''

class PatternAttr(Attr):
    def distill_tuple_left(self) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField('left', prescrip), TField('right', Bot())), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def distill_tuple_right(self, left : PCombo) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField('left', left.descrip), TField('right', prescrip)), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_tuple(self, left : PCombo, right : PCombo) -> PCombo:
        return PCombo(left.enviro + right.enviro, Inter(TField('left', left.descrip), TField('right', right.descrip)))

'''
end PatternAttr
'''

class PatternBaseAttr(Attr):

    def combine_var(self, id : str) -> PCombo:
        descrip = self.solver.fresh_type_var()
        enviro = m().set(id, descrip)
        interp = self.solver.solve(self.plate.interp, descrip, self.plate.prescrip)
        return PCombo(enviro, descrip)

    def combine_unit(self) -> PCombo:
        descrip = TUnit()
        interp = self.solver.solve(self.plate.interp, descrip, self.plate.prescrip)
        return PCombo(m(), descrip)

    def distill_tag_body(self, id : str) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, TTag(id, prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip)

    def combine_tag(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TTag(label, body.descrip))
'''
end PatternBaseAttr
'''

class PatternRecordAttr(Attr):

    def distill_single_body(self, id : str) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, TField(id, prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_single(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TField(label, body.descrip))

    def distill_cons_body(self, id : str) -> Distillation:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PCombo) -> Distillation:
        prescrip = self.solver.fresh_type_var()
        interp = self.solver.solve(self.plate.interp, Inter(TField(id, body.descrip), prescrip), self.plate.prescrip)
        return Distillation(interp, self.plate.enviro, prescrip) 

    def combine_cons(self, label : str, body : PCombo, tail : PCombo) -> PCombo:
        return PCombo(body.enviro + tail.enviro, Inter(TField(label, body.descrip), tail.descrip))
