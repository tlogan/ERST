import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

namespace Lang

-- The English word "any" does not hold quantification meaning; it is simply a predication of a collection.
-- the quantification of "any" can be inferred to me either all or exists depending on context and inflection.
def List.exi (xs : List α) (condition : α → Bool) : Bool :=
  List.any xs condition

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




--------------------------



-- theorem List.cons_containment {α} [BEq α] {x : α} {xs ys : List α} :
--   x :: xs  ⊆ ys → x ∈ ys ∧ xs ⊆ ys
-- := by
--   intro p0
--   apply And.intro
--   {
--     apply p0
--     simp [*]
--   }
--   {
--     intro y p1
--     apply p0
--     simp [*]
--   }

-- -- #print List.inter

-- #print decide

-- example {α} [DecidableEq α] (x : α) (xs : List α) :
--   List.contains xs x =  decide (x ∈ xs)
-- := by exact List.contains_eq_mem x xs


-- theorem List.not_mem_cons {α} [BEq α] {x x': α} {xs : List α} :
--   x ∉ (x' :: xs) →
--   x ≠ x' ∧ x ∉ xs
-- := by intro p ; exact List.ne_and_not_mem_of_not_mem_cons p

-- -- set_option pp.notation false in
-- theorem List.nonmem_to_disjoint_right {α} [DecidableEq α] (x : α) (xs : List α) :
--   x ∉ xs → xs ∩ [x] = []
-- := by
--   intro h
--   induction xs with
--   | nil => exact rfl
--   | cons y ys ih =>
--     simp [Inter.inter, List.inter]

--     have ⟨l,r⟩ := List.ne_and_not_mem_of_not_mem_cons h
--     apply And.intro
--     { exact id (Ne.symm l) }
--     { intros x'' p ; exact (ne_of_mem_of_not_mem p r) }


-- theorem List.disjoint_preservation_left {α} [BEq α] {xs ys zs : List α} :
--   xs ⊆ ys → ys ∩ zs = [] → xs ∩ zs = []
-- := by
--   simp [Inter.inter, List.inter]
--   intro p0
--   induction xs with
--   | nil =>
--     intro p1; intro a;
--     intro p2
--     cases p2
--   | cons x xs' ih =>
--     intro p1
--     have ⟨p2, p3⟩ := List.cons_containment p0
--     intro a
--     intro p4
--     cases p4 with
--     | head =>
--       exact p1 x p2
--     | tail _ p5 =>
--       apply ih p3 p1
--       exact p5

-- theorem List.disjoint_preservation_right {α} [BEq α] {xs ys zs : List α} :
--   ys ⊆ zs → xs ∩ zs = [] → xs ∩ ys = []
-- := by
--   simp [Inter.inter, List.inter]
--   intro p0
--   induction xs with
--   | nil =>
--     intro p1; intro a;
--     intro p2
--     cases p2
--   | cons x xs' ih =>
--     intro p1
--     sorry

-- theorem List.disjoint_concat_right {α} [BEq α] {xs ys zs : List α} :
--   xs ∩ (ys ++ zs) = [] → xs ∩ ys = [] ∧ xs ∩ zs = []
-- := by sorry


-- theorem List.inter_empty_eq_empty {α} [BEq α] {ys : List α} :
--   ys ∩ [] = []
-- := by
--   cases ys with
--   | nil => exact rfl
--   | cons x xs =>
--     simp [Inter.inter, List.inter]


-- theorem List.disjoint_swap {α} [BEq α] {xs ys : List α} :
--   xs ∩ ys = [] → ys ∩ xs = []
-- := by
--   intros
--   induction xs with
--   | nil => exact inter_empty_eq_empty
--   | cons => sorry



-- example (id : String) (xs ys : List String):
--   id ∈ (xs ∪ ys) →
--   id ∈ xs ∨ id ∈ ys
-- := by
--   intro h0
--   exact Iff.mp List.mem_union_iff h0



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



end Lang
