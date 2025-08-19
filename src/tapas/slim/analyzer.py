from __future__ import annotations
from dataclasses import dataclass, replace
from typing import *
from typing import Callable 
import sys
from antlr4 import *
import sys

import random

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

class InhabitableError(Exception):
    pass

class Elim:
    # elim <: intro
    pass
class Intro:
    # elim <: intro
    pass

Position = Union[Elim,Intro]

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
            f'"{item.pattern}"'
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
SEMI = t(';')

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

# @dataclass(frozen=True, eq=True)
# class TTag:
#     label : str
#     body : Typ 

@dataclass(frozen=True, eq=True)
class TEntry:
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
    subtraction : Typ # NOTE:, restrict to a tag/field pattern that is easy decide anti-unification

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

# Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, Exi, All, Fixpoint, Top, Bot]
Typ = Union[TVar, TUnit, TEntry, Unio, Inter, Diff, Imp, Exi, All, LeastFP, Top, Bot]


@dataclass(frozen=True, eq=True)
class NDBranch:
    pattern : Typ 
    results : list[Result]

@dataclass(frozen=True, eq=True)
class DBranch:
    world : World
    pattern : Typ 
    body : Typ

Enviro = PMap[str, Typ]

@dataclass(frozen=True, eq=True)
class FunctionResult:
    pid : int
    world : World
    branches : list[NDBranch]

@dataclass(frozen=True, eq=True)
class KeychainResult:
    keys : list[str]

@dataclass(frozen=True, eq=True)
class RecordBranch:
    world : World
    label : str 
    body : Typ


@dataclass(frozen=True, eq=True)
class RecordResult:
    branches : list[RecordBranch]

'''
Nameless Type
'''
@dataclass(frozen=True, eq=True)
class BVar:
    id : int 

# @dataclass(frozen=True, eq=True)
# class TTagNL:
#     label : str
#     body : NL 

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

