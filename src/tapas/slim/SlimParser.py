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
        4,1,15,237,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,3,0,65,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,92,8,
        1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,3,2,115,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,138,8,
        3,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,3,4,157,8,4,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,
        5,3,5,171,8,5,1,6,1,6,1,6,1,6,1,6,1,6,3,6,179,8,6,1,7,1,7,1,7,1,
        7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,3,7,193,8,7,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,212,8,8,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,3,9,235,8,9,1,9,0,0,10,0,2,4,6,8,10,12,14,16,18,
        0,0,256,0,64,1,0,0,0,2,91,1,0,0,0,4,114,1,0,0,0,6,137,1,0,0,0,8,
        156,1,0,0,0,10,170,1,0,0,0,12,178,1,0,0,0,14,192,1,0,0,0,16,211,
        1,0,0,0,18,234,1,0,0,0,20,65,1,0,0,0,21,22,3,2,1,0,22,23,6,0,-1,
        0,23,65,1,0,0,0,24,25,6,0,-1,0,25,26,3,2,1,0,26,27,6,0,-1,0,27,28,
        5,1,0,0,28,29,6,0,-1,0,29,30,3,2,1,0,30,31,6,0,-1,0,31,65,1,0,0,
        0,32,33,6,0,-1,0,33,34,3,2,1,0,34,35,6,0,-1,0,35,36,3,10,5,0,36,
        37,6,0,-1,0,37,65,1,0,0,0,38,39,6,0,-1,0,39,40,3,2,1,0,40,41,6,0,
        -1,0,41,42,3,8,4,0,42,43,6,0,-1,0,43,65,1,0,0,0,44,45,5,2,0,0,45,
        46,6,0,-1,0,46,47,5,13,0,0,47,48,6,0,-1,0,48,49,3,12,6,0,49,50,6,
        0,-1,0,50,51,5,3,0,0,51,52,6,0,-1,0,52,53,3,0,0,0,53,54,6,0,-1,0,
        54,65,1,0,0,0,55,56,5,4,0,0,56,57,6,0,-1,0,57,58,5,5,0,0,58,59,6,
        0,-1,0,59,60,3,0,0,0,60,61,6,0,-1,0,61,62,5,6,0,0,62,63,6,0,-1,0,
        63,65,1,0,0,0,64,20,1,0,0,0,64,21,1,0,0,0,64,24,1,0,0,0,64,32,1,
        0,0,0,64,38,1,0,0,0,64,44,1,0,0,0,64,55,1,0,0,0,65,1,1,0,0,0,66,
        92,1,0,0,0,67,68,5,7,0,0,68,92,6,1,-1,0,69,70,5,8,0,0,70,71,6,1,
        -1,0,71,72,5,13,0,0,72,73,6,1,-1,0,73,74,3,0,0,0,74,75,6,1,-1,0,
        75,92,1,0,0,0,76,77,3,6,3,0,77,78,6,1,-1,0,78,92,1,0,0,0,79,80,3,
        4,2,0,80,81,6,1,-1,0,81,92,1,0,0,0,82,83,5,13,0,0,83,92,6,1,-1,0,
        84,85,5,5,0,0,85,86,6,1,-1,0,86,87,3,0,0,0,87,88,6,1,-1,0,88,89,
        5,6,0,0,89,90,6,1,-1,0,90,92,1,0,0,0,91,66,1,0,0,0,91,67,1,0,0,0,
        91,69,1,0,0,0,91,76,1,0,0,0,91,79,1,0,0,0,91,82,1,0,0,0,91,84,1,
        0,0,0,92,3,1,0,0,0,93,115,1,0,0,0,94,95,5,9,0,0,95,96,6,2,-1,0,96,
        97,3,14,7,0,97,98,6,2,-1,0,98,99,5,10,0,0,99,100,6,2,-1,0,100,101,
        3,0,0,0,101,102,6,2,-1,0,102,115,1,0,0,0,103,104,5,9,0,0,104,105,
        6,2,-1,0,105,106,3,14,7,0,106,107,6,2,-1,0,107,108,5,10,0,0,108,
        109,6,2,-1,0,109,110,3,0,0,0,110,111,6,2,-1,0,111,112,3,4,2,0,112,
        113,6,2,-1,0,113,115,1,0,0,0,114,93,1,0,0,0,114,94,1,0,0,0,114,103,
        1,0,0,0,115,5,1,0,0,0,116,138,1,0,0,0,117,118,5,8,0,0,118,119,6,
        3,-1,0,119,120,5,13,0,0,120,121,6,3,-1,0,121,122,5,11,0,0,122,123,
        6,3,-1,0,123,124,3,0,0,0,124,125,6,3,-1,0,125,138,1,0,0,0,126,127,
        5,8,0,0,127,128,6,3,-1,0,128,129,5,13,0,0,129,130,6,3,-1,0,130,131,
        5,11,0,0,131,132,6,3,-1,0,132,133,3,0,0,0,133,134,6,3,-1,0,134,135,
        3,6,3,0,135,136,6,3,-1,0,136,138,1,0,0,0,137,116,1,0,0,0,137,117,
        1,0,0,0,137,126,1,0,0,0,138,7,1,0,0,0,139,157,1,0,0,0,140,141,5,
        5,0,0,141,142,6,4,-1,0,142,143,3,0,0,0,143,144,6,4,-1,0,144,145,
        5,6,0,0,145,146,6,4,-1,0,146,157,1,0,0,0,147,148,5,5,0,0,148,149,
        6,4,-1,0,149,150,3,0,0,0,150,151,6,4,-1,0,151,152,5,6,0,0,152,153,
        6,4,-1,0,153,154,3,8,4,0,154,155,6,4,-1,0,155,157,1,0,0,0,156,139,
        1,0,0,0,156,140,1,0,0,0,156,147,1,0,0,0,157,9,1,0,0,0,158,171,1,
        0,0,0,159,160,5,12,0,0,160,161,6,5,-1,0,161,162,5,13,0,0,162,171,
        6,5,-1,0,163,164,5,12,0,0,164,165,6,5,-1,0,165,166,5,13,0,0,166,
        167,6,5,-1,0,167,168,3,10,5,0,168,169,6,5,-1,0,169,171,1,0,0,0,170,
        158,1,0,0,0,170,159,1,0,0,0,170,163,1,0,0,0,171,11,1,0,0,0,172,179,
        1,0,0,0,173,174,5,11,0,0,174,175,6,6,-1,0,175,176,3,0,0,0,176,177,
        6,6,-1,0,177,179,1,0,0,0,178,172,1,0,0,0,178,173,1,0,0,0,179,13,
        1,0,0,0,180,193,1,0,0,0,181,182,3,16,8,0,182,183,6,7,-1,0,183,193,
        1,0,0,0,184,185,6,7,-1,0,185,186,3,2,1,0,186,187,6,7,-1,0,187,188,
        5,1,0,0,188,189,6,7,-1,0,189,190,3,2,1,0,190,191,6,7,-1,0,191,193,
        1,0,0,0,192,180,1,0,0,0,192,181,1,0,0,0,192,184,1,0,0,0,193,15,1,
        0,0,0,194,212,1,0,0,0,195,196,5,13,0,0,196,212,6,8,-1,0,197,198,
        5,13,0,0,198,212,6,8,-1,0,199,200,5,7,0,0,200,212,6,8,-1,0,201,202,
        5,8,0,0,202,203,6,8,-1,0,203,204,5,13,0,0,204,205,6,8,-1,0,205,206,
        3,14,7,0,206,207,6,8,-1,0,207,212,1,0,0,0,208,209,3,18,9,0,209,210,
        6,8,-1,0,210,212,1,0,0,0,211,194,1,0,0,0,211,195,1,0,0,0,211,197,
        1,0,0,0,211,199,1,0,0,0,211,201,1,0,0,0,211,208,1,0,0,0,212,17,1,
        0,0,0,213,235,1,0,0,0,214,215,5,8,0,0,215,216,6,9,-1,0,216,217,5,
        13,0,0,217,218,6,9,-1,0,218,219,5,11,0,0,219,220,6,9,-1,0,220,221,
        3,14,7,0,221,222,6,9,-1,0,222,235,1,0,0,0,223,224,5,8,0,0,224,225,
        6,9,-1,0,225,226,5,13,0,0,226,227,6,9,-1,0,227,228,5,11,0,0,228,
        229,6,9,-1,0,229,230,3,14,7,0,230,231,6,9,-1,0,231,232,3,18,9,0,
        232,233,6,9,-1,0,233,235,1,0,0,0,234,213,1,0,0,0,234,214,1,0,0,0,
        234,223,1,0,0,0,235,19,1,0,0,0,10,64,91,114,137,156,170,178,192,
        211,234
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "','", "'let'", "';'", "'fix'", "'('", 
                     "')'", "'@'", "':'", "'case'", "'=>'", "'='", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_expr = 0
    RULE_base = 1
    RULE_function = 2
    RULE_record = 3
    RULE_argchain = 4
    RULE_keychain = 5
    RULE_target = 6
    RULE_pattern = 7
    RULE_pattern_base = 8
    RULE_pattern_record = 9

    ruleNames =  [ "expr", "base", "function", "record", "argchain", "keychain", 
                   "target", "pattern", "pattern_base", "pattern_record" ]

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




    _solver : Solver 
    _cache : dict[int, str] = {}

    _guidance : Guidance 
    _overflow = False  

    def init(self): 
        self._solver = Solver() 
        self._cache = {}
        self._guidance = distillation_default 
        self._overflow = False  

    def reset(self): 
        self._guidance = distillation_default
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def guide_nonterm(self, name : str, f : Callable, *args) -> Optional[Distillation]:
        for arg in args:
            if arg == None:
                self._overflow = True

        distillation_result = None
        if not self._overflow:
            distillation_result = f(*args)
            self._guidance = Nonterm(name, distillation_result)

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return distillation_result 



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



    def collect(self, f : Callable, *args):

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._base = None # BaseContext
            self.left = None # BaseContext
            self.right = None # BaseContext
            self.cator = None # BaseContext
            self._keychain = None # KeychainContext
            self.content = None # ArgchainContext
            self._argchain = None # ArgchainContext
            self._ID = None # Token
            self._target = None # TargetContext
            self.contin = None # ExprContext
            self.body = None # ExprContext
            self.distillation = distillation

        def base(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.BaseContext)
            else:
                return self.getTypedRuleContext(SlimParser.BaseContext,i)


        def keychain(self):
            return self.getTypedRuleContext(SlimParser.KeychainContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def target(self):
            return self.getTypedRuleContext(SlimParser.TargetContext,0)


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




    def expr(self, distillation:Distillation):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 64
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 21
                localctx._base = self.base(distillation)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_left)

                self.state = 25
                localctx.left = self.base(distillation)

                self.guide_symbol(',')

                self.state = 27
                self.match(SlimParser.T__0)

                distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_right, localctx.left.combo)

                self.state = 29
                localctx.right = self.base(distillation)

                localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, localctx.left.combo, localctx.right.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)

                distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_projection_cator)

                self.state = 33
                localctx.cator = self.base(distillation_cator)

                distillation_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, distillation).distill_projection_keychain, localctx.cator.combo)

                self.state = 35
                localctx._keychain = self.keychain(distillation_keychain)

                localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_projection, localctx.cator.combo, localctx._keychain.ids) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_application_cator)

                self.state = 39
                localctx.cator = self.base(distillation_cator)

                distillation_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, distillation).distill_application_argchain, localctx.cator.combo)

                self.state = 41
                localctx.content = localctx._argchain = self.argchain(distillation_argchain)

                localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_application, localctx.cator.combo, localctx._argchain.combos)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 44
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 46
                localctx._ID = self.match(SlimParser.ID)

                distillation_target = self.guide_nonterm('target', ExprAttr(self._solver, distillation).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 48
                localctx._target = self.target(distillation_target)

                self.guide_symbol(';')

                self.state = 50
                self.match(SlimParser.T__2)

                distillation_contin = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 52
                localctx.contin = self.expr(distillation_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 55
                self.match(SlimParser.T__3)

                self.guide_symbol('(')

                self.state = 57
                self.match(SlimParser.T__4)

                distillation_body = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_fix_body)

                self.state = 59
                localctx.body = self.expr(distillation_body)

                self.guide_symbol(')')

                self.state = 61
                self.match(SlimParser.T__5)

                localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_fix, localctx.body.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class BaseContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._expr = None # ExprContext
            self.distillation = distillation

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def record(self):
            return self.getTypedRuleContext(SlimParser.RecordContext,0)


        def function(self):
            return self.getTypedRuleContext(SlimParser.FunctionContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_base

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterBase" ):
                listener.enterBase(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitBase" ):
                listener.exitBase(self)




    def base(self, distillation:Distillation):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 2, self.RULE_base)
        try:
            self.state = 91
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 67
                self.match(SlimParser.T__6)

                localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 69
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 71
                localctx._ID = self.match(SlimParser.ID)

                distillation_body = self.guide_nonterm('expr', BaseAttr(self._solver, distillation).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 73
                localctx.body = self.expr(distillation_body)

                localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 76
                localctx._record = self.record(distillation)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 79
                localctx._function = self.function(distillation)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 82
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseAttr(self._solver, distillation).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 84
                self.match(SlimParser.T__4)

                distillation_expr = self.guide_nonterm('expr', lambda: distillation)

                self.state = 86
                localctx._expr = self.expr(distillation_expr)

                self.guide_symbol(')')

                self.state = 88
                self.match(SlimParser.T__5)

                localctx.combo = localctx._expr.combo

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self.tail = None # FunctionContext
            self.distillation = distillation

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




    def function(self, distillation:Distillation):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 4, self.RULE_function)
        try:
            self.state = 114
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 94
                self.match(SlimParser.T__8)

                distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_single_pattern)

                self.state = 96
                localctx._pattern = self.pattern(distillation_pattern)

                self.guide_symbol('=>')

                self.state = 98
                self.match(SlimParser.T__9)

                distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_single_body, localctx._pattern.combo)

                self.state = 100
                localctx.body = self.expr(distillation_body)

                localctx.combo = self.collect(FunctionAttr(self._solver, distillation).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 103
                self.match(SlimParser.T__8)

                distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_cons_pattern)

                self.state = 105
                localctx._pattern = self.pattern(distillation_pattern)

                self.guide_symbol('=>')

                self.state = 107
                self.match(SlimParser.T__9)

                distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_cons_body, localctx._pattern.combo)

                self.state = 109
                localctx.body = self.expr(distillation_body)

                distillation_tail = self.guide_nonterm('function', FunctionAttr(self._solver, distillation).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 111
                localctx.tail = self.function(distillation)

                localctx.combo = self.collect(FunctionAttr(self._solver, distillation).combine_cons, localctx._pattern.combo, localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.tail = None # RecordContext
            self.distillation = distillation

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




    def record(self, distillation:Distillation):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 6, self.RULE_record)
        try:
            self.state = 137
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 117
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 119
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 121
                self.match(SlimParser.T__10)

                distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 123
                localctx.body = self.expr(distillation_body)

                localctx.combo = self.collect(RecordAttr(self._solver, distillation).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 126
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 128
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 130
                self.match(SlimParser.T__10)

                distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 132
                localctx.body = self.expr(distillation)

                distillation_tail = self.guide_nonterm('record', RecordAttr(self._solver, distillation).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 134
                localctx.tail = self.record(distillation)

                localctx.combo = self.collect(RecordAttr(self._solver, distillation).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combos = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.distillation = distillation

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




    def argchain(self, distillation:Distillation):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 8, self.RULE_argchain)
        try:
            self.state = 156
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 140
                self.match(SlimParser.T__4)

                distillation_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_single_content) 

                self.state = 142
                localctx.content = self.expr(distillation_content)

                self.guide_symbol(')')

                self.state = 144
                self.match(SlimParser.T__5)

                localctx.combos = self.collect(ArgchainAttr(self._solver, distillation).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 147
                self.match(SlimParser.T__4)

                distillation_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_cons_head) 

                self.state = 149
                localctx.head = self.expr(distillation_head)

                self.guide_symbol(')')

                self.state = 151
                self.match(SlimParser.T__5)

                distillation_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, distillation).distill_cons_tail, localctx.head.combo) 

                self.state = 153
                localctx.tail = self.argchain(distillation_tail)

                localctx.combos = self.collect(ArgchainAttr(self._solver, distillation).combine_cons, localctx.head.combo, localctx.tail.combos)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.ids = None
            self._ID = None # Token
            self.tail = None # KeychainContext
            self.distillation = distillation

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




    def keychain(self, distillation:Distillation):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 10, self.RULE_keychain)
        try:
            self.state = 170
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 159
                self.match(SlimParser.T__11)

                self.guide_terminal('ID')

                self.state = 161
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.collect(KeychainAttr(self._solver, distillation).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 163
                self.match(SlimParser.T__11)

                self.guide_terminal('ID')

                self.state = 165
                localctx._ID = self.match(SlimParser.ID)

                distillation_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, distillation).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 167
                localctx.tail = self.keychain(distillation_tail)

                localctx.ids = self.collect(KeychainAttr(self._solver, distillation).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class TargetContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._expr = None # ExprContext
            self.distillation = distillation

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_target

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTarget" ):
                listener.enterTarget(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTarget" ):
                listener.exitTarget(self)




    def target(self, distillation:Distillation):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 12, self.RULE_target)
        try:
            self.state = 178
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [3]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [11]:
                self.enterOuterAlt(localctx, 2)
                self.state = 173
                self.match(SlimParser.T__10)

                distillation_expr = self.guide_nonterm('expr', lambda: distillation)

                self.state = 175
                localctx._expr = self.expr(distillation_expr)

                localctx.combo = localctx._expr.combo

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


    class PatternContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._pattern_base = None # Pattern_baseContext
            self.left = None # BaseContext
            self.right = None # BaseContext
            self.distillation = distillation

        def pattern_base(self):
            return self.getTypedRuleContext(SlimParser.Pattern_baseContext,0)


        def base(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.BaseContext)
            else:
                return self.getTypedRuleContext(SlimParser.BaseContext,i)


        def getRuleIndex(self):
            return SlimParser.RULE_pattern

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPattern" ):
                listener.enterPattern(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPattern" ):
                listener.exitPattern(self)




    def pattern(self, distillation:Distillation):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 14, self.RULE_pattern)
        try:
            self.state = 192
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 181
                localctx._pattern_base = self.pattern_base(distillation)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_left)

                self.state = 185
                localctx.left = self.base(distillation)

                self.guide_symbol(',')

                self.state = 187
                self.match(SlimParser.T__0)

                distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_right, localctx.left.combo)

                self.state = 189
                localctx.right = self.base(distillation)

                localctx.combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, localctx.left.combo, localctx.right.combo) 

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Pattern_baseContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self._pattern_record = None # Pattern_recordContext
            self.distillation = distillation

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def pattern_record(self):
            return self.getTypedRuleContext(SlimParser.Pattern_recordContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_pattern_base

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPattern_base" ):
                listener.enterPattern_base(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPattern_base" ):
                listener.exitPattern_base(self)




    def pattern_base(self, distillation:Distillation):

        localctx = SlimParser.Pattern_baseContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 16, self.RULE_pattern_base)
        try:
            self.state = 211
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 195
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 197
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 199
                self.match(SlimParser.T__6)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 201
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 203
                localctx._ID = self.match(SlimParser.ID)

                distillation_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, distillation).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 205
                localctx.body = self.pattern(distillation_body)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 208
                localctx._pattern_record = self.pattern_record(distillation)

                localctx.combo = localctx._pattern_record.combo

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Pattern_recordContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, distillation:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.distillation = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # Pattern_recordContext
            self.distillation = distillation

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def pattern_record(self):
            return self.getTypedRuleContext(SlimParser.Pattern_recordContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_pattern_record

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPattern_record" ):
                listener.enterPattern_record(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPattern_record" ):
                listener.exitPattern_record(self)




    def pattern_record(self, distillation:Distillation):

        localctx = SlimParser.Pattern_recordContext(self, self._ctx, self.state, distillation)
        self.enterRule(localctx, 18, self.RULE_pattern_record)
        try:
            self.state = 234
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 214
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 216
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 218
                self.match(SlimParser.T__10)

                distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 220
                localctx.body = self.pattern(distillation_body)

                localctx.combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 223
                self.match(SlimParser.T__7)

                self.guide_terminal('ID')

                self.state = 225
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 227
                self.match(SlimParser.T__10)

                distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 229
                localctx.body = self.pattern(distillation_body)

                distillation_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, distillation).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 231
                localctx.tail = self.pattern_record(distillation_tail)

                localctx.combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





