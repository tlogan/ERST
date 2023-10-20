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


def serializedATN():
    return [
        4,1,7,18,2,0,7,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,3,0,16,8,0,1,0,0,0,1,0,0,0,19,0,15,1,0,0,0,2,16,1,0,0,0,3,16,
        5,5,0,0,4,5,5,1,0,0,5,16,6,0,-1,0,6,7,5,2,0,0,7,8,6,0,-1,0,8,9,5,
        3,0,0,9,10,6,0,-1,0,10,11,3,0,0,0,11,12,6,0,-1,0,12,13,5,4,0,0,13,
        14,6,0,-1,0,14,16,1,0,0,0,15,2,1,0,0,0,15,3,1,0,0,0,15,4,1,0,0,0,
        15,6,1,0,0,0,16,1,1,0,0,0,1,15
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




    _guidance : Guidance 
    _cache : dict[int, str] = {}
    _overflow = False  

    def reset(self): 
        # self.setInputStream(token_stream)
        self._guidance = NontermExpr(Top)
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def updateOverflow(self):
        tok = self.getCurrentToken()
        if not self._overflow and tok.type == self.EOF :
            self._overflow = True 

    def overflow(self) -> bool: 
        return self._overflow


    # @contextmanager
    # def manage_guidance(self):
    #     if not self.overflow():
    #         yield
    #     self.updateOverflow()

    def guard_down(self, f : Callable, *args):
        if not self.overflow():
            self._guidance = f(*args)
        self.updateOverflow()

    def guard_up(self, f : Callable, *args):
        if self.overflow():
            return None
        else:
            index = self.tokenIndex()
            cache_result = self._cache.get(index)
            if cache_result:
                return cache_result
            else:
                result = f(*args)
                self._cache[index] = result
                return result




    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self.body = None # ExprContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

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




    def expr(self):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 15
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [5]:
                self.enterOuterAlt(localctx, 2)
                self.state = 3
                self.match(SlimParser.ID)
                pass
            elif token in [1]:
                self.enterOuterAlt(localctx, 3)
                self.state = 4
                self.match(SlimParser.T__0)

                localctx.result = self.guard_up(gather_expr_unit)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 4)
                self.state = 6
                self.match(SlimParser.T__1)
                 
                self.guard_down(lambda: Symbol("("))

                self.state = 8
                self.match(SlimParser.T__2)

                self.guard_down(lambda: NontermExpr(Top))

                self.state = 10
                localctx.body = self.expr()

                self.guard_down(lambda: Symbol(')'))

                self.state = 12
                self.match(SlimParser.T__3)

                localctx.result = self.guard_up(gather_expr_fix, localctx.body.result)

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





