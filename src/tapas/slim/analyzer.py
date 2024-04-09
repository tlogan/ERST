from __future__ import annotations
from dataclasses import dataclass, replace
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

@dataclass(frozen=True, eq=True)
class RNode:
    content : PMap[str, RTree] 

@dataclass(frozen=True, eq=True)
class RLeaf:
    content : Typ 

RTree = Union[RNode, RLeaf]

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
class Exi:
    ids : tuple[str, ...]
    constraints : tuple[Subtyping, ...] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class All:
    ids : tuple[str, ...]
    constraints : tuple[Subtyping, ...] 
    body : Typ 

@dataclass(frozen=True, eq=True)
class LeastFP:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, Exi, All, LeastFP, Top, Bot]


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
class ExiNL:
    count : int
    constraints : tuple[SubtypingNL, ...] 
    body : NL 

@dataclass(frozen=True, eq=True)
class AllNL:
    count : int
    constraints : tuple[SubtypingNL, ...] 
    body : NL 

@dataclass(frozen=True, eq=True)
class LeastFPNL:
    body : NL 

@dataclass(frozen=True, eq=True)
class SubtypingNL:
    strong : NL 
    weak : NL 

NL = Union[TVar, BVar, TUnit, TTagNL, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, ExiNL, AllNL, LeastFPNL, Top, Bot]

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
    elif isinstance(typ, Exi):
        count = len(typ.ids)
        bound_ids = tuple(typ.ids) + bound_ids

        constraints_nl = tuple(
            SubtypingNL(to_nameless(bound_ids, st.strong), to_nameless(bound_ids, st.weak))
            for st in typ.constraints
        )
        return ExiNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, All):
        count = len(typ.ids)
        bound_ids = tuple(typ.ids) + bound_ids

        constraints_nl = tuple(
            SubtypingNL(to_nameless(bound_ids, st.strong), to_nameless(bound_ids, st.weak))
            for st in typ.constraints
        )
        return AllNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, LeastFP):
        bound_ids = tuple([typ.id]) + bound_ids
        return LeastFPNL(to_nameless(bound_ids, typ.body))

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
    return "".join([
        " ; " + concretize_typ(st.strong) + " <: " + concretize_typ(st.weak)
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
                isinstance(control.left, TField) and control.left.label == "head" and 
                isinstance(control.right, TField) and control.right.label == "tail" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({left}, {right})")  
            else:
                plate_entry = ([control.left,control.right], lambda left, right : f"({left} & {right})")  
        elif isinstance(control, Diff):
            plate_entry = ([control.context,control.negation], lambda context,negation : f"({context} \\ {negation})")  
        elif isinstance(control, Exi):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate_entry = ([control.body], lambda body : f"(EXI [{ids}{constraints}] {body})")  
        elif isinstance(control, All):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            plate_entry = ([control.body], lambda body : f"(ALL [{ids}{constraints}] {body})")  
        elif isinstance(control, LeastFP):
            id = control.id
            plate_entry = ([control.body], lambda body : f"LFP {id} {body}")  
        elif isinstance(control, Top):
            plate_entry = ([], lambda: "TOP")  
        elif isinstance(control, Bot):
            plate_entry = ([], lambda: "BOT")  

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
    # models : list[Model]
    typ : Typ    


@dataclass(frozen=True, eq=True)
class ArgchainAttr:
    models : list[Model]
    args : list[TVar]

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
    name : str 
    enviro : PMap[str, Typ] 
    models : list[Model]
    typ_var : TVar 
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

def pattern_type(t : Typ) -> bool:
    return (
        isinstance(t, TVar) or
        isinstance(t, TUnit) or
        (isinstance(t, TTag) and pattern_type(t.body)) or 
        (isinstance(t, TField) and pattern_type(t.body)) or 
        False
    )

def negation_well_formed(neg : Typ) -> bool:
    '''
    restriction to avoid dealing with negating divergence (which would need to soundly fail under even negs, soundly pass under odd negs)
    '''
#     print(f"""
# ~~~~~~~~~~~~~~~~~~~
# DEBUG negation_well_formed
# ~~~~~~~~~~~~~~~~~~~
# neg: {concretize_typ(neg)}
# ~~~~~~~~~~~~~~~~~~~
#     """)
    if isinstance(neg, Exi):
        return len(neg.constraints) == 0 and negation_well_formed(neg.body)
    elif isinstance(neg, TVar):
        return True
    elif isinstance(neg, TUnit):
        return True
    elif isinstance(neg, TTag):
        return negation_well_formed(neg.body)
    elif isinstance(neg, TField):
        return negation_well_formed(neg.body)
    elif isinstance(neg, Inter):
        return (
            negation_well_formed(neg.left) and 
            negation_well_formed(neg.right)
        )
    else:
        return False


def diff_well_formed(diff : Diff) -> bool:
    '''
    restriction to avoid dealing with negating divergence (which would need to soundly fail under even negs, soundly pass under odd negs)
    '''
    return negation_well_formed(diff.negation)

def make_diff(context : Typ, negs : list[Typ]) -> Typ:
    result = context 
    for neg in negs:
        result = Diff(result, neg)
    return result

def make_pair_typ(left : Typ, right : Typ) -> Typ:
    return Inter(TField("head", left), TField("tail", right))

def from_branches_to_choices(cases : list[Imp]) -> list[tuple[Typ, Typ]]:
    '''
    nil -> zero
    cons X -> succ Y 
    --------------------
    (nil,zero) | (cons X\\nil, succ Y)
    '''

    choices = []
    negs = []

    for case in cases:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG from_branches_to_choices
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG case: {concretize_typ(case)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
        choices += [(make_diff(case.antec, negs), case.consq)]
        neg_fvs = extract_free_vars_from_typ(s(), case.antec)  
        neg = (
            Exi(tuple(sorted(neg_fvs)), (), case.antec)
            if neg_fvs else
            case.antec
        )
        # TODO
        # negs += [neg]
        negs = []
    return choices 

def linearize_unions(t : Typ) -> list[Typ]:
    if isinstance(t, Unio):
        return linearize_unions(t.left) + linearize_unions(t.right)
    else:
        return [t]

def extract_paths(t : Typ, tvar : Optional[TVar] = None) -> PSet[tuple[str, ...]]:  
    if False:
        assert False
    elif isinstance(t, Exi):
        return extract_paths(t.body)
    elif isinstance(t, Inter):
        left = extract_paths(t.left) 
        right = extract_paths(t.right)
        return left.union(right)
    elif isinstance(t, TField):
        body = t.body
        if isinstance(body, TVar) and (not tvar or tvar.id == body.id):
            path = tuple([t.label])
            return s(path)
        else:
            paths_tail = extract_paths(t.body)
            return pset(
                tuple([t.label]) + path_tail
                for path_tail in paths_tail
            )

        

    else:
        return pset()


def extract_field_recurse(t : Typ, path : tuple[str, ...]) -> Optional[Typ]:
    if not path:
        return None
    elif isinstance(t, Inter):
        left = extract_field_recurse(t.left, path)
        right = extract_field_recurse(t.right, path)
        if left and right:
            return Inter(left, right)
        else:
            return left or right
    elif isinstance(t, TField):
        label = path[0]
        if t.label == label:
            if len(path) == 1:
                return t.body
            else:
                return extract_field_recurse(t.body, path[1:])
        else:
            return None


def extract_field_plain(path : tuple[str, ...], t : Typ) -> Typ:
    result = extract_field_recurse(t, path)
    if result:
        return result
    else:
        raise Exception(f"extract_field_plain error: {path} in {concretize_typ(t)}")

def extract_field(path : tuple[str, ...], id_induc : str, t : Typ) -> Typ:
    if isinstance(t, Exi):  
        new_constraints = tuple(
            (
            Subtyping(extract_field_plain(path, st.strong), TVar(id_induc))
            if st.weak == TVar(id_induc) else
            st
            )
            for st in t.constraints
        )
        new_body = extract_field_plain(path, t.body)
        return Exi(t.ids, new_constraints, new_body)
    else:
        return extract_field_plain(path, t)


def extract_column(path : tuple[str, ...], id_induc : str, choices : list[Typ]) -> Typ:
    choices_column = [
        extract_field(path, id_induc, choice)
        for choice in choices
        if choice != Bot()
    ] 
    typ_unio = choices_column[0]
    for choice in choices_column[1:]:
        typ_unio = Unio(typ_unio, choice)
    return LeastFP(id_induc, typ_unio)

def factor_path(path : tuple[str, ...], least : LeastFP) -> Typ:
    choices = linearize_unions(least.body)
    column = extract_column(path, least.id, choices)
    return column 


def insert_at_path(rnode : RNode, path : tuple[str, ...], t : Typ) -> RNode:
    assert path
    key = path[0]  
    remainder = path[1:]

#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG insert_at_path 
# ~~ path: {path}
# ~~ key in rnode.content: {key in rnode.content}
# ~~ remainder: {remainder}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)

    if remainder:
        if key in rnode.content:
            assert remainder
            n = rnode.content[key] 
            assert isinstance(n, RNode)
        else:
            n = RNode(m())

        o = insert_at_path(n, remainder, t)
        content = rnode.content.set(key, o) 
        return RNode(content)
    else:
        o = RLeaf(t) 
        content = rnode.content.set(key, o) 
        return RNode(content)

def to_record_typ(rnode : RNode) -> Typ:
    result = Top()
    for key in rnode.content:
        v = rnode.content[key]
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG to_record_typ
# DEBUG v: {v}
# DEBUG type(v): {v} 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
        if isinstance(v, RLeaf):
            field = TField(key, v.content)
        else:
            assert (v, RNode)
            t = to_record_typ(v)
            field = TField(key, t)
        result = Inter(field, result)
    return result



def factor_least(least : LeastFP) -> Typ:
    choices = linearize_unions(least.body)
    paths = [
        path
        for choice in choices
        for path in list(extract_paths(choice))
    ]

    rnode = RNode(m()) 
    for path in paths:
        column = extract_column(path, least.id, choices)
        assert isinstance(rnode, RNode)
        rnode = insert_at_path(rnode, path, column)

    return to_record_typ(rnode) 

def alpha_equiv(t1 : Typ, t2 : Typ) -> bool:
    return to_nameless((), t1) == to_nameless((), t2)

def is_relational_key(model : Model, t : Typ) -> bool:
    # TODO: assume the key appears on the strong side of subtyping; 
    # - make sure this uses the strongest(lenient) or weakest(strict) substitution based on frozen variables 
    if isinstance(t, TField):
        if isinstance(t.body, TVar):
            op = interpret_strongest_for_id(model, t.body.id) 
            if op != None:
                (strongest, _) = op
                return strongest != None and (isinstance(strongest, Bot) or is_relational_key(model, strongest))
            else:
                return False
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

def interpret_weakest_for_id(model : Model, id : str) -> Optional[tuple[Typ, PSet[Subtyping]]]:
    '''
    for constraints X <: T, X <: U; find weakest type stronger than T, stronger than U
    which is T & U.
    NOTE: related to weakest precondition concept
    '''


    has_weakest_interpretation = True
    # TODO: determine if some restriction is actually necessary
    # all(
    #     (
    #         id not in extract_free_vars_from_typ(s(), st.strong) or
    #         st.strong == TVar(id) 
    #     )
    #     for st in model.constraints
    # )

#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG interpret_weakest_for_id 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# model.freezer: {model.freezer}
# model.constraints: {concretize_constraints(tuple(model.constraints))}
# id: {id}
# has_weakest_interpretation: {has_weakest_interpretation}
# ~~~~~~~~~~~~~~~~~~~~~~~~
#     """)


    if has_weakest_interpretation:
        constraints = [
            st
            for st in model.constraints
            if st.strong == TVar(id)
        ]
        typ_strong = Top() 
        for c in reversed(constraints):
            typ_strong = Inter(c.weak, typ_strong) 
        
        return (simplify_typ(typ_strong), pset(constraints))
    else:
        return None


    # '''
    # LHS variables in relational constraints: always have relation of variables on LHS; need to factor; then perform union after
    # case relational: if variable is part of relational constraint, factor out type from rhs
    # case simple: otherwise, extract rhs
    # -- NOTE: relational constraints are restricted to record types of variables
    # -- NOTE: tail-recursion, e.g. reverse list, requires patterns in relational constraint, but, that's bound inside of LeastFP
    # -- e.g. (A, B, C, L) <: (LeastFP I . (nil, Y, Y) | {(X, cons Y, Z) <: I} (cons X, Y, Z))
    # ---------------
    # '''
    # constraints_relational = [
    #     st
    #     for st in model.constraints
    #     if is_relational_key(model, st.weak) and (id in extract_free_vars_from_typ(s(), st.weak))
    # ]

    # typ_factored = Top()
    # for st in constraints_relational:
    #     paths = extract_paths(st.weak, TVar(id)) 
    #     for path in paths:
    #         assert isinstance(st.strong, LeastFP)
    #         typ_labeled = factor_path(path, st.strong)
    #         typ_factored = Inter(typ_labeled, typ_factored)

    # typ_final = Inter(typ_strong, typ_factored)

    # return typ_final 

def interpret_strongest_for_id(model : Model, id : str) -> Optional[tuple[Typ, PSet[Subtyping]]]:
    '''
    for constraints T <: X, U <: X; find strongest type weaker than T, weaker than U
    which is T | U.
    NOTE: related to strongest postcondition concept
    '''

    has_strongest_interpretation = True
    # TODO: determine if some restriction is actually necessary
    # all(
    #     (
    #         id not in extract_free_vars_from_typ(s(), st.weak) or
    #         st.weak == TVar(id) 
    #     )
    #     for st in model.constraints

    # )

#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG interpret_strongest_for_id ~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~ model.freezer: {model.freezer}
# ~~ model.constraints: {concretize_constraints(tuple(model.constraints))}
# ~~ id: {id}
# ~~ has_strongest_interpretation: {has_strongest_interpretation}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)

    if has_strongest_interpretation:
        constraints = [
            st
            for st in model.constraints
            if st.weak == TVar(id) 
        ]
        typ_weak = Bot() 
        for c in reversed(constraints):
            typ_weak = Unio(c.strong, typ_weak) 
        return (simplify_typ(typ_weak), pset(constraints))
    else:
        return None

def interpret_strongest_for_ids(model : Model, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:

    trips = [ 
        (id, strongest, cs)
        for id in ids
        for op in [interpret_strongest_for_id(model, id)]
        if op 
        for (strongest, cs) in [op]
    ]


    m = pmap({
        id : strongest
        for (id, strongest, cs) in trips
    })

    cs = pset([
        c 
        for (id, strongest, cs) in trips
        for c in cs
    ]) 
    return (m, cs)

def interpret_weakest_for_ids(model : Model, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:
    trips = [ 
        (id, weakest, cs)
        for id in ids
        for op in [interpret_weakest_for_id(model, id)]
        if op 
        for (weakest, cs) in [op]
    ]


    m = pmap({
        id : weakest
        for (id, weakest, cs) in trips
    })

    cs = pset([
        c 
        for (id, weakest, cs) in trips
        for c in cs
    ]) 
    return (m, cs)

def mapOp(f):
    def call(o):
        if o != None:
            return f(o)
        else:
            return None
    return call


# def interpret_strong_side(model : Model, typ : Typ) -> tuple[Typ, PSet[Subtyping]]:
#     # NOTE: the unfrozen variables use strongest interpretation
#     # NOTE: the frozen variables use weakest interpretation 
#     if isinstance(typ, Imp):
#         antec, antec_constraints = interpret_weak_side(model, typ.antec)
#         consq, consq_constraints = interpret_strong_side(model, typ.consq)
#         return (Imp(antec, consq), antec_constraints.union(consq_constraints))
#     else:
#         fvs = extract_free_vars_from_typ(s(), typ)


#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_strongest_for_id(model, id))]
#         #     if op != None
#         #     if (id in model.freezer)
#         #     for (strongest_once, cs_once) in [op]
#         #     for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#         #     # for m in [model]
#         #     for (t, cs_cont) in [interpret_weak_side(m, strongest_once)]
#         # ]


#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_strongest_for_id(model, id))]
#         #     if op != None
#         #     for (strongest_once, cs_once) in [op]
#         #     if (id in model.freezer) or inhabitable(strongest_once) 
#         #     for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#         #     for (t, cs_cont) in [
#         #         interpret_weak_side(m, strongest_once)
#         #         if (id in model.freezer) else
#         #         interpret_strong_side(m, strongest_once)
#         #     ]
#         # ]

#         trips = [ 
#             (id, t, cs_once.union(cs_cont)) 
#             for id in fvs
#             for op in [
#                 mapOp(simplify_typ)(interpret_weakest_for_id(model, id))
#                 if id in model.freezer else
#                 mapOp(simplify_typ)(interpret_strongest_for_id(model, id))
#             ]
#             if op != None
#             for (strongest_once, cs_once) in [op]
#             if (id in model.freezer) or inhabitable(strongest_once) 
#             for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#             for (t, cs_cont) in [interpret_strong_side(m, strongest_once)]
#         ]

#         renaming = pmap({
#             id : strongest 
#             for (id, strongest, cs) in trips
#         })

# #         print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# # DEBUG interpret_strong_side
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# # model.freezer: {model.freezer}
# # model.constraints: {concretize_constraints(tuple(model.constraints))}
# # typ: {concretize_typ(typ)}
# # interp _4: {mapOp(simplify_typ)(interpret_strongest_for_id(model, '_4'))}
# # renaming: {renaming}
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# #         """)

#         cs = pset(
#             c
#             for (id, strongest, cs) in trips
#             for c in cs
#         )
#         return (simplify_typ(sub_typ(renaming, typ)), cs)

# def interpret_weak_side(model : Model, typ : Typ) -> tuple[Typ, PSet[Subtyping]]:
#     if isinstance(typ, Imp):
#         antec, antec_constraints = interpret_strong_side(model, typ.antec)
#         consq, consq_constraints = interpret_weak_side(model, typ.consq)
#         return (Imp(antec, consq), antec_constraints.union(consq_constraints))
#     else:
#         fvs = extract_free_vars_from_typ(s(), typ)

#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_weakest_for_id(model, id))]
#         #     if op != None
#         #     # if (id in model.freezer)
#         #     # for (weakest_once, cs_once) in [op]
#         #     # for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#         #     # for (t, cs_cont) in [interpret_strong_side(m, weakest_once)]
#         #     for (weakest_once, cs_once) in [op]
#         #     if (id in model.freezer) or selective(weakest_once) 
#         #     for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#         #     for (t, cs_cont) in [
#         #         interpret_strong_side(m, weakest_once)
#         #         if (id in model.freezer) else
#         #         interpret_weak_side(m, weakest_once)
#         #     ]
#         # ]

#         trips = [ 
#             (id, t, cs_once.union(cs_cont)) 
#             for id in fvs
#             for op in [
#                 mapOp(simplify_typ)(interpret_strongest_for_id(model, id))
#                 if (id in model.freezer) else
#                 mapOp(simplify_typ)(interpret_weakest_for_id(model, id))
#             ]
#             if op != None
#             for (weakest_once, cs_once) in [op]
#             if (id in model.freezer) or selective(weakest_once) 
#             for m in [Model(model.constraints.difference(cs_once), model.freezer)]
#             for (t, cs_cont) in [interpret_weak_side(m, weakest_once)]
#         ]

#         renaming = pmap({
#             id : weakest 
#             for (id, weakest, cs) in trips
#         })

# #         print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# # DEBUG interpret_weak_side 
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# # model.freezer: {model.freezer}
# # model.constraints: {concretize_constraints(tuple(model.constraints))}
# # typ: {concretize_typ(typ)}
# # renaming: {[id + " --*> " + concretize_typ(t) for id, t in renaming.items()]}
# # fvs: {fvs}
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# #         """)

#         cs = pset(
#             c
#             for (id, weakest, cs) in trips
#             for c in cs
#         )
#         return (simplify_typ(sub_typ(renaming, typ)), cs)

def meaningful(polarity : bool, t : Typ) -> bool:
    if polarity:
        return inhabitable(t)
    else:
        return selective(t)


def interpret_with_polarity(polarity : bool, model : Model, typ : Typ, ignored_ids : PSet[str]) -> tuple[Typ, PSet[Subtyping]]:
    def interpret_for_id(polarity : bool, id : str): 
        if polarity:
            return interpret_strongest_for_id(model, id)
        else:
            return interpret_weakest_for_id(model, id)

    if False:
        assert False
    elif isinstance(typ, TVar) and typ.id in ignored_ids:
        return (typ, s())
    elif isinstance(typ, TVar) and typ.id not in ignored_ids:
        id = typ.id
        op = ( 
            mapOp(simplify_typ)(interpret_for_id(not polarity, id))
            if (id in model.freezer) else
            mapOp(simplify_typ)(interpret_for_id(polarity, id))
        )

        if op != None:
            (interp_typ_once, cs_once) = op
            if (id in model.freezer) or meaningful(polarity, interp_typ_once): 
                m = Model(model.constraints.difference(cs_once), model.freezer)
                (t, cs_cont) = interpret_with_polarity(polarity, m, interp_typ_once, ignored_ids)
                return (simplify_typ(t), cs_once.union(cs_cont))
            else:
                return (typ, s())
        else:
            return (typ, s())

    elif isinstance(typ, TUnit):
        return (typ, s())
    elif isinstance(typ, TTag):
        body = typ.body
        body, body_constraints = interpret_with_polarity(polarity, model, typ.body, ignored_ids)
        return (TTag(typ.label, body), body_constraints)
    elif isinstance(typ, TField):
        body = typ.body
        body, body_constraints = interpret_with_polarity(polarity, model, typ.body, ignored_ids)
        return (TField(typ.label, body), body_constraints)
    elif isinstance(typ, Unio):
        left, left_constraints = interpret_with_polarity(polarity, model, typ.left, ignored_ids)
        right, right_constraints = interpret_with_polarity(polarity, model, typ.right, ignored_ids)
        return (Unio(left, right), left_constraints.union(right_constraints))
    elif isinstance(typ, Inter):
        left, left_constraints = interpret_with_polarity(polarity, model, typ.left, ignored_ids)
        right, right_constraints = interpret_with_polarity(polarity, model, typ.right, ignored_ids)
        return (Inter(left, right), left_constraints.union(right_constraints))
    elif isinstance(typ, Diff):
        context, context_constraints = interpret_with_polarity(polarity, model, typ.context, ignored_ids)
        return (Diff(context, typ.negation), context_constraints)

    elif isinstance(typ, Imp):
        antec, antec_constraints = interpret_with_polarity(not polarity, model, typ.antec, ignored_ids)
        model = Model(model.constraints.difference(antec_constraints), model.freezer)
        consq, consq_constraints = interpret_with_polarity(polarity, model, typ.consq, ignored_ids)
        return (Imp(antec, consq), antec_constraints.union(consq_constraints))

    elif isinstance(typ, Exi):

        # return (typ, s())
        # TODO: uncomment below: gathering used constraints of negated side first (strong side of <: )

        neg_constraints = s() 
        strong_constraint_pairs = []
        for st in typ.constraints:
            strong, strong_constraints = interpret_with_polarity(not polarity, model, st.strong, ignored_ids)
            neg_constraints = neg_constraints.union(strong_constraints)
            strong_constraint_pairs.append((strong, st))

        model = Model(model.constraints.difference(neg_constraints), model.freezer)

        pos_constraints = s() 
        new_constraints = [] 
        for (strong, st) in strong_constraint_pairs:
            weak, weak_constraints = interpret_with_polarity(polarity, model, st.weak, ignored_ids)
            pos_constraints = pos_constraints.union(weak_constraints)
            new_constraints.append(Subtyping(strong, weak))


        body, body_constraints = interpret_with_polarity(polarity, model, typ.body, ignored_ids)
        ignored_ids = ignored_ids.union(typ.ids)
        used_constraints = body_constraints.union(pos_constraints).union(neg_constraints)
        return (Exi(typ.ids, tuple(new_constraints), body), used_constraints)

    elif isinstance(typ, All):
        return (typ, s())
        # TODO: copy Exi rule
    elif isinstance(typ, LeastFP):
        ignored_ids = ignored_ids.add(typ.id)
        body, body_constraints = interpret_with_polarity(polarity, model, typ.body, ignored_ids)
        return (LeastFP(typ.id, body), body_constraints)
    elif isinstance(typ, Top):
        return (typ, s())
    elif isinstance(typ, Bot):
        return (typ, s())
    else:
        assert False



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
    elif isinstance(typ, Exi):
        return Exi(typ.ids, simplify_constraints(typ.constraints), simplify_typ(typ.body))
    elif isinstance(typ, All):
        return All(typ.ids, simplify_constraints(typ.constraints), simplify_typ(typ.body))
    elif isinstance(typ, LeastFP):
        return LeastFP(typ.id, simplify_typ(typ.body))
    else:
        return typ
    
def simplify_constraints(constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(simplify_typ(st.strong), simplify_typ(st.weak))
        for st in constraints
    )

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
    elif isinstance(typ, Exi):  
        for bid in typ.ids:
            assignment_map = assignment_map.discard(bid)
        return Exi(typ.ids, sub_constraints(assignment_map, typ.constraints), sub_typ(assignment_map, typ.body)) 
    elif isinstance(typ, All):  
        for bid in typ.ids:
            assignment_map = assignment_map.discard(bid)
        return All(typ.ids, sub_constraints(assignment_map, typ.constraints), sub_typ(assignment_map, typ.body)) 
    elif isinstance(typ, LeastFP):  
        assignment_map = assignment_map.discard(typ.id)
        return LeastFP(typ.id, sub_typ(assignment_map, typ.body))
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
            plate_entry = ([], lambda : s(typ.id))
        elif isinstance(typ, TVar) :
            plate_entry = ([], lambda : s())
        elif isinstance(typ, TUnit):
            plate_entry = ([], lambda : s())
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

        elif isinstance(typ, Exi):
            bound_vars = bound_vars.union(typ.ids)
            set_constraints = extract_free_vars_from_constraints(bound_vars, typ.constraints)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_constraints.union(set_body))

        elif isinstance(typ, All):
            bound_vars = bound_vars.union(typ.ids)
            set_constraints = extract_free_vars_from_constraints(bound_vars, typ.constraints)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_constraints.union(set_body))

        elif isinstance(typ, LeastFP):
            bound_vars = bound_vars.add(typ.id)
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_body)

        elif isinstance(typ, Bot):
            plate_entry = ([], lambda : s())

        elif isinstance(typ, Top):
            plate_entry = ([], lambda : s())

        return plate_entry

    return util_system.make_stack_machine(make_plate_entry)((bound_vars, typ))
'''
end extract_free_vars_from_typ
'''

def extract_free_vars_from_constraints(bound_vars : PSet[str], constraints : Iterable[Subtyping]) -> PSet[str]:
    result = s()
    for st in constraints:
        result = (
            result
            .union(extract_free_vars_from_typ(bound_vars, st.strong))
            .union(extract_free_vars_from_typ(bound_vars, st.weak))
        )

    return result

def is_variable_unassigned(model : Model, id : str) -> bool:
    return (
        id not in extract_free_vars_from_constraints(s(), model.constraints)
    )

def extract_reachable_constraints(model : Model, id : str, ids_seen : PSet[str]) -> PSet[Subtyping]:
    constraints = extract_constraints_with_id(model, id) 
    ids_seen = ids_seen.add(id)
    ids = extract_free_vars_from_constraints(s(), constraints).difference(ids_seen)
    for id in ids:
        constraints = constraints.union(
            extract_reachable_constraints(model, id, ids_seen)
        ) 

    return constraints 

def extract_reachable_constraints_from_typ(model : Model, typ : Typ) -> PSet[Subtyping]:
    ids_base = extract_free_vars_from_typ(s(), typ)
    constraints = s()
    for id_base in ids_base: 
        constraints_reachable = extract_reachable_constraints(model, id_base, s())
        constraints = constraints.union(constraints_reachable)
    return constraints

def package_typ(model : Model, typ : Typ) -> Typ:
    constraints = extract_reachable_constraints_from_typ(model, typ)
    bound_ids = tuple(model.freezer.intersection(extract_free_vars_from_constraints(s(), constraints)))
    if not bound_ids and not constraints:
        typ_idx_unio = typ
    else:
        typ_idx_unio = Exi(bound_ids, tuple(constraints), typ)

    return simplify_typ(typ_idx_unio)

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

def make_unio(ts : list[Typ]) -> Typ:
    u = Bot()
    for t in reversed(ts):
        u = Unio(t, u)
    return simplify_typ(u)

def make_inter(ts : list[Typ]) -> Typ:
    u = Top()
    for t in reversed(ts):
        u = Inter(t, u)
    return simplify_typ(u)

def cast_up(renaming : PMap[str, TVar]) -> PMap[str, Typ]:
    return pmap({
        id : target
        for id, target in renaming.items()
    })


class Solver:
    _type_id : int = 0 
    _battery : int = 10 

    def decode_typ(self, models : list[Model], t : Typ) -> Typ:
        constraint_typs = [
            package_typ(model, t)
            for model in models
        ] 
        return make_unio(constraint_typs)

    # def decode_strong_side(self, models : list[Model], t : Typ, arg : Typ = TUnit()) -> Typ:

    #     for m in models:
    #         print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG decode_strong_side 
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # m.freezer: {m.freezer}
    # m.constraints: {concretize_constraints(tuple(m.constraints))}
    # t: {concretize_typ(t)}
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    #         """)

    #     constraint_typs = [
    #         package_typ(m, strongest)
    #         for model in models
    #         for op in [interpret_with_polarity(True, model, t)]
    #         if op != None
    #         for (strongest, cs) in [op]
    #         # for m in [model]
    #         for m in [Model(model.constraints.difference(cs), model.freezer)]
    #     ] 
    #     return make_unio(constraint_typs)

    # def decode_weak_side(self, models : list[Model], t : Typ) -> Typ:

    # #     for m in models:
    # #         print(f"""
    # # ~~~~~~~~~~~~~~~~~~~~~~~~
    # # DEBUG decode_weak_side 
    # # ~~~~~~~~~~~~~~~~~~~~~~~~
    # # m.freezer: {m.freezer}
    # # m.constraints: {concretize_constraints(tuple(m.constraints))}
    # # t: {concretize_typ(t)}
    # # ~~~~~~~~~~~~~~~~~~~~~~~~
    # #         """)
    #     constraint_typs = [
    #         package_typ(m, weakest)
    #         for model in models
    #         for op in [interpret_with_polarity(model, t, False)]
    #         if op != None
    #         for (weakest, cs) in [op]
    #         # for m in [model]
    #         for m in [Model(model.constraints.difference(cs), model.freezer)]
    #     ] 
    #     return make_unio(constraint_typs)

    def decode_with_polarity(self, polarity : bool, models : list[Model], t : Typ) -> Typ:

    #     for m in models:
    #         print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG decode_with_polarity 
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # m.freezer: {m.freezer}
    # m.constraints: {concretize_constraints(tuple(m.constraints))}
    # t: {concretize_typ(t)}
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    #         """)

        constraint_typs = [
            package_typ(m, tt)
            for model in models
            for op in [interpret_with_polarity(polarity, model, t, s())]
            if op != None
            for (tt, cs) in [op]
            # for m in [model]
            for m in [Model(model.constraints.difference(cs), model.freezer)]
        ] 
        return make_unio(constraint_typs)




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
        elif isinstance(t, Exi):
            renaming = self.make_renaming(t.ids)
            constraints = sub_constraints(renaming, t.constraints)
            body = sub_typ(renaming, t.body)
            bound_ids = tuple(t.id for t in renaming.values() if isinstance(t, TVar))

            (body_ids, body_constraints, body_typ) = self.flatten_index_unios(body)
            return (bound_ids + body_ids, constraints + body_constraints, body_typ)
        elif isinstance(t, All):
            return ((), (), t)
        elif isinstance(t, LeastFP):
            return ((), (), t)
        elif isinstance(t, Top):
            return ((), (), t)
        elif isinstance(t, Bot):
            return ((), (), t)


    def set_battery(self, battery : int):
        self._battery = battery 

    def fresh_type_id(self) -> str:
        self._type_id += 1
        return (f"_{self._type_id}")

    def fresh_type_var(self) -> TVar:
        return TVar(self.fresh_type_id())

    def make_renaming_tvars(self, old_ids) -> PMap[str, TVar]:
        '''
        Map old_ids to fresh ids
        '''
        d = {}
        for old_id in old_ids:
            fresh = self.fresh_type_var()
            d[old_id] = fresh

        return pmap(d)

    def make_renaming_ids(self, old_ids) -> PMap[str, str]:
        '''
        Map old_ids to fresh ids
        '''
        d = {}
        for old_id in old_ids:
            fresh = self.fresh_type_id()
            d[old_id] = fresh

        return pmap(d)

    def make_submap_from_renaming(self, renaming : PMap[str, str]) -> PMap[str, Typ]:
        return pmap({
            id : TVar(target)
            for id, target in renaming.items()
        })

    def make_renaming(self, old_ids) -> PMap[str, Typ]:
        return self.make_submap_from_renaming(self.make_renaming_ids(old_ids))


    def solve(self, model : Model, strong : Typ, weak : Typ) -> list[Model]:
        if self._battery == 0:
            return []
#         print(f'''
# || DEBUG SOLVE
# =================
# ||
# || model.freezer::: 
# || :::::::: {model.freezer}
# ||
# || model.constraints::: 
# || :::::::: {concretize_constraints(tuple(model.constraints))}
# ||
# || |- {concretize_typ(strong)} 
# || <: {concretize_typ(weak)}
# ||
#         ''')

        if alpha_equiv(strong, weak): 
            return [model] 

        if False:
            return [] 
        #######################################

        elif isinstance(strong, Exi):
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

        elif isinstance(weak, All):
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            next_id = self._type_id
            models = [model]
            for constraint in weak_constraints:
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
                for m2 in self.solve(m1, strong, weak_body)
            ]






        #######################################
        #### Variable rules: ####
        #######################################


        

        # NOTE: must interpret frozen/rigid/skolem variables before learning new constraints
        # but if uninterpretable and other type is learnable, then simply add it: 
        elif isinstance(strong, TVar) and strong.id in model.freezer: 
            interp = interpret_weakest_for_id(model, strong.id)
            if interp != None:
                weakest_strong = interp[0]
                return self.solve(model, weakest_strong, weak)
            elif isinstance(weak, TVar) and weak.id not in model.freezer:
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer
                )]
            else:
                return []

        elif isinstance(weak, TVar) and weak.id in model.freezer: 
            interp = interpret_strongest_for_id(model, weak.id)
            if interp != None:
                strongest_weak = interp[0]
                return self.solve(model, strong, strongest_weak)
            elif isinstance(strong, TVar) and strong.id not in model.freezer:
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer
                )]
            else:
                return []


