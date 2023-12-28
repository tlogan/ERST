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
class Diff:
    context : Typ 
    negation : Typ # NOTE:, restrict to a tag/field pattern that is easy decide anti-unification

@dataclass(frozen=True, eq=True)
class Imp:
    antec : Typ 
    consq : Typ 

@dataclass(frozen=True, eq=True)
class IdxUnio:
    ids : list[str]
    constraints : list[Subtyping] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class IdxInter:
    ids : list[str]
    constraints : list[Subtyping] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Least:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Imp, IdxUnio, IdxInter, Least, Top, Bot]


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

def concretize_constraints(subtypings : list[Subtyping]) -> str:
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
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate = ([control.body], lambda body : f"{{{ids} . {constraints}}} {body}", [])  
        elif isinstance(control, IdxInter):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate = ([control.body], lambda body : f"[{ids} . {constraints}] {body}", [])  
        elif isinstance(control, Least):
            id = control.id
            plate = ([control.body], lambda body : f"least {id} with {body}", [])  
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




Grounding = PMap[str, Typ]
Model = PSet[Subtyping]


@dataclass(frozen=True, eq=True)
class Premise:
    model : Model
    grounding : Grounding 

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

def pattern_type(t : Typ) -> bool:
    return (
        isinstance(t, TVar) or
        isinstance(t, TUnit) or
        (isinstance(t, TTag) and pattern_type(t.body)) or 
        (isinstance(t, TField) and pattern_type(t.body)) or 
        False
    )


