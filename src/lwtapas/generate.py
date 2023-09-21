from __future__ import annotations

from core.util_system import write_code
from core import \
    language_system, construction_system, abstract_token_plan, \
    line_format_plan, meta_plan, language_system 

import slim.syntax_plan


'''
core generation
'''

write_code('core', "meta",
    construction_system.generate(meta_plan.construction)
)

write_code('core', "abstract_token", 
    construction_system.generate(abstract_token_plan.construction)
)

write_code('core', "line_format", 
    construction_system.generate(line_format_plan.construction)
)

'''
slim generation
'''
write_code('slim', "lexeme", 
    language_system.generate_lexeme_code(slim.syntax_plan.content)
)

write_code('slim', "syntax", 
    construction_system.generate(language_system.to_construction(
        slim.syntax_plan.content
    ))
)

write_code('slim', "semantics_base", 
    language_system.generate_semantics_base_code(
        slim.syntax_plan.content
    )
)
