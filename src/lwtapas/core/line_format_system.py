from __future__ import annotations
from typing import Iterator

from core.line_format_autogen import * 


def to_string(line_form : LineFormat) -> str:
    class Handler(LineFormatHandler):
        def case_InLine(self, _): return "InLine"
        def case_NewLine(self, _): return "NewLine"
        def case_IndentLine(self, _): return "IndentLine" 
    return line_form.match(Handler())


def is_inline(line_form : LineFormat) -> bool:
    class Handler(LineFormatHandler):
        def case_InLine(self, _): return True
        def case_NewLine(self, _): return False
        def case_IndentLine(self, _): return False 
    return line_form.match(Handler())

def next_indent_width(prev_iw : int, line_form : LineFormat) -> int:
    class Handler(LineFormatHandler):
        def case_InLine(self, _): return prev_iw
        def case_NewLine(self, _): return prev_iw, 
        def case_IndentLine(self, _): return prev_iw + 1 
    return line_form.match(Handler())

