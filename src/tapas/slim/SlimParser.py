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
        4,1,10,32,2,0,7,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,
        0,30,8,0,1,0,0,0,1,0,0,0,35,0,29,1,0,0,0,2,30,1,0,0,0,3,4,5,8,0,
        0,4,30,6,0,-1,0,5,6,5,1,0,0,6,30,6,0,-1,0,7,8,5,2,0,0,8,9,5,8,0,
        0,9,10,3,0,0,0,10,11,6,0,-1,0,11,30,1,0,0,0,12,13,5,3,0,0,13,14,
        5,8,0,0,14,15,5,4,0,0,15,16,3,0,0,0,16,17,6,0,-1,0,17,18,3,0,0,0,
        18,19,6,0,-1,0,19,30,1,0,0,0,20,21,5,5,0,0,21,22,6,0,-1,0,22,23,
        5,6,0,0,23,24,6,0,-1,0,24,25,3,0,0,0,25,26,6,0,-1,0,26,27,5,7,0,
        0,27,28,6,0,-1,0,28,30,1,0,0,0,29,2,1,0,0,0,29,3,1,0,0,0,29,5,1,
        0,0,0,29,7,1,0,0,0,29,12,1,0,0,0,29,20,1,0,0,0,30,1,1,0,0,0,1,29
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "':'", "'let'", "'='", "'fix'", 
                     "'('", "')'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "ID", "INT", "WS" ]

    RULE_expr = 0

    ruleNames =  [ "expr" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    T__4=5
    T__5=6
    T__6=7
    ID=8
    INT=9
    WS=10

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    _guidance : Guidance 
    _cache : dict[int, str] = {}
    _overflow = False  

    def reset(self): 
        self._guidance = NontermExpr(m(), Top())
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def updateOverflow(self):
        tok = self.getCurrentToken()
        if not self._overflow and tok.type == self.EOF :
            self._overflow = True 

    def overflow(self) -> bool: 
        return self._overflow


    def guard_down(self, f : Callable, *args):
        if not self.overflow():
            self._guidance = f(*args)

        self.updateOverflow()

    def guard_up(self, f : Callable, *args):
        if self.overflow():
            return None
        else:

            return f(*args)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, env:PMap[str, Typ]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.env = None
            self.typ = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.target = None # ExprContext
            self.env = env

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def expr(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.ExprContext)
            else:
                return self.getTypedRuleContext(SlimParser.ExprContext,i)


        def getRuleIndex(self):
            return SlimParser.RULE_expr

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterExpr" ):
                listener.enterExpr(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitExpr" ):
                listener.exitExpr(self)




    def expr(self, env:PMap[str, Typ]):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, env)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 29
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 3
                localctx._ID = self.match(SlimParser.ID)

                localctx.typ = self.guard_up(gather_expr_id, env, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 5
                self.match(SlimParser.T__0)

                localctx.typ = self.guard_up(gather_expr_unit)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 7
                self.match(SlimParser.T__1)
                self.state = 8
                localctx._ID = self.match(SlimParser.ID)
                self.state = 9
                localctx.body = self.expr(env)


                print(f"TAG body type: {localctx.body.typ}")
                localctx.typ = self.guard_up(gather_expr_tag, env, (None if localctx._ID is None else localctx._ID.text), localctx.body.typ)

                print(f"TAG $typ: {localctx.typ}")

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 12
                self.match(SlimParser.T__2)
                self.state = 13
                localctx._ID = self.match(SlimParser.ID)
                self.state = 14
                self.match(SlimParser.T__3)
                self.state = 15
                localctx.target = self.expr(env)

                self.guard_down(guide_expr_let_body, env, (None if localctx._ID is None else localctx._ID.text), localctx.target.typ)
                if isinstance(self._guidance, NontermExpr):
                    env = self._guidance.env

                self.state = 17
                localctx.body = self.expr(env)

                localctx.typ = self.guard_up(lambda: NontermExpr(env, localctx.body.typ))

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 20
                self.match(SlimParser.T__4)
                 
                self.guard_down(lambda: Symbol("("))

                self.state = 22
                self.match(SlimParser.T__5)

                self.guard_down(lambda: NontermExpr(env, Top()))

                self.state = 24
                localctx.body = self.expr(env)

                self.guard_down(lambda: Symbol(')'))

                self.state = 26
                self.match(SlimParser.T__6)

                localctx.typ = self.guard_up(gather_expr_fix, localctx.body.typ)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





