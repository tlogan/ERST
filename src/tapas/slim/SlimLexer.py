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
        4,0,14,77,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,
        6,7,6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,
        7,13,1,0,1,0,1,1,1,1,1,2,1,2,1,3,1,3,1,4,1,4,1,5,1,5,1,5,1,6,1,6,
        1,6,1,6,1,7,1,7,1,8,1,8,1,8,1,8,1,9,1,9,1,9,1,9,1,10,1,10,1,10,1,
        10,1,11,4,11,62,8,11,11,11,12,11,63,1,12,4,12,67,8,12,11,12,12,12,
        68,1,13,4,13,72,8,13,11,13,12,13,73,1,13,1,13,0,0,14,1,1,3,2,5,3,
        7,4,9,5,11,6,13,7,15,8,17,9,19,10,21,11,23,12,25,13,27,14,1,0,3,
        2,0,65,90,97,122,1,0,48,57,3,0,9,10,13,13,32,32,79,0,1,1,0,0,0,0,
        3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,1,0,0,0,0,13,
        1,0,0,0,0,15,1,0,0,0,0,17,1,0,0,0,0,19,1,0,0,0,0,21,1,0,0,0,0,23,
        1,0,0,0,0,25,1,0,0,0,0,27,1,0,0,0,1,29,1,0,0,0,3,31,1,0,0,0,5,33,
        1,0,0,0,7,35,1,0,0,0,9,37,1,0,0,0,11,39,1,0,0,0,13,42,1,0,0,0,15,
        46,1,0,0,0,17,48,1,0,0,0,19,52,1,0,0,0,21,56,1,0,0,0,23,61,1,0,0,
        0,25,66,1,0,0,0,27,71,1,0,0,0,29,30,5,64,0,0,30,2,1,0,0,0,31,32,
        5,58,0,0,32,4,1,0,0,0,33,34,5,40,0,0,34,6,1,0,0,0,35,36,5,41,0,0,
        36,8,1,0,0,0,37,38,5,46,0,0,38,10,1,0,0,0,39,40,5,61,0,0,40,41,5,
        62,0,0,41,12,1,0,0,0,42,43,5,108,0,0,43,44,5,101,0,0,44,45,5,116,
        0,0,45,14,1,0,0,0,46,47,5,61,0,0,47,16,1,0,0,0,48,49,5,102,0,0,49,
        50,5,105,0,0,50,51,5,120,0,0,51,18,1,0,0,0,52,53,5,40,0,0,53,54,
        5,45,0,0,54,55,5,45,0,0,55,20,1,0,0,0,56,57,5,45,0,0,57,58,5,45,
        0,0,58,59,5,41,0,0,59,22,1,0,0,0,60,62,7,0,0,0,61,60,1,0,0,0,62,
        63,1,0,0,0,63,61,1,0,0,0,63,64,1,0,0,0,64,24,1,0,0,0,65,67,7,1,0,
        0,66,65,1,0,0,0,67,68,1,0,0,0,68,66,1,0,0,0,68,69,1,0,0,0,69,26,
        1,0,0,0,70,72,7,2,0,0,71,70,1,0,0,0,72,73,1,0,0,0,73,71,1,0,0,0,
        73,74,1,0,0,0,74,75,1,0,0,0,75,76,6,13,0,0,76,28,1,0,0,0,4,0,63,
        68,73,1,6,0,0
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
    T__9 = 10
    T__10 = 11
    ID = 12
    INT = 13
    WS = 14

    channelNames = [ u"DEFAULT_TOKEN_CHANNEL", u"HIDDEN" ]

    modeNames = [ "DEFAULT_MODE" ]

    literalNames = [ "<INVALID>",
            "'@'", "':'", "'('", "')'", "'.'", "'=>'", "'let'", "'='", "'fix'", 
            "'(--'", "'--)'" ]

    symbolicNames = [ "<INVALID>",
            "ID", "INT", "WS" ]

    ruleNames = [ "T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", 
                  "T__7", "T__8", "T__9", "T__10", "ID", "INT", "WS" ]

    grammarFileName = "Slim.g4"

    def __init__(self, input=None, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = LexerATNSimulator(self, self.atn, self.decisionsToDFA, PredictionContextCache())
        self._actions = None
        self._predicates = None


