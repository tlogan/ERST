
from typing import *
import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser
from tapas.slim import server, analysis

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
    tree = parser.expr(analysis.plate_default)


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
# """
# (.uno = @ .dos = @).uno
# """,
###############
# """
# let rec = .uno = @ .dos = @ ;
# rec.uno
# """,
###############
# """
# ((.uno = (.one = @)).uno).one
# """,
###############
# TODO: debug this case
"""
(.uno = (.one = @)).uno.one
""",
###############
# """
# let rec = .uno = (.one = @) .dos = @ ;
# (rec.uno).one
# """,
###############
# """
# let rec = .uno = (.one = @) .dos = @ ;
# rec.uno.one
# """,
###############
# """
# x => :ooga :booga x 
# """,
###############
# """
# (x => :ooga :booga x)
# """,
##################
# """
# (x => :ooga :booga x)(@)
# """,
###############
# """
# let foo = x => :ooga :booga x 
# foo(@)
# """,
###############
# """
# x => y => :ooga :booga (.uno = x .dos = y) 
# """,
###############
# """
# (x => y => :ooga :booga (.uno = x .dos = y)) (:one @) (:two @) 
# """,
###############
# """
# let foo = (x => y => :ooga :booga (.uno = x .dos = y)) ;
# foo(:one @)(:two @)
# """,
###############
# "let x = :boo @ ;",
# '''
# let y = :foo x ;
# ''',
# ".uno = y .dos = @",
################
# ".uno = () .dos = ()",
################
# "fix (", "()", ")",
################
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
        answr = await connection.mk_caller(piece)
        print(f'answr: {answr}')
        if isinstance(answr, server.Done):
            break


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
