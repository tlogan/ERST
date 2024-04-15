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
class Nonterm: 
    id : str 

@dataclass(frozen=True, eq=True)
class Termin: 
    pattern : str 

GItem = Union[Nonterm, Termin]

SyntaxSeq = tuple[Union[Nonterm, Termin], ...] 

@dataclass(frozen=True, eq=True)
class SyntaxRule:
    head : str
    body : SyntaxSeq

Grammar = dict[str, list[SyntaxSeq]]

n = Nonterm
t = Termin
def from_rules_to_grammar (rules : PSet[SyntaxRule]) -> Grammar:
    g = {}
    for rule in rules:
        if rule.head in g:
            bodies = g[rule.head]
            g[rule.head] = bodies + [rule.body]
        else:
            g[rule.head] = [rule.body]
    return g

def concretize_rule_body(items : SyntaxSeq) -> str:
    return " ".join([
        (
            item.id
            if isinstance(item, Nonterm) else
            f"'{item.pattern}'"
            if isinstance(item, Termin) else
            "<ERROR>"
        )

        for item in items
    ])

def concretize_grammar(g : Grammar) -> str:
    result = ""
    for head in g:
        bodies = g[head]
        init_body = bodies[0]
        result += f"{head} ::= {concretize_rule_body(init_body)}" + "\n"
        result += "".join([
            (" " * len(head)) + "   | " + f"{concretize_rule_body(body)}" + "\n"
            for body in bodies[1:]
        ])
        result += "\n"
    return result

ID = t(r"[a-zA-Z][_a-zA-Z]*")

# def make_prompt_grammar() -> Grammar: 
#     return {
#         'expr' : [
#             [n('base')],
#             [n('base'), t(','), n('expr')],
#             [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')],
#             [n('base'), n('keychain')],
#             [n('base'), n('argchain')],
#             [n('base'), n('pipeline')],
#             [t('let'), ID, n('target'), t(';'), n('expr')],
#             [t('fix'), t('('), n('expr'), t(')')],
#         ],
        
#         'base' : [
#             [t('@')],
#             [t('~'), ID, n('base')],
#             [n('record')],
#             [n('function')],
#             [ID],
#             [n('argchain')]
#         ], 

#         'record' : [
#             [t('_.'), ID, t('='), n('expr')],
#             [t('_.'), ID, t('='), n('expr'), n('record')],
#         ],

#         'function' : [
#             [t('case'), n('pattern'), t('=>'), n('expr')],
#             [t('case'), n('pattern'), t('=>'), n('expr'), n('function')],
#         ],

#         'keychain' : [
#             [t('.'), ID],
#             [t('.'), ID, n('keychain')],
#         ],

#         'argchain' : [
#             [t('('), n('expr'), t(')')],
#             [t('('), n('expr'), t(')'), n('argchain')],
#         ],

#         'pipeline' : [
#             [t('|>'), n('expr')],
#             [t('|>'), n('expr'), n('pipeline')],
#         ],
        
#         'target' : [
#             # [t('='), n('expr')],
#             [t(':'), ID, t('='), n('expr')],
#         ],
        
#         'pattern' : [
#             [n('basepat')],
#             [n('basepat'), t(','), n('pattern')],
#         ],

#         'basepat' : [
#             [ID],
#             [t('@')],
#             [t('~'), ID, n('basepat')],
#             [n('recpat')],
#             [t('('), n('pattern'), t(')')],
#         ],
        
#         'recpat' : [
#             [t('_.'), ID, t('='), n('pattern')],
#             [t('_.'), ID, t('='), n('pattern'), n('recpat')],
#         ]

        
#     } 





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


@dataclass(frozen=True, eq=True)
class Branch:
    models : list[Model]
    pattern : Typ 
    body : TVar

@dataclass(frozen=True, eq=True)
class RecordBranch:
    models : list[Model]
    label : str 
    body : TVar


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

@dataclass(frozen=True, eq=True)
class PipelineAttr:
    models : list[Model]
    cators : list[TVar]

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
class Context:
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
    relids : PSet[str]

def by_variable(constraints : PSet[Subtyping], key : str) -> PSet[Subtyping]: 
    return pset((
        st
        for st in constraints
        if key in extract_free_vars_from_typ(pset(), st.strong)
    )) 

Guidance = Union[Symbol, Terminal, Context]

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

