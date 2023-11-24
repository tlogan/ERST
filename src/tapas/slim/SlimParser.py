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
        4,1,14,219,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,90,8,0,1,1,1,1,
        1,1,1,1,1,1,1,1,3,1,98,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,3,2,115,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,138,8,
        3,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,3,4,161,8,4,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,184,8,
        5,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,3,6,203,8,6,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,
        7,3,7,217,8,7,1,7,0,0,8,0,2,4,6,8,10,12,14,0,0,237,0,89,1,0,0,0,
        2,97,1,0,0,0,4,114,1,0,0,0,6,137,1,0,0,0,8,160,1,0,0,0,10,183,1,
        0,0,0,12,202,1,0,0,0,14,216,1,0,0,0,16,90,1,0,0,0,17,18,5,12,0,0,
        18,90,6,0,-1,0,19,20,5,1,0,0,20,90,6,0,-1,0,21,22,5,2,0,0,22,23,
        6,0,-1,0,23,24,5,12,0,0,24,25,6,0,-1,0,25,26,3,0,0,0,26,27,6,0,-1,
        0,27,90,1,0,0,0,28,29,3,10,5,0,29,30,6,0,-1,0,30,90,1,0,0,0,31,32,
        5,3,0,0,32,33,6,0,-1,0,33,34,3,0,0,0,34,35,6,0,-1,0,35,36,5,4,0,
        0,36,37,6,0,-1,0,37,90,1,0,0,0,38,39,5,3,0,0,39,40,6,0,-1,0,40,41,
        3,0,0,0,41,42,6,0,-1,0,42,43,5,4,0,0,43,44,6,0,-1,0,44,45,3,14,7,
        0,45,46,6,0,-1,0,46,90,1,0,0,0,47,48,5,12,0,0,48,49,6,0,-1,0,49,
        50,3,14,7,0,50,51,6,0,-1,0,51,90,1,0,0,0,52,53,3,6,3,0,53,54,6,0,
        -1,0,54,90,1,0,0,0,55,56,5,3,0,0,56,57,6,0,-1,0,57,58,3,0,0,0,58,
        59,6,0,-1,0,59,60,5,4,0,0,60,61,6,0,-1,0,61,62,3,12,6,0,62,63,6,
        0,-1,0,63,90,1,0,0,0,64,65,5,12,0,0,65,66,6,0,-1,0,66,67,3,12,6,
        0,67,68,6,0,-1,0,68,90,1,0,0,0,69,70,5,5,0,0,70,71,6,0,-1,0,71,72,
        5,12,0,0,72,73,6,0,-1,0,73,74,3,2,1,0,74,75,6,0,-1,0,75,76,5,6,0,
        0,76,77,6,0,-1,0,77,78,3,0,0,0,78,79,6,0,-1,0,79,90,1,0,0,0,80,81,
        5,7,0,0,81,82,6,0,-1,0,82,83,5,3,0,0,83,84,6,0,-1,0,84,85,3,0,0,
        0,85,86,6,0,-1,0,86,87,5,4,0,0,87,88,6,0,-1,0,88,90,1,0,0,0,89,16,
        1,0,0,0,89,17,1,0,0,0,89,19,1,0,0,0,89,21,1,0,0,0,89,28,1,0,0,0,
        89,31,1,0,0,0,89,38,1,0,0,0,89,47,1,0,0,0,89,52,1,0,0,0,89,55,1,
        0,0,0,89,64,1,0,0,0,89,69,1,0,0,0,89,80,1,0,0,0,90,1,1,0,0,0,91,
        98,1,0,0,0,92,93,5,8,0,0,93,94,6,1,-1,0,94,95,3,0,0,0,95,96,6,1,
        -1,0,96,98,1,0,0,0,97,91,1,0,0,0,97,92,1,0,0,0,98,3,1,0,0,0,99,115,
        1,0,0,0,100,101,5,12,0,0,101,115,6,2,-1,0,102,103,5,1,0,0,103,115,
        6,2,-1,0,104,105,5,2,0,0,105,106,6,2,-1,0,106,107,5,12,0,0,107,108,
        6,2,-1,0,108,109,3,4,2,0,109,110,6,2,-1,0,110,115,1,0,0,0,111,112,
        3,8,4,0,112,113,6,2,-1,0,113,115,1,0,0,0,114,99,1,0,0,0,114,100,
        1,0,0,0,114,102,1,0,0,0,114,104,1,0,0,0,114,111,1,0,0,0,115,5,1,
        0,0,0,116,138,1,0,0,0,117,118,5,9,0,0,118,119,6,3,-1,0,119,120,3,
        4,2,0,120,121,6,3,-1,0,121,122,5,10,0,0,122,123,6,3,-1,0,123,124,
        3,0,0,0,124,125,6,3,-1,0,125,138,1,0,0,0,126,127,5,9,0,0,127,128,
        6,3,-1,0,128,129,3,4,2,0,129,130,6,3,-1,0,130,131,5,10,0,0,131,132,
        6,3,-1,0,132,133,3,0,0,0,133,134,6,3,-1,0,134,135,3,6,3,0,135,136,
        6,3,-1,0,136,138,1,0,0,0,137,116,1,0,0,0,137,117,1,0,0,0,137,126,
        1,0,0,0,138,7,1,0,0,0,139,161,1,0,0,0,140,141,5,2,0,0,141,142,6,
        4,-1,0,142,143,5,12,0,0,143,144,6,4,-1,0,144,145,5,8,0,0,145,146,
        6,4,-1,0,146,147,3,4,2,0,147,148,6,4,-1,0,148,161,1,0,0,0,149,150,
        5,2,0,0,150,151,6,4,-1,0,151,152,5,12,0,0,152,153,6,4,-1,0,153,154,
        5,8,0,0,154,155,6,4,-1,0,155,156,3,4,2,0,156,157,6,4,-1,0,157,158,
        3,8,4,0,158,159,6,4,-1,0,159,161,1,0,0,0,160,139,1,0,0,0,160,140,
        1,0,0,0,160,149,1,0,0,0,161,9,1,0,0,0,162,184,1,0,0,0,163,164,5,
        2,0,0,164,165,6,5,-1,0,165,166,5,12,0,0,166,167,6,5,-1,0,167,168,
        5,8,0,0,168,169,6,5,-1,0,169,170,3,0,0,0,170,171,6,5,-1,0,171,184,
        1,0,0,0,172,173,5,2,0,0,173,174,6,5,-1,0,174,175,5,12,0,0,175,176,
        6,5,-1,0,176,177,5,8,0,0,177,178,6,5,-1,0,178,179,3,0,0,0,179,180,
        6,5,-1,0,180,181,3,10,5,0,181,182,6,5,-1,0,182,184,1,0,0,0,183,162,
        1,0,0,0,183,163,1,0,0,0,183,172,1,0,0,0,184,11,1,0,0,0,185,203,1,
        0,0,0,186,187,5,3,0,0,187,188,6,6,-1,0,188,189,3,0,0,0,189,190,6,
        6,-1,0,190,191,5,4,0,0,191,192,6,6,-1,0,192,203,1,0,0,0,193,194,
        5,3,0,0,194,195,6,6,-1,0,195,196,3,0,0,0,196,197,6,6,-1,0,197,198,
        5,4,0,0,198,199,6,6,-1,0,199,200,3,12,6,0,200,201,6,6,-1,0,201,203,
        1,0,0,0,202,185,1,0,0,0,202,186,1,0,0,0,202,193,1,0,0,0,203,13,1,
        0,0,0,204,217,1,0,0,0,205,206,5,11,0,0,206,207,6,7,-1,0,207,208,
        5,12,0,0,208,217,6,7,-1,0,209,210,5,11,0,0,210,211,6,7,-1,0,211,
        212,5,12,0,0,212,213,6,7,-1,0,213,214,3,14,7,0,214,215,6,7,-1,0,
        215,217,1,0,0,0,216,204,1,0,0,0,216,205,1,0,0,0,216,209,1,0,0,0,
        217,15,1,0,0,0,8,89,97,114,137,160,183,202,216
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'let'", "';'", 
                     "'fix'", "'='", "'case'", "'=>'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "ID", "INT", "WS" ]

    RULE_expr = 0
    RULE_target = 1
    RULE_pattern = 2
    RULE_function = 3
    RULE_recpat = 4
    RULE_record = 5
    RULE_argchain = 6
    RULE_keychain = 7

    ruleNames =  [ "expr", "target", "pattern", "function", "recpat", "record", 
                   "argchain", "keychain" ]

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

    def guide_nonterm(self, name : str, f : Callable, *args) -> Optional[Plate]:
        for arg in args:
            if arg == None:
                self._overflow = True

        plate_result = None
        if not self._overflow:
            plate_result = f(*args)
            self._guidance = Nonterm(name, plate_result)

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return plate_result 



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
            self._target = None # TargetContext
            self.contin = None # ExprContext
            self.plate = plate

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def record(self):
            return self.getTypedRuleContext(SlimParser.RecordContext,0)


        def keychain(self):
            return self.getTypedRuleContext(SlimParser.KeychainContext,0)


        def function(self):
            return self.getTypedRuleContext(SlimParser.FunctionContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


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




    def expr(self, plate:Plate):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 89
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 17
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_id, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 19
                self.match(SlimParser.T__0)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 21
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 23
                localctx._ID = self.match(SlimParser.ID)

                plate_body = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 25
                localctx.body = self.expr(plate_body)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 28
                localctx._record = self.record(plate)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 31
                self.match(SlimParser.T__2)

                plate_expr = self.guide_nonterm('expr', lambda: plate)

                self.state = 33
                localctx._expr = self.expr(plate_expr)

                self.guide_symbol(')')

                self.state = 35
                self.match(SlimParser.T__3)

                localctx.combo = localctx._expr.combo

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 38
                self.match(SlimParser.T__2)

                plate_cator = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_projmulti_cator)

                self.state = 40
                localctx.cator = localctx._expr = self.expr(plate_expr)

                self.guide_symbol(')')

                self.state = 42
                self.match(SlimParser.T__3)

                plate_keychain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_projmulti_keychain, localctx._expr.combo)

                self.state = 44
                localctx._keychain = self.keychain(plate_keychain)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_projmulti, localctx._expr.combo, localctx._keychain.ids) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 47
                localctx._ID = self.match(SlimParser.ID)

                plate_keychain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_idprojmulti_keychain, (None if localctx._ID is None else localctx._ID.text))

                self.state = 49
                localctx._keychain = self.keychain(plate_keychain)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_idprojmulti, (None if localctx._ID is None else localctx._ID.text), localctx._keychain.ids) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 52
                localctx._function = self.function(plate)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 55
                self.match(SlimParser.T__2)

                plate_cator = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_appmulti_cator)

                self.state = 57
                localctx.cator = self.expr(plate_cator)

                self.guide_symbol(')')

                self.state = 59
                self.match(SlimParser.T__3)

                plate_argchain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_appmulti_argchain, localctx.cator.combo)

                self.state = 61
                localctx.content = localctx._argchain = self.argchain(plate_argchain)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_appmulti, localctx.cator.combo, localctx._argchain.combos)

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 64
                localctx._ID = self.match(SlimParser.ID)

                plate_argchain = self.guide_nonterm(ExprAttr(self._solver, plate).distill_idappmulti_argchain, (None if localctx._ID is None else localctx._ID.text))

                self.state = 66
                localctx._argchain = self.argchain(plate_argchain)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_idappmulti, (None if localctx._ID is None else localctx._ID.text), localctx._argchain.combos) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 69
                self.match(SlimParser.T__4)

                self.guide_terminal('ID')

                self.state = 71
                localctx._ID = self.match(SlimParser.ID)

                plate_target = self.guide_nonterm('target', ExprAttr(self._solver, plate).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 73
                localctx._target = self.target(plate_target)

                self.guide_symbol(';')

                self.state = 75
                self.match(SlimParser.T__5)

                plate_contin = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 77
                localctx.contin = self.expr(plate_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 13:
                self.enterOuterAlt(localctx, 13)
                self.state = 80
                self.match(SlimParser.T__6)

                self.guide_symbol('(')

                self.state = 82
                self.match(SlimParser.T__2)

                plate_body = self.guide_nonterm('expr', ExprAttr(self._solver, plate).distill_fix_body)

                self.state = 84
                localctx.body = self.expr(plate_body)

                self.guide_symbol(')')

                self.state = 86
                self.match(SlimParser.T__3)

                localctx.combo = self.collect(ExprAttr(self._solver, plate).combine_fix, localctx.body.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, plate:Plate=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.plate = None
            self.combo = None
            self._expr = None # ExprContext
            self.plate = plate

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




    def target(self, plate:Plate):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, plate)
        self.enterRule(localctx, 2, self.RULE_target)
        try:
            self.state = 97
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [6]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [8]:
                self.enterOuterAlt(localctx, 2)
                self.state = 92
                self.match(SlimParser.T__7)

                plate_expr = self.guide_nonterm('expr', lambda: plate)

                self.state = 94
                localctx._expr = self.expr(plate_expr)

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
        self.enterRule(localctx, 4, self.RULE_pattern)
        try:
            self.state = 114
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 100
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_id, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 102
                self.match(SlimParser.T__0)

                localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 104
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 106
                localctx._ID = self.match(SlimParser.ID)

                plate_body = self.guide_nonterm('pattern', PatternAttr(self._solver, plate).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 108
                localctx.body = self.pattern(plate_body)

                localctx.combo = self.collect(PatternAttr(self._solver, plate).combine_tag, localctx.body.combo)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 111
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
            self.tail = None # FunctionContext
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
        self.enterRule(localctx, 6, self.RULE_function)
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
                self.match(SlimParser.T__8)

                plate_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, plate).distill_single_pattern)

                self.state = 119
                localctx._pattern = self.pattern(plate_pattern)

                self.guide_symbol('=>')

                self.state = 121
                self.match(SlimParser.T__9)

                plate_body = self.guide_nonterm('expr', FunctionAttr(self._solver, plate).distill_single_body, localctx._pattern.combo)

                self.state = 123
                localctx.body = self.expr(plate_body)

                localctx.combo = self.collect(FunctionAttr(self._solver, plate).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 126
                self.match(SlimParser.T__8)

                plate_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, plate).distill_cons_pattern)

                self.state = 128
                localctx._pattern = self.pattern(plate_pattern)

                self.guide_symbol('=>')

                self.state = 130
                self.match(SlimParser.T__9)

                plate_body = self.guide_nonterm('expr', FunctionAttr(self._solver, plate).distill_cons_body, localctx._pattern.combo)

                self.state = 132
                localctx.body = self.expr(plate_body)

                plate_tail = self.guide_nonterm('function', FunctionAttr(self._solver, plate).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 134
                localctx.tail = self.function(plate)

                localctx.combo = self.collect(FunctionAttr(self._solver, plate).combine_cons, localctx._pattern.combo, localctx.body.combo, localctx.tail.combo)

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
        self.enterRule(localctx, 8, self.RULE_recpat)
        try:
            self.state = 160
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 140
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 142
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 144
                self.match(SlimParser.T__7)

                plate_body = self.guide_nonterm('pattern', RecpatAttr(self._solver, plate).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 146
                localctx.body = self.pattern(plate_body)

                localctx.combo = self.collect(RecpatAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 149
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 151
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 153
                self.match(SlimParser.T__7)

                plate_body = self.guide_nonterm('pattern', RecpatAttr(self._solver, plate).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 155
                localctx.body = self.pattern(plate_body)

                plate_tail = self.guide_nonterm('recpat', RecpatAttr(self._solver, plate).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 157
                localctx.tail = self.recpat(plate_tail)

                localctx.combo = self.collect(RecpatAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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
            self.body = None # ExprContext
            self.tail = None # RecordContext
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
        self.enterRule(localctx, 10, self.RULE_record)
        try:
            self.state = 183
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 163
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 165
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 167
                self.match(SlimParser.T__7)

                plate_body = self.guide_nonterm('expr', RecordAttr(self._solver, plate).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 169
                localctx.body = self.expr(plate_expr)

                localctx.combo = self.collect(RecordAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 172
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 174
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 176
                self.match(SlimParser.T__7)

                plate_body = self.guide_nonterm('expr', RecordAttr(self._solver, plate).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 178
                localctx.body = self.expr(plate)

                plate_tail = self.guide_nonterm('record', RecordAttr(self._solver, plate).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 180
                localctx.tail = self.record(plate)

                localctx.combo = self.collect(RecordAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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
        self.enterRule(localctx, 12, self.RULE_argchain)
        try:
            self.state = 202
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 186
                self.match(SlimParser.T__2)

                plate_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, plate).distill_single_content) 

                self.state = 188
                localctx.content = self.expr(plate_content)

                self.guide_symbol(')')

                self.state = 190
                self.match(SlimParser.T__3)

                localctx.combos = self.collect(ArgchainAttr(self._solver, plate).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 193
                self.match(SlimParser.T__2)

                plate_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, plate).distill_cons_head) 

                self.state = 195
                localctx.head = self.expr(plate_head)

                self.guide_symbol(')')

                self.state = 197
                self.match(SlimParser.T__3)

                plate_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, plate).distill_cons_tail, localctx.head.combo) 

                self.state = 199
                localctx.tail = self.argchain(plate_tail)

                localctx.combos = self.collect(ArgchainAttr(self._solver, plate).combine_cons, localctx.head.combo, localctx.tail.combos)

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
        self.enterRule(localctx, 14, self.RULE_keychain)
        try:
            self.state = 216
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 205
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 207
                localctx._ID = self.match(SlimParser.ID)

                localctx.ids = self.collect(KeychainAttr(self._solver, plate).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 209
                self.match(SlimParser.T__10)

                self.guide_terminal('ID')

                self.state = 211
                localctx._ID = self.match(SlimParser.ID)

                plate_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, plate).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 213
                localctx.tail = self.keychain(plate_tail)

                localctx.ids = self.collect(KeychainAttr(self._solver, plate).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.tail.ids)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





