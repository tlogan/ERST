from __future__ import annotations

from lwtapas.base import abstract_stream_crawl_def
from lwtapas.lang import schema_system

content = (

    abstract_stream_crawl_def.generate_content(f'''
from tapas_lib.python_ast_construct_autogen import * 
        ''', 
        singles = schema_system.singles_schema, 
        choices = schema_system.choices_schema
    )
)



