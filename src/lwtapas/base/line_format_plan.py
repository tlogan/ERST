from __future__ import annotations

from lwtapas.base import construction_system
from lwtapas.base.construction_system import Constructor, Field
from lwtapas.base.schema_system import Schema 

choices = {"line_format" : [
    Constructor("InLine", [], []),
    Constructor("NewLine", [], []),
    Constructor("IndentLine", [], [])
]}



