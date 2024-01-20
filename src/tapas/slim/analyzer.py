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

from tapas import util_system

T = TypeVar('T')
R = TypeVar('R')


Op = Optional

"""
Typ data types
"""

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


def concretize_ids(ids : list[str]) -> str:
    return ", ".join(ids)

def concretize_constraints(subtypings : list[Subtyping]) -> str:
    return ", ".join([
        concretize_typ(st.strong) + " <: " + concretize_typ(st.weak)
        for st in subtypings
    ])

def concretize_typ(typ : Typ) -> str:
    def make_plate_entry (control : Typ):
        if False: 
            pass
        elif isinstance(control, TVar):
            plate_entry = ([], lambda: control.id)  
        elif isinstance(control, TUnit):
            plate_entry = ([], lambda: "@")  
        elif isinstance(control, TTag):
            plate_entry = ([control.body], lambda body : f":{control.label} {body}")  
        elif isinstance(control, TField):
            plate_entry = ([control.body], lambda body : f"{control.label} : {body}")  
        elif isinstance(control, Imp):
            plate_entry = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})")  
        elif isinstance(control, Unio):
            plate_entry = ([control.left,control.right], lambda left, right : f"({left} | {right})")  
        elif isinstance(control, Inter):
            plate_entry = ([control.left,control.right], lambda left, right : f"({left} & {right})")  
        elif isinstance(control, Diff):
            plate_entry = ([control.context,control.negation], lambda context,negation : f"({context} \\ {negation})")  
        elif isinstance(control, IdxUnio):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate_entry = ([control.body], lambda body : f"{{{ids} . {constraints}}} {body}")  
        elif isinstance(control, IdxInter):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate_entry = ([control.body], lambda body : f"[{ids} . {constraints}] {body}")  
        elif isinstance(control, Least):
            id = control.id
            plate_entry = ([control.body], lambda body : f"least {id} with {body}")  
        elif isinstance(control, Top):
            plate_entry = ([], lambda: "top")  
        elif isinstance(control, Bot):
            plate_entry = ([], lambda: "bot")  

        return plate_entry

    return util_system.make_stack_machine(make_plate_entry)(typ)





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



