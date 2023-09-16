from __future__ import annotations

from core.construction_system import Construction, Constructor, Field

construction = Construction(
    [],
    {
        "AbstractToken" : [
            Constructor(
                "Grammar", [], [
                    Field('options', 'str', ""),
                    Field('selection', 'str', ""),
                ]
            ),
            Constructor(
                "Vocab", [], [
                    Field('options', 'str', ""),
                    Field('selection', 'str', "")
                ]
            )
        ]
    }
)

