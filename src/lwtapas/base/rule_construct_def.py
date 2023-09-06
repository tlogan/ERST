from __future__ import annotations

from lwtapas.base.construct_def import Constructor, Field
from lwtapas.base import construct_def

# def generate_content():
content = (
        construct_def.header +
        "\n\n" +
        "from lwtapas.base.line_format_construct_autogen import line_format" +
        "\n\n" +
        construct_def.generate_choice("item", "", [
            Constructor(
                "Terminal", [], [
                    Field('terminal', 'str', "")
                ]
            ),

            Constructor(
                "Nonterm", [], [
                    Field('relation', 'str', ""),
                    Field('nonterminal', 'str', ""),
                    Field('format', 'line_format', ""),
                ]
            ),

            Constructor(
                "Vocab", [], [
                    Field('relation', 'str', ""),
                    Field('vocab', 'str', ""),
                ]
            )
        ]) +

        "\n\n" +
        "\n\n" +
        construct_def.generate_single(
            Constructor(
                "Rule", [], [
                    Field('name', 'str', ""), 
                    Field('content', 'list[item]', "")
                ]
            )
        )
    )






