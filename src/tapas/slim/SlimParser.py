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
        4,1,37,403,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,3,0,46,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,3,1,62,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,
        2,73,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,
        1,3,1,3,1,3,1,3,1,3,1,3,3,3,95,8,3,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,162,8,4,1,5,1,5,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,175,8,5,1,6,1,6,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,3,6,186,8,6,1,7,1,7,1,7,1,7,1,7,1,7,3,7,194,8,7,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,243,
        8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,
        1,9,1,9,1,9,1,9,1,9,3,9,265,8,9,1,10,1,10,1,10,1,10,1,10,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,282,8,10,1,11,1,
        11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,
        11,1,11,3,11,300,8,11,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,12,1,
        12,1,12,3,12,312,8,12,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,
        13,1,13,1,13,1,13,1,13,3,13,327,8,13,1,14,1,14,1,14,1,14,1,14,1,
        14,1,14,1,14,1,14,1,14,1,14,3,14,340,8,14,1,15,1,15,1,15,1,15,1,
        15,1,15,1,15,1,15,1,15,1,15,1,15,3,15,353,8,15,1,16,1,16,1,16,1,
        16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,365,8,16,1,17,1,17,1,17,1,
        17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,
        17,1,17,3,17,385,8,17,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,
        18,1,18,1,18,1,18,1,18,1,18,3,18,401,8,18,1,18,0,0,19,0,2,4,6,8,
        10,12,14,16,18,20,22,24,26,28,30,32,34,36,0,0,446,0,45,1,0,0,0,2,
        61,1,0,0,0,4,72,1,0,0,0,6,94,1,0,0,0,8,161,1,0,0,0,10,174,1,0,0,
        0,12,185,1,0,0,0,14,193,1,0,0,0,16,242,1,0,0,0,18,264,1,0,0,0,20,
        281,1,0,0,0,22,299,1,0,0,0,24,311,1,0,0,0,26,326,1,0,0,0,28,339,
        1,0,0,0,30,352,1,0,0,0,32,364,1,0,0,0,34,384,1,0,0,0,36,400,1,0,
        0,0,38,46,1,0,0,0,39,40,5,35,0,0,40,46,6,0,-1,0,41,42,5,35,0,0,42,
        43,3,0,0,0,43,44,6,0,-1,0,44,46,1,0,0,0,45,38,1,0,0,0,45,39,1,0,
        0,0,45,41,1,0,0,0,46,1,1,0,0,0,47,62,1,0,0,0,48,49,5,1,0,0,49,50,
        5,35,0,0,50,51,5,2,0,0,51,52,3,8,4,0,52,53,6,1,-1,0,53,62,1,0,0,
        0,54,55,5,1,0,0,55,56,5,35,0,0,56,57,5,2,0,0,57,58,3,8,4,0,58,59,
        3,2,1,0,59,60,6,1,-1,0,60,62,1,0,0,0,61,47,1,0,0,0,61,48,1,0,0,0,
        61,54,1,0,0,0,62,3,1,0,0,0,63,73,1,0,0,0,64,65,3,2,1,0,65,66,6,2,
        -1,0,66,67,3,16,8,0,67,68,6,2,-1,0,68,73,1,0,0,0,69,70,3,16,8,0,
        70,71,6,2,-1,0,71,73,1,0,0,0,72,63,1,0,0,0,72,64,1,0,0,0,72,69,1,
        0,0,0,73,5,1,0,0,0,74,95,1,0,0,0,75,76,5,3,0,0,76,95,6,3,-1,0,77,
        78,5,4,0,0,78,95,6,3,-1,0,79,80,5,35,0,0,80,95,6,3,-1,0,81,82,5,
        5,0,0,82,95,6,3,-1,0,83,84,5,6,0,0,84,85,5,35,0,0,85,86,5,7,0,0,
        86,87,3,6,3,0,87,88,6,3,-1,0,88,95,1,0,0,0,89,90,5,8,0,0,90,91,3,
        8,4,0,91,92,5,9,0,0,92,93,6,3,-1,0,93,95,1,0,0,0,94,74,1,0,0,0,94,
        75,1,0,0,0,94,77,1,0,0,0,94,79,1,0,0,0,94,81,1,0,0,0,94,83,1,0,0,
        0,94,89,1,0,0,0,95,7,1,0,0,0,96,162,1,0,0,0,97,98,3,6,3,0,98,99,
        6,4,-1,0,99,162,1,0,0,0,100,101,3,6,3,0,101,102,5,10,0,0,102,103,
        3,8,4,0,103,104,6,4,-1,0,104,162,1,0,0,0,105,106,3,6,3,0,106,107,
        5,11,0,0,107,108,3,8,4,0,108,109,6,4,-1,0,109,162,1,0,0,0,110,111,
        3,6,3,0,111,112,3,10,5,0,112,113,6,4,-1,0,113,162,1,0,0,0,114,115,
        3,6,3,0,115,116,5,12,0,0,116,117,3,8,4,0,117,118,6,4,-1,0,118,162,
        1,0,0,0,119,120,3,6,3,0,120,121,5,13,0,0,121,122,3,8,4,0,122,123,
        6,4,-1,0,123,162,1,0,0,0,124,125,5,14,0,0,125,126,5,15,0,0,126,127,
        3,0,0,0,127,128,5,16,0,0,128,129,3,8,4,0,129,130,6,4,-1,0,130,162,
        1,0,0,0,131,132,5,14,0,0,132,133,5,15,0,0,133,134,3,0,0,0,134,135,
        5,16,0,0,135,136,3,12,6,0,136,137,3,8,4,0,137,138,6,4,-1,0,138,162,
        1,0,0,0,139,140,5,17,0,0,140,141,5,15,0,0,141,142,3,0,0,0,142,143,
        5,16,0,0,143,144,3,8,4,0,144,145,6,4,-1,0,145,162,1,0,0,0,146,147,
        5,17,0,0,147,148,5,15,0,0,148,149,3,0,0,0,149,150,5,16,0,0,150,151,
        3,12,6,0,151,152,3,8,4,0,152,153,6,4,-1,0,153,162,1,0,0,0,154,155,
        5,18,0,0,155,156,5,15,0,0,156,157,5,35,0,0,157,158,5,16,0,0,158,
        159,3,8,4,0,159,160,6,4,-1,0,160,162,1,0,0,0,161,96,1,0,0,0,161,
        97,1,0,0,0,161,100,1,0,0,0,161,105,1,0,0,0,161,110,1,0,0,0,161,114,
        1,0,0,0,161,119,1,0,0,0,161,124,1,0,0,0,161,131,1,0,0,0,161,139,
        1,0,0,0,161,146,1,0,0,0,161,154,1,0,0,0,162,9,1,0,0,0,163,175,1,
        0,0,0,164,165,5,19,0,0,165,166,3,8,4,0,166,167,6,5,-1,0,167,175,
        1,0,0,0,168,169,5,19,0,0,169,170,3,8,4,0,170,171,6,5,-1,0,171,172,
        3,10,5,0,172,173,6,5,-1,0,173,175,1,0,0,0,174,163,1,0,0,0,174,164,
        1,0,0,0,174,168,1,0,0,0,175,11,1,0,0,0,176,186,1,0,0,0,177,178,5,
        20,0,0,178,186,6,6,-1,0,179,180,5,8,0,0,180,181,3,14,7,0,181,182,
        5,9,0,0,182,183,3,12,6,0,183,184,6,6,-1,0,184,186,1,0,0,0,185,176,
        1,0,0,0,185,177,1,0,0,0,185,179,1,0,0,0,186,13,1,0,0,0,187,194,1,
        0,0,0,188,189,3,8,4,0,189,190,5,21,0,0,190,191,3,8,4,0,191,192,6,
        7,-1,0,192,194,1,0,0,0,193,187,1,0,0,0,193,188,1,0,0,0,194,15,1,
        0,0,0,195,243,1,0,0,0,196,197,3,18,9,0,197,198,6,8,-1,0,198,243,
        1,0,0,0,199,200,3,18,9,0,200,201,5,22,0,0,201,202,6,8,-1,0,202,203,
        3,16,8,0,203,204,6,8,-1,0,204,243,1,0,0,0,205,206,5,23,0,0,206,207,
        3,16,8,0,207,208,5,24,0,0,208,209,6,8,-1,0,209,210,3,16,8,0,210,
        211,5,25,0,0,211,212,3,16,8,0,212,213,6,8,-1,0,213,243,1,0,0,0,214,
        215,3,18,9,0,215,216,3,24,12,0,216,217,6,8,-1,0,217,243,1,0,0,0,
        218,219,3,18,9,0,219,220,6,8,-1,0,220,221,3,26,13,0,221,222,6,8,
        -1,0,222,243,1,0,0,0,223,224,3,18,9,0,224,225,6,8,-1,0,225,226,3,
        28,14,0,226,227,6,8,-1,0,227,243,1,0,0,0,228,229,5,26,0,0,229,230,
        5,35,0,0,230,231,3,30,15,0,231,232,5,27,0,0,232,233,6,8,-1,0,233,
        234,3,16,8,0,234,235,6,8,-1,0,235,243,1,0,0,0,236,237,5,28,0,0,237,
        238,5,8,0,0,238,239,3,16,8,0,239,240,5,9,0,0,240,241,6,8,-1,0,241,
        243,1,0,0,0,242,195,1,0,0,0,242,196,1,0,0,0,242,199,1,0,0,0,242,
        205,1,0,0,0,242,214,1,0,0,0,242,218,1,0,0,0,242,223,1,0,0,0,242,
        228,1,0,0,0,242,236,1,0,0,0,243,17,1,0,0,0,244,265,1,0,0,0,245,246,
        5,5,0,0,246,265,6,9,-1,0,247,248,5,29,0,0,248,249,5,35,0,0,249,250,
        3,18,9,0,250,251,6,9,-1,0,251,265,1,0,0,0,252,253,3,20,10,0,253,
        254,6,9,-1,0,254,265,1,0,0,0,255,256,6,9,-1,0,256,257,3,22,11,0,
        257,258,6,9,-1,0,258,265,1,0,0,0,259,260,5,35,0,0,260,265,6,9,-1,
        0,261,262,3,26,13,0,262,263,6,9,-1,0,263,265,1,0,0,0,264,244,1,0,
        0,0,264,245,1,0,0,0,264,247,1,0,0,0,264,252,1,0,0,0,264,255,1,0,
        0,0,264,259,1,0,0,0,264,261,1,0,0,0,265,19,1,0,0,0,266,282,1,0,0,
        0,267,268,5,6,0,0,268,269,5,35,0,0,269,270,5,7,0,0,270,271,3,16,
        8,0,271,272,6,10,-1,0,272,282,1,0,0,0,273,274,5,6,0,0,274,275,5,
        35,0,0,275,276,5,7,0,0,276,277,3,16,8,0,277,278,6,10,-1,0,278,279,
        3,20,10,0,279,280,6,10,-1,0,280,282,1,0,0,0,281,266,1,0,0,0,281,
        267,1,0,0,0,281,273,1,0,0,0,282,21,1,0,0,0,283,300,1,0,0,0,284,285,
        5,30,0,0,285,286,3,32,16,0,286,287,5,31,0,0,287,288,6,11,-1,0,288,
        289,3,16,8,0,289,290,6,11,-1,0,290,300,1,0,0,0,291,292,5,30,0,0,
        292,293,3,32,16,0,293,294,5,31,0,0,294,295,6,11,-1,0,295,296,3,16,
        8,0,296,297,3,22,11,0,297,298,6,11,-1,0,298,300,1,0,0,0,299,283,
        1,0,0,0,299,284,1,0,0,0,299,291,1,0,0,0,300,23,1,0,0,0,301,312,1,
        0,0,0,302,303,5,32,0,0,303,304,5,35,0,0,304,312,6,12,-1,0,305,306,
        5,32,0,0,306,307,5,35,0,0,307,308,6,12,-1,0,308,309,3,24,12,0,309,
        310,6,12,-1,0,310,312,1,0,0,0,311,301,1,0,0,0,311,302,1,0,0,0,311,
        305,1,0,0,0,312,25,1,0,0,0,313,327,1,0,0,0,314,315,5,8,0,0,315,316,
        3,16,8,0,316,317,5,9,0,0,317,318,6,13,-1,0,318,327,1,0,0,0,319,320,
        5,8,0,0,320,321,3,16,8,0,321,322,5,9,0,0,322,323,6,13,-1,0,323,324,
        3,26,13,0,324,325,6,13,-1,0,325,327,1,0,0,0,326,313,1,0,0,0,326,
        314,1,0,0,0,326,319,1,0,0,0,327,27,1,0,0,0,328,340,1,0,0,0,329,330,
        5,33,0,0,330,331,3,16,8,0,331,332,6,14,-1,0,332,340,1,0,0,0,333,
        334,5,33,0,0,334,335,3,16,8,0,335,336,6,14,-1,0,336,337,3,28,14,
        0,337,338,6,14,-1,0,338,340,1,0,0,0,339,328,1,0,0,0,339,329,1,0,
        0,0,339,333,1,0,0,0,340,29,1,0,0,0,341,353,1,0,0,0,342,343,5,2,0,
        0,343,344,3,16,8,0,344,345,6,15,-1,0,345,353,1,0,0,0,346,347,5,34,
        0,0,347,348,3,8,4,0,348,349,5,2,0,0,349,350,3,16,8,0,350,351,6,15,
        -1,0,351,353,1,0,0,0,352,341,1,0,0,0,352,342,1,0,0,0,352,346,1,0,
        0,0,353,31,1,0,0,0,354,365,1,0,0,0,355,356,3,34,17,0,356,357,6,16,
        -1,0,357,365,1,0,0,0,358,359,6,16,-1,0,359,360,3,34,17,0,360,361,
        5,22,0,0,361,362,3,32,16,0,362,363,6,16,-1,0,363,365,1,0,0,0,364,
        354,1,0,0,0,364,355,1,0,0,0,364,358,1,0,0,0,365,33,1,0,0,0,366,385,
        1,0,0,0,367,368,5,35,0,0,368,385,6,17,-1,0,369,370,5,5,0,0,370,385,
        6,17,-1,0,371,372,5,29,0,0,372,373,5,35,0,0,373,374,3,34,17,0,374,
        375,6,17,-1,0,375,385,1,0,0,0,376,377,3,36,18,0,377,378,6,17,-1,
        0,378,385,1,0,0,0,379,380,5,8,0,0,380,381,3,32,16,0,381,382,5,9,
        0,0,382,383,6,17,-1,0,383,385,1,0,0,0,384,366,1,0,0,0,384,367,1,
        0,0,0,384,369,1,0,0,0,384,371,1,0,0,0,384,376,1,0,0,0,384,379,1,
        0,0,0,385,35,1,0,0,0,386,401,1,0,0,0,387,388,5,20,0,0,388,389,5,
        35,0,0,389,390,5,2,0,0,390,391,3,32,16,0,391,392,6,18,-1,0,392,401,
        1,0,0,0,393,394,5,20,0,0,394,395,5,35,0,0,395,396,5,2,0,0,396,397,
        3,32,16,0,397,398,3,36,18,0,398,399,6,18,-1,0,399,401,1,0,0,0,400,
        386,1,0,0,0,400,387,1,0,0,0,400,393,1,0,0,0,401,37,1,0,0,0,19,45,
        61,72,94,161,174,185,193,242,264,281,299,311,326,339,352,364,384,
        400
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'alias'", "'='", "'TOP'", "'BOT'", "'@'", 
                     "'<'", "'>'", "'('", "')'", "'|'", "'&'", "'->'", "'*'", 
                     "'EXI'", "'['", "']'", "'ALL'", "'LFP'", "'\\'", "';'", 
                     "'<:'", "','", "'if'", "'then'", "'else'", "'let'", 
                     "'in'", "'fix'", "'~'", "'case'", "'=>'", "'.'", "'|>'", 
                     "':'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "ID", "INT", 
                      "WS" ]

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
    T__31=32
    T__32=33
    T__33=34
    ID=35
    INT=36
    WS=37

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
            self.state = 94
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
                self.match(SlimParser.T__6)
                self.state = 86
                localctx._typ_base = self.typ_base()

                localctx.combo = TEntry((None if localctx._ID is None else localctx._ID.text), localctx._typ_base.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 89
                self.match(SlimParser.T__7)
                self.state = 90
                localctx._typ = self.typ()
                self.state = 91
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
            self.state = 161
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,4,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 97
                localctx._typ_base = self.typ_base()

                localctx.combo = localctx._typ_base.combo

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 100
                localctx._typ_base = self.typ_base()
                self.state = 101
                self.match(SlimParser.T__9)
                self.state = 102
                localctx._typ = self.typ()

                localctx.combo = Unio(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 105
                localctx._typ_base = self.typ_base()
                self.state = 106
                self.match(SlimParser.T__10)
                self.state = 107
                localctx._typ = self.typ()

                localctx.combo = Inter(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 110
                localctx.context = self.typ_base()
                self.state = 111
                localctx.acc = self.negchain(localctx.context.combo)

                localctx.combo = localctx.acc.combo 

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 114
                localctx._typ_base = self.typ_base()
                self.state = 115
                self.match(SlimParser.T__11)
                self.state = 116
                localctx._typ = self.typ()

                localctx.combo = Imp(localctx._typ_base.combo, localctx._typ.combo) 

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 119
                localctx._typ_base = self.typ_base()
                self.state = 120
                self.match(SlimParser.T__12)
                self.state = 121
                localctx._typ = self.typ()

                localctx.combo = Inter(TEntry('head', localctx._typ_base.combo), TEntry('tail', localctx._typ.combo)) 

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 124
                self.match(SlimParser.T__13)
                self.state = 125
                self.match(SlimParser.T__14)
                self.state = 126
                localctx._ids = self.ids()
                self.state = 127
                self.match(SlimParser.T__15)
                self.state = 128
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 131
                self.match(SlimParser.T__13)
                self.state = 132
                self.match(SlimParser.T__14)
                self.state = 133
                localctx._ids = self.ids()
                self.state = 134
                self.match(SlimParser.T__15)
                self.state = 135
                localctx._qualification = self.qualification()
                self.state = 136
                localctx._typ = self.typ()

                localctx.combo = Exi(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 10:
                self.enterOuterAlt(localctx, 10)
                self.state = 139
                self.match(SlimParser.T__16)
                self.state = 140
                self.match(SlimParser.T__14)
                self.state = 141
                localctx._ids = self.ids()
                self.state = 142
                self.match(SlimParser.T__15)
                self.state = 143
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, (), localctx._typ.combo) 

                pass

            elif la_ == 11:
                self.enterOuterAlt(localctx, 11)
                self.state = 146
                self.match(SlimParser.T__16)
                self.state = 147
                self.match(SlimParser.T__14)
                self.state = 148
                localctx._ids = self.ids()
                self.state = 149
                self.match(SlimParser.T__15)
                self.state = 150
                localctx._qualification = self.qualification()
                self.state = 151
                localctx._typ = self.typ()

                localctx.combo = All(localctx._ids.combo, localctx._qualification.combo, localctx._typ.combo) 

                pass

            elif la_ == 12:
                self.enterOuterAlt(localctx, 12)
                self.state = 154
                self.match(SlimParser.T__17)
                self.state = 155
                self.match(SlimParser.T__14)
                self.state = 156
                localctx._ID = self.match(SlimParser.ID)
                self.state = 157
                self.match(SlimParser.T__15)
                self.state = 158
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
        self.enterRule(localctx, 10, self.RULE_negchain)
        try:
            self.state = 174
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 164
                self.match(SlimParser.T__18)
                self.state = 165
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 168
                self.match(SlimParser.T__18)
                self.state = 169
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 171
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
            self.state = 185
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 177
                self.match(SlimParser.T__19)

                localctx.combo = tuple([])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 179
                self.match(SlimParser.T__7)
                self.state = 180
                localctx._subtyping = self.subtyping()
                self.state = 181
                self.match(SlimParser.T__8)
                self.state = 182
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
            self.state = 193
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [9]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [3, 4, 5, 6, 8, 10, 11, 12, 13, 14, 17, 18, 19, 21, 35]:
                self.enterOuterAlt(localctx, 2)
                self.state = 188
                localctx.strong = self.typ()
                self.state = 189
                self.match(SlimParser.T__20)
                self.state = 190
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
            self.state = 242
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 196
                localctx._base = self.base(contexts)

                localctx.results = localctx._base.results

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 199
                localctx.head = self.base(contexts)
                self.state = 200
                self.match(SlimParser.T__21)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results 
                ] 

                self.state = 202
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
                self.state = 205
                self.match(SlimParser.T__22)
                self.state = 206
                localctx.condition = self.expr(contexts)
                self.state = 207
                self.match(SlimParser.T__23)

                branch_contexts = [
                    Context(contexts[conditionr.pid].enviro, conditionr.world)
                    for conditionr in localctx.condition.results
                ]

                self.state = 209
                localctx.true_branch = self.expr(branch_contexts)
                self.state = 210
                self.match(SlimParser.T__24)
                self.state = 211
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
                self.state = 214
                localctx.rator = self.base(contexts)
                self.state = 215
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
                self.state = 218
                localctx.cator = self.base(contexts)

                argchain_contexts = [
                    Context(contexts[cator_result.pid].enviro, cator_result.world)
                    for cator_result in localctx.cator.results 
                ]

                self.state = 220
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
                self.state = 223
                localctx.arg = self.base(contexts)

                pipeline_contexts = [
                    Context(contexts[arg_result.pid].enviro, arg_result.world)
                    for arg_result in localctx.arg.results 
                ]

                self.state = 225
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
                self.state = 228
                self.match(SlimParser.T__25)
                self.state = 229
                localctx._ID = self.match(SlimParser.ID)
                self.state = 230
                localctx._target = self.target(contexts)
                self.state = 231
                self.match(SlimParser.T__26)

                contin_contexts = [
                    Context(enviro, world)
                    for target_result in localctx._target.results
                    for enviro in [contexts[target_result.pid].enviro.set((None if localctx._ID is None else localctx._ID.text), target_result.typ)]
                    for world in [target_result.world]
                ]

                self.state = 233
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
                self.state = 236
                self.match(SlimParser.T__27)
                self.state = 237
                self.match(SlimParser.T__7)
                self.state = 238
                localctx.body = self.expr(contexts)
                self.state = 239
                self.match(SlimParser.T__8)

                localctx.results = [
                    ExprRule(self._solver).combine_fix(
                        pid,
                        contexts[pid].enviro,
                        body_result.world,
                        body_result.typ
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
            self.state = 264
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 245
                self.match(SlimParser.T__4)

                localctx.results = [
                    BaseRule(self._solver).combine_unit(pid, context.world)
                    for pid, context in enumerate(contexts)
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 247
                self.match(SlimParser.T__28)
                self.state = 248
                localctx._ID = self.match(SlimParser.ID)
                self.state = 249
                localctx.body = self.base(contexts)

                localctx.results = [
                    BaseRule(self._solver).combine_tag(pid, body_result.world, (None if localctx._ID is None else localctx._ID.text), body_result.typ)
                    for body_result in localctx.body.results
                    for pid in [body_result.pid]
                ]

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 252
                localctx._record = self.record(contexts)

                localctx.results = localctx._record.results 

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 256
                localctx._function = self.function(contexts)

                localctx.results = [
                    BaseRule(self._solver).combine_function(pid, contexts[pid].enviro, function_result.world, function_result.branches)
                    for function_result in localctx._function.results
                    for pid in [function_result.pid]
                ]

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 259
                localctx._ID = self.match(SlimParser.ID)

                localctx.results = [
                    result
                    for pid, context in enumerate(contexts)
                    for result in BaseRule(self._solver).combine_var(pid, context.enviro, context.world, (None if localctx._ID is None else localctx._ID.text))
                ]

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 261
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
            self.state = 281
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 267
                self.match(SlimParser.T__5)
                self.state = 268
                localctx._ID = self.match(SlimParser.ID)
                self.state = 269
                self.match(SlimParser.T__6)
                self.state = 270
                localctx.body = self.expr(contexts)

                localctx.results = [
                    RecordRule(self._solver).combine_single(pid, body_result.world, (None if localctx._ID is None else localctx._ID.text), body_result.typ)
                    for body_result in localctx.body.results
                    for pid in [body_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 273
                self.match(SlimParser.T__5)
                self.state = 274
                localctx._ID = self.match(SlimParser.ID)
                self.state = 275
                self.match(SlimParser.T__6)
                self.state = 276
                localctx.body = self.expr(contexts)

                tail_contexts = [
                    Context(contexts[body_result.pid].enviro, body_result.world)
                    for body_result in localctx.body.results
                ]

                self.state = 278
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
            self.state = 299
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 284
                self.match(SlimParser.T__29)
                self.state = 285
                localctx._pattern = self.pattern()
                self.state = 286
                self.match(SlimParser.T__30)

                body_contexts = [
                    Context(context.enviro.update(localctx._pattern.result.enviro), context.world)
                    for context in contexts 
                ]

                self.state = 288
                localctx.body = self.expr(body_contexts)

                localctx.results = [
                    FunctionRule(self._solver).combine_single(pid, context.world, localctx._pattern.result.typ, body_results)
                    for pid, context in enumerate(contexts)
                    for body_results in [self.filter(pid, localctx.body.results)]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 291
                self.match(SlimParser.T__29)
                self.state = 292
                localctx._pattern = self.pattern()
                self.state = 293
                self.match(SlimParser.T__30)

                body_contexts = [
                    Context(context.enviro.update(localctx._pattern.result.enviro), context.world)
                    for context in contexts 
                ]

                self.state = 295
                localctx.body = self.expr(body_contexts)
                self.state = 296
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
            self.state = 311
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 302
                self.match(SlimParser.T__31)
                self.state = 303
                localctx._ID = self.match(SlimParser.ID)

                localctx.keys = KeychainRule(self._solver).combine_single((None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 305
                self.match(SlimParser.T__31)
                self.state = 306
                localctx._ID = self.match(SlimParser.ID)


                self.state = 308
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
            self.state = 326
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 314
                self.match(SlimParser.T__7)
                self.state = 315
                localctx.content = self.expr(contexts)
                self.state = 316
                self.match(SlimParser.T__8)

                localctx.results = [
                    ArgchainRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
                    for content_result in localctx.content.results 
                    for pid in [content_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 319
                self.match(SlimParser.T__7)
                self.state = 320
                localctx.head = self.expr(contexts)
                self.state = 321
                self.match(SlimParser.T__8)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results
                ]

                self.state = 323
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
            self.state = 339
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 329
                self.match(SlimParser.T__32)
                self.state = 330
                localctx.content = self.expr(contexts)

                localctx.results = [
                    PipelineRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
                    for content_result in localctx.content.results 
                    for pid in [content_result.pid]
                ]

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 333
                self.match(SlimParser.T__32)
                self.state = 334
                localctx.head = self.expr(contexts)

                tail_contexts = [
                    Context(contexts[head_result.pid].enviro, head_result.world)
                    for head_result in localctx.head.results
                ]

                self.state = 336
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
            self._typ = None # TypContext
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
            self.state = 352
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [27]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 2)
                self.state = 342
                self.match(SlimParser.T__1)
                self.state = 343
                localctx._expr = self.expr(contexts)

                localctx.results = localctx._expr.results

                pass
            elif token in [34]:
                self.enterOuterAlt(localctx, 3)
                self.state = 346
                self.match(SlimParser.T__33)
                self.state = 347
                localctx._typ = self.typ()
                self.state = 348
                self.match(SlimParser.T__1)
                self.state = 349
                localctx._expr = self.expr(contexts)

                localctx.results = [
                    result 
                    for expr_result in localctx._expr.results
                    for pid in [expr_result.pid]
                    for result in TargetRule(self._solver).combine_anno(
                        pid,
                        expr_result.world,
                        expr_result.typ,
                        localctx._typ.combo
                    )
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
            self.state = 364
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 355
                localctx._base_pattern = self.base_pattern()

                localctx.result = localctx._base_pattern.result

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)


                self.state = 359
                localctx.head = self.base_pattern()
                self.state = 360
                self.match(SlimParser.T__21)
                self.state = 361
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
            self.state = 384
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,17,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 367
                localctx._ID = self.match(SlimParser.ID)

                localctx.result = BasePatternRule(self._solver).combine_var((None if localctx._ID is None else localctx._ID.text))

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 369
                self.match(SlimParser.T__4)

                localctx.result = BasePatternRule(self._solver).combine_unit()

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 371
                self.match(SlimParser.T__28)
                self.state = 372
                localctx._ID = self.match(SlimParser.ID)
                self.state = 373
                localctx.body = self.base_pattern()

                localctx.result = BasePatternRule(self._solver).combine_tag((None if localctx._ID is None else localctx._ID.text), localctx.body.result)

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 376
                localctx._record_pattern = self.record_pattern()

                localctx.result = localctx._record_pattern.result

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 379
                self.match(SlimParser.T__7)
                self.state = 380
                localctx._pattern = self.pattern()
                self.state = 381
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
            self.state = 400
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,18,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 387
                self.match(SlimParser.T__19)
                self.state = 388
                localctx._ID = self.match(SlimParser.ID)
                self.state = 389
                self.match(SlimParser.T__1)
                self.state = 390
                localctx.body = self.pattern()

                localctx.result = RecordPatternRule(self._solver, self._light_mode).combine_single((None if localctx._ID is None else localctx._ID.text), localctx.body.result)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 393
                self.match(SlimParser.T__19)
                self.state = 394
                localctx._ID = self.match(SlimParser.ID)
                self.state = 395
                self.match(SlimParser.T__1)
                self.state = 396
                localctx.body = self.pattern()
                self.state = 397
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