# NL = Union[TVar, BVar, TUnit, TTagNL, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, ExiNL, AllNL, LeastFPNL, Top, Bot]
NL = Union[TVar, BVar, TUnit, TFieldNL, UnioNL, InterNL, DiffNL, ImpNL, ExiNL, AllNL, LeastFPNL, Top, Bot]

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
    # elif isinstance(typ, TTag):
    #     return TTagNL(typ.label, to_nameless(bound_ids, typ.body))
    elif isinstance(typ, TEntry):
        return TFieldNL(typ.label, to_nameless(bound_ids, typ.body))
    elif isinstance(typ, Unio):
        return UnioNL(to_nameless(bound_ids, typ.left), to_nameless(bound_ids, typ.right))
    elif isinstance(typ, Inter):
        return InterNL(to_nameless(bound_ids, typ.left), to_nameless(bound_ids, typ.right))
    elif isinstance(typ, Diff):
        return DiffNL(to_nameless(bound_ids, typ.context), to_nameless(bound_ids, typ.subtraction))
    elif isinstance(typ, Imp):
        return ImpNL(to_nameless(bound_ids, typ.antec), to_nameless(bound_ids, typ.consq))
    elif isinstance(typ, Exi):
        count = len(typ.ids)
        bound_ids = tuple(typ.ids) + bound_ids

        constraints_nl = tuple(
            SubtypingNL(to_nameless(bound_ids, st.lower), to_nameless(bound_ids, st.upper))
            for st in typ.constraints
        )
        return ExiNL(count, constraints_nl, to_nameless(bound_ids, typ.body))

    elif isinstance(typ, All):
        count = len(typ.ids)
        bound_ids = tuple(typ.ids) + bound_ids

        constraints_nl = tuple(
            SubtypingNL(to_nameless(bound_ids, st.lower), to_nameless(bound_ids, st.upper))
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
    lower : Typ
    upper : Typ
    def __lt__(self, other):
        return (
            concretize_typ(self.lower) + "<:" + concretize_typ(self.upper)
            <
            concretize_typ(other.lower) + "<:" + concretize_typ(other.upper)
        )


def concretize_ids(ids : tuple[str, ...]) -> str:
    return " ".join(ids)

def concretize_constraints(subtypings : Iterable[Subtyping], inline = False) -> str:
    sep = " " if inline else "\n"
    return sep.join([
        "(" + concretize_typ(st.lower) + " <: " + concretize_typ(st.upper) + ") "
        for st in subtypings
    ])

dent = 4 * " "
def indent(block: str) -> str:
    lines = block.split("\n")
    return "\n".join([
        dent + line
        for line in lines
    ])

def concretize_ndbranch(nd : NDBranch) -> str:
    return "NDBRANCH(" + concretize_typ(nd.pattern) + "->\n" + "".join([ 
        "---\n" + 
        str(result.world.closedids) + "\n" +
        "<<<\n" + 
        concretize_constraints(result.world.constraints) + 
        "\n>>>" + "\n" +
        "** " + concretize_typ(result.typ) + " **"
        for result in nd.results
    ]) + ")"



def concretize_switch(sw : FunctionResult) -> str:
    return "".join([
        concretize_ndbranch(ndbranch) + "\n"
        for ndbranch in sw.branches
    ])

def concretize_typ(typ : Typ) -> str:
    def make_plate_entry (control : Typ):
        if False: 
            pass
        elif isinstance(control, TVar):
            plate_entry = ([], lambda: control.id)  
        elif isinstance(control, TUnit):
            plate_entry = ([], lambda: "@")  
        # elif isinstance(control, TTag):
        #     plate_entry = ([control.body], lambda body : f"~{control.label} {body}")  
        elif isinstance(control, TEntry):
            plate_entry = ([control.body], lambda body : f"<{control.label}> {body}")  
        elif isinstance(control, Imp):
            plate_entry = ([control.antec, control.consq], lambda antec, consq : f"({antec} -> {consq})")  
        elif isinstance(control, Unio):
            plate_entry = ([control.left,control.right], lambda left, right : f"({left} | {right})")  
        elif isinstance(control, Inter):
            if (
                isinstance(control.left, TEntry) and control.left.label == "head" and 
                isinstance(control.right, TEntry) and control.right.label == "tail" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({left} * {right})")  
            elif (
                isinstance(control.right, TEntry) and control.right.label == "head" and 
                isinstance(control.left, TEntry) and control.left.label == "tail" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({right} * {left})")  
            else:
                plate_entry = ([control.left,control.right], lambda left, right : f"({left} & {right})")  
        elif isinstance(control, Diff):
            plate_entry = ([control.context,control.subtraction], lambda context,negation : f"({context} \\ {negation})")  
        elif isinstance(control, Exi):
            constraints = concretize_constraints(control.constraints, inline=True)
            ids = concretize_ids(control.ids)
            if constraints:
                plate_entry = ([control.body], lambda body : f"(EXI[{ids}] {constraints} : {body})")
            else:
                plate_entry = ([control.body], lambda body : f"(EXI[{ids}] {body})")
        elif isinstance(control, All):
            constraints = concretize_constraints(control.constraints, inline=True)
            ids = concretize_ids(control.ids)
            if constraints:
                plate_entry = ([control.body], lambda body : f"(ALL[{ids}] {constraints} : {body})")  
            else:
                plate_entry = ([control.body], lambda body : f"(ALL[{ids}] {body})")
        elif isinstance(control, LeastFP):
            id = control.id
            plate_entry = ([control.body], lambda body : f"(LFP[{id}] {body})")  
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
class PatternResult:
    enviro : PMap[str, Typ]
    typ : Typ    


@dataclass(frozen=True, eq=True)
class ChainResult:
    pid : int
    world : World
    typs : list[Typ]

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
    enviro : PMap[str, Typ] 
    world : World


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
    closedids : PSet[str]
    relids : PSet[str]

def empty_world() -> World:
    return World(s(), s(), s())

def union_worlds(w1 : World, w2 : World) -> World:
    return World(
        w1.constraints.union(w2.constraints),
        w1.closedids.union(w2.closedids),
        w1.relids.union(w2.relids)
    )



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
    world.skolems: {world.closedids}

    world.constraints: 
    {constraints_str}

    world.relids: {world.relids}
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)

def by_variable(constraints : PSet[Subtyping], key : str) -> PSet[Subtyping]: 
    return pset((
        st
        for st in constraints
        if key in extract_free_vars_from_typ(pset(), st.lower)
    )) 

Guidance = Union[Symbol, Terminal, Context]

def pattern_type(t : Typ) -> bool:
    return (
        isinstance(t, TVar) or
        isinstance(t, TUnit) or
        # (isinstance(t, TTag) and pattern_type(t.body)) or 
        (isinstance(t, TEntry) and pattern_type(t.body)) or 
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
    # elif isinstance(neg, TTag):
    #     return negation_well_formed(neg.body)
    elif isinstance(neg, TEntry):
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
    return negation_well_formed(diff.subtraction)


def make_pair_typ(left : Typ, right : Typ) -> Typ:
    return Inter(TEntry("head", left), TEntry("tail", right))

def linearize_unions(t : Typ) -> list[Typ]:
    if isinstance(t, Bot):
        return []
    elif isinstance(t, Unio):
        return linearize_unions(t.left) + linearize_unions(t.right)
    else:
        return [t]

def linearize_intersections(t : Typ) -> list[Typ]:
    if isinstance(t, Top):
        return []
    elif isinstance(t, Inter):
        return linearize_intersections(t.left) + linearize_intersections(t.right)
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
    elif isinstance(t, TEntry):
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


def project_typ_recurse(t : Typ, path : Sequence[str]) -> Optional[Typ]:
    if not path:
        return None
    elif isinstance(t, Diff):
        context = project_typ_recurse(t.context, path)
        negation = project_typ_recurse(t.subtraction, path)
        if context and negation:
            return Diff(context, negation)
        else:
            return None
    elif isinstance(t, Exi):
        # assert not bool(t.constraints)
        body = project_typ_recurse(t.body, path)
        if body:
            ids = tuple(
                id 
                for id in t.ids
                if id in extract_free_vars_from_typ(s(), body)
            )
            return Exi(ids, t.constraints, body)
        else:
            None
    elif isinstance(t, Inter):
        left = project_typ_recurse(t.left, path)
        right = project_typ_recurse(t.right, path)
        if left and right:
            return make_inter([left, right])
        else:
            return left or right
    # elif isinstance(t, TField):
    #     label = path[0]
    #     if t.label == label:
    #         if len(path) == 1:
    #             return t.body
    #         else:
    #             return project_typ_recurse(t.body, path[1:])
    #     else:
    #         return None
    elif isinstance(t, TEntry):
        label = path[0]
        if t.label == label:
            deeper = None if len(path) == 1 else project_typ_recurse(t.body, path[1:])
            if bool(deeper):
                return deeper
            else:
                return t.body
        else:
            return None


def project_typ(t : Typ, path : Sequence[str]) -> Typ:
    result = project_typ_recurse(t, path)
    if result:
        return result
    else:
        raise Exception(f"extract_field_plain error: {list(path)} in {concretize_typ(t)}")

def project_typ_induc(id_induc : str, t : Typ, path : tuple[str, ...]) -> Typ:
    if isinstance(t, Exi):  
        new_constraints = tuple(
            (
            Subtyping(project_typ(st.lower, path), TVar(id_induc))
            if st.upper == TVar(id_induc) else
            st
            )
            for st in t.constraints
        )
        new_body = project_typ(t.body, path)
        return Exi(t.ids, new_constraints, new_body)
    else:
        return project_typ(t, path)


def insert_at_path(rnode : RNode, path : tuple[str, ...], t : Typ) -> RNode:
    assert path
    key = path[0]  
    remainder = path[1:]

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
        if isinstance(v, RLeaf):
            field = TEntry(key, v.content)
        else:
            assert isinstance(v, RNode)
            t = to_record_typ(v)
            field = TEntry(key, t)
        result = make_inter([field, result])
    return result

def alpha_equiv(t1 : Typ, t2 : Typ) -> bool:
    left_nameless_typ = to_nameless((), t1)
    right_nameless_typ = to_nameless((), t2)
    result = left_nameless_typ == right_nameless_typ
    return result

def is_record_typ(t : Typ) -> bool:
    if isinstance(t, TEntry):
        return True
    elif isinstance(t, Inter):
        return is_record_typ(t.left) and is_record_typ(t.right)
    else:
        return False


def is_decidable_shape(t : Typ) -> bool:
    if isinstance(t, TUnit):
        return True
    elif isinstance(t, Top):
        return True
    elif isinstance(t, Bot):
        return True
    # elif isinstance(t, TTag):
    #     return True
    elif isinstance(t, TEntry):
        return True
    elif isinstance(t, Unio):
        return is_decidable_shape(t.left) and is_decidable_shape(t.right)
    elif isinstance(t, Inter):
        return is_decidable_shape(t.left) and is_decidable_shape(t.right)
    else:
        return False

def extract_column_comparisons(key : Typ, rel : LeastFP) -> list[tuple[Typ, list[Typ]]]:
    choices = [
        choice
        for choice in linearize_unions(rel.body)
        if choice != Bot()
    ]

    paths = list(find_longest_common_prefixes(key, choices))

    if bool(paths):
        result = []
        for path in pset(paths):
            column_key = project_typ(key, path)
            column_choices = [
                project_typ_induc(rel.id, choice, path)
                for choice in choices
                if choice != Bot()
            ] 
            result.append((column_key, column_choices))
        return result 
    else:
        return [(key, choices)]
    #end-if 


def find_common_prefix(a : tuple[str, ...], b : tuple[str, ...]) -> tuple[str, ...]:
    prefix = []
    for i in range(min(len(a), len(b))):
        if a[i] == b[i]:
            prefix.append(a[i])
        else:
            break 
    return tuple(prefix) 

def find_longest_common_prefix(path : tuple[str, ...], choices : list[Typ]) -> tuple[str, ...]:
    outer_prefix = path
    for choice in choices:
        other_paths = extract_paths(choice)
        inner_prefix = tuple([]) 
        for other_path in other_paths:
            prefix = find_common_prefix(outer_prefix, other_path)
            if len(prefix) > len(inner_prefix):
                inner_prefix = prefix
            #end
        #end
        outer_prefix = find_common_prefix(outer_prefix, inner_prefix)
    #end
    return outer_prefix


def find_longest_common_prefixes(src : Typ, choices : list[Typ]) -> PSet[tuple[str, ...]]:
    assert bool(choices)
    src_paths = extract_paths(src)
    prefixes = s()
    for path in src_paths:
        lcp = find_longest_common_prefix(path, choices)
        if bool(lcp):
            prefixes = prefixes.add(lcp)
    return prefixes 
    
    

def is_consistently_labeled(src : LeastFP, label : str) -> bool:
    choices = linearize_unions(src.body)
    return all(
        bool(project_typ_recurse(choice, tuple([label])))
        for choice in choices
    )


def is_inflatable(key : Typ, rel : LeastFP) -> bool:
    comparisons = extract_column_comparisons(key, rel)

    result = False 
    for column_key, column_choices in comparisons:
        key_is_decidable = is_decidable_shape(column_key)
        there_are_decidable_shapes_in_choices = any(
            isinstance(cc, TEntry) or
            (isinstance(cc, Exi) and is_decidable_shape(cc.body))
            for cc in column_choices
        )
        there_is_no_unguarded_subtyping_of_self = all(
            cc != TVar(rel.id) and 
            (not isinstance(cc, Exi) or 
                all(cc.body != st.lower 
                    for st in cc.constraints
                    if st.upper == TVar(rel.id)
                )
            )
            for cc in column_choices
        ) 
        if (key_is_decidable and there_are_decidable_shapes_in_choices and there_is_no_unguarded_subtyping_of_self):
            return True 
        # endif

    return result


def extract_kv_pairs(t : Typ) -> PSet[tuple[tuple[str, ...], Typ]]:
    if False:
        assert False
    elif isinstance(t, Exi):
        return extract_kv_pairs(t.body)
    elif isinstance(t, Inter):
        left = extract_kv_pairs(t.left) 
        right = extract_kv_pairs(t.right)
        return left.union(right)
    elif isinstance(t, TEntry):
        sub_kv_pairs = extract_kv_pairs(t.body)
        result = (
            pset(
                (tuple([t.label]) + sub_path, v) 
                for (sub_path, v) in sub_kv_pairs
            )
            if bool(sub_kv_pairs) else
            s((tuple([t.label]), t.body))
        )
        return result
    else:
        return pset()


def make_tuple_typ(xs : list[Typ]) -> Typ: 
    assert len(xs) >= 2
    result = make_pair_typ(xs[1], xs[0])
    for x in xs[2:]:
        result = make_pair_typ(x, result)
    return result

def to_tuple_typ(t, ordered_paths : list[tuple[str, ...]]) -> Typ:
    ordered_targets = [
        project_typ(t, path)
        for path in ordered_paths
    ]
    return make_tuple_typ(ordered_targets)


def normalize_choice(induc_id : str, choice : Typ, ordered_paths : list[tuple[str, ...]]) -> Typ:
    if isinstance(choice, Exi):


        new_constraints = tuple(
            (
            Subtyping(to_tuple_typ(st.lower, ordered_paths), TVar(induc_id))
            if st.upper == TVar(induc_id) else
            st
            )
            for st in choice.constraints
        )
        new_body = to_tuple_typ(choice.body, ordered_paths)
        return Exi(choice.ids, new_constraints, new_body)
    else:
        return to_tuple_typ(choice, ordered_paths)

def normalize_least_fp(t : LeastFP, ordered_paths : list[tuple[str, ...]]) -> LeastFP:

    normalized_body = Bot() 
    choices = linearize_unions(t.body)
    for choice in reversed(choices):
        norm_choice = normalize_choice(t.id, choice, ordered_paths)
        normalized_body = Unio(norm_choice, normalized_body)
    return LeastFP(t.id, normalized_body)


def extract_ordered_path_target_pairs(key : Typ) -> list[tuple[tuple[str, ...], Typ]]:
    def ordering_key(p):
        return concretize_typ(p[1])
    path_target_pairs = extract_kv_pairs(key)
    ordered_path_target_pairs = sorted(path_target_pairs, key=ordering_key)
    return ordered_path_target_pairs


def extract_relational_paths(t : LeastFP) -> PSet[tuple[str, ...]]: 
    choices = linearize_unions(t.body)
    paths = s()
    for choice in reversed(choices):
        paths = paths.union(k for (k,v) in extract_kv_pairs(choice))
    return paths 


def extract_targets(t : Typ):
    return [v for k,v in extract_kv_pairs(t)]

def extract_matching_ordered_paths(assumed_key : Typ, search_targets : list[Typ]) -> Optional[list[tuple[str, ...]]]:
    ordered_path_target_pairs = extract_ordered_path_target_pairs(assumed_key)

    filtered_paths = []
    for (k,v) in ordered_path_target_pairs:
        if v in search_targets:
            search_targets.remove(v)
            filtered_paths.append(k)
    if search_targets:
        return None
    else:
        return filtered_paths

def targets_match(assumed_key : Typ, search_targets : list[Typ]) -> bool:
    pairs = extract_kv_pairs(assumed_key)
    for (k,v) in pairs:
        if v in search_targets:
            search_targets.remove(v)
    return not bool(search_targets)


def lookup_relational_constraint(world : World, targets : list[Typ]) -> Optional[Subtyping]:
    for constraint in world.constraints:
        if targets_match(constraint.lower, targets):
            return constraint
    return None


def find_path(assumed_key : Typ, search_target : Typ) -> Optional[tuple[str, ...]]:
    ordered_path_target_pairs = extract_ordered_path_target_pairs(assumed_key)
    for (k,v) in ordered_path_target_pairs:
        if v == search_target:
            return k
    return None

def find_paths(assumed_key : Typ, search_target : Typ) -> PSet[Sequence[str]]:
    results : PSet[Sequence[str]] = s()
    ordered_path_target_pairs = extract_ordered_path_target_pairs(assumed_key)
    for (k,v) in ordered_path_target_pairs:
        if v == search_target:
            results = results.add(k)
    return results 

def factorize_choice(induc_id : str, choice : Typ, path : Sequence[str]) -> Optional[Typ]:
    if isinstance(choice, Exi):

        new_constraints = tuple(
            (
            Subtyping(proj, st.upper)
            if proj else
            st
            )
            for st in choice.constraints
            for proj in [
                project_typ_recurse(st.lower, path)
                if st.upper == TVar(induc_id) else
                None
            ]
        )

        new_body = project_typ_recurse(choice.body, path)
        if new_body:
            used_ids = extract_free_vars_from_constraints(s(), new_constraints).union(extract_free_vars_from_typ(s(), new_body))
            new_ids = used_ids.intersection(choice.ids)
            return Exi(tuple(new_ids), new_constraints, new_body)
        else:
            return None
    else:
        return project_typ_recurse(choice, path)

def factorize_least_fp(t : LeastFP, path : Sequence[str]) -> Optional[LeastFP]:

    factorized_body = Bot() 
    choices = linearize_unions(t.body)
    for choice in reversed(choices):
        fc = factorize_choice(t.id, choice, path)
        if fc:
            factorized_body = Unio(fc, factorized_body)
        else:
            return None
    return LeastFP(t.id, factorized_body)


def find_factors(world : World, search_target : Typ) -> PSet[Typ]:
    return pset( 
        result
        for constraint in world.constraints
        for result in find_factors_from_constraint(constraint, search_target)
    )
    #######################
    #### OLD #######
    #######################
    # results = s()
    # for constraint in world.constraints:
    #     path = find_path(constraint.lower, search_target)
    #     if path != None:
    #         if isinstance(constraint.upper, LeastFP):
    #             result = factorize_least_fp(constraint.upper, path)
    #             results = results.add(result)
    # return results
    #######################




def find_factors_from_constraint(constraint : Subtyping, search_target : Typ) -> PSet[Typ]:
    if isinstance(constraint.upper, LeastFP):
        return find_factors_from_pattern(constraint.upper, constraint.lower, search_target)
    else:
        return s()
    #########################
    ########### OLD #########
    #########################
    # results = s()
    # paths = find_paths(constraint.lower, search_target)
    # # paths = [find_path(constraint.lower, search_target)]
    # for path in paths:
    #     if isinstance(constraint.upper, LeastFP) and path != None:
    #         result = factorize_least_fp(constraint.upper, path)
    #         results = results.add(result)
    # return results
    #########################


def find_factors_from_pattern(src : LeastFP, pattern : Typ, target : Typ) -> PSet[Typ]:
    paths : PSet[Sequence[str]] = find_paths(pattern, target)
    return find_factors_from_labels(src, paths)

def find_factors_from_labels(src : LeastFP, labels : PSet[Sequence[str]]) -> PSet[Typ]:
    results = s()
    for label_seq in labels:
        result = factorize_least_fp(src, label_seq)
        if result:
            results = results.add(result)
    return results

def find_factor_from_label(src : LeastFP, label : str) -> Optional[LeastFP]:
    return factorize_least_fp(src, [label])


def mapOp(f):
    def call(o):
        if o != None:
            return f(o)
        else:
            return None
    return call



def extract_constraints_with_id(world : World, id : str) -> PSet[Subtyping]:
    result = pset(
        st
        for st in world.constraints
        if id in extract_free_vars_from_constraints(pset(), [st])
    )
    return result


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
    # elif isinstance(typ, TTag):  
    #     return TTag(typ.label, sub_typ(assignment_map, typ.body))
    elif isinstance(typ, TEntry):  
        return TEntry(typ.label, sub_typ(assignment_map, typ.body))
    elif isinstance(typ, Unio):  
        return make_unio([sub_typ(assignment_map, typ.left), sub_typ(assignment_map, typ.right)])
    elif isinstance(typ, Inter):  
        return make_inter([sub_typ(assignment_map, typ.left), sub_typ(assignment_map, typ.right)])
    elif isinstance(typ, Diff):  
        return Diff(sub_typ(assignment_map, typ.context), sub_typ(assignment_map, typ.subtraction))
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

def sub_constraints(assignment_map : PMap[str, Typ], constraints : Iterable[Subtyping]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(sub_typ(assignment_map, st.lower), sub_typ(assignment_map, st.upper))
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
        # elif isinstance(typ, TTag):
        #     plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_bodyA: set_bodyA)
        elif isinstance(typ, TEntry):
            plate_entry = (pair_up(bound_vars, [typ.body]), lambda set_body: set_body)
        elif isinstance(typ, Unio):
            plate_entry = (pair_up(bound_vars, [typ.left, typ.right]), lambda set_left, set_right: set_left.union(set_right))
        elif isinstance(typ, Inter):
            plate_entry = (pair_up(bound_vars, [typ.left, typ.right]), lambda set_left, set_right: set_left.union(set_right))
        elif isinstance(typ, Diff):
            plate_entry = (pair_up(bound_vars, [typ.context, typ.subtraction]), lambda set_context, set_negation: set_context.union(set_negation))
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
    return pset(
        id
        for st in constraints
        for id in extract_free_vars_from_typ(bound_vars, st.lower).union(extract_free_vars_from_typ(bound_vars, st.upper))
    )

def extract_free_vars_from_enviro(enviro : PMap[str, Typ]) -> PSet[str]:
    return pset( 
        id
        for t in enviro.values()
        for id in extract_free_vars_from_typ(s(), t)
    )

def filter_constraints_by_all_variables(constraints : Iterable[Subtyping], influential_ids) -> PSet[Subtyping]:
    return pset( 
        st
        for st in constraints 
        # if all free type variabls in st constraint are influential
        if not bool(extract_free_vars_from_constraints(s(), [st]).difference(influential_ids))
    )

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
    if debug:
        print(f"""
    ~~~~~~~~~~~~~~~~~~~~
    DEBUG extract_reachable_constraints_from_typ 
    ~~~~~~~~~~~~~~~~~~~~
    ids_base: {ids_base}
    ~~~~~~~~~~~~~~~~~~~~
        """)
    for id_base in ids_base: 
        if id not in ids_seen:
            new_constraints, ids_seen = extract_reachable_constraints(world, id_base, ids_seen, debug)
            constraints = constraints.union(new_constraints)
    return constraints


def make_unio(ts : list[Typ]) -> Typ:
    u = Bot()
    for t in reversed(ts):
        if u == Bot():
            u = t
        else:
            u = Unio(t, u)
    return u

def make_inter(ts : list[Typ]) -> Typ:
    i = Top()
    for t in reversed(ts):
        if i == Top():
            i = t
        else:
            i = Inter(t, i)
    return i 

def cast_up(renaming : PMap[str, TVar]) -> PMap[str, Typ]:
    return pmap({
        id : target
        for id, target in renaming.items()
    })


def get_skolems_adjacent_learnable_ids(world : World) -> PSet[str]:
    return pset(
        st.upper.id
        for st in world.constraints
        if isinstance(st.lower, TVar) and st.lower.id in world.closedids  
        if isinstance(st.upper, TVar) and st.upper.id not in world.closedids  
    ) 

def is_typ_structured(t : Typ, lfp_id : str) -> bool:
    if False:
        assert False
    elif isinstance(t, Exi):
        return (
            is_typ_structured(t.body, lfp_id) or
            any(
                is_typ_structured(t.body, st.lower.id)
                for st in t.constraints 
                if isinstance(st.upper, TVar) and st.upper.id == lfp_id
                if isinstance(st.lower, TVar)
            )
        )
    elif isinstance(t, All):
        return is_typ_structured(t.body, lfp_id)
    elif isinstance(t, Top):
        return True
    elif isinstance(t, Bot):
        return True
    # elif isinstance(t, TTag):
    #     return True
    elif isinstance(t, TEntry):
        return True
    elif isinstance(t, Unio):
        return is_typ_structured(t.left, lfp_id) and is_typ_structured(t.right, lfp_id)
    elif isinstance(t, Inter):
        return is_typ_structured(t.left, lfp_id) and is_typ_structured(t.right, lfp_id)
    elif isinstance(t, TVar):
        return t.id == lfp_id
    else:
        return False



@dataclass(frozen=True, eq=True)
class Pos:
    pass
@dataclass(frozen=True, eq=True)
class Neg:
    pass
@dataclass(frozen=True, eq=True)
class Zero:
    pass
Polarity = Union[Pos, Neg, Zero]

def compare_polarities(a : Optional[Polarity], b : Optional[Polarity]) -> Optional[Polarity]:
    if a == None:
        return b
    elif b == None:
        return a
    elif a == Zero():
        return Zero()
    elif b == Zero():
        return Zero()
    elif a == Pos() and b == Pos():
        return Pos()
    elif a == Neg() and b == Neg():
        return Neg()
    else:
        return None


def get_polarity_from_constraints(positive : bool, constraints : Sequence[Subtyping], id : str) -> Optional[Polarity]: 
    pol = None
    for st in constraints:
        lower = get_polarity_from_target(positive, st.lower, id)
        upper = get_polarity_from_target(not positive, st.upper, id)
        combo = compare_polarities(lower, upper)
        pol = compare_polarities(pol, combo)
    return pol

def get_polarity_from_target(positive : bool, target : Typ, id : str) -> Optional[Polarity]: 


    if False:
        assert False

    elif isinstance(target, TVar):
        if target.id == id and positive: 
            return Pos() 
        elif target.id == id and not positive: 
            return Neg() 
        else:
            return None
        #end if

    elif isinstance(target, TUnit):
        return None 

    # elif isinstance(target, TTag):
    #     body = target.body
    #     return get_polarity_from_target(positive, body, id)

    elif isinstance(target, TEntry):
        body = target.body
        return get_polarity_from_target(positive, body, id)

    elif isinstance(target, Unio):
        left = get_polarity_from_target(positive, target.left, id)
        right = get_polarity_from_target(positive, target.right, id)
        return compare_polarities(left, right)



    elif isinstance(target, Inter):
        left = get_polarity_from_target(positive, target.left, id)
        right = get_polarity_from_target(positive, target.right, id)
        return compare_polarities(left, right)

    elif isinstance(target, Diff):
        context = get_polarity_from_target(positive, target.context, id)
        # invariant: negation should have no free variables
        return context

    elif isinstance(target, Imp):
        antec = get_polarity_from_target(not positive, target.antec, id)
        consq = get_polarity_from_target(positive, target.consq, id)
        return compare_polarities(antec, consq)

    elif isinstance(target, Exi):
        if id in target.ids:
            return None
        else:
            constraints = get_polarity_from_constraints(positive, target.constraints, id)
            body = get_polarity_from_target(positive, target.body, id)
            return compare_polarities(constraints, body)

    elif isinstance(target, All):
        if id in target.ids:
            return None
        else:
            constraints = get_polarity_from_constraints(positive, target.constraints, id)
            body = get_polarity_from_target(positive, target.body, id)
            return compare_polarities(constraints, body)

    elif isinstance(target, LeastFP):

        if id == target.id:
            return None
        else:
            return get_polarity_from_target(positive, target.body, id)

    elif isinstance(target, Top):
        return None 

    elif isinstance(target, Bot):
        return None 

def get_polarity_from_targets(positive : bool, targets : Iterable[Typ], id : str) -> Optional[Polarity]: 
    id_targets = [ 
        t
        for t in targets
        if id in extract_free_vars_from_typ(s(), t)
    ]
    if len(id_targets) != 1:
        return Zero() 
    else:
        target = id_targets[0] 
        return get_polarity_from_target(positive, target, id)
    
default_context = Context(m(), World(s(), s(), s()))


class Solver:
    _type_id : int
    _limit : int
    _checking : bool

    aliasing : PMap[str, Typ]

    priority_map : dict[Subtyping, int] = {} 

    def print(self, x):
        if not self._checking:
            print(x)

    def __init__(self, aliasing : PMap[str, Typ]):
        self._type_id = 0 
        self._limit = 500 
        self.debug = True
        self.count = 0
        self.aliasing = aliasing
        self._checking = False 

    def lookup_normalized_relational_typ(self, world : World, key : Typ) -> Optional[Typ]:
        # TODO: update to avoid using simplify_typ
        key = self.simplify_typ(key)
        if is_record_typ(key):
            for constraint in world.constraints:
                ordered_paths = extract_matching_ordered_paths(constraint.lower, extract_targets(key))
                if ordered_paths != None:
                    if isinstance(constraint.upper, LeastFP):
                        return normalize_least_fp(constraint.upper, ordered_paths)
            return None
        else:
            return None

    def make_checker(self) -> Solver:
        checker = Solver(m()) 
        checker._type_id = self._type_id 
        checker._limit = self._limit
        checker.debug = self.debug
        checker.count = self.count
        checker.aliasing = self.aliasing
        checker._checking = True 
        return checker

    def is_useless(self, positive : bool, t : Typ) -> bool:
        ult = Top() if positive else Bot()
        if t == ult: 
            return True
        elif isinstance(t, Imp): 
            return self.is_useless(not positive, t.antec) or self.is_useless(positive, t.consq)
        else:
            return False



    def simplify_typ(self, typ : Typ) -> Typ:
        if False:
            assert False
        # elif isinstance(typ, TTag):
        #     return TTag(typ.label, self.simplify_typ(typ.body))
        elif isinstance(typ, TEntry):
            return TEntry(typ.label, self.simplify_typ(typ.body))
        elif isinstance(typ, Inter): 
            new_left = self.simplify_typ(typ.left)
            new_right = self.simplify_typ(typ.right)
            if not bool(extract_free_vars_from_typ(s(), typ)): 
                if self.check(empty_world(), new_left, new_right):
                    return new_left
                elif self.check(empty_world(), new_right, new_left): 
                    return new_right
                else:
                    return make_inter([new_left, new_right])
            else:
                if isinstance(new_left, Top):
                    return new_right
                elif isinstance(new_right, Top):
                    return new_left
                else:
                    return make_inter([new_left, new_right])
        elif isinstance(typ, Unio): 
            new_left = self.simplify_typ(typ.left)
            new_right = self.simplify_typ(typ.right)
            # if False:
            # TODO: make sure check is sound before using
            if not bool(extract_free_vars_from_typ(s(), typ)): 
                if self.check(empty_world(), new_left, new_right):
                    return new_right
                elif self.check(empty_world(), new_right, new_left): 
                    return new_left
                else:
                    return make_unio([new_left, new_right])
            else:
                if isinstance(new_left, Bot):
                    return new_right
                elif isinstance(new_right, Bot): 
                    return new_left
                else:
                    return make_unio([new_left, new_right])
        elif isinstance(typ, Diff): 
            typ = Diff(self.simplify_typ(typ.context), self.simplify_typ(typ.subtraction))
            if typ.subtraction == Bot():
                return typ.context
            else:
                return typ
        elif isinstance(typ, Imp): 
            return Imp(self.simplify_typ(typ.antec), self.simplify_typ(typ.consq))
        elif isinstance(typ, Exi):
            if not typ.ids and not typ.constraints:
                return self.simplify_typ(typ.body)
            elif not typ.constraints and isinstance(typ.body, TVar) and typ.body.id in typ.ids:
                return Top()
            else:
                return Exi(typ.ids, self.simplify_constraints(typ.constraints), self.simplify_typ(typ.body))
        elif isinstance(typ, All):
            return All(typ.ids, self.simplify_constraints(typ.constraints), self.simplify_typ(typ.body))
        elif isinstance(typ, LeastFP):
            if typ.id not in extract_free_vars_from_typ(s(), typ.body):
                return self.simplify_typ(typ.body)
            else:
                return LeastFP(typ.id, self.simplify_typ(typ.body))
        else:
            return typ
        
    def simplify_constraints(self, constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
        return tuple(
            Subtyping(self.simplify_typ(st.lower), self.simplify_typ(st.upper))
            for st in constraints
        )


    def to_aliasing_constraints(self, constraints : Iterable[Subtyping]) -> tuple[Subtyping, ...]:
        new_constraints = []
        for st in constraints:
            lower = self.to_aliasing_typ(st.lower)
            upper = self.to_aliasing_typ(st.upper)
            new_constraints.append(Subtyping(lower, upper))

        return tuple(new_constraints)


    def to_aliasing_typ(self, t : Typ) -> Typ:

        if False: 
            pass
        # elif isinstance(t, TTag):
        #     body_typ = self.to_aliasing_typ(t.body)
        #     return TTag(t.label, body_typ)
        elif isinstance(t, TEntry):
            body_typ = self.to_aliasing_typ(t.body)
            return TEntry(t.label, body_typ)
        elif isinstance(t, Imp):
            antec_typ = self.to_aliasing_typ(t.antec)
            consq_typ = self.to_aliasing_typ(t.consq)
            return Imp(antec_typ, consq_typ)
        elif isinstance(t, Unio):
            left_typ = self.to_aliasing_typ(t.left)
            right_typ = self.to_aliasing_typ(t.right)
            return Unio(left_typ, right_typ)
        elif isinstance(t, Inter):
            left_typ = self.to_aliasing_typ(t.left)
            right_typ = self.to_aliasing_typ(t.right)
            return Inter(left_typ, right_typ)
        elif isinstance(t, Diff):
            context_typ = self.to_aliasing_typ(t.context)
            neg_typ = self.to_aliasing_typ(t.subtraction)
            return Diff(context_typ, neg_typ)
        elif isinstance(t, Exi):
            constraints = self.to_aliasing_constraints(t.constraints)
            body_typ = self.to_aliasing_typ(t.body)
            return Exi(t.ids, constraints, body_typ)
        elif isinstance(t, All):
            constraints = self.to_aliasing_constraints(t.constraints)
            body_typ = self.to_aliasing_typ(t.body)
            return All(t.ids, constraints, body_typ)
        elif isinstance(t, LeastFP):
            body_typ = self.to_aliasing_typ(t.body)
            new_typ = LeastFP(t.id, body_typ)
            alias = next((
                alias
                for alias,ty in self.aliasing.items()
                if alpha_equiv(ty, new_typ)
            ), None)
            if alias != None:
                return TVar(alias)
            else:
                return new_typ 
        else:
            return t

    def is_constraint_dead(self, world : World, ignored : PSet[str], st : Subtyping) -> bool:
        lower_result = False
        upper_result = False
        # if isinstance(st.lower, TVar) and st.lower.id not in ignored and st.lower.id not in world.skolems:
        if isinstance(st.lower, TVar):
            lower_result = (
                st.lower.id not in ignored and 
                st.lower.id not in world.closedids and 
                st.lower.id not in extract_free_vars_from_constraints(s(), world.constraints.difference(s(st)))
            )

        if isinstance(st.upper, TVar): 
            upper_result = (
                st.upper.id not in ignored and 
                st.upper.id not in world.closedids and 
                st.upper.id not in extract_free_vars_from_constraints(s(), world.constraints.difference(s(st)))
            )

        return lower_result or upper_result 

    def decode_polarity_typ(self, results : list[Result], polarity : bool) -> Typ:
        base = (Top() if polarity else Bot())
        operator = (Inter if polarity else Unio)

        big_typ = base
        for result in results:

            ids = extract_free_vars_from_typ(result.world.closedids, result.typ)
            m = self.interpret_ids_polar(polarity, ids, result.world.constraints)
            t = sub_typ(m, result.typ)
            # t = self.interpret_polar_typ(polarity, result.world.closedids, result.world.constraints, result.typ)
            influential_ids = result.world.closedids.union(extract_free_vars_from_typ(s(), t))
            influential_constraints =  filter_constraints_by_all_variables(result.world.constraints, influential_ids)
            ctyp = self.make_constraint_typ(polarity)(s(), result.world.closedids, influential_constraints, t)
            big_typ = operator(big_typ, ctyp)
        return big_typ

    def flatten_index_unios(self, t : Typ) -> tuple[tuple[str, ...], tuple[Subtyping, ...], Typ]:
        if False:
            pass
        elif isinstance(t, TVar):
            return ((), (), t)
        elif isinstance(t, TUnit):
            return ((), (), t)
        # elif isinstance(t, TTag):
        #     (body_ids, body_constraints, body_typ) = self.flatten_index_unios(t.body)
        #     return (body_ids, body_constraints, TTag(t.label, body_typ))
        elif isinstance(t, TEntry):
            (body_ids, body_constraints, body_typ) = self.flatten_index_unios(t.body)
            return (body_ids, body_constraints, TEntry(t.label, body_typ))
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
            return (context_ids, context_constraints, Diff(context_typ, t.subtraction))
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
        self._type_id = self._type_id + 1
        return ("G" + f"{self._type_id}".zfill(3))

    def fresh_type_var(self) -> TVar:
        return TVar(self.fresh_type_id())

    def make_renaming_tvars(self, old_ids : Sequence[str]) -> PMap[str, TVar]:
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

    def make_constraint_typ(self, positive : bool):
        (outer_con, inner_con) = ((Exi, All) if positive else (All, Exi))

        def make(foreignids : PSet[str], closedids : PSet[str], constraints : PSet[Subtyping], payload : Typ):
            payload_ids = extract_free_vars_from_typ(s(), payload)
            assert not bool(foreignids.intersection(closedids))

            outer_constraints = pset(
                st
                for st in constraints
                for fids in [extract_free_vars_from_constraints(s(), [st])]
                if not bool (fids.difference(closedids).difference(foreignids)) # every free id is closed or foreign
                if bool(fids.intersection(closedids)) # there's at least one closed id
            )
            inner_constraints = constraints.difference(outer_constraints)

            # NOTE: If a constraint has neither a skolem variable nor a learnable variable,
            # then is should be packed in the inner (learnable) constraints 
            # this is a safe but weaker requirement. 
            # in the outer (skoleim) constraints it could run afoul of the decidabily requirement.

            outer_ids = extract_free_vars_from_constraints(s(), constraints).union(payload_ids).intersection(closedids)
            inner_ids = extract_free_vars_from_constraints(s(), inner_constraints).union(payload_ids).difference(closedids).difference(foreignids)
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG MAKE:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# foreignids: {foreignids}
# skolems: {closedids}

# payload
# {concretize_typ(payload)}

# outer_constraints:
# {concretize_constraints(outer_constraints)}

# inner_constraints:
# {concretize_constraints(inner_constraints)}

# outer_ids:
# {outer_ids}

# inner_ids:
# {inner_ids}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            # ######### invariant: for each constraint in inner_constraints, there is at least one open / inner id in fids(constraint) 
            # for st in inner_constraints:
            #     fids = extract_free_vars_from_constraints(s(), [st]) 
            #     assert bool(inner_ids.intersection(fids))
            # ######################

            if (outer_ids or outer_constraints) and (inner_ids or inner_constraints):
                return outer_con(
                    tuple(outer_ids), tuple(outer_constraints),
                    inner_con(tuple(inner_ids), tuple(inner_constraints), payload)
                )
            elif (outer_ids or outer_constraints):
                assert not inner_constraints
                return outer_con(tuple(outer_ids), tuple(outer_constraints), payload)
            elif (inner_ids or inner_constraints):
                assert not outer_constraints
                return inner_con(tuple(inner_ids), tuple(inner_constraints), payload)
            else:
                assert not inner_constraints and not outer_constraints
                return payload
            # end if/else
        # end def
        return make
    # end def

    def get_negative_extra_constraints(self, ignore : PSet[str], constraints : PSet[Subtyping], id : str) -> PSet[Subtyping]:
        extra_constraints : PSet[Subtyping] = s()
        for st in constraints:
            if st.lower == TVar(id): 
                fids = extract_free_vars_from_typ(s(), st.upper).difference(ignore)
                intermediates = pset(
                    inner
                    for inner in constraints
                    if isinstance(inner.lower, TVar)
                    if inner.lower.id in fids 
                )
                if bool(intermediates):
                    extra_constraints = extra_constraints.union(intermediates).add(st)
        return extra_constraints

    def get_positive_extra_constraints(self, ignore : PSet[str], constraints : PSet[Subtyping], id : str) -> PSet[Subtyping]:
        extra_constraints : PSet[Subtyping] = s()
        for st in constraints:
            if st.upper == TVar(id): 
                fids = extract_free_vars_from_typ(s(), st.lower).difference(ignore)
                intermediates = pset(
                    inner
                    for inner in constraints
                    if isinstance(inner.upper, TVar)
                    if inner.upper.id in fids
                )
                if bool(intermediates):
                    extra_constraints = extra_constraints.union(intermediates).add(st)
        return extra_constraints


    def relational_ids(self, constraints : PSet[Subtyping]) -> PSet[str]:
        return pset(
            id
            for st in constraints
            if self.is_relational_key(st.lower)
            if isinstance(st.upper, LeastFP)
            for id in extract_free_vars_from_typ(s(), st.lower) 
        )

    ###############################################3
    def interpret_ids_strongest(self, ids : PSet[str], constraints : PSet[Subtyping]) -> PMap[str, Typ]:
        return pmap({
            id : self.interpret_id_strongest(constraints, id) 
            for id in ids
        })

    def interpret_ids_weakest(self, ids : PSet[str], constraints : PSet[Subtyping]) -> PMap[str, Typ]:
        return pmap({
            id : self.interpret_id_weakest(constraints, id) 
            for id in ids
        })

    def interpret_ids_polar(self, strongest : bool, ids : PSet[str], constraints : PSet[Subtyping]) -> PMap[str, Typ]:
        if strongest:
            return self.interpret_ids_strongest(ids, constraints)
        else:
            return self.interpret_ids_weakest(ids, constraints)

    def interpret_sub(self, strongest : bool, ignore : PSet[str], constraints : PSet[Subtyping], target : Typ) -> Typ:
        prev = Bot() if strongest else Top() 
        while prev != target:
            prev = target
            m = self.interpret_ids_strongest(ignore, constraints)
            target = sub_typ(m, target)
        return target
    ###############################################3

    def interpret_id_weakest(self, constraints : PSet[Subtyping], id : str) -> Typ:

        if id in self.relational_ids(constraints):
            return TVar(id)

        result_typ : Typ = TVar(id) 
        for st in constraints:
            if st.lower == TVar(id): 
                if result_typ == TVar(id):
                    result_typ = st.upper
                else:
                    result_typ = Inter(result_typ, st.upper)
        return  result_typ

    # def interpret_polar_typ(self, positive : bool, ignore : PSet[str], constraints : PSet[Subtyping], src : Typ) -> Typ:
    #     # TODO: simplify to always ignore closedids
    #     # only open variables should be interpreted
    #     if False:
    #         assert False
    #     elif isinstance(src, TVar) and src.id not in ignore:  
    #         if positive:
    #             return self.interpret_id_strongest(constraints, src.id)
    #         else:
    #             return self.interpret_id_weakest(constraints, src.id)
    #     elif isinstance(src, TUnit):  
    #         return TUnit()
    #     elif isinstance(src, TEntry):  
    #         body = self.interpret_polar_typ(positive, ignore, constraints, src.body)
    #         return TEntry(src.label, body)
    #     elif isinstance(src, Unio):  
    #         left = self.interpret_polar_typ(positive, ignore, constraints, src.left)
    #         right = self.interpret_polar_typ(positive, ignore, constraints, src.right)
    #         return Unio(left, right)
    #     elif isinstance(src, Inter):  
    #         left = self.interpret_polar_typ(positive, ignore, constraints, src.left)
    #         right = self.interpret_polar_typ(positive, ignore, constraints, src.right)
    #         return Inter(left, right)
    #     elif isinstance(src, Diff):  
    #         context = self.interpret_polar_typ(positive, ignore, constraints, src.context)
    #         return Diff(context, src.subtraction)
    #     elif isinstance(src, Imp):  
    #         consq = self.interpret_polar_typ(positive, ignore, constraints, src.consq)
    #         antec = self.interpret_polar_typ(not positive, ignore, constraints, src.antec)
    #         return Imp(antec, consq)
    #     elif isinstance(src, Exi):  
    #         inner_constraints = self.interpret_polar_constraints(positive, ignore.union(src.ids), constraints, src.constraints)
    #         body = self.interpret_polar_typ(positive, ignore.union(src.ids), constraints, src.body)
    #         return Exi(src.ids, tuple(inner_constraints), body)
    #     elif isinstance(src, All):  
    #         inner_constraints = self.interpret_polar_constraints(positive, ignore.union(src.ids), constraints, src.constraints)
    #         body = self.interpret_polar_typ(positive, ignore.union(src.ids), constraints, src.body)
    #         return All(src.ids, tuple(inner_constraints), body)

    #     elif isinstance(src, LeastFP):  
    #         body = self.interpret_polar_typ(positive, ignore.add(src.id), constraints, src.body)
    #         return LeastFP(src.id, src.body)
    #     elif isinstance(src, Top):  
    #         return src
    #     elif isinstance(src, Bot):  
    #         return src
    #     else:
    #         return src

    # def interpret_polar_constraints(self, positive : bool, ignore : PSet[str], 
    #         outer_constraints : PSet[Subtyping], 
    #         inner_constraints : Iterable[Subtyping]
    # ) -> PSet[Subtyping]:
    #     result_inner_constraints : PSet[Subtyping] = s()
    #     for inner in inner_constraints:
    #         upper = self.interpret_polar_typ(positive, ignore, outer_constraints, inner.upper)
    #         lower = self.interpret_polar_typ(not positive, ignore, outer_constraints, inner.lower)

    #         result_inner_constraints = result_inner_constraints.add(Subtyping(lower, upper))
    #     return result_inner_constraints


    def interpret_id_strongest(self, constraints : PSet[Subtyping], id : str) -> Typ:
        result_typ : Typ = TVar(id) 
        for st in constraints:
            if st.upper == TVar(id): 
                if result_typ == TVar(id):
                    result_typ = st.lower
                else:
                    result_typ = Unio(result_typ, st.lower)
        return  result_typ


    def flip_constraints(self, old_id : str, constraints : PSet[Subtyping], new_id : str) -> PSet[Subtyping]:
        result_constraints : PSet[Subtyping] = pset()
        for st in constraints:
            assert st.lower == TVar(old_id) and isinstance(st.upper, Imp)
            left = st.upper.antec
            right = st.upper.consq
            result_constraints = result_constraints.add(Subtyping(make_pair_typ(left, right), TVar(new_id)))
        return result_constraints

    def sub_polar_constraints(self, greenlight : bool, constraints : Iterable[Subtyping], id : str, payload : Typ) -> PSet[Subtyping]:
        return pset(
            Subtyping(lower, upper)
            for st in constraints
            for lower in [self.sub_polar_typ(not greenlight, st.lower, id, payload)]
            for upper in [self.sub_polar_typ(greenlight, st.upper, id, payload)]
        )

    def sub_polar_typ(self, greenlight : bool, src : Typ, id : str, payload : Typ) -> Typ:
        if False:
            assert False
        elif isinstance(src, TVar) and src.id == id and greenlight:  
            return payload
        elif isinstance(src, TUnit):  
            return TUnit()
        # elif isinstance(src, TTag):  
        #     return TTag(src.label, self.sub_polar_typ(greenlight, src.body, id, payload))
        elif isinstance(src, TEntry):  
            return TEntry(src.label, self.sub_polar_typ(greenlight, src.body, id, payload))
        elif isinstance(src, Unio):  
            return Unio(
                self.sub_polar_typ(greenlight, src.left, id, payload),
                self.sub_polar_typ(greenlight, src.right, id, payload),
            )
        elif isinstance(src, Inter):  
            return Inter(
                self.sub_polar_typ(greenlight, src.left, id, payload),
                self.sub_polar_typ(greenlight, src.right, id, payload),
            )
        elif isinstance(src, Diff):  
            return Diff(
                self.sub_polar_typ(greenlight, src.context, id, payload),
                self.sub_polar_typ(not greenlight, src.subtraction, id, payload),
            )
        elif isinstance(src, Imp):  
            return Imp(
                self.sub_polar_typ(not greenlight, src.antec, id, payload),
                self.sub_polar_typ(greenlight, src.consq, id, payload),
            )

        elif isinstance(src, Exi):  
            if id in src.ids:
                return src
            else:
                return Exi(
                    src.ids,
                    tuple(self.sub_polar_constraints(greenlight, src.constraints, id, payload)),
                    self.sub_polar_typ(greenlight, src.body, id, payload),
                )

        elif isinstance(src, All):  
            if id in src.ids:
                return src
            else:
                return All(
                    src.ids,
                    tuple(self.sub_polar_constraints(greenlight, src.constraints, id, payload)),
                    self.sub_polar_typ(greenlight, src.body, id, payload),
                )
        elif isinstance(src, LeastFP):  
            if id == src.id:
                return src
            else:
                return LeastFP(
                    src.id,
                    self.sub_polar_typ(greenlight, src.body, id, payload)
                )
        elif isinstance(src, Top):  
            return src
        elif isinstance(src, Bot):  
            return src
        else:
            return src

    def extract_polar_vars_from_constraints(self, greenlight : bool, ignore : PSet[str], constraints : Iterable[Subtyping]) -> PSet[str]:
        return pset(
            id 
            for st in constraints
            for id in self.extract_polar_vars_from_typ(not greenlight, ignore, st.lower).union(
                self.extract_polar_vars_from_typ(greenlight, ignore, st.upper)
            )
        )

    def extract_polar_vars_from_typ(self, greenlight : bool, ignore : PSet[str], src : Typ) -> PSet[str]:
        if False:
            assert False
        elif isinstance(src, TVar) and greenlight:  
            return pset({src.id})
        elif isinstance(src, TUnit):  
            return pset({})
        elif isinstance(src, TEntry):  
            return self.extract_polar_vars_from_typ(greenlight, ignore, src.body)
        elif isinstance(src, Unio):  
            return self.extract_polar_vars_from_typ(greenlight, ignore, src.left).union(
                self.extract_polar_vars_from_typ(greenlight, ignore, src.right)
            )
        elif isinstance(src, Inter):  
            return self.extract_polar_vars_from_typ(greenlight, ignore, src.left).union(
                self.extract_polar_vars_from_typ(greenlight, ignore, src.right)
            )
        elif isinstance(src, Diff):  
            return self.extract_polar_vars_from_typ(greenlight, ignore, src.context).union(
                self.extract_polar_vars_from_typ(not greenlight, ignore, src.subtraction)
            )
        elif isinstance(src, Imp):  
            return self.extract_polar_vars_from_typ(not greenlight, ignore, src.antec).union(
                self.extract_polar_vars_from_typ(greenlight, ignore, src.consq)
            )

        elif isinstance(src, Exi):  
            return self.extract_polar_vars_from_constraints(greenlight, ignore.union(src.ids), src.constraints).union(
                self.extract_polar_vars_from_typ(greenlight, ignore.union(src.ids), src.body)
            )

        elif isinstance(src, All):  
            return self.extract_polar_vars_from_constraints(greenlight, ignore.union(src.ids), src.constraints).union(
                self.extract_polar_vars_from_typ(greenlight, ignore.union(src.ids), src.body)
            )
        elif isinstance(src, LeastFP):  
            return self.extract_polar_vars_from_typ(greenlight, ignore.add(src.id), src.body)
        elif isinstance(src, Top):  
            return pset({}) 
        elif isinstance(src, Bot):  
            return pset({}) 
        else:
            return pset({}) 

    def make_diff(self, world : World, pos : Typ, negs : list[Typ]) -> Typ:
        result = pos 
        for neg in negs:
            if not self.is_disjoint(world, result, neg):
                result = Diff(result, neg)
        return result

    def augment_branches_with_diff(self, ndbranches : list[NDBranch]) -> list[DBranch]:
        '''
        nil -> zero
        cons X -> succ Y 
        --------------------
        (nil,zero) | (cons X\\nil, succ Y)
        '''

        augmented_branches = []
        negs = []
        for ndbranch in ndbranches:
            augmented_branches += [
                DBranch(
                        result.world, 
                        self.make_diff(empty_world(), ndbranch.pattern, negs), 
                        result.typ)
                for result in ndbranch.results
            ]
            neg_fvs = extract_free_vars_from_typ(s(), ndbranch.pattern)  
            neg = (
                Exi(tuple(sorted(neg_fvs)), (), ndbranch.pattern)
                if neg_fvs else
                ndbranch.pattern 
            )
            negs += [neg]
        return augmented_branches 



    def is_disjoint(self, world : World, t1 : Typ, t2 : Typ) -> bool:
        """
        True iff certainly disjoint
        False if either inhabitable or disjoint
        """

        if False:
            assert False
        elif isinstance(t1, Inter):
            return self.is_disjoint(world, t1.left, t2) or self.is_disjoint(world, t1.right, t2)
        elif isinstance(t2, Inter):
            return self.is_disjoint(world, t1, t2.left) or self.is_disjoint(world, t1, t2.right)
        elif isinstance(t1, Diff):
            return self.check(world, t2, t1.subtraction)
        elif isinstance(t2, Diff):
            return self.check(world, t1, t2.subtraction)
        # elif isinstance(t1, TTag) and isinstance(t2, TTag):
        #     return t1.label != t2.label or (
        #         self.is_disjoint(world, t1.body, t2.body)
        #     ) 
        # elif isinstance(t1, TField) and isinstance(t2, TField) and t1.label == t2.label:
        #     return self.is_disjoint(world, t1.body, t2.body) 
        elif isinstance(t1, TEntry) and isinstance(t2, TEntry):
            return t1.label != t2.label or (
                self.is_disjoint(world, t1.body, t2.body)
            ) 

        elif isinstance(t2, Exi):
            renaming = self.make_renaming(t2.ids)
            constraints = world.constraints.union(sub_constraints(renaming, t2.constraints))
            body = sub_typ(renaming, t2.body)
            world = replace(world, constraints = constraints)
            return self.is_disjoint(world, t1, body) 
        else:
            return False

    # def is_solvable_relational_constraint(self, lower : Typ, upper : LeastFP) -> bool: 
    #     # but subbing in BOT could also weakenG if target is in negative position
    #     renaming : PMap[str, Typ] = pmap({upper.id : Top()})
    #     upper_body = sub_typ(renaming, upper.body)
    #     # NOTE: this is not circular because it's unrolled and TOP is subbed in for self reference 
    #     # NOTE: this check only cares about the local structure of the types
    #     # NOTE: consistency with the rest of the world is handled elsewhere
    #     return bool(self.check(empty_world(), lower, upper_body))

    def check(self, world : World, lower : Typ, upper : Typ) -> bool:
        try:
            return bool(self.make_checker().solve(world, lower, upper))
        except RecursionError as e:
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~
# check: RecursionError 
# ~~~~~~~~~~~~~~~~~~~~~~~
# lower:
# {concretize_typ(lower)}

# upper:
# {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            # raise e
            return False
        except InhabitableError:
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~
# check: InhabitableError 
# ~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            return False


    def infinite_potential(self, world : World, st : Subtyping) -> int:
        neg_vars = self.extract_polar_vars_from_constraints(False, s(), world.constraints.add(st)).difference(world.closedids)
        pos_vars = self.extract_polar_vars_from_constraints(True, s(), world.constraints.add(st)).difference(world.closedids)
        return len(list(neg_vars.intersection(pos_vars)))



    def is_compatible(self, lower : Typ, upper : LeastFP) -> bool:
        fresh_var = self.fresh_type_var()
        return self.is_record_key(lower) and all(
            any(
                key_path == case_path[:len(key_path)]
                for case_path in case_paths
            )
            for upper_body in [sub_typ(pmap({upper.id : fresh_var}), upper.body)]
            for case in linearize_unions(upper_body)
            for key_paths in [extract_paths(lower)]
            for case_paths in [extract_paths(case)]
            for key_path in key_paths
#             for thing in [
#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
# DEBUG:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
# lower
# {concretize_typ(lower)}

# key_paths: {key_paths}

# case:
# {concretize_typ(case)}

# case_paths: {case_paths}

# result: {not bool(key_paths.difference(case_paths))}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
#                 """)
            # ]
        )


    def learn_factored_constraints(self, world : World, lower : Typ, upper : LeastFP) -> list[World]:
        if self.is_compatible(lower, upper): 
            fids = extract_free_vars_from_typ(s(), lower)
            if not bool(fids.intersection(world.closedids)):
                factored_constraints = []
                for fid in fids:
                    factored_lower = TVar(fid) 
                    factored_uppers = find_factors_from_pattern(upper, lower, factored_lower)
                    assert factored_uppers
                    factored_upper = make_inter(list(factored_uppers))
                    factored_constraints.append(Subtyping(factored_lower, factored_upper))
                return self.solve_multi(world, factored_constraints) 
            else:
                return []
        else:
            return []
        

    def learn_or_check_relational_constraints(self, world : World, lower : Typ, upper : LeastFP) -> list[World]:
        # TODO: clean up this logic
        # CHECK (READ) 



        assumed_relational_typ = self.lookup_normalized_relational_typ(world, lower)
        if assumed_relational_typ != None:
            # print("~~~~~~ FIX A")
            # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
            ordered_paths = [k for (k,v) in extract_ordered_path_target_pairs(lower)]
            normalized_upper = normalize_least_fp(upper, ordered_paths)
            worlds = self.solve(world, assumed_relational_typ, normalized_upper)
            return worlds
        else:
            lower_fvs = extract_free_vars_from_typ(s(), lower)  
            closed_var_consistent = True 
            for fv in lower_fvs:
                if fv in world.closedids: 
                    upper_parts = pset(
                        st.upper
                        for st in world.constraints
                        if st.lower == TVar(fv)
                    ).union(find_factors(world, TVar(fv)))

                    some_parts_consistent = any(
                        all(
                            bool(self.solve(world, closed_part, factor))
                            for factor in find_factors_from_constraint(Subtyping(lower, upper), TVar(fv))
                        )
                        for closed_part in upper_parts
                        if not isinstance(closed_part, TVar) or closed_part.id in world.closedids 
                    )
                    closed_var_consistent = closed_var_consistent and some_parts_consistent

            if closed_var_consistent and bool(lower_fvs.difference(world.closedids)) and self.is_compatible(lower, upper):
                print(f"""
==============================================
SOLVABLE:
~~~~~~~~~~~~~~~~~~~~~~~~~
{concretize_typ(lower)} <: {concretize_typ(upper)}
==============================================
                """)
                # LEARN (WRITE) 
                # new_lower = self.interpret_polar_typ(True, world.closedids, world.constraints, lower)

                
                m = self.interpret_ids_polar(True, extract_free_vars_from_constraints(world.closedids, world.constraints), world.constraints)
                new_lower = sub_typ(m, lower)
                if new_lower != lower:
                    lower_fvs = extract_free_vars_from_typ(s(), lower)  
                    return [
                        new_world
                        for world in self.solve(world, new_lower, upper)
                        for new_world in [replace(world, 
                            constraints = world.constraints.add(Subtyping(lower, upper)),
                            relids = world.relids.union(lower_fvs)
                        )]
                        # if self.ensure_upper_intersection_inhabitable(new_world, lower.id, upper)
                    ]
                else:
                    return [replace(world, 
                        constraints = world.constraints.add(Subtyping(lower, upper)),
                        relids = world.relids.union(lower_fvs)
                    )]
                #end if
            else:
                return []

    def solve_multi(self, world : World, constraints : Iterable[Subtyping]) -> list[World]:
        worlds = [world]
        for st in constraints:
            worlds = [
                w1
                for w0 in worlds
                for w1 in self.solve(w0, st.lower, st.upper)
            ]
        return worlds
        #############################

        # priorities = list(constraints)
        # for st in priorities:
        #     if st not in self.priority_map:
        #         self.priority_map[st] = self.infinite_potential(world, st) 

        # def key(st):
        #     i = self.priority_map.get(st)
        #     if i == None:
        #         return 0 
        #     else:
        #         return i 

        # priorities.sort(key=key)

        # worlds : list[World] = [world]

        # for st in priorities:
        #     all_solutions = []
        #     for world in worlds:
        #         solutions = self.solve(world, st.lower, st.upper)
        #         if solutions:
        #             self.priority_map[st] = 1 
        #         else:
        #             self.priority_map[st] = 2 
        #         all_solutions = all_solutions + solutions
        #     worlds = all_solutions
        # return worlds


    def solve_plastic_elimination(self, world : World, lower : TVar, upper : Typ) -> list[World]:
        constraints = [
            Subtyping(st.lower, upper)
            for st in world.constraints
            if st.upper == lower
        ]
        return [
            replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
            for w0 in self.solve_multi(world, constraints)
        ]
        ###### Relational ##########
        constraints = self.sub_polar_constraints(True, world.constraints, lower.id, upper)
        subbed_constraints = list(constraints.difference(world.constraints))
        return [
            replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
            for w0 in self.solve_multi(world, subbed_constraints)
        ]
        #########################


    def solve_plastic_introduction(self, world : World, lower : Typ, upper : TVar) -> list[World]:
        constraints = [
            Subtyping(lower, st.upper)
            for st in world.constraints
            if st.lower == upper
        ]
        return [
            replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
            for w0 in self.solve_multi(world, constraints)
        ]
        ####### Relational ############
        constraints = self.sub_polar_constraints(False, world.constraints, upper.id, lower)
        subbed_constraints = list(constraints.difference(world.constraints))
        return [
            replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
            for w0 in self.solve_multi(world, subbed_constraints)
        ]
        ##########################

    def is_finite_paths_typ(self, t : Typ) -> bool:
        if isinstance(t, Imp): 
            return True
        elif isinstance(t, Inter): 
            return self.is_finite_paths_typ(t.left) and self.is_finite_paths_typ(t.right)
        else:
            return False

    def is_record_key(self, t : Typ) -> bool:
        if isinstance(t, TVar):
            return True
        elif isinstance(t, TEntry):
            return self.is_record_key(t.body)
        elif isinstance(t, Inter):
            return self.is_record_key(t.left) and self.is_record_key(t.right)
        else:
            return False

    def is_pattern_typ(self, t : Typ) -> bool:
        if isinstance(t, TVar):
            return True
        if isinstance(t, TUnit):
            return True
        # elif isinstance(t, TTag):
        #     return self.is_pattern_typ(t.body)
        elif isinstance(t, TEntry):
            return self.is_pattern_typ(t.body)
        elif isinstance(t, Inter):
            return self.is_pattern_typ(t.left) and self.is_pattern_typ(t.right)
        else:
            return False

    def is_guarded_typ(self, t : Typ) -> bool:
        return isinstance(t, TUnit) or isinstance(t, TEntry)

    def is_subtractable_typ(self, t : Typ) -> bool:
        return (
            (
                self.is_pattern_typ(t) or
                isinstance(t, Top) or
                (
                    isinstance(t, Exi) and
                    self.is_pattern_typ(t.body) and
                    # self.is_negatable_typ(world, t.body) and
                    not bool(t.constraints)
                    # not self.are_negatable_constraints(world, t.constraints)
                )
            ) and
            not bool(extract_free_vars_from_typ(s(), t))
        )

    def is_negatable_constraint(self, world : World, lower : Typ, upper : Typ) -> bool:
            return (
                self.is_subtractable_typ(upper) or 
                (
                    isinstance(lower, TVar) and
                    lower not in world.closedids and
                    all(
                        wst.upper == Top()
                        for wst in world.constraints
                        if wst.lower == lower 
                    )
                ) or
                # TODO: is inflatable check actually needed?
                # TODO: does inflatable imply completeness of subtyping?
                (isinstance(upper, LeastFP) and is_inflatable(lower, upper))
                # False
            )

    def are_negatable_constraints(self, world : World, constraints : Iterable[Subtyping]) -> bool:
        return all(
            self.is_negatable_constraint(world, st.lower, st.upper)
            for st in constraints
        )



    def is_base_typ(self, t : Typ) -> bool:
        return (
            # isinstance(t, TTag) or
            isinstance(t, TEntry) or
            isinstance(t, Imp)
        )

    def is_relational_key(self, t : Typ) -> bool:
        if isinstance(t, TEntry):
            return True
        elif isinstance(t, Inter):
            return self.is_relational_key(t.left) and self.is_relational_key(t.right)
        else:
            return False

    def is_refinement_typ(self, t : Typ) -> bool:
        return (
            isinstance(t, Top) or
            isinstance(t, Inter) or
            isinstance(t, Diff) or
            isinstance(t, All)
        )

    def is_abstraction_typ(self, t : Typ) -> bool:
        return (
            isinstance(t, Bot) or
            isinstance(t, Unio) or
            isinstance(t, LeastFP) or
            isinstance(t, Exi)
        )


    # def check_closed_variable_elimination(self, world : World, lower : TVar, upper : Typ) -> bool:
    #     upper_parts = pset(
    #         st.upper
    #         for st in world.constraints
    #         if st.lower == lower 
    #     ).union(find_factors(world, lower))

    #     some_parts_consistent = lambda : any(
    #         (
    #             (isinstance(upper_part, TVar) and upper_part.id not in world.closedids) 
    #             or bool(self.solve(world, upper_part, upper))
    #         )
    #         for upper_part in upper_parts
    #     )

    #     constraints = self.sub_polar_constraints(True, world.constraints, lower.id, upper)
    #     subbed_constraints = list(constraints.difference(world.constraints))
    #     all_parts_consistent = lambda : bool(self.solve_multi(world, subbed_constraints))

    #     return all_parts_consistent() and some_parts_consistent()

    def solve_skolem_elimination(self, world : World, lower : TVar, upper : Typ) -> list[World]:
        upper_parts = pset(
            st.upper
            for st in world.constraints
            if st.lower == lower 
        ).union(find_factors(world, lower))

        worlds = []
        if any(
            isinstance(upper_part, TVar) and upper_part.id not in world.closedids
            for upper_part in upper_parts
        ):
            worlds = self.solve_plastic_elimination(world, lower, upper)
        if worlds:
            return worlds
        else:
            closed_upper_parts = [
                upper_part
                for upper_part in upper_parts
                if not isinstance(upper_part, TVar) or upper_part.id in world.closedids
            ]
            worlds = []
            for upper_part in closed_upper_parts:
                worlds += self.solve(world, upper_part, upper)
            return worlds


    # def solve_skolem_elimination_imprecise(self, world : World, lower : TVar, upper : Typ) -> list[World]:
    #     upper_parts = pset(
    #         st.upper
    #         for st in world.constraints
    #         if st.lower == lower 
    #         if not isinstance(st.upper, TVar) or st.upper.id in world.closedids
    #     ).union(find_factors(world, lower))

    #     worlds = []
    #     for upper_part in upper_parts:
    #         worlds += self.solve(world, upper_part, upper)

    #     return [
    #         replace(w, constraints = w.constraints.add(Subtyping(lower, upper))) 
    #         for w in worlds
    #     ]

    def solve_skolem_introduction(self, world : World, lower : Typ, upper : TVar) -> list[World]:
        lower_parts = pset(
            st.lower
            for st in world.constraints
            if st.upper == upper 
        )

        worlds = []
        if any( 
            (isinstance(lower_part, TVar) and lower_part.id not in world.closedids)
            for lower_part in lower_parts
        ): 
            worlds = self.solve_plastic_introduction(world, lower, upper)
        if worlds:
            return worlds
        else:
            closed_lower_parts = [
                lower_part
                for lower_part in lower_parts
                if not isinstance(lower_part, TVar) or lower_part.id in world.closedids
            ]
            worlds = []
            for lower_part in closed_lower_parts:
                worlds += self.solve(world, lower, lower_part)
            return worlds

    # def solve_skolem_introduction_imprecise(self, world : World, lower : Typ, upper : TVar) -> list[World]:
    #     lower_parts = pset(
    #         st.lower
    #         for st in world.constraints
    #         if st.upper == upper 
    #         if not isinstance(st.lower, TVar) or st.lower.id in world.closedids
    #     )
    #     worlds = []
    #     for lower_part in lower_parts:
    #         worlds += self.solve(world, lower, lower_part)
    #     return worlds



    # def closed_constraints_safe(self, world : World, constraints : PSet[Subtyping]) -> bool:
    #     return all(
    #         (False
    #             or not isinstance(st.lower, TVar) 
    #             or (st.lower.id not in world.closedids)
    #             or bool(self.solve_skolem_elimination(world, st.lower, st.upper))
    #         ) and
    #         (False
    #             or not isinstance(st.upper, TVar) 
    #             or (st.upper.id not in world.closedids)
    #             or bool(self.solve_skolem_introduction(world, st.lower, st.upper))
    #         )
    #         for st in constraints
    #     )

    def found(self, t : LeastFP) -> LeastFP:
        # NOTE: weaken from an increasing LFP to a decreasing LFP
        content = self.simplify_typ(t.body)  
        if isinstance(content, Exi) and isinstance(content.body, TVar):
            choices = [
                self.sub_polar_typ(True, st.lower, content.body.id, TVar(t.id))
                for st in content.constraints
                if isinstance(st.upper, TVar) and st.upper.id == t.id
            ] + [content.body]
            return LeastFP(t.id, make_unio(choices))
        else:
            return t
            

    def solve(self, world : World, lower : Typ, upper : Typ, reset = False) -> list[World]:
        self.count += 1
        if reset:
            self.count = 0

        if self.count > self._limit:
            return []

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG SOLVE:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# count: {self.count}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# closed:
# {world.closedids}

# constraints:
# {concretize_constraints(world.constraints)}
              
# |-
# {concretize_typ(lower)}
# <:
# {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)

        #######################################
        #### Reflection ####
        #######################################


        if alpha_equiv(lower, upper): 
            return [world] 

        #######################################
        #### Reflection ####
        #######################################

        elif isinstance(lower, Bot): 
            return [world] 

        elif isinstance(upper, Top): 
            return [world] 

        #######################################
        #### Dealiasing ####
        #######################################
        elif isinstance(upper, TVar) and upper.id in self.aliasing: 
            return self.solve(world, lower, self.aliasing[upper.id])

        elif isinstance(lower, TVar) and lower.id in self.aliasing: 
            return self.solve(world, self.aliasing[lower.id], upper)

        #######################################
        #### Base Preservation ################
        #######################################

        elif isinstance(lower, TUnit) and isinstance(upper, TUnit): 
            return [world] 

        # elif isinstance(lower, TTag) and isinstance(upper, TTag): 
        #     if lower.label == upper.label:
        #         return self.solve(world, lower.body, upper.body) 
        #     else:
        #         return [] 

        elif isinstance(lower, TEntry) and isinstance(upper, TEntry): 
            if lower.label == upper.label:
                return self.solve(world, lower.body, upper.body) 
            else:
                return [] 

        elif isinstance(lower, Imp) and isinstance(upper, Imp): 
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG IMP IMP
# ~~~~~~~~~~~~~~~~~~~~~~~
# count: {self.count}
# ~~~~~~~~~~~~~~~~~~~~~~~
# {concretize_typ(lower)}
# <:
# {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~
# skolems:
# {world.closedids}

# constraints:
# {concretize_constraints(world.constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            worlds = [
                m1
                # TODO: consider switching order
                # NOTE: to add relational constraint in consequent before checking antecedent

                for m0 in self.solve(world, upper.antec, lower.antec) 
                for m1 in self.solve(m0, lower.consq, upper.consq) 

                # for m0 in self.solve(world, lower.consq, upper.consq) 
                # for m1 in self.solve(m0, upper.antec, lower.antec) 
            ]
            return worlds

        #######################################
        ####  Abstraction Elimination #########
        #######################################


        elif isinstance(lower, Unio):
            return [
                m1
                for m0 in self.solve(world, lower.left, upper)
                for m1 in self.solve(m0, lower.right, upper)
            ]

        elif isinstance(lower, Exi):
            renaming = self.make_renaming(lower.ids)
            strong_constraints = sub_constraints(renaming, lower.constraints)
            lower_body = sub_typ(renaming, lower.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            worlds = [world]
            for constraint in strong_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    # for m1 in self.solve_or_cache(m0, constraint.lower, constraint.upper)
                    for m1 in self.solve(m0, constraint.lower, constraint.upper)
                ]  

            # TODO: modify to ensure qualifiers are decidable (thus, complete) 
            # TODO: restriction should make world unique 
            # TODO: if multiple contextual worlds, then final solutions should be crossed with previous solutions

            return [
                m2
                for m0 in worlds
                for m1 in [replace(m0, closedids = m0.closedids.union(renamed_ids))]
                for m2 in self.solve(m1, lower_body, upper)
            ]

#         elif isinstance(lower, LeastFP) and not isinstance(upper, LeastFP):
#             # TODO: modify rewriting to ensure relational constraint has at least a pair of variables
#             # to avoid infinitue  back into the original problem, causing non-termination
#             '''
#             NOTE: rewrite into existential making shape of relation visible
#             - allows matching shapes even if unrolling is undecidable
#             '''
#             paths = extract_relational_paths(lower)
#             if bool(paths):
#                 rnode = RNode(m()) 
#                 tvars = []
#                 for path in paths:
#                     tvar = self.fresh_type_var()
#                     assert isinstance(rnode, RNode)
#                     rnode = insert_at_path(rnode, path, tvar)
#                     tvars.append(tvar)
#                 # end for

#                 key = to_record_typ(rnode) 
#             else:
#                 tvar = self.fresh_type_var()
#                 tvars = [tvar]
#                 key = tvar

#             exi = Exi(tuple(t.id for t in tvars), tuple([Subtyping(key, lower)]), key)

#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG new constraint
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# original:
# {concretize_typ(lower)} <: {concretize_typ(upper)}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# rewritten:
# {concretize_typ(exi)} <: {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)

#             return self.solve(world, exi, upper)

        #######################################
        #### Refinement Introduction ##########
        #######################################

        elif isinstance(upper, Inter):
            return [
                m1 
                for m0 in self.solve(world, lower, upper.left)
                for m1 in self.solve(m0, lower, upper.right)
            ]

        elif isinstance(upper, All):
            renaming = self.make_renaming(upper.ids)
            weak_constraints = sub_constraints(renaming, upper.constraints)
            weak_body = sub_typ(renaming, upper.body)
            renamed_ids = (t.id for t in renaming.values() if isinstance(t, TVar))

            worlds = [world]
            for constraint in weak_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.lower, constraint.upper)
                ]  

            return [
                m2
                for m0 in worlds
                for m1 in [replace(m0, closedids = m0.closedids.union(renamed_ids))]
                for m2 in self.solve(m1, lower, weak_body)
            ]




        #######################################
        #### Plastic Elimination #############
        #######################################

        elif isinstance(lower, TVar) and lower.id not in world.closedids:
            worlds = self.solve_plastic_elimination(world, lower, upper)
            if isinstance(upper, TVar) and upper.id not in world.closedids: 
                worlds = [
                    w1
                    for w0 in worlds 
                    for w1 in self.solve_plastic_introduction(w0, lower, upper) 
                ]
            return worlds 

        #######################################
        #### Plastic Introduction #############
        #######################################

        elif isinstance(upper, TVar) and upper.id not in world.closedids: 
            return self.solve_plastic_introduction(world, lower, upper)



        #######################################
        #### Skolem Introduction #############
        #######################################

        # elif isinstance(upper, TVar) and upper.id in world.closedids and (not isinstance(lower, TVar) or lower.id in world.closedids): 
        # elif isinstance(upper, TVar) and upper.id in world.closedids and (not isinstance(lower, TVar)): 
        elif isinstance(upper, TVar) and upper.id in world.closedids: 
            return self.solve_skolem_introduction(world, lower, upper)

        #######################################
        #### Skolem Elimination #############
        #######################################

        # elif isinstance(lower, TVar) and lower.id in world.closedids and (not isinstance(upper, TVar) or upper.id not in world.closedids): 
        # elif isinstance(lower, TVar) and lower.id in world.closedids and (not isinstance(upper, TVar)): 
        elif isinstance(lower, TVar) and lower.id in world.closedids: 
            return self.solve_skolem_elimination(world, lower, upper)






        #######################################
        #### Implication Rewriting ############
        #######################################


        elif isinstance(upper, Imp) and isinstance(upper.antec, Unio):
            return self.solve(world, lower, Inter(
                Imp(upper.antec.left, upper.consq), 
                Imp(upper.antec.right, upper.consq)
            ))

        elif isinstance(upper, Imp) and isinstance(upper.consq, Inter):
            return self.solve(world, lower, Inter(
                Imp(upper.antec, upper.consq.left), 
                Imp(upper.antec, upper.consq.right)
            ))

        elif isinstance(upper, TEntry) and isinstance(upper.body, Inter):
            return [
                m1
                for m0 in self.solve(world, lower, TEntry(upper.label, upper.body.left))
                for m1 in self.solve(m0, lower, TEntry(upper.label, upper.body.right))
            ]

        elif isinstance(upper, Imp) and isinstance(upper.antec, LeastFP):
            param_typ = self.fresh_type_var()
            universal_typ = All(
                tuple([param_typ.id]), 
                tuple([Subtyping(param_typ, upper.antec)]), 
                Imp(param_typ, upper.consq)
            )
            return self.solve(world, lower, universal_typ)


        #######################################
        #### Diff Introduction #############
        #######################################

        elif isinstance(upper, Diff):
            ######
            # NOTE:
            # must ensure that the subtracted type does 
            # not intersect with the lower type 
            ######
            # if subtraction is subtractable, then it cannot partially overlap 
            # therefore, checking subtyping in both directions is sufficient
            ######
            if (
                self.is_subtractable_typ(upper.subtraction) and 
                not bool(self.solve(world, lower, upper.subtraction)) and 
                self.is_negatable_constraint(world, upper.subtraction, lower) and
                not bool(self.solve(world, upper.subtraction, lower)) and
                True
            ):
                return self.solve(world, lower, upper.context)
            else:
                return []

        #######################################
        #### Fixpoint Elimination #############
        #######################################

        elif isinstance(lower, LeastFP):
            factor = (
                find_factor_from_label(lower, upper.label)
                if isinstance(upper, TEntry) else
                None
            )
            if factor and isinstance(upper, TEntry):
                return self.solve(world, factor, upper.body)
            elif isinstance(lower.body, Imp) and lower.id not in extract_free_vars_from_typ(s(), lower.body.antec):
                # TODO: add distribution rule to paper
                dist_lower = Imp(lower.body.antec, LeastFP(lower.id, lower.body.consq))
                return self.solve(world, dist_lower, upper)
            elif lower.id not in extract_free_vars_from_typ(s(), lower.body):
                return self.solve(world, lower.body, upper)
            else:
                renaming : PMap[str, Typ] = pmap({lower.id : upper})
                lower_body = self.sub_polar_typ(True, lower.body, lower.id, upper)
                if (lower.id in extract_free_vars_from_typ(s(), lower_body)):
                    return []
                else:
                    return self.solve(world, lower_body, upper)
                # end-if



        #######################################
        #### Fixpoint Introduction #############
        #######################################

        elif isinstance(upper, LeastFP): 

            if is_inflatable(lower, upper): # TODO: make is_deciable more strict
                renaming : PMap[str, Typ] = pmap({upper.id : upper})
                upper_body = sub_typ(renaming, upper.body)
                worlds = self.solve(world, lower, upper_body)
                return worlds
            else :
                #############################################
                ##### OLD Relational constraint reasoning
                #############################################
                # worlds = self.learn_or_check_relational_constraints(world, lower, upper)
                # ################
                # if worlds:
                #     return worlds
                # else:
                # ################
                strengthened_upper = make_unio([
                    case
                    for case in linearize_unions(upper.body)
                    if upper.id not in extract_free_vars_from_typ(s(), case)
                ])
                worlds = self.solve(world, lower, strengthened_upper)
                return worlds


        #######################################
        #### Abstraction Introduction #########
        #######################################

        # elif isinstance(upper, Unio) and (self.is_base_typ(lower) or self.is_pattern_typ(lower)): 
        elif isinstance(upper, Unio): 
            return self.solve(world, lower, upper.left) + self.solve(world, lower, upper.right)

        elif isinstance(upper, Exi):
            # and self.are_negatable_constraints(world, upper.constraints):
            renaming = self.make_renaming(upper.ids)
            weak_constraints = sub_constraints(renaming, upper.constraints)
            weak_body = sub_typ(renaming, upper.body)
            worlds = self.solve(world, lower, weak_body) 
            for constraint in weak_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    for m1 in self.solve(m0, constraint.lower, constraint.upper)
                ]
            return worlds

        #######################################
        #### Refinement Elimination ###########
        #######################################

        # elif isinstance(lower, Inter) and self.is_base_typ(upper) : 
        # elif isinstance(lower, Inter) and (not isinstance(upper, Fixpoint)
        #     # and not isinstance(upper, Unio)
        #     # and not isinstance(upper, Exi)
        # ) : 
        elif isinstance(lower, Inter):
            worlds = self.solve(world, lower.left, upper) + self.solve(world, lower.right, upper)
            if worlds:
                return worlds
            # elif isinstance(upper, Imp) and self.is_finite_paths_typ(lower):
            elif isinstance(upper, Imp):
                paths = linearize_intersections(lower)
                param_types = []
                return_types = []
                for path in paths:
                    if not isinstance(path, Imp):
                        return []
                    param_types.append(path.antec)
                    return_types.append(path.consq)
                return self.solve(world, Imp(make_unio(param_types), make_unio(return_types)), upper)
            else:
                return []
                

        elif isinstance(lower, All): 
            renaming = self.make_renaming(lower.ids)
            strong_constraints = sub_constraints(renaming, lower.constraints)
            lower_body = sub_typ(renaming, lower.body)
            worlds = self.solve(world, lower_body, upper) 
            for constraint in strong_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    # for m1 in self.solve_or_cache(m0, constraint.lower, constraint.upper)
                    for m1 in self.solve(m0, constraint.lower, constraint.upper)
                ]

            return worlds

        #######################################
        #### Diff Elimination #############
        #######################################

        elif isinstance(lower, Diff):
            if diff_well_formed(lower):
                '''
                A \\ B <: T === A <: T | B  
                '''
                return self.solve(world, lower.context, Unio(upper, lower.subtraction))
            else:
                return []


        #######################################
        #### Otherwise Failure ################
        #######################################
        else:
            return []



    '''
    end solve
    '''

    # def is_relation_constraint_wellformed(self, world : World, strong : Typ, weak : LeastFP) -> bool:
    #     # TODO: check that key (strong) can match the pattern in each case
    #     factored = factor_least(weak)
    #     worlds = self.solve(world, strong, factored)  
    #     return bool(worlds)

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
    def __init__(self, solver : Solver, light_mode : bool = False):
        self.solver = solver
        # TODO: split all rules into two modes
        self.light_mode = light_mode

