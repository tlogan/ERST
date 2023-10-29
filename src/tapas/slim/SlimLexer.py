# Generated from /Users/thomas/tlogan/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
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
        4,0,12,65,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,
        6,7,6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,1,0,1,0,1,1,1,
        1,1,2,1,2,1,3,1,3,1,4,1,4,1,5,1,5,1,5,1,6,1,6,1,6,1,6,1,7,1,7,1,
        8,1,8,1,8,1,8,1,9,4,9,50,8,9,11,9,12,9,51,1,10,4,10,55,8,10,11,10,
        12,10,56,1,11,4,11,60,8,11,11,11,12,11,61,1,11,1,11,0,0,12,1,1,3,
        2,5,3,7,4,9,5,11,6,13,7,15,8,17,9,19,10,21,11,23,12,1,0,3,2,0,65,
        90,97,122,1,0,48,57,3,0,9,10,13,13,32,32,67,0,1,1,0,0,0,0,3,1,0,
        0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,1,0,0,0,0,13,1,0,0,
        0,0,15,1,0,0,0,0,17,1,0,0,0,0,19,1,0,0,0,0,21,1,0,0,0,0,23,1,0,0,
        0,1,25,1,0,0,0,3,27,1,0,0,0,5,29,1,0,0,0,7,31,1,0,0,0,9,33,1,0,0,
        0,11,35,1,0,0,0,13,38,1,0,0,0,15,42,1,0,0,0,17,44,1,0,0,0,19,49,
        1,0,0,0,21,54,1,0,0,0,23,59,1,0,0,0,25,26,5,64,0,0,26,2,1,0,0,0,
        27,28,5,58,0,0,28,4,1,0,0,0,29,30,5,40,0,0,30,6,1,0,0,0,31,32,5,
        41,0,0,32,8,1,0,0,0,33,34,5,46,0,0,34,10,1,0,0,0,35,36,5,61,0,0,
        36,37,5,62,0,0,37,12,1,0,0,0,38,39,5,108,0,0,39,40,5,101,0,0,40,
        41,5,116,0,0,41,14,1,0,0,0,42,43,5,61,0,0,43,16,1,0,0,0,44,45,5,
        102,0,0,45,46,5,105,0,0,46,47,5,120,0,0,47,18,1,0,0,0,48,50,7,0,
        0,0,49,48,1,0,0,0,50,51,1,0,0,0,51,49,1,0,0,0,51,52,1,0,0,0,52,20,
        1,0,0,0,53,55,7,1,0,0,54,53,1,0,0,0,55,56,1,0,0,0,56,54,1,0,0,0,
        56,57,1,0,0,0,57,22,1,0,0,0,58,60,7,2,0,0,59,58,1,0,0,0,60,61,1,
        0,0,0,61,59,1,0,0,0,61,62,1,0,0,0,62,63,1,0,0,0,63,64,6,11,0,0,64,
        24,1,0,0,0,4,0,51,56,61,1,6,0,0
    ]

class SlimLexer(Lexer):

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    T__0 = 1
    T__1 = 2
    T__2 = 3
    T__3 = 4
    T__4 = 5
    T__5 = 6
    T__6 = 7
    T__7 = 8
    T__8 = 9
    ID = 10
    INT = 11
    WS = 12

    channelNames = [ u"DEFAULT_TOKEN_CHANNEL", u"HIDDEN" ]

    modeNames = [ "DEFAULT_MODE" ]

    literalNames = [ "<INVALID>",
            "'@'", "':'", "'('", "')'", "'.'", "'=>'", "'let'", "'='", "'fix'" ]

    symbolicNames = [ "<INVALID>",
            "ID", "INT", "WS" ]

    ruleNames = [ "T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", 
                  "T__7", "T__8", "ID", "INT", "WS" ]

    grammarFileName = "Slim.g4"

    def __init__(self, input=None, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = LexerATNSimulator(self, self.atn, self.decisionsToDFA, PredictionContextCache())
        self._actions = None
        self._predicates = None


