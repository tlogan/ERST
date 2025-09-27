import Lang.Util
import Lang.Basic
import Lang.Static
import Lang.Dynamic


-- import Std.Data.List.Basic
-- import Std.Data.List.Lemmas

set_option pp.fieldNotation false


#print List.diff
#print List.erase

lemma erase_preservation (xs0 : List String) :
∀ xs1, xs0 ⊆ xs1 → ∀ x, x ∈ xs0 → x ∈ xs1 → List.erase xs0 x ⊆ List.erase xs1 x
:= by
  induction xs0 with
  | nil => simp [*]
  | cons s ss ih =>
    sorry

lemma erase_introduction (xs0 : List String) :
  ∀ xs1, xs0 ⊆ xs1 → ∀ x, x ∉ xs0 → x ∈ xs1 → xs0 ⊆ (List.erase xs1 x)
:= by sorry

lemma diff_increasing_preservation (xs : List String) :
  ∀ ys zs, ys ⊆ zs → List.diff ys xs ⊆ List.diff zs xs
:= by
  induction xs with
  | nil =>
    simp [List.diff]
  | cons x xs ih =>
    intro ys zs ss
    -- apply ih at ss
    simp [List.diff]
    have d0 : Decidable (x ∈ ys) := inferInstance
    cases d0 with
    | isFalse h0 =>
      have d1 : Decidable (x ∈ zs) := inferInstance
      cases d1 with
      | isFalse h1 => simp [*]
      | isTrue h1 =>
        simp [*]
        have h2 : ys ⊆ (List.erase zs x) := by
          exact erase_introduction ys zs ss x h0 h1
        simp [*]
    | isTrue h0 =>
      simp [*]
      have h1 : x ∈ zs := by apply ss; simp [*]
      simp [*]
      apply ih
      exact erase_preservation ys zs ss x h0 (ss h0)

#check ListPair.dom


-- lemma ListPair.mem_concat_disj {β}
--   (x : String) (am1 am0 : List (String × β))
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
--       apply ih at h
--       cases h with
--       | inl h' =>
--         simp [*]
--       | inr h' =>
--         simp [*]

-- lemma ListPair.mem_disj_concat_left {β}
--   (x : String) (am1 am0 : List (String × β))
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
--       apply ih at h
--       simp [*]

-- lemma ListPair.mem_disj_concat_right {β}
--   (x : String) (am1 am0 : List (String × β))
-- :
--   x ∈ ListPair.dom am0 →
--   x ∈ ListPair.dom (am1 ++ am0)
-- := by induction am1 with
--   | nil => simp
--   | cons a am1' ih =>
--     simp [dom]
--     intro p
--     apply ih at p
--     simp [*]



lemma diff_concat_preservation (xs ys zs : List String) :
  List.diff xs (ys ++ zs) ⊆ List.diff xs ys
:= by sorry


lemma diff_erase_right_preservation (xs zs : List String) y :
List.diff xs zs ⊆ List.diff xs (List.erase zs y)
:= by sorry


lemma diff_concat_diff_preservation (ys : List String) :
∀ xs zs, ys ⊆ zs → List.diff xs zs ⊆ List.diff xs (ys ++ List.diff zs ys)
:= by induction ys with
  | nil =>
    simp [List.diff]
  | cons y ys' ih =>
    simp [List.diff]
    intro xs zs yzs ss x m
    have dx : Decidable (y ∈ xs) := inferInstance
    have dz : Decidable (y ∈ zs) := inferInstance
    sorry


lemma diff_decreasing_preservation (xs ys zs : List String) :
  ys ⊆ zs → List.diff xs zs ⊆ List.diff xs ys
:= by
  intro ss
  intro x dz
  apply diff_concat_preservation xs ys (List.diff zs ys)
  apply diff_concat_diff_preservation ys xs zs ss
  simp [*]





  -- ys ⊆ zs → List.diff xs zs ⊆ List.diff xs ys

  -- List.diff xs zs ⊆ List.diff xs (ys ++ List.diff zs ys)
  -- List.diff xs (ys ++ zs') ⊆ List.diff xs ys





lemma
dom_diff_concat {β} (am0 am1 : List (String × β))
  xs xs_im xs'
:
xs ⊆ xs_im →
ListPair.dom am0 ⊆ List.diff xs_im xs →
xs_im ⊆ xs' →
ListPair.dom am1 ⊆ List.diff xs' xs_im →
ListPair.dom (am1 ++ am0) ⊆ List.diff xs' xs
:= by
  intros ss0 dd0 ss1 dd1
  induction am1 with
  | nil =>
    simp [*]
    have ss1' : List.diff xs_im xs ⊆ List.diff xs' xs := by
      apply diff_increasing_preservation; simp [*]
    intro x p
    apply ss1'
    apply dd0
    simp [*]
  |cons a am1' ih =>
    let (x, v) := a
    simp [ListPair.dom]
    apply And.intro
    case left =>
      simp [ListPair.dom] at dd1
      apply diff_decreasing_preservation xs' xs xs_im ss0
      simp [*]
    case right =>
      simp [ListPair.dom] at dd1
      cases dd1 with | intro dd1l dd1r =>
      intro x h
      apply ih dd1r
      simp [*]

#print List.concat

mutual
  theorem ListSubtyping.soundness skolems assums cs skolems' assums' :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.diff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      MultiSubtyping.Dynamic (am ++ am') cs
    )
  | .nil => by
    exists []
    simp
    apply And.intro
    case left =>
      simp [ListPair.dom]
    case right =>
      intro am'
      intro md
      simp [MultiSubtyping.Dynamic]
  | .cons l r cs' skolems_im assums_im ss lss => by
    have ih0 := Subtyping.soundness skolems assums l r skolems_im assums_im ss
    have ih1 := ListSubtyping.soundness skolems_im assums_im cs' skolems' assums' lss
    cases ih0 with | intro am0 h0 =>
    cases h0 with | intro h0l h0r =>
    cases ih1 with | intro am1 h1 =>
    cases h1 with | intro h1l h1r =>

    sorry


  theorem Subtyping.soundness skolems assums lower upper skolems' assums' :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.diff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper
    )
  := by sorry

end
