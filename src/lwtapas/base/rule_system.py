from __future__ import annotations

from dataclasses import dataclass
from typing import TypeVar, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

from lwtapas.base.rule_construct_autogen import *
from lwtapas.base import construction_system
from lwtapas.base import line_format_system as lf


def to_dictionary(node: Rule):

    class Handler(ItemHandler):
        def case_Terminal(o): 
            return {
                'kind' : 'terminal',
                'terminal' : o.terminal
            }
        def case_Nonterm(o): 
            return {
                'kind' : 'grammar',
                'relation' : o.relation,
                'nonterminal' : o.nonterminal,
                'format' : lf.to_string(o.format),
            }

        def case_Vocab(o):
            return {
                'kind' : 'vocab',
                'relation' : o.relation,
                'vocab' : o.vocab
            }

    return {
        'name' : node.name,
        'children' : [
            item.match(Handler())
            for item in node.content
        ]

    }

def to_constructor(n : Rule) -> construction_system.Constructor:

    def fail():
        assert False 

    return construction_system.Constructor(
        n.name, [], [
            match_item(item, ItemHandlers[construction_system.Field](
                case_Terminal = lambda o : (
                    fail()
                ),
                case_Nonterm = lambda o : (
                    construction_system.Field(attr = o.relation, typ = f'{o.nonterminal} | None', default = "")
                ),
                case_Vocab = lambda o : (
                    construction_system.Field(attr = o.relation, typ = 'str', default = "")
                )
            )) 
            for item in n.content
            if not isinstance(item, Terminal)
        ] + [
            construction_system.Field(attr = "source_start", typ = 'int', default = "0"),
            construction_system.Field(attr = "source_end", typ = 'int', default = "0"),
        ]
    )


def get_abstract_items(rule : Rule): 
    return [item
        for item in rule.content
        if not isinstance(item, Terminal)
    ]


def type_from_item(item : item, prefix : str = ""):
    if isinstance(item, Nonterm):
        if prefix:
            return f"{prefix}.{item.nonterminal}"
        else:
            return item.nonterminal

    elif isinstance(item, Vocab):
        return "str" 
    else:
        raise Exception()

def relation_from_item(item : item):
    if isinstance(item, Nonterm):
        return item.relation
    elif isinstance(item, Vocab):
        return item.relation 
    else:
        raise Exception()


def is_inductive(type_name : str, rules : list[Rule]) -> bool:
    for rule in rules:
        for item in rule.content:
            if not isinstance(item, Terminal) and type_name == type_from_item(item, ""):
                return True
    return False


