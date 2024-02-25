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
class Induc:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, IdxUnio, IdxInter, Induc, Top, Bot]


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
class InducNL:
    body : NL 

@dataclass(frozen=True, eq=True)
class SubtypingNL:
    strong : NL 
    weak : NL 

NL = Union[TVar, BVar, TUnit, TTagNL, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, IdxUnioNL, IdxInterNL, InducNL, Top, Bot]

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

    elif isinstance(typ, Induc):
        bound_ids = tuple([typ.id]) + bound_ids
        return InducNL(to_nameless(bound_ids, typ.body))

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
            plate_entry = ([control.body], lambda body : f"([| {ids} . {constraints} ] {body})")  
        elif isinstance(control, IdxInter):
            id = control.id
            plate_entry = ([control.upper, control.body], lambda upper, body : f"([{id} <: {upper}] {body})")  
        elif isinstance(control, Induc):
            id = control.id
            plate_entry = ([control.body], lambda body : f"induc {id} {body}")  
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
    is_applicator : bool = False



'''
NOTE: 
Freezer dictates when the strongest solution for a variable is found.
The assignment map could be tracked, or computed lazily when variable is used. 

NOTE: frozen variables correspond to hidden type information of existential/indexed union.

NOTE: freezing variables corresponds to refining predicates from duality interpolation in CHC
'''
Freezer = PSet[str]

@dataclass(frozen=True, eq=True)
class Model:
    constraints : PSet[Subtyping]
    freezer : PSet[str]


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
    return Induc(id_induc, typ_unio)

def factor_path(path : list[str], least : Induc) -> Typ:
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



def factor_least(least : Induc) -> Typ:
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
    # TODO: assume the key appears on the strong side of subtyping; 
    # - make sure this uses the strongest(lenient) or weakest(conservative) substitution based on frozen variables 
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
    for constraint in model.constraints:
        if strong == constraint.strong:
            return constraint.weak
    return None

