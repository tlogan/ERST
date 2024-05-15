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