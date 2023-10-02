import sys
from antlr4 import *
from ExprParser import ExprParser
from ExprListener import ExprListener

class ListenerDump(ExprListener):
    def __init__(self):
        self.result = {}

    def enterAtom(self, ctx:ExprParser.AtomContext):
        print(f"enter Atom: ")
        for i in range(0, ctx.getChildCount(), 2):
            print(' ~~~ ')
            print(ctx.getChild(i).getText())
        print(f"done entering Atom: ")
        print(f"----")
        print(f"----")

    def exitAtom(self, ctx:ExprParser.AtomContext):
        pass

    def enterExpr(self, ctx:ExprParser.ExprContext):
        print(f"enter Expr: ")
        for i in range(0, ctx.getChildCount()):
            print(' ~~~ ')
            print(ctx.getChild(i).getText())
        print(f"done entering Expr: ")
        print(f"----")
        print(f"----")
        pass

    def exitExpr(self, ctx:ExprParser.ExprContext):
        pass

    def enterStart_(self, ctx:ExprParser.Start_Context):
        pass

    def exitStart_(self, ctx:ExprParser.Start_Context):
        pass
        # for i in range(0, ctx.getChildCount(), 2):
        #     print(self.result[ctx.getChild(i)])