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
class PatternAttr:
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
    interp : Interp
    enviro : Enviro 
    typ : Typ


# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
Interp = PMap[str, Typ]
Enviro = PMap[str, Typ]


Guidance = Union[Symbol, Terminal, Nonterm]

nt_default = Nonterm('expr', m(), m(), Top())

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

class Rule:
    def __init__(self, solver : Solver, nt : Nonterm):
        self.solver = solver
        self.nt = nt 



class BaseRule(Rule):

    def combine_var(self, id : str) -> Typ:
        return self.nt.enviro[id]

    def combine_unit(self) -> Typ:
        return TUnit()

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, TTag(id, typ), self.nt.typ)
        return Nonterm('expr', interp, self.nt.enviro, typ)

    def combine_tag(self, label : str, body : Typ) -> Typ:
        return TTag(label, body)

class ExprRule(Rule):

    def distill_tuple_head(self) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        return Nonterm('expr', interp, self.nt.enviro, typ) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField('head', head), TField('tail', typ)), self.nt.typ)
        return Nonterm('expr', interp, self.nt.enviro, typ) 

    def combine_tuple(self, head : Typ, tail : Typ) -> Typ:
        return Inter(TField('head', head), TField('tail', tail))

    def distill_ite_condition(self) -> Nonterm:
        typ = Unio(TTag('false', TUnit()), TTag('true', TUnit()))
        return Nonterm('expr', self.nt.interp, self.nt.enviro, typ)

    def distill_ite_branch_true(self, condition : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :true? case given (condition : A), and unrefined prescription B.
        (:true? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('true', TUnit()), typ) 
        premise_conclusion = Imp(condition, self.nt.typ)
        interp = self.solver.solve(self.nt.interp, implication, premise_conclusion)
        return Nonterm('expr', interp, self.nt.enviro, typ) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ) 
        premise_conclusion = Imp(condition, self.nt.typ)
        interp = self.solver.solve(self.nt.interp, implication, premise_conclusion)
        return Nonterm('expr', interp, self.nt.enviro, typ) 

    def combine_ite(self, condition : Typ, branch_true : Typ, branch_false : Typ) -> Typ: 
        interp_true = self.solver.solve(self.nt.interp, condition, TTag('true', TUnit()))
        interp_false = self.solver.solve(self.nt.interp, condition, TTag('false', TUnit()))
        return Unio(
            Exis(branch_true, interp_true), 
            Exis(branch_false, interp_false)
        )

    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.interp, self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.interp, self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        interp_i = self.nt.interp
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, TField(key, answr))
            answr_i = answr

        return Exis(answr_i, interp_i)

    #########

    def distill_application_cator(self) -> Nonterm: 
        return Nonterm('expr', self.nt.interp, self.nt.enviro, Imp(Bot(), Top()))

    def distill_application_argchain(self, cator : Typ) -> Nonterm: 
        return Nonterm('argchain', self.nt.interp, self.nt.enviro, cator)

    def combine_application(self, cator : Typ, arguments : list[Typ]) -> Typ: 
        interp_i = self.nt.interp
        answr_i = cator 
        for argument in arguments:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, answr_i, Imp(argument, answr))
            answr_i = answr

        return Exis(answr_i, interp_i)


    #########
    def distill_funnel_arg(self) -> Nonterm: 
        return Nonterm('expr', self.nt.interp, self.nt.enviro, Top())

    def distill_funnel_pipeline(self, arg : Typ) -> Nonterm: 
        return Nonterm('pipeline', self.nt.interp, self.nt.enviro, arg)

    def combine_funnel(self, arg : Typ, cators : list[Typ]) -> Typ: 
        interp_i = self.nt.interp
        answr_i = arg 
        for cator in cators:
            answr = self.solver.fresh_type_var()
            interp_i = self.solver.solve(interp_i, Imp(answr_i, answr), cator)
            answr_i = answr

        return Exis(answr_i, interp_i)
    #########


    def distill_fix_body(self) -> Nonterm:
        return Nonterm('expr', self.nt.interp, self.nt.enviro, Top())

    def combine_fix(self, body : Typ) -> Typ:
        return Induc(body)
    
    def distill_let_target(self, id : str) -> Nonterm:
        return Nonterm('target', self.nt.interp, self.nt.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Nonterm:
        interp = self.nt.interp
        '''
        TODO: generalize target
        - avoid overgeneralizing by not abstracting variables introduced before target
        '''
        enviro = self.nt.enviro.set(id, target)
        return Nonterm('expr', interp, enviro, self.nt.typ)
'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, TField(id, typ), self.nt.typ)
        return Nonterm('expr', interp, self.nt.enviro, typ) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField(id, body), typ), self.nt.typ)
        return Nonterm('record', interp, self.nt.enviro, typ) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, self.nt.typ, Imp(typ, Top()))
        return Nonterm('pattern', interp, self.nt.enviro, typ)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        conclusion = self.solver.fresh_type_var() 
        interp = self.solver.solve(self.nt.interp, self.nt.typ, Imp(pattern.typ, conclusion)) 
        enviro = self.nt.enviro + pattern.enviro
        return Nonterm('expr', interp, enviro, conclusion)

    def combine_single(self, pattern : PatternAttr, body : Typ) -> Typ:
        return Imp(pattern.typ, body)

    def distill_cons_pattern(self) -> Nonterm:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PatternAttr) -> Nonterm:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PatternAttr, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(Imp(pattern.typ, body), typ), self.nt.typ)
        return Nonterm('function', interp, self.nt.enviro, typ)

    def combine_cons(self, pattern : PatternAttr, body : Typ, tail : Typ) -> Typ:
        return Inter(Imp(pattern.typ, body), tail)


