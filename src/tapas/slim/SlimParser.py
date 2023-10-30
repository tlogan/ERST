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
        4,1,13,98,2,0,7,0,2,1,7,1,2,2,7,2,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,71,8,0,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,87,8,1,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,3,2,96,8,2,1,2,0,0,3,0,2,4,0,0,108,0,70,1,0,0,0,2,86,1,
        0,0,0,4,95,1,0,0,0,6,71,1,0,0,0,7,8,5,11,0,0,8,71,6,0,-1,0,9,10,
        5,1,0,0,10,71,6,0,-1,0,11,12,5,2,0,0,12,13,5,11,0,0,13,14,3,0,0,
        0,14,15,6,0,-1,0,15,71,1,0,0,0,16,17,3,2,1,0,17,18,6,0,-1,0,18,71,
        1,0,0,0,19,20,5,3,0,0,20,21,3,0,0,0,21,22,5,4,0,0,22,23,5,5,0,0,
        23,24,5,11,0,0,24,25,6,0,-1,0,25,71,1,0,0,0,26,27,5,11,0,0,27,28,
        5,6,0,0,28,29,6,0,-1,0,29,30,3,0,0,0,30,31,6,0,-1,0,31,71,1,0,0,
        0,32,33,5,3,0,0,33,34,3,0,0,0,34,35,5,4,0,0,35,36,6,0,-1,0,36,71,
        1,0,0,0,37,38,6,0,-1,0,38,39,5,3,0,0,39,40,3,0,0,0,40,41,6,0,-1,
        0,41,42,5,4,0,0,42,43,6,0,-1,0,43,44,3,4,2,0,44,45,6,0,-1,0,45,71,
        1,0,0,0,46,47,5,11,0,0,47,48,6,0,-1,0,48,49,3,4,2,0,49,50,6,0,-1,
        0,50,71,1,0,0,0,51,52,5,7,0,0,52,53,5,11,0,0,53,54,5,8,0,0,54,55,
        6,0,-1,0,55,56,3,0,0,0,56,57,5,9,0,0,57,58,6,0,-1,0,58,59,3,0,0,
        0,59,60,6,0,-1,0,60,71,1,0,0,0,61,62,5,10,0,0,62,63,6,0,-1,0,63,
        64,5,3,0,0,64,65,6,0,-1,0,65,66,3,0,0,0,66,67,6,0,-1,0,67,68,5,4,
        0,0,68,69,6,0,-1,0,69,71,1,0,0,0,70,6,1,0,0,0,70,7,1,0,0,0,70,9,
        1,0,0,0,70,11,1,0,0,0,70,16,1,0,0,0,70,19,1,0,0,0,70,26,1,0,0,0,
        70,32,1,0,0,0,70,37,1,0,0,0,70,46,1,0,0,0,70,51,1,0,0,0,70,61,1,
        0,0,0,71,1,1,0,0,0,72,87,1,0,0,0,73,74,5,5,0,0,74,75,5,11,0,0,75,
        76,5,8,0,0,76,77,3,0,0,0,77,78,6,1,-1,0,78,87,1,0,0,0,79,80,5,5,
        0,0,80,81,5,11,0,0,81,82,5,8,0,0,82,83,3,0,0,0,83,84,3,2,1,0,84,
        85,6,1,-1,0,85,87,1,0,0,0,86,72,1,0,0,0,86,73,1,0,0,0,86,79,1,0,
        0,0,87,3,1,0,0,0,88,96,1,0,0,0,89,90,6,2,-1,0,90,91,5,3,0,0,91,92,
        3,0,0,0,92,93,5,4,0,0,93,94,6,2,-1,0,94,96,1,0,0,0,95,88,1,0,0,0,
        95,89,1,0,0,0,96,5,1,0,0,0,3,70,86,95
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'.'", "'=>'", 
                     "'let'", "'='", "';'", "'fix'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "ID", "INT", 
                      "WS" ]

    RULE_expr = 0
    RULE_record = 1
    RULE_applicands = 2

    ruleNames =  [ "expr", "record", "applicands" ]

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
    ID=11
    INT=12
    WS=13

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
        # TODO: construct guidance from self.getCurrentToken()
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
            self.applicator = None # ExprContext
            self.content = None # ApplicandsContext
            self._applicands = None # ApplicandsContext
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


        def applicands(self):
            return self.getTypedRuleContext(SlimParser.ApplicandsContext,0)


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
            self.state = 70
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 7
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_id, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 9
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_unit, plate)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 11
                self.match(SlimParser.T__1)
                self.state = 12
                localctx._ID = self.match(SlimParser.ID)
                self.state = 13
                localctx.body = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_tag, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 16
                localctx._record = self.record(plate)

                localctx.typ = localctx._record.typ

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 19
                self.match(SlimParser.T__2)
                self.state = 20
                localctx._expr = self.expr(plate)
                self.state = 21
                self.match(SlimParser.T__3)
                self.state = 22
                self.match(SlimParser.T__4)
                self.state = 23
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_projection, plate, localctx._expr.typ, (None if localctx._ID is None else localctx._ID.text)) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 26
                localctx._ID = self.match(SlimParser.ID)
                self.state = 27
                self.match(SlimParser.T__5)

                plate_body = self.guard_down(self._analyzer.distill_expr_function_body, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 29
                localctx.body = self.expr(plate_body)

                plate = plate_body
                localctx.typ = self.guard_up(self._analyzer.combine_expr_function, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 32
                self.match(SlimParser.T__2)
                self.state = 33
                localctx._expr = self.expr(plate)
                self.state = 34
                self.match(SlimParser.T__3)

                localctx.typ = localctx._expr.typ

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.shift(Symbol("("))
                self.state = 38
                self.match(SlimParser.T__2)
                self.state = 39
                localctx.applicator = self.expr(plate)
                self.shift(Symbol(")"))
                self.state = 41
                self.match(SlimParser.T__3)

                plate_applicands = self.guard_down(self._analyzer.distill_expr_appmulti_applicands, plate, localctx.applicator.typ)

                self.state = 43
                localctx.content = localctx._applicands = self.applicands(plate_applicands)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_appmulti, plate, localctx.applicator.typ, localctx._applicands.typs)

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 46
                localctx._ID = self.match(SlimParser.ID)

                plate_applicands = self.guard_down(self._analyzer.distill_expr_callmulti_applicands, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 48
                localctx._applicands = self.applicands(plate_applicands)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_callmulti, plate, (None if localctx._ID is None else localctx._ID.text), localctx._applicands.typs) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 51
                self.match(SlimParser.T__6)
                self.state = 52
                localctx._ID = self.match(SlimParser.ID)
                self.state = 53
                self.match(SlimParser.T__7)

                # TODO
                plate_target = plate 

                self.state = 55
                localctx.target = self.expr(plate_target)
                self.state = 56
                self.match(SlimParser.T__8)

                plate_body = self.guard_down(self._analyzer.distill_expr_let_body, plate, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)

                self.state = 58
                localctx.body = self.expr(plate_body)

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 61
                self.match(SlimParser.T__9)
                 
                self.shift(Symbol("("))

                self.state = 63
                self.match(SlimParser.T__2)

                plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)

                self.state = 65
                localctx.body = self.expr(plate_body)

                self.shift(Symbol(')'))

                self.state = 67
                self.match(SlimParser.T__3)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_fix, plate, localctx.body.typ)

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
            self.state = 86
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 73
                self.match(SlimParser.T__4)
                self.state = 74
                localctx._ID = self.match(SlimParser.ID)
                self.state = 75
                self.match(SlimParser.T__7)
                self.state = 76
                localctx._expr = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_record_single, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 79
                self.match(SlimParser.T__4)
                self.state = 80
                localctx._ID = self.match(SlimParser.ID)
                self.state = 81
                self.match(SlimParser.T__7)
                self.state = 82
                localctx._expr = self.expr(plate)
                self.state = 83
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


    class ApplicandsContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.typs = None
            self.content = None # ExprContext
            self.plate = plate

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_applicands

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterApplicands" ):
                listener.enterApplicands(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitApplicands" ):
                listener.exitApplicands(self)




    def applicands(self, plate:Plate):

        localctx = SlimParser.ApplicandsContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 4, self.RULE_applicands)
        try:
            self.state = 95
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4, 5, 9]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [3]:
                self.enterOuterAlt(localctx, 2)

                plate_content = plate # self.guard_down(self._analyzer.distill_applicands_single_content, plate) 

                self.state = 90
                self.match(SlimParser.T__2)
                self.state = 91
                localctx.content = self.expr(plate_content)
                self.state = 92
                self.match(SlimParser.T__3)

                localctx.typs = [localctx.content.typ]

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