# NOTE: this commented stuff doesn't actually work
# TODO: remove it
#         elif (
#             isinstance(strong, TVar) and strong.id not in model.freezer and
#             isinstance(weak, TVar) and weak.id not in model.freezer
#         ):
#             """
#             interpret both sides together to avoid transitive edges in subtyping lattice  
#             """
# #             print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~
# # DEBUG double TVar 
# # ~~~~~~~~~~~~~~~~~~~~
# # strong: {concretize_typ(strong)}
# # weak: {concretize_typ(weak)}
# # ~~~~~~~~~~~~~~~~~~~~~
# #             """)
#             strong_interp = interpret_strongest_for_id(model, strong.id)
#             weak_interp = interpret_weakest_for_id(model, weak.id)
#             if (
#                 strong_interp == None or not inhabitable(strong_interp[0]) or
#                 weak_interp == None or not selective(weak_interp[0])
#             ):
#                 return [Model(
#                     model.constraints.add(Subtyping(strong, weak)),
#                     model.freezer
#                 )]
#             else:
#                 strongest = strong_interp[0]
#                 weakest = weak_interp[0]
#                 return [
#                     Model(
#                         model.constraints.add(Subtyping(strong, weak)),
#                         model.freezer
#                     )
#                     for model in self.solve(model, strongest, weakest)
#                 ]

        elif isinstance(strong, TVar) and strong.id not in model.freezer: 
            interp = interpret_strongest_for_id(model, strong.id)

            # NOTE: this commented stuff doesn't actually work
            # TODO: remove it
            # '''
            # skip over the learnable variables to avoid redundant learning already covered by transitivity  
            # '''
            # while interp != None and isinstance(interp[0], TVar) and interp[0].id not in model.freezer:
            #         model = Model(model.constraints.difference(interp[1]), model.freezer)
            #         next_interp = interpret_strongest_for_id(model, interp[0].id)
            #         if next_interp:
                        
            #             interp = (next_interp[0], interp[1].union(next_interp[1]))
            #         else:
            #             interp = None


            if interp == None or not inhabitable(interp[0]):
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer
                )]

            else:
                strongest = interp[0]
                return [
                    Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer
                    )
                    for model in self.solve(model, strongest, weak)
                ]


        elif isinstance(weak, TVar) and weak.id not in model.freezer: 
            interp = interpret_weakest_for_id(model, weak.id)

            # NOTE: this commented stuff doesn't actually work
            # TODO: remove it
            # '''
            # skip over the learnable variables to avoid redundant learning already covered by transitivity  
            # '''
            # while interp != None and isinstance(interp[0], TVar) and interp[0].id not in model.freezer:
            #         model = Model(model.constraints.difference(interp[1]), model.freezer)
            #         next_interp = interpret_weakest_for_id(model, interp[0].id)
            #         if next_interp:
                        
            #             interp = (next_interp[0], interp[1].union(next_interp[1]))
            #         else:
            #             interp = None


            if interp == None or not selective(interp[0]):
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer
                )]
            else:
                weakest = interp[0]
                return [
                    Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer
                    )
                    for model in self.solve(model, strong, weakest)
                ]

        #######################################
        #### learnable bound variables ####
        #######################################
        # NOTE: Variable instantiation happens afte variable updates in order to maintain generalization
        elif isinstance(weak, Exi): 
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)
            models = self.solve(model, strong, weak_body) 
            for constraint in weak_constraints:
                models = [
                    m1
                    for m0 in models
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]
            return models


        elif isinstance(strong, All): 
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)
            models = self.solve(model, strong_body, weak) 
            for constraint in strong_constraints:
                models = [
                    m1
                    for m0 in models
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]
            return models


        #######################################
        #### Model rules: ####
        #######################################


        elif isinstance(strong, LeastFP):
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
            '''
            antecedent union: strong <: ((T1 | T2) -> TR)
            NOTE: (T1 -> TR) & (T2 -> TR) the same as (T1 -> TR) | (T2 -> TR) if and only if TR is learnable
            e.g. (A -> X & B -> Y) <: ([...]A | [...]B -> Q)
            ==== (A -> X & B -> Y) <: ([...]A -> Q) & ([...]B -> Q)
            '''

            return self.solve(model, strong, Inter(
                Imp(weak.antec.left, weak.consq), 
                Imp(weak.antec.right, weak.consq)
            ))

        # elif isinstance(weak, Imp) and isinstance(weak.consq, Inter):
        #     # TODO: remove; doesn't seem to be necessary
        #     '''
        #     consequent intersection: strong <: (TA -> (T1 & T2))
        #     P -> A & P -> B ~~~ P -> A & B 
        #     '''
        #     return [
        #         m1 
        #         for m0 in self.solve(model, strong, Imp(weak.antec, weak.consq.left))
        #         for m1 in self.solve(m0, strong, Imp(weak.antec, weak.consq.right))
        #     ]

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

        elif isinstance(weak, Diff): 
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, Diff 
# ~~~~~~~~~~~~~~~~~~~~
# strong: {concretize_typ(strong)}
# weak: {concretize_typ(weak)}
# well_formed: {diff_well_formed(weak)}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            if diff_well_formed(weak):
                # TODO: need a sound/safe/conservative inhabitable check
                # only works if we assume T is not empty
                '''
                T <: A \\ B === (T <: A) and (T is inhabitable --> ~(T <: B))
                ----
                T <: A \\ B === (T <: A) and ((T <: B) --> T is empty)
                ----
                T <: A \\ B === (T <: A) and (~(T <: B) or T is empty)
                '''
                context_models = self.solve(model, strong, weak.context)
    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG weak, Diff 
    # ~~~~~~~~~~~~~~~~~~~~
    # len(context_models): {len(context_models)}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)
                return [
                    m
                    for m in context_models 
                    if (
                        not inhabitable(strong) or 
                        self.solve(m, strong, weak.negation) == []
                    )
                ]   
            else:
                return []
        

        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(weak, Top): 
            return [model] 

        elif isinstance(strong, Bot): 
            return [model] 


        elif isinstance(weak, LeastFP): 
            # ids = extract_free_vars_from_typ(s(), strong)
            # sub_map = pmap({
            #     id : interp 
            #     for id in ids
            #     for pair in [
            #         mapOp(simplify_typ)(interpret_weakest_for_id(model, id))
            #         if id in model.freezer else
            #         mapOp(simplify_typ)(interpret_strongest_for_id(model, id))
            #     ]
            #     if pair 
            #     for interp in [pair[0]]
            #     if inhabitable(interp) 
            # })
            
            # reduced_strong = sub_typ(sub_map, strong)

            reduced_strong, used_constraints = interpret_with_polarity(True, model, strong, s())
            model = Model(model.constraints.difference(used_constraints), model.freezer)
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP
# ~~~~~~~~~~~~~~~~~~~~~
# model.freezer: {model.freezer}
# model.constraints: {concretize_constraints(tuple(model.constraints))}
# strong: {concretize_typ(strong)}
# reduced_strong: {concretize_typ(reduced_strong)}
# weak: {concretize_typ(weak)}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            if strong != reduced_strong:
                return self.solve(model, reduced_strong, weak)
            elif not is_relational_key(model, strong) and self._battery != 0:
                self._battery -= 1
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({weak.id : weak})
                weak_body = sub_typ(renaming, weak.body)

