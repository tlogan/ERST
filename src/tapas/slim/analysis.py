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
# Field ==> - :uno = expr :uno = expr
# TField ==> uno : typ & dos : typ 
# Tag  ==> :tag :tag :tag typ 
# TTag  ==> ^cons x * ^cons y * ^nil unit 
# TTag  ==> :cons x, :cons y, :nil unit 

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
class Unio:
    left : Typ 
    right : Typ 

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

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Imp, Exis, Induc, Top, Bot]


@dataclass(frozen=True, eq=True)
class ECombo:
    typ : Typ    

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
    typ : Typ    


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
    disn : Distillation


# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
Interp = PMap[str, Typ]
Enviro = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class Distillation: 
    interp : Interp
    enviro : Enviro 
    typ : Typ

Guidance = Union[Symbol, Terminal, Nonterm]

disn_default = Distillation(m(), m(), Top())

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

        '''
        TODO:
        solve (LOWER <: ARG -> RESULT) for RESULT by rewriting and applying modus ponens
        e.g. lower = A -> B & C -> D becomes lower = X -> ({B with X <: A} | {D with X <: C} ) 
        '''

        '''
        NOTE: (T |= T) type satisfaction represents subset inclusion of interpretations for types inhabited by some term
        '''

        '''
        NOTE: (x : T |= x : T) typing satisfaction represents subset inclusion of interpretations for types inhabited by then given term
        '''

        '''
        NOTE: (T <: T |= T <: T) subtyping satisfaction represents subset inclusion of interpretations for subtyping
        '''

        '''
        NOTE: (M |- T <: T) subtyping entailment represents subset inclusion of terms that inhabit types for some interpretation
        '''

        '''
        NOTE: (M |- x : T) typing entailment represents inhabitation of a term in a types for some interpretation
        '''

        '''
        A |= P
        P -> Q, A |= B  
        -- corresponds to --
        (A <: P) |= (B <: Q) 
        -- corresponds to --
        M |- A <: P
        M |- Q <: B
        -- corresponds to --
        M |- (P -> Q) <: (A -> B) 
        '''

        return interp 

class Attr:
    def __init__(self, solver : Solver, disn : Distillation):
        self.solver = solver
        self.disn = disn 



class BaseAttr(Attr):

    def combine_var(self, id : str) -> ECombo:
        return ECombo(self.disn.enviro[id])

    def combine_unit(self) -> ECombo:
        return ECombo(TUnit())

    def distill_tag_body(self, id : str) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, TTag(id, typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ)

    def combine_tag(self, label : str, body : ECombo) -> ECombo:
        return ECombo(TTag(label, body.typ))

