from __future__ import annotations

from lwtapas.base.util_system import write_code
from lwtapas.base import rule_construction 
from lwtapas.base import line_format_construction 
from lwtapas.base import abstract_token_construction
from lwtapas.base import construction_system 


'''
base generation
'''
write_code('base', "rule",
    construction_system.generate_content('''
        from lwtapas.base.line_format_construct_autogen import line_format
        ''', 
        rule_construction.singles,
        rule_construction.choices
    )
)
write_code('base', "line_format", 
    construction_system.generate_content("", line_format_construction.singles, line_format_construction.choices)
)
write_code('base', "abstract_token", 
    construction_system.generate_content("", abstract_token_construction.singles, abstract_token_construction.choices)
)