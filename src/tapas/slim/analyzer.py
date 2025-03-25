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
class Fixpoint:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

# Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, Exi, All, Fixpoint, Top, Bot]
Typ = Union[TVar, TUnit, TEntry, Unio, Inter, Diff, Imp, Exi, All, Fixpoint, Top, Bot]


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
        return DiffNL(to_nameless(bound_ids, typ.context), to_nameless(bound_ids, typ.negation))
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

    elif isinstance(typ, Fixpoint):
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

def concretize_constraints(subtypings : Iterable[Subtyping]) -> str:
    return "\n".join([
        "; " + concretize_typ(st.lower) + " <: " + concretize_typ(st.upper)
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
            plate_entry = ([control.left,control.right], lambda left, right : f"({left}\n{indent('| ' + right)})")  
        elif isinstance(control, Inter):
            if (
                isinstance(control.left, TEntry) and control.left.label == "head" and 
                isinstance(control.right, TEntry) and control.right.label == "tail" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({left}, {right})")  
            elif (
                isinstance(control.right, TEntry) and control.right.label == "head" and 
                isinstance(control.left, TEntry) and control.left.label == "tail" 
            ):
                plate_entry = ([control.left.body,control.right.body], lambda left, right : f"({right}, {left})")  
            else:
                plate_entry = ([control.left,control.right], lambda left, right : f"({left} & {right})")  
        elif isinstance(control, Diff):
            plate_entry = ([control.context,control.negation], lambda context,negation : f"({context} \\ {negation})")  
        elif isinstance(control, Exi):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            if constraints:
                plate_entry = ([control.body], lambda body : f"(EXI [{ids}\n{indent(constraints)}\n] {body})")
            else:
                plate_entry = ([control.body], lambda body : f"(EXI [{ids}] {body})")
        elif isinstance(control, All):
            constraints = concretize_constraints(control.constraints)
            ids = concretize_ids(control.ids)
            if constraints:
                plate_entry = ([control.body], lambda body : f"(ALL [{ids}\n{indent(constraints)}\n] {body})")  
            else:
                plate_entry = ([control.body], lambda body : f"(ALL [{ids}] {body})")
        elif isinstance(control, Fixpoint):
            id = control.id
            plate_entry = ([control.body], lambda body : f"(FX {id}\n{indent('| ' + body)})")  
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
    return negation_well_formed(diff.negation)


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


def project_typ_recurse(t : Typ, path : tuple[str, ...]) -> Optional[Typ]:
    if not path:
        return None
    elif isinstance(t, Diff):
        context = project_typ_recurse(t.context, path)
        negation = project_typ_recurse(t.negation, path)
        if context and negation:
            return Diff(context, negation)
        else:
            return None
    elif isinstance(t, Exi):
        assert not bool(t.constraints)
        body = project_typ_recurse(t.body, path)
        if body:
            ids = tuple(
                id 
                for id in t.ids
                if id in extract_free_vars_from_typ(s(), body)
            )
            return Exi(ids, (), body)
        else:
            None
    elif isinstance(t, Inter):
        left = project_typ_recurse(t.left, path)
        right = project_typ_recurse(t.right, path)
        if left and right:
            return Inter(left, right)
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


def project_typ(t : Typ, path : tuple[str, ...]) -> Typ:
    result = project_typ_recurse(t, path)
    if result:
        return result
    else:
        raise Exception(f"extract_field_plain error: {path} in {concretize_typ(t)}")

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
        result = Inter(field, result)
    # return simplify_typ(result)
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

def extract_column_comparisons(key : Typ, rel : Fixpoint) -> list[tuple[Typ, list[Typ]]]:
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
    
    

def is_decomposable(key : Typ, rel : Fixpoint) -> bool:
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

def normalize_least_fp(t : Fixpoint, ordered_paths : list[tuple[str, ...]]) -> Fixpoint:

    normalized_body = Bot() 
    choices = linearize_unions(t.body)
    for choice in reversed(choices):
        norm_choice = normalize_choice(t.id, choice, ordered_paths)
        normalized_body = Unio(norm_choice, normalized_body)
    return Fixpoint(t.id, normalized_body)


def extract_ordered_path_target_pairs(key : Typ) -> list[tuple[tuple[str, ...], Typ]]:
    def ordering_key(p):
        return concretize_typ(p[1])
    path_target_pairs = extract_kv_pairs(key)
    ordered_path_target_pairs = sorted(path_target_pairs, key=ordering_key)
    return ordered_path_target_pairs


def extract_relational_paths(t : Fixpoint) -> PSet[tuple[str, ...]]: 
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

def find_paths(assumed_key : Typ, search_target : Typ) -> PSet[tuple[str, ...]]:
    results : PSet[tuple[str, ...]] = s()
    ordered_path_target_pairs = extract_ordered_path_target_pairs(assumed_key)
    for (k,v) in ordered_path_target_pairs:
        if v == search_target:
            results = results.add(k)
    return results 

def factorize_choice(induc_id : str, choice : Typ, path : tuple[str, ...]) -> Typ:
    if isinstance(choice, Exi):

        new_constraints = tuple(
            (
            Subtyping(project_typ(st.lower, path), TVar(induc_id))
            if st.upper == TVar(induc_id) else
            st
            )
            for st in choice.constraints
        )

        new_body = project_typ(choice.body, path)
        used_ids = extract_free_vars_from_constraints(s(), new_constraints).union(extract_free_vars_from_typ(s(), new_body))
        new_ids = used_ids.intersection(choice.ids)
        return Exi(tuple(new_ids), new_constraints, new_body)
    else:
        return project_typ(choice, path)

def factorize_least_fp(t : Fixpoint, path : tuple[str, ...]) -> Fixpoint:

    factorized_body = Bot() 
    choices = linearize_unions(t.body)
    for choice in reversed(choices):
        factor_choice = factorize_choice(t.id, choice, path)
        factorized_body = Unio(factor_choice, factorized_body)
    return Fixpoint(t.id, factorized_body)


def find_factors(world : World, search_target : Typ) -> PSet[Typ]:
    results = s()
    for constraint in world.constraints:
        path = find_path(constraint.lower, search_target)
        if path != None:
            if isinstance(constraint.upper, Fixpoint):
                result = factorize_least_fp(constraint.upper, path)
                results = results.add(result)
    return results

def find_factors_from_constraint(constraint : Subtyping, search_target : Typ) -> PSet[Typ]:
    results = s()
    paths = find_paths(constraint.lower, search_target)
    # paths = [find_path(constraint.lower, search_target)]
    for path in paths:
        if isinstance(constraint.upper, Fixpoint) and path != None:
            result = factorize_least_fp(constraint.upper, path)
            results = results.add(result)
    return results


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
    elif isinstance(typ, Fixpoint):  
        assignment_map = assignment_map.discard(typ.id)
        return Fixpoint(typ.id, sub_typ(assignment_map, typ.body))
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

        elif isinstance(typ, Fixpoint):
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
            .union(extract_free_vars_from_typ(bound_vars, st.lower))
            .union(extract_free_vars_from_typ(bound_vars, st.upper))
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

def is_typ_structured(t : Typ) -> bool:
    if False:
        assert False
    elif isinstance(t, Exi):
        return is_typ_structured(t.body)
    elif isinstance(t, All):
        return is_typ_structured(t.body)
    elif isinstance(t, Top):
        return True
    elif isinstance(t, Bot):
        return True
    # elif isinstance(t, TTag):
    #     return True
    elif isinstance(t, TEntry):
        return True
    elif isinstance(t, Unio):
        return is_typ_structured(t.left) and is_typ_structured(t.right)
    elif isinstance(t, Inter):
        return is_typ_structured(t.left) and is_typ_structured(t.right)
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

    elif isinstance(target, Fixpoint):

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

    def print(self, x):
        if not self._checking:
            print(x)

    def __init__(self, aliasing : PMap[str, Typ]):
        self._type_id = 0 
        self._limit = 1000 
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
                    if isinstance(constraint.upper, Fixpoint):
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
                    return Inter(new_left, new_right)
            else:
                if isinstance(new_left, Top):
                    return new_right
                elif isinstance(new_right, Top):
                    return new_left
                else:
                    return Inter(new_left, new_right)
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
                    return Unio(new_left, new_right)
            else:
                if isinstance(new_left, Bot):
                    return new_right
                elif isinstance(new_right, Bot): 
                    return new_left
                else:
                    return Unio(new_left, new_right)
        elif isinstance(typ, Diff): 
            typ = Diff(self.simplify_typ(typ.context), self.simplify_typ(typ.negation))
            if typ.negation == Bot():
                return typ.context
            else:
                return typ
        elif isinstance(typ, Imp): 
            return Imp(self.simplify_typ(typ.antec), self.simplify_typ(typ.consq))
        elif isinstance(typ, Exi):
            return Exi(typ.ids, self.simplify_constraints(typ.constraints), self.simplify_typ(typ.body))
        elif isinstance(typ, All):
            return All(typ.ids, self.simplify_constraints(typ.constraints), self.simplify_typ(typ.body))
        elif isinstance(typ, Fixpoint):
            return Fixpoint(typ.id, self.simplify_typ(typ.body))
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
            neg_typ = self.to_aliasing_typ(t.negation)
            return Diff(context_typ, neg_typ)
        elif isinstance(t, Exi):
            constraints = self.to_aliasing_constraints(t.constraints)
            body_typ = self.to_aliasing_typ(t.body)
            return Exi(t.ids, constraints, body_typ)
        elif isinstance(t, All):
            constraints = self.to_aliasing_constraints(t.constraints)
            body_typ = self.to_aliasing_typ(t.body)
            return All(t.ids, constraints, body_typ)
        elif isinstance(t, Fixpoint):
            body_typ = self.to_aliasing_typ(t.body)
            new_typ = Fixpoint(t.id, body_typ)
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

    def decode_polarity_typ(self, results : list[WorldTyp], polarity : bool) -> Typ:
        base = (Bot() if polarity else Top())
        operator = (Unio if polarity else Inter)

        big_typ = base
        for result in results:

            new_constraints, t = self.prune_interpret_polar_typ(s(), polarity, result.world.closedids, result.world.constraints, result.typ)
            ctyp = self.make_constraint_typ(polarity)(s(), result.world.closedids, new_constraints, t)
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
        elif isinstance(t, Fixpoint):
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

            influential_ids = foreignids.union(closedids).union(extract_free_vars_from_typ(s(), payload))
            constraints = pset( 
                st
                for st in constraints 
                # if all free type variabls in st constraint are influential
                if not bool(extract_free_vars_from_constraints(s(), [st]).difference(influential_ids))
            )

            payload_ids = extract_free_vars_from_typ(s(), payload)
            assert not bool(foreignids.intersection(closedids))

            outer_constraints = pset(
                st
                for st in constraints
                for fids in [extract_free_vars_from_constraints(s(), [st])]
                if not bool (fids.difference(closedids).union(foreignids)) # every free id is closed or foreign
                if bool(fids.intersection(closedids)) # there's at least one closed id
            )
            inner_constraints = constraints.difference(outer_constraints)

            outer_ids = extract_free_vars_from_constraints(s(), constraints).union(payload_ids).intersection(closedids)
            inner_ids = extract_free_vars_from_constraints(s(), inner_constraints).union(payload_ids).difference(closedids).difference(foreignids)
            ######### invariant: for each constraint in inner_constraints, there is at least one open and inner id in fids(constraint) 
            for st in inner_constraints:
                fids = extract_free_vars_from_constraints(s(), [st]) 
                assert bool(inner_ids.intersection(fids))
            ######################

            if outer_ids and inner_ids:
                return outer_con(
                    tuple(outer_ids), tuple(outer_constraints),
                    inner_con(tuple(inner_ids), tuple(inner_constraints), payload)
                )
            elif outer_ids:
                assert not inner_constraints
                return outer_con(tuple(outer_ids), tuple(outer_constraints), payload)
            elif inner_ids:
                assert not outer_constraints
                return inner_con(tuple(inner_ids), tuple(inner_constraints), payload)
            else:
                assert not inner_constraints and not outer_constraints
                return payload
            # end if/else
        # end def
        return make
    # end def

    def extract_factored_upper_bounds(self, world : World, id : str) -> PSet[Typ]:
        return find_factors(world, TVar(id))

    def get_negative_extra_constraints(self, closedids : PSet[str], constraints : PSet[Subtyping], id : str) -> PSet[Subtyping]:
        extra_constraints : PSet[Subtyping] = s()
        for st in constraints:
            if st.lower == TVar(id): 
                fids = extract_free_vars_from_typ(s(), st.upper).difference(closedids)
                intermediates = pset(
                    inner
                    for inner in constraints
                    if isinstance(inner.lower, TVar)
                    if inner.lower.id in fids 
                )
                if bool(intermediates):
                    extra_constraints = extra_constraints.union(intermediates).add(st)
        return extra_constraints

    def get_positive_extra_constraints(self, closedids : PSet[str], constraints : PSet[Subtyping], id : str) -> PSet[Subtyping]:
        extra_constraints : PSet[Subtyping] = s()
        for st in constraints:
            if st.upper == TVar(id): 
                fids = extract_free_vars_from_typ(s(), st.lower).difference(closedids)
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
            if isinstance(st.upper, Fixpoint)
            for id in extract_free_vars_from_typ(s(), st.lower) 
        )

    def interpret_negative_id(self, constraints : PSet[Subtyping], id : str) -> tuple[PSet[Subtyping], Typ]:

        if id in self.relational_ids(constraints):
            return (constraints, TVar(id))

        result_typ : Typ = TVar(id) 
        result_constraints : PSet[Subtyping] = pset()
        for st in constraints:
            if st.lower == TVar(id): 
                if result_typ == TVar(id):
                    result_typ = st.upper
                else:
                    result_typ = Inter(result_typ, st.upper)
            else:
                result_constraints = result_constraints.union([st])
        return  (result_constraints, result_typ)

    def prune_interpret_positive_id(self, closedids : PSet[str], constraints : PSet[Subtyping], id : str) -> tuple[PSet[Subtyping], Typ]:
        constraints = constraints.difference(self.get_positive_extra_constraints(closedids, constraints, id))
        return self.interpret_positive_id(constraints, id)

    def prune_interpret_negative_id(self, closedids : PSet[str], constraints : PSet[Subtyping], id : str) -> tuple[PSet[Subtyping], Typ]:
        constraints = constraints.difference(self.get_negative_extra_constraints(closedids, constraints, id))
        return self.interpret_negative_id(constraints, id)

    def prune_interpret_polar_typ(self, ignore : PSet[str], positive : bool, closedids : PSet[str], constraints : PSet[Subtyping], src : Typ) -> tuple[PSet[Subtyping], Typ]:
        # TODO: simplify to always ignore closedids
        # only open variables should be interpreted
        if False:
            assert False
        elif isinstance(src, TVar) and src.id not in ignore and src.id not in closedids:  
            if positive:
                return self.prune_interpret_positive_id(closedids, constraints, src.id)
            else:
                return self.prune_interpret_negative_id(closedids, constraints, src.id)
        elif isinstance(src, TUnit):  
            return constraints, TUnit()
        # elif isinstance(src, TTag):  
        #     body_constraints, body = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.body)
        #     return body_constraints, TTag(src.label, body)
        elif isinstance(src, TEntry):  
            body_constraints, body = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.body)
            return body_constraints, TEntry(src.label, body)
        elif isinstance(src, Unio):  
            left_constraints, left = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.left)
            right_constraints, right = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.right)
            return (left_constraints).intersection(right_constraints), Unio(left, right)
        elif isinstance(src, Inter):  
            left_constraints, left = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.left)
            right_constraints, right = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.right)
            return (left_constraints).intersection(right_constraints), Inter(left, right)
        elif isinstance(src, Diff):  
            context_constraints, context = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.context)
            return (context_constraints), Diff(context, src.negation)
        elif isinstance(src, Imp):  
            consq_constraints, consq = self.prune_interpret_polar_typ(ignore, positive, closedids, constraints, src.consq)
            antec_constraints, antec = self.prune_interpret_polar_typ(ignore, not positive, closedids, constraints, src.antec)
            return (consq_constraints).intersection(antec_constraints), Imp(antec, consq)
        elif isinstance(src, Exi):  
            outer_constraints, inner_constraints = self.prune_interpret_polar_constraints(ignore.union(src.ids), positive, closedids, constraints, src.constraints)
            body_constraints, body = self.prune_interpret_polar_typ(ignore.union(src.ids), positive, closedids, constraints, src.body)
            return (outer_constraints).intersection(body_constraints), Exi(src.ids, tuple(inner_constraints), body)
        elif isinstance(src, All):  
            outer_constraints, inner_constraints = self.prune_interpret_polar_constraints(ignore.union(src.ids), positive, closedids, constraints, src.constraints)
            body_constraints, body = self.prune_interpret_polar_typ(ignore.union(src.ids), positive, closedids, constraints, src.body)
            return (outer_constraints).intersection(body_constraints), All(src.ids, tuple(inner_constraints), body)

        elif isinstance(src, Fixpoint):  
            body_constraints, body = self.prune_interpret_polar_typ(ignore.add(src.id), positive, closedids, constraints, src.body)
            return body_constraints, Fixpoint(src.id, src.body)
        elif isinstance(src, Top):  
            return constraints, src
        elif isinstance(src, Bot):  
            return constraints, src
        else:
            return (constraints, src)

    def prune_interpret_polar_constraints(self, ignore : PSet[str], positive : bool, 
            closedids : PSet[str],
            outer_constraints : PSet[Subtyping], 
            inner_constraints : Iterable[Subtyping]
    ) -> tuple[PSet[Subtyping], PSet[Subtyping]]:
        result_outer_constraints : PSet[Subtyping] = outer_constraints 
        result_inner_constraints : PSet[Subtyping] = s()
        for inner in inner_constraints:
            upper_constraints, upper = self.prune_interpret_polar_typ(ignore, positive, closedids, outer_constraints, inner.upper)
            lower_constraints, lower = self.prune_interpret_polar_typ(ignore, not positive, closedids, outer_constraints, inner.lower)

            result_inner_constraints = result_inner_constraints.add(Subtyping(lower, upper))
            result_outer_constraints = result_outer_constraints.intersection(upper_constraints).intersection(lower_constraints)
        return (result_outer_constraints, result_inner_constraints)


    def interpret_positive_id(self, constraints : PSet[Subtyping], id : str) -> tuple[PSet[Subtyping], Typ]:

        result_typ : Typ = TVar(id) 
        result_constraints : PSet[Subtyping] = pset()
        for st in constraints:
            if st.upper == TVar(id): 
                if result_typ == TVar(id):
                    result_typ = st.lower
                else:
                    result_typ = Unio(result_typ, st.lower)
            else:
                result_constraints = result_constraints.union([st])
        return  (result_constraints, result_typ)


    def prune_flip_constraints(self, old_id : str, closedids : PSet[str], constraints : PSet[Subtyping], new_id : str) -> PSet[Subtyping]:
        constraints = constraints.difference(self.get_negative_extra_constraints(closedids, constraints, old_id))
        return self.flip_constraints(old_id, constraints, new_id)

    def flip_constraints(self, old_id : str, constraints : PSet[Subtyping], new_id : str) -> PSet[Subtyping]:
        result_constraints : PSet[Subtyping] = pset()
        for st in constraints:
            if st.lower == TVar(old_id): 
                if isinstance(st.upper, Imp):
                    left = st.upper.antec
                    right = st.upper.consq
                    result_constraints = result_constraints.add(Subtyping(make_pair_typ(left, right), TVar(new_id)))
                else:
                    result_constraints = result_constraints.add(st)
            else:
                result_constraints = result_constraints.add(st)
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
                self.sub_polar_typ(not greenlight, src.negation, id, payload),
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
        elif isinstance(src, Fixpoint):  
            if id == src.id:
                return src
            else:
                return Fixpoint(
                    src.id,
                    self.sub_polar_typ(greenlight, src.body, id, payload)
                )
        elif isinstance(src, Top):  
            return src
        elif isinstance(src, Bot):  
            return src
        else:
            return src

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
            return self.check(world, t2, t1.negation)
        elif isinstance(t2, Diff):
            return self.check(world, t1, t2.negation)
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

    def is_relational_constraint_consistent(self, lower : Typ, upper : Fixpoint) -> bool: 
        renaming : PMap[str, Typ] = pmap({upper.id : Top()})
        upper_body = sub_typ(renaming, upper.body)
        # NOTE: this is not circular because it's unrolled and TOP is subbed in for self reference 
        # NOTE: this check only cares about the local structure of the types
        # NOTE: consistency with the rest of the world is handled elsewhere
        return bool(self.check(empty_world(), lower, upper_body))

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

    def solve_multi(self, world : World, constraints : Iterable[Subtyping]) -> list[World]:
        worlds = [world]
        for st in constraints:
            worlds = [
                w1
                for w0 in worlds
                for w1 in self.solve(w0, st.lower, st.upper)
            ]
        return worlds


    def solve_open_variable_introduction(self, world : World, lower : Typ, upper : TVar) -> list[World]:
        new_constraints = self.sub_polar_constraints(False, world.constraints, upper.id, lower).difference(world.constraints)

        closed_constraints = pset(
            st
            for st in new_constraints 
            if isinstance(st.upper, TVar) and st.upper.id in world.closedids
        )

        unsolved_constraints = pset(
            st
            for st in new_constraints 
            if not isinstance(st.upper, TVar) or st.upper.id not in world.closedids
        )

        new_world = replace(world, constraints = world.constraints.union(closed_constraints))
        return [
            replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
            for w0 in self.solve_multi(new_world, unsolved_constraints)
        ]

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
            isinstance(t, Fixpoint) or
            isinstance(t, Exi)
        )
            

    def solve(self, world : World, lower : Typ, upper : Typ) -> list[World]:
        self.count += 1
        if self.count > self._limit:
            return []