#     def evolve_worlds(self, contexts : list[Context], t : Typ) -> list[World]:
# #         print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # DEBUG evolve_worlds
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # nt.enviro: {nt.enviro}
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# #         """)
#         return [
#             m1
#             for m0 in nt.worlds
#             for m1 in self.solver.solve(m0, 
#                 t, 
#                 nt.typ_var
#             )
#         ]

# @dataclass(frozen=True, eq=True)
# class WorldTyp:
#     world: World
#     typ: Typ

@dataclass(frozen=True, eq=True)
class Result:
    pid : int #problem id
    world: World
    typ: Typ

MulitResult = list[Result]


class BaseRule(Rule):

    def combine_var(self, pid : int, enviro : Enviro, world : World, id : str) -> list[Result]:
        if id in enviro:
            return [Result(pid, world, enviro[id])]
        else:
            return []

    def combine_assoc(self, pid : int, world : World, typs : list[Typ]) -> list[Result]:
        if len(typs) == 1:
            return [Result(pid, world, typs[0])]
        else:
            applicator = typs[0]
            arguments = typs[1:]
            results = ExprRule(self.solver).combine_application(pid, world, applicator, arguments) 
            return results

    def combine_unit(self, pid : int, world : World) -> Result:
        return Result(pid, world, TUnit())

    def combine_tag(self, pid : int, world : World, label : str, body : TVar) -> Result:
        # return Result(pid, world, TTag(label, body))
        return Result(pid, world, TEntry(label, body))

    # def combine_record(self, context : Context, record_result : RecordResult) -> list[Result]:
    #     result = Top() 
    #     for branch in reversed(record_result.branches): 
    #         # (body_typ, body_used_constraints) = self.solver.interpret_with_polarity(True, new_world, branch.body, s())
    #         body_typ = branch.body
    #         # new_world = World(new_world.constraints.difference(body_used_constraints), new_world.skolems, new_world.relids)

    #         field = TField(branch.label, body_typ)
    #         ######## NOTE: no generalization since the negative position is merely a label #############
    #         ######## NOTE: However; it can use universal type for its conditional constraints ##########
    #         constraints = tuple(extract_reachable_constraints_from_typ(branch.world, field))
    #         if constraints:
    #             constrained_field = All((), constraints, field)
    #         else:
    #             constrained_field = field 
    #         #############################################
    #         result = Inter(constrained_field, result)
    #     '''
    #     end for 
    #     '''

    #     # return TypingResult(nt.worlds, simplify_typ(result))
    #     return [Result(context.enviro, context.world, result)]

    # TODO: redo Context such that it only has a single world as input
    def combine_function(self, pid : int, enviro : Enviro, world : World, function_branches : list[NDBranch]) -> Result:
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

        foreignids = extract_free_vars_from_enviro(enviro).union(extract_free_vars_from_constraints(s(), world.constraints))
        # NOTE: worlds are intersected
        # TODO: need to extrude to not lose constraints on foreign variables
        augmented_branches = self.solver.augment_branches_with_diff(function_branches)
        generalized_branches = []

        for branch in augmented_branches: 
            local_constraints = branch.world.constraints.difference(world.constraints)
            local_closedids = branch.world.closedids.difference(world.closedids)

            ######### TIDY UP #############
            param_ids = extract_free_vars_from_typ(foreignids.union(local_closedids), branch.pattern)
            body_ids= extract_free_vars_from_typ(foreignids.union(local_closedids).union(param_ids), branch.body)
            m_left = self.solver.interpret_ids_polar(False, param_ids, local_constraints)
            m_right = self.solver.interpret_ids_polar(True, body_ids, local_constraints)
            # imp = Imp(branch.pattern, sub_typ(m_right, branch.body))
            imp = Imp(sub_typ(m_left, branch.pattern), sub_typ(m_right + m_left, branch.body))


            # imp = self.solver.interpret_polar_typ(
            #     True, 
            #     foreignids.union(local_closedids), local_constraints, 
            #     Imp(branch.pattern, branch.body)
            # )

            influential_ids = foreignids.union(local_closedids).union(extract_free_vars_from_typ(s(), imp))
            influential_constraints = filter_constraints_by_all_variables(local_constraints, influential_ids)
            ######### END TIDY UP #############

            generalized_case = self.solver.make_constraint_typ(True)( 
                foreignids, 
                local_closedids,
                influential_constraints, 
                imp
            )

            generalized_branches = generalized_branches + [generalized_case]
        '''
        end for 
        '''
        return Result(pid, world, make_inter(generalized_branches))
    '''
    end def
    '''

