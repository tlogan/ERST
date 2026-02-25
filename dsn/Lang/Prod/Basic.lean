import Lean
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

namespace Lang


--------------------------

def Prod.dom (xs : List (α × β)) :=
  List.map Prod.fst xs


def Prod.remove [BEq α] (target : α) (xs : List (α × β)) : List (α × β)
:= List.filter (fun (key,_) => key != target) xs

def Prod.remove_all [BEq α] (xs : List (α × β)) : List α → List (α × β)
| [] => xs
| target :: targets => remove_all (Prod.remove target xs) targets

def Prod.find [BEq α] (target : α) (xs : List (α × β)) : Option β :=
  Option.map Prod.snd (List.find? (fun (key,_) => key == target) xs)


-- def find (target : String) : List (String × α) → Option α
-- | .nil => none
-- | (key, e) :: m =>
--   if key == target then
--     some e
--   else
--     find target m



-- theorem ListPair.mem_concat_disj {β}
--   (x : String) (am0 am1 : List (String × β))
-- :
--   x ∈ ListPair.dom (am1 ++ am0) →
--   x ∈ ListPair.dom am1 ∨ x ∈ ListPair.dom am0
-- := by induction am1 with
--   | nil =>
--     simp [dom]
--   | cons a am1' ih =>
--     simp [dom]
--     intro p
--     cases p with
--     | inl h =>
--       simp [*]
--     | inr h =>
--       have h := ih h
--       cases h with
--       | inl h' =>
--         simp [*]
--       | inr h' =>
--         simp [*]

-- theorem ListPair.mem_disj_concat_left {β}
--   (x : String) (am0 am1 : List (String × β))
-- :
--   x ∈ ListPair.dom am1 →
--   x ∈ ListPair.dom (am1 ++ am0)
-- := by induction am1 with
--   | nil => simp [dom]
--   | cons a am1' ih =>
--     simp [dom]
--     intro p
--     cases p with
--     | inl h =>
--       simp [*]
--     | inr h =>
--       have h := ih h
--       simp [*]

-- theorem ListPair.mem_disj_concat_right {β}
--   (x : String) (am0 am1 : List (String × β))
-- :
--   x ∈ ListPair.dom am0 →
--   x ∈ ListPair.dom (am1 ++ am0)
-- := by induction am1 with
--   | nil => simp
--   | cons a am1' ih =>
--     simp [dom]
--     intro p
--     have p := ih p
--     simp [*]


-- theorem removeAll_refl {α} [BEq α] {xs ys : List α}:
--    List.removeAll xs ys ⊆ xs
-- := by sorry

-- theorem containment_removeAll_concat_elim {α} [BEq α] {xs ys : List α}:
--    List.removeAll (xs ++ ys) ys ⊆ xs
-- := by sorry

-- theorem containment_removeAll_union_elim {α} [BEq α] {xs ys : List α}:
--    List.removeAll (xs ∪ ys) ys ⊆ xs
-- := by sorry


-- theorem removeAll_right_sub_cons_eq y {xs ys : List String} :
--   y ∈ ys → List.removeAll xs ys = List.removeAll xs (y :: ys)
-- := by sorry

-- theorem removeAll_left_sub_refl_disjoint {xs ys : List String} :
--   List.removeAll xs ys ∩ ys = []
-- := by sorry


-- theorem removeAll_concat_eq {xs ys zs : List String} :
--   ys ⊆ zs →
--   List.removeAll xs zs = List.removeAll xs (ys ++ zs)
-- := by induction ys with
--   | nil =>
--     simp
--   | cons y ys' ih =>
--     intro ss
--     have p0 : y ∈ zs := by
--       apply ss
--       exact List.mem_cons_self
--     have p1 : ys' ⊆ zs := by
--       intro x m
--       apply ss
--       exact List.mem_cons_of_mem y m
--     rw [ih p1]
--     apply removeAll_right_sub_cons_eq
--     exact List.mem_append_right ys' p0

