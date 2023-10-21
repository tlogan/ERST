
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

from pyrsistent import m, pmap, v



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
    tree = parser.expr(m())


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




##############################
 

# _guidance : Union[Symbol, Terminal, Nonterm]
# @property
# def guidance(self) -> Union[Symbol, Terminal, Nonterm]:
#     return self._guidance
# 
# @guidance.setter
# def guidance(self, value : Union[Symbol, Terminal, Nonterm]):
#     self._guidance = value

#def getAllText(self):  # include hidden channel
#    # token_stream = ctx.parser.getTokenStream()
#    token_stream = self.getTokenStream()
#    lexer = token_stream.tokenSource
#    input_stream = lexer.inputStream
#    # start = ctx.start.start
#    start = 0
#    # stop = ctx.stop.stop
#
#    # TODO: increment token position in attributes
#    # TODO: map token position to result 
#    # TODO: figure out a way to get the current position of the parser
#    stop = self.getRuleIndex()
#    # return input_stream.getText(start, stop)
#    print(f"start: {start}")
#    print(f"stoppy poop: {stop}")
#    return "<<not yet implemented>>"
#    # return input_stream.getText(start, stop)[start:stop]

# @contextmanager
# def manage_guidance(self):
#     if not self.overflow():
#         yield
#     self.updateOverflow()
