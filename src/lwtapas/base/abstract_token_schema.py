from __future__ import annotations

from base.construct_def import Constructor, Field

content = {
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