#         print(f"""
# DEBUG SOLVE:
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

        elif isinstance(upper, Imp) and isinstance(upper.antec, Fixpoint):
            param_typ = self.fresh_type_var()
            universal_typ = All(
                tuple([param_typ.id]), 
                tuple([Subtyping(param_typ, upper.antec)]), 
                Imp(param_typ, upper.consq)
            )
            return self.solve(world, lower, universal_typ)


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

            return [
                m2
                for m0 in worlds
                for m1 in [replace(m0, closedids = m0.closedids.union(renamed_ids))]
                for m2 in self.solve(m1, lower_body, upper)
            ]

        # elif isinstance(lower, Fixpoint) and not isinstance(upper, Fixpoint):
        #     # TODO: modify rewriting to ensure relational constraint has at least a pair of variables
        #     # to avoid infinitue  back into the original problem, causing non-termination
        #     '''
        #     NOTE: rewrite into existential making shape of relation visible
        #     - allows matching shapes even if unrolling is undecidable
        #     '''
        #     paths = extract_relational_paths(lower)
        #     if bool(paths):
        #         rnode = RNode(m()) 
        #         tvars = []
        #         for path in paths:
        #             tvar = self.fresh_type_var()
        #             assert isinstance(rnode, RNode)
        #             rnode = insert_at_path(rnode, path, tvar)
        #             tvars.append(tvar)
        #         # end for

        #         key = to_record_typ(rnode) 
        #     else:
        #         tvar = self.fresh_type_var()
        #         tvars = [tvar]
        #         key = tvar

        #     exi = Exi(tuple(t.id for t in tvars), tuple([Subtyping(key, lower)]), key)

        #     return self.solve(world, exi, upper)

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
        #### Variable Elimination #############
        #######################################

        elif isinstance(lower, TVar) and lower.id not in world.closedids:
            new_constraints = self.sub_polar_constraints(True, world.constraints, lower.id, upper).difference(world.constraints)

            closed_constraints = pset(
                st
                for st in new_constraints 
                if isinstance(st.lower, TVar) and st.lower.id in world.closedids
            )

            unsolved_constraints = pset(
                st
                for st in new_constraints 
                if not isinstance(st.lower, TVar) or st.lower.id not in world.closedids
            )

            new_world = replace(world, constraints = world.constraints.union(closed_constraints))
            worlds = [
                replace(w0, constraints = w0.constraints.add(Subtyping(lower, upper))) 
                for w0 in self.solve_multi(new_world, unsolved_constraints)
            ]

            if isinstance(upper, TVar) and upper.id not in world.closedids: 
                worlds = [
                    w1
                    for w0 in worlds 
                    for w1 in self.solve_open_variable_introduction(w0, lower, upper) 
                ]
            return worlds 

        # elif isinstance(lower, TVar) and lower.id in world.closedids and (not isinstance(upper, TVar) or upper.id in world.closedids): 
        # elif isinstance(lower, TVar) and lower.id in world.closedids and (not isinstance(upper, TVar)): 
        elif isinstance(lower, TVar) and lower.id in world.closedids: 
            # ignore_constraints, lower_interp = self.prune_interpret_negative_id(world.closedids, world.constraints, lower.id)
            # if bool(self.solve(world, lower_interp, upper)):
            #     return [world]
            # else:
            #     return []

            closed_parts = pset(
                st.upper
                for st in world.constraints
                if st.lower == lower 
            ).union(self.extract_factored_upper_bounds(world, lower.id))

            one_part_consistent = any(
                bool(self.solve(world, closed_part, upper))
                for closed_part in closed_parts
                if not isinstance(closed_part, TVar) or closed_part.id in world.closedids 
            )

            if one_part_consistent: 
                return [world]
            else:
                return []

        #######################################
        #### Variable Introduction #############
        #######################################

        elif isinstance(upper, TVar) and upper.id not in world.closedids: 
            return self.solve_open_variable_introduction(world, lower, upper)

        # elif isinstance(upper, TVar) and upper.id in world.closedids and (not isinstance(lower, TVar) or lower.id in world.closedids): 
        elif isinstance(upper, TVar) and upper.id in world.closedids and (not isinstance(lower, TVar)): 
            # ignore_constraints, upper_interp = self.prune_interpret_positive_id(world.closedids, world.constraints, upper.id)
            # if self.solve(world, upper_interp, upper):
            #     return [world]
            # else:
            #     return []

            closed_parts = pset(
                st.lower
                for st in world.constraints
                if st.upper == upper 
            )

            one_part_consistent = any(
                bool(self.solve(world, upper, closed_part))
                for closed_part in closed_parts
                if not isinstance(closed_part, TVar) or closed_part.id in world.closedids 
            )

            if one_part_consistent: 
                return [world]
            else:
                return []

        #######################################
        #### Diff Introduction #############
        #######################################

        elif isinstance(upper, Diff): 

            # if diff_well_formed(upper): # TODO: change to: DF(lower) and DF(upper)
            if True:
                # TODO: need a sound/safe/conservative inhabitable check
                # only works if we assume T is not empty
                '''
                T <: A \\ B === (T <: A) and (T is inhabitable --> ~(T <: B))
                ----
                T <: A \\ B === (T <: A) and ((T <: B) --> T is empty)
                ----
                T <: A \\ B === (T <: A) and (~(T <: B) or T is empty)
                '''
                context_worlds = self.solve(world, lower, upper.context)
                return [
                    m
                    for m in context_worlds 
                    # if (
                    #     # not self.is_inhabitable(world, lower) or 
                    #     # Fail (incompletely) if lower is empty
                    #     self.solve(m, lower, upper.negation) == []
                    # )
                ]   
            else:
                return []


        #######################################
        #### Fixpoint Elimination #############
        #######################################


        elif isinstance(lower, Fixpoint):
            if is_typ_structured(lower.body):
                # renaming : PMap[str, Typ] = pmap({lower.id : upper})
                # lower_body = sub_typ(renaming, lower.body)

                # return self.solve(world, lower_body, upper)
                ####################

                renaming : PMap[str, Typ] = pmap({lower.id : upper})
                lower_body = self.sub_polar_typ(True, lower.body, lower.id, upper)
                if (lower.id in extract_free_vars_from_typ(s(), lower_body)):
                    return []
                else:
                    return self.solve(world, lower_body, upper)
                # end-if

                ####################
                fresh_id = self.fresh_type_id()
                renaming : PMap[str, Typ] = pmap({lower.id : TVar(fresh_id)})
                lower_body = sub_typ(renaming, lower.body)

                new_world = World(
                    world.constraints.add(Subtyping(TVar(fresh_id), upper)),
                    # world.constraints,
                    # world.closedids,
                    world.closedids.add(fresh_id),
                    world.relids
                )
                return self.solve(new_world, lower_body, upper)
                ####################
                # return []
            else:
                return []


        #######################################
        #### Fixpoint Introduction #############
        #######################################

        elif isinstance(upper, Fixpoint): 

