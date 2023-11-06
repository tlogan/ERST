from dataclasses import dataclass
from typing import *
from antlr4 import *
import sys

import asyncio
from asyncio import Queue, Task

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser, Guidance
from tapas.slim.analysis import * 

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
O = Union[Guidance, AttributeError, Killed, Done]

# @dataclass(frozen=True, eq=True)
# class SynthAttr: pass 
SynthAttr = str

@dataclass(frozen=True, eq=True)
class InherAttr: pass 

# async def mk_task(input : Queue, output : Queue) -> Optional[str]:
#     return "hello"

async def _mk_task(input : Queue[I], output : Queue[O]) -> Optional[str]:
    none : Any = None
    parser = SlimParser(none)
    parser.init()
    # parser.buildParseTrees = False
    code = ''
    ctx = None
    # parser.fresh_index = 0
    while True:
        print("")
        print("")
        i = await input.get()
        print(f"--- GOT: {i} ------")
        if isinstance(i, Kill):
            print("Killed")
            await output.put(Killed())
            break

        code += i 
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        # token_stream = CommonTokenStream(lexer)
        # token_stream.tokens

        token_stream : Any = CommonTokenStream(lexer)
        parser.setInputStream(token_stream)
        parser.reset()

        try:
            ctx = parser.expr(plate_default)
            if ctx.combo: 
                await output.put(Done())
                break
            else:
                await output.put(parser.getGuidance())

        except AttributeError as e : 
            print(f"OOGA EXCEPTION: {type(e)} // {e.args}")
            await output.put(e)
            ctx = None



    '''
    end while
    '''

    if parser.getNumberOfSyntaxErrors() > 0 or ctx == None:
        print(f"syntax errors: {parser.getNumberOfSyntaxErrors()}")
        pass
    else:
        print(f"tree: {ctx.toStringTree(recog=parser)}")

    if ctx:
        return ctx.combo
    else:
        return None

'''
end mk_task 
'''





class Connection:
    _input : Queue
    _output : Queue
    _task : Task[str]

    def __init__(self, input, output, task):
        self._input = input
        self._output = output
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

    async def mk_getter(self):
        return await self._task

def launch():
    input : Queue = Queue()
    output : Queue = Queue()
    task = asyncio.create_task(_mk_task(input, output))
    return Connection(input, output, task)


