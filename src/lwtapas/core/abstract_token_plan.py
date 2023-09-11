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
                    Field('source_start', 'int', "0"),
                    Field('source_end', 'int', "0"),
                ]
            ),
            Constructor(
                "Vocab", [], [
                    Field('options', 'str', ""),
                    Field('selection', 'str', "")
                ]
            ),
            Constructor(
                "Hole", [], []
            )
        ]
    }
)

