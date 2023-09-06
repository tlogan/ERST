from __future__ import annotations

from lwtapas.base import construct_def
from lwtapas.base.construct_def import Constructor, Field

content = construct_def.generate_content("", [], {"line_format" : [
    Constructor("InLine", [], []),
    Constructor("NewLine", [], []),
    Constructor("IndentLine", [], [])
]})



