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
        4,1,34,417,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,42,
        8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,68,8,1,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,132,8,2,1,3,1,3,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,145,8,3,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,3,4,156,8,4,1,5,1,5,1,5,1,5,1,5,1,5,3,5,164,8,5,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,229,
        8,6,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,
        1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,3,7,257,8,7,1,8,1,8,
        1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
        1,8,1,8,1,8,3,8,280,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,
        1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,303,8,9,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,
        1,10,1,10,3,10,322,8,10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,
        1,11,1,11,1,11,1,11,1,11,3,11,337,8,11,1,12,1,12,1,12,1,12,1,12,
        1,12,1,12,1,12,1,12,1,12,1,12,1,12,3,12,351,8,12,1,13,1,13,1,13,
        1,13,1,13,1,13,3,13,359,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,
        1,14,1,14,1,14,1,14,1,14,3,14,373,8,14,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,3,15,
        392,8,15,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,415,8,16,
        1,16,0,0,17,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,0,0,458,
        0,41,1,0,0,0,2,67,1,0,0,0,4,131,1,0,0,0,6,144,1,0,0,0,8,155,1,0,
        0,0,10,163,1,0,0,0,12,228,1,0,0,0,14,256,1,0,0,0,16,279,1,0,0,0,
        18,302,1,0,0,0,20,321,1,0,0,0,22,336,1,0,0,0,24,350,1,0,0,0,26,358,
        1,0,0,0,28,372,1,0,0,0,30,391,1,0,0,0,32,414,1,0,0,0,34,42,1,0,0,
        0,35,36,5,32,0,0,36,42,6,0,-1,0,37,38,5,32,0,0,38,39,3,0,0,0,39,
        40,6,0,-1,0,40,42,1,0,0,0,41,34,1,0,0,0,41,35,1,0,0,0,41,37,1,0,
        0,0,42,1,1,0,0,0,43,68,1,0,0,0,44,45,5,1,0,0,45,68,6,1,-1,0,46,47,
        5,2,0,0,47,68,6,1,-1,0,48,49,5,32,0,0,49,68,6,1,-1,0,50,51,5,3,0,
        0,51,68,6,1,-1,0,52,53,5,4,0,0,53,54,5,32,0,0,54,55,3,2,1,0,55,56,
        6,1,-1,0,56,68,1,0,0,0,57,58,5,32,0,0,58,59,5,4,0,0,59,60,3,2,1,
        0,60,61,6,1,-1,0,61,68,1,0,0,0,62,63,5,5,0,0,63,64,3,4,2,0,64,65,
        5,6,0,0,65,66,6,1,-1,0,66,68,1,0,0,0,67,43,1,0,0,0,67,44,1,0,0,0,
        67,46,1,0,0,0,67,48,1,0,0,0,67,50,1,0,0,0,67,52,1,0,0,0,67,57,1,
        0,0,0,67,62,1,0,0,0,68,3,1,0,0,0,69,132,1,0,0,0,70,71,3,2,1,0,71,
        72,6,2,-1,0,72,132,1,0,0,0,73,74,3,2,1,0,74,75,5,7,0,0,75,76,3,4,
        2,0,76,77,6,2,-1,0,77,132,1,0,0,0,78,79,3,2,1,0,79,80,5,8,0,0,80,
        81,3,4,2,0,81,82,6,2,-1,0,82,132,1,0,0,0,83,84,3,2,1,0,84,85,3,6,
        3,0,85,86,6,2,-1,0,86,132,1,0,0,0,87,88,3,2,1,0,88,89,5,9,0,0,89,
        90,3,4,2,0,90,91,6,2,-1,0,91,132,1,0,0,0,92,93,3,2,1,0,93,94,5,10,
        0,0,94,95,3,4,2,0,95,96,6,2,-1,0,96,132,1,0,0,0,97,98,5,11,0,0,98,
        99,3,0,0,0,99,100,5,12,0,0,100,101,3,8,4,0,101,102,5,13,0,0,102,
        103,3,4,2,0,103,104,6,2,-1,0,104,132,1,0,0,0,105,106,5,14,0,0,106,
        107,5,32,0,0,107,108,5,15,0,0,108,109,3,4,2,0,109,110,6,2,-1,0,110,
        132,1,0,0,0,111,112,5,14,0,0,112,113,5,32,0,0,113,114,5,16,0,0,114,
        115,3,4,2,0,115,116,5,15,0,0,116,117,3,4,2,0,117,118,6,2,-1,0,118,
        132,1,0,0,0,119,120,5,17,0,0,120,121,5,32,0,0,121,122,5,18,0,0,122,
        123,3,4,2,0,123,124,6,2,-1,0,124,132,1,0,0,0,125,126,5,19,0,0,126,
        127,5,32,0,0,127,128,5,20,0,0,128,129,3,4,2,0,129,130,6,2,-1,0,130,
        132,1,0,0,0,131,69,1,0,0,0,131,70,1,0,0,0,131,73,1,0,0,0,131,78,
        1,0,0,0,131,83,1,0,0,0,131,87,1,0,0,0,131,92,1,0,0,0,131,97,1,0,
        0,0,131,105,1,0,0,0,131,111,1,0,0,0,131,119,1,0,0,0,131,125,1,0,
        0,0,132,5,1,0,0,0,133,145,1,0,0,0,134,135,5,21,0,0,135,136,3,4,2,
        0,136,137,6,3,-1,0,137,145,1,0,0,0,138,139,5,21,0,0,139,140,3,4,
        2,0,140,141,6,3,-1,0,141,142,3,6,3,0,142,143,6,3,-1,0,143,145,1,
        0,0,0,144,133,1,0,0,0,144,134,1,0,0,0,144,138,1,0,0,0,145,7,1,0,
        0,0,146,156,1,0,0,0,147,148,3,10,5,0,148,149,6,4,-1,0,149,156,1,
        0,0,0,150,151,3,10,5,0,151,152,5,22,0,0,152,153,3,8,4,0,153,154,
        6,4,-1,0,154,156,1,0,0,0,155,146,1,0,0,0,155,147,1,0,0,0,155,150,
        1,0,0,0,156,9,1,0,0,0,157,164,1,0,0,0,158,159,3,4,2,0,159,160,5,
        16,0,0,160,161,3,4,2,0,161,162,6,5,-1,0,162,164,1,0,0,0,163,157,
        1,0,0,0,163,158,1,0,0,0,164,11,1,0,0,0,165,229,1,0,0,0,166,167,3,
        14,7,0,167,168,6,6,-1,0,168,229,1,0,0,0,169,170,6,6,-1,0,170,171,
        3,14,7,0,171,172,6,6,-1,0,172,173,5,10,0,0,173,174,6,6,-1,0,174,
        175,3,14,7,0,175,176,6,6,-1,0,176,229,1,0,0,0,177,178,5,23,0,0,178,
        179,6,6,-1,0,179,180,3,12,6,0,180,181,6,6,-1,0,181,182,5,24,0,0,
        182,183,6,6,-1,0,183,184,3,12,6,0,184,185,6,6,-1,0,185,186,5,25,
        0,0,186,187,6,6,-1,0,187,188,3,12,6,0,188,189,6,6,-1,0,189,229,1,
        0,0,0,190,191,6,6,-1,0,191,192,3,14,7,0,192,193,6,6,-1,0,193,194,
        3,24,12,0,194,195,6,6,-1,0,195,229,1,0,0,0,196,197,6,6,-1,0,197,
        198,3,14,7,0,198,199,6,6,-1,0,199,200,3,20,10,0,200,201,6,6,-1,0,
        201,229,1,0,0,0,202,203,6,6,-1,0,203,204,3,14,7,0,204,205,6,6,-1,
        0,205,206,3,22,11,0,206,207,6,6,-1,0,207,229,1,0,0,0,208,209,5,26,
        0,0,209,210,6,6,-1,0,210,211,5,32,0,0,211,212,6,6,-1,0,212,213,3,
        26,13,0,213,214,6,6,-1,0,214,215,5,22,0,0,215,216,6,6,-1,0,216,217,
        3,12,6,0,217,218,6,6,-1,0,218,229,1,0,0,0,219,220,5,27,0,0,220,221,
        6,6,-1,0,221,222,5,5,0,0,222,223,6,6,-1,0,223,224,3,12,6,0,224,225,
        6,6,-1,0,225,226,5,6,0,0,226,227,6,6,-1,0,227,229,1,0,0,0,228,165,
        1,0,0,0,228,166,1,0,0,0,228,169,1,0,0,0,228,177,1,0,0,0,228,190,
        1,0,0,0,228,196,1,0,0,0,228,202,1,0,0,0,228,208,1,0,0,0,228,219,
        1,0,0,0,229,13,1,0,0,0,230,257,1,0,0,0,231,232,5,3,0,0,232,257,6,
        7,-1,0,233,234,5,4,0,0,234,235,6,7,-1,0,235,236,5,32,0,0,236,237,
        6,7,-1,0,237,238,3,12,6,0,238,239,6,7,-1,0,239,257,1,0,0,0,240,241,
        3,18,9,0,241,242,6,7,-1,0,242,257,1,0,0,0,243,244,6,7,-1,0,244,245,
        3,16,8,0,245,246,6,7,-1,0,246,257,1,0,0,0,247,248,5,32,0,0,248,257,
        6,7,-1,0,249,250,5,5,0,0,250,251,6,7,-1,0,251,252,3,12,6,0,252,253,
        6,7,-1,0,253,254,5,6,0,0,254,255,6,7,-1,0,255,257,1,0,0,0,256,230,
        1,0,0,0,256,231,1,0,0,0,256,233,1,0,0,0,256,240,1,0,0,0,256,243,
        1,0,0,0,256,247,1,0,0,0,256,249,1,0,0,0,257,15,1,0,0,0,258,280,1,
        0,0,0,259,260,5,28,0,0,260,261,6,8,-1,0,261,262,3,28,14,0,262,263,
        6,8,-1,0,263,264,5,29,0,0,264,265,6,8,-1,0,265,266,3,12,6,0,266,
        267,6,8,-1,0,267,280,1,0,0,0,268,269,5,28,0,0,269,270,6,8,-1,0,270,
        271,3,28,14,0,271,272,6,8,-1,0,272,273,5,29,0,0,273,274,6,8,-1,0,
        274,275,3,12,6,0,275,276,6,8,-1,0,276,277,3,16,8,0,277,278,6,8,-1,
        0,278,280,1,0,0,0,279,258,1,0,0,0,279,259,1,0,0,0,279,268,1,0,0,
        0,280,17,1,0,0,0,281,303,1,0,0,0,282,283,5,4,0,0,283,284,6,9,-1,
        0,284,285,5,32,0,0,285,286,6,9,-1,0,286,287,5,30,0,0,287,288,6,9,
        -1,0,288,289,3,12,6,0,289,290,6,9,-1,0,290,303,1,0,0,0,291,292,5,
        4,0,0,292,293,6,9,-1,0,293,294,5,32,0,0,294,295,6,9,-1,0,295,296,
        5,30,0,0,296,297,6,9,-1,0,297,298,3,12,6,0,298,299,6,9,-1,0,299,
        300,3,18,9,0,300,301,6,9,-1,0,301,303,1,0,0,0,302,281,1,0,0,0,302,
        282,1,0,0,0,302,291,1,0,0,0,303,19,1,0,0,0,304,322,1,0,0,0,305,306,
        5,5,0,0,306,307,6,10,-1,0,307,308,3,12,6,0,308,309,6,10,-1,0,309,
        310,5,6,0,0,310,311,6,10,-1,0,311,322,1,0,0,0,312,313,5,5,0,0,313,
        314,6,10,-1,0,314,315,3,12,6,0,315,316,6,10,-1,0,316,317,5,6,0,0,
        317,318,6,10,-1,0,318,319,3,20,10,0,319,320,6,10,-1,0,320,322,1,
        0,0,0,321,304,1,0,0,0,321,305,1,0,0,0,321,312,1,0,0,0,322,21,1,0,
        0,0,323,337,1,0,0,0,324,325,5,31,0,0,325,326,6,11,-1,0,326,327,3,
        12,6,0,327,328,6,11,-1,0,328,337,1,0,0,0,329,330,5,31,0,0,330,331,
        6,11,-1,0,331,332,3,12,6,0,332,333,6,11,-1,0,333,334,3,22,11,0,334,
        335,6,11,-1,0,335,337,1,0,0,0,336,323,1,0,0,0,336,324,1,0,0,0,336,
        329,1,0,0,0,337,23,1,0,0,0,338,351,1,0,0,0,339,340,5,12,0,0,340,
        341,6,12,-1,0,341,342,5,32,0,0,342,351,6,12,-1,0,343,344,5,12,0,
        0,344,345,6,12,-1,0,345,346,5,32,0,0,346,347,6,12,-1,0,347,348,3,
        24,12,0,348,349,6,12,-1,0,349,351,1,0,0,0,350,338,1,0,0,0,350,339,
        1,0,0,0,350,343,1,0,0,0,351,25,1,0,0,0,352,359,1,0,0,0,353,354,5,
        30,0,0,354,355,6,13,-1,0,355,356,3,12,6,0,356,357,6,13,-1,0,357,
        359,1,0,0,0,358,352,1,0,0,0,358,353,1,0,0,0,359,27,1,0,0,0,360,373,
        1,0,0,0,361,362,3,30,15,0,362,363,6,14,-1,0,363,373,1,0,0,0,364,
        365,6,14,-1,0,365,366,3,14,7,0,366,367,6,14,-1,0,367,368,5,10,0,
        0,368,369,6,14,-1,0,369,370,3,14,7,0,370,371,6,14,-1,0,371,373,1,
        0,0,0,372,360,1,0,0,0,372,361,1,0,0,0,372,364,1,0,0,0,373,29,1,0,
        0,0,374,392,1,0,0,0,375,376,5,32,0,0,376,392,6,15,-1,0,377,378,5,
        32,0,0,378,392,6,15,-1,0,379,380,5,3,0,0,380,392,6,15,-1,0,381,382,
        5,4,0,0,382,383,6,15,-1,0,383,384,5,32,0,0,384,385,6,15,-1,0,385,
        386,3,28,14,0,386,387,6,15,-1,0,387,392,1,0,0,0,388,389,3,32,16,
        0,389,390,6,15,-1,0,390,392,1,0,0,0,391,374,1,0,0,0,391,375,1,0,
        0,0,391,377,1,0,0,0,391,379,1,0,0,0,391,381,1,0,0,0,391,388,1,0,
        0,0,392,31,1,0,0,0,393,415,1,0,0,0,394,395,5,4,0,0,395,396,6,16,
        -1,0,396,397,5,32,0,0,397,398,6,16,-1,0,398,399,5,30,0,0,399,400,
        6,16,-1,0,400,401,3,28,14,0,401,402,6,16,-1,0,402,415,1,0,0,0,403,
        404,5,4,0,0,404,405,6,16,-1,0,405,406,5,32,0,0,406,407,6,16,-1,0,
        407,408,5,30,0,0,408,409,6,16,-1,0,409,410,3,28,14,0,410,411,6,16,
        -1,0,411,412,3,32,16,0,412,413,6,16,-1,0,413,415,1,0,0,0,414,393,
        1,0,0,0,414,394,1,0,0,0,414,403,1,0,0,0,415,33,1,0,0,0,17,41,67,
        131,144,155,163,228,256,279,302,321,336,350,358,372,391,414
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'top'", "'bot'", "'@'", "':'", "'('", 
                     "')'", "'|'", "'&'", "'->'", "','", "'{'", "'.'", "'}'", 
                     "'['", "']'", "'<:'", "'least'", "'with'", "'greatest'", 
                     "'of'", "'\\'", "';'", "'if'", "'then'", "'else'", 
                     "'let'", "'fix'", "'case'", "'=>'", "'='", "'|>'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "ID", "INT", "WS" ]

    RULE_ids = 0
    RULE_typ_base = 1
    RULE_typ = 2
    RULE_negchain = 3
    RULE_qualification = 4
    RULE_subtyping = 5
    RULE_expr = 6
    RULE_base = 7
    RULE_function = 8
    RULE_record = 9
    RULE_argchain = 10
    RULE_pipeline = 11
    RULE_keychain = 12
    RULE_target = 13
    RULE_pattern = 14
    RULE_pattern_base = 15
    RULE_pattern_record = 16

    ruleNames =  [ "ids", "typ_base", "typ", "negchain", "qualification", 
                   "subtyping", "expr", "base", "function", "record", "argchain", 
                   "pipeline", "keychain", "target", "pattern", "pattern_base", 
                   "pattern_record" ]

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
    T__29=30
    T__30=31
    ID=32
    INT=33
    WS=34

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
            self.state = 41
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 35
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = [(None if localctx._ID is None else localctx._ID.text)]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 37
                localctx._ID = self.match(SlimParser.ID)
                self.state = 38
                localctx._ids = self.ids()

                localctx.combo = [(None if localctx._ID is None else localctx._ID.text)] + localctx._ids.combo

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
            self.state = 67
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 44
                self.match(SlimParser.T__0)

                localctx.combo = Top() 

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 46
                self.match(SlimParser.T__1)

                localctx.combo = Bot() 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 48
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = TVar((None if localctx._ID is None else localctx._ID.text)) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 50
                self.match(SlimParser.T__2)

                localctx.combo = TUnit() 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 52
                self.match(SlimParser.T__3)
                self.state = 53
                localctx._ID = self.match(SlimParser.ID)
                self.state = 54
                localctx._typ_base = self.typ_base()

                localctx.combo = TTag((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 57
                localctx._ID = self.match(SlimParser.ID)
                self.state = 58
                self.match(SlimParser.T__3)
                self.state = 59
                localctx._typ_base = self.typ_base()

                localctx.combo = TField((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 62
                self.match(SlimParser.T__4)
                self.state = 63
                localctx._typ = self.typ()
                self.state = 64
                self.match(SlimParser.T__5)

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
            self.context = None # Typ_baseContext
            self.acc = None # NegchainContext
            self._ids = None # IdsContext
            self._qualification = None # QualificationContext
            self._ID = None # Token
            self.body = None # TypContext
            self.upper = None # TypContext

        def typ_base(self):
            return self.getTypedRuleContext(SlimParser.Typ_baseContext,0)


        def typ(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(SlimParser.TypContext)
            else:
                return self.getTypedRuleContext(SlimParser.TypContext,i)


        def negchain(self):
            return self.getTypedRuleContext(SlimParser.NegchainContext,0)


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
            self.state = 131
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 70
                localctx._typ_base = self.typ_base()

                localctx.combo = localctx._typ_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 73
                localctx._typ_base = self.typ_base()
                self.state = 74
                self.match(SlimParser.T__6)
                self.state = 75
                localctx._typ = self.typ()

                localctx.combo = Unio(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 78
                localctx._typ_base = self.typ_base()
                self.state = 79
                self.match(SlimParser.T__7)
                self.state = 80
                localctx._typ = self.typ()

                localctx.combo = Inter(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 83
                localctx.context = self.typ_base()
                self.state = 84
                localctx.acc = self.negchain(localctx.context.combo)

                localctx.combo = localctx.acc.combo 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 87
                localctx._typ_base = self.typ_base()
                self.state = 88
                self.match(SlimParser.T__8)
                self.state = 89
                localctx._typ = self.typ()

                localctx.combo = Imp(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 92
                localctx._typ_base = self.typ_base()
                self.state = 93
                self.match(SlimParser.T__9)
                self.state = 94
                localctx._typ = self.typ()

                localctx.combo = Inter(TField('left', localctx._typ_base.combo), TField('right', localctx._typ.combo)) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 97
                self.match(SlimParser.T__10)
                self.state = 98
                localctx._ids = self.ids()
                self.state = 99
                self.match(SlimParser.T__11)
                self.state = 100
                localctx._qualification = self.qualification()
                self.state = 101
                self.match(SlimParser.T__12)
                self.state = 102
                localctx._typ = self.typ()

                localctx.combo = IdxUnio(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 105
                self.match(SlimParser.T__13)
                self.state = 106
                localctx._ID = self.match(SlimParser.ID)
                self.state = 107
                self.match(SlimParser.T__14)
                self.state = 108
                localctx.body = self.typ()

                localctx.combo = IdxInter((None if localctx._ID is None else localctx._ID.text), Top(), localctx.body.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 111
                self.match(SlimParser.T__13)
                self.state = 112
                localctx._ID = self.match(SlimParser.ID)
                self.state = 113
                self.match(SlimParser.T__15)
                self.state = 114
                localctx.upper = self.typ()
                self.state = 115
                self.match(SlimParser.T__14)
                self.state = 116
                localctx.body = self.typ()

                localctx.combo = IdxInter((None if localctx._ID is None else localctx._ID.text), localctx.upper.combo, localctx.body.combo) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 119
                self.match(SlimParser.T__16)
                self.state = 120
                localctx._ID = self.match(SlimParser.ID)
                self.state = 121
                self.match(SlimParser.T__17)
                self.state = 122
                localctx._typ = self.typ()

                localctx.combo = Least((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 125
                self.match(SlimParser.T__18)
                self.state = 126
                localctx._ID = self.match(SlimParser.ID)
                self.state = 127
                self.match(SlimParser.T__19)
                self.state = 128
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


    class NegchainContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, context:Typ=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.context = None
            self.combo = None
            self.negation = None # TypContext
            self.tail = None # NegchainContext
            self.context = context

        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


        def negchain(self):
            return self.getTypedRuleContext(SlimParser.NegchainContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_negchain

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterNegchain" ):
                listener.enterNegchain(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitNegchain" ):
                listener.exitNegchain(self)




    def negchain(self, context:Typ):

        localctx = SlimParser.NegchainContext(self, self._ctx, self.state, context)
        self.enterRule(localctx, 6, self.RULE_negchain)
        try:
            self.state = 144
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 134
                self.match(SlimParser.T__20)
                self.state = 135
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 138
                self.match(SlimParser.T__20)
                self.state = 139
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 141
                localctx.tail = self.negchain(context_tail)

                localctx.combo = Diff(context, localctx.negation.combo)

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
            self._subtyping = None # SubtypingContext
            self._qualification = None # QualificationContext

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
        self.enterRule(localctx, 8, self.RULE_qualification)
        try:
            self.state = 155
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 147
                localctx._subtyping = self.subtyping()

                localctx.combo = [localctx._subtyping.combo]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 150
                localctx._subtyping = self.subtyping()
                self.state = 151
                self.match(SlimParser.T__21)
                self.state = 152
                localctx._qualification = self.qualification()

                localctx.combo = [localctx._subtyping.combo] + localctx._qualification.combo

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
            self.strong = None # TypContext
            self.weak = None # TypContext

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
        self.enterRule(localctx, 10, self.RULE_subtyping)
        try:
            self.state = 163
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [13, 22]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 14, 16, 17, 19, 21, 32]:
                self.enterOuterAlt(localctx, 2)
                self.state = 158
                localctx.strong = self.typ()
                self.state = 159
                self.match(SlimParser.T__15)
                self.state = 160
                localctx.weak = self.typ()

                localctx.combo = Subtyping(localctx.strong.combo, localctx.weak.combo)

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
        self.enterRule(localctx, 12, self.RULE_expr)
        try:
            self.state = 228
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 166
                localctx._base = self.base(nt)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

                self.state = 170
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 172
                self.match(SlimParser.T__9)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 174
                localctx.tail = self.base(nt)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 177
                self.match(SlimParser.T__22)

                nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

                self.state = 179
                localctx.condition = self.expr(nt_condition)

                self.guide_symbol('then')

                self.state = 181
                self.match(SlimParser.T__23)

                nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, localctx.condition.combo)

                self.state = 183
                localctx.branch_true = self.expr(nt_branch_true)

                self.guide_symbol('else')

                self.state = 185
                self.match(SlimParser.T__24)

                nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, localctx.condition.combo, localctx.branch_true.combo)

                self.state = 187
                localctx.branch_false = self.expr(nt_branch_false)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, localctx.condition.combo, localctx.branch_true.combo, localctx.branch_false.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

                self.state = 191
                localctx.cator = self.base(nt_cator)

                nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, localctx.cator.combo)

                self.state = 193
                localctx._keychain = self.keychain(nt_keychain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, localctx.cator.combo, localctx._keychain.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

                self.state = 197
                localctx.cator = self.base(nt_cator)

                nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, localctx.cator.combo)

                self.state = 199
                localctx._argchain = self.argchain(nt_argchain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, localctx.cator.combo, localctx._argchain.combo)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

                self.state = 203
                localctx.cator = self.base(nt_arg)

                nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 205
                localctx._pipeline = self.pipeline(nt_pipeline)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, localctx.cator.combo, localctx._pipeline.combo)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 208
                self.match(SlimParser.T__25)

                self.guide_terminal('ID')

                self.state = 210
                localctx._ID = self.match(SlimParser.ID)

                nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 212
                localctx._target = self.target(nt_target)

                self.guide_symbol(';')

                self.state = 214
                self.match(SlimParser.T__21)

                nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 216
                localctx.contin = self.expr(nt_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 219
                self.match(SlimParser.T__26)

                self.guide_symbol('(')

                self.state = 221
                self.match(SlimParser.T__4)

                nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

                self.state = 223
                localctx.body = self.expr(nt_body)

                self.guide_symbol(')')

                self.state = 225
                self.match(SlimParser.T__5)

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
        self.enterRule(localctx, 14, self.RULE_base)
        try:
            self.state = 256
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 231
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 233
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 235
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 237
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 240
                localctx._record = self.record(nt)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 244
                localctx._function = self.function(nt)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_function, localctx._function.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 247
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 249
                self.match(SlimParser.T__4)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 251
                localctx._expr = self.expr(nt_expr)

                self.guide_symbol(')')

                self.state = 253
                self.match(SlimParser.T__5)

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
        self.enterRule(localctx, 16, self.RULE_function)
        try:
            self.state = 279
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 259
                self.match(SlimParser.T__27)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

                self.state = 261
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 263
                self.match(SlimParser.T__28)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, localctx._pattern.combo)

                self.state = 265
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 268
                self.match(SlimParser.T__27)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

                self.state = 270
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 272
                self.match(SlimParser.T__28)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, localctx._pattern.combo)

                self.state = 274
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 276
                localctx.tail = self.function(nt_tail)

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
        self.enterRule(localctx, 18, self.RULE_record)
        try:
            self.state = 302
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 282
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 284
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 286
                self.match(SlimParser.T__29)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 288
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 291
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 293
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 295
                self.match(SlimParser.T__29)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 297
                localctx.body = self.expr(nt)

                nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 299
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
        self.enterRule(localctx, 20, self.RULE_argchain)
        try:
            self.state = 321
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 305
                self.match(SlimParser.T__4)

                nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

                self.state = 307
                localctx.content = self.expr(nt_content)

                self.guide_symbol(')')

                self.state = 309
                self.match(SlimParser.T__5)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 312
                self.match(SlimParser.T__4)

                nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

                self.state = 314
                localctx.head = self.expr(nt_head)

                self.guide_symbol(')')

                self.state = 316
                self.match(SlimParser.T__5)

                nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 318
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
        self.enterRule(localctx, 22, self.RULE_pipeline)
        try:
            self.state = 336
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 324
                self.match(SlimParser.T__30)

                nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

                self.state = 326
                localctx.content = self.expr(nt_content)

                localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 329
                self.match(SlimParser.T__30)

                nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

                self.state = 331
                localctx.head = self.expr(nt_head)

                nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 333
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
        self.enterRule(localctx, 24, self.RULE_keychain)
        try:
            self.state = 350
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 339
                self.match(SlimParser.T__11)

                self.guide_terminal('ID')

                self.state = 341
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 343
                self.match(SlimParser.T__11)

                self.guide_terminal('ID')

                self.state = 345
                localctx._ID = self.match(SlimParser.ID)

                nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 347
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
        self.enterRule(localctx, 26, self.RULE_target)
        try:
            self.state = 358
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [22]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [30]:
                self.enterOuterAlt(localctx, 2)
                self.state = 353
                self.match(SlimParser.T__29)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 355
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
        self.enterRule(localctx, 28, self.RULE_pattern)
        try:
            self.state = 372
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 361
                localctx._pattern_base = self.pattern_base(nt)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_head)

                self.state = 365
                localctx.head = self.base(nt)

                self.guide_symbol(',')

                self.state = 367
                self.match(SlimParser.T__9)

                nt_cator = self.guide_nonterm(PatterRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 369
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
        self.enterRule(localctx, 30, self.RULE_pattern_base)
        try:
            self.state = 391
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 375
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 377
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 379
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 381
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 383
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 385
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 388
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
        self.enterRule(localctx, 32, self.RULE_pattern_record)
        try:
            self.state = 414
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 394
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 396
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 398
                self.match(SlimParser.T__29)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 400
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 403
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 405
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 407
                self.match(SlimParser.T__29)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 409
                localctx.body = self.pattern(nt_body)

                nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 411
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





