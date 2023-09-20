from __future__ import annotations

from core.construction_system import Construction, Constructor, Field

construction = Construction(
    '''
from core.line_format_autogen import LineFormat 
    ''',
    [
        Constructor(
            "Choice", [], [
                Field('dis_rules', 'dict[str, Rule]', ""),
                Field('fall_rule', 'Rule', ""), 
            ]
        ),
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
                    Field('key', 'str', ""),
                    Field('regex', 'str', "")
                ]
            ),

            Constructor(
                "Nonterm", [], [
                    Field('relation', 'str', ""),
                    Field('key', 'str', ""),
                    Field('format', 'LineFormat', ""),
                ]
            ),

        ]
    }
)





