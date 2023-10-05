# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,15,71,2,0,7,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,4,0,17,8,0,11,0,12,0,18,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,4,0,33,8,0,11,0,12,0,34,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,
        0,58,8,0,1,0,1,0,1,0,1,0,1,0,1,0,5,0,66,8,0,10,0,12,0,69,9,0,1,0,
        0,1,0,1,0,0,0,81,0,57,1,0,0,0,2,58,6,0,-1,0,3,4,5,13,0,0,4,58,6,
        0,-1,0,5,6,5,1,0,0,6,58,6,0,-1,0,7,8,5,2,0,0,8,9,5,13,0,0,9,10,3,
        0,0,8,10,11,6,0,-1,0,11,58,1,0,0,0,12,13,5,3,0,0,13,14,5,13,0,0,
        14,15,5,4,0,0,15,17,3,0,0,0,16,12,1,0,0,0,17,18,1,0,0,0,18,16,1,
        0,0,0,18,19,1,0,0,0,19,20,1,0,0,0,20,21,6,0,-1,0,21,58,1,0,0,0,22,
        23,5,13,0,0,23,24,5,5,0,0,24,25,3,0,0,6,25,26,6,0,-1,0,26,58,1,0,
        0,0,27,28,5,8,0,0,28,29,3,0,0,0,29,30,5,5,0,0,30,31,3,0,0,0,31,33,
        1,0,0,0,32,27,1,0,0,0,33,34,1,0,0,0,34,32,1,0,0,0,34,35,1,0,0,0,
        35,36,1,0,0,0,36,37,6,0,-1,0,37,58,1,0,0,0,38,39,5,9,0,0,39,40,3,
        0,0,0,40,41,5,10,0,0,41,42,3,0,0,0,42,43,5,11,0,0,43,44,3,0,0,3,
        44,45,6,0,-1,0,45,58,1,0,0,0,46,47,5,12,0,0,47,48,5,6,0,0,48,49,
        3,0,0,0,49,50,5,7,0,0,50,51,6,0,-1,0,51,58,1,0,0,0,52,53,5,6,0,0,
        53,54,3,0,0,0,54,55,5,7,0,0,55,56,6,0,-1,0,56,58,1,0,0,0,57,2,1,
        0,0,0,57,3,1,0,0,0,57,5,1,0,0,0,57,7,1,0,0,0,57,16,1,0,0,0,57,22,
        1,0,0,0,57,32,1,0,0,0,57,38,1,0,0,0,57,46,1,0,0,0,57,52,1,0,0,0,
        58,67,1,0,0,0,59,60,10,5,0,0,60,61,5,6,0,0,61,62,3,0,0,0,62,63,5,
        7,0,0,63,64,6,0,-1,0,64,66,1,0,0,0,65,59,1,0,0,0,66,69,1,0,0,0,67,
        65,1,0,0,0,67,68,1,0,0,0,68,1,1,0,0,0,69,67,1,0,0,0,4,18,34,57,67
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "':'", "'.'", "'='", "'=>'", "'('", 
                     "')'", "'fun'", "'if'", "'then'", "'else'", "'fix'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_expr = 0

    ruleNames =  [ "expr" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    T__4=5
    T__5=6
    T__6=7
    T__7=8
    T__8=9
    T__9=10
    T__10=11
    T__11=12
    ID=13
    INT=14
    WS=15

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self.param = None # ExprContext
            self.body = None # ExprContext
            self.cond = None # ExprContext
            self.t = None # ExprContext
            self.f = None # ExprContext

        def ID(self, i:int=None):
            if i is None:
                return self.getTokens(SlimParser.ID)
            else:
                return self.getToken(SlimParser.ID, i)

        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.ExprContext)
            else:
                return self.getTypedRuleContext(SlimParser.ExprContext,i)


        def getRuleIndex(self):
            return SlimParser.RULE_expr

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterExpr" ):
                listener.enterExpr(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitExpr" ):
                listener.exitExpr(self)



    def expr(self, _p:int=0):
        _parentctx = self._ctx
        _parentState = self.state
        localctx = SlimParser.ExprContext(self, self._ctx, _parentState)
        _prevctx = localctx
        _startState = 0
        self.enterRecursionRule(localctx, 0, self.RULE_expr, _p)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 57
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                pass

            elif la_ == 2:
                self.state = 3
                self.match(SlimParser.ID)

                    
                pass

            elif la_ == 3:
                self.state = 5
                self.match(SlimParser.T__0)

                    
                pass

            elif la_ == 4:
                self.state = 7
                self.match(SlimParser.T__1)
                self.state = 8
                self.match(SlimParser.ID)
                self.state = 9
                self.expr(8)

                    
                pass

            elif la_ == 5:
                self.state = 16 
                self._errHandler.sync(self)
                _alt = 1
                while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                    if _alt == 1:
                        self.state = 12
                        self.match(SlimParser.T__2)
                        self.state = 13
                        self.match(SlimParser.ID)
                        self.state = 14
                        self.match(SlimParser.T__3)
                        self.state = 15
                        self.expr(0)

                    else:
                        raise NoViableAltException(self)
                    self.state = 18 
                    self._errHandler.sync(self)
                    _alt = self._interp.adaptivePredict(self._input,0,self._ctx)


                    
                pass

            elif la_ == 6:
                self.state = 22
                self.match(SlimParser.ID)
                self.state = 23
                self.match(SlimParser.T__4)
                self.state = 24
                self.expr(6)

                    
                pass

            elif la_ == 7:
                self.state = 32 
                self._errHandler.sync(self)
                _alt = 1
                while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                    if _alt == 1:
                        self.state = 27
                        self.match(SlimParser.T__7)
                        self.state = 28
                        localctx.param = self.expr(0)
                        self.state = 29
                        self.match(SlimParser.T__4)
                        self.state = 30
                        localctx.body = self.expr(0)

                    else:
                        raise NoViableAltException(self)
                    self.state = 34 
                    self._errHandler.sync(self)
                    _alt = self._interp.adaptivePredict(self._input,1,self._ctx)


                    
                pass

            elif la_ == 8:
                self.state = 38
                self.match(SlimParser.T__8)
                self.state = 39
                localctx.cond = self.expr(0)
                self.state = 40
                self.match(SlimParser.T__9)
                self.state = 41
                localctx.t = self.expr(0)
                self.state = 42
                self.match(SlimParser.T__10)
                self.state = 43
                localctx.f = self.expr(3)

                    
                pass

            elif la_ == 9:
                self.state = 46
                self.match(SlimParser.T__11)
                self.state = 47
                self.match(SlimParser.T__5)
                self.state = 48
                localctx.body = self.expr(0)
                self.state = 49
                self.match(SlimParser.T__6)

                    
                pass

            elif la_ == 10:
                self.state = 52
                self.match(SlimParser.T__5)
                self.state = 53
                localctx.body = self.expr(0)
                self.state = 54
                self.match(SlimParser.T__6)

                    
                pass


            self._ctx.stop = self._input.LT(-1)
            self.state = 67
            self._errHandler.sync(self)
            _alt = self._interp.adaptivePredict(self._input,3,self._ctx)
            while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                if _alt==1:
                    if self._parseListeners is not None:
                        self.triggerExitRuleEvent()
                    _prevctx = localctx
                    localctx = SlimParser.ExprContext(self, _parentctx, _parentState)
                    self.pushNewRecursionContext(localctx, _startState, self.RULE_expr)
                    self.state = 59
                    if not self.precpred(self._ctx, 5):
                        from antlr4.error.Errors import FailedPredicateException
                        raise FailedPredicateException(self, "self.precpred(self._ctx, 5)")
                    self.state = 60
                    self.match(SlimParser.T__5)
                    self.state = 61
                    self.expr(0)
                    self.state = 62
                    self.match(SlimParser.T__6)

                                   
                self.state = 69
                self._errHandler.sync(self)
                _alt = self._interp.adaptivePredict(self._input,3,self._ctx)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.unrollRecursionContexts(_parentctx)
        return localctx



    def sempred(self, localctx:RuleContext, ruleIndex:int, predIndex:int):
        if self._predicates == None:
            self._predicates = dict()
        self._predicates[0] = self.expr_sempred
        pred = self._predicates.get(ruleIndex, None)
        if pred is None:
            raise Exception("No predicate with index:" + str(ruleIndex))
        else:
            return pred(localctx, predIndex)

    def expr_sempred(self, localctx:ExprContext, predIndex:int):
            if predIndex == 0:
                return self.precpred(self._ctx, 5)
         