#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP --- Unrolling
# ~~~~~~~~~~~~~~~~~~~~~
# weak_body: {concretize_typ(weak_body)}
# ~~~~~~~~~~~~~~~~~~~~~
#                 """)
                models = self.solve(model, strong, weak_body)

                return models
            else:
                strong_cache = match_strong(model, strong)

                if strong_cache:
                    # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
                    return self.solve(model, strong_cache, weak)
                else:
                    if self.is_relation_constraint_wellformed(model, strong, weak):
                        """
                        relational constraint must be well formed, since a matching factorization exists
                        update model with well formed constraint that can't yet be solved
                        relational_key is well formed
                        and matches the cases of the weak type
                        """
                        return [Model(
                            model.constraints.add(Subtyping(strong, weak)),
                            model.freezer.union(extract_free_vars_from_typ(s(), strong))
                        )]
                    else:
                        return []

        elif isinstance(strong, Diff):
            if diff_well_formed(strong):
                '''
                A \\ B <: T === A <: T | B  
                '''
                return self.solve(model, strong.context, Unio(weak, strong.negation))
            else:
                return []


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

    def is_relation_constraint_wellformed(self, model : Model, strong : Typ, weak : LeastFP) -> bool:
        factored = factor_least(weak)
        models = self.solve(model, strong, factored)  
        return bool(models)

    def solve_composition(self, strong : Typ, weak : Typ) -> List[Model]: 
        self._battery = 100
        model = Model(s(), s())
        return self.solve(model, strong, weak)
    '''
    end solve_composition
    '''

