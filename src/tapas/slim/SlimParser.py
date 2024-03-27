# Generated from /Users/thomas/tlogan@github.com/lightweight-tapas/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
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
        4,1,33,428,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,42,
        8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,68,8,1,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,3,2,141,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,
        3,3,3,154,8,3,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,166,8,
        4,1,5,1,5,1,5,1,5,1,5,1,5,3,5,174,8,5,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,239,8,6,1,7,1,7,1,7,1,7,1,
        7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,
        7,1,7,3,7,263,8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,286,8,8,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,3,9,309,8,9,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,328,8,10,1,11,1,11,1,
        11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,3,11,343,8,
        11,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,3,
        12,357,8,12,1,13,1,13,1,13,1,13,1,13,1,13,3,13,365,8,13,1,14,1,14,
        1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,3,14,379,8,14,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,3,15,403,8,15,1,16,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,426,8,16,1,16,0,0,17,0,2,
        4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,0,0,471,0,41,1,0,0,0,2,
        67,1,0,0,0,4,140,1,0,0,0,6,153,1,0,0,0,8,165,1,0,0,0,10,173,1,0,
        0,0,12,238,1,0,0,0,14,262,1,0,0,0,16,285,1,0,0,0,18,308,1,0,0,0,
        20,327,1,0,0,0,22,342,1,0,0,0,24,356,1,0,0,0,26,364,1,0,0,0,28,378,
        1,0,0,0,30,402,1,0,0,0,32,425,1,0,0,0,34,42,1,0,0,0,35,36,5,31,0,
        0,36,42,6,0,-1,0,37,38,5,31,0,0,38,39,3,0,0,0,39,40,6,0,-1,0,40,
        42,1,0,0,0,41,34,1,0,0,0,41,35,1,0,0,0,41,37,1,0,0,0,42,1,1,0,0,
        0,43,68,1,0,0,0,44,45,5,1,0,0,45,68,6,1,-1,0,46,47,5,2,0,0,47,68,
        6,1,-1,0,48,49,5,31,0,0,49,68,6,1,-1,0,50,51,5,3,0,0,51,68,6,1,-1,
        0,52,53,5,4,0,0,53,54,5,31,0,0,54,55,3,2,1,0,55,56,6,1,-1,0,56,68,
        1,0,0,0,57,58,5,31,0,0,58,59,5,5,0,0,59,60,3,2,1,0,60,61,6,1,-1,
        0,61,68,1,0,0,0,62,63,5,6,0,0,63,64,3,4,2,0,64,65,5,7,0,0,65,66,
        6,1,-1,0,66,68,1,0,0,0,67,43,1,0,0,0,67,44,1,0,0,0,67,46,1,0,0,0,
        67,48,1,0,0,0,67,50,1,0,0,0,67,52,1,0,0,0,67,57,1,0,0,0,67,62,1,
        0,0,0,68,3,1,0,0,0,69,141,1,0,0,0,70,71,3,2,1,0,71,72,6,2,-1,0,72,
        141,1,0,0,0,73,74,3,2,1,0,74,75,5,8,0,0,75,76,3,4,2,0,76,77,6,2,
        -1,0,77,141,1,0,0,0,78,79,3,2,1,0,79,80,5,9,0,0,80,81,3,4,2,0,81,
        82,6,2,-1,0,82,141,1,0,0,0,83,84,3,2,1,0,84,85,3,6,3,0,85,86,6,2,
        -1,0,86,141,1,0,0,0,87,88,3,2,1,0,88,89,5,10,0,0,89,90,3,4,2,0,90,
        91,6,2,-1,0,91,141,1,0,0,0,92,93,3,2,1,0,93,94,5,11,0,0,94,95,3,
        4,2,0,95,96,6,2,-1,0,96,141,1,0,0,0,97,98,5,12,0,0,98,99,5,13,0,
        0,99,100,3,0,0,0,100,101,5,14,0,0,101,102,3,4,2,0,102,103,6,2,-1,
        0,103,141,1,0,0,0,104,105,5,12,0,0,105,106,5,13,0,0,106,107,3,8,
        4,0,107,108,5,14,0,0,108,109,3,4,2,0,109,110,6,2,-1,0,110,141,1,
        0,0,0,111,112,5,12,0,0,112,113,5,13,0,0,113,114,3,0,0,0,114,115,
        3,8,4,0,115,116,5,14,0,0,116,117,3,4,2,0,117,118,6,2,-1,0,118,141,
        1,0,0,0,119,120,5,15,0,0,120,121,5,13,0,0,121,122,5,31,0,0,122,123,
        5,14,0,0,123,124,3,4,2,0,124,125,6,2,-1,0,125,141,1,0,0,0,126,127,
        5,15,0,0,127,128,5,13,0,0,128,129,5,31,0,0,129,130,5,16,0,0,130,
        131,3,4,2,0,131,132,5,14,0,0,132,133,3,4,2,0,133,134,6,2,-1,0,134,
        141,1,0,0,0,135,136,5,17,0,0,136,137,5,31,0,0,137,138,3,4,2,0,138,
        139,6,2,-1,0,139,141,1,0,0,0,140,69,1,0,0,0,140,70,1,0,0,0,140,73,
        1,0,0,0,140,78,1,0,0,0,140,83,1,0,0,0,140,87,1,0,0,0,140,92,1,0,
        0,0,140,97,1,0,0,0,140,104,1,0,0,0,140,111,1,0,0,0,140,119,1,0,0,
        0,140,126,1,0,0,0,140,135,1,0,0,0,141,5,1,0,0,0,142,154,1,0,0,0,
        143,144,5,18,0,0,144,145,3,4,2,0,145,146,6,3,-1,0,146,154,1,0,0,
        0,147,148,5,18,0,0,148,149,3,4,2,0,149,150,6,3,-1,0,150,151,3,6,
        3,0,151,152,6,3,-1,0,152,154,1,0,0,0,153,142,1,0,0,0,153,143,1,0,
        0,0,153,147,1,0,0,0,154,7,1,0,0,0,155,166,1,0,0,0,156,157,5,19,0,
        0,157,158,3,10,5,0,158,159,6,4,-1,0,159,166,1,0,0,0,160,161,5,19,
        0,0,161,162,3,10,5,0,162,163,3,8,4,0,163,164,6,4,-1,0,164,166,1,
        0,0,0,165,155,1,0,0,0,165,156,1,0,0,0,165,160,1,0,0,0,166,9,1,0,
        0,0,167,174,1,0,0,0,168,169,3,4,2,0,169,170,5,16,0,0,170,171,3,4,
        2,0,171,172,6,5,-1,0,172,174,1,0,0,0,173,167,1,0,0,0,173,168,1,0,
        0,0,174,11,1,0,0,0,175,239,1,0,0,0,176,177,3,14,7,0,177,178,6,6,
        -1,0,178,239,1,0,0,0,179,180,6,6,-1,0,180,181,3,14,7,0,181,182,6,
        6,-1,0,182,183,5,11,0,0,183,184,6,6,-1,0,184,185,3,12,6,0,185,186,
        6,6,-1,0,186,239,1,0,0,0,187,188,5,20,0,0,188,189,6,6,-1,0,189,190,
        3,12,6,0,190,191,6,6,-1,0,191,192,5,21,0,0,192,193,6,6,-1,0,193,
        194,3,12,6,0,194,195,6,6,-1,0,195,196,5,22,0,0,196,197,6,6,-1,0,
        197,198,3,12,6,0,198,199,6,6,-1,0,199,239,1,0,0,0,200,201,6,6,-1,
        0,201,202,3,14,7,0,202,203,6,6,-1,0,203,204,3,24,12,0,204,205,6,
        6,-1,0,205,239,1,0,0,0,206,207,6,6,-1,0,207,208,3,14,7,0,208,209,
        6,6,-1,0,209,210,3,20,10,0,210,211,6,6,-1,0,211,239,1,0,0,0,212,
        213,6,6,-1,0,213,214,3,14,7,0,214,215,6,6,-1,0,215,216,3,22,11,0,
        216,217,6,6,-1,0,217,239,1,0,0,0,218,219,5,23,0,0,219,220,6,6,-1,
        0,220,221,5,31,0,0,221,222,6,6,-1,0,222,223,3,26,13,0,223,224,6,
        6,-1,0,224,225,5,19,0,0,225,226,6,6,-1,0,226,227,3,12,6,0,227,228,
        6,6,-1,0,228,239,1,0,0,0,229,230,5,24,0,0,230,231,6,6,-1,0,231,232,
        5,6,0,0,232,233,6,6,-1,0,233,234,3,12,6,0,234,235,6,6,-1,0,235,236,
        5,7,0,0,236,237,6,6,-1,0,237,239,1,0,0,0,238,175,1,0,0,0,238,176,
        1,0,0,0,238,179,1,0,0,0,238,187,1,0,0,0,238,200,1,0,0,0,238,206,
        1,0,0,0,238,212,1,0,0,0,238,218,1,0,0,0,238,229,1,0,0,0,239,13,1,
        0,0,0,240,263,1,0,0,0,241,242,5,3,0,0,242,263,6,7,-1,0,243,244,5,
        4,0,0,244,245,6,7,-1,0,245,246,5,31,0,0,246,247,6,7,-1,0,247,248,
        3,14,7,0,248,249,6,7,-1,0,249,263,1,0,0,0,250,251,3,18,9,0,251,252,
        6,7,-1,0,252,263,1,0,0,0,253,254,6,7,-1,0,254,255,3,16,8,0,255,256,
        6,7,-1,0,256,263,1,0,0,0,257,258,5,31,0,0,258,263,6,7,-1,0,259,260,
        3,20,10,0,260,261,6,7,-1,0,261,263,1,0,0,0,262,240,1,0,0,0,262,241,
        1,0,0,0,262,243,1,0,0,0,262,250,1,0,0,0,262,253,1,0,0,0,262,257,
        1,0,0,0,262,259,1,0,0,0,263,15,1,0,0,0,264,286,1,0,0,0,265,266,5,
        25,0,0,266,267,6,8,-1,0,267,268,3,28,14,0,268,269,6,8,-1,0,269,270,
        5,26,0,0,270,271,6,8,-1,0,271,272,3,12,6,0,272,273,6,8,-1,0,273,
        286,1,0,0,0,274,275,5,25,0,0,275,276,6,8,-1,0,276,277,3,28,14,0,
        277,278,6,8,-1,0,278,279,5,26,0,0,279,280,6,8,-1,0,280,281,3,12,
        6,0,281,282,6,8,-1,0,282,283,3,16,8,0,283,284,6,8,-1,0,284,286,1,
        0,0,0,285,264,1,0,0,0,285,265,1,0,0,0,285,274,1,0,0,0,286,17,1,0,
        0,0,287,309,1,0,0,0,288,289,5,27,0,0,289,290,6,9,-1,0,290,291,5,
        31,0,0,291,292,6,9,-1,0,292,293,5,28,0,0,293,294,6,9,-1,0,294,295,
        3,12,6,0,295,296,6,9,-1,0,296,309,1,0,0,0,297,298,5,27,0,0,298,299,
        6,9,-1,0,299,300,5,31,0,0,300,301,6,9,-1,0,301,302,5,28,0,0,302,
        303,6,9,-1,0,303,304,3,12,6,0,304,305,6,9,-1,0,305,306,3,18,9,0,
        306,307,6,9,-1,0,307,309,1,0,0,0,308,287,1,0,0,0,308,288,1,0,0,0,
        308,297,1,0,0,0,309,19,1,0,0,0,310,328,1,0,0,0,311,312,5,6,0,0,312,
        313,6,10,-1,0,313,314,3,12,6,0,314,315,6,10,-1,0,315,316,5,7,0,0,
        316,317,6,10,-1,0,317,328,1,0,0,0,318,319,5,6,0,0,319,320,6,10,-1,
        0,320,321,3,12,6,0,321,322,6,10,-1,0,322,323,5,7,0,0,323,324,6,10,
        -1,0,324,325,3,20,10,0,325,326,6,10,-1,0,326,328,1,0,0,0,327,310,
        1,0,0,0,327,311,1,0,0,0,327,318,1,0,0,0,328,21,1,0,0,0,329,343,1,
        0,0,0,330,331,5,29,0,0,331,332,6,11,-1,0,332,333,3,12,6,0,333,334,
        6,11,-1,0,334,343,1,0,0,0,335,336,5,29,0,0,336,337,6,11,-1,0,337,
        338,3,12,6,0,338,339,6,11,-1,0,339,340,3,22,11,0,340,341,6,11,-1,
        0,341,343,1,0,0,0,342,329,1,0,0,0,342,330,1,0,0,0,342,335,1,0,0,
        0,343,23,1,0,0,0,344,357,1,0,0,0,345,346,5,30,0,0,346,347,6,12,-1,
        0,347,348,5,31,0,0,348,357,6,12,-1,0,349,350,5,30,0,0,350,351,6,
        12,-1,0,351,352,5,31,0,0,352,353,6,12,-1,0,353,354,3,24,12,0,354,
        355,6,12,-1,0,355,357,1,0,0,0,356,344,1,0,0,0,356,345,1,0,0,0,356,
        349,1,0,0,0,357,25,1,0,0,0,358,365,1,0,0,0,359,360,5,28,0,0,360,
        361,6,13,-1,0,361,362,3,12,6,0,362,363,6,13,-1,0,363,365,1,0,0,0,
        364,358,1,0,0,0,364,359,1,0,0,0,365,27,1,0,0,0,366,379,1,0,0,0,367,
        368,3,30,15,0,368,369,6,14,-1,0,369,379,1,0,0,0,370,371,6,14,-1,
        0,371,372,3,30,15,0,372,373,6,14,-1,0,373,374,5,11,0,0,374,375,6,
        14,-1,0,375,376,3,28,14,0,376,377,6,14,-1,0,377,379,1,0,0,0,378,
        366,1,0,0,0,378,367,1,0,0,0,378,370,1,0,0,0,379,29,1,0,0,0,380,403,
        1,0,0,0,381,382,5,31,0,0,382,403,6,15,-1,0,383,384,5,31,0,0,384,
        403,6,15,-1,0,385,386,5,3,0,0,386,403,6,15,-1,0,387,388,5,4,0,0,
        388,389,6,15,-1,0,389,390,5,31,0,0,390,391,6,15,-1,0,391,392,3,30,
        15,0,392,393,6,15,-1,0,393,403,1,0,0,0,394,395,3,32,16,0,395,396,
        6,15,-1,0,396,403,1,0,0,0,397,398,5,6,0,0,398,399,3,28,14,0,399,
        400,5,7,0,0,400,401,6,15,-1,0,401,403,1,0,0,0,402,380,1,0,0,0,402,
        381,1,0,0,0,402,383,1,0,0,0,402,385,1,0,0,0,402,387,1,0,0,0,402,
        394,1,0,0,0,402,397,1,0,0,0,403,31,1,0,0,0,404,426,1,0,0,0,405,406,
        5,27,0,0,406,407,6,16,-1,0,407,408,5,31,0,0,408,409,6,16,-1,0,409,
        410,5,28,0,0,410,411,6,16,-1,0,411,412,3,28,14,0,412,413,6,16,-1,
        0,413,426,1,0,0,0,414,415,5,27,0,0,415,416,6,16,-1,0,416,417,5,31,
        0,0,417,418,6,16,-1,0,418,419,5,28,0,0,419,420,6,16,-1,0,420,421,
        3,28,14,0,421,422,6,16,-1,0,422,423,3,32,16,0,423,424,6,16,-1,0,
        424,426,1,0,0,0,425,404,1,0,0,0,425,405,1,0,0,0,425,414,1,0,0,0,
        426,33,1,0,0,0,17,41,67,140,153,165,173,238,262,285,308,327,342,
        356,364,378,402,425
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
            self.state = 140
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

                localctx.combo = Exi(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 104
                self.match(SlimParser.T__11)
                self.state = 105
                self.match(SlimParser.T__12)
                self.state = 106
                localctx._qualification = self.qualification()
                self.state = 107
                self.match(SlimParser.T__13)
                self.state = 108
                localctx._typ = self.typ()

                localctx.combo = Exi((), localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 111
                self.match(SlimParser.T__11)
                self.state = 112
                self.match(SlimParser.T__12)
                self.state = 113
                localctx._ids = self.ids()
                self.state = 114
                localctx._qualification = self.qualification()
                self.state = 115
                self.match(SlimParser.T__13)
                self.state = 116
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

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
                self.match(SlimParser.T__13)
                self.state = 123
                localctx.body = self.typ()

                localctx.combo = All((None if localctx._ID is None else localctx._ID.text), Top(), localctx.body.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 126
                self.match(SlimParser.T__14)
                self.state = 127
                self.match(SlimParser.T__12)
                self.state = 128
                localctx._ID = self.match(SlimParser.ID)
                self.state = 129
                self.match(SlimParser.T__15)
                self.state = 130
                localctx.upper = self.typ()
                self.state = 131
                self.match(SlimParser.T__13)
                self.state = 132
                localctx.body = self.typ()

                localctx.combo = All((None if localctx._ID is None else localctx._ID.text), localctx.upper.combo, localctx.body.combo) 

                pass

            elif la_ == 13:
                self.enterOuterAlt(localctx, 13)
                self.state = 135
                self.match(SlimParser.T__16)
                self.state = 136
                localctx._ID = self.match(SlimParser.ID)
                self.state = 137
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
            self.state = 153
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 143
                self.match(SlimParser.T__17)
                self.state = 144
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 147
                self.match(SlimParser.T__17)
                self.state = 148
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 150
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
            self.state = 165
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 156
                self.match(SlimParser.T__18)
                self.state = 157
                localctx._subtyping = self.subtyping()

                localctx.combo = tuple([localctx._subtyping.combo])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 160
                self.match(SlimParser.T__18)
                self.state = 161
                localctx._subtyping = self.subtyping()
                self.state = 162
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
            self.state = 173
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [14, 19]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1, 2, 3, 4, 6, 8, 9, 10, 11, 12, 15, 16, 17, 18, 31]:
                self.enterOuterAlt(localctx, 2)
                self.state = 168
                localctx.strong = self.typ()
                self.state = 169
                self.match(SlimParser.T__15)
                self.state = 170
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
            self.state = 238
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 176
                localctx._base = self.base(nt)

                localctx.combo = localctx._base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_head = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_head)

                self.state = 180
                localctx.head = self.base(nt_head)

                self.guide_symbol(',')

                self.state = 182
                self.match(SlimParser.T__10)

                nt_tail = self.guide_nonterm(ExprRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 184
                localctx.tail = self.expr(nt_tail)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_tuple, localctx.head.combo, localctx.tail.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 187
                self.match(SlimParser.T__19)

                nt_condition = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_condition)

                self.state = 189
                localctx.condition = self.expr(nt_condition)

                self.guide_symbol('then')

                self.state = 191
                self.match(SlimParser.T__20)

                nt_branch_true = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_true, localctx.condition.combo)

                self.state = 193
                localctx.branch_true = self.expr(nt_branch_true)

                self.guide_symbol('else')

                self.state = 195
                self.match(SlimParser.T__21)

                nt_branch_false = self.guide_nonterm(ExprRule(self._solver, nt).distill_ite_branch_false, localctx.condition.combo, localctx.branch_true.combo)

                self.state = 197
                localctx.branch_false = self.expr(nt_branch_false)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_ite, localctx.condition.combo, localctx.branch_true.combo, localctx.branch_false.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_cator)

                self.state = 201
                localctx.cator = self.base(nt_cator)

                nt_keychain = self.guide_nonterm(ExprRule(self._solver, nt).distill_projection_keychain, localctx.cator.combo)

                self.state = 203
                localctx._keychain = self.keychain(nt_keychain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_projection, localctx.cator.combo, localctx._keychain.combo) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                nt_cator = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_cator)

                self.state = 207
                localctx.cator = self.base(nt_cator)

                nt_argchain = self.guide_nonterm(ExprRule(self._solver, nt).distill_application_argchain, localctx.cator.combo)

                self.state = 209
                localctx._argchain = self.argchain(nt_argchain)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_application, localctx.cator.combo, localctx._argchain.combo)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                nt_arg = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_arg)

                self.state = 213
                localctx.cator = self.base(nt_arg)

                nt_pipeline = self.guide_nonterm(ExprRule(self._solver, nt).distill_funnel_pipeline, localctx.cator.combo)

                self.state = 215
                localctx._pipeline = self.pipeline(nt_pipeline)

                localctx.combo = self.collect(ExprRule(self._solver, nt).combine_funnel, localctx.cator.combo, localctx._pipeline.combo)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 218
                self.match(SlimParser.T__22)

                self.guide_terminal('ID')

                self.state = 220
                localctx._ID = self.match(SlimParser.ID)

                nt_target = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_target, (None if localctx._ID is None else localctx._ID.text))

                self.state = 222
                localctx._target = self.target(nt_target)

                self.guide_symbol(';')

                self.state = 224
                self.match(SlimParser.T__18)

                nt_contin = self.guide_nonterm(ExprRule(self._solver, nt).distill_let_contin, (None if localctx._ID is None else localctx._ID.text), localctx._target.combo)

                self.state = 226
                localctx.contin = self.expr(nt_contin)

                localctx.combo = localctx.contin.combo

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 229
                self.match(SlimParser.T__23)

                self.guide_symbol('(')

                self.state = 231
                self.match(SlimParser.T__5)

                nt_body = self.guide_nonterm(ExprRule(self._solver, nt).distill_fix_body)

                self.state = 233
                localctx.body = self.expr(nt_body)

                self.guide_symbol(')')

                self.state = 235
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
            self.state = 262
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 241
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 243
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 245
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(BaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 247
                localctx.body = self.base(nt_body)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 250
                localctx._record = self.record(nt)

                localctx.combo = localctx._record.combo

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 254
                localctx._function = self.function(nt)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_function, localctx._function.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 257
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(BaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 259
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
            self.state = 285
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 265
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_pattern)

                self.state = 267
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 269
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_single_body, localctx._pattern.combo)

                self.state = 271
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(FunctionRule(self._solver, nt).combine_single, localctx._pattern.combo, localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 274
                self.match(SlimParser.T__24)

                nt_pattern = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_pattern)

                self.state = 276
                localctx._pattern = self.pattern(nt_pattern)

                self.guide_symbol('=>')

                self.state = 278
                self.match(SlimParser.T__25)

                nt_body = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_body, localctx._pattern.combo)

                self.state = 280
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(FunctionRule(self._solver, nt).distill_cons_tail, localctx._pattern.combo, localctx.body.combo)

                self.state = 282
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
            self.state = 308
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 288
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 290
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 292
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 294
                localctx.body = self.expr(nt_body)

                localctx.combo = self.collect(RecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 297
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 299
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 301
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 303
                localctx.body = self.expr(nt_body)

                nt_tail = self.guide_nonterm(RecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 305
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
            self.state = 327
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 311
                self.match(SlimParser.T__5)

                nt_content = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_single_content) 

                self.state = 313
                localctx.content = self.expr(nt_content)

                self.guide_symbol(')')

                self.state = 315
                self.match(SlimParser.T__6)

                localctx.combo = self.collect(ArgchainRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 318
                self.match(SlimParser.T__5)

                nt_head = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_head) 

                self.state = 320
                localctx.head = self.expr(nt_head)

                self.guide_symbol(')')

                self.state = 322
                self.match(SlimParser.T__6)

                nt_tail = self.guide_nonterm(ArgchainRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 324
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
            self.state = 342
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 330
                self.match(SlimParser.T__28)

                nt_content = self.guide_nonterm(PipelineRule(self._solver, nt).distill_single_content) 

                self.state = 332
                localctx.content = self.expr(nt_content)

                localctx.combo = self.collect(PipelineRule(self._solver, nt).combine_single, localctx.content.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 335
                self.match(SlimParser.T__28)

                nt_head = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_head) 

                self.state = 337
                localctx.head = self.expr(nt_head)

                nt_tail = self.guide_nonterm(PipelineRule(self._solver, nt).distill_cons_tail, localctx.head.combo) 

                self.state = 339
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
            self.state = 356
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 345
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 347
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(KeychainRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 349
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 351
                localctx._ID = self.match(SlimParser.ID)

                nt_tail = self.guide_nonterm(KeychainRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text)) 

                self.state = 353
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
            self.state = 364
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [19]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [28]:
                self.enterOuterAlt(localctx, 2)
                self.state = 359
                self.match(SlimParser.T__27)

                nt_expr = self.guide_nonterm(lambda: nt)

                self.state = 361
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
            self.state = 378
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 367
                localctx._pattern_base = self.pattern_base(nt)

                localctx.combo = localctx._pattern_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                nt_head = self.guide_nonterm(PatternRule(self._solver, nt).distill_tuple_head)

                self.state = 371
                localctx.head = self.pattern_base(nt_head)

                self.guide_symbol(',')

                self.state = 373
                self.match(SlimParser.T__10)

                nt_tail = self.guide_nonterm(PatternRule(self._solver, nt).distill_tuple_tail, localctx.head.combo)

                self.state = 375
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
            self.state = 402
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 381
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 383
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_var, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 385
                self.match(SlimParser.T__2)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_unit)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 387
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 389
                localctx._ID = self.match(SlimParser.ID)

                nt_body = self.guide_nonterm(PatternBaseRule(self._solver, nt).distill_tag_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 391
                localctx.body = self.pattern_base(nt_body)

                localctx.combo = self.collect(PatternBaseRule(self._solver, nt).combine_tag, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 394
                localctx._pattern_record = self.pattern_record(nt)

                localctx.combo = localctx._pattern_record.combo

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 397
                self.match(SlimParser.T__5)
                self.state = 398
                localctx._pattern = self.pattern(nt)
                self.state = 399
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
            self.state = 425
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 405
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 407
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 409
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_single_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 411
                localctx.body = self.pattern(nt_body)

                localctx.combo = self.collect(PatternRecordRule(self._solver, nt).combine_single, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 414
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 416
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 418
                self.match(SlimParser.T__27)

                nt_body = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_body, (None if localctx._ID is None else localctx._ID.text))

                self.state = 420
                localctx.body = self.pattern(nt_body)

                nt_tail = self.guide_nonterm(PatternRecordRule(self._solver, nt).distill_cons_tail, (None if localctx._ID is None else localctx._ID.text), localctx.body.combo)

                self.state = 422
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





