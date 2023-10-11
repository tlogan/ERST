from dataclasses import dataclass
from typing import *
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

async def mk_server(input : Queue, output : Queue) -> Optional[str]:
    none : Any = None
    parser = SlimParser(none)
    # parser.buildParseTrees = False
    code = ''
    ctx = None
    parser.cache = {} 
    # parser.fresh_index = 0
    while True:
        i = await input.get()
        if isinstance(i, Kill):
            break

        code += i 
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        # token_stream = CommonTokenStream(lexer)
        # token_stream.tokens

        token_stream : Any = CommonTokenStream(lexer)
        # token_stream.index
        parser.setInputStream(token_stream)
        parser.token_index = 0
        parser.guidance = None 
        parser.getCurrentToken()

        try:
            ctx = parser.expr()

            ####################
            ####################

            # parser.getCurrentToken()
            # token_stream = ctx.parser.getTokenStream()
            # lexer = token_stream.tokenSource
            # input_stream = lexer.inputStream
            # # start = ctx.start.start
            # start = 0
            # # stop = ctx.stop.stop
            # stop = parser.state - 1
            # # return input_stream.getText(start, stop)
            # print(f"start: {start}")
            # print(f"stop: {stop}")
            # return input_stream.getText(start, stop)[start:stop]

        except:
            ctx = None


        if parser.guidance:
            output.put_nowait(parser.guidance)
        # parser.fresh_index = parser.token_index 

    '''
    end while
    '''

    if parser.getNumberOfSyntaxErrors() > 0 or ctx == None:
        print(f"syntax errors: {parser.getNumberOfSyntaxErrors()}")
        pass
    else:
        print(f"tree: {ctx.toStringTree(recog=parser)}")

    if ctx:
        return ctx.result
    else:
        return None

#end analyze 





class Connection:
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
        return self._task.done() and self._output.empty()

    async def mk_getter(self):
        return await self._task

def launch():
    input : Queue = Queue()
    output : Queue = Queue()
    task = asyncio.create_task(mk_server(input, output))
    return Connection(input, output, task)