'''
end Solver
'''

default_solver = Solver()
default_nonterm = Nonterm('expr', m(), [Model(s(), s())], default_solver.fresh_type_var())


class Rule:
    def __init__(self, solver : Solver):
        self.solver = solver

    def evolve_models(self, nt : Nonterm, t : Typ) -> list[Model]:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG evolve_models
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nt.enviro: {nt.enviro}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        return [
            m1
            for m0 in nt.models
            for m1 in self.solver.solve(m0, 
                t, 
                nt.typ_var
            )
        ]

    def evolve_models_with_pattern(self, nt : Nonterm, pat : Typ) -> list[Model]:
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG evolve_models_with_pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nt.enviro: {nt.enviro}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        return [
            m1
            for m0 in nt.models
            for m1 in self.solver.solve(m0, 
                nt.typ_var,
                pat 
            )
        ]



class BaseRule(Rule):

    def combine_var(self, nt : Nonterm, id : str) -> list[Model]:
        return self.evolve_models(nt, nt.enviro[id])

    def combine_assoc(self, nt : Nonterm, argchain : list[TVar]) -> list[Model]:
        if len(argchain) == 1:
            return self.evolve_models(nt, argchain[0])
        else:
            applicator = argchain[0]
            arguments = argchain[1:]
            print(f"""
~~~~~~~~~~~~~~~~~~~~~~
DEBUG combine_assoc
~~~~~~~~~~~~~~~~~~~~~
applicator: {applicator}
arguments: {arguments}
nt.models: {nt.models}
~~~~~~~~~~~~~~~~~~~~~
            """)
            result =  ExprRule(self.solver).combine_application(nt, applicator, arguments) 
            print(f"""
~~~~~~~~~~~~~~~~~~~~~~
DEBUG combine_assoc
~~~~~~~~~~~~~~~~~~~~~
result: {result}
~~~~~~~~~~~~~~~~~~~~~
            """)
            return result

    def combine_unit(self, nt : Nonterm) -> list[Model]:
        return self.evolve_models(nt, TUnit())

    def distill_tag_body(self, nt : Nonterm, label : str) -> Nonterm:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, TTag(label, body_var))
        return Nonterm('expr', nt.enviro, models, body_var)

    def combine_tag(self, nt : Nonterm, label : str, body : TVar) -> list[Model]:
        # TODO: remove existential check now that the types are simply variables
        # '''
        # move existential outside
        # '''
        # if isinstance(body, Exi):
        #     return self.evolve_models(nt, Exi(body.ids, body.constraints, TTag(label, body.body)))
        # else:
        # TODO: note that this constraint is redundant with constraint in distill rule
        # - consider removing redundancy
        return self.evolve_models(nt, TTag(label, body))

    def combine_function(self, nt : Nonterm, branches : list[Imp]) -> list[Model]:
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

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function len(nt.models): {len(nt.models)}
# ~~~~~~~~~~~~~~~~~~~~~
#         """)

