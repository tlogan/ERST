from __future__ import annotations

from core.construction_system import Construction, Constructor, Field

construction = Construction(
    '''
    ''',
    [],
    {
        "RichToken" : [
            Constructor(
                "Grammar", [], [
                    Field('key', 'str', ""),
                    Field('selection', 'str', ""),
                ]
            ),
            Constructor(
                "Vocab", [], [
                    Field('key', 'str', ""),
                    Field('selection', 'str', "")
                ]
            )
        ]
    }
)

