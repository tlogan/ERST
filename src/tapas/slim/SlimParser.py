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
        4,1,14,207,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,88,8,0,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,105,8,1,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,3,2,128,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,
        1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,151,8,3,1,4,1,4,
        1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,
        1,4,1,4,1,4,3,4,174,8,4,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,
        1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,193,8,5,1,6,1,6,1,6,1,6,1,6,1,6,
        1,6,1,6,1,6,1,6,3,6,205,8,6,1,6,0,0,7,0,2,4,6,8,10,12,0,0,225,0,
        87,1,0,0,0,2,104,1,0,0,0,4,127,1,0,0,0,6,150,1,0,0,0,8,173,1,0,0,
        0,10,192,1,0,0,0,12,204,1,0,0,0,14,88,1,0,0,0,15,16,5,12,0,0,16,
        88,6,0,-1,0,17,18,5,1,0,0,18,88,6,0,-1,0,19,20,5,2,0,0,20,21,5,12,
        0,0,21,22,3,0,0,0,22,23,6,0,-1,0,23,88,1,0,0,0,24,25,3,8,4,0,25,
        26,6,0,-1,0,26,88,1,0,0,0,27,28,5,3,0,0,28,29,6,0,-1,0,29,30,3,0,
        0,0,30,31,6,0,-1,0,31,32,5,4,0,0,32,33,6,0,-1,0,33,88,1,0,0,0,34,
        35,5,3,0,0,35,36,6,0,-1,0,36,37,3,0,0,0,37,38,6,0,-1,0,38,39,5,4,
        0,0,39,40,6,0,-1,0,40,41,3,12,6,0,41,42,6,0,-1,0,42,88,1,0,0,0,43,
        44,5,12,0,0,44,45,6,0,-1,0,45,46,3,12,6,0,46,47,6,0,-1,0,47,88,1,
        0,0,0,48,49,3,4,2,0,49,50,6,0,-1,0,50,88,1,0,0,0,51,52,5,3,0,0,52,
        53,6,0,-1,0,53,54,3,0,0,0,54,55,6,0,-1,0,55,56,5,4,0,0,56,57,6,0,
        -1,0,57,58,3,10,5,0,58,59,6,0,-1,0,59,88,1,0,0,0,60,61,5,12,0,0,
        61,62,6,0,-1,0,62,63,3,10,5,0,63,64,6,0,-1,0,64,88,1,0,0,0,65,66,
        5,5,0,0,66,67,6,0,-1,0,67,68,5,12,0,0,68,69,6,0,-1,0,69,70,5,6,0,
        0,70,71,6,0,-1,0,71,72,3,0,0,0,72,73,6,0,-1,0,73,74,5,7,0,0,74,75,
        6,0,-1,0,75,76,3,0,0,0,76,77,6,0,-1,0,77,88,1,0,0,0,78,79,5,8,0,
        0,79,80,6,0,-1,0,80,81,5,3,0,0,81,82,6,0,-1,0,82,83,3,0,0,0,83,84,
        6,0,-1,0,84,85,5,4,0,0,85,86,6,0,-1,0,86,88,1,0,0,0,87,14,1,0,0,
        0,87,15,1,0,0,0,87,17,1,0,0,0,87,19,1,0,0,0,87,24,1,0,0,0,87,27,
        1,0,0,0,87,34,1,0,0,0,87,43,1,0,0,0,87,48,1,0,0,0,87,51,1,0,0,0,
        87,60,1,0,0,0,87,65,1,0,0,0,87,78,1,0,0,0,88,1,1,0,0,0,89,105,1,
        0,0,0,90,91,5,12,0,0,91,105,6,1,-1,0,92,93,5,1,0,0,93,105,6,1,-1,
        0,94,95,5,2,0,0,95,96,6,1,-1,0,96,97,5,12,0,0,97,98,6,1,-1,0,98,
        99,3,2,1,0,99,100,6,1,-1,0,100,105,1,0,0,0,101,102,3,6,3,0,102,103,
        6,1,-1,0,103,105,1,0,0,0,104,89,1,0,0,0,104,90,1,0,0,0,104,92,1,
        0,0,0,104,94,1,0,0,0,104,101,1,0,0,0,105,3,1,0,0,0,106,128,1,0,0,
        0,107,108,5,9,0,0,108,109,6,2,-1,0,109,110,3,2,1,0,110,111,6,2,-1,
        0,111,112,5,10,0,0,112,113,6,2,-1,0,113,114,3,0,0,0,114,115,6,2,
        -1,0,115,128,1,0,0,0,116,117,5,9,0,0,117,118,6,2,-1,0,118,119,3,
        2,1,0,119,120,6,2,-1,0,120,121,5,10,0,0,121,122,6,2,-1,0,122,123,
        3,0,0,0,123,124,6,2,-1,0,124,125,3,4,2,0,125,126,6,2,-1,0,126,128,
        1,0,0,0,127,106,1,0,0,0,127,107,1,0,0,0,127,116,1,0,0,0,128,5,1,
        0,0,0,129,151,1,0,0,0,130,131,5,2,0,0,131,132,6,3,-1,0,132,133,5,
        12,0,0,133,134,6,3,-1,0,134,135,5,6,0,0,135,136,6,3,-1,0,136,137,
        3,2,1,0,137,138,6,3,-1,0,138,151,1,0,0,0,139,140,5,2,0,0,140,141,
        6,3,-1,0,141,142,5,12,0,0,142,143,6,3,-1,0,143,144,5,6,0,0,144,145,
        6,3,-1,0,145,146,3,2,1,0,146,147,6,3,-1,0,147,148,3,6,3,0,148,149,
        6,3,-1,0,149,151,1,0,0,0,150,129,1,0,0,0,150,130,1,0,0,0,150,139,
        1,0,0,0,151,7,1,0,0,0,152,174,1,0,0,0,153,154,5,2,0,0,154,155,6,
        4,-1,0,155,156,5,12,0,0,156,157,6,4,-1,0,157,158,5,6,0,0,158,159,
        6,4,-1,0,159,160,3,0,0,0,160,161,6,4,-1,0,161,174,1,0,0,0,162,163,
        5,2,0,0,163,164,6,4,-1,0,164,165,5,12,0,0,165,166,6,4,-1,0,166,167,
        5,6,0,0,167,168,6,4,-1,0,168,169,3,0,0,0,169,170,6,4,-1,0,170,171,
        3,8,4,0,171,172,6,4,-1,0,172,174,1,0,0,0,173,152,1,0,0,0,173,153,
        1,0,0,0,173,162,1,0,0,0,174,9,1,0,0,0,175,193,1,0,0,0,176,177,5,
        3,0,0,177,178,6,5,-1,0,178,179,3,0,0,0,179,180,6,5,-1,0,180,181,
        5,4,0,0,181,182,6,5,-1,0,182,193,1,0,0,0,183,184,5,3,0,0,184,185,
        6,5,-1,0,185,186,3,0,0,0,186,187,6,5,-1,0,187,188,5,4,0,0,188,189,
        6,5,-1,0,189,190,3,10,5,0,190,191,6,5,-1,0,191,193,1,0,0,0,192,175,
        1,0,0,0,192,176,1,0,0,0,192,183,1,0,0,0,193,11,1,0,0,0,194,205,1,
        0,0,0,195,196,5,11,0,0,196,197,5,12,0,0,197,205,6,6,-1,0,198,199,
        5,11,0,0,199,200,5,12,0,0,200,201,6,6,-1,0,201,202,3,12,6,0,202,
        203,6,6,-1,0,203,205,1,0,0,0,204,194,1,0,0,0,204,195,1,0,0,0,204,
        198,1,0,0,0,205,13,1,0,0,0,7,87,104,127,150,173,192,204
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'let'", "'='", 
                     "';'", "'fix'", "'case'", "'=>'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "ID", "INT", "WS" ]

    RULE_expr = 0
    RULE_pattern = 1
    RULE_function = 2
    RULE_recpat = 3
    RULE_record = 4
    RULE_argchain = 5
    RULE_keychain = 6

    ruleNames =  [ "expr", "pattern", "function", "recpat", "record", "argchain", 
                   "keychain" ]

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
    ID=12
    INT=13
    WS=14

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    _solver : Solver 
    _cache : dict[int, str] = {}

    _guidance : Guidance 
    _overflow = False  

    def init(self): 
        self._solver = Solver() 
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



    def mem(self, f : Callable, *args):

        if self._overflow:
            return None
        else:

            clean = next((
                False
                for arg in args
                if arg == None
            ), True)

            if clean:
                return f(*args)
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
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self._expr = None # ExprContext
            self.cator = None # ExprContext
            self._keychain = None # KeychainContext
            self._function = None # FunctionContext
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


        def function(self):
            return self.getTypedRuleContext(SlimParser.FunctionContext,0)


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
            self.state = 87
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 15
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_id, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 17
                self.match(SlimParser.T__0)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 19
                self.match(SlimParser.T__1)
                self.state = 20
                localctx._ID = self.match(SlimParser.ID)
                self.state = 21
                localctx.body = self.expr(plate)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 24
                localctx._record = self.record(plate)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 27
                self.match(SlimParser.T__2)


                self.state = 29
                localctx._expr = self.expr(plate)

                self.guide_symbol(')')

                self.state = 31
                self.match(SlimParser.T__3)

                localctx.combo = localctx._expr.combo

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 34
                self.match(SlimParser.T__2)

                plate_cator = self.guide_choice(ExprAttr(self._solver, plate).distill_projmulti_cator)

                self.state = 36
                localctx.cator = localctx._expr = self.expr(plate_expr)

                self.guide_symbol(')')

                self.state = 38
                self.match(SlimParser.T__3)

                plate_keychain = self.guide_choice(ExprAttr(self._solver, plate).distill_projmulti_keychain, localctx._expr.combo)

                self.state = 40
                localctx._keychain = self.keychain(plate_keychain)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_projmulti, localctx._expr.combo, localctx._keychain.ids) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 43
                localctx._ID = self.match(SlimParser.ID)

                plate_keychain = self.guide_choice(ExprAttr(self._solver, plate).distill_idprojmulti_keychain, (None if localctx._ID is None else localctx._ID.text))

                self.state = 45
                localctx._keychain = self.keychain(plate_keychain)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_idprojmulti, (None if localctx._ID is None else localctx._ID.text), localctx._keychain.ids) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 48
                localctx._function = self.function(plate)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 51
                self.match(SlimParser.T__2)

                plate_cator = self.guide_choice(ExprAttr(self._solver, plate).distill_appmulti_cator)

                self.state = 53
                localctx.cator = self.expr(plate_cator)

                self.guide_symbol(')')

                self.state = 55
                self.match(SlimParser.T__3)

                plate_argchain = self.guide_choice(ExprAttr(self._solver, plate).distill_appmulti_argchain, localctx.cator.combo)

                self.state = 57
                localctx.content = localctx._argchain = self.argchain(plate_argchain)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_appmulti, localctx.cator.combo, localctx._argchain.combos)

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 60
                localctx._ID = self.match(SlimParser.ID)

                plate_argchain = self.guide_choice(ExprAttr(self._solver, plate).distill_idappmulti_argchain, (None if localctx._ID is None else localctx._ID.text))

                self.state = 62
                localctx._argchain = self.argchain(plate_argchain)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_idappmulti, (None if localctx._ID is None else localctx._ID.text), localctx._argchain.combos) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 65
                self.match(SlimParser.T__4)

                self.guide_terminal('ID')

                self.state = 67
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 69
                self.match(SlimParser.T__5)

                plate_target = plate #TODO

                self.state = 71
                localctx.target = self.expr(plate_target)

                self.guide_symbol(';')

                self.state = 73
                self.match(SlimParser.T__6)

                plate_body = self.guide_choice(ExprAttr(self._solver, plate).distill_let_body, (None if localctx._ID is None else localctx._ID.text), localctx.target.combo)

                self.state = 75
                localctx.body = self.expr(plate_body)

                localctx.combo = localctx.body.combo

                pass

            elif la_ == 13:
                self.enterOuterAlt(localctx, 13)
                self.state = 78
                self.match(SlimParser.T__7)

                self.guide_symbol('(')

                self.state = 80
                self.match(SlimParser.T__2)

                plate_body = self.guide_choice(ExprAttr(self._solver, plate).distill_fix_body)

                self.state = 82
                localctx.body = self.expr(plate_body)

                self.guide_symbol(')')

                self.state = 84
                self.match(SlimParser.T__3)

                localctx.combo = self.mem(ExprAttr(self._solver, plate).combine_fix, localctx.body.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PatternContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self._recpat = None # RecpatContext
            self.plate = plate

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def recpat(self):
            return self.getTypedRuleContext(SlimParser.RecpatContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_pattern

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPattern" ):
                listener.enterPattern(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPattern" ):
                listener.exitPattern(self)




    def pattern(self, plate:Plate):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 2, self.RULE_pattern)
        try:
            self.state = 104
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 90
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.mem(PatternAttr(self._solver, plate).combine_id, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 92
                self.match(SlimParser.T__0)

                localctx.combo = self.mem(PatternAttr(self._solver, plate).combine_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 94
                self.match(SlimParser.T__1)


                self.state = 96
                self.match(SlimParser.ID)

                plate_body = plate # TODO

                self.state = 98
                localctx.body = self.pattern(plate_body)

                localctx.combo = self.mem(PatternAttr(self._solver, plate).combine_tag, localctx.body.combo)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 101
                localctx._recpat = self.recpat(plate)

                localctx.combo = localctx._recpat.combo

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class FunctionContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.combo = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self._function = None # FunctionContext
            self.plate = plate

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def function(self):
            return self.getTypedRuleContext(SlimParser.FunctionContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_function

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterFunction" ):
                listener.enterFunction(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitFunction" ):
                listener.exitFunction(self)




    def function(self, plate:Plate):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 4, self.RULE_function)
        try:
            self.state = 127
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 107
                self.match(SlimParser.T__8)

                # TODO
                plate_pattern = self.guide_choice(FunctionAttr(self._solver, plate).distill_single_pattern)

                self.state = 109
                localctx._pattern = self.pattern(plate_pattern)

                self.guide_symbol('=>')

                self.state = 111
                self.match(SlimParser.T__9)

                # TODO
                plate_body = self.guide_choice(FunctionAttr(self._solver, plate).distill_single_body, localctx._pattern.combo)

                self.state = 113
                localctx.body = self.expr(plate_body)

                localctx.combo = self.mem(FunctionAttr(self._solver, plate).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 116
                self.match(SlimParser.T__8)

                # TODO
                plate_pattern = self.guide_choice(FunctionAttr(self._solver, plate).distill_cons_pattern, plate)

                self.state = 118
                localctx._pattern = self.pattern(plate_pattern)

                self.guide_symbol('=>')

                self.state = 120
                self.match(SlimParser.T__9)

                # TODO
                plate_body = self.guide_choice(FunctionAttr(self._solver, plate).distill_cons_body, localctx._pattern.combo)

                self.state = 122
                localctx.body = self.expr(plate_body)

                plate_function = plate # TODO

                self.state = 124
                localctx._function = self.function(plate)

                localctx.combo = self.mem(FunctionAttr(self._solver, plate).combine_cons, localctx._pattern.combo, localctx.body.combo, localctx._function.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class RecpatContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # RecpatContext
            self.plate = plate

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def recpat(self):
            return self.getTypedRuleContext(SlimParser.RecpatContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_recpat

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterRecpat" ):
                listener.enterRecpat(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitRecpat" ):
                listener.exitRecpat(self)




    def recpat(self, plate:Plate):

        localctx = SlimParser.RecpatContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 6, self.RULE_recpat)
        try:
            self.state = 150
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 130
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 132
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 134
                self.match(SlimParser.T__5)

                plate_body = plate # TODO

                self.state = 136
                localctx.body = self.pattern(plate_body)

                localctx.combo = self.mem(RecpatAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 139
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 141
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 143
                self.match(SlimParser.T__5)

                plate_body = plate # TODO

                self.state = 145
                localctx.body = self.pattern(plate_body)

                plate_tail = plate # TODO

                self.state = 147
                localctx.tail = self.recpat(plate_tail)

                localctx.combo = self.mem(RecpatAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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
            self.combo = None
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
        self.enterRule(localctx, 8, self.RULE_record)
        try:
            self.state = 173
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 153
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 155
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 157
                self.match(SlimParser.T__5)

                plate_expr = plate # TODO

                self.state = 159
                localctx._expr = self.expr(plate_expr)

                localctx.combo = self.mem(RecordAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx._expr.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 162
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 164
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 166
                self.match(SlimParser.T__5)

                plate_expr = plate # TODO

                self.state = 168
                localctx._expr = self.expr(plate)

                plate_record = plate # TODO

                self.state = 170
                localctx._record = self.record(plate)

                localctx.combo = self.mem(RecordAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx._expr.combo, localctx._record.combo)

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
            self.combos = None
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
        self.enterRule(localctx, 10, self.RULE_argchain)
        try:
            self.state = 192
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 176
                self.match(SlimParser.T__2)

                plate_content = self.guide_choice(ArgchainAttr(self._solver, plate).distill_single_content) 

                self.state = 178
                localctx.content = self.expr(plate_content)

                self.guide_symbol(')')

                self.state = 180
                self.match(SlimParser.T__3)

                localctx.combos = self.mem(ArgchainAttr(self._solver, plate).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 183
                self.match(SlimParser.T__2)

                plate_head = self.guide_choice(ArgchainAttr(self._solver, plate).distill_cons_head) 

                self.state = 185
                localctx.head = self.expr(plate_head)

                self.guide_symbol(')')

                self.state = 187
                self.match(SlimParser.T__3)

                plate_tail = self.guide_choice(ArgchainAttr(self._solver, plate).distill_cons_tail, localctx.head.combo) 

                self.state = 189
                localctx.tail = self.argchain(plate_tail)

                localctx.combos = self.mem(ArgchainAttr(self._solver, plate).combine_cons, localctx.head.combo, localctx.tail.combos)

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
        self.enterRule(localctx, 12, self.RULE_keychain)
        try:
            self.state = 204
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 195
                self.match(SlimParser.T__10)
                self.state = 196
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.mem(KeychainAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 198
                self.match(SlimParser.T__10)
                self.state = 199
                localctx._ID = self.match(SlimParser.ID)

                plate_tail = self.guide_choice(KeychainAttr(self._solver, plate).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 201
                localctx.tail = self.keychain(plate_tail)

                localctx.ids = self.mem(KeychainAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





