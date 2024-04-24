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




def make_program_example(description : str, code : str) -> str:
    g = language.refine_grammar(code)
    return json.dumps({
        'description' : description.strip(),
        'grammar' : analyzer.concretize_grammar(g),
        'program' : code.strip(),
    })


def prettify_program_example(example) -> str:
    sample = json.loads(example) 
    return (f"""
<<<<<<<<
*** description ***
{sample['description']}

*** grammar ***
{sample['grammar']}

*** program ***
{sample['program']}
>>>>>>>>
    """)




client = OpenAI()

def generate_gpt_example(examples, temperature=.5):
    messages : Iterable =[
        {"role": "system", "content": '''
You are a functional programming assistant, skilled in conjuring up 
archetypal and classic functional programming concepts.
You are generating data about functional programs where each datum is 
a json object with three fields: 'description', 'grammar', and 'program'. 
The program adheres to the behavior described by the description (English).
The program is constructed according to the rules of the grammar (EBNF). 
Do not assume a helper function exists unless you define it.
        '''}
    ]

    if len(examples) > 0:
        if len(examples) > 10:
            prev_examples = random.sample(examples, 10)
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
    return completion.choices[0].message.content

@dataclass(frozen=True, eq=True)
class Lib: 
    length = (f"""
fix(case self => (
    case ~nil @ => ~zero @ 
    case ~cons (x, xs) => ~succ (self(xs)) 
)) 
    """.strip())
    add = (f"""
fix (case self => ( 
    case (~zero @, n) => n 
    case (~succ m, n) => ~succ (self(m, n))
))
    """.strip())
    mult : Callable[[str], str] = (lambda add : (f"""
fix (case self => ( 
    case (~zero @, n) => ~zero 
    case (~succ m, n) => ({add})(n, (self)(m, n))
))
    """).strip())
    lte = (f"""
fix(case self => (
    case (~zero @, n) => ~true @ 
    case (~succ m, ~succ n) => self(m,n) 
    case (~succ m, ~zero @) => ~false @ 
))
    """.strip())
    max : Callable[[str], str] = (lambda lte : (f"""
case (x, y) => (
    if ({lte})(x, y) then
        y
    else
        x
)
    """).strip())

    # NOTE: an example demonstrating refinement abilities
    refiner : Callable[[str, str], str] = (lambda f, g : (f"""
case x => (
    (({f})(x), ({g})(x))
)
    """).strip())

    # NOTE: an example demonstrating expansion abilities
    expander : Callable[[str], str] = (lambda length : (f"""
case (b, l)  => (
    if b then
        (l, ({length})(l)
    else
        l
)
    """).strip())

# end FunLib
    
lib = Lib()

init_program_examples = [

    make_program_example(f"""
A program that defines some basic values.
    """, f"""
let unit : T0 = @ ;
let true : T1 = ~true @ ;
let false : T2 = ~false @ ;
let zero : T3 = ~zero @ ;
let one : T4 = ~succ ~zero @ ;
let two : T5 = ~succ ~succ ~zero @ ;
@
    """),

    make_program_example(f"""
A program that defines a function that takes a list and returns its length.
    """, f"""
let length : T0 = {lib.length} ;
@
    """),

    make_program_example(f"""
A program that defines addition.
    """, f"""
let add : T0 = {lib.add} ;
@
    """),

#     make_program_example(f"""
# A program that defines less-than-or-equal of two numbers and maximum of two numbers.
#     """, f"""
# let lte : T0 = {lib.lte} ;
# let max : T1 = {lib.max('lte')} ;
# @
#     """),

#     make_program_example(f"""
# A program that defines addition and multiplication.
#     """, f"""
# let add : T0 = {lib.add} ;
# let plus : T1 = add ;
# let mult : T2 = {lib.mult('add')} ;
# let times : T3 = {lib.mult('plus')} ;
# @
#     """),


#     # NOTE: this demonstrates extrinsic typing and type reconstruction using refinement 
#     make_program_example(f"""
# A program that defines construction of a pair by calling two different functions on the same input.
#     """, f"""
# let f : T0 = (case (_.uno = x) => x)
# let g : T1 = (case (_.dos = x) => x)
# let make_pair : T2 = {lib.refiner('f', 'g')} ;
# let max : T1 = {lib.max('lte')} ;
# @
#     """),

#     # NOTE: this demonstrates extrinsic typing and type reconstruction using expansion
#     make_program_example(f"""
# A program that defines a function that takes a boolean and a list and returns its length or the list paired with its length.
#     """, f"""
# let length : T0 = {lib.length} ;
# let maybe_with_length : T1 = {lib.expander('length')} ;
# @
#     """),

]

def generate_program_examples(num_examples = 10, temperature=.5):
    new_examples = []
    for i in range(num_examples):
        print(f'Generating GPT example {i}')
        example = generate_gpt_example(new_examples + init_program_examples.copy(), temperature)
        if example:
            new_examples.append(example)
    return new_examples




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




# def to_anno_map_with_rev_aliasing(
#     solver : analyzer.Solver,
#     anno_map : PMap[str, analyzer.Typ], 
#     rev_aliasing : PMap[analyzer.Typ, str]
# ) -> tuple[PMap[analyzer.Typ, str], PMap[str, analyzer.Typ]]:  
#     # returns (rev_aliasing, new_anno_map)
#     new_anno_map = m()
#     for id, t in anno_map.items():
#         (rev_aliasing, new_typ) = solver.to_aliasing_typ(t, rev_aliasing)
#         new_anno_map = new_anno_map.set(id, new_typ)
#     return (rev_aliasing, new_anno_map)
    

def make_masked_program(code : str, ids : list[str]) -> str:
    result = code 
    for i in ids:
        result = result.replace(f"T{i}", f"<extra_id_{i}>")
    return result

def make_masked_annotations(
    anno_map : PMap[str, analyzer.Typ]
) -> str:
    return "".join([
        "<" + k.replace("T", "extra_id_") + "> " + u(t) + "\n"
        for (k,t) in anno_map.items()
    ])

def make_annotation_example(prog : str) -> str: 
    # TODO: modify to include serialized worlds as context in input
    (worlds, t, _, solver) = analyze(prog)
    context = "<<TODO>>"
    ids = extract_annotation_ids(prog)
    masked_prog = make_masked_program(prog, ids)

    anno_map = decode_annotations(solver, worlds, [f"T{i}" for i in ids])
    annotations = make_masked_annotations(anno_map)

    # TODO: remove old aliasing code
    # raw_anno_map = decode_annotations(solver, worlds, [f"T{i}" for i in ids])
    # (rev_aliasing, anno_map) = to_anno_map_with_rev_aliasing(solver, raw_anno_map, solver.reversed_aliasing) 
    # aliasing = analyzer.concretize_reversed_aliasing(rev_aliasing)
    # annotations = make_masked_annotations(anno_map)

    return json.dumps({
        'program' : masked_prog, 
        'context' : context, 
        'annotations' : annotations
    })

def prettify_annotation_example(example) -> str:
    sample = json.loads(example) 
    return (f"""
<<<<<<<<
*** program ***
{sample['program']}

*** context ***
{sample['context']}

*** aliasing ***
{sample['aliasing']}

*** annotations ***
{sample['annotations']}
>>>>>>>>
    """)

def make_annotation_examples(programs : list[str]) -> list[str]: 
    return [
        make_annotation_example(prog)
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

