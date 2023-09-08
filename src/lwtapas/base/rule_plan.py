from __future__ import annotations

from lwtapas.base.construction_system import Constructor, Field
from lwtapas.base import construction_system
from lwtapas.base.schema_system import Schema 

singles = [
    Constructor(
        "Rule", [], [
            Field('name', 'str', ""), 
            Field('content', 'list[item]', "")
        ]
    )
]

choices = { 
    "item" : [
        Constructor(
            "Terminal", [], [
                Field('terminal', 'str', "")
            ]
        ),

        Constructor(
            "Nonterm", [], [
                Field('relation', 'str', ""),
                Field('nonterminal', 'str', ""),
                Field('format', 'line_format', ""),
            ]
        ),

        Constructor(
            "Vocab", [], [
                Field('relation', 'str', ""),
                Field('vocab', 'str', ""),
            ]
        )
    ]
}





