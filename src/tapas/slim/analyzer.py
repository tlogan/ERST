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
    ids : tuple[str, ...]
    constraints : tuple[Subtyping, ...] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class IdxInter:
    id : str
    upper : Typ 
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
    constraints : tuple[SubtypingNL, ...] 
    body : NL 

@dataclass(frozen=True, eq=True)
class IdxInterNL:
    upper : NL 
    body : NL 

@dataclass(frozen=True, eq=True)
class LeastNL:
    body : NL 

@dataclass(frozen=True, eq=True)
class SubtypingNL:
    strong : NL 
    weak : NL 

NL = Union[TVar, BVar, TUnit, TTagNL, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, IdxUnioNL, IdxInterNL, LeastNL, Top, Bot]

def to_nameless(bound_ids : tuple[str, ...], typ : Typ) -> NL:
    assert isinstance(bound_ids, tuple)
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
        # bound_ids = typ.ids + bound_ids
        bound_ids = tuple(typ.ids) + bound_ids

        constraints_nl = tuple(
            SubtypingNL(to_nameless(bound_ids, st.strong), to_nameless(bound_ids, st.weak))
            for st in typ.constraints
        )
        return IdxUnioNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, IdxInter):
        bound_ids = tuple([typ.id]) + bound_ids
        return IdxInterNL(to_nameless(bound_ids, typ.upper), to_nameless(bound_ids, typ.body))

    elif isinstance(typ, Least):
        bound_ids = tuple([typ.id]) + bound_ids
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


def concretize_ids(ids : tuple[str, ...]) -> str:
    return " ".join(ids)