class KeychainRule(Rule):

    def combine_single(self, key : str) -> list[str]:
        # self.solver.solve(plate.enviro, plate.typ, TField(key, Top())) 
        return [key]

    '''
    return the plate with the tyption as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, key : str):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, self.nt.typ, TField(key, typ))
        return Nonterm('keychain', interp, self.nt.enviro, typ)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, self.nt.typ, Imp(typ, Top()))
        return Nonterm('expr', interp, self.nt.enviro, typ)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, self.nt.typ, Imp(typ, Top()))
        return Nonterm('expr', interp, self.nt.enviro, typ)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        interp = self.solver.solve(self.nt.interp, self.nt.typ, Imp(head, typ))
        return Nonterm('argchain', interp, self.nt.enviro, typ)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail

######

class PipelineRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, typ, Imp(self.nt.typ, Top()))
        return Nonterm('expr', interp, self.nt.enviro, typ)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, typ, Imp(self.nt.typ, Top()))
        return Nonterm('expr', interp, self.nt.enviro, typ)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        interp = self.solver.solve(self.nt.interp, head, Imp(self.nt.typ, typ))

        return Nonterm('pipeline', interp, self.nt.enviro, typ)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail


'''
start Pattern Ruleibutes
'''

class PatternRule(Rule):
    def distill_tuple_head(self) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        return Nonterm('pattern', interp, self.nt.enviro, typ) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField('head', head.typ), TField('tail', typ)), self.nt.typ)
        return Nonterm('pattern', interp, self.nt.enviro, typ) 

    def combine_tuple(self, head : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(head.enviro + tail.enviro, Inter(TField('head', head.typ), TField('tail', tail.typ)))

'''
end PatternRule
'''

class PatternBaseRule(Rule):

    def combine_var(self, id : str) -> PatternAttr:
        typ = self.solver.fresh_type_var()
        enviro = m().set(id, typ)
        interp = self.solver.solve(self.nt.interp, typ, self.nt.typ)
        return PatternAttr(enviro, typ)

    def combine_unit(self) -> PatternAttr:
        typ = TUnit()
        interp = self.solver.solve(self.nt.interp, typ, self.nt.typ)
        return PatternAttr(m(), typ)

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        print(f'OOGA: {self.nt}')
        interp = self.solver.solve(self.nt.interp, TTag(id, typ), self.nt.typ)
        return Nonterm('pattern', interp, self.nt.enviro, typ)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, TField(id, typ), self.nt.typ)
        return Nonterm('pattern_record', interp, self.nt.enviro, typ) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        interp = self.solver.solve(self.nt.interp, Inter(TField(id, body.typ), typ), self.nt.typ)
        return Nonterm('pattern_record', interp, self.nt.enviro, typ) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
