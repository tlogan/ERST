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
        4,1,19,273,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,86,8,0,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,3,1,113,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,136,8,2,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
        3,1,3,1,3,1,3,3,3,159,8,3,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,178,8,4,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,193,8,5,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,207,8,6,1,7,1,7,1,7,1,7,1,7,1,7,3,
        7,215,8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,229,
        8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,
        1,9,1,9,3,9,248,8,9,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,
        271,8,10,1,10,0,0,11,0,2,4,6,8,10,12,14,16,18,20,0,0,295,0,85,1,
        0,0,0,2,112,1,0,0,0,4,135,1,0,0,0,6,158,1,0,0,0,8,177,1,0,0,0,10,
        192,1,0,0,0,12,206,1,0,0,0,14,214,1,0,0,0,16,228,1,0,0,0,18,247,
        1,0,0,0,20,270,1,0,0,0,22,86,1,0,0,0,23,24,3,2,1,0,24,25,6,0,-1,
        0,25,86,1,0,0,0,26,27,6,0,-1,0,27,28,3,2,1,0,28,29,6,0,-1,0,29,30,
        5,1,0,0,30,31,6,0,-1,0,31,32,3,2,1,0,32,33,6,0,-1,0,33,86,1,0,0,
        0,34,35,5,2,0,0,35,36,6,0,-1,0,36,37,3,0,0,0,37,38,6,0,-1,0,38,39,
        5,3,0,0,39,40,6,0,-1,0,40,41,3,0,0,0,41,42,6,0,-1,0,42,43,5,4,0,
        0,43,44,6,0,-1,0,44,45,3,0,0,0,45,46,6,0,-1,0,46,86,1,0,0,0,47,48,
        6,0,-1,0,48,49,3,2,1,0,49,50,6,0,-1,0,50,51,3,12,6,0,51,52,6,0,-1,
        0,52,86,1,0,0,0,53,54,6,0,-1,0,54,55,3,2,1,0,55,56,6,0,-1,0,56,57,
        3,8,4,0,57,58,6,0,-1,0,58,86,1,0,0,0,59,60,6,0,-1,0,60,61,3,2,1,
        0,61,62,6,0,-1,0,62,63,3,10,5,0,63,64,6,0,-1,0,64,86,1,0,0,0,65,
        66,5,5,0,0,66,67,6,0,-1,0,67,68,5,17,0,0,68,69,6,0,-1,0,69,70,3,
        14,7,0,70,71,6,0,-1,0,71,72,5,6,0,0,72,73,6,0,-1,0,73,74,3,0,0,0,
        74,75,6,0,-1,0,75,86,1,0,0,0,76,77,5,7,0,0,77,78,6,0,-1,0,78,79,
        5,8,0,0,79,80,6,0,-1,0,80,81,3,0,0,0,81,82,6,0,-1,0,82,83,5,9,0,
        0,83,84,6,0,-1,0,84,86,1,0,0,0,85,22,1,0,0,0,85,23,1,0,0,0,85,26,
        1,0,0,0,85,34,1,0,0,0,85,47,1,0,0,0,85,53,1,0,0,0,85,59,1,0,0,0,
        85,65,1,0,0,0,85,76,1,0,0,0,86,1,1,0,0,0,87,113,1,0,0,0,88,89,5,
        10,0,0,89,113,6,1,-1,0,90,91,5,11,0,0,91,92,6,1,-1,0,92,93,5,17,
        0,0,93,94,6,1,-1,0,94,95,3,0,0,0,95,96,6,1,-1,0,96,113,1,0,0,0,97,
        98,3,6,3,0,98,99,6,1,-1,0,99,113,1,0,0,0,100,101,3,4,2,0,101,102,
        6,1,-1,0,102,113,1,0,0,0,103,104,5,17,0,0,104,113,6,1,-1,0,105,106,
        5,8,0,0,106,107,6,1,-1,0,107,108,3,0,0,0,108,109,6,1,-1,0,109,110,
        5,9,0,0,110,111,6,1,-1,0,111,113,1,0,0,0,112,87,1,0,0,0,112,88,1,
        0,0,0,112,90,1,0,0,0,112,97,1,0,0,0,112,100,1,0,0,0,112,103,1,0,
        0,0,112,105,1,0,0,0,113,3,1,0,0,0,114,136,1,0,0,0,115,116,5,12,0,
        0,116,117,6,2,-1,0,117,118,3,16,8,0,118,119,6,2,-1,0,119,120,5,13,
        0,0,120,121,6,2,-1,0,121,122,3,0,0,0,122,123,6,2,-1,0,123,136,1,
        0,0,0,124,125,5,12,0,0,125,126,6,2,-1,0,126,127,3,16,8,0,127,128,
        6,2,-1,0,128,129,5,13,0,0,129,130,6,2,-1,0,130,131,3,0,0,0,131,132,
        6,2,-1,0,132,133,3,4,2,0,133,134,6,2,-1,0,134,136,1,0,0,0,135,114,
        1,0,0,0,135,115,1,0,0,0,135,124,1,0,0,0,136,5,1,0,0,0,137,159,1,
        0,0,0,138,139,5,11,0,0,139,140,6,3,-1,0,140,141,5,17,0,0,141,142,
        6,3,-1,0,142,143,5,14,0,0,143,144,6,3,-1,0,144,145,3,0,0,0,145,146,
        6,3,-1,0,146,159,1,0,0,0,147,148,5,11,0,0,148,149,6,3,-1,0,149,150,
        5,17,0,0,150,151,6,3,-1,0,151,152,5,14,0,0,152,153,6,3,-1,0,153,
        154,3,0,0,0,154,155,6,3,-1,0,155,156,3,6,3,0,156,157,6,3,-1,0,157,
        159,1,0,0,0,158,137,1,0,0,0,158,138,1,0,0,0,158,147,1,0,0,0,159,
        7,1,0,0,0,160,178,1,0,0,0,161,162,5,8,0,0,162,163,6,4,-1,0,163,164,
        3,0,0,0,164,165,6,4,-1,0,165,166,5,9,0,0,166,167,6,4,-1,0,167,178,
        1,0,0,0,168,169,5,8,0,0,169,170,6,4,-1,0,170,171,3,0,0,0,171,172,
        6,4,-1,0,172,173,5,9,0,0,173,174,6,4,-1,0,174,175,3,8,4,0,175,176,
        6,4,-1,0,176,178,1,0,0,0,177,160,1,0,0,0,177,161,1,0,0,0,177,168,
        1,0,0,0,178,9,1,0,0,0,179,193,1,0,0,0,180,181,5,15,0,0,181,182,6,
        5,-1,0,182,183,3,0,0,0,183,184,6,5,-1,0,184,193,1,0,0,0,185,186,
        5,15,0,0,186,187,6,5,-1,0,187,188,3,0,0,0,188,189,6,5,-1,0,189,190,
        3,10,5,0,190,191,6,5,-1,0,191,193,1,0,0,0,192,179,1,0,0,0,192,180,
        1,0,0,0,192,185,1,0,0,0,193,11,1,0,0,0,194,207,1,0,0,0,195,196,5,
        16,0,0,196,197,6,6,-1,0,197,198,5,17,0,0,198,207,6,6,-1,0,199,200,
        5,16,0,0,200,201,6,6,-1,0,201,202,5,17,0,0,202,203,6,6,-1,0,203,
        204,3,12,6,0,204,205,6,6,-1,0,205,207,1,0,0,0,206,194,1,0,0,0,206,
        195,1,0,0,0,206,199,1,0,0,0,207,13,1,0,0,0,208,215,1,0,0,0,209,210,
        5,14,0,0,210,211,6,7,-1,0,211,212,3,0,0,0,212,213,6,7,-1,0,213,215,
        1,0,0,0,214,208,1,0,0,0,214,209,1,0,0,0,215,15,1,0,0,0,216,229,1,
        0,0,0,217,218,3,18,9,0,218,219,6,8,-1,0,219,229,1,0,0,0,220,221,
        6,8,-1,0,221,222,3,2,1,0,222,223,6,8,-1,0,223,224,5,1,0,0,224,225,
        6,8,-1,0,225,226,3,2,1,0,226,227,6,8,-1,0,227,229,1,0,0,0,228,216,
        1,0,0,0,228,217,1,0,0,0,228,220,1,0,0,0,229,17,1,0,0,0,230,248,1,
        0,0,0,231,232,5,17,0,0,232,248,6,9,-1,0,233,234,5,17,0,0,234,248,
        6,9,-1,0,235,236,5,10,0,0,236,248,6,9,-1,0,237,238,5,11,0,0,238,
        239,6,9,-1,0,239,240,5,17,0,0,240,241,6,9,-1,0,241,242,3,16,8,0,
        242,243,6,9,-1,0,243,248,1,0,0,0,244,245,3,20,10,0,245,246,6,9,-1,
        0,246,248,1,0,0,0,247,230,1,0,0,0,247,231,1,0,0,0,247,233,1,0,0,
        0,247,235,1,0,0,0,247,237,1,0,0,0,247,244,1,0,0,0,248,19,1,0,0,0,
        249,271,1,0,0,0,250,251,5,11,0,0,251,252,6,10,-1,0,252,253,5,17,
        0,0,253,254,6,10,-1,0,254,255,5,14,0,0,255,256,6,10,-1,0,256,257,
        3,16,8,0,257,258,6,10,-1,0,258,271,1,0,0,0,259,260,5,11,0,0,260,
        261,6,10,-1,0,261,262,5,17,0,0,262,263,6,10,-1,0,263,264,5,14,0,
        0,264,265,6,10,-1,0,265,266,3,16,8,0,266,267,6,10,-1,0,267,268,3,
        20,10,0,268,269,6,10,-1,0,269,271,1,0,0,0,270,249,1,0,0,0,270,250,
        1,0,0,0,270,259,1,0,0,0,271,21,1,0,0,0,11,85,112,135,158,177,192,
        206,214,228,247,270
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "','", "'if'", "'then'", "'else'", "'let'", 
                     "';'", "'fix'", "'('", "')'", "'@'", "':'", "'case'", 
                     "'=>'", "'='", "'|>'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_expr = 0
    RULE_base = 1
    RULE_function = 2
    RULE_record = 3
    RULE_argchain = 4
    RULE_pipeline = 5
    RULE_keychain = 6
    RULE_target = 7
    RULE_pattern = 8
    RULE_pattern_base = 9
    RULE_pattern_record = 10

    ruleNames =  [ "expr", "base", "function", "record", "argchain", "pipeline", 
                   "keychain", "target", "pattern", "pattern_base", "pattern_record" ]

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
    T__12=13
    T__13=14
    T__14=15
    T__15=16
    ID=17
    INT=18
    WS=19

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
        self._guidance = disn_default 
        self._overflow = False  

    def reset(self): 
        self._guidance = disn_default
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

        disn_result = None
        if not self._overflow:
            disn_result = f(*args)
            self._guidance = Nonterm(name, disn_result)

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return disn_result 



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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._base = None # BaseContext
            self.head = None # BaseContext
            self.tail = None # BaseContext
            self.condition = None # ExprContext
            self.true_branch = None # ExprContext
            self.false_branch = None # ExprContext
            self.cator = None # BaseContext
            self._keychain = None # KeychainContext
            self._argchain = None # ArgchainContext
            self._pipeline = None # PipelineContext
            self._ID = None # Token
            self._target = None # TargetContext
            self.contin = None # ExprContext
            self.body = None # ExprContext
            self.disn = disn

        def base(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.BaseContext)
            else:
                return self.getTypedRuleContext(SlimParser.BaseContext,i)


        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.ExprContext)
            else:
                return self.getTypedRuleContext(SlimParser.ExprContext,i)


        def keychain(self):
            return self.getTypedRuleContext(SlimParser.KeychainContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


        def pipeline(self):
            return self.getTypedRuleContext(SlimParser.PipelineContext,0)


        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def target(self):
            return self.getTypedRuleContext(SlimParser.TargetContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_expr

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterExpr" ):
                listener.enterExpr(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitExpr" ):
                listener.exitExpr(self)




    def expr(self, disn:Distillation):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 85
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 23
                localctx._base = self.base(disn)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_head)

                self.state = 27
                localctx.head = self.base(disn)

                self.guide_symbol(',')

                self.state = 29
                self.match(SlimParser.T__0)

                disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_tail, localctx.head.combo)

                self.state = 31
                localctx.tail = self.base(disn)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 34
                self.match(SlimParser.T__1)

                disn_condition = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_condition)

                self.state = 36
                localctx.condition = self.expr(disn_condition)

                self.guide_symbol('then')

                self.state = 38
                self.match(SlimParser.T__2)

                disn_true_branch = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_true_branch, localctx.condition.combo)

                self.state = 40
                localctx.true_branch = self.expr(disn_true_branch)

                self.guide_symbol('else')

                self.state = 42
                self.match(SlimParser.T__3)

                disn_false_branch = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_false_branch, localctx.condition.combo, localctx.true_branch.combo)

                self.state = 44
                localctx.false_branch = self.expr(disn_false_branch)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_ite, localctx.condition.combo, localctx.true_branch.combo, localctx.false_branch.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_projection_cator)

                self.state = 48
                localctx.cator = self.base(disn_cator)

                disn_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, disn).distill_projection_keychain, localctx.cator.combo)

                self.state = 50
                localctx._keychain = self.keychain(disn_keychain)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_projection, localctx.cator.combo, localctx._keychain.ids) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_application_cator)

                self.state = 54
                localctx.cator = self.base(disn_cator)

                disn_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, disn).distill_application_argchain, localctx.cator.combo)

                self.state = 56
                localctx._argchain = self.argchain(disn_argchain)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_application, localctx.cator.combo, localctx._argchain.combos)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                disn_arg = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_funnel_arg)

                self.state = 60
                localctx.cator = self.base(disn_arg)

                disn_pipeline = self.guide_nonterm('pipeline', ExprAttr(self._solver, disn).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 62
                localctx._pipeline = self.pipeline(disn_pipeline)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_funnel, localctx.cator.combo, localctx._pipeline.combos)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 65
                self.match(SlimParser.T__4)

                self.guide_terminal('ID')

                self.state = 67
                localctx._ID = self.match(SlimParser.ID)

                disn_target = self.guide_nonterm('target', ExprAttr(self._solver, disn).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 69
                localctx._target = self.target(disn_target)

                self.guide_symbol(';')

                self.state = 71
                self.match(SlimParser.T__5)

                disn_contin = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 73
                localctx.contin = self.expr(disn_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 76
                self.match(SlimParser.T__6)

                self.guide_symbol('(')

                self.state = 78
                self.match(SlimParser.T__7)

                disn_body = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_fix_body)

                self.state = 80
                localctx.body = self.expr(disn_body)

                self.guide_symbol(')')

                self.state = 82
                self.match(SlimParser.T__8)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_fix, localctx.body.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._expr = None # ExprContext
            self.disn = disn

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




    def base(self, disn:Distillation):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 2, self.RULE_base)
        try:
            self.state = 112
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 88
                self.match(SlimParser.T__9)

                localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 90
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 92
                localctx._ID = self.match(SlimParser.ID)

                disn_body = self.guide_nonterm('expr', BaseAttr(self._solver, disn).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 94
                localctx.body = self.expr(disn_body)

                localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 97
                localctx._record = self.record(disn)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 100
                localctx._function = self.function(disn)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 103
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseAttr(self._solver, disn).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 105
                self.match(SlimParser.T__7)

                disn_expr = self.guide_nonterm('expr', lambda: disn)

                self.state = 107
                localctx._expr = self.expr(disn_expr)

                self.guide_symbol(')')

                self.state = 109
                self.match(SlimParser.T__8)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self.tail = None # FunctionContext
            self.disn = disn

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




    def function(self, disn:Distillation):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 4, self.RULE_function)
        try:
            self.state = 135
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 115
                self.match(SlimParser.T__11)

                disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_single_pattern)

                self.state = 117
                localctx._pattern = self.pattern(disn_pattern)

                self.guide_symbol('=>')

                self.state = 119
                self.match(SlimParser.T__12)

                disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_single_body, localctx._pattern.combo)

                self.state = 121
                localctx.body = self.expr(disn_body)

                localctx.combo = self.collect(FunctionAttr(self._solver, disn).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 124
                self.match(SlimParser.T__11)

                disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_cons_pattern)

                self.state = 126
                localctx._pattern = self.pattern(disn_pattern)

                self.guide_symbol('=>')

                self.state = 128
                self.match(SlimParser.T__12)

                disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_cons_body, localctx._pattern.combo)

                self.state = 130
                localctx.body = self.expr(disn_body)

                disn_tail = self.guide_nonterm('function', FunctionAttr(self._solver, disn).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 132
                localctx.tail = self.function(disn)

                localctx.combo = self.collect(FunctionAttr(self._solver, disn).combine_cons, localctx._pattern.combo, localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.tail = None # RecordContext
            self.disn = disn

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




    def record(self, disn:Distillation):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 6, self.RULE_record)
        try:
            self.state = 158
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 138
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 140
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 142
                self.match(SlimParser.T__13)

                disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 144
                localctx.body = self.expr(disn_body)

                localctx.combo = self.collect(RecordAttr(self._solver, disn).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 147
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 149
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 151
                self.match(SlimParser.T__13)

                disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 153
                localctx.body = self.expr(disn)

                disn_tail = self.guide_nonterm('record', RecordAttr(self._solver, disn).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 155
                localctx.tail = self.record(disn)

                localctx.combo = self.collect(RecordAttr(self._solver, disn).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combos = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.disn = disn

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




    def argchain(self, disn:Distillation):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 8, self.RULE_argchain)
        try:
            self.state = 177
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 161
                self.match(SlimParser.T__7)

                disn_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_single_content) 

                self.state = 163
                localctx.content = self.expr(disn_content)

                self.guide_symbol(')')

                self.state = 165
                self.match(SlimParser.T__8)

                localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 168
                self.match(SlimParser.T__7)

                disn_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_cons_head) 

                self.state = 170
                localctx.head = self.expr(disn_head)

                self.guide_symbol(')')

                self.state = 172
                self.match(SlimParser.T__8)

                disn_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, disn).distill_cons_tail, localctx.head.combo) 

                self.state = 174
                localctx.tail = self.argchain(disn_tail)

                localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, localctx.head.combo, localctx.tail.combos)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PipelineContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combos = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # PipelineContext
            self.disn = disn

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def pipeline(self):
            return self.getTypedRuleContext(SlimParser.PipelineContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_pipeline

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPipeline" ):
                listener.enterPipeline(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPipeline" ):
                listener.exitPipeline(self)




    def pipeline(self, disn:Distillation):

        localctx = SlimParser.PipelineContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 10, self.RULE_pipeline)
        try:
            self.state = 192
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 180
                self.match(SlimParser.T__14)

                disn_content = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_single_content) 

                self.state = 182
                localctx.content = self.expr(disn_content)

                localctx.combos = self.collect(PipelineAttr(self._solver, disn).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 185
                self.match(SlimParser.T__14)

                disn_head = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_cons_head) 

                self.state = 187
                localctx.head = self.expr(disn_head)

                disn_tail = self.guide_nonterm('pipeline', PipelineAttr(self._solver, disn).distill_cons_tail, localctx.head.combo) 

                self.state = 189
                localctx.tail = self.pipeline(disn_tail)

                localctx.combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, localctx.head.combo, localctx.tail.combos)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.ids = None
            self._ID = None # Token
            self.tail = None # KeychainContext
            self.disn = disn

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




    def keychain(self, disn:Distillation):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 12, self.RULE_keychain)
        try:
            self.state = 206
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 195
                self.match(SlimParser.T__15)

                self.guide_terminal('ID')

                self.state = 197
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.collect(KeychainAttr(self._solver, disn).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 199
                self.match(SlimParser.T__15)

                self.guide_terminal('ID')

                self.state = 201
                localctx._ID = self.match(SlimParser.ID)

                disn_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, disn).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 203
                localctx.tail = self.keychain(disn_tail)

                localctx.ids = self.collect(KeychainAttr(self._solver, disn).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._expr = None # ExprContext
            self.disn = disn

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




    def target(self, disn:Distillation):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 14, self.RULE_target)
        try:
            self.state = 214
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [6]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [14]:
                self.enterOuterAlt(localctx, 2)
                self.state = 209
                self.match(SlimParser.T__13)

                disn_expr = self.guide_nonterm('expr', lambda: disn)

                self.state = 211
                localctx._expr = self.expr(disn_expr)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._pattern_base = None # Pattern_baseContext
            self.head = None # BaseContext
            self.tail = None # BaseContext
            self.disn = disn

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




    def pattern(self, disn:Distillation):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 16, self.RULE_pattern)
        try:
            self.state = 228
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 217
                localctx._pattern_base = self.pattern_base(disn)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_head)

                self.state = 221
                localctx.head = self.base(disn)

                self.guide_symbol(',')

                self.state = 223
                self.match(SlimParser.T__0)

                disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_tail, localctx.head.combo)

                self.state = 225
                localctx.tail = self.base(disn)

                localctx.combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, localctx.head.combo, localctx.tail.combo) 

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self._pattern_record = None # Pattern_recordContext
            self.disn = disn

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




    def pattern_base(self, disn:Distillation):

        localctx = SlimParser.Pattern_baseContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 18, self.RULE_pattern_base)
        try:
            self.state = 247
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 231
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 233
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 235
                self.match(SlimParser.T__9)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 237
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 239
                localctx._ID = self.match(SlimParser.ID)

                disn_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, disn).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 241
                localctx.body = self.pattern(disn_body)

                localctx.combo = self.collect(PatternBaseAttr(self._solver, disn).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 244
                localctx._pattern_record = self.pattern_record(disn)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, disn:Distillation=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.disn = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # Pattern_recordContext
            self.disn = disn

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




    def pattern_record(self, disn:Distillation):

        localctx = SlimParser.Pattern_recordContext(self, self._ctx, self.state, disn)
        self.enterRule(localctx, 20, self.RULE_pattern_record)
        try:
            self.state = 270
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 250
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 252
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 254
                self.match(SlimParser.T__13)

                disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 256
                localctx.body = self.pattern(disn_body)

                localctx.combo = self.collect(PatternRecordAttr(self._solver, disn).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 259
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 261
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 263
                self.match(SlimParser.T__13)

                disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 265
                localctx.body = self.pattern(disn_body)

                disn_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, disn).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 267
                localctx.tail = self.pattern_record(disn_tail)

                localctx.combo = self.collect(PatternRecordAttr(self._solver, disn).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





