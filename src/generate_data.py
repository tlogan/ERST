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


def write_init_data():
    write(project_path("res"), "init_program_grammar_examples.txt", "\n".join(init_program_examples))

    json_init_program_examples = [
        from_program_exform_to_json(ex)
        for ex in init_program_examples
    ]

    write(project_path("res"), "init_program_grammar_examples.jsonl", "\n".join(json_init_program_examples))

    init_programs = [
        json.loads(ex)['program']
        for ex in json_init_program_examples
    ]
    init_annotation_examples = [
        make_annotation_example(program)
        for program in init_programs
    ]

    write(project_path("res"), "init_program_typing_examples.jsonl", "\n".join(init_annotation_examples))
    write(project_path("res"), "init_program_typing_examples.txt", "\n".join([
        prettify_annotation_example(ex)
        for ex in init_annotation_examples 
    ]))

# def write_generated_data():
#     generated_examples = generate_program_examples(70)
#     write(project_path("res"), "generated_program_examples.jsonl", "\n".join(generated_examples))
#     write(project_path("res"), "pretty_generated_program_examples.txt", "\n".join([
#         prettify_program_example(ex)
#         for ex in generated_examples
#     ]))

#############
write_init_data()
# write_generated_data()
#############