class ExprRule(Rule):

    def combine_tuple(self, pid : int, world : World, head_typ : Typ, tail_typ : Typ) -> Result:
        return Result(pid,  world, Inter(TEntry('head', head_typ), TEntry('tail', tail_typ)))

    def combine_ite(self, pid : int, enviro : Enviro, world : World, condition_typ : Typ, 
        true_body_results: list[Result], 
        false_body_results: list[Result] 
    ) -> list[Result]: 
        # ndbranches = [
        #     NDBranch(TTag('true', TUnit()), true_body_results),
        #     NDBranch(TTag('false', TUnit()), false_body_results)
        # ]
        ndbranches = [
            NDBranch(TEntry('true', TUnit()), true_body_results),
            NDBranch(TEntry('false', TUnit()), false_body_results)
        ]

        function_result = BaseRule(self.solver).combine_function(pid, enviro, world, ndbranches)
        return self.combine_application(pid, function_result.world, function_result.typ, [condition_typ])

    def combine_projection(self, pid : int, world : World, record_typ : Typ, keys : list[str]) -> list[Result]: 
        worlds = [world] 
        for key in keys:
            result_var = self.solver.fresh_type_var()
            worlds = [
                m1
                for m0 in worlds
                for m1 in self.solver.solve(m0, record_typ, TEntry(key, result_var))
            ]
            record_typ = result_var
        return [
            Result(pid, world, result_var)
            for world in worlds
        ]

    #########



    def combine_application(self, pid : int, world : World, cator_typ : Typ, arg_typs : list[Typ]) -> List[Result]: 
        zones = [(world, cator_typ)] 
        for arg_typ in arg_typs:
            result_var = self.solver.fresh_type_var()
            new_zones = []
            for world, current_cator_typ in zones:
                # TODO: pass in enviro to get foreign vars 
                # foreignids = extract_free_vars_from_enviro(world.enviro).union(extract_free_vars_from_constraints(s(), world.constraints))
                # foreignids = extract_free_vars_from_constraints(s(), world.constraints)
                new_zones.extend([
                    (w, result_var)
                    for w in self.solver.solve(world, current_cator_typ, Imp(arg_typ, result_var), reset=True)
                ])
                zones = new_zones

        print(f"zones found: {len(zones)}")

        for i, (w, result) in enumerate(zones):

            print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG application result world {i}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
