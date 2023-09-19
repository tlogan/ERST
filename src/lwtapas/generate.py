from __future__ import annotations

from core.util_system import write_code
from core import construction_system, abstract_token_plan, line_format_plan, meta_plan 


'''
base generation
'''
write_code('core', "abstract_token", 
    construction_system.generate("", abstract_token_plan.construction)
)
write_code('core', "line_format", 
    construction_system.generate("", line_format_plan.construction)
)
write_code('core', "meta",
    construction_system.generate('''
from core.line_format_autogen import LineFormat 
        ''', 
        meta_plan.construction,
    )
)