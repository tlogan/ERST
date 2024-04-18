from __future__ import annotations
from openai import OpenAI
from dataclasses import dataclass
from typing import *
from tapas.slim.analyzer import * 
from tapas.slim.language import * 
from tapas.slim.datagenerator import * 
import json


def test_generate_example():
    code = (f'''
let x : ~uno B = ~uno @ ;
let ident : T0 = (case x => x) ;
let add : T1 = fix (case self => ( 
    case (~zero @, b) => b 
    case (~succ a, b) => ~succ (self(a, b))
)) ;
@
    ''')

    example = generate_example(code)
    input = example['input']
    output = example['output']
    reconstitute_annotations(input, output)

    # json: {json.dumps(example)}
    # print(f"""
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # generate example 
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # input: {input}

    # output: {output}
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # """)


if __name__ == '__main__':
    test_generate_example()