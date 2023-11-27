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


    # Enter a parse tree produced by SlimParser#base.
    def enterBase(self, ctx:SlimParser.BaseContext):
        pass

    # Exit a parse tree produced by SlimParser#base.
    def exitBase(self, ctx:SlimParser.BaseContext):
        pass


    # Enter a parse tree produced by SlimParser#function.
    def enterFunction(self, ctx:SlimParser.FunctionContext):
        pass

    # Exit a parse tree produced by SlimParser#function.
    def exitFunction(self, ctx:SlimParser.FunctionContext):
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


    # Enter a parse tree produced by SlimParser#pipeline.
    def enterPipeline(self, ctx:SlimParser.PipelineContext):
        pass

    # Exit a parse tree produced by SlimParser#pipeline.
    def exitPipeline(self, ctx:SlimParser.PipelineContext):
        pass


    # Enter a parse tree produced by SlimParser#keychain.
    def enterKeychain(self, ctx:SlimParser.KeychainContext):
        pass

    # Exit a parse tree produced by SlimParser#keychain.
    def exitKeychain(self, ctx:SlimParser.KeychainContext):
        pass


    # Enter a parse tree produced by SlimParser#target.
    def enterTarget(self, ctx:SlimParser.TargetContext):
        pass

    # Exit a parse tree produced by SlimParser#target.
    def exitTarget(self, ctx:SlimParser.TargetContext):
        pass


    # Enter a parse tree produced by SlimParser#pattern.
    def enterPattern(self, ctx:SlimParser.PatternContext):
        pass

    # Exit a parse tree produced by SlimParser#pattern.
    def exitPattern(self, ctx:SlimParser.PatternContext):
        pass


    # Enter a parse tree produced by SlimParser#pattern_base.
    def enterPattern_base(self, ctx:SlimParser.Pattern_baseContext):
        pass

    # Exit a parse tree produced by SlimParser#pattern_base.
    def exitPattern_base(self, ctx:SlimParser.Pattern_baseContext):
        pass


    # Enter a parse tree produced by SlimParser#pattern_record.
    def enterPattern_record(self, ctx:SlimParser.Pattern_recordContext):
        pass

    # Exit a parse tree produced by SlimParser#pattern_record.
    def exitPattern_record(self, ctx:SlimParser.Pattern_recordContext):
        pass



del SlimParser