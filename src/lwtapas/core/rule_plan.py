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
                "Keyword", [], [
                    Field('content', 'str', "")
                ]
            ),

            Constructor(
                "Terminal", [], [
                    Field('relation', 'str', ""),
                    Field('vocab', 'str', ""),
                ]
            ),

            Constructor(
                "Nonterm", [], [
                    Field('relation', 'str', ""),
                    Field('tag', 'str', ""),
                    Field('format', 'LineFormat', ""),
                ]
            ),

        ]
    }
)