-- theorem removeAll_concat_containment_left {xs ys zs : List String} :
--   List.removeAll xs (ys ++ zs) ⊆ List.removeAll xs ys
-- := by sorry

-- theorem removeAll_concat_containment_right {xs ys zs : List String} :
--   List.removeAll xs (ys ++ zs) ⊆ List.removeAll xs zs
-- := by sorry


-- theorem concat_right_containment {xs ys zs : List String} :
--   (xs ++ ys) ⊆ zs → ys ⊆ zs
-- := by
--   intro p0
--   intro a p1
--   apply p0
--   exact List.mem_append_right xs p1


-- theorem removeAll_decreasing_containment {xs ys zs : List String} :
-- ys ⊆ zs → List.removeAll xs zs ⊆ List.removeAll xs ys
-- := by
--   intro ss
--   intro x dz
--   apply removeAll_concat_containment_left
--   rw [← removeAll_concat_eq] <;> assumption


-- theorem removeAll_increasing_containment {xs : List String} :
--   ∀ ys zs, ys ⊆ zs → List.removeAll ys xs ⊆ List.removeAll zs xs
-- := by induction xs with
--   | nil =>
--     simp [List.removeAll]
--     exact fun ys zs a ↦ List.filter_subset (fun x ↦ true) a
--   | cons x xs ih =>
--     intro ys zs ss
--     simp [List.removeAll]
--     exact List.filter_subset (fun x_1 ↦ !decide (x_1 = x) && !decide (x_1 ∈ xs)) ss


-- theorem dom_concat_removeAll_containment {β} {am0 am1 : List (String × β)} {xs xs_im xs'} :
--   xs ⊆ xs_im → ListPair.dom am0 ⊆ List.removeAll xs_im xs →
--   xs_im ⊆ xs' → ListPair.dom am1 ⊆ List.removeAll xs' xs_im →
--   ListPair.dom (am1 ++ am0) ⊆ List.removeAll xs' xs
-- := by
--   intros ss0 dd0 ss1 dd1
--   induction am1 with
--   | nil =>
--     simp [*]
--     have ss1' : List.removeAll xs_im xs ⊆ List.removeAll xs' xs := by
--       apply removeAll_increasing_containment; simp [*]
--     intro x p
--     apply ss1'
--     apply dd0
--     simp [*]
--   |cons a am1' ih =>
--     let (x, v) := a
--     simp [ListPair.dom]
--     apply And.intro
--     {
--       apply removeAll_decreasing_containment ss0
--       apply dd1
--       simp [ListPair.dom]
--     }
--     {
--       apply ih
--       intro y1 p1
--       apply dd1
--       simp [ListPair.dom]
--       apply Or.inr
--       assumption
--     }

-- theorem remove_all_empty α ids:
--   @remove_all α [] ids = []
-- := by induction ids with
-- | nil =>
--   simp [remove_all]
-- | cons id ids' ih =>
--   simp [remove_all, remove]
--   exact ih

-- theorem remove_all_single_membership :
--   x ∈ ids →
--   remove_all [(x,c)] ids = []
-- := by induction ids with
-- | nil =>
--   simp [remove_all]
-- | cons id ids' ih =>
--   simp [remove_all]
--   intro h0
--   cases h0 with
--   | inl h1 =>
--     simp [*, remove]
--     simp [remove_all_empty]
--   | inr h1 =>
--     specialize ih h1
--     simp [remove]
--     by_cases h2 : x = id
--     { simp [h2,remove_all_empty] }
--     { simp [h2,ih] }

-- theorem remove_all_single_nomem :
--   x ∉ ids →
--   remove_all [(x,c)] ids = [(x,c)]
-- := by induction ids with
-- | nil =>
--   simp [remove_all]
-- | cons id ids ih =>
--   simp [remove_all,remove]
--   intro h0 h1
--   simp [h0]
--   apply ih h1



end Lang
