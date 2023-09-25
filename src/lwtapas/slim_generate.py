from __future__ import annotations

from core.util_system import write_code
from core import meta_system

import slim.syntax_plan


write_code('slim', "lexeme", 
    meta_system.generate_lexeme_code(slim.syntax_plan.content)
)

write_code('slim', "syntax", 
    meta_system.generate_syntax_code(slim.syntax_plan.content)
)

write_code('slim', "semantics_base", 
    meta_system.generate_semantics_base_code(
        slim.syntax_plan.content
    )
)
