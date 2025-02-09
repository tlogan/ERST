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
        4,1,34,457,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
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
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,3,8,263,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,287,8,9,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,
        10,1,10,1,10,1,10,1,10,1,10,1,10,3,10,310,8,10,1,11,1,11,1,11,1,
        11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,
        11,1,11,1,11,1,11,1,11,3,11,333,8,11,1,12,1,12,1,12,1,12,1,12,1,
        12,1,12,1,12,1,12,1,12,1,12,1,12,3,12,347,8,12,1,13,1,13,1,13,1,
        13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,
        13,3,13,366,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,
        14,1,14,1,14,1,14,3,14,381,8,14,1,15,1,15,1,15,1,15,1,15,1,15,1,
        15,1,15,1,15,1,15,1,15,1,15,1,15,3,15,396,8,15,1,16,1,16,1,16,1,
        16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,410,8,16,1,17,1,
        17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,
        17,1,17,1,17,1,17,1,17,1,17,3,17,432,8,17,1,18,1,18,1,18,1,18,1,
        18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,
        18,1,18,1,18,1,18,3,18,455,8,18,1,18,0,0,19,0,2,4,6,8,10,12,14,16,
        18,20,22,24,26,28,30,32,34,36,0,0,501,0,45,1,0,0,0,2,61,1,0,0,0,
        4,72,1,0,0,0,6,98,1,0,0,0,8,164,1,0,0,0,10,177,1,0,0,0,12,189,1,
        0,0,0,14,197,1,0,0,0,16,262,1,0,0,0,18,286,1,0,0,0,20,309,1,0,0,
        0,22,332,1,0,0,0,24,346,1,0,0,0,26,365,1,0,0,0,28,380,1,0,0,0,30,
        395,1,0,0,0,32,409,1,0,0,0,34,431,1,0,0,0,36,454,1,0,0,0,38,46,1,
        0,0,0,39,40,5,32,0,0,40,46,6,0,-1,0,41,42,5,32,0,0,42,43,3,0,0,0,
        43,44,6,0,-1,0,44,46,1,0,0,0,45,38,1,0,0,0,45,39,1,0,0,0,45,41,1,
        0,0,0,46,1,1,0,0,0,47,62,1,0,0,0,48,49,5,1,0,0,49,50,5,32,0,0,50,
        51,5,2,0,0,51,52,3,8,4,0,52,53,6,1,-1,0,53,62,1,0,0,0,54,55,5,1,
        0,0,55,56,5,32,0,0,56,57,5,2,0,0,57,58,3,8,4,0,58,59,3,2,1,0,59,
        60,6,1,-1,0,60,62,1,0,0,0,61,47,1,0,0,0,61,48,1,0,0,0,61,54,1,0,
        0,0,62,3,1,0,0,0,63,73,1,0,0,0,64,65,3,2,1,0,65,66,6,2,-1,0,66,67,
        3,16,8,0,67,68,6,2,-1,0,68,73,1,0,0,0,69,70,3,16,8,0,70,71,6,2,-1,
        0,71,73,1,0,0,0,72,63,1,0,0,0,72,64,1,0,0,0,72,69,1,0,0,0,73,5,1,
        0,0,0,74,99,1,0,0,0,75,76,5,3,0,0,76,99,6,3,-1,0,77,78,5,4,0,0,78,
        99,6,3,-1,0,79,80,5,32,0,0,80,99,6,3,-1,0,81,82,5,5,0,0,82,99,6,
        3,-1,0,83,84,5,6,0,0,84,85,5,32,0,0,85,86,3,6,3,0,86,87,6,3,-1,0,
        87,99,1,0,0,0,88,89,5,32,0,0,89,90,5,7,0,0,90,91,3,6,3,0,91,92,6,
        3,-1,0,92,99,1,0,0,0,93,94,5,8,0,0,94,95,3,8,4,0,95,96,5,9,0,0,96,
        97,6,3,-1,0,97,99,1,0,0,0,98,74,1,0,0,0,98,75,1,0,0,0,98,77,1,0,
        0,0,98,79,1,0,0,0,98,81,1,0,0,0,98,83,1,0,0,0,98,88,1,0,0,0,98,93,
        1,0,0,0,99,7,1,0,0,0,100,165,1,0,0,0,101,102,3,6,3,0,102,103,6,4,
        -1,0,103,165,1,0,0,0,104,105,3,6,3,0,105,106,5,10,0,0,106,107,3,
        8,4,0,107,108,6,4,-1,0,108,165,1,0,0,0,109,110,3,6,3,0,110,111,5,
        11,0,0,111,112,3,8,4,0,112,113,6,4,-1,0,113,165,1,0,0,0,114,115,
        3,6,3,0,115,116,3,10,5,0,116,117,6,4,-1,0,117,165,1,0,0,0,118,119,
        3,6,3,0,119,120,5,12,0,0,120,121,3,8,4,0,121,122,6,4,-1,0,122,165,
        1,0,0,0,123,124,3,6,3,0,124,125,5,13,0,0,125,126,3,8,4,0,126,127,
        6,4,-1,0,127,165,1,0,0,0,128,129,5,14,0,0,129,130,5,15,0,0,130,131,
        3,0,0,0,131,132,5,16,0,0,132,133,3,8,4,0,133,134,6,4,-1,0,134,165,
        1,0,0,0,135,136,5,14,0,0,136,137,5,15,0,0,137,138,3,0,0,0,138,139,
        3,12,6,0,139,140,5,16,0,0,140,141,3,8,4,0,141,142,6,4,-1,0,142,165,
        1,0,0,0,143,144,5,17,0,0,144,145,5,15,0,0,145,146,3,0,0,0,146,147,
        5,16,0,0,147,148,3,8,4,0,148,149,6,4,-1,0,149,165,1,0,0,0,150,151,
        5,17,0,0,151,152,5,15,0,0,152,153,3,0,0,0,153,154,3,12,6,0,154,155,
        5,16,0,0,155,156,3,8,4,0,156,157,6,4,-1,0,157,165,1,0,0,0,158,159,
        5,18,0,0,159,160,5,32,0,0,160,161,5,10,0,0,161,162,3,8,4,0,162,163,
        6,4,-1,0,163,165,1,0,0,0,164,100,1,0,0,0,164,101,1,0,0,0,164,104,
        1,0,0,0,164,109,1,0,0,0,164,114,1,0,0,0,164,118,1,0,0,0,164,123,
        1,0,0,0,164,128,1,0,0,0,164,135,1,0,0,0,164,143,1,0,0,0,164,150,
        1,0,0,0,164,158,1,0,0,0,165,9,1,0,0,0,166,178,1,0,0,0,167,168,5,
        19,0,0,168,169,3,8,4,0,169,170,6,5,-1,0,170,178,1,0,0,0,171,172,
        5,19,0,0,172,173,3,8,4,0,173,174,6,5,-1,0,174,175,3,10,5,0,175,176,
        6,5,-1,0,176,178,1,0,0,0,177,166,1,0,0,0,177,167,1,0,0,0,177,171,
        1,0,0,0,178,11,1,0,0,0,179,190,1,0,0,0,180,181,5,20,0,0,181,182,
        3,14,7,0,182,183,6,6,-1,0,183,190,1,0,0,0,184,185,5,20,0,0,185,186,
        3,14,7,0,186,187,3,12,6,0,187,188,6,6,-1,0,188,190,1,0,0,0,189,179,
        1,0,0,0,189,180,1,0,0,0,189,184,1,0,0,0,190,13,1,0,0,0,191,198,1,
        0,0,0,192,193,3,8,4,0,193,194,5,21,0,0,194,195,3,8,4,0,195,196,6,
        7,-1,0,196,198,1,0,0,0,197,191,1,0,0,0,197,192,1,0,0,0,198,15,1,
        0,0,0,199,263,1,0,0,0,200,201,3,18,9,0,201,202,6,8,-1,0,202,263,
        1,0,0,0,203,204,6,8,-1,0,204,205,3,18,9,0,205,206,6,8,-1,0,206,207,
        5,13,0,0,207,208,6,8,-1,0,208,209,3,16,8,0,209,210,6,8,-1,0,210,
        263,1,0,0,0,211,212,5,22,0,0,212,213,6,8,-1,0,213,214,3,16,8,0,214,
        215,6,8,-1,0,215,216,5,23,0,0,216,217,6,8,-1,0,217,218,3,16,8,0,
        218,219,6,8,-1,0,219,220,5,24,0,0,220,221,6,8,-1,0,221,222,3,16,
        8,0,222,223,6,8,-1,0,223,263,1,0,0,0,224,225,6,8,-1,0,225,226,3,
        18,9,0,226,227,6,8,-1,0,227,228,3,24,12,0,228,229,6,8,-1,0,229,263,
        1,0,0,0,230,231,6,8,-1,0,231,232,3,18,9,0,232,233,6,8,-1,0,233,234,
        3,26,13,0,234,235,6,8,-1,0,235,263,1,0,0,0,236,237,6,8,-1,0,237,
        238,3,18,9,0,238,239,6,8,-1,0,239,240,3,28,14,0,240,241,6,8,-1,0,
        241,263,1,0,0,0,242,243,5,25,0,0,243,244,6,8,-1,0,244,245,5,32,0,
        0,245,246,6,8,-1,0,246,247,3,30,15,0,247,248,6,8,-1,0,248,249,5,
        26,0,0,249,250,6,8,-1,0,250,251,3,16,8,0,251,252,6,8,-1,0,252,263,
        1,0,0,0,253,254,5,27,0,0,254,255,6,8,-1,0,255,256,5,8,0,0,256,257,
        6,8,-1,0,257,258,3,16,8,0,258,259,6,8,-1,0,259,260,5,9,0,0,260,261,
        6,8,-1,0,261,263,1,0,0,0,262,199,1,0,0,0,262,200,1,0,0,0,262,203,
        1,0,0,0,262,211,1,0,0,0,262,224,1,0,0,0,262,230,1,0,0,0,262,236,
        1,0,0,0,262,242,1,0,0,0,262,253,1,0,0,0,263,17,1,0,0,0,264,287,1,
        0,0,0,265,266,5,5,0,0,266,287,6,9,-1,0,267,268,5,6,0,0,268,269,6,
        9,-1,0,269,270,5,32,0,0,270,271,6,9,-1,0,271,272,3,18,9,0,272,273,
        6,9,-1,0,273,287,1,0,0,0,274,275,3,20,10,0,275,276,6,9,-1,0,276,
        287,1,0,0,0,277,278,6,9,-1,0,278,279,3,22,11,0,279,280,6,9,-1,0,
        280,287,1,0,0,0,281,282,5,32,0,0,282,287,6,9,-1,0,283,284,3,26,13,
        0,284,285,6,9,-1,0,285,287,1,0,0,0,286,264,1,0,0,0,286,265,1,0,0,
        0,286,267,1,0,0,0,286,274,1,0,0,0,286,277,1,0,0,0,286,281,1,0,0,
        0,286,283,1,0,0,0,287,19,1,0,0,0,288,310,1,0,0,0,289,290,5,20,0,
        0,290,291,6,10,-1,0,291,292,5,32,0,0,292,293,6,10,-1,0,293,294,5,
        2,0,0,294,295,6,10,-1,0,295,296,3,16,8,0,296,297,6,10,-1,0,297,310,
        1,0,0,0,298,299,5,20,0,0,299,300,6,10,-1,0,300,301,5,32,0,0,301,
        302,6,10,-1,0,302,303,5,2,0,0,303,304,6,10,-1,0,304,305,3,16,8,0,
        305,306,6,10,-1,0,306,307,3,20,10,0,307,308,6,10,-1,0,308,310,1,
        0,0,0,309,288,1,0,0,0,309,289,1,0,0,0,309,298,1,0,0,0,310,21,1,0,
        0,0,311,333,1,0,0,0,312,313,5,28,0,0,313,314,6,11,-1,0,314,315,3,
        32,16,0,315,316,6,11,-1,0,316,317,5,29,0,0,317,318,6,11,-1,0,318,
        319,3,16,8,0,319,320,6,11,-1,0,320,333,1,0,0,0,321,322,5,28,0,0,
        322,323,6,11,-1,0,323,324,3,32,16,0,324,325,6,11,-1,0,325,326,5,
        29,0,0,326,327,6,11,-1,0,327,328,3,16,8,0,328,329,6,11,-1,0,329,
        330,3,22,11,0,330,331,6,11,-1,0,331,333,1,0,0,0,332,311,1,0,0,0,
        332,312,1,0,0,0,332,321,1,0,0,0,333,23,1,0,0,0,334,347,1,0,0,0,335,
        336,5,30,0,0,336,337,6,12,-1,0,337,338,5,32,0,0,338,347,6,12,-1,
        0,339,340,5,30,0,0,340,341,6,12,-1,0,341,342,5,32,0,0,342,343,6,
        12,-1,0,343,344,3,24,12,0,344,345,6,12,-1,0,345,347,1,0,0,0,346,
        334,1,0,0,0,346,335,1,0,0,0,346,339,1,0,0,0,347,25,1,0,0,0,348,366,
        1,0,0,0,349,350,5,8,0,0,350,351,6,13,-1,0,351,352,3,16,8,0,352,353,
        6,13,-1,0,353,354,5,9,0,0,354,355,6,13,-1,0,355,366,1,0,0,0,356,
        357,5,8,0,0,357,358,6,13,-1,0,358,359,3,16,8,0,359,360,6,13,-1,0,
        360,361,5,9,0,0,361,362,6,13,-1,0,362,363,3,26,13,0,363,364,6,13,
        -1,0,364,366,1,0,0,0,365,348,1,0,0,0,365,349,1,0,0,0,365,356,1,0,
        0,0,366,27,1,0,0,0,367,381,1,0,0,0,368,369,5,31,0,0,369,370,6,14,
        -1,0,370,371,3,16,8,0,371,372,6,14,-1,0,372,381,1,0,0,0,373,374,
        5,31,0,0,374,375,6,14,-1,0,375,376,3,16,8,0,376,377,6,14,-1,0,377,
        378,3,28,14,0,378,379,6,14,-1,0,379,381,1,0,0,0,380,367,1,0,0,0,
        380,368,1,0,0,0,380,373,1,0,0,0,381,29,1,0,0,0,382,396,1,0,0,0,383,
        384,5,2,0,0,384,385,6,15,-1,0,385,386,3,16,8,0,386,387,6,15,-1,0,
        387,396,1,0,0,0,388,389,5,7,0,0,389,390,3,8,4,0,390,391,5,2,0,0,
        391,392,6,15,-1,0,392,393,3,16,8,0,393,394,6,15,-1,0,394,396,1,0,
        0,0,395,382,1,0,0,0,395,383,1,0,0,0,395,388,1,0,0,0,396,31,1,0,0,
        0,397,410,1,0,0,0,398,399,3,34,17,0,399,400,6,16,-1,0,400,410,1,
        0,0,0,401,402,6,16,-1,0,402,403,3,34,17,0,403,404,6,16,-1,0,404,
        405,5,13,0,0,405,406,6,16,-1,0,406,407,3,32,16,0,407,408,6,16,-1,
        0,408,410,1,0,0,0,409,397,1,0,0,0,409,398,1,0,0,0,409,401,1,0,0,
        0,410,33,1,0,0,0,411,432,1,0,0,0,412,413,5,32,0,0,413,432,6,17,-1,
        0,414,415,5,5,0,0,415,432,6,17,-1,0,416,417,5,6,0,0,417,418,6,17,
        -1,0,418,419,5,32,0,0,419,420,6,17,-1,0,420,421,3,34,17,0,421,422,
        6,17,-1,0,422,432,1,0,0,0,423,424,3,36,18,0,424,425,6,17,-1,0,425,
        432,1,0,0,0,426,427,5,8,0,0,427,428,3,32,16,0,428,429,5,9,0,0,429,
        430,6,17,-1,0,430,432,1,0,0,0,431,411,1,0,0,0,431,412,1,0,0,0,431,
        414,1,0,0,0,431,416,1,0,0,0,431,423,1,0,0,0,431,426,1,0,0,0,432,
        35,1,0,0,0,433,455,1,0,0,0,434,435,5,20,0,0,435,436,6,18,-1,0,436,
        437,5,32,0,0,437,438,6,18,-1,0,438,439,5,2,0,0,439,440,6,18,-1,0,
        440,441,3,32,16,0,441,442,6,18,-1,0,442,455,1,0,0,0,443,444,5,20,
        0,0,444,445,6,18,-1,0,445,446,5,32,0,0,446,447,6,18,-1,0,447,448,
        5,2,0,0,448,449,6,18,-1,0,449,450,3,32,16,0,450,451,6,18,-1,0,451,
        452,3,36,18,0,452,453,6,18,-1,0,453,455,1,0,0,0,454,433,1,0,0,0,
        454,434,1,0,0,0,454,443,1,0,0,0,455,37,1,0,0,0,19,45,61,72,98,164,
        177,189,197,262,286,309,332,346,365,380,395,409,431,454
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
        self._guidance = [default_prompt]
        self._overflow = False  
        self._light_mode = light_mode  

    def reset(self): 
        self._guidance = [default_prompt]
        self._overflow = False
        # self.getCurrentToken()
        # self.getTokenStream()


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

    def refine_prompt(self, f : Callable, prompt : Prompt) -> Optional[Prompt]:
        args = [Context(prompt.enviro, prompt.world)] + prompt.args
        for arg in args:
            if arg == None:
                self._overflow = True

        result_context = None
        if not self._overflow:
            result_context = f(*args)
            prompt = Prompt(result_context.enviro, result_context.world, [])
            self._guidance = prompt 

            tok = self.getCurrentToken()
            if tok.type == self.EOF :
                self._overflow = True 

        return prompt




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



    def collect(self, f : Callable, prompt : Prompt):
        args = [Context(prompt.enviro, prompt.world)] + prompt.args

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.mrs = None
            self._preamble = None # PreambleContext
            self._expr = None # ExprContext
            self.prompts = prompts

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




    def program(self, prompts:list[Prompt]):

        localctx = SlimParser.ProgramContext(self, self._ctx, self.state, prompts)
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
                localctx._expr = self.expr(prompts)

                localctx.mrs = localctx._expr.mrs

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 69
                localctx._expr = self.expr(prompts)

                self._solver = Solver(m())
                localctx.mrs = localctx._expr.mrs

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.mrs = None
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
            self.prompts = prompts

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




    def expr(self, prompts:list[Prompt]):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 16, self.RULE_expr)
        try:
            self.state = 262
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 200
                localctx._base = self.base(prompts)

                localctx.mrs = localctx._base.mrs
                self.update_sr('expr', [n('base')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                head_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_tuple_head, prompt)
                    for prompt in prompts 
                ]

                self.state = 204
                localctx.head = self.base(head_prompts)

                self.guide_symbol(',')

                self.state = 206
                self.match(SlimParser.T__12)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = head_result.world,
                        args = prompt.args + [head_result.typ]
                    )
                    for i, prompt in enumerate(prompts) 
                    for head_result in localctx.head.mrs[i]
                ] 
                tail_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_tuple_tail, prompt)
                    for prompt in prompts
                ]

                self.state = 208
                localctx.tail = self.expr(tail_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = tail_result.world,
                        args = prompt.args + [tail_result.typ]
                    )
                    for i, prompt in enumerate(prompts)
                    for tail_result in localctx.tail.mrs[i]
                ] 

                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_tuple, prompt) 
                    for prompt in prompts
                ]
                self.update_sr('expr', [n('base'), t(','), n('expr')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 211
                self.match(SlimParser.T__21)

                condition_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_condition, prompt)
                    for prompt in prompts
                ]

                self.state = 213
                localctx.condition = self.expr(condition_prompts)

                self.guide_symbol('then')

                self.state = 215
                self.match(SlimParser.T__22)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = condition_result.world,
                        args = prompt.args + [condition_result.typ]
                    )
                    for i, prompt in enumerate(prompts)
                    for condition_result in localctx.condition.mrs[i] 
                ]
                true_branch_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_true_branch, prompt)
                    for prompt in prompts
                ]

                self.state = 217
                localctx.true_branch = self.expr(true_branch_prompts)

                self.guide_symbol('else')

                self.state = 219
                self.match(SlimParser.T__23)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.true_branch.mrs[i]]
                    )
                    for i, prompt in enumerate(prompts)
                ]
                false_branch_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_false_branch, prompt)
                    for prompt in prompts
                ]

                self.state = 221
                localctx.false_branch = self.expr(false_branch_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.false_branch.mrs[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_ite, prompt)
                    for prompt in prompts
                ]
                self.update_sr('expr', [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                rator_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_projection_rator, prompt)
                    for prompt in prompts
                ]

                self.state = 225
                localctx.rator = self.base(rator_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = rator_result.world,
                        args = prompt.args + [rator_result.typ]
                    )
                    for i, prompt in enumerate(prompts)
                    for rator_result in localctx.rator.mrs[i]
                ]
                keychain_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_projection_keychain, prompt)
                    for prompt in prompts
                ]

                self.state = 227
                localctx._keychain = self.keychain()

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world,
                        args = prompt.args + [localctx._keychain.keys]
                    )
                    for prompt in prompts
                ]
                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_projection, prompt) 
                    for prompt in prompts
                ]
                self.update_sr('expr', [n('base'), n('keychain')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                cator_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_application_cator, prompt)
                    for prompt in prompts
                ]

                self.state = 231
                localctx.cator = self.base(cator_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = cator_result.world,
                        args = prompt.args + [cator_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for cator_result in localctx.cator.mrs[i] 
                ]
                argchain_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_application_argchain, prompt)
                    for prompt in prompts
                ]

                self.state = 233
                localctx._argchain = self.argchain(argchain_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = localctx._argchain.attrs[i].world,
                        args = prompt.args + [localctx._argchain.attrs[i].args]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_application, prompt)
                    for prompt in prompts
                ]
                self.update_sr('expr', [n('base'), n('argchain')])

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                arg_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_funnel_arg, prompt)
                    for prompt in prompts
                ]

                self.state = 237
                localctx.arg = self.base(arg_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = arg_result.worlds,
                        args = prompt.args + [arg_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for arg_result in localctx.arg.mrs[i]
                ]
                pipeline_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_funnel_pipeline, prompt)
                    for prompt in prompts
                ]

                self.state = 239
                localctx._pipeline = self.pipeline(pipeline_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = pipeline_attr.worlds,
                        args = prompt.args + [localctx._pipeline.attrs[i].cators]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_funnel, prompts)
                    for prompt in prompts
                ]
                self.update_sr('expr', [n('base'), n('pipeline')])

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 242
                self.match(SlimParser.T__24)

                self.guide_terminal('ID')

                self.state = 244
                localctx._ID = self.match(SlimParser.ID)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [(None if localctx._ID is None else localctx._ID.text)]
                    )
                    for prompt in prompts
                ]
                target_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_let_target, prompt)
                    for prompt in prompts
                ]

                self.state = 246
                localctx._target = self.target(target_prompts)

                self.guide_symbol('in')

                self.state = 248
                self.match(SlimParser.T__25)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = target_result.world,
                        args = prompt.args + [target_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for target_result in localctx._target.mrs[i]
                ]
                contin_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_let_contin, prompt)
                    for prompt in prompts
                ]

                self.state = 250
                localctx.contin = self.expr(contin_prompts)

                localctx.mrs = localctx.contin.mrs
                self.update_sr('expr', [t('let'), ID, n('target'), t('in'), n('expr')])

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 253
                self.match(SlimParser.T__26)

                self.guide_symbol('(')

                self.state = 255
                self.match(SlimParser.T__7)

                body_prompts = [
                    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_fix_body, prompt)
                    for prompt in prompts
                ]

                self.state = 257
                localctx.body = self.expr(body_prompts)

                self.guide_symbol(')')

                self.state = 259
                self.match(SlimParser.T__8)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = body_result.world,
                        args = prompt.args + [body_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for body_result in localctx.body.mrs[i]
                ]
                localctx.mrs = [
                    self.collect(ExprRule(self._solver, self._light_mode).combine_fix, prompt)
                    for prompt in prompts
                ]
                self.update_sr('expr', [t('fix'), t('('), n('expr'), t(')')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.mrs = None
            self._ID = None # Token
            self.body = None # BaseContext
            self._record = None # RecordContext
            self._function = None # FunctionContext
            self._argchain = None # ArgchainContext
            self.prompts = prompts

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




    def base(self, prompts:list[Prompt]):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 18, self.RULE_base)
        try:
            self.state = 286
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 265
                self.match(SlimParser.T__4)

                localctx.mrs = [
                    self.collect(BaseRule(self._solver, self._light_mode).combine_unit, prompt)
                    for prompt in prompts
                ]
                self.update_sr('base', [t('@')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 267
                self.match(SlimParser.T__5)

                self.guide_terminal('ID')

                self.state = 269
                localctx._ID = self.match(SlimParser.ID)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [(None if localctx._ID is None else localctx._ID.text)]
                    )
                    for prompt in prompts
                ]
                body_prompts = [
                    self.refine_prompt(BaseRule(self._solver, self._light_mode).distill_tag_body, prompt)
                    for prompt in prompts
                ]

                self.state = 271
                localctx.body = self.base(body_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = body_result.world,
                        args = prompt.args + [body_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for body_result in localctx.body.mrs[i]
                ]
                localctx.mrs = [
                    self.collect(BaseRule(self._solver, self._light_mode).combine_tag, prompt)
                    for prompt in prompts
                ]
                self.update_sr('base', [t('~'), ID, n('base')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 274
                localctx._record = self.record(prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx._record.switches[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.mrs = [
                    self.collect(BaseRule(self._solver, self._light_mode).combine_record, prompts)
                    for prompts in prompt
                ]
                self.update_sr('base', [n('record')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 278
                localctx._function = self.function(prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx._function.switches[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.mrs = [
                    self.collect(BaseRule(self._solver, self._light_mode).combine_function, prompt)
                    for prompt in prompts
                ]
                self.update_sr('base', [n('function')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 281
                localctx._ID = self.match(SlimParser.ID)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [(None if localctx._ID is None else localctx._ID.text)]
                    )
                    for prompt in prompts
                ]
                localctx.mrs = [
                    self.collect(BaseRule(self._solver, self._light_mode).combine_var, prompt)
                    for prompt in prompts
                ]
                self.update_sr('base', [ID])

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 283
                localctx._argchain = self.argchain(prompts)


                localctx.mrs = [
                    [
                        r
                        for attr in localctx._argchain.attrs
                        for r in self.collect(BaseRule(self._solver, self._light_mode).combine_assoc, Prompt(
                            enviro = outer_prompt.enviro, 
                            world = attr.world,
                            args = [attr.args]
                        ))
                    ]
                    for outer_prompt in prompts
                ]
                self.update_sr('base', [n('argchain')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.switches = None
            self._ID = None # Token
            self.body = None # ExprContext
            self.tail = None # RecordContext
            self.prompts = prompts

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




    def record(self, prompts:list[Prompt]):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 20, self.RULE_record)
        try:
            self.state = 309
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 289
                self.match(SlimParser.T__19)

                self.guide_terminal('ID')

                self.state = 291
                localctx._ID = self.match(SlimParser.ID)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [(None if localctx._ID is None else localctx._ID.text)]
                    )
                    for prompt in prompts
                ]
                self.guide_symbol('=')

                self.state = 293
                self.match(SlimParser.T__1)

                sub_prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = []
                    )
                    for prompt in prompts
                ]

                self.state = 295
                localctx.body = self.expr(sub_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.body.mrs[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]

                localctx.switches = [
                    self.collect(RecordRule(self._solver, self._light_mode).combine_single, prompt)
                    for prompt in prompts
                ]
                self.update_sr('record', [SEMI, ID, t('='), n('expr')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 298
                self.match(SlimParser.T__19)

                self.guide_terminal('ID')

                self.state = 300
                localctx._ID = self.match(SlimParser.ID)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [(None if localctx._ID is None else localctx._ID.text)]
                    )
                    for prompt in prompts
                ]
                self.guide_symbol('=')

                self.state = 302
                self.match(SlimParser.T__1)

                sub_prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = []
                    )
                    for prompt in prompts
                ]

                self.state = 304
                localctx.body = self.expr(sub_prompts)


                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.body.mrs[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]

                sub_prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = []
                    )
                    for prompt in prompts
                ]

                self.state = 306
                localctx.tail = self.record(sub_prompts)


                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.tail.switches[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.switches = [
                    self.collect(RecordRule(self._solver, self._light_mode).combine_cons, prompt) 
                    for prompt in prompts
                ]
                self.update_sr('record', [SEMI, ID, t('='), n('expr'), n('record')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.switches = None
            self._pattern = None # PatternContext
            self.body = None # ExprContext
            self.tail = None # FunctionContext
            self.prompts = prompts

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




    def function(self, prompts:list[Prompt]):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 22, self.RULE_function)
        try:
            self.state = 332
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 312
                self.match(SlimParser.T__27)


                self.state = 314
                localctx._pattern = self.pattern()

                self.guide_symbol('=>')

                self.state = 316
                self.match(SlimParser.T__28)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = [localctx._pattern.attr]
                    )
                    for prompt in prompts
                ]
                body_prompts = [
                    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_single_body, prompt)
                    for prompt in prompts
                ]


                self.state = 318
                localctx.body = self.expr(body_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.body.mrs[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.switches = [
                    self.collect(FunctionRule(self._solver, self._light_mode).combine_single, prompt)
                    for prompt in prompts
                ]
                self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 321
                self.match(SlimParser.T__27)


                self.state = 323
                localctx._pattern = self.pattern()

                self.guide_symbol('=>')

                self.state = 325
                self.match(SlimParser.T__28)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx._pattern.attr]
                    )
                    for prompt in prompts
                ]
                body_prompts = [
                    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_cons_body, prompt)
                    for prompt in prompts
                ]

                self.state = 327
                localctx.body = self.expr(body_prompts)


                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.body.mrs[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                tail_prompts = [
                    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_cons_tail, prompt)
                    for prompt in prompts
                ]

                self.state = 329
                localctx.tail = self.function(tail_prompts)


                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = prompt.args + [localctx.tail.switches[i]]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.switches = [
                    self.collect(FunctionRule(self._solver, self._light_mode).combine_cons, prompt)
                    for prompt in prompts 
                ]
                self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr'), n('function')])

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
            self.state = 346
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 335
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 337
                localctx._ID = self.match(SlimParser.ID)

                localctx.keys = KeychainRule(self._solver, self._light_mode).combine_single((None if localctx._ID is None else localctx._ID.text))
                self.update_sr('keychain', [t('.'), ID])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 339
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 341
                localctx._ID = self.match(SlimParser.ID)


                self.state = 343
                localctx.tail = self.keychain()

                localctx.keys = KeychainRule(self._solver, self._light_mode).combine_cons((None if localctx._ID is None else localctx._ID.text), localctx.tail.keys)
                self.update_sr('keychain', [t('.'), ID, n('keychain')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.attrs = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # ArgchainContext
            self.prompts = prompts

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




    def argchain(self, prompts:list[Prompt]):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 26, self.RULE_argchain)
        try:
            self.state = 365
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 349
                self.match(SlimParser.T__7)

                content_prompts = [
                    self.refine_prompt(ArgchainRule(self._solver, self._light_mode).distill_single_content, prompt) 
                    for prompt in prompts
                ]   

                self.state = 351
                localctx.content = self.expr(content_prompts)

                self.guide_symbol(')')

                self.state = 353
                self.match(SlimParser.T__8)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = content_result.world,
                        args = prompt.args + [content_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for content_result in localctx.content.mrs[i]
                ]
                localctx.attrs = [
                    self.collect(ArgchainRule(self._solver, self._light_mode).combine_single, prompt)
                    for prompt in prompts
                ]
                self.update_sr('argchain', [t('('), n('expr'), t(')')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 356
                self.match(SlimParser.T__7)

                head_prompts = [
                    self.refine_prompt(ArgchainRule(self._solver, self._light_mode).distill_cons_head, prompt) 
                    for prompt in prompts
                ]

                self.state = 358
                localctx.head = self.expr(head_prompts)

                self.guide_symbol(')')

                self.state = 360
                self.match(SlimParser.T__8)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = head_result.world,
                        args = prompt.args + [head_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for head_result in localctx.head.mrs[i]
                ]
                tail_prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = prompt.world, 
                        args = []
                    )
                    for prompt in prompts
                ] 

                self.state = 362
                localctx.tail = self.argchain(tail_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = localctx.tail.attrs[i].world,
                        args = prompt.args + [localctx.tail.attrs[i].args]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.attrs = [
                    self.collect(ArgchainRule(self._solver, self._light_mode).combine_cons, prompt)
                    for prompt in prompts
                ]
                self.update_sr('argchain', [t('('), n('expr'), t(')'), n('argchain')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.attrs = None
            self.content = None # ExprContext
            self.head = None # ExprContext
            self.tail = None # PipelineContext
            self.prompts = prompts

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




    def pipeline(self, prompts:list[Prompt]):

        localctx = SlimParser.PipelineContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 28, self.RULE_pipeline)
        try:
            self.state = 380
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 368
                self.match(SlimParser.T__30)

                content_prompts = [
                    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_single_content, prompt)
                    for prompt in prompts
                ]

                self.state = 370
                localctx.content = self.expr(content_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = content_result.world,
                        args = prompt.args + [content_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for content_result in localctx.content.mrs[i]
                ]
                localctx.attrs = [
                    self.collect(PipelineRule(self._solver, self._light_mode).combine_single, prompt)
                    for prompt in prompts
                ]
                self.update_sr('pipeline', [t('|>'), n('expr')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 373
                self.match(SlimParser.T__30)

                head_prompts = [
                    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_cons_head, prompt) 
                    for prompt in prompts
                ]

                self.state = 375
                localctx.head = self.expr(head_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = head_result.world,
                        args = prompt.args + [head_result.typ]
                    )
                    for i,prompt in enumerate(prompts)
                    for head_result in localctx.head.mrs[i]
                ]
                tail_prompts = [
                    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_cons_tail, prompt) 
                    for prompt in prompts
                ]

                self.state = 377
                localctx.tail = self.pipeline(tail_prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = localctx.tail.attrs[i].world,
                        args = prompt.args + [localctx.tail.attrs[i].cators]
                    )
                    for i,prompt in enumerate(prompts)
                ]
                localctx.attrs = [
                    self.collect(ArgchainRule(self._solver, self._light_mode, prompts).combine_cons, prompt)
                    for prompt in prompts
                ]
                self.update_sr('pipeline', [t('|>'), n('expr'), n('pipeline')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, prompts:list[Prompt]=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.prompts = None
            self.mrs = None
            self._expr = None # ExprContext
            self._typ = None # TypContext
            self.prompts = prompts

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




    def target(self, prompts:list[Prompt]):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, prompts)
        self.enterRule(localctx, 30, self.RULE_target)
        try:
            self.state = 395
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [26]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 2)
                self.state = 383
                self.match(SlimParser.T__1)


                self.state = 385
                localctx._expr = self.expr(prompts)

                localctx.mrs = localctx._expr.mrs
                self.update_sr('target', [t('='), n('expr')])

                pass
            elif token in [7]:
                self.enterOuterAlt(localctx, 3)
                self.state = 388
                self.match(SlimParser.T__6)
                self.state = 389
                localctx._typ = self.typ()
                self.state = 390
                self.match(SlimParser.T__1)


                self.state = 392
                localctx._expr = self.expr(prompts)

                prompts = [
                    Prompt(
                        enviro = prompt.enviro, 
                        world = expr_result.world,
                        args = prompt.args + [localctx._typ.combo]
                    )
                    for i,prompt in enumerate(prompts)
                    for expr_result in localctx._expr.mrs[i]
                ]
                localctx.mrs = [
                    self.collect(TargetRule(self._solver, self._light_mode).combine_anno, prompt) 
                    for prompt in prompts
                ]
                self.update_sr('target', [t(':'), TID, t('='), n('expr')])

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
            self.attr = None
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
            self.state = 409
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 398
                localctx._base_pattern = self.base_pattern()

                localctx.attr = localctx._base_pattern.attr
                self.update_sr('pattern', [n('basepat')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)


                self.state = 402
                localctx.head = self.base_pattern()

                self.guide_symbol(',')

                self.state = 404
                self.match(SlimParser.T__12)


                self.state = 406
                localctx.tail = self.pattern()

                localctx.attr = PatternRule(self._solver, self._light_mode).combine_tuple(localctx.head.attr, localctx.tail.attr)
                self.update_sr('pattern', [n('basepat'), t(','), n('pattern')])

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
            self.attr = None
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
            self.state = 431
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,17,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 412
                localctx._ID = self.match(SlimParser.ID)

                localctx.attr = BasePatternRule(self._solver, self._light_mode).combine_var((None if localctx._ID is None else localctx._ID.text))
                self.update_sr('basepat', [ID])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 414
                self.match(SlimParser.T__4)

                localctx.attr = BasePatternRule(self._solver, self._light_mode).combine_unit()
                self.update_sr('basepat', [t('@')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 416
                self.match(SlimParser.T__5)

                self.guide_terminal('ID')

                self.state = 418
                localctx._ID = self.match(SlimParser.ID)


                self.state = 420
                localctx.body = self.base_pattern()

                localctx.attr = BasePatternRule(self._solver, self._light_mode).combine_tag((None if localctx._ID is None else localctx._ID.text), localctx.body.attr)
                self.update_sr('basepat', [t('~'), ID, n('basepat')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 423
                localctx._record_pattern = self.record_pattern()

                localctx.attr = localctx._record_pattern.attr
                self.update_sr('basepat', [n('recpat')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 426
                self.match(SlimParser.T__7)
                self.state = 427
                localctx._pattern = self.pattern()
                self.state = 428
                self.match(SlimParser.T__8)

                localctx.attr = localctx._pattern.attr
                self.update_sr('basepat', [t('('), n('pattern'), t(')')])

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
            self.attr = None
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
            self.state = 454
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,18,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 434
                self.match(SlimParser.T__19)

                self.guide_terminal('ID')

                self.state = 436
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 438
                self.match(SlimParser.T__1)


                self.state = 440
                localctx.body = self.pattern()

                localctx.attr = RecordPatternRule(self._solver, self._light_mode).combine_single((None if localctx._ID is None else localctx._ID.text), localctx.body.attr)
                self.update_sr('recpat', [SEMI, ID, t('='), n('pattern')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 443
                self.match(SlimParser.T__19)

                self.guide_terminal('ID')

                self.state = 445
                localctx._ID = self.match(SlimParser.ID)


                self.state = 447
                self.match(SlimParser.T__1)


                self.state = 449
                localctx.body = self.pattern()


                self.state = 451
                localctx.tail = self.record_pattern()

                localctx.attr = RecordPatternRule(self._solver, self._light_mode, prompts).combine_cons((None if localctx._ID is None else localctx._ID.text), localctx.body.attr, localctx.tail.attr)
                self.update_sr('recpat', [SEMI, ID, t('='), n('pattern'), n('recpat')])

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





