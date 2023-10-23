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
        4,0,11,61,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,
        6,7,6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,1,0,1,0,1,0,1,1,1,1,1,2,
        1,2,1,2,1,2,1,3,1,3,1,4,1,4,1,4,1,4,1,5,1,5,1,6,1,6,1,7,1,7,1,8,
        4,8,46,8,8,11,8,12,8,47,1,9,4,9,51,8,9,11,9,12,9,52,1,10,4,10,56,
        8,10,11,10,12,10,57,1,10,1,10,0,0,11,1,1,3,2,5,3,7,4,9,5,11,6,13,
        7,15,8,17,9,19,10,21,11,1,0,3,2,0,65,90,97,122,1,0,48,57,3,0,9,10,
        13,13,32,32,63,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,
        9,1,0,0,0,0,11,1,0,0,0,0,13,1,0,0,0,0,15,1,0,0,0,0,17,1,0,0,0,0,
        19,1,0,0,0,0,21,1,0,0,0,1,23,1,0,0,0,3,26,1,0,0,0,5,28,1,0,0,0,7,
        32,1,0,0,0,9,34,1,0,0,0,11,38,1,0,0,0,13,40,1,0,0,0,15,42,1,0,0,
        0,17,45,1,0,0,0,19,50,1,0,0,0,21,55,1,0,0,0,23,24,5,40,0,0,24,25,
        5,41,0,0,25,2,1,0,0,0,26,27,5,58,0,0,27,4,1,0,0,0,28,29,5,108,0,
        0,29,30,5,101,0,0,30,31,5,116,0,0,31,6,1,0,0,0,32,33,5,61,0,0,33,
        8,1,0,0,0,34,35,5,102,0,0,35,36,5,105,0,0,36,37,5,120,0,0,37,10,
        1,0,0,0,38,39,5,40,0,0,39,12,1,0,0,0,40,41,5,41,0,0,41,14,1,0,0,
        0,42,43,5,46,0,0,43,16,1,0,0,0,44,46,7,0,0,0,45,44,1,0,0,0,46,47,
        1,0,0,0,47,45,1,0,0,0,47,48,1,0,0,0,48,18,1,0,0,0,49,51,7,1,0,0,
        50,49,1,0,0,0,51,52,1,0,0,0,52,50,1,0,0,0,52,53,1,0,0,0,53,20,1,
        0,0,0,54,56,7,2,0,0,55,54,1,0,0,0,56,57,1,0,0,0,57,55,1,0,0,0,57,
        58,1,0,0,0,58,59,1,0,0,0,59,60,6,10,0,0,60,22,1,0,0,0,4,0,47,52,
        57,1,6,0,0
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
    ID = 9
    INT = 10
    WS = 11

    channelNames = [ u"DEFAULT_TOKEN_CHANNEL", u"HIDDEN" ]

    modeNames = [ "DEFAULT_MODE" ]

    literalNames = [ "<INVALID>",
            "'()'", "':'", "'let'", "'='", "'fix'", "'('", "')'", "'.'" ]

    symbolicNames = [ "<INVALID>",
            "ID", "INT", "WS" ]

    ruleNames = [ "T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", 
                  "T__7", "ID", "INT", "WS" ]

    grammarFileName = "Slim.g4"

    def __init__(self, input=None, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = LexerATNSimulator(self, self.atn, self.decisionsToDFA, PredictionContextCache())
        self._actions = None
        self._predicates = None


