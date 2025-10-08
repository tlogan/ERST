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


lemma mdiff_right_sub_cons_eq y {xs ys : List String} :
  y ∈ ys → List.mdiff xs ys = List.mdiff xs (y :: ys)
:= by sorry

lemma mdiff_left_sub_refl_disjoint {xs ys : List String} :
  List.mdiff xs ys ∩ ys = []
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

lemma mdiff_concat_containment_left {xs ys zs : List String} :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs ys
:= by sorry

lemma mdiff_concat_containment_right {xs ys zs : List String} :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs zs
:= by sorry


lemma concat_right_containment {xs ys zs : List String} :
  (xs ++ ys) ⊆ zs → ys ⊆ zs
:= by
  intro p0
  intro a p1
  apply p0
  exact List.mem_append_right xs p1


lemma mdiff_decreasing_containment {xs ys zs : List String} :
ys ⊆ zs → List.mdiff xs zs ⊆ List.mdiff xs ys
:= by
  intro ss
  intro x dz
  apply mdiff_concat_containment_left
  rw [← mdiff_concat_eq] <;> assumption


lemma merase_mem x y (zs : List String) :
y ∈ zs → x ≠ y → y ∈ List.merase x zs
:= by sorry


lemma merase_containment x {ys zs : List String} :
 ys ⊆ zs → List.merase x ys ⊆ List.merase x zs
:= by
  induction ys with
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
      intro y' p2
      apply ih p1 p2

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
  xs ⊆ ys → ys ∩ zs = [] → xs ∩ zs = []
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
    have ⟨p2, p3⟩ := List.cons_containment p0
    intro a
    intro p4
    cases p4 with
    | head =>
      exact p1 x p2
    | tail _ p5 =>
      apply ih p3 p1
      exact p5

lemma List.disjoint_preservation_right {α} [BEq α] {xs ys zs : List α} :
  ys ⊆ zs → xs ∩ zs = [] → xs ∩ ys = []
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

lemma List.disjoint_concat_right {α} [BEq α] {xs ys zs : List α} :
  xs ∩ (ys ++ zs) = [] → xs ∩ ys = [] ∧ xs ∩ zs = []
:= by sorry



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


lemma Subtyping.Dynamic.refl am t :
  Subtyping.Dynamic am t t
:= by sorry


lemma Subtyping.Dynamic.entry_pres {am bodyl bodyu} l :
  Subtyping.Dynamic am bodyl bodyu →
  Subtyping.Dynamic am (Typ.entry l bodyl) (Typ.entry l bodyu)
:= by sorry

lemma Subtyping.Dynamic.path_pres {am p q x y} :
  Subtyping.Dynamic am x p →
  Subtyping.Dynamic am q y →
  Subtyping.Dynamic am (Typ.path p q) (Typ.path x y)
:= by sorry


lemma Subtyping.Dynamic.unio_left_intro {am t left right} :
  Subtyping.Dynamic am t left →
  Subtyping.Dynamic am t (Typ.unio left right)
:= by sorry

lemma Subtyping.Dynamic.unio_right_intro {am t left right} :
  Subtyping.Dynamic am t right →
  Subtyping.Dynamic am t (Typ.unio left right)
:= by sorry

lemma Subtyping.Dynamic.unio_elim {am left right t} :
  Subtyping.Dynamic am left t →
  Subtyping.Dynamic am right t →
  Subtyping.Dynamic am (Typ.unio left right) t
:= by sorry




lemma Subtyping.Dynamic.inter_left_elim {am left right t} :
  Subtyping.Dynamic am left t →
  Subtyping.Dynamic am (Typ.inter left right) t
:= by sorry

lemma Subtyping.Dynamic.inter_right_elim {am left right t} :
  Subtyping.Dynamic am right t →
  Subtyping.Dynamic am (Typ.inter left right) t
:= by sorry

lemma Subtyping.Dynamic.inter_intro {am t left right} :
  Subtyping.Dynamic am t left →
  Subtyping.Dynamic am t right →
  Subtyping.Dynamic am t (Typ.inter left right)
:= by sorry



lemma Subtyping.Dynamic.diff_elim {am left right t} :
  Subtyping.Dynamic am left (Typ.unio t right) →
  Subtyping.Dynamic am (Typ.diff left right) t
:= by sorry

lemma Subtyping.Dynamic.diff_intro {am t left right} :
  Subtyping.Dynamic am t left →
  ¬ (Subtyping.Dynamic am t right) →
  ¬ (Subtyping.Dynamic am right t) →
  Subtyping.Dynamic am t (Typ.diff left right)
:= by sorry


lemma Subtyping.Dynamic.not_diff_elim {am t0 t1 t2} :
  Typ.toBruijn [] t1 = Typ.toBruijn [] t2 →
  ¬ Dynamic am (Typ.diff t0 t1) t2
:= by sorry