skolems:
{w.closedids} 

constraints:
{concretize_constraints(w.constraints)}

result:
{concretize_typ(result)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)

        return [
            Result(pid, world, t)
            for world, t in zones 
        ]



#         ats = [
#             concretize_typ(at)
#             for at in arg_typs
#         ]

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine application
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# skolems:
# {world.closedids} 

# constraints:
# {concretize_constraints(world.constraints)}


# cator_typ:
# {concretize_typ(cator_typ)}

# arg_typs:
# {ats}

# result_var: {result_var.id}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)


    #########

    def combine_funnel(self, pid : int, world : World, arg_typ : Typ, cator_typs : list[Typ]) -> list[Result]: 

        results = [Result(pid, world, arg_typ)]
        for cator_typ in cator_typs: 
            results = [
                result1
                for result0 in results
                for result1 in self.combine_application(pid, result0.world, cator_typ, [arg_typ])
            ]
        return results

        # worlds = [nt.world]
        # for cator_typ in cator_typs:
        #     app_nt = replace(nt, worlds = worlds) 
        #     app_result = self.combine_application(app_nt, cator_typ, [arg_typ])
        #     worlds = app_result.worlds
        #     result_typ = app_result.typ
        #     arg_typ = result_typ 

        # # NOTE: add final constraint to connect to expected type var: the result_typ <: nt.typ_var
        # return [
        #     TypingResult(world, result_typ)
        #     for world in worlds
        # ]

    def combine_fix(self, pid : int, enviro : Enviro, world : World, body_typ : Typ) -> Result:
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

        outer_world = world

        foreignids = extract_free_vars_from_enviro(enviro).union(extract_free_vars_from_constraints(s(), world.constraints))

        inner_locales = [
            (w, left_typ, right_typ) 
            for inner_world in self.solver.solve(outer_world, body_typ, Imp(self_typ, Imp(in_typ, out_typ)))
            for local_constraints in [inner_world.constraints.difference(world.constraints)]
            for left_typ in [self.solver.interpret_id_weakest(local_constraints, in_typ.id)] 
            for right_typ in [self.solver.interpret_id_strongest(local_constraints, out_typ.id)]
            for pre_right_typ in [self.solver.interpret_id_strongest(local_constraints, out_typ.id)]
            for (right_typ, right_constraints) in [
                # TODO: handle recursion nested in function
                [
                    (right_body, right_constraints)
                    for renaming in [self.solver.make_renaming(pre_right_typ.ids)]
                    for right_constraints in [sub_constraints(renaming, pre_right_typ.constraints)]
                    for right_body in [sub_typ(renaming, pre_right_typ.body)]
                ][-1]
                if isinstance(pre_right_typ, All) else
                (pre_right_typ, [])
            ]
            for w in self.solver.solve_multi(inner_world, right_constraints)
            # for w in [inner_world]
        ]

        left_unstructured_vars = pset(
            left_typ.id
            for (inner_world, left_typ, right_typ) in inner_locales
            if (len(inner_locales) == 1)
            if isinstance(left_typ, TVar) 
        )
        foreignids = foreignids.union(left_unstructured_vars)

        # TODO: 
        # - extrude param type variables, and replace positive occurences in result 
        # - replace pattern with extrusions.  
        # - add constraint that the weakened inferred param type subtypes the extrusion


        # LFP[W] EXI[T] (<succ> T <: W):T <: <succ> T' 
        # LFP[W] EXI[T] T | <succ> W  <: <succ> T' 
        #  EXI[T] T | <succ> <succ> T'  <: <succ> T' 

        induc_body = Bot()
        for i, (inner_world, left_typ, right_typ) in enumerate(reversed(inner_locales)):
            ###### TODO: ensure that the assertion is invariant
            assert in_typ.id not in inner_world.relids
            local_constraints = inner_world.constraints.difference(world.constraints)

            local_closedids = inner_world.closedids.difference(world.closedids) 

            rel_pattern = make_pair_typ(left_typ, right_typ)


            influential_ids = foreignids.union([self_typ.id]).union(local_closedids).union(extract_free_vars_from_typ(s(), rel_pattern))
            influential_constraints = filter_constraints_by_all_variables(local_constraints, influential_ids)

            print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMBINE FIX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