#         for model in nt.models:
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function model
# ~~~~~~~~~~~~~~~~~~~~~
# model.freezer: {model.freezer}
# model.constraints: {concretize_constraints(tuple(model.constraints))}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)

        used_constraints = s()
        new_models = []
        for model in nt.models:

#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function model 
# ~~~~~~~~~~~~~~~~~~~~~
# model.freezer: {model.freezer}
# model.constraints: {concretize_constraints(tuple(model.constraints))}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            choices = from_branches_to_choices(branches)
            result = Top() 
            for choice in reversed(choices): 
                '''
                interpret, extrude, and generalize
                '''
                new_model = model

                (param_typ, param_used_constraints) = interpret_with_polarity(False, new_model, choice[0], s())
                used_constraints = used_constraints.union(param_used_constraints)
                new_model = Model(new_model.constraints .difference(used_constraints), new_model.freezer)

                (return_typ, return_used_constraints) = interpret_with_polarity(True, new_model, choice[1], s())
                used_constraints = used_constraints.union(return_used_constraints)
                new_model = Model(new_model.constraints .difference(used_constraints), new_model.freezer)

                fvs = extract_free_vars_from_typ(s(), param_typ)


                fvs = extract_free_vars_from_typ(s(), param_typ)
                renaming = self.solver.make_renaming_tvars(fvs)
                sub_map = cast_up(renaming)
                bound_ids = tuple(var.id for var in renaming.values())
                imp = Imp(param_typ, return_typ)
                generalized_case = imp
                ######## TODO: generalization #############
                # constraints = tuple(Subtyping(new_var, TVar(old_id)) for old_id, new_var in renaming.items()) + (
                #     # TODO: adding the following causes non-termination
                #     # but it's necessary to related return type to generalized parameter type
                #     sub_constraints(sub_map, tuple(extract_reachable_constraints_from_typ(new_model, imp)))
                # )

                # renamed_imp = sub_typ(sub_map, imp)
                # if bound_ids or constraints:
                #     generalized_case = All(bound_ids, constraints, renamed_imp)
                # else:
                #     generalized_case = renamed_imp
                #############################################

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_function iteration
    # ~~~~~~~~~~~~~~~~~~~~~
    # choice[0]: {concretize_typ(choice[0])}
    # choice[1]: {concretize_typ(choice[1])}

    # param_typ: {concretize_typ(param_typ)}
    # return_typ: {concretize_typ(return_typ)}

    # nt.env: {nt.enviro}
    # model.freezer: {model.freezer}
    # model.constraints: {concretize_constraints(tuple(model.constraints))}

    # generalized_case: {concretize_typ(generalized_case)}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)

                result = Inter(generalized_case, result)
                used_constraints = used_constraints.union(param_used_constraints).union(return_used_constraints)
            '''
            end for 
            '''

            new_model = Model(model.constraints.difference(used_constraints), model.freezer)
            new_models.extend(
                self.solver.solve(new_model, 
                    simplify_typ(result), 
                    nt.typ_var
                )
            )

