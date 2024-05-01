from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 
from tapas.slim.datamunger import * 
import random
from tapas.util_system import *
import json

def make_init_program_examples(): 
    return [
    make_program_example(f"""
A program that defines some basic values.
    """, f"""
let unit : T0 = @ in
let true : T1 = ~true @ in
let false : T2 = ~false @ in
let zero : T3 = ~zero @ in
let one : T4 = ~succ ~zero @ in
let two : T5 = ~succ ~succ ~zero @ in
@
    """),

    make_program_example(f"""
A program that defines a function that takes a list and returns its length.
    """, f"""
let length : T0 = {lib.length} in
@
    """),

    # NOTE: this demonstrates extrinsic typing and type reconstruction using expansion
    make_program_example(f"""
A program that defines a function that takes a boolean and a list and returns its length or the list paired with its length.
    """, f"""
let length : T0 = {lib.length} in
let maybe_with_length : T1 = {lib.expander('length')} in
@
    """),

    # NOTE: this demonstrates extrinsic typing and type reconstruction using refinement 
    make_program_example(f"""
A program that defines construction of a pair by calling two different functions on the same input.
    """, f"""
let f : T0 = (case (;uno = x) => x) in
let g : T1 = (case (;dos = x) => x) in
let make_pair : T2 = {lib.refiner('f', 'g')} in
@
    """),


    make_program_example(f"""
A program that defines addition.
    """, f"""
let add : T0 = {lib.add} in
@
    """),

    make_program_example(f"""
A program that defines less-than-or-equal of two numbers and maximum of two numbers.
    """, f"""
let lte : T0 = {lib.lte} in
let max : T1 = {lib.max('lte')} in
@
    """),

    make_program_example(f"""
A program that defines addition and multiplication.
    """, f"""
let add : T0 = {lib.add} in
let plus : T1 = add in
let mult : T2 = {lib.mult('add')} in
let times : T3 = {lib.mult('plus')} in
@
    """),

    make_program_example(f"""
A program that defines addition, summation from left, and summation from right.
    """, f"""
let add : T0 = {lib.add} in
let suml : T1 = {lib.suml('add')} in
let sumr : T2 = {lib.sumr('add')} in
@
    """),

    make_program_example(f"""
a program that defines the fibonacci sequence.
    """, f"""
let add : T0 = {lib.add} in
let fib : T1 = {lib.fib('add')} in
@
    """),

    make_program_example(f"""
a program that defines the factorial.
    """, f"""
let add : T0 = {lib.add} in
let mult : T1 = {lib.mult('add')} in
let fact : T2 = {lib.fact('mult')} in
@
    """),

    ]





def write_init_data():
    init_program_examples = make_init_program_examples()
    write(project_path("res"), "init_program_grammar_examples.txt", "\n".join(init_program_examples))

    json_init_program_grammar_examples = [
        from_pge_to_json(ex)
        for ex in init_program_examples
    ]

    write(project_path("res"), "init_program_grammar_examples.jsonl", "\n".join(json_init_program_grammar_examples))

    init_programs = [
        json.loads(ex)['program']
        for ex in json_init_program_grammar_examples
    ]
    init_program_typing_examples = [
        make_program_typing_example(program)
        for program in init_programs
    ]

    write(project_path("res"), "init_program_typing_examples.jsonl", "\n".join(init_program_typing_examples))
    write(project_path("res"), "init_program_typing_examples.txt", "\n".join([
        prettify_program_typing_example(ex)
        for ex in init_program_typing_examples 
    ]))

def write_generated_pge_data():
    init_program_examples = make_init_program_examples()
    generated_examples = generate_program_grammar_examples(init_program_examples, 30)
    write(project_path("res"), "generated_program_grammar_examples.txt", "\n".join(generated_examples))
    json_examples = [
        from_pge_to_json(ex)
        for ex in generated_examples
    ]
    write(project_path("res"), "generated_program_grammar_examples.jsonl", "\n".join(json_examples))



def parse_jsonl_file(fpath : str) -> list:
    result = []
    with open(fpath, 'r') as f:
        line = f.readline()
        while line: 
            line_obj = json.loads(line)
            result.append(line_obj)
            line = f.readline()
    return result

def read_pge_write_pte_data(fname):
    fpath = project_path("res") + "/" + fname 
    programs = [
        ex['program']
        for ex in parse_jsonl_file(fpath)
    ]


    def try_make(program):
        try:
            return make_program_typing_example(program)
        except:
            return None

    program_typing_examples = [
        result
        for program in programs
        for result in [try_make(program)]
        if result
    ]
    print(f"""
~~~~~~~~~~~~~~~~~~~~~~~~~~
DEBUG: program_typing_examples 
~~~~~~~~~~~~~~~~~~~~~~~~~~
len(program_typing_examples): {len(program_typing_examples)} 
~~~~~~~~~~~~~~~~~~~~~~~~~~
    """)

    write(project_path("res"), "generated_program_typing_examples.jsonl", "\n".join(program_typing_examples))
    write(project_path("res"), "generated_program_typing_examples.txt", "\n".join([
        prettify_program_typing_example(ex)
        for ex in program_typing_examples 
    ]))

def read_split_write(fname):
    fpath = project_path("res") + "/" + fname 
    examples = parse_jsonl_file(fpath)
    random.shuffle(examples)
    split_index = int(len(examples) * .7)
    training_examples = [json.dumps(ex) for ex in examples[:split_index]]
    testing_examples = [json.dumps(ex) for ex in examples[split_index:]]
    write(project_path("res"), "training_"+fname, "\n".join(training_examples))
    write(project_path("res"), "testing_"+fname, "\n".join(testing_examples))










#############
# write_init_data()
# write_generated_pge_data()
# read_pge_write_pte_data("generated_program_grammar_examples.jsonl")
read_split_write("generated_program_typing_examples.jsonl")
#############