goal:
{concretize_typ(body_typ)} <: {concretize_typ(Imp(self_typ, Imp(in_typ, out_typ)))}

IH_typ.id
{IH_typ.id}


local constraints:
{concretize_constraints(local_constraints)}

influential constraints:
{concretize_constraints(influential_constraints)}


left_typ:
{concretize_typ(left_typ)}

right_typ:
{concretize_typ(right_typ)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)

            flipped_constraints = self.solver.flip_constraints(self_typ.id, influential_constraints, IH_typ.id)

            constrained_rel = self.solver.make_constraint_typ(False)(
                foreignids.union(world.closedids).union([IH_typ.id]), 
                inner_world.closedids.difference(world.closedids), 
                flipped_constraints, 
                rel_pattern
            )
            induc_body = Unio(constrained_rel, induc_body) 
        #end for

        rel_typ = LeastFP(IH_typ.id, induc_body)

        print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMBINE FIX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rel_typ:
{concretize_typ(rel_typ)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        """)

        ################################################
        # NEW Relational Type Option B
        ################################################
        # param_var = self.solver.fresh_type_var()
        # param_typs = find_factors_from_pattern(rel_typ, TEntry("head", param_var), param_var)
        # assert len(param_typs) == 1
        # param_typ = list(param_typs)[0]
        # param_constraint = Subtyping(param_var, param_typ)

        # return_var = self.solver.fresh_type_var()
        # return_constraint = Subtyping(make_pair_typ(param_var, return_var), rel_typ)
        # return_typ = Exi(tuple([return_var.id]), tuple([return_constraint]), return_var)  

        # return Result(pid, outer_world, All(tuple([param_var.id]), tuple([param_constraint]), Imp(param_typ, return_typ)))
        ################################################

        if bool(left_unstructured_vars):
            ################################################
            # Stream Type 
            ##################################################
            (_, param_typ, _) = inner_locales[0]
            assert isinstance(param_typ, TVar)
            param_upper_bound = find_factor_from_label(rel_typ, "head")
            assert param_upper_bound
            founded_lfp_typ = self.solver.found(param_upper_bound)

            print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LFP CONVERSION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
before: {concretize_typ(param_upper_bound)}
after: {concretize_typ(founded_lfp_typ)}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            """)
            #TODO: reassociate antecedent out of LFP 
            return_typ = find_factor_from_label(rel_typ, "tail")
            assert return_typ
            specialized_return_typ = self.solver.sub_polar_typ(True, return_typ, param_typ.id, founded_lfp_typ)
            return Result(pid, outer_world, Imp(param_typ, specialized_return_typ))
        else:
            ################################################
            # Factored Type
            ################################################
            param_typ = find_factor_from_label(rel_typ, "head")
            return_typ = find_factor_from_label(rel_typ, "tail")
            assert param_typ and return_typ
            return Result(pid, outer_world, Imp(param_typ, return_typ))
    