def diff_well_formed(diff : Diff) -> bool:
    '''
    restriction to avoid dealing with negating divergence (which would need to soundly fail under even negs, soundly pass under odd negs)
    '''
    return pattern_type(diff.negation)

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
    '''

    '''
    TODO: distinguish between adjustable variables and variables with fixed assignments 
    TODO: create an assignment map (grounding); variables in grounding are fixed; all others may be adjusted! 
    '''

    def reducible(self, premise : Premise, lower : Typ, upper : Typ) -> bool:
        # TODO
        return False

    def match_lower(self, model : Model, lower : Typ) -> Optional[Typ]:
        for constraint in model:
            if lower == constraint.lower:
                return constraint.upper
        return None

    def constraint_well_formed(self, premise : Premise, lower : Typ, upper : Typ) -> bool:
        # TODO
        return False



    def from_cases(self, cases : list[Imp]) -> Imp:
        # TODO
        return Imp(Bot(), Top())

    def factor_least(self, least : Least) -> Typ:
        # TODO
        return Top()

    def alpha_equiv(self, lower : Typ, upper : Typ) -> bool:
        # TODO
        return False

    def solve(self, premise : Premise, lower : Typ, upper : Typ) -> list[Premise]:

        if False: 
            return [] 

        #######################################
        #### Variable rules: ####
        #######################################

        elif isinstance(upper, TVar): 
            upper_ground = premise.grounding.get(upper.id)
            if upper_ground:
                return self.solve(premise, lower, upper_ground) 
            else:
                premise = Premise(premise.model.add(Subtyping(lower, upper)), premise.grounding)
                return [premise]

        elif isinstance(lower, TVar): 
            lower_ground = premise.grounding.get(lower.id)
            if lower_ground:
                return self.solve(premise, lower_ground, upper) 
            else:
                premise = Premise(premise.model.add(Subtyping(lower, upper)), premise.grounding)
                return [premise]

        #######################################
        #### Model rules: ####
        #######################################

        elif isinstance(lower, IdxUnio):
            renaming = self.mk_renaming(lower.ids)
            lower_constraints = self.rename_constraints(renaming, lower.constraints)
            lower_body = self.rename_typ(renaming, lower.body)

            premises = [premise]
            for constraint in lower_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.lower, constraint.upper)
                ]  

            return [
                p2
                for p1 in premises
                for p2 in self.solve(p1, lower_body, upper)
            ]

        elif isinstance(upper, IdxInter):
            renaming = self.mk_renaming(upper.ids)
            upper_constraints = self.rename_constraints(renaming, upper.constraints)
            upper_body = self.rename_typ(renaming, upper.body)

            premises = [premise]
            for constraint in upper_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.lower, constraint.upper)
                ]  

            return [
                p2
                for p1 in premises
                for p2 in self.solve(p1, lower, upper_body)
            ]

        elif isinstance(lower, Least):
            if self.alpha_equiv(lower, upper):
                return [premise]
            else:
                lower_factored = self.factor_least(lower)
                solution = self.solve(premise, lower_factored, upper)
                if solution == []:
                    '''
                    NOTE: k-induction
                    use the pattern on LHS to dictate number of unrollings needed on RHS 
                    simply need to sub RHS into LHS's self-referencing variable
                    '''
                    # TODO: at check for timeout after some number of iterations 
                    tvar_fresh = self.fresh_type_var()
                    renaming = pmap({tvar_fresh.id : lower.id})
                    lower_body = self.rename_typ(renaming, lower.body)

                    '''
                    add induction hypothesis to premise:
                    '''
                    grounding = premise.grounding.set(tvar_fresh.id, upper)
                    premise = Premise(premise.model, grounding)
                    return self.solve(premise, lower_body, upper)
                    
                else:
                    return solution

        elif isinstance(upper, Imp) and isinstance(upper.antec, Unio):
            '''
            antecedent union: lower <: ((T1 | T2) -> TR)
            A -> Q & B -> Q ~~~ A | B -> Q
            '''
            return [
                p2
                for p1 in self.solve(premise, lower, Imp(upper.antec.left, upper.consq))
                for p2 in self.solve(p1, lower, Imp(upper.antec.right, upper.consq))
            ]

        elif isinstance(upper, Imp) and isinstance(upper.consq, Inter):
            '''
            consequent intersection: lower <: (TA -> (T1 & T2))
            P -> A & P -> B ~~~ P -> A & B 
            '''
            return [
                p2
                for p1 in self.solve(premise, lower, Imp(upper.antec, upper.consq.left))
                for p2 in self.solve(p1, lower, Imp(upper.antec, upper.consq.right))
            ]

        # NOTE: field body intersection: lower <: (:label = (T1 & T2))
        # l : A & l : B ~~~ l : A & B 
        elif isinstance(upper, TField) and isinstance(upper.body, Inter):
            return [
                p2
                for p1 in self.solve(premise, lower, TField(upper.label, upper.body.left))
                for p2 in self.solve(p1, lower, TField(upper.label, upper.body.right))
            ]

        elif isinstance(lower, Unio):
            return [
                p2
                for p1 in self.solve(premise, lower.left, upper)
                for p2 in self.solve(p1, lower.right, upper)
            ]

        elif isinstance(upper, Inter):
            return [
                p2
                for p1 in self.solve(premise, lower, upper.left)
                for p2 in self.solve(p1, lower, upper.right)
            ]

        elif isinstance(upper, Diff) and diff_well_formed(upper):
            '''
            T <: A \ B === (T <: A), ~(T <: B) 
            '''
            return [
                p1
                for p1 in self.solve(premise, lower, upper.context)
                if self.solve(p1, lower, upper.negation) == []
            ]
        

        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(upper, Top): 
            return [premise] 

        elif isinstance(lower, Bot): 
            return [premise] 

        elif isinstance(upper, IdxUnio): 
            renaming = self.mk_renaming(upper.ids)
            upper_constraints = self.rename_constraints(renaming, upper.constraints)
            upper_body = self.rename_typ(renaming, upper.body)

            solution = self.solve(premise, lower, upper_body) 
            ids_ground = list(renaming.values())

            model = premise.model
            grounding = premise.grounding + (self.ground_ids(solution, ids_ground))
            premises = [Premise(model, grounding)]

            for constraint in upper_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.lower, constraint.upper)
                ]

            return premises

        elif isinstance(lower, IdxInter): 
            renaming = self.mk_renaming(lower.ids)
            lower_constraints = self.rename_constraints(renaming, lower.constraints)
            lower_body = self.rename_typ(renaming, lower.body)

            solution = self.solve(premise, lower_body, upper) 
            ids_ground = list(renaming.values())

            model = premise.model
            grounding = premise.grounding + (self.ground_ids(solution, ids_ground))
            premises = [Premise(model, grounding)]

            for constraint in lower_constraints:
                premises = [
                    p2 
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.lower, constraint.upper)
                ] 

            return premises

        elif isinstance(upper, Least): 
            if self.reducible(premise, lower, upper):
                id_fresh = self.fresh_type_var().id
                grounding = premise.grounding.set(id_fresh, upper)
                renaming = pmap({upper.id : id_fresh})
                upper_body = self.rename_typ(renaming, upper.body)
                premise = Premise(premise.model, grounding)
                return self.solve(premise, lower, upper_body)
            else:
                upper_cache = self.match_lower(premise.model, lower)
                if upper_cache:
                    return self.solve(premise, upper_cache, upper)
                # elif self.constraint_well_formed(premise, lower, upper):
                #     # TODO: this is questionable: can't be sound to simply strengthen the premise here
                #     model = premise.model.add(Subtyping(lower, upper))
                #     return [Premise(model, premise.grounding)]
                else:
                    return []

        elif isinstance(lower, Diff) and diff_well_formed(lower):
            '''
            A \ B <: T === A <: T | B  
            '''
            return self.solve(premise, lower.context, Unio(upper, lower.negation))


        elif isinstance(upper, Unio): 
            return self.solve(premise, lower, upper.left) + self.solve(premise, lower, upper.right)

        elif isinstance(lower, Inter): 
            return self.solve(premise, lower.left, upper) + self.solve(premise, lower.right, upper)


        #######################################
        #### Unification rules: ####
        #######################################

        elif isinstance(lower, TUnit) and isinstance(upper, TUnit): 
            return [premise] 

        elif isinstance(lower, TTag) and isinstance(upper, TTag): 
            if lower.label == upper.label:
                return self.solve(premise, lower.body, upper.body) 
            else:
                return [] 

        elif isinstance(lower, TField) and isinstance(upper, TField): 
            if lower.label == upper.label:
                return self.solve(premise, lower.body, upper.body) 
            else:
                return [] 



        elif isinstance(lower, Imp) and isinstance(upper, Imp): 
            return [
                p2
                for p1 in self.solve(premise, upper.antec, lower.antec) 
                for p2 in self.solve(p1, lower.consq, upper.consq) 
            ]

        return []

    '''
    end solve
    '''


    def ground_typ(self, solution : list[Premise], typ : Typ) -> Typ:
        return Top() 

    def ground_ids(self, solution : list[Premise], ids : list[str]) -> Grounding:
        grounding = m()
        for id in ids: 
            typ_ground = self.ground_typ(solution, TVar(id)) 
            grounding.set(id, typ_ground)
        return grounding

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
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), TTag(id, typ_var), self.nt.typ)
        typ_guide = self.solver.ground_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide)

    def combine_tag(self, label : str, body : Typ) -> Typ:
        return TTag(label, body)

    def combine_function(self, cases : list[Imp]) -> Typ:
        # - TODO: solve subtyping of case types from function rewriting into implication 
        # - view of cases as first-come-first-serve
        # - e.g. A -> B, C -> D becomes [X <: (A | C)] X -> ({Y . X * Y <: (A * B) | (C\A * D)} Y)
        #####################
        # NOTE: alternative view of cases as pure intersection
        # P --> Q & A --> B
        # (~P | Q) & (~A | B)
        # (~P | (P, Q)) & (~A | (A, B))
        # (~P & ~A) | (~P & A, B) | (~A & P, Q) | (P & A, Q & B)
        # [X <: (P | A)] X -> ({X <: A\P} B) | ({X <: P\A} Q | ({X <: P, X <: A} (Q & B)
        # [X <: (P | A)] X -> ({X <: P\A} Q | ({X <: A\P} B) | ({X <: P, X <: A} (Q & B)
        return Imp(Bot(), Top())





class ExprRule(Rule):

    def distill_tuple_head(self) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), Inter(TField('head', typ_var), TField('tail', Bot())), self.nt.typ)
        typ_guide = self.solver.ground_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), Inter(TField('head', head), TField('tail', typ_var)), self.nt.typ)
        typ_guide = self.solver.ground_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

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
        typ_var = self.solver.fresh_type_var()
        implication = Imp(TTag('true', TUnit()), typ_var) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve(Premise(s(), m()), implication, premise_conclusion)
        typ_guide = self.solver.ground_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ_var = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ_var) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve(Premise(s(), m()), implication, premise_conclusion)
        typ_guide = self.solver.ground_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def combine_ite(self, condition : Typ, branch_true : Typ, branch_false : Typ) -> Typ: 
        solution_true = self.solver.solve(Premise(s(), m()), condition, TTag('true', TUnit()))
        solution_false = self.solver.solve(Premise(s(), m()), condition, TTag('false', TUnit()))

        return Unio(
            self.solver.ground_typ(solution_true, branch_true), 
            self.solver.ground_typ(solution_false, branch_false), 
        )


    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve(Premise(s(), m()), answr_i, TField(key, answr))
            answr_i = self.solver.ground_typ(solution, answr)

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
            solution = self.solver.solve(Premise(s(), m()), answr_i, Imp(argument, answr))
            answr_i = self.solver.ground_typ(solution, answr)

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
            solution = self.solver.solve(Premise(s(), m()), Imp(answr_i, answr), cator)
            answr_i = self.solver.ground_typ(solution, answr)

        return answr_i
    #########


    def distill_fix_body(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def combine_fix(self, body : Typ) -> Typ:
        typ = self.solver.fresh_type_var()
        # TODO: construct implication of least
        # ==== cases: (P -> Q), ...
        # ==== ([X . X <: (P | ...)] X -> {Y . X * Y <: least (P * Q) | ...} Y)
        #####################
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
        solution = self.solver.solve(Premise(s(), m()), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), Inter(TField(id, body), typ), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, Imp(typ_var, Top()))

        typ_guide = self.solver.ground_typ(solution, typ_var)
        return Nonterm('pattern', self.nt.enviro, typ_guide)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        conclusion = self.solver.fresh_type_var() 
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, Imp(pattern.typ, conclusion)) 
        conclusion_grounded = self.solver.ground_typ(solution, conclusion)
        enviro = self.nt.enviro + pattern.enviro
        return Nonterm('expr', enviro, conclusion_grounded)

    def combine_single(self, pattern : PatternAttr, body : Typ) -> list[Imp]:
        return [Imp(pattern.typ, body)]

    def distill_cons_pattern(self) -> Nonterm:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PatternAttr) -> Nonterm:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PatternAttr, body : Typ) -> Nonterm:
        typ_antec = self.solver.fresh_type_var()
        typ_consq = self.solver.fresh_type_var()
        typ_imp = self.solver.from_cases([Imp(pattern.typ, body), Imp(typ_antec, typ_consq)])

        solution = self.solver.solve(Premise(s(), m()), typ_imp, self.nt.typ)
        typ_guide = self.solver.ground_typ(solution, Imp(typ_antec, typ_consq))
        '''
        NOTE: the guide is an implication guiding the next case
        '''
        return Nonterm('function', self.nt.enviro, typ_guide)

    def combine_cons(self, pattern : PatternAttr, body : Typ, tail : list[Imp]) -> list[Imp]:
        return [Imp(pattern.typ, body)] + tail


class KeychainRule(Rule):

    def combine_single(self, key : str) -> list[str]:
        # self.solver.solve(plate.enviro, plate.typ, TField(key, Top())) 
        return [key]

    '''
    return the plate with the tyption as the type that the next element in tail cuts
    '''
    def distill_cons_tail(self, key : str):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, TField(key, typ))
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('keychain', self.nt.enviro, typ_grounded)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        solution = self.solver.solve(Premise(s(), m()), self.nt.typ, Imp(head, typ))
        typ_grounded = self.solver.ground_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), m()), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        solution = self.solver.solve(Premise(s(), m()), head, Imp(self.nt.typ, typ))
        typ_grounded = self.solver.ground_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), m()), Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), Inter(TField('head', head.typ), TField('tail', typ)), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), m()), typ, self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return PatternAttr(enviro, typ_grounded)

    def combine_unit(self) -> PatternAttr:
        return PatternAttr(m(), TUnit())

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), TTag(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), m()), Inter(TField(id, body.typ), typ), self.nt.typ)
        typ_grounded = self.solver.ground_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