#             print(f"""
# DEBUG upper, Fixpoint SOLVE:
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
# decomp: {is_decomposable(lower, upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)

            if is_decomposable(lower, upper): # TODO: make is_deciable more strict
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({upper.id : upper})
                weak_body = sub_typ(renaming, upper.body)
                worlds = self.solve(world, lower, weak_body)
                return worlds
            else:
                # READ
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
                            closed_parts = pset(
                                st.upper
                                for st in world.constraints
                                if st.lower == TVar(fv)
                            ).union(self.extract_factored_upper_bounds(world, fv))

                            one_part_consistent = any(
                                all(
                                    bool(self.solve(world, closed_part, factor))
                                    for factor in find_factors_from_constraint(Subtyping(lower, upper), TVar(fv))
                                )
                                for closed_part in closed_parts
                                if not isinstance(closed_part, TVar) or closed_part.id in world.closedids 
                            )

                            closed_var_consistent = closed_var_consistent and one_part_consistent

#                         print(f"""
# DEBUG upper, Fixpoint:
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {concretize_typ(lower)}
# <:
# {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# closedids: {world.closedids}
# constraints: 
# {concretize_constraints(world.constraints)}

# closed_constraints_consistent: {closed_var_consistent} 
# bool(lower_fvs.difference(world.closedids)): {bool(lower_fvs.difference(world.closedids))}
# self.is_relational_constraint_consistent(lower, upper): {self.is_relational_constraint_consistent(lower, upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                         """)

                    if closed_var_consistent and bool(lower_fvs.difference(world.closedids)) and self.is_relational_constraint_consistent(lower, upper):
                        # WRITE 
                        ignore, new_lower = self.prune_interpret_polar_typ(s(), True, world.closedids, world.constraints, lower)
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
                    #end if
                #end if


        #######################################
        #### Abstraction Introduction #########
        #######################################

        # elif isinstance(upper, Unio) and (self.is_base_typ(lower) or self.is_pattern_typ(lower)): 
        elif isinstance(upper, Unio): 
            return self.solve(world, lower, upper.left) + self.solve(world, lower, upper.right)

        elif isinstance(upper, Exi): 
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
            return self.solve(world, lower.left, upper) + self.solve(world, lower.right, upper)

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
                return self.solve(world, lower.context, Unio(upper, lower.negation))
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

