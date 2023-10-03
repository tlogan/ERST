# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,12,40,2,0,7,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,4,0,13,
        8,0,11,0,12,0,14,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
        1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,38,8,0,1,0,0,0,1,0,0,0,45,
        0,37,1,0,0,0,2,38,1,0,0,0,3,4,5,10,0,0,4,38,6,0,-1,0,5,6,5,1,0,0,
        6,38,6,0,-1,0,7,8,5,2,0,0,8,9,3,0,0,0,9,10,5,3,0,0,10,11,3,0,0,0,
        11,13,1,0,0,0,12,7,1,0,0,0,13,14,1,0,0,0,14,12,1,0,0,0,14,15,1,0,
        0,0,15,16,1,0,0,0,16,17,6,0,-1,0,17,38,1,0,0,0,18,19,5,4,0,0,19,
        20,3,0,0,0,20,21,5,5,0,0,21,22,3,0,0,0,22,23,5,6,0,0,23,24,3,0,0,
        0,24,25,6,0,-1,0,25,38,1,0,0,0,26,27,5,7,0,0,27,28,5,8,0,0,28,29,
        3,0,0,0,29,30,5,9,0,0,30,31,6,0,-1,0,31,38,1,0,0,0,32,33,5,8,0,0,
        33,34,3,0,0,0,34,35,5,9,0,0,35,36,6,0,-1,0,36,38,1,0,0,0,37,2,1,
        0,0,0,37,3,1,0,0,0,37,5,1,0,0,0,37,12,1,0,0,0,37,18,1,0,0,0,37,26,
        1,0,0,0,37,32,1,0,0,0,38,1,1,0,0,0,2,14,37
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'()'", "'fun'", "'=>'", "'if'", "'then'", 
                     "'else'", "'fix'", "'('", "')'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "ID", "INT", "WS" ]

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




    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self.param = None # ExprContext
            self.body = None # ExprContext
            self.cond = None # ExprContext
            self.t = None # ExprContext
            self.f = None # ExprContext

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




    def expr(self):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_expr)
        try:
            self.state = 37
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 3
                self.match(SlimParser.ID)

                        localctx.result = f'(id)'
                    
                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 5
                self.match(SlimParser.T__0)

                        localctx.result = f'(unit)'
                    
                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 12 
                self._errHandler.sync(self)
                _alt = 1
                while _alt!=2 and _alt!=ATN.INVALID_ALT_NUMBER:
                    if _alt == 1:
                        self.state = 7
                        self.match(SlimParser.T__1)
                        self.state = 8
                        localctx.param = self.expr()
                        self.state = 9
                        self.match(SlimParser.T__2)
                        self.state = 10
                        localctx.body = self.expr()

                    else:
                        raise NoViableAltException(self)
                    self.state = 14 
                    self._errHandler.sync(self)
                    _alt = self._interp.adaptivePredict(self._input,0,self._ctx)


                        prefix = '['
                        content = ''.join([
                            '(fun ' + p + ' ' + b + ')'  
                            for p, b in zip(localctx.param.result, localctx.body.result)
                        ])
                        suffix = ']'
                        localctx.result = prefix + content + suffix
                    
                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 18
                self.match(SlimParser.T__3)
                self.state = 19
                localctx.cond = self.expr()
                self.state = 20
                self.match(SlimParser.T__4)
                self.state = 21
                localctx.t = self.expr()
                self.state = 22
                self.match(SlimParser.T__5)
                self.state = 23
                localctx.f = self.expr()

                        localctx.result = f'(ite {localctx.cond.result} {localctx.t.result} {localctx.f.result})'
                    
                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 26
                self.match(SlimParser.T__6)
                self.state = 27
                self.match(SlimParser.T__7)
                self.state = 28
                localctx.body = self.expr()
                self.state = 29
                self.match(SlimParser.T__8)

                        localctx.result = f'(fix {localctx.body.result})'
                    
                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 32
                self.match(SlimParser.T__7)
                self.state = 33
                localctx.body = self.expr()
                self.state = 34
                self.match(SlimParser.T__8)

                        localctx.result = f'(paren {localctx.body.result})' 
                    
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





