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
from tapas.slim.language import analyze, infer_typ, parse_typ, solve_subtyping

from tapas.slim import exprlib as el, typlib as tl
from tapas.slim.exprlib import ctx 

def test_induction_nat_is_even():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> R)
    """, f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """
    )
    assert not bool(worlds)


def test_union_is_not_zero():
    worlds = solve_subtyping(f"""
(<zero> @) | (<succ> <zero> @)
    """, f"""
TOP \\ (<zero> @)
    """
    )
    assert not bool(worlds)

def test_induction_even_is_not_zero():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> <succ> R)
    """, f"""
TOP \\ (<zero> @)
    """
    )
    assert not bool(worlds)

def test_induction_nat_is_not_one():
    worlds = solve_subtyping(f"""
LFP [R] (<zero> @) | (<succ> R)
    """, f"""
TOP \\ (<succ> <zero> @)
    """
    )
    assert not bool(worlds)


###############################################################
###############################################################

if __name__ == '__main__':
    pass
    ##########################


#######################################################################
