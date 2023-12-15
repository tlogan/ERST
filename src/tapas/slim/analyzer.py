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

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset

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
class IdxUnio:
    ids : list[str]
    qualification : list[Subtyping] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class IdxInter:
    ids : list[str]
    qualification : list[Subtyping] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Least:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Greatest:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Imp, IdxUnio, IdxInter, Least, Greatest, Top, Bot]


@dataclass(frozen=True, eq=True)
class Subtyping:
    lower : Typ
    upper : Typ


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

def concretize_ids(ids : list[str]) -> str:
    return ", ".join(ids)

def concretize_qualification(subtypings : list[Subtyping]) -> str:
    return ", ".join([
        concretize_typ(st.lower) + " <: " + concretize_typ(st.upper)
        for st in subtypings
    ])

def concretize_typ(typ : Typ) -> str:
    def mk_plate (control : Typ):
        if False: 
            pass
        elif isinstance(control, TVar):
            plate = ([], lambda: control.id, [])  
        elif isinstance(control, TUnit):
            plate = ([], lambda: "@", [])  
        elif isinstance(control, TTag):
            plate = ([control.body], lambda body : f":{control.label} {body}", [])  
        elif isinstance(control, TField):
            plate = ([control.body], lambda body : f"{control.label} : {body}", [])  
        elif isinstance(control, Imp):
            plate = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})", [])  
        elif isinstance(control, Unio):
            plate = ([control.left,control.right], lambda left, right : f"({left} | {right})", [])  
        elif isinstance(control, Inter):
            plate = ([control.left,control.right], lambda left, right : f"({left} & {right})", [])  
        elif isinstance(control, IdxUnio):
            qualification = concretize_qualification(control.qualification)
            ids = concretize_ids(control.ids)
            plate = ([control.body], lambda body : f"{{{ids} . {qualification}}} {body}", [])  
        elif isinstance(control, IdxInter):
            qualification = concretize_qualification(control.qualification)
            ids = concretize_ids(control.ids)
            plate = ([control.body], lambda body : f"[{ids} . {qualification}] {body}", [])  
        elif isinstance(control, Least):
            id = control.id
            plate = ([control.body], lambda body : f"least {id} with {body}", [])  
        elif isinstance(control, Greatest):
            id = control.id
            plate = ([control.body], lambda body : f"greatest {id} of {body}", [])  
        elif isinstance(control, Top):
            plate = ([], lambda: "top", [])  
        elif isinstance(control, Bot):
            plate = ([], lambda: "bot", [])  

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
    enviro : Enviro 
    typ : Typ


# TODO: the interpretation could map type patterns to types, rather than merely strings
# -- in order to handle subtyping of relational types
# Interp = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class Model:
    _constraints : PSet[Subtyping]

    def add(self, constraint : Subtyping) -> Model:
        return Model(self._constraints.add(constraint))


def by_variable(constraints : PSet[Subtyping], key : str) -> PSet[Subtyping]: 
    return pset((
        st
        for st in constraints
        if contains(st.lower, key)
    )) 


def contains(typ : Typ, var : str) -> bool:
    # TODO: check if the type variable exists in type
    return False


Enviro = PMap[str, Typ]


Guidance = Union[Symbol, Terminal, Nonterm]

nt_default = Nonterm('expr', m(), Top())

