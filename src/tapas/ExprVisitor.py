# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/Expr.g4 by ANTLR 4.13.0
from antlr4 import *
if "." in __name__:
    from .ExprParser import ExprParser
else:
    from ExprParser import ExprParser

# This class defines a complete generic visitor for a parse tree produced by ExprParser.

class ExprVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by ExprParser#start_.
    def visitStart_(self, ctx:ExprParser.Start_Context):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#expr.
    def visitExpr(self, ctx:ExprParser.ExprContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#atom.
    def visitAtom(self, ctx:ExprParser.AtomContext):
        return self.visitChildren(ctx)



del ExprParser