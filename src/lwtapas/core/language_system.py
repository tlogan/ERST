from __future__ import annotations

from dataclasses import dataclass
from typing import TypeVar, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

from core.rule_autogen import *
from core import construction_system, line_format_system

T = TypeVar('T')
D = TypeVar('D')
U = TypeVar('U')


def to_dictionary(node: Rule):

    class Handler(ItemHandler):
        def case_Terminal(self, o): 
            return {
                'kind' : 'terminal',
                'terminal' : o.terminal
            }
        def case_Nonterm(self, o): 
            return {
                'kind' : 'grammar',
                'relation' : o.relation,
                'nonterminal' : o.nonterminal,
                'format' : line_format_system.to_string(o.format),
            }

        def case_Vocab(self, o):
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

    class Handler(ItemHandler):
        def case_Terminal(self, o):
            fail()
        def case_Nonterm(self, o):
            return construction_system.Field(
                attr = o.relation, 
                typ = f'{o.nonterminal} | None', 
                default = ""
            )
        def case_Vocab(self, o):
            return construction_system.Field(
                attr = o.relation, 
                typ = 'str', 
                default = ""
            )

    return construction_system.Constructor(
        n.name, [], [
            item.match(Handler())
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


def type_from_item(item : Item, prefix : str = ""):
    if isinstance(item, Nonterm):
        if prefix:
            return f"{prefix}.{item.nonterminal}"
        else:
            return item.nonterminal

    elif isinstance(item, Vocab):
        return "str" 
    else:
        raise Exception()

def relation_from_item(item : Item):
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


class Syntax:
    def __init__(self, 
        singles : list[Rule], 
        choices : dict[str, list[Rule]]
    ):
        self.singles = singles
        self.choices = choices


        self.map = (
            {
                r.name : {r.name : r} 
                for r in self.singles
            } | {
                key : {
                    r.name : r
                    for r in rules 
                }
                for key, rules in self.choices.items()
            }
        )

        self.rules =  (
            {
                r.name : r 
                for r in self.singles
            } | {
                r.name : r 
                for rs in self.choices.values()
                for r in rs 
            }
        )

        self.full = {
            rule.name : [rule]
            for rule in self.singles 
        } | self.choices

        self.portable = {
            name : [to_dictionary(rule) for rule in rules]
            for name, rules in self.full.items()
        }

class Guide(Generic[U]):
    pass

class Combiner(Generic[U]):
    pass

@dataclass
class Semantics(Generic[D, U]): 
    guide : Guide[D]
    combiner : Combiner[U]