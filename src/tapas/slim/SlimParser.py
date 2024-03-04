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
        4,1,33,421,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,42,
        8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,68,8,1,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,134,8,2,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,147,8,3,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,159,8,4,1,5,1,5,1,5,1,5,1,5,1,5,3,
        5,167,8,5,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,3,6,232,8,6,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,
        7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,3,7,256,8,7,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,3,8,279,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,302,8,9,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,
        1,10,1,10,3,10,321,8,10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,
        1,11,1,11,1,11,1,11,1,11,3,11,336,8,11,1,12,1,12,1,12,1,12,1,12,
        1,12,1,12,1,12,1,12,1,12,1,12,1,12,3,12,350,8,12,1,13,1,13,1,13,
        1,13,1,13,1,13,3,13,358,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,
        1,14,1,14,1,14,1,14,1,14,3,14,372,8,14,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,3,15,396,8,15,1,16,1,16,1,16,1,16,1,16,1,16,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,
        1,16,1,16,3,16,419,8,16,1,16,0,0,17,0,2,4,6,8,10,12,14,16,18,20,
        22,24,26,28,30,32,0,0,463,0,41,1,0,0,0,2,67,1,0,0,0,4,133,1,0,0,
        0,6,146,1,0,0,0,8,158,1,0,0,0,10,166,1,0,0,0,12,231,1,0,0,0,14,255,
        1,0,0,0,16,278,1,0,0,0,18,301,1,0,0,0,20,320,1,0,0,0,22,335,1,0,
        0,0,24,349,1,0,0,0,26,357,1,0,0,0,28,371,1,0,0,0,30,395,1,0,0,0,
        32,418,1,0,0,0,34,42,1,0,0,0,35,36,5,31,0,0,36,42,6,0,-1,0,37,38,
        5,31,0,0,38,39,3,0,0,0,39,40,6,0,-1,0,40,42,1,0,0,0,41,34,1,0,0,
        0,41,35,1,0,0,0,41,37,1,0,0,0,42,1,1,0,0,0,43,68,1,0,0,0,44,45,5,
        1,0,0,45,68,6,1,-1,0,46,47,5,2,0,0,47,68,6,1,-1,0,48,49,5,31,0,0,
        49,68,6,1,-1,0,50,51,5,3,0,0,51,68,6,1,-1,0,52,53,5,4,0,0,53,54,
        5,31,0,0,54,55,3,2,1,0,55,56,6,1,-1,0,56,68,1,0,0,0,57,58,5,31,0,
        0,58,59,5,5,0,0,59,60,3,2,1,0,60,61,6,1,-1,0,61,68,1,0,0,0,62,63,
        5,6,0,0,63,64,3,4,2,0,64,65,5,7,0,0,65,66,6,1,-1,0,66,68,1,0,0,0,
        67,43,1,0,0,0,67,44,1,0,0,0,67,46,1,0,0,0,67,48,1,0,0,0,67,50,1,
        0,0,0,67,52,1,0,0,0,67,57,1,0,0,0,67,62,1,0,0,0,68,3,1,0,0,0,69,
        134,1,0,0,0,70,71,3,2,1,0,71,72,6,2,-1,0,72,134,1,0,0,0,73,74,3,
        2,1,0,74,75,5,8,0,0,75,76,3,4,2,0,76,77,6,2,-1,0,77,134,1,0,0,0,
        78,79,3,2,1,0,79,80,5,9,0,0,80,81,3,4,2,0,81,82,6,2,-1,0,82,134,
        1,0,0,0,83,84,3,2,1,0,84,85,3,6,3,0,85,86,6,2,-1,0,86,134,1,0,0,
        0,87,88,3,2,1,0,88,89,5,10,0,0,89,90,3,4,2,0,90,91,6,2,-1,0,91,134,
        1,0,0,0,92,93,3,2,1,0,93,94,5,11,0,0,94,95,3,4,2,0,95,96,6,2,-1,
        0,96,134,1,0,0,0,97,98,5,12,0,0,98,99,5,13,0,0,99,100,3,0,0,0,100,
        101,5,14,0,0,101,102,3,4,2,0,102,103,6,2,-1,0,103,134,1,0,0,0,104,
        105,5,12,0,0,105,106,5,13,0,0,106,107,3,0,0,0,107,108,3,8,4,0,108,
        109,5,14,0,0,109,110,3,4,2,0,110,111,6,2,-1,0,111,134,1,0,0,0,112,
        113,5,15,0,0,113,114,5,13,0,0,114,115,5,31,0,0,115,116,5,14,0,0,
        116,117,3,4,2,0,117,118,6,2,-1,0,118,134,1,0,0,0,119,120,5,15,0,
        0,120,121,5,13,0,0,121,122,5,31,0,0,122,123,5,16,0,0,123,124,3,4,
        2,0,124,125,5,14,0,0,125,126,3,4,2,0,126,127,6,2,-1,0,127,134,1,
        0,0,0,128,129,5,17,0,0,129,130,5,31,0,0,130,131,3,4,2,0,131,132,
        6,2,-1,0,132,134,1,0,0,0,133,69,1,0,0,0,133,70,1,0,0,0,133,73,1,
        0,0,0,133,78,1,0,0,0,133,83,1,0,0,0,133,87,1,0,0,0,133,92,1,0,0,
        0,133,97,1,0,0,0,133,104,1,0,0,0,133,112,1,0,0,0,133,119,1,0,0,0,
        133,128,1,0,0,0,134,5,1,0,0,0,135,147,1,0,0,0,136,137,5,18,0,0,137,
        138,3,4,2,0,138,139,6,3,-1,0,139,147,1,0,0,0,140,141,5,18,0,0,141,
        142,3,4,2,0,142,143,6,3,-1,0,143,144,3,6,3,0,144,145,6,3,-1,0,145,
        147,1,0,0,0,146,135,1,0,0,0,146,136,1,0,0,0,146,140,1,0,0,0,147,
        7,1,0,0,0,148,159,1,0,0,0,149,150,5,19,0,0,150,151,3,10,5,0,151,
        152,6,4,-1,0,152,159,1,0,0,0,153,154,5,19,0,0,154,155,3,10,5,0,155,
        156,3,8,4,0,156,157,6,4,-1,0,157,159,1,0,0,0,158,148,1,0,0,0,158,
        149,1,0,0,0,158,153,1,0,0,0,159,9,1,0,0,0,160,167,1,0,0,0,161,162,
        3,4,2,0,162,163,5,16,0,0,163,164,3,4,2,0,164,165,6,5,-1,0,165,167,
        1,0,0,0,166,160,1,0,0,0,166,161,1,0,0,0,167,11,1,0,0,0,168,232,1,
        0,0,0,169,170,3,14,7,0,170,171,6,6,-1,0,171,232,1,0,0,0,172,173,
        6,6,-1,0,173,174,3,14,7,0,174,175,6,6,-1,0,175,176,5,11,0,0,176,
        177,6,6,-1,0,177,178,3,12,6,0,178,179,6,6,-1,0,179,232,1,0,0,0,180,
        181,5,20,0,0,181,182,6,6,-1,0,182,183,3,12,6,0,183,184,6,6,-1,0,
        184,185,5,21,0,0,185,186,6,6,-1,0,186,187,3,12,6,0,187,188,6,6,-1,
        0,188,189,5,22,0,0,189,190,6,6,-1,0,190,191,3,12,6,0,191,192,6,6,
        -1,0,192,232,1,0,0,0,193,194,6,6,-1,0,194,195,3,14,7,0,195,196,6,
        6,-1,0,196,197,3,24,12,0,197,198,6,6,-1,0,198,232,1,0,0,0,199,200,
        6,6,-1,0,200,201,3,14,7,0,201,202,6,6,-1,0,202,203,3,20,10,0,203,
        204,6,6,-1,0,204,232,1,0,0,0,205,206,6,6,-1,0,206,207,3,14,7,0,207,
        208,6,6,-1,0,208,209,3,22,11,0,209,210,6,6,-1,0,210,232,1,0,0,0,
        211,212,5,23,0,0,212,213,6,6,-1,0,213,214,5,31,0,0,214,215,6,6,-1,
        0,215,216,3,26,13,0,216,217,6,6,-1,0,217,218,5,19,0,0,218,219,6,
        6,-1,0,219,220,3,12,6,0,220,221,6,6,-1,0,221,232,1,0,0,0,222,223,
        5,24,0,0,223,224,6,6,-1,0,224,225,5,6,0,0,225,226,6,6,-1,0,226,227,
        3,12,6,0,227,228,6,6,-1,0,228,229,5,7,0,0,229,230,6,6,-1,0,230,232,
        1,0,0,0,231,168,1,0,0,0,231,169,1,0,0,0,231,172,1,0,0,0,231,180,
        1,0,0,0,231,193,1,0,0,0,231,199,1,0,0,0,231,205,1,0,0,0,231,211,
        1,0,0,0,231,222,1,0,0,0,232,13,1,0,0,0,233,256,1,0,0,0,234,235,5,
        3,0,0,235,256,6,7,-1,0,236,237,5,4,0,0,237,238,6,7,-1,0,238,239,
        5,31,0,0,239,240,6,7,-1,0,240,241,3,14,7,0,241,242,6,7,-1,0,242,
        256,1,0,0,0,243,244,3,18,9,0,244,245,6,7,-1,0,245,256,1,0,0,0,246,
        247,6,7,-1,0,247,248,3,16,8,0,248,249,6,7,-1,0,249,256,1,0,0,0,250,
        251,5,31,0,0,251,256,6,7,-1,0,252,253,3,20,10,0,253,254,6,7,-1,0,
        254,256,1,0,0,0,255,233,1,0,0,0,255,234,1,0,0,0,255,236,1,0,0,0,
        255,243,1,0,0,0,255,246,1,0,0,0,255,250,1,0,0,0,255,252,1,0,0,0,
        256,15,1,0,0,0,257,279,1,0,0,0,258,259,5,25,0,0,259,260,6,8,-1,0,
        260,261,3,28,14,0,261,262,6,8,-1,0,262,263,5,26,0,0,263,264,6,8,
        -1,0,264,265,3,12,6,0,265,266,6,8,-1,0,266,279,1,0,0,0,267,268,5,
        25,0,0,268,269,6,8,-1,0,269,270,3,28,14,0,270,271,6,8,-1,0,271,272,
        5,26,0,0,272,273,6,8,-1,0,273,274,3,12,6,0,274,275,6,8,-1,0,275,
        276,3,16,8,0,276,277,6,8,-1,0,277,279,1,0,0,0,278,257,1,0,0,0,278,
        258,1,0,0,0,278,267,1,0,0,0,279,17,1,0,0,0,280,302,1,0,0,0,281,282,
        5,27,0,0,282,283,6,9,-1,0,283,284,5,31,0,0,284,285,6,9,-1,0,285,
        286,5,28,0,0,286,287,6,9,-1,0,287,288,3,12,6,0,288,289,6,9,-1,0,
        289,302,1,0,0,0,290,291,5,27,0,0,291,292,6,9,-1,0,292,293,5,31,0,
        0,293,294,6,9,-1,0,294,295,5,28,0,0,295,296,6,9,-1,0,296,297,3,12,
        6,0,297,298,6,9,-1,0,298,299,3,18,9,0,299,300,6,9,-1,0,300,302,1,
        0,0,0,301,280,1,0,0,0,301,281,1,0,0,0,301,290,1,0,0,0,302,19,1,0,
        0,0,303,321,1,0,0,0,304,305,5,6,0,0,305,306,6,10,-1,0,306,307,3,
        12,6,0,307,308,6,10,-1,0,308,309,5,7,0,0,309,310,6,10,-1,0,310,321,
        1,0,0,0,311,312,5,6,0,0,312,313,6,10,-1,0,313,314,3,12,6,0,314,315,
        6,10,-1,0,315,316,5,7,0,0,316,317,6,10,-1,0,317,318,3,20,10,0,318,
        319,6,10,-1,0,319,321,1,0,0,0,320,303,1,0,0,0,320,304,1,0,0,0,320,
        311,1,0,0,0,321,21,1,0,0,0,322,336,1,0,0,0,323,324,5,29,0,0,324,
        325,6,11,-1,0,325,326,3,12,6,0,326,327,6,11,-1,0,327,336,1,0,0,0,
        328,329,5,29,0,0,329,330,6,11,-1,0,330,331,3,12,6,0,331,332,6,11,
        -1,0,332,333,3,22,11,0,333,334,6,11,-1,0,334,336,1,0,0,0,335,322,
        1,0,0,0,335,323,1,0,0,0,335,328,1,0,0,0,336,23,1,0,0,0,337,350,1,
        0,0,0,338,339,5,30,0,0,339,340,6,12,-1,0,340,341,5,31,0,0,341,350,
        6,12,-1,0,342,343,5,30,0,0,343,344,6,12,-1,0,344,345,5,31,0,0,345,
        346,6,12,-1,0,346,347,3,24,12,0,347,348,6,12,-1,0,348,350,1,0,0,
        0,349,337,1,0,0,0,349,338,1,0,0,0,349,342,1,0,0,0,350,25,1,0,0,0,
        351,358,1,0,0,0,352,353,5,28,0,0,353,354,6,13,-1,0,354,355,3,12,
        6,0,355,356,6,13,-1,0,356,358,1,0,0,0,357,351,1,0,0,0,357,352,1,
        0,0,0,358,27,1,0,0,0,359,372,1,0,0,0,360,361,3,30,15,0,361,362,6,
        14,-1,0,362,372,1,0,0,0,363,364,6,14,-1,0,364,365,3,30,15,0,365,
        366,6,14,-1,0,366,367,5,11,0,0,367,368,6,14,-1,0,368,369,3,28,14,
        0,369,370,6,14,-1,0,370,372,1,0,0,0,371,359,1,0,0,0,371,360,1,0,
        0,0,371,363,1,0,0,0,372,29,1,0,0,0,373,396,1,0,0,0,374,375,5,31,
        0,0,375,396,6,15,-1,0,376,377,5,31,0,0,377,396,6,15,-1,0,378,379,
        5,3,0,0,379,396,6,15,-1,0,380,381,5,4,0,0,381,382,6,15,-1,0,382,
        383,5,31,0,0,383,384,6,15,-1,0,384,385,3,30,15,0,385,386,6,15,-1,
        0,386,396,1,0,0,0,387,388,3,32,16,0,388,389,6,15,-1,0,389,396,1,
        0,0,0,390,391,5,6,0,0,391,392,3,28,14,0,392,393,5,7,0,0,393,394,
        6,15,-1,0,394,396,1,0,0,0,395,373,1,0,0,0,395,374,1,0,0,0,395,376,
        1,0,0,0,395,378,1,0,0,0,395,380,1,0,0,0,395,387,1,0,0,0,395,390,
        1,0,0,0,396,31,1,0,0,0,397,419,1,0,0,0,398,399,5,27,0,0,399,400,
        6,16,-1,0,400,401,5,31,0,0,401,402,6,16,-1,0,402,403,5,28,0,0,403,
        404,6,16,-1,0,404,405,3,28,14,0,405,406,6,16,-1,0,406,419,1,0,0,
        0,407,408,5,27,0,0,408,409,6,16,-1,0,409,410,5,31,0,0,410,411,6,
        16,-1,0,411,412,5,28,0,0,412,413,6,16,-1,0,413,414,3,28,14,0,414,
        415,6,16,-1,0,415,416,3,32,16,0,416,417,6,16,-1,0,417,419,1,0,0,
        0,418,397,1,0,0,0,418,398,1,0,0,0,418,407,1,0,0,0,419,33,1,0,0,0,
        17,41,67,133,146,158,166,231,255,278,301,320,335,349,357,371,395,
        418
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'TOP'", "'BOT'", "'@'", "'~'", "':'", 
                     "'('", "')'", "'|'", "'&'", "'->'", "','", "'EXI'", 
                     "'['", "']'", "'ALL'", "'<:'", "'LFP'", "'\\'", "';'", 
                     "'if'", "'then'", "'else'", "'let'", "'fix'", "'case'", 
                     "'=>'", "'_.'", "'='", "'|>'", "'.'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "ID", "INT", 
                      "WS" ]

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
    ID=31
    INT=32
    WS=33

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

                localctx.combo = tuple([(None if localctx._ID is None else localctx._ID.text)])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 37
                localctx._ID = self.match(SlimParser.ID)
                self.state = 38
                localctx._ids = self.ids()

                localctx.combo = tuple([(None if localctx._ID is None else localctx._ID.text)]) + localctx._ids.combo

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
                self.match(SlimParser.T__4)
                self.state = 59
                localctx._typ_base = self.typ_base()

                localctx.combo = TField((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 62
                self.match(SlimParser.T__5)
                self.state = 63
                localctx._typ = self.typ()
                self.state = 64
                self.match(SlimParser.T__6)

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
            self.state = 133
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
                self.match(SlimParser.T__7)
                self.state = 75
                localctx._typ = self.typ()

                localctx.combo = Unio(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 78
                localctx._typ_base = self.typ_base()
                self.state = 79
                self.match(SlimParser.T__8)
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
                self.match(SlimParser.T__9)
                self.state = 89
                localctx._typ = self.typ()

                localctx.combo = Imp(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 92
                localctx._typ_base = self.typ_base()
                self.state = 93
                self.match(SlimParser.T__10)
                self.state = 94
                localctx._typ = self.typ()

                localctx.combo = Inter(TField('head', localctx._typ_base.combo), TField('tail', localctx._typ.combo)) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 97
                self.match(SlimParser.T__11)
                self.state = 98
                self.match(SlimParser.T__12)
                self.state = 99
                localctx._ids = self.ids()
                self.state = 100
                self.match(SlimParser.T__13)
                self.state = 101
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, [], localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 104
                self.match(SlimParser.T__11)
                self.state = 105
                self.match(SlimParser.T__12)
                self.state = 106
                localctx._ids = self.ids()
                self.state = 107
                localctx._qualification = self.qualification()
                self.state = 108
                self.match(SlimParser.T__13)
                self.state = 109
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 112
                self.match(SlimParser.T__14)
                self.state = 113
                self.match(SlimParser.T__12)
                self.state = 114
                localctx._ID = self.match(SlimParser.ID)
                self.state = 115
                self.match(SlimParser.T__13)
                self.state = 116
                localctx.body = self.typ()

                localctx.combo = All((None if localctx._ID is None else localctx._ID.text), Top(), localctx.body.combo) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 119
                self.match(SlimParser.T__14)
                self.state = 120
                self.match(SlimParser.T__12)
                self.state = 121
                localctx._ID = self.match(SlimParser.ID)
                self.state = 122
                self.match(SlimParser.T__15)
                self.state = 123
                localctx.upper = self.typ()
                self.state = 124
                self.match(SlimParser.T__13)
                self.state = 125
                localctx.body = self.typ()

                localctx.combo = All((None if localctx._ID is None else localctx._ID.text), localctx.upper.combo, localctx.body.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 128
                self.match(SlimParser.T__16)
                self.state = 129
                localctx._ID = self.match(SlimParser.ID)
                self.state = 130
                localctx._typ = self.typ()

                localctx.combo = LeastFP((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo) 

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
            self.state = 146
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 136
                self.match(SlimParser.T__17)
                self.state = 137
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 140
                self.match(SlimParser.T__17)
                self.state = 141
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 143
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
            self.state = 158
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 149
                self.match(SlimParser.T__18)
                self.state = 150
                localctx._subtyping = self.subtyping()

                localctx.combo = tuple([localctx._subtyping.combo])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 153
                self.match(SlimParser.T__18)
                self.state = 154
                localctx._subtyping = self.subtyping()
                self.state = 155
                localctx._qualification = self.qualification()

                localctx.combo = tuple([localctx._subtyping.combo]) + localctx._qualification.combo

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
            self.state = 166
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [14, 19]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1, 2, 3, 4, 6, 8, 9, 10, 11, 12, 15, 16, 17, 18, 31]:
                self.enterOuterAlt(localctx, 2)
                self.state = 161
                localctx.strong = self.typ()
                self.state = 162
                self.match(SlimParser.T__15)
                self.state = 163
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
            self.tail = None # ExprContext
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

        def base(self):
            return self.getTypedRuleContext(SlimParser.BaseContext,0)


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
            self.state = 231
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 169
                localctx._base = self.base(nt)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_head = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

                self.state = 173
                localctx.head = self.base(nt_head)

                self.guide_symbol(',')

                self.state = 175
                self.match(SlimParser.T__10)

                nt_tail = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 177
                localctx.tail = self.expr(nt_tail)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 180
                self.match(SlimParser.T__19)

                nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

                self.state = 182
                localctx.condition = self.expr(nt_condition)

                self.guide_symbol('then')

                self.state = 184
                self.match(SlimParser.T__20)

                nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, localctx.condition.combo)

                self.state = 186
                localctx.branch_true = self.expr(nt_branch_true)

                self.guide_symbol('else')

                self.state = 188
                self.match(SlimParser.T__21)

                nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, localctx.condition.combo, localctx.branch_true.combo)

                self.state = 190
                localctx.branch_false = self.expr(nt_branch_false)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, localctx.condition.combo, localctx.branch_true.combo, localctx.branch_false.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

                self.state = 194
                localctx.cator = self.base(nt_cator)

                nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, localctx.cator.combo)

                self.state = 196
                localctx._keychain = self.keychain(nt_keychain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, localctx.cator.combo, localctx._keychain.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

                self.state = 200
                localctx.cator = self.base(nt_cator)

                nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, localctx.cator.combo)

                self.state = 202
                localctx._argchain = self.argchain(nt_argchain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, localctx.cator.combo, localctx._argchain.combo)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

                self.state = 206
                localctx.cator = self.base(nt_arg)

                nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 208
                localctx._pipeline = self.pipeline(nt_pipeline)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, localctx.cator.combo, localctx._pipeline.combo)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 211
                self.match(SlimParser.T__22)

                self.guide_terminal('ID')

                self.state = 213
                localctx._ID = self.match(SlimParser.ID)

                nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 215
                localctx._target = self.target(nt_target)

                self.guide_symbol(';')

                self.state = 217
                self.match(SlimParser.T__18)

                nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 219
                localctx.contin = self.expr(nt_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 222
                self.match(SlimParser.T__23)

                self.guide_symbol('(')

                self.state = 224
                self.match(SlimParser.T__5)

                nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

                self.state = 226
                localctx.body = self.expr(nt_body)

                self.guide_symbol(')')

                self.state = 228
                self.match(SlimParser.T__6)

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
            self.body = None # BaseContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._argchain = None # ArgchainContext
            self.nt = nt

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def base(self):
            return self.getTypedRuleContext(SlimParser.BaseContext,0)


        def record(self):
            return self.getTypedRuleContext(SlimParser.RecordContext,0)


        def function(self):
            return self.getTypedRuleContext(SlimParser.FunctionContext,0)


        def argchain(self):
            return self.getTypedRuleContext(SlimParser.ArgchainContext,0)


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
            self.state = 255
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 234
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 236
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 238
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 240
                localctx.body = self.base(nt_body)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 243
                localctx._record = self.record(nt)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 247
                localctx._function = self.function(nt)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_function, localctx._function.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 250
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 252
                localctx._argchain = self.argchain(nt)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_assoc, localctx._argchain.combo)

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
            self.state = 278
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 258
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

                self.state = 260
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 262
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, localctx._pattern.combo)

                self.state = 264
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 267
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

                self.state = 269
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 271
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, localctx._pattern.combo)

                self.state = 273
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 275
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
            self.state = 301
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 281
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 283
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 285
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 287
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 290
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 292
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 294
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 296
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 298
                localctx.tail = self.record(nt_tail)

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
            self.state = 320
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 304
                self.match(SlimParser.T__5)

                nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

                self.state = 306
                localctx.content = self.expr(nt_content)

                self.guide_symbol(')')

                self.state = 308
                self.match(SlimParser.T__6)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 311
                self.match(SlimParser.T__5)

                nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

                self.state = 313
                localctx.head = self.expr(nt_head)

                self.guide_symbol(')')

                self.state = 315
                self.match(SlimParser.T__6)

                nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 317
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
            self.state = 335
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 323
                self.match(SlimParser.T__28)

                nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

                self.state = 325
                localctx.content = self.expr(nt_content)

                localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 328
                self.match(SlimParser.T__28)

                nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

                self.state = 330
                localctx.head = self.expr(nt_head)

                nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 332
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
            self.state = 349
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 338
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 340
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 342
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 344
                localctx._ID = self.match(SlimParser.ID)

                nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 346
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
            self.state = 357
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [19]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [28]:
                self.enterOuterAlt(localctx, 2)
                self.state = 352
                self.match(SlimParser.T__27)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 354
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
            self.head = None # Pattern_baseContext
            self.tail = None # PatternContext
            self.nt = nt

        def pattern_base(self):
            return self.getTypedRuleContext(SlimParser.Pattern_baseContext,0)


        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


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
            self.state = 371
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 360
                localctx._pattern_base = self.pattern_base(nt)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_head = self.guide_nonterm(PatternRule(self._solver, nt).distill_tuple_head)

                self.state = 364
                localctx.head = self.pattern_base(nt_head)

                self.guide_symbol(',')

                self.state = 366
                self.match(SlimParser.T__10)

                nt_tail = self.guide_nonterm(PatternRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 368
                localctx.tail = self.pattern(nt_tail)

                localctx.combo = self.collect(PatternRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

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
            self.body = None # Pattern_baseContext
            self._pattern_record = None # Pattern_recordContext
            self._pattern = None # PatternContext
            self.nt = nt

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern_base(self):
            return self.getTypedRuleContext(SlimParser.Pattern_baseContext,0)


        def pattern_record(self):
            return self.getTypedRuleContext(SlimParser.Pattern_recordContext,0)


        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


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
            self.state = 395
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 374
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 376
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 378
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 380
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 382
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 384
                localctx.body = self.pattern_base(nt_body)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 387
                localctx._pattern_record = self.pattern_record(nt)

                localctx.combo = localctx._pattern_record.combo

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 390
                self.match(SlimParser.T__5)
                self.state = 391
                localctx._pattern = self.pattern(nt)
                self.state = 392
                self.match(SlimParser.T__6)

                localctx.combo = localctx._pattern.combo   

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
            self.state = 418
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 398
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 400
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 402
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 404
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 407
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 409
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 411
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 413
                localctx.body = self.pattern(nt_body)

                nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 415
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





