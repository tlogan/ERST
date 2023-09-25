from __future__ import annotations
from typing import Iterator, Optional, Coroutine, Sequence

from core.rich_token_autogen import *

from core.line_format_system import LineFormat, LineFormatHandler, is_inline, next_indent_width
from core.meta_system import Rule, Item, PatternHandler, Terminal, Nonterm, Syntax, Semantics

from dataclasses import dataclass
from core.rich_token_autogen import Grammar, Vocab

from core import meta_system

import asyncio

import ply.lex as lex
from ply.lex import LexToken


T = TypeVar('T')
D = TypeVar('D')
U = TypeVar('U')

def from_primitive(ptok : list[str]) -> RichToken:
    assert len(ptok) == 4
    assert ptok[0] == "P"
    if ptok[1] == "grammar":
        return make_Grammar(ptok[2], ptok[3])
    else:
        assert ptok[1] == "vocab"
        return make_Vocab(ptok[2], ptok[3])


def raise_exception(e):
    raise e

def to_primitive(inst : RichToken) -> list[str]:
    class Handler(RichTokenHandler):
        def case_Grammar(self, o):
            return ["P", "grammar", o.key, o.selection]

        def case_Vocab(self, o): 
            return ["P", "vocab", o.key, o.selection]

    return inst.match(Handler())

def to_string(token : RichToken) -> str:
    class Handler(RichTokenHandler):
        def case_Grammar(self, g): return f"grammar: {g.selection} <{g.key}>"
        def case_Vocab(self, v): return f"vocab: {v.selection} <{v.key}>"
    return token.match(Handler())


def dump(rule_map : dict[str, Rule], RichTokens : tuple[RichToken, ...], indent : int = 4):

    @dataclass
    class Format:
        relation : str 
        depth : int 

    def dump_RichToken(inst : RichToken, format : Format) -> str:

        class Handler(RichTokenHandler):
            def case_Grammar(self, o):
                indent_str = (' ' * format.depth * indent)
                relation_str = (' = .' + format.relation if (isinstance(format.relation, str)) else '')
                return (
                    indent_str + o.selection + (' (' + o.key  + ')' if o.key != o.selection else '') +
                    relation_str
                )

            def case_Vocab(self, o):
                indent_str = (' ' * format.depth * indent)
                relation_str = (' = .' + format.relation if (isinstance(format.relation, str)) else '')
                return (
                    indent_str + o.selection + ' (' + o.key  + ')' +
                    relation_str
                )

        return inst.match(Handler())





    result_strs = [] 

    inst_iter = iter(RichTokens)

    stack : list[Format] = [Format("", 0)]

    while stack:
        format : Format = stack.pop()
        inst = next(inst_iter, None)

        if not inst:
            return '\n'.join(result_strs)

        class Formatter(RichTokenHandler):
            def case_Grammar(self, inst):
                nonlocal stack
                nonlocal format
                rule = rule_map[inst.selection]

                for item in reversed(rule.content):
                    class Handler(PatternHandler):
                        def case_Terminal(self, p):
                            return Format(item.relation, format.depth + 1)
                        def case_Nonterm(self, p): 
                            return Format(item.relation, format.depth + 1)

                    child_format = item.pattern.match(Handler())
                    stack += [child_format]

            def case_Vocab(self, inst):
                pass

        inst.match(Formatter())

        result_strs += [dump_RichToken(inst, format)]

    return '\n'.join(result_strs)


