from __future__ import annotations

from dataclasses import dataclass
from typing import TypeVar, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

from core.meta_autogen import *
from core import construction_system, line_format_system

T = TypeVar('T')
D = TypeVar('D')
U = TypeVar('U')


def to_dictionary(node: Rule):

    class Handler(ItemHandler):
        def case_Keyword(self, o): 
            return {
                'kind' : 'terminal_const',
                'content' : o.content
            }
        def case_Terminal(self, o):
            return {
                'kind' : 'terminal_var',
                'relation' : o.relation,
                'vocab_key' : o.key
            }
        def case_Nonterm(self, o): 
            return {
                'kind' : 'grammar',
                'relation' : o.relation,
                'grammar_key' : o.key,
                'format' : line_format_system.to_string(o.format),
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

    class Handler(ItemHandler):
        def case_Keyword(self, o):
            fail()
        def case_Terminal(self, o):
            return construction_system.Field(
                attr = o.relation, 
                typ = 'str', 
                default = ""
            )
        def case_Nonterm(self, o):
            return construction_system.Field(
                attr = o.relation, 
                typ = f'{o.key} | None', 
                default = ""
            )

    return construction_system.Constructor(
        n.name, [], [
            item.match(Handler())
            for item in n.content
            if not isinstance(item, Keyword)
        ] + [
            construction_system.Field(attr = "source_start", typ = 'int', default = "0"),
            construction_system.Field(attr = "source_end", typ = 'int', default = "0"),
        ]
    )


def get_abstract_items(rule : Rule): 
    return [item
        for item in rule.content
        if not isinstance(item, Keyword)
    ]


def type_from_item(item : Item, prefix : str = ""):
    if isinstance(item, Nonterm):
        if prefix:
            return f"{prefix}.{item.key}"
        else:
            return item.key

    elif isinstance(item, Terminal):
        return "str" 
    else:
        raise Exception()

def relation_from_item(item : Item):
    if isinstance(item, Nonterm):
        return item.relation
    elif isinstance(item, Terminal):
        return item.relation 
    else:
        raise Exception()


def is_inductive(type_name : str, rules : list[Rule]) -> bool:
    for rule in rules:
        for item in rule.content:
            if not isinstance(item, Keyword) and type_name == type_from_item(item, ""):
                return True
    return False


class Syntax:
    def __init__(self, 
        start : str,
        singles : list[Rule], 
        choices : dict[str, Choice],
    ):
        self.singles = singles
        self.choices = choices
        self.start = start


        self.rule_map = (
            {
                r.name : {r.name : r} 
                for r in self.singles
            } | {
                key : {
                    r.name : r
                    for r in choice.dis_rules.values() 
                } | {
                    r.name : r
                    for r in [choice.fall_rule]
                }
                for key, choice in self.choices.items()
            }
        )

        self.total : dict [str, Choice] = (
            {
                r.name : Choice({}, r)
                for r in self.singles
            } | self.choices
        )

class Semantics(Generic[D, U]): 
    pass