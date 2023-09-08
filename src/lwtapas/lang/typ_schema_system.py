from __future__ import annotations
from lwtapas.base.rule_construct_autogen import ItemHandlers, Rule, Vocab, Terminal, Nonterm 
from lwtapas.base.line_format_construct_autogen import NewLine, InLine, IndentLine
from lwtapas.base import rule_system as rs
from lwtapas.base.schema_system import Schema 

content = Schema([],
{
    "Typ" : [
        Rule("Var", [
            Vocab("name", "identifier"),
        ]),
        Rule("Exis", [
            Nonterm("body", "Typ", InLine()),
            Nonterm("qualifiers", "ListQual", InLine()),
            Nonterm("indicies", "ListIdent", InLine()),
        ]),
        Rule("Univ", [
            Vocab("index", "identifier"),
            Nonterm("upper_bound", "Typ", InLine()),
            Nonterm("body", "Typ", InLine()),
        ]),
        Rule("Induc", [
            Vocab("fixedpoint", "identifier"),
            Nonterm("body", "Typ", InLine()),
        ]),
        Rule("Union", [
            Nonterm("left", "Typ", InLine()),
            Nonterm("right", "Typ", InLine()),
        ]),
        Rule("Inter", [
            Nonterm("left", "Typ", InLine()),
            Nonterm("right", "Typ", InLine()),
        ]),
        Rule("Top", []),
        Rule("Bot", []),
        Rule("Unit", []),
        Rule("Tag", [
            Vocab("label", "discriminator"),
            Nonterm("body", "Typ", InLine()),
        ]),
        Rule("Field", [
            Vocab("label", "selector"),
            Nonterm("body", "Typ", InLine()),
        ]),
        Rule("Impli", [
            Nonterm("ante", "Typ", InLine()),
            Nonterm("consq", "Typ", InLine()),
        ])
    ],
    "ListQual" : [
        Rule("NilQual", []),
        Rule("ConsQual", [
            Nonterm("lower", "Typ", InLine()),
            Nonterm("upper", "TYp", InLine()),
            Nonterm("qualifiers", "ListQual", InLine()),
        ]),
    ],
    "ListIdent" : [
        Rule("NilIdent", []),
        Rule("ConsIdent", [
            Vocab("name", "identifier"),
            Nonterm("identifiers", "ListIdent", InLine()),
        ]),
    ],
}
)