'''
NOTE: 
Freezer dictates when the strongest solution for a variable is found.
The assignment map could be tracked, or computed lazily when variable is used. 

NOTE: frozen variables correspond to hidden type information of existential/indexed union.

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
        if key in extract_free_vars_from_typ(pset(), st.strong)
    )) 


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

def make_diff(context : Typ, negs : list[Typ]) -> Typ:
    result = context 
    for neg in negs:
        result = Diff(result, neg)
    return result

def make_pair_typ(left : Typ, right : Typ) -> Typ:
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
        choices += [(make_diff(case.antec, negs), case.consq)]
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
        return left.union(right)
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

def extract_strongest_weaker(model : Model, id : str) -> Typ:

    '''
    assumption: strongest weaker is weaker than the stronger types of id:
    H <: X, I <: X - the strongest type weaker than X is H | I
    '''

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

    -------------
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
        if is_relational_key(st.weak) and (id in extract_free_vars_from_typ(pset(), st.weak))
    ]

    typ_factored = Top()
    for st in constraints_relational:
        paths = extract_paths(st.weak, TVar(id)) 
        for path in paths:
            assert isinstance(st.strong, Least)
            typ_labeled = factor_path(path, st.strong)
            typ_factored = Inter(typ_labeled, typ_factored)

    typ_final = Inter(typ_strong, typ_factored)

    return typ_final 

def extract_strongers(model : Model, id : str) -> PSet[Typ]:
    return pset(
        st.strong
        for st in model
        if st.weak == TVar(id)
    )


def extract_constraints_with_id(model : Model, id : str) -> PSet[Subtyping]:
    return pset(
        st
        for st in model
        if id in extract_free_vars_from_constraints(pset(), [st])
    )


def sub_typ(assignment_map : PMap[str, Typ], typ : Typ) -> Typ:
    '''
    assignment_map: map from old id to new id
    '''
    if False:
        assert False
    elif isinstance(typ, TVar):  
        if typ.id in assignment_map:
            return assignment_map[typ.id]
        else:
            return typ
    elif isinstance(typ, TUnit):  
        return typ
    elif isinstance(typ, TTag):  
        return TTag(typ.label, sub_typ(assignment_map, typ.body))
    elif isinstance(typ, TField):  
        return TField(typ.label, sub_typ(assignment_map, typ.body))
    elif isinstance(typ, Unio):  
        return Unio(sub_typ(assignment_map, typ.left), sub_typ(assignment_map, typ.right))
    elif isinstance(typ, Inter):  
        return Inter(sub_typ(assignment_map, typ.left), sub_typ(assignment_map, typ.right))
    elif isinstance(typ, Diff):  
        return Diff(sub_typ(assignment_map, typ.context), sub_typ(assignment_map, typ.negation))
    elif isinstance(typ, Imp):  
        return Imp(sub_typ(assignment_map, typ.antec), sub_typ(assignment_map, typ.consq))
    elif isinstance(typ, IdxUnio):  
        for bid in typ.ids:
            assignment_map = assignment_map.discard(bid)
        return IdxUnio(typ.ids, sub_constraints(assignment_map, typ.constraints), sub_typ(assignment_map, typ.body)) 
    elif isinstance(typ, IdxInter):  
        for bid in typ.ids:
            assignment_map = assignment_map.discard(bid)
        return IdxInter(typ.ids, sub_constraints(assignment_map, typ.constraints), sub_typ(assignment_map, typ.body)) 
    elif isinstance(typ, Least):  
        assignment_map = assignment_map.discard(typ.id)
        return Least(typ.id, sub_typ(assignment_map, typ.body))
    elif isinstance(typ, Top):  
        return typ
    elif isinstance(typ, Bot):  
        return typ
'''
end sub_type
'''

def sub_constraints(assignment_map : PMap[str, Typ], constraints : list[Subtyping]) -> list[Subtyping]:
    return [
        Subtyping(sub_typ(assignment_map, st.strong), sub_typ(assignment_map, st.weak))
        for st in constraints
    ]
'''
end sub_constraints
'''

def extract_free_vars_from_typ(bound_vars : PSet[str], typ : Typ) -> PSet[str]:

    def pair_up(bound_vars, items) -> list:
        return [
            (bound_vars, item)
            for item in items
        ]

    def make_plate_entry(control_pair : tuple[PSet[str], Typ]):

        bound_vars = control_pair[0]
        typ : Typ = control_pair[1]

        if False:
            assert False
        elif isinstance(typ, TVar) and typ.id not in bound_vars:
            plate_entry = ([], lambda : pset().add(typ.id))
        elif isinstance(typ, TVar) :
            plate_entry = ([], lambda : pset())
        elif isinstance(typ, TUnit):
            plate_entry = ([], lambda : pset())
        elif isinstance(typ, TTag):
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_bodyA: set_bodyA)
        elif isinstance(typ, TField):
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_body)
        elif isinstance(typ, Unio):
            plate_entry = (pair_up(bound_vars, [typ.left, typ.right]), lambda set_left, set_right: set_left.union(set_right))
        elif isinstance(typ, Inter):
            plate_entry = (pair_up(bound_vars, [typ.left, typ.right]), lambda set_left, set_right: set_left.union(set_right))
        elif isinstance(typ, Diff):
            plate_entry = (pair_up(bound_vars, [typ.context, typ.negation]), lambda set_context, set_negation: set_context.union(set_negation))
        elif isinstance(typ, Imp):
            plate_entry = (pair_up(bound_vars, [typ.antec, typ.consq]), lambda set_antec, set_consq: set_antec.union(set_consq))
        elif isinstance(typ, IdxUnio):
            bound_vars = bound_vars.union(typ.ids)
            set_constraints = extract_free_vars_from_constraints(bound_vars, typ.constraints)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_constraints.union(set_body))

        elif isinstance(typ, IdxInter):
            bound_vars = bound_vars.union(typ.ids)
            set_constraints = extract_free_vars_from_constraints(bound_vars, typ.constraints)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_constraints.union(set_body))

        elif isinstance(typ, Least):
            bound_vars = bound_vars.add(typ.id)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_body)

        elif isinstance(typ, Bot):
            plate_entry = ([], lambda : pset())

        elif isinstance(typ, Top):
            plate_entry = ([], lambda : pset())

        return plate_entry

    return util_system.make_stack_machine(make_plate_entry)((bound_vars, typ))
'''
end extract_free_vars_from_typ
'''

def extract_free_vars_from_constraints(bound_vars : PSet[str], constraints : Iterable[Subtyping]) -> PSet[str]:
    result = pset()
    for st in constraints:
        result = (
            result
            .union(extract_free_vars_from_typ(bound_vars, st.strong))
            .union(extract_free_vars_from_typ(bound_vars, st.weak))
        )

    return result

def is_variable_unassigned(premise : Premise, id : str) -> bool:
    return (
        id not in extract_free_vars_from_constraints(pset(), premise.model) and
        id not in premise.freezer and
        True
    )

def extract_reachable_constraints(model : Model, id : str, constraints : PSet[Subtyping]) -> PSet[Subtyping]:
    constraints_with_id = extract_constraints_with_id(model, id) 
    diff = constraints_with_id.difference(constraints)
    ids = extract_free_vars_from_constraints(pset(), diff)
    for id in ids:
        constraints = constraints.union(
            extract_reachable_constraints(model, id, constraints)
        ) 

    return constraints 

def package_typ(premises : list[Premise], typ : Typ) -> Typ:
    '''
    construct an IdxUnio type, with frozen variables as bound variable.
    '''

    typ_result = Bot()
    ids_base = extract_free_vars_from_typ(pset(), typ)
    for premise in premises:
        constraints = pset()
        for id_base in ids_base: 
            constraints_reachable = extract_reachable_constraints(premise.model, id_base, constraints)
             #constraints = constraints.union(constraints_reachable)

        ids_constraints = extract_free_vars_from_constraints(pset(), constraints)
        ids_bound = premise.freezer.intersection(ids_constraints)

        typ_idx_unio = IdxUnio(list(ids_bound), list(constraints), typ)
        typ_result = Unio(typ_idx_unio, typ_result)

    return typ_result 


class Solver:
    _type_id : int = 0 
    _battery : int = 0 
    _max_battery : int = 100

    def set_max_battery(self, max_battery : int):
        self._max_battery = max_battery 

    def fresh_type_var(self) -> TVar:
        self._type_id += 1
        return TVar(f"_{self._type_id}")

    def make_renaming(self, old_ids) -> PMap[str, Typ]:
        '''
        Map old_ids to fresh ids
        '''
        d = {}
        for old_id in old_ids:
            fresh = self.fresh_type_var()
            d[old_id] = fresh

        return pmap(d)




    def solve(self, premise : Premise, strong : Typ, weak : Typ) -> list[Premise]:

        if False: 
            return [] 

        #######################################
        #### Variable rules: ####
        #######################################

        elif isinstance(weak, TVar): 
            frozen = weak.id in premise.freezer
            weak_strongest_weaker = extract_strongest_weaker(premise.model, weak.id)
            solution = self.solve(premise, strong, weak_strongest_weaker)
            if solution:
                if frozen:
                    return solution
                else:
                    '''
                    add constraint and wait for more information
                    '''
                    return [Premise(premise.model.add(Subtyping(strong, weak)), premise.freezer)]
            else:
                return []

        elif isinstance(strong, TVar): 
            frozen = strong.id in premise.freezer
            if frozen:
                strong_strongest_weaker = extract_strongest_weaker(premise.model, strong.id)
                '''
                NOTE: 
                assumption: strong_strongest_weaker is already safe wrt existing stronger types 
                '''
                return self.solve(premise, strong_strongest_weaker, weak) 
            else:
                '''
                NOTE: ensure that (U <: Weak) before adding (Strong <: Weak)  
                
                U <: Strong 
                |-
                Strong <: Weak 
                '''

                strongers = extract_strongers(premise.model, strong.id)
                if (
                    any(
                        not self.solve(premise, stronger, weak) 
                        for stronger in strongers 
                    )
                ) :
                    '''
                    failure
                    '''
                    return []
                else:
                    return [Premise(premise.model.add(Subtyping(strong, weak)), premise.freezer)]

        #######################################
        #### Model rules: ####
        #######################################

        elif isinstance(strong, IdxUnio):
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)
            freezer = premise.freezer.union(t.id for t in renaming.values() if isinstance(t, TVar))

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
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)
            freezer = premise.freezer.union(t.id for t in renaming.values() if isinstance(t, TVar))

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
                    tvar_fresh = self.fresh_type_var()
                    renaming : PMap[str, Typ] = pmap({strong.id : tvar_fresh})
                    strong_body = sub_typ(renaming, strong.body)

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
            # TODO: remove; doesn't seem to be necessary
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
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)

            solution = self.solve(premise, strong, weak_body) 
            ids_ground = (t.id for t in renaming.values() if isinstance(t, TVar))

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
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)

            solution = self.solve(premise, strong_body, weak) 
            ids_ground = (t.id for t in renaming.values() if isinstance(t, TVar))

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
            if not is_relational_key(strong) and self._battery > 0:
                self._battery -= 1
                tvar_fresh = self.fresh_type_var()
                unrolling = Subtyping(tvar_fresh, weak)
                model = premise.model.add(unrolling)
                freezer = premise.freezer.add(tvar_fresh.id)
                renaming : PMap[str, Typ] = pmap({weak.id : tvar_fresh})
                weak_body = sub_typ(renaming, weak.body)
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
        solution = self.solver.solve_composition(TTag(id, typ_var), self.nt.typ)
        typ_guide = package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide)

    def combine_tag(self, label : str, body : Typ) -> Typ:
        return TTag(label, body)

    def combine_function(self, cases : list[Imp]) -> Typ:
        '''
        Example
        ==============
        nil -> zero
        cons A -> succ B 
        --------------------
        [X . X <: nil | cons A] X -> {Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)} Y
        '''
        choices = from_cases_to_choices(cases)
        rel = Bot() 
        for choice in reversed(choices): 
            rel = Unio(make_pair_typ(*choice), rel)

        antec = Bot()  
        for case in reversed(cases): 
            antec = Unio(case.antec, antec)

        var_antec = self.solver.fresh_type_var()
        var_concl = self.solver.fresh_type_var()
        var_pair = make_pair_typ(var_antec, var_concl)

        return IdxInter([var_antec.id], [Subtyping(var_antec, antec)],
            Imp(
                var_antec,
                IdxUnio([var_concl.id], [Subtyping(var_pair, rel)], var_concl)
            )
        )   


class ExprRule(Rule):

    def distill_tuple_head(self) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(Inter(TField('head', typ_var), TField('tail', Bot())), self.nt.typ)
        typ_guide = package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(Inter(TField('head', head), TField('tail', typ_var)), self.nt.typ)
        typ_guide = package_typ(solution, typ_var)  
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
        solution = self.solver.solve_composition(implication, premise_conclusion)
        typ_guide = package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ_var = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ_var) 
        premise_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve_composition(implication, premise_conclusion)
        typ_guide = package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def combine_ite(self, condition : Typ, branch_true : Typ, branch_false : Typ) -> Typ: 
        solution_true = self.solver.solve_composition(condition, TTag('true', TUnit()))
        solution_false = self.solver.solve_composition(condition, TTag('false', TUnit()))

        return Unio(
            package_typ(solution_true, branch_true), 
            package_typ(solution_false, branch_false), 
        )


    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            solution = self.solver.solve_composition(answr_i, TField(key, answr))
            answr_i = package_typ(solution, answr)

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
            solution = self.solver.solve_composition(answr_i, Imp(argument, answr))
            answr_i = package_typ(solution, answr)

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
            solution = self.solver.solve_composition(Imp(answr_i, answr), cator)
            answr_i = package_typ(solution, answr)

        return answr_i
    #########


    def distill_fix_body(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def combine_fix(self, body : Typ) -> Typ:
        typ_self = self.solver.fresh_type_var()
        typ_content = self.solver.fresh_type_var()

        typ_self_in = self.solver.fresh_type_var()
        typ_self_out = self.solver.fresh_type_var()

        typ_content_in = self.solver.fresh_type_var()
        typ_content_out = self.solver.fresh_type_var()

        solution = [
            p2
            for p0 in self.solver.solve_composition(body, Imp(typ_self, typ_content))
            for p1 in self.solver.solve(p0, typ_self, Imp(typ_self_in, typ_self_out))
            for p2 in self.solver.solve(p1, typ_content, Imp(typ_content_in, typ_content_out))
        ]

        tvar_fixy = self.solver.fresh_type_var()

        rel_unio = Bot()
        antec_unio = Bot()
        for premise in reversed(solution):
            typ_content_pair = make_pair_typ(typ_content_in, typ_content_out)
            typ_self_pair = make_pair_typ(typ_self_in, typ_self_out)

            free_vars_content = extract_free_vars_from_typ(pset(), typ_content_pair)
            free_vars_self = extract_free_vars_from_typ(pset(), typ_self_pair)

            if (free_vars_content.intersection(free_vars_self)) :
                model = premise.model.add(Subtyping(typ_self_pair, tvar_fixy))
                premise = Premise(model, premise.freezer)

            rel_choice = package_typ([premise], typ_content_pair) 
            rel_unio = Unio(rel_choice, rel_unio) 

            antec_choice = package_typ([premise], typ_content_in) 
            antec_unio = Unio(antec_choice, antec_unio) 


        rel = Least(tvar_fixy.id, rel_unio)
        antec = Least(tvar_fixy.id, antec_unio)
        var_antec = self.solver.fresh_type_var()
        var_concl = self.solver.fresh_type_var()
        var_pair = make_pair_typ(var_antec, var_concl)

        return IdxInter([var_antec.id], [Subtyping(var_antec, antec)],
            Imp(
                var_antec,
                IdxUnio([var_concl.id], [Subtyping(var_pair, rel)], var_concl)
            )
        )   
    
    def distill_let_target(self, id : str) -> Nonterm:
        return Nonterm('target', self.nt.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Nonterm:
        '''
        assumption: target type is assumed to be well formed / inhabitable
        '''
        free_ids = extract_free_vars_from_typ(pset(), target)
        target_generalized = IdxInter(list(free_ids), [], target)
        enviro = self.nt.enviro.set(id, target_generalized)
        return Nonterm('expr', enviro, self.nt.typ)

'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(TField(id, typ), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(Inter(TField(id, body), typ), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(self.nt.typ, Imp(typ_var, Top()))

        typ_guide = package_typ(solution, typ_var)
        return Nonterm('pattern', self.nt.enviro, typ_guide)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        conclusion = self.solver.fresh_type_var() 
        solution = self.solver.solve_composition(self.nt.typ, Imp(pattern.typ, conclusion)) 
        conclusion_grounded = package_typ(solution, conclusion)
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
        typ_pair = make_pair_typ(typ_left, typ_right)
        typ_imp = Imp(typ_left, typ_right)

        model = pset(
            Subtyping(typ_pair, make_pair_typ(choice[0], choice[1]))
            for choice in choices
        )

        solution = self.solver.solve(Premise(model, s()), typ_imp, self.nt.typ)
        typ_guide = package_typ(solution, Imp(case_antec, case_consq))
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
        solution = self.solver.solve_composition(self.nt.typ, TField(key, typ))
        typ_grounded = package_typ(solution, typ)
        return Nonterm('keychain', self.nt.enviro, typ_grounded)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):

    def distill_single_content(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(self.nt.typ, Imp(typ, Top()))
        typ_grounded = package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(self.nt.typ, Imp(typ, Top()))
        typ_grounded = package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ):
        typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        solution = self.solver.solve_composition(self.nt.typ, Imp(head, typ))
        typ_grounded = package_typ(solution, typ)
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
        solution = self.solver.solve_composition(typ, Imp(self.nt.typ, Top()))
        typ_grounded = package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)


    def distill_cons_head(self):
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(typ, Imp(self.nt.typ, Top()))
        typ_grounded = package_typ(solution, typ)
        return Nonterm('expr', self.nt.enviro, typ_grounded)

    def distill_cons_tail(self, head : Typ) -> Nonterm:
        typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        solution = self.solver.solve_composition(head, Imp(self.nt.typ, typ))
        typ_grounded = package_typ(solution, typ)
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
        solution = self.solver.solve_composition(Inter(TField('head', typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(Inter(TField('head', head.typ), TField('tail', typ)), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
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
        solution = self.solver.solve_composition(typ, self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return PatternAttr(enviro, typ_grounded)

    def combine_unit(self) -> PatternAttr:
        return PatternAttr(m(), TUnit())

    def distill_tag_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(TTag(id, typ), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('pattern', self.nt.enviro, typ_grounded)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(TField(id, typ), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        typ = self.solver.fresh_type_var()
        solution = self.solver.solve_composition(Inter(TField(id, body.typ), typ), self.nt.typ)
        typ_grounded = package_typ(solution, typ)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
