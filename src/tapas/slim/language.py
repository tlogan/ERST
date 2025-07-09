from dataclasses import dataclass
from typing import *
from antlr4 import *
import sys

import time

import asyncio
from asyncio import Queue, Task

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser, Guidance
from tapas.slim import analyzer 

T = TypeVar("T")

from pyrsistent.typing import PMap, PSet
from pyrsistent import m, pmap, v, pset, s



     



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
    answer = tc.combo
#     print(f"""
# ============================================================================================
# Parse Type: {answer}
# ============================================================================================
#     """)
    return answer

def analyze(code : str, typing_context = m()) -> tuple[Optional[analyzer.Typ], str, analyzer.Solver]:
    try:
        input_stream = InputStream(code)
        lexer = SlimLexer(input_stream)
        token_stream : Any = CommonTokenStream(lexer)
        parser = SlimParser(token_stream)
        parser.init()

        context = analyzer.Context(typing_context, analyzer.World(s(), s(), s()))
        tc = parser.program([context])
        if tc.results == None:
            raise Exception("Parsing Error")
        elif len(tc.results) > 0:
            # result = tc.results[0]
            solver = parser._solver
            for i, result in enumerate(tc.results):
                print(f"""
=======================
analysis multi result {i}
=======================
typ:
{analyzer.concretize_typ(result.typ)}

skolems:
{result.world.closedids}

constraints:
{analyzer.concretize_constraints(result.world.constraints)}
=======================
                """)

            # t1 = solver.interpret_polar_typ(True, result.world.closedids, result.world.constraints, result.typ) 
            # influential_ids = result.world.closedids.union(analyzer.extract_free_vars_from_typ(s(), t1))
            # influential_constraints = analyzer.filter_constraints_by_all_variables(result.world.constraints, influential_ids)
            # t2 = solver.make_constraint_typ(True)(s(), result.world.closedids, influential_constraints, t1)
            t2 = solver.decode_polarity_typ(tc.results, True)
            return (t2, tc.toStringTree(recog=parser), parser._solver)
        else: 
            # In what scenario would we expect be multiple results at the top level?
            print("!!!!!!!!!!!!!!!")
            print("result size: " + str(len(tc.results)))
            print("!!!!!!!!!!!!!!!")
            return (None, tc.toStringTree(recog=parser), parser._solver)
    # except Exception as e:
    #     raise e
    except RecursionError:
        print("!!!!!!!!!!!!!!!")
        print("RECURSION ERROR")
        print("!!!!!!!!!!!!!!!")
        return (None, "", parser._solver)
    except analyzer.InhabitableError:
        print("DEBUG A")
        return (None, "", parser._solver)

def infer_typ(code : str, context = {}) -> str:

    typing_context = pmap({
        k : parse_typ(v) 
        for k,v in context.items()
    })

    print(context)

    start = time.time()
    (result, parsetree, solver) = analyze(code, typing_context)
    end = time.time()
    print(f"TIME: {end - start}")
    if result == None:
        return ""
    else:
        simpres = solver.simplify_typ(result)
        if solver.is_useless(True, simpres):
            print(f"""
!!!!!!!!!!!!!!!!
USELESS: {analyzer.concretize_typ(simpres)}
!!!!!!!!!!!!!!!!
            """)
            return ""
        else:
            answer = analyzer.concretize_typ(simpres)
            print(f"""
=========================================================================================================================
INFERENCE: 
~~~~~~~
{answer}
=========================================================================================================================
            """)
            return answer

def solve_subtyping(a : str, b : str) -> list[analyzer.World]:
    x = parse_typ(a)
    assert x
    y = parse_typ(b)
    assert y 
    try:
        solver = analyzer.Solver(m())
        return solver.solve_composition(x, y)
    except RecursionError:
        print("!!!!!!!!!!!!!!!")
        print("RECURSION ERROR")
        print("!!!!!!!!!!!!!!!")
        return []
    # except:
    #     return []

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





