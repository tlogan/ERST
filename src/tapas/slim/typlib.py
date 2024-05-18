from __future__ import annotations

from typing import *
from dataclasses import dataclass

import sys
from antlr4 import *
import sys

import asyncio
from asyncio import Queue

from tapas.slim.SlimLexer import SlimLexer
from tapas.slim.SlimParser import SlimParser
from tapas.slim import analyzer, language

from tapas.util_system import box, unbox

from pyrsistent import m, s, pmap, pset
from pyrsistent.typing import PMap, PSet 

import pytest
from tapas.slim.language import analyze 
import re
import json

from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 
import random
from tapas.util_system import *

nat = (f"""
(LFP N | ~zero @  | ~succ N )
""".strip())

even = (f"""
(LFP E | ~zero @ | ~succ ~succ E)
""".strip())

nat_list = (f"""
(LFP NL 
    | (~zero @, ~nil @) 
    | (EXI [N L ; (N, L) <: NL] (~succ N, ~cons L))
)
""".strip())

even_list = (f"""
(LFP NL 
    | (~zero @, ~nil @) 
    | EXI [N L ; (N, L) <: NL] (~succ ~succ N, ~cons ~cons L)  
)
""".strip())



nat_equal = (f"""
(LFP SELF 
    | (~zero @, ~zero @) 
    | EXI [A B ; (A, B) <: SELF] (~succ A, ~succ B)  
)
""".strip())

addition = (f'''
LFP AR 
    | (EXI [Y Z ; (Y, Z) <: ({nat_equal})] (x : ~zero @ & y : Y & z : Z))
    | (EXI [X Y Z ; (x : X & y : Y & z : Z) <: AR] (x : ~succ X & y : Y & z : ~succ Z))
''')

lte = (f"""
(LFP SELF 
    | (EXI [x ; x <: ({nat})] (~zero @, x))
    | (EXI [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")

open_lte = (f"""
(LFP SELF 
    | (EXI [x] (~zero @, x))
    | (EXI [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")


lted = (f"""
(LFP self 
    | (EXI [x ; x <: ({nat})] ((~zero @, x), ~true @))
    | (EXI [a b c ; ((a,b),c) <: self] ((~succ a, ~succ b), c))
    | (EXI [x ; x <: ({nat})] ((~succ x, ~zero @), ~false @))
)
""")

nat_pair = (f"""
(LFP self 
    | (EXI [n ; n <: ({nat})] (~zero @, n))
    | (EXI [m n ; (m,n) <: self] (~succ m, ~succ n))
    | (EXI [m ; m <: ({nat})] (~succ m, ~zero @))
)
""")

lted_imp = (f'''
(ALL [XY ; XY <: ({nat_pair})] (XY -> 
    (EXI [Z ; (XY, Z) <: ({lted})] Z)
))) 
''')


# (x : ~zero @ & y : Y & z : Z)
lted_xyz = (f"""
(LFP SELF 
    | (EXI [Y ; Y <: ({nat})] (x : ~zero @ & y : Y & z : ~true @))
    | (EXI [X Y Z ; (x : X & y : Y & z : Z) <: SELF] (x : ~succ X & y : ~succ Y & z : Z))
    | (EXI [X ; X <: ({nat})] (x : ~succ X & y : ~zero @ & z : ~false @))
)
""")



open_nat_pair = (f"""
(LFP SELF 
    | (EXI [N] (~zero @, N))
    | (EXI [N M ; (M, N) <: SELF ] (~succ M, ~succ N)) 
    | (EXI [M] (~succ M, ~zero @))
)
""")

open_lted = (f"""
(LFP SELF 
    | (EXI [N] ((~zero @, N), ~true @)) 
    | (EXI [N D M ; ((M, N), D) <: SELF ] ((~succ M, ~succ N), D))
    | (EXI [M] ((~succ M, ~zero @), ~false @))
)
""")

# NOTE: max, un-simplified
max = (f"""
(ALL [G44 G45] 
    ((ALL [M N
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
        ; G44 <: ~true @
    ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44](M, N) -> N)) & 

    (ALL [M N
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
        ; G44 <: ~false @
    ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44 ] (M, N) -> M)))
)
""")