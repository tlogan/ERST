from __future__ import annotations

from dataclasses import dataclass
from typing import TypeVar, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

from core.meta_autogen import *
from core import construction_system, line_format_system
from core.construction_system import Construction, Constructor, Field

import itertools

from core.meta_autogen import Nonterm, Terminal

T = TypeVar('T')
D = TypeVar('D')
U = TypeVar('U')


def to_dictionary(node: Rule):

    class PatternToString(PatternHandler):
        def case_Terminal(self, p : Terminal) -> dict:
            return {
                'kind' : 'terminal',
                'vocab' : p.vocab
            }
        def case_Nonterm(self, p : Nonterm) -> dict: 
            return {
                'kind' : 'nonterm',
                'grammar' : p.grammar,
                'format' : line_format_system.to_string(p.format),
            }


    return {
        'name' : node.name,
        'children' : [
            {
                'relation' : item.relation,
                'pattern' : item.pattern.match(PatternToString())
            }
            for item in node.content
        ]

    }

def to_constructor(n : Rule) -> construction_system.Constructor:

    def fail():
        assert False 

    return construction_system.Constructor(
        n.name, [], [
            construction_system.Field(
                attr = item.relation, 
                typ = (
                    f'{item.pattern.grammar} | None'
                    if isinstance(item.pattern, Nonterm) else
                    'str'
                ), 
                default = ""
            )
            for item in n.content
        ] + [
            construction_system.Field(attr = "source_start", typ = 'int', default = "0"),
            construction_system.Field(attr = "source_end", typ = 'int', default = "0"),
        ]
    )


def type_from_item(item : Item, prefix : str = ""):
    if isinstance(item.pattern, Nonterm):
        if prefix:
            return f"{prefix}.{item.pattern.grammar}"
        else:
            return item.pattern.grammar

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
            if type_name == type_from_item(item, ""):
                return True
    return False


class Syntax:
    def __init__(self, 
        header : str,
        start : str,
        singles : list[Rule], 
        choices : dict[str, list[Rule]],
    ):
        self.header = header
        self.singles = singles
        self.choices = choices
        self.start = start


        self.full_map = (
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

class Semantics(Generic[D, U]): 
    pass

def generate_lexeme_code(lexicon : dict[str,str]) -> str:

    nl = "\n"

    header = '''
import ply.lex as lex
    '''

    code_tokens = f'''
tokens = (
{("," + nl).join(
    "    " + "r'" + token + "'" 
    for token in lexicon.keys()
)}
)
    '''

    code_rules = f'''
{nl.join(
    "t_" + key + " = " +  "r'" + regex + "'"
    for (key, regex) in lexicon.items()
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

    def from_rule_to_constructor(rule : Rule) -> Constructor:
        return Constructor(rule.name, [], [
            # item.match(ItemToField())
            Field(item.relation, (
                item.pattern.grammar
                if isinstance(item.pattern, Nonterm) else
                'str'
            ), '')
            for item in rule.content
        ]) 

    singles = [
        from_rule_to_constructor(rule)
        for rule in syntax.singles
    ]

    choices = {
        k : [
            from_rule_to_constructor(rule)
            for rule in rules 
        ] 
        for k, rules in syntax.choices.items()
    }
    return Construction(syntax.header, singles, choices)


def generate_semantics_base_code(syntax : Syntax) -> str:
    '''
    TODO
    '''

    nl = "\n"

    def extract_left_siblings(rule : Rule, relation : str): 


        def condition(item : Item) -> bool:
            return item.relation != relation 


        return [item.relation for item in (itertools.takewhile(condition, rule.content))]

    def make_combine_up_method(key : str, rule : Rule) -> str:

        params = "self, " + ", ".join([
            item.relation + " : U"
            for item in rule.content
        ])


        return f'''
    def combine_up_{key}_{rule.name}_({params}) -> Optional[D]:
        raise Exception("not yet implemented") 
        ''' 

    def make_item_method(key : str, rule : Rule, item : Item) -> str:

        class PatternToMethodStr(PatternHandler):
            def case_Nonterm(self, o: Nonterm) -> str:
                left_siblings = extract_left_siblings(rule, item.relation)
                params = "self, context : D, " + "".join([(ls + " : U, ") for ls in left_siblings]) + "gram : Grammar"

                return f'''
    def guide_down_{key}_{rule.name}_{item.relation}({params}) -> Optional[D]:
        raise Exception("not yet implemented") 
                ''' 
            def case_Terminal(self, o: Terminal) -> str:
                left_siblings = extract_left_siblings(rule, item.relation)
                params = "self, context : D, " + "".join([(ls + " : U, ") for ls in left_siblings]) + "vocab : Vocab"
                return f'''
    def analyze_terminal_{key}_{rule.name}_{item.relation}({params}) -> U:
        raise Exception("not yet implemented") 
                ''' 
        return item.pattern.match(PatternToMethodStr()) 




    method_codes = [
        method_code
        for key, inner_map in syntax.full_map.items()
        for _, rule in inner_map.items()
        for method_code in [
            make_combine_up_method(key, rule)
        ] + [
            make_item_method(key, rule, item)
            for item in rule.content
        ]
    ]

    return f'''
from core import meta_system
from typing import TypeVar, Optional
from core.rich_token_system import Grammar, Vocab

D = TypeVar('D')
U = TypeVar('U')




class SemanticsBase(meta_system.Semantics[D,U]):
{nl.join(method_codes) if len(method_codes) > 0 else "    pass"}
    '''



def generate_syntax_code(syntax : Syntax):
    return construction_system.generate(to_construction(syntax))