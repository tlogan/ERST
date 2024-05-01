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


def from_pge_to_json(exform : str) -> str:
    remainder = exform
    description = ""
    grammar = ""
    program = ""
    splits = remainder.split("<<<description>>>")
    remainder = splits[1] 
    splits = remainder.split("<<<grammar>>>")
    description = splits[0].strip()
    remainder = splits[1]
    splits = remainder.split("<<<program>>>")
    grammar = splits[0].strip()
    program = splits[1].strip()
    return json.dumps({
        'description' : description,
        'grammar' : grammar,
        'program' : program
    })

    

example_delim = "**********************************************"

def make_program_example(description : str, code : str) -> str:
    g = language.refine_grammar(code)
    return (f""" 
{example_delim}
<<<description>>> 
{description.strip()}

<<<grammar>>>
{analyzer.concretize_grammar(g)}

<<<program>>>
{code.strip()}
    """).strip()






client = OpenAI()

def generate_program_example(examples):
    messages : Iterable =[
        {"role": "system", "content": '''
You are a functional programming assistant, skilled in conjuring up 
archetypal and classic functional programming concepts.
You are generating data about functional programs where each datum is 
consists of three kinds of information: 'description', 'grammar', and 'program'. 
The format looks like:
```

<<<description>>>
$description_goes_here     

<<<grammar>>>
$description_goes_here

<<<program>>>
$program_goes_here

```
         
The program adheres to the behavior described by the description (English).
The program is constructed according to the rules of the grammar (EBNF). 
The programs should consist of multiple functions that operate over trees, lists and natural numbers.
Make sure that you define all helper functions that you use.
        '''}
    ]

    if len(examples) > 0:
        max_context = 20 
        if len(examples) > max_context:
            examples = random.sample(examples, max_context)
        for example in examples:
            messages.append({
                "role": "assistant",
                "content": example
            })

    # response = openai.ChatCompletion.create(
    completion = client.chat.completions.create(
        # model="gpt-3.5-turbo",
        model="gpt-4-turbo",
        messages=messages,
        temperature=0.5,
        # frequency_penalty=1.0,
        # presence_penalty=1.0,
        # response_format={ "type": "json_object" },
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


    suml : Callable[[str], str] = (lambda add : (f"""
fix (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => self(xs, ({add})(b, x))
))
    """).strip())

    sumr : Callable[[str], str] = (lambda add : (f"""
fix (case self => ( 
    case (~nil @, b) => b
    case (~cons (x, xs), b) => ({add})((self)(xs, b), x)
))
    """).strip())

    fib : Callable[[str], str] = (lambda add : (f"""
fix (case self => ( 
    case (~zero @) => ~zero @
    case (~succ ~zero @) => ~succ ~zero @
    case (~succ ~succ n) => ({add})((self)(~succ n), (self)(n))
))
    """).strip())

    fact : Callable[[str], str] = (lambda mul : (f"""
fix (case self => ( 
    case (~zero @) => ~succ ~zero @
    case (~succ n) => ({mul})((self)(n), ~succ n)
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
(case (b, l) => (
    (if b then
        (({length})(l), l)
    else
        ({length})(l)
    )
))
    """).strip())


    #TODO: divide, split, merge, sort, reverse, append/concat

# end FunLib
    
lib = Lib()

def generate_program_grammar_examples(init_program_examples, num_examples):
    new_examples = []
    for i in range(num_examples):
        print(f'Generating GPT example {i}')
        example = generate_program_example(new_examples + init_program_examples.copy())
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
    


def make_mask_constraints(ids : list[str]) -> str:
    return "\n".join([
        f"; T{i} <: <extra_id_{i}>"
        for i in ids
    ])

def make_masked_string(code : str, ids : list[str]) -> str:
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

def make_program_typing_example(prog : str) -> str: 
    (worlds, t, _, solver) = analyze(prog)

    ids = extract_annotation_ids(prog)

    masked_prog = make_masked_string(prog, ids)

    light_constraints = analyze_light(prog)
    context = concretize_constraints(light_constraints) + "\n" + make_mask_constraints(ids)

    anno_map = decode_annotations(solver, worlds, [f"T{i}" for i in ids])
    annotations = make_masked_annotations(anno_map)

    return json.dumps({
        'program' : masked_prog, 
        'context' : context, 
        'annotations' : annotations
    })

def prettify_program_typing_example(example) -> str:
    sample = json.loads(example) 
    return (f"""
<<<<<<<<
*** program ***
{sample['program']}

*** context ***
{sample['context']}

*** annotations ***
{sample['annotations']}
>>>>>>>>
    """)

def make_annotation_examples(programs : list[str]) -> list[str]: 
    return [
        make_program_typing_example(prog)
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

