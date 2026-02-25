import Lang.Util

set_option pp.fieldNotation false

namespace Lang

#check List.any
-- The English word "any" does not hold quantification meaning; it is simply a predication of a collection.
-- the quantification of "any" can be inferred to me either all or exists dependeing on context and inflection.
def List.exi.{u} {α : Type u} (l : List α) (p : α → Bool) : Bool := List.any l p


def List.firstIndexOf {α} [BEq α] (target : α) (l : List α) : Option Nat :=
  let ns := List.indexesOf target l
  if h : List.length ns > 0 then
      let i : Fin (List.length ns) := {
        val := 0,
        isLt := by simp [h]
      }
      .some (List.get ns i)
  else
    .none


example (id : String) (xs ys : List String):
  id ∈ (xs ∪ ys) →
  id ∈ xs ∨ id ∈ ys
:= by
  intro h0
  exact Iff.mp List.mem_union_iff h0


theorem List.get_none_add_preservation {α} (m : List α) (i : Nat) (i' : Nat):
  m[i]? = none →
  m[i + i']? = none
:= by induction i' with
| zero =>
  simp [*]
| succ i'' ih =>
  simp [*]
  intro h0
  exact Nat.le_add_right_of_le h0


theorem remove_all_empty α ids:
  @remove_all α [] ids = []
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids' ih =>
  simp [remove_all, remove]
  exact ih

theorem remove_all_single_membership :
  x ∈ ids →
  remove_all [(x,c)] ids = []
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids' ih =>
  simp [remove_all]
  intro h0
  cases h0 with
  | inl h1 =>
    simp [*, remove]
    simp [remove_all_empty]
  | inr h1 =>
    specialize ih h1
    simp [remove]
    by_cases h2 : x = id
    { simp [h2,remove_all_empty] }
    { simp [h2,ih] }

theorem remove_all_single_nomem :
  x ∉ ids →
  remove_all [(x,c)] ids = [(x,c)]
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids ih =>
  simp [remove_all,remove]
  intro h0 h1
  simp [h0]
  apply ih h1


end Lang
