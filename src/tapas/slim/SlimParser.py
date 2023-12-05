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

from tapas.slim.analyzer import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 


def serializedATN():
    return [
        4,1,31,384,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,40,8,0,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,3,1,62,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,116,8,2,1,3,1,3,1,3,1,3,
        1,3,1,3,3,3,124,8,3,1,4,1,4,1,4,1,4,1,4,3,4,131,8,4,1,5,1,5,1,5,
        1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,
        1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,
        1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,
        1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,196,8,5,1,6,
        1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,
        1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,224,8,6,1,7,1,7,1,7,1,7,
        1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,
        1,7,3,7,247,8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
        1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,270,8,8,1,9,1,9,1,9,1,9,
        1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,289,8,9,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,
        3,10,304,8,10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,
        1,11,1,11,3,11,318,8,11,1,12,1,12,1,12,1,12,1,12,1,12,3,12,326,8,
        12,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,3,
        13,340,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,
        14,1,14,1,14,1,14,1,14,1,14,1,14,3,14,359,8,14,1,15,1,15,1,15,1,
        15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,
        15,1,15,1,15,1,15,1,15,3,15,382,8,15,1,15,0,0,16,0,2,4,6,8,10,12,
        14,16,18,20,22,24,26,28,30,0,0,420,0,39,1,0,0,0,2,61,1,0,0,0,4,115,
        1,0,0,0,6,123,1,0,0,0,8,130,1,0,0,0,10,195,1,0,0,0,12,223,1,0,0,
        0,14,246,1,0,0,0,16,269,1,0,0,0,18,288,1,0,0,0,20,303,1,0,0,0,22,
        317,1,0,0,0,24,325,1,0,0,0,26,339,1,0,0,0,28,358,1,0,0,0,30,381,
        1,0,0,0,32,40,1,0,0,0,33,34,5,29,0,0,34,40,6,0,-1,0,35,36,5,29,0,
        0,36,37,3,0,0,0,37,38,6,0,-1,0,38,40,1,0,0,0,39,32,1,0,0,0,39,33,
        1,0,0,0,39,35,1,0,0,0,40,1,1,0,0,0,41,62,1,0,0,0,42,43,5,29,0,0,
        43,62,6,1,-1,0,44,45,5,1,0,0,45,62,6,1,-1,0,46,47,5,2,0,0,47,48,
        5,29,0,0,48,49,3,2,1,0,49,50,6,1,-1,0,50,62,1,0,0,0,51,52,5,29,0,
        0,52,53,5,2,0,0,53,54,3,2,1,0,54,55,6,1,-1,0,55,62,1,0,0,0,56,57,
        5,3,0,0,57,58,3,4,2,0,58,59,5,4,0,0,59,60,6,1,-1,0,60,62,1,0,0,0,
        61,41,1,0,0,0,61,42,1,0,0,0,61,44,1,0,0,0,61,46,1,0,0,0,61,51,1,
        0,0,0,61,56,1,0,0,0,62,3,1,0,0,0,63,116,1,0,0,0,64,65,3,2,1,0,65,
        66,6,2,-1,0,66,116,1,0,0,0,67,68,3,2,1,0,68,69,5,5,0,0,69,70,3,4,
        2,0,70,71,6,2,-1,0,71,116,1,0,0,0,72,73,3,2,1,0,73,74,5,6,0,0,74,
        75,3,4,2,0,75,76,6,2,-1,0,76,116,1,0,0,0,77,78,3,2,1,0,78,79,5,7,
        0,0,79,80,3,4,2,0,80,81,6,2,-1,0,81,116,1,0,0,0,82,83,3,2,1,0,83,
        84,5,8,0,0,84,85,3,4,2,0,85,86,6,2,-1,0,86,116,1,0,0,0,87,88,5,9,
        0,0,88,89,3,0,0,0,89,90,5,10,0,0,90,91,3,6,3,0,91,92,5,11,0,0,92,
        93,3,4,2,0,93,94,6,2,-1,0,94,116,1,0,0,0,95,96,5,12,0,0,96,97,3,
        0,0,0,97,98,5,10,0,0,98,99,3,6,3,0,99,100,5,13,0,0,100,101,3,4,2,
        0,101,102,6,2,-1,0,102,116,1,0,0,0,103,104,5,14,0,0,104,105,5,29,
        0,0,105,106,5,15,0,0,106,107,3,4,2,0,107,108,6,2,-1,0,108,116,1,
        0,0,0,109,110,5,16,0,0,110,111,5,29,0,0,111,112,5,17,0,0,112,113,
        3,4,2,0,113,114,6,2,-1,0,114,116,1,0,0,0,115,63,1,0,0,0,115,64,1,
        0,0,0,115,67,1,0,0,0,115,72,1,0,0,0,115,77,1,0,0,0,115,82,1,0,0,
        0,115,87,1,0,0,0,115,95,1,0,0,0,115,103,1,0,0,0,115,109,1,0,0,0,
        116,5,1,0,0,0,117,124,1,0,0,0,118,124,3,8,4,0,119,120,3,8,4,0,120,
        121,5,8,0,0,121,122,3,6,3,0,122,124,1,0,0,0,123,117,1,0,0,0,123,
        118,1,0,0,0,123,119,1,0,0,0,124,7,1,0,0,0,125,131,1,0,0,0,126,127,
        3,4,2,0,127,128,5,18,0,0,128,129,3,4,2,0,129,131,1,0,0,0,130,125,
        1,0,0,0,130,126,1,0,0,0,131,9,1,0,0,0,132,196,1,0,0,0,133,134,3,
        12,6,0,134,135,6,5,-1,0,135,196,1,0,0,0,136,137,6,5,-1,0,137,138,
        3,12,6,0,138,139,6,5,-1,0,139,140,5,8,0,0,140,141,6,5,-1,0,141,142,
        3,12,6,0,142,143,6,5,-1,0,143,196,1,0,0,0,144,145,5,19,0,0,145,146,
        6,5,-1,0,146,147,3,10,5,0,147,148,6,5,-1,0,148,149,5,20,0,0,149,
        150,6,5,-1,0,150,151,3,10,5,0,151,152,6,5,-1,0,152,153,5,21,0,0,
        153,154,6,5,-1,0,154,155,3,10,5,0,155,156,6,5,-1,0,156,196,1,0,0,
        0,157,158,6,5,-1,0,158,159,3,12,6,0,159,160,6,5,-1,0,160,161,3,22,
        11,0,161,162,6,5,-1,0,162,196,1,0,0,0,163,164,6,5,-1,0,164,165,3,
        12,6,0,165,166,6,5,-1,0,166,167,3,18,9,0,167,168,6,5,-1,0,168,196,
        1,0,0,0,169,170,6,5,-1,0,170,171,3,12,6,0,171,172,6,5,-1,0,172,173,
        3,20,10,0,173,174,6,5,-1,0,174,196,1,0,0,0,175,176,5,22,0,0,176,
        177,6,5,-1,0,177,178,5,29,0,0,178,179,6,5,-1,0,179,180,3,24,12,0,
        180,181,6,5,-1,0,181,182,5,23,0,0,182,183,6,5,-1,0,183,184,3,10,
        5,0,184,185,6,5,-1,0,185,196,1,0,0,0,186,187,5,24,0,0,187,188,6,
        5,-1,0,188,189,5,3,0,0,189,190,6,5,-1,0,190,191,3,10,5,0,191,192,
        6,5,-1,0,192,193,5,4,0,0,193,194,6,5,-1,0,194,196,1,0,0,0,195,132,
        1,0,0,0,195,133,1,0,0,0,195,136,1,0,0,0,195,144,1,0,0,0,195,157,
        1,0,0,0,195,163,1,0,0,0,195,169,1,0,0,0,195,175,1,0,0,0,195,186,
        1,0,0,0,196,11,1,0,0,0,197,224,1,0,0,0,198,199,5,1,0,0,199,224,6,
        6,-1,0,200,201,5,2,0,0,201,202,6,6,-1,0,202,203,5,29,0,0,203,204,
        6,6,-1,0,204,205,3,10,5,0,205,206,6,6,-1,0,206,224,1,0,0,0,207,208,
        3,16,8,0,208,209,6,6,-1,0,209,224,1,0,0,0,210,211,6,6,-1,0,211,212,
        3,14,7,0,212,213,6,6,-1,0,213,224,1,0,0,0,214,215,5,29,0,0,215,224,
        6,6,-1,0,216,217,5,3,0,0,217,218,6,6,-1,0,218,219,3,10,5,0,219,220,
        6,6,-1,0,220,221,5,4,0,0,221,222,6,6,-1,0,222,224,1,0,0,0,223,197,
        1,0,0,0,223,198,1,0,0,0,223,200,1,0,0,0,223,207,1,0,0,0,223,210,
        1,0,0,0,223,214,1,0,0,0,223,216,1,0,0,0,224,13,1,0,0,0,225,247,1,
        0,0,0,226,227,5,25,0,0,227,228,6,7,-1,0,228,229,3,26,13,0,229,230,
        6,7,-1,0,230,231,5,26,0,0,231,232,6,7,-1,0,232,233,3,10,5,0,233,
        234,6,7,-1,0,234,247,1,0,0,0,235,236,5,25,0,0,236,237,6,7,-1,0,237,
        238,3,26,13,0,238,239,6,7,-1,0,239,240,5,26,0,0,240,241,6,7,-1,0,
        241,242,3,10,5,0,242,243,6,7,-1,0,243,244,3,14,7,0,244,245,6,7,-1,
        0,245,247,1,0,0,0,246,225,1,0,0,0,246,226,1,0,0,0,246,235,1,0,0,
        0,247,15,1,0,0,0,248,270,1,0,0,0,249,250,5,2,0,0,250,251,6,8,-1,
        0,251,252,5,29,0,0,252,253,6,8,-1,0,253,254,5,27,0,0,254,255,6,8,
        -1,0,255,256,3,10,5,0,256,257,6,8,-1,0,257,270,1,0,0,0,258,259,5,
        2,0,0,259,260,6,8,-1,0,260,261,5,29,0,0,261,262,6,8,-1,0,262,263,
        5,27,0,0,263,264,6,8,-1,0,264,265,3,10,5,0,265,266,6,8,-1,0,266,
        267,3,16,8,0,267,268,6,8,-1,0,268,270,1,0,0,0,269,248,1,0,0,0,269,
        249,1,0,0,0,269,258,1,0,0,0,270,17,1,0,0,0,271,289,1,0,0,0,272,273,
        5,3,0,0,273,274,6,9,-1,0,274,275,3,10,5,0,275,276,6,9,-1,0,276,277,
        5,4,0,0,277,278,6,9,-1,0,278,289,1,0,0,0,279,280,5,3,0,0,280,281,
        6,9,-1,0,281,282,3,10,5,0,282,283,6,9,-1,0,283,284,5,4,0,0,284,285,
        6,9,-1,0,285,286,3,18,9,0,286,287,6,9,-1,0,287,289,1,0,0,0,288,271,
        1,0,0,0,288,272,1,0,0,0,288,279,1,0,0,0,289,19,1,0,0,0,290,304,1,
        0,0,0,291,292,5,28,0,0,292,293,6,10,-1,0,293,294,3,10,5,0,294,295,
        6,10,-1,0,295,304,1,0,0,0,296,297,5,28,0,0,297,298,6,10,-1,0,298,
        299,3,10,5,0,299,300,6,10,-1,0,300,301,3,20,10,0,301,302,6,10,-1,
        0,302,304,1,0,0,0,303,290,1,0,0,0,303,291,1,0,0,0,303,296,1,0,0,
        0,304,21,1,0,0,0,305,318,1,0,0,0,306,307,5,10,0,0,307,308,6,11,-1,
        0,308,309,5,29,0,0,309,318,6,11,-1,0,310,311,5,10,0,0,311,312,6,
        11,-1,0,312,313,5,29,0,0,313,314,6,11,-1,0,314,315,3,22,11,0,315,
        316,6,11,-1,0,316,318,1,0,0,0,317,305,1,0,0,0,317,306,1,0,0,0,317,
        310,1,0,0,0,318,23,1,0,0,0,319,326,1,0,0,0,320,321,5,27,0,0,321,
        322,6,12,-1,0,322,323,3,10,5,0,323,324,6,12,-1,0,324,326,1,0,0,0,
        325,319,1,0,0,0,325,320,1,0,0,0,326,25,1,0,0,0,327,340,1,0,0,0,328,
        329,3,28,14,0,329,330,6,13,-1,0,330,340,1,0,0,0,331,332,6,13,-1,
        0,332,333,3,12,6,0,333,334,6,13,-1,0,334,335,5,8,0,0,335,336,6,13,
        -1,0,336,337,3,12,6,0,337,338,6,13,-1,0,338,340,1,0,0,0,339,327,
        1,0,0,0,339,328,1,0,0,0,339,331,1,0,0,0,340,27,1,0,0,0,341,359,1,
        0,0,0,342,343,5,29,0,0,343,359,6,14,-1,0,344,345,5,29,0,0,345,359,
        6,14,-1,0,346,347,5,1,0,0,347,359,6,14,-1,0,348,349,5,2,0,0,349,
        350,6,14,-1,0,350,351,5,29,0,0,351,352,6,14,-1,0,352,353,3,26,13,
        0,353,354,6,14,-1,0,354,359,1,0,0,0,355,356,3,30,15,0,356,357,6,
        14,-1,0,357,359,1,0,0,0,358,341,1,0,0,0,358,342,1,0,0,0,358,344,
        1,0,0,0,358,346,1,0,0,0,358,348,1,0,0,0,358,355,1,0,0,0,359,29,1,
        0,0,0,360,382,1,0,0,0,361,362,5,2,0,0,362,363,6,15,-1,0,363,364,
        5,29,0,0,364,365,6,15,-1,0,365,366,5,27,0,0,366,367,6,15,-1,0,367,
        368,3,26,13,0,368,369,6,15,-1,0,369,382,1,0,0,0,370,371,5,2,0,0,
        371,372,6,15,-1,0,372,373,5,29,0,0,373,374,6,15,-1,0,374,375,5,27,
        0,0,375,376,6,15,-1,0,376,377,3,26,13,0,377,378,6,15,-1,0,378,379,
        3,30,15,0,379,380,6,15,-1,0,380,382,1,0,0,0,381,360,1,0,0,0,381,
        361,1,0,0,0,381,370,1,0,0,0,382,31,1,0,0,0,16,39,61,115,123,130,
        195,223,246,269,288,303,317,325,339,358,381
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'@'", "':'", "'('", "')'", "'|'", "'&'", 
                     "'->'", "','", "'{'", "'.'", "'}'", "'['", "']'", "'least'", 
                     "'with'", "'greatest'", "'of'", "'<:'", "'if'", "'then'", 
                     "'else'", "'let'", "';'", "'fix'", "'case'", "'=>'", 
                     "'='", "'|>'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "ID", "INT", "WS" ]

    RULE_ids = 0
    RULE_typ_base = 1
    RULE_typ = 2
    RULE_qualification = 3
    RULE_subtyping = 4
    RULE_expr = 5
    RULE_base = 6
    RULE_function = 7
    RULE_record = 8
    RULE_argchain = 9
    RULE_pipeline = 10
    RULE_keychain = 11
    RULE_target = 12
    RULE_pattern = 13
    RULE_pattern_base = 14
    RULE_pattern_record = 15

    ruleNames =  [ "ids", "typ_base", "typ", "qualification", "subtyping", 
                   "expr", "base", "function", "record", "argchain", "pipeline", 
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
    T__16=17
    T__17=18
    T__18=19
    T__19=20
    T__20=21
    T__21=22
    T__22=23
    T__23=24
    T__24=25
    T__25=26
    T__26=27
    T__27=28
    ID=29
    INT=30
    WS=31

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
        self._guidance = nt_default 
        self._overflow = False  

    def reset(self): 
        self._guidance = nt_default
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()



    def getGuidance(self):
        return self._guidance

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def guide_nonterm(self, f : Callable, *args) -> Optional[Nonterm]:
        for arg in args:
            if arg == None:
                self._overflow = True

        nt_result = None
        if not self._overflow:
            nt_result = f(*args)
            self._guidance = nt_result

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return nt_result 



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




    class IdsContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None
            self._ID = None # Token
            self._ids = None # IdsContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def ids(self):
            return self.getTypedRuleContext(SlimParser.IdsContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_ids

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterIds" ):
                listener.enterIds(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitIds" ):
                listener.exitIds(self)




    def ids(self):

        localctx = SlimParser.IdsContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_ids)
        try:
            self.state = 39
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 33
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = [(None if localctx._ID is None else localctx._ID.text)]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 35
                localctx._ID = self.match(SlimParser.ID)
                self.state = 36
                localctx._ids = self.ids()

                localctx.combo = [(None if localctx._ID is None else localctx._ID.text)] ++ localctx._ids.combo

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Typ_baseContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None
            self._ID = None # Token
            self._typ_base = None # Typ_baseContext
            self._typ = None # TypContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def typ_base(self):
            return self.getTypedRuleContext(SlimParser.Typ_baseContext,0)


        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_typ_base

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTyp_base" ):
                listener.enterTyp_base(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTyp_base" ):
                listener.exitTyp_base(self)




    def typ_base(self):

        localctx = SlimParser.Typ_baseContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_typ_base)
        try:
            self.state = 61
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 42
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = TVar((None if localctx._ID is None else localctx._ID.text)) 

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 44
                self.match(SlimParser.T__0)

                localctx.combo = TUnit() 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 46
                self.match(SlimParser.T__1)
                self.state = 47
                localctx._ID = self.match(SlimParser.ID)
                self.state = 48
                localctx._typ_base = self.typ_base()

                localctx.combo = TTag((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 51
                localctx._ID = self.match(SlimParser.ID)
                self.state = 52
                self.match(SlimParser.T__1)
                self.state = 53
                localctx._typ_base = self.typ_base()

                localctx.combo = TField((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 56
                self.match(SlimParser.T__2)
                self.state = 57
                localctx._typ = self.typ()
                self.state = 58
                self.match(SlimParser.T__3)

                localctx.combo = localctx._typ.combo   

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class TypContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None
            self._typ_base = None # Typ_baseContext
            self._typ = None # TypContext
            self._ids = None # IdsContext
            self._qualification = None # QualificationContext
            self._ID = None # Token

        def typ_base(self):
            return self.getTypedRuleContext(SlimParser.Typ_baseContext,0)


        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


        def ids(self):
            return self.getTypedRuleContext(SlimParser.IdsContext,0)


        def qualification(self):
            return self.getTypedRuleContext(SlimParser.QualificationContext,0)


        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def getRuleIndex(self):
            return SlimParser.RULE_typ

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTyp" ):
                listener.enterTyp(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTyp" ):
                listener.exitTyp(self)




    def typ(self):

        localctx = SlimParser.TypContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_typ)
        try:
            self.state = 115
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 64
                localctx._typ_base = self.typ_base()

                localctx.combo = localctx._typ_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 67
                localctx._typ_base = self.typ_base()
                self.state = 68
                self.match(SlimParser.T__4)
                self.state = 69
                localctx._typ = self.typ()

                localctx.combo = Unio(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 72
                localctx._typ_base = self.typ_base()
                self.state = 73
                self.match(SlimParser.T__5)
                self.state = 74
                localctx._typ = self.typ()

                localctx.combo = Inter(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 77
                localctx._typ_base = self.typ_base()
                self.state = 78
                self.match(SlimParser.T__6)
                self.state = 79
                localctx._typ = self.typ()

                localctx.combo = Imp(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 82
                localctx._typ_base = self.typ_base()
                self.state = 83
                self.match(SlimParser.T__7)
                self.state = 84
                localctx._typ = self.typ()

                localctx.combo = Inter(TField('left', localctx._typ_base.combo), TField('right', localctx._typ.combo)) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 87
                self.match(SlimParser.T__8)
                self.state = 88
                localctx._ids = self.ids()
                self.state = 89
                self.match(SlimParser.T__9)
                self.state = 90
                localctx._qualification = self.qualification()
                self.state = 91
                self.match(SlimParser.T__10)
                self.state = 92
                localctx._typ = self.typ()

                localctx.combo = IdxUnio(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 95
                self.match(SlimParser.T__11)
                self.state = 96
                localctx._ids = self.ids()
                self.state = 97
                self.match(SlimParser.T__9)
                self.state = 98
                localctx._qualification = self.qualification()
                self.state = 99
                self.match(SlimParser.T__12)
                self.state = 100
                localctx._typ = self.typ()

                localctx.combo = IdxInter(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 103
                self.match(SlimParser.T__13)
                self.state = 104
                localctx._ID = self.match(SlimParser.ID)
                self.state = 105
                self.match(SlimParser.T__14)
                self.state = 106
                localctx._typ = self.typ()

                localctx.combo = Least((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 109
                self.match(SlimParser.T__15)
                self.state = 110
                localctx._ID = self.match(SlimParser.ID)
                self.state = 111
                self.match(SlimParser.T__16)
                self.state = 112
                localctx._typ = self.typ()

                localctx.combo = Greatest((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo) 

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class QualificationContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None

        def subtyping(self):
            return self.getTypedRuleContext(SlimParser.SubtypingContext,0)


        def qualification(self):
            return self.getTypedRuleContext(SlimParser.QualificationContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_qualification

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterQualification" ):
                listener.enterQualification(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitQualification" ):
                listener.exitQualification(self)




    def qualification(self):

        localctx = SlimParser.QualificationContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_qualification)
        try:
            self.state = 123
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 118
                self.subtyping()
                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 119
                self.subtyping()
                self.state = 120
                self.match(SlimParser.T__7)
                self.state = 121
                self.qualification()
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class SubtypingContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None

        def typ(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.TypContext)
            else:
                return self.getTypedRuleContext(SlimParser.TypContext,i)


        def getRuleIndex(self):
            return SlimParser.RULE_subtyping

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterSubtyping" ):
                listener.enterSubtyping(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitSubtyping" ):
                listener.exitSubtyping(self)




    def subtyping(self):

        localctx = SlimParser.SubtypingContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_subtyping)
        try:
            self.state = 130
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 126
                self.typ()
                self.state = 127
                self.match(SlimParser.T__17)
                self.state = 128
                self.typ()
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ExprContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._base = None # BaseContext
            self.head = None # BaseContext
            self.tail = None # BaseContext
            self.condition = None # ExprContext
            self.branch_true = None # ExprContext
            self.branch_false = None # ExprContext
            self.cator = None # BaseContext
            self._keychain = None # KeychainContext
            self._argchain = None # ArgchainContext
            self._pipeline = None # PipelineContext
            self._ID = None # Token
            self._target = None # TargetContext
            self.contin = None # ExprContext
            self.body = None # ExprContext
            self.nt = nt

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




    def expr(self, nt:Nonterm):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 10, self.RULE_expr)
        try:
            self.state = 195
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 133
                localctx._base = self.base(nt)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

                self.state = 137
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 139
                self.match(SlimParser.T__7)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 141
                localctx.tail = self.base(nt)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 144
                self.match(SlimParser.T__18)

                nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

                self.state = 146
                localctx.condition = self.expr(nt_condition)

                self.guide_symbol('then')

                self.state = 148
                self.match(SlimParser.T__19)

                nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, localctx.condition.combo)

                self.state = 150
                localctx.branch_true = self.expr(nt_branch_true)

                self.guide_symbol('else')

                self.state = 152
                self.match(SlimParser.T__20)

                nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, localctx.condition.combo, localctx.branch_true.combo)

                self.state = 154
                localctx.branch_false = self.expr(nt_branch_false)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, localctx.condition.combo, localctx.branch_true.combo, localctx.branch_false.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

                self.state = 158
                localctx.cator = self.base(nt_cator)

                nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, localctx.cator.combo)

                self.state = 160
                localctx._keychain = self.keychain(nt_keychain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, localctx.cator.combo, localctx._keychain.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

                self.state = 164
                localctx.cator = self.base(nt_cator)

                nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, localctx.cator.combo)

                self.state = 166
                localctx._argchain = self.argchain(nt_argchain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, localctx.cator.combo, localctx._argchain.combo)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

                self.state = 170
                localctx.cator = self.base(nt_arg)

                nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 172
                localctx._pipeline = self.pipeline(nt_pipeline)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, localctx.cator.combo, localctx._pipeline.combo)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 175
                self.match(SlimParser.T__21)

                self.guide_terminal('ID')

                self.state = 177
                localctx._ID = self.match(SlimParser.ID)

                nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 179
                localctx._target = self.target(nt_target)

                self.guide_symbol(';')

                self.state = 181
                self.match(SlimParser.T__22)

                nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 183
                localctx.contin = self.expr(nt_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 186
                self.match(SlimParser.T__23)

                self.guide_symbol('(')

                self.state = 188
                self.match(SlimParser.T__2)

                nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

                self.state = 190
                localctx.body = self.expr(nt_body)

                self.guide_symbol(')')

                self.state = 192
                self.match(SlimParser.T__3)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_fix, localctx.body.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._expr = None # ExprContext
            self.nt = nt

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




    def base(self, nt:Nonterm):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 12, self.RULE_base)
        try:
            self.state = 223
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 198
                self.match(SlimParser.T__0)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 200
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 202
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 204
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 207
                localctx._record = self.record(nt)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 211
                localctx._function = self.function(nt)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 214
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 216
                self.match(SlimParser.T__2)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 218
                localctx._expr = self.expr(nt_expr)

                self.guide_symbol(')')

                self.state = 220
                self.match(SlimParser.T__3)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self.tail = None # FunctionContext
            self.nt = nt

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




    def function(self, nt:Nonterm):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 14, self.RULE_function)
        try:
            self.state = 246
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 226
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

                self.state = 228
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 230
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, localctx._pattern.combo)

                self.state = 232
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 235
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

                self.state = 237
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 239
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, localctx._pattern.combo)

                self.state = 241
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 243
                localctx.tail = self.function(nt)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_cons, localctx._pattern.combo, localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.tail = None # RecordContext
            self.nt = nt

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




    def record(self, nt:Nonterm):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 16, self.RULE_record)
        try:
            self.state = 269
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 249
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 251
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 253
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 255
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 258
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 260
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 262
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 264
                localctx.body = self.expr(nt)

                nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 266
                localctx.tail = self.record(nt)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.nt = nt

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




    def argchain(self, nt:Nonterm):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 18, self.RULE_argchain)
        try:
            self.state = 288
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 272
                self.match(SlimParser.T__2)

                nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

                self.state = 274
                localctx.content = self.expr(nt_content)

                self.guide_symbol(')')

                self.state = 276
                self.match(SlimParser.T__3)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 279
                self.match(SlimParser.T__2)

                nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

                self.state = 281
                localctx.head = self.expr(nt_head)

                self.guide_symbol(')')

                self.state = 283
                self.match(SlimParser.T__3)

                nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 285
                localctx.tail = self.argchain(nt_tail)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_cons, localctx.head.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # PipelineContext
            self.nt = nt

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




    def pipeline(self, nt:Nonterm):

        localctx = SlimParser.PipelineContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 20, self.RULE_pipeline)
        try:
            self.state = 303
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 291
                self.match(SlimParser.T__27)

                nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

                self.state = 293
                localctx.content = self.expr(nt_content)

                localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 296
                self.match(SlimParser.T__27)

                nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

                self.state = 298
                localctx.head = self.expr(nt_head)

                nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 300
                localctx.tail = self.pipeline(nt_tail)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_cons, localctx.head.combo, localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._ID = None # Token
            self.tail = None # KeychainContext
            self.nt = nt

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




    def keychain(self, nt:Nonterm):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 22, self.RULE_keychain)
        try:
            self.state = 317
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 306
                self.match(SlimParser.T__9)

                self.guide_terminal('ID')

                self.state = 308
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 310
                self.match(SlimParser.T__9)

                self.guide_terminal('ID')

                self.state = 312
                localctx._ID = self.match(SlimParser.ID)

                nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 314
                localctx.tail = self.keychain(nt_tail)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.tail.combo)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._expr = None # ExprContext
            self.nt = nt

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




    def target(self, nt:Nonterm):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 24, self.RULE_target)
        try:
            self.state = 325
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [23]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [27]:
                self.enterOuterAlt(localctx, 2)
                self.state = 320
                self.match(SlimParser.T__26)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 322
                localctx._expr = self.expr(nt_expr)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._pattern_base = None # Pattern_baseContext
            self.head = None # BaseContext
            self.tail = None # BaseContext
            self.nt = nt

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




    def pattern(self, nt:Nonterm):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 26, self.RULE_pattern)
        try:
            self.state = 339
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 328
                localctx._pattern_base = self.pattern_base(nt)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_head)

                self.state = 332
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 334
                self.match(SlimParser.T__7)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 336
                localctx.tail = self.base(nt)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self._pattern_record = None # Pattern_recordContext
            self.nt = nt

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




    def pattern_base(self, nt:Nonterm):

        localctx = SlimParser.Pattern_baseContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 28, self.RULE_pattern_base)
        try:
            self.state = 358
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 342
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 344
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 346
                self.match(SlimParser.T__0)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 348
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 350
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 352
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 355
                localctx._pattern_record = self.pattern_record(nt)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.combo = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # Pattern_recordContext
            self.nt = nt

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




    def pattern_record(self, nt:Nonterm):

        localctx = SlimParser.Pattern_recordContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 30, self.RULE_pattern_record)
        try:
            self.state = 381
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 361
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 363
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 365
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 367
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 370
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 372
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 374
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 376
                localctx.body = self.pattern(nt_body)

                nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 378
                localctx.tail = self.pattern_record(nt_tail)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_cons, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo, localctx.tail.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





