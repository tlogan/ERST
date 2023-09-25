from __future__ import annotations
from core.meta_system import Rule, Nonterm, Terminal, Syntax
from core.line_format_system import NewLine, InLine, IndentLine

'''
TODO: update syntax to use choice with leftward discrimination between rules
-- use the convention that only the last can begin without a terminal.
'''
content = Syntax(
    '''''',
    "Expr",
    [],
    {
        # "Expr" : Choice(
        #     [
        #     ],
        #     Rule("",[
        #     ]) 
        # ), 
        #     Rule("Exis", [
        #         Nonterm("body", "Typ", InLine()),
        #         Nonterm("qualifiers", "ListQual", InLine()),
        #         Nonterm("indicies", "ListIdent", InLine()),
        #     ]),
        #     Rule("Univ", [
        #         Terminal("index", "identifier"),
        #         Nonterm("upper_bound", "Typ", InLine()),
        #         Nonterm("body", "Typ", InLine()),
        #     ]),
        #     Rule("Induc", [
        #         Terminal("fixedpoint", "identifier"),
        #         Nonterm("body", "Typ", InLine()),
        #     ]),
        #     Rule("Union", [
        #         Nonterm("left", "Typ", InLine()),
        #         Nonterm("right", "Typ", InLine()),
        #     ]),
        #     Rule("Inter", [
        #         Nonterm("left", "Typ", InLine()),
        #         Nonterm("right", "Typ", InLine()),
        #     ]),
        #     Rule("Top", []),
        #     Rule("Bot", []),
        #     Rule("Unit", []),
        #     Rule("Tag", [
        #         Terminal("label", "discriminator"),
        #         Nonterm("body", "Typ", InLine()),
        #     ]),
        #     Rule("Field", [
        #         Terminal("label", "selector"),
        #         Nonterm("body", "Typ", InLine()),
        #     ]),
        #     Rule("Impli", [
        #         Nonterm("ante", "Typ", InLine()),
        #         Nonterm("consq", "Typ", InLine()),
        #     ])
        # ],
        # "ListQual" : [
        #     Rule("NilQual", []),
        #     Rule("ConsQual", [
        #         Nonterm("lower", "Typ", InLine()),
        #         Nonterm("upper", "Typ", InLine()),
        #         Nonterm("qualifiers", "ListQual", InLine()),
        #     ]),
        # ],
        # "ListIdent" : [
        #     Rule("NilIdent", []),
        #     Rule("ConsIdent", [
        #         Terminal("name", "identifier"),
        #         Nonterm("identifiers", "ListIdent", InLine()),
        #     ]),
        # ],

        # "Expr" : [
        #     Rule("Var", [
        #         Terminal("name", "identifier"),
        #     ]),
        #     Rule("Unit", []),
        #     Rule("Tag", [
        #         Terminal("label", "discriminator"),
        #         Nonterm("body", "Expr", InLine()),
        #     ]),
        #     Rule("Record", [
        #         Nonterm("fields", "ListField", InLine()),
        #     ]),
        #     Rule("Function", [
        #         Terminal("param", "identifier"),
        #         Nonterm("fields", "ListField", InLine()),
        #     ]),
        #     Rule("Match", [
        #         Nonterm("switch", "Expr", InLine()),
        #         Nonterm("branches", "ListBranch", InLine()),
        #     ]),
        #     Rule("Project", [
        #         Nonterm("target", "Expr", InLine()),
        #         Terminal("label", "selection"),
        #     ]),
        #     Rule("App", [
        #         Nonterm("function", "Expr", InLine()),
        #         Nonterm("arg", "Expr", InLine()),
        #     ]),
        #     Rule("Letb", [
        #         Terminal("param", "identifier"),
        #         Nonterm("annotation", "Typ", InLine()),
        #         Nonterm("arg", "Expr", InLine()),
        #         Nonterm("body", "Expr", InLine()),
        #     ]),
        #     Rule("Fix", [
        #         Nonterm("body", "Expr", InLine()),
        #     ]),
        # ],
        # "ListField" : [
        #     Rule("NilField", []),
        #     Rule("ConsField", [
        #         Terminal("label", "discriminator"),
        #         Nonterm("body", "Expr", InLine()),
        #         Nonterm("fields", "ListField", InLine()),
        #     ]),
        # ],
        # "ListBranch" : [
        #     Rule("NilBranch", []),
        #     Rule("ConsBranch", [
        #         Nonterm("pattern", "Expr", InLine()),
        #         Nonterm("body", "Expr", InLine()),
        #         Nonterm("branches", "ListBranch", InLine()),
        #     ]),
        # ]
    },
)