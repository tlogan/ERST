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

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, IdxUnio, IdxInter, Least, Top, Bot]


'''
Nameless Type
'''
@dataclass(frozen=True, eq=True)
class BVar:
    id : int 

@dataclass(frozen=True, eq=True)
class TTagNL:
    label : str
    body : NL 

@dataclass(frozen=True, eq=True)
class TFieldNL:
    label : str
    body : NL 

@dataclass(frozen=True, eq=True)
class UnioNL:
    left : NL 
    right : NL 

@dataclass(frozen=True, eq=True)
class InterNL:
    left : NL 
    right : NL 

@dataclass(frozen=True, eq=True)
class DiffNL:
    context : NL 
    negation : NL # NOTE:, restrict to a tag/field pattern that is easy decide anti-unification

@dataclass(frozen=True, eq=True)
class ImpNL:
    antec : NL 
    consq : NL 

@dataclass(frozen=True, eq=True)
class IdxUnioNL:
    count : int
    constraints : list[SubtypingNL] 
    body : NL 

@dataclass(frozen=True, eq=True)
class IdxInterNL:
    count : int
    constraints : list[SubtypingNL] 
    body : NL 

@dataclass(frozen=True, eq=True)
class LeastNL:
    body : NL 

@dataclass(frozen=True, eq=True)
class SubtypingNL:
    strong : NL 
    weak : NL 

NL = Union[TVar, BVar, TUnit, TTagNL, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, IdxUnioNL, IdxInterNL, LeastNL, Top, Bot]

def to_nameless(bound_ids : list[str], typ : Typ) -> NL:
    if False: 
        pass
    elif isinstance(typ, TVar):  
        if typ.id in bound_ids:
            id = bound_ids.index(typ.id)
            return BVar(id)
        else:
            return typ
    elif isinstance(typ, TUnit):
        return typ
    elif isinstance(typ, TTag):
        return TTagNL(typ.label, to_nameless(bound_ids, typ.body))
    elif isinstance(typ, TField):
        return TFieldNL(typ.label, to_nameless(bound_ids, typ.body))
    elif isinstance(typ, Unio):
        return UnioNL(to_nameless(bound_ids, typ.left), to_nameless(bound_ids, typ.right))
    elif isinstance(typ, Inter):
        return InterNL(to_nameless(bound_ids, typ.left), to_nameless(bound_ids, typ.right))
    elif isinstance(typ, Diff):
        return DiffNL(to_nameless(bound_ids, typ.context), to_nameless(bound_ids, typ.negation))
    elif isinstance(typ, Imp):
        return ImpNL(to_nameless(bound_ids, typ.antec), to_nameless(bound_ids, typ.consq))
    elif isinstance(typ, IdxUnio):
        count = len(typ.ids)
        bound_ids = typ.ids + bound_ids

        constraints_nl = [
            SubtypingNL(to_nameless(bound_ids, st.strong), to_nameless(bound_ids, st.weak))
            for st in typ.constraints
        ]
        return IdxUnioNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, IdxInter):
        count = len(typ.ids)
        bound_ids = typ.ids + bound_ids

        constraints_nl = [
            SubtypingNL(to_nameless(bound_ids, st.strong), to_nameless(bound_ids, st.weak))
            for st in typ.constraints
        ]
        return IdxInterNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, Least):
        bound_ids = [typ.id] + bound_ids
        return LeastNL(to_nameless(bound_ids, typ.body))

    elif isinstance(typ, Top):
        return typ

    elif isinstance(typ, Bot):
        return typ
'''
end to_nameless
'''


@dataclass(frozen=True, eq=True)
class Subtyping:
    strong : Typ
    weak : Typ


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
        concretize_typ(st.strong) + " <: " + concretize_typ(st.weak)
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
        elif isinstance(control, Diff):
            plate = ([control.context,control.negation], lambda context,negation : f"({context} \\ {negation})", [])  
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




'''
NOTE: 
Freezer dictates when the strongest solution for a variable is found.
The assignment map could be tracked, or computed lazily when variable is used. 

NOTE: freezing variables corresponds to refining predicates from duality interpolation in CHC
'''
Freezer = PSet[str]
Model = PSet[Subtyping]


@dataclass(frozen=True, eq=True)
class Premise:
    model : Model
    freezer : Freezer 

