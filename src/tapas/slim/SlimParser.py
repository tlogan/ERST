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

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset


def serializedATN():
    return [
        4,1,34,456,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,
        2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,1,0,1,0,1,0,1,
        0,1,0,1,0,1,0,3,0,46,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
        1,1,1,1,1,1,1,1,3,1,62,8,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,3,
        2,73,8,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,
        1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,99,8,3,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,
        4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,3,4,164,8,4,1,5,1,
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,3,5,177,8,5,1,6,1,6,1,6,1,
        6,1,6,1,6,1,6,1,6,1,6,1,6,3,6,189,8,6,1,7,1,7,1,7,1,7,1,7,1,7,3,
        7,197,8,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,
        8,1,8,3,8,262,8,8,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,
        9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,1,9,3,9,286,8,9,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,1,10,
        1,10,1,10,1,10,1,10,1,10,1,10,3,10,309,8,10,1,11,1,11,1,11,1,11,
        1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,1,11,
        1,11,1,11,1,11,1,11,3,11,332,8,11,1,12,1,12,1,12,1,12,1,12,1,12,
        1,12,1,12,1,12,1,12,1,12,1,12,3,12,346,8,12,1,13,1,13,1,13,1,13,
        1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,1,13,
        3,13,365,8,13,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,1,14,
        1,14,1,14,1,14,3,14,380,8,14,1,15,1,15,1,15,1,15,1,15,1,15,1,15,
        1,15,1,15,1,15,1,15,1,15,1,15,3,15,395,8,15,1,16,1,16,1,16,1,16,
        1,16,1,16,1,16,1,16,1,16,1,16,1,16,1,16,3,16,409,8,16,1,17,1,17,
        1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,1,17,
        1,17,1,17,1,17,1,17,1,17,3,17,431,8,17,1,18,1,18,1,18,1,18,1,18,
        1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,1,18,
        1,18,1,18,1,18,3,18,454,8,18,1,18,0,0,19,0,2,4,6,8,10,12,14,16,18,
        20,22,24,26,28,30,32,34,36,0,0,500,0,45,1,0,0,0,2,61,1,0,0,0,4,72,
        1,0,0,0,6,98,1,0,0,0,8,163,1,0,0,0,10,176,1,0,0,0,12,188,1,0,0,0,
        14,196,1,0,0,0,16,261,1,0,0,0,18,285,1,0,0,0,20,308,1,0,0,0,22,331,
        1,0,0,0,24,345,1,0,0,0,26,364,1,0,0,0,28,379,1,0,0,0,30,394,1,0,
        0,0,32,408,1,0,0,0,34,430,1,0,0,0,36,453,1,0,0,0,38,46,1,0,0,0,39,
        40,5,32,0,0,40,46,6,0,-1,0,41,42,5,32,0,0,42,43,3,0,0,0,43,44,6,
        0,-1,0,44,46,1,0,0,0,45,38,1,0,0,0,45,39,1,0,0,0,45,41,1,0,0,0,46,
        1,1,0,0,0,47,62,1,0,0,0,48,49,5,1,0,0,49,50,5,32,0,0,50,51,5,2,0,
        0,51,52,3,8,4,0,52,53,6,1,-1,0,53,62,1,0,0,0,54,55,5,1,0,0,55,56,
        5,32,0,0,56,57,5,2,0,0,57,58,3,8,4,0,58,59,3,2,1,0,59,60,6,1,-1,
        0,60,62,1,0,0,0,61,47,1,0,0,0,61,48,1,0,0,0,61,54,1,0,0,0,62,3,1,
        0,0,0,63,73,1,0,0,0,64,65,3,2,1,0,65,66,6,2,-1,0,66,67,3,16,8,0,
        67,68,6,2,-1,0,68,73,1,0,0,0,69,70,3,16,8,0,70,71,6,2,-1,0,71,73,
        1,0,0,0,72,63,1,0,0,0,72,64,1,0,0,0,72,69,1,0,0,0,73,5,1,0,0,0,74,
        99,1,0,0,0,75,76,5,3,0,0,76,99,6,3,-1,0,77,78,5,4,0,0,78,99,6,3,
        -1,0,79,80,5,32,0,0,80,99,6,3,-1,0,81,82,5,5,0,0,82,99,6,3,-1,0,
        83,84,5,6,0,0,84,85,5,32,0,0,85,86,3,6,3,0,86,87,6,3,-1,0,87,99,
        1,0,0,0,88,89,5,32,0,0,89,90,5,7,0,0,90,91,3,6,3,0,91,92,6,3,-1,
        0,92,99,1,0,0,0,93,94,5,8,0,0,94,95,3,8,4,0,95,96,5,9,0,0,96,97,
        6,3,-1,0,97,99,1,0,0,0,98,74,1,0,0,0,98,75,1,0,0,0,98,77,1,0,0,0,
        98,79,1,0,0,0,98,81,1,0,0,0,98,83,1,0,0,0,98,88,1,0,0,0,98,93,1,
        0,0,0,99,7,1,0,0,0,100,164,1,0,0,0,101,102,3,6,3,0,102,103,6,4,-1,
        0,103,164,1,0,0,0,104,105,3,6,3,0,105,106,5,10,0,0,106,107,3,8,4,
        0,107,108,6,4,-1,0,108,164,1,0,0,0,109,110,3,6,3,0,110,111,5,11,
        0,0,111,112,3,8,4,0,112,113,6,4,-1,0,113,164,1,0,0,0,114,115,3,6,
        3,0,115,116,3,10,5,0,116,117,6,4,-1,0,117,164,1,0,0,0,118,119,3,
        6,3,0,119,120,5,12,0,0,120,121,3,8,4,0,121,122,6,4,-1,0,122,164,
        1,0,0,0,123,124,3,6,3,0,124,125,5,13,0,0,125,126,3,8,4,0,126,127,
        6,4,-1,0,127,164,1,0,0,0,128,129,5,14,0,0,129,130,5,15,0,0,130,131,
        3,0,0,0,131,132,5,16,0,0,132,133,3,8,4,0,133,134,6,4,-1,0,134,164,
        1,0,0,0,135,136,5,14,0,0,136,137,5,15,0,0,137,138,3,0,0,0,138,139,
        3,12,6,0,139,140,5,16,0,0,140,141,3,8,4,0,141,142,6,4,-1,0,142,164,
        1,0,0,0,143,144,5,17,0,0,144,145,5,15,0,0,145,146,3,0,0,0,146,147,
        5,16,0,0,147,148,3,8,4,0,148,149,6,4,-1,0,149,164,1,0,0,0,150,151,
        5,17,0,0,151,152,5,15,0,0,152,153,3,0,0,0,153,154,3,12,6,0,154,155,
        5,16,0,0,155,156,3,8,4,0,156,157,6,4,-1,0,157,164,1,0,0,0,158,159,
        5,18,0,0,159,160,5,32,0,0,160,161,3,8,4,0,161,162,6,4,-1,0,162,164,
        1,0,0,0,163,100,1,0,0,0,163,101,1,0,0,0,163,104,1,0,0,0,163,109,
        1,0,0,0,163,114,1,0,0,0,163,118,1,0,0,0,163,123,1,0,0,0,163,128,
        1,0,0,0,163,135,1,0,0,0,163,143,1,0,0,0,163,150,1,0,0,0,163,158,
        1,0,0,0,164,9,1,0,0,0,165,177,1,0,0,0,166,167,5,19,0,0,167,168,3,
        8,4,0,168,169,6,5,-1,0,169,177,1,0,0,0,170,171,5,19,0,0,171,172,
        3,8,4,0,172,173,6,5,-1,0,173,174,3,10,5,0,174,175,6,5,-1,0,175,177,
        1,0,0,0,176,165,1,0,0,0,176,166,1,0,0,0,176,170,1,0,0,0,177,11,1,
        0,0,0,178,189,1,0,0,0,179,180,5,20,0,0,180,181,3,14,7,0,181,182,
        6,6,-1,0,182,189,1,0,0,0,183,184,5,20,0,0,184,185,3,14,7,0,185,186,
        3,12,6,0,186,187,6,6,-1,0,187,189,1,0,0,0,188,178,1,0,0,0,188,179,
        1,0,0,0,188,183,1,0,0,0,189,13,1,0,0,0,190,197,1,0,0,0,191,192,3,
        8,4,0,192,193,5,21,0,0,193,194,3,8,4,0,194,195,6,7,-1,0,195,197,
        1,0,0,0,196,190,1,0,0,0,196,191,1,0,0,0,197,15,1,0,0,0,198,262,1,
        0,0,0,199,200,3,18,9,0,200,201,6,8,-1,0,201,262,1,0,0,0,202,203,
        6,8,-1,0,203,204,3,18,9,0,204,205,6,8,-1,0,205,206,5,13,0,0,206,
        207,6,8,-1,0,207,208,3,16,8,0,208,209,6,8,-1,0,209,262,1,0,0,0,210,
        211,5,22,0,0,211,212,6,8,-1,0,212,213,3,16,8,0,213,214,6,8,-1,0,
        214,215,5,23,0,0,215,216,6,8,-1,0,216,217,3,16,8,0,217,218,6,8,-1,
        0,218,219,5,24,0,0,219,220,6,8,-1,0,220,221,3,16,8,0,221,222,6,8,
        -1,0,222,262,1,0,0,0,223,224,6,8,-1,0,224,225,3,18,9,0,225,226,6,
        8,-1,0,226,227,3,24,12,0,227,228,6,8,-1,0,228,262,1,0,0,0,229,230,
        6,8,-1,0,230,231,3,18,9,0,231,232,6,8,-1,0,232,233,3,26,13,0,233,
        234,6,8,-1,0,234,262,1,0,0,0,235,236,6,8,-1,0,236,237,3,18,9,0,237,
        238,6,8,-1,0,238,239,3,28,14,0,239,240,6,8,-1,0,240,262,1,0,0,0,
        241,242,5,25,0,0,242,243,6,8,-1,0,243,244,5,32,0,0,244,245,6,8,-1,
        0,245,246,3,30,15,0,246,247,6,8,-1,0,247,248,5,20,0,0,248,249,6,
        8,-1,0,249,250,3,16,8,0,250,251,6,8,-1,0,251,262,1,0,0,0,252,253,
        5,26,0,0,253,254,6,8,-1,0,254,255,5,8,0,0,255,256,6,8,-1,0,256,257,
        3,16,8,0,257,258,6,8,-1,0,258,259,5,9,0,0,259,260,6,8,-1,0,260,262,
        1,0,0,0,261,198,1,0,0,0,261,199,1,0,0,0,261,202,1,0,0,0,261,210,
        1,0,0,0,261,223,1,0,0,0,261,229,1,0,0,0,261,235,1,0,0,0,261,241,
        1,0,0,0,261,252,1,0,0,0,262,17,1,0,0,0,263,286,1,0,0,0,264,265,5,
        5,0,0,265,286,6,9,-1,0,266,267,5,6,0,0,267,268,6,9,-1,0,268,269,
        5,32,0,0,269,270,6,9,-1,0,270,271,3,18,9,0,271,272,6,9,-1,0,272,
        286,1,0,0,0,273,274,3,20,10,0,274,275,6,9,-1,0,275,286,1,0,0,0,276,
        277,6,9,-1,0,277,278,3,22,11,0,278,279,6,9,-1,0,279,286,1,0,0,0,
        280,281,5,32,0,0,281,286,6,9,-1,0,282,283,3,26,13,0,283,284,6,9,
        -1,0,284,286,1,0,0,0,285,263,1,0,0,0,285,264,1,0,0,0,285,266,1,0,
        0,0,285,273,1,0,0,0,285,276,1,0,0,0,285,280,1,0,0,0,285,282,1,0,
        0,0,286,19,1,0,0,0,287,309,1,0,0,0,288,289,5,27,0,0,289,290,6,10,
        -1,0,290,291,5,32,0,0,291,292,6,10,-1,0,292,293,5,2,0,0,293,294,
        6,10,-1,0,294,295,3,16,8,0,295,296,6,10,-1,0,296,309,1,0,0,0,297,
        298,5,27,0,0,298,299,6,10,-1,0,299,300,5,32,0,0,300,301,6,10,-1,
        0,301,302,5,2,0,0,302,303,6,10,-1,0,303,304,3,16,8,0,304,305,6,10,
        -1,0,305,306,3,20,10,0,306,307,6,10,-1,0,307,309,1,0,0,0,308,287,
        1,0,0,0,308,288,1,0,0,0,308,297,1,0,0,0,309,21,1,0,0,0,310,332,1,
        0,0,0,311,312,5,28,0,0,312,313,6,11,-1,0,313,314,3,32,16,0,314,315,
        6,11,-1,0,315,316,5,29,0,0,316,317,6,11,-1,0,317,318,3,16,8,0,318,
        319,6,11,-1,0,319,332,1,0,0,0,320,321,5,28,0,0,321,322,6,11,-1,0,
        322,323,3,32,16,0,323,324,6,11,-1,0,324,325,5,29,0,0,325,326,6,11,
        -1,0,326,327,3,16,8,0,327,328,6,11,-1,0,328,329,3,22,11,0,329,330,
        6,11,-1,0,330,332,1,0,0,0,331,310,1,0,0,0,331,311,1,0,0,0,331,320,
        1,0,0,0,332,23,1,0,0,0,333,346,1,0,0,0,334,335,5,30,0,0,335,336,
        6,12,-1,0,336,337,5,32,0,0,337,346,6,12,-1,0,338,339,5,30,0,0,339,
        340,6,12,-1,0,340,341,5,32,0,0,341,342,6,12,-1,0,342,343,3,24,12,
        0,343,344,6,12,-1,0,344,346,1,0,0,0,345,333,1,0,0,0,345,334,1,0,
        0,0,345,338,1,0,0,0,346,25,1,0,0,0,347,365,1,0,0,0,348,349,5,8,0,
        0,349,350,6,13,-1,0,350,351,3,16,8,0,351,352,6,13,-1,0,352,353,5,
        9,0,0,353,354,6,13,-1,0,354,365,1,0,0,0,355,356,5,8,0,0,356,357,
        6,13,-1,0,357,358,3,16,8,0,358,359,6,13,-1,0,359,360,5,9,0,0,360,
        361,6,13,-1,0,361,362,3,26,13,0,362,363,6,13,-1,0,363,365,1,0,0,
        0,364,347,1,0,0,0,364,348,1,0,0,0,364,355,1,0,0,0,365,27,1,0,0,0,
        366,380,1,0,0,0,367,368,5,31,0,0,368,369,6,14,-1,0,369,370,3,16,
        8,0,370,371,6,14,-1,0,371,380,1,0,0,0,372,373,5,31,0,0,373,374,6,
        14,-1,0,374,375,3,16,8,0,375,376,6,14,-1,0,376,377,3,28,14,0,377,
        378,6,14,-1,0,378,380,1,0,0,0,379,366,1,0,0,0,379,367,1,0,0,0,379,
        372,1,0,0,0,380,29,1,0,0,0,381,395,1,0,0,0,382,383,5,2,0,0,383,384,
        6,15,-1,0,384,385,3,16,8,0,385,386,6,15,-1,0,386,395,1,0,0,0,387,
        388,5,7,0,0,388,389,3,8,4,0,389,390,5,2,0,0,390,391,6,15,-1,0,391,
        392,3,16,8,0,392,393,6,15,-1,0,393,395,1,0,0,0,394,381,1,0,0,0,394,
        382,1,0,0,0,394,387,1,0,0,0,395,31,1,0,0,0,396,409,1,0,0,0,397,398,
        3,34,17,0,398,399,6,16,-1,0,399,409,1,0,0,0,400,401,6,16,-1,0,401,
        402,3,34,17,0,402,403,6,16,-1,0,403,404,5,13,0,0,404,405,6,16,-1,
        0,405,406,3,32,16,0,406,407,6,16,-1,0,407,409,1,0,0,0,408,396,1,
        0,0,0,408,397,1,0,0,0,408,400,1,0,0,0,409,33,1,0,0,0,410,431,1,0,
        0,0,411,412,5,32,0,0,412,431,6,17,-1,0,413,414,5,5,0,0,414,431,6,
        17,-1,0,415,416,5,6,0,0,416,417,6,17,-1,0,417,418,5,32,0,0,418,419,
        6,17,-1,0,419,420,3,34,17,0,420,421,6,17,-1,0,421,431,1,0,0,0,422,
        423,3,36,18,0,423,424,6,17,-1,0,424,431,1,0,0,0,425,426,5,8,0,0,
        426,427,3,32,16,0,427,428,5,9,0,0,428,429,6,17,-1,0,429,431,1,0,
        0,0,430,410,1,0,0,0,430,411,1,0,0,0,430,413,1,0,0,0,430,415,1,0,
        0,0,430,422,1,0,0,0,430,425,1,0,0,0,431,35,1,0,0,0,432,454,1,0,0,
        0,433,434,5,27,0,0,434,435,6,18,-1,0,435,436,5,32,0,0,436,437,6,
        18,-1,0,437,438,5,2,0,0,438,439,6,18,-1,0,439,440,3,32,16,0,440,
        441,6,18,-1,0,441,454,1,0,0,0,442,443,5,27,0,0,443,444,6,18,-1,0,
        444,445,5,32,0,0,445,446,6,18,-1,0,446,447,5,2,0,0,447,448,6,18,
        -1,0,448,449,3,32,16,0,449,450,6,18,-1,0,450,451,3,36,18,0,451,452,
        6,18,-1,0,452,454,1,0,0,0,453,432,1,0,0,0,453,433,1,0,0,0,453,442,
        1,0,0,0,454,37,1,0,0,0,19,45,61,72,98,163,176,188,196,261,285,308,
        331,345,364,379,394,408,430,453
    ]

