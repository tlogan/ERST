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
(FX N | ~zero @  | ~succ N )
""".strip())

even = (f"""
(FX E | ~zero @ | ~succ ~succ E)
""".strip())

nat_list = (f"""
(FX NL 
    | (~zero @, ~nil @) 
    | (ANY [N L ; (N, L) <: NL] (~succ N, ~cons L))
)
""".strip())

even_list = (f"""
(FX NL 
    | (~zero @, ~nil @) 
    | ANY [N L ; (N, L) <: NL] (~succ ~succ N, ~cons ~cons L)  
)
""".strip())



nat_equal = (f"""
(FX SELF 
    | (~zero @, ~zero @) 
    | ANY [A B ; (A, B) <: SELF] (~succ A, ~succ B)  
)
""".strip())

addition = (f'''
FX AR 
    | (ANY [Y Z ; (Y, Z) <: ({nat_equal})] (x : ~zero @ & y : Y & z : Z))
    | (ANY [X Y Z ; (x : X & y : Y & z : Z) <: AR] (x : ~succ X & y : Y & z : ~succ Z))
''')

lte = (f"""
(FX SELF 
    | (ANY [x ; x <: ({nat})] (~zero @, x))
    | (ANY [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")

open_lte = (f"""
(FX SELF 
    | (ANY [x] (~zero @, x))
    | (ANY [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")


lted = (f"""
(FX self 
    | (ANY [x ; x <: ({nat})] ((~zero @, x), ~true @))
    | (ANY [a b c ; ((a,b),c) <: self] ((~succ a, ~succ b), c))
    | (ANY [x ; x <: ({nat})] ((~succ x, ~zero @), ~false @))
)
""")

nat_pair = (f"""
(FX self 
    | (ANY [n ; n <: ({nat})] (~zero @, n))
    | (ANY [m n ; (m,n) <: self] (~succ m, ~succ n))
    | (ANY [m ; m <: ({nat})] (~succ m, ~zero @))
)
""")

lted_imp = (f'''
(ALL [XY ; XY <: ({nat_pair})] (XY -> 
    (ANY [Z ; (XY, Z) <: ({lted})] Z)
))) 
''')


# (x : ~zero @ & y : Y & z : Z)
lted_xyz = (f"""
(FX SELF 
    | (ANY [Y ; Y <: ({nat})] (x : ~zero @ & y : Y & z : ~true @))
    | (ANY [X Y Z ; (x : X & y : Y & z : Z) <: SELF] (x : ~succ X & y : ~succ Y & z : Z))
    | (ANY [X ; X <: ({nat})] (x : ~succ X & y : ~zero @ & z : ~false @))
)
""")



open_nat_pair = (f"""
(FX SELF 
    | (ANY [N] (~zero @, N))
    | (ANY [N M ; (M, N) <: SELF ] (~succ M, ~succ N)) 
    | (ANY [M] (~succ M, ~zero @))
)
""")

open_lted = (f"""
(FX SELF 
    | (ANY [N] ((~zero @, N), ~true @)) 
    | (ANY [N D M ; ((M, N), D) <: SELF ] ((~succ M, ~succ N), D))
    | (ANY [M] ((~succ M, ~zero @), ~false @))
)
""")

# NOTE: max, un-simplified
max = (f"""
(ALL [G44 G45] 
    ((ALL [M N
        ; G44 <: ~true @
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
    ] (ANY [O ; ((M, N), O) <: {open_lted} ; O <: G44](M, N) -> N)) & 

    (ALL [M N
        ; G44 <: ~false @
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
    ] (ANY [O ; ((M, N), O) <: {open_lted} ; O <: G44 ] (M, N) -> M)))
)
""")

# # NOTE: without the antecedent constraint
# max = (f"""
# (ALL [G44 G45] 
#     ((ALL [M N
#         ; G44 <: ~true @
#     ] (ANY [O ; ((M, N), O) <: {open_lted} ; O <: G44](M, N) -> N)) & 

#     (ALL [M N
#         ; G44 <: ~false @
#     ] (ANY [O ; ((M, N), O) <: {open_lted} ; O <: G44 ] (M, N) -> M)))
# )
# """)