def augment_branches_with_diff(branches : list[Branch]) -> list[Branch]:
    '''
    nil -> zero
    cons X -> succ Y 
    --------------------
    (nil,zero) | (cons X\\nil, succ Y)
    '''

    augmented_branches = []
    negs = []

    for branch in branches:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG from_branches_to_choices
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG case: {concretize_typ(case)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
        augmented_branches += [Branch(branch.models, make_diff(branch.pattern, negs), branch.body)]
        neg_fvs = extract_free_vars_from_typ(s(), branch.pattern)  
        neg = (
            Exi(tuple(sorted(neg_fvs)), (), branch.pattern)
            if neg_fvs else
            branch.pattern 
        )
        # TODO
        # negs += [neg]
        negs = []
    return augmented_branches 

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
            op = interpret_strong_for_id(model, t.body.id) 
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

def interpret_weak_for_id(model : Model, id : str) -> Optional[tuple[Typ, PSet[Subtyping]]]:
    '''
    for constraints X <: T, X <: U; find weakest type stronger than T, stronger than U
    which is T & U.
    NOTE: related to weakest precondition concept
    '''


    has_weak_interpretation = id not in model.relids
    # TODO: determine if the following is needed or too restrictive
    # all(
    #     id != fv 
    #     for st in model.constraints
    #     if is_relational_key(model, st.strong)
    #     for fv in extract_free_vars_from_typ(s(), st.strong)
    # )

#     return result


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
# DEBUG interpret_weak_for_id 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# model.freezer: {model.freezer}
# model.constraints: {concretize_constraints(tuple(model.constraints))}
# id: {id}
# has_weakest_interpretation: {has_weakest_interpretation}
# ~~~~~~~~~~~~~~~~~~~~~~~~
#     """)


    if has_weak_interpretation:
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

def interpret_strong_for_id(model : Model, id : str) -> Optional[tuple[Typ, PSet[Subtyping]]]:
    '''
    for constraints T <: X, U <: X; find strongest type weaker than T, weaker than U
    which is T | U.
    NOTE: related to strongest postcondition concept
    '''

    has_strong_interpretation = True
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
# DEBUG interpret_strong_for_id ~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~ model.freezer: {model.freezer}
# ~~ model.constraints: {concretize_constraints(tuple(model.constraints))}
# ~~ id: {id}
# ~~ has_strongest_interpretation: {has_strongest_interpretation}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)

    if has_strong_interpretation:
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

def interpret_strong_for_ids(model : Model, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:

    trips = [ 
        (id, strongest, cs)
        for id in ids
        for op in [interpret_strong_for_id(model, id)]
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

def interpret_weak_for_ids(model : Model, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:
    trips = [ 
        (id, weakest, cs)
        for id in ids
        for op in [interpret_weak_for_id(model, id)]
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
#         #     for op in [mapOp(simplify_typ)(interpret_strong_for_id(model, id))]
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
#         #     for op in [mapOp(simplify_typ)(interpret_strong_for_id(model, id))]
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
#                 mapOp(simplify_typ)(interpret_weak_for_id(model, id))
#                 if id in model.freezer else
#                 mapOp(simplify_typ)(interpret_strong_for_id(model, id))
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
# # interp _4: {mapOp(simplify_typ)(interpret_strong_for_id(model, '_4'))}
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
#         #     for op in [mapOp(simplify_typ)(interpret_weak_for_id(model, id))]
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
#                 mapOp(simplify_typ)(interpret_strong_for_id(model, id))
#                 if (id in model.freezer) else
#                 mapOp(simplify_typ)(interpret_weak_for_id(model, id))
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


    # print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG interpret_with_polarity:
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # typ: {concretize_typ(typ)}

    # model.freezer: {model.freezer}
    # model.constraints: {concretize_constraints(tuple(model.constraints))}
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # """)

    def interpret_for_id(polarity : bool, id : str): 
        if polarity:
            return interpret_strong_for_id(model, id)
        else:
            return interpret_weak_for_id(model, id)

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
            # print(f"""
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # DEBUG: used_constraints: {concretize_constraints(cs_once)}
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # """)
            if (id in model.freezer) or meaningful(polarity, interp_typ_once): 
                m = Model(model.constraints.difference(cs_once), model.freezer, model.relids)
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
        consq, consq_constraints = interpret_with_polarity(polarity, model, typ.consq, ignored_ids)
        model = Model(model.constraints.difference(consq_constraints), model.freezer, model.relids)
        antec, antec_constraints = interpret_with_polarity(not polarity, model, typ.antec, ignored_ids.union(extract_free_vars_from_typ(ignored_ids, consq)))
        return (Imp(antec, consq), antec_constraints.union(consq_constraints))

    elif isinstance(typ, Exi):
        return (typ, s())
        # TODO: uncomment below: gathering used constraints of negated side first (strong side of <: )
        # pos_constraints = s() 
        # weak_constraint_pairs = []
        # for st in typ.constraints:
        #     weak, weak_constraints = interpret_with_polarity(not polarity, model, st.weak, ignored_ids)
        #     pos_constraints = pos_constraints.union(weak_constraints)
        #     weak_constraint_pairs.append((weak, st))
        #     ignored_ids = ignored_ids.union(extract_free_vars_from_typ(ignored_ids, weak))

        # model = Model(model.constraints.difference(pos_constraints), model.freezer)

        # neg_constraints = s() 
        # new_constraints = [] 
        # for (weak, st) in weak_constraint_pairs:
        #     strong, strong_constraints = interpret_with_polarity(polarity, model, st.strong, ignored_ids)
        #     pos_constraints = pos_constraints.union(strong_constraints)
        #     new_constraints.append(Subtyping(strong, weak))


        # body, body_constraints = interpret_with_polarity(polarity, model, typ.body, ignored_ids)
        # ignored_ids = ignored_ids.union(typ.ids)
        # used_constraints = body_constraints.union(pos_constraints).union(neg_constraints)
        # return (Exi(typ.ids, tuple(new_constraints), body), used_constraints)

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

    reachable_ids = extract_free_vars_from_constraints(s(), constraints).union(extract_free_vars_from_typ(s(), typ))
    bound_ids = tuple(model.freezer.intersection(reachable_ids))
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

        for model in models:
            print(f"""
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            DEBUG decode_with_polarity:
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            typ: {concretize_typ(t)}

            model.freezer: {model.freezer}
            model.constraints: {concretize_constraints(tuple(model.constraints))}
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)

        constraint_typs = [
            package_typ(m, tt)
            for model in models
            for op in [interpret_with_polarity(polarity, model, t, s())]
            if op != None
            for (tt, cs) in [op]
            # for m in [model]
            for m in [Model(model.constraints.difference(cs), model.freezer, model.relids)]
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
                for m1 in [Model(m0.constraints, m0.freezer.union(renamed_ids).union(new_ids), m0.relids)]
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
                for m1 in [Model(m0.constraints, m0.freezer.union(renamed_ids).union(new_ids), m0.relids)]
                for m2 in self.solve(m1, strong, weak_body)
            ]






        #######################################
        #### Variable rules: ####
        #######################################


        

        # NOTE: must interpret frozen/rigid/skolem variables before learning new constraints
        # but if uninterpretable and other type is learnable, then simply add it: 
        elif isinstance(strong, TVar) and strong.id in model.freezer: 


            interp = interpret_weak_for_id(model, strong.id)
            print(f"""
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            DEBUG strong, TVar frozen  
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            strong: {concretize_typ(strong)}
            weak: {concretize_typ(weak)}
            has interp: {interp != None}
            model.relids: {model.relids}
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)
            if interp != None:
                weakest_strong = interp[0]
                return self.solve(model, weakest_strong, weak)
            elif isinstance(weak, TVar) and weak.id not in model.freezer:
                # TODO: consider safety check
                #     # safe = bool(self.solve(model, Top(), weak))
                #     safe = True
                #     if safe:
                #         return [Model(
                #             model.constraints.add(Subtyping(strong, weak)),
                #             model.freezer, model.relids
                #         )]
                #     else:
                #         return []
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer, model.relids
                )]
            else:
                print(f"""
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                !!!!!!!!!!!!!!! DEBUG strong, TVar frozen FAILURE  !!!!!!!!!!!
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                strong: {concretize_typ(strong)}
                weak: {concretize_typ(weak)}
                has interp: {interp != None}
                model.relids: {model.relids}
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                """)
                return []

        elif isinstance(weak, TVar) and weak.id in model.freezer: 
            interp = interpret_strong_for_id(model, weak.id)
            if interp != None:
                strongest_weak = interp[0]
                return self.solve(model, strong, strongest_weak)
            elif isinstance(strong, TVar) and strong.id not in model.freezer:
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer, model.relids
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
#             strong_interp = interpret_strong_for_id(model, strong.id)
#             weak_interp = interpret_weak_for_id(model, weak.id)
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
            print(f"""
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            DEBUG strong, TVar learnable  
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            strong: {concretize_typ(strong)}
            weak: {concretize_typ(weak)}
            model.relids: {model.relids}
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)
            interp = interpret_strong_for_id(model, strong.id)
            if interp == None or not inhabitable(interp[0]):
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer, model.relids
                )]

            else:
                strongest = interp[0]
                return [
                    Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer, model.relids
                    )
                    for model in self.solve(model, strongest, weak)
                ]


        elif isinstance(weak, TVar) and weak.id not in model.freezer: 
            interp = interpret_weak_for_id(model, weak.id)
            if interp == None or not selective(interp[0]):
                return [Model(
                    model.constraints.add(Subtyping(strong, weak)),
                    model.freezer, model.relids
                )]
            else:
                weakest = interp[0]
                return [
                    Model(
                        model.constraints.add(Subtyping(strong, weak)),
                        model.freezer, model.relids
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
            return self.solve(model, strong, Inter(
                Imp(weak.antec.left, weak.consq), 
                Imp(weak.antec.right, weak.consq)
            ))

        elif isinstance(weak, Imp) and isinstance(weak.consq, Inter):
            return self.solve(model, strong, Inter(
                Imp(weak.antec, weak.consq.left), 
                Imp(weak.antec, weak.consq.right)
            ))

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
            #         mapOp(simplify_typ)(interpret_weak_for_id(model, id))
            #         if id in model.freezer else
            #         mapOp(simplify_typ)(interpret_strong_for_id(model, id))
            #     ]
            #     if pair 
            #     for interp in [pair[0]]
            #     if inhabitable(interp) 
            # })
            
            # reduced_strong = sub_typ(sub_map, strong)

            reduced_strong, used_constraints = interpret_with_polarity(True, model, strong, s())
            print(f"""
~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~
DEBUG weak, LeastFP
~~~~~~~~~~~~~~~~~~~~~
model.relids: {model.relids}
model.freezer: {model.freezer}
model.constraints: {concretize_constraints(tuple(model.constraints))}

strong: {concretize_typ(strong)}
reduced_strong: {concretize_typ(reduced_strong)}
weak: {concretize_typ(weak)}
~~~~~~~~~~~~~~~~~~~~~
            """)
            model = Model(model.constraints.difference(used_constraints), model.freezer, model.relids)
            if strong != reduced_strong:
                return self.solve(model, reduced_strong, weak)
            elif not is_relational_key(model, strong) and self._battery != 0:
                self._battery -= 1
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({weak.id : weak})
                weak_body = sub_typ(renaming, weak.body)

                print(f"""
~~~~~~~~~~~~~~~~~~~~~
DEBUG weak, LeastFP --- Unrolling
~~~~~~~~~~~~~~~~~~~~~
weak_body: {concretize_typ(weak_body)}
~~~~~~~~~~~~~~~~~~~~~
                """)
                models = self.solve(model, strong, weak_body)

                return models
            else:
                strong_cache = match_strong(model, strong)

                if strong_cache:
                    # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
                    return self.solve(model, strong_cache, weak)
                else:
                    fvs = extract_free_vars_from_typ(s(), strong)  
                    print(f"""
~~~~~~~~~~~~~~~~~~~~~
DEBUG weak, LeastFP --- Adding relids 
~~~~~~~~~~~~~~~~~~~~~
fvs: {fvs}
~~~~~~~~~~~~~~~~~~~~~

                    """)
                    if (
                        (all((fv not in model.freezer) for fv in fvs)) and 
                        self.is_relation_constraint_wellformed(model, strong, weak)
                    ):
                        return [Model(
                            model.constraints.add(Subtyping(strong, weak)),
                            model.freezer, model.relids.union(fvs)
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
        model = Model(s(), s(), s())
        return self.solve(model, strong, weak)
    '''
    end solve_composition
    '''

'''
end Solver
'''

default_solver = Solver()
default_nonterm = Context('expr', m(), [Model(s(), s(), s())], default_solver.fresh_type_var())


class Rule:
    def __init__(self, solver : Solver):
        self.solver = solver

    def evolve_models(self, nt : Context, t : Typ) -> list[Model]:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG evolve_models
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# nt.enviro: {nt.enviro}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
        return [
            m1
            for m0 in nt.models
            for m1 in self.solver.solve(m0, 
                t, 
                nt.typ_var
            )
        ]

class BaseRule(Rule):

    def combine_var(self, nt : Context, id : str) -> list[Model]:
        return self.evolve_models(nt, nt.enviro[id])

    def combine_assoc(self, nt : Context, argchain : list[TVar]) -> list[Model]:
        if len(argchain) == 1:
            return self.evolve_models(nt, argchain[0])
        else:
            applicator = argchain[0]
            arguments = argchain[1:]
            result = ExprRule(self.solver).combine_application(nt, applicator, arguments) 
            return result

    def combine_unit(self, nt : Context) -> list[Model]:
        return self.evolve_models(nt, TUnit())

    def distill_tag_body(self, nt : Context, label : str) -> Context:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, TTag(label, body_var))
        return Context('expr', nt.enviro, models, body_var)

    def combine_tag(self, nt : Context, label : str, body : TVar) -> list[Model]:
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

    def combine_record(self, nt : Context, branches : list[RecordBranch]) -> list[Model]:
        result = Top() 
        for branch in reversed(branches): 
            for branch_model in reversed(branch.models):
                new_model = branch_model

                (body_typ, body_used_constraints) = interpret_with_polarity(True, new_model, branch.body, s())
                new_model = Model(new_model.constraints.difference(body_used_constraints), new_model.freezer, new_model.relids)

                field = TField(branch.label, body_typ)
                constraints = tuple(extract_reachable_constraints_from_typ(new_model, field))
                if constraints:
                    # TODO: update outer model instead of nesting constraints; since there's no generalization
                    generalized_case = All((), constraints, field)
                else:
                    generalized_case = field 


                result = Inter(generalized_case, result)
            '''
            end for 
            '''
        '''
        end for 
        '''

        return self.evolve_models(nt, simplify_typ(result))

    def combine_function(self, nt : Context, branches : list[Branch]) -> list[Model]:
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

        augmented_branches = augment_branches_with_diff(branches)
        constrained_branches = []
        for branch in reversed(augmented_branches): 
            for branch_model in reversed(branch.models):
                '''
                interpret, extrude, and generalize
                '''
                new_model = branch_model

                (return_typ, return_used_constraints) = interpret_with_polarity(True, new_model, branch.body, s())
                new_model = Model(new_model.constraints.difference(return_used_constraints), new_model.freezer, new_model.relids)
                (param_typ, param_used_constraints) = interpret_with_polarity(False, new_model, branch.pattern, extract_free_vars_from_typ(s(), return_typ))
                new_model = Model(new_model.constraints.difference(param_used_constraints), new_model.freezer, new_model.relids)
                imp = Imp(param_typ, return_typ)
                constrained_branches.append((new_model, imp))
            '''
            end for 
            '''
        '''
        end for 
        '''
        if len(constrained_branches) == 1:
            new_model, imp = constrained_branches[0]
            return self.solver.solve(new_model, simplify_typ(imp), nt.typ_var)
        else:
            result = Top()
            for new_model, imp in constrained_branches:
                generalized_case = imp
                ######## DEBUG: without generalization #############
                constraints = tuple(extract_reachable_constraints_from_typ(new_model, imp))
                if constraints:
                    generalized_case = All((), constraints, imp)
                else:
                    generalized_case = imp
                ######## TODO: generalize in a separate loop over constrained_branches #############
                # fvs = extract_free_vars_from_typ(s(), param_typ)
                # renaming = self.solver.make_renaming_tvars(fvs)
                # sub_map = cast_up(renaming)
                # bound_ids = tuple(var.id for var in renaming.values())
                # constraints = tuple(Subtyping(new_var, TVar(old_id)) for old_id, new_var in renaming.items()) + (
                #     sub_constraints(sub_map, tuple(extract_reachable_constraints_from_typ(new_model, imp)))
                # )

                # renamed_imp = sub_typ(sub_map, imp)
                # if bound_ids or constraints:
                #     generalized_case = All(bound_ids, constraints, renamed_imp)
                # else:
                #     generalized_case = renamed_imp
                #############################################
                result = Inter(generalized_case, result)
            '''
            end for
            '''
            models = self.evolve_models(nt, simplify_typ(result))
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
            return models
        '''
        end if/else
        '''
    '''
    end def
    '''

class ExprRule(Rule):

    def distill_tuple_head(self, nt : Context) -> Context:
        head_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, Inter(TField('head', head_var), TField('tail', Bot())))
        return Context('expr', nt.enviro, models, head_var) 

    def distill_tuple_tail(self, nt : Context, head_var : TVar) -> Context:
        tail_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt,Inter(TField('head', head_var), TField('tail', tail_var)))
        return Context('expr', nt.enviro, models, tail_var) 

    def combine_tuple(self, nt : Context, head_var : TVar, tail_var : TVar) -> list[Model]:
        return self.evolve_models(nt, Inter(TField('head', head_var), TField('tail', tail_var)))

    def distill_ite_condition(self, nt : Context) -> Context:
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
        return Context('expr', nt.enviro, models, condition_var)

    def distill_ite_true_branch(self, nt : Context, condition_var : TVar) -> Context:
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
        return Context('expr', nt.enviro, models, true_body_var) 

    def distill_ite_false_branch(self, nt : Context, condition_var : TVar, true_body_var : TVar) -> Context:
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
        return Context('expr', nt.enviro, models, false_body_var) 

    def combine_ite(self, nt : Context, condition_var : TVar, 
                true_body_models: list[Model], true_body_var : TVar, 
                false_body_models: list[Model], false_body_var : TVar
    ) -> list[Model]: 
        branches = [
            Branch(true_body_models, TTag('true', TUnit()), true_body_var), 
            Branch(false_body_models, TTag('false', TUnit()), false_body_var)
        ]
        cator_var = self.solver.fresh_type_var()
        function_nt = replace(nt, typ_var = cator_var)
        function_models = BaseRule(self.solver).combine_function(function_nt, branches)
        nt = replace(nt, models = function_models)
        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG ite len(function_models): {len(function_models)}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)
        arguments = [condition_var]
        return self.combine_application(nt, cator_var, arguments) 

    def distill_projection_rator(self, nt : Context) -> Context:
        # the type of the record being projected from
        rator_var = self.solver.fresh_type_var()
        return Context('expr', nt.enviro, nt.models, rator_var)

    def distill_projection_keychain(self, nt : Context, rator_var : TVar) -> Context: 
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
        return Context('keychain', nt.enviro, models, keychain_var)


    def combine_projection(self, nt : Context, record_var : TVar, keys : list[str]) -> list[Model]: 
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

    def distill_application_cator(self, nt : Context) -> Context: 
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
        return Context('expr', nt.enviro, models, cator_var)

    def distill_application_argchain(self, nt : Context, cator_var : TVar) -> Context: 
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
        return Context('argchain', nt.enviro, models, next_cator_var, True)

    def combine_application(self, nt : Context, cator_var : TVar, arg_vars : list[TVar]) -> list[Model]: 

        print(f"""
        ~~~~~~~~~~~~~~
        DEBUG application init
        ~~~~~~~~~~~~~~
        len(nt.enviro): {nt.enviro}
        len(nt.models): {len(nt.models)}
        ~~~~~~~~~~~~~~
        """)

        models = nt.models 
        for arg_var in arg_vars:
            result_var = self.solver.fresh_type_var()
            new_models = []
            for model in models:
                # NOTE: interpretation to keep types and constraints compact 
                cator_typ, cator_used_constraints = interpret_with_polarity(True, model, cator_var, s())
                arg_typ, arg_used_constraints = interpret_with_polarity(True, model, arg_var, s())
                # arg_typ, arg_used_constraints = (arg_var, s())

                print(f"""
                ~~~~~~~~~~~~~~
                DEBUG application
                ~~~~~~~~~~~~~~
                model.freezer: {tuple(model.freezer)}
                model.constraints: {concretize_constraints(tuple(model.constraints))}

                cator_var: {concretize_typ(cator_var)}
                cator_typ: {concretize_typ(cator_typ)}

                arg_var: {arg_var.id}
                arg_typ: {concretize_typ(arg_typ)}
                result_var: {result_var.id}
                ~~~~~~~~~~~~~~
                """)

                # print(f"""
                # ~~~~~~~~~~~~~~
                # DEBUG application
                # ~~~~~~~~~~~~~~
                # model.freezer: {tuple(model.freezer)}
                # model.constraints: {concretize_constraints(tuple(model.constraints))}
                # cator_var: {cator_var}
                # arg_var: {arg_var}

                # cator_typ: {concretize_typ(cator_typ)}
                # arg_typ: {concretize_typ(arg_typ)}
                # ~~~~~~~~~~~~~~
                # """)
                model = Model(model.constraints.difference(cator_used_constraints).difference(arg_used_constraints), model.freezer, model.relids)
                new_models.extend(self.solver.solve(model, cator_typ, Imp(arg_typ, result_var)))
            models = new_models

            # TODO: remove version without interpretation
            # models = [
            #     m1
            #     for m0 in models
            #     for m1 in self.solver.solve(m0, cator_var, Imp(arg_var, result_var))
            # ] 
            ###########################
            cator_var = result_var

        models = [
            m1
            for m0 in models
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]

        print(f"""
        ~~~~~~~~~~~~~~
        DEBUG application results 
        len(models): {len(models)}
        ~~~~~~~~~~~~~~
        """)

        for model in models:
            print(f"""
            ~~~~~~~~~~~~~~
            DEBUG application results
            ~~~~~~~~~~~~~~
            model.freezer: {tuple(model.freezer)}
            model.constraints: {concretize_constraints(tuple(model.constraints))}
            cator_var: {cator_var}
            arg_var: {arg_var}

            cator_typ: {concretize_typ(cator_typ)}
            arg_typ: {concretize_typ(arg_typ)}
            ~~~~~~~~~~~~~~
            """)
        return models

    #########
    def distill_funnel_arg(self, nt : Context) -> Context: 
        arg_var = self.solver.fresh_type_var()
        models = nt.models
        return Context('expr', nt.enviro, models, arg_var)

    def distill_funnel_pipeline(self, nt : Context, arg_var : TVar) -> Context: 
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
        return Context('pipeline', nt.enviro, models, typ_var)

    def combine_funnel(self, nt : Context, arg_var : TVar, cator_vars : list[TVar]) -> list[Model]: 
        models = nt.models
        for cator_var in cator_vars:
            print(f"""
            ~~~~~~~~
            DEBUG funnel
            cator_var: {cator_var}
            ~~~~~~~~
            """)
            result_var = self.solver.fresh_type_var() 
            app_nt = replace(nt, models = models, typ_var = result_var) 
            models = self.combine_application(app_nt, cator_var, [arg_var])
            arg_var = result_var 

        # NOTE: add final constraint to connect to expected type var: the result_typ <: nt.typ_var
        models = [
            m1
            for m0 in models
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]
        return models 

    def distill_fix_body(self, nt : Context) -> Context:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        return Context('expr', nt.enviro, models, body_var)

    def combine_fix(self, nt : Context, body_var : TVar) -> list[Model]:
        """
        from: 
        SELF -> (nil -> zero) & (cons A\\nil -> succ B) ;  SELF <: A -> B SELF(A) <: B
        --------------- OR -----------------------
        ALL[X . X <: nil | cons A] X -> EXI[Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] Y
        --------------- OR -----------------------
        ALL[X Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] X -> Y
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

                inner_model = Model(inner_model.constraints.difference(left_used_constraints), inner_model.freezer, inner_model.relids)
                right_interp = interpret_with_polarity(True, inner_model, out_typ, s())
                (right_typ, right_used_constraints) = (right_interp if right_interp else (out_typ, s())) 

                inner_model = Model(inner_model.constraints.difference(right_used_constraints), inner_model.freezer, inner_model.relids)

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

                self_used_constraints = s()
                if self_interp and isinstance(self_interp[0], Imp):
                    self_left = self_interp[0].antec
                    self_right = self_interp[0].consq

                    self_used_constraints = self_interp[1]
                    IH_rel_constraints = s(Subtyping(make_pair_typ(self_left, self_right), IH_typ))
                    # IH_left_constraints = s(Subtyping(self_left, IH_typ))
                else:
                    self_used_constraints = s()

                    IH_rel_constraints = s()
                    # IH_left_constraints = s()
                #end if

                inner_model = Model(inner_model.constraints.difference(self_used_constraints), inner_model.freezer, inner_model.relids)
                reachable_constraints = tuple(
                    st
                    for st in extract_reachable_constraints_from_typ(inner_model, rel_pattern)
                    if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
                )

                rel_constraints = IH_rel_constraints.union(reachable_constraints)
                # left_constraints = IH_left_constraints.union(reachable_constraints)

                # TODO: see why frozen variables aren't in existential from package type

                # TODO: what if there are existing frozen variables in inner_model?
                rel_model = Model(pset(rel_constraints), pset(bound_ids), inner_model.relids)
                constrained_rel = package_typ(rel_model, rel_pattern)

                # TODO: what if there are existing frozen variables in inner_model?
                # left_model = Model(pset(left_constraints).difference(left_used_constraints), pset(left_bound_ids), inner_model.relids)
                # constrained_left = package_typ(left_model, left_typ)

                induc_body = Unio(constrained_rel, induc_body) 
                # param_body = Unio(constrained_left, param_body)


                print(f"""
    ~~~~~~~~~~~~~~~~~~~~~
    DEBUG combine_fix rel
    ~~~~~~~~~~~~~~~~~~~~~
    body_var: {body_var}
    IH_typ: {IH_typ.id}
    rel_model.freezer: {rel_model.freezer}
    rel_model.constraints: {concretize_constraints(tuple(rel_model.constraints))}
    ======================
    rel_pattern: {concretize_typ(rel_pattern)}
    constrained rel: {concretize_typ(constrained_rel)}
    ~~~~~~~~~~~~~~~~~~~~~
                """)

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
            # consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
            # consq_typ = Exi(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
            # result = All(tuple([param_typ.id]), tuple([Subtyping(param_typ, param_upper)]), Imp(param_typ, consq_typ))  

            full_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
            result = All(tuple([param_typ.id, return_typ.id]), tuple([full_constraint]), Imp(param_typ, return_typ))  

    # :: param_upper: {concretize_typ(param_upper)}

    # ::::

            print(f"""
    DEBUG combine_fix result 
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    :: rel_typ: {concretize_typ(rel_typ)}

    ::::
    
    :: result: {concretize_typ(result)}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)


            new_model = self.evolve_models(nt, result)
            ##################################
        return new_model

    
    def distill_let_target(self, nt : Context, id : str) -> Context:
        typ_var = self.solver.fresh_type_var()
        models = nt.models
        return Context('target', nt.enviro, models, typ_var)

    def distill_let_contin(self, nt : Context, id : str, target : Typ) -> Context:
        enviro = nt.enviro.set(id, target)
        return Context('expr', enviro, nt.models, nt.typ_var)

'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, nt : Context, id : str) -> Context:
        body_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, TField(id, body_var))
        return Context('expr', nt.enviro, models, body_var) 

    def combine_single(self, nt : Context, label : str, body_models : list[Model], body_var : TVar) -> list[RecordBranch]:
        return [RecordBranch(body_models, label, body_var)]

    def distill_cons_body(self, nt : Context, id : str) -> Context:
        return self.distill_single_body(nt, id)

    def distill_cons_tail(self, nt : Context, id : str, body_var : TVar) -> Context:
        tail_var = self.solver.fresh_type_var()
        models = nt.models
        # TODO: add constraints in distill for type-guided program synthesis 
        # models = self.evolve_models(nt, Inter(TField(id, body_var), tail_var))
        return Context('record', nt.enviro, models, tail_var) 

    def combine_cons(self, nt : Context, label : str, body_models : list[Model], body_var : TVar, tail : list[RecordBranch]) -> list[RecordBranch]:
        return self.combine_single(nt, label, body_models, body_var) + tail

class FunctionRule(Rule):

    def distill_single_body(self, nt : Context, pattern_attr : PatternAttr) -> Context:

        enviro = pattern_attr.enviro

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

        return Context('expr', nt.enviro.update(enviro), models, body_var)

    def combine_single(self, nt : Context, pattern_typ : Typ, body_models : list[Model], body_var : TVar) -> list[Branch]:
        """
        NOTE: this could learn constraints on the param variables,
        which could separate params into case patterns.
        should package the 
        """
        return [Branch(body_models, pattern_typ, body_var)]

    def distill_cons_body(self, nt : Context, pattern_attr : PatternAttr) -> Context:
        return self.distill_single_body(nt, pattern_attr)

    def distill_cons_tail(self, nt : Context, pattern_typ : Typ, body_var : TVar) -> Context:
        '''
        - the previous pattern should not influence what pattern occurs next
        - patterns may overlap
        '''
        return nt

    def combine_cons(self, nt : Context, pattern_typ : Typ, body_models : list[Model], body_var : TVar, tail : list[Branch]) -> list[Branch]:
        return self.combine_single(nt, pattern_typ, body_models, body_var) + tail


class KeychainRule(Rule):

    def combine_single(self, nt : Context, key : str) -> list[str]:
        return [key]

    def combine_cons(self, nt : Context, key : str, keys : list[str]) -> list[str]:
        return [key] + keys


class ArgchainRule(Rule):
    def distill_single_content(self, nt : Context) -> Context:
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
        return Context('expr', nt.enviro, models, content_var, False)

    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def combine_single(self, nt : Context, content_var : TVar) -> ArgchainAttr:
        return ArgchainAttr(nt.models, [content_var])

    def combine_cons(self, nt : Context, head_var : TVar, tail_vars : list[TVar]) -> ArgchainAttr:
        return ArgchainAttr(nt.models, [head_var] + tail_vars)

######

class PipelineRule(Rule):

    def distill_single_content(self, nt : Context) -> Context:
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
        return Context('expr', nt.enviro, models, content_var)


    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def distill_cons_tail(self, nt : Context, head_var : TVar) -> Context:
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
        return Context('pipeline', nt.enviro, models, tail_var)

    def combine_single(self, nt : Context, content_var : TVar) -> PipelineAttr:
        return PipelineAttr(nt.models, [content_var])

    def combine_cons(self, nt : Context, head_var : TVar, tail_var : list[TVar]) -> PipelineAttr:
        return PipelineAttr(nt.models, [head_var] + tail_var)


'''
start Pattern Rule
'''

class PatternRule(Rule):
    # def distill_tuple_head(self, nt : Context) -> Context:
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

    #     return Context('pattern', nt.enviro, models, typ_var) 

    # def distill_tuple_tail(self, nt : Context, head_typ : Typ) -> Context:
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
    #     return Context('pattern', nt.enviro, models, typ_var) 

    def combine_tuple(self, nt : Context, head_attr : PatternAttr, tail_attr : PatternAttr) -> PatternAttr:
        pattern = Inter(TField('head', head_attr.typ), TField('tail', tail_attr.typ))
        enviro = head_attr.enviro.update(tail_attr.enviro) 
        return PatternAttr(enviro, pattern)

'''
end PatternRule
'''

class BasePatternRule(Rule):

    def combine_var(self, nt : Context, id : str) -> PatternAttr:
        pattern = self.solver.fresh_type_var()
        # TODO
        enviro : PMap[str, Typ] = pmap({id : pattern})
        return PatternAttr(enviro, pattern)

    def combine_unit(self, nt : Context) -> PatternAttr:
        pattern = TUnit()
        return PatternAttr(m(), pattern)

    # def distill_tag_body(self, nt : Context, id : str) -> Context:
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
    #     return Context('pattern', nt.enviro, models, body_var)

    def combine_tag(self, nt : Context, label : str, body_attr : PatternAttr) -> PatternAttr:
        pattern = TTag(label, body_attr.typ)
        return PatternAttr(body_attr.enviro, pattern)
'''
end BasePatternRule
'''

class RecordPatternRule(Rule):

    # def distill_single_body(self, nt : Context, id : str) -> Context:
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
    #     return Context('pattern_record', nt.enviro, models, body_var) 

    def combine_single(self, nt : Context, label : str, body_attr : PatternAttr) -> PatternAttr:
        pattern = TField(label, body_attr.typ)
        return PatternAttr(body_attr.enviro, pattern)

    # def distill_cons_body(self, nt : Context, id : str) -> Context:
    #     return self.distill_cons_body(nt, id)

    # def distill_cons_tail(self, nt : Context, id : str, body_typ : Typ) -> Context:
    #     tail_var = self.solver.fresh_type_var()
    #     models = nt.models
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # models = self.evolve_models(nt, Inter(TField(id, body_typ), tail_var))
    #     return Context('pattern_record', nt.enviro, models, tail_var) 

    def combine_cons(self, nt : Context, label : str, body_attr : PatternAttr, tail_attr : PatternAttr) -> PatternAttr:
        pattern = Inter(TField(label, body_attr.typ), tail_attr.typ)
        enviro = body_attr.enviro.update(tail_attr.enviro)
        return PatternAttr(enviro, pattern)