'''
end ExprRule
'''


class RecordRule(Rule):

    def combine_single(self, pid : int, world : World, label : str, body_typ : Typ) -> Result:
        return Result(pid, world, TEntry(label, body_typ))

    def combine_cons(self, pid : int, world : World, label : str, body_typ : Typ, tail_typ : Typ) -> Result:
        return Result(pid, world, make_inter([TEntry(label, body_typ), tail_typ]))


class FunctionRule(Rule):

    def combine_single(self, pid : int, world : World, pattern_typ : Typ, body_results : list[Result]) -> FunctionResult:
        """
        NOTE: this could learn constraints on the param variables,
        which could separate params into case patterns.
        should package the 
        """
        return FunctionResult(pid, world, [NDBranch(pattern_typ, body_results)])

    def combine_cons(self, pid : int, world : World, pattern_typ : Typ, body_results : list[Result], tail : FunctionResult) -> FunctionResult:
        switch = self.combine_single(pid, world, pattern_typ, body_results) 
        return FunctionResult(pid, world, switch.branches + tail.branches)


class KeychainRule(Rule):

    def combine_single(self, key : str) -> KeychainResult:
        return KeychainResult([key])

    def combine_cons(self, key : str, kc : KeychainResult) -> KeychainResult:
        return KeychainResult([key] + kc.keys)