def by_variable(constraints : PSet[Subtyping], key : str) -> PSet[Subtyping]: 
    return pset((
        st
        for st in constraints
        if contains(st.strong, key)
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

def mk_diff(context : Typ, negs : list[Typ]) -> Typ:
    result = context 
    for neg in negs:
        result = Diff(result, neg)
    return result

def mk_pair_type(left : Typ, right : Typ) -> Typ:
    return Inter(TField("left", left), TField("right", right))

def from_cases_to_choices(cases : list[Imp]) -> list[tuple[Typ, Typ]]:
    '''
    nil -> zero
    cons X -> succ Y 
    --------------------
    (nil,zero) | (cons X\\nil, succ Y)
    '''

    choices = []
    negs = []

    for case in cases:
        choices += [(mk_diff(case.antec, negs), case.consq)]
        negs += [case.antec]
    return choices 

def linearize_unions(t : Typ) -> list[Typ]:
    if isinstance(t, Unio):
        return linearize_unions(t.left) + linearize_unions(t.right)
    else:
        return [t]

def extract_paths(t : Typ, tvar : Optional[TVar] = None) -> PSet[list[str]]:  
    if False:
        assert False
    elif isinstance(t, IdxUnio):
        return extract_paths(t.body)
    elif isinstance(t, Inter):
        left = extract_paths(t.left) 
        right = extract_paths(t.right)
        return PSet.union(left, right)
    elif isinstance(t, TField):
        body = t.body
        if isinstance(body, TVar) and (not tvar or tvar.id == body.id):
            path = [t.label]
            return pset().add(path)
        else:
            paths_tail = extract_paths(t.body)
            return pset( 
                [t.label] + path_tail
                for path_tail in paths_tail
            )

    else:
        raise Exception("extract_labels error")


def extract_field_recurse(t : Typ, path : list[str]) -> Optional[Typ]:
    assert path

    if isinstance(t, Inter):
        left = extract_field_recurse(t.left, path)
        right = extract_field_recurse(t.left, path)
        if left and right:
            return Inter(left, right)
        else:
            return left or right
    elif isinstance(t, TField):
        label = path[0]
        if len(path) == 1 and t.label == label:
            return t.body
        else:
            return extract_field_recurse(t.body, path[1:])


def extract_field_plain(path : list[str], t : Typ) -> Typ:
    result = extract_field_recurse(t, path)
    if result:
        return result
    else:
        raise Exception("extract_field_plain error")

def extract_field(path : list[str], id_induc : str, t : Typ) -> Typ:
    if isinstance(t, IdxUnio):  
        new_constraints = [
            (
            Subtyping(extract_field_plain(path, st.strong), TVar(id_induc))
            if st.weak == TVar(id_induc) else
            st
            )
            for st in t.constraints
        ] 
        new_body = extract_field_plain(path, t.body)
        return IdxUnio(t.ids, new_constraints, new_body)
    else:
        return extract_field_plain(path, t)


def extract_column(path : list[str], id_induc : str, choices : list[Typ]) -> Typ:
    choices_column = [
        extract_field(path, id_induc, choice)
        for choice in choices
    ] 
    typ_unio = choices_column[0]
    for choice in choices_column[1:]:
        typ_unio = Unio(typ_unio, choice)
    return Least(id_induc, typ_unio)

def factor_path(path : list[str], least : Least) -> Typ:
    choices = linearize_unions(least.body)
    column = extract_column(path, least.id, choices)
    return column 

def factor_least(least : Least) -> Typ:
    choices = linearize_unions(least.body)
    paths = list(extract_paths(choices[0]))
    typ_inter = Top() 
    for path in paths:
        column = extract_column(path, least.id, choices)
        typ_inter = Inter(typ_inter, column)
    return typ_inter


def alpha_equiv(t1 : Typ, t2 : Typ) -> bool:
    return to_nameless([], t1) == to_nameless([], t2)

def is_relational_key(t : Typ) -> bool:
    if isinstance(t, TField):
        return isinstance(t.body, TVar) or is_relational_key(t.body) 
    elif isinstance(t, Inter):
        return is_relational_key(t.left) and is_relational_key(t.right)
    else:
        return False

def match_strong(model : Model, strong : Typ) -> Optional[Typ]:
    for constraint in model:
        if strong == constraint.strong:
            return constraint.weak
    return None

# def constraint_well_formed(premise : Premise, strong : Typ, weak : Typ) -> bool:
#     # TODO
#     return False

def is_record_type_with_var(t : Typ, id : str) -> bool:
    # TODO
    return False


def extract_strongest_weaker(model : Model, id : str) -> Typ:
    # TODO
    '''
    NOTE: related to strongest-post concept

    Step 1: LHS variable in simple constraints:
    X <: A, X <: B - the strongest type weaker than X is A & B,
    --------


    Step 2: LHS variables in relational constraints: always have relation of variables on LHS; need to factor; then perform union after
    case relational: if variable is part of relational constraint, factor out type from rhs
    case simple: otherwise, extract rhs
    -- NOTE: relational constraints are restricted to record types of variables
    -- NOTE: tail-recursion, e.g. reverse list, requires patterns in relational constraint, but, that's bound inside of Least
    -- e.g. (A, B, C, L) <: (Least I . (nil, Y, Y) | {(X, cons Y, Z) <: I} (cons X, Y, Z))
    ---------------

    Step 3: RHS variable simple constraints:
    H <: X, I <: X - the strongest type weaker than X is H | I
    '''

    typs_strengthen = [
        st.weak
        for st in model
        if st.strong == TVar(id)
    ]
    typ_strong = Top() 
    for t in reversed(typs_strengthen):
        typ_strong = Inter(t, typ_strong) 


    constraints_relational = [
        st
        for st in model
        if is_record_type_with_var(st.weak, id)
    ]

    typ_factored = Top()
    for st in constraints_relational:
        paths = extract_paths(st.weak, TVar(id)) 
        for path in paths:
            assert isinstance(st.strong, Least)
            typ_labeled = factor_path(path, st.strong)
            typ_factored = Inter(typ_labeled, typ_factored)



    typs_weaken = [
        st.strong
        for st in model
        if st.weak == TVar(id)
    ]

    typ_weak = Bot() 
    for t in reversed(typs_weaken):
        typ_weak = Inter(t, typ_weak) 


    typ_final = Inter(typ_strong, Inter(typ_factored, typ_weak))

    return typ_final 


class Solver:
    _type_id : int = 0 
    _battery : int = 0 
    _max_battery : int = 100

    def set_max_battery(self, max_battery : int):
        self._max_battery = max_battery 

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


    def rename_typ(self, renaming : PMap[str, str], typ : Typ) -> Typ:
        '''
        renaming: map from old id to new id
        '''
        if False:
            assert False
        elif isinstance(typ, TVar):  
            if typ.id in renaming:
                return TVar(renaming[typ.id])
            else:
                return typ
        elif isinstance(typ, TUnit):  
            return typ
        elif isinstance(typ, TTag):  
            return TTag(typ.label, self.rename_typ(renaming, typ.body))
        elif isinstance(typ, TField):  
            return TField(typ.label, self.rename_typ(renaming, typ.body))
        elif isinstance(typ, Unio):  
            return Unio(self.rename_typ(renaming, typ.left), self.rename_typ(renaming, typ.right))
        elif isinstance(typ, Inter):  
            return Inter(self.rename_typ(renaming, typ.left), self.rename_typ(renaming, typ.right))
        elif isinstance(typ, Diff):  
            return Diff(self.rename_typ(renaming, typ.context), self.rename_typ(renaming, typ.negation))
        elif isinstance(typ, Imp):  
            return Imp(self.rename_typ(renaming, typ.antec), self.rename_typ(renaming, typ.consq))
        elif isinstance(typ, IdxUnio):  
            for bid in typ.ids:
                renaming = renaming.discard(bid)
            return IdxUnio(typ.ids, self.rename_constraints(renaming, typ.constraints), self.rename_typ(renaming, typ.body)) 
        elif isinstance(typ, IdxInter):  
            for bid in typ.ids:
                renaming = renaming.discard(bid)
            return IdxInter(typ.ids, self.rename_constraints(renaming, typ.constraints), self.rename_typ(renaming, typ.body)) 
        elif isinstance(typ, Least):  
            renaming = renaming.discard(typ.id)
            return Least(typ.id, self.rename_typ(renaming, typ.body))
        elif isinstance(typ, Top):  
            return typ
        elif isinstance(typ, Bot):  
            return typ
    '''
    end rename_type
    '''

    def rename_constraints(self, renaming : PMap[str, str], constraints : list[Subtyping]) -> list[Subtyping]:
        return [
            Subtyping(self.rename_typ(renaming, st.strong), self.rename_typ(renaming, st.weak))
            for st in constraints
        ]
    '''
    end rename_constraints
    '''


    def solve(self, premise : Premise, strong : Typ, weak : Typ) -> list[Premise]:

        if False: 
            return [] 

        #######################################
        #### Variable rules: ####
        #######################################

        elif isinstance(weak, TVar): 
            frozen = weak.id in premise.freezer
            if frozen:
                '''
                package weak; an IdxUnio will be constructed, and the right IdxUnio rule will specialize its constraints with strong

                e.g.
                L <: {X . X, Y <: R, X <: T } X
                -------------------------------
                X |-> L 
                L, Y <: R, L <: T
                '''
                weak_packaged = self.package_typ([premise], weak)
                return self.solve(premise, strong, weak_packaged) 
            else:
                premise = Premise(premise.model.add(Subtyping(strong, weak)), premise.freezer)
                return [premise]

        elif isinstance(strong, TVar): 
            frozen = strong.id in premise.freezer
            if frozen:
                '''
                package strong 
                - if the strong has only simple constraints, it will be subbed
                - if the strong has relational constraints, the collapsing would cause an IdxUnio will be constructed, and the left IdxUnio rule will cause an infinite loop 
                e.g.
                {X . X, Y <: R, X <: T } X <: U
                -------------------------------
                -------------------------------
                X, Y <: R, X <: T, X <: U

                -----------------------

                '''
                strongest_weaker = extract_strongest_weaker(premise.model, strong.id)
                return self.solve(premise, strongest_weaker, weak) 
            else:
                premise = Premise(premise.model.add(Subtyping(strong, weak)), premise.freezer)
                return [premise]

        #######################################
        #### Model rules: ####
        #######################################

        elif isinstance(strong, IdxUnio):
            renaming = self.mk_renaming(strong.ids)
            strong_constraints = self.rename_constraints(renaming, strong.constraints)
            strong_body = self.rename_typ(renaming, strong.body)
            freezer = premise.freezer.union(renaming.values())

            premises = [Premise(premise.model, freezer)]
            for constraint in strong_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.strong, constraint.weak)
                ]  

            return [
                p2
                for p1 in premises
                for p2 in self.solve(p1, strong_body, weak)
            ]

        elif isinstance(weak, IdxInter):
            renaming = self.mk_renaming(weak.ids)
            weak_constraints = self.rename_constraints(renaming, weak.constraints)
            weak_body = self.rename_typ(renaming, weak.body)
            freezer = premise.freezer.union(renaming.values())

            premises = [Premise(premise.model, freezer)]
            for constraint in weak_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.strong, constraint.weak)
                ]  

            return [
                p2
                for p1 in premises
                for p2 in self.solve(p1, strong, weak_body)
            ]

        elif isinstance(strong, Least):
            if alpha_equiv(strong, weak):
                return [premise]
            else:
                solution = []

                strong_factored = factor_least(strong)
                solution = self.solve(premise, strong_factored, weak)

                if solution == []:
                    '''
                    NOTE: k-induction
                    use the pattern on LHS to dictate number of unrollings needed on RHS 
                    simply need to sub RHS into LHS's self-referencing variable
                    '''
                    # TODO: at check for timeout after some number of iterations 
                    tvar_fresh = self.fresh_type_var()
                    renaming = pmap({strong.id : tvar_fresh.id})
                    strong_body = self.rename_typ(renaming, strong.body)

                    '''
                    add induction hypothesis to premise:
                    '''
                    IH = Subtyping(tvar_fresh, weak) 
                    model = premise.model.add(IH)
                    freezer = premise.freezer.add(tvar_fresh.id)
                    premise = Premise(model, freezer) 
                    return self.solve(premise, strong_body, weak)
                    
                else:
                    return solution

        elif isinstance(weak, Imp) and isinstance(weak.antec, Unio):
            '''
            antecedent union: strong <: ((T1 | T2) -> TR)
            A -> Q & B -> Q ~~~ A | B -> Q
            '''
            return [
                p2
                for p1 in self.solve(premise, strong, Imp(weak.antec.left, weak.consq))
                for p2 in self.solve(p1, strong, Imp(weak.antec.right, weak.consq))
            ]

        elif isinstance(weak, Imp) and isinstance(weak.consq, Inter):
            '''
            consequent intersection: strong <: (TA -> (T1 & T2))
            P -> A & P -> B ~~~ P -> A & B 
            '''
            return [
                p2
                for p1 in self.solve(premise, strong, Imp(weak.antec, weak.consq.left))
                for p2 in self.solve(p1, strong, Imp(weak.antec, weak.consq.right))
            ]

        # NOTE: field body intersection: strong <: (:label = (T1 & T2))
        # l : A & l : B ~~~ l : A & B 
        elif isinstance(weak, TField) and isinstance(weak.body, Inter):
            return [
                p2
                for p1 in self.solve(premise, strong, TField(weak.label, weak.body.left))
                for p2 in self.solve(p1, strong, TField(weak.label, weak.body.right))
            ]

        elif isinstance(strong, Unio):
            return [
                p2
                for p1 in self.solve(premise, strong.left, weak)
                for p2 in self.solve(p1, strong.right, weak)
            ]

        elif isinstance(weak, Inter):
            return [
                p2
                for p1 in self.solve(premise, strong, weak.left)
                for p2 in self.solve(p1, strong, weak.right)
            ]

        elif isinstance(weak, Diff) and diff_well_formed(weak):
            '''
            T <: A \ B === (T <: A), ~(T <: B) 
            '''
            return [
                p1
                for p1 in self.solve(premise, strong, weak.context)
                if self.solve(p1, strong, weak.negation) == []
            ]
        

        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(weak, Top): 
            return [premise] 

        elif isinstance(strong, Bot): 
            return [premise] 

        elif isinstance(weak, IdxUnio): 
            renaming = self.mk_renaming(weak.ids)
            weak_constraints = self.rename_constraints(renaming, weak.constraints)
            weak_body = self.rename_typ(renaming, weak.body)

            solution = self.solve(premise, strong, weak_body) 
            ids_ground = renaming.values()

            model = premise.model
            freezer = premise.freezer.union(ids_ground)
            premises = [Premise(model, freezer)]

            for constraint in weak_constraints:
                premises = [
                    p2
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.strong, constraint.weak)
                ]

            return premises

        elif isinstance(strong, IdxInter): 
            renaming = self.mk_renaming(strong.ids)
            strong_constraints = self.rename_constraints(renaming, strong.constraints)
            strong_body = self.rename_typ(renaming, strong.body)

            solution = self.solve(premise, strong_body, weak) 
            ids_ground = renaming.values()

            model = premise.model
            freezer = premise.freezer.union(ids_ground)
            premises = [Premise(model, freezer)]

            for constraint in strong_constraints:
                premises = [
                    p2 
                    for p1 in premises
                    for p2 in self.solve(p1, constraint.strong, constraint.weak)
                ] 

            return premises

        elif isinstance(weak, Least): 
            # TODO: add energy check; and energy decrementing
            # if not relational_key(strong) and self.energy > 0:
            if not is_relational_key(strong) and self._battery > 0:
                self._battery -= 1
                tvar_fresh = self.fresh_type_var()
                unrolling = Subtyping(tvar_fresh, weak)
                model = premise.model.add(unrolling)
                freezer = premise.freezer.add(tvar_fresh.id)
                renaming = pmap({weak.id : tvar_fresh.id})
                weak_body = self.rename_typ(renaming, weak.body)
                premise = Premise(model, freezer)

                return self.solve(premise, strong, weak_body)
            else:
                weak_cache = match_strong(premise.model, strong)
                if weak_cache:
                    return self.solve(premise, weak_cache, weak)
                # elif constraint_well_formed(premise, strong, weak):
                #     # TODO: this is questionable: can't be sound to simply strengthen the premise here
                #     model = premise.model.add(Subtyping(strong, weak))
                #     return [Premise(model, premise.grounding)]
                else:
                    return []

        elif isinstance(strong, Diff) and diff_well_formed(strong):
            '''
            A \ B <: T === A <: T | B  
            '''
            return self.solve(premise, strong.context, Unio(weak, strong.negation))


        elif isinstance(weak, Unio): 
            return self.solve(premise, strong, weak.left) + self.solve(premise, strong, weak.right)

        elif isinstance(strong, Inter): 
            return self.solve(premise, strong.left, weak) + self.solve(premise, strong.right, weak)


        #######################################
        #### Unification rules: ####
        #######################################

        elif isinstance(strong, TUnit) and isinstance(weak, TUnit): 
            return [premise] 

        elif isinstance(strong, TTag) and isinstance(weak, TTag): 
            if strong.label == weak.label:
                return self.solve(premise, strong.body, weak.body) 
            else:
                return [] 

        elif isinstance(strong, TField) and isinstance(weak, TField): 
            if strong.label == weak.label:
                return self.solve(premise, strong.body, weak.body) 
            else:
                return [] 



        elif isinstance(strong, Imp) and isinstance(weak, Imp): 
            return [
                p2
                for p1 in self.solve(premise, weak.antec, strong.antec) 
                for p2 in self.solve(p1, strong.consq, weak.consq) 
            ]

        return []

    '''
    end solve
    '''

    def solve_composition(self, strong : Typ, weak : Typ) -> List[Premise]: 
        self._battery = self._max_battery
        premise = Premise(s(), s())
        return self.solve(premise, strong, weak)
    '''
    end solve_composition
    '''


    # TODO: move outside of class
    def from_typ_extract_free_vars(self, bound_vars : PSet[str], typ : Typ) -> PSet[str]:
        if False:
            assert False
        elif isinstance(typ, TVar):
            if typ.id not in bound_vars:
                return pset(typ.id)
            else:
                return pset()
        elif isinstance(typ, TUnit):
            return pset()
        elif isinstance(typ, TTag):
            return self.from_typ_extract_free_vars(bound_vars, typ.body)
        elif isinstance(typ, TField):
            return self.from_typ_extract_free_vars(bound_vars, typ.body)
        elif isinstance(typ, Unio):
            return PSet.union(
                self.from_typ_extract_free_vars(bound_vars, typ.left),
                self.from_typ_extract_free_vars(bound_vars, typ.right),
            ) 
        elif isinstance(typ, Inter):
            return PSet.union(
                self.from_typ_extract_free_vars(bound_vars, typ.left),
                self.from_typ_extract_free_vars(bound_vars, typ.right),
            ) 
        elif isinstance(typ, Diff):
            return PSet.union(
                self.from_typ_extract_free_vars(bound_vars, typ.context),
                self.from_typ_extract_free_vars(bound_vars, typ.negation),
            ) 
        elif isinstance(typ, Imp):
            return PSet.union(
                self.from_typ_extract_free_vars(bound_vars, typ.antec),
                self.from_typ_extract_free_vars(bound_vars, typ.consq),
            ) 
        elif isinstance(typ, IdxUnio):
            bound_vars = PSet.union(bound_vars, typ.ids)
            return PSet.union(
                self.from_constraints_extract_free_vars(bound_vars, typ.constraints),
                self.from_typ_extract_free_vars(bound_vars, typ.body),
            )
        elif isinstance(typ, IdxInter):
            bound_vars = PSet.union(bound_vars, typ.ids)
            return PSet.union(
                self.from_constraints_extract_free_vars(bound_vars, typ.constraints),
                self.from_typ_extract_free_vars(bound_vars, typ.body),
            )
        elif isinstance(typ, Least):
            bound_vars = bound_vars.add(typ.id)
            return self.from_typ_extract_free_vars(bound_vars, typ.body)
        elif isinstance(typ, Bot):
            return pset()
        elif isinstance(typ, Top):
            return pset()
    '''
    end from_typ_extract_free_vars
    '''


    def from_constraints_extract_free_vars(self, bound_vars : PSet[str], constraints : Iterable[Subtyping]) -> PSet[str]:
        result = pset()
        for st in constraints:
            result = PSet.union(result, 
                PSet.union( self.from_typ_extract_free_vars(bound_vars, st.strong), 
                    self.from_typ_extract_free_vars(bound_vars, st.weak)))

        return result

    def extract_reachable_constraints(self, model : Model, id : str) -> Sequence[Subtyping]:
        # TODO
        return [] 

    def package_typ(self, premises : list[Premise], typ : Typ) -> Typ:
        '''
        construct an IdxUnio type, with frozen variables as bound variable.
        '''

        typ_result = Bot()
        ids_base = self.from_typ_extract_free_vars(pset(), typ)
        for premise in premises:
            constraints = pset()
            for id_base in ids_base: 
                constraints = PSet.union(
                    constraints, 
                    self.extract_reachable_constraints(premise.model, id_base)
                )

            ids_constraints = self.from_constraints_extract_free_vars(pset(), constraints)
            ids_bound = PSet.intersection(premise.freezer, ids_constraints)
            typ_idx_unio = IdxUnio(list(ids_bound), list(constraints), typ)
            typ_result = Unio(typ_idx_unio, typ_result)

        return typ_result 


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
        solution = self.solver.solve(Premise(s(), s()), TTag(id, typ_var), self.nt.typ)
        typ_guide = self.solver.package_typ(solution, typ_var)  
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
        solution = self.solver.solve(Premise(s(), s()), Inter(TField('head', typ_var), TField('tail', Bot())), self.nt.typ)
        typ_guide = self.solver.package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), Inter(TField('head', head), TField('tail', typ_var)), self.nt.typ)
        typ_guide = self.solver.package_typ(solution, typ_var)  
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
        solution = self.solver.solve(Premise(s(), s()), implication, premise_conclusion)
        typ_guide = self.solver.package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ_var = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ_var) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve(Premise(s(), s()), implication, premise_conclusion)
        typ_guide = self.solver.package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def combine_ite(self, condition : Typ, branch_true : Typ, branch_false : Typ) -> Typ: 
        solution_true = self.solver.solve(Premise(s(), s()), condition, TTag('true', TUnit()))
        solution_false = self.solver.solve(Premise(s(), s()), condition, TTag('false', TUnit()))

        return Unio(
            self.solver.package_typ(solution_true, branch_true), 
            self.solver.package_typ(solution_false, branch_false), 
        )


    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve(Premise(s(), s()), answr_i, TField(key, answr))
            answr_i = self.solver.package_typ(solution, answr)

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
            solution = self.solver.solve(Premise(s(), s()), answr_i, Imp(argument, answr))
            answr_i = self.solver.package_typ(solution, answr)

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
            solution = self.solver.solve(Premise(s(), s()), Imp(answr_i, answr), cator)
            answr_i = self.solver.package_typ(solution, answr)

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
        solution = self.solver.solve(Premise(s(), s()), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), Inter(TField(id, body), typ), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, Imp(typ_var, Top()))

        typ_guide = self.solver.package_typ(solution, typ_var)
        return Nonterm('pattern', self.nt.enviro, typ_guide)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        conclusion = self.solver.fresh_type_var() 
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, Imp(pattern.typ, conclusion)) 
        conclusion_grounded = self.solver.package_typ(solution, conclusion)
        enviro = self.nt.enviro + pattern.enviro
        return Nonterm('expr', enviro, conclusion_grounded)

    def combine_single(self, pattern : PatternAttr, body : Typ) -> list[Imp]:
        return [Imp(pattern.typ, body)]

    def distill_cons_pattern(self) -> Nonterm:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PatternAttr) -> Nonterm:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PatternAttr, body : Typ) -> Nonterm:
        case_antec = self.solver.fresh_type_var()
        case_consq = self.solver.fresh_type_var()

        choices = from_cases_to_choices([Imp(pattern.typ, body), Imp(case_antec, case_consq)])


        typ_left = self.solver.fresh_type_var()
        typ_right = self.solver.fresh_type_var()
        typ_pair = mk_pair_type(typ_left, typ_right)
        typ_imp = Imp(typ_left, typ_right)

        model = pset(
            Subtyping(typ_pair, mk_pair_type(choice[0], choice[1]))
            for choice in choices
        )

        solution = self.solver.solve(Premise(model, s()), typ_imp, self.nt.typ)
        typ_guide = self.solver.package_typ(solution, Imp(case_antec, case_consq))
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
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, TField(key, typ))
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('keychain', self.nt.enviro, typ_grounded)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, Imp(typ, Top()))
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        solution = self.solver.solve(Premise(s(), s()), self.nt.typ, Imp(head, typ))
        typ_grounded = self.solver.package_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), s()), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), typ, Imp(self.nt.typ, Top()))
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        solution = self.solver.solve(Premise(s(), s()), head, Imp(self.nt.typ, typ))
        typ_grounded = self.solver.package_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), s()), Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), Inter(TField('head', head.typ), TField('tail', typ)), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
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
        solution = self.solver.solve(Premise(s(), s()), typ, self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return PatternAttr(enviro, typ_grounded)

    def combine_unit(self) -> PatternAttr:
        return PatternAttr(m(), TUnit())

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), TTag(id, typ), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), TField(id, typ), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve(Premise(s(), s()), Inter(TField(id, body.typ), typ), self.nt.typ)
        typ_grounded = self.solver.package_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
