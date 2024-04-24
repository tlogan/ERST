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




def make_gpt_example(description : str, code : str) -> str:
    g = language.refine_grammar(code)
    return json.dumps({
        'description' : description.strip(),
        'program' : code.strip(),
        'grammar' : analyzer.concretize_grammar(g)
    })




client = OpenAI()

def generate_gpt_example(prev_examples, temperature=.5):
    messages : Iterable =[
        {"role": "system", "content": '''
You are a functional programming assistant, skilled in conjuring up 
simple, complex, quintessential, archetypal, and classic functional programming concepts.
You are generating data about functional programs where each datum is 
a json object with three fields: description, program, and grammar. 
The program adheres to the behavior described by the description.
The program is constructed according to the rules of the grammar. 
Do not assume a helper function exists unless you define it.
        '''}
    ]

    if len(prev_examples) > 0:
        if len(prev_examples) > 10:
            prev_examples = random.sample(prev_examples, 10)
        for example in prev_examples:
            messages.append({
                "role": "assistant",
                "content": example
            })

    # response = openai.ChatCompletion.create(
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        # model="gpt-4",
        messages=messages,
        temperature=temperature,
        response_format={ "type": "json_object" },
        max_tokens=1354,
    )

    # return response.choices[0].message['content']
    print(completion.choices[0].message.content)
    return completion.choices[0].message.content

init_gpt_examples = [
    make_gpt_example('''
A function that takes a list and returns its length
        ''', """
let foo : T1 =
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons (x, xs) => ~succ (self(xs)) 
)) 
;
foo
    """)
]

def generate_gpt_examples(num_examples = 10, temperature=.5):
    prev_examples = init_gpt_examples 
    for i in range(num_examples):
        print(f'Generating GPT example {i}')
        example = generate_gpt_example(prev_examples, temperature)
        if example:
            prev_examples.append(example)
    return prev_examples




def p(s): 
    t = language.parse_typ(s)
    assert t 
    return t 

def u(t): 
    s = analyzer.concretize_typ(t)
    assert s 
    return s 

def decode_annotations(solver : analyzer.Solver, worlds, placeholders : list[str]) -> PMap[str, analyzer.Typ]:
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
    solver : analyzer.Solver,
    anno_map : PMap[str, analyzer.Typ], 
    rev_aliasing : PMap[analyzer.Typ, str]
) -> tuple[PMap[analyzer.Typ, str], PMap[str, analyzer.Typ]]:  
    # returns (rev_aliasing, new_anno_map)
    new_anno_map = m()
    for id, t in anno_map.items():
        (rev_aliasing, new_typ) = solver.to_aliasing_typ(t, rev_aliasing)
        new_anno_map = new_anno_map.set(id, new_typ)
    return (rev_aliasing, new_anno_map)
    

def make_example(prog : str) -> dict[str, str]: 
    # TODO: modify to include serialized worlds as context in input
    (worlds, t, _, solver) = analyze(prog)
    ids = extract_annotation_ids(prog)
    input_seq = make_input_seq(prog, ids)
    raw_anno_map = decode_annotations(solver, worlds, [f"T{i}" for i in ids])
    (rev_aliasing, anno_map) = to_anno_map_with_rev_aliasing(solver, raw_anno_map, solver.reversed_aliasing) 
    output_seq = make_output_seq(rev_aliasing, anno_map)


    return {'input' : input_seq, 'output' : output_seq}

def make_examples(programs : list[str]) -> list[dict[str, str]]: 
    return [
        make_example(prog)
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

