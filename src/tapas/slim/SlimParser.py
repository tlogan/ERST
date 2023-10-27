# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO


from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analysis import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 


def serializedATN():
    return [
        4,1,7,17,2,0,7,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        3,0,15,8,0,1,0,0,0,1,0,0,0,17,0,14,1,0,0,0,2,15,1,0,0,0,3,4,5,1,
        0,0,4,15,6,0,-1,0,5,6,5,2,0,0,6,7,6,0,-1,0,7,8,5,3,0,0,8,9,6,0,-1,
        0,9,10,3,0,0,0,10,11,6,0,-1,0,11,12,5,4,0,0,12,13,6,0,-1,0,13,15,
        1,0,0,0,14,2,1,0,0,0,14,3,1,0,0,0,14,5,1,0,0,0,15,1,1,0,0,0,1,14
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "'fix'", "'('", "')'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_expr = 0

    ruleNames =  [ "expr" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    ID=5
    INT=6
    WS=7

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    _analyzer : Analyzer
    _cache : dict[int, str] = {}

    _guidance : Guidance 
    _overflow = False  

    def init(self): 
        self._analyzer = Analyzer() 
        self._cache = {}
        self._guidance = plate_default 
        self._overflow = False  

    def reset(self): 
        self._guidance = plate_default
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def guard_down(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
        for arg in args:
            if arg == None:
                self._overflow = True

        result = None
        if not self._overflow:
            result = f(plate, *args)
            self._guidance = result

            # tok = self.getCurrentToken()
            # if tok.type == self.EOF :
            #     self._overflow = True 

        return result


    def shift(self, guidance : Union[Symbol, Terminal]):   
        if not self._overflow:
            self._guidance = guidance 

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 



    def guard_up(self, f : Callable, plate : Plate, *args):

        if self._overflow:
            return None
        else:

            clean = next((
                False
                for arg in args
                if arg == None
            ), True)

            if clean:
                return f(plate, *args)
            else:
                return None
            # TODO: caching is broken; tokenIndex does not change 
            # index = self.tokenIndex() 
            # cache_result = self._cache.get(index)
            # print(f"CACHE: {self._cache}")
            # if False: # cache_result:
            #     return cache_result
            # else:
            #     result = f(*args)
            #     self._cache[index] = result
            #     return result




    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.typ = None
            self.body = None # ExprContext
            self.plate = plate

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_expr

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterExpr" ):
                listener.enterExpr(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitExpr" ):
                listener.exitExpr(self)




    def expr(self, plate:Plate):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 14
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1]:
                self.enterOuterAlt(localctx, 2)
                self.state = 3
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_unit, plate)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 3)
                self.state = 5
                self.match(SlimParser.T__1)
                 
                self.shift(Symbol("("))

                self.state = 7
                self.match(SlimParser.T__2)

                plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)

                self.state = 9
                localctx.body = self.expr(plate_body)

                self.shift(Symbol(')'))

                self.state = 11
                self.match(SlimParser.T__3)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_fix, plate, localctx.body.typ)

                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