def extract_weakest(model : Model, id : str) -> Typ:

    '''
    for constraints X <: T, X <: U; find weakest type stronger than T, stronger than U
    which is T & U.
    NOTE: related to weakest precondition concept
    '''
    typs_strengthen = [
        st.weak
        for st in model.constraints
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
    -- NOTE: tail-recursion, e.g. reverse list, requires patterns in relational constraint, but, that's bound inside of Induc
    -- e.g. (A, B, C, L) <: (Induc I . (nil, Y, Y) | {(X, cons Y, Z) <: I} (cons X, Y, Z))
    ---------------
    '''
    constraints_relational = [
        st
        for st in model.constraints
        if is_relational_key(model, st.weak) and (id in extract_free_vars_from_typ(pset(), st.weak))
    ]

    typ_factored = Top()
    for st in constraints_relational:
        paths = extract_paths(st.weak, TVar(id)) 
        for path in paths:
            assert isinstance(st.strong, Induc)
            typ_labeled = factor_path(path, st.strong)
            typ_factored = Inter(typ_labeled, typ_factored)

    typ_final = Inter(typ_strong, typ_factored)

    return typ_final 

def extract_strongest(model : Model, id : str) -> Typ:
    '''
    for constraints T <: X, U <: X; find strongest type weaker than T, weaker than U
    which is T | U.
    NOTE: related to strongest postcondition concept
    '''
    typs_weaken = [
        st.strong
        for st in model.constraints
        if st.weak == TVar(id) 
    ]
    typ_weak = Bot() 
    for t in reversed(typs_weaken):
        typ_weak = Unio(t, typ_weak) 
    return typ_weak


def condense_strongest(model : Model, typ : Typ) -> Typ:
    '''
    @param seen : tracks variables that have been seen. used to prevent cycling 
    '''
    if isinstance(typ, Imp):
        antec = condense_weakest(model, typ.antec)
        consq = condense_strongest(model, typ.consq)
        return Imp(antec, consq)
    else:
        fvs = extract_free_vars_from_typ(pset(), typ)
        renaming = pmap({
            id : condense_strongest(model, strongest)
            for id in fvs
            for strongest in [extract_strongest(model, id)]
            if simplify_typ(strongest) != Bot()
        })
        return sub_typ(renaming, typ)

def condense_weakest(model : Model, typ : Typ) -> Typ:
    '''
    The weakest type that we can determine a abstract type must be
    @param seen : tracks variables that have been seen. used to prevent cycling 
    '''
    if isinstance(typ, Imp):
        antec = condense_strongest(model, typ.antec)
        consq = condense_weakest(model, typ.consq)
        return Imp(antec, consq)
    else:
        fvs = extract_free_vars_from_typ(pset(), typ)
        renaming = pmap({
            id : condense_weakest(model, weakest)
            for id in fvs
            for weakest in [extract_weakest(model, id)]
            if simplify_typ(weakest) != Top()
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
    elif isinstance(typ, Induc):
        return Induc(typ.id, simplify_typ(typ.body))
    else:
        return typ
    
def simplify_constraints(constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(simplify_typ(st.strong), simplify_typ(st.weak))
        for st in constraints
    )

# TODO: remove weird kludgy concept
# def prettify_strongest_influence(model : Model, typ : Typ) -> str:
#     # return concretize_typ((condense_strongest_influence(model, pset(), typ)))
#     return concretize_typ(simplify_typ(condense_strongest_influence(model, pset(), typ)))


def prettify_weakest(model : Model, typ : Typ) -> str:
    return concretize_typ(simplify_typ(condense_weakest(model, typ)))

def prettify_strongest(model : Model, typ : Typ) -> str:
    return concretize_typ(simplify_typ(condense_strongest(model, typ)))


def extract_constraints_with_id(model : Model, id : str) -> PSet[Subtyping]:
    return pset(
        st
        for st in model.constraints
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
    elif isinstance(typ, Induc):  
        assignment_map = assignment_map.discard(typ.id)
        return Induc(typ.id, sub_typ(assignment_map, typ.body))
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

        elif isinstance(typ, Induc):
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
        id not in extract_free_vars_from_constraints(pset(), model.constraints)
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

def package_typ(model : Model, typ : Typ) -> Typ:
    ids_base = extract_free_vars_from_typ(pset(), typ)
    constraints = pset()
    for id_base in ids_base: 
        constraints_reachable = extract_reachable_constraints(model, id_base, pset())
        constraints = constraints.union(constraints_reachable)

    bound_ids = tuple(model.freezer.intersection(extract_free_vars_from_constraints(pset(), constraints)))
    typ_idx_unio = IdxUnio(bound_ids, tuple(constraints), typ)

    return simplify_typ(typ_idx_unio)

def decode_typ(models : list[Model], t : Typ) -> Typ:
    constraint_typs = [
        package_typ(model, t)
        for model in models
    ] 
    return mk_unio(constraint_typs)

def decode_strongest_typ(models : list[Model], id : str) -> Typ:
    constraint_typs = [
        package_typ(model, strongest_answer)
        for model in models
        for strongest_answer in [extract_strongest(model, id)]
    ] 
    return mk_unio(constraint_typs)

def decode_weakest_typ(models : list[Model], id : str) -> Typ:
    constraint_typs = [
        package_typ(model, weakest_answer)
        for model in models
        for weakest_answer in [extract_weakest(model, id)]
    ] 
    return mk_unio(constraint_typs)

def inhabitable(t : Typ) -> bool:
    t = simplify_typ(t)
    if False:
        pass
    elif isinstance(t, Bot):
        return False
    else:
        # TODO
        return True

def selective(t : Typ) -> bool:
    t = simplify_typ(t)
    if False:
        pass
    elif isinstance(t, Top):
        return False
    else:
        # TODO
        return True

def mk_unio(ts : list[Typ]) -> Typ:
    u = Bot()
    for t in reversed(ts):
        u = Unio(t, u)
    return u

class Solver:
    _type_id : int = 0 
    _battery  : int = -1


    def flatten_index_unios(self, t : Typ) -> tuple[tuple[str, ...], tuple[Subtyping, ...], Typ]:
        if False:
            pass
        elif isinstance(t, TVar):
            return ((), (), t)
        elif isinstance(t, TUnit):
            return ((), (), t)
        elif isinstance(t, TTag):
            (body_ids, body_constraints, body_typ) = self.flatten_index_unios(t.body)
            return (body_ids, body_constraints, TTag(t.label, body_typ))
        elif isinstance(t, TField):
            (body_ids, body_constraints, body_typ) = self.flatten_index_unios(t.body)
            return (body_ids, body_constraints, TField(t.label, body_typ))
        elif isinstance(t, Unio):
            (left_ids, left_constraints, left_typ) = self.flatten_index_unios(t.left)
            (right_ids, right_constraints, right_typ) = self.flatten_index_unios(t.right)
            return (left_ids + right_ids, left_constraints + right_constraints, Unio(left_typ, right_typ))
        elif isinstance(t, Inter):
            (left_ids, left_constraints, left_typ) = self.flatten_index_unios(t.left)
            (right_ids, right_constraints, right_typ) = self.flatten_index_unios(t.right)
            return (left_ids + right_ids, left_constraints + right_constraints, Inter(left_typ, right_typ))
        elif isinstance(t, Diff):
            (context_ids, context_constraints, context_typ) = self.flatten_index_unios(t.context)
            return (context_ids, context_constraints, Diff(context_typ, t.negation))
        elif isinstance(t, Imp):
            (consq_ids, consq_constraints, consq_typ) = self.flatten_index_unios(t.consq)
            return (consq_ids, consq_constraints, Inter(t.antec, consq_typ))
        elif isinstance(t, IdxUnio):
            renaming = self.make_renaming(t.ids)
            constraints = sub_constraints(renaming, t.constraints)
            body = sub_typ(renaming, t.body)
            bound_ids = tuple(t.id for t in renaming.values() if isinstance(t, TVar))

            (body_ids, body_constraints, body_typ) = self.flatten_index_unios(body)
            return (bound_ids + body_ids, constraints + body_constraints, body_typ)
        elif isinstance(t, IdxInter):
            return ((), (), t)
        elif isinstance(t, Induc):
            return ((), (), t)
        elif isinstance(t, Top):
            return ((), (), t)
        elif isinstance(t, Bot):
            return ((), (), t)


    def set_battery(self, battery : int):
        self._battery = battery 

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
# ||
# || premise model::: 
# || :::::::: {concretize_constraints(tuple(model.constraints))}
# ||
# || freezer::: 
# || :::::::: {model.freezer}
# ||
# || |- {concretize_typ(strong)} <: {concretize_typ(weak)}
# ||
#         ''')


        # if alpha_equiv(strong, weak): 
        #     return [model] 

        if False:
            return [] 
        #######################################

        elif isinstance(strong, IdxUnio):
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            next_id = self._type_id
            models = [model]
            for constraint in strong_constraints:
                models = [
                    m1
                    for m0 in models
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]  
            new_ids = (f"_{i}" for i in range(next_id, self._type_id))

            return [
                m2
                for m0 in models
                for m1 in [Model(m0.constraints, m0.freezer.union(renamed_ids).union(new_ids))]
                for m2 in self.solve(m1, strong_body, weak)
            ]

        elif isinstance(weak, IdxInter):
            tvar_fresh = self.fresh_type_var()
            renaming = pmap({weak.id : tvar_fresh})
            weak_upper = sub_typ(renaming, weak.upper)
            weak_body = sub_typ(renaming, weak.body)
            renamed_id = tvar_fresh.id


            next_id = self._type_id
            models = self.solve(model, tvar_fresh, weak_upper)
            new_ids = (f"_{i}" for i in range(next_id, self._type_id))

            return [
                m2
                for m0 in models
                for m1 in [Model(m0.constraints, m0.freezer.add(renamed_id).union(new_ids))]
                for m2 in self.solve(m1, strong, weak_body)
            ]

        elif isinstance(weak, IdxUnio): 
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)

            # unio_indices = pset(t.id for t in renaming.values() if isinstance(t, TVar))
            models = self.solve(model, strong, weak_body) 

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

            # inter_indices = (t.id for t in renaming.values() if isinstance(t, TVar))
            models = self.solve(model, strong_body, weak) 

            return [
                m1
                for m0 in models
                for m1 in self.solve(m0, tvar_fresh, strong_upper)
            ]   

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


            if strong.id in model.freezer: 
                weakest_strong = condense_weakest(model, strong)
                return self.solve(model, weakest_strong, weak)
            else:
                strongest = extract_strongest(model, strong.id)
                if not inhabitable(strongest):
                    return [Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer
                    )]
                else:
                    models = self.solve(model, strongest, weak)

                    return [
                        Model(
                            model.constraints.add(Subtyping(strong, weak)),
                            model.freezer
                        )
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

            if weak.id in model.freezer: 
                strongest_weak = condense_strongest(model, weak)
                return self.solve(model, strong, strongest_weak)
            else:
                weakest = extract_weakest(model, weak.id)
                if not selective(weakest):
                    return [Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer
                    )]
                else:
                    models = self.solve(model, strong, weakest)
                    models = [
                        Model(
                            model.constraints.add(Subtyping(strong, weak)),
                            model.freezer
                        )
                        for model in models
                    ]

                    return models



        #######################################
        #### Model rules: ####
        #######################################


        elif isinstance(strong, Induc):
            if alpha_equiv(strong, weak):
                return [model]
            else:
                models = []

                strong_factored = factor_least(strong)
                models = self.solve(model, strong_factored, weak)

                if models == []:
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
                    return models 

        elif isinstance(weak, Imp) and isinstance(weak.antec, Unio):
            # TODO: do we need this rule? 
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
            # TODO: need a sound/safe/conservative inhabitable check
            # only works if we assume T is not empty
            '''
            T <: A \\ B === (T <: A) and (T is inhabitable --> ~(T <: B))
            ----
            T <: A \\ B === (T <: A) and ((T <: B) --> T is empty)
            ----
            T <: A \\ B === (T <: A) and (~(T <: B) or T is empty)
            '''
            return [
                m
                for m in self.solve(model, strong, weak.context)
                if (
                    not inhabitable(strong) or 
                    self.solve(m, strong, weak.negation) == []
                )
            ]
        

        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(weak, Top): 
            return [model] 

        elif isinstance(strong, Bot): 
            return [model] 


        elif isinstance(weak, Induc): 

            if not is_relational_key(model, strong) and self._battery > 0 or self._battery < 0:
                self._battery -= 1
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({weak.id : weak})
                weak_body = sub_typ(renaming, weak.body)
                models = self.solve(model, strong, weak_body)

                return models
            else:
                weak_cache = match_strong(model, strong)
                if weak_cache:
                    # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
                    return self.solve(model, weak_cache, weak)
                else:
                    # NOTE: factoring indicates that it can be cached
                    # TODO: write a separate function called well-formed for clarity
                    factored = factor_least(weak)
                    models = self.solve(model, weak, factored)  
                    if models:
                        """
                        relational constraint must be well formed, since a matching factorization exists
                        update model with well formed constraint that can't yet be solved
                        relational_key is well formed
                        and matches the cases of the weak type
                        """
                        return [Model(
                            model.constraints.add(Subtyping(strong, weak)),
                            model.freezer
                        )]
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
        model = Model(s(), s())
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

    def combine_assoc(self, argchain : list[Typ]) -> Typ:
        if len(argchain) == 1:
            return argchain[0]
        else:
            applicator = argchain[0]
            arguments = argchain[1:]
            return ExprRule(self.solver, self.nt).combine_application(applicator, arguments) 

    def combine_unit(self) -> Typ:
        return TUnit()

    def distill_tag_body(self, id : str) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(TTag(id, query_typ), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)  
        return Nonterm('expr', self.nt.enviro, expected_typ)

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
        return simplify_typ(result)

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
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(TField('head', query_typ), TField('tail', Bot())), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)  
        return Nonterm('expr', self.nt.enviro, expected_typ) 

    def distill_tuple_tail(self, head : Typ) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(TField('head', head), TField('tail', query_typ)), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)  
        return Nonterm('expr', self.nt.enviro, expected_typ) 

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
        query_typ = self.solver.fresh_type_var()
        implication = Imp(TTag('true', TUnit()), query_typ) 
        model_conclusion = Imp(condition, self.nt.typ)
        models = self.solver.solve_composition(implication, model_conclusion)
        expected_typ = decode_strongest_typ(models, query_typ.id)  
        return Nonterm('expr', self.nt.enviro, expected_typ) 

    def distill_ite_branch_false(self, condition : Typ, branch_true : Typ) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        query_typ = self.solver.fresh_type_var()
        implication = Imp(TTag('false', TUnit()), query_typ) 
        model_conclusion = Imp(condition, self.nt.typ)
        models = self.solver.solve_composition(implication, model_conclusion)
        expected_typ = decode_strongest_typ(models, query_typ.id)  
        return Nonterm('expr', self.nt.enviro, expected_typ) 

    def combine_ite(self, condition : Typ, true_branch : Typ, false_branch : Typ) -> Typ: 
        true_models = self.solver.solve_composition(condition, TTag('true', TUnit()))
        false_models = self.solver.solve_composition(condition, TTag('false', TUnit()))
        return Unio(
            decode_typ(true_models, true_branch), 
            decode_typ(false_models, false_branch), 
        )


    def distill_projection_cator(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_projection_keychain(self, record : Typ) -> Nonterm: 
        return Nonterm('keychain', self.nt.enviro, record)


    def combine_projection(self, record : Typ, keys : list[str]) -> Typ: 
        answr_i = record 
        for key in keys:
            answr = self.solver.fresh_type_var()
            models = self.solver.solve_composition(answr_i, TField(key, answr))
            answr_i = decode_strongest_typ(models, answr.id)

        return answr_i

    #########

    def distill_application_cator(self) -> Nonterm: 
        return Nonterm('expr', self.nt.enviro, Imp(Bot(), Top()))

    def distill_application_argchain(self, cator : Typ) -> Nonterm: 
        return Nonterm('argchain', self.nt.enviro, cator, True)

    def combine_application(self, cator : Typ, arguments : list[Typ]) -> Typ: 
        print(f"""
~~~~~~~~~~~~~~~~~
>> cator: {concretize_typ(cator)}
>> args : {[concretize_typ(t) for t in arguments]} 
~~~~~~~~~~~~~~~~~
        """)
        answr_i = cator 
        for argument in arguments:
            answr = self.solver.fresh_type_var()

            # TODO: delete this commented code
            # No need to extract strongest weaker
            # '''
            # extract strongest weaker to use as return type
            # '''
            # models = [
            #     Model(p0.model.add(Subtyping(answr, typ_return)), p0.freezer.add(answr.id))
            #     for p0 in self.solver.solve_composition(answr_i, Imp(argument, answr))
            #     for typ_return in [extract_strongest(p0.model, answr.id)]
            # ]

            models = self.solver.solve_composition(answr_i, Imp(argument, answr))
            decode_strongest_typ(models, answr.id)

        return simplify_typ(answr_i)


    #########
    def distill_funnel_arg(self) -> Nonterm: 
        return Nonterm('expr', self.nt.enviro, Top())

    def distill_funnel_pipeline(self, arg : Typ) -> Nonterm: 
        return Nonterm('pipeline', self.nt.enviro, arg)

    def combine_funnel(self, arg : Typ, cators : list[Typ]) -> Typ: 
        return self.combine_application(arg, cators)

    def distill_fix_body(self) -> Nonterm:
        return Nonterm('expr', self.nt.enviro, Top())

    def combine_fix(self, body : Typ) -> Typ:
        """
        from: 
        SELF -> (nil -> zero) & (cons A\\nil -> succ B) ;  SELF <: A -> B SELF(A) <: B
        --------------- OR -----------------------
        [X . X <: nil | cons A] X -> {Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)} Y
        """

        self_typ = self.solver.fresh_type_var()
        in_typ = self.solver.fresh_type_var()
        out_typ = self.solver.fresh_type_var()

        IH_typ = self.solver.fresh_type_var()

        models = self.solver.solve_composition(body, Imp(self_typ, Imp(in_typ, out_typ)))

        induc_body = Bot()
        param_body = Bot()
        for model in reversed(models):
            left_typ = simplify_typ(condense_weakest(model, in_typ))
            raw_right_typ = simplify_typ(condense_strongest(model, out_typ))
            (right_bound_ids, right_constraints, right_typ) = self.solver.flatten_index_unios(raw_right_typ)

            left_bound_ids = tuple(extract_free_vars_from_typ(pset(), left_typ))
            bound_ids = left_bound_ids + right_bound_ids
            rel_pattern = make_pair_typ(left_typ, right_typ)

            IH_typ_args = next(
                (
                    (st.weak.antec, st.weak.consq)
                    for st in right_constraints
                    if st.strong == self_typ 
                    if isinstance(st.weak, Imp)
                ),
                None
            )  

            if IH_typ_args:
                other_constraints = tuple(
                    st
                    for st in right_constraints
                    if st.strong != self_typ 
                ) 
                IH_rel_constraint = Subtyping(make_pair_typ(IH_typ_args[0], IH_typ_args[1]), IH_typ)

                IH_left_constraint = Subtyping(IH_typ_args[0], IH_typ)

                rel_constraints = tuple([IH_rel_constraint]) + other_constraints
                constrained_rel = IdxUnio(bound_ids, rel_constraints, rel_pattern) 

                left_constraints = tuple([IH_left_constraint]) + other_constraints
                constrained_left = IdxUnio(left_bound_ids, left_constraints, left_typ)
            elif bound_ids:
                constraints = right_constraints 
                constrained_rel = IdxUnio(bound_ids, constraints, rel_pattern) 
                constrained_left = IdxUnio(left_bound_ids, constraints, left_typ) 
            else:
                assert not right_constraints
                constrained_rel = rel_pattern
                constrained_left = left_typ 
            #end if

            induc_body = Unio(constrained_rel, induc_body) 
            param_body = Unio(constrained_left, param_body)

#             print(f"""
# <<<<<<<<<<<<<<

# raw right typ::::
# =====================
# {concretize_typ(raw_right_typ) }
                  
# ------------------------

# rel constraints::::
# =====================
# {concretize_constraints(tuple(rel_constraints)) }

# model constraints::::
# =====================
# {concretize_constraints(tuple(model.constraints)) }
# >>>>>>>>>>>>>>
#             """)
        #end for

        rel_typ = Induc(IH_typ.id, induc_body)
        param_upper = Induc(IH_typ.id, param_body)

        param_typ = self.solver.fresh_type_var()
        return_typ = self.solver.fresh_type_var()
        consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
        consq_typ = IdxUnio(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
        result = IdxInter(param_typ.id, param_upper, Imp(param_typ, consq_typ))  

#         print(f"""
# <<<<<<<<<<<<<<
# result: {concretize_typ(result)} 

# param_upper: {concretize_typ(param_upper)} 
# <<<<<<<<<<<<<<
#         """)

# constrained_rel: {concretize_typ(constrained_rel)}
# self_typ: {self_typ.id} 

# left_typ: {concretize_typ(left_typ)} 

# raw_right_typ: {concretize_typ(raw_right_typ)} 

# right_bound_ids: {right_bound_ids}
# right_constraints: {concretize_constraints(right_constraints)}
# right_typ: {concretize_typ(right_typ)} 

# relational_constraint: {concretize_constraints(tuple([relational_constraint])) if relational_constraint else "NADA"}

# constrained_rel: {concretize_typ(constrained_rel)} 

        return result

    
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
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(TField(id, query_typ), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('expr', self.nt.enviro, expected_typ) 

    def combine_single(self, id : str, body : Typ) -> Typ:
        return TField(id, body) 

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_single_body(id)

    def distill_cons_tail(self, id : str, body : Typ) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(TField(id, body), query_typ), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('record', self.nt.enviro, expected_typ) 

    def combine_cons(self, id : str, body : Typ, tail : Typ) -> Typ:
        return Inter(TField(id, body), tail)

class FunctionRule(Rule):

    def distill_single_pattern(self) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(self.nt.typ, Imp(query_typ, Top()))
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('pattern', self.nt.enviro, expected_typ)

    def distill_single_body(self, pattern : PatternAttr) -> Nonterm:
        query_typ = self.solver.fresh_type_var() 
        models = self.solver.solve_composition(self.nt.typ, Imp(pattern.typ, query_typ)) 
        expected_typ = decode_strongest_typ(models, query_typ.id)
        enviro = self.nt.enviro + pattern.enviro
        return Nonterm('expr', enviro, expected_typ)

    def combine_single(self, pattern : PatternAttr, body : Typ) -> list[Imp]:
        return [Imp(pattern.typ, body)]

    def distill_cons_pattern(self) -> Nonterm:
        return self.distill_single_pattern()

    def distill_cons_body(self, pattern : PatternAttr) -> Nonterm:
        return self.distill_single_body(pattern)

    def distill_cons_tail(self, pattern : PatternAttr, body : Typ) -> Nonterm:
        antec_query_typ = self.solver.fresh_type_var()
        consq_query_typ = self.solver.fresh_type_var()

        choices = from_cases_to_choices([Imp(pattern.typ, body), Imp(antec_query_typ, consq_query_typ)])


        left_query_typ = self.solver.fresh_type_var()
        right_query_typ = self.solver.fresh_type_var()
        pair_typ = make_pair_typ(left_query_typ, right_query_typ)
        imp_typ = Imp(left_query_typ, right_query_typ)

        model = Model(
            pset(
                Subtyping(pair_typ, make_pair_typ(choice[0], choice[1]))
                for choice in choices
            ),
            pset()
        )

        models = self.solver.solve(model, imp_typ, self.nt.typ)

        expected_typ = decode_typ(models, Imp(antec_query_typ, consq_query_typ))
        '''
        NOTE: the guide is an implication guiding the next case
        '''
        return Nonterm('function', self.nt.enviro, expected_typ)

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
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(self.nt.typ, TField(key, query_typ))
        typ_grounded = decode_strongest_typ(models, query_typ.id)
        return Nonterm('keychain', self.nt.enviro, typ_grounded)

    def combine_cons(self, key : str, keys : list[str]) -> list[str]:
        return self.combine_single(key) + keys

class ArgchainRule(Rule):
    def distill_single_content(self):
        if self.nt.is_applicator:
            query_typ = self.solver.fresh_type_var()
            models = self.solver.solve_composition(self.nt.typ, Imp(query_typ, Top()))
            expected_typ = decode_weakest_typ(models, query_typ.id)
            return Nonterm('expr', self.nt.enviro, expected_typ, False)
        else:
            return self.nt

    def distill_cons_head(self):
        if self.nt.is_applicator:
            query_typ = self.solver.fresh_type_var()
            models = self.solver.solve_composition(self.nt.typ, Imp(query_typ, Top()))
            expected_typ = decode_weakest_typ(models, query_typ.id)
            return Nonterm('expr', self.nt.enviro, expected_typ, False)
        else:
            return self.nt

    def distill_cons_tail(self, head : Typ):
        query_typ = self.solver.fresh_type_var()
        '''
        cut the previous tyption with the head 
        resulting in a new tyption of what can be cut by the next element in the tail
        '''
        models = self.solver.solve_composition(self.nt.typ, Imp(head, query_typ))
        typ_grounded = decode_strongest_typ(models, query_typ.id)
        return Nonterm('argchain', self.nt.enviro, typ_grounded, True)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail

######

class PipelineRule(Rule):

    def distill_single_content(self):
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(query_typ, Imp(self.nt.typ, Top()))
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('expr', self.nt.enviro, expected_typ)


    def distill_cons_head(self):
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(query_typ, Imp(self.nt.typ, Top()))
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('expr', self.nt.enviro, expected_typ)

    def distill_cons_tail(self, head : Typ) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        models = self.solver.solve_composition(head, Imp(self.nt.typ, query_typ))
        expected_typ = decode_strongest_typ(models, query_typ.id)
        return Nonterm('pipeline', self.nt.enviro, expected_typ)

    def combine_single(self, content : Typ) -> list[Typ]:
        # self.solver.solve(plate.enviro, plate.typ, Imp(content, Top()))
        return [content]

    def combine_cons(self, head : Typ, tail : list[Typ]) -> list[Typ]:
        return self.combine_single(head) + tail


'''
start Pattern Rule
'''

class PatternRule(Rule):
    def distill_tuple_head(self) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(TField('head', query_typ), TField('tail', Bot())), self.nt.typ)
        typ_grounded = decode_weakest_typ(models, query_typ.id)
        return Nonterm('pattern', self.nt.enviro, typ_grounded) 

    def distill_tuple_tail(self, head : PatternAttr) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(
            TField('head', head.typ), 
                TField('tail', query_typ)), 
                    self.nt.typ)

        typ_grounded = decode_weakest_typ(models, query_typ.id)
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
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(TTag(id, query_typ), self.nt.typ)
        expected_typ = decode_weakest_typ(models, query_typ.id)
        return Nonterm('pattern', self.nt.enviro, expected_typ)

    def combine_tag(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TTag(label, body.typ))
'''
end PatternBaseRule
'''

class PatternRecordRule(Rule):

    def distill_single_body(self, id : str) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(TField(id, query_typ), self.nt.typ)
        typ_grounded = decode_weakest_typ(models, query_typ.id)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_single(self, label : str, body : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro, TField(label, body.typ))

    def distill_cons_body(self, id : str) -> Nonterm:
        return self.distill_cons_body(id)

    def distill_cons_tail(self, id : str, body : PatternAttr) -> Nonterm:
        query_typ = self.solver.fresh_type_var()
        models = self.solver.solve_composition(Inter(TField(id, body.typ), query_typ), self.nt.typ)
        typ_grounded = decode_weakest_typ(models, query_typ.id)
        return Nonterm('pattern_record', self.nt.enviro, typ_grounded) 

    def combine_cons(self, label : str, body : PatternAttr, tail : PatternAttr) -> PatternAttr:
        return PatternAttr(body.enviro + tail.enviro, Inter(TField(label, body.typ), tail.typ))
