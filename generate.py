from __future__ import annotations

from src.lwtapas.base.util_system import write_code
from src.lwtapas.base import line_format_construct_def
from src.lwtapas.base import abstract_token_construct_def
from src.lwtapas.base import rule_construct_def


'''
base generation
'''
write_code('lwtapas/base', "rule_construct", rule_construct_def.content)
write_code('lwtapas/base', "line_format_construct", line_format_construct_def.content)
write_code('lwtapas/base', "abstract_token_construct", abstract_token_construct_def.content)

'''
lib generation
'''