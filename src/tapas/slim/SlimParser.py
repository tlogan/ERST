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
        4,1,13,141,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,85,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,108,
        8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,3,2,127,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,
        139,8,3,1,3,0,0,4,0,2,4,6,0,0,154,0,84,1,0,0,0,2,107,1,0,0,0,4,126,
        1,0,0,0,6,138,1,0,0,0,8,85,1,0,0,0,9,10,5,11,0,0,10,85,6,0,-1,0,
        11,12,5,1,0,0,12,85,6,0,-1,0,13,14,5,2,0,0,14,15,5,11,0,0,15,16,
        3,0,0,0,16,17,6,0,-1,0,17,85,1,0,0,0,18,19,3,2,1,0,19,20,6,0,-1,
        0,20,85,1,0,0,0,21,22,5,3,0,0,22,23,6,0,-1,0,23,24,3,0,0,0,24,25,
        6,0,-1,0,25,26,5,4,0,0,26,27,6,0,-1,0,27,85,1,0,0,0,28,29,5,3,0,
        0,29,30,6,0,-1,0,30,31,3,0,0,0,31,32,6,0,-1,0,32,33,5,4,0,0,33,34,
        6,0,-1,0,34,35,3,6,3,0,35,36,6,0,-1,0,36,85,1,0,0,0,37,38,5,11,0,
        0,38,39,6,0,-1,0,39,40,3,6,3,0,40,41,6,0,-1,0,41,85,1,0,0,0,42,43,
        5,11,0,0,43,44,6,0,-1,0,44,45,5,5,0,0,45,46,6,0,-1,0,46,47,3,0,0,
        0,47,48,6,0,-1,0,48,85,1,0,0,0,49,50,5,3,0,0,50,51,6,0,-1,0,51,52,
        3,0,0,0,52,53,6,0,-1,0,53,54,5,4,0,0,54,55,6,0,-1,0,55,56,3,4,2,
        0,56,57,6,0,-1,0,57,85,1,0,0,0,58,59,5,11,0,0,59,60,6,0,-1,0,60,
        61,3,4,2,0,61,62,6,0,-1,0,62,85,1,0,0,0,63,64,5,6,0,0,64,65,5,11,
        0,0,65,66,6,0,-1,0,66,67,5,7,0,0,67,68,6,0,-1,0,68,69,3,0,0,0,69,
        70,6,0,-1,0,70,71,5,8,0,0,71,72,6,0,-1,0,72,73,3,0,0,0,73,74,6,0,
        -1,0,74,85,1,0,0,0,75,76,5,9,0,0,76,77,6,0,-1,0,77,78,5,3,0,0,78,
        79,6,0,-1,0,79,80,3,0,0,0,80,81,6,0,-1,0,81,82,5,4,0,0,82,83,6,0,
        -1,0,83,85,1,0,0,0,84,8,1,0,0,0,84,9,1,0,0,0,84,11,1,0,0,0,84,13,
        1,0,0,0,84,18,1,0,0,0,84,21,1,0,0,0,84,28,1,0,0,0,84,37,1,0,0,0,
        84,42,1,0,0,0,84,49,1,0,0,0,84,58,1,0,0,0,84,63,1,0,0,0,84,75,1,
        0,0,0,85,1,1,0,0,0,86,108,1,0,0,0,87,88,5,2,0,0,88,89,6,1,-1,0,89,
        90,5,11,0,0,90,91,6,1,-1,0,91,92,5,7,0,0,92,93,6,1,-1,0,93,94,3,
        0,0,0,94,95,6,1,-1,0,95,108,1,0,0,0,96,97,5,2,0,0,97,98,6,1,-1,0,
        98,99,5,11,0,0,99,100,6,1,-1,0,100,101,5,7,0,0,101,102,6,1,-1,0,
        102,103,3,0,0,0,103,104,6,1,-1,0,104,105,3,2,1,0,105,106,6,1,-1,
        0,106,108,1,0,0,0,107,86,1,0,0,0,107,87,1,0,0,0,107,96,1,0,0,0,108,
        3,1,0,0,0,109,127,1,0,0,0,110,111,5,3,0,0,111,112,6,2,-1,0,112,113,
        3,0,0,0,113,114,6,2,-1,0,114,115,5,4,0,0,115,116,6,2,-1,0,116,127,
        1,0,0,0,117,118,5,3,0,0,118,119,6,2,-1,0,119,120,3,0,0,0,120,121,
        6,2,-1,0,121,122,5,4,0,0,122,123,6,2,-1,0,123,124,3,4,2,0,124,125,
        6,2,-1,0,125,127,1,0,0,0,126,109,1,0,0,0,126,110,1,0,0,0,126,117,
        1,0,0,0,127,5,1,0,0,0,128,139,1,0,0,0,129,130,5,10,0,0,130,131,5,
        11,0,0,131,139,6,3,-1,0,132,133,5,10,0,0,133,134,5,11,0,0,134,135,
        6,3,-1,0,135,136,3,6,3,0,136,137,6,3,-1,0,137,139,1,0,0,0,138,128,
        1,0,0,0,138,129,1,0,0,0,138,132,1,0,0,0,139,7,1,0,0,0,4,84,107,126,
        138
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

    def guide_choice(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
        for arg in args:
            if arg == None:
                self._overflow = True

        result = None
        if not self._overflow:
            result = f(plate, *args)
            self._guidance = result

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return result



    def guide_lex(self, guidance : Union[Symbol, Terminal]):   
        if not self._overflow:
            self._guidance = guidance 

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 


    def guide_symbol(self, text : str):
        self.guide_lex(Symbol(text))

    def guide_terminal(self, text : str):
        self.guide_lex(Terminal(text))



    def mem(self, f : Callable, plate : Plate, *args):

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
            self.state = 84
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 9
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.mem(self._analyzer.combine_expr_id, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 11
                self.match(SlimParser.T__0)

                localctx.typ = self.mem(self._analyzer.combine_expr_unit, plate)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 13
                self.match(SlimParser.T__1)
                self.state = 14
                localctx._ID = self.match(SlimParser.ID)
                self.state = 15
                localctx.body = self.expr(plate)

                localctx.typ = self.mem(self._analyzer.combine_expr_tag, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

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


                self.state = 23
                localctx._expr = self.expr(plate)

                self.guide_symbol(')')

                self.state = 25
                self.match(SlimParser.T__3)

                localctx.typ = localctx._expr.typ

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 28
                self.match(SlimParser.T__2)

                plate_cator = self.guide_choice(self._analyzer.distill_expr_projmulti_cator, plate)

                self.state = 30
                localctx.cator = localctx._expr = self.expr(plate_expr)

                self.guide_symbol(')')

                self.state = 32
                self.match(SlimParser.T__3)

                plate_keychain = self.guide_choice(self._analyzer.distill_expr_projmulti_keychain, plate, localctx._expr.typ)

                self.state = 34
                localctx._keychain = self.keychain(plate_keychain)

                localctx.typ = self.mem(self._analyzer.combine_expr_projmulti, plate, localctx._expr.typ, localctx._keychain.ids) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 37
                localctx._ID = self.match(SlimParser.ID)

                plate_keychain = self.guide_choice(self._analyzer.distill_expr_idprojmulti_keychain, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 39
                localctx._keychain = self.keychain(plate_keychain)

                localctx.typ = self.mem(self._analyzer.combine_expr_idprojmulti, plate, (None if localctx._ID is None else localctx._ID.text), localctx._keychain.ids) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 42
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=>')

                self.state = 44
                self.match(SlimParser.T__4)

                plate_body = self.guide_choice(self._analyzer.distill_expr_function_body, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 46
                localctx.body = self.expr(plate_body)

                plate = plate_body
                localctx.typ = self.mem(self._analyzer.combine_expr_function, plate, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 49
                self.match(SlimParser.T__2)

                plate_cator = self.guide_choice(self._analyzer.distill_expr_appmulti_cator, plate)

                self.state = 51
                localctx.cator = self.expr(plate_cator)

                self.guide_symbol(')')

                self.state = 53
                self.match(SlimParser.T__3)

                plate_argchain = self.guide_choice(self._analyzer.distill_expr_appmulti_argchain, plate, localctx.cator.typ)

                self.state = 55
                localctx.content = localctx._argchain = self.argchain(plate_argchain)

                localctx.typ = self.mem(self._analyzer.combine_expr_appmulti, plate, localctx.cator.typ, localctx._argchain.typs)

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 58
                localctx._ID = self.match(SlimParser.ID)

                plate_argchain = self.guide_choice(self._analyzer.distill_expr_idappmulti_argchain, plate, (None if localctx._ID is None else localctx._ID.text))

                self.state = 60
                localctx._argchain = self.argchain(plate_argchain)

                localctx.typ = self.mem(self._analyzer.combine_expr_idappmulti, plate, (None if localctx._ID is None else localctx._ID.text), localctx._argchain.typs) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 63
                self.match(SlimParser.T__5)
                self.state = 64
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 66
                self.match(SlimParser.T__6)

                plate_target = plate #TODO

                self.state = 68
                localctx.target = self.expr(plate_target)

                self.guide_symbol(';')

                self.state = 70
                self.match(SlimParser.T__7)

                plate_body = self.guide_choice(self._analyzer.distill_expr_let_body, plate, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)

                self.state = 72
                localctx.body = self.expr(plate_body)

                localctx.typ = localctx.body.typ

                pass

            elif la_ == 13:
                self.enterOuterAlt(localctx, 13)
                self.state = 75
                self.match(SlimParser.T__8)

                self.guide_symbol('(')

                self.state = 77
                self.match(SlimParser.T__2)

                plate_body = self.guide_choice(self._analyzer.distill_expr_fix_body, plate)

                self.state = 79
                localctx.body = self.expr(plate_body)

                self.guide_symbol(')')

                self.state = 81
                self.match(SlimParser.T__3)

                localctx.typ = self.mem(self._analyzer.combine_expr_fix, plate, localctx.body.typ)

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
            self.state = 107
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 87
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 89
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 91
                self.match(SlimParser.T__6)

                plate_expr = plate # TODO

                self.state = 93
                localctx._expr = self.expr(plate_expr)

                localctx.typ = self.mem(self._analyzer.combine_record_single, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 96
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 98
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 100
                self.match(SlimParser.T__6)

                plate_expr = plate # TODO

                self.state = 102
                localctx._expr = self.expr(plate)

                plate_record = plate # TODO

                self.state = 104
                localctx._record = self.record(plate)

                localctx.typ = self.mem(self._analyzer.combine_record_cons, plate, (None if localctx._ID is None else localctx._ID.text), localctx._expr.typ, localctx._record.typ)

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
            self.state = 126
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 110
                self.match(SlimParser.T__2)

                plate_content = self.guide_choice(self._analyzer.distill_argchain_single_content, plate) 

                self.state = 112
                localctx.content = self.expr(plate_content)

                self.guide_symbol(')')

                self.state = 114
                self.match(SlimParser.T__3)

                localctx.typs = self.mem(self._analyzer.combine_argchain_single, plate, localctx.content.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 117
                self.match(SlimParser.T__2)

                plate_head = self.guide_choice(self._analyzer.distill_argchain_cons_head, plate) 

                self.state = 119
                localctx.head = self.expr(plate_head)

                self.guide_symbol(')')

                self.state = 121
                self.match(SlimParser.T__3)

                plate_tail = self.guide_choice(self._analyzer.distill_argchain_cons_tail, plate, localctx.head.typ) 

                self.state = 123
                localctx.tail = self.argchain(plate_tail)

                localctx.typs = self.mem(self._analyzer.combine_argchain_cons, plate, localctx.head.typ, localctx.tail.typs)

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
            self.state = 138
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 129
                self.match(SlimParser.T__9)
                self.state = 130
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.mem(self._analyzer.combine_keychain_single, plate, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 132
                self.match(SlimParser.T__9)
                self.state = 133
                localctx._ID = self.match(SlimParser.ID)

                plate_tail = self.guide_choice(self._analyzer.distill_keychain_cons_tail, plate, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 135
                localctx.tail = self.keychain(plate_tail)

                localctx.ids = self.mem(self._analyzer.combine_keychain_cons, plate, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