class Solver:
    _type_id : int = 0 

    # def __init__(self, type_id : int):
    #     self._type_id = type_id

    def fresh_type_var(self) -> TVar:
        self._type_id += 1
        return TVar(f"_{self._type_id}")

    def mk_renaming(self, old_ids) -> PMap[str, str]:
        '''
        Map old_ids to fresh ids
        '''
        d = {}
        for old_id in old_ids:
            fresh = self.fresh_type_var()
            d[old_id] = fresh.id

        return pmap(d)

    def rename_constraints(self, renaming : PMap[str, str], constraints : list[Subtyping]) -> list[Subtyping]:
        '''
        # TODO
        '''
        return []

    def rename_typ(self, renaming : PMap[str, str], typ : Typ) -> Typ:
        '''
        # TODO: remove bound variables from renaming as it deepens
        '''
        return Top()

    '''
    TODO: if using custom unification logic, then use while loop to avoid recursion limit 
    TODO: encode problem into Z3; decode back to Slim. 
    TODO: an interpretation could be constraints indexed by their LHS free variables
    TODO: constraints should be stored in simplified form 
    TODO: LHS must be simple pattern: variable; tag; fields; intersection 
    '''

    '''
    NOTE: constraints with type variables are simply added to the model
        - construction of an assignment is handled in the grounding procedure
        - for a variable that exists on the RHS, its assignment becomes the union of its LHSs
        - for a variable that exists on the LHS, its assignment becomes the intersection of its RHSs
    '''

    def solve(self, model : Model, lower : Typ, upper : Typ) -> list[Model]:


        if False: 
            return [] 

        elif isinstance(upper, TVar): 
            return [model.add(Subtyping(lower, upper))] 

        elif isinstance(lower, TVar): 
            return [model.add(Subtyping(lower, upper))] 

        elif isinstance(upper, Top): 
            return [model] 

        elif isinstance(lower, Bot): 
            return [model] 

        elif isinstance(upper, IdxUnio): 
            renaming = self.mk_renaming(upper.ids)
            constraints = self.rename_constraints(renaming, upper.qualification)
            body = self.rename_typ(renaming, upper.body)

            result = []
            for st in constraints:
                sol = self.solve(model, lower, body)
                lower_c = self.ground(sol, st.lower)
                upper_c = self.ground(sol, st.upper)
                result += self.solve(model, lower_c, upper_c)
            return result

        elif isinstance(lower, IdxInter): 
            renaming = self.mk_renaming(lower.ids)
            constraints = self.rename_constraints(renaming, lower.qualification)
            body = self.rename_typ(renaming, lower.body)

            result = []
            for st in constraints:
                sol = self.solve(model, body, upper)
                lower_c = self.ground(sol, st.lower)
                upper_c = self.ground(sol, st.upper)
                result += self.solve(model, lower_c, upper_c)
            return result

        '''
        TODO: WORK ON THIS
        '''

        # Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Imp, IdxUnio, IdxInter, Least, Greatest, Top, Bot]

        # elif isinstance(lower, TUnit):
        #     if isinstance(upper, TUnit):
        #         return [model]
        #     else:
        #         return []

        # elif isinstance(control, TTag):
        #     plate = ([control.body], lambda body : f":{control.label} {body}", [])  
        # elif isinstance(control, TField):
        #     plate = ([control.body], lambda body : f"{control.label} : {body}", [])  
        # elif isinstance(control, Imp):
        #     plate = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})", [])  
        # elif isinstance(control, Unio):
        #     plate = ([control.left,control.right], lambda left, right : f"({left} | {right})", [])  
        # elif isinstance(control, Inter):
        #     plate = ([control.left,control.right], lambda left, right : f"({left} & {right})", [])  
        # elif isinstance(control, IdxUnio):
        #     qualification = concretize_qualification(control.qualification)
        #     ids = concretize_ids(control.ids)
        #     plate = ([control.body], lambda body : f"{{{ids} . {qualification}}} {body}", [])  
        # elif isinstance(control, IdxInter):
        #     qualification = concretize_qualification(control.qualification)
        #     ids = concretize_ids(control.ids)
        #     plate = ([control.body], lambda body : f"[{ids} . {qualification}] {body}", [])  
        # elif isinstance(control, Least):
        #     id = control.id
        #     plate = ([control.body], lambda body : f"least {id} with {body}", [])  
        # elif isinstance(control, Greatest):
        #     id = control.id
        #     plate = ([control.body], lambda body : f"greatest {id} of {body}", [])  
        # elif isinstance(control, Top):
        #     plate = ([], lambda: "top", [])  
        # elif isinstance(control, Bot):
        #     plate = ([], lambda: "bot", [])  


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

        return [interp]

    def ground(self, solution : list[Model], typ : Typ) -> Typ:
        return Top()

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
        solution = self.solver.solve(m(), TTag(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)  
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def combine_tag(self, label : str, body : Typ) -> Typ:
        return TTag(label, body)

class ExprRule(Rule):

    def distill_tuple_head(self) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)  
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(TField('head', head), TField('tail', typ)), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)  
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_tuple(self, head : Typ, tail : Typ) -> Typ:
        return Inter(TField('head', head), TField('tail', tail))

    def distill_ite_condition(self) -> Nonterm:
        typ = Unio(TTag('false', TUnit()), TTag('true', TUnit()))
        return Nonterm('expr', self.nt.enviro, typ)

    def distill_ite_branch_true(self, condition : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :true? case given (condition : A), and unrefined prescription B.
        (:true? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('true', TUnit()), typ) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve(m(), implication, premise_conclusion)
        typ_grounded = self.solver.ground(solution, typ)  
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve(m(), implication, premise_conclusion)
        typ_grounded = self.solver.ground(solution, typ)  
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_ite(self, condition : Typ, branch_true : Typ, branch_false : Typ) -> Typ: 
        solution_true = self.solver.solve(m(), condition, TTag('true', TUnit()))
        solution_false = self.solver.solve(m(), condition, TTag('false', TUnit()))

        return Unio(
            self.solver.ground(solution_true, branch_true), 
            self.solver.ground(solution_false, branch_false), 
        )


    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve(m(), answr_i, TField(key, answr))
            answr_i = self.solver.ground(solution, answr)

        return answr_i

    #########

    def distill_application_cator(self) -> Nonterm: 
        return Nonterm('expr', self.nt.enviro, Imp(Bot(), Top()))

    def distill_application_argchain(self, cator : Typ) -> Nonterm: 
        return Nonterm('argchain', self.nt.enviro, cator)

    def combine_application(self, cator : Typ, arguments : list[Typ]) -> Typ: 
        answr_i = cator 
        for argument in arguments:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve(m(), answr_i, Imp(argument, answr))
            answr_i = self.solver.ground(solution, answr)

        return answr_i


    #########
    def distill_funnel_arg(self) -> Nonterm: 
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_funnel_pipeline(self, arg : Typ) -> Nonterm: 
        return Nonterm('pipeline', self.nt.enviro, arg)

    def combine_funnel(self, arg : Typ, cators : list[Typ]) -> Typ: 
        answr_i = arg 
        for cator in cators:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve(m(), Imp(answr_i, answr), cator)
            answr_i = self.solver.ground(solution, answr)

        return answr_i
    #########


    def distill_fix_body(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def combine_fix(self, body : Typ) -> Typ:
        typ = self.solver.fresh_type_var()
        return Least(typ.id, body)
    
    def distill_let_target(self, id : str) -> Nonterm:
        return Nonterm('target', self.nt.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Nonterm:
        '''
        TODO: generalize target
        - avoid overgeneralizing by not abstracting variables introduced before target
        '''
        enviro = self.nt.enviro.set(id, target)
        return Nonterm('expr', enviro, self.nt.typ)
'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(TField(id, body), typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        conclusion = self.solver.fresh_type_var() 
        solution = self.solver.solve(m(), self.nt.typ, Imp(pattern.typ, conclusion)) 
        conclusion_grounded = self.solver.ground(solution, conclusion)
        enviro = self.nt.enviro + pattern.enviro
        return Nonterm('expr', enviro, conclusion_grounded)

    def combine_single(self, pattern : PatternAttr, body : Typ) -> Typ:
        return Imp(pattern.typ, body)

    def distill_cons_pattern(self) -> Nonterm:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PatternAttr) -> Nonterm:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PatternAttr, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(Imp(pattern.typ, body), typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('function', self.nt.enviro, typ_grounded)

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
        solution = self.solver.solve(m(), self.nt.typ, TField(key, typ))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('keychain', self.nt.enviro, typ_grounded)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        solution = self.solver.solve(m(), self.nt.typ, Imp(head, typ))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('argchain', self.nt.enviro, typ_grounded)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail

######

class PipelineRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        solution = self.solver.solve(m(), head, Imp(self.nt.typ, typ))
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pipeline', self.nt.enviro, typ_grounded)

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
        solution = self.solver.solve(m(), Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(TField('head', head.typ), TField('tail', typ)), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def combine_tuple(self, head : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(head.enviro + tail.enviro, Inter(TField('head', head.typ), TField('tail', tail.typ)))

'''
end PatternRule
'''

class PatternBaseRule(Rule):

    def combine_var(self, id : str) -> PatternAttr:
        typ = self.solver.fresh_type_var()
        enviro = m().set(id, typ)
        solution = self.solver.solve(m(), typ, self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return PatternAttr(enviro, typ_grounded)

    def combine_unit(self) -> PatternAttr:
        return PatternAttr(m(), TUnit())

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), TTag(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(m(), Inter(TField(id, body.typ), typ), self.nt.typ)
        typ_grounded = self.solver.ground(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
