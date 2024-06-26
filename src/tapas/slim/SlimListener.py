# Generated from /Users/thomas/tlogan@github.com/ERST/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
from antlr4 import *
if "." in __name__:
    from .SlimParser import SlimParser
else:
    from SlimParser import SlimParser

from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset



# This class defines a complete listener for a parse tree produced by SlimParser.
class SlimListener(ParseTreeListener):

    # Enter a parse tree produced by SlimParser#ids.
    def enterIds(self, ctx:SlimParser.IdsContext):
        pass

    # Exit a parse tree produced by SlimParser#ids.
    def exitIds(self, ctx:SlimParser.IdsContext):
        pass


    # Enter a parse tree produced by SlimParser#preamble.
    def enterPreamble(self, ctx:SlimParser.PreambleContext):
        pass

    # Exit a parse tree produced by SlimParser#preamble.
    def exitPreamble(self, ctx:SlimParser.PreambleContext):
        pass


    # Enter a parse tree produced by SlimParser#program.
    def enterProgram(self, ctx:SlimParser.ProgramContext):
        pass

    # Exit a parse tree produced by SlimParser#program.
    def exitProgram(self, ctx:SlimParser.ProgramContext):
        pass


    # Enter a parse tree produced by SlimParser#typ_base.
    def enterTyp_base(self, ctx:SlimParser.Typ_baseContext):
        pass

    # Exit a parse tree produced by SlimParser#typ_base.
    def exitTyp_base(self, ctx:SlimParser.Typ_baseContext):
        pass


    # Enter a parse tree produced by SlimParser#typ.
    def enterTyp(self, ctx:SlimParser.TypContext):
        pass

    # Exit a parse tree produced by SlimParser#typ.
    def exitTyp(self, ctx:SlimParser.TypContext):
        pass


    # Enter a parse tree produced by SlimParser#negchain.
    def enterNegchain(self, ctx:SlimParser.NegchainContext):
        pass

    # Exit a parse tree produced by SlimParser#negchain.
    def exitNegchain(self, ctx:SlimParser.NegchainContext):
        pass


    # Enter a parse tree produced by SlimParser#qualification.
    def enterQualification(self, ctx:SlimParser.QualificationContext):
        pass

    # Exit a parse tree produced by SlimParser#qualification.
    def exitQualification(self, ctx:SlimParser.QualificationContext):
        pass


    # Enter a parse tree produced by SlimParser#subtyping.
    def enterSubtyping(self, ctx:SlimParser.SubtypingContext):
        pass

    # Exit a parse tree produced by SlimParser#subtyping.
    def exitSubtyping(self, ctx:SlimParser.SubtypingContext):
        pass


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


    # Enter a parse tree produced by SlimParser#record.
    def enterRecord(self, ctx:SlimParser.RecordContext):
        pass

    # Exit a parse tree produced by SlimParser#record.
    def exitRecord(self, ctx:SlimParser.RecordContext):
        pass


    # Enter a parse tree produced by SlimParser#function.
    def enterFunction(self, ctx:SlimParser.FunctionContext):
        pass

    # Exit a parse tree produced by SlimParser#function.
    def exitFunction(self, ctx:SlimParser.FunctionContext):
        pass


    # Enter a parse tree produced by SlimParser#keychain.
    def enterKeychain(self, ctx:SlimParser.KeychainContext):
        pass

    # Exit a parse tree produced by SlimParser#keychain.
    def exitKeychain(self, ctx:SlimParser.KeychainContext):
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


    # Enter a parse tree produced by SlimParser#base_pattern.
    def enterBase_pattern(self, ctx:SlimParser.Base_patternContext):
        pass

    # Exit a parse tree produced by SlimParser#base_pattern.
    def exitBase_pattern(self, ctx:SlimParser.Base_patternContext):
        pass


    # Enter a parse tree produced by SlimParser#record_pattern.
    def enterRecord_pattern(self, ctx:SlimParser.Record_patternContext):
        pass

    # Exit a parse tree produced by SlimParser#record_pattern.
    def exitRecord_pattern(self, ctx:SlimParser.Record_patternContext):
        pass



del SlimParser