#             print(f"""
#     ~~~~~~~~~~~~~~~~~~~~~
#     DEBUG combine_function
#     ~~~~~~~~~~~~~~~~~~~~~
#     result: {concretize_typ(simplify_typ(result))}
#     ~~~~~~~~~~~~~~~~~~~~~
#             """)

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function len(new_models): {len(new_models)}
# ~~~~~~~~~~~~~~~~~~~~~
#         """)
        return new_models

class ExprRule(Rule):

    def distill_tuple_head(self, nt : Nonterm) -> Nonterm:
        head_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, Inter(TField('head', head_var), TField('tail', Bot())))
        return Nonterm('expr', nt.enviro, models, head_var) 

    def distill_tuple_tail(self, nt : Nonterm, head_var : TVar) -> Nonterm:
        tail_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt,Inter(TField('head', head_var), TField('tail', tail_var)))
        return Nonterm('expr', nt.enviro, models, tail_var) 

    def combine_tuple(self, nt : Nonterm, head_var : TVar, tail_var : TVar) -> list[Model]:
        return self.evolve_models(nt, Inter(TField('head', head_var), TField('tail', tail_var)))

    def distill_ite_condition(self, nt : Nonterm) -> Nonterm:
        condition_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var,
        #         Unio(TTag('false', TUnit()), TTag('true', TUnit()))
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, condition_var)

    def distill_ite_true_branch(self, nt : Nonterm, condition_var : TVar) -> Nonterm:
        '''
        Find refined prescription Q in the :true? case given (condition : A), and unrefined prescription B.
        (:true? @ -> Q) <: (A -> B) 
        '''
        true_body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         Imp(TTag('true', TUnit()), true_body_var),
        #         Imp(true_body_var, nt.typ_var)
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, true_body_var) 

    def distill_ite_false_branch(self, nt : Nonterm, condition_var : TVar, true_body_var : TVar) -> Nonterm:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        false_body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         Imp(TTag('false', TUnit()), false_body_var),
        #         Imp(condition_var, nt.typ_var)
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, false_body_var) 

    def combine_ite(self, nt : Nonterm, condition_var : TVar, true_body_var : TVar, false_body_var : TVar) -> list[Model]: 
        cases = [
            Imp(TTag('true', TUnit()), true_body_var), 
            Imp(TTag('false', TUnit()), false_body_var)
        ]
        cator_var = self.solver.fresh_type_var()
        cator_models = [
            m1
            for m0 in nt.models
            for m1 in self.solver.solve(m0, cator_var, Imp(nt.typ_var, Top()))
        ]
        function_nt = replace(nt, models = cator_models, typ_var = cator_var)
        function_models = BaseRule(self.solver).combine_function(function_nt, cases)
        nt = replace(nt, models = function_models)
        arguments = [condition_var]
        return self.combine_application(nt, cator_var, arguments) 

    def distill_projection_rator(self, nt : Nonterm) -> Nonterm:
        # the type of the record being projected from
        rator_var = self.solver.fresh_type_var()
        return Nonterm('expr', nt.enviro, nt.models, rator_var)

    def distill_projection_keychain(self, nt : Nonterm, rator_var : TVar) -> Nonterm: 
        keychain_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         keychain_var,
        #         rator_var 
        #     )
        # ]
        return Nonterm('keychain', nt.enviro, models, keychain_var)


    def combine_projection(self, nt : Nonterm, record_var : TVar, keys : list[str]) -> list[Model]: 
        models = nt.models
        for key in keys:
            result_var = self.solver.fresh_type_var()
            models = [
                m1
                for m0 in models
                for m1 in self.solver.solve(m0, record_var, TField(key, result_var))
            ]
            record_var = result_var

        models = [
            m1
            for m0 in models
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]
        return models 

    #########

    def distill_application_cator(self, nt : Nonterm) -> Nonterm: 
        cator_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         cator_var,
        #         Imp(Bot(), Top()) 
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, cator_var)

    def distill_application_argchain(self, nt : Nonterm, cator_var : TVar) -> Nonterm: 
        next_cator_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         next_cator_var,
        #         cator_var
        #     )
        # ]
        return Nonterm('argchain', nt.enviro, models, next_cator_var, True)

    def combine_application(self, nt : Nonterm, cator_var : TVar, arg_vars : list[TVar]) -> list[Model]: 

        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG: combine_application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cator_var: {cator_var}
