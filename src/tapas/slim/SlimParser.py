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


@dataclass(frozen=True, eq=True)
class Symbol:
    content : str

@dataclass(frozen=True, eq=True)
class Terminal:
    content : str

@dataclass(frozen=True, eq=True)
class Nonterm: 
    content : str



def serializedATN():
    return [
        4,1,15,78,2,0,7,0,2,1,7,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,4,0,26,8,0,11,0,12,
        0,27,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,3,0,50,8,0,1,0,1,0,1,0,1,0,1,0,5,0,57,8,0,10,
        0,12,0,60,9,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,3,1,76,8,1,1,1,0,1,0,2,0,2,0,0,88,0,49,1,0,0,0,2,75,1,0,0,
        0,4,50,6,0,-1,0,5,6,5,13,0,0,6,50,6,0,-1,0,7,8,5,1,0,0,8,50,6,0,
        -1,0,9,10,5,2,0,0,10,11,5,13,0,0,11,12,3,0,0,8,12,13,6,0,-1,0,13,
        50,1,0,0,0,14,15,3,2,1,0,15,16,6,0,-1,0,16,50,1,0,0,0,17,18,5,13,
        0,0,18,19,5,3,0,0,19,50,3,0,0,6,20,21,5,6,0,0,21,22,3,0,0,0,22,23,
        5,3,0,0,23,24,3,0,0,0,24,26,1,0,0,0,25,20,1,0,0,0,26,27,1,0,0,0,
        27,25,1,0,0,0,27,28,1,0,0,0,28,50,1,0,0,0,29,30,5,7,0,0,30,31,3,
        0,0,0,31,32,5,8,0,0,32,33,3,0,0,0,33,34,5,9,0,0,34,35,3,0,0,3,35,
        50,1,0,0,0,36,37,5,10,0,0,37,38,6,0,-1,0,38,39,5,4,0,0,39,40,6,0,
        -1,0,40,41,3,0,0,0,41,42,6,0,-1,0,42,43,5,5,0,0,43,44,6,0,-1,0,44,
        50,1,0,0,0,45,46,5,4,0,0,46,47,3,0,0,0,47,48,5,5,0,0,48,50,1,0,0,
        0,49,4,1,0,0,0,49,5,1,0,0,0,49,7,1,0,0,0,49,9,1,0,0,0,49,14,1,0,
        0,0,49,17,1,0,0,0,49,25,1,0,0,0,49,29,1,0,0,0,49,36,1,0,0,0,49,45,
        1,0,0,0,50,58,1,0,0,0,51,52,10,5,0,0,52,53,5,4,0,0,53,54,3,0,0,0,
        54,55,5,5,0,0,55,57,1,0,0,0,56,51,1,0,0,0,57,60,1,0,0,0,58,56,1,
        0,0,0,58,59,1,0,0,0,59,1,1,0,0,0,60,58,1,0,0,0,61,76,1,0,0,0,62,
        63,5,11,0,0,63,64,5,13,0,0,64,65,5,12,0,0,65,66,3,0,0,0,66,67,6,
        1,-1,0,67,76,1,0,0,0,68,69,5,11,0,0,69,70,5,13,0,0,70,71,5,12,0,
        0,71,72,3,0,0,0,72,73,3,2,1,0,73,74,6,1,-1,0,74,76,1,0,0,0,75,61,
        1,0,0,0,75,62,1,0,0,0,75,68,1,0,0,0,76,3,1,0,0,0,4,27,49,58,75
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




    guidance : Union[Symbol, Terminal, Nonterm]
    cache : dict[int, str] 
    _overflow = False  

     

    # _guidance : Union[Symbol, Terminal, Nonterm]
    # @property
    # def guidance(self) -> Union[Symbol, Terminal, Nonterm]:
    #     return self._guidance
    # 
    # @guidance.setter
    # def guidance(self, value : Union[Symbol, Terminal, Nonterm]):
    #     self._guidance = value

    #def getAllText(self):  # include hidden channel
    #    # token_stream = ctx.parser.getTokenStream()
    #    token_stream = self.getTokenStream()
    #    lexer = token_stream.tokenSource
    #    input_stream = lexer.inputStream
    #    # start = ctx.start.start
    #    start = 0
    #    # stop = ctx.stop.stop
    #
    #    # TODO: increment token position in attributes
    #    # TODO: map token position to result 
    #    # TODO: figure out a way to get the current position of the parser
    #    stop = self.getRuleIndex()
    #    # return input_stream.getText(start, stop)
    #    print(f"start: {start}")
    #    print(f"stoppy poop: {stop}")
    #    return "<<not yet implemented>>"
    #    # return input_stream.getText(start, stop)[start:stop]


    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def updateOverflow(self):
        tok = self.getCurrentToken()
        print(f"TOK (updateOverflow): {tok}")
        print(f"_overflow: : {self._overflow}")
        if not self._overflow and tok.type == self.EOF :
            self._overflow = True 

    def overflow(self) -> bool: 
        return self._overflow


    # @contextmanager
    # def manage_guidance(self):
    #     if not self.overflow():
    #         yield
    #     self.updateOverflow()

    def guide(self, g):
        if not self.overflow():
            self.guidance = g
        self.updateOverflow()

    # @contextmanager
    # def gather(self) -> Optional:
    #     if not self.overflow():
    #         return
    #     else
    #       return None




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
            self.state = 49
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

                if self.cache.get(self.tokenIndex()):
                    print("CACHE HIT")
                    localctx.result = self.cache[self.tokenIndex()]
                else:
                    print("COMPUTATION")
                    localctx.result = f'(unit)'
                    self.cache[self.tokenIndex()] = localctx.result

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
                 
                self.guide(Symbol("("))

                self.state = 38
                self.match(SlimParser.T__3)

                self.guide(Nonterm("expr"))

                # with self.manage_guidance():
                #     self.guidance = Nonterm("expr")
                #     # print(f"GUIDANCE: {self.guidance}")


                self.state = 40
                localctx.body = localctx._expr = self.expr(0)

                # TODO: need to detect that token index has not changed 
                # lack of change indicates outofbounds  
                # set token_index to -1 when out of bounds
                print("REACHED HERE")
                print(f"REACHED HERE overflow: {self.overflow()}")
                print(f"CURRENT TOKEN: {self.getCurrentToken()}")

                # if not self.overflow(): 
                #     self.guidance = Symbol(")")
                #     # print(f"GUIDANCE: {self.guidance}")
                # 
                # self.updateOverflow()
                self.guide(Symbol(')'))

                self.state = 42
                self.match(SlimParser.T__4)

                if not self.overflow(): 
                    localctx.result = unbox(
                        f'(fix {body})'
                        for body in box(localctx.body.result) 
                    )

                pass

            elif la_ == 10:
                self.state = 45
                self.match(SlimParser.T__3)
                self.state = 46
                localctx.body = localctx._expr = self.expr(0)
                self.state = 47
                self.match(SlimParser.T__4)
                pass


            self._ctx.stop = self._input.LT(-1)
            self.state = 58
            self._errHandler.sync(self)
            _alt = self._interp.adaptivePredict(self._input,2,self._ctx)
            while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                if _alt==1:
                    if self._parseListeners is not None:
                        self.triggerExitRuleEvent()
                    _prevctx = localctx
                    localctx = SlimParser.ExprContext(self, _parentctx, _parentState)
                    self.pushNewRecursionContext(localctx, _startState, self.RULE_expr)
                    self.state = 51
                    if not self.precpred(self._ctx, 5):
                        from antlr4.error.Errors import FailedPredicateException
                        raise FailedPredicateException(self, "self.precpred(self._ctx, 5)")
                    self.state = 52
                    self.match(SlimParser.T__3)
                    self.state = 53
                    localctx._expr = self.expr(0)
                    self.state = 54
                    self.match(SlimParser.T__4) 
                self.state = 60
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
            self.state = 75
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 62
                self.match(SlimParser.T__10)
                self.state = 63
                localctx._ID = self.match(SlimParser.ID)
                self.state = 64
                self.match(SlimParser.T__11)
                self.state = 65
                localctx._expr = self.expr(0)

                localctx.result = f'(field {(None if localctx._ID is None else localctx._ID.text)} {localctx._expr.result})'

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 68
                self.match(SlimParser.T__10)
                self.state = 69
                localctx._ID = self.match(SlimParser.ID)
                self.state = 70
                self.match(SlimParser.T__11)
                self.state = 71
                localctx._expr = self.expr(0)
                self.state = 72
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
         




