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
        4,1,33,420,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,1,0,1,0,1,0,1,0,1,0,1,0,1,0,3,0,42,
        8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,68,8,1,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
        2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,2,133,8,2,1,3,1,3,1,
        3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,146,8,3,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,3,4,158,8,4,1,5,1,5,1,5,1,5,1,5,1,5,3,5,166,
        8,5,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,
        1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,
        1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,
        1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,
        3,6,231,8,6,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,
        1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,1,7,3,7,255,8,7,1,8,1,8,1,8,1,8,
        1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
        1,8,3,8,278,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,
        1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,301,8,9,1,10,1,10,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,
        10,3,10,320,8,10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,
        11,1,11,1,11,1,11,3,11,335,8,11,1,12,1,12,1,12,1,12,1,12,1,12,1,
        12,1,12,1,12,1,12,1,12,1,12,3,12,349,8,12,1,13,1,13,1,13,1,13,1,
        13,1,13,3,13,357,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,
        14,1,14,1,14,1,14,3,14,371,8,14,1,15,1,15,1,15,1,15,1,15,1,15,1,
        15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,
        15,1,15,1,15,3,15,395,8,15,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,
        16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,
        16,3,16,418,8,16,1,16,0,0,17,0,2,4,6,8,10,12,14,16,18,20,22,24,26,
        28,30,32,0,0,462,0,41,1,0,0,0,2,67,1,0,0,0,4,132,1,0,0,0,6,145,1,
        0,0,0,8,157,1,0,0,0,10,165,1,0,0,0,12,230,1,0,0,0,14,254,1,0,0,0,
        16,277,1,0,0,0,18,300,1,0,0,0,20,319,1,0,0,0,22,334,1,0,0,0,24,348,
        1,0,0,0,26,356,1,0,0,0,28,370,1,0,0,0,30,394,1,0,0,0,32,417,1,0,
        0,0,34,42,1,0,0,0,35,36,5,31,0,0,36,42,6,0,-1,0,37,38,5,31,0,0,38,
        39,3,0,0,0,39,40,6,0,-1,0,40,42,1,0,0,0,41,34,1,0,0,0,41,35,1,0,
        0,0,41,37,1,0,0,0,42,1,1,0,0,0,43,68,1,0,0,0,44,45,5,1,0,0,45,68,
        6,1,-1,0,46,47,5,2,0,0,47,68,6,1,-1,0,48,49,5,31,0,0,49,68,6,1,-1,
        0,50,51,5,3,0,0,51,68,6,1,-1,0,52,53,5,4,0,0,53,54,5,31,0,0,54,55,
        3,2,1,0,55,56,6,1,-1,0,56,68,1,0,0,0,57,58,5,31,0,0,58,59,5,5,0,
        0,59,60,3,2,1,0,60,61,6,1,-1,0,61,68,1,0,0,0,62,63,5,6,0,0,63,64,
        3,4,2,0,64,65,5,7,0,0,65,66,6,1,-1,0,66,68,1,0,0,0,67,43,1,0,0,0,
        67,44,1,0,0,0,67,46,1,0,0,0,67,48,1,0,0,0,67,50,1,0,0,0,67,52,1,
        0,0,0,67,57,1,0,0,0,67,62,1,0,0,0,68,3,1,0,0,0,69,133,1,0,0,0,70,
        71,3,2,1,0,71,72,6,2,-1,0,72,133,1,0,0,0,73,74,3,2,1,0,74,75,5,8,
        0,0,75,76,3,4,2,0,76,77,6,2,-1,0,77,133,1,0,0,0,78,79,3,2,1,0,79,
        80,5,9,0,0,80,81,3,4,2,0,81,82,6,2,-1,0,82,133,1,0,0,0,83,84,3,2,
        1,0,84,85,3,6,3,0,85,86,6,2,-1,0,86,133,1,0,0,0,87,88,3,2,1,0,88,
        89,5,10,0,0,89,90,3,4,2,0,90,91,6,2,-1,0,91,133,1,0,0,0,92,93,3,
        2,1,0,93,94,5,11,0,0,94,95,3,4,2,0,95,96,6,2,-1,0,96,133,1,0,0,0,
        97,98,5,12,0,0,98,99,5,13,0,0,99,100,3,0,0,0,100,101,5,14,0,0,101,
        102,3,4,2,0,102,103,6,2,-1,0,103,133,1,0,0,0,104,105,5,12,0,0,105,
        106,5,13,0,0,106,107,3,0,0,0,107,108,3,8,4,0,108,109,5,14,0,0,109,
        110,3,4,2,0,110,111,6,2,-1,0,111,133,1,0,0,0,112,113,5,15,0,0,113,
        114,5,13,0,0,114,115,3,0,0,0,115,116,5,14,0,0,116,117,3,4,2,0,117,
        118,6,2,-1,0,118,133,1,0,0,0,119,120,5,15,0,0,120,121,5,13,0,0,121,
        122,3,0,0,0,122,123,3,8,4,0,123,124,5,14,0,0,124,125,3,4,2,0,125,
        126,6,2,-1,0,126,133,1,0,0,0,127,128,5,16,0,0,128,129,5,31,0,0,129,
        130,3,4,2,0,130,131,6,2,-1,0,131,133,1,0,0,0,132,69,1,0,0,0,132,
        70,1,0,0,0,132,73,1,0,0,0,132,78,1,0,0,0,132,83,1,0,0,0,132,87,1,
        0,0,0,132,92,1,0,0,0,132,97,1,0,0,0,132,104,1,0,0,0,132,112,1,0,
        0,0,132,119,1,0,0,0,132,127,1,0,0,0,133,5,1,0,0,0,134,146,1,0,0,
        0,135,136,5,17,0,0,136,137,3,4,2,0,137,138,6,3,-1,0,138,146,1,0,
        0,0,139,140,5,17,0,0,140,141,3,4,2,0,141,142,6,3,-1,0,142,143,3,
        6,3,0,143,144,6,3,-1,0,144,146,1,0,0,0,145,134,1,0,0,0,145,135,1,
        0,0,0,145,139,1,0,0,0,146,7,1,0,0,0,147,158,1,0,0,0,148,149,5,18,
        0,0,149,150,3,10,5,0,150,151,6,4,-1,0,151,158,1,0,0,0,152,153,5,
        18,0,0,153,154,3,10,5,0,154,155,3,8,4,0,155,156,6,4,-1,0,156,158,
        1,0,0,0,157,147,1,0,0,0,157,148,1,0,0,0,157,152,1,0,0,0,158,9,1,
        0,0,0,159,166,1,0,0,0,160,161,3,4,2,0,161,162,5,19,0,0,162,163,3,
        4,2,0,163,164,6,5,-1,0,164,166,1,0,0,0,165,159,1,0,0,0,165,160,1,
        0,0,0,166,11,1,0,0,0,167,231,1,0,0,0,168,169,3,14,7,0,169,170,6,
        6,-1,0,170,231,1,0,0,0,171,172,6,6,-1,0,172,173,3,14,7,0,173,174,
        6,6,-1,0,174,175,5,11,0,0,175,176,6,6,-1,0,176,177,3,12,6,0,177,
        178,6,6,-1,0,178,231,1,0,0,0,179,180,5,20,0,0,180,181,6,6,-1,0,181,
        182,3,12,6,0,182,183,6,6,-1,0,183,184,5,21,0,0,184,185,6,6,-1,0,
        185,186,3,12,6,0,186,187,6,6,-1,0,187,188,5,22,0,0,188,189,6,6,-1,
        0,189,190,3,12,6,0,190,191,6,6,-1,0,191,231,1,0,0,0,192,193,6,6,
        -1,0,193,194,3,14,7,0,194,195,6,6,-1,0,195,196,3,24,12,0,196,197,
        6,6,-1,0,197,231,1,0,0,0,198,199,6,6,-1,0,199,200,3,14,7,0,200,201,
        6,6,-1,0,201,202,3,20,10,0,202,203,6,6,-1,0,203,231,1,0,0,0,204,
        205,6,6,-1,0,205,206,3,14,7,0,206,207,6,6,-1,0,207,208,3,22,11,0,
        208,209,6,6,-1,0,209,231,1,0,0,0,210,211,5,23,0,0,211,212,6,6,-1,
        0,212,213,5,31,0,0,213,214,6,6,-1,0,214,215,3,26,13,0,215,216,6,
        6,-1,0,216,217,5,18,0,0,217,218,6,6,-1,0,218,219,3,12,6,0,219,220,
        6,6,-1,0,220,231,1,0,0,0,221,222,5,24,0,0,222,223,6,6,-1,0,223,224,
        5,6,0,0,224,225,6,6,-1,0,225,226,3,12,6,0,226,227,6,6,-1,0,227,228,
        5,7,0,0,228,229,6,6,-1,0,229,231,1,0,0,0,230,167,1,0,0,0,230,168,
        1,0,0,0,230,171,1,0,0,0,230,179,1,0,0,0,230,192,1,0,0,0,230,198,
        1,0,0,0,230,204,1,0,0,0,230,210,1,0,0,0,230,221,1,0,0,0,231,13,1,
        0,0,0,232,255,1,0,0,0,233,234,5,3,0,0,234,255,6,7,-1,0,235,236,5,
        4,0,0,236,237,6,7,-1,0,237,238,5,31,0,0,238,239,6,7,-1,0,239,240,
        3,14,7,0,240,241,6,7,-1,0,241,255,1,0,0,0,242,243,3,18,9,0,243,244,
        6,7,-1,0,244,255,1,0,0,0,245,246,6,7,-1,0,246,247,3,16,8,0,247,248,
        6,7,-1,0,248,255,1,0,0,0,249,250,5,31,0,0,250,255,6,7,-1,0,251,252,
        3,20,10,0,252,253,6,7,-1,0,253,255,1,0,0,0,254,232,1,0,0,0,254,233,
        1,0,0,0,254,235,1,0,0,0,254,242,1,0,0,0,254,245,1,0,0,0,254,249,
        1,0,0,0,254,251,1,0,0,0,255,15,1,0,0,0,256,278,1,0,0,0,257,258,5,
        25,0,0,258,259,6,8,-1,0,259,260,3,28,14,0,260,261,6,8,-1,0,261,262,
        5,26,0,0,262,263,6,8,-1,0,263,264,3,12,6,0,264,265,6,8,-1,0,265,
        278,1,0,0,0,266,267,5,25,0,0,267,268,6,8,-1,0,268,269,3,28,14,0,
        269,270,6,8,-1,0,270,271,5,26,0,0,271,272,6,8,-1,0,272,273,3,12,
        6,0,273,274,6,8,-1,0,274,275,3,16,8,0,275,276,6,8,-1,0,276,278,1,
        0,0,0,277,256,1,0,0,0,277,257,1,0,0,0,277,266,1,0,0,0,278,17,1,0,
        0,0,279,301,1,0,0,0,280,281,5,27,0,0,281,282,6,9,-1,0,282,283,5,
        31,0,0,283,284,6,9,-1,0,284,285,5,28,0,0,285,286,6,9,-1,0,286,287,
        3,12,6,0,287,288,6,9,-1,0,288,301,1,0,0,0,289,290,5,27,0,0,290,291,
        6,9,-1,0,291,292,5,31,0,0,292,293,6,9,-1,0,293,294,5,28,0,0,294,
        295,6,9,-1,0,295,296,3,12,6,0,296,297,6,9,-1,0,297,298,3,18,9,0,
        298,299,6,9,-1,0,299,301,1,0,0,0,300,279,1,0,0,0,300,280,1,0,0,0,
        300,289,1,0,0,0,301,19,1,0,0,0,302,320,1,0,0,0,303,304,5,6,0,0,304,
        305,6,10,-1,0,305,306,3,12,6,0,306,307,6,10,-1,0,307,308,5,7,0,0,
        308,309,6,10,-1,0,309,320,1,0,0,0,310,311,5,6,0,0,311,312,6,10,-1,
        0,312,313,3,12,6,0,313,314,6,10,-1,0,314,315,5,7,0,0,315,316,6,10,
        -1,0,316,317,3,20,10,0,317,318,6,10,-1,0,318,320,1,0,0,0,319,302,
        1,0,0,0,319,303,1,0,0,0,319,310,1,0,0,0,320,21,1,0,0,0,321,335,1,
        0,0,0,322,323,5,29,0,0,323,324,6,11,-1,0,324,325,3,12,6,0,325,326,
        6,11,-1,0,326,335,1,0,0,0,327,328,5,29,0,0,328,329,6,11,-1,0,329,
        330,3,12,6,0,330,331,6,11,-1,0,331,332,3,22,11,0,332,333,6,11,-1,
        0,333,335,1,0,0,0,334,321,1,0,0,0,334,322,1,0,0,0,334,327,1,0,0,
        0,335,23,1,0,0,0,336,349,1,0,0,0,337,338,5,30,0,0,338,339,6,12,-1,
        0,339,340,5,31,0,0,340,349,6,12,-1,0,341,342,5,30,0,0,342,343,6,
        12,-1,0,343,344,5,31,0,0,344,345,6,12,-1,0,345,346,3,24,12,0,346,
        347,6,12,-1,0,347,349,1,0,0,0,348,336,1,0,0,0,348,337,1,0,0,0,348,
        341,1,0,0,0,349,25,1,0,0,0,350,357,1,0,0,0,351,352,5,28,0,0,352,
        353,6,13,-1,0,353,354,3,12,6,0,354,355,6,13,-1,0,355,357,1,0,0,0,
        356,350,1,0,0,0,356,351,1,0,0,0,357,27,1,0,0,0,358,371,1,0,0,0,359,
        360,3,30,15,0,360,361,6,14,-1,0,361,371,1,0,0,0,362,363,6,14,-1,
        0,363,364,3,30,15,0,364,365,6,14,-1,0,365,366,5,11,0,0,366,367,6,
        14,-1,0,367,368,3,28,14,0,368,369,6,14,-1,0,369,371,1,0,0,0,370,
        358,1,0,0,0,370,359,1,0,0,0,370,362,1,0,0,0,371,29,1,0,0,0,372,395,
        1,0,0,0,373,374,5,31,0,0,374,395,6,15,-1,0,375,376,5,31,0,0,376,
        395,6,15,-1,0,377,378,5,3,0,0,378,395,6,15,-1,0,379,380,5,4,0,0,
        380,381,6,15,-1,0,381,382,5,31,0,0,382,383,6,15,-1,0,383,384,3,30,
        15,0,384,385,6,15,-1,0,385,395,1,0,0,0,386,387,3,32,16,0,387,388,
        6,15,-1,0,388,395,1,0,0,0,389,390,5,6,0,0,390,391,3,28,14,0,391,
        392,5,7,0,0,392,393,6,15,-1,0,393,395,1,0,0,0,394,372,1,0,0,0,394,
        373,1,0,0,0,394,375,1,0,0,0,394,377,1,0,0,0,394,379,1,0,0,0,394,
        386,1,0,0,0,394,389,1,0,0,0,395,31,1,0,0,0,396,418,1,0,0,0,397,398,
        5,27,0,0,398,399,6,16,-1,0,399,400,5,31,0,0,400,401,6,16,-1,0,401,
        402,5,28,0,0,402,403,6,16,-1,0,403,404,3,28,14,0,404,405,6,16,-1,
        0,405,418,1,0,0,0,406,407,5,27,0,0,407,408,6,16,-1,0,408,409,5,31,
        0,0,409,410,6,16,-1,0,410,411,5,28,0,0,411,412,6,16,-1,0,412,413,
        3,28,14,0,413,414,6,16,-1,0,414,415,3,32,16,0,415,416,6,16,-1,0,
        416,418,1,0,0,0,417,396,1,0,0,0,417,397,1,0,0,0,417,406,1,0,0,0,
        418,33,1,0,0,0,17,41,67,132,145,157,165,230,254,277,300,319,334,
        348,356,370,394,417
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'TOP'", "'BOT'", "'@'", "'~'", "':'", 
                     "'('", "')'", "'|'", "'&'", "'->'", "','", "'EXI'", 
                     "'['", "']'", "'ALL'", "'LFP'", "'\\'", "';'", "'<:'", 
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
    RULE_base_pattern = 15
    RULE_record_pattern = 16

    ruleNames =  [ "ids", "typ_base", "typ", "negchain", "qualification", 
                   "subtyping", "expr", "base", "function", "record", "argchain", 
                   "pipeline", "keychain", "target", "pattern", "base_pattern", 
                   "record_pattern" ]

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
        self._solver = default_solver 
        self._cache = {}
        self._guidance = default_nonterm 
        self._overflow = False  

    def reset(self): 
        self._guidance = default_nonterm
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

        result_nt = None
        if not self._overflow:
            result_nt = f(*args)
            self._guidance = result_nt

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return result_nt 



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

        def typ_base(self):
            return self.getTypedRuleContext(SlimParser.Typ_baseContext,0)


        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


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
            self.state = 132
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
                localctx._ids = self.ids()
                self.state = 115
                self.match(SlimParser.T__13)
                self.state = 116
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 119
                self.match(SlimParser.T__14)
                self.state = 120
                self.match(SlimParser.T__12)
                self.state = 121
                localctx._ids = self.ids()
                self.state = 122
                localctx._qualification = self.qualification()
                self.state = 123
                self.match(SlimParser.T__13)
                self.state = 124
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 127
                self.match(SlimParser.T__15)
                self.state = 128
                localctx._ID = self.match(SlimParser.ID)
                self.state = 129
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
            self.state = 145
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 135
                self.match(SlimParser.T__16)
                self.state = 136
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 139
                self.match(SlimParser.T__16)
                self.state = 140
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 142
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
            self.state = 157
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 148
                self.match(SlimParser.T__17)
                self.state = 149
                localctx._subtyping = self.subtyping()

                localctx.combo = tuple([localctx._subtyping.combo])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 152
                self.match(SlimParser.T__17)
                self.state = 153
                localctx._subtyping = self.subtyping()
                self.state = 154
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
            self.state = 165
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [14, 18]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [1, 2, 3, 4, 6, 8, 9, 10, 11, 12, 15, 16, 17, 19, 31]:
                self.enterOuterAlt(localctx, 2)
                self.state = 160
                localctx.strong = self.typ()
                self.state = 161
                self.match(SlimParser.T__18)
                self.state = 162
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
            self.models = None
            self._base = None # BaseContext
            self.head = None # BaseContext
            self.tail = None # ExprContext
            self.condition = None # ExprContext
            self.true_branch = None # ExprContext
            self.false_branch = None # ExprContext
            self.rator = None # BaseContext
            self._keychain = None # KeychainContext
            self.cator = None # BaseContext
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
            self.state = 230
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 168
                localctx._base = self.base(nt)

                localctx.models = localctx._base.models

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                head_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_head, nt)

                self.state = 172
                localctx.head = self.base(head_nt)

                self.guide_symbol(',')

                self.state = 174
                self.match(SlimParser.T__10)

                nt = replace(nt, models = localctx.head.models)
                tail_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_tail, nt, head_nt.typ_var)

                self.state = 176
                localctx.tail = self.expr(tail_nt)

                nt = replace(nt, models = localctx.tail.models)
                localctx.models = self.collect(ExprRule(self._solver).combine_tuple, nt, head_nt.typ_var, tail_nt.typ_var) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 179
                self.match(SlimParser.T__19)

                condition_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_condition, nt)

                self.state = 181
                localctx.condition = self.expr(condition_nt)

                self.guide_symbol('then')

                self.state = 183
                self.match(SlimParser.T__20)

                nt = replace(nt, models = condition.models)
                true_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_true_branch, nt, condition_nt.typ_var)

                self.state = 185
                localctx.true_branch = self.expr(true_branch_nt)

                self.guide_symbol('else')

                self.state = 187
                self.match(SlimParser.T__21)

                nt = replace(nt, models = true_branch.models)
                false_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_false_branch, nt, condition_nt.typ_var, true_branch_nt.typ_var)

                self.state = 189
                localctx.false_branch = self.expr(false_branch_nt)

                localctx.models = self.collect(ExprRule(self._solver).combine_ite, nt, condition_nt.typ_var, true_branch_nt.typ_var, false_branch_nt.typ_var) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                rator_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_rator, nt)

                self.state = 193
                localctx.rator = self.base(rator_nt)

                nt = replace(nt, models = localctx.rator.models)
                keychain_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_keychain, nt, rator_nt.typ_var)

                self.state = 195
                localctx._keychain = self.keychain(keychain_nt)

                nt = replace(nt, models = keychain_nt.models)
                localctx.models = self.collect(ExprRule(self._solver).combine_projection, nt, rator_nt.typ_var, localctx._keychain.keys) 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                cator_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_cator, nt)

                self.state = 199
                localctx.cator = self.base(cator_nt)

                nt = replace(nt, models = localctx.cator.models)
                argchain_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_argchain, nt, cator_nt.typ_var)

                self.state = 201
                localctx._argchain = self.argchain(argchain_nt)

                nt = replace(nt, models = localctx._argchain.attr.models)
                localctx.models = self.collect(ExprRule(self._solver).combine_application, nt, cator_nt.typ_var, localctx._argchain.attr.args)

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                arg_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_arg, nt)

                self.state = 205
                localctx.cator = self.base(arg_nt)

                nt = replace(nt, models = localctx.cator.models)
                pipeline_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_pipeline, nt, cator_nt.typ_var)

                self.state = 207
                localctx._pipeline = self.pipeline(pipeline_nt)

                nt = replace(nt, models = pipeline_nt.models)
                localctx.models = self.collect(ExprRule(self._solver).combine_funnel, nt, cator.typ_var, localctx._pipeline.cator_vars)

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 210
                self.match(SlimParser.T__22)

                self.guide_terminal('ID')

                self.state = 212
                localctx._ID = self.match(SlimParser.ID)

                target_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_target, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 214
                localctx._target = self.target(target_nt)

                self.guide_symbol(';')

                self.state = 216
                self.match(SlimParser.T__17)

                nt = replace(nt, models = localctx._target.models)
                contin_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_contin, nt, (None if localctx._ID is None else localctx._ID.text), target_nt.typ_var)

                self.state = 218
                localctx.contin = self.expr(contin_nt)

                localctx.models = localctx.contin.models

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 221
                self.match(SlimParser.T__23)

                self.guide_symbol('(')

                self.state = 223
                self.match(SlimParser.T__5)

                body_nt = self.guide_nonterm(ExprRule(self._solver).distill_fix_body, nt)

                self.state = 225
                localctx.body = self.expr(body_nt)

                self.guide_symbol(')')

                self.state = 227
                self.match(SlimParser.T__6)

                nt = replace(nt, models = localctx.body.models)
                localctx.models = self.collect(ExprRule(self._solver).combine_fix, nt, body_nt.typ_var)

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
            self.models = None
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
            self.state = 254
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,7,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 233
                self.match(SlimParser.T__2)

                localctx.models = self.collect(BaseRule(self._solver).combine_unit, nt)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 235
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 237
                localctx._ID = self.match(SlimParser.ID)

                body_nt = self.guide_nonterm(BaseRule(self._solver).distill_tag_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 239
                localctx.body = self.base(body_nt)

                nt = replace(nt, models = localctx.body.models)
                localctx.models = self.collect(BaseRule(self._solver).combine_tag, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var)

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 242
                localctx._record = self.record(nt)

                localctx.models = localctx._record.models

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 246
                localctx._function = self.function(nt)

                (models, branches) = localctx._function.models_branches
                nt = replace(nt, models = models)
                localctx.models = self.collect(BaseRule(self._solver).combine_function, nt, branches)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 249
                localctx._ID = self.match(SlimParser.ID)

                localctx.models = self.collect(BaseRule(self._solver).combine_var, nt, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 251
                localctx._argchain = self.argchain(nt)

                nt = replace(nt, models = localctx._argchain.attr.models)
                localctx.models = self.collect(BaseRule(self._solver).combine_assoc, nt, localctx._argchain.attr.args)

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
            self.models_branches = None
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
            self.state = 277
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 257
                self.match(SlimParser.T__24)

                pattern_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_pattern, nt)

                self.state = 259
                localctx._pattern = self.pattern(pattern_nt)

                self.guide_symbol('=>')

                self.state = 261
                self.match(SlimParser.T__25)

                nt = replace(nt, enviro =  localctx._pattern.attr.enviro, models = localctx._pattern.attr.models)
                body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_body, nt, localctx._pattern.attr.typ)

                self.state = 263
                localctx.body = self.expr(body_nt)

                nt = replace(nt, models = localctx.body.models)
                localctx.models_branches = (localctx.body.models, self.collect(FunctionRule(self._solver).combine_single, nt, localctx._pattern.attr.typ, body_nt.typ_var))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 266
                self.match(SlimParser.T__24)

                pattern_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_pattern, nt)

                self.state = 268
                localctx._pattern = self.pattern(pattern_nt)

                self.guide_symbol('=>')

                self.state = 270
                self.match(SlimParser.T__25)

                nt = replace(nt, enviro =  localctx._pattern.attr.enviro, models = localctx._pattern.attr.models)
                body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_body, nt, localctx._pattern.attr.typ)

                self.state = 272
                localctx.body = self.expr(body_nt)

                nt = replace(nt, models = localctx.body.models)
                tail_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_tail, nt, localctx._pattern.attr.typ, body_nt.typ_var)

                self.state = 274
                localctx.tail = self.function(tail_nt)

                (models, branches) = localctx.tail.models_branches
                localctx.models_branches = (models, self.collect(FunctionRule(self._solver).combine_cons, nt, localctx._pattern.attr.typ, body_nt.typ_var, branches))

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
            self.models = None
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
            self.state = 300
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 280
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 282
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 284
                self.match(SlimParser.T__27)

                body_nt = self.guide_nonterm(RecordRule(self._solver).distill_single_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 286
                localctx.body = self.expr(body_nt)

                nt = replace(nt, models = localctx.body.models)
                localctx.models = self.collect(RecordRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 289
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 291
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 293
                self.match(SlimParser.T__27)

                body_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 295
                localctx.body = self.expr(body_nt)

                nt = replace(nt, models = localctx.body.models)
                tail_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_tail, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var)

                self.state = 297
                localctx.tail = self.record(tail_nt)

                nt = replace(nt, models = localctx.tail.models)
                localctx.models = self.collect(RecordRule(self._solver).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var, tail_nt.typ_var)

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
            self.attr = None
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
            self.state = 319
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 303
                self.match(SlimParser.T__5)

                content_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_single_content, nt) 

                self.state = 305
                localctx.content = self.expr(content_nt)

                self.guide_symbol(')')

                self.state = 307
                self.match(SlimParser.T__6)

                nt = replace(nt, models = localctx.content.models)
                localctx.attr = self.collect(ArgchainRule(self._solver).combine_single, nt, content_nt.typ_var)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 310
                self.match(SlimParser.T__5)

                head_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_cons_head, nt) 

                self.state = 312
                localctx.head = self.expr(head_nt)

                self.guide_symbol(')')

                self.state = 314
                self.match(SlimParser.T__6)

                nt = replace(nt, models = localctx.head.models)

                self.state = 316
                localctx.tail = self.argchain(nt)

                nt = replace(nt, models = localctx.tail.attr.models)
                localctx.attr = self.collect(ArgchainRule(self._solver).combine_cons, nt, head_nt.typ_var, localctx.tail.attr.args)

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
            self.cator_vars = None
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
            self.state = 334
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 322
                self.match(SlimParser.T__28)

                content_nt = self.guide_nonterm(PipelineRule(self._solver).distill_single_content, nt) 

                self.state = 324
                localctx.content = self.expr(content_nt)

                nt = replace(nt, models = content.models)
                localctx.cator_vars = self.collect(PipelineRule(self._solver).combine_single, nt, content_nt.typ_var)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 327
                self.match(SlimParser.T__28)

                head_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_head, nt) 

                self.state = 329
                localctx.head = self.expr(head_nt)

                nt = replace(nt, models = localctx.head.models)
                tail_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_tail, nt, head_nt.typ_var) 

                self.state = 331
                localctx.tail = self.pipeline(tail_nt)

                localctx.cator_vars = self.collect(ArgchainRule(self._solver, nt).combine_cons, nt, head_nt.typ_var, localctx.tail.cator_vars)

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
            self.keys = None
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
            self.state = 348
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 337
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 339
                localctx._ID = self.match(SlimParser.ID)

                localctx.keys = self.collect(KeychainRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 341
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 343
                localctx._ID = self.match(SlimParser.ID)


                self.state = 345
                localctx.tail = self.keychain(nt)

                localctx.keys = self.collect(KeychainRule(self._solver).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), localctx.tail.keys)

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
            self.models = None
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
            self.state = 356
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [18]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [28]:
                self.enterOuterAlt(localctx, 2)
                self.state = 351
                self.match(SlimParser.T__27)

                expr_nt = self.guide_nonterm(lambda: nt)

                self.state = 353
                localctx._expr = self.expr(expr_nt)

                localctx.models = localctx._expr.models

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
            self.attr = None
            self._base_pattern = None # Base_patternContext
            self.head = None # Base_patternContext
            self.tail = None # PatternContext
            self.nt = nt

        def base_pattern(self):
            return self.getTypedRuleContext(SlimParser.Base_patternContext,0)


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
            self.state = 370
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 359
                localctx._base_pattern = self.base_pattern(nt)

                localctx.attr = localctx._base_pattern.attr

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                head_nt = self.guide_nonterm(PatternRule(self._solver).distill_tuple_head, nt)

                self.state = 363
                localctx.head = self.base_pattern(head_nt)

                self.guide_symbol(',')

                self.state = 365
                self.match(SlimParser.T__10)

                nt = replace(nt, enviro =  localctx.head.attr.enviro, models = localctx.head.attr.models)
                tail_nt = self.guide_nonterm(PatternRule(self._solver).distill_tuple_tail, nt, localctx.head.attr.typ)

                self.state = 367
                localctx.tail = self.pattern(tail_nt)

                localctx.attr = self.collect(PatternRule(self._solver, nt).combine_tuple, localctx.head.attr.typ, localctx.tail.attr.typ) 

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Base_patternContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.attr = None
            self._ID = None # Token
            self.body = None # Base_patternContext
            self._record_pattern = None # Record_patternContext
            self._pattern = None # PatternContext
            self.nt = nt

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def base_pattern(self):
            return self.getTypedRuleContext(SlimParser.Base_patternContext,0)


        def record_pattern(self):
            return self.getTypedRuleContext(SlimParser.Record_patternContext,0)


        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_base_pattern

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterBase_pattern" ):
                listener.enterBase_pattern(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitBase_pattern" ):
                listener.exitBase_pattern(self)




    def base_pattern(self, nt:Nonterm):

        localctx = SlimParser.Base_patternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 30, self.RULE_base_pattern)
        try:
            self.state = 394
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,15,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 373
                localctx._ID = self.match(SlimParser.ID)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 375
                localctx._ID = self.match(SlimParser.ID)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 377
                self.match(SlimParser.T__2)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_unit, nt)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 379
                self.match(SlimParser.T__3)

                self.guide_terminal('ID')

                self.state = 381
                localctx._ID = self.match(SlimParser.ID)

                body_nt = self.guide_nonterm(BasePatternRule(self._solver).distill_tag_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 383
                localctx.body = self.base_pattern(body_nt)


                nt = replace(nt, enviro =  localctx.body.attr.enviro, models = localctx.body.attr.models)
                localctx.attr = self.collect(BasePatternRule(self._solver).combine_tag, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr.typ)

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 386
                localctx._record_pattern = self.record_pattern(nt)

                localctx.attr = localctx._record_pattern.attr

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 389
                self.match(SlimParser.T__5)
                self.state = 390
                localctx._pattern = self.pattern(nt)
                self.state = 391
                self.match(SlimParser.T__6)

                localctx.attr = localctx._pattern.attr

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Record_patternContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Nonterm=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.attr = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # Record_patternContext
            self.nt = nt

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def pattern(self):
            return self.getTypedRuleContext(SlimParser.PatternContext,0)


        def record_pattern(self):
            return self.getTypedRuleContext(SlimParser.Record_patternContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_record_pattern

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterRecord_pattern" ):
                listener.enterRecord_pattern(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitRecord_pattern" ):
                listener.exitRecord_pattern(self)




    def record_pattern(self, nt:Nonterm):

        localctx = SlimParser.Record_patternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 32, self.RULE_record_pattern)
        try:
            self.state = 417
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 397
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 399
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 401
                self.match(SlimParser.T__27)

                body_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_single_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 403
                localctx.body = self.pattern(body_nt)

                nt = replace(nt, enviro = localctx.body.attr.enviro, models = localctx.body.attr.models)
                localctx.attr = self.collect(RecordPatternRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr.typ)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 406
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 408
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 410
                self.match(SlimParser.T__27)


                body_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_cons_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 412
                localctx.body = self.pattern(body_nt)


                nt = replace(nt, enviro = localctx.body.attr.enviro, models = localctx.body.attr.models)
                tail_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_cons_tail, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr.typ)

                self.state = 414
                localctx.tail = self.record_pattern(tail_nt)


                nt = replace(nt, enviro = localctx.tail.attr.enviro, models = localctx.tail.attr.models)
                localctx.attr = self.collect(RecordPatternRule(self._solver, nt).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr.typ, localctx.tail.attr.typ)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





