# Generated from /Users/thomas/tlogan@github.com/ERST/src/tapas/slim/Slim.g4 by ANTLR 4.13.0
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

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset


def serializedATN():
    return [
        4,1,34,407,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,3,0,46,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,3,1,62,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,
        2,73,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,
        1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,99,8,3,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,165,8,4,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,178,8,5,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,190,8,6,1,7,1,7,1,7,1,7,1,7,1,
        7,3,7,198,8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,3,8,247,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,269,8,9,1,10,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,
        286,8,10,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,
        1,11,1,11,1,11,1,11,1,11,3,11,304,8,11,1,12,1,12,1,12,1,12,1,12,
        1,12,1,12,1,12,1,12,1,12,3,12,316,8,12,1,13,1,13,1,13,1,13,1,13,
        1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,3,13,331,8,13,1,14,1,14,
        1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,3,14,344,8,14,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,1,15,3,15,357,8,15,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,369,8,16,
        1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,
        1,17,1,17,1,17,1,17,1,17,3,17,389,8,17,1,18,1,18,1,18,1,18,1,18,
        1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,3,18,405,8,18,1,18,
        0,0,19,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,0,0,451,
        0,45,1,0,0,0,2,61,1,0,0,0,4,72,1,0,0,0,6,98,1,0,0,0,8,164,1,0,0,
        0,10,177,1,0,0,0,12,189,1,0,0,0,14,197,1,0,0,0,16,246,1,0,0,0,18,
        268,1,0,0,0,20,285,1,0,0,0,22,303,1,0,0,0,24,315,1,0,0,0,26,330,
        1,0,0,0,28,343,1,0,0,0,30,356,1,0,0,0,32,368,1,0,0,0,34,388,1,0,
        0,0,36,404,1,0,0,0,38,46,1,0,0,0,39,40,5,32,0,0,40,46,6,0,-1,0,41,
        42,5,32,0,0,42,43,3,0,0,0,43,44,6,0,-1,0,44,46,1,0,0,0,45,38,1,0,
        0,0,45,39,1,0,0,0,45,41,1,0,0,0,46,1,1,0,0,0,47,62,1,0,0,0,48,49,
        5,1,0,0,49,50,5,32,0,0,50,51,5,2,0,0,51,52,3,8,4,0,52,53,6,1,-1,
        0,53,62,1,0,0,0,54,55,5,1,0,0,55,56,5,32,0,0,56,57,5,2,0,0,57,58,
        3,8,4,0,58,59,3,2,1,0,59,60,6,1,-1,0,60,62,1,0,0,0,61,47,1,0,0,0,
        61,48,1,0,0,0,61,54,1,0,0,0,62,3,1,0,0,0,63,73,1,0,0,0,64,65,3,2,
        1,0,65,66,6,2,-1,0,66,67,3,16,8,0,67,68,6,2,-1,0,68,73,1,0,0,0,69,
        70,3,16,8,0,70,71,6,2,-1,0,71,73,1,0,0,0,72,63,1,0,0,0,72,64,1,0,
        0,0,72,69,1,0,0,0,73,5,1,0,0,0,74,99,1,0,0,0,75,76,5,3,0,0,76,99,
        6,3,-1,0,77,78,5,4,0,0,78,99,6,3,-1,0,79,80,5,32,0,0,80,99,6,3,-1,
        0,81,82,5,5,0,0,82,99,6,3,-1,0,83,84,5,6,0,0,84,85,5,32,0,0,85,86,
        3,6,3,0,86,87,6,3,-1,0,87,99,1,0,0,0,88,89,5,32,0,0,89,90,5,7,0,
        0,90,91,3,6,3,0,91,92,6,3,-1,0,92,99,1,0,0,0,93,94,5,8,0,0,94,95,
        3,8,4,0,95,96,5,9,0,0,96,97,6,3,-1,0,97,99,1,0,0,0,98,74,1,0,0,0,
        98,75,1,0,0,0,98,77,1,0,0,0,98,79,1,0,0,0,98,81,1,0,0,0,98,83,1,
        0,0,0,98,88,1,0,0,0,98,93,1,0,0,0,99,7,1,0,0,0,100,165,1,0,0,0,101,
        102,3,6,3,0,102,103,6,4,-1,0,103,165,1,0,0,0,104,105,3,6,3,0,105,
        106,5,10,0,0,106,107,3,8,4,0,107,108,6,4,-1,0,108,165,1,0,0,0,109,
        110,3,6,3,0,110,111,5,11,0,0,111,112,3,8,4,0,112,113,6,4,-1,0,113,
        165,1,0,0,0,114,115,3,6,3,0,115,116,3,10,5,0,116,117,6,4,-1,0,117,
        165,1,0,0,0,118,119,3,6,3,0,119,120,5,12,0,0,120,121,3,8,4,0,121,
        122,6,4,-1,0,122,165,1,0,0,0,123,124,3,6,3,0,124,125,5,13,0,0,125,
        126,3,8,4,0,126,127,6,4,-1,0,127,165,1,0,0,0,128,129,5,14,0,0,129,
        130,5,15,0,0,130,131,3,0,0,0,131,132,5,16,0,0,132,133,3,8,4,0,133,
        134,6,4,-1,0,134,165,1,0,0,0,135,136,5,14,0,0,136,137,5,15,0,0,137,
        138,3,0,0,0,138,139,3,12,6,0,139,140,5,16,0,0,140,141,3,8,4,0,141,
        142,6,4,-1,0,142,165,1,0,0,0,143,144,5,17,0,0,144,145,5,15,0,0,145,
        146,3,0,0,0,146,147,5,16,0,0,147,148,3,8,4,0,148,149,6,4,-1,0,149,
        165,1,0,0,0,150,151,5,17,0,0,151,152,5,15,0,0,152,153,3,0,0,0,153,
        154,3,12,6,0,154,155,5,16,0,0,155,156,3,8,4,0,156,157,6,4,-1,0,157,
        165,1,0,0,0,158,159,5,18,0,0,159,160,5,32,0,0,160,161,5,10,0,0,161,
        162,3,8,4,0,162,163,6,4,-1,0,163,165,1,0,0,0,164,100,1,0,0,0,164,
        101,1,0,0,0,164,104,1,0,0,0,164,109,1,0,0,0,164,114,1,0,0,0,164,
        118,1,0,0,0,164,123,1,0,0,0,164,128,1,0,0,0,164,135,1,0,0,0,164,
        143,1,0,0,0,164,150,1,0,0,0,164,158,1,0,0,0,165,9,1,0,0,0,166,178,
        1,0,0,0,167,168,5,19,0,0,168,169,3,8,4,0,169,170,6,5,-1,0,170,178,
        1,0,0,0,171,172,5,19,0,0,172,173,3,8,4,0,173,174,6,5,-1,0,174,175,
        3,10,5,0,175,176,6,5,-1,0,176,178,1,0,0,0,177,166,1,0,0,0,177,167,
        1,0,0,0,177,171,1,0,0,0,178,11,1,0,0,0,179,190,1,0,0,0,180,181,5,
        20,0,0,181,182,3,14,7,0,182,183,6,6,-1,0,183,190,1,0,0,0,184,185,
        5,20,0,0,185,186,3,14,7,0,186,187,3,12,6,0,187,188,6,6,-1,0,188,
        190,1,0,0,0,189,179,1,0,0,0,189,180,1,0,0,0,189,184,1,0,0,0,190,
        13,1,0,0,0,191,198,1,0,0,0,192,193,3,8,4,0,193,194,5,21,0,0,194,
        195,3,8,4,0,195,196,6,7,-1,0,196,198,1,0,0,0,197,191,1,0,0,0,197,
        192,1,0,0,0,198,15,1,0,0,0,199,247,1,0,0,0,200,201,3,18,9,0,201,
        202,6,8,-1,0,202,247,1,0,0,0,203,204,3,18,9,0,204,205,5,13,0,0,205,
        206,6,8,-1,0,206,207,3,16,8,0,207,208,6,8,-1,0,208,247,1,0,0,0,209,
        210,5,22,0,0,210,211,3,16,8,0,211,212,5,23,0,0,212,213,6,8,-1,0,
        213,214,3,16,8,0,214,215,5,24,0,0,215,216,3,16,8,0,216,217,6,8,-1,
        0,217,247,1,0,0,0,218,219,3,18,9,0,219,220,3,24,12,0,220,221,6,8,
        -1,0,221,247,1,0,0,0,222,223,3,18,9,0,223,224,6,8,-1,0,224,225,3,
        26,13,0,225,226,6,8,-1,0,226,247,1,0,0,0,227,228,3,18,9,0,228,229,
        6,8,-1,0,229,230,3,28,14,0,230,231,6,8,-1,0,231,247,1,0,0,0,232,
        233,5,25,0,0,233,234,5,32,0,0,234,235,3,30,15,0,235,236,5,26,0,0,
        236,237,6,8,-1,0,237,238,3,16,8,0,238,239,6,8,-1,0,239,247,1,0,0,
        0,240,241,5,27,0,0,241,242,5,8,0,0,242,243,3,16,8,0,243,244,5,9,
        0,0,244,245,6,8,-1,0,245,247,1,0,0,0,246,199,1,0,0,0,246,200,1,0,
        0,0,246,203,1,0,0,0,246,209,1,0,0,0,246,218,1,0,0,0,246,222,1,0,
        0,0,246,227,1,0,0,0,246,232,1,0,0,0,246,240,1,0,0,0,247,17,1,0,0,
        0,248,269,1,0,0,0,249,250,5,5,0,0,250,269,6,9,-1,0,251,252,5,6,0,
        0,252,253,5,32,0,0,253,254,3,18,9,0,254,255,6,9,-1,0,255,269,1,0,
        0,0,256,257,3,20,10,0,257,258,6,9,-1,0,258,269,1,0,0,0,259,260,6,
        9,-1,0,260,261,3,22,11,0,261,262,6,9,-1,0,262,269,1,0,0,0,263,264,
        5,32,0,0,264,269,6,9,-1,0,265,266,3,26,13,0,266,267,6,9,-1,0,267,
        269,1,0,0,0,268,248,1,0,0,0,268,249,1,0,0,0,268,251,1,0,0,0,268,
        256,1,0,0,0,268,259,1,0,0,0,268,263,1,0,0,0,268,265,1,0,0,0,269,
        19,1,0,0,0,270,286,1,0,0,0,271,272,5,20,0,0,272,273,5,32,0,0,273,
        274,5,2,0,0,274,275,3,16,8,0,275,276,6,10,-1,0,276,286,1,0,0,0,277,
        278,5,20,0,0,278,279,5,32,0,0,279,280,5,2,0,0,280,281,3,16,8,0,281,
        282,6,10,-1,0,282,283,3,20,10,0,283,284,6,10,-1,0,284,286,1,0,0,
        0,285,270,1,0,0,0,285,271,1,0,0,0,285,277,1,0,0,0,286,21,1,0,0,0,
        287,304,1,0,0,0,288,289,5,28,0,0,289,290,3,32,16,0,290,291,5,29,
        0,0,291,292,6,11,-1,0,292,293,3,16,8,0,293,294,6,11,-1,0,294,304,
        1,0,0,0,295,296,5,28,0,0,296,297,3,32,16,0,297,298,5,29,0,0,298,
        299,6,11,-1,0,299,300,3,16,8,0,300,301,3,22,11,0,301,302,6,11,-1,
        0,302,304,1,0,0,0,303,287,1,0,0,0,303,288,1,0,0,0,303,295,1,0,0,
        0,304,23,1,0,0,0,305,316,1,0,0,0,306,307,5,30,0,0,307,308,5,32,0,
        0,308,316,6,12,-1,0,309,310,5,30,0,0,310,311,5,32,0,0,311,312,6,
        12,-1,0,312,313,3,24,12,0,313,314,6,12,-1,0,314,316,1,0,0,0,315,
        305,1,0,0,0,315,306,1,0,0,0,315,309,1,0,0,0,316,25,1,0,0,0,317,331,
        1,0,0,0,318,319,5,8,0,0,319,320,3,16,8,0,320,321,5,9,0,0,321,322,
        6,13,-1,0,322,331,1,0,0,0,323,324,5,8,0,0,324,325,3,16,8,0,325,326,
        5,9,0,0,326,327,6,13,-1,0,327,328,3,26,13,0,328,329,6,13,-1,0,329,
        331,1,0,0,0,330,317,1,0,0,0,330,318,1,0,0,0,330,323,1,0,0,0,331,
        27,1,0,0,0,332,344,1,0,0,0,333,334,5,31,0,0,334,335,3,16,8,0,335,
        336,6,14,-1,0,336,344,1,0,0,0,337,338,5,31,0,0,338,339,3,16,8,0,
        339,340,6,14,-1,0,340,341,3,28,14,0,341,342,6,14,-1,0,342,344,1,
        0,0,0,343,332,1,0,0,0,343,333,1,0,0,0,343,337,1,0,0,0,344,29,1,0,
        0,0,345,357,1,0,0,0,346,347,5,2,0,0,347,348,3,16,8,0,348,349,6,15,
        -1,0,349,357,1,0,0,0,350,351,5,7,0,0,351,352,3,8,4,0,352,353,5,2,
        0,0,353,354,3,16,8,0,354,355,6,15,-1,0,355,357,1,0,0,0,356,345,1,
        0,0,0,356,346,1,0,0,0,356,350,1,0,0,0,357,31,1,0,0,0,358,369,1,0,
        0,0,359,360,3,34,17,0,360,361,6,16,-1,0,361,369,1,0,0,0,362,363,
        6,16,-1,0,363,364,3,34,17,0,364,365,5,13,0,0,365,366,3,32,16,0,366,
        367,6,16,-1,0,367,369,1,0,0,0,368,358,1,0,0,0,368,359,1,0,0,0,368,
        362,1,0,0,0,369,33,1,0,0,0,370,389,1,0,0,0,371,372,5,32,0,0,372,
        389,6,17,-1,0,373,374,5,5,0,0,374,389,6,17,-1,0,375,376,5,6,0,0,
        376,377,5,32,0,0,377,378,3,34,17,0,378,379,6,17,-1,0,379,389,1,0,
        0,0,380,381,3,36,18,0,381,382,6,17,-1,0,382,389,1,0,0,0,383,384,
        5,8,0,0,384,385,3,32,16,0,385,386,5,9,0,0,386,387,6,17,-1,0,387,
        389,1,0,0,0,388,370,1,0,0,0,388,371,1,0,0,0,388,373,1,0,0,0,388,
        375,1,0,0,0,388,380,1,0,0,0,388,383,1,0,0,0,389,35,1,0,0,0,390,405,
        1,0,0,0,391,392,5,20,0,0,392,393,5,32,0,0,393,394,5,2,0,0,394,395,
        3,32,16,0,395,396,6,18,-1,0,396,405,1,0,0,0,397,398,5,20,0,0,398,
        399,5,32,0,0,399,400,5,2,0,0,400,401,3,32,16,0,401,402,3,36,18,0,
        402,403,6,18,-1,0,403,405,1,0,0,0,404,390,1,0,0,0,404,391,1,0,0,
        0,404,397,1,0,0,0,405,37,1,0,0,0,19,45,61,72,98,164,177,189,197,
        246,268,285,303,315,330,343,356,368,388,404
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'alias'", "'='", "'TOP'", "'BOT'", "'@'", 
                     "'~'", "':'", "'('", "')'", "'|'", "'&'", "'->'", "','", 
                     "'EXI'", "'['", "']'", "'ALL'", "'FX'", "'\\'", "';'", 
                     "'<:'", "'if'", "'then'", "'else'", "'let'", "'in'", 
                     "'fix'", "'case'", "'=>'", "'.'", "'|>'" ]

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
    RULE_preamble = 1
    RULE_program = 2
    RULE_typ_base = 3
    RULE_typ = 4
    RULE_negchain = 5
    RULE_qualification = 6
    RULE_subtyping = 7
    RULE_expr = 8
    RULE_base = 9
    RULE_record = 10
    RULE_function = 11
    RULE_keychain = 12
    RULE_argchain = 13
    RULE_pipeline = 14
    RULE_target = 15
    RULE_pattern = 16
    RULE_base_pattern = 17
    RULE_record_pattern = 18

    ruleNames =  [ "ids", "preamble", "program", "typ_base", "typ", "negchain", 
                   "qualification", "subtyping", "expr", "base", "record", 
                   "function", "keychain", "argchain", "pipeline", "target", 
                   "pattern", "base_pattern", "record_pattern" ]

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
    _light_mode : bool  

    _syntax_rules : PSet[SyntaxRule] = s() 

    def init(self, light_mode = False): 
        self._cache = {}
        self._guidance = [default_context]
        self._overflow = False  
        self._light_mode = light_mode  

    def reset(self): 
        self._guidance = [default_context]
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()

    def filter(self, i, rs):
        return [
            r
            for r in rs  
            if r.pid == i
        ]


    def get_syntax_rules(self):
        return self._syntax_rules

    def update_sr(self, head : str, body : list[Union[Nonterm, Termin]]):
        rule = SyntaxRule(head, tuple(body))
        self._syntax_rules = self._syntax_rules.add(rule)

    def getGuidance(self):
        return self._guidance

    def getSolver(self):
        return self._solver

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex





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
            self.state = 45
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,0,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 39
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = tuple([(None if localctx._ID is None else localctx._ID.text)])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 41
                localctx._ID = self.match(SlimParser.ID)
                self.state = 42
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


    class PreambleContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.aliasing = None
            self._ID = None # Token
            self._typ = None # TypContext
            self._preamble = None # PreambleContext

        def ID(self):
            return self.getToken(SlimParser.ID, 0)

        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


        def preamble(self):
            return self.getTypedRuleContext(SlimParser.PreambleContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_preamble

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPreamble" ):
                listener.enterPreamble(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPreamble" ):
                listener.exitPreamble(self)




    def preamble(self):

        localctx = SlimParser.PreambleContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_preamble)
        try:
            self.state = 61
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 48
                self.match(SlimParser.T__0)
                self.state = 49
                localctx._ID = self.match(SlimParser.ID)
                self.state = 50
                self.match(SlimParser.T__1)
                self.state = 51
                localctx._typ = self.typ()

                localctx.aliasing = m().set((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 54
                self.match(SlimParser.T__0)
                self.state = 55
                localctx._ID = self.match(SlimParser.ID)
                self.state = 56
                self.match(SlimParser.T__1)
                self.state = 57
                localctx._typ = self.typ()
                self.state = 58
                localctx._preamble = self.preamble()

                localctx.aliasing = localctx._preamble.aliasing.set((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ProgramContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self._preamble = None # PreambleContext
            self._expr = None # ExprContext
            self.contexts = contexts

        def preamble(self):
            return self.getTypedRuleContext(SlimParser.PreambleContext,0)


        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_program

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterProgram" ):
                listener.enterProgram(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitProgram" ):
                listener.exitProgram(self)




    def program(self, contexts:list[Context]):

        localctx = SlimParser.ProgramContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 4, self.RULE_program)
        try:
            self.state = 72
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,2,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 64
                localctx._preamble = self.preamble()

                self._solver = Solver(localctx._preamble.aliasing if localctx._preamble.aliasing else m())

                self.state = 66
                localctx._expr = self.expr(contexts)

                localctx.results = localctx._expr.results

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 69
                localctx._expr = self.expr(contexts)

                self._solver = Solver(m())
                localctx.results = localctx._expr.results

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
        self.enterRule(localctx, 6, self.RULE_typ_base)
        try:
            self.state = 98
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,3,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 75
                self.match(SlimParser.T__2)

                localctx.combo = Top() 

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 77
                self.match(SlimParser.T__3)

                localctx.combo = Bot() 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 79
                localctx._ID = self.match(SlimParser.ID)

                localctx.combo = TVar((None if localctx._ID is None else localctx._ID.text)) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 81
                self.match(SlimParser.T__4)

                localctx.combo = TUnit() 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 83
                self.match(SlimParser.T__5)
                self.state = 84
                localctx._ID = self.match(SlimParser.ID)
                self.state = 85
                localctx._typ_base = self.typ_base()

                localctx.combo = TTag((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 88
                localctx._ID = self.match(SlimParser.ID)
                self.state = 89
                self.match(SlimParser.T__6)
                self.state = 90
                localctx._typ_base = self.typ_base()

                localctx.combo = TField((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 93
                self.match(SlimParser.T__7)
                self.state = 94
                localctx._typ = self.typ()
                self.state = 95
                self.match(SlimParser.T__8)

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
        self.enterRule(localctx, 8, self.RULE_typ)
        try:
            self.state = 164
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 101
                localctx._typ_base = self.typ_base()

                localctx.combo = localctx._typ_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 104
                localctx._typ_base = self.typ_base()
                self.state = 105
                self.match(SlimParser.T__9)
                self.state = 106
                localctx._typ = self.typ()

                localctx.combo = Unio(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 109
                localctx._typ_base = self.typ_base()
                self.state = 110
                self.match(SlimParser.T__10)
                self.state = 111
                localctx._typ = self.typ()

                localctx.combo = Inter(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 114
                localctx.context = self.typ_base()
                self.state = 115
                localctx.acc = self.negchain(localctx.context.combo)

                localctx.combo = localctx.acc.combo 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 118
                localctx._typ_base = self.typ_base()
                self.state = 119
                self.match(SlimParser.T__11)
                self.state = 120
                localctx._typ = self.typ()

                localctx.combo = Imp(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 123
                localctx._typ_base = self.typ_base()
                self.state = 124
                self.match(SlimParser.T__12)
                self.state = 125
                localctx._typ = self.typ()

                localctx.combo = Inter(TField('head', localctx._typ_base.combo), TField('tail', localctx._typ.combo)) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 128
                self.match(SlimParser.T__13)
                self.state = 129
                self.match(SlimParser.T__14)
                self.state = 130
                localctx._ids = self.ids()
                self.state = 131
                self.match(SlimParser.T__15)
                self.state = 132
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 135
                self.match(SlimParser.T__13)
                self.state = 136
                self.match(SlimParser.T__14)
                self.state = 137
                localctx._ids = self.ids()
                self.state = 138
                localctx._qualification = self.qualification()
                self.state = 139
                self.match(SlimParser.T__15)
                self.state = 140
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 143
                self.match(SlimParser.T__16)
                self.state = 144
                self.match(SlimParser.T__14)
                self.state = 145
                localctx._ids = self.ids()
                self.state = 146
                self.match(SlimParser.T__15)
                self.state = 147
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 150
                self.match(SlimParser.T__16)
                self.state = 151
                self.match(SlimParser.T__14)
                self.state = 152
                localctx._ids = self.ids()
                self.state = 153
                localctx._qualification = self.qualification()
                self.state = 154
                self.match(SlimParser.T__15)
                self.state = 155
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 158
                self.match(SlimParser.T__17)
                self.state = 159
                localctx._ID = self.match(SlimParser.ID)
                self.state = 160
                self.match(SlimParser.T__9)
                self.state = 161
                localctx._typ = self.typ()

                localctx.combo = Fixpoint((None if localctx._ID is None else localctx._ID.text), localctx._typ.combo) 

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
        self.enterRule(localctx, 10, self.RULE_negchain)
        try:
            self.state = 177
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 167
                self.match(SlimParser.T__18)
                self.state = 168
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 171
                self.match(SlimParser.T__18)
                self.state = 172
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 174
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
        self.enterRule(localctx, 12, self.RULE_qualification)
        try:
            self.state = 189
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 180
                self.match(SlimParser.T__19)
                self.state = 181
                localctx._subtyping = self.subtyping()

                localctx.combo = tuple([localctx._subtyping.combo])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 184
                self.match(SlimParser.T__19)
                self.state = 185
                localctx._subtyping = self.subtyping()
                self.state = 186
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
        self.enterRule(localctx, 14, self.RULE_subtyping)
        try:
            self.state = 197
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [16, 20]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [3, 4, 5, 6, 8, 10, 11, 12, 13, 14, 17, 18, 19, 21, 32]:
                self.enterOuterAlt(localctx, 2)
                self.state = 192
                localctx.strong = self.typ()
                self.state = 193
                self.match(SlimParser.T__20)
                self.state = 194
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
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
            self.arg = None # BaseContext
            self._pipeline = None # PipelineContext
            self._ID = None # Token
            self._target = None # TargetContext
            self.contin = None # ExprContext
            self.body = None # ExprContext
            self.contexts = contexts

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




    def expr(self, contexts:list[Context]):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 16, self.RULE_expr)
        try:
            self.state = 246
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 200
                localctx._base = self.base(contexts)

                localctx.results = localctx._base.results

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 203
                localctx.head = self.base(contexts)
                self.state = 204
                self.match(SlimParser.T__12)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results 
                ] 

                self.state = 206
                localctx.tail = self.expr(tail_contexts)

                localctx.results = [
                    ExprRule(self._solver).combine_tuple(
                        pid, 
                        tail_result.world, 
                        head_result.typ, 
                        tail_result.typ
                    ) 
                    for tail_result in localctx.tail.results 
                    for head_result in [localctx.head.results[tail_result.pid]]
                    for pid in [head_result.pid]
                ]

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 209
                self.match(SlimParser.T__21)
                self.state = 210
                localctx.condition = self.expr(contexts)
                self.state = 211
                self.match(SlimParser.T__22)

                branch_contexts = [
                    Context(contexts[conditionr.pid].enviro, conditionr.world)
                    for conditionr in localctx.condition.results
                ]

                self.state = 213
                localctx.true_branch = self.expr(branch_contexts)
                self.state = 214
                self.match(SlimParser.T__23)
                self.state = 215
                localctx.false_branch = self.expr(branch_contexts)

                localctx.results = [
                    result
                    for condition_id, condition_result in enumerate(localctx.condition.results)
                    for true_branch_results in [self.filter(condition_id, localctx.true_branch.results)]
                    for false_branch_results in [self.filter(condition_id, localctx.false_branch.results)]
                    for pid in [condition_result.pid]
                    for result in ExprRule(self._solver).combine_ite(
                        pid,  
                        contexts[pid].enviro,
                        condition_result.world,
                        condition_result.typ,
                        true_branch_results,
                        false_branch_results,
                    )
                ]

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 218
                localctx.rator = self.base(contexts)
                self.state = 219
                localctx._keychain = self.keychain()

                localctx.results = [
                    result
                    for rator_result in localctx.rator.results
                    for pid in [rator_result.pid]
                    for result in ExprRule(self._solver).combine_projection(
                        pid,
                        rator_result.world,
                        rator_result.typ,
                        localctx._keychain.keys
                    ) 
                ]

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 222
                localctx.cator = self.base(contexts)

                argchain_contexts = [
                    Context(contexts[cator_result.pid].enviro, cator_result.world)
                    for cator_result in localctx.cator.results 
                ]

                self.state = 224
                localctx._argchain = self.argchain(argchain_contexts)

                localctx.results = [
                    result 
                    for argchain_result in localctx._argchain.results
                    for cator_result in [localctx.cator.results[argchain_result.pid]]
                    for pid in [cator_result.pid]
                    for result in ExprRule(self._solver).combine_application(
                        pid,
                        argchain_result.world,
                        cator_result.typ,
                        argchain_result.typs,
                    )
                ]

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 227
                localctx.arg = self.base(contexts)

                pipeline_contexts = [
                    Context(contexts[arg_result.pid].enviro, arg_result.world)
                    for arg_result in localctx.arg.results 
                ]

                self.state = 229
                localctx._pipeline = self.pipeline(pipeline_contexts)

                localctx.results = [
                    result
                    for pipeline_result in localctx._pipeline.results 
                    for arg_result in [localctx.arg.results[pipeline_result.pid]]
                    for pid in [arg_result.pid]
                    for result in ExprRule(self._solver).combine_funnel(
                        pid,
                        pipeline_result.world,
                        arg_result.typ,
                        pipeline_result.typs
                    )
                ]

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 232
                self.match(SlimParser.T__24)
                self.state = 233
                localctx._ID = self.match(SlimParser.ID)
                self.state = 234
                localctx._target = self.target(contexts)
                self.state = 235
                self.match(SlimParser.T__25)

                contin_contexts = [
                    Context(enviro, world)
                    for target_result in localctx._target.results
                    for enviro in [contexts[target_result.pid].enviro.set((None if localctx._ID is None else localctx._ID.text), target_result.typ)]
                    for world in [target_result.world]
                ]

                self.state = 237
                localctx.contin = self.expr(contin_contexts)

                localctx.results = [
                    Result(pid, contin_result.world, contin_result.typ)
                    for contin_result in localctx.contin.results
                    for target_result in [localctx._target.results[contin_result.pid]]
                    for pid in [target_result.pid]
                ]

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 240
                self.match(SlimParser.T__26)
                self.state = 241
                self.match(SlimParser.T__7)
                self.state = 242
                localctx.body = self.expr(contexts)
                self.state = 243
                self.match(SlimParser.T__8)

                localctx.results = [
                    ExprRule(self._solver).combine_fix(
                        pid,
                        contexts[pid].enviro,
                        body_result.world,
                        body_reuslt.typ
                    )
                    for body_result in localctx.body.results 
                    for pid in [body_result.pid]
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self._ID = None # Token
            self.body = None # BaseContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._argchain = None # ArgchainContext
            self.contexts = contexts

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




    def base(self, contexts:list[Context]):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 18, self.RULE_base)
        try:
            self.state = 268
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 249
                self.match(SlimParser.T__4)

                localctx.results = [
                    BaseRule(self._solver).combine_unit(pid, context.world)
                    for pid, context in enumerate(contexts)
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 251
                self.match(SlimParser.T__5)
                self.state = 252
                localctx._ID = self.match(SlimParser.ID)
                self.state = 253
                localctx.body = self.base(contexts)

                localctx.results = [
                    BaseRule(self._solver).combine_tag(pid, body_result.world, (None if localctx._ID is None else localctx._ID.text), body_result.typ)
                    for body_result in localctx.body.results
                    for pid in [body_result.pid]
                ]

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 256
                localctx._record = self.record(contexts)

                localctx.results = localctx._record.results 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 260
                localctx._function = self.function(contexts)

                localctx.results = [
                    BaseRule(self._solver).combine_function(pid, contexts[pid].enviro, function_result.world, function_result.branches)
                    for function_result in localctx._function.results
                    for pid in [function_result.pid]
                ]

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 263
                localctx._ID = self.match(SlimParser.ID)

                localctx.results = [
                    BaseRule(self._solver).combine_var(pid, context.enviro, context.world, (None if localctx._ID is None else localctx._ID.text))
                    for pid, context in enumerate(contexts)
                ]

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 265
                localctx._argchain = self.argchain(contexts)

                localctx.results = [
                    result
                    for argchain_result in localctx._argchain.results
                    for pid in [argchain_result.pid]
                    for result in BaseRule(self._solver).combine_assoc(pid, argchain_result.world, argchain_result.typs)
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.tail = None # RecordContext
            self.contexts = contexts

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




    def record(self, contexts:list[Context]):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 20, self.RULE_record)
        try:
            self.state = 285
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 271
                self.match(SlimParser.T__19)
                self.state = 272
                localctx._ID = self.match(SlimParser.ID)
                self.state = 273
                self.match(SlimParser.T__1)
                self.state = 274
                localctx.body = self.expr(contexts)

                localctx.results = [
                    RecordRule(self._solver).combine_single(pid, contexts[pid].enviro, body_result.world, (None if localctx._ID is None else localctx._ID.text), body_result.typ)
                    for body_result in localctx.body.results
                    for pid in [body_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 277
                self.match(SlimParser.T__19)
                self.state = 278
                localctx._ID = self.match(SlimParser.ID)
                self.state = 279
                self.match(SlimParser.T__1)
                self.state = 280
                localctx.body = self.expr(contexts)

                tail_contexts = [
                    Context(contexts[body_result.pid].enviro, body_result.world)
                    for body_result in localctx.body.results
                ]

                self.state = 282
                localctx.tail = self.record(tail_contexts)

                localctx.results = [
                    RecordRule(self._solver).combine_cons(pid, contexts[pid].enviro, tail_result.world, (None if localctx._ID is None else localctx._ID.text), body_result.typ, tail_result.branches) 
                    for tail_result in localctx.tail.results
                    for body_result in [localctx.body.results[tail_result.pid]]
                    for pid in [body_result.pid]
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self.tail = None # FunctionContext
            self.contexts = contexts

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




    def function(self, contexts:list[Context]):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 22, self.RULE_function)
        try:
            self.state = 303
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 288
                self.match(SlimParser.T__27)
                self.state = 289
                localctx._pattern = self.pattern()
                self.state = 290
                self.match(SlimParser.T__28)

                body_contexts = [
                    Context(context.enviro.update(localctx._pattern.result.enviro), context.world)
                    for context in contexts 
                ]

                self.state = 292
                localctx.body = self.expr(body_contexts)

                localctx.results = [
                    FunctionRule(self._solver).combine_single(pid, context.world, localctx._pattern.result.typ, body_results)
                    for pid, context in enumerate(contexts)
                    for body_results in [self.filter(pid, localctx.body.results)]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 295
                self.match(SlimParser.T__27)
                self.state = 296
                localctx._pattern = self.pattern()
                self.state = 297
                self.match(SlimParser.T__28)

                body_contexts = [
                    Context(context.enviro.update(localctx._pattern.result.enviro), context.world)
                    for context in contexts 
                ]

                self.state = 299
                localctx.body = self.expr(body_contexts)
                self.state = 300
                localctx.tail = self.function(contexts)

                localctx.results = [
                    FunctionRule(self._solver).combine_cons(pid, context.world, localctx._pattern.result.typ, body_results, tail_result)
                    for pid, context in enumerate(contexts)
                    for body_results in [self.filter(pid, localctx.body.results)]
                    for tail_result in [localctx.tail.results[pid]]
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.keys = None
            self._ID = None # Token
            self.tail = None # KeychainContext

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




    def keychain(self):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state)
        self.enterRule(localctx, 24, self.RULE_keychain)
        try:
            self.state = 315
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 306
                self.match(SlimParser.T__29)
                self.state = 307
                localctx._ID = self.match(SlimParser.ID)

                localctx.keys = KeychainRule(self._solver).combine_single((None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 309
                self.match(SlimParser.T__29)
                self.state = 310
                localctx._ID = self.match(SlimParser.ID)


                self.state = 312
                localctx.tail = self.keychain()

                localctx.keys = KeychainRule(self._solver).combine_cons((None if localctx._ID is None else localctx._ID.text), localctx.tail.keys)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.contexts = contexts

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




    def argchain(self, contexts:list[Context]):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 26, self.RULE_argchain)
        try:
            self.state = 330
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 318
                self.match(SlimParser.T__7)
                self.state = 319
                localctx.content = self.expr(contexts)
                self.state = 320
                self.match(SlimParser.T__8)

                localctx.results = [
                    ArgchainRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
                    for content_result in localctx.content.results 
                    for pid in [content_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 323
                self.match(SlimParser.T__7)
                self.state = 324
                localctx.head = self.expr(contexts)
                self.state = 325
                self.match(SlimParser.T__8)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results
                ]

                self.state = 327
                localctx.tail = self.argchain(tail_contexts)

                localctx.results = [
                    ArgchainRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
                    for tail_result in localctx.tail.results 
                    for head_result in [localctx.head.results[tail_result.pid]]
                    for pid in [head_result.pid]
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # PipelineContext
            self.contexts = contexts

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




    def pipeline(self, contexts:list[Context]):

        localctx = SlimParser.PipelineContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 28, self.RULE_pipeline)
        try:
            self.state = 343
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 333
                self.match(SlimParser.T__30)
                self.state = 334
                localctx.content = self.expr(contexts)

                localctx.results = [
                    PipelineRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
                    for content_result in localctx.content.results 
                    for pid in [content_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 337
                self.match(SlimParser.T__30)
                self.state = 338
                localctx.head = self.expr(contexts)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results
                ]

                self.state = 340
                localctx.tail = self.pipeline(tail_contexts)

                localctx.results = [
                    PipelineRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
                    for tail_result in localctx.tail.results 
                    for head_result in [localctx.head.results[tail_result.pid]]
                    for pid in [head_result.pid]
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, contexts:list[Context]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.contexts = None
            self.results = None
            self._expr = None # ExprContext
            self.contexts = contexts

        def expr(self):
            return self.getTypedRuleContext(SlimParser.ExprContext,0)


        def typ(self):
            return self.getTypedRuleContext(SlimParser.TypContext,0)


        def getRuleIndex(self):
            return SlimParser.RULE_target

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterTarget" ):
                listener.enterTarget(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitTarget" ):
                listener.exitTarget(self)




    def target(self, contexts:list[Context]):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, contexts)
        self.enterRule(localctx, 30, self.RULE_target)
        try:
            self.state = 356
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [26]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 2)
                self.state = 346
                self.match(SlimParser.T__1)
                self.state = 347
                localctx._expr = self.expr(contexts)

                localctx.results = localctx._expr.results

                pass
            elif token in [7]:
                self.enterOuterAlt(localctx, 3)
                self.state = 350
                self.match(SlimParser.T__6)
                self.state = 351
                self.typ()
                self.state = 352
                self.match(SlimParser.T__1)
                self.state = 353
                localctx._expr = self.expr(contexts)

                localctx.results = [
                    Result(expr_result.pid, expr_result.world, expr_result.typ)
                    for expr_result in localctx._expr.results 
                ]

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self._base_pattern = None # Base_patternContext
            self.head = None # Base_patternContext
            self.tail = None # PatternContext

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




    def pattern(self):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state)
        self.enterRule(localctx, 32, self.RULE_pattern)
        try:
            self.state = 368
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 359
                localctx._base_pattern = self.base_pattern()

                localctx.result = localctx._base_pattern.result

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)


                self.state = 363
                localctx.head = self.base_pattern()
                self.state = 364
                self.match(SlimParser.T__12)
                self.state = 365
                localctx.tail = self.pattern()

                localctx.result = PatternRule(self._solver).combine_tuple(localctx.head.result, localctx.tail.result)

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self._ID = None # Token
            self.body = None # Base_patternContext
            self._record_pattern = None # Record_patternContext
            self._pattern = None # PatternContext

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




    def base_pattern(self):

        localctx = SlimParser.Base_patternContext(self, self._ctx, self.state)
        self.enterRule(localctx, 34, self.RULE_base_pattern)
        try:
            self.state = 388
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,17,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 371
                localctx._ID = self.match(SlimParser.ID)

                localctx.result = BasePatternRule(self._solver).combine_var((None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 373
                self.match(SlimParser.T__4)

                localctx.result = BasePatternRule(self._solver).combine_unit()

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 375
                self.match(SlimParser.T__5)
                self.state = 376
                localctx._ID = self.match(SlimParser.ID)
                self.state = 377
                localctx.body = self.base_pattern()

                localctx.result = BasePatternRule(self._solver).combine_tag((None if localctx._ID is None else localctx._ID.text), localctx.body.result)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 380
                localctx._record_pattern = self.record_pattern()

                localctx.result = localctx._record_pattern.result

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 383
                self.match(SlimParser.T__7)
                self.state = 384
                localctx._pattern = self.pattern()
                self.state = 385
                self.match(SlimParser.T__8)

                localctx.result = localctx._pattern.result

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.result = None
            self._ID = None # Token
            self.body = None # PatternContext
            self.tail = None # Record_patternContext

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




    def record_pattern(self):

        localctx = SlimParser.Record_patternContext(self, self._ctx, self.state)
        self.enterRule(localctx, 36, self.RULE_record_pattern)
        try:
            self.state = 404
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,18,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 391
                self.match(SlimParser.T__19)
                self.state = 392
                localctx._ID = self.match(SlimParser.ID)
                self.state = 393
                self.match(SlimParser.T__1)
                self.state = 394
                localctx.body = self.pattern()

                localctx.result = RecordPatternRule(self._solver, self._light_mode).combine_single((None if localctx._ID is None else localctx._ID.text), localctx.body.result)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 397
                self.match(SlimParser.T__19)
                self.state = 398
                localctx._ID = self.match(SlimParser.ID)
                self.state = 399
                self.match(SlimParser.T__1)
                self.state = 400
                localctx.body = self.pattern()
                self.state = 401
                localctx.tail = self.record_pattern()

                localctx.result = RecordPatternRule(self._solver).combine_cons((None if localctx._ID is None else localctx._ID.text), localctx.body.result, localctx.tail.result)

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