def concretize(rule_map : dict[str, Rule], RichTokens : tuple[RichToken, ...]) -> str:

    @dataclass
    class Format:
        inline : bool 
        indent_width : int 

    token_iter = iter(RichTokens)
    first_token = next(token_iter)
    assert isinstance(first_token, Grammar)
    stack : list[tuple[Format, Grammar, tuple[str, ...]]] = [(Format(True, 0), first_token, ())]

    stack_result : str | None = None 
    while stack:

        (format, token, children) = stack.pop()

        if stack_result != None:
            # get the result from the child in the stack
            children = children + (stack_result,) 
            stack_result = None

        rule = rule_map[token.selection]
        index = len(children)
        if index == len(rule.content):
            prefix = "" if format.inline else "\n" + "    " * format.indent_width
            stack_result = prefix + "".join(children)

        else:
            item = rule.content[index]
            if isinstance(item.pattern, Terminal):
                vocab_token = next(token_iter, None)
                if isinstance(vocab_token, Vocab):
                    if vocab_token.key == "comment" and vocab_token.selection:
                        comments = vocab_token.selection.split("\n")

                        comment = ('' if index == 0 else ' ') + ("\n" + ("    " * format.indent_width)).join([c for c in comments if c]) + "\n"

                        stack.append((format, token, children + (comment,)))
                    else:
                        stack.append((format, token, children + (vocab_token.selection,)))
                else:
                    break

            else: 
                assert isinstance(item.pattern, Nonterm)
                child_token = next(token_iter, None)

                stack.append((format, token, children))
                child_format = Format(is_inline(item.pattern.format), next_indent_width(format.indent_width, item.pattern.format))
                if isinstance(child_token, Grammar):
                    stack.append((child_format, child_token, ()))
                else:
                    break

    '''
    if stack is not empty, then input program must be incomplete
    so clean up the stack
    '''
    while stack:
        (format, token, children) = stack.pop()

        if stack_result != None:
            # get the result from the child in the stack
            children = children + (stack_result,) 

        rule = rule_map[token.selection]
        prefix = "" if format.inline else "\n" + "    " * format.indent_width
        stack_result = prefix + "".join(children)

    assert stack_result != None
    return stack_result
'''
end concretize
'''



'''
traverse stack and call combine_up and guide_down handlers
combine_up occurs after last child has been popped (i.e. return)
guide_down occurs before push (i.e. call) 
'''
async def analyze(
    syntax : Syntax, 
    semantics : Semantics[D, U],
    input : asyncio.Queue[RichToken], 
    output : asyncio.Queue[Optional[D]]
) -> U | None:

    token_init = await input.get()
    context_init : Optional[D] = None
    assert isinstance(token_init, Grammar)
    stack : list[tuple[Optional[D], Grammar, list[U]]] = [(context_init, token_init, [])]

    result : Optional[U] = None
    while stack:

        (context, gram, children) = stack.pop()

        if result != None:
            '''
            return the result from the sub procedure in the stack
            '''
            children = children + [result]
            result = None


        rule : Rule = syntax.full_map[gram.key][gram.selection]
        index = len(children)
        if index == len(rule.content):
            combine_method_name = f"combine_up_{gram.key}_{gram.selection}"
            result = getattr(semantics, combine_method_name)(*children)
        else:
            item = rule.content[index]
            if isinstance(item.pattern, Terminal):
                vocab_token = await input.get()

                if isinstance(vocab_token, Vocab):
                    terminal_method_name = f"analyze_terminal_{gram.key}_{gram.selection}_{item.relation}"
                    terminal_result : U = getattr(semantics, terminal_method_name)(context, *children, vocab_token) 
                    stack.append((context, gram, children + [terminal_result]))
                else:
                    break
            elif isinstance(item.pattern, Nonterm):
                child_token = await input.get()

                if isinstance(child_token, Grammar):
                    stack.append((context, gram, children))
                    guide_method_name = f"guide_down_{gram.key}_{gram.selection}_{item.relation}"
                    child_context : Optional[D] = getattr(semantics, guide_method_name)(context, *children, child_token) 
                    await output.put(child_context)
                    stack.append((child_context, child_token, []))

                else:
                    break
            else:
                assert(False)






    return result 
'''
end analyze 
'''


##########################################################################

def choose(rules : dict[str, Rule], lex_token) -> Rule:
    selection = next(
        rule
        for name, rule in rules.items()
        if isinstance(rule.content[0], Terminal) 
        if rule.content[0] == lex_token.type
    )
    return selection

