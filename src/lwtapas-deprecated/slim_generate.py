from __future__ import annotations

from core.util_system import write_code, project_path
from core import meta_system

import slim.language_plan
import os 


grammar_path = project_path('slim/Expr.g4')
os.system(f"antlr4 -v 4.13.0 -Dlanguage=Python3 {grammar_path}")

# write_code('slim', "lexeme", 
#     meta_system.generate_lexeme_code(slim.language_plan.lexicon)
# )

# write_code('slim', "syntax", 
#     meta_system.generate_syntax_code(slim.language_plan.syntax)
# )

# write_code('slim', "semantics_base", 
#     meta_system.generate_semantics_base_code(
#         slim.language_plan.syntax
#     )
# )