class SlimParser ( Parser ):

    grammarFileName = "Slim.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'alias'", "'='", "'TOP'", "'BOT'", "'@'", 
                     "'~'", "':'", "'('", "')'", "'|'", "'&'", "'->'", "','", 
                     "'EXI'", "'['", "']'", "'ALL'", "'LFP'", "'\\'", "';'", 
                     "'<:'", "'if'", "'then'", "'else'", "'let'", "'fix'", 
                     "'_.'", "'case'", "'=>'", "'.'", "'|>'" ]

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

    _syntax_rules : PSet[SyntaxRule] = s() 

    def init(self): 
        self._cache = {}
        self._guidance = Context('expr', m(), [World(s(), s(), s())], TVar("G0"))
        self._overflow = False  

    def reset(self): 
        self._guidance = Context('expr', m(), [World(s(), s(), s())], TVar("G0"))
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

    def tokenIndex(self):
        return self.getCurrentToken().tokenIndex

    def guide_nonterm(self, f : Callable, *args) -> Optional[Context]:
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, context:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.context = None
            self.worlds = None
            self._preamble = None # PreambleContext
            self._expr = None # ExprContext
            self.context = context

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




    def program(self, context:Context):

        localctx = SlimParser.ProgramContext(self, self._ctx, self.state, context)
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
                localctx._expr = self.expr(context)

                localctx.worlds = localctx._expr.worlds

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 69
                localctx._expr = self.expr(context)

                self._solver = Solver(m())
                localctx.worlds = localctx._expr.worlds

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
            self.state = 163
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
            self.state = 176
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,5,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 166
                self.match(SlimParser.T__18)
                self.state = 167
                localctx.negation = self.typ()

                localctx.combo = Diff(context, localctx.negation.combo)

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 170
                self.match(SlimParser.T__18)
                self.state = 171
                localctx.negation = self.typ()

                context_tail = Diff(context, localctx.negation.combo)

                self.state = 173
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
            self.state = 188
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,6,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 179
                self.match(SlimParser.T__19)
                self.state = 180
                localctx._subtyping = self.subtyping()

                localctx.combo = tuple([localctx._subtyping.combo])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 183
                self.match(SlimParser.T__19)
                self.state = 184
                localctx._subtyping = self.subtyping()
                self.state = 185
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
            self.state = 196
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [16, 20]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [3, 4, 5, 6, 8, 10, 11, 12, 13, 14, 17, 18, 19, 21, 32]:
                self.enterOuterAlt(localctx, 2)
                self.state = 191
                localctx.strong = self.typ()
                self.state = 192
                self.match(SlimParser.T__20)
                self.state = 193
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.worlds = None
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




    def expr(self, nt:Context):

        localctx = SlimParser.ExprContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 16, self.RULE_expr)
        try:
            self.state = 261
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,8,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 199
                localctx._base = self.base(nt)

                localctx.worlds = localctx._base.worlds
                self.update_sr('expr', [n('base')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)

                head_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_head, nt)

                self.state = 203
                localctx.head = self.base(head_nt)

                self.guide_symbol(',')

                self.state = 205
                self.match(SlimParser.T__12)

                nt = replace(nt, worlds = localctx.head.worlds)
                tail_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_tail, nt, head_nt.typ_var)

                self.state = 207
                localctx.tail = self.expr(tail_nt)

                nt = replace(nt, worlds = localctx.tail.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_tuple, nt, head_nt.typ_var, tail_nt.typ_var) 
                self.update_sr('expr', [n('base'), t(','), n('expr')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 210
                self.match(SlimParser.T__21)

                condition_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_condition, nt)

                self.state = 212
                localctx.condition = self.expr(condition_nt)

                self.guide_symbol('then')

                self.state = 214
                self.match(SlimParser.T__22)

                true_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_true_branch, nt, condition_nt.typ_var)

                self.state = 216
                localctx.true_branch = self.expr(true_branch_nt)

                self.guide_symbol('else')

                self.state = 218
                self.match(SlimParser.T__23)

                false_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_false_branch, nt, condition_nt.typ_var, true_branch_nt.typ_var)

                self.state = 220
                localctx.false_branch = self.expr(false_branch_nt)

                nt = replace(nt, worlds = localctx.condition.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_ite, nt, condition_nt.typ_var, 
                    localctx.true_branch.worlds, true_branch_nt.typ_var, 
                    localctx.false_branch.worlds, false_branch_nt.typ_var
                ) 
                self.update_sr('expr', [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)

                rator_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_rator, nt)

                self.state = 224
                localctx.rator = self.base(rator_nt)

                nt = replace(nt, worlds = localctx.rator.worlds)
                keychain_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_keychain, nt, rator_nt.typ_var)

                self.state = 226
                localctx._keychain = self.keychain(keychain_nt)

                nt = replace(nt, worlds = keychain_nt.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_projection, nt, rator_nt.typ_var, localctx._keychain.keys) 
                self.update_sr('expr', [n('base'), n('keychain')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)

                cator_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_cator, nt)

                self.state = 230
                localctx.cator = self.base(cator_nt)

                nt = replace(nt, worlds = localctx.cator.worlds)
                argchain_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_argchain, nt, cator_nt.typ_var)

                self.state = 232
                localctx._argchain = self.argchain(argchain_nt)

                nt = replace(nt, worlds = localctx._argchain.attr.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_application, nt, cator_nt.typ_var, localctx._argchain.attr.args)
                self.update_sr('expr', [n('base'), n('argchain')])

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)

                arg_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_arg, nt)

                self.state = 236
                localctx.arg = self.base(arg_nt)

                nt = replace(nt, worlds = localctx.arg.worlds)
                pipeline_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_pipeline, nt, arg_nt.typ_var)

                self.state = 238
                localctx._pipeline = self.pipeline(pipeline_nt)

                nt = replace(nt, worlds = localctx._pipeline.attr.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_funnel, nt, arg_nt.typ_var, localctx._pipeline.attr.cators)
                self.update_sr('expr', [n('base'), n('pipeline')])

                pass

            elif la_ == 8:
                self.enterOuterAlt(localctx, 8)
                self.state = 241
                self.match(SlimParser.T__24)

                self.guide_terminal('ID')

                self.state = 243
                localctx._ID = self.match(SlimParser.ID)

                target_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_target, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 245
                localctx._target = self.target(target_nt)

                self.guide_symbol(';')

                self.state = 247
                self.match(SlimParser.T__19)

                nt = replace(nt, worlds = localctx._target.worlds)
                contin_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_contin, nt, (None if localctx._ID is None else localctx._ID.text), target_nt.typ_var)

                self.state = 249
                localctx.contin = self.expr(contin_nt)

                localctx.worlds =  localctx.contin.worlds
                self.update_sr('expr', [t('let'), ID, n('target'), t(''), n('expr')])

                pass

            elif la_ == 9:
                self.enterOuterAlt(localctx, 9)
                self.state = 252
                self.match(SlimParser.T__25)

                self.guide_symbol('(')

                self.state = 254
                self.match(SlimParser.T__7)

                body_nt = self.guide_nonterm(ExprRule(self._solver).distill_fix_body, nt)

                self.state = 256
                localctx.body = self.expr(body_nt)

                self.guide_symbol(')')

                self.state = 258
                self.match(SlimParser.T__8)

                nt = replace(nt, worlds = localctx.body.worlds)
                localctx.worlds = self.collect(ExprRule(self._solver).combine_fix, nt, body_nt.typ_var)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.worlds = None
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




    def base(self, nt:Context):

        localctx = SlimParser.BaseContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 18, self.RULE_base)
        try:
            self.state = 285
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,9,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 264
                self.match(SlimParser.T__4)

                localctx.worlds = self.collect(BaseRule(self._solver).combine_unit, nt)
                self.update_sr('base', [t('@')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 266
                self.match(SlimParser.T__5)

                self.guide_terminal('ID')

                self.state = 268
                localctx._ID = self.match(SlimParser.ID)

                body_nt = self.guide_nonterm(BaseRule(self._solver).distill_tag_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 270
                localctx.body = self.base(body_nt)

                nt = replace(nt, worlds = localctx.body.worlds)
                localctx.worlds = self.collect(BaseRule(self._solver).combine_tag, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var)
                self.update_sr('base', [t('~'), ID, n('base')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 273
                localctx._record = self.record(nt)

                branches = localctx._record.branches
                localctx.worlds = self.collect(BaseRule(self._solver).combine_record, nt, branches)
                self.update_sr('base', [n('record')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)


                self.state = 277
                localctx._function = self.function(nt)

                branches = localctx._function.branches
                localctx.worlds = self.collect(BaseRule(self._solver).combine_function, nt, branches)
                self.update_sr('base', [n('function')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 280
                localctx._ID = self.match(SlimParser.ID)

                localctx.worlds = self.collect(BaseRule(self._solver).combine_var, nt, (None if localctx._ID is None else localctx._ID.text))
                self.update_sr('base', [ID])

                pass

            elif la_ == 7:
                self.enterOuterAlt(localctx, 7)
                self.state = 282
                localctx._argchain = self.argchain(nt)

                nt = replace(nt, worlds = localctx._argchain.attr.worlds)
                localctx.worlds = self.collect(BaseRule(self._solver).combine_assoc, nt, localctx._argchain.attr.args)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.branches = None
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




    def record(self, nt:Context):

        localctx = SlimParser.RecordContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 20, self.RULE_record)
        try:
            self.state = 308
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,10,self._ctx)
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
                self.match(SlimParser.T__1)

                body_nt = self.guide_nonterm(RecordRule(self._solver).distill_single_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 294
                localctx.body = self.expr(body_nt)

                localctx.branches = self.collect(RecordRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.worlds, body_nt.typ_var)
                self.update_sr('record', [t('_.'), ID, t('='), n('expr')])

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
                self.match(SlimParser.T__1)

                body_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_body, nt, (None if localctx._ID is None else localctx._ID.text))

                self.state = 303
                localctx.body = self.expr(body_nt)

                tail_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_tail, nt, (None if localctx._ID is None else localctx._ID.text), body_nt.typ_var)

                self.state = 305
                localctx.tail = self.record(tail_nt)

                tail_branches = localctx.tail.branches
                localctx.branches = self.collect(RecordRule(self._solver).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.worlds, body_nt.typ_var, tail_branches)
                self.update_sr('record', [t('_.'), ID, t('='), n('expr'), n('record')])

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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.branches = None
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




    def function(self, nt:Context):

        localctx = SlimParser.FunctionContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 22, self.RULE_function)
        try:
            self.state = 331
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,11,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 311
                self.match(SlimParser.T__27)


                self.state = 313
                localctx._pattern = self.pattern(nt)

                self.guide_symbol('=>')

                self.state = 315
                self.match(SlimParser.T__28)

                body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_body, nt, localctx._pattern.attr)

                self.state = 317
                localctx.body = self.expr(body_nt)

                localctx.branches = self.collect(FunctionRule(self._solver).combine_single, nt, localctx._pattern.attr.typ, localctx.body.worlds, body_nt.typ_var)
                self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 320
                self.match(SlimParser.T__27)


                self.state = 322
                localctx._pattern = self.pattern(nt)

                self.guide_symbol('=>')

                self.state = 324
                self.match(SlimParser.T__28)

                body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_body, nt, localctx._pattern.attr)

                self.state = 326
                localctx.body = self.expr(body_nt)

                tail_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_tail, nt, localctx._pattern.attr.typ, body_nt.typ_var)

                self.state = 328
                localctx.tail = self.function(tail_nt)

                tail_branches = localctx.tail.branches
                localctx.branches = self.collect(FunctionRule(self._solver).combine_cons, nt, localctx._pattern.attr.typ, localctx.body.worlds, body_nt.typ_var, tail_branches)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
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




    def keychain(self, nt:Context):

        localctx = SlimParser.KeychainContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 24, self.RULE_keychain)
        try:
            self.state = 345
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,12,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 334
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 336
                localctx._ID = self.match(SlimParser.ID)

                localctx.keys = self.collect(KeychainRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text))
                self.update_sr('keychain', [t('.'), ID])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 338
                self.match(SlimParser.T__29)

                self.guide_terminal('ID')

                self.state = 340
                localctx._ID = self.match(SlimParser.ID)


                self.state = 342
                localctx.tail = self.keychain(nt)

                localctx.keys = self.collect(KeychainRule(self._solver).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), localctx.tail.keys)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
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




    def argchain(self, nt:Context):

        localctx = SlimParser.ArgchainContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 26, self.RULE_argchain)
        try:
            self.state = 364
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,13,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 348
                self.match(SlimParser.T__7)

                content_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_single_content, nt) 

                self.state = 350
                localctx.content = self.expr(content_nt)

                self.guide_symbol(')')

                self.state = 352
                self.match(SlimParser.T__8)

                nt = replace(nt, worlds = localctx.content.worlds)
                localctx.attr = self.collect(ArgchainRule(self._solver).combine_single, nt, content_nt.typ_var)
                self.update_sr('argchain', [t('('), n('expr'), t(')')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 355
                self.match(SlimParser.T__7)

                head_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_cons_head, nt) 

                self.state = 357
                localctx.head = self.expr(head_nt)

                self.guide_symbol(')')

                self.state = 359
                self.match(SlimParser.T__8)

                nt = replace(nt, worlds = localctx.head.worlds)

                self.state = 361
                localctx.tail = self.argchain(nt)

                nt = replace(nt, worlds = localctx.tail.attr.worlds)
                localctx.attr = self.collect(ArgchainRule(self._solver).combine_cons, nt, head_nt.typ_var, localctx.tail.attr.args)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.attr = None
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




    def pipeline(self, nt:Context):

        localctx = SlimParser.PipelineContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 28, self.RULE_pipeline)
        try:
            self.state = 379
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,14,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 367
                self.match(SlimParser.T__30)

                content_nt = self.guide_nonterm(PipelineRule(self._solver).distill_single_content, nt) 

                self.state = 369
                localctx.content = self.expr(content_nt)

                nt = replace(nt, worlds = localctx.content.worlds)
                localctx.attr = self.collect(PipelineRule(self._solver).combine_single, nt, content_nt.typ_var)
                self.update_sr('pipeline', [t('|>'), n('expr')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 372
                self.match(SlimParser.T__30)

                head_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_head, nt) 

                self.state = 374
                localctx.head = self.expr(head_nt)

                nt = replace(nt, worlds = localctx.head.worlds)
                tail_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_tail, nt, head_nt.typ_var) 

                self.state = 376
                localctx.tail = self.pipeline(tail_nt)

                nt = replace(nt, worlds = localctx.tail.attr.worlds)
                localctx.attr = self.collect(ArgchainRule(self._solver, nt).combine_cons, nt, head_nt.typ_var, localctx.tail.attr.cators)
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.nt = None
            self.worlds = None
            self._expr = None # ExprContext
            self._typ = None # TypContext
            self.nt = nt

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




    def target(self, nt:Context):

        localctx = SlimParser.TargetContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 30, self.RULE_target)
        try:
            self.state = 394
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [20]:
                self.enterOuterAlt(localctx, 1)

                pass
            elif token in [2]:
                self.enterOuterAlt(localctx, 2)
                self.state = 382
                self.match(SlimParser.T__1)

                expr_nt = self.guide_nonterm(lambda: nt)

                self.state = 384
                localctx._expr = self.expr(expr_nt)

                localctx.worlds = localctx._expr.worlds
                self.update_sr('target', [t('='), n('expr')])

                pass
            elif token in [7]:
                self.enterOuterAlt(localctx, 3)
                self.state = 387
                self.match(SlimParser.T__6)
                self.state = 388
                localctx._typ = self.typ()
                self.state = 389
                self.match(SlimParser.T__1)

                expr_nt = self.guide_nonterm(lambda: nt)

                self.state = 391
                localctx._expr = self.expr(expr_nt)

                nt = replace(nt, worlds = localctx._expr.worlds)
                localctx.worlds = self.collect(TargetRule(self._solver).combine_anno, nt, localctx._typ.combo) 
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
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




    def pattern(self, nt:Context):

        localctx = SlimParser.PatternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 32, self.RULE_pattern)
        try:
            self.state = 408
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,16,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 397
                localctx._base_pattern = self.base_pattern(nt)

                localctx.attr = localctx._base_pattern.attr
                self.update_sr('pattern', [n('basepat')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)


                self.state = 401
                localctx.head = self.base_pattern(nt)

                self.guide_symbol(',')

                self.state = 403
                self.match(SlimParser.T__12)


                self.state = 405
                localctx.tail = self.pattern(nt)

                localctx.attr = self.collect(PatternRule(self._solver).combine_tuple, nt, localctx.head.attr, localctx.tail.attr) 
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
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




    def base_pattern(self, nt:Context):

        localctx = SlimParser.Base_patternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 34, self.RULE_base_pattern)
        try:
            self.state = 430
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,17,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 411
                localctx._ID = self.match(SlimParser.ID)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_var, nt, (None if localctx._ID is None else localctx._ID.text))
                self.update_sr('basepat', [ID])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 413
                self.match(SlimParser.T__4)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_unit, nt)
                self.update_sr('basepat', [t('@')])

                pass

            elif la_ == 4:
                self.enterOuterAlt(localctx, 4)
                self.state = 415
                self.match(SlimParser.T__5)

                self.guide_terminal('ID')

                self.state = 417
                localctx._ID = self.match(SlimParser.ID)


                self.state = 419
                localctx.body = self.base_pattern(nt)

                localctx.attr = self.collect(BasePatternRule(self._solver).combine_tag, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr)
                self.update_sr('basepat', [t('~'), ID, n('basepat')])

                pass

            elif la_ == 5:
                self.enterOuterAlt(localctx, 5)
                self.state = 422
                localctx._record_pattern = self.record_pattern(nt)

                localctx.attr = localctx._record_pattern.attr
                self.update_sr('basepat', [n('recpat')])

                pass

            elif la_ == 6:
                self.enterOuterAlt(localctx, 6)
                self.state = 425
                self.match(SlimParser.T__7)
                self.state = 426
                localctx._pattern = self.pattern(nt)
                self.state = 427
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

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1, nt:Context=None):
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




    def record_pattern(self, nt:Context):

        localctx = SlimParser.Record_patternContext(self, self._ctx, self.state, nt)
        self.enterRule(localctx, 36, self.RULE_record_pattern)
        try:
            self.state = 453
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,18,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)

                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 433
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 435
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 437
                self.match(SlimParser.T__1)


                self.state = 439
                localctx.body = self.pattern(nt)

                localctx.attr = self.collect(RecordPatternRule(self._solver).combine_single, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr)
                self.update_sr('recpat', [t('_.'), ID, t('='), n('pattern')])

                pass

            elif la_ == 3:
                self.enterOuterAlt(localctx, 3)
                self.state = 442
                self.match(SlimParser.T__26)

                self.guide_terminal('ID')

                self.state = 444
                localctx._ID = self.match(SlimParser.ID)

                self.guide_symbol('=')

                self.state = 446
                self.match(SlimParser.T__1)


                self.state = 448
                localctx.body = self.pattern(nt)


                self.state = 450
                localctx.tail = self.record_pattern(nt)

                localctx.attr = self.collect(RecordPatternRule(self._solver, nt).combine_cons, nt, (None if localctx._ID is None else localctx._ID.text), localctx.body.attr, localctx.tail.attr)
                self.update_sr('recpat', [t('_.'), ID, t('='), n('pattern'), n('recpat')])

                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





