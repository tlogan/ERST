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

solver = analyzer.Solver(m()) 

def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 

def decode_annotations(worlds, placeholders : list[str]) -> PMap[str, analyzer.Typ]:
    return pmap({
        ph : analyzer.simplify_typ(solver.decode_with_polarity(True, worlds, analyzer.TVar(ph))) 
        for ph in placeholders
    })

def extract_annotation_ids(prog : str) -> list[str]:
    regex = re.compile(r'let \S+ : T([0-9]+) =')
    matches = regex.findall(prog)
    return matches


def make_input_seq(code : str, ids : list[str]) -> str:
    result = code 
    for i in ids:
        result = result.replace(f"T{i}", f"<extra_id_{i}>")
    return result

def make_output_seq(
    rev_aliasing : PMap[analyzer.Typ, str], 
    anno_map : PMap[str, analyzer.Typ]
) -> str:
    aliasing_seq = analyzer.concretize_reversed_aliasing(rev_aliasing)
    anno_seq = "".join([
        "<" + k.replace("T", "extra_id_") + ">" + u(t)
        for (k,t) in anno_map.items()
    ])
    return aliasing_seq + anno_seq


def to_anno_map_with_rev_aliasing(
        anno_map : PMap[str, analyzer.Typ], 
        rev_aliasing : PMap[analyzer.Typ, str]
) -> tuple[PMap[analyzer.Typ, str], PMap[str, analyzer.Typ]]:  
    # returns (rev_aliasing, new_anno_map)
    new_anno_map = m()
    for id, t in anno_map.items():
        (rev_aliasing, new_typ) = solver.to_aliasing_typ(t, rev_aliasing)
        new_anno_map = new_anno_map.set(id, new_typ)
    return (rev_aliasing, new_anno_map)
    

def generate_example(prog : str) -> dict[str, str]: 
    ids = extract_annotation_ids(prog)
    input_seq = make_input_seq(prog, ids)

    (worlds, t, _) = analyze(prog)


    raw_anno_map = decode_annotations(worlds, [f"T{i}" for i in ids])
    # (rev_aliasing, anno_map) = to_anno_map_with_rev_aliasing(raw_anno_map, solver.reversed_aliasing) 
    # output_seq = make_output_seq(rev_aliasing, anno_map)
    rev_aliasing : PMap[analyzer.Typ, str] = pmap()
    print(f"""
    ~~~~~~~~~~~~~~~~~
    DEBUG raw_anno_map: {raw_anno_map}
    result type: {analyzer.concretize_typ((analyzer.simplify_typ(solver.decode_with_polarity(True, worlds, t))))}
    ~~~~~~~~~~~~~~~~~
    """)
    output_seq = make_output_seq(rev_aliasing, raw_anno_map)


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

