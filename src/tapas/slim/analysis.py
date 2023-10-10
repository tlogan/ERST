from dataclasses import dataclass
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue, Task

from SlimLexer import SlimLexer
from SlimParser import SlimParser

@dataclass(frozen=True, eq=True)
class Kill: pass 

I = Union[Kill, str]

# @dataclass(frozen=True, eq=True)
# class SynthAttr: pass 
SynthAttr = str

@dataclass(frozen=True, eq=True)
class InherAttr: pass 

async def mk_server(input : Queue[I], output : Queue[InherAttr]) -> str:
    none : Any = None
    parser = SlimParser(none)
    # parser.buildParseTrees = False
    parser.output = output
    code = ''
    ctx = None
    while True:
        i = await input.get()
        if isinstance(i, Kill):
            break

        code += i 
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        token_stream : Any = CommonTokenStream(lexer)
        parser.setInputStream(token_stream)

        try:
            ctx = parser.expr()
        except:
            ctx = None

    '''
    end while
    '''

    # if parser.getNumberOfSyntaxErrors() > 0 or ctx == None:
    #     print(f"syntax errors: {parser.getNumberOfSyntaxErrors()}")
    #     pass
    # else:
    #     print(f"tree: {ctx.toStringTree(recog=parser)}")

    assert ctx
    assert isinstance(ctx.synth_attr, str)
    return ctx.synth_attr

#end analyze 





class Client:
    _input : Queue
    _output : Queue
    _task : Task[str]

    def __init__(self, input, output, task):
        self._input = input
        self._output = output
        self._task = task 

    def send(self, item):
        self._input.put_nowait(item)

    def mk_receiver(self):
        return self._output.get()

    def cancel(self):
        return self._task.cancel()

    def done(self):
        return self._task.done()

    async def mk_getter(self):
        return await self._task

mk_client = Client
        
def launch():
    input : Queue = Queue()
    output : Queue = Queue()
    task = asyncio.create_task(mk_server(input, output))
    return mk_client(input, output, task)


