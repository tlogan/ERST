from __future__ import annotations

from core.construction_system import Construction, Constructor, Field

construction = Construction(
    '''
from core.line_format_autogen import LineFormat 
    ''',
    [
        Constructor(
            "Rule", [], [
                Field('name', 'str', ""), 
                Field('content', 'list[Item]', "")
            ]
        ),
        Constructor(
            "Item", [], [
                Field('relation', 'str', ""),
                Field('pattern', "Pattern", ""),
            ]
        )
    ],
    { 
        "Pattern" : [
            Constructor(
                "Terminal", [], [
                    Field('vocab', 'str', ""),
                ]
            ),

            Constructor(
                "Nonterm", [], [
                    Field('grammar', 'str', ""),
                    Field('format', 'LineFormat', ""),
                ]
            ),

        ]
    }
)





