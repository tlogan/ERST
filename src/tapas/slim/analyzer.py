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
class Fixpoint:
    id : str 
    body : Typ 

@dataclass(frozen=True, eq=True)
class Top:
    pass

@dataclass(frozen=True, eq=True)
class Bot:
    pass

Typ = Union[TVar, TUnit, TTag, TField, Unio, Inter, Diff, Imp, Exi, All, Fixpoint, Top, Bot]


@dataclass(frozen=True, eq=True)
class Branch:
    worlds : list[World]
    pattern : Typ 
    body : Typ

@dataclass(frozen=True, eq=True)
class AugBranch:
    world : World
    pattern : Typ 
    body : Typ

@dataclass(frozen=True, eq=True)
class RecordBranch:
    worlds : list[World]
    label : str 
    body : Typ


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
            plate_entry = ([control.left,control.right], lambda left, right : f"({left}\n{indent('| ' + right)})")  
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
    enviro : PMap[str, Typ] 
    worlds : list[World]

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

def union_worlds(w1 : World, w2 : World) -> World:
    return World(
        w1.constraints.union(w2.constraints),
        w1.freezer.union(w2.freezer),
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
        if key in extract_free_vars_from_typ(pset(), st.lower)
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


def make_pair_typ(left : Typ, right : Typ) -> Typ:
    return Inter(TField("head", left), TField("tail", right))

def linearize_unions(t : Typ) -> list[Typ]:
    if isinstance(t, Unio):
        return linearize_unions(t.left) + linearize_unions(t.right)
    else:
        return [t]

def linearize_intersections(t : Typ) -> list[Typ]:
    if isinstance(t, Inter):
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
    elif isinstance(t, TField):
        label = path[0]
        if t.label == label:
            if len(path) == 1:
                return t.body
            else:
                return project_typ_recurse(t.body, path[1:])
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
    return simplify_typ(result)



# def factor_least(least : LeastFP) -> Typ:
#     choices = linearize_unions(least.body)
#     paths = [
#         path
#         for choice in choices
#         for path in list(extract_paths(choice))
#     ]

#     rnode = RNode(m()) 
#     for path in paths:
#         column = extract_column(path, least.id, choices)
#         assert isinstance(rnode, RNode)
#         rnode = insert_at_path(rnode, path, column)

#     return to_record_typ(rnode) 

def alpha_equiv(t1 : Typ, t2 : Typ) -> bool:
    left_nameless_typ = to_nameless((), t1)
    right_nameless_typ = to_nameless((), t2)
    result = left_nameless_typ == right_nameless_typ
#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG alpha_equiv
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# t1: 
# {concretize_typ(t1)}
# -----------------------
# t2: 
# {concretize_typ(t2)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# left_nameless_typ: 
# {left_nameless_typ}
# -----------------------
# right_nameless_typ: 
# {right_nameless_typ}
# -----------------------
# result: {result} 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)
    return result

def is_record_typ(t : Typ) -> bool:
    if isinstance(t, TField):
        return True
    elif isinstance(t, Inter):
        return is_record_typ(t.left) and is_record_typ(t.right)
    else:
        return False


def is_decidable_shape(t : Typ) -> bool:
    # TODO:
    # simple strategy: anything that's not a variable
    # 
    # alternate
    # a decidable shape could be a union or intersection
    # as long as each member of union or intersection is a decidable shape 
    # base case is a tag, top, bot, unit. 
    # is field a base case?
    return not isinstance(t, TVar)

def extract_column_comparisons(key : Typ, rel : Fixpoint) -> list[tuple[Typ, list[Typ]]]:
    choices = [
        choice
        for choice in linearize_unions(rel.body)
        if choice != Bot()
    ]

    if is_record_typ(key):
        paths = list(extract_paths(key))
        # TODO: double check that it is sound or not too incomplete to do this
        # paths = [
        #     path
        #     for choice in choices
        #     for path in list(extract_paths(choice))
        # ]

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

def is_decidable(key : Typ, rel : Fixpoint) -> bool:
#     print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG is_decidable
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# key:
# {concretize_typ(key)}

# rel:
# {concretize_typ(rel)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     """)
    comparisons = extract_column_comparisons(key, rel)

    result = False 
    for column_key, column_choices in comparisons:
        key_is_decidable = is_decidable_shape(column_key)
        there_are_decidable_shapes_in_choices = any(
            isinstance(cc, TTag) or
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
    elif isinstance(t, TField):
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
    choices = linearize_unions(simplify_typ(t.body))
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

def lookup_normalized_relational_typ(world : World, key : Typ) -> Optional[Typ]:
    if is_record_typ(key):
        for constraint in world.constraints:
            ordered_paths = extract_matching_ordered_paths(constraint.lower, extract_targets(key))
            if ordered_paths != None:
                if isinstance(constraint.upper, Fixpoint):
                    return normalize_least_fp(constraint.upper, ordered_paths)
        return None
    else:
        return None

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
        return Exi(choice.ids, new_constraints, new_body)
    else:
        return project_typ(choice, path)

def factorize_least_fp(t : Fixpoint, path : tuple[str, ...]) -> Fixpoint:

    factorized_body = Bot() 
    choices = linearize_unions(simplify_typ(t.body))
    for choice in reversed(choices):
        factor_choice = factorize_choice(t.id, choice, path)
        factorized_body = Unio(factor_choice, factorized_body)
    return Fixpoint(t.id, factorized_body)

# # TODO: remove
# def find_factor_typ(world : World, search_target : Typ) -> Optional[Typ]:
#     for constraint in world.constraints:
#         path = find_path(constraint.lower, search_target)
#         if path != None:
#             if isinstance(constraint.upper, LeastFP):
#                 return factorize_least_fp(constraint.upper, path)
#     return None

def find_factors(world : World, search_target : Typ) -> tuple[PSet[Typ], PSet[Subtyping]]:
    result = s()
    used_constraints = s()
    for constraint in world.constraints:
        path = find_path(constraint.lower, search_target)
        if path != None:
            if isinstance(constraint.upper, Fixpoint):
                result = result.add(factorize_least_fp(constraint.upper, path))
                used_constraints = used_constraints.add(constraint)
    return (result, used_constraints) 


def mapOp(f):
    def call(o):
        if o != None:
            return f(o)
        else:
            return None
    return call



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
    elif isinstance(typ, Fixpoint):
        return Fixpoint(typ.id, simplify_typ(typ.body))
    else:
        return typ
    
def simplify_constraints(constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
    return tuple(
        Subtyping(simplify_typ(st.lower), simplify_typ(st.upper))
        for st in constraints
    )

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

def sub_constraints(assignment_map : PMap[str, Typ], constraints : tuple[Subtyping, ...]) -> tuple[Subtyping, ...]:
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

def extract_existential_constraints(freezer: PSet[str], constraints : PSet[Subtyping]) -> PSet[Subtyping]:
    return pset( 
        st
        for st in constraints
        for lower_fvs in [extract_free_vars_from_typ(s(), st.lower)]
        for upper_fvs in [extract_free_vars_from_typ(s(), st.upper)]
        if bool(freezer.intersection(lower_fvs.union(upper_fvs))) 
    )

def package_typ(world : World, typ : Typ) -> Typ:
    constraints = extract_reachable_constraints_from_typ(world, typ)
    existential_constraints = extract_existential_constraints(world.freezer, constraints)
    reachable_ids = extract_free_vars_from_constraints(s(), constraints).union(extract_free_vars_from_typ(s(), typ))
    existential_bound_ids = tuple(sorted(world.freezer.intersection(reachable_ids)))

    if not existential_bound_ids:
        assert not existential_constraints
        exi_typ = typ
    else:
        exi_typ = Exi(existential_bound_ids, tuple(sorted(existential_constraints)), typ)

    # return simplify_typ(exi_typ)

    universal_constraints = constraints.difference(existential_constraints)
    universal_bound_ids = tuple(sorted(reachable_ids.difference(world.freezer)))
    # NOTE: alternative
    # universal_constraints = extract_reachable_constraints_from_typ(world, exi_typ)
    # universal_bound_ids = tuple(extract_free_vars_from_constraints(s(), universal_constraints).union(extract_free_vars_from_typ(s(), exi_typ)))

    if not universal_bound_ids:
        assert not universal_constraints
        univ_typ = exi_typ
    else:
        univ_typ = All(universal_bound_ids, tuple(sorted(universal_constraints)), exi_typ)
    return simplify_typ(univ_typ)



def is_selective(t : Typ) -> bool:
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
        st.upper.id
        for st in world.constraints
        if isinstance(st.lower, TVar) and st.lower.id in world.freezer  
        if isinstance(st.upper, TVar) and st.upper.id not in world.freezer  
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
    elif isinstance(t, TTag):
        return True
    elif isinstance(t, TField):
        return True
    elif isinstance(t, Unio):
        return is_typ_structured(t.left) and is_typ_structured(t.right)
    elif isinstance(t, Inter):
        return is_typ_structured(t.left) and is_typ_structured(t.right)
    else:
        return False


default_context = Context(m(), [World(s(), s(), s())])


class Solver:
    _type_id : int
    _limit : int

    aliasing : PMap[str, Typ]

    def __init__(self, aliasing : PMap[str, Typ]):
        self._type_id = 0 
        self._limit = 100000
        self.debug = True
        self.count = 0
        self.aliasing = aliasing

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
        elif isinstance(t, TTag):
            body_typ = self.to_aliasing_typ(t.body)
            return TTag(t.label, body_typ)
        elif isinstance(t, TField):
            body_typ = self.to_aliasing_typ(t.body)
            return TField(t.label, body_typ)
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



    def resolve_strongest_upper_bound(self, world : World, id : str) -> tuple[Typ, PSet[Subtyping]]:
        # if id in self.aliasing:
        #     return (self.aliasing[id], s())

        uppers, constraints = self.extract_upper_bounds(world, id) 
        result = Top() 
        for upper in uppers:
            result = Inter(upper, result) 
        
        return (simplify_typ(result), pset(constraints))

    def resolve_weakest_lower_bound(self, world : World, id : str) -> tuple[Typ, PSet[Subtyping]]:
        # if id in self.aliasing:
        #     return (self.aliasing[id], s())

        constraints = [
            st
            for st in world.constraints
            if st.upper == TVar(id) 
        ]
        result = Bot() 
        for c in reversed(constraints):
            result = Unio(c.lower, result) 
        return (simplify_typ(result), pset(constraints))

    def is_constraint_dead(self, world : World, ignored : PSet[str], st : Subtyping) -> bool:
        lower_result = False
        upper_result = False
        # if isinstance(st.lower, TVar) and st.lower.id not in ignored and st.lower.id not in world.freezer:
        if isinstance(st.lower, TVar):
            lower_result = (
                st.lower.id not in ignored and 
                st.lower.id not in world.freezer and 
                st.lower.id not in extract_free_vars_from_constraints(s(), world.constraints.difference(s(st)))
            )

        if isinstance(st.upper, TVar): 
            upper_result = (
                st.upper.id not in ignored and 
                st.upper.id not in world.freezer and 
                st.upper.id not in extract_free_vars_from_constraints(s(), world.constraints.difference(s(st)))
            )

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG is_constraint_dead
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ignored: {ignored}

# st: {concretize_typ(st.lower)} <: {concretize_typ(st.upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# world.freezer: {world.freezer}

# world.constraints:
# {concretize_constraints(world.constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lower_result: {lower_result}
# upper_result: {upper_result}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)

        return lower_result or upper_result 


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

    def resolve_polarity(self, polarity : bool, world : World, typ : Typ, ignored_ids : PSet[str]) -> tuple[Typ, PSet[Subtyping]]:
        def resolve(polarity : bool, id : str): 
            if polarity:
                return self.resolve_weakest_lower_bound(world, id)
            else:
                return self.resolve_strongest_upper_bound(world, id)

        if False:
            assert False
        elif isinstance(typ, TVar) and typ.id in ignored_ids:
            return (typ, s())
        elif isinstance(typ, TVar) and typ.id not in ignored_ids:
            id = typ.id
            new_polarity = ( 
                not polarity
                if (id in world.freezer) else
                polarity
            )
            include_factors = False
            should_interpret = (
                new_polarity or include_factors or id not in world.relids 
            )
            op = ( 
                resolve(new_polarity, id)
                if should_interpret else
                None
            )
            # op = ( 
            #     mapOp(simplify_typ)(interpret_id(not polarity, id))
            #     if (id in world.freezer) else
            #     mapOp(simplify_typ)(interpret_id(polarity, id))
            # )

            if op != None:
                (interp_typ_once, cs_once) = op
                interp_typ_once = simplify_typ(interp_typ_once)
                # print(f"""
                # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                # DEBUG: used_constraints: {concretize_constraints(cs_once)}
                # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                # """)
                if (id in world.freezer) or self.is_meaningful(new_polarity, world, interp_typ_once): 
                    m = World(world.constraints.difference(cs_once), world.freezer, world.relids)
                    (t, cs_cont) = self.resolve_polarity(polarity, m, interp_typ_once, ignored_ids)
                    return (simplify_typ(t), cs_once.union(cs_cont))
                else:
                    return (typ, s())
            else:
                return (typ, s())

        elif isinstance(typ, TUnit):
            return (typ, s())
        elif isinstance(typ, TTag):
            body = typ.body
            body, body_constraints = self.resolve_polarity(polarity, world, typ.body, ignored_ids)
            return (TTag(typ.label, body), body_constraints)
        elif isinstance(typ, TField):
            body = typ.body
            body, body_constraints = self.resolve_polarity(polarity, world, typ.body, ignored_ids)
            return (TField(typ.label, body), body_constraints)
        elif isinstance(typ, Unio):
            left, left_constraints = self.resolve_polarity(polarity, world, typ.left, ignored_ids)
            right, right_constraints = self.resolve_polarity(polarity, world, typ.right, ignored_ids)
            return (Unio(left, right), left_constraints.union(right_constraints))
        elif isinstance(typ, Inter):
            left, left_constraints = self.resolve_polarity(polarity, world, typ.left, ignored_ids)
            right, right_constraints = self.resolve_polarity(polarity, world, typ.right, ignored_ids)
            return (Inter(left, right), left_constraints.union(right_constraints))
        elif isinstance(typ, Diff):
            context, context_constraints = self.resolve_polarity(polarity, world, typ.context, ignored_ids)
            return (Diff(context, typ.negation), context_constraints)

        # TODO: remove version that resolves antecedent 
        # elif isinstance(typ, Imp):
        #     consq, consq_constraints = self.resolve_polarity(polarity, world, typ.consq, ignored_ids)
        #     world = World(world.constraints.difference(consq_constraints), world.freezer, world.relids)
        #     antec, antec_constraints = self.resolve_polarity(not polarity, world, typ.antec, ignored_ids.union(extract_free_vars_from_typ(ignored_ids, consq)))
        #     return (Imp(antec, consq), antec_constraints.union(consq_constraints))

        # NOTE: only resolve the consequent and leaving the antecedent alone
        elif isinstance(typ, Imp):
            antec = typ.antec
            consq, consq_constraints = self.resolve_polarity(polarity, world, typ.consq, ignored_ids.union(extract_free_vars_from_typ(ignored_ids, antec)))
            world = World(world.constraints.difference(consq_constraints), world.freezer, world.relids)
            return (Imp(antec, consq), consq_constraints)

        elif isinstance(typ, Exi):
            return (typ, s())
        elif isinstance(typ, All):
            return (typ, s())
        elif isinstance(typ, Fixpoint):
            ignored_ids = ignored_ids.add(typ.id)
            body, body_constraints = self.resolve_polarity(polarity, world, typ.body, ignored_ids)
            return (Fixpoint(typ.id, body), body_constraints)
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
            for op in [self.resolve_polarity(polarity, world, t, s())]
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

#     def solve_or_cache(self, world : World, lower : Typ, upper : Typ) -> list[World]:
#         # TODO: consider if other checks are necessary to soundly cache constraint as assumption 
#         # - e.g. should we ensure that variables constrained by relation are constrained alone?
#         worlds = self.solve(world, lower, upper)
# #         print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~
# # DEBUG solve_or_cache 
# # ~~~~~~~~~~~~~~~~~~~~~
# # world.constraints:
# # {concretize_constraints(world.constraints)}

# # strong: 
# # {concretize_typ(strong)}

# # weak: 
# # {concretize_typ(weak)}
# # ~~~~~~~~~~~~~~~~~~~~~
# #         """)
#         reduced_lower, used_constraints = self.interpret_with_polarity(True, world, lower, s())
#         if not worlds and isinstance(upper, LeastFP) and not is_decidable(reduced_lower, upper):

# #             print(f"""
# # ~~~~~~~~~~~~~~~~~~~~~
# # DEBUG SAVING Relational Constraint 
# # ~~~~~~~~~~~~~~~~~~~~~
# # world.constraints:
# # {concretize_constraints(world.constraints)}

# # strong: 
# # {concretize_typ(strong)}

# # weak: 
# # {concretize_typ(weak)}
# # ~~~~~~~~~~~~~~~~~~~~~
# #             """)
#             # TODO: might need to reduce strong before caching
#         # if (
#         #     (all((fv not in world.freezer) for fv in fvs)) 
#         #     # TODO: remove wellformed check
#         #     # - should be sound without this; not unrollable means it can't be proven to fail 
#         #     # and 
#         #     # self.is_relation_constraint_wellformed(world, normalized_strong, normalized_weak)
#         # ):
#             fvs = extract_free_vars_from_typ(s(), reduced_lower)  
#             return [World(
#                 # world.constraints.difference(used_constraints).add(Subtyping(reduced_strong, weak)),
#                 world.constraints.add(Subtyping(reduced_lower, upper)),
#                 world.freezer, world.relids.union(fvs)
#             )]
#         else:
#             return worlds 

    def extract_upper_bounds(self, world : World, id : str) -> tuple[PSet[Typ], PSet[Subtyping]]:
        result = s()
        used_constraints = s()
        for constraint in world.constraints:
            if constraint.lower == TVar(id):
                result = result.add(constraint.upper)
                used_constraints = used_constraints.add(constraint)

        factors, factors_used_constraints = find_factors(world, TVar(id))
        result = result.union(factors)
        used_constraints = used_constraints.union(factors_used_constraints)
        return (result, used_constraints) 

    def is_meaningful(self, polarity : bool, world : World, t : Typ) -> bool:
        tt = simplify_typ(t)
        if polarity:
            return not isinstance(tt, Bot)
            # return self.is_inhabitable(world, t)
        else:
            return not isinstance(tt, Top)
            # return is_selective(t)



    def is_inhabitable(self, world : World, t : Typ) -> bool:
        """
        True iff certainly inhabitable 
        False if either disjoint or inhabitable 
        """
        # TODO: this is currently not sound
        t = simplify_typ(t)
        if False:
            pass
        elif isinstance(t, Bot):
            return False
        elif isinstance(t, Inter):
            return (
                self.is_inhabitable(world, t.left) and
                self.is_inhabitable(world, t.right) and
                self.is_intersection_inhabitable(world, t.left, t.right)
            )
        else:
            # TODO: decompose into parts and check subparts are inhabitable
            return True

    def make_diff(self, world : World, context : Typ, negs : list[Typ]) -> Typ:
        result = context 
        for neg in negs:
            if not self.is_disjoint(world, result, neg):
                result = Diff(result, neg)
        return result

    def augment_branches_with_diff(self, branches : list[Branch]) -> list[AugBranch]:
        '''
        nil -> zero
        cons X -> succ Y 
        --------------------
        (nil,zero) | (cons X\\nil, succ Y)
        '''

        augmented_branches = []
        negs = []

        for branch in branches:
            for world in branch.worlds:
                augmented_branches += [AugBranch(world, self.make_diff(world, branch.pattern, negs), branch.body)]
                neg_fvs = extract_free_vars_from_typ(s(), branch.pattern)  
                neg = (
                    Exi(tuple(sorted(neg_fvs)), (), branch.pattern)
                    if neg_fvs else
                    branch.pattern 
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
            return bool(self.solve(world, t2, t1.negation))
        elif isinstance(t2, Diff):
            return bool(self.solve(world, t1, t2.negation))
        elif isinstance(t1, TTag) and isinstance(t2, TTag):
            return t1.label != t2.label or (
                self.is_disjoint(world, t1.body, t2.body)
            ) 
        elif isinstance(t1, TField) and isinstance(t2, TField) and t1.label == t2.label:
            return self.is_disjoint(world, t1.body, t2.body) 

        elif isinstance(t2, Exi):
            renaming = self.make_renaming(t2.ids)
            constraints = world.constraints.union(sub_constraints(renaming, t2.constraints))
            body = sub_typ(renaming, t2.body)
            world = replace(world, constraints = constraints)
            return self.is_disjoint(world, t1, body) 
        else:
            return False

    def is_intersection_inhabitable(self, world : World, left : Typ, right : Typ) -> bool:

        # NOTE: assume left and right are already assumed to be inhabitable 
        # TODO: to make a symmetrical version 
        """
        True iff certainly inhabitable 
        False if either disjoint or inhabitable 
        """
        if False:
            assert False
        elif isinstance(left, Top): 
            return True
        elif isinstance(right, Top): 
            return True
        elif isinstance(left, TVar): 
            new_lefts = self.extract_upper_bounds(world, left.id)[0]
            return all(
                self.is_intersection_inhabitable(world, new_left, right)
                for new_left in new_lefts
            )
        elif isinstance(right, TVar): 
            new_rights = self.extract_upper_bounds(world, right.id)[0]
            return all(
                self.is_intersection_inhabitable(world, left, new_right)
                for new_right in new_rights 
            )

        elif isinstance(left, All): 
            renaming = self.make_renaming(left.ids)
            constraints = world.constraints.union(sub_constraints(renaming, left.constraints))
            body = sub_typ(renaming, left.body)
            world = replace(world, constraints = constraints)
            return self.is_intersection_inhabitable(world, body, right)
        elif isinstance(right, All): 
            renaming = self.make_renaming(right.ids)
            constraints = world.constraints.union(sub_constraints(renaming, right.constraints))
            body = sub_typ(renaming, right.body)
            world = replace(world, constraints = constraints)
            return self.is_intersection_inhabitable(world, left, body)
        elif isinstance(left, Inter): 
            return (
                self.is_intersection_inhabitable(world, left.left, right) and
                self.is_intersection_inhabitable(world, left.right, right)
            )
        elif isinstance(right, Inter): 
            return (
                self.is_intersection_inhabitable(world, left, right.left) and
                self.is_intersection_inhabitable(world, left, right.right)
            )

        elif isinstance(left, TField) and isinstance(right, TField): 
            return left.label != right.label or (
                self.is_intersection_inhabitable(world, left.body, right.body)
            )

        elif isinstance(left, Imp) and isinstance(right, Imp): 
            return self.is_disjoint(world, left.antec, right.antec) or (
                self.is_intersection_inhabitable(world, left.consq, right.consq)
            )

        else:
            return self.check(world, left, right) or self.check(world, right, left)

    def ensure_upper_intersection_inhabitable(self, world : World, id : str, target : Typ) -> bool:
        if self.is_upper_intersection_inhabitable(world, id, target):
            return True
        else:
            raise InhabitableError()

    def is_upper_intersection_inhabitable(self, world : World, id : str, target : Typ) -> bool:
        # TODO: ensure that the intersection of the upper bounds is inhabitable
        # - check that weak can intersect every upper bound of id in world
        # - for union upper bounds, linearize and check for at least one pair in cross product is_weak_inhabitable is true 
        # - if both are fields and body is inhabitable, then return true 
        # - if both are implications and body is inhabitable, then return true 
        # - if intersection
        # legacies = self.extract_uppers(world, id)[0]
        # return self.are_intersections_inhabitable(world, legacies, target)

        result = (
            self.is_inhabitable(world, target) and
            all(
                # NOTE: no need to check legacy; e.g. self.is_inhabitable(world, legacy)
                # - we know it's inhabitable since it is in the world
                # - and only the solver adds constraints to the world
                self.is_intersection_inhabitable(world, legacy, target)
                for legacy in self.extract_upper_bounds(world, id)[0]
            ) 
        )
        return result

    def is_fixpoint_constraint_safe(self, world : World, lower : Typ, upper : Fixpoint) -> bool: 
        renaming : PMap[str, Typ] = pmap({upper.id : Top()})
        weak_body = sub_typ(renaming, upper.body)
        return self.check(world, lower, weak_body)

    def check(self, world : World, lower : Typ, upper : Typ) -> bool:
        try:
            return bool(self.solve(world, lower, upper))
        except RecursionError as e:
            print(f"""
~~~~~~~~~~~~~~~~~~~~~~~
check: RecursionError 
~~~~~~~~~~~~~~~~~~~~~~~
lower:
{concretize_typ(lower)}

upper:
{concretize_typ(upper)}
~~~~~~~~~~~~~~~~~~~~~~~
            """)
            # raise e
            return False
        except InhabitableError:
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~
# check: InhabitableError 
# ~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            return False
    def solve(self, world : World, lower : Typ, upper : Typ) -> list[World]:
        self.count += 1
        if self.count > self._limit:
            return []

#         print(f'''
# =================
# DEBUG SOLVE
# =================
# self.aliasing :::
# :::::::: {self.aliasing}

# world.freezer::: 
# :::::::: {world.freezer}

# world.constraints::: 
# {concretize_constraints(world.constraints)}

# lower:
# {concretize_typ(lower)} 

# upper:
# {concretize_typ(upper)}

# count: {self.count}
# =================
#         ''')

        if alpha_equiv(lower, upper): 
            return [world] 

        if False:
            return [] 
        #######################################

        #######################################
        #### Dealiasing ####
        #######################################
        elif isinstance(upper, TVar) and upper.id in self.aliasing: 
            return self.solve(world, lower, self.aliasing[upper.id])

        elif isinstance(lower, TVar) and lower.id in self.aliasing: 
            return self.solve(world, self.aliasing[lower.id], upper)
        #######################################

        elif isinstance(lower, Fixpoint) and not isinstance(upper, Fixpoint):
            # TODO: modify rewriting to ensure relational constraint has at least a pair of variables
            # to avoid infinitue substiting back into the original problem, causing non-termination
            '''
            NOTE: rewrite into existential making shape of relation visible
            - allows matching shapes even if unrolling is undecidable
            '''
            paths = extract_relational_paths(lower)
            if bool(paths):
                rnode = RNode(m()) 
                tvars = []
                for path in paths:
                    tvar = self.fresh_type_var()
                    assert isinstance(rnode, RNode)
                    rnode = insert_at_path(rnode, path, tvar)
                    tvars.append(tvar)
                # end for

                key = to_record_typ(rnode) 
            else:
                tvar = self.fresh_type_var()
                tvars = [tvar]
                key = tvar

            exi = Exi(tuple(t.id for t in tvars), tuple([Subtyping(key, lower)]), key)

            return self.solve(world, exi, upper)

        elif isinstance(upper, Exi): 
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG: upper, Exi 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# strong:
# {concretize_typ(lower)}

# weak:
# {concretize_typ(upper)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)
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


        elif isinstance(lower, TVar) and lower.id not in world.freezer: 
            interp = self.resolve_weakest_lower_bound(world, lower.id)
            if  isinstance(interp[0], Bot):
                # self.ensure_upper_intersection_inhabitable(world, lower.id, upper)
                return [World(
                    world.constraints.add(Subtyping(lower, upper)),
                    world.freezer, world.relids
                )]
            ###################################
            elif isinstance(interp[0], TVar) and (interp[0].id in world.freezer):
                # NOTE: the existence of a F <: L connstraint implies that a frozen variable can be refined by subsequent information. 
                # NOTE: this is necessary for the max example

                # TODO: move inhabitable checks to typing rules
                # self.ensure_upper_intersection_inhabitable(world, lower.id, upper)
                # return [World(
                #     world.constraints.add(Subtyping(lower, upper)),
                #     world.freezer, world.relids
                # )]

                # NOTE: safety check 
                # - add strongest_upper check of transitive skolem variable 
                strongest_once_removed = self.resolve_weakest_lower_bound(world, interp[0].id)[0]
                worlds = [
                    new_world
                    for world in self.solve(world, strongest_once_removed, upper)
                    for new_world in [World(
                        world.constraints.add(Subtyping(lower, upper)),
                        world.freezer, world.relids
                    )]
                    # if self.ensure_upper_intersection_inhabitable(new_world, lower.id, upper)
                ]
                return worlds
            ###################################
            else:
                strongest = interp[0]
                worlds = [
                    new_world
                    for world in self.solve(world, strongest, upper)
                    for new_world in [World(
                        world.constraints.add(Subtyping(lower, upper)),
                        world.freezer, world.relids
                    )]
                    # if self.ensure_upper_intersection_inhabitable(new_world, lower.id, upper)
                ]
                return worlds

        elif isinstance(lower, Exi):
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG: strong, Exi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# strong:
# {concretize_typ(strong)}

# weak:
# {concretize_typ(weak)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            renaming = self.make_renaming(lower.ids)
            strong_constraints = sub_constraints(renaming, lower.constraints)
            strong_body = sub_typ(renaming, lower.body)
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
                for m1 in [World(m0.constraints, m0.freezer.union(renamed_ids), m0.relids)]
                for m2 in self.solve(m1, strong_body, upper)
            ]

        #######################################
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

        elif isinstance(upper, TField) and isinstance(upper.body, Inter):
            return [
                m1
                for m0 in self.solve(world, lower, TField(upper.label, upper.body.left))
                for m1 in self.solve(m0, lower, TField(upper.label, upper.body.right))
            ]

        elif isinstance(lower, Unio):
            return [
                m1
                for m0 in self.solve(world, lower.left, upper)
                for m1 in self.solve(m0, lower.right, upper)
            ]

        elif isinstance(upper, Inter):
            return [
                m1 
                for m0 in self.solve(world, lower, upper.left)
                for m1 in self.solve(m0, lower, upper.right)
            ]

        elif isinstance(upper, Diff): 
            if diff_well_formed(upper):
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
                    if (
                        not self.is_inhabitable(world, lower) or 
                        self.solve(m, lower, upper.negation) == []
                    )
                ]   
            else:
                return []
        
        #######################################
        #######################################

        elif isinstance(lower, TVar) and lower.id in world.freezer: 
            if lower.id in world.relids and isinstance(upper, TVar) and upper.id not in world.freezer:
                # NOTE: No interpretation means the variable is relationally constrained;
                return [World(
                    world.constraints.add(Subtyping(lower, upper)),
                    world.freezer, world.relids
                )]
            else:
                interp = self.resolve_strongest_upper_bound(world, lower.id)
                weakest_strong = interp[0]
                return self.solve(world, weakest_strong, upper)
            #end if-else
        #end if-else


        elif isinstance(upper, TVar) and upper.id not in world.freezer: 
            # TODO: remove relational case unless we can determine why it's needed
            # if upper.id in world.relids:
            #     # TODO: add safety check; e.g. that weak is TOP or weaker than strong 
            #     return [World(
            #         world.constraints.add(Subtyping(lower, upper)),
            #         world.freezer, world.relids
            #     )]
            interp = self.resolve_strongest_upper_bound(world, upper.id)
            if isinstance(interp[0], Top):
                return [World(
                    world.constraints.add(Subtyping(lower, upper)),
                    world.freezer, world.relids
                )]
            ###################################
            elif isinstance(interp[0], TVar) and (interp[0].id in world.freezer):
                # NOTE: the existence of a L <: F connstraint implies that a frozen variable can be expanded by subsequent information. 
                # NOTE: what examples is this necessary for? 

                # return [World(
                #     world.constraints.add(Subtyping(lower, upper)),
                #     world.freezer, world.relids
                # )]

                # TODO: add safety check? what is the safety condition?
                weakest_once_removed = self.resolve_strongest_upper_bound(world, interp[0].id)[0]
                return [
                    World(
                        world.constraints.add(Subtyping(lower, upper)),
                        world.freezer, world.relids
                    )
                    for world in self.solve(world, lower, weakest_once_removed)
                ]
            ###################################
            else:
                weakest = interp[0]
                return [
                    World(
                        world.constraints.add(Subtyping(lower, upper)),
                        world.freezer, world.relids
                    )
                    for world in self.solve(world, lower, weakest)
                ]
            #end if-else

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
                for m1 in [World(m0.constraints, m0.freezer.union(renamed_ids), m0.relids)]
                for m2 in self.solve(m1, lower, weak_body)
            ]

        elif isinstance(lower, All): 
            renaming = self.make_renaming(lower.ids)
            strong_constraints = sub_constraints(renaming, lower.constraints)
            strong_body = sub_typ(renaming, lower.body)
            worlds = self.solve(world, strong_body, upper) 
            for constraint in strong_constraints:
                worlds = [
                    m1
                    for m0 in worlds
                    # for m1 in self.solve_or_cache(m0, constraint.lower, constraint.upper)
                    for m1 in self.solve(m0, constraint.lower, constraint.upper)
                ]

            return worlds

        elif isinstance(upper, TVar) and upper.id in world.freezer: 
            interp = self.resolve_weakest_lower_bound(world, upper.id)
            strongest_weak = interp[0]
            return self.solve(world, lower, strongest_weak)


        #######################################
        #### Grounding rules: ####
        #######################################

        elif isinstance(upper, Top): 
            return [world] 

        elif isinstance(lower, Bot): 
            return [world] 

        elif isinstance(lower, Top): 
            return [] 

        elif isinstance(upper, Bot): 
            return [] 

        elif isinstance(lower, Fixpoint):
            if is_typ_structured(lower.body):
                '''
                NOTE: k-induction / bi-simulation
                use the pattern on LHS to dictate number of unrollings needed on RHS 
                simply need to sub RHS into LHS's self-referencing variable
                '''
                '''
                sub in induction hypothesis to world:
                '''
                renaming : PMap[str, Typ] = pmap({lower.id : upper})
                strong_body = sub_typ(renaming, lower.body)
                return self.solve(world, strong_body, upper)
            else:
                return []

        elif isinstance(upper, Fixpoint): 

#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG: upper, LeastFP 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# strong:
# {concretize_typ(lower)}

# weak:
# {concretize_typ(upper)}

# constraints:
# {concretize_constraints(world.constraints)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)


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

            # TODO: don't interpret learnable variables as frozen variables
            # - is this necessary? this notion breaks the even_list subs nat_list
            # ignored_ids = get_freezer_adjacent_learnable_ids(world)
            ignored_ids = s()
            reduced_strong = self.resolve_polarity(True, world, lower, ignored_ids)[0]
            print(f"""
~~~~~~~~~~~~~~~~~~~~~
DEBUG upper, LeastFP
~~~~~~~~~~~~~~~~~~~~~
world.relids: 
{world.relids}

world.freezer: 
{world.freezer}

world.constraints: 
{concretize_constraints(tuple(world.constraints))}

lower: 
{concretize_typ(lower)}

reduced_strong: 
{concretize_typ(reduced_strong)}

upper: 
{concretize_typ(upper)}
~~~~~~~~~~~~~~~~~~~~~
            """)

#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~
# DEBUG upper, LeastFP
# ~~~~~~~~~~~~~~~~~~~~~
# is_decidable: 
# {is_decidable(reduced_strong, upper)}
# ~~~~~~~~~~~~~~~~~~~~~
#             """)
            if lower != reduced_strong:
                print("~~~~~~ NOT FULLY REDUCED")
                return self.solve(world, reduced_strong, upper)
            elif is_decidable(lower, upper):
                print("~~~~~~ UNROLLING")
                '''
                unroll
                '''
                renaming : PMap[str, Typ] = pmap({upper.id : upper})
                weak_body = sub_typ(renaming, upper.body)
                worlds = self.solve(world, lower, weak_body)
                return worlds
            else:
                assumed_relational_typ = lookup_normalized_relational_typ(world, lower)
                if assumed_relational_typ != None:
                    print("~~~~~ A")
                    # NOTE: this only uses the strict interpretation; so frozen or not doesn't matter
                    ordered_paths = [k for (k,v) in extract_ordered_path_target_pairs(lower)]
                    normalized_upper = normalize_least_fp(upper, ordered_paths)
                    worlds = self.solve(world, assumed_relational_typ, normalized_upper)
                    return worlds
                elif self.is_fixpoint_constraint_safe(world, lower, upper):
                    print("~~~~~ B")
                    """
                    NOTE: frozen variables should be interpreted away at this point 
                    """
                    lower_fvs = extract_free_vars_from_typ(s(), lower)  
                    assert all((fv not in world.freezer) for fv in lower_fvs)
                    return [World(
                        # world.constraints.difference(used_constraints).add(Subtyping(reduced_strong, weak)),
                        world.constraints.add(Subtyping(lower, upper)),
                        world.freezer, world.relids.union(lower_fvs)
                    )]
                else:
                    print("~~~~~ C")
                    return []

        elif isinstance(lower, Diff):
            if diff_well_formed(lower):
                '''
                A \\ B <: T === A <: T | B  
                '''
                return self.solve(world, lower.context, Unio(upper, lower.negation))
            else:
                return []


        elif isinstance(upper, Unio): 
            return self.solve(world, lower, upper.left) + self.solve(world, lower, upper.right)

        elif isinstance(lower, Inter): 
            return self.solve(world, lower.left, upper) + self.solve(world, lower.right, upper)


        #######################################
        #### Unification rules: ####
        #######################################

        elif isinstance(lower, TUnit) and isinstance(upper, TUnit): 
            return [world] 

        elif isinstance(lower, TTag) and isinstance(upper, TTag): 
            if lower.label == upper.label:
                return self.solve(world, lower.body, upper.body) 
            else:
                return [] 

        elif isinstance(lower, TField) and isinstance(upper, TField): 
            if lower.label == upper.label:
                return self.solve(world, lower.body, upper.body) 
            else:
                return [] 

        elif isinstance(lower, Imp) and isinstance(upper, Imp): 
            worlds = [
                m1
                for m0 in self.solve(world, upper.antec, lower.antec) 
                for m1 in self.solve(m0, lower.consq, upper.consq) 
            ]
            return worlds

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
    def __init__(self, solver : Solver, light_mode : bool):
        self.solver = solver
        # TODO: split all rules into two modes
        self.light_mode = light_mode

#     def evolve_worlds(self, nt : Context, t : Typ) -> list[World]:
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
class Result:
    worlds: list[World]
    typ: Typ

class BaseRule(Rule):

    def combine_var(self, nt : Context, id : str) -> Result:
        return Result(nt.worlds, nt.enviro[id])

    def combine_assoc(self, nt : Context, argchain : list[Typ]) -> Result:
        if len(argchain) == 1:
            return Result(nt.worlds, argchain[0])
        else:
            applicator = argchain[0]
            arguments = argchain[1:]
            result = ExprRule(self.solver, self.light_mode).combine_application(nt, applicator, arguments) 
            return result

    def combine_unit(self, nt : Context) -> Result:
        return Result(nt.worlds, TUnit())

    def distill_tag_body(self, nt : Context, label : str) -> Context:
        worlds = nt.worlds
        return Context(nt.enviro, worlds)

    def combine_tag(self, nt : Context, label : str, body : TVar) -> Result:
        return Result(nt.worlds, TTag(label, body))

    def combine_record(self, nt : Context, branches : list[RecordBranch]) -> Result:
        result = Top() 
        for branch in reversed(branches): 
            for branch_world in reversed(branch.worlds):
                new_world = branch_world

                # (body_typ, body_used_constraints) = self.solver.interpret_with_polarity(True, new_world, branch.body, s())
                body_typ = branch.body
                # new_world = World(new_world.constraints.difference(body_used_constraints), new_world.freezer, new_world.relids)

                field = TField(branch.label, body_typ)
                ######## NOTE: no generalization since the negative position is merely a label #############
                ######## NOTE: However; it can use universal type for its conditional constraints ##########
                constraints = tuple(extract_reachable_constraints_from_typ(branch_world, field))
                if constraints:
                    constrained_field = All((), constraints, field)
                else:
                    constrained_field = field 
                #############################################
                result = Inter(constrained_field, result)
            '''
            end for 
            '''
        '''
        end for 
        '''

        return Result(nt.worlds, simplify_typ(result))

    def combine_function(self, nt : Context, branches : list[Branch]) -> Result:
        augmented_branches = self.solver.augment_branches_with_diff(branches)
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

        constrained_branches = []
        for branch in reversed(augmented_branches): 
            '''
            interpret
            '''
            new_world = branch.world

            # TODO: ensure that it's safe to remove used constraints after interpretation
            # - safety criteria: interpreted variables are NOT used elsewhere 
            # - ERROR: safety criteria doesn't seem to be met by branch body
            # (return_typ, return_used_constraints) = self.solver.interpret_with_polarity(True, new_world, branch.body, s())
            return_typ = branch.body
            # new_world = World(new_world.constraints.difference(return_used_constraints), new_world.freezer, new_world.relids)
            # (param_typ, param_used_constraints) = self.solver.interpret_with_polarity(False, new_world, branch.pattern, extract_free_vars_from_typ(s(), return_typ))
            param_typ = branch.pattern
            # new_world = World(new_world.constraints.difference(param_used_constraints), new_world.freezer, new_world.relids)
            imp = Imp(param_typ, return_typ)

            constrained_branches.append((new_world, imp))
        '''
        end for 
        '''
        if len(constrained_branches) == 1:
            new_world, imp = constrained_branches[0]
#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function SINGLE BRANCH
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# result: {concretize_typ(simplify_typ(imp))}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)
            return Result([new_world], simplify_typ(imp))
        else:
            result = Top()
            for new_world, imp in constrained_branches:
                ######## DEBUG: without generalization #############
                # constraints = tuple(extract_reachable_constraints_from_typ(new_world, imp))
                # if constraints:
                #     generalized_case = All((), constraints, imp)
                # else:
                #     generalized_case = imp
                ######## NOTE: construct existential #############
                reachable_constraints = extract_reachable_constraints_from_typ(new_world, imp)
                existential_constraints = extract_existential_constraints(new_world.freezer, reachable_constraints)
                reachable_ids = extract_free_vars_from_constraints(s(), reachable_constraints).union(extract_free_vars_from_typ(s(), imp))
                existential_bound_ids = tuple(sorted(new_world.freezer.intersection(reachable_ids)))

                if not existential_bound_ids:
                    assert not existential_constraints
                    body = imp 
                else:
                    body = Exi(existential_bound_ids, tuple(sorted(existential_constraints)), imp)
                #end if-else


                ######## NOTE: generalization #############
                # TODO: figure out a less cluttered way to include extrusion
                # TODO: consider using special extruded flag and/or representation that igonroes extruded variables

                fvs = sorted(extract_free_vars_from_typ(s(), imp.antec).difference(new_world.freezer))
                renaming = self.solver.make_renaming_tvars(fvs)
                sub_map = cast_up(renaming)
                bound_ids = tuple(sorted(var.id for var in renaming.values()))

                constraints = (
                    sub_constraints(sub_map, tuple(sorted(reachable_constraints.difference(existential_constraints))))
                )

                renamed_body = sub_typ(sub_map, body)
                if bound_ids or constraints:
                    generalized_case = All(bound_ids, constraints, renamed_body)
                else:
                    generalized_case = renamed_body
                #############################################
                result = Inter(generalized_case, result)

#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_function
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# new_world.constraints:
# {concretize_constraints(new_world.constraints)}

# new_world.freezer: {new_world.freezer} 

# new_world.relids: {new_world.relids} 

# reachable_constraints:
# {concretize_constraints(reachable_constraints)}

# existential_constraints:
# {concretize_constraints(existential_constraints)}

# imp:
# {concretize_typ(imp)}

# body_typ:
# {concretize_typ(body)}


# result:
# {concretize_typ(result)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                 """)
            '''
            end for
            '''
            return Result(nt.worlds, simplify_typ(result))
        #end if/else
    '''
    end def
    '''

class ExprRule(Rule):

    def distill_tuple_head(self, nt : Context) -> Context:
        return nt

    def distill_tuple_tail(self, nt : Context, head_typ : Typ) -> Context:
        return nt 

    def combine_tuple(self, nt : Context, head_var : TVar, tail_var : TVar) -> Result:
        return Result(nt.worlds, Inter(TField('head', head_var), TField('tail', tail_var)))

    def distill_ite_condition(self, nt : Context) -> Context:
        return nt

    def distill_ite_true_branch(self, nt : Context, condition_typ : Typ) -> Context:
        return nt 

    def distill_ite_false_branch(self, nt : Context, condition_typ : TVar, true_body_typ : TVar) -> Context:
        return nt

    def combine_ite(self, nt : Context, condition_typ : Typ, 
                true_body_worlds: list[World], true_body_typ : Typ, 
                false_body_worlds: list[World], false_body_typ :Typ 
    ) -> Result: 
        branches = [
            Branch(true_body_worlds, TTag('true', TUnit()), true_body_typ), 
            Branch(false_body_worlds, TTag('false', TUnit()), false_body_typ)
        ]
        function_result = BaseRule(self.solver, self.light_mode).combine_function(nt, branches)
        nt = replace(nt, worlds = function_result.worlds)
        # print(f"""
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # DEBUG ite len(function_worlds): {len(function_worlds)}
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~
        # """)
        arguments = [condition_typ]
        return self.combine_application(nt, function_result.typ, arguments) 

    def distill_projection_rator(self, nt : Context) -> Context:
        return nt

    def distill_projection_keychain(self, nt : Context, rator_typ : Typ) -> Context: 
        return nt

    def combine_projection(self, nt : Context, record_typ : Typ, keys : list[str]) -> Result: 
        worlds = nt.worlds
        for key in keys:
            result_var = self.solver.fresh_type_var()
            worlds = [
                m1
                for m0 in worlds
                for m1 in self.solver.solve(m0, record_var, TField(key, result_var))
            ]
            record_var = result_var
        return Result(worlds, result_var)

    #########

    def distill_application_cator(self, nt : Context) -> Context: 
        return nt

    def distill_application_argchain(self, nt : Context, cator_typ : Typ) -> Context: 
        return nt

    def combine_application(self, nt : Context, cator_typ : Typ, arg_typs : list[Typ]) -> Result: 
        worlds = nt.worlds 
        for arg_typ in arg_typs:
            result_var = self.solver.fresh_type_var()
            new_worlds = []
            for world in worlds:
                # NOTE: interpretation to keep types and constraints compact 
                # cator_typ, cator_used_constraints = self.solver.interpret_with_polarity(True, world, cator_var, s())
                ignored_ids = get_freezer_adjacent_learnable_ids(world)
                # arg_typ, arg_used_constraints = self.solver.interpret_with_polarity(True, world, arg_typ, ignored_ids)
                # arg_typ, arg_used_constraints = (arg_var, s())

#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG application
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# world.freezer: {tuple(world.freezer)}

# world.constraints: 
# {concretize_constraints(world.constraints)}


# cator_typ: {concretize_typ(cator_typ)}
# cator_var: {concretize_typ(cator_var)}
# cator_used_constraints:
# {concretize_constraints(cator_used_constraints)}

# arg_typ: {concretize_typ(arg_typ)}
# arg_var: {arg_var.id}
# arg_used_constraints:
# {concretize_constraints(arg_used_constraints)}

# result_var: {result_var.id}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                 """)

                # world = World(world.constraints.difference(cator_used_constraints).difference(arg_used_constraints), world.freezer, world.relids)
                new_worlds.extend(self.solver.solve(world, cator_typ, Imp(arg_typ, result_var)))
            worlds = new_worlds

            # TODO: remove version without interpretation
            # worlds = [
            #     m1
            #     for m0 in worlds
            #     for m1 in self.solver.solve(m0, cator_var, Imp(arg_var, result_var))
            # ] 
            ###########################
            cator_typ = result_var

        return Result(worlds, result_var)

    #########
    def distill_funnel_arg(self, nt : Context) -> Context: 
        return nt

    def distill_funnel_pipeline(self, nt : Context, arg_typ : TVar) -> Context: 
        return nt

    def combine_funnel(self, nt : Context, arg_typ : Typ, cator_typs : list[Typ]) -> Result: 
        worlds = nt.worlds
        for cator_typ in cator_typs:
            app_nt = replace(nt, worlds = worlds) 
            app_result = self.combine_application(app_nt, cator_typ, [arg_typ])
            worlds = app_result.worlds
            result_typ = app_result.typ
            arg_typ = result_typ 

        # NOTE: add final constraint to connect to expected type var: the result_typ <: nt.typ_var
        return Result(worlds, result_typ)

    def distill_fix_body(self, nt : Context) -> Context:
        return nt

    def combine_fix(self, nt : Context, body_typ : Typ) -> Result:
        """
        from: 
        SELF -> (nil -> zero) & (cons A\\nil -> succ B) ;  SELF <: A -> B SELF(A) <: B
        --------------- OR -----------------------
        ALL[X . X <: nil | cons A] X -> EXI[Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] Y
        --------------- OR -----------------------
        ALL[X Y . (X, Y) <: (nil,zero) | (cons A\\nil, succ B)] X -> EXI[Z ; Z <: Y] Z
        """

#         print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_fix START 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# body_typ: {concretize_typ(body_typ)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#         """)

        self_typ = self.solver.fresh_type_var()
        in_typ = self.solver.fresh_type_var()
        out_typ = self.solver.fresh_type_var()

        IH_typ = self.solver.fresh_type_var()

        assert nt.worlds
        outer_worlds = []
        for outer_world in nt.worlds:

            '''
            Construct a least fixed point type over union from the inner worlds
            '''

            # body_interp = self.solver.interpret_upper_id(outer_world, body_var.id)
            # (body_typ, body_used_constraints) = (body_interp if body_interp else (body_var, s())) 
            # outer_world = replace(outer_world, constraints = outer_world.constraints.difference(body_used_constraints))

            outer_worlds.append(outer_world)
            inner_worlds = self.solver.solve(outer_world, body_typ, Imp(self_typ, Imp(in_typ, out_typ)))

            induc_body = Bot()
            # NOTE: don't actually need the upper bound for param 
            # param_body = Bot()

            ###########################
            for i, inner_world in enumerate(reversed(inner_worlds)):

                # NOTE: avoid over-interpreting into extruded type;
                # TODO: if this is too restrictive, consider using an extrusion flag to indicate stopping point for interpret_with_polarity. 
                # NOTE: self_typ, in_typ, and out_typ are created here; we know they are not used elswhere; so it's safe to remove their used constraints
                left_interp = self.solver.resolve_strongest_upper_bound(inner_world, in_typ.id)
                (left_typ, left_used_constraints) = (
                    left_interp 
                    if in_typ.id not in inner_world.relids else 
                    (in_typ, s())
                )
                inner_world = World(inner_world.constraints.difference(left_used_constraints), inner_world.freezer, inner_world.relids)

                # NOTE: allow multi-step interpretation, since extruded variables don't play a role in this direction
                # TODO: should left_typ variables be ignored to prevent over interpretation; see similar idea in resolve_polarity - Imp case 
                # ignored_ids = s()
                ignored_ids = extract_free_vars_from_typ(s(), left_typ)
                right_interp = self.solver.resolve_polarity(True, inner_world, out_typ, ignored_ids)
                # right_interp = self.solver.resolve_strongest_upper(inner_world, out_typ.id)
                (right_typ, right_used_constraints) = right_interp
                inner_world = World(inner_world.constraints.difference(right_used_constraints), inner_world.freezer, inner_world.relids)

                left_bound_ids = extract_free_vars_from_typ(s(), left_typ)
                right_bound_ids = extract_free_vars_from_typ(s(), right_typ)
                bound_ids = left_bound_ids.union(right_bound_ids).union(
                    inner_world.freezer.intersection(extract_free_vars_from_constraints(s(), inner_world.constraints))
                )
                rel_pattern = make_pair_typ(left_typ, right_typ)
                #########################################

                # TODO: it may not be safe to remove used_constraints from multihop interpretation 
                # TODO: need a safety argument for removing used_constraints
                # - argument: constriants aren't removed; but are merely rerwritten
                self_interp = self.solver.resolve_polarity(False, inner_world, self_typ, s())
                # self_interp = self.solver.interpret_lower_id(inner_world, self_typ.id)
                # TODO: linearize intersections of self_interp
                # - remove redudant types
                # - there could be multiple implications due to multiple applications of recursive function 
                # - are all of them necessary for constructing inductive hypothesis?
                self_interps = list(set(linearize_intersections(self_interp[0])))
#                 print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_fix --- self_interp 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# self_interp: {concretize_typ(self_interp[0])}

# self_interps: 
# {[concretize_typ(t) for t in self_interps]}

# self_typ: {concretize_typ(self_typ)}

# inner_world.constraints:
# {concretize_constraints(inner_world.constraints)}

# left_used_constraints:
# {concretize_constraints(left_used_constraints)}

# right_used_constraints:
# {concretize_constraints(right_used_constraints)}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# in_typ: {in_typ.id}
# left_typ: {concretize_typ(left_typ)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# out_typ: {out_typ.id}
# right_typ: {concretize_typ(right_typ)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                 """)

                self_used_constraints = self_interp[1]
                IH_rel_constraints = s()
                IH_left_constraints = s()

                for self_interp_case in self_interps:
                    if isinstance(self_interp_case, Imp):
                        self_left = self_interp_case.antec
                        self_right = self_interp_case.consq
    #                     print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # DEBUG combine_fix --- SELF used constraints
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # self_used_constraints:
    # {concretize_constraints(self_used_constraints)}

    # self_used_constraints.intersection(outer_world.constraints):
    # {concretize_constraints(self_used_constraints.intersection(outer_world.constraints))}

    # body_typ: {concretize_typ(body_typ)}
    # in_typ: {in_typ.id}
    # out_typ: {out_typ.id}
    # self_typ: {self_typ.id}
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #                     """)
                        IH_rel_constraints = IH_rel_constraints.add(Subtyping(make_pair_typ(self_left, self_right), IH_typ))
                        IH_left_constraints = IH_left_constraints.add(Subtyping(self_left, IH_typ))
                    #end if
                #end for

                # TODO: remove; this shouldn't be necessary if body is interpreted before solving
                # inner_world = World(pset(
                #     st
                #     for st in inner_world.constraints.difference(self_used_constraints)
                #     if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
                # ) , inner_world.freezer, inner_world.relids)

                # NOTE: assert that used constaints are local, therefore safe to remove erroneously disconnecting uninterpreted variables elsewhere 
                assert not bool(self_used_constraints.intersection(outer_world.constraints)) 
                inner_world = replace(inner_world, constraints = inner_world.constraints.difference(self_used_constraints))
                rel_reachable_constraints = pset(
                    st
                    for st in extract_reachable_constraints_from_typ(inner_world, rel_pattern)
                    # if not self.solver.is_constraint_dead(inner_world, s(), st)
                    if not self.solver.is_constraint_dead(inner_world, extract_free_vars_from_typ(s(), rel_pattern), st)
                )
                rel_constraints = IH_rel_constraints.union(rel_reachable_constraints)
                

                # NOTE: parameter constraint isn't actually necessary; sound without it.
                # left_reachable_constraints = extract_reachable_constraints_from_typ(inner_world, left_typ)
                # left_constraints = IH_left_constraints.union(left_reachable_constraints)

                if bool(bound_ids):
                    constrained_rel = Exi(tuple(sorted(bound_ids)), tuple(sorted(rel_constraints)), rel_pattern)
                else:
                    assert not bool(rel_constraints)
                    constrained_rel = rel_pattern

                # TODO: remove old commented code
                # rel_world = World(pset(rel_constraints), pset(bound_ids), inner_world.relids)
                # package_typ(rel_world, rel_pattern)


                # NOTE: parameter constraint isn't actually necessary; sound without it.
                # if bool(left_bound_ids):
                #     constrained_left = Exi(tuple(sorted(left_bound_ids)), tuple(sorted(left_constraints)), left_typ)
                # else:
                #     assert not bool(left_constraints)
                #     constrained_left = left_typ

                # TODO: remove old commented code
                # left_world = World(pset(left_constraints).difference(left_used_constraints), pset(left_bound_ids), inner_world.relids)
                # constrained_left = package_typ(left_world, left_typ)

                induc_body = Unio(constrained_rel, induc_body) 
                # NOTE: parameter constraint isn't actually necessary; sound without it.
                # param_body = Unio(constrained_left, param_body)

            #end for

            rel_typ = Fixpoint(IH_typ.id, induc_body)
            # NOTE: parameter constraint isn't actually necessary; sound without it.
            # param_upper = LeastFP(IH_typ.id, param_body)



            param_typ = self.solver.fresh_type_var()
            return_typ = self.solver.fresh_type_var()
            consq_constraint = Subtyping(make_pair_typ(param_typ, return_typ), rel_typ)
            consq_typ = Exi(tuple([return_typ.id]), tuple([consq_constraint]), return_typ)  
            result = All(tuple([param_typ.id]), tuple(), Imp(param_typ, consq_typ))  
            # NOTE: parameter constraint isn't actually necessary; sound without it.
            # result = All(tuple([param_typ.id]), tuple([Subtyping(param_typ, param_upper)]), Imp(param_typ, consq_typ))  

#             print(f"""
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEBUG combine_fix 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# result:
# {concretize_typ(result)}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#             """)


        # TODO: remove; this shouldn't be necessary since body is interpreted and used constraints are removed
        # nt = replace(nt, worlds = [
        #     World(pset(
        #         st
        #         for st in world.constraints
        #         if (st.strong != body_var) and (st.weak != body_var) # remove body var which has been merely used for transitivity. 
        #     ) , world.freezer, world.relids)
        #     for world in nt.worlds
        # ])
        return Result(outer_worlds, result)
        ##################################

    
    def distill_let_target(self, nt : Context, id : str) -> Context:
        return nt

    def distill_let_contin(self, nt : Context, id : str, target : Typ) -> Context:
        enviro = nt.enviro.set(id, target)
        return Context(enviro, nt.worlds)

'''
end ExprRule
'''


class RecordRule(Rule):

    def distill_single_body(self, nt : Context, id : str) -> Context:
        return nt

    def combine_single(self, nt : Context, label : str, body_worlds : list[World], body_var : TVar) -> list[RecordBranch]:
        return [RecordBranch(body_worlds, label, body_var)]

    def distill_cons_body(self, nt : Context, id : str) -> Context:
        return self.distill_single_body(nt, id)

    def distill_cons_tail(self, nt : Context, id : str, body_var : TVar) -> Context:
        return nt

    def combine_cons(self, nt : Context, label : str, body_worlds : list[World], body_var : TVar, tail : list[RecordBranch]) -> list[RecordBranch]:
        return self.combine_single(nt, label, body_worlds, body_var) + tail

class FunctionRule(Rule):

    def distill_single_body(self, nt : Context, pattern_attr : PatternAttr) -> Context:
        enviro = pattern_attr.enviro
        worlds = nt.worlds
        return Context(nt.enviro.update(enviro), worlds)

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
        return nt

    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def combine_single(self, nt : Context, content_var : TVar) -> ArgchainAttr:
        return ArgchainAttr(nt.worlds, [content_var])

    def combine_cons(self, nt : Context, head_var : TVar, tail_vars : list[TVar]) -> ArgchainAttr:
        return ArgchainAttr(nt.worlds, [head_var] + tail_vars)

######

class PipelineRule(Rule):

    def distill_single_content(self, nt : Context) -> Context:
        return nt

    def distill_cons_head(self, nt : Context) -> Context:
        return self.distill_single_content(nt)

    def distill_cons_tail(self, nt : Context, head_var : TVar) -> Context:
        return nt

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
    def combine_anno(self, nt : Context, anno_typ : Typ) -> Result: 
        return Result(nt.worlds, anno_typ)

