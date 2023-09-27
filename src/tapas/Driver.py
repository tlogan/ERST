import sys
from antlr4 import *
from ExprLexer import ExprLexer
from ExprParser import ExprParser
from ListenerInterp import ListenerInterp
from ListenerDump import ListenerDump
from io import StringIO

code = f'''
-(1 + 2)/3;
1;
2+3;
8*9
'''

incomplete_code = f'''
-(1 + 2)/3;
1;
2+3;
8*
'''
def main(argv):
    # input_stream : InputStream = FileStream(argv[1])
    # input_stream : InputStream = StdinStream()
    # input_stream = InputStream(incomplete_code)
    input_stream = InputStream(incomplete_code)

    lexer = ExprLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = ExprParser(stream)
    tree = parser.start_()



    linterp = ListenerDump()
    walker = ParseTreeWalker()
    walker.walk(linterp, tree)




    # if parser.getNumberOfSyntaxErrors() > 0:
    #     print("syntax errors")
    # else:
    #     linterp = ListenerDump()
    #     walker = ParseTreeWalker()
    #     walker.walk(linterp, tree)

if __name__ == '__main__':
    main(sys.argv)