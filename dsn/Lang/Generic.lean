import Lang.Util
import Lang.Basic
import Lang.Static
import Lang.Dynamic


-- import Std.Data.List.Basic
-- import Std.Data.List.Lemmas

set_option pp.fieldNotation false




lemma ListPair.mem_concat_disj {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom (am1 ++ am0) →
  x ∈ ListPair.dom am1 ∨ x ∈ ListPair.dom am0
:= by induction am1 with
  | nil =>
    simp [dom]
  | cons a am1' ih =>
    simp [dom]
    intro p
    cases p with
    | inl h =>
      simp [*]
    | inr h =>
      apply ih at h
      cases h with
      | inl h' =>
        simp [*]
      | inr h' =>
        simp [*]

lemma ListPair.mem_disj_concat_left {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom am1 →
  x ∈ ListPair.dom (am1 ++ am0)
:= by induction am1 with
  | nil => simp [dom]
  | cons a am1' ih =>
    simp [dom]
    intro p
    cases p with
    | inl h =>
      simp [*]
    | inr h =>
      apply ih at h
      simp [*]

lemma ListPair.mem_disj_concat_right {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom am0 →
  x ∈ ListPair.dom (am1 ++ am0)
:= by induction am1 with
  | nil => simp
  | cons a am1' ih =>
    simp [dom]
    intro p
    apply ih at p
    simp [*]


lemma mdiff_right_sub_cons_eq y (xs ys : List String):
  y ∈ ys → List.mdiff xs ys = List.mdiff xs (y :: ys)
:= by sorry

lemma mdiff_concat_eq (xs ys zs : List String) :
  ys ⊆ zs →
  List.mdiff xs zs = List.mdiff xs (ys ++ zs)
:= by induction ys with
  | nil =>
    simp
  | cons y ys' ih =>
    intro ss
    have p0 : y ∈ zs := by
      apply ss
      exact List.mem_cons_self
    have p1 : ys' ⊆ zs := by
      intro x m
      apply ss
      exact List.mem_cons_of_mem y m
    rw [ih p1]
    apply mdiff_right_sub_cons_eq
    exact List.mem_append_right ys' p0

lemma mdiff_concat_subseteq (xs ys zs : List String) :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs ys
:= by sorry


#print List.eq_nil_of_subset_nil
lemma mdiff_decreasing_subseteq (xs ys zs : List String) :
ys ⊆ zs → List.mdiff xs zs ⊆ List.mdiff xs ys
:= by
  intro ss
  intro x dz
  apply mdiff_concat_subseteq xs ys zs
  rw [← mdiff_concat_eq] <;> assumption


lemma merase_mem x y (zs : List String) :
y ∈ zs → x ≠ y → y ∈ List.merase x zs
:= by sorry


lemma merase_subseteq x (ys zs : List String) :
  ys ⊆ zs → List.merase x ys ⊆ List.merase x zs
:= by induction ys with
  | nil =>
    intro ss
    simp [List.merase]
  | cons y ys' ih =>
    intro ss
    have p0 : y ∈ zs := by apply ss; exact List.mem_cons_self
    have p1 : ys' ⊆ zs := by intro x h ; apply ss; exact List.mem_cons_of_mem y h
    simp [List.merase]
    have d : Decidable (x = y) := inferInstance
    cases d with
    | isFalse h =>
      simp [*]
      exact merase_mem x y zs p0 h
    | isTrue h =>
      simp [*]
      rw [← h]
      apply ih
      assumption

lemma mdiff_increasing_subseteq (xs : List String) :
  ∀ ys zs, ys ⊆ zs → List.mdiff ys xs ⊆ List.mdiff zs xs
:= by induction xs with
  | nil =>
    simp [List.mdiff]
  | cons x xs ih =>
    intro ys zs ss
    simp [List.mdiff]
    apply ih
    apply merase_subseteq
    assumption


lemma dom_concat_concat_subseteq {β} (am0 am1 : List (String × β)) xs xs_im xs' :
  xs ⊆ xs_im → ListPair.dom am0 ⊆ List.mdiff xs_im xs →
  xs_im ⊆ xs' → ListPair.dom am1 ⊆ List.mdiff xs' xs_im →
  ListPair.dom (am1 ++ am0) ⊆ List.mdiff xs' xs
:= by
  intros ss0 dd0 ss1 dd1
  induction am1 with
  | nil =>
    simp [*]
    have ss1' : List.mdiff xs_im xs ⊆ List.mdiff xs' xs := by
      apply mdiff_increasing_subseteq; simp [*]
    intro x p
    apply ss1'
    apply dd0
    simp [*]
  |cons a am1' ih =>
    let (x, v) := a
    intro y0 p0
    apply ih
    {
      intro y1 p1
      apply dd1
      simp [ListPair.dom]
      apply Or.inr
      assumption
    }
    {
      simp [ListPair.dom] at p0
      cases p0 with
      | inl h =>
        rw [h]

        sorry
      | inr h =>
        assumption
    }
    -- simp [ListPair.dom]
    -- apply And.intro
    -- case left =>
    --   apply ih
    --   {
    --     intro x0 p0
    --     apply dd1
    --     simp [ListPair.dom]
    --     apply Or.inr
    --     assumption
    --   }
    --   {

    --     sorry
    --   }
    -- case right =>
    --   simp [ListPair.dom] at dd1
    --   cases dd1 with | intro dd1l dd1r =>
    --   intro x h
    --   apply ih dd1r
    --   simp [*]

#print List.concat


lemma Subtyping.Static.skoelms_subseteq skolems assums l r skolems' assums' :
  Subtyping.Static skolems assums l r skolems' assums' →
  skolems ⊆ skolems'
:= by sorry


mutual
  theorem ListSubtyping.soundness skolems assums cs skolems' assums' :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
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
    exists (am1 ++ am0)
    simp [*]
    apply And.intro
    {
      apply dom_concat_concat_subseteq _ _ _ skolems_im
      · exact Subtyping.Static.skoelms_subseteq skolems assums l r skolems_im assums_im ss
      · sorry
      · sorry
      · simp [*]
    }
    {
      intro am' msd0
      simp [MultiSubtyping.Dynamic]
      apply And.intro
      {
        sorry
      }
      {
        sorry
      }
    }

  theorem Subtyping.soundness skolems assums lower upper skolems' assums' :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.diff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper
    )
  := by sorry

end