def concretize_constraints(subtypings : tuple[Subtyping, ...]) -> str:
    return " ; ".join([
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
            plate_entry = ([control.body], lambda body : f"~{control.label} {body}")  
        elif isinstance(control, TField):
            plate_entry = ([control.body], lambda body : f"{control.label} : {body}")  
        elif isinstance(control, Imp):
            plate_entry = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})")  
        elif isinstance(control, Unio):
            plate_entry = ([control.left,control.right], lambda left, right : f"({left} | {right})")  
        elif isinstance(control, Inter):
            if (
                isinstance(control.left, TField) and control.left.label == "left" and 
                isinstance(control.right, TField) and control.right.label == "right" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({left}, {right})")  
            else:
                plate_entry = ([control.left,control.right], lambda left, right : f"({left} & {right})")  
        elif isinstance(control, Diff):
            plate_entry = ([control.context,control.negation], lambda context,negation : f"({context} \\ {negation})")  
        elif isinstance(control, IdxUnio):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate_entry = ([control.body], lambda body : f"({{{ids} . {constraints}}} {body})")  
        elif isinstance(control, IdxInter):
            id = control.id
            plate_entry = ([control.upper, control.body], lambda upper, body : f"([{id} <: {upper}] {body})")  
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
    enviro : PMap[str, Typ] 
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


def by_variable(constraints : PSet[Subtyping], key : str) -> PSet[Subtyping]: 
    return pset((
        st
        for st in constraints
        if key in extract_free_vars_from_typ(pset(), st.strong)
    )) 





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
        return pset()


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
        new_constraints = tuple(
            (
            Subtyping(extract_field_plain(path, st.strong), TVar(id_induc))
            if st.weak == TVar(id_induc) else
            st
            )
            for st in t.constraints
        )
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

def insert_at_path(m : PMap, path : list[str], o):
    if path:
        key = path[0]  
        if key in m:
            assert path[1:]
            n = m[key] 
            return m.add({key : insert_at_path(n, path[1:], o)})
        else:
            return m.add({key : insert_at_path(pmap(), path[1:], o)})
    else:
        return o


def to_record_typ(m) -> Typ:
    result = Top()
    for key in m:
        v = m[key]
         
        if isinstance(v, Typ):
            field = TField(key, v)
        else:
            t = to_record_typ(v)
            field = TField(key, t)
        result = Inter(field, result)
    return result



def factor_least(least : Least) -> Typ:
    choices = linearize_unions(least.body)
    paths = [
        path
        for choice in choices
        for path in list(extract_paths(choice))
    ]

    m = pmap() 
    for path in paths:
        column = extract_column(path, least.id, choices)
        m = insert_at_path(m, path, column)

    return to_record_typ(m) 

def alpha_equiv(t1 : Typ, t2 : Typ) -> bool:
    return to_nameless((), t1) == to_nameless((), t2)

def is_relational_key(model : Model, t : Typ) -> bool:
    if isinstance(t, TField):
        if isinstance(t.body, TVar):
            strongest = extract_strongest(model, t.body.id) 
            return isinstance(strongest, Bot) or is_relational_key(model, strongest)
        else:
            return is_relational_key(model, t.body)
        # TODO: remove old code
        # return (
        #     isinstance(t.body, TVar) and 
        #     (t.body.id not in freezer) 
        # ) or is_relational_key(freezer, t.body) 
    elif isinstance(t, Inter):
        return is_relational_key(model, t.left) and is_relational_key(model, t.right)
    else:
        return False

def match_strong(model : Model, strong : Typ) -> Optional[Typ]:
    for constraint in model:
        if strong == constraint.strong:
            return constraint.weak
    return None

def extract_weakest(model : Model, id : str) -> Typ:

    '''
    for constraints X <: T, <: U; find weakest type stronger than T, stronger than U
    which is T & U.
    NOTE: related to weakest precondition concept
    '''
    typs_strengthen = [
        st.weak
        for st in model
        if st.strong == TVar(id)
    ]
    typ_strong = Top() 
    for t in reversed(typs_strengthen):
        typ_strong = Inter(t, typ_strong) 


    '''
    LHS variables in relational constraints: always have relation of variables on LHS; need to factor; then perform union after
    case relational: if variable is part of relational constraint, factor out type from rhs
    case simple: otherwise, extract rhs
    -- NOTE: relational constraints are restricted to record types of variables
    -- NOTE: tail-recursion, e.g. reverse list, requires patterns in relational constraint, but, that's bound inside of Least
    -- e.g. (A, B, C, L) <: (Least I . (nil, Y, Y) | {(X, cons Y, Z) <: I} (cons X, Y, Z))
    ---------------
    '''
    constraints_relational = [
        st
        for st in model
        if is_relational_key(model, st.weak) and (id in extract_free_vars_from_typ(pset(), st.weak))
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

# TODO: remove option in return type; remove exclude param
def extract_strongest(model : Model, id : str) -> Typ:
    '''
    for constraints T <: X, U <: X; find strongest type weaker than T, weaker than U
    which is T | U.
    NOTE: related to strongest postcondition concept
    '''
    typs_weaken = [
        st.strong
        for st in model
        if st.weak == TVar(id) 
    ]
    typ_weak = Bot() 
    for t in reversed(typs_weaken):
        typ_weak = Unio(t, typ_weak) 
    return typ_weak


def condense_strongest(model : Model, seen : PSet[str], typ : Typ) -> Typ:
    '''
    @param seen : tracks variables that have been seen. used to prevent cycling 
    '''
    if isinstance(typ, Imp):
        antec = condense_weakest(model, seen, typ.antec)
        consq = condense_strongest(model, seen, typ.consq)
        return Imp(antec, consq)
    else:
        fvs = extract_free_vars_from_typ(pset(), typ)
        seen = seen.union(fvs) 
        renaming = pmap({
            id : condense_strongest(model, seen, extract_strongest(model, id))
            for id in fvs
        })
        return sub_typ(renaming, typ)

def condense_weakest(model : Model, seen : PSet[str], typ : Typ) -> Typ:
    '''
    The weakest type that we can determine a abstract type must be
    @param seen : tracks variables that have been seen. used to prevent cycling 
    '''
    if isinstance(typ, Imp):
        antec = condense_strongest(model, seen, typ.antec)
        consq = condense_weakest(model, seen, typ.consq)
        return Imp(antec, consq)
    else:
        fvs = extract_free_vars_from_typ(pset(), typ)
        seen = seen.union(fvs) 
        renaming = pmap({
            id : condense_weakest(model, seen, extract_weakest(model, id))
            for id in fvs
        })
        return sub_typ(renaming, typ)


def simplify_typ(typ : Typ) -> Typ:

    if False:
        assert False
    elif isinstance(typ, TTag):
            return TTag(typ.label, simplify_typ(typ.body))
    elif isinstance(typ, TField):
            return TField(typ.label, simplify_typ(typ.body))
    elif isinstance(typ, Inter): 
        typ = Inter(simplify_typ(typ.left), simplify_typ(typ.right))
        if typ.left == Top():
            return typ.right
        elif typ.right == Top() or alpha_equiv(typ.left, typ.right):
            return typ.left
        else:
            return typ
    elif isinstance(typ, Unio): 
        typ = Unio(simplify_typ(typ.left), simplify_typ(typ.right))
        if typ.left == Bot():
            return typ.right
        elif typ.right == Bot() or alpha_equiv(typ.left, typ.right):
            return typ.left
        else:
            return typ
    elif isinstance(typ, Diff): 
        typ = Diff(simplify_typ(typ.context), simplify_typ(typ.negation))
        if typ.negation == Bot():
            return typ.context
        else:
            return typ
    elif isinstance(typ, Imp): 
        return Imp(simplify_typ(typ.antec), simplify_typ(typ.consq))
    elif isinstance(typ, IdxUnio):
        return IdxUnio(typ.ids, simplify_constraints(typ.constraints), simplify_typ(typ.body))
    elif isinstance(typ, IdxInter):
        return IdxInter(typ.id, simplify_typ(typ.upper), simplify_typ(typ.body))
    elif isinstance(typ, Least):
        return Least(typ.id, simplify_typ(typ.body))
    else:
        return typ
    
def simplify_constraints(constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(simplify_typ(st.weak), simplify_typ(st.strong))
        for st in constraints
    )

# TODO: remove weird kludgy concept
# def prettify_strongest_influence(model : Model, typ : Typ) -> str:
#     # return concretize_typ((condense_strongest_influence(model, pset(), typ)))
#     return concretize_typ(simplify_typ(condense_strongest_influence(model, pset(), typ)))


def prettify_weakest(model : Model, typ : Typ) -> str:
    return concretize_typ(simplify_typ(condense_weakest(model, pset(), typ)))


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
        assignment_map = assignment_map.discard(typ.id)
        return IdxInter(typ.id, sub_typ(assignment_map, typ.upper), sub_typ(assignment_map, typ.body)) 
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

def sub_constraints(assignment_map : PMap[str, Typ], constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(sub_typ(assignment_map, st.strong), sub_typ(assignment_map, st.weak))
        for st in constraints
    )
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
            set_constraints = pset()
            plate_entry = (pair_up(bound_vars, [typ.upper, typ.body]), lambda set_upper, set_body: set_constraints.union(set_upper).union(set_body))

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

def is_variable_unassigned(model : Model, id : str) -> bool:
    return (
        id not in extract_free_vars_from_constraints(pset(), model)
    )

def extract_reachable_constraints(model : Model, id : str, ids_seen : PSet[str]) -> PSet[Subtyping]:
    constraints = extract_constraints_with_id(model, id) 
    ids_seen = ids_seen.add(id)
    ids = extract_free_vars_from_constraints(pset(), constraints).difference(ids_seen)
    for id in ids:
        constraints = constraints.union(
            extract_reachable_constraints(model, id, ids_seen)
        ) 

    return constraints 

def package_typ(models : list[Model], typ : Typ) -> Typ:
    typ_result = Bot()
    ids_base = extract_free_vars_from_typ(pset(), typ)
    for model in models:
        constraints = pset()
        for id_base in ids_base: 
            constraints_reachable = extract_reachable_constraints(model, id_base, pset())
            constraints = constraints.union(constraints_reachable)

        ids_constraints = extract_free_vars_from_constraints(pset(), constraints)
        ids_bound = ids_constraints

        typ_idx_unio = IdxUnio(tuple(ids_bound), tuple(constraints), typ)
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




    def solve(self, model : Model, strong : Typ, weak : Typ) -> list[Model]:

#         print(f'''
# || DEBUG SOLVE
# =================
# || ------------
# || model: {concretize_constraints(tuple(model))}
# || |- {concretize_typ(strong)} <: {concretize_typ(weak)}
#         ''')

        # if alpha_equiv(strong, weak): 
        #     return [model] 

        if False:
            return [] 

        #######################################
        #### Variable rules: ####
        #######################################
        elif isinstance(strong, TVar): 
            '''
            X <: T
            '''

            # print(f''' 
            # DEBUG (strong, TVar)
            # model: {concretize_constraints(list(model))}
            # ---- |- ----------------------------------------
            # strong: {concretize_typ(strong)}
            # ---- <: ----------------------------------------
            # weak: {concretize_typ(weak)}
            # ''')
            strongest = extract_strongest(model, strong.id)
            if isinstance(strongest, Bot):
                return [model.add(Subtyping(strong, weak))]
            else:
                models = self.solve(model, strongest, weak)

                return [
                    model.add(Subtyping(strong, weak))
                    for model in models
                ]

        elif isinstance(weak, TVar): 
            '''
            T <: X
            '''

            # print(f''' 
            # DEBUG (weak, TVar)
            # model: {concretize_constraints(list(model))}
            # ---- |- ----------------------------------------
            # strong: {concretize_typ(strong)}
            # ---- <: ----------------------------------------
            # weak: {concretize_typ(weak)}
            # ''')

            weakest = extract_weakest(model, weak.id)
            if isinstance(weakest, Top):
                return [model.add(Subtyping(strong, weak))]
            else:
                models = self.solve(model, strong, weakest)
                models = [
                    model.add(Subtyping(strong, weak))
                    for model in models
                ]

                return models



        #######################################
        #### Model rules: ####
        #######################################

        elif isinstance(strong, IdxUnio):
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)

            models = [model]
            for constraint in strong_constraints:
                models = [
                    m1
                    for m0 in models
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]  

            return [
                m1
                for m0 in models
                for m1 in self.solve(m0, strong_body, weak)
            ]

        elif isinstance(weak, IdxInter):
            tvar_fresh = self.fresh_type_var()
            renaming = pmap({weak.id : tvar_fresh})
            weak_upper = sub_typ(renaming, weak.upper)
            weak_body = sub_typ(renaming, weak.body)

            models = self.solve(model, tvar_fresh, weak_upper)

            return [
                m1
                for m0 in models
                for m1 in self.solve(m0, strong, weak_body)
            ]

        elif isinstance(strong, Least):
            if alpha_equiv(strong, weak):
                return [model]
            else:
                solution = []

                strong_factored = factor_least(strong)
                solution = self.solve(model, strong_factored, weak)

                if solution == []:
                    '''
                    NOTE: k-induction
                    use the pattern on LHS to dictate number of unrollings needed on RHS 
                    simply need to sub RHS into LHS's self-referencing variable
                    '''
                    '''
                    sub in induction hypothesis to model:
                    '''
                    renaming : PMap[str, Typ] = pmap({strong.id : weak})
                    strong_body = sub_typ(renaming, strong.body)
                    return self.solve(model, strong_body, weak)
                    
                else:
                    return solution

        elif isinstance(weak, Imp) and isinstance(weak.antec, Unio):
            '''
            antecedent union: strong <: ((T1 | T2) -> TR)
            A -> Q & B -> Q ~~~ A | B -> Q
            '''
            return [
                m1 
                for m0 in self.solve(model, strong, Imp(weak.antec.left, weak.consq))
                for m1 in self.solve(m0, strong, Imp(weak.antec.right, weak.consq))
            ]

        elif isinstance(weak, Imp) and isinstance(weak.consq, Inter):
            # TODO: remove; doesn't seem to be necessary
            '''
            consequent intersection: strong <: (TA -> (T1 & T2))
            P -> A & P -> B ~~~ P -> A & B 
            '''
            return [
                m1 
                for m0 in self.solve(model, strong, Imp(weak.antec, weak.consq.left))
                for m1 in self.solve(m0, strong, Imp(weak.antec, weak.consq.right))
            ]

        # NOTE: field body intersection: strong <: (:label = (T1 & T2))
        # l : A & l : B ~~~ l : A & B 
        elif isinstance(weak, TField) and isinstance(weak.body, Inter):
            return [
                m1
                for m0 in self.solve(model, strong, TField(weak.label, weak.body.left))
                for m1 in self.solve(m0, strong, TField(weak.label, weak.body.right))
            ]

        elif isinstance(strong, Unio):
            return [
                m1
                for m0 in self.solve(model, strong.left, weak)
                for m1 in self.solve(m0, strong.right, weak)
            ]

        elif isinstance(weak, Inter):
            return [
                m1 
                for m0 in self.solve(model, strong, weak.left)
                for m1 in self.solve(m0, strong, weak.right)
            ]

        elif isinstance(weak, Diff) and diff_well_formed(weak):
            '''
            T <: A \\ B === (T <: A), ~(T <: B) 
            '''
            return [
                m
                for m in self.solve(model, strong, weak.context)
                if self.solve(m, strong, weak.negation) == []
            ]
        

        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(weak, Top): 
            return [model] 

        elif isinstance(strong, Bot): 
            return [model] 

        elif isinstance(weak, IdxUnio): 
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)

            unio_indices = pset(t.id for t in renaming.values() if isinstance(t, TVar))
            models = self.solve(model, strong, weak_body) 
            # '''
            # - add upper bound constraints to unio_indices after solving
            # - rationale is that all inputs are also output
            # '''
            # models = [
            #     model.union( 
            #         Subtyping(TVar(id), extract_strongest(model, id))
            #         for id in unio_indices
            #     )
            #     for model in models
            # ]


            for constraint in weak_constraints:
                models = [
                    m1
                    for m0 in models
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]
            return models


        elif isinstance(strong, IdxInter): 
            tvar_fresh = self.fresh_type_var()
            renaming = pmap({strong.id : tvar_fresh})
            strong_upper = sub_typ(renaming, strong.upper)
            strong_body = sub_typ(renaming, strong.body)

            inter_indices = (t.id for t in renaming.values() if isinstance(t, TVar))
            models = self.solve(model, strong_body, weak) 

            # '''
            # - add upper bound constraints to unio_indices after solving
            # - rationale is that all inputs are also output
            # '''
            # models = [
            #     model.union( 
            #         Subtyping(TVar(id), extract_strongest(model, id))
            #         for id in inter_indices
            #     )
            #     for model in models
            # ]

            return [
                m1
                for m0 in models
                for m1 in self.solve(m0, tvar_fresh, strong_upper)
            ]   

        elif isinstance(weak, Least): 

            # print(f'''
            # DEBUG (weak, Least):
            # model: {(len(model.model))}
            # frozen: {list(model.freezer)}
            # strong: {concretize_typ(strong)}
            # weak: {concretize_typ(weak)}
            # Will unroll?: {not is_relational_key(model, strong)}
            # ''')

            if not is_relational_key(model, strong) and self._battery > 0:
                self._battery -= 1
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({weak.id : weak})
                weak_body = sub_typ(renaming, weak.body)
                return self.solve(model, strong, weak_body)
            else:
                weak_cache = match_strong(model, strong)
                if weak_cache:
                    return self.solve(model, weak_cache, weak)
                else:
                    factored = factor_least(weak)
                    solution = self.solve(model, weak, factored)  
                    if solution:
                        """
                        relational constraint must be well formed, since a matching factorization exists
                        update model with well formed constraint that can't yet be solved
                        relational_key is well formed
                        and matches the cases of the weak type
                        """
                        return [model.add(Subtyping(strong, weak))]
                    else:
                        return []

        elif isinstance(strong, Diff) and diff_well_formed(strong):
            '''
            A \\ B <: T === A <: T | B  
            '''
            return self.solve(model, strong.context, Unio(weak, strong.negation))


        elif isinstance(weak, Unio): 
            return self.solve(model, strong, weak.left) + self.solve(model, strong, weak.right)

        elif isinstance(strong, Inter): 
            return self.solve(model, strong.left, weak) + self.solve(model, strong.right, weak)


        #######################################
        #### Unification rules: ####
        #######################################

        elif isinstance(strong, TUnit) and isinstance(weak, TUnit): 
            return [model] 

        elif isinstance(strong, TTag) and isinstance(weak, TTag): 
            if strong.label == weak.label:
                return self.solve(model, strong.body, weak.body) 
            else:
                return [] 

        elif isinstance(strong, TField) and isinstance(weak, TField): 
            if strong.label == weak.label:
                return self.solve(model, strong.body, weak.body) 
            else:
                return [] 

        elif isinstance(strong, Imp) and isinstance(weak, Imp): 
            return [
                m1
                for m0 in self.solve(model, weak.antec, strong.antec) 
                for m1 in self.solve(m0, strong.consq, weak.consq) 
            ]

        return []

    '''
    end solve
    '''

    def solve_composition(self, strong : Typ, weak : Typ) -> List[Model]: 
        self._battery = self._max_battery
        model = s()
        return self.solve(model, strong, weak)
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
        (nil -> zero) & (cons A\\nil -> succ B)
        --------------- OR -----------------------
        [X . X <: nil | cons A] X -> {Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)} Y
        '''

#         for case in cases:
#             print(f"""
# ---------------
# DEBUG case.antec: {case.antec}
# ---------------
#             """)
        choices = from_cases_to_choices(cases)
#         for choice in choices:
#             print(f"""
# ---------------
# DEBUG choice[0]: {choice[0]}
# ---------------
#             """)

        result = Top() 
        for choice in reversed(choices): 
            result = Inter(Imp(choice[0], choice[1]), result)
        return result

        # OLD construction of relation
        # rel = Bot() 
        # for choice in reversed(choices): 
        #     rel = Unio(make_pair_typ(*choice), rel)

        # antec = Bot()  
        # for case in reversed(cases): 
        #     antec = Unio(case.antec, antec)

        # var_antec = self.solver.fresh_type_var()
        # var_concl = self.solver.fresh_type_var()
        # var_pair = make_pair_typ(var_antec, var_concl)

        # return IdxInter(var_antec.id, antec,
        #     Imp(
        #         var_antec,
        #         IdxUnio(tuple([var_concl.id]), tuple([Subtyping(var_pair, rel)]), var_concl)
        #     )
        # )   


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
        model_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve_composition(implication, model_conclusion)
        typ_guide = package_typ(solution, typ_var)  
        return Nonterm('expr', self.nt.enviro, typ_guide) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        typ_var = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), typ_var) 
        model_conclusion = Imp(condition, self.nt.typ)
        solution = self.solver.solve_composition(implication, model_conclusion)
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
            # TODO: Remove commented code
            # No need to extract strongest weaker
            # '''
            # extract strongest weaker to use as return type
            # '''
            # solution = [
            #     Model(p0.model.add(Subtyping(answr, typ_return)), p0.freezer.add(answr.id))
            #     for p0 in self.solver.solve_composition(answr_i, Imp(argument, answr))
            #     for typ_return in [extract_strongest(p0.model, answr.id)]
            # ]

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
            m2
            for m0 in self.solver.solve_composition(body, Imp(typ_self, typ_content))
            for m1 in self.solver.solve(m0, typ_self, Imp(typ_self_in, typ_self_out))
            for m2 in self.solver.solve(m1, typ_content, Imp(typ_content_in, typ_content_out))
        ]

        tvar_fixy = self.solver.fresh_type_var()

        rel_unio = Bot()
        antec_unio = Bot()
        for model in reversed(solution):
            typ_content_pair = make_pair_typ(typ_content_in, typ_content_out)
            typ_self_pair = make_pair_typ(typ_self_in, typ_self_out)

            free_vars_content = extract_free_vars_from_typ(pset(), typ_content_pair)
            free_vars_self = extract_free_vars_from_typ(pset(), typ_self_pair)

            if (free_vars_content.intersection(free_vars_self)) :
                model = model.add(Subtyping(typ_self_pair, tvar_fixy))

            rel_choice = package_typ([model], typ_content_pair) 
            rel_unio = Unio(rel_choice, rel_unio) 

            antec_choice = package_typ([model], typ_content_in) 
            antec_unio = Unio(antec_choice, antec_unio) 


        rel = Least(tvar_fixy.id, rel_unio)
        antec = Least(tvar_fixy.id, antec_unio)
        var_antec = self.solver.fresh_type_var()
        var_concl = self.solver.fresh_type_var()
        var_pair = make_pair_typ(var_antec, var_concl)

        return IdxInter(var_antec.id, antec,
            Imp(
                var_antec,
                IdxUnio(tuple([var_concl.id]), tuple([Subtyping(var_pair, rel)]), var_concl)
            )
        )   
    
    def distill_let_target(self, id : str) -> Nonterm:
        return Nonterm('target', self.nt.enviro, Top())

    def distill_let_contin(self, id : str, target : Typ) -> Nonterm:
        '''
        assumption: target type is assumed to be well formed / inhabitable
        '''
        free_ids = extract_free_vars_from_typ(pset(), target)
        target_generalized = target
        for fid in reversed(list(free_ids)):
            target_generalized = IdxInter(fid, Top(), target_generalized) 
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

        solution = self.solver.solve(model, typ_imp, self.nt.typ)
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
        solution = self.solver.solve_composition(Inter(
            TField('head', head.typ), 
                TField('tail', typ)), 
                    self.nt.typ)
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
        return PatternAttr(enviro, typ)

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