lemma Subtyping.Dynamic.not_diff_intro {am t0 t1 t2} :
  Typ.toBruijn [] t0 = Typ.toBruijn [] t2 →
  ¬ Dynamic am t0 (Typ.diff t1 t2)
:= by sorry


lemma Subtyping.Dynamic.exi_intro {am am' t ids quals body} :
  ListPair.dom am' ⊆ ids →
  Subtyping.Dynamic (am' ++ am) t body →
  MultiSubtyping.Dynamic (am' ++ am) quals →
  Subtyping.Dynamic am t (Typ.exi ids quals body)
:= by sorry

lemma Subtyping.Dynamic.exi_elim {am ids quals body t} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping.Dynamic (am' ++ am) quals →
    Subtyping.Dynamic (am' ++ am) body t
  ) →
  Subtyping.Dynamic am (Typ.exi ids quals body) t
:= by sorry


lemma Subtyping.Dynamic.all_elim {am am' ids quals body t} :
  ListPair.dom am' ⊆ ids →
  Subtyping.Dynamic (am' ++ am) body t →
  MultiSubtyping.Dynamic (am' ++ am) quals →
  Subtyping.Dynamic am (Typ.all ids quals body) t
:= by sorry

lemma Subtyping.Dynamic.all_intro {am t ids quals body} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping.Dynamic (am' ++ am) quals →
    Subtyping.Dynamic (am' ++ am) t body
  ) →
  Subtyping.Dynamic am t (Typ.all ids quals body)
:= by sorry

lemma Subtyping.Dynamic.lfp_intro {am t id body} :
  Typ.Monotonic id true body →
  Subtyping.Dynamic ((id, (Typ.lfp id body)) :: am) t body →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

lemma Subtyping.Dynamic.lfp_elim {am id body t} :
  Typ.Monotonic id true body →
  id ∉ Typ.free_vars t →
  Subtyping.Dynamic ((id, t) :: am) t body →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry


lemma Subtyping.Dynamic.rename_lower {am lower lower' upper} :
  Typ.toBruijn [] lower = Typ.toBruijn [] lower' →
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am lower' upper
:= by sorry

lemma Subtyping.Dynamic.rename_upper {am lower upper upper'} :
  Typ.toBruijn [] upper = Typ.toBruijn [] upper' →
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am lower upper'
:= by sorry

lemma Subtyping.Dynamic.bot_elim {am upper} :
  Subtyping.Dynamic am Typ.bot upper
:= by sorry

lemma Subtyping.Dynamic.top_intro {am lower} :
  Subtyping.Dynamic am lower Typ.top
:= by sorry


lemma fresh_ids n (ignore : List String) :
  ∃ ids , ids.length = n ∧ ids ∩ ignore = []
:= by sorry
-- TODO: concat all the existing strings together and add numbers

lemma fresh_id (ignore : List String) :
  ∃ id ,id ∉ ignore
:= by sorry


lemma Typ.all_rename {ids' ids} quals body :
  ids'.length = ids.length →
  ∃ quals' body',
  Typ.toBruijn [] (Typ.all ids' quals' body') = Typ.toBruijn [] (Typ.all ids quals body)
:= by sorry
-- TODO: construct subbing map and sub in

lemma Typ.exi_rename {ids' ids} quals body :
  ids'.length = ids.length →
  ∃ quals' body',
  Typ.toBruijn [] (Typ.exi ids' quals' body') = Typ.toBruijn [] (Typ.exi ids quals body)
:= by sorry

lemma Typ.lfp_rename id' id body :
  ∃ body',
  Typ.toBruijn [] (Typ.lfp id' body') = Typ.toBruijn [] (Typ.lfp id body)
:= by sorry

  -- lemma ListSubtyping.bruijn_eq_imp_dynamic {am} :
  --   ∀ {lower upper},
  --   ListSubtyping.toBruijn 0 [] lower = ListSubtyping.toBruijn 0 [] upper →
  --   MultiSubtyping.Dynamic am lower →
  --   MultiSubtyping.Dynamic am upper
  -- := by sorry

lemma Subtyping.Dynamic.bruijn_eq {lower upper} am :
  Typ.toBruijn [] lower = Typ.toBruijn [] upper →
  Subtyping.Dynamic am lower upper
:= by
  intro p0
  apply Subtyping.Dynamic.rename_upper p0
  apply Subtyping.Dynamic.refl am lower



lemma ListSubtyping.toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  ListSubtyping.toBruijn ids' quals' = ListSubtyping.toBruijn ids quals
:= by sorry

lemma Typ.toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  Typ.toBruijn ids' body' = Typ.toBruijn ids body
:= by sorry


lemma ListSubtyping.restricted_rename {skolems assums ids quals ids' quals'} :
  ListSubtyping.toBruijn ids quals = ListSubtyping.toBruijn ids' quals' →
  ListSubtyping.restricted skolems assums quals →
  ListSubtyping.restricted skolems assums quals'
:= by sorry


lemma ListSubtyping.solution_completeness {skolems assums cs skolems' assums' am am'} :
  ListSubtyping.restricted skolems assums cs →
  ListSubtyping.Static skolems assums cs skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  MultiSubtyping.Dynamic (am' ++ am) cs →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry


lemma List.disjoint_swap {α} [BEq α] {xs ys : List α} :
  xs ∩ ys = [] → ys ∩ xs = []
:= by sorry

lemma ListSubtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' cs} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  MultiSubtyping.Dynamic (am ++ (am' ++ am'')) cs →
  MultiSubtyping.Dynamic (am' ++ (am ++ am'')) cs
:= by sorry

lemma Subtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' lower upper} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  Subtyping.Dynamic (am ++ (am' ++ am'')) lower upper →
  Subtyping.Dynamic (am' ++ (am ++ am'')) lower upper
:= by sorry

lemma Subtyping.assumptions_independence
  {skolems assums lower upper skolems' assums' am am'}
:
  Subtyping.Static skolems assums lower upper skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  ListPair.dom am' ⊆ ListSubtyping.free_vars assums →
  MultiSubtyping.Dynamic (am' ++ am) assums →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry

mutual
  theorem ListSubtyping.soundness {skolems assums cs skolems' assums'} :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
    (∀ {am'},
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
    { exact dom_concat_mdiff_containment p0 ih0l p7 ih1l }
    { intro am' p12
      simp [MultiSubtyping.Dynamic]
      apply And.intro
      { apply Subtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p2
          apply p10 }
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p3
          apply p10 }
        { apply ih0r
          apply MultiSubtyping.Dynamic.dom_reduction
          { apply List.disjoint_preservation_left ih1l p10 }
          { apply MultiSubtyping.Dynamic.reduction p8 p12 } } }
      { exact ih1r p12 }
    }


  theorem Subtyping.soundness {skolems assums lower upper skolems' assums'} :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper)
  | .refl skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro (by simp [ListPair.dom])
    intros am0 p1
    exact Subtyping.Dynamic.refl am0 t

  | .entry_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.entry_pres l (ih0r p9)

  | .path_pres lower0 lower1 upper0 upper1 skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.path_pres
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }
  | .bot_elim skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.Dynamic.bot_elim

  | .top_intro skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.Dynamic.top_intro

  | .unio_elim left right t skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.unio_elim
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .exi_elim ids quals body t skolems0 assums0 p0 p4 p5 p1 p2 => by

    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.attributes p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.attributes p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_mdiff_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply mdiff_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.Dynamic.exi_elim p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply mdiff_concat_containment_left
        apply mdiff_left_sub_refl_disjoint

      apply Subtyping.Dynamic.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.Dynamic.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.Dynamic.reduction p18 p24) p26 } }

  | .inter_intro t left right skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.inter_intro
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .all_intro t ids quals body skolems0 assums0 p0 p4 p5 p1 p2 => by
    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.attributes p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.attributes p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_mdiff_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply mdiff_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.Dynamic.all_intro p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply mdiff_concat_containment_left
        apply mdiff_left_sub_refl_disjoint

      apply Subtyping.Dynamic.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.Dynamic.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.Dynamic.reduction p18 p24) p26 } }

  | .placeholder_elim id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .placeholder_intro id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  -- | skolem_placeholder_intro skolems assums t id trans skolems' assums'  :
  -- | skolem_intro skolems assums t id t' skolems' assums'  :
  -- | skolem_placeholder_elim skolems assums id t trans skolems' assums'  :
  -- | skolem_elim skolems assums id t t' skolems' assums' :
  -------------------------------------------------------------------
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


--------------------------------------------------------------------
    -- have ⟨ids', p3, p4⟩ := fresh_ids (ids.length) (
    --     (skolems ++ ListSubtyping.free_vars assums) ++
    --     (skolems0 ++ ListSubtyping.free_vars assums0) ++
    --     (skolems' ++ ListSubtyping.free_vars assums') ++
    --     Typ.free_vars t
    -- )
    -- -- TODO: need to rename assums0 to assums0' and assums' to assums''
    -- have ⟨quals', body', p5⟩ := Typ.exi_rename quals body p3
    -- have p6 := ListSubtyping.toBruijn_exi_injection p5
    -- have p7 := Typ.toBruijn_exi_injection p5
    -- have ⟨p8,p9⟩ := List.disjoint_concat_right p4
    -- have ⟨p10,p11⟩ := List.disjoint_concat_right p8
    -- have ⟨p30,p31⟩ := List.disjoint_concat_right p10
    -- have ⟨p40,p41⟩ := List.disjoint_concat_right p11

    -- have p0 := ListSubtyping.restricted_rename (Eq.symm p6) p0
    -- have p1 := ListSubtyping.Static.rename_drop p30 (Eq.symm p6) p1
    -- have p2 := Subtyping.Static.rename_skolems_lower  _ _ p31 (Eq.symm p7) p2

    -----------------------------------------------------
