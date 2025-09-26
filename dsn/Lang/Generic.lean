import Lang.Util
import Lang.Basic
import Lang.Static
import Lang.Dynamic

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

lemma diff_preservation (xs : List String) :
  ∀ xs0 xs1, xs0 ⊆ xs1 → List.diff xs0 xs ⊆ List.diff xs1 xs
:= by
  induction xs with
  | nil =>
    simp [List.diff]
  | cons x xs ih =>
    intro xs0 xs1 ss
    -- apply ih at ss
    simp [List.diff]
    have d0 : Decidable (x ∈ xs0) := inferInstance
    cases d0 with
    | isFalse h0 =>
      have d1 : Decidable (x ∈ xs1) := inferInstance
      cases d1 with
      | isFalse h1 => simp [*]
      | isTrue h1 =>
        simp [*]
        have h2 : xs0 ⊆ (List.erase xs1 x) := by
          exact erase_introduction xs0 xs1 ss x h0 h1
        simp [*]
    | isTrue h0 =>
      simp [*]
      have h1 : x ∈ xs1 := by apply ss; simp [*]
      simp [*]
      apply ih
      exact erase_preservation xs0 xs1 ss x h0 (ss h0)


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
    sorry
  |cons head tail ih =>
    sorry

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
