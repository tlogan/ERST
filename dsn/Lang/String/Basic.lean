import Lang.Util
import Lang.List.Basic

set_option pp.fieldNotation false

declare_syntax_cat ids
-- declare_syntax_cat box_ids

syntax:20 ident : ids
syntax:20 ident ids : ids

-- syntax "[" "]" : box_ids
-- syntax "[" ids "]" : box_ids


syntax "[eid|" ident "]" : term
syntax "[id|" ident "]" : term

syntax "[ids|" "]": term
syntax "[ids|" ids "]": term


macro_rules
| `([ids| ]) => `([])
| `([ids| $i:ident ]) => `([id| $i] :: [])
| `([ids| $i:ident $ps:ids ]) => `([id| $i] :: [ids| $ps])


namespace Lang


open Std.Format

def String.has_whitespace (s : String) :=
  (s.contains ' ') ||
  s.contains '\t' ||
  s.contains '\n'

instance : Repr (List String) where
  reprPrec ids _ :=
    if List.exi ids String.has_whitespace then
      repr ids
    else
      let rec loop ids := match ids with
        | [] => ""
        | id :: ids => id ++ line ++ (loop ids)
      group ("[ids|" ++ line ++ nest 2 (loop ids) ++ "]")

def append_line : List Std.Format → Std.Format
| .nil => ""
| x :: xs => x ++ line ++ append_line xs

def wrap (content : Std.Format) (p threshold : Nat) : Std.Format :=
    if p > threshold then
      "(" ++ content ++ ")"
    else
      content




elab_rules : term
  | `([id| $i:ident ])  => do
    let idStr := toString i.getId
    if idStr.contains '.' then
      Lean.Elab.throwUnsupportedSyntax
    return (Lean.mkStrLit idStr)

partial def buildSyntaxFromDotted (parts : List Lean.Ident)
: Lean.Elab.TermElabM (Lean.TSyntax `term) :=
  match parts with
  | [] => Lean.Elab.throwUnsupportedSyntax
  | [x] => `(Expr.var [id| $x])
  | x :: xs => do
    let ys ← buildSyntaxFromDotted xs
    `(Expr.app
        (Expr.function [
          (Pat.record [
            ([id| $x], Pat.var "x")
          ], Expr.var "x")
        ])
        $ys
    )

elab_rules : term
  | `([eid| $i:ident ])  => do
    let name := i.getId
    let parts := name.components.map Lean.mkIdent
    let s ← buildSyntaxFromDotted parts.reverse
    Lean.Elab.Term.elabTerm s none


-- syntax "{" term "}"  : ids


end Lang