async def parse(
    syntax : Syntax, 
    input : asyncio.Queue[LexToken], 
    output : asyncio.Queue[RichToken]
):
    '''
    stack keeps track of grammatical abstract token and child index to work on 
    '''
    lex_token_init = await input.get()
    rule_map = syntax.full_map[syntax.start]
    rule_init = choose(rule_map, lex_token_init)
    gram_init = Grammar(syntax.start, rule_init.name)

    '''
    stack keeps track of grammatical abstract token and index of child being worked on 
    '''
    await output.put(gram_init)
    stack : list[tuple[Rule, int]] = [(rule_init, 0)]

    backtrack_signal : bool = False


    while stack:
        (rule, child_index) = stack.pop()


        if backtrack_signal:
            '''
            return the result from the sub procedure in the stack
            '''
            child_index += 1
            backtrack_signal = False 

        if child_index == len(rule.content):
            backtrack_signal = True 

        else:

            lex_token : Any = await input.get()
            item = rule.content[child_index]
            if isinstance(item.pattern, Terminal):
                assert lex_token.type == item.key
                vocab = Vocab(item.key, lex_token.value)
                await output.put(vocab)
                stack.append((rule, child_index + 1))

            elif isinstance(item.pattern, Nonterm):
                stack.append((rule, child_index))
                rule_map = syntax.full_map[item.key]
                child_rule = choose(rule_map, lex_token_init)
                child_gram = Grammar(item.key, child_rule.name)
                await output.put(child_gram)
                stack.append((child_rule, 0))
            else:
                assert(False)
'''
end parse 
'''

# def concretize_old(rule_map : dict[str, Rule], RichTokens : tuple[RichToken, ...]) -> str:

#     @dataclass
#     class Format:
#         inline : bool 
#         indent_width : int 

#     result = ""

#     token_iter = iter(RichTokens)

#     stack : list[Union[str, Format]] = [Format(True, 0)] # str is concrete syntax, and int is indentation of the RichToken from the iterator 
#     RichToken_count = 0

#     while stack:

#         stack_item : Union[str, Format] = stack.pop()
#         if isinstance(stack_item, str):
#             result += stack_item 
#         else: 
#             assert isinstance(stack_item, Format)
#             format = stack_item

#             # take an element from the iterator
#             inst = next(token_iter, None)
#             if not inst:
#                 break

#             RichToken_count += 1

#             class Handler(RichTokenHandler):
#                 def case_Grammar(self, inst):
#                     nonlocal stack
#                     rule = rule_map[inst.selection]
#                     for i, item in enumerate(reversed(rule.content)):
#                         class Handler(ItemHandler):
#                             def case_Terminal(self, o):
#                                 j = len(rule.content) - 1 - i
#                                 class Formatter(LineFormatHandler):
#                                     def case_InLine(self, _): return ""
#                                     def case_NewLine(self, _): return "\n" + ("    " * format.indent_width)
#                                     def case_IndentLine(self, _): return "\n" + ("    " * format.indent_width)

#                                 prefix = ""
#                                 if i == 0: 
#                                     pred = rule.content[j - 1]
#                                     if isinstance(pred, Nonterm):
#                                         prefix = pred.format.match(Formatter())

#                                 stack.append(prefix + o.terminal)

#                             def case_Nonterm(self, o):
#                                 child_format = Format(is_inline(o.format), next_indent_width(format.indent_width, o.format))
#                                 stack.append(child_format)

#                             def case_Vocab(self, o):
#                                 stack.append(format)

#                         item.match(Handler())

#                     prefix = "" if format.inline else "\n" + "    " * format.indent_width
#                     stack += [prefix]
                
#                 def case_Vocab(self, inst):
#                     nonlocal stack
#                     stack += [inst.selection]

#             inst.match(Handler())

#     return result