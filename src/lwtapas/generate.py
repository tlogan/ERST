from __future__ import annotations

from base.util_system import write_code
from base import abstract_token_schema
from base import construct_def


'''
base generation
'''
# write_code('lwtapas/base', "rule_construct", rule_construct_def.content)
# write_code('lwtapas/base', "line_format_construct", line_format_construct_def.content)
write_code('base', "abstract_token_construct", 
    construct_def.generate_content("", [], abstract_token_schema.content)
)

# '''
# lib generation
# '''
# write_code('lwtapas/lib', "abstract_stream_crawl",

#     (
#         abstract_stream_crawl_def.generate_content(f'''
#     from tapas_lib.python_ast_construct_autogen import * 
#             ''', 
#             schema
#         )
#     )
# )