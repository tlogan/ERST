from __future__ import annotations

from core.construction_system import Construction, Constructor, Field

construction = Construction(
    [
        Constructor(
            "Rule", [], [
                Field('name', 'str', ""), 
                Field('content', 'list[Item]', "")
            ]
        )
    ],
    { 
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
)





