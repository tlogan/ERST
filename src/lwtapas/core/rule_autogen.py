# THIS FILE IS AUTOGENERATED
# CHANGES MAY BE LOST



from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, TypeVar, Any, Generic, Union, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

T = TypeVar('T')


@dataclass(frozen=True, eq=True)
class SourceFlag: 
    pass



from core.line_format_autogen import LineFormat 
        


# type Item
@dataclass(frozen=True, eq=True)
class Item(ABC):
    @abstractmethod
    def match(self, handler : ItemHandler[T]) -> T:
        pass

# constructors for type Item

@dataclass(frozen=True, eq=True)
class Keyword(Item):
    content : str

    def match(self, handler : ItemHandler[T]) -> T:
        return handler.case_Keyword(self)

def make_Keyword(
    content : str
) -> Item:
    return Keyword(
        content
    )

def update_Keyword(source_Keyword : Keyword,
    content : Union[str, SourceFlag] = SourceFlag()
) -> Keyword:
    return Keyword(
        source_Keyword.content if isinstance(content, SourceFlag) else content
    )

        

@dataclass(frozen=True, eq=True)
class Terminal(Item):
    relation : str
    vocab_key : str

    def match(self, handler : ItemHandler[T]) -> T:
        return handler.case_Terminal(self)

def make_Terminal(
    relation : str, 
    vocab_key : str
) -> Item:
    return Terminal(
        relation,
        vocab_key
    )

def update_Terminal(source_Terminal : Terminal,
    relation : Union[str, SourceFlag] = SourceFlag(),
    vocab_key : Union[str, SourceFlag] = SourceFlag()
) -> Terminal:
    return Terminal(
        source_Terminal.relation if isinstance(relation, SourceFlag) else relation,
        source_Terminal.vocab_key if isinstance(vocab_key, SourceFlag) else vocab_key
    )

        

@dataclass(frozen=True, eq=True)
class Nonterm(Item):
    relation : str
    grammar_key : str
    format : LineFormat

    def match(self, handler : ItemHandler[T]) -> T:
        return handler.case_Nonterm(self)

def make_Nonterm(
    relation : str, 
    grammar_key : str, 
    format : LineFormat
) -> Item:
    return Nonterm(
        relation,
        grammar_key,
        format
    )

def update_Nonterm(source_Nonterm : Nonterm,
    relation : Union[str, SourceFlag] = SourceFlag(),
    grammar_key : Union[str, SourceFlag] = SourceFlag(),
    format : Union[LineFormat, SourceFlag] = SourceFlag()
) -> Nonterm:
    return Nonterm(
        source_Nonterm.relation if isinstance(relation, SourceFlag) else relation,
        source_Nonterm.grammar_key if isinstance(grammar_key, SourceFlag) else grammar_key,
        source_Nonterm.format if isinstance(format, SourceFlag) else format
    )

        

# case handler for type Item
class ItemHandler(ABC, Generic[T]):
    @abstractmethod
    def case_Keyword(self, o : Keyword) -> T :
        pass
    @abstractmethod
    def case_Terminal(self, o : Terminal) -> T :
        pass
    @abstractmethod
    def case_Nonterm(self, o : Nonterm) -> T :
        pass

     


# type and constructor Choice
@dataclass(frozen=True, eq=True)
class Choice:
    dis_rules : dict[str, Rule]
    fall_rule : Rule


def make_Choice(
    dis_rules : dict[str, Rule],
    fall_rule : Rule
) -> Choice:
    return Choice(
        dis_rules,
        fall_rule)

def update_Choice(source_Choice : Choice,
    dis_rules : Union[dict[str, Rule], SourceFlag] = SourceFlag(),
    fall_rule : Union[Rule, SourceFlag] = SourceFlag()
) -> Choice:
    return Choice(
        source_Choice.dis_rules if isinstance(dis_rules, SourceFlag) else dis_rules, 
        source_Choice.fall_rule if isinstance(fall_rule, SourceFlag) else fall_rule)

    

# type and constructor Rule
@dataclass(frozen=True, eq=True)
class Rule:
    name : str
    content : list[Item]


def make_Rule(
    name : str,
    content : list[Item]
) -> Rule:
    return Rule(
        name,
        content)

def update_Rule(source_Rule : Rule,
    name : Union[str, SourceFlag] = SourceFlag(),
    content : Union[list[Item], SourceFlag] = SourceFlag()
) -> Rule:
    return Rule(
        source_Rule.name if isinstance(name, SourceFlag) else name, 
        source_Rule.content if isinstance(content, SourceFlag) else content)

     
    