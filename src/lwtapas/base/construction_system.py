from __future__ import annotations

from dataclasses import dataclass

import inflection

@dataclass(frozen=True, eq=True)
class Field:
    attr : str
    typ : str
    default : str

@dataclass(frozen=True, eq=True)
class Constructor:
    name: str 
    bases : list[str]
    fields: list[Field]


nl = "\n"
header = ("""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, TypeVar, Any, Generic, Union, Optional
from collections.abc import Callable

from abc import ABC, abstractmethod

T = TypeVar('T')


@dataclass(frozen=True, eq=True)
class SourceFlag: 
    pass
""")

def generate_single(
    constructor : Constructor 
) -> str:

    bases_str = (
        '(' + ', '.join([
            base
            for  base in constructor.bases
        ]) + ')'
        if len(constructor.bases) > 0 else
        ""
    )

    code = (f"""
# type and constructor {constructor.name}
@dataclass(frozen=True, eq=True)
class {constructor.name}{bases_str}:
{nl.join([
    f"    {field.attr} : {field.typ}"
    for field in constructor.fields 
]) if len(constructor.fields) > 0 else "    pass"}


def make_{constructor.name}({",".join([f'''
    {field.attr} : {field.typ}''' + (f" = {field.default}" if field.default else "")
    for field in constructor.fields
])}
) -> {constructor.name}:
    return {constructor.name}({",".join([f'''
        {field.attr}'''
        for field in constructor.fields
    ])})

def update_{constructor.name}(source_{constructor.name} : {constructor.name}{''.join([
    f",{nl}    {field.attr} : Union[{field.typ}, SourceFlag] = SourceFlag()"
    for field in constructor.fields
])}
) -> {constructor.name}:
    return {constructor.name}({f", ".join([f'''
        source_{constructor.name}.{field.attr} if isinstance({field.attr}, SourceFlag) else {field.attr}'''
        for field in constructor.fields
    ])})

    """)
    return code 





def generate_choice(
    type_name : str,
    type_base : str,
    constructors : list[Constructor] 
) -> str:
    handler_name = f"{inflection.camelize(type_name)}Handler"


    def generate_constructor(constructor : Constructor) -> str:
        nonlocal handler_name
        bases_str = ''.join([
            f', {base}'
            for  base in constructor.bases
        ])
        return (f"""
@dataclass(frozen=True, eq=True)
class {constructor.name}({type_name}{bases_str}):
{nl.join([
    f"    {field.attr} : {field.typ}"
    for field in constructor.fields
])}

    def match(self, handler : {handler_name}[T]) -> T:
        return handler.case_{constructor.name}(self)

def make_{constructor.name}({", ".join([f'''
    {field.attr} : {field.typ}''' + (f" = {field.default}" if field.default else "")
    for field in constructor.fields
])}
) -> {type_name}:
    return {constructor.name}({",".join([f'''
        {field.attr}'''
        for field in constructor.fields
    ])}
    )

def update_{constructor.name}(source_{constructor.name} : {constructor.name}{''.join([
    f",{nl}    {field.attr} : Union[{field.typ}, SourceFlag] = SourceFlag()"
    for field in constructor.fields
])}
) -> {constructor.name}:
    return {constructor.name}({f",".join([f'''
        source_{constructor.name}.{field.attr} if isinstance({field.attr}, SourceFlag) else {field.attr}'''
        for field in constructor.fields
    ])}
    )

        """)

    code = (f"""
# type {type_name}
@dataclass(frozen=True, eq=True)
class {type_name}({type_base + ', ' if type_base else ''}ABC):
    @abstractmethod
    def match(self, handler : {handler_name}[T]) -> T:
        pass

# constructors for type {type_name}
{nl.join([
    generate_constructor(constructor)
    for constructor in constructors
])}

# case handler for type {type_name}
class {handler_name}(ABC, Generic[T]):
{nl.join([
    f"    @abstractmethod" + nl +
    f"    def case_{constructor.name}(self, o : {constructor.name}) -> T :" + nl +
    f"        pass"
    for constructor in constructors 
])}

    """)
    return code 

def generate_content(content_header : str, singles : list[Constructor], choices : dict[str, list[Constructor]]) -> str:

    return (f"""

{header}

{content_header}

{nl.join([
    generate_choice(type_name, '', cons)
    for type_name, cons in choices.items()
])} 

{nl.join([
    generate_single(con)
    for con in singles
])} 
    """)

def generate_choices_type_base(choices : dict[tuple[str, str], list[Constructor]]) -> str:
    return (f"""
{nl.join([
    generate_choice(type_name, type_base, cons)
    for (type_name, type_base), cons in choices.items()
])} 
    """)