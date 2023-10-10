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


@dataclass(frozen=True, eq=True)
class Symbol:
    content : str

@dataclass(frozen=True, eq=True)
class Terminal:
    content : str

@dataclass(frozen=True, eq=True)
class Nonterm: 
    content : str

@dataclass(frozen=True, eq=True)
class Guidance:
    syntax : Union[Symbol, Terminal, Nonterm]


def serializedATN():
    return [
        4,1,15,77,2,0,7,0,2,1,7,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,4,0,26,8,0,11,0,12,
        0,27,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,3,0,49,8,0,1,0,1,0,1,0,1,0,1,0,5,0,56,8,0,10,0,12,
        0,59,9,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        3,1,75,8,1,1,1,0,1,0,2,0,2,0,0,87,0,48,1,0,0,0,2,74,1,0,0,0,4,49,
        6,0,-1,0,5,6,5,13,0,0,6,49,6,0,-1,0,7,8,5,1,0,0,8,49,6,0,-1,0,9,
        10,5,2,0,0,10,11,5,13,0,0,11,12,3,0,0,8,12,13,6,0,-1,0,13,49,1,0,
        0,0,14,15,3,2,1,0,15,16,6,0,-1,0,16,49,1,0,0,0,17,18,5,13,0,0,18,
        19,5,3,0,0,19,49,3,0,0,6,20,21,5,6,0,0,21,22,3,0,0,0,22,23,5,3,0,
        0,23,24,3,0,0,0,24,26,1,0,0,0,25,20,1,0,0,0,26,27,1,0,0,0,27,25,
        1,0,0,0,27,28,1,0,0,0,28,49,1,0,0,0,29,30,5,7,0,0,30,31,3,0,0,0,
        31,32,5,8,0,0,32,33,3,0,0,0,33,34,5,9,0,0,34,35,3,0,0,3,35,49,1,
        0,0,0,36,37,5,10,0,0,37,38,6,0,-1,0,38,39,5,4,0,0,39,40,6,0,-1,0,
        40,41,3,0,0,0,41,42,5,5,0,0,42,43,6,0,-1,0,43,49,1,0,0,0,44,45,5,
        4,0,0,45,46,3,0,0,0,46,47,5,5,0,0,47,49,1,0,0,0,48,4,1,0,0,0,48,
        5,1,0,0,0,48,7,1,0,0,0,48,9,1,0,0,0,48,14,1,0,0,0,48,17,1,0,0,0,
        48,25,1,0,0,0,48,29,1,0,0,0,48,36,1,0,0,0,48,44,1,0,0,0,49,57,1,
        0,0,0,50,51,10,5,0,0,51,52,5,4,0,0,52,53,3,0,0,0,53,54,5,5,0,0,54,
        56,1,0,0,0,55,50,1,0,0,0,56,59,1,0,0,0,57,55,1,0,0,0,57,58,1,0,0,
        0,58,1,1,0,0,0,59,57,1,0,0,0,60,75,1,0,0,0,61,62,5,11,0,0,62,63,
        5,13,0,0,63,64,5,12,0,0,64,65,3,0,0,0,65,66,6,1,-1,0,66,75,1,0,0,
        0,67,68,5,11,0,0,68,69,5,13,0,0,69,70,5,12,0,0,70,71,3,0,0,0,71,
        72,3,2,1,0,72,73,6,1,-1,0,73,75,1,0,0,0,74,60,1,0,0,0,74,61,1,0,
        0,0,74,67,1,0,0,0,75,3,1,0,0,0,4,27,48,57,74
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "':'", "'=>'", "'('", "')'", "'fun'", 
                     "'if'", "'then'", "'else'", "'fix'", "'.'", "'='" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_expr = 0
    RULE_record = 1

    ruleNames =  [ "expr", "record" ]

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




    _guidance : Guidance

    @property
    def guidance(self) -> Guidance:
        return self._guidance

    @guidance.setter
    def guidance(self, value : Guidance):
        self._guidance = value




    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self._ID = None # Token
            self._expr = None # ExprContext
            self._record = None # RecordContext
            self.param = None # ExprContext
            self.body = None # ExprContext
            self.cond = None # ExprContext
            self.t = None # ExprContext
            self.f = None # ExprContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.ExprContext)
            else:
                return self.getTypedRuleContext(SlimParser.ExprContext,i)


        def record(self):
            return self.getTypedRuleContext(SlimParser.RecordContext,0)


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
            self.state = 48
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                pass

            elif la_ == 2:
                self.state = 5
                localctx._ID = self.match(SlimParser.ID)

                localctx.result =  f'(id {(None if localctx._ID is None else localctx._ID.text)})'

                pass

            elif la_ == 3:
                self.state = 7
                self.match(SlimParser.T__0)

                localctx.result = f'(unit)'

                pass

            elif la_ == 4:
                self.state = 9
                self.match(SlimParser.T__1)
                self.state = 10
                localctx._ID = self.match(SlimParser.ID)
                self.state = 11
                localctx._expr = self.expr(8)

                localctx.result = f'(tag {(None if localctx._ID is None else localctx._ID.text)} {localctx._expr.result})'

                pass

            elif la_ == 5:
                self.state = 14
                localctx._record = self.record()

                localctx.result = localctx._record.result

                pass

            elif la_ == 6:
                self.state = 17
                localctx._ID = self.match(SlimParser.ID)
                self.state = 18
                self.match(SlimParser.T__2)
                self.state = 19
                localctx._expr = self.expr(6)
                pass

            elif la_ == 7:
                self.state = 25 
                self._errHandler.sync(self)
                _alt = 1
                while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                    if _alt == 1:
                        self.state = 20
                        self.match(SlimParser.T__5)
                        self.state = 21
                        localctx.param = localctx._expr = self.expr(0)
                        self.state = 22
                        self.match(SlimParser.T__2)
                        self.state = 23
                        localctx.body = localctx._expr = self.expr(0)

                    else:
                        raise NoViableAltException(self)
                    self.state = 27 
                    self._errHandler.sync(self)
                    _alt = self._interp.adaptivePredict(self._input,0,self._ctx)

                pass

            elif la_ == 8:
                self.state = 29
                self.match(SlimParser.T__6)
                self.state = 30
                localctx.cond = localctx._expr = self.expr(0)
                self.state = 31
                self.match(SlimParser.T__7)
                self.state = 32
                localctx.t = localctx._expr = self.expr(0)
                self.state = 33
                self.match(SlimParser.T__8)
                self.state = 34
                localctx.f = localctx._expr = self.expr(3)
                pass

            elif la_ == 9:
                self.state = 36
                self.match(SlimParser.T__9)
                 
                self.guidance = Guidance(Symbol("(")); 

                self.state = 38
                self.match(SlimParser.T__3)

                self.guidance = Guidance(Nonterm("expr")); 

                self.state = 40
                localctx.body = localctx._expr = self.expr(0)
                self.state = 41
                self.match(SlimParser.T__4)

                localctx.result = f'(fix {localctx.body.result})'

                pass

            elif la_ == 10:
                self.state = 44
                self.match(SlimParser.T__3)
                self.state = 45
                localctx.body = localctx._expr = self.expr(0)
                self.state = 46
                self.match(SlimParser.T__4)
                pass


            self._ctx.stop = self._input.LT(-1)
            self.state = 57
            self._errHandler.sync(self)
            _alt = self._interp.adaptivePredict(self._input,2,self._ctx)
            while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                if _alt==1:
                    if self._parseListeners is not None:
                        self.triggerExitRuleEvent()
                    _prevctx = localctx
                    localctx = SlimParser.ExprContext(self, _parentctx, _parentState)
                    self.pushNewRecursionContext(localctx, _startState, self.RULE_expr)
                    self.state = 50
                    if not self.precpred(self._ctx, 5):
                        from antlr4.error.Errors import FailedPredicateException
                        raise FailedPredicateException(self, "self.precpred(self._ctx, 5)")
                    self.state = 51
                    self.match(SlimParser.T__3)
                    self.state = 52
                    localctx._expr = self.expr(0)
                    self.state = 53
                    self.match(SlimParser.T__4) 
                self.state = 59
                self._errHandler.sync(self)
                _alt = self._interp.adaptivePredict(self._input,2,self._ctx)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.unrollRecursionContexts(_parentctx)
        return localctx


    class RecordContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self._ID = None # Token
            self._expr = None # ExprContext
            self._record = None # RecordContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def record(self):
            return self.getTypedRuleContext(SlimParser.RecordContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_record

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterRecord" ):
                listener.enterRecord(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitRecord" ):
                listener.exitRecord(self)




    def record(self):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_record)
        try:
            self.state = 74
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 61
                self.match(SlimParser.T__10)
                self.state = 62
                localctx._ID = self.match(SlimParser.ID)
                self.state = 63
                self.match(SlimParser.T__11)
                self.state = 64
                localctx._expr = self.expr(0)

                localctx.result = f'(field {(None if localctx._ID is None else localctx._ID.text)} {localctx._expr.result})'

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 67
                self.match(SlimParser.T__10)
                self.state = 68
                localctx._ID = self.match(SlimParser.ID)
                self.state = 69
                self.match(SlimParser.T__11)
                self.state = 70
                localctx._expr = self.expr(0)
                self.state = 71
                localctx._record = self.record()

                localctx.result = f'(field {(None if localctx._ID is None else localctx._ID.text)} {localctx._expr.result})' + ' ' + localctx._record.result 

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
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
         




