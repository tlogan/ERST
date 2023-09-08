from __future__ import annotations
from lwtapas.base.rule_construct_autogen import ItemHandlers, Rule, Vocab, Terminal, Nonterm 
from lwtapas.base.line_format_construct_autogen import NewLine, InLine, IndentLine
from lwtapas.base import rule_system as rs

from lwtapas.base.schema_system import Schema

content = Schema([],
{
    "Expr" : [
        Rule("Var", [
            Vocab("name", "identifier"),
        ]),
        Rule("Unit", []),
        Rule("Tag", [
            Vocab("label", "discriminator"),
            Nonterm("body", "Expr", InLine()),
        ]),
        Rule("Record", [
            Nonterm("fields", "ListField", InLine()),
        ]),
        Rule("Function", [
            Vocab("param", "identifier"),
            Nonterm("fields", "ListField", InLine()),
        ]),
        Rule("Match", [
            Nonterm("switch", "Expr", InLine()),
            Nonterm("branches", "ListBranch", InLine()),
        ]),
        Rule("Project", [
            Nonterm("target", "Expr", InLine()),
            Vocab("label", "selection"),
        ]),
        Rule("App", [
            Nonterm("function", "Expr", InLine()),
            Nonterm("arg", "Expr", InLine()),
        ]),
        Rule("Letb", [
            Vocab("param", "identifier"),
            Nonterm("annotation", "Typ", InLine()),
            Nonterm("arg", "Expr", InLine()),
            Nonterm("body", "Expr", InLine()),
        ]),
        Rule("Fix", [
            Nonterm("body", "Expr", InLine()),
        ]),
    ],
    "ListField" : [
        Rule("NilField", []),
        Rule("ConsField", [
            Vocab("label", "discriminator"),
            Nonterm("body", "Expr", InLine()),
            Nonterm("fields", "ListField", InLine()),
        ]),
    ],
    "ListBranch" : [
        Rule("NilBranch", []),
        Rule("ConsBranch", [
            Nonterm("pattern", "Expr", InLine()),
            Nonterm("body", "Expr", InLine()),
            Nonterm("branches", "ListBranch", InLine()),
        ]),
    ]
}
)