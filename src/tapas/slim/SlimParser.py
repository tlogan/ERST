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
        4,1,13,127,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,3,0,80,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,3,1,96,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,3,2,113,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
        3,3,3,125,8,3,1,3,0,0,4,0,2,4,6,0,0,140,0,79,1,0,0,0,2,95,1,0,0,
        0,4,112,1,0,0,0,6,124,1,0,0,0,8,80,1,0,0,0,9,10,5,11,0,0,10,80,6,
        0,-1,0,11,12,5,1,0,0,12,80,6,0,-1,0,13,14,5,2,0,0,14,15,5,11,0,0,
        15,16,3,0,0,0,16,17,6,0,-1,0,17,80,1,0,0,0,18,19,3,2,1,0,19,20,6,
        0,-1,0,20,80,1,0,0,0,21,22,5,3,0,0,22,23,3,0,0,0,23,24,5,4,0,0,24,
        25,6,0,-1,0,25,80,1,0,0,0,26,27,6,0,-1,0,27,28,5,3,0,0,28,29,3,0,
        0,0,29,30,5,4,0,0,30,31,6,0,-1,0,31,32,3,6,3,0,32,33,6,0,-1,0,33,
        80,1,0,0,0,34,35,5,11,0,0,35,36,6,0,-1,0,36,37,3,6,3,0,37,38,6,0,
        -1,0,38,80,1,0,0,0,39,40,5,11,0,0,40,41,5,5,0,0,41,42,6,0,-1,0,42,
        43,3,0,0,0,43,44,6,0,-1,0,44,80,1,0,0,0,45,46,6,0,-1,0,46,47,5,3,
        0,0,47,48,6,0,-1,0,48,49,3,0,0,0,49,50,6,0,-1,0,50,51,5,4,0,0,51,
        52,6,0,-1,0,52,53,3,4,2,0,53,54,6,0,-1,0,54,80,1,0,0,0,55,56,5,11,
        0,0,56,57,6,0,-1,0,57,58,3,4,2,0,58,59,6,0,-1,0,59,80,1,0,0,0,60,
        61,5,6,0,0,61,62,5,11,0,0,62,63,5,7,0,0,63,64,6,0,-1,0,64,65,3,0,
        0,0,65,66,5,8,0,0,66,67,6,0,-1,0,67,68,3,0,0,0,68,69,6,0,-1,0,69,
        80,1,0,0,0,70,71,5,9,0,0,71,72,6,0,-1,0,72,73,5,3,0,0,73,74,6,0,
        -1,0,74,75,3,0,0,0,75,76,6,0,-1,0,76,77,5,4,0,0,77,78,6,0,-1,0,78,
        80,1,0,0,0,79,8,1,0,0,0,79,9,1,0,0,0,79,11,1,0,0,0,79,13,1,0,0,0,
        79,18,1,0,0,0,79,21,1,0,0,0,79,26,1,0,0,0,79,34,1,0,0,0,79,39,1,
        0,0,0,79,45,1,0,0,0,79,55,1,0,0,0,79,60,1,0,0,0,79,70,1,0,0,0,80,
        1,1,0,0,0,81,96,1,0,0,0,82,83,5,2,0,0,83,84,5,11,0,0,84,85,5,7,0,
        0,85,86,3,0,0,0,86,87,6,1,-1,0,87,96,1,0,0,0,88,89,5,2,0,0,89,90,
        5,11,0,0,90,91,5,7,0,0,91,92,3,0,0,0,92,93,3,2,1,0,93,94,6,1,-1,
        0,94,96,1,0,0,0,95,81,1,0,0,0,95,82,1,0,0,0,95,88,1,0,0,0,96,3,1,
        0,0,0,97,113,1,0,0,0,98,99,6,2,-1,0,99,100,5,3,0,0,100,101,3,0,0,
        0,101,102,5,4,0,0,102,103,6,2,-1,0,103,113,1,0,0,0,104,105,6,2,-1,
        0,105,106,5,3,0,0,106,107,3,0,0,0,107,108,5,4,0,0,108,109,6,2,-1,
        0,109,110,3,4,2,0,110,111,6,2,-1,0,111,113,1,0,0,0,112,97,1,0,0,
        0,112,98,1,0,0,0,112,104,1,0,0,0,113,5,1,0,0,0,114,125,1,0,0,0,115,
        116,5,10,0,0,116,117,5,11,0,0,117,125,6,3,-1,0,118,119,5,10,0,0,
        119,120,5,11,0,0,120,121,6,3,-1,0,121,122,3,6,3,0,122,123,6,3,-1,
        0,123,125,1,0,0,0,124,114,1,0,0,0,124,115,1,0,0,0,124,118,1,0,0,
        0,125,7,1,0,0,0,4,79,95,112,124
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'=>'", "'let'", 
                     "'='", "';'", "'fix'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "ID", "INT", 
                      "WS" ]

    RULE_expr = 0
    RULE_record = 1
    RULE_argchain = 2
    RULE_keychain = 3

    ruleNames =  [ "expr", "record", "argchain", "keychain" ]

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
            self.cator = None # ExprContext
            self._keychain = None # KeychainContext
            self.content = None # ArgchainContext
            self._argchain = None # ArgchainContext
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


        def keychain(self):
            return self.getTypedRuleContext(SlimParser.KeychainContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


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
            self.state = 79
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 9
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_id, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 11
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_unit, plate)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 13
                self.match(SlimParser.T__1)
                self.state = 14
                localctx._ID = self.match(SlimParser.ID)
                self.state = 15
                localctx.body = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_tag, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 18
                localctx._record = self.record(plate)

                localctx.typ = localctx._record.typ

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 21
                self.match(SlimParser.T__2)
                self.state = 22
                localctx._expr = self.expr(plate)
                self.state = 23
                self.match(SlimParser.T__3)

                localctx.typ = localctx._expr.typ

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                plate_cator = self.guard_down(self._analyzer.distill_expr_projmulti_cator, plate)

                self.state = 27
                self.match(SlimParser.T__2)
                self.state = 28
                localctx.cator = localctx._expr = self.expr(plate_expr)
                self.state = 29
                self.match(SlimParser.T__3)

                plate_keychain = self.guard_down(self._analyzer.distill_expr_projmulti_keychain, plate, localctx._expr.typ)

                self.state = 31
                localctx._keychain = self.keychain(plate_keychain)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_projmulti, plate, localctx._expr.typ, localctx._keychain.ids) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 34
                localctx._ID = self.match(SlimParser.ID)

                plate_keychain = self.guard_down(self._analyzer.distill_expr_idprojmulti_keychain, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 36
                localctx._keychain = self.keychain(plate_keychain)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_idprojmulti, plate, (None if localctx._ID is None else localctx._ID.text), localctx._keychain.ids) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 39
                localctx._ID = self.match(SlimParser.ID)
                self.state = 40
                self.match(SlimParser.T__4)

                plate_body = self.guard_down(self._analyzer.distill_expr_function_body, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 42
                localctx.body = self.expr(plate_body)

                plate = plate_body
                localctx.typ = self.guard_up(self._analyzer.combine_expr_function, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.shift(Symbol("("))
                self.state = 46
                self.match(SlimParser.T__2)

                plate_cator = self.guard_down(self._analyzer.distill_expr_appmulti_cator, plate)

                self.state = 48
                localctx.cator = self.expr(plate_cator)
                self.shift(Symbol(")"))
                self.state = 50
                self.match(SlimParser.T__3)

                plate_argchain = self.guard_down(self._analyzer.distill_expr_appmulti_argchain, plate, localctx.cator.typ)

                self.state = 52
                localctx.content = localctx._argchain = self.argchain(plate_argchain)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_appmulti, plate, localctx.cator.typ, localctx._argchain.typs)

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 55
                localctx._ID = self.match(SlimParser.ID)

                plate_argchain = self.guard_down(self._analyzer.distill_expr_callmulti_argchain, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 57
                localctx._argchain = self.argchain(plate_argchain)

                localctx.typ = self.guard_up(self._analyzer.combine_expr_callmulti, plate, (None if localctx._ID is None else localctx._ID.text), localctx._argchain.typs) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 60
                self.match(SlimParser.T__5)
                self.state = 61
                localctx._ID = self.match(SlimParser.ID)
                self.state = 62
                self.match(SlimParser.T__6)

                # TODO
                plate_target = plate 

                self.state = 64
                localctx.target = self.expr(plate_target)
                self.state = 65
                self.match(SlimParser.T__7)

                plate_body = self.guard_down(self._analyzer.distill_expr_let_body, plate, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)

                self.state = 67
                localctx.body = self.expr(plate_body)

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 13:
                self.enterOuterAlt(localctx, 13)
                self.state = 70
                self.match(SlimParser.T__8)
                 
                self.shift(Symbol("("))

                self.state = 72
                self.match(SlimParser.T__2)

                plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)

                self.state = 74
                localctx.body = self.expr(plate_body)

                self.shift(Symbol(')'))

                self.state = 76
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
            self.state = 95
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 82
                self.match(SlimParser.T__1)
                self.state = 83
                localctx._ID = self.match(SlimParser.ID)
                self.state = 84
                self.match(SlimParser.T__6)
                self.state = 85
                localctx._expr = self.expr(plate)

                localctx.typ = self.guard_up(self._analyzer.combine_record_single, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 88
                self.match(SlimParser.T__1)
                self.state = 89
                localctx._ID = self.match(SlimParser.ID)
                self.state = 90
                self.match(SlimParser.T__6)
                self.state = 91
                localctx._expr = self.expr(plate)
                self.state = 92
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


    class ArgchainContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.typs = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.plate = plate

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_argchain

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterArgchain" ):
                listener.enterArgchain(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitArgchain" ):
                listener.exitArgchain(self)




    def argchain(self, plate:Plate):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 4, self.RULE_argchain)
        try:
            self.state = 112
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)

                plate_content = self.guard_down(self._analyzer.distill_argchain_single_content, plate) 

                self.state = 99
                self.match(SlimParser.T__2)
                self.state = 100
                localctx.content = self.expr(plate_content)
                self.state = 101
                self.match(SlimParser.T__3)

                localctx.typs = self.guard_up(self._analyzer.combine_argchain_single, plate, localctx.content.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                plate_head = self.guard_down(self._analyzer.distill_argchain_cons_head, plate) 

                self.state = 105
                self.match(SlimParser.T__2)
                self.state = 106
                localctx.head = self.expr(plate_head)
                self.state = 107
                self.match(SlimParser.T__3)

                plate_tail = self.guard_down(self._analyzer.distill_argchain_cons_tail, plate, localctx.head.typ) 

                self.state = 109
                localctx.tail = self.argchain(plate_tail)

                localctx.typs = self.guard_up(self._analyzer.combine_argchain_cons, plate, localctx.head.typ, localctx.tail.typs)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class KeychainContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.ids = None
            self._ID = None # Token
            self.tail = None # KeychainContext
            self.plate = plate

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def keychain(self):
            return self.getTypedRuleContext(SlimParser.KeychainContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_keychain

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterKeychain" ):
                listener.enterKeychain(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitKeychain" ):
                listener.exitKeychain(self)




    def keychain(self, plate:Plate):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 6, self.RULE_keychain)
        try:
            self.state = 124
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 115
                self.match(SlimParser.T__9)
                self.state = 116
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.guard_up(self._analyzer.combine_keychain_single, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 118
                self.match(SlimParser.T__9)
                self.state = 119
                localctx._ID = self.match(SlimParser.ID)

                plate_tail = self.guard_down(self._analyzer.distill_keychain_cons_tail, plate, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 121
                localctx.tail = self.keychain(plate_tail)

                localctx.ids = self.guard_up(self._analyzer.combine_keychain_cons, plate, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





