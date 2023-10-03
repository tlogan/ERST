import sys
from antlr4 import *
from io import StringIO

import asyncio
from asyncio import Queue

from SlimLexer import SlimLexer
from SlimParser import SlimParser
'''
NOTE: lexer does NOT preserve skipped lexicon (e.g. skipped white space)
NOTE: there is a built in mechanism to stringify partial parse tree as s-expression
NOTE: NO built in mechanism to build indented string representation of parse tree
NOTE: NO built in mechanism to concretize partial parse tree. must implement custom attribute rules.

TODO: determine how to build parse tree of incomplete token stream?
TODO: determine how to use BufferedInputStream to put tokens on the stream one by one 
'''

def test_parse_tree_serialize(code):

    # input_stream : InputStream = FileStream(argv[1])
    # input_stream : InputStream = StdinStream()
    # input_stream = InputStream(incomplete_code)
    input_stream = InputStream(code)

    #############################
    lexer = SlimLexer(input_stream)
    token_stream = CommonTokenStream(lexer)
    #############################
    parser = SlimParser(token_stream)
    tree = parser.expr()


    if parser.getNumberOfSyntaxErrors() > 0:
        print("syntax errors")
    else:
        print(tree.toStringTree())

    # lexer = ExprLexer(input_stream)
    # stream = CommonTokenStream(lexer)
    # parser = ExprParser(stream)
    # tree = parser.start_()



    # linterp = ListenerDump()
    # walker = ParseTreeWalker()
    # walker.walk(linterp, tree)

    ####################################


    # if parser.getNumberOfSyntaxErrors() > 0:
    #     print("syntax errors")
    # else:
    #     linterp = ListenerDump()
    #     walker = ParseTreeWalker()
    #     walker.walk(linterp, tree)

def line_col_pos(x : str) -> tuple[int, int]:
    lines = x.split("\n")
    return (len(lines), len(lines[-1]))

async def analyze(input : Queue, output : Queue):

    parser = SlimParser(None)
    parser.buildParseTrees = False
    line = 1
    column = 1
    while True:
        code = await input.get()
        ############################
        input_stream = InputStream(code)
        #############################
        lexer = SlimLexer(input_stream)
        lexer.line = line
        lexer.column = column


        token_stream = CommonTokenStream(lexer)
        #############################
        parser.setTokenStream(token_stream)
        expr_context = parser.expr()
        #############################
        new_line, new_column = line_col_pos(code)
        line = line + new_line -1
        column = column + new_column -1
        ########################
        # TODO: break look if semantic parser has completed
        # TODO: create attribute grammar that takes output queue as parameter 
        ########################
        pass

async def test_analyze_coroutine():
    input : Queue = Queue()
    output : Queue = Queue()
    pieces = [
        "fix (self =>", " (", "\n",
        "    fun nil;. => zero;. ", "\n",
        "    fun cons;x ", "=>", "succ;", "(self(", "x))", "\n",
        ")", ")"
    ]
    await analyze(input, output)

def test_analyze():
    asyncio.run(test_analyze_coroutine())

if __name__ == '__main__':
    # main(sys.argv)
####################
    # test_analyze()
####################

    test_parse_tree_serialize(f'''
fix (self => (
    fun :nil () => :zero () 
    fun :cons () => :succ (self(x))
))
    ''')

####################

#     test_parse_tree_serialize(f'''
# .hello = ()
# .bye = ()
#     ''')