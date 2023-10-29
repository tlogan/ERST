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
        4,1,12,88,2,0,7,0,2,1,7,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,70,8,0,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,86,8,1,1,1,0,0,2,0,2,0,0,98,
        0,69,1,0,0,0,2,85,1,0,0,0,4,70,1,0,0,0,5,6,5,10,0,0,6,70,6,0,-1,
        0,7,8,5,1,0,0,8,70,6,0,-1,0,9,10,5,2,0,0,10,11,5,10,0,0,11,12,3,
        0,0,0,12,13,6,0,-1,0,13,70,1,0,0,0,14,15,3,2,1,0,15,16,6,0,-1,0,
        16,70,1,0,0,0,17,18,5,3,0,0,18,19,3,0,0,0,19,20,5,4,0,0,20,21,5,
        5,0,0,21,22,5,10,0,0,22,23,6,0,-1,0,23,70,1,0,0,0,24,25,5,10,0,0,
        25,26,5,6,0,0,26,27,6,0,-1,0,27,28,3,0,0,0,28,29,6,0,-1,0,29,70,
        1,0,0,0,30,31,5,3,0,0,31,32,6,0,-1,0,32,33,3,0,0,0,33,34,5,4,0,0,
        34,35,6,0,-1,0,35,36,5,3,0,0,36,37,3,0,0,0,37,38,5,4,0,0,38,39,6,
        0,-1,0,39,70,1,0,0,0,40,41,5,10,0,0,41,42,6,0,-1,0,42,43,5,3,0,0,
        43,44,3,0,0,0,44,45,5,4,0,0,45,46,6,0,-1,0,46,70,1,0,0,0,47,48,5,
        7,0,0,48,49,5,10,0,0,49,50,5,8,0,0,50,51,6,0,-1,0,51,52,3,0,0,0,
        52,53,6,0,-1,0,53,54,3,0,0,0,54,55,6,0,-1,0,55,70,1,0,0,0,56,57,
        5,9,0,0,57,58,6,0,-1,0,58,59,5,3,0,0,59,60,6,0,-1,0,60,61,3,0,0,
        0,61,62,6,0,-1,0,62,63,5,4,0,0,63,64,6,0,-1,0,64,70,1,0,0,0,65,66,
        5,3,0,0,66,67,3,0,0,0,67,68,5,4,0,0,68,70,1,0,0,0,69,4,1,0,0,0,69,
        5,1,0,0,0,69,7,1,0,0,0,69,9,1,0,0,0,69,14,1,0,0,0,69,17,1,0,0,0,
        69,24,1,0,0,0,69,30,1,0,0,0,69,40,1,0,0,0,69,47,1,0,0,0,69,56,1,
        0,0,0,69,65,1,0,0,0,70,1,1,0,0,0,71,86,1,0,0,0,72,73,5,5,0,0,73,
        74,5,10,0,0,74,75,5,8,0,0,75,76,3,0,0,0,76,77,6,1,-1,0,77,86,1,0,
        0,0,78,79,5,5,0,0,79,80,5,10,0,0,80,81,5,8,0,0,81,82,3,0,0,0,82,
        83,3,2,1,0,83,84,6,1,-1,0,84,86,1,0,0,0,85,71,1,0,0,0,85,72,1,0,
        0,0,85,78,1,0,0,0,86,3,1,0,0,0,2,69,85
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'.'", "'=>'", 
                     "'let'", "'='", "'fix'" ]

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
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self._expr = None # ExprContext
            self.rator = None # ExprContext
            self.rand = None # ExprContext
            self.target = None # ExprContext
            self.plate = plate

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




    def expr(self, plate:Plate):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 69
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 5
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_id, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 7
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_unit, plate)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 9
                self.match(SlimParser.T__1)
                self.state = 10
                localctx._ID = self.match(SlimParser.ID)
                self.state = 11
                localctx.body = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_tag, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 14
                localctx._record = self.record(plate)

                localctx.typ = localctx._record.typ

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 17
                self.match(SlimParser.T__2)
                self.state = 18
                localctx._expr = self.expr(plate)
                self.state = 19
                self.match(SlimParser.T__3)
                self.state = 20
                self.match(SlimParser.T__4)
                self.state = 21
                localctx._ID = self.match(SlimParser.ID)
                 \
                localctx.typ = self.guard_up(self._analyzer.combine_expr_projection, plate, localctx._expr.typ, (None if localctx._ID is None else localctx._ID.text)) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 24
                localctx._ID = self.match(SlimParser.ID)
                self.state = 25
                self.match(SlimParser.T__5)

                plate_body = self.guard_down(self._analyzer.distill_expr_function_body, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 27
                localctx.body = self.expr(plate_body)

                plate = plate_body
                localctx.typ = self.guard_up(self._analyzer.combine_expr_function, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 30
                self.match(SlimParser.T__2)

                # TODO
                plate_rator = plate

                self.state = 32
                localctx.rator = self.expr(plate_rator)
                self.state = 33
                self.match(SlimParser.T__3)
                 \
                plate_rand = self.guard_down(self._analyzer.distill_expr_application_rand, plate, localctx.rator.typ)

                self.state = 35
                self.match(SlimParser.T__2)
                self.state = 36
                localctx.rand = self.expr(plate_rand)
                self.state = 37
                self.match(SlimParser.T__3)
                 \
                localctx.typ = self.guard_up(self._analyzer.combine_expr_application, plate, localctx.rator.typ, localctx.rand.typ) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 40
                localctx._ID = self.match(SlimParser.ID)
                 \
                plate_rand = self.guard_down(self._analyzer.distill_expr_call_rand, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 42
                self.match(SlimParser.T__2)
                self.state = 43
                localctx.rand = self.expr(plate_rand)
                self.state = 44
                self.match(SlimParser.T__3)
                 \
                localctx.typ = self.guard_up(self._analyzer.combine_expr_call, plate, (None if localctx._ID is None else localctx._ID.text), localctx.rand.typ) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 47
                self.match(SlimParser.T__6)
                self.state = 48
                localctx._ID = self.match(SlimParser.ID)
                self.state = 49
                self.match(SlimParser.T__7)

                # TODO
                plate_target = plate 

                self.state = 51
                localctx.target = self.expr(plate_target)

                plate_body = self.guard_down(self._analyzer.distill_expr_let_body, plate, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)

                self.state = 53
                localctx.body = self.expr(plate_body)

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 56
                self.match(SlimParser.T__8)
                 
                self.shift(Symbol("("))

                self.state = 58
                self.match(SlimParser.T__2)

                plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)

                self.state = 60
                localctx.body = self.expr(plate_body)

                self.shift(Symbol(')'))

                self.state = 62
                self.match(SlimParser.T__3)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_fix, plate, localctx.body.typ)

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 65
                self.match(SlimParser.T__2)
                self.state = 66
                self.expr(plate)
                self.state = 67
                self.match(SlimParser.T__3)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.typ = None
            self._ID = None # Token
            self._expr = None # ExprContext
            self._record = None # RecordContext
            self.plate = plate

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




    def record(self, plate:Plate):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 2, self.RULE_record)
        try:
            self.state = 85
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 72
                self.match(SlimParser.T__4)
                self.state = 73
                localctx._ID = self.match(SlimParser.ID)
                self.state = 74
                self.match(SlimParser.T__7)
                self.state = 75
                localctx._expr = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_record_single, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 78
                self.match(SlimParser.T__4)
                self.state = 79
                localctx._ID = self.match(SlimParser.ID)
                self.state = 80
                self.match(SlimParser.T__7)
                self.state = 81
                localctx._expr = self.expr(plate)
                self.state = 82
                localctx._record = self.record(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_record_cons, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ, localctx._record.typ)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





