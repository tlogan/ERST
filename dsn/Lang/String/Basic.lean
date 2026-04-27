import Lean

import Mathlib.Data.String.Lemmas
-- (for String.length_append, String.length_join, etc.) and/or
import Mathlib.Data.List.Lemmas

import Lang.List.Basic

set_option pp.fieldNotation false

namespace Lang

#check Lean.mkFreshId
def fresh_typ_id {m : Type → Type} [Monad m] [Lean.MonadNameGenerator m] : m String :=
  do
  let raw := (← Lean.mkFreshId).toString
  let content :=  "T" ++ raw.drop ("_uniq.".length + 3)
  return content

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



theorem String.length_repr_non_zero :
  String.length (Nat.repr i) ≠ 0
:= by
  simp [Nat.repr]
  sorry



theorem String.foldl_append_seed_exclusion :
List.foldl (fun r s => r ++ s) (pre ++ name ++ post) names ++ Nat.repr i ≠ name
:= by cases names with
| nil =>
  intro h0
  apply congrArg String.length at h0
  simp at h0
  have it :
    String.length pre + String.length name =
    String.length name + String.length pre
  := by exact Nat.add_comm (String.length pre) (String.length name)
  simp [it] at h0 ; clear it
  rw [Nat.add_assoc] at h0
  rw [Nat.add_assoc] at h0
  simp at h0
  have ⟨h3,h4,h5⟩ := h0
  clear h0 h3
  apply String.length_repr_non_zero h5
| cons name' names' =>
  simp [List.foldl]
  have h0 :
    pre ++ name ++ post ++ name' =
    pre ++ name ++ (post ++ name')
  := by exact String.append_assoc (pre ++ name) post name'
  rw [h0]
  apply String.foldl_append_seed_exclusion

theorem String.foldl_append_list_exclusion :
List.foldl (fun r s => r ++ s) name names ++ Nat.repr i ∉ names
:= by cases names with
| nil =>
  simp
| cons name' names' =>
  simp
  apply And.intro
  { rw [←String.append_empty (name ++ name')]
    apply String.foldl_append_seed_exclusion
  }
  { apply String.foldl_append_list_exclusion }



-- theorem Nat.repr_injectivity :
--   (Nat.repr i) = (Nat.repr n') → i = n'
-- := by
--   simp [Nat.repr]
--   intro h0

--   sorry

-- theorem String.indexed_name_uniqueness :
--   List.Pairwise (fun x y => x ≠ y) (List.map (fun i => name ++ Nat.repr i) (List.range n))
-- := by cases n with
-- | zero =>
--   simp [List.range, List.range.loop]
-- | succ n' =>
--   rw [List.range_succ]
--   simp
--   rw [List.pairwise_append]
--   apply And.intro
--   { apply String.indexed_name_uniqueness }
--   {
--     apply And.intro
--     { exact List.pairwise_singleton (fun x y => ¬x = y) (name ++ Nat.repr n') }
--     { simp
--       intro i h0 h2
--       apply congrArg String.data at h2
--       simp at h2
--       apply String.ext at h2
--       apply Nat.repr_injectivity at h2
--       rw [h2] at h0
--       exact Iff.mp (lt_self_iff_false n') h0
--     }
--   }


-- def String.recursive_prefix := "_r_"

-- def String.namespace_recursive (name : String) : Prop :=
--   String.IsPrefix recursive_prefix name


-- def String.no_namespace_recursive (names : List String) : Prop :=
--   ∀ name ∈ names, ¬ String.namespace_recursive name


-- def String.quantified_prefix := "_q_"
-- def String.namespace_quantified (name : String) : Prop :=
--   String.IsPrefix quantified_prefix name


-- example :
--   ∀ name,
--     String.IsPrefix String.quantified_prefix name →
--     ¬ String.IsPrefix String.recursive_prefix name
-- := by
--   simp [String.quantified_prefix, String.recursive_prefix, String.IsPrefix]
--   intro name h0 h1

--   simp [List.IsPrefix] at h0 h1
--   have ⟨xs,h2⟩ := h0
--   have ⟨ys,h3⟩ := h1
--   simp [←h2] at h3


theorem String.fresh_names n names' :
  ∃ names : List String,
  List.length names = n ∧
  List.Disjoint names names'
  /- NOTE: uniqueness of names is necessary for renaming
  -- ∧ List.Pairwise (fun x y => x ≠ y) names
  -/
:= by
  exists (List.map (fun i => (String.join names') ++ (Nat.repr i)) (List.range n))

  apply And.intro
  { simp }
  { simp [List.Disjoint, String.join]
    intro i h0 h1
    apply String.foldl_append_list_exclusion h1
  }

theorem String.fresh_name (names : List String):
  ∃ name, name ∉ names
:= by
  exists (String.join names)++ (Nat.repr 0)
  simp [String.join]
  intro h0
  apply String.foldl_append_list_exclusion h0

end Lang
