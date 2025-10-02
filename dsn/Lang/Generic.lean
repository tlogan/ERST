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


lemma mdiff_right_sub_cons_eq y {xs ys : List String}:
  y ∈ ys → List.mdiff xs ys = List.mdiff xs (y :: ys)
:= by sorry

lemma mdiff_concat_eq {xs ys zs : List String} :
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

lemma mdiff_concat_containment {xs ys zs : List String} :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs ys
:= by sorry


#print List.eq_nil_of_subset_nil
lemma mdiff_decreasing_containment {xs ys zs : List String} :
ys ⊆ zs → List.mdiff xs zs ⊆ List.mdiff xs ys
:= by
  intro ss
  intro x dz
  apply mdiff_concat_containment
  rw [← mdiff_concat_eq] <;> assumption


lemma merase_mem x y (zs : List String) :
y ∈ zs → x ≠ y → y ∈ List.merase x zs
:= by sorry


lemma merase_containment x {ys zs : List String} :
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

lemma mdiff_increasing_containment {xs : List String} :
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


lemma dom_concat_mdiff_containment {β} {am0 am1 : List (String × β)} {xs xs_im xs'} :
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
      apply mdiff_decreasing_containment ss0
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


lemma Subtyping.Dynamic.dom_extension {am1 am0 lower upper} :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping.Dynamic am0 lower upper →
  Subtyping.Dynamic (am1 ++ am0) lower upper
:= by sorry

lemma MultiSubtyping.Dynamic.dom_extension {am1 am0 cs} :
  (ListPair.dom am1) ∩ ListSubtyping.free_vars cs = [] →
  MultiSubtyping.Dynamic am0 cs →
  MultiSubtyping.Dynamic (am1 ++ am0) cs
:= by sorry

lemma MultiSubtyping.Dynamic.dom_reduction {am1 am0 cs} :
  (ListPair.dom am1) ∩ ListSubtyping.free_vars cs = [] →
  MultiSubtyping.Dynamic (am1 ++ am0) cs →
  MultiSubtyping.Dynamic am0 cs
:= by sorry

lemma MultiSubtyping.Dynamic.reduction {am cs cs'} :
  cs ⊆ cs' →
  MultiSubtyping.Dynamic am cs'  →
  MultiSubtyping.Dynamic am cs
:= by sorry

lemma List.cons_containment {α} [BEq α] {x : α} {xs ys : List α} :
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

lemma List.disjoint_preservation_left {α} [BEq α] {xs ys zs : List α} :
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
    have ⟨p2, p3⟩ := List.cons_containment p1
    intro a
    intro p4
    cases p4 with
    | head =>
      exact p0 x p2
    | tail _ p5 =>
      apply ih p3
      apply p5

lemma List.disjoint_preservation_right {α} [BEq α] {xs ys zs : List α} :
  xs ∩ zs = [] → ys ⊆ zs → xs ∩ ys = []
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
    sorry



lemma ListSubtyping.Static.attributes {skolems assums cs skolems' assums'} :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListSubtyping.free_vars cs ⊆ ListSubtyping.free_vars assums' ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars cs = []
:= by sorry

lemma Subtyping.Static.attributes {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums' ∧
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars lower = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars upper = []
:= by sorry

lemma ListSubtyping.free_vars_containment {xs ys : List (Typ × Typ)} :
  xs ⊆ ys → ListSubtyping.free_vars xs ⊆ ListSubtyping.free_vars ys
:= by sorry

lemma Subtyping.Static.upper_containment {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'
:= by
  intro h
  have ⟨p0, p1, p2, p3,_,_,_⟩ := Subtyping.Static.attributes h
  apply p3

#eval Typ.toBruijn 0 [] (Typ.var "hello")
lemma Typ.bruijn_var_eq {idl idu} :
  Typ.toBruijn 0 [] (Typ.var idl) = Typ.toBruijn 0 [] (Typ.var idu)
  →
  idl = idu
:= by sorry

-- lemma Typ.bruijn_var_eq {idl idu} :
--   Typ.toBruijn 0 [] (Typ.var idl) = Typ.toBruijn 0 [] (Typ.var idu)
-- := by sorry


lemma Subtyping.refl_dynamic {am t} :
  Subtyping.Dynamic am t t
:= by sorry


lemma Subtyping.Dynamic.entry_pres {am l bodyl bodyu} :
  Subtyping.Dynamic am bodyl bodyu →
  Subtyping.Dynamic am (Typ.entry l bodyl) (Typ.entry l bodyu)
:= by sorry

lemma Subtyping.Dynamic.path_pres {am p q x y} :
  Subtyping.Dynamic am x p →
  Subtyping.Dynamic am q y →
  Subtyping.Dynamic am (Typ.path p q) (Typ.path x y)
:= by sorry

mutual

  lemma Subtyping.bruijn_eq_imp_dynamic {am} :
    ∀ {lower upper},
    Typ.toBruijn 0 [] lower = Typ.toBruijn 0 [] upper →
    Subtyping.Dynamic am lower upper
  := fun {lower upper} => match lower with
    | .var idl => by
      cases upper with
      | var idu =>
        intro p0
        apply Typ.bruijn_var_eq at p0
        simp [*]
        exact refl_dynamic
      | _ =>
        simp [Typ.toBruijn, List.firstIndexOf]
        have d : Decidable (0 < List.length (List.indexesOf idl [])) := inferInstance
        cases d <;> simp [*]
    | .unit => by
      cases upper with
      | unit =>
        simp [Typ.toBruijn]
        exact refl_dynamic
      | var id =>
        simp [Typ.toBruijn, List.firstIndexOf]
        have d : Decidable (0 < List.length (List.indexesOf id [])) := inferInstance
        cases d <;> simp [*]
      | _ =>
        simp [Typ.toBruijn]
    | .entry ll bodyl => by
      cases upper with
      | entry lu bodyu =>
        simp [Typ.toBruijn]
        intro p0 p1
        simp [*]
        apply Subtyping.Dynamic.entry_pres
        apply Subtyping.bruijn_eq_imp_dynamic p1
      | var id =>
        simp [Typ.toBruijn, List.firstIndexOf]
        have d : Decidable (0 < List.length (List.indexesOf id [])) := inferInstance
        cases d <;> simp [*]
      | _ =>
        simp [Typ.toBruijn]
    | .path p q => by
      cases upper with
      | path x y =>
        simp [Typ.toBruijn]
        intro p0 p1
        apply Subtyping.Dynamic.path_pres
        apply Subtyping.bruijn_eq_imp_dynamic (Eq.symm p0)
        apply Subtyping.bruijn_eq_imp_dynamic p1
      | var id =>
        simp [Typ.toBruijn, List.firstIndexOf]
        have d : Decidable (0 < List.length (List.indexesOf id [])) := inferInstance
        cases d <;> simp [*]
      | _ =>
        simp [Typ.toBruijn]
    -- | path : Typ → Typ → Typ
    -- | bot :  Typ
    -- | top :  Typ
    -- | unio :  Typ → Typ → Typ
    -- | inter :  Typ → Typ → Typ
    -- | diff :  Typ → Typ → Typ
    -- | all :  List String → List (Typ × Typ) → Typ → Typ
    -- | exi :  List String → List (Typ × Typ) → Typ → Typ
    -- | lfp :  String → Typ → Typ
    | _ => by sorry
end



mutual
  theorem ListSubtyping.soundness {skolems assums cs skolems' assums'} :
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
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.soundness ss
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.soundness lss
    have ⟨p0,p1,p2,p3,p4,p5,p6⟩ := Subtyping.Static.attributes ss
    have ⟨p7,p8,p9,p10,p11⟩ := ListSubtyping.Static.attributes lss
    exists (am1 ++ am0)
    simp [*]
    apply And.intro
    · exact dom_concat_mdiff_containment p0 ih0l p7 ih1l
    · {
      intro am' p12
      simp [MultiSubtyping.Dynamic]
      apply And.intro
      · {
        apply Subtyping.Dynamic.dom_extension
        · {
          apply List.disjoint_preservation_left _ ih1l
          apply List.disjoint_preservation_right _ p2
          apply p10
        }
        · {
          apply List.disjoint_preservation_left _ ih1l
          apply List.disjoint_preservation_right _ p3
          apply p10
        }
        · {
          apply ih0r
          apply MultiSubtyping.Dynamic.dom_reduction
          · exact List.disjoint_preservation_left p10 ih1l
          · exact MultiSubtyping.Dynamic.reduction p8 p12
        }
      }
      · exact ih1r (am0 ++ am') p12
    }

  theorem Subtyping.soundness {skolems assums lower upper skolems' assums'} :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper
    )
  | .refl p0 => by
    exists []
    simp [*]
    apply And.intro
    · simp [ListPair.dom]
    · {
      intros am p1
      exact Subtyping.bruijn_eq_imp_dynamic p0
    }
  -- | rename_right skolems assums left right right' skolems' assums' :
  -- | entry_pres skolems assums l left right skolems' assums' :
  -- | path_pres skolems assums p q  skolems' assums' x y skolems'' assums'' :
  -- | bot_elim skolems assums t :
  -- | top_intro skolems assums t :
  -- | unio_elim skolems assums a t b skolems' assums' skolems'' assums'' :
  -- | exi_elim skolems assums ids quals body t skolems' assums' skolems'' assums'' :
  -- | inter_intro skolems assums t a  b skolems' assums' skolems'' assums'' :
  -- | all_intro skolems assums ids quals body t skolems' assums' skolems'' assums'' :
  -- | placeholder_elim skolems assums id t trans skolems' assums'  :
  -- | placeholder_intro skolems assums t id trans skolems' assums'  :
  -- | skolem_placeholder_intro skolems assums t id trans skolems' assums'  :
  -- | skolem_intro skolems assums t id t' skolems' assums'  :
  -- | skolem_placeholder_elim skolems assums id t trans skolems' assums'  :
  -- | skolem_elim skolems assums id t t' skolems' assums' :
  -- | unio_antec skolems assums l a b r skolems' assums' :
  -- | inter_conseq skolems assums l a b r skolems' assums' :
  -- | inter_entry skolems assums t l a b skolems' assums' :
  -- | lfp_skip_elim skolems assums id left right skolems' assums' :
  -- | lfp_induct_elim skolems assums id left right skolems' assums' :
  -- | lfp_factor_elim skolems assums id left l right fac skolems' assums' :
  -- | lfp_elim_diff_intro skolems assums id t l r h skolems' assums' :
  -- | diff_intro skolems assums t l r skolems' assums' :
  -- | lfp_inflate_intro skolems assums l id r skolems' assums' :
  -- | lfp_drop_intro skolems assums l id r r' skolems' assums' :
  -- | diff_elim skolems assums l r t skolems' assums' :
  -- | unio_left_intro skolems assums t l r skolems' assums' :
  -- | unio_right_intro skolems assums t l r skolems' assums' :
  -- | exi_intro skolems assums l ids quals r skolems' assums' skolems'' assums'' :
  -- | inter_left_elim skolems assums l r t skolems' assums' :
  -- | inter_right_elim skolems assums l r t skolems' assums' :
  -- | all_elim skolems assums ids quals l r skolems' assums' skolems'' assums'' :
  | _ => by sorry

end
