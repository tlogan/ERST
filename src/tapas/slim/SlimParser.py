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
        4,1,12,59,2,0,7,0,2,1,7,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,41,8,0,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,57,8,1,1,1,0,0,2,
        0,2,0,0,65,0,40,1,0,0,0,2,56,1,0,0,0,4,41,1,0,0,0,5,6,5,10,0,0,6,
        41,6,0,-1,0,7,8,5,1,0,0,8,41,6,0,-1,0,9,10,5,2,0,0,10,11,5,10,0,
        0,11,12,3,0,0,0,12,13,6,0,-1,0,13,41,1,0,0,0,14,15,3,2,1,0,15,16,
        6,0,-1,0,16,41,1,0,0,0,17,18,5,10,0,0,18,19,5,3,0,0,19,20,6,0,-1,
        0,20,21,3,0,0,0,21,22,6,0,-1,0,22,41,1,0,0,0,23,24,5,4,0,0,24,25,
        5,10,0,0,25,26,5,5,0,0,26,27,3,0,0,0,27,28,6,0,-1,0,28,29,3,0,0,
        0,29,30,6,0,-1,0,30,41,1,0,0,0,31,32,5,6,0,0,32,33,6,0,-1,0,33,34,
        5,7,0,0,34,35,6,0,-1,0,35,36,3,0,0,0,36,37,6,0,-1,0,37,38,5,8,0,
        0,38,39,6,0,-1,0,39,41,1,0,0,0,40,4,1,0,0,0,40,5,1,0,0,0,40,7,1,
        0,0,0,40,9,1,0,0,0,40,14,1,0,0,0,40,17,1,0,0,0,40,23,1,0,0,0,40,
        31,1,0,0,0,41,1,1,0,0,0,42,57,1,0,0,0,43,44,5,9,0,0,44,45,5,10,0,
        0,45,46,5,5,0,0,46,47,3,0,0,0,47,48,6,1,-1,0,48,57,1,0,0,0,49,50,
        5,9,0,0,50,51,5,10,0,0,51,52,5,5,0,0,52,53,3,0,0,0,53,54,3,2,1,0,
        54,55,6,1,-1,0,55,57,1,0,0,0,56,42,1,0,0,0,56,43,1,0,0,0,56,49,1,
        0,0,0,57,3,1,0,0,0,2,40,56
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "':'", "'=>'", "'let'", "'='", 
                     "'fix'", "'('", "')'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "ID", "INT", "WS" ]

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
    ID=10
    INT=11
    WS=12

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
        self._guidance = init_guidance
        self._overflow = False  

    def reset(self): 
        self._guidance = init_guidance
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def guard_down(self, f : Callable, *args):
        assert isinstance(self._guidance, ExprGuide)

        for arg in args:
            if arg == None:
                self._overflow = True

        if not self._overflow:
            self._guidance = f(self._guidance, *args)

        tok = self.getCurrentToken()
        if not self._overflow and tok.type == self.EOF :
            self._overflow = True 

    def guard_up(self, f : Callable, *args):

        assert isinstance(self._guidance, ExprGuide)
        
        if self._overflow:
            return None
        else:

            return f(self._guidance, *args)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.typ = None
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self.target = None # ExprContext

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




    def expr(self):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 40
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 5
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_id, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 7
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 9
                self.match(SlimParser.T__1)
                self.state = 10
                localctx._ID = self.match(SlimParser.ID)
                self.state = 11
                localctx.body = self.expr()

                localctx.typ = self.guard_up(self._analyzer.combine_expr_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 14
                localctx._record = self.record()

                localctx.typ = localctx._record.typ

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 17
                localctx._ID = self.match(SlimParser.ID)
                self.state = 18
                self.match(SlimParser.T__2)

                self.guard_down(self._analyzer.distill_expr_function_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 20
                localctx.body = self.expr()

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 23
                self.match(SlimParser.T__3)
                self.state = 24
                localctx._ID = self.match(SlimParser.ID)
                self.state = 25
                self.match(SlimParser.T__4)
                self.state = 26
                localctx.target = self.expr()

                self.guard_down(self._analyzer.distill_expr_let_body, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)

                self.state = 28
                localctx.body = self.expr()

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 31
                self.match(SlimParser.T__5)
                 
                self.guard_down(lambda: SymbolGuide("("))

                self.state = 33
                self.match(SlimParser.T__6)

                self.guard_down(self._analyzer.distill_expr_fix_body)

                self.state = 35
                localctx.body = self.expr()

                self.guard_down(lambda: SymbolGuide(')'))

                self.state = 37
                self.match(SlimParser.T__7)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_fix, localctx.body.typ)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class RecordContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.typ = None
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
            self.state = 56
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 43
                self.match(SlimParser.T__8)
                self.state = 44
                localctx._ID = self.match(SlimParser.ID)
                self.state = 45
                self.match(SlimParser.T__4)
                self.state = 46
                localctx._expr = self.expr()

                localctx.typ = self.guard_up(self._analyzer.combine_record_single, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 49
                self.match(SlimParser.T__8)
                self.state = 50
                localctx._ID = self.match(SlimParser.ID)
                self.state = 51
                self.match(SlimParser.T__4)
                self.state = 52
                localctx._expr = self.expr()
                self.state = 53
                localctx._record = self.record()

                localctx.typ = self.guard_up(self._analyzer.combine_record_cons, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ, localctx._record.typ)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





