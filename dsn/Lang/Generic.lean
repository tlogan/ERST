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

lemma mdiff_concat_containment (xs ys zs : List String) :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs ys
:= by sorry


#print List.eq_nil_of_subset_nil
lemma mdiff_decreasing_containment (xs ys zs : List String) :
ys ⊆ zs → List.mdiff xs zs ⊆ List.mdiff xs ys
:= by
  intro ss
  intro x dz
  apply mdiff_concat_containment xs ys zs
  rw [← mdiff_concat_eq] <;> assumption


lemma merase_mem x y (zs : List String) :
y ∈ zs → x ≠ y → y ∈ List.merase x zs
:= by sorry


lemma merase_containment x (ys zs : List String) :
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

lemma mdiff_increasing_containment (xs : List String) :
  ∀ ys zs, ys ⊆ zs → List.mdiff ys xs ⊆ List.mdiff zs xs
:= by induction xs with
  | nil =>
    simp [List.mdiff]
  | cons x xs ih =>
    intro ys zs ss
    simp [List.mdiff]
    apply ih
    apply merase_containment
    assumption


lemma dom_concat_mdiff_containment {β} (am0 am1 : List (String × β)) xs xs_im xs' :
  xs ⊆ xs_im → ListPair.dom am0 ⊆ List.mdiff xs_im xs →
  xs_im ⊆ xs' → ListPair.dom am1 ⊆ List.mdiff xs' xs_im →
  ListPair.dom (am1 ++ am0) ⊆ List.mdiff xs' xs
:= by
  intros ss0 dd0 ss1 dd1
  induction am1 with
  | nil =>
    simp [*]
    have ss1' : List.mdiff xs_im xs ⊆ List.mdiff xs' xs := by
      apply mdiff_increasing_containment; simp [*]
    intro x p
    apply ss1'
    apply dd0
    simp [*]
  |cons a am1' ih =>
    let (x, v) := a
    simp [ListPair.dom]
    apply And.intro
    {
      apply mdiff_decreasing_containment xs' xs xs_im ss0
      apply dd1
      simp [ListPair.dom]
    }
    {
      apply ih
      intro y1 p1
      apply dd1
      simp [ListPair.dom]
      apply Or.inr
      assumption
    }


lemma Subtyping.Dynamic.dom_extension am1 am0 lower upper :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping.Dynamic am0 lower upper →
  Subtyping.Dynamic (am1 ++ am0) lower upper
:= by sorry

lemma MultiSubtyping.Dynamic.dom_reduction am1 am0 cs :
  (ListPair.dom am1) ∩ ListSubtyping.free_vars cs = [] →
  MultiSubtyping.Dynamic (am1 ++ am0) cs →
  MultiSubtyping.Dynamic am0 cs
:= by sorry

lemma MultiSubtyping.Dynamic.reduction am cs cs' :
  cs ⊆ cs' →
  MultiSubtyping.Dynamic am cs'  →
  MultiSubtyping.Dynamic am cs
:= by sorry

lemma List.cons_containment {α} [BEq α] (x : α) (xs ys : List α) :
  x :: xs  ⊆ ys → x ∈ ys ∧ xs ⊆ ys
:= by
  intro p0
  apply And.intro
  {
    apply p0
    simp [*]
  }
  {
    intro y p1
    apply p0
    simp [*]
  }

#print List.inter

set_option pp.notation false in
#check (1 :: [1,2,3]) ∩ [4] = []

lemma List.disjoint_preservation {α} [BEq α] (xs ys zs : List α) :
  ys ∩ zs = [] → xs ⊆ ys → xs ∩ zs = []
:= by
  simp [Inter.inter, List.inter]
  intro p0
  induction xs with
  | nil =>
    intro p1; intro a;
    intro p2
    cases p2
  | cons x xs' ih =>
    intro p1
    have ⟨p2, p3⟩ := List.cons_containment x xs' ys p1
    intro a
    intro p4
    cases p4 with
    | head =>
      exact p0 x p2
    | tail _ p5 =>
      apply ih p3
      apply p5


lemma Subtyping.Static.assums_skolems_freshness skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = []
:= by sorry

lemma Subtyping.Static.lower_skolems_freshness skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  (List.mdiff skolems' skolems) ∩ Typ.free_vars lower = []
:= by sorry

lemma Subtyping.Static.upper_skolems_freshness skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  (List.mdiff skolems' skolems) ∩ Typ.free_vars upper = []
:= by sorry


lemma Subtyping.Static.skolems_containment skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  skolems ⊆ skolems'
:= by sorry

lemma Subtyping.Static.assums_containment skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  assums ⊆ assums'
:= by sorry

lemma Subtyping.Static.lower_containment skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums'
:= by sorry

lemma Subtyping.Static.upper_containment skolems assums lower upper skolems' assums' :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums'
:= by sorry

lemma ListSubtyping.Static.assums_containment skolems assums cs skolems' assums' :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  assums ⊆ assums'
:= by sorry

lemma ListSubtyping.Static.conclusions_containment skolems assums cs skolems' assums' :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  ListSubtyping.free_vars cs ⊆ ListSubtyping.free_vars assums'
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
    have ⟨am0,⟨h0l, h0r⟩⟩ := Subtyping.soundness skolems assums l r skolems_im assums_im ss
    have ⟨am1,⟨h1l, h1r⟩⟩ := ListSubtyping.soundness skolems_im assums_im cs' skolems' assums' lss
    exists (am1 ++ am0)
    simp [*]
    apply And.intro
    {
      apply dom_concat_mdiff_containment _ _ _ skolems_im
      · exact Subtyping.Static.skolems_containment skolems assums l r skolems_im assums_im ss
      · sorry
      · sorry
      · simp [*]
    }
    {
      intro am' p0
      simp [MultiSubtyping.Dynamic]
      apply And.intro
      {
        -- TODO: create lemmas with various properties of subtyping static params
        have p1 : (ListPair.dom am0) ∩ Typ.free_vars l = [] := by
          apply List.disjoint_preservation (ListPair.dom am0) _ (Typ.free_vars l) _ h0l
          apply Subtyping.Static.lower_skolems_freshness skolems assums l r skolems_im assums_im
          apply ss
        have p2 : (ListPair.dom am1) ∩ Typ.free_vars r = [] := by sorry
        apply Subtyping.Dynamic.dom_extension am1 (am0 ++ am') l r p1 p2
        apply h0r am'
        have p3 : assums_im ⊆ assums' := by
          exact ListSubtyping.Static.assums_containment
            skolems_im assums_im cs' skolems' assums' lss
        apply MultiSubtyping.Dynamic.reduction _ assums_im assums' p3
        have p4 : (ListPair.dom am1) ∩ ListSubtyping.free_vars assums' = [] := by sorry
        exact MultiSubtyping.Dynamic.dom_reduction am1 (am0 ++ am') assums' p4 p0
      }
      {
        sorry
      }
    }

  theorem Subtyping.soundness skolems assums lower upper skolems' assums' :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper
    )
  := by sorry

end
