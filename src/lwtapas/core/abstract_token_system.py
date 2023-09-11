from __future__ import annotations
from typing import Iterator, Optional, Coroutine

from core.abstract_token_autogen import *

from core.line_format_system import LineFormat, LineFormatHandler, is_inline, next_indent_width
from core.rule_system import Rule, Item, ItemHandler, Terminal, Nonterm

from dataclasses import dataclass
from lwtapas.core.abstract_token_autogen import Grammar, Vocab

from lwtapas.core.rule_autogen import Nonterm, Terminal, Vocab

import asyncio


T = TypeVar('T')
D = TypeVar('D')
U = TypeVar('U')

def from_primitive(ptok : list[str]) -> AbstractToken:
    assert len(ptok) == 4
    assert ptok[0] == "P"
    if ptok[1] == "grammar":
        return make_Grammar(ptok[2], ptok[3])
    else:
        assert ptok[1] == "vocab"
        return make_Vocab(ptok[2], ptok[3])


def raise_exception(e):
    raise e

def to_primitive(inst : AbstractToken) -> list[str]:
    class Handler(AbstractTokenHandler):
        def case_Grammar(self, o):
            return ["P", "grammar", o.options, o.selection]

        def case_Vocab(self, o): 
            return ["P", "vocab", o.options, o.selection]

    return inst.match(Handler())

def to_string(token : AbstractToken) -> str:
    class Handler(AbstractTokenHandler):
        def case_Grammar(self, g): return f"grammar: {g.selection} <{g.options}>"
        def case_Vocab(self, v): return f"vocab: {v.selection} <{v.options}>"
    return token.match(Handler())


def dump(rule_map : dict[str, Rule], AbstractTokens : tuple[AbstractToken, ...], indent : int = 4):

    @dataclass
    class Format:
        relation : str 
        depth : int 

    def dump_AbstractToken(inst : AbstractToken, format : Format) -> str:

        class Handler(AbstractTokenHandler):
            def case_Grammar(self, o):
                indent_str = (' ' * format.depth * indent)
                relation_str = (' = .' + format.relation if (isinstance(format.relation, str)) else '')
                return (
                    indent_str + o.selection + (' (' + o.options  + ')' if o.options != o.selection else '') +
                    relation_str
                )

            def case_Vocab(self, o):
                indent_str = (' ' * format.depth * indent)
                relation_str = (' = .' + format.relation if (isinstance(format.relation, str)) else '')
                return (
                    indent_str + o.selection + ' (' + o.options  + ')' +
                    relation_str
                )

        return inst.match(Handler())





    result_strs = [] 

    inst_iter = iter(AbstractTokens)

    stack : list[Format] = [Format("", 0)]

    while stack:
        format : Format = stack.pop()
        inst = next(inst_iter, None)

        if not inst:
            return '\n'.join(result_strs)

        class Formatter(AbstractTokenHandler):
            def case_Grammar(self, inst):
                nonlocal stack
                nonlocal format
                rule = rule_map[inst.selection]

                for item in reversed(rule.content):
                    if not isinstance(item, Terminal):
                        class Handler(ItemHandler):
                            def case_Terminal(self, o):
                                raise Exception()
                            def case_Nonterm(self, o): 
                                return Format(o.relation, format.depth + 1)
                            def case_Vocab(self, o):
                                return Format(o.relation, format.depth + 1)

                        child_format = item.match(Handler())
                        stack += [child_format]

            def case_Vocab(self, inst):
                pass

        inst.match(Formatter())

        result_strs += [dump_AbstractToken(inst, format)]

    return '\n'.join(result_strs)


def concretize(rule_map : dict[str, Rule], AbstractTokens : tuple[AbstractToken, ...]) -> str:

    @dataclass
    class Format:
        inline : bool 
        indent_width : int 

    token_iter = iter(AbstractTokens)
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
            class ItemConcretizer(ItemHandler):
                def case_Nonterm(self, item):
                    child_token = next(token_iter, None)

                    stack.append((format, token, children))
                    child_format = Format(is_inline(item.format), next_indent_width(format.indent_width, item.format))
                    if isinstance(child_token, Grammar):
                        stack.append((child_format, child_token, ()))
                    else:
                        break
                def case_Terminal(self, item):
                    class LineFormatConcretizer(LineFormatHandler):
                        def case_InLine(self, _): return ""
                        def case_NewLine(self, _): return "\n" + ("    " * format.indent_width)
                        def case_IndentLine(self, _): return "\n" + ("    " * format.indent_width)

                    prefix = ""
                    if index != 0 and index == len(rule.content) - 1:
                        pred = rule.content[index - 1]
                        if isinstance(pred, Nonterm):
                            prefix = pred.format.match(LineFormatConcretizer())

                    s = (prefix + item.terminal)
                    stack.append((format, token, children + (s,)))
                def case_Vocab(self, item):
                    vocab_token = next(token_iter, None)
                    if isinstance(vocab_token, Vocab):
                        if vocab_token.options == "comment" and vocab_token.selection:
                            comments = vocab_token.selection.split("\n")

                            comment = ('' if index == 0 else ' ') + ("\n" + ("    " * format.indent_width)).join([c for c in comments if c]) + "\n"

                            stack.append((format, token, children + (comment,)))
                        else:
                            stack.append((format, token, children + (vocab_token.selection,)))
                    else:
                        break
            item.match(ItemConcretizer())

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
traverse stack and calling combine_up and guide_down handlers
combine_up occurs after last child has been popped (i.e. return)
guide_down occurs before push (i.e. call) 
'''
async def analyze(rule_map : dict[str, Rule], input : asyncio.Queue[AbstractToken], output : asyncio.Queue[D]) -> U | None:

    token_init = await input.get()
    assert isinstance(token_init, Grammar)
    stack : list[tuple[Grammar, list[U]]] = [(token_init, [])]

    result : U | None = None
    while stack:

        (gram, children) = stack.pop()

        if result != None:
            '''
            get the result from the child in the stack
            '''
            children = children + [result]
            result = None

        rule = rule_map[gram.selection]
        index = len(children)
        if index == len(rule.content):
            methods_name = f"combine_up_{rule.name}"
            args = children
            '''
            TODO: figure out how to define handlers 
            - maybe can associate handler with rules in rule_map
            '''
            pass
        else:
            '''
            TODO: modify to call guide_down before stack.append (i.e. push/call) 
            '''
            item = rule.content[index]
            class ItemAnalyzer(ItemHandler):
                def case_Nonterm(self, item):
                    child_token = next(token_iter, None)

                    stack.append((format, token, children))
                    child_format = Format(is_inline(item.format), next_indent_width(format.indent_width, item.format))
                    if isinstance(child_token, Grammar):
                        stack.append((child_format, child_token, ()))
                    else:
                        break
                def case_Terminal(self, item):
                    class LineFormatConcretizer(LineFormatHandler):
                        def case_InLine(self, _): return ""
                        def case_NewLine(self, _): return "\n" + ("    " * format.indent_width)
                        def case_IndentLine(self, _): return "\n" + ("    " * format.indent_width)

                    prefix = ""
                    if index != 0 and index == len(rule.content) - 1:
                        pred = rule.content[index - 1]
                        if isinstance(pred, Nonterm):
                            prefix = pred.format.match(LineFormatConcretizer())

                    s = (prefix + item.terminal)
                    stack.append((format, token, children + (s,)))
                def case_Vocab(self, item):
                    vocab_token = next(token_iter, None)
                    if isinstance(vocab_token, Vocab):
                        if vocab_token.options == "comment" and vocab_token.selection:
                            comments = vocab_token.selection.split("\n")

                            comment = ('' if index == 0 else ' ') + ("\n" + ("    " * format.indent_width)).join([c for c in comments if c]) + "\n"

                            stack.append((format, token, children + (comment,)))
                        else:
                            stack.append((format, token, children + (vocab_token.selection,)))
                    else:
                        break
            item.match(ItemAnalyzer())






    return result 
'''
end analyze 
'''

# def concretize_old(rule_map : dict[str, Rule], AbstractTokens : tuple[AbstractToken, ...]) -> str:

#     @dataclass
#     class Format:
#         inline : bool 
#         indent_width : int 

#     result = ""

#     token_iter = iter(AbstractTokens)

#     stack : list[Union[str, Format]] = [Format(True, 0)] # str is concrete syntax, and int is indentation of the AbstractToken from the iterator 
#     AbstractToken_count = 0

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

#             AbstractToken_count += 1

#             class Handler(AbstractTokenHandler):
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