class ArgchainRule(Rule):

    def combine_single(self, pid : int, world : World, content : Typ) -> ChainResult:
        return ChainResult(pid, world, [content])

    def combine_cons(self, pid : int, world : World, head : Typ, tail : list[Typ]) -> ChainResult:
        return ChainResult(pid, world, [head] + tail)

######

class PipelineRule(Rule):

    def combine_single(self, pid : int, world : World, content_typ : Typ) -> ChainResult:
        return ChainResult(pid, world, [content_typ])

    def combine_cons(self, pid : int, world : World, head_typ: Typ, tail_typ : list[Typ]) -> ChainResult:
        return ChainResult(pid, world, [head_typ] + tail_typ)


'''
start Pattern Rule
'''

class PatternRule(Rule):
    def combine_tuple(self, head_result : PatternResult, tail_result : PatternResult) -> PatternResult:
        pattern = Inter(TEntry('head', head_result.typ), TEntry('tail', tail_result.typ))
        enviro = head_result.enviro.update(tail_result.enviro) 
        return PatternResult(enviro, pattern)

'''
end PatternRule
'''

class BasePatternRule(Rule):

    def combine_var(self, id : str) -> PatternResult:
        pattern = self.solver.fresh_type_var()
        enviro : PMap[str, Typ] = pmap({id : pattern})
        return PatternResult(enviro, pattern)

    def combine_unit(self) -> PatternResult:
        pattern = TUnit()
        return PatternResult(m(), pattern)


    def combine_tag(self, label : str, body_result : PatternResult) -> PatternResult:
        # pattern = TTag(label, body_result.typ)
        pattern = TEntry(label, body_result.typ)
        return PatternResult(body_result.enviro, pattern)
'''
end BasePatternRule
'''

class RecordPatternRule(Rule):

    def combine_single(self, label : str, body_result : PatternResult) -> PatternResult:
        pattern = TEntry(label, body_result.typ)
        return PatternResult(body_result.enviro, pattern)

    def combine_cons(self, label : str, body_result : PatternResult, tail_result : PatternResult) -> PatternResult:
        pattern = make_inter([TEntry(label, body_result.typ), tail_result.typ])
        enviro = body_result.enviro.update(tail_result.enviro)
        return PatternResult(enviro, pattern)

class TargetRule(Rule):

    # def combine_anno(self, pid : int, world : World, expr_typ : Typ, anno_typ : Typ) -> list[Result]:
    #     if bool(extract_free_vars_from_typ(s(), anno_typ)):
    #         return []
    #     else:
    #         # NOTE: we don't care about learning anything about the annotation; just that it's legal
    #         if bool(self.solver.solve(world, expr_typ, anno_typ, reset=True)): 
    #             return [
    #                 Result(pid, world, anno_typ)
    #             ]
    #         else:
    #             return []

    def combine_anno(self, pid : int, enviro : Enviro, world : World, target_results : list[Result], anno_typ : Typ) -> list[Result]:
        if bool(extract_free_vars_from_typ(s(), anno_typ)):
            return []
        else:
            foreignids = extract_free_vars_from_enviro(enviro).union(extract_free_vars_from_constraints(s(), world.constraints))
            # NOTE: we don't care about learning anything about the annotation; just that it's legal
            generalized_cases = []
            for target_result in target_results:
                pass

                local_constraints = target_result.world.constraints.difference(world.constraints)
                local_closedids = target_result.world.closedids.difference(world.closedids)
                # target = self.solver.interpret_polar_typ(
                #     True, 
                #     foreignids.union(local_closedids), local_constraints, 
                #     target_result.typ
                # )
                ids = extract_free_vars_from_typ(foreignids.union(local_closedids), target_result.typ) 
                m = self.solver.interpret_ids_polar(True, ids, local_constraints)
                target = sub_typ(m, target_result.typ)

                influential_ids = foreignids.union(local_closedids).union(extract_free_vars_from_typ(s(), target))
                influential_constraints = filter_constraints_by_all_variables(local_constraints, influential_ids)

                generalized_case = self.solver.make_constraint_typ(True)( 
                    foreignids, 
                    local_closedids,
                    influential_constraints, 
                    target 
                )

                generalized_cases = generalized_cases + [generalized_case]
            # endfor

            if bool(self.solver.solve(world, make_inter(generalized_cases), anno_typ, reset=True)): 
                return [
                    Result(pid, world, anno_typ)
                ]
            else:
                return []