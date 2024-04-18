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

solver = analyzer.Solver() 

def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 

def decode_annotations(worlds, placeholders : list[str]) -> dict[str, str]:
    return {
        ph : u(analyzer.simplify_typ(solver.decode_with_polarity(True, worlds, analyzer.TVar(ph)))) 
        for ph in placeholders
    }

def extract_annotation_ids(prog : str) -> list[str]:
    regex = re.compile(r'let \S+ : T([0-9]+) =')
    matches = regex.findall(prog)
    return matches


def make_input_seq(code : str, ids : list[str]) -> str:
    result = code 
    for i in ids:
        result = result.replace(f"T{i}", f"<extra_id_{i}>")
    return result

def make_output_seq(anno_map : dict[str, str]) -> str:
    return "".join([
        "<" + k.replace("T", "extra_id_") + ">" + v 
        for (k,v) in anno_map.items()
    ])


def generate_example(prog : str) -> dict[str, str]: 
    ids = extract_annotation_ids(prog)
    input_seq = make_input_seq(prog, ids)

    worlds = analyze(prog)[0]
    anno_map = decode_annotations(worlds, [f"T{i}" for i in ids])
    output_seq = make_output_seq(anno_map)
    return {'input' : input_seq, 'output' : output_seq}

def generate_examples(programs : list[str]) -> list[dict[str, str]]: 
    return [
        generate_example(prog)
        for prog in programs
    ]


def reconstitute_annotations(input_seq : str, output_seq : str) -> str:
    mask_pattern = r"<extra_id_[0-9]+>"
    keys = re.findall(mask_pattern, output_seq)
    values = [
        v
        for v in re.split(mask_pattern, output_seq)
        if bool(v)
    ]

    result = input_seq 
    for idx, key in enumerate(keys):
        v = values[idx]
        result = result.replace(f"{key}", v)
    return result