@dataclass(frozen=True, eq=True)
class WorldTyp:
    world: World
    typ: Typ

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

        foreignids = pset( 
            id
            for t in enviro.values()
            for id in extract_free_vars_from_typ(s(), t)
        )
        # NOTE: worlds are intersected
        # TODO: need to extrude to not lose constraints on foreign variables
        augmented_branches = self.solver.augment_branches_with_diff(function_branches)
        generalized_branches = []

        for branch in augmented_branches: 
            new_constraints = branch.world.constraints.difference(world.constraints)
            # new_constraints, body_typ = self.solver.prune_interpret_positive_typ(world.closedids, new_constraints, branch.body)
            # new_constraints, param_typ = self.solver.prune_interpret_negative_typ(world.closedids, new_constraints, branch.pattern)

            # imp = Imp(param_typ, body_typ)


            new_constraints, imp = self.solver.prune_interpret_polar_typ(s(), True, world.closedids, new_constraints, Imp(branch.pattern, branch.body))

            generalized_case = self.solver.make_constraint_typ(True)( 
                foreignids.union(world.closedids), 
                branch.world.closedids.difference(world.closedids), 
                new_constraints, 
                imp
            )

            #############################################
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
        worlds = [world] 
        current_cator_typ = cator_typ
        for arg_typ in arg_typs:
            result_var = self.solver.fresh_type_var()
            new_worlds = []
            for world in worlds:
                new_worlds.extend(self.solver.solve(world, current_cator_typ, Imp(arg_typ, result_var)))
            worlds = new_worlds
            current_cator_typ = result_var

        return [
            Result(pid, world, result_var)
            for world in worlds
        ]

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

        induc_body = Bot()

        outer_world = world

        foreignids = pset( 
            id
            for t in enviro.values()
            for id in extract_free_vars_from_typ(s(), t)
        )
        inner_worlds = [
            inner_world
            for inner_world in self.solver.solve(outer_world, body_typ, Imp(self_typ, Imp(in_typ, out_typ)))
        ]
        for i, inner_world in enumerate(reversed(inner_worlds)):
            ###### TODO: ensure that the assertion is invariant
            assert in_typ.id not in inner_world.relids
            new_constraints = inner_world.constraints

            new_constraints, right_typ = self.solver.prune_interpret_positive_id(world.closedids, new_constraints, out_typ.id) 
            new_constraints, left_typ = self.solver.prune_interpret_negative_id(world.closedids, new_constraints, in_typ.id) 

            rel_pattern = make_pair_typ(left_typ, right_typ)
            new_constraints = self.solver.prune_flip_constraints(self_typ.id, world.closedids, new_constraints, IH_typ.id)
            new_constraints = new_constraints.difference(world.constraints)

            constrained_rel = self.solver.make_constraint_typ(False)(
                foreignids.union(world.closedids).union([IH_typ.id]), 
                inner_world.closedids.difference(world.closedids), 
                new_constraints, 
                rel_pattern
            )
            induc_body = Unio(constrained_rel, induc_body) 
        #end for

        rel_typ = Fixpoint(IH_typ.id, induc_body)
        param_typ = self.solver.fresh_type_var()
        return_typ = self.solver.fresh_type_var()
        consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
        consq_typ = Exi(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
        return Result(pid, outer_world, All(tuple([param_typ.id]), tuple(), Imp(param_typ, consq_typ)))

        ##################################

    
'''
end ExprRule
'''


class RecordRule(Rule):

    def combine_single(self, pid : int, world : World, label : str, body_typ : Typ) -> Result:
        return Result(pid, world, TEntry(label, body_typ))

    def combine_cons(self, pid : int, world : World, label : str, body_typ : Typ, tail_typ : Typ) -> Result:
        return Result(pid, world, Inter(TEntry(label, body_typ), tail_typ))


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
        pattern = Inter(TEntry(label, body_result.typ), tail_result.typ)
        enviro = body_result.enviro.update(tail_result.enviro)
        return PatternResult(enviro, pattern)

