from __future__ import annotations

from base.util_system import write_code
from base import construction_system, abstract_token_plan, line_format_plan, rule_plan 


'''
base generation
'''
write_code('base', "abstract_token", 
    construction_system.generate_content("", abstract_token_plan.singles, abstract_token_plan.choices)
)
write_code('base', "line_format", 
    construction_system.generate_content("", line_format_plan.singles, line_format_plan.choices)
)
write_code('base', "rule",
    construction_system.generate_content('''
from lwtapas.base.line_format_autogen import line_format
        ''', 
        rule_plan.singles,
        rule_plan.choices
    )
)