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
class Nonterm: 
    id : str 

@dataclass(frozen=True, eq=True)
class Termin: 
    pattern : str 

GItem = Union[Nonterm, Termin]

RuleBody = list[Union[Nonterm, Termin]] 

@dataclass(frozen=True, eq=True)
class Rule:
    head : str
    body : RuleBody

Grammar = dict[str, list[RuleBody]]

n = Nonterm
t = Termin

def make_prompt_grammar() -> Grammar: 
    ID = t(r"[a-zA-Z][_a-zA-Z]*")
    return {
        'expr' : [
            [n('base')],
            [n('base'), t(','), n('expr')],
            [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')],
            [n('base'), n('keychain')],
            [n('base'), n('argchain')],
            [n('base'), n('pipeline')],
            [t('let'), ID, n('target'), t(';'), n('expr')],
            [t('fix'), t('('), n('expr'), t(')')],
        ],
        
        'base' : [
            [t('@')],
            [t('~'), ID, n('base')],
            [n('record')],
            [n('function')],
            [ID],
            [n('argchain')]
        ], 

        'record' : [
            [t('_.'), ID, t('='), n('expr')],
            [t('_.'), ID, t('='), n('expr'), n('record')],
        ],

        'function' : [
            [t('case'), n('pattern'), t('=>'), n('expr')],
            [t('case'), n('pattern'), t('=>'), n('expr'), n('function')],
        ],

        'keychain' : [
            [t('.'), ID],
            [t('.'), ID, n('keychain')],
        ],

        'argchain' : [
            [t('('), n('expr'), t(')')],
            [t('('), n('expr'), t(')'), n('argchain')],
        ],

        'pipeline' : [
            [t('|>'), n('expr')],
            [t('|>'), n('expr'), n('pipeline')],
        ],
        
        'target' : [
            # [t('='), n('expr')],
            [t(':'), ID, t('='), n('expr')],
        ],
        
        'pattern' : [
            [n('basepat')],
            [n('basepat'), t(','), n('pattern')],
        ],

        'basepat' : [
            [ID],
            [t('@')],
            [t('~'), ID, n('basepat')],
            [n('recpat')],
            [t('('), n('pattern'), t(')')],
        ],
        
        'recpat' : [
            [t('_.'), ID, t('='), n('pattern')],
            [t('_.'), ID, t('='), n('pattern'), n('recpat')],
        ]

        
    } 

def from_rules_to_grammar (rules : list[Rule]) -> Grammar:
    g = {}
    for rule in rules:
        if rule.head in g:
            bodies = g[rule.head]
            g[rule.head] = bodies + [rule.body]
        else:
            g[rule.head] = [rule.body]
    return g

def concretize_rule_body(items : RuleBody) -> str:
    return " ".join([
        (
            item.id
            if isinstance(item, Nonterm) else
            f"'{item.pattern}'"
            if isinstance(item, Termin) else
            "<ERROR>"
        )

        for item in items
    ])

def concretize_grammar(g : Grammar) -> str:
    result = ""
    for head in g:
        bodies = g[head]
        init_body = bodies[0]
        result += f"{head} ::= {concretize_rule_body(init_body)}" + "\n"
        result += "".join([
            (" " * len(head)) + "   | " + f"{concretize_rule_body(body)}" + "\n"
            for body in bodies[1:]
        ])
        result += "\n"
    return result

     



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
            ctx = parser.expr(analyzer.default_nonterm)

            num_syn_err = parser.getNumberOfSyntaxErrors()

            if num_syn_err > 0:
                raise(Exception(f"Syntax Errors: {num_syn_err}"))
            elif ctx.models: 
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
    _parser : Parser 
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

def analyze(code : str) -> tuple[Optional[list[analyzer.Model]], analyzer.TVar, str]:
    input_stream = InputStream(code)
    lexer = SlimLexer(input_stream)
    token_stream : Any = CommonTokenStream(lexer)
    parser = SlimParser(token_stream)
    tc = parser.expr(analyzer.default_nonterm)
    return (tc.models, analyzer.default_nonterm.typ_var, tc.toStringTree(recog=parser))




