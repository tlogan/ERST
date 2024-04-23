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

'''
Prompt identifier lexemes
'''
ID = t(r"[a-zA-Z][_a-zA-Z]*")
TID = t(r"T[0-9]+")

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
    worlds : list[World]
    pattern : Typ 
    body : TVar

@dataclass(frozen=True, eq=True)
class RecordBranch:
    worlds : list[World]
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

def concretize_constraints(subtypings : Iterable[Subtyping]) -> str:
    return "".join([
        " ; " + concretize_typ(st.strong) + " <: " + concretize_typ(st.weak)
        for st in subtypings
    ])

def list_out_constraints(subtypings : Iterable[Subtyping], indent = 0) -> str:
    return "\n" + "".join([ 
        ((indent * 4) * " ") + "# " + concretize_typ(st.strong) + " <: " + concretize_typ(st.weak) + "\n\n"
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
            plate_entry = ([control.body], lambda body : f"(LFP {id} {body})")  
        elif isinstance(control, Top):
            plate_entry = ([], lambda: "TOP")  
        elif isinstance(control, Bot):
            plate_entry = ([], lambda: "BOT")  

        return plate_entry

    return util_system.make_stack_machine(make_plate_entry)(typ)

def concretize_reversed_aliasing(rev_aliasing : PMap[Typ, str]):
    return "".join([
        "alias " + id + " = " + (concretize_typ(t)) + "\n" 
        for t, id in rev_aliasing.items() 
    ]) 





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
    # worlds : list[World]
    typ : Typ    


@dataclass(frozen=True, eq=True)
class ArgchainAttr:
    worlds : list[World]
    args : list[TVar]

@dataclass(frozen=True, eq=True)
class PipelineAttr:
    worlds : list[World]
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
    worlds : list[World]
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
class World:
    constraints : PSet[Subtyping]
    freezer : PSet[str]
    relids : PSet[str]

def print_worlds(worlds : list[World], msg = ""):
    for i, world in enumerate(worlds):
        constraints_str = "".join([ 
            f"  ---{concretize_constraints(tuple([st]))}" + "\n"
            for st in world.constraints
        ])
        
        print(f"""
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DEBUG {msg} WORLD {i}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    world.freezer: {world.freezer}

    world.constraints: 
    {constraints_str}

    world.relids: {world.relids}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)

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
        augmented_branches += [Branch(branch.worlds, make_diff(branch.pattern, negs), branch.body)]
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
            result = (
                pset(
                    tuple([t.label]) + path_tail
                    for path_tail in paths_tail
                )
                if bool(paths_tail) else
                s(tuple([t.label]))
            )
            return result

        

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

def is_record_typ(t : Typ) -> bool:
    if isinstance(t, TField):
        return True
    elif isinstance(t, Inter):
        return is_record_typ(t.left) and is_record_typ(t.right)
    else:
        return False

def is_unrollable(key : Typ, rel : LeastFP) -> bool:
    if not is_record_typ(key):
        return True
    else:
        # TODO: unrollable iff there is a tag in key and correspond column has at least one tag? 
        choices = [
            choice
            for choice in linearize_unions(rel.body)
            if choice != Bot()
        ]
        paths = [
            path
            for choice in choices
            for path in list(extract_paths(choice))
        ]

        # nl = "\n"
        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG is_unrollable 
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # choices: {nl.join([(concretize_typ(choice)) for choice in choices])}
        # paths: {pset(paths)}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)
        result = False 
        for path in pset(paths):
            column_key = extract_field_plain(path, key)
            is_key_tag = isinstance(column_key, TTag)
            column_choices = [
                extract_field(path, rel.id, choice)
                for choice in choices
                if choice != Bot()
            ] 
            are_there_tags_in_choices = any(
                isinstance(cc, TTag) or
                (isinstance(cc, Exi) and isinstance(cc.body, TTag))
                for cc in column_choices
            )
            # print(f"""
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # DEBUG is_unrollable 
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # path: {path}
            # is_key_tag: {is_key_tag}

            # column_choices: {[concretize_typ(choice) for choice in column_choices]}
            # are_there_tags_in_choices: {are_there_tags_in_choices}
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # """)
            if (is_key_tag and are_there_tags_in_choices):
                return True 
            # endif

        return result
    # endif

def match_strong(world : World, strong : Typ) -> Optional[Typ]:
    for constraint in world.constraints:
        if strong == constraint.strong:
            return constraint.weak
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
    #     for st in world.constraints
    #     if is_relational_key(world, st.weak) and (id in extract_free_vars_from_typ(s(), st.weak))
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


def mapOp(f):
    def call(o):
        if o != None:
            return f(o)
        else:
            return None
    return call


# def interpret_strong_side(world : World, typ : Typ) -> tuple[Typ, PSet[Subtyping]]:
#     # NOTE: the unfrozen variables use strongest interpretation
#     # NOTE: the frozen variables use weakest interpretation 
#     if isinstance(typ, Imp):
#         antec, antec_constraints = interpret_weak_side(world, typ.antec)
#         consq, consq_constraints = interpret_strong_side(world, typ.consq)
#         return (Imp(antec, consq), antec_constraints.union(consq_constraints))
#     else:
#         fvs = extract_free_vars_from_typ(s(), typ)


#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_strong_for_id(world, id))]
#         #     if op != None
#         #     if (id in world.freezer)
#         #     for (strongest_once, cs_once) in [op]
#         #     for m in [World(world.constraints.difference(cs_once), world.freezer)]
#         #     # for m in [world]
#         #     for (t, cs_cont) in [interpret_weak_side(m, strongest_once)]
#         # ]


#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_strong_for_id(world, id))]
#         #     if op != None
#         #     for (strongest_once, cs_once) in [op]
#         #     if (id in world.freezer) or inhabitable(strongest_once) 
#         #     for m in [World(world.constraints.difference(cs_once), world.freezer)]
#         #     for (t, cs_cont) in [
#         #         interpret_weak_side(m, strongest_once)
#         #         if (id in world.freezer) else
#         #         interpret_strong_side(m, strongest_once)
#         #     ]
#         # ]

#         trips = [ 
#             (id, t, cs_once.union(cs_cont)) 
#             for id in fvs
#             for op in [
#                 mapOp(simplify_typ)(interpret_weak_for_id(world, id))
#                 if id in world.freezer else
#                 mapOp(simplify_typ)(interpret_strong_for_id(world, id))
#             ]
#             if op != None
#             for (strongest_once, cs_once) in [op]
#             if (id in world.freezer) or inhabitable(strongest_once) 
#             for m in [World(world.constraints.difference(cs_once), world.freezer)]
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
# # world.freezer: {world.freezer}
# # world.constraints: {concretize_constraints(tuple(world.constraints))}
# # typ: {concretize_typ(typ)}
# # interp _4: {mapOp(simplify_typ)(interpret_strong_for_id(world, '_4'))}
# # renaming: {renaming}
# # ~~~~~~~~~~~~~~~~~~~~~~~~
# #         """)

#         cs = pset(
#             c
#             for (id, strongest, cs) in trips
#             for c in cs
#         )
#         return (simplify_typ(sub_typ(renaming, typ)), cs)

# def interpret_weak_side(world : World, typ : Typ) -> tuple[Typ, PSet[Subtyping]]:
#     if isinstance(typ, Imp):
#         antec, antec_constraints = interpret_strong_side(world, typ.antec)
#         consq, consq_constraints = interpret_weak_side(world, typ.consq)
#         return (Imp(antec, consq), antec_constraints.union(consq_constraints))
#     else:
#         fvs = extract_free_vars_from_typ(s(), typ)

#         # trips = [ 
#         #     (id, t, cs_once.union(cs_cont)) 
#         #     for id in fvs
#         #     for op in [mapOp(simplify_typ)(interpret_weak_for_id(world, id))]
#         #     if op != None
#         #     # if (id in world.freezer)
#         #     # for (weakest_once, cs_once) in [op]
#         #     # for m in [World(world.constraints.difference(cs_once), world.freezer)]
#         #     # for (t, cs_cont) in [interpret_strong_side(m, weakest_once)]
#         #     for (weakest_once, cs_once) in [op]
#         #     if (id in world.freezer) or selective(weakest_once) 
#         #     for m in [World(world.constraints.difference(cs_once), world.freezer)]
#         #     for (t, cs_cont) in [
#         #         interpret_strong_side(m, weakest_once)
#         #         if (id in world.freezer) else
#         #         interpret_weak_side(m, weakest_once)
#         #     ]
#         # ]

#         trips = [ 
#             (id, t, cs_once.union(cs_cont)) 
#             for id in fvs
#             for op in [
#                 mapOp(simplify_typ)(interpret_strong_for_id(world, id))
#                 if (id in world.freezer) else
#                 mapOp(simplify_typ)(interpret_weak_for_id(world, id))
#             ]
#             if op != None
#             for (weakest_once, cs_once) in [op]
#             if (id in world.freezer) or selective(weakest_once) 
#             for m in [World(world.constraints.difference(cs_once), world.freezer)]
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
# # world.freezer: {world.freezer}
# # world.constraints: {concretize_constraints(tuple(world.constraints))}
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

def extract_constraints_with_id(world : World, id : str) -> PSet[Subtyping]:
    return pset(
        st
        for st in world.constraints
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

def is_variable_unassigned(world : World, id : str) -> bool:
    return (
        id not in extract_free_vars_from_constraints(s(), world.constraints)
    )

def extract_reachable_constraints(world : World, id : str, ids_seen : PSet[str], debug = False) -> tuple[PSet[Subtyping], PSet[str]]:
    if debug:
        print(f"DEBUG extract_reachable_constraints -- id: {id} -- seen: {len(ids_seen)}")
    constraints = extract_constraints_with_id(world, id) 
    ids_seen = ids_seen.add(id)
    ids = extract_free_vars_from_constraints(s(), constraints).difference(ids_seen)
    for id in ids:
        if id not in ids_seen:
            new_constraints, ids_seen = extract_reachable_constraints(world, id, ids_seen, debug)
            constraints = constraints.union(new_constraints) 

    return (constraints, ids_seen)

def extract_reachable_constraints_from_typ(world : World, typ : Typ, debug = False) -> PSet[Subtyping]:
    ids_base = extract_free_vars_from_typ(s(), typ)
    constraints = s()
    ids_seen = s()
    for id_base in ids_base: 
        if id not in ids_seen:
            new_constraints, ids_seen = extract_reachable_constraints(world, id_base, ids_seen, debug)
            constraints = constraints.union(new_constraints)
    return constraints

def package_typ(world : World, typ : Typ) -> Typ:
    constraints = extract_reachable_constraints_from_typ(world, typ)
    existential_constraints = pset( 
        st
        for st in constraints
        for strong_fvs in [extract_free_vars_from_typ(s(), st.strong)]
        for weak_fvs in [extract_free_vars_from_typ(s(), st.weak)]
        if bool(world.freezer.intersection(strong_fvs.union(weak_fvs))) 
    )

    reachable_ids = extract_free_vars_from_constraints(s(), constraints).union(extract_free_vars_from_typ(s(), typ))
    existential_bound_ids = tuple(world.freezer.intersection(reachable_ids))

    if not existential_bound_ids:
        assert not existential_constraints
        exi_typ = typ
    else:
        exi_typ = Exi(existential_bound_ids, tuple(existential_constraints), typ)

    universal_constraints = constraints.difference(existential_constraints)
    universal_bound_ids = tuple(reachable_ids.difference(world.freezer))

    if not universal_bound_ids:
        assert not universal_constraints
        univ_typ = exi_typ
    else:
        univ_typ = All(universal_bound_ids, tuple(universal_constraints), exi_typ)
    return simplify_typ(univ_typ)

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


def get_freezer_adjacent_learnable_ids(world : World) -> PSet[str]:
    return pset(
        st.weak.id
        for st in world.constraints
        if isinstance(st.strong, TVar) and st.strong.id in world.freezer  
        if isinstance(st.weak, TVar) and st.weak.id not in world.freezer  
    ) 

default_context = Context('expr', m(), [World(s(), s(), s())], TVar("G0"))

class Solver:
    _type_id : int
    _limit : int

    aliasing : PMap[str, Typ]
    reversed_aliasing : PMap[Typ, str]

    def __init__(self, aliasing : PMap[str, Typ]):
        self._type_id : int = 0 
        self._limit : int = 1000
        self.count = 0
        self.aliasing = aliasing
        self.reversed_aliasing : PMap[Typ, str] = pmap({
            t : id
            for id, t in self.aliasing.items()
        })

    def to_aliasing_constraints(self, constraints : Iterable[Subtyping], rev_aliasing : PMap[Typ, str]) -> tuple[PMap[Typ, str], tuple[Subtyping, ...]]:
        new_constraints = []
        for st in constraints:
            (rev_aliasing, strong) = self.to_aliasing_typ(st.strong, rev_aliasing)
            (rev_aliasing, weak) = self.to_aliasing_typ(st.weak, rev_aliasing)
            new_constraints.append(Subtyping(strong, weak))

        return tuple(new_constraints)


    def to_aliasing_typ(self, t : Typ, rev_aliasing : PMap[Typ, str]) -> tuple[PMap[Typ, str], Typ]:

        if False: 
            pass
        elif isinstance(t, TTag):
            (rev_aliasing, body_typ) = self.to_aliasing_typ(t.body, rev_aliasing)
            return (rev_aliasing, TTag(t.label, body_typ)) 
        elif isinstance(t, TField):
            (rev_aliasing, body_typ) = self.to_aliasing_typ(t.body, rev_aliasing)
            return (rev_aliasing, TField(t.label, body_typ)) 
        elif isinstance(t, Imp):
            (rev_aliasing, antec_typ) = self.to_aliasing_typ(t.antec, rev_aliasing)
            (rev_aliasing, consq_typ) = self.to_aliasing_typ(t.consq, rev_aliasing)
            return (rev_aliasing, Imp(antec_typ, consq_typ)) 
        elif isinstance(t, Unio):
            (rev_aliasing, left_typ) = self.to_aliasing_typ(t.left, rev_aliasing)
            (rev_aliasing, right_typ) = self.to_aliasing_typ(t.right, rev_aliasing)
            return (rev_aliasing, Unio(left_typ, right_typ)) 
        elif isinstance(t, Inter):
            (rev_aliasing, left_typ) = self.to_aliasing_typ(t.left, rev_aliasing)
            (rev_aliasing, right_typ) = self.to_aliasing_typ(t.right, rev_aliasing)
            return (rev_aliasing, Inter(left_typ, right_typ)) 
        elif isinstance(t, Diff):
            (rev_aliasing, context_typ) = self.to_aliasing_typ(t.context, rev_aliasing)
            (rev_aliasing, neg_typ) = self.to_aliasing_typ(t.negation, rev_aliasing)
            return (rev_aliasing, Diff(context_typ, neg_typ)) 
        elif isinstance(t, Exi):
            (rev_aliasing, constraints) = self.to_aliasing_constraints(t.constraints, rev_aliasing)
            (rev_aliasing, body_typ) = self.to_aliasing_typ(t.body, rev_aliasing)
            return (rev_aliasing, Exi(t.ids, constraints, body_typ))
        elif isinstance(t, All):
            (rev_aliasing, constraints) = self.to_aliasing_constraints(t.constraints, rev_aliasing)
            (rev_aliasing, body_typ) = self.to_aliasing_typ(t.body, rev_aliasing)
            return (rev_aliasing, All(t.ids, constraints, body_typ))
        elif isinstance(t, LeastFP):
            (rev_aliasing, body_typ) = self.to_aliasing_typ(t.body, rev_aliasing)
            new_typ = LeastFP(t.id, body_typ)
            if new_typ in rev_aliasing:
                return (rev_aliasing, TVar(rev_aliasing[new_typ]))
            else:
                new_id = self.fresh_type_id()
                rev_aliasing = rev_aliasing.set(new_typ, new_id)
                return (rev_aliasing, TVar(new_id))
        else:
            return (rev_aliasing, t)


    def interpret_weak_for_id(self, world : World, id : str) -> Optional[tuple[Typ, PSet[Subtyping]]]:
        '''
        for constraints X <: T, X <: U; find weakest type stronger than T, stronger than U
        which is T & U.
        NOTE: related to weakest precondition concept
        '''

        # if id in self.aliasing:
        #     return (self.aliasing[id], s())

        should_interpret = id not in world.relids
        # TODO: determine if the following is needed or too restrictive
        # all(
        #     id != fv 
        #     for st in world.constraints
        #     if is_relational_key(world, st.strong)
        #     for fv in extract_free_vars_from_typ(s(), st.strong)
        # )

    #     return result


        # TODO: determine if some restriction is actually necessary
        # all(
        #     (
        #         id not in extract_free_vars_from_typ(s(), st.strong) or
        #         st.strong == TVar(id) 
        #     )
        #     for st in world.constraints
        # )

    #     print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG interpret_weak_for_id 
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    # world.freezer: {world.freezer}
    # world.constraints: {concretize_constraints(tuple(world.constraints))}
    # id: {id}
    # has_weakest_interpretation: {has_weakest_interpretation}
    # ~~~~~~~~~~~~~~~~~~~~~~~~
    #     """)


        if should_interpret:
            constraints = [
                st
                for st in world.constraints
                if st.strong == TVar(id)
            ]
            typ_strong = Top() 
            for c in reversed(constraints):
                typ_strong = Inter(c.weak, typ_strong) 
            
            return (simplify_typ(typ_strong), pset(constraints))
        else:
            return None

    def interpret_strong_for_id(self, world : World, id : str) -> tuple[Typ, PSet[Subtyping]]:
        # if id in self.aliasing:
        #     return (self.aliasing[id], s())

        '''
        for constraints T <: X, U <: X; find strongest type weaker than T, weaker than U
        which is T | U.
        NOTE: related to strongest postcondition concept
        '''
        constraints = [
            st
            for st in world.constraints
            if st.weak == TVar(id) 
        ]
        typ_weak = Bot() 
        for c in reversed(constraints):
            typ_weak = Unio(c.strong, typ_weak) 
        return (simplify_typ(typ_weak), pset(constraints))

    def interpret_strong_for_ids(self, world : World, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:

        trips = [ 
            (id, strongest, cs)
            for id in ids
            for op in [self.interpret_strong_for_id(world, id)]
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

    def interpret_weak_for_ids(self, world : World, ids : list[str]) -> tuple[PMap[str, Typ], PSet[Subtyping]]:
        trips = [ 
            (id, weakest, cs)
            for id in ids
            for op in [self.interpret_weak_for_id(world, id)]
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



    def decode_typ(self, worlds : list[World], t : Typ) -> Typ:
        constraint_typs = [
            package_typ(world, t)
            for world in worlds
        ] 
        return make_unio(constraint_typs)

    # def decode_strong_side(self, worlds : list[World], t : Typ, arg : Typ = TUnit()) -> Typ:

    #     for m in worlds:
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
    #         for world in worlds
    #         for op in [interpret_with_polarity(True, world, t)]
    #         if op != None
    #         for (strongest, cs) in [op]
    #         # for m in [world]
    #         for m in [World(world.constraints.difference(cs), world.freezer)]
    #     ] 
    #     return make_unio(constraint_typs)

    # def decode_weak_side(self, worlds : list[World], t : Typ) -> Typ:

    # #     for m in worlds:
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
    #         for world in worlds
    #         for op in [interpret_with_polarity(world, t, False)]
    #         if op != None
    #         for (weakest, cs) in [op]
    #         # for m in [world]
    #         for m in [World(world.constraints.difference(cs), world.freezer)]
    #     ] 
    #     return make_unio(constraint_typs)

    def interpret_with_polarity(self, polarity : bool, world : World, typ : Typ, ignored_ids : PSet[str]) -> tuple[Typ, PSet[Subtyping]]:


        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG interpret_with_polarity:
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # typ: {concretize_typ(typ)}

        # world.freezer: {world.freezer}
        # world.constraints: {concretize_constraints(tuple(world.constraints))}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)

        def interpret_for_id(polarity : bool, id : str): 
            if polarity:
                return self.interpret_strong_for_id(world, id)
            else:
                return self.interpret_weak_for_id(world, id)

        if False:
            assert False
        elif isinstance(typ, TVar) and typ.id in ignored_ids:
            return (typ, s())
        elif isinstance(typ, TVar) and typ.id not in ignored_ids:
            id = typ.id
            op = ( 
                mapOp(simplify_typ)(interpret_for_id(not polarity, id))
                if (id in world.freezer) else
                mapOp(simplify_typ)(interpret_for_id(polarity, id))
            )

            if op != None:
                (interp_typ_once, cs_once) = op
                # print(f"""
                # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                # DEBUG: used_constraints: {concretize_constraints(cs_once)}
                # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                # """)
                if (id in world.freezer) or meaningful(polarity, interp_typ_once): 
                    m = World(world.constraints.difference(cs_once), world.freezer, world.relids)
                    (t, cs_cont) = self.interpret_with_polarity(polarity, m, interp_typ_once, ignored_ids)
                    return (simplify_typ(t), cs_once.union(cs_cont))
                else:
                    return (typ, s())
            else:
                return (typ, s())

        elif isinstance(typ, TUnit):
            return (typ, s())
        elif isinstance(typ, TTag):
            body = typ.body
            body, body_constraints = self.interpret_with_polarity(polarity, world, typ.body, ignored_ids)
            return (TTag(typ.label, body), body_constraints)
        elif isinstance(typ, TField):
            body = typ.body
            body, body_constraints = self.interpret_with_polarity(polarity, world, typ.body, ignored_ids)
            return (TField(typ.label, body), body_constraints)
        elif isinstance(typ, Unio):
            left, left_constraints = self.interpret_with_polarity(polarity, world, typ.left, ignored_ids)
            right, right_constraints = self.interpret_with_polarity(polarity, world, typ.right, ignored_ids)
            return (Unio(left, right), left_constraints.union(right_constraints))
        elif isinstance(typ, Inter):
            left, left_constraints = self.interpret_with_polarity(polarity, world, typ.left, ignored_ids)
            right, right_constraints = self.interpret_with_polarity(polarity, world, typ.right, ignored_ids)
            return (Inter(left, right), left_constraints.union(right_constraints))
        elif isinstance(typ, Diff):
            context, context_constraints = self.interpret_with_polarity(polarity, world, typ.context, ignored_ids)
            return (Diff(context, typ.negation), context_constraints)

        elif isinstance(typ, Imp):
            consq, consq_constraints = self.interpret_with_polarity(polarity, world, typ.consq, ignored_ids)
            world = World(world.constraints.difference(consq_constraints), world.freezer, world.relids)
            antec, antec_constraints = self.interpret_with_polarity(not polarity, world, typ.antec, ignored_ids.union(extract_free_vars_from_typ(ignored_ids, consq)))
            return (Imp(antec, consq), antec_constraints.union(consq_constraints))

        elif isinstance(typ, Exi):
            return (typ, s())
            # TODO: uncomment below: gathering used constraints of negated side first (strong side of <: )
            # pos_constraints = s() 
            # weak_constraint_pairs = []
            # for st in typ.constraints:
            #     weak, weak_constraints = interpret_with_polarity(not polarity, world, st.weak, ignored_ids)
            #     pos_constraints = pos_constraints.union(weak_constraints)
            #     weak_constraint_pairs.append((weak, st))
            #     ignored_ids = ignored_ids.union(extract_free_vars_from_typ(ignored_ids, weak))

            # world = World(world.constraints.difference(pos_constraints), world.freezer)

            # neg_constraints = s() 
            # new_constraints = [] 
            # for (weak, st) in weak_constraint_pairs:
            #     strong, strong_constraints = interpret_with_polarity(polarity, world, st.strong, ignored_ids)
            #     pos_constraints = pos_constraints.union(strong_constraints)
            #     new_constraints.append(Subtyping(strong, weak))


            # body, body_constraints = interpret_with_polarity(polarity, world, typ.body, ignored_ids)
            # ignored_ids = ignored_ids.union(typ.ids)
            # used_constraints = body_constraints.union(pos_constraints).union(neg_constraints)
            # return (Exi(typ.ids, tuple(new_constraints), body), used_constraints)

        elif isinstance(typ, All):
            return (typ, s())
            # TODO: copy Exi rule
        elif isinstance(typ, LeastFP):
            ignored_ids = ignored_ids.add(typ.id)
            body, body_constraints = self.interpret_with_polarity(polarity, world, typ.body, ignored_ids)
            return (LeastFP(typ.id, body), body_constraints)
        elif isinstance(typ, Top):
            return (typ, s())
        elif isinstance(typ, Bot):
            return (typ, s())
        else:
            assert False



    def decode_with_polarity(self, polarity : bool, worlds : list[World], t : Typ) -> Typ:

        constraint_typs = [
            package_typ(m, tt)
            for world in worlds
            for op in [self.interpret_with_polarity(polarity, world, t, s())]
            if op != None
            for (tt, cs) in [op]
            # for m in [world]
            for m in [World(world.constraints.difference(cs), world.freezer, world.relids)]
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


    def fresh_type_id(self) -> str:
        print(f"self id: {id(self)}")
        print(f"debug fresh before: {self._type_id}")
        self._type_id = self._type_id + 1
        print(f"debug fresh after: {self._type_id}")
        return (f"G{self._type_id}")

    def fresh_type_var(self) -> TVar:
        id = self.fresh_type_id()
        return TVar(f"G{self._type_id}")

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


    def solve(self, world : World, strong : Typ, weak : Typ) -> list[World]:
        self.count += 1
        if self.count > self._limit:
            return []

#         print(f'''
# || DEBUG SOLVE
# =================
# || self.aliasing :::
# || :::::::: {self.aliasing}
# ||
# || world.freezer::: 
# || :::::::: {world.freezer}
# ||
# || world.constraints::: 
#     {list_out_constraints(world.constraints, 1)}
# ||
# || |- {concretize_typ(strong)} 
# || <: {concretize_typ(weak)}
# ||
# || count: {self.count}
#         ''')

        if alpha_equiv(strong, weak): 
            return [world] 

        if False:
            return [] 
        #######################################

        #######################################
        #### Dealiasing ####
        #######################################
        elif isinstance(weak, TVar) and weak.id in self.aliasing: 
            return self.solve(world, strong, self.aliasing[weak.id])

        elif isinstance(strong, TVar) and strong.id in self.aliasing: 
            return self.solve(world, self.aliasing[strong.id], weak)
        #######################################

        elif isinstance(strong, Exi):
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            worlds = [world]
            for constraint in strong_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]  

            # print(f"""
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~
            # DEBUG strong, EXI
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~
            # renamed_ids: {renamed_ids}
            # new_ids: {[n for n in new_ids]}
            # new_ids: {[n for n in new_ids]}
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~
            # """)

            return [
                m2
                for m0 in worlds
                for m1 in [World(m0.constraints, m0.freezer.union(renamed_ids), m0.relids)]
                for m2 in self.solve(m1, strong_body, weak)
            ]

        elif isinstance(weak, All):
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            worlds = [world]
            for constraint in weak_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]  

            return [
                m2
                for m0 in worlds
                for m1 in [World(m0.constraints, m0.freezer.union(renamed_ids), m0.relids)]
                for m2 in self.solve(m1, strong, weak_body)
            ]







        #######################################
        #### Learnable variable rules: ####
        #######################################

        elif isinstance(weak, TVar) and weak.id in world.freezer: 
            interp = self.interpret_strong_for_id(world, weak.id)
            strongest_weak = interp[0]
            return self.solve(world, strong, strongest_weak)

        elif isinstance(strong, TVar) and strong.id not in world.freezer: 
            interp = self.interpret_strong_for_id(world, strong.id)
            # print(f"""
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # DEBUG strong, TVar learnable  
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # strong: {concretize_typ(strong)}
            # weak: {concretize_typ(weak)}
            # world.relids: {world.relids}
            # world.freezer: {world.freezer}
            # world.constraints: {concretize_constraints(tuple(world.constraints))}
            # interp: {mapOp(lambda x : concretize_typ(x[0]))(interp)}
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # """)
            if not inhabitable(interp[0]):
                return [World(
                    world.constraints.add(Subtyping(strong, weak)),
                    world.freezer, world.relids
                )]

            elif isinstance(interp[0], TVar) and (interp[0].id in world.freezer):
                # NOTE: prevent over interprenting into frozen to allow learning new type values 
                return [World(
                    world.constraints.add(Subtyping(strong, weak)),
                    world.freezer, world.relids
                )]
            else:
                # NOTE: if there is a frozen <: learnable constraint then they could simply jump back and forth forever
                strongest = interp[0]
                return [
                    World(
                        world.constraints.add(Subtyping(strong, weak)),
                        world.freezer, world.relids
                    )
                    for world in self.solve(world, strongest, weak)
                ]


        elif isinstance(weak, TVar) and weak.id not in world.freezer: 
            interp = self.interpret_weak_for_id(world, weak.id)
            if interp == None:
                # TODO: add safety check; e.g. that weak is TOP or weaker than strong 
                return [World(
                    world.constraints.add(Subtyping(strong, weak)),
                    world.freezer, world.relids
                )]
            elif not selective(interp[0]):
                return [World(
                    world.constraints.add(Subtyping(strong, weak)),
                    world.freezer, world.relids
                )]
            else:
                weakest = interp[0]
                return [
                    World(
                        world.constraints.add(Subtyping(strong, weak)),
                        world.freezer, world.relids
                    )
                    for world in self.solve(world, strong, weakest)
                ]


        #########################################
        #### learnable bound variables (EXI) ####
        #########################################
        elif isinstance(weak, Exi): 
            renaming = self.make_renaming(weak.ids)
            weak_constraints = sub_constraints(renaming, weak.constraints)
            weak_body = sub_typ(renaming, weak.body)
            worlds = self.solve(world, strong, weak_body) 
            for constraint in weak_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]
            return worlds


        #########################################
        #### learnable bound variables (ALL) ####
        #########################################
        # NOTE: Variable instantiation happens after variable updates in order to maintain generalization
        # TODO: why is this necessary? for which example?
        elif isinstance(strong, All): 
            renaming = self.make_renaming(strong.ids)
            strong_constraints = sub_constraints(renaming, strong.constraints)
            strong_body = sub_typ(renaming, strong.body)
            worlds = self.solve(world, strong_body, weak) 
            for constraint in strong_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.strong, constraint.weak)
                ]
            return worlds


        #######################################
        #### World rules: ####
        #######################################


        elif isinstance(strong, LeastFP):
            if alpha_equiv(strong, weak):
                return [world]
            else:
                worlds = []

                strong_factored = factor_least(strong)
                worlds = self.solve(world, strong_factored, weak)

                if worlds == []:
                    '''
                    NOTE: k-induction
                    use the pattern on LHS to dictate number of unrollings needed on RHS 
                    simply need to sub RHS into LHS's self-referencing variable
                    '''
                    '''
                    sub in induction hypothesis to world:
                    '''
                    renaming : PMap[str, Typ] = pmap({strong.id : weak})
                    strong_body = sub_typ(renaming, strong.body)
                    return self.solve(world, strong_body, weak)
                    
                else:
                    return worlds 

        elif isinstance(weak, Imp) and isinstance(weak.antec, Unio):
            return self.solve(world, strong, Inter(
                Imp(weak.antec.left, weak.consq), 
                Imp(weak.antec.right, weak.consq)
            ))

        elif isinstance(weak, Imp) and isinstance(weak.consq, Inter):
            return self.solve(world, strong, Inter(
                Imp(weak.antec, weak.consq.left), 
                Imp(weak.antec, weak.consq.right)
            ))

        elif isinstance(weak, TField) and isinstance(weak.body, Inter):
            return [
                m1
                for m0 in self.solve(world, strong, TField(weak.label, weak.body.left))
                for m1 in self.solve(m0, strong, TField(weak.label, weak.body.right))
            ]

        elif isinstance(strong, Unio):
            return [
                m1
                for m0 in self.solve(world, strong.left, weak)
                for m1 in self.solve(m0, strong.right, weak)
            ]

        elif isinstance(weak, Inter):
            return [
                m1 
                for m0 in self.solve(world, strong, weak.left)
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
                context_worlds = self.solve(world, strong, weak.context)
    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG weak, Diff 
    # ~~~~~~~~~~~~~~~~~~~~
    # len(context_worlds): {len(context_worlds)}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)
                return [
                    m
                    for m in context_worlds 
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
            return [world] 

        elif isinstance(strong, Bot): 
            return [world] 


        elif isinstance(weak, LeastFP): 
            # ids = extract_free_vars_from_typ(s(), strong)
            # sub_map = pmap({
            #     id : interp 
            #     for id in ids
            #     for pair in [
            #         mapOp(simplify_typ)(interpret_weak_for_id(world, id))
            #         if id in world.freezer else
            #         mapOp(simplify_typ)(interpret_strong_for_id(world, id))
            #     ]
            #     if pair 
            #     for interp in [pair[0]]
            #     if inhabitable(interp) 
            # })
            
            # reduced_strong = sub_typ(sub_map, strong)

            # NOTE: don't interpret learnable variables as frozen variables
            # ignored_ids = get_freezer_adjacent_learnable_ids(world)

            ignored_ids = s()
            reduced_strong, used_constraints = self.interpret_with_polarity(True, world, strong, ignored_ids)
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP
# ~~~~~~~~~~~~~~~~~~~~~
# world.relids: {world.relids}
# world.freezer: {world.freezer}
# world.constraints: {concretize_constraints(tuple(world.constraints))}

# strong: {concretize_typ(strong)}
# reduced_strong: {concretize_typ(reduced_strong)}
# weak: {concretize_typ(weak)}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            world = World(world.constraints.difference(used_constraints), world.freezer, world.relids)
            if strong != reduced_strong:
                return self.solve(world, reduced_strong, weak)
            elif is_unrollable(strong, weak):
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({weak.id : weak})
                weak_body = sub_typ(renaming, weak.body)

#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP --- Unrolling
# ~~~~~~~~~~~~~~~~~~~~~
# strong: {concretize_typ(strong)}
# weak_body: {concretize_typ(weak_body)}
# ~~~~~~~~~~~~~~~~~~~~~
#                 """)
                worlds = self.solve(world, strong, weak_body)

#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP --- Unrolling Result
# ~~~~~~~~~~~~~~~~~~~~~
# status: {'FAILURE!!!!!!!!' if len(worlds) == 0 else len(worlds)}

# strong: {concretize_typ(strong)}
# weak_body: {concretize_typ(weak_body)}

# world.freezer: {world.freezer} 
# world.constraints: 
# {list_out_constraints(world.constraints)}

# world.freezer: {world.relids} 
# ~~~~~~~~~~~~~~~~~~~~~
#                 """)

                return worlds
            else:
#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP --- CAN'T UNROLL 
# ~~~~~~~~~~~~~~~~~~~~~
#                 """)
                strong_cache = match_strong(world, strong)

                if strong_cache:
                    # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
                    return self.solve(world, strong_cache, weak)
                else:
                    fvs = extract_free_vars_from_typ(s(), strong)  
#                     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG weak, LeastFP --- Adding relids 
# ~~~~~~~~~~~~~~~~~~~~~
# fvs: {fvs}
# ~~~~~~~~~~~~~~~~~~~~~
#                     """)
                    if (
                        (all((fv not in world.freezer) for fv in fvs)) and 
                        self.is_relation_constraint_wellformed(world, strong, weak)
                    ):
                        return [World(
                            world.constraints.add(Subtyping(strong, weak)),
                            world.freezer, world.relids.union(fvs)
                        )]
                    else:
                        return []

        elif isinstance(strong, Diff):
            if diff_well_formed(strong):
                '''
                A \\ B <: T === A <: T | B  
                '''
                return self.solve(world, strong.context, Unio(weak, strong.negation))
            else:
                return []


        elif isinstance(weak, Unio): 
            return self.solve(world, strong, weak.left) + self.solve(world, strong, weak.right)

        elif isinstance(strong, Inter): 
            return self.solve(world, strong.left, weak) + self.solve(world, strong.right, weak)


        #######################################
        #### Unification rules: ####
        #######################################

        elif isinstance(strong, TUnit) and isinstance(weak, TUnit): 
            return [world] 

        elif isinstance(strong, TTag) and isinstance(weak, TTag): 
            if strong.label == weak.label:
                return self.solve(world, strong.body, weak.body) 
            else:
                return [] 

        elif isinstance(strong, TField) and isinstance(weak, TField): 
            if strong.label == weak.label:
                return self.solve(world, strong.body, weak.body) 
            else:
                return [] 

        elif isinstance(strong, Imp) and isinstance(weak, Imp): 
            worlds = [
                m1
                for m0 in self.solve(world, weak.antec, strong.antec) 
                for m1 in self.solve(m0, strong.consq, weak.consq) 
            ]
            return worlds

        #######################################
        #### Frozen variable rules: ####
        #######################################

        elif (
            isinstance(strong, TVar) and strong.id in world.freezer and
            isinstance(weak, TVar) and weak.id not in world.freezer
        ):
            # NOTE: no interpretation; simply add constraint
            return [World(
                world.constraints.add(Subtyping(strong, weak)),
                world.freezer, world.relids
            )]

        # NOTE: must interpret frozen/rigid/skolem variables before learning new constraints
        # but if uninterpretable and other type is learnable, then simply add it: 
        elif isinstance(strong, TVar) and strong.id in world.freezer: 


            interp = self.interpret_weak_for_id(world, strong.id)
            # print(f"""
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # DEBUG strong, TVar frozen  
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # strong: {concretize_typ(strong)}
            # weak: {concretize_typ(weak)}
            # has interp: {interp != None}
            # world.relids: {world.relids}
            # ~~~~~~~~~~~~~~~~~~~~~~~~~~~
            # """)
            if interp != None:
                weakest_strong = interp[0]
                return self.solve(world, weakest_strong, weak)
            elif isinstance(weak, TVar) and weak.id not in world.freezer:
                # TODO: consider safety check
                #     # safe = bool(self.solve(world, Top(), weak))
                #     safe = True
                #     if safe:
                #         return [World(
                #             world.constraints.add(Subtyping(strong, weak)),
                #             world.freezer, world.relids
                #         )]
                #     else:
                #         return []
                return [World(
                    world.constraints.add(Subtyping(strong, weak)),
                    world.freezer, world.relids
                )]
            else:
                print(f"""
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                !!!!!!!!!!!!!!! DEBUG strong, TVar frozen FAILURE  !!!!!!!!!!!
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                strong: {concretize_typ(strong)}
                weak: {concretize_typ(weak)}
                has interp: {interp != None}
                world.relids: {world.relids}
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
                """)
                return []
            #end if-else
        #end if-else
        return []



    '''
    end solve
    '''

    def is_relation_constraint_wellformed(self, world : World, strong : Typ, weak : LeastFP) -> bool:
        factored = factor_least(weak)
        worlds = self.solve(world, strong, factored)  
        return bool(worlds)

    def solve_composition(self, strong : Typ, weak : Typ) -> List[World]: 
        self.count = 0
        world = World(s(), s(), s())
        return self.solve(world, strong, weak)
    '''
    end solve_composition
    '''

'''
end Solver
'''



class Rule:
    def __init__(self, solver : Solver):
        self.solver = solver

    def evolve_worlds(self, nt : Context, t : Typ) -> list[World]:
#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG evolve_worlds
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# nt.enviro: {nt.enviro}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)
        return [
            m1
            for m0 in nt.worlds
            for m1 in self.solver.solve(m0, 
                t, 
                nt.typ_var
            )
        ]

class BaseRule(Rule):

    def combine_var(self, nt : Context, id : str) -> list[World]:
        return self.evolve_worlds(nt, nt.enviro[id])

    def combine_assoc(self, nt : Context, argchain : list[TVar]) -> list[World]:
        if len(argchain) == 1:
            return self.evolve_worlds(nt, argchain[0])
        else:
            applicator = argchain[0]
            arguments = argchain[1:]
            result = ExprRule(self.solver).combine_application(nt, applicator, arguments) 
            return result

    def combine_unit(self, nt : Context) -> list[World]:
        return self.evolve_worlds(nt, TUnit())

    def distill_tag_body(self, nt : Context, label : str) -> Context:
        body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = self.evolve_worlds(nt, TTag(label, body_var))
        return Context('expr', nt.enviro, worlds, body_var)

    def combine_tag(self, nt : Context, label : str, body : TVar) -> list[World]:
        # TODO: remove existential check now that the types are simply variables
        # '''
        # move existential outside
        # '''
        # if isinstance(body, Exi):
        #     return self.evolve_worlds(nt, Exi(body.ids, body.constraints, TTag(label, body.body)))
        # else:
        # TODO: note that this constraint is redundant with constraint in distill rule
        # - consider removing redundancy
        return self.evolve_worlds(nt, TTag(label, body))

    def combine_record(self, nt : Context, branches : list[RecordBranch]) -> list[World]:
        result = Top() 
        for branch in reversed(branches): 
            for branch_world in reversed(branch.worlds):
                new_world = branch_world

                (body_typ, body_used_constraints) = self.solver.interpret_with_polarity(True, new_world, branch.body, s())
                new_world = World(new_world.constraints.difference(body_used_constraints), new_world.freezer, new_world.relids)

                field = TField(branch.label, body_typ)
                constraints = tuple(extract_reachable_constraints_from_typ(new_world, field))
                if constraints:
                    # TODO: update outer world instead of nesting constraints; since there's no generalization
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

        return self.evolve_worlds(nt, simplify_typ(result))

    def combine_function(self, nt : Context, branches : list[Branch]) -> list[World]:
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
            for branch_world in reversed(branch.worlds):
                '''
                interpret, extrude, and generalize
                '''
                new_world = branch_world

                (return_typ, return_used_constraints) = self.solver.interpret_with_polarity(True, new_world, branch.body, s())
                new_world = World(new_world.constraints.difference(return_used_constraints), new_world.freezer, new_world.relids)
                (param_typ, param_used_constraints) = self.solver.interpret_with_polarity(False, new_world, branch.pattern, extract_free_vars_from_typ(s(), return_typ))
                new_world = World(new_world.constraints.difference(param_used_constraints), new_world.freezer, new_world.relids)
                imp = Imp(param_typ, return_typ)
                constrained_branches.append((new_world, imp))
            '''
            end for 
            '''
        '''
        end for 
        '''
        if len(constrained_branches) == 1:
            new_world, imp = constrained_branches[0]
            return self.solver.solve(new_world, simplify_typ(imp), nt.typ_var)
        else:
            result = Top()
            for new_world, imp in constrained_branches:
                generalized_case = imp
                ######## DEBUG: without generalization #############
                constraints = tuple(extract_reachable_constraints_from_typ(new_world, imp))
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
                #     sub_constraints(sub_map, tuple(extract_reachable_constraints_from_typ(new_world, imp)))
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
            worlds = self.evolve_worlds(nt, simplify_typ(result))
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function iteration
# ~~~~~~~~~~~~~~~~~~~~~
# choice[0]: {concretize_typ(choice[0])}
# choice[1]: {concretize_typ(choice[1])}

# param_typ: {concretize_typ(param_typ)}
# return_typ: {concretize_typ(return_typ)}

# nt.env: {nt.enviro}
# world.freezer: {world.freezer}
# world.constraints: {concretize_constraints(tuple(world.constraints))}

# generalized_case: {concretize_typ(generalized_case)}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            return worlds
        '''
        end if/else
        '''
    '''
    end def
    '''

class ExprRule(Rule):

    def distill_tuple_head(self, nt : Context) -> Context:
        head_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = self.evolve_worlds(nt, Inter(TField('head', head_var), TField('tail', Bot())))
        return Context('expr', nt.enviro, worlds, head_var) 

    def distill_tuple_tail(self, nt : Context, head_var : TVar) -> Context:
        tail_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = self.evolve_worlds(nt,Inter(TField('head', head_var), TField('tail', tail_var)))
        return Context('expr', nt.enviro, worlds, tail_var) 

    def combine_tuple(self, nt : Context, head_var : TVar, tail_var : TVar) -> list[World]:
        return self.evolve_worlds(nt, Inter(TField('head', head_var), TField('tail', tail_var)))

    def distill_ite_condition(self, nt : Context) -> Context:
        condition_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var,
        #         Unio(TTag('false', TUnit()), TTag('true', TUnit()))
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, condition_var)

    def distill_ite_true_branch(self, nt : Context, condition_var : TVar) -> Context:
        '''
        Find refined prescription Q in the :true? case given (condition : A), and unrefined prescription B.
        (:true? @ -> Q) <: (A -> B) 
        '''
        true_body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         Imp(TTag('true', TUnit()), true_body_var),
        #         Imp(true_body_var, nt.typ_var)
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, true_body_var) 

    def distill_ite_false_branch(self, nt : Context, condition_var : TVar, true_body_var : TVar) -> Context:
        '''
        Find refined prescription Q in the :false? case given (condition : A), and unrefined prescription B.
        (:false? @ -> Q) <: (A -> B) 
        '''
        false_body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         Imp(TTag('false', TUnit()), false_body_var),
        #         Imp(condition_var, nt.typ_var)
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, false_body_var) 

    def combine_ite(self, nt : Context, condition_var : TVar, 
                true_body_worlds: list[World], true_body_var : TVar, 
                false_body_worlds: list[World], false_body_var : TVar
    ) -> list[World]: 
        branches = [
            Branch(true_body_worlds, TTag('true', TUnit()), true_body_var), 
            Branch(false_body_worlds, TTag('false', TUnit()), false_body_var)
        ]
        cator_var = self.solver.fresh_type_var()
        function_nt = replace(nt, typ_var = cator_var)
        function_worlds = BaseRule(self.solver).combine_function(function_nt, branches)
        nt = replace(nt, worlds = function_worlds)
        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG ite len(function_worlds): {len(function_worlds)}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)
        arguments = [condition_var]
        return self.combine_application(nt, cator_var, arguments) 

    def distill_projection_rator(self, nt : Context) -> Context:
        # the type of the record being projected from
        rator_var = self.solver.fresh_type_var()
        return Context('expr', nt.enviro, nt.worlds, rator_var)

    def distill_projection_keychain(self, nt : Context, rator_var : TVar) -> Context: 
        keychain_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         keychain_var,
        #         rator_var 
        #     )
        # ]
        return Context('keychain', nt.enviro, worlds, keychain_var)


    def combine_projection(self, nt : Context, record_var : TVar, keys : list[str]) -> list[World]: 
        worlds = nt.worlds
        for key in keys:
            result_var = self.solver.fresh_type_var()
            worlds = [
                m1
                for m0 in worlds
                for m1 in self.solver.solve(m0, record_var, TField(key, result_var))
            ]
            record_var = result_var

        worlds = [
            m1
            for m0 in worlds
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]
        return worlds 

    #########

    def distill_application_cator(self, nt : Context) -> Context: 
        cator_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         cator_var,
        #         Imp(Bot(), Top()) 
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, cator_var)

    def distill_application_argchain(self, nt : Context, cator_var : TVar) -> Context: 
        next_cator_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         next_cator_var,
        #         cator_var
        #     )
        # ]
        return Context('argchain', nt.enviro, worlds, next_cator_var, True)

    def combine_application(self, nt : Context, cator_var : TVar, arg_vars : list[TVar]) -> list[World]: 

        # print(f"""
        # ~~~~~~~~~~~~~~
        # DEBUG application init
        # ~~~~~~~~~~~~~~
        # len(nt.enviro): {nt.enviro}
        # len(nt.worlds): {len(nt.worlds)}
        # ~~~~~~~~~~~~~~
        # """)

        worlds = nt.worlds 
        for arg_var in arg_vars:
            result_var = self.solver.fresh_type_var()
            new_worlds = []
            for world in worlds:
                # NOTE: interpretation to keep types and constraints compact 
                cator_typ, cator_used_constraints = self.solver.interpret_with_polarity(True, world, cator_var, s())
                ignored_ids = get_freezer_adjacent_learnable_ids(world)
                arg_typ, arg_used_constraints = self.solver.interpret_with_polarity(True, world, arg_var, ignored_ids)
                # arg_typ, arg_used_constraints = (arg_var, s())

                # print(f"""
                # ~~~~~~~~~~~~~~
                # DEBUG application
                # ~~~~~~~~~~~~~~
                # world.freezer: {tuple(world.freezer)}

                # world.constraints: 
                # {list_out_constraints(world.constraints, 4)}

                # cator_var: {concretize_typ(cator_var)}
                # cator_typ: {concretize_typ(cator_typ)}

                # arg_var: {arg_var.id}
                # arg_typ: {concretize_typ(arg_typ)}

                # result_var: {result_var.id}
                # ~~~~~~~~~~~~~~
                # """)

                world = World(world.constraints.difference(cator_used_constraints).difference(arg_used_constraints), world.freezer, world.relids)
                new_worlds.extend(self.solver.solve(world, cator_typ, Imp(arg_typ, result_var)))
            worlds = new_worlds

            # TODO: remove version without interpretation
            # worlds = [
            #     m1
            #     for m0 in worlds
            #     for m1 in self.solver.solve(m0, cator_var, Imp(arg_var, result_var))
            # ] 
            ###########################
            cator_var = result_var

        worlds = [
            m1
            for m0 in worlds
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]

        ########################
        # print(f"""
        # ~~~~~~~~~~~~~~
        # DEBUG application results 
        # len(worlds): {len(worlds)}
        # ~~~~~~~~~~~~~~
        # """)

        # for world in worlds:
        #     print(f"""
        #     ~~~~~~~~~~~~~~
        #     DEBUG application results
        #     ~~~~~~~~~~~~~~
        #     world.freezer: {tuple(world.freezer)}

        #     world.constraints: 
        #     {list_out_constraints(world.constraints, 3)}

        #     cator_var: {cator_var}
        #     arg_var: {arg_var}

        #     cator_typ: {concretize_typ(cator_typ)}
        #     arg_typ: {concretize_typ(arg_typ)}
        #     ~~~~~~~~~~~~~~
        #     """)
        ########################

        return worlds

    #########
    def distill_funnel_arg(self, nt : Context) -> Context: 
        arg_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        return Context('expr', nt.enviro, worlds, arg_var)

    def distill_funnel_pipeline(self, nt : Context, arg_var : TVar) -> Context: 
        typ_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         typ_var,
        #         arg_var
        #     )
        # ]
        return Context('pipeline', nt.enviro, worlds, typ_var)

    def combine_funnel(self, nt : Context, arg_var : TVar, cator_vars : list[TVar]) -> list[World]: 
        worlds = nt.worlds
        for cator_var in cator_vars:
            # print(f"""
            # ~~~~~~~~
            # DEBUG funnel
            # cator_var: {cator_var}
            # ~~~~~~~~
            # """)
            result_var = self.solver.fresh_type_var() 
            app_nt = replace(nt, worlds = worlds, typ_var = result_var) 
            worlds = self.combine_application(app_nt, cator_var, [arg_var])
            arg_var = result_var 

        # NOTE: add final constraint to connect to expected type var: the result_typ <: nt.typ_var
        worlds = [
            m1
            for m0 in worlds
            for m1 in self.solver.solve(m0, result_var, nt.typ_var)
        ]
        return worlds 

    def distill_fix_body(self, nt : Context) -> Context:
        body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        return Context('expr', nt.enviro, worlds, body_var)

    def combine_fix(self, nt : Context, body_var : TVar) -> list[World]:
        """
        from: 
        SELF -> (nil -> zero) & (cons A\\nil -> succ B) ;  SELF <: A -> B SELF(A) <: B
        --------------- OR -----------------------
        ALL[X . X <: nil | cons A] X -> EXI[Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] Y
        --------------- OR -----------------------
        ALL[X Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] X -> EXI[Z ; Z <: Y] Z
        """

        self_typ = self.solver.fresh_type_var()
        in_typ = self.solver.fresh_type_var()
        out_typ = self.solver.fresh_type_var()

        IH_typ = self.solver.fresh_type_var()

        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG combine_fix
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # nt: {nt}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)

        for outer_world in nt.worlds:

            '''
            Constructive a least fixed point type over union from the inner worlds
            '''
            inner_worlds = self.solver.solve(outer_world, body_var, Imp(self_typ, Imp(in_typ, out_typ)))

            induc_body = Bot()
            param_body = Bot()

            ########## DEBUG ##########
            # print_worlds(inner_worlds, ":: combine_fix :: inner ::")
            ###########################
            for i, inner_world in enumerate(reversed(inner_worlds)):

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_fix (initial inner_world)
    # ~~~~~~~~~~~~~~~~~~~~~
    # inner_world.freezer: {inner_world.freezer}
    # inner_world.constraints: {concretize_constraints(tuple(inner_world.constraints))}
    # ======================
    # self_typ: {self_typ.id}
    # body_var: {concretize_typ(body_var)}

    # IH_typ: {IH_typ.id}
    # ======================
    #             """)

                left_interp = self.solver.interpret_with_polarity(False, inner_world, in_typ, s())
                (left_typ, left_used_constraints) = (left_interp if left_interp else (in_typ, s()))

                inner_world = World(inner_world.constraints.difference(left_used_constraints), inner_world.freezer, inner_world.relids)
                right_interp = self.solver.interpret_with_polarity(True, inner_world, out_typ, s())
                (right_typ, right_used_constraints) = (right_interp if right_interp else (out_typ, s())) 

                inner_world = World(inner_world.constraints.difference(right_used_constraints), inner_world.freezer, inner_world.relids)

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
    # inner_world.freezer: {inner_world.freezer}
    # inner_world.constraints: {concretize_constraints(tuple(inner_world.constraints))}
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)

                left_bound_ids = tuple(extract_free_vars_from_typ(s(), left_typ))
                right_bound_ids = tuple(extract_free_vars_from_typ(s(), right_typ))
                bound_ids = left_bound_ids + right_bound_ids
                rel_pattern = make_pair_typ(left_typ, right_typ)
                #########################################
                self_interp = self.solver.interpret_with_polarity(False, inner_world, self_typ, s())

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
                    IH_left_constraints = s(Subtyping(self_left, IH_typ))
                else:
                    self_used_constraints = s()

                    IH_rel_constraints = s()
                    IH_left_constraints = s()
                #end if


                inner_world = World(inner_world.constraints.difference(self_used_constraints), inner_world.freezer, inner_world.relids)

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # $$$$$$$ OOGA START 
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)

                reachable_constraints = tuple(
                    st
                    for st in extract_reachable_constraints_from_typ(inner_world, rel_pattern)
                    if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
                )

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # $$$$$$$ OOGA END 
    # ~~~~~~~~~~~~~~~~~~~~~
    #             """)


                rel_constraints = IH_rel_constraints.union(reachable_constraints)
                left_constraints = IH_left_constraints.union(reachable_constraints)

                # TODO: what if there are existing frozen variables in inner_world?
                # - does inner world invariantly lack frozen variables: e.g. (assert not bool(inner_world.freezer))?
                if bool(bound_ids):
                    constrained_rel = Exi(bound_ids, tuple(rel_constraints), rel_pattern)
                else:
                    assert not bool(rel_constraints)
                    constrained_rel = rel_pattern

                # TODO: remove old commented code
                # rel_world = World(pset(rel_constraints), pset(bound_ids), inner_world.relids)
                # package_typ(rel_world, rel_pattern)

                if bool(left_bound_ids):
                    constrained_left = Exi(left_bound_ids, tuple(left_constraints), left_typ)
                else:
                    assert not bool(left_constraints)
                    constrained_left = left_typ

                # TODO: remove old commented code
                # left_world = World(pset(left_constraints).difference(left_used_constraints), pset(left_bound_ids), inner_world.relids)
                # constrained_left = package_typ(left_world, left_typ)

                induc_body = Unio(constrained_rel, induc_body) 
                param_body = Unio(constrained_left, param_body)

    #             print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_fix rel {i} / len={len(inner_worlds)}
    # ~~~~~~~~~~~~~~~~~~~~~
    # rel_pattern: {concretize_typ(rel_pattern)}
    # constrained rel: {concretize_typ(constrained_rel)}
    # ======================
    # body_var: {body_var}
    # IH_typ: {IH_typ.id}
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
            consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
            consq_typ = Exi(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
            result = All(tuple([param_typ.id]), tuple([Subtyping(param_typ, param_upper)]), Imp(param_typ, consq_typ))  


    #         print(f"""
    # DEBUG combine_fix result 
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # :: rel_typ: {concretize_typ(rel_typ)}

    # ::::
    
    # :: result: {concretize_typ(result)}
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #         """)


            new_world = self.evolve_worlds(nt, result)
            ##################################
        return new_world

    
    def distill_let_target(self, nt : Context, id : str) -> Context:
        print(f"""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        DEBUG let_target init
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        nt: {nt.typ_var.id}
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        typ_var = self.solver.fresh_type_var()
        print(f"""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        DEBUG let_target
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        new: {concretize_typ(typ_var)}
        nt: {nt.typ_var.id}
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        worlds = nt.worlds
        return Context('target', nt.enviro, worlds, typ_var)

    def distill_let_contin(self, nt : Context, id : str, target : Typ) -> Context:
        print(f"""
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        DEBUG let_contin
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        target: {concretize_typ(target)}
        contin: {nt.typ_var.id}
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        enviro = nt.enviro.set(id, target)
        return Context('expr', enviro, nt.worlds, nt.typ_var)

'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, nt : Context, id : str) -> Context:
        body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = self.evolve_worlds(nt, TField(id, body_var))
        return Context('expr', nt.enviro, worlds, body_var) 

    def combine_single(self, nt : Context, label : str, body_worlds : list[World], body_var : TVar) -> list[RecordBranch]:
        return [RecordBranch(body_worlds, label, body_var)]

    def distill_cons_body(self, nt : Context, id : str) -> Context:
        return self.distill_single_body(nt, id)

    def distill_cons_tail(self, nt : Context, id : str, body_var : TVar) -> Context:
        tail_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = self.evolve_worlds(nt, Inter(TField(id, body_var), tail_var))
        return Context('record', nt.enviro, worlds, tail_var) 

    def combine_cons(self, nt : Context, label : str, body_worlds : list[World], body_var : TVar, tail : list[RecordBranch]) -> list[RecordBranch]:
        return self.combine_single(nt, label, body_worlds, body_var) + tail

class FunctionRule(Rule):

    def distill_single_body(self, nt : Context, pattern_attr : PatternAttr) -> Context:

        enviro = pattern_attr.enviro

        body_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var, Imp(pattern_typ, body_var)
        #     )
        # ]

        return Context('expr', nt.enviro.update(enviro), worlds, body_var)

    def combine_single(self, nt : Context, pattern_typ : Typ, body_worlds : list[World], body_var : TVar) -> list[Branch]:
        """
        NOTE: this could learn constraints on the param variables,
        which could separate params into case patterns.
        should package the 
        """
        return [Branch(body_worlds, pattern_typ, body_var)]

    def distill_cons_body(self, nt : Context, pattern_attr : PatternAttr) -> Context:
        return self.distill_single_body(nt, pattern_attr)

    def distill_cons_tail(self, nt : Context, pattern_typ : Typ, body_var : TVar) -> Context:
        '''
        - the previous pattern should not influence what pattern occurs next
        - patterns may overlap
        '''
        return nt

    def combine_cons(self, nt : Context, pattern_typ : Typ, body_worlds : list[World], body_var : TVar, tail : list[Branch]) -> list[Branch]:
        return self.combine_single(nt, pattern_typ, body_worlds, body_var) + tail


class KeychainRule(Rule):

    def combine_single(self, nt : Context, key : str) -> list[str]:
        return [key]

    def combine_cons(self, nt : Context, key : str, keys : list[str]) -> list[str]:
        return [key] + keys


class ArgchainRule(Rule):
    def distill_single_content(self, nt : Context) -> Context:
        content_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         nt.typ_var, Imp(typ_var, Top())
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, content_var, False)

    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def combine_single(self, nt : Context, content_var : TVar) -> ArgchainAttr:
        return ArgchainAttr(nt.worlds, [content_var])

    def combine_cons(self, nt : Context, head_var : TVar, tail_vars : list[TVar]) -> ArgchainAttr:
        return ArgchainAttr(nt.worlds, [head_var] + tail_vars)

######

class PipelineRule(Rule):

    def distill_single_content(self, nt : Context) -> Context:
        content_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         content_var, Imp(nt.typ_var, Top())
        #     )
        # ]
        return Context('expr', nt.enviro, worlds, content_var)


    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def distill_cons_tail(self, nt : Context, head_var : TVar) -> Context:
        '''
        cut the head with the previous tyption
        resulting in a new tyption of what can cut the next element in the tail
        '''
        tail_var = self.solver.fresh_type_var()
        worlds = nt.worlds
        # TODO: add constraints in distill for type-guided program synthesis 
        # worlds = [
        #     m1
        #     for m0 in nt.worlds
        #     for m1 in self.solver.solve(m0, 
        #         head_var, Imp(nt.typ_var, tail_var)
        #     )
        # ]
        return Context('pipeline', nt.enviro, worlds, tail_var)

    def combine_single(self, nt : Context, content_var : TVar) -> PipelineAttr:
        return PipelineAttr(nt.worlds, [content_var])

    def combine_cons(self, nt : Context, head_var : TVar, tail_var : list[TVar]) -> PipelineAttr:
        return PipelineAttr(nt.worlds, [head_var] + tail_var)


'''
start Pattern Rule
'''

class PatternRule(Rule):
    # def distill_tuple_head(self, nt : Context) -> Context:
    #     typ_var = self.solver.fresh_type_var()
    #     worlds = nt.worlds
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # worlds = [
    #     #     m1
    #     #     for m0 in nt.worlds
    #     #     for m1 in self.solver.solve(m0, 
    #     #         Inter(TField('head', typ_var), TField('tail', Bot())), 
    #     #         nt.typ_var
    #     #     )
    #     # ]

    #     return Context('pattern', nt.enviro, worlds, typ_var) 

    # def distill_tuple_tail(self, nt : Context, head_typ : Typ) -> Context:
    #     typ_var = self.solver.fresh_type_var()
    #     worlds = nt.worlds
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # worlds = [
    #     #     m1
    #     #     for m0 in nt.worlds
    #     #     for m1 in self.solver.solve(m0, 
    #     #         Inter(TField('head', head_typ), TField('tail', typ_var)), 
    #     #         nt.typ_var,
    #     #     )
    #     # ]
    #     return Context('pattern', nt.enviro, worlds, typ_var) 

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
    #     worlds = nt.worlds
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # worlds = [
    #     #     m1
    #     #     for m0 in nt.worlds
    #     #     for m1 in self.solver.solve(m0, 
    #     #         TTag(id, body_var), nt.typ_var
    #     #     )
    #     # ]
    #     return Context('pattern', nt.enviro, worlds, body_var)

    def combine_tag(self, nt : Context, label : str, body_attr : PatternAttr) -> PatternAttr:
        pattern = TTag(label, body_attr.typ)
        return PatternAttr(body_attr.enviro, pattern)
'''
end BasePatternRule
'''

class RecordPatternRule(Rule):

    # def distill_single_body(self, nt : Context, id : str) -> Context:
    #     body_var = self.solver.fresh_type_var()
    #     worlds = nt.worlds
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # worlds = [
    #     #     m1
    #     #     for m0 in nt.worlds
    #     #     for m1 in self.solver.solve(m0, 
    #     #         TField(id, typ_var), nt.typ_var
    #     #     )
    #     # ]
    #     return Context('pattern_record', nt.enviro, worlds, body_var) 

    def combine_single(self, nt : Context, label : str, body_attr : PatternAttr) -> PatternAttr:
        pattern = TField(label, body_attr.typ)
        return PatternAttr(body_attr.enviro, pattern)

    # def distill_cons_body(self, nt : Context, id : str) -> Context:
    #     return self.distill_cons_body(nt, id)

    # def distill_cons_tail(self, nt : Context, id : str, body_typ : Typ) -> Context:
    #     tail_var = self.solver.fresh_type_var()
    #     worlds = nt.worlds
    #     # TODO: add constraints in distill for type-guided program synthesis 
    #     # worlds = self.evolve_worlds(nt, Inter(TField(id, body_typ), tail_var))
    #     return Context('pattern_record', nt.enviro, worlds, tail_var) 

    def combine_cons(self, nt : Context, label : str, body_attr : PatternAttr, tail_attr : PatternAttr) -> PatternAttr:
        pattern = Inter(TField(label, body_attr.typ), tail_attr.typ)
        enviro = body_attr.enviro.update(tail_attr.enviro)
        return PatternAttr(enviro, pattern)

class TargetRule(Rule):
    def combine_anno(self, nt : Context, anno_typ : Typ) -> list[World]: 
        print(f"""
        ~~~~~~~~~~~~~~~~~~~~~~~~~
        DEBUG anno: 
        {concretize_typ(nt.typ_var)}
        <:
        {concretize_typ(anno_typ)}
        ~~~~~~~~~~~~~~~~~~~~~~~~~
        """)
        worlds = [
            m1
            for m0 in nt.worlds
            for m1 in self.solver.solve(m0, 
                nt.typ_var,
                anno_typ
            )
        ]
        # for world in worlds:
        #     print(f"""
        #     ~~~~~~~~~~~~~~~~~~~~~~~~~
        #     DEBUG anno result constraints: 
        #     {list_out_constraints(world.constraints)}
        #     ~~~~~~~~~~~~~~~~~~~~~~~~~
        #     """)
        return worlds

