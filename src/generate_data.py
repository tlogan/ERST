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
    generated_examples = generate_program_grammar_examples(init_program_examples, 200)
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