arg_vars: {arg_vars}
nt.models: {[concretize_constraints(tuple(m.constraints)) for m in nt.models]}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)

        models = nt.models
        for arg_var in arg_vars:
            result_var = self.solver.fresh_type_var()

            models = [
                m1
                for m0 in models
                for m1 in self.solver.solve(m0, cator_var, Imp(arg_var, result_var))
            ]
            cator_var = result_var

        models = [
            m1
            for m0 in models
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]
        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG: combine_application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
result_var: {result_var}
nt.typ_var: {nt.typ_var}
models: {[concretize_constraints(tuple(m.constraints)) for m in models]}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        return models

    #########
    def distill_funnel_arg(self, nt : Nonterm) -> Nonterm: 
        arg_var = self.solver.fresh_type_var()
        models = nt.models
        return Nonterm('expr', nt.enviro, models, arg_var)

    def distill_funnel_pipeline(self, nt : Nonterm, arg_var : TVar) -> Nonterm: 
        typ_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         typ_var,
        #         arg_var
        #     )
        # ]
        return Nonterm('pipeline', nt.enviro, models, typ_var)

    def combine_funnel(self, nt : Nonterm, arg_var : TVar, cator_vars : list[TVar]) -> list[Model]: 
        models = nt.models
        for cator_var in cator_vars:
            result_var = self.solver.fresh_type_var() 
            app_nt = replace(nt, models = models, typ_var = result_var) 
            models = self.combine_application(app_nt, cator_var, [arg_var])
            arg_var = result_var 
        # TODO: add final check that the result_typ <: nt.typ_var
        return models 

    def distill_fix_body(self, nt : Nonterm) -> Nonterm:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        return Nonterm('expr', nt.enviro, models, body_var)

    def combine_fix(self, nt : Nonterm, body_var : TVar) -> list[Model]:
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


        for outer_model in nt.models:

            '''
            Constructive a least fixed point type over union from the inner models
            '''
            inner_models = self.solver.solve(outer_model, body_var, Imp(self_typ, Imp(in_typ, out_typ)))

            induc_body = Bot()
            param_body = Bot()
            for inner_model in reversed(inner_models):
    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_fix (initial inner_model)
    # ~~~~~~~~~~~~~~~~~~~~~
    # inner_model.freezer: {inner_model.freezer}
    # inner_model.constraints: {concretize_constraints(tuple(inner_model.constraints))}
    # ======================
    # self_typ: {self_typ.id}
    # body_var: {concretize_typ(body_var)}

    # IH_typ: {IH_typ.id}
    # ======================
    #             """)

                left_interp = interpret_with_polarity(False, inner_model, in_typ, s())
                (left_typ, left_used_constraints) = (left_interp if left_interp else (in_typ, s()))

                inner_model = Model(inner_model.constraints.difference(left_used_constraints), inner_model.freezer)
                right_interp = interpret_with_polarity(True, inner_model, out_typ, s())
                (right_typ, right_used_constraints) = (right_interp if right_interp else (out_typ, s())) 

                inner_model = Model(inner_model.constraints.difference(right_used_constraints), inner_model.freezer)

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_fix (after interpretation of left and right)
    # ~~~~~~~~~~~~~~~~~~~~~
    # self_typ: {self_typ.id}
    # body_var: {concretize_typ(body_var)}

    # IH_typ: {IH_typ.id}
    # ======================
    # in_typ: {concretize_typ(in_typ)}
    # left_typ (weakly condensed in_typ): {concretize_typ(left_typ)}
    # left_used_constraints: {concretize_constraints(tuple(left_used_constraints))}

    # out_typ: {concretize_typ(out_typ)}
    # right_typ (strongly condensed out_typ): {concretize_typ(right_typ)}
    # right_used_constraints: {concretize_constraints(tuple(right_used_constraints))}
    # ======================
    # (:after removing used constraints:)
    # inner_model.freezer: {inner_model.freezer}
    # inner_model.constraints: {concretize_constraints(tuple(inner_model.constraints))}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)

                left_bound_ids = tuple(extract_free_vars_from_typ(s(), left_typ))
                right_bound_ids = tuple(extract_free_vars_from_typ(s(), right_typ))
                bound_ids = left_bound_ids + right_bound_ids
                rel_pattern = make_pair_typ(left_typ, right_typ)
                #########################################
                self_interp = interpret_with_polarity(False, inner_model, self_typ, s())

    #             nl = "\n"
    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG self_typ: {self_typ.id}
    # DEBUG self_interp: {mapOp(lambda p : concretize_typ(p[0]) + nl + concretize_constraints(tuple(p[1])))(self_interp)}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)

                if self_interp and isinstance(self_interp[0], Imp):
                    self_left = self_interp[0].antec
                    self_right = self_interp[0].consq
                    self_used_constraints = self_interp[1]
                    inner_model = Model(inner_model.constraints.difference(self_used_constraints), inner_model.freezer)
                    reachable_constraints = tuple(
                        st
                        for st in extract_reachable_constraints_from_typ(inner_model, rel_pattern)
                        if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
                    )

                    IH_rel_constraint = Subtyping(make_pair_typ(self_left, self_right), IH_typ)
                    rel_constraints = tuple([IH_rel_constraint]) + reachable_constraints
                    # TODO: what if there are existing frozen variables in inner_model?
                    rel_model = Model(pset(rel_constraints), pset(bound_ids))
                    constrained_rel = package_typ(rel_model, rel_pattern)

        #             print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~
        # DEBUG combine_fix rel
        # ~~~~~~~~~~~~~~~~~~~~~
        # body_var: {body_var}
        # IH_typ: {IH_typ.id}
        # rel_model.freezer: {rel_model.freezer}
        # rel_model.constraints: {concretize_constraints(tuple(rel_model.constraints))}
        # ======================
        # rel_pattern: {concretize_typ(rel_pattern)}
        # constrained rel: {concretize_typ(constrained_rel)}
        # ~~~~~~~~~~~~~~~~~~~~~
        #             """)

                    IH_left_constraint = Subtyping(self_left, IH_typ)
                    left_constraints = tuple([IH_left_constraint]) + reachable_constraints
                    # TODO: what if there are existing frozen variables in inner_model?
                    left_model = Model(pset(left_constraints).difference(left_used_constraints), pset(left_bound_ids))
                    constrained_left = package_typ(left_model, left_typ)

        #             print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~
        # DEBUG combine_fix left
        # ~~~~~~~~~~~~~~~~~~~~~
        # IH_typ: {IH_typ.id}
        # left_model.freezer: {left_model.freezer}
        # left_model.constraints: {concretize_constraints(tuple(left_model.constraints))}
        # ======================
        # left_pattern: {concretize_typ(left_typ)}
        # constrained left: {concretize_typ(constrained_left)}
        # ~~~~~~~~~~~~~~~~~~~~~
        #             """)
                else:

                    inner_model = Model(inner_model.constraints.difference(self_used_constraints), inner_model.freezer)
                    reduced_constraints = pset(
                        st
                        for st in extract_reachable_constraints_from_typ(inner_model, rel_pattern)
                        if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
                    )


                    constrained_rel = package_typ(Model(reduced_constraints, pset(bound_ids)), rel_pattern)
                    constrained_left = package_typ(Model(reduced_constraints, pset(left_bound_ids)), left_typ) 
                #end if

                induc_body = Unio(constrained_rel, induc_body) 
                param_body = Unio(constrained_left, param_body)

            #end for

            rel_typ = LeastFP(IH_typ.id, induc_body)
            param_upper = LeastFP(IH_typ.id, param_body)

    #         print(f"""
    # DEBUG rel_typ 
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # :: rel_typ: {concretize_typ(rel_typ)}
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #         """)

            param_typ = self.solver.fresh_type_var()
            return_typ = self.solver.fresh_type_var()
            consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
            consq_typ = Exi(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
            result = All(tuple([param_typ.id]), tuple([Subtyping(param_typ, param_upper)]), Imp(param_typ, consq_typ))  

            print(f"""
    DEBUG combine_fix result 
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    :: param_upper: {concretize_typ(param_upper)}
    :: result: {concretize_typ(result)}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)


            new_model = self.evolve_models(nt, result)
            ##################################
        return new_model

    
    def distill_let_target(self, nt : Nonterm, id : str) -> Nonterm:
        typ_var = self.solver.fresh_type_var()
        models = nt.models
        return Nonterm('target', nt.enviro, models, typ_var)

    def distill_let_contin(self, nt : Nonterm, id : str, target : Typ) -> Nonterm:
        '''
        no need to generalize; generalizstion occurs in combine_function
        '''
        enviro = nt.enviro.set(id, target)

        return Nonterm('expr', enviro, nt.models, nt.typ_var)

'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, nt : Nonterm, id : str) -> Nonterm:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, TField(id, body_var))
        return Nonterm('expr', nt.enviro, models, body_var) 

    def combine_single(self, nt : Nonterm, label : str, body_var : Typ) -> list[Model]:
        return self.evolve_models(nt, TField(label, body_var))

    def distill_cons_body(self, nt : Nonterm, id : str) -> Nonterm:
        return self.distill_single_body(nt, id)

    def distill_cons_tail(self, nt : Nonterm, id : str, body_var : TVar) -> Nonterm:
        tail_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, Inter(TField(id, body_var), tail_var))
        return Nonterm('record', nt.enviro, models, tail_var) 

    def combine_cons(self, nt : Nonterm, id : str, body : Typ, tail_var : TVar) -> list[Model]:
        return self.evolve_models(nt, Inter(TField(id, body), tail_var))

class FunctionRule(Rule):

    def distill_single_body(self, nt : Nonterm, pattern_typ : Typ) -> Nonterm:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var, Imp(pattern_typ, body_var)
        #     )
        # ]

        return Nonterm('expr', nt.enviro, models, body_var)

    def combine_single(self, nt : Nonterm, pattern_typ : Typ, body_var : TVar) -> list[Imp]:
        return [Imp(pattern_typ, body_var)]

    def distill_cons_body(self, nt : Nonterm, pattern_typ : Typ) -> Nonterm:
        return self.distill_single_body(nt, pattern_typ)

    def distill_cons_tail(self, nt : Nonterm, pattern_typ : Typ, body_var : TVar) -> Nonterm:
        '''
        - the previous pattern should not influence what pattern occurs next
        - patterns may overlap
        '''
        return nt

    def combine_cons(self, nt : Nonterm, pattern_typ : Typ, body_var : TVar, tail : list[Imp]) -> list[Imp]:
        return [Imp(pattern_typ, body_var)] + tail


class KeychainRule(Rule):

    def combine_single(self, nt : Nonterm, key : str) -> list[str]:
        return [key]

    def combine_cons(self, nt : Nonterm, key : str, keys : list[str]) -> list[str]:
        return [key] + keys


class ArgchainRule(Rule):
    def distill_single_content(self, nt : Nonterm) -> Nonterm:
        content_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var, Imp(typ_var, Top())
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, content_var, False)

    def distill_cons_head(self, nt : Nonterm) -> Nonterm:
        return self.distill_single_content(nt)

    def combine_single(self, nt : Nonterm, content_var : TVar) -> ArgchainAttr:
        return ArgchainAttr(nt.models, [content_var])

    def combine_cons(self, nt : Nonterm, head_var : TVar, tail_vars : list[TVar]) -> ArgchainAttr:
        print(f""""
~~~~~~~~~~~~~~~~~~~~~~~
Argchain combine_cons
~~~~~~~~~~~~~~~~~~~~~~~
>> head_var {head_var}
>> tail_vars {tail_vars}
>> combined vars {[head_var] + tail_vars}
~~~~~~~~~~~~~~~~~~~~~~~
        """)
        return ArgchainAttr(nt.models, [head_var] + tail_vars)

######

class PipelineRule(Rule):

    def distill_single_content(self, nt : Nonterm) -> Nonterm:
        content_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         content_var, Imp(nt.typ_var, Top())
        #     )
        # ]
        return Nonterm('expr', nt.enviro, models, content_var)


    def distill_cons_head(self, nt : Nonterm) -> Nonterm:
        return self.distill_single_content(nt)

    def distill_cons_tail(self, nt : Nonterm, head_var : TVar) -> Nonterm:
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        tail_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = [
        #     m1
        #     for m0 in nt.models
        #     for m1 in self.solver.solve(m0, 
        #         head_var, Imp(nt.typ_var, tail_var)
        #     )
        # ]
        return Nonterm('pipeline', nt.enviro, models, tail_var)

    def combine_single(self, nt : Nonterm, content_var : TVar) -> list[TVar]:
        return [content_var]

    def combine_cons(self, nt : Nonterm, head_var : TVar, tail_var : list[TVar]) -> list[TVar]:
        return [head_var] + tail_var


'''
start Pattern Rule
'''

class PatternRule(Rule):
    # def distill_tuple_head(self, nt : Nonterm) -> Nonterm:
    #     typ_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = [
    #     #     m1
    #     #     for m0 in nt.models
    #     #     for m1 in self.solver.solve(m0, 
    #     #         Inter(TField('head', typ_var), TField('tail', Bot())), 
    #     #         nt.typ_var
    #     #     )
    #     # ]

    #     return Nonterm('pattern', nt.enviro, models, typ_var) 

    # def distill_tuple_tail(self, nt : Nonterm, head_typ : Typ) -> Nonterm:
    #     typ_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = [
    #     #     m1
    #     #     for m0 in nt.models
    #     #     for m1 in self.solver.solve(m0, 
    #     #         Inter(TField('head', head_typ), TField('tail', typ_var)), 
    #     #         nt.typ_var,
    #     #     )
    #     # ]
    #     return Nonterm('pattern', nt.enviro, models, typ_var) 

    def combine_tuple(self, nt : Nonterm, head_typ : Typ, tail_typ : Typ) -> PatternAttr:
        pattern = Inter(TField('head', head_typ), TField('tail', tail_typ))
        return PatternAttr(nt.enviro, pattern)

'''
end PatternRule
'''

class BasePatternRule(Rule):

    def combine_var(self, nt : Nonterm, id : str) -> PatternAttr:
        pattern = self.solver.fresh_type_var()
        enviro = nt.enviro.set(id, pattern)
        return PatternAttr(enviro, pattern)

    def combine_unit(self, nt : Nonterm) -> PatternAttr:
        pattern = TUnit()
        return PatternAttr(nt.enviro, pattern)

    # def distill_tag_body(self, nt : Nonterm, id : str) -> Nonterm:
    #     body_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = [
    #     #     m1
    #     #     for m0 in nt.models
    #     #     for m1 in self.solver.solve(m0, 
    #     #         TTag(id, body_var), nt.typ_var
    #     #     )
    #     # ]
    #     return Nonterm('pattern', nt.enviro, models, body_var)

    def combine_tag(self, nt : Nonterm, label : str, body_typ : Typ) -> PatternAttr:
        pattern = TTag(label, body_typ)
        return PatternAttr(nt.enviro, pattern)
'''
end BasePatternRule
'''

class RecordPatternRule(Rule):

    # def distill_single_body(self, nt : Nonterm, id : str) -> Nonterm:
    #     body_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = [
    #     #     m1
    #     #     for m0 in nt.models
    #     #     for m1 in self.solver.solve(m0, 
    #     #         TField(id, typ_var), nt.typ_var
    #     #     )
    #     # ]
    #     return Nonterm('pattern_record', nt.enviro, models, body_var) 

    def combine_single(self, nt : Nonterm, label : str, body_typ : Typ) -> PatternAttr:
        pattern = TField(label, body_typ)
        return PatternAttr(nt.enviro, pattern)

    # def distill_cons_body(self, nt : Nonterm, id : str) -> Nonterm:
    #     return self.distill_cons_body(nt, id)

    # def distill_cons_tail(self, nt : Nonterm, id : str, body_typ : Typ) -> Nonterm:
    #     tail_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = self.evolve_models(nt, Inter(TField(id, body_typ), tail_var))
    #     return Nonterm('pattern_record', nt.enviro, models, tail_var) 

    def combine_cons(self, nt : Nonterm, label : str, body_typ : Typ, tail_typ : Typ) -> PatternAttr:
        pattern = Inter(TField(label, body_typ), tail_typ)
        return PatternAttr(nt.enviro, pattern)
