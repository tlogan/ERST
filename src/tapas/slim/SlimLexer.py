# Generated from /Users/thomas/tlogan@github.com/ERST/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
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

from tapas.slim.analyzer import * 

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset



def serializedATN():
    return [
        4,0,34,182,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,
        2,6,7,6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,
        13,7,13,2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,
        19,2,20,7,20,2,21,7,21,2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,
        26,7,26,2,27,7,27,2,28,7,28,2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,
        32,2,33,7,33,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,1,3,
        1,3,1,3,1,3,1,4,1,4,1,5,1,5,1,6,1,6,1,7,1,7,1,8,1,8,1,9,1,9,1,10,
        1,10,1,11,1,11,1,11,1,12,1,12,1,13,1,13,1,13,1,13,1,14,1,14,1,15,
        1,15,1,16,1,16,1,16,1,16,1,17,1,17,1,17,1,18,1,18,1,19,1,19,1,20,
        1,20,1,20,1,21,1,21,1,21,1,22,1,22,1,22,1,22,1,22,1,23,1,23,1,23,
        1,23,1,23,1,24,1,24,1,24,1,24,1,25,1,25,1,25,1,26,1,26,1,26,1,26,
        1,27,1,27,1,27,1,27,1,27,1,28,1,28,1,28,1,29,1,29,1,30,1,30,1,30,
        1,31,1,31,5,31,166,8,31,10,31,12,31,169,9,31,1,32,4,32,172,8,32,
        11,32,12,32,173,1,33,4,33,177,8,33,11,33,12,33,178,1,33,1,33,0,0,
        34,1,1,3,2,5,3,7,4,9,5,11,6,13,7,15,8,17,9,19,10,21,11,23,12,25,
        13,27,14,29,15,31,16,33,17,35,18,37,19,39,20,41,21,43,22,45,23,47,
        24,49,25,51,26,53,27,55,28,57,29,59,30,61,31,63,32,65,33,67,34,1,
        0,4,2,0,65,90,97,122,4,0,48,57,65,90,95,95,97,122,1,0,48,57,3,0,
        9,10,13,13,32,32,184,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,
        0,0,0,9,1,0,0,0,0,11,1,0,0,0,0,13,1,0,0,0,0,15,1,0,0,0,0,17,1,0,
        0,0,0,19,1,0,0,0,0,21,1,0,0,0,0,23,1,0,0,0,0,25,1,0,0,0,0,27,1,0,
        0,0,0,29,1,0,0,0,0,31,1,0,0,0,0,33,1,0,0,0,0,35,1,0,0,0,0,37,1,0,
        0,0,0,39,1,0,0,0,0,41,1,0,0,0,0,43,1,0,0,0,0,45,1,0,0,0,0,47,1,0,
        0,0,0,49,1,0,0,0,0,51,1,0,0,0,0,53,1,0,0,0,0,55,1,0,0,0,0,57,1,0,
        0,0,0,59,1,0,0,0,0,61,1,0,0,0,0,63,1,0,0,0,0,65,1,0,0,0,0,67,1,0,
        0,0,1,69,1,0,0,0,3,75,1,0,0,0,5,77,1,0,0,0,7,81,1,0,0,0,9,85,1,0,
        0,0,11,87,1,0,0,0,13,89,1,0,0,0,15,91,1,0,0,0,17,93,1,0,0,0,19,95,
        1,0,0,0,21,97,1,0,0,0,23,99,1,0,0,0,25,102,1,0,0,0,27,104,1,0,0,
        0,29,108,1,0,0,0,31,110,1,0,0,0,33,112,1,0,0,0,35,116,1,0,0,0,37,
        119,1,0,0,0,39,121,1,0,0,0,41,123,1,0,0,0,43,126,1,0,0,0,45,129,
        1,0,0,0,47,134,1,0,0,0,49,139,1,0,0,0,51,143,1,0,0,0,53,146,1,0,
        0,0,55,150,1,0,0,0,57,155,1,0,0,0,59,158,1,0,0,0,61,160,1,0,0,0,
        63,163,1,0,0,0,65,171,1,0,0,0,67,176,1,0,0,0,69,70,5,97,0,0,70,71,
        5,108,0,0,71,72,5,105,0,0,72,73,5,97,0,0,73,74,5,115,0,0,74,2,1,
        0,0,0,75,76,5,61,0,0,76,4,1,0,0,0,77,78,5,84,0,0,78,79,5,79,0,0,
        79,80,5,80,0,0,80,6,1,0,0,0,81,82,5,66,0,0,82,83,5,79,0,0,83,84,
        5,84,0,0,84,8,1,0,0,0,85,86,5,64,0,0,86,10,1,0,0,0,87,88,5,126,0,
        0,88,12,1,0,0,0,89,90,5,58,0,0,90,14,1,0,0,0,91,92,5,40,0,0,92,16,
        1,0,0,0,93,94,5,41,0,0,94,18,1,0,0,0,95,96,5,124,0,0,96,20,1,0,0,
        0,97,98,5,38,0,0,98,22,1,0,0,0,99,100,5,45,0,0,100,101,5,62,0,0,
        101,24,1,0,0,0,102,103,5,44,0,0,103,26,1,0,0,0,104,105,5,69,0,0,
        105,106,5,88,0,0,106,107,5,73,0,0,107,28,1,0,0,0,108,109,5,91,0,
        0,109,30,1,0,0,0,110,111,5,93,0,0,111,32,1,0,0,0,112,113,5,65,0,
        0,113,114,5,76,0,0,114,115,5,76,0,0,115,34,1,0,0,0,116,117,5,70,
        0,0,117,118,5,88,0,0,118,36,1,0,0,0,119,120,5,92,0,0,120,38,1,0,
        0,0,121,122,5,59,0,0,122,40,1,0,0,0,123,124,5,60,0,0,124,125,5,58,
        0,0,125,42,1,0,0,0,126,127,5,105,0,0,127,128,5,102,0,0,128,44,1,
        0,0,0,129,130,5,116,0,0,130,131,5,104,0,0,131,132,5,101,0,0,132,
        133,5,110,0,0,133,46,1,0,0,0,134,135,5,101,0,0,135,136,5,108,0,0,
        136,137,5,115,0,0,137,138,5,101,0,0,138,48,1,0,0,0,139,140,5,108,
        0,0,140,141,5,101,0,0,141,142,5,116,0,0,142,50,1,0,0,0,143,144,5,
        105,0,0,144,145,5,110,0,0,145,52,1,0,0,0,146,147,5,102,0,0,147,148,
        5,105,0,0,148,149,5,120,0,0,149,54,1,0,0,0,150,151,5,99,0,0,151,
        152,5,97,0,0,152,153,5,115,0,0,153,154,5,101,0,0,154,56,1,0,0,0,
        155,156,5,61,0,0,156,157,5,62,0,0,157,58,1,0,0,0,158,159,5,46,0,
        0,159,60,1,0,0,0,160,161,5,124,0,0,161,162,5,62,0,0,162,62,1,0,0,
        0,163,167,7,0,0,0,164,166,7,1,0,0,165,164,1,0,0,0,166,169,1,0,0,
        0,167,165,1,0,0,0,167,168,1,0,0,0,168,64,1,0,0,0,169,167,1,0,0,0,
        170,172,7,2,0,0,171,170,1,0,0,0,172,173,1,0,0,0,173,171,1,0,0,0,
        173,174,1,0,0,0,174,66,1,0,0,0,175,177,7,3,0,0,176,175,1,0,0,0,177,
        178,1,0,0,0,178,176,1,0,0,0,178,179,1,0,0,0,179,180,1,0,0,0,180,
        181,6,33,0,0,181,68,1,0,0,0,4,0,167,173,178,1,6,0,0
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
    T__11 = 12
    T__12 = 13
    T__13 = 14
    T__14 = 15
    T__15 = 16
    T__16 = 17
    T__17 = 18
    T__18 = 19
    T__19 = 20
    T__20 = 21
    T__21 = 22
    T__22 = 23
    T__23 = 24
    T__24 = 25
    T__25 = 26
    T__26 = 27
    T__27 = 28
    T__28 = 29
    T__29 = 30
    T__30 = 31
    ID = 32
    INT = 33
    WS = 34

    channelNames = [ u"DEFAULT_TOKEN_CHANNEL", u"HIDDEN" ]

    modeNames = [ "DEFAULT_MODE" ]

    literalNames = [ "<INVALID>",
            "'alias'", "'='", "'TOP'", "'BOT'", "'@'", "'~'", "':'", "'('", 
            "')'", "'|'", "'&'", "'->'", "','", "'EXI'", "'['", "']'", "'ALL'", 
            "'FX'", "'\\'", "';'", "'<:'", "'if'", "'then'", "'else'", "'let'", 
            "'in'", "'fix'", "'case'", "'=>'", "'.'", "'|>'" ]

    symbolicNames = [ "<INVALID>",
            "ID", "INT", "WS" ]

    ruleNames = [ "T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", 
                  "T__7", "T__8", "T__9", "T__10", "T__11", "T__12", "T__13", 
                  "T__14", "T__15", "T__16", "T__17", "T__18", "T__19", 
                  "T__20", "T__21", "T__22", "T__23", "T__24", "T__25", 
                  "T__26", "T__27", "T__28", "T__29", "T__30", "ID", "INT", 
                  "WS" ]

    grammarFileName = "Slim.g4"

    def __init__(self, input=None, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.0")
        self._interp = LexerATNSimulator(self, self.atn, self.decisionsToDFA, PredictionContextCache())
        self._actions = None
        self._predicates = None


