# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
from antlr4 import *
if "." in __name__:
    from .SlimParser import SlimParser
else:
    from SlimParser import SlimParser

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analysis import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 



# This class defines a complete listener for a parse tree produced by SlimParser.
class SlimListener(ParseTreeListener):

    # Enter a parse tree produced by SlimParser#expr.
    def enterExpr(self, ctx:SlimParser.ExprContext):
        pass

    # Exit a parse tree produced by SlimParser#expr.
    def exitExpr(self, ctx:SlimParser.ExprContext):
        pass


    # Enter a parse tree produced by SlimParser#record.
    def enterRecord(self, ctx:SlimParser.RecordContext):
        pass

    # Exit a parse tree produced by SlimParser#record.
    def exitRecord(self, ctx:SlimParser.RecordContext):
        pass


    # Enter a parse tree produced by SlimParser#argchain.
    def enterArgchain(self, ctx:SlimParser.ArgchainContext):
        pass

    # Exit a parse tree produced by SlimParser#argchain.
    def exitArgchain(self, ctx:SlimParser.ArgchainContext):
        pass


    # Enter a parse tree produced by SlimParser#keychain.
    def enterKeychain(self, ctx:SlimParser.KeychainContext):
        pass

    # Exit a parse tree produced by SlimParser#keychain.
    def exitKeychain(self, ctx:SlimParser.KeychainContext):
        pass



del SlimParser