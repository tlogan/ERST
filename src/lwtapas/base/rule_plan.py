from __future__ import annotations

from base.construction_system import Constructor, Field

singles = [
    Constructor(
        "Rule", [], [
            Field('name', 'str', ""), 
            Field('content', 'list[Item]', "")
        ]
    )
]

choices = { 
    "Item" : [
        Constructor(
            "Terminal", [], [
                Field('terminal', 'str', "")
            ]
        ),

        Constructor(
            "Nonterm", [], [
                Field('relation', 'str', ""),
                Field('nonterminal', 'str', ""),
                Field('format', 'LineFormat', ""),
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





