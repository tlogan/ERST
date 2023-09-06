from __future__ import annotations

from lwtapas.base.construct_def import Constructor, Field
from lwtapas.base import construct_def

content = construct_def.generate_content("", [], {
    "abstract_token" : [
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
})

