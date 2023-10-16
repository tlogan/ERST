
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser
from tapas.slim import client

from tapas.util_system import box, unbox



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







if __name__ == '__main__':
    # main(sys.argv)
####################
    client.interact()
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