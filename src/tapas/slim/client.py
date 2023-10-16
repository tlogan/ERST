from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from SlimLexer import SlimLexer
from SlimParser import SlimParser

import server
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

def newline_column_count(x : str) -> tuple[int, int]:
    lines = x.split("\n")
    return (len(lines) - 1, len(lines[-1]))



async def _mk_task():
    # pieces = [

    #     "fix (self =>", " (", "\n",
    #     "    fun :nil . => :zero () ", "\n",
    #     "    fun :cons x ", "=>", ":succ", "(self(", "x))", "\n",
    #     ")", ")"
    # ]

    # pieces = [
    #     "hello"
    # ]

    # pieces = [
    #     ":hello ()"
    # ]

    pieces = [
        # "fix (())",
        "fix (",
        # "fix (()",
        # "fix (", "()",
        # "fix (", "(", ")",
        server.Kill()
    ]


    results = []

    connection = server.launch()

    # pieces = [
    # f'''
    # fun :nil () => :zero () 
    # fun :cons () => :succ (self(x))
    # '''
    # ]

    for piece in pieces:
        await connection.mk_sender(piece)


    while not connection.done():
        '''
        assume that receiver is non-empty if task is not done 
        '''
        # not done --> not empty
        # empty --> done
        rcvd = await connection.mk_receiver()
        print(f'received: {rcvd}')

    print('post while')
    result = await connection.mk_getter()
    print(f'result: {result}')


def interact():
    asyncio.run(_mk_task())

if __name__ == '__main__':
    # main(sys.argv)
####################
    interact()
####################

#     test_parse_tree_serialize(f'''
# fix (self => (
#     fun :nil () => :zero () 
#     fun :cons x => :succ (self(x)) 
# ))
#     ''')

####################

#     test_parse_tree_serialize(f'''
# .hello = ()
# .bye = ()
#     ''')