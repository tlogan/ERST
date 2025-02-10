from dataclasses import dataclass
from typing import *
from antlr4 import *
import sys

import asyncio
from asyncio import Queue, Task

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser, Guidance
from tapas.slim import analyzer 

T = TypeVar("T")

from pyrsistent.typing import PMap 
from pyrsistent import m, pmap, v



     



@dataclass(frozen=True, eq=True)
class Kill: 
    pass 

@dataclass(frozen=True, eq=True)
class Killed(): 
    pass

@dataclass(frozen=True, eq=True)
class Done: 
    pass

I = Union[Kill, str]
O = Union[Guidance, Exception, Killed, Done]

async def _mk_task(parser : SlimParser, input : Queue[I], output : Queue[O]) -> Optional[SlimParser.ExprContext]:
    parser.init()
    # parser.buildParseTrees = False
    code = ''
    ctx = None
    # parser.fresh_index = 0
    while True:
        piece = await input.get()
        if isinstance(piece, Kill):
            await output.put(Killed())
            break

        code += (' ' + piece) 
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        # token_stream = CommonTokenStream(lexer)
        # token_stream.tokens

        token_stream : Any = CommonTokenStream(lexer)
        parser.setInputStream(token_stream)
        parser.reset()

        try:
            ctx = parser.expr([analyzer.default_context])

            num_syn_err = parser.getNumberOfSyntaxErrors()

            if num_syn_err > 0:
                raise(Exception(f"Syntax Errors: {num_syn_err}"))
            elif ctx.results: 
                await output.put(Done())
                break
            else:
                await output.put(parser.getGuidance())

        except Exception as e : 
            print(f"EXCEPTION: {type(e)} // {e.args}")
            await output.put(e)
            ctx = None



    '''
    end while
    '''

    if parser.getNumberOfSyntaxErrors() > 0 or ctx == None:
        print(f"syntax errors: {parser.getNumberOfSyntaxErrors()}")
        pass
    return ctx

'''
end mk_task 
'''





class Connection(Generic[T]):
    _input : Queue
    _output : Queue
    _parser : SlimParser 
    _task : Task[T]

    def __init__(self, input, output, parser, task):
        self._input = input
        self._output = output
        self._parser = parser 
        self._task = task 

    async def mk_caller(self, item):
        await self._input.put(item)
        return await self._output.get()

    def mk_receiver(self):
        return self._output.get()

    def cancel(self):
        return self._task.cancel()

    def done(self):
        return self._task.done() and self._output.empty()

    def to_string_tree(self, ctx : ParserRuleContext):
        return ctx.toStringTree(recog=self._parser)

    async def mk_getter(self):
        return await self._task

    def get_solver(self):
        return self._parser.getSolver()

def launch() -> Connection[Optional[SlimParser.ExprContext]]:
    input : Queue = Queue()
    output : Queue = Queue()
    none : Any = None
    parser = SlimParser(none)
    task = asyncio.create_task(_mk_task(parser, input, output))
    return Connection(input, output, parser, task)



def parse_typ(code : str) -> Optional[analyzer.Typ]:
    input_stream = InputStream(code)
    lexer = SlimLexer(input_stream)
    token_stream : Any = CommonTokenStream(lexer)
    parser = SlimParser(token_stream)
    tc = parser.typ()
    return tc.combo

def analyze(code : str) -> tuple[analyzer.Typ, str, analyzer.Solver]:
    try:
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        token_stream : Any = CommonTokenStream(lexer)
        parser = SlimParser(token_stream)
        parser.init()
        tc = parser.program([analyzer.default_context])
        if tc.results == None:
            raise Exception("Parsing Error")
        elif len(tc.results) == 1:
            result = tc.results[0]
            return (result.typ, tc.toStringTree(recog=parser), parser._solver)
        else: 
            return (analyzer.Bot(), tc.toStringTree(recog=parser), parser._solver)
    except analyzer.Fail:
        return (analyzer.Bot(), "", parser._solver)
    except RecursionError:
        print("!!!!!!!!!!!!!!!")
        print("RECURSION ERROR")
        print("!!!!!!!!!!!!!!!")
        return (analyzer.Bot(), "", parser._solver)
    except analyzer.InhabitableError:
        return (analyzer.Bot(), "", parser._solver)

def refine_grammar(code : str) -> analyzer.Grammar:
    input_stream = InputStream(code)
    lexer = SlimLexer(input_stream)
    token_stream : Any = CommonTokenStream(lexer)
    parser = SlimParser(token_stream)
    parser.init()
    tc = parser.program([analyzer.default_context])
    rs = parser.get_syntax_rules()
    g = analyzer.from_rules_to_grammar(rs)
    return g





