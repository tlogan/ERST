from __future__ import annotations

from dataclasses import dataclass
from typing import TypeVar, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

from core.meta_autogen import *
from core import construction_system, line_format_system
from core.construction_system import Construction, Constructor, Field
from core.meta_autogen import Keyword, Nonterm, Terminal

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
        header : str,
        start : str,
        singles : list[Rule], 
        choices : dict[str, Choice],
    ):
        self.header = header
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

        self.total : dict[str, Choice] = (
            {
                r.name : Choice({}, r)
                for r in self.singles
            } | self.choices
        )

        self.discrim_tokens : list[str] = (
            [
                discrim_token
                for choice in self.total.values()
                for discrim_token in choice.dis_rules.keys() 
            ]
        )


        self.keyword_tokens : list[str] = (
            [
                item.content
                for inner_map in self.rule_map.values()
                for rule in inner_map.values()
                for item in rule.content
                if isinstance(item, Keyword)
            ]
        )

        self.terminal_token_regex : dict[str,str] = (
            {
                item.key : item.regex
                for inner_map in self.rule_map.values()
                for rule in inner_map.values()
                for item in rule.content
                if isinstance(item, Terminal)
            }
        )

        self.lex_tokens : list[str] = (
            self.discrim_tokens + 
            self.keyword_tokens +
            list(self.terminal_token_regex.keys())
        )

        self.lex_rules : list[tuple[str, str]] = (
            [
                (t, t)
                for t in self.discrim_tokens
            ] +
            [
                (t, t)
                for t in self.keyword_tokens
            ] +
            [
                (k, v)
                for k, v in self.terminal_token_regex.items()
            ]
        )

class Semantics(Generic[D, U]): 
    pass

def generate_lexeme_code(syntax : Syntax) -> str:

    nl = "\n"

    header = '''
import ply.lex as lex
    '''

    code_tokens = f'''
tokens = (
{("," + nl).join(
    "    " + "r'" + token + "'" 
    for token in syntax.lex_tokens
)}
)
    '''

    code_rules = f'''
{nl.join(
    "t_" + key + " = " +  "r'" + regex + "'"
    for (key, regex) in syntax.lex_rules
)}
    '''

    backslash = "\\"

    return f"""
{header}
{code_tokens}
{code_rules}

def t_newline(t):
    {"r'" + backslash + "n+" + "'"}
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = '{" " + backslash + "t"}'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

lexer = lex.lex()
    """

def to_construction(syntax : Syntax) -> Construction:

    class ItemToField(ItemHandler):
        def case_Keyword(self, o: Keyword) -> Field:
            raise Exception("fail")

        def case_Nonterm(self, o: Nonterm) -> Field:
            return Field(o.relation, o.key, '')

        def case_Terminal(self, o: Terminal) -> Field:
            return Field(o.relation, 'str', '')

    def from_rule_to_constructor(rule : Rule) -> Constructor:
        return Constructor(rule.name, [], [
            item.match(ItemToField())
            for item in rule.content
            if not isinstance(item, Keyword)
        ]) 

    singles = [
        from_rule_to_constructor(rule)
        for rule in syntax.singles
    ]

    choices = {
        k : [
            from_rule_to_constructor(rule)
            for rule in choice.dis_rules.values()
        ] + [from_rule_to_constructor(choice.fall_rule)]
        for k, choice in syntax.choices.items()
    }
    return Construction(syntax.header, singles, choices)

def generate_semantics_base_code(syntax : Syntax) -> str:
    '''
    TODO
    '''

    nl = "\n"

    method_codes = [
        method_code
        for key, inner_map in syntax.rule_map.items()
        for tag, rule in inner_map.items()
        for method_code in [
            make_combine_up_method(key, tag, rule)
        ] + [
            make_guide_down_method(key, tag, rule, item)
            for item in rule.content
            if isinstance(item, Nonterm)
        ] + [
            make_analyze_terminal_method(key, tag, rule, item)
            for item in rule.content
            if isinstance(item, Terminal)
        ] + [
            make_analyze_keyword_method(key, tag, rule, item)
            for item in rule.content
            if isinstance(item, Keyword)
        ]
    ]

    return f'''
from core import language_system
class SemanticsBase(language_system.Semantics[D,U]):
{nl.join(method_codes)}
    '''