class ExprAttr(Attr):

    def distill_tuple_head(self) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField('head', typ), TField('tail', Bot())), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def distill_tuple_tail(self, head : ECombo) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField('head', head.typ), TField('tail', typ)), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_tuple(self, head : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(TField('head', head.typ), TField('tail', tail.typ)))

    def distill_ite_condition(self) -> Distillation:
        typ = Unio(TTag('false', TUnit()), TTag('true', TUnit()))
        return Distillation(self.disn.interp, self.disn.enviro, typ)

    def distill_ite_branch_true(self, condition : ECombo) -> Distillation:
        '''
        Find refined prescription Q in the :true? case given (condition : A), and unrefined prescription B.
        (:true? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('true', TUnit()), typ) 
        premise_conclusion = Imp(condition.typ, self.disn.typ)
        interp = self.solver.solve(self.disn.interp, implication, premise_conclusion)
        return Distillation(interp, self.disn.enviro, typ) 

    def distill_ite_branch_false(self, condition : ECombo, branch_true : ECombo) -> Distillation:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ) 
        premise_conclusion = Imp(condition.typ, self.disn.typ)
        interp = self.solver.solve(self.disn.interp, implication, premise_conclusion)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_ite(self, condition : ECombo, branch_true : ECombo, branch_false : ECombo) -> ECombo: 
        interp_true = self.solver.solve(self.disn.interp, condition.typ, TTag('true', TUnit()))
        interp_false = self.solver.solve(self.disn.interp, condition.typ, TTag('false', TUnit()))
        return ECombo(Unio(
            Exis(branch_true.typ, interp_true), 
            Exis(branch_false.typ, interp_false)
        ))

    def distill_projection_cator(self) -> Distillation:
        return Distillation(self.disn.interp, self.disn.enviro, Top())

    def distill_projection_keychain(self, record : ECombo) -> Distillation: 
        return Distillation(self.disn.interp, self.disn.enviro, record.typ)


    def combine_projection(self, record : ECombo, keys : list[str]) -> ECombo: 
        interp_i = self.disn.interp
        answr_i = record.typ 
        for key in keys:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))

    #########

    def distill_application_cator(self) -> Distillation: 
        return Distillation(self.disn.interp, self.disn.enviro, Imp(Bot(), Top()))

    def distill_application_argchain(self, cator : ECombo) -> Distillation: 
        return Distillation(self.disn.interp, self.disn.enviro, cator.typ)

    def combine_application(self, cator : ECombo, arguments : list[ECombo]) -> ECombo: 
        interp_i = self.disn.interp
        answr_i = cator.typ 
        for argument in arguments:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, Imp(argument.typ, answr))
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))


    #########
    def distill_funnel_arg(self) -> Distillation: 
        return Distillation(self.disn.interp, self.disn.enviro, Top())

    def distill_funnel_pipeline(self, arg : ECombo) -> Distillation: 
        return Distillation(self.disn.interp, self.disn.enviro, arg.typ)

    def combine_funnel(self, arg : ECombo, cators : list[ECombo]) -> ECombo: 
        interp_i = self.disn.interp
        answr_i = arg.typ 
        for cator in cators:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, Imp(answr_i, answr), cator.typ)
            answr_i = answr

        return ECombo(Exis(answr_i, interp_i))
    #########


    def distill_fix_body(self) -> Distillation:
        return Distillation(self.disn.interp, self.disn.enviro, Top())

    def combine_fix(self, body : ECombo) -> ECombo:
        return ECombo(Induc(body.typ))
    
    def distill_let_target(self, id : str) -> Distillation:
        return Distillation(self.disn.interp, self.disn.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Distillation:
        interp = self.disn.interp
        '''
        TODO: generalize target
        - avoid overgeneralizing by not abstracting variables introduced before target
        '''
        enviro = self.disn.enviro.set(id, target)
        return Distillation(interp, enviro, self.disn.typ)
'''
end ExprAttr
'''


class RecordAttr(Attr):

    def distill_single_body(self, id : str) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, TField(id, typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_single(self, id : str, body : ECombo) -> ECombo:
        return ECombo(TField(id, body.typ)) 

    def distill_cons_body(self, id : str) -> Distillation:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : ECombo) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField(id, body.typ), typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_cons(self, id : str, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(TField(id, body.typ), tail.typ))

class FunctionAttr(Attr):

    def distill_single_pattern(self) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, self.disn.typ, Imp(typ, Top()))
        return Distillation(interp, self.disn.enviro, typ)

    def distill_single_body(self, pattern : PCombo) -> Distillation:
        conclusion = self.solver.fresh_type_var() 
        interp = self.solver.solve(self.disn.interp, self.disn.typ, Imp(pattern.typ, conclusion)) 
        enviro = self.disn.enviro + pattern.enviro
        return Distillation(interp, enviro, conclusion)

    def combine_single(self, pattern : PCombo, body : ECombo) -> ECombo:
        return ECombo(Imp(pattern.typ, body.typ))

    def distill_cons_pattern(self) -> Distillation:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PCombo) -> Distillation:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PCombo, body : ECombo) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(Imp(pattern.typ, body.typ), typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ)

    def combine_cons(self, pattern : PCombo, body : ECombo, tail : ECombo) -> ECombo:
        return ECombo(Inter(Imp(pattern.typ, body.typ), tail.typ))


class KeychainAttr(Attr):

    def combine_single(self, key : str) -> list[str]:
        # self.solver.solve(plate.enviro, plate.typ, TField(key, Top())) 
        return [key]

    '''
    return the plate with the tyption as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, key : str):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, self.disn.typ, TField(key, typ))
        return Distillation(interp, self.disn.enviro, typ)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainAttr(Attr):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, self.disn.typ, Imp(typ, Top()))
        return Distillation(interp, self.disn.enviro, typ)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, self.disn.typ, Imp(typ, Top()))
        return Distillation(interp, self.disn.enviro, typ)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        interp = self.solver.solve(self.disn.interp, self.disn.typ, Imp(head, typ))
        return Distillation(interp, self.disn.enviro, typ)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail

######

class PipelineAttr(Attr):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, typ, Imp(self.disn.typ, Top()))
        return Distillation(interp, self.disn.enviro, typ)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, typ, Imp(self.disn.typ, Top()))
        return Distillation(interp, self.disn.enviro, typ)

    def distill_cons_tail(self, head : ECombo):
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        interp = self.solver.solve(self.disn.interp, head.typ, Imp(self.disn.typ, typ))

        return Distillation(interp, self.disn.enviro, typ)

    def combine_single(self, content : ECombo) -> list[ECombo]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : ECombo, tail : list[ECombo]) -> list[ECombo]:
        return self.combine_single(head) + tail


'''
start Pattern Attributes
'''

class PatternAttr(Attr):
    def distill_tuple_head(self) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField('head', typ), TField('tail', Bot())), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def distill_tuple_tail(self, head : PCombo) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField('head', head.typ), TField('tail', typ)), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_tuple(self, head : PCombo, tail : PCombo) -> PCombo:
        return PCombo(head.enviro + tail.enviro, Inter(TField('head', head.typ), TField('tail', tail.typ)))

'''
end PatternAttr
'''

class PatternBaseAttr(Attr):

    def combine_var(self, id : str) -> PCombo:
        typ = self.solver.fresh_type_var()
        enviro = m().set(id, typ)
        interp = self.solver.solve(self.disn.interp, typ, self.disn.typ)
        return PCombo(enviro, typ)

    def combine_unit(self) -> PCombo:
        typ = TUnit()
        interp = self.solver.solve(self.disn.interp, typ, self.disn.typ)
        return PCombo(m(), typ)

    def distill_tag_body(self, id : str) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, TTag(id, typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ)

    def combine_tag(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TTag(label, body.typ))
'''
end PatternBaseAttr
'''

class PatternRecordAttr(Attr):

    def distill_single_body(self, id : str) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, TField(id, typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_single(self, label : str, body : PCombo) -> PCombo:
        return PCombo(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Distillation:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PCombo) -> Distillation:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.disn.interp, Inter(TField(id, body.typ), typ), self.disn.typ)
        return Distillation(interp, self.disn.enviro, typ) 

    def combine_cons(self, label : str, body : PCombo, tail : PCombo) -> PCombo:
        return PCombo(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
