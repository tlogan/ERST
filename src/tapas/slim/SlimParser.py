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
        4,1,32,366,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,40,8,0,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,54,8,1,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,
        1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,98,8,2,1,3,1,3,1,3,1,3,1,3,1,3,3,
        3,106,8,3,1,4,1,4,1,4,1,4,1,4,3,4,113,8,4,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,178,8,5,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,206,8,6,1,7,1,7,1,7,1,7,1,7,1,7,1,
        7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,3,7,229,
        8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
        1,8,1,8,1,8,1,8,1,8,1,8,3,8,252,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,
        1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,271,8,9,1,10,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,286,8,
        10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,3,
        11,300,8,11,1,12,1,12,1,12,1,12,1,12,1,12,3,12,308,8,12,1,13,1,13,
        1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,3,13,322,8,13,
        1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,
        1,14,1,14,1,14,1,14,3,14,341,8,14,1,15,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,3,15,364,8,15,1,15,0,0,16,0,2,4,6,8,10,12,14,16,18,20,
        22,24,26,28,30,0,0,401,0,39,1,0,0,0,2,53,1,0,0,0,4,97,1,0,0,0,6,
        105,1,0,0,0,8,112,1,0,0,0,10,177,1,0,0,0,12,205,1,0,0,0,14,228,1,
        0,0,0,16,251,1,0,0,0,18,270,1,0,0,0,20,285,1,0,0,0,22,299,1,0,0,
        0,24,307,1,0,0,0,26,321,1,0,0,0,28,340,1,0,0,0,30,363,1,0,0,0,32,
        40,1,0,0,0,33,34,5,30,0,0,34,40,6,0,-1,0,35,36,5,30,0,0,36,37,3,
        0,0,0,37,38,6,0,-1,0,38,40,1,0,0,0,39,32,1,0,0,0,39,33,1,0,0,0,39,
        35,1,0,0,0,40,1,1,0,0,0,41,54,1,0,0,0,42,54,5,1,0,0,43,44,5,30,0,
        0,44,45,5,2,0,0,45,54,3,4,2,0,46,47,5,2,0,0,47,48,5,30,0,0,48,54,
        3,4,2,0,49,50,5,3,0,0,50,51,3,4,2,0,51,52,5,4,0,0,52,54,1,0,0,0,
        53,41,1,0,0,0,53,42,1,0,0,0,53,43,1,0,0,0,53,46,1,0,0,0,53,49,1,
        0,0,0,54,3,1,0,0,0,55,98,1,0,0,0,56,57,3,2,1,0,57,58,6,2,-1,0,58,
        98,1,0,0,0,59,60,3,2,1,0,60,61,5,5,0,0,61,62,3,4,2,0,62,98,1,0,0,
        0,63,64,3,2,1,0,64,65,5,6,0,0,65,66,3,4,2,0,66,98,1,0,0,0,67,68,
        3,2,1,0,68,69,5,7,0,0,69,70,3,4,2,0,70,98,1,0,0,0,71,72,3,2,1,0,
        72,73,5,8,0,0,73,74,3,4,2,0,74,98,1,0,0,0,75,76,5,9,0,0,76,77,3,
        0,0,0,77,78,5,10,0,0,78,79,3,6,3,0,79,80,5,11,0,0,80,81,3,4,2,0,
        81,98,1,0,0,0,82,83,5,12,0,0,83,84,3,0,0,0,84,85,5,10,0,0,85,86,
        3,6,3,0,86,87,5,13,0,0,87,88,3,4,2,0,88,98,1,0,0,0,89,90,5,14,0,
        0,90,91,5,30,0,0,91,92,5,15,0,0,92,98,3,4,2,0,93,94,5,16,0,0,94,
        95,5,30,0,0,95,96,5,17,0,0,96,98,3,4,2,0,97,55,1,0,0,0,97,56,1,0,
        0,0,97,59,1,0,0,0,97,63,1,0,0,0,97,67,1,0,0,0,97,71,1,0,0,0,97,75,
        1,0,0,0,97,82,1,0,0,0,97,89,1,0,0,0,97,93,1,0,0,0,98,5,1,0,0,0,99,
        106,1,0,0,0,100,106,3,8,4,0,101,102,3,8,4,0,102,103,5,8,0,0,103,
        104,3,6,3,0,104,106,1,0,0,0,105,99,1,0,0,0,105,100,1,0,0,0,105,101,
        1,0,0,0,106,7,1,0,0,0,107,113,1,0,0,0,108,109,3,4,2,0,109,110,5,
        18,0,0,110,111,3,4,2,0,111,113,1,0,0,0,112,107,1,0,0,0,112,108,1,
        0,0,0,113,9,1,0,0,0,114,178,1,0,0,0,115,116,3,12,6,0,116,117,6,5,
        -1,0,117,178,1,0,0,0,118,119,6,5,-1,0,119,120,3,12,6,0,120,121,6,
        5,-1,0,121,122,5,8,0,0,122,123,6,5,-1,0,123,124,3,12,6,0,124,125,
        6,5,-1,0,125,178,1,0,0,0,126,127,5,19,0,0,127,128,6,5,-1,0,128,129,
        3,10,5,0,129,130,6,5,-1,0,130,131,5,20,0,0,131,132,6,5,-1,0,132,
        133,3,10,5,0,133,134,6,5,-1,0,134,135,5,21,0,0,135,136,6,5,-1,0,
        136,137,3,10,5,0,137,138,6,5,-1,0,138,178,1,0,0,0,139,140,6,5,-1,
        0,140,141,3,12,6,0,141,142,6,5,-1,0,142,143,3,22,11,0,143,144,6,
        5,-1,0,144,178,1,0,0,0,145,146,6,5,-1,0,146,147,3,12,6,0,147,148,
        6,5,-1,0,148,149,3,18,9,0,149,150,6,5,-1,0,150,178,1,0,0,0,151,152,
        6,5,-1,0,152,153,3,12,6,0,153,154,6,5,-1,0,154,155,3,20,10,0,155,
        156,6,5,-1,0,156,178,1,0,0,0,157,158,5,22,0,0,158,159,6,5,-1,0,159,
        160,5,30,0,0,160,161,6,5,-1,0,161,162,3,24,12,0,162,163,6,5,-1,0,
        163,164,5,23,0,0,164,165,6,5,-1,0,165,166,3,10,5,0,166,167,6,5,-1,
        0,167,178,1,0,0,0,168,169,5,24,0,0,169,170,6,5,-1,0,170,171,5,3,
        0,0,171,172,6,5,-1,0,172,173,3,10,5,0,173,174,6,5,-1,0,174,175,5,
        4,0,0,175,176,6,5,-1,0,176,178,1,0,0,0,177,114,1,0,0,0,177,115,1,
        0,0,0,177,118,1,0,0,0,177,126,1,0,0,0,177,139,1,0,0,0,177,145,1,
        0,0,0,177,151,1,0,0,0,177,157,1,0,0,0,177,168,1,0,0,0,178,11,1,0,
        0,0,179,206,1,0,0,0,180,181,5,25,0,0,181,206,6,6,-1,0,182,183,5,
        2,0,0,183,184,6,6,-1,0,184,185,5,30,0,0,185,186,6,6,-1,0,186,187,
        3,10,5,0,187,188,6,6,-1,0,188,206,1,0,0,0,189,190,3,16,8,0,190,191,
        6,6,-1,0,191,206,1,0,0,0,192,193,6,6,-1,0,193,194,3,14,7,0,194,195,
        6,6,-1,0,195,206,1,0,0,0,196,197,5,30,0,0,197,206,6,6,-1,0,198,199,
        5,3,0,0,199,200,6,6,-1,0,200,201,3,10,5,0,201,202,6,6,-1,0,202,203,
        5,4,0,0,203,204,6,6,-1,0,204,206,1,0,0,0,205,179,1,0,0,0,205,180,
        1,0,0,0,205,182,1,0,0,0,205,189,1,0,0,0,205,192,1,0,0,0,205,196,
        1,0,0,0,205,198,1,0,0,0,206,13,1,0,0,0,207,229,1,0,0,0,208,209,5,
        26,0,0,209,210,6,7,-1,0,210,211,3,26,13,0,211,212,6,7,-1,0,212,213,
        5,27,0,0,213,214,6,7,-1,0,214,215,3,10,5,0,215,216,6,7,-1,0,216,
        229,1,0,0,0,217,218,5,26,0,0,218,219,6,7,-1,0,219,220,3,26,13,0,
        220,221,6,7,-1,0,221,222,5,27,0,0,222,223,6,7,-1,0,223,224,3,10,
        5,0,224,225,6,7,-1,0,225,226,3,14,7,0,226,227,6,7,-1,0,227,229,1,
        0,0,0,228,207,1,0,0,0,228,208,1,0,0,0,228,217,1,0,0,0,229,15,1,0,
        0,0,230,252,1,0,0,0,231,232,5,2,0,0,232,233,6,8,-1,0,233,234,5,30,
        0,0,234,235,6,8,-1,0,235,236,5,28,0,0,236,237,6,8,-1,0,237,238,3,
        10,5,0,238,239,6,8,-1,0,239,252,1,0,0,0,240,241,5,2,0,0,241,242,
        6,8,-1,0,242,243,5,30,0,0,243,244,6,8,-1,0,244,245,5,28,0,0,245,
        246,6,8,-1,0,246,247,3,10,5,0,247,248,6,8,-1,0,248,249,3,16,8,0,
        249,250,6,8,-1,0,250,252,1,0,0,0,251,230,1,0,0,0,251,231,1,0,0,0,
        251,240,1,0,0,0,252,17,1,0,0,0,253,271,1,0,0,0,254,255,5,3,0,0,255,
        256,6,9,-1,0,256,257,3,10,5,0,257,258,6,9,-1,0,258,259,5,4,0,0,259,
        260,6,9,-1,0,260,271,1,0,0,0,261,262,5,3,0,0,262,263,6,9,-1,0,263,
        264,3,10,5,0,264,265,6,9,-1,0,265,266,5,4,0,0,266,267,6,9,-1,0,267,
        268,3,18,9,0,268,269,6,9,-1,0,269,271,1,0,0,0,270,253,1,0,0,0,270,
        254,1,0,0,0,270,261,1,0,0,0,271,19,1,0,0,0,272,286,1,0,0,0,273,274,
        5,29,0,0,274,275,6,10,-1,0,275,276,3,10,5,0,276,277,6,10,-1,0,277,
        286,1,0,0,0,278,279,5,29,0,0,279,280,6,10,-1,0,280,281,3,10,5,0,
        281,282,6,10,-1,0,282,283,3,20,10,0,283,284,6,10,-1,0,284,286,1,
        0,0,0,285,272,1,0,0,0,285,273,1,0,0,0,285,278,1,0,0,0,286,21,1,0,
        0,0,287,300,1,0,0,0,288,289,5,10,0,0,289,290,6,11,-1,0,290,291,5,
        30,0,0,291,300,6,11,-1,0,292,293,5,10,0,0,293,294,6,11,-1,0,294,
        295,5,30,0,0,295,296,6,11,-1,0,296,297,3,22,11,0,297,298,6,11,-1,
        0,298,300,1,0,0,0,299,287,1,0,0,0,299,288,1,0,0,0,299,292,1,0,0,
        0,300,23,1,0,0,0,301,308,1,0,0,0,302,303,5,28,0,0,303,304,6,12,-1,
        0,304,305,3,10,5,0,305,306,6,12,-1,0,306,308,1,0,0,0,307,301,1,0,
        0,0,307,302,1,0,0,0,308,25,1,0,0,0,309,322,1,0,0,0,310,311,3,28,
        14,0,311,312,6,13,-1,0,312,322,1,0,0,0,313,314,6,13,-1,0,314,315,
        3,12,6,0,315,316,6,13,-1,0,316,317,5,8,0,0,317,318,6,13,-1,0,318,
        319,3,12,6,0,319,320,6,13,-1,0,320,322,1,0,0,0,321,309,1,0,0,0,321,
        310,1,0,0,0,321,313,1,0,0,0,322,27,1,0,0,0,323,341,1,0,0,0,324,325,
        5,30,0,0,325,341,6,14,-1,0,326,327,5,30,0,0,327,341,6,14,-1,0,328,
        329,5,25,0,0,329,341,6,14,-1,0,330,331,5,2,0,0,331,332,6,14,-1,0,
        332,333,5,30,0,0,333,334,6,14,-1,0,334,335,3,26,13,0,335,336,6,14,
        -1,0,336,341,1,0,0,0,337,338,3,30,15,0,338,339,6,14,-1,0,339,341,
        1,0,0,0,340,323,1,0,0,0,340,324,1,0,0,0,340,326,1,0,0,0,340,328,
        1,0,0,0,340,330,1,0,0,0,340,337,1,0,0,0,341,29,1,0,0,0,342,364,1,
        0,0,0,343,344,5,2,0,0,344,345,6,15,-1,0,345,346,5,30,0,0,346,347,
        6,15,-1,0,347,348,5,28,0,0,348,349,6,15,-1,0,349,350,3,26,13,0,350,
        351,6,15,-1,0,351,364,1,0,0,0,352,353,5,2,0,0,353,354,6,15,-1,0,
        354,355,5,30,0,0,355,356,6,15,-1,0,356,357,5,28,0,0,357,358,6,15,
        -1,0,358,359,3,26,13,0,359,360,6,15,-1,0,360,361,3,30,15,0,361,362,
        6,15,-1,0,362,364,1,0,0,0,363,342,1,0,0,0,363,343,1,0,0,0,363,352,
        1,0,0,0,364,31,1,0,0,0,16,39,53,97,105,112,177,205,228,251,270,285,
        299,307,321,340,363
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'unit'", "':'", "'('", "')'", "'|'", 
                     "'&'", "'->'", "','", "'{'", "'.'", "'}'", "'['", "']'", 
                     "'least'", "'with'", "'greatest'", "'of'", "'<:'", 
                     "'if'", "'then'", "'else'", "'let'", "';'", "'fix'", 
                     "'@'", "'case'", "'=>'", "'='", "'|>'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "ID", "INT", "WS" ]

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
    T__28=29
    ID=30
    INT=31
    WS=32

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

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

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
            self.state = 53
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4, 5, 6, 7, 8, 11, 13, 18]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1]:
                self.enterOuterAlt(localctx, 2)
                self.state = 42
                self.match(SlimParser.T__0)
                pass
            elif token in [30]:
                self.enterOuterAlt(localctx, 3)
                self.state = 43
                self.match(SlimParser.ID)
                self.state = 44
                self.match(SlimParser.T__1)
                self.state = 45
                self.typ()
                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 4)
                self.state = 46
                self.match(SlimParser.T__1)
                self.state = 47
                self.match(SlimParser.ID)
                self.state = 48
                self.typ()
                pass
            elif token in [3]:
                self.enterOuterAlt(localctx, 5)
                self.state = 49
                self.match(SlimParser.T__2)
                self.state = 50
                self.typ()
                self.state = 51
                self.match(SlimParser.T__3)
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


    class TypContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.combo = None
            self._typ_base = None # Typ_baseContext

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
            self.state = 97
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 56
                localctx._typ_base = self.typ_base()

                localctx.combo = localctx._typ_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 59
                self.typ_base()
                self.state = 60
                self.match(SlimParser.T__4)
                self.state = 61
                self.typ()
                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 63
                self.typ_base()
                self.state = 64
                self.match(SlimParser.T__5)
                self.state = 65
                self.typ()
                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 67
                self.typ_base()
                self.state = 68
                self.match(SlimParser.T__6)
                self.state = 69
                self.typ()
                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 71
                self.typ_base()
                self.state = 72
                self.match(SlimParser.T__7)
                self.state = 73
                self.typ()
                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 75
                self.match(SlimParser.T__8)
                self.state = 76
                self.ids()
                self.state = 77
                self.match(SlimParser.T__9)
                self.state = 78
                self.qualification()
                self.state = 79
                self.match(SlimParser.T__10)
                self.state = 80
                self.typ()
                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 82
                self.match(SlimParser.T__11)
                self.state = 83
                self.ids()
                self.state = 84
                self.match(SlimParser.T__9)
                self.state = 85
                self.qualification()
                self.state = 86
                self.match(SlimParser.T__12)
                self.state = 87
                self.typ()
                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 89
                self.match(SlimParser.T__13)
                self.state = 90
                self.match(SlimParser.ID)
                self.state = 91
                self.match(SlimParser.T__14)
                self.state = 92
                self.typ()
                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 93
                self.match(SlimParser.T__15)
                self.state = 94
                self.match(SlimParser.ID)
                self.state = 95
                self.match(SlimParser.T__16)
                self.state = 96
                self.typ()
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
            self.state = 105
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 100
                self.subtyping()
                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 101
                self.subtyping()
                self.state = 102
                self.match(SlimParser.T__7)
                self.state = 103
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
            self.state = 112
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 108
                self.typ()
                self.state = 109
                self.match(SlimParser.T__17)
                self.state = 110
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
            self.state = 177
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 115
                localctx._base = self.base(nt)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

                self.state = 119
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 121
                self.match(SlimParser.T__7)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 123
                localctx.tail = self.base(nt)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 126
                self.match(SlimParser.T__18)

                nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

                self.state = 128
                localctx.condition = self.expr(nt_condition)

                self.guide_symbol('then')

                self.state = 130
                self.match(SlimParser.T__19)

                nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, localctx.condition.combo)

                self.state = 132
                localctx.branch_true = self.expr(nt_branch_true)

                self.guide_symbol('else')

                self.state = 134
                self.match(SlimParser.T__20)

                nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, localctx.condition.combo, localctx.branch_true.combo)

                self.state = 136
                localctx.branch_false = self.expr(nt_branch_false)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, localctx.condition.combo, localctx.branch_true.combo, localctx.branch_false.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

                self.state = 140
                localctx.cator = self.base(nt_cator)

                nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, localctx.cator.combo)

                self.state = 142
                localctx._keychain = self.keychain(nt_keychain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, localctx.cator.combo, localctx._keychain.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

                self.state = 146
                localctx.cator = self.base(nt_cator)

                nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, localctx.cator.combo)

                self.state = 148
                localctx._argchain = self.argchain(nt_argchain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, localctx.cator.combo, localctx._argchain.combo)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

                self.state = 152
                localctx.cator = self.base(nt_arg)

                nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 154
                localctx._pipeline = self.pipeline(nt_pipeline)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, localctx.cator.combo, localctx._pipeline.combo)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 157
                self.match(SlimParser.T__21)

                self.guide_terminal('ID')

                self.state = 159
                localctx._ID = self.match(SlimParser.ID)

                nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 161
                localctx._target = self.target(nt_target)

                self.guide_symbol(';')

                self.state = 163
                self.match(SlimParser.T__22)

                nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 165
                localctx.contin = self.expr(nt_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 168
                self.match(SlimParser.T__23)

                self.guide_symbol('(')

                self.state = 170
                self.match(SlimParser.T__2)

                nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

                self.state = 172
                localctx.body = self.expr(nt_body)

                self.guide_symbol(')')

                self.state = 174
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
            self.state = 205
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 180
                self.match(SlimParser.T__24)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 182
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 184
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 186
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 189
                localctx._record = self.record(nt)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 193
                localctx._function = self.function(nt)

                localctx.combo = localctx._function.combo

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 196
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 198
                self.match(SlimParser.T__2)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 200
                localctx._expr = self.expr(nt_expr)

                self.guide_symbol(')')

                self.state = 202
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
            self.state = 228
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 208
                self.match(SlimParser.T__25)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

                self.state = 210
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 212
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, localctx._pattern.combo)

                self.state = 214
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 217
                self.match(SlimParser.T__25)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

                self.state = 219
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 221
                self.match(SlimParser.T__26)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, localctx._pattern.combo)

                self.state = 223
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 225
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
            self.state = 251
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 231
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 233
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 235
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 237
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 240
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 242
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 244
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 246
                localctx.body = self.expr(nt)

                nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 248
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
            self.state = 270
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 254
                self.match(SlimParser.T__2)

                nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

                self.state = 256
                localctx.content = self.expr(nt_content)

                self.guide_symbol(')')

                self.state = 258
                self.match(SlimParser.T__3)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 261
                self.match(SlimParser.T__2)

                nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

                self.state = 263
                localctx.head = self.expr(nt_head)

                self.guide_symbol(')')

                self.state = 265
                self.match(SlimParser.T__3)

                nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 267
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
            self.state = 285
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 273
                self.match(SlimParser.T__28)

                nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

                self.state = 275
                localctx.content = self.expr(nt_content)

                localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 278
                self.match(SlimParser.T__28)

                nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

                self.state = 280
                localctx.head = self.expr(nt_head)

                nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 282
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
            self.state = 299
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 288
                self.match(SlimParser.T__9)

                self.guide_terminal('ID')

                self.state = 290
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 292
                self.match(SlimParser.T__9)

                self.guide_terminal('ID')

                self.state = 294
                localctx._ID = self.match(SlimParser.ID)

                nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 296
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
            self.state = 307
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [23]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [28]:
                self.enterOuterAlt(localctx, 2)
                self.state = 302
                self.match(SlimParser.T__27)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 304
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
            self.state = 321
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 310
                localctx._pattern_base = self.pattern_base(nt)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_head)

                self.state = 314
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 316
                self.match(SlimParser.T__7)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 318
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
            self.state = 340
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 324
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 326
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 328
                self.match(SlimParser.T__24)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 330
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 332
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 334
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 337
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
            self.state = 363
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 343
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 345
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 347
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 349
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 352
                self.match(SlimParser.T__1)

                self.guide_terminal('ID')

                self.state = 354
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 356
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 358
                localctx.body = self.pattern(nt_body)

                nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 360
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





