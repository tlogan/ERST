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
                Field('key', 'str', ""),
                Field('pattern', "Pattern", ""),
            ]
        )
    ],
    { 
        "Pattern" : [
            Constructor(
                "Terminal", [], [
                    Field('regex', 'str', "")
                ]
            ),

            Constructor(
                "Nonterm", [], [
                    Field('format', 'LineFormat', ""),
                ]
            ),

        ]
    }
)





