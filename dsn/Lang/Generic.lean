import Lang.Util
import Lang.Basic
import Lang.Static
import Lang.Dynamic


-- import Std.Data.List.Basic
-- import Std.Data.List.Lemmas

set_option pp.fieldNotation false




theorem ListPair.mem_concat_disj {β}
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

theorem ListPair.mem_disj_concat_left {β}
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

theorem ListPair.mem_disj_concat_right {β}
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


theorem mdiff_refl {α} [BEq α] {xs ys : List α}:
   List.mdiff xs ys ⊆ xs
:= by sorry

theorem containment_mdiff_concat_elim {α} [BEq α] {xs ys : List α}:
   List.mdiff (xs ++ ys) ys ⊆ xs
:= by sorry

theorem containment_mdiff_union_elim {α} [BEq α] {xs ys : List α}:
   List.mdiff (xs ∪ ys) ys ⊆ xs
:= by sorry


theorem mdiff_right_sub_cons_eq y {xs ys : List String} :
  y ∈ ys → List.mdiff xs ys = List.mdiff xs (y :: ys)
:= by sorry

theorem mdiff_left_sub_refl_disjoint {xs ys : List String} :
  List.mdiff xs ys ∩ ys = []
:= by sorry



theorem MultiSubtyping.Dynamic.mdiff_union {tam cs' cs} :
  MultiSubtyping.Dynamic tam (List.mdiff cs' cs ∪ cs) →
  MultiSubtyping.Dynamic tam cs'
:= by sorry


theorem mdiff_concat_eq {xs ys zs : List String} :
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

theorem mdiff_concat_containment_left {xs ys zs : List String} :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs ys
:= by sorry

theorem mdiff_concat_containment_right {xs ys zs : List String} :
  List.mdiff xs (ys ++ zs) ⊆ List.mdiff xs zs
:= by sorry


theorem concat_right_containment {xs ys zs : List String} :
  (xs ++ ys) ⊆ zs → ys ⊆ zs
:= by
  intro p0
  intro a p1
  apply p0
  exact List.mem_append_right xs p1


theorem mdiff_decreasing_containment {xs ys zs : List String} :
ys ⊆ zs → List.mdiff xs zs ⊆ List.mdiff xs ys
:= by
  intro ss
  intro x dz
  apply mdiff_concat_containment_left
  rw [← mdiff_concat_eq] <;> assumption


theorem merase_mem x y (zs : List String) :
y ∈ zs → x ≠ y → y ∈ List.merase x zs
:= by sorry

theorem merase_containment x {ys zs : List String} :
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

theorem mdiff_increasing_containment {xs : List String} :
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


theorem dom_concat_mdiff_containment {β} {am0 am1 : List (String × β)} {xs xs_im xs'} :
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


theorem Typing.Dynamic.dom_reduction {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing.Dynamic (tam1 ++ tam0) e t →
  Typing.Dynamic tam0 e t
:= by sorry

theorem Typing.Dynamic.dom_extension {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing.Dynamic tam0 e t →
  Typing.Dynamic (tam1 ++ tam0) e t
:= by sorry

theorem Typing.Dynamic.dom_single_extension {id am e t t'} :
  id ∉ Typ.free_vars t →
  Typing.Dynamic am e t' →
  Typing.Dynamic ((id,t) :: am) e t'
:= by sorry


theorem MultiTyping.Dynamic.dom_reduction {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping.Dynamic (tam1 ++ tam0) eam cs →
  MultiTyping.Dynamic tam0 eam cs
:= by sorry


theorem MultiTyping.Dynamic.dom_extension {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping.Dynamic tam0 eam cs →
  MultiTyping.Dynamic (tam1 ++ tam0) eam cs
:= by sorry

theorem MultiTyping.Dynamic.dom_context_extension {tam eam cs} :
  MultiTyping.Dynamic tam eam cs →
  ∀ eam', MultiTyping.Dynamic tam (eam ++ eam') cs
:= by sorry


theorem Subtyping.Dynamic.dom_extension {am1 am0 lower upper} :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping.Dynamic am0 lower upper →
  Subtyping.Dynamic (am1 ++ am0) lower upper
:= by sorry

theorem MultiSubtyping.Dynamic.dom_single_extension {id tam0 t cs} :
  id ∉ ListSubtyping.free_vars cs →
  MultiSubtyping.Dynamic tam0 cs →
  MultiSubtyping.Dynamic ((id,t) :: tam0) cs
:= by sorry

theorem MultiSubtyping.Dynamic.dom_extension {am1 am0 cs} :
  (ListPair.dom am1) ∩ ListSubtyping.free_vars cs = [] →
  MultiSubtyping.Dynamic am0 cs →
  MultiSubtyping.Dynamic (am1 ++ am0) cs
:= by sorry

theorem MultiSubtyping.Dynamic.dom_reduction {am1 am0 cs} :
  (ListPair.dom am1) ∩ ListSubtyping.free_vars cs = [] →
  MultiSubtyping.Dynamic (am1 ++ am0) cs →
  MultiSubtyping.Dynamic am0 cs
:= by sorry

theorem MultiSubtyping.Dynamic.reduction {am cs cs'} :
  cs ⊆ cs' →
  MultiSubtyping.Dynamic am cs'  →
  MultiSubtyping.Dynamic am cs
:= by sorry

theorem List.cons_containment {α} [BEq α] {x : α} {xs ys : List α} :
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

-- #print List.inter

#print decide

example {α} [DecidableEq α] (x : α) (xs : List α) :
  List.contains xs x =  decide (x ∈ xs)
:= by exact List.contains_eq_mem x xs


theorem List.not_mem_cons {α} [BEq α] {x x': α} {xs : List α} :
  x ∉ (x' :: xs) →
  x ≠ x' ∧ x ∉ xs
:= by intro p ; exact ne_and_not_mem_of_not_mem_cons p

-- set_option pp.notation false in
theorem List.nonmem_to_disjoint_right {α} [DecidableEq α] (x : α) (xs : List α) :
  x ∉ xs → xs ∩ [x] = []
:= by
  intro h
  induction xs with
  | nil => exact rfl
  | cons y ys ih =>
    simp [Inter.inter, List.inter]

    have ⟨l,r⟩ := ne_and_not_mem_of_not_mem_cons h
    apply And.intro
    { exact id (Ne.symm l) }
    { intros x'' p ; exact (ne_of_mem_of_not_mem p r) }


theorem List.disjoint_preservation_left {α} [BEq α] {xs ys zs : List α} :
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

theorem List.disjoint_preservation_right {α} [BEq α] {xs ys zs : List α} :
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

theorem List.disjoint_concat_right {α} [BEq α] {xs ys zs : List α} :
  xs ∩ (ys ++ zs) = [] → xs ∩ ys = [] ∧ xs ∩ zs = []
:= by sorry



theorem ListSubtyping.Static.aux {skolems assums cs skolems' assums'} :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListSubtyping.free_vars cs ⊆ ListSubtyping.free_vars assums' ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars cs = []
:= by sorry

theorem Subtyping.Static.aux {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums' ∧
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars lower = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars upper = []
:= by sorry

theorem Expr.Typing.Static.aux {skolems assums context e t skolems' assums'} :
  Expr.Typing.Static skolems assums context e t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem Function.Typing.Static.aux
  {skolems assums context f nested_zones subtras skolems' assums' t}
:
  Function.Typing.Static skolems assums context subtras f nested_zones →
  ⟨skolems',assums',t⟩ ∈ nested_zones.flatten →
  skolems' ∩ skolems = [] ∧
  skolems' ∩ ListSubtyping.free_vars assums = [] ∧
  skolems' ∩ ListTyping.free_vars context = [] ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums
:= by sorry

theorem Record.Typing.Static.aux
  {skolems assums context r t skolems' assums'}
:
  Record.Typing.Static skolems assums context r t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem ListSubtyping.free_vars_containment {xs ys : List (Typ × Typ)} :
  xs ⊆ ys → ListSubtyping.free_vars xs ⊆ ListSubtyping.free_vars ys
:= by sorry

theorem Subtyping.Static.upper_containment {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'
:= by
  intro h
  have ⟨p0, p1, p2, p3,_,_,_⟩ := Subtyping.Static.aux h
  apply p3


theorem Subtyping.Dynamic.refl am t :
  Subtyping.Dynamic am t t
:= by sorry

theorem Subtyping.Dynamic.unio_left_intro {am t l r} :
  Subtyping.Dynamic am t l →
  Subtyping.Dynamic am t (Typ.unio l r)
:= by sorry


theorem Subtyping.Dynamic.unio_right_intro {am t l r} :
  Subtyping.Dynamic am t r →
  Subtyping.Dynamic am t (Typ.unio l r)
:= by sorry

theorem Subtyping.Dynamic.inter_left_elim {am l r t} :
  Subtyping.Dynamic am l t →
  Subtyping.Dynamic am (Typ.inter l r) t
:= by sorry

theorem Subtyping.Dynamic.inter_right_elim {am l r t} :
  Subtyping.Dynamic am r t →
  Subtyping.Dynamic am (Typ.inter l r) t
:= by sorry


theorem Subtyping.Dynamic.iso_pres {am bodyl bodyu} l :
  Subtyping.Dynamic am bodyl bodyu →
  Subtyping.Dynamic am (Typ.iso l bodyl) (Typ.iso l bodyu)
:= by sorry

theorem Subtyping.Dynamic.entry_pres {am bodyl bodyu} l :
  Subtyping.Dynamic am bodyl bodyu →
  Subtyping.Dynamic am (Typ.entry l bodyl) (Typ.entry l bodyu)
:= by sorry

theorem Subtyping.Dynamic.path_pres {am p q x y} :
  Subtyping.Dynamic am x p →
  Subtyping.Dynamic am q y →
  Subtyping.Dynamic am (Typ.path p q) (Typ.path x y)
:= by sorry


theorem Subtyping.Dynamic.unio_elim {am left right t} :
  Subtyping.Dynamic am left t →
  Subtyping.Dynamic am right t →
  Subtyping.Dynamic am (Typ.unio left right) t
:= by sorry


theorem Subtyping.Dynamic.inter_intro {am t left right} :
  Subtyping.Dynamic am t left →
  Subtyping.Dynamic am t right →
  Subtyping.Dynamic am t (Typ.inter left right)
:= by sorry

theorem Subtyping.Dynamic.unio_antec {am t left right upper} :
  Subtyping.Dynamic am t (Typ.path left upper) →
  Subtyping.Dynamic am t (Typ.path right upper) →
  Subtyping.Dynamic am t (Typ.path (Typ.unio left right) upper)
:= by sorry

theorem Subtyping.Dynamic.inter_conseq {am t upper left right} :
  Subtyping.Dynamic am t (Typ.path upper left) →
  Subtyping.Dynamic am t (Typ.path upper right) →
  Subtyping.Dynamic am t (Typ.path upper (Typ.inter left right))
:= by sorry

theorem Subtyping.Dynamic.inter_entry {am t l left right} :
  Subtyping.Dynamic am t (Typ.entry l left) →
  Subtyping.Dynamic am t (Typ.entry l right) →
  Subtyping.Dynamic am t (Typ.entry l (Typ.inter left right))
:= by sorry




theorem Subtyping.Dynamic.diff_elim {am lower sub upper} :
  Subtyping.Dynamic am lower (Typ.unio sub upper) →
  Subtyping.Dynamic am (Typ.diff lower sub) upper
:= by sorry


theorem Subtyping.Dynamic.not_diff_elim {am t0 t1 t2} :
  Typ.toBruijn [] t1 = Typ.toBruijn [] t2 →
  ¬ Dynamic am (Typ.diff t0 t1) t2
:= by sorry

theorem Subtyping.Dynamic.not_diff_intro {am t0 t1 t2} :
  Typ.toBruijn [] t0 = Typ.toBruijn [] t2 →
  ¬ Dynamic am t0 (Typ.diff t1 t2)
:= by sorry



theorem Subtyping.Dynamic.diff_sub_elim {am lower upper} sub:
  Subtyping.Dynamic am lower sub →
  Subtyping.Dynamic am (Typ.diff lower sub) upper
:= by sorry

theorem Subtyping.Dynamic.diff_upper_elim {am lower upper} sub:
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am (Typ.diff lower sub) upper
:= by sorry


-- theorem Subtyping.Dynamic.exi_intro {am am' t ids quals body} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping.Dynamic (am' ++ am) quals →
--   Subtyping.Dynamic (am' ++ am) t body →
--   Subtyping.Dynamic am t (Typ.exi ids quals body)
-- := by sorry

theorem Subtyping.Dynamic.lfp_skip_elim {am id body t} :
  id ∉ Typ.free_vars body →
  Subtyping.Dynamic am body t →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry

theorem Subtyping.Dynamic.lfp_induct_elim {am id body t} :
  Typ.Monotonic.Dynamic am id body →
  Subtyping.Dynamic am (Typ.sub [(id, t)] body) t →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry

theorem Subtyping.Dynamic.lfp_factor_elim {am id lower upper l fac} :
  Typ.factor id lower l = .some fac →
  Subtyping.Dynamic am fac upper →
  Subtyping.Dynamic am (Typ.lfp id lower) (.entry l upper)
:= by sorry


theorem Subtyping.Dynamic.lfp_elim_diff_intro {am id lower upper sub n} :
  Typ.Monotonic.Dynamic am id lower →
  Subtyping.Dynamic am (Typ.lfp id lower) upper →
  ¬ Subtyping.Dynamic am (Typ.subfold id lower 1) sub →
  ¬ Subtyping.Dynamic am sub (Typ.subfold id lower n) →
  Subtyping.Dynamic am (Typ.lfp id lower) (.diff upper sub)
:= by sorry

theorem Subtyping.Dynamic.diff_intro {am t left right} :
  Subtyping.Dynamic am t left →
  ¬ (Subtyping.Dynamic am t right) →
  ¬ (Subtyping.Dynamic am right t) →
  Subtyping.Dynamic am t (Typ.diff left right)
:= by sorry


theorem Subtyping.Dynamic.lfp_peel_intro {am t id body} :
  Subtyping.Dynamic am t (Typ.sub [(id, .lfp id body)] body) →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

theorem Subtyping.Dynamic.lfp_drop_intro {am t id body} :
  Subtyping.Dynamic am t (Typ.drop id body) →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

theorem Subtyping.Dynamic.exi_intro {am t ids quals body} :
  MultiSubtyping.Dynamic am quals →
  Subtyping.Dynamic am t body →
  Subtyping.Dynamic am t (Typ.exi ids quals body)
:= by sorry

theorem Subtyping.Dynamic.exi_elim {am ids quals body t} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping.Dynamic (am' ++ am) quals →
    Subtyping.Dynamic (am' ++ am) body t
  ) →
  Subtyping.Dynamic am (Typ.exi ids quals body) t
:= by sorry

-- theorem Subtyping.Dynamic.all_elim {am am' ids quals body t} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping.Dynamic (am' ++ am) quals →
--   Subtyping.Dynamic (am' ++ am) body t →
--   Subtyping.Dynamic am (Typ.all ids quals body) t
-- := by sorry

theorem Subtyping.Dynamic.all_elim {am ids quals body t} :
  MultiSubtyping.Dynamic am quals →
  Subtyping.Dynamic am body t →
  Subtyping.Dynamic am (Typ.all ids quals body) t
:= by sorry

theorem Subtyping.Dynamic.all_intro {am t ids quals body} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping.Dynamic (am' ++ am) quals →
    Subtyping.Dynamic (am' ++ am) t body
  ) →
  Subtyping.Dynamic am t (Typ.all ids quals body)
:= by sorry

theorem Subtyping.Dynamic.lfp_intro {am t id body} :
  Typ.Monotonic.Dynamic am id body →
  Subtyping.Dynamic ((id, (Typ.lfp id body)) :: am) t body →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

theorem Subtyping.Dynamic.lfp_elim {am id body t} :
  Typ.Monotonic.Dynamic am id body →
  id ∉ Typ.free_vars t →
  Subtyping.Dynamic ((id, t) :: am) t body →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry


theorem Subtyping.Dynamic.rename_lower {am lower lower' upper} :
  Typ.toBruijn [] lower = Typ.toBruijn [] lower' →
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am lower' upper
:= by sorry

theorem Subtyping.Dynamic.rename_upper {am lower upper upper'} :
  Typ.toBruijn [] upper = Typ.toBruijn [] upper' →
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am lower upper'
:= by sorry

theorem Subtyping.Dynamic.bot_elim {am upper} :
  Subtyping.Dynamic am Typ.bot upper
:= by sorry

theorem Subtyping.Dynamic.top_intro {am lower} :
  Subtyping.Dynamic am lower Typ.top
:= by sorry


theorem Typing.Dynamic.empty_record_top am :
  Typing.Dynamic am (Expr.record []) Typ.top
:= by sorry

theorem Typing.Dynamic.inter_entry_intro {am l e r body t} :
  Typing.Dynamic am e body →
  Typing.Dynamic am (.record r) t  →
  Typing.Dynamic am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry

theorem Typing.Dynamic.entry_intro {am l e t} :
  Typing.Dynamic am e t →
  Typing.Dynamic am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by sorry

theorem Typing.Dynamic.function_head_elim {am p e f subtras tp tr} :
  (∀ {v} ,
    IsValue v → Typing.Dynamic am v tp →
    ∃ eam , pattern_match v p = .some eam ∧ Typing.Dynamic am (Expr.sub eam e) tr
  ) →
  Typing.Dynamic am (Expr.function ((p, e) :: f)) (Typ.path (ListTyp.diff tp subtras) tr)
:= by sorry

-- theorem Typing.Dynamic.function_head_elim {am p e f subtras tp tr} :
--   (∀ {v} ,
--     IsValue v → Typing.Dynamic am v tp →
--     ∃ eam , pattern_match v p = .some eam ∧ Typing.Dynamic am (Expr.sub eam e) tr
--   ) →
--   Typing.Dynamic am (Expr.function ((p, e) :: f)) (Typ.path (ListTyp.diff tp subtras) tr)
-- := by sorry

theorem Typing.Dynamic.function_tail_elim {am p tp e f t } :
  (∀ {v} , IsValue v → Typing.Dynamic am v tp → ∃ eam , pattern_match v p = .some eam) →
  ¬ Subtyping.Dynamic am t (.path tp .top) →
  Typing.Dynamic am (.function f) t →
  Typing.Dynamic am (.function ((p,e) :: f)) t
:= by sorry


theorem Typing.Dynamic.path_elim {am ef ea t t'} :
  Typing.Dynamic am ef (.path t t') →
  Typing.Dynamic am ea t →
  Typing.Dynamic am (.app ef ea) t'
:= by sorry

theorem Typing.Dynamic.loop_path_elim {am e t} id :
  Typing.Dynamic am e (.path (.var id) t) →
  Typing.Dynamic am (.loop e) t
:= by sorry

theorem Typing.Dynamic.anno_intro {am e t ta} :
  Subtyping.Dynamic am t ta →
  Typing.Dynamic am e t →
  Typing.Dynamic am (.anno e ta) ta
:= by sorry


theorem fresh_ids n (ignore : List String) :
  ∃ ids , ids.length = n ∧ ids ∩ ignore = []
:= by sorry
-- TODO: concat all the existing strings together and add numbers

theorem fresh_id (ignore : List String) :
  ∃ id ,id ∉ ignore
:= by sorry


theorem Typ.all_rename {ids' ids} quals body :
  ids'.length = ids.length →
  ∃ quals' body',
  Typ.toBruijn [] (Typ.all ids' quals' body') = Typ.toBruijn [] (Typ.all ids quals body)
:= by sorry
-- TODO: construct subbing map and sub in

theorem Typ.exi_rename {ids' ids} quals body :
  ids'.length = ids.length →
  ∃ quals' body',
  Typ.toBruijn [] (Typ.exi ids' quals' body') = Typ.toBruijn [] (Typ.exi ids quals body)
:= by sorry

theorem Typ.lfp_rename id' id body :
  ∃ body',
  Typ.toBruijn [] (Typ.lfp id' body') = Typ.toBruijn [] (Typ.lfp id body)
:= by sorry

  -- theorem ListSubtyping.bruijn_eq_imp_dynamic {am} :
  --   ∀ {lower upper},
  --   ListSubtyping.toBruijn 0 [] lower = ListSubtyping.toBruijn 0 [] upper →
  --   MultiSubtyping.Dynamic am lower →
  --   MultiSubtyping.Dynamic am upper
  -- := by sorry

theorem Subtyping.Dynamic.bruijn_eq {lower upper} am :
  Typ.toBruijn [] lower = Typ.toBruijn [] upper →
  Subtyping.Dynamic am lower upper
:= by
  intro p0
  apply Subtyping.Dynamic.rename_upper p0
  apply Subtyping.Dynamic.refl am lower



theorem ListSubtyping.toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  ListSubtyping.toBruijn ids' quals' = ListSubtyping.toBruijn ids quals
:= by sorry

theorem Typ.toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  Typ.toBruijn ids' body' = Typ.toBruijn ids body
:= by sorry


theorem ListSubtyping.restricted_rename {skolems assums ids quals ids' quals'} :
  ListSubtyping.toBruijn ids quals = ListSubtyping.toBruijn ids' quals' →
  ListSubtyping.restricted skolems assums quals →
  ListSubtyping.restricted skolems assums quals'
:= by sorry


theorem ListSubtyping.solution_completeness {skolems assums cs skolems' assums' am am'} :
  ListSubtyping.restricted skolems assums cs →
  ListSubtyping.Static skolems assums cs skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  MultiSubtyping.Dynamic (am' ++ am) cs →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry


theorem List.disjoint_swap {α} [BEq α] {xs ys : List α} :
  xs ∩ ys = [] → ys ∩ xs = []
:= by sorry

theorem ListSubtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' cs} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  MultiSubtyping.Dynamic (am ++ (am' ++ am'')) cs →
  MultiSubtyping.Dynamic (am' ++ (am ++ am'')) cs
:= by sorry

theorem Subtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' lower upper} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  Subtyping.Dynamic (am ++ (am' ++ am'')) lower upper →
  Subtyping.Dynamic (am' ++ (am ++ am'')) lower upper
:= by sorry

theorem Subtyping.assumptions_independence
  {skolems assums lower upper skolems' assums' am am'}
:
  Subtyping.Static skolems assums lower upper skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  ListPair.dom am' ⊆ ListSubtyping.free_vars assums →
  MultiSubtyping.Dynamic (am' ++ am) assums →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry

theorem Subtyping.Dynamic.pluck {am cs lower upper} :
  MultiSubtyping.Dynamic am cs →
  (lower, upper) ∈ cs →
  Subtyping.Dynamic am lower upper
:= by sorry

theorem Subtyping.Dynamic.trans {am lower upper} t :
  Subtyping.Dynamic am lower t → Subtyping.Dynamic am t upper →
  Subtyping.Dynamic am lower upper
:= by
  simp [Subtyping.Dynamic]
  intros p0 p1
  intros e p5
  apply p1
  apply p0
  assumption

theorem Subtyping.check_completeness {am lower upper} :
  Subtyping.Dynamic am lower upper →
  Subtyping.check lower upper
:= by sorry

theorem Typ.Monotonic.Static.soundness {id t} am :
  Typ.Monotonic.Static id true t →
  Typ.Monotonic.Dynamic am id t
:= by sorry

set_option maxHeartbeats 500000 in
mutual
  theorem ListSubtyping.Static.soundness {skolems assums cs skolems' assums'} :
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
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness ss
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness lss
    have ⟨p0,p1,p2,p3,p4,p5,p6⟩ := Subtyping.Static.aux ss
    have ⟨p7,p8,p9,p10,p11⟩ := ListSubtyping.Static.aux lss
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


  theorem Subtyping.Static.soundness {skolems assums lower upper skolems' assums'} :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.mdiff skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper)
  | .refl => by
    exists []
    simp [*]
    apply And.intro (by simp [ListPair.dom])
    intros am0 p1
    exact Subtyping.Dynamic.refl am0 lower

  | .iso_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.iso_pres l (ih0r p9)

  | .entry_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.entry_pres l (ih0r p9)

  | .path_pres lower0 lower1 upper0 upper1 skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
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
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
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

    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

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
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
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
    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

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

  | .skolem_placeholder_elim id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .skolem_placeholder_intro id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .skolem_intro t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (ih0r p40) (Subtyping.Dynamic.pluck p40 (p10 p1))

  | .skolem_elim t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (Subtyping.Dynamic.pluck p40 (p10 p1)) (ih0r p40)

  -------------------------------------------------------------------
  | .unio_antec a b r skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.unio_antec
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

  | .inter_conseq upper a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.inter_conseq
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

  | .inter_entry l a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.inter_entry
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

  -------------------------------------------------------------------
  | .lfp_skip_elim id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_skip_elim p0 (ih0r p40)

  | .lfp_induct_elim id lower p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_induct_elim (Typ.Monotonic.Static.soundness (am0 ++ am') p0) (ih0r p40)

  | .lfp_factor_elim id lower upper fac p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_factor_elim p0 (ih0r p40)

  | .lfp_elim_diff_intro id lower upper sub h p0 p1 p2 p3 p4 p5 p6 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p4
    have ⟨p10,p15,p20,p25,p30,p35,p40⟩ := Subtyping.Static.aux p4
    exists am0
    simp [*]
    intros am' p45
    apply Subtyping.Dynamic.lfp_elim_diff_intro (Typ.Monotonic.Static.soundness (am0 ++ am') p3) (ih0r p45)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  | .diff_intro upper sub p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intro am' p40
    apply Subtyping.Dynamic.diff_intro (ih0r p40)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  -------------------------------------------------------------------
  | .lfp_peel_intro id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_peel_intro (ih0r p40)

  | .lfp_drop_intro id body p0 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_drop_intro (ih0r p40)
  -------------------------------------------------------------------

  | .diff_elim lower sub upper p0  => by

    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p10
    apply Subtyping.Dynamic.diff_elim (ih0r p10)

  | .unio_left_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_left_intro (ih0r p9)

  | .unio_right_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_right_intro (ih0r p9)

  | .exi_intro ids quals upper skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.Dynamic.exi_intro (ih1r p40)
    apply Subtyping.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.Dynamic.reduction p11 p40 } }

  | .inter_left_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp[*]
    intros am' p9
    exact Subtyping.Dynamic.inter_left_elim (ih0r p9)

  | .inter_right_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.inter_right_elim (ih0r p9)

  | .all_elim ids quals lower skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.Dynamic.all_elim (ih1r p40)
    apply Subtyping.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.Dynamic.reduction p11 p40 } }

end


def Expr.Convergence (a b : Expr) :=
  ∃ e , ProgressionStar a e ∧ ProgressionStar b e

theorem Expr.Convergence.typing_left_to_right {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am a t →
  Typing.Dynamic am b t
:= by sorry

theorem Expr.Convergence.typing_right_to_left {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am b t →
  Typing.Dynamic am a t
:= by sorry


theorem Typ.factor_expansion_soundness {am id t label t' e'} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e' (.lfp id t') →
  ∃ e ,
    Expr.Convergence (Expr.proj e label) e' ∧
    Typing.Dynamic am e (.lfp id t)
:= by sorry

theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e (.lfp id t) →
  Expr.Convergence (Expr.proj e label) e' →
  Typing.Dynamic am e' (.lfp id t')
:= by sorry



theorem ListZone.pack_positive_soundness {pids zones t am assums e} :
  ListZone.pack pids .true zones = t →
  -- ListZone.pack (ListSubtyping.free_vars assums) .true zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) ) →
  Typing.Dynamic am e t
:= by sorry


theorem Expr.Convergence.transitivity {a b c} :
  Expr.Convergence a b →
  Expr.Convergence b c →
  Expr.Convergence a c
:= by sorry

theorem Expr.Convergence.swap {a b} :
  Expr.Convergence a b →
  Expr.Convergence b a
:= by sorry

theorem Expr.Convergence.app_arg_preservation {a b} f :
  Expr.Convergence a b →
  Expr.Convergence (.app f a) (.app f b)
:= by sorry

theorem ListZone.pack_negative_soundness {pids zones t am assums e} :
  ListZone.pack pids .false zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  -- ListZone.pack (id :: ListSubtyping.free_vars assums) .false zones = t →
  MultiSubtyping.Dynamic am assums →
  Typing.Dynamic am e t →
  (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones ∧
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) )
:= by sorry

theorem Zone.pack_negative_soundness {pids t am assums skolems' assums' t'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  ∀ e, Typing.Dynamic am e t →
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) )
:= by sorry


example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  apply h0
  intro h2
  exact h1

example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  specialize h0 (by exact fun a ↦ h1)
  exact h0



theorem Zone.pack_negative_soundness_left_to_right {pids t am assums skolems' assums' t' e am'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  MultiSubtyping.Dynamic (am' ++ am) assums' →
  Typing.Dynamic (am' ++ am) e t' →
  Typing.Dynamic am e t
:= by sorry
--   Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
--   ListSubtyping.free_vars assums ⊆ pids →
--   MultiSubtyping.Dynamic am assums →
--   ∀ e,
--     (∀ am'', ListPair.dom am'' ⊆ skolems' →
--       (∃ am',
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
--         Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) →
--     Typing.Dynamic am e t
-- := by sorry

theorem ListZone.inversion_soundness {id zones zones' am assums} :
  ListZone.invert id zones = some zones' →
  MultiSubtyping.Dynamic am assums →
  ∀ ef,
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) ef t' ) ) )
  →
  (∀ ep ,
    (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones' ∧
      (∀ am'', ListPair.dom am'' ⊆ skolems' →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep t' ) )
    ) →
    Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
  )
:= by sorry


theorem ListSubtyping.inversion_soundness {id am assums assums0 assums0'} skolems tl tr :
  ListSubtyping.invert id assums0 = some assums0' →
  MultiSubtyping.Dynamic am assums →
  ∀ ef,
    (∃ am'',
      ListPair.dom am'' ⊆ skolems ∧
      ∀ {am' : List (String × Typ)},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 →
            Typing.Dynamic (am'' ++ am' ++ am) ef (.path tl tr))
    →
    (∀ ep,
      (∀ am'', ListPair.dom am'' ⊆ skolems →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep (.pair tl tr) )
      ) →
      Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
    )
:= by sorry

theorem ListSubtyping.inversion_top_extension {id am assums0 assums1} am' :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping.Dynamic (am' ++ am) assums0 →
  MultiSubtyping.Dynamic (am' ++ (id,.top)::am) assums0
:= by sorry

theorem ListSubtyping.inversion_substance {id am am' assums0 assums1} :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping.Dynamic (am' ++ (id,.top)::am) assums0 →
  MultiSubtyping.Dynamic (am' ++ (id,.bot)::am) assums1
:= by sorry



theorem Typing.Dynamic.lfp_elim_top {am e id t} :
  Typ.Monotonic.Dynamic am id t →
  Typing.Dynamic am e (.lfp id t) →
  Typing.Dynamic ((id, .top) :: am) e t
:= by sorry

theorem Typing.Dynamic.lfp_intro_bot {am e id t} :
  Typ.Monotonic.Dynamic am id t →
  Typing.Dynamic ((id, .bot) :: am) e t →
  Typing.Dynamic am e (.lfp id t)
:= by sorry

theorem Typing.Dynamic.existential_top_drop
  {id am skolems' assums assums0 ep}
  tl tr
:
  id ∉ (ListSubtyping.free_vars assums) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping.Dynamic (am'' ++ am' ++ (id,.top)::am) assums0 ∧
      Typing.Dynamic (am'' ++ am' ++ (id,.top)::am) ep (.pair tl tr)) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 ∧
      Typing.Dynamic (am'' ++ am' ++ am) ep (.pair tl tr) )


:= by sorry

theorem Typing.ListZone.Dynamic.existential_top_drop {id am assums ep} {zones' : List Zone} :
  id ∉ (ListSubtyping.free_vars assums) →
  (∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ (id,.top)::am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ (id,.top)::am) ep t'
  ) →
  ∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep t'


:= by sorry



theorem Typ.factor_imp_typing_covariant {am0 am1 id label t0 t0' t1 t1'} :
  Typ.factor id t0 label = .some t0' →
  Typ.factor id t1 label = .some t1' →
  (∀ e , Typing.Dynamic am0 e t0 → Typing.Dynamic am1 e t1) →
  (∀ e , Typing.Dynamic am0 e t0' → Typing.Dynamic am1 e t1')
:= by sorry

-- theorem Typ.factor_subtyping_soundness {am id label t0 t0' t1 t1'} :
--   Typ.factor id t0 label = .some t0' →
--   Typ.factor id t1 label = .some t1' →
--   Subtyping.Dynamic am t0 t1 →
--   Subtyping.Dynamic am t0' t1'
-- := by sorry

theorem Typ.Monotonic.Dynamic.pair {am id t0 t1} :
  Typ.Monotonic.Dynamic am id t0 →
  Typ.Monotonic.Dynamic am id t1 →
  Typ.Monotonic.Dynamic am id (.pair t0 t1)
:= by sorry

theorem Typ.factor_monotonic {am id label t t'} :
  Typ.factor id t label = .some t' →
  Typ.Monotonic.Dynamic am id t →
  Typ.Monotonic.Dynamic am id t'
:= by sorry


theorem Typ.UpperFounded.soundness {id l l'} am :
  Typ.UpperFounded id l l' →
  Subtyping.Dynamic am (.lfp id l) (.lfp id l')
:= by sorry

theorem Typ.sub_weaken_soundness {am idl t0 t1 t2} :
  Typ.sub [(idl, t0)] t1 = t2 →
  Typ.Monotonic.Dynamic am idl t1 →
  Subtyping.Dynamic am (.var idl) t0 →
  Subtyping.Dynamic am t1 t2
:= by sorry


theorem Subtyping.LoopListZone.Static.soundness {id zones t am assums e} :
  LoopListZone.Subtyping.Static (ListSubtyping.free_vars assums) id zones t →
  MultiSubtyping.Dynamic am assums →
  id ∉ ListSubtyping.free_vars assums →
  ------------------------------
  -- substance
  ------------------------------
  -- (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
  --   ∃ am' ,
  --   ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
  --   MultiSubtyping.Dynamic (am' ++ am) assums'
  -- ) →
  ------------------------------
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    -------------
    -- substance
    -------------
    (∃ am' ,
      ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
      MultiSubtyping.Dynamic (am' ++ am) assums'
    ) ∧
    -------------
    -- soundness
    -------------
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) )
  ) →
  ------------------------------
  Typing.Dynamic am e t
:= by
  intros p0 p1 p2 substance_and_soundness
  cases p0 with
  | batch zones' t' left right p4 p5 p6 p7 p8 =>
    unfold Typing.Dynamic
    intro ea
    intro p9

    have ⟨ep,p10,p11⟩ := Typ.factor_expansion_soundness p7 p9

    apply Expr.Convergence.typing_left_to_right
      (Expr.Convergence.app_arg_preservation e p10)

    apply Typ.factor_reduction_soundness p8 p11

    have p3 := (fun {x y z} mem_zones =>
      let ⟨substance, soundness⟩ := @substance_and_soundness x y z mem_zones
      soundness
    )
    apply ListZone.inversion_soundness p4 p1 at p3

    apply p3 ep

    have p12 : Typing.Dynamic ((id, .top) :: am) ep t' := by
      apply Typing.Dynamic.lfp_elim_top (Typ.Monotonic.Static.soundness am p6) p11
    have p13 : MultiSubtyping.Dynamic ((id,.top) :: am) assums := by
      apply MultiSubtyping.Dynamic.dom_single_extension p2 p1

    apply Typing.ListZone.Dynamic.existential_top_drop p2

    apply ListZone.pack_negative_soundness p5
      (List.subset_cons_of_subset id (fun _ x => x)) p13 p12


  | stream
    skolems assums0 assums0' idl r t' l r' l' r''
    p4 idl_fresh p5 p6 p7 p8 p9 p10 upper_founded sub_eq
  =>
    unfold Typing.Dynamic
    intro ea
    intro p13

    have ⟨substance, soundness⟩ := substance_and_soundness (Iff.mpr List.mem_singleton rfl)
    have ⟨am', dom_local_assums, subtyping_local_assums⟩ := substance

    have subtyping_assums0'_bot : MultiSubtyping.Dynamic (am' ++ (id,.bot)::am) assums0' := by
      apply ListSubtyping.inversion_substance p5
      apply ListSubtyping.inversion_top_extension am' p5 subtyping_local_assums

    have factor_pair : Typ.factor id (.pair (.var idl) r) "left" = some (Typ.var idl) := by
      reduce; rfl

    have monotonic_packed : Typ.Monotonic.Dynamic ((id, Typ.bot) :: am) id t' := by
      exact Typ.Monotonic.Static.soundness ((id, Typ.bot) :: am) p7

    have imp_typing_pair_to_packed :
      ∀ e ,
        Typing.Dynamic (am' ++ (id,.bot)::am) e (Typ.pair (Typ.var idl) r) →
        Typing.Dynamic ((id,.bot)::am) e t'
    := by
      intros e_pair typing_pair
      -- NOTE: pack_negative_soundness_left_to_right depends on substance
      apply Zone.pack_negative_soundness_left_to_right p6
        (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
        (MultiSubtyping.Dynamic.dom_single_extension p2 p1)
        subtyping_assums0'_bot
        typing_pair

    have imp_typing_factored_left :
      ∀ e ,
        Typing.Dynamic (am' ++ (id,.bot)::am) e (Typ.var idl) →
        Typing.Dynamic ((id,.bot)::am) e l
    := by
      exact fun e a ↦ Typ.factor_imp_typing_covariant factor_pair p8 imp_typing_pair_to_packed e a

    have subtyping_idl_left : Subtyping.Dynamic ((id,.bot)::am) (Typ.var idl) l := by
      unfold Subtyping.Dynamic
      intros el typing_idl
      apply imp_typing_factored_left
      apply Typing.Dynamic.dom_extension
      { simp [Typ.free_vars]
        apply List.disjoint_preservation_left dom_local_assums
        exact List.nonmem_to_disjoint_right idl (ListSubtyping.free_vars assums0) idl_fresh }
      { exact typing_idl }

    have typing_idl_bot : Typing.Dynamic ((id,.bot)::am) ea (Typ.var idl) := by
      apply Typing.Dynamic.dom_single_extension (Iff.mp List.count_eq_zero rfl) p13

    have typing_factor_left_bot : Typing.Dynamic ((id,.bot)::am) ea l := by
      unfold Subtyping.Dynamic at subtyping_idl_left
      exact subtyping_idl_left ea typing_idl_bot

    have monotonic_left : Typ.Monotonic.Dynamic am id l := by
      apply Typ.factor_monotonic p8 (Typ.Monotonic.Static.soundness am p7)

    have typing_factor_left : Typing.Dynamic am ea (.lfp id l) :=
      Typing.Dynamic.lfp_intro_bot monotonic_left typing_factor_left_bot


    have subtyping_left_pre := Typ.UpperFounded.soundness am upper_founded
    unfold Subtyping.Dynamic at subtyping_left_pre

    have subtyping_left : Subtyping.Dynamic am (Typ.var idl) (Typ.lfp id l') := by
      unfold Subtyping.Dynamic
      intro el typing_idl
      apply subtyping_left_pre
      apply Typing.Dynamic.lfp_intro_bot monotonic_left
      unfold Subtyping.Dynamic at subtyping_idl_left
      apply subtyping_idl_left
      apply Typing.Dynamic.dom_single_extension (Iff.mp List.count_eq_zero rfl)
      exact typing_idl

    have subtyping_right : Subtyping.Dynamic am (.lfp id r') r'' := by
      apply Typ.sub_weaken_soundness sub_eq
        (Typ.Monotonic.Static.soundness am p10) subtyping_left

    unfold Subtyping.Dynamic at subtyping_right
    apply subtyping_right

    have ⟨ep,p14,p15⟩ := Typ.factor_expansion_soundness p8 typing_factor_left

    apply Expr.Convergence.typing_left_to_right (Expr.Convergence.app_arg_preservation e p14)
    apply Typ.factor_reduction_soundness p9 p15

    apply ListSubtyping.inversion_soundness skolems (Typ.var idl) r p5 p1 at soundness

    apply soundness ep

    have p20 : Typing.Dynamic ((id, .top) :: am) ep t' := by
      apply Typing.Dynamic.lfp_elim_top (Typ.Monotonic.Static.soundness am p7) p15

    have p22 : MultiSubtyping.Dynamic ((id,.top) :: am) assums := by
      apply MultiSubtyping.Dynamic.dom_single_extension p2 p1

    apply Typing.Dynamic.existential_top_drop (Typ.var idl) r p2

    apply Zone.pack_negative_soundness p6
      (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
      p22 ep p20

-- theorem ListZone.tidy_substance {pids zones0 zones1 am} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums0 ∧
--         MultiSubtyping.Dynamic (am'' ++ am) assums0)
--   →
--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums1 ∧
--         MultiSubtyping.Dynamic (am'' ++ am) assums1)
-- := by sorry


-- theorem ListZone.tidy_soundness {pids zones0 zones1 am assums e} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (ListSubtyping.free_vars assums) ⊆ pids →
--   MultiSubtyping.Dynamic am assums →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 →
--         Typing.Dynamic (am'' ++ am' ++ am) e t0 ) ) ) →

--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums1 →
--         Typing.Dynamic (am'' ++ am' ++ am) e t1 ) ) )
-- := by sorry

-- theorem ListZone.tidy_soundness_alt
--   {zones0 zones1 e context skolems assums1 t1}
--   {assums : List (Typ × Typ)}
-- :
--   ListZone.tidy (ListSubtyping.free_vars assums) zones0 = .some zones1 →
--   ⟨skolems, assums1, t1⟩ ∈ zones1 →

--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         MultiSubtyping.Dynamic (am'' ++ am') (assums0 ++ assums) →
--         ∀ {eam}, MultiTyping.Dynamic am' eam context →
--         Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t0 ) ) ) →

--   (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--     (∀ {am'},
--       MultiSubtyping.Dynamic (am'' ++ am') (assums1 ++ assums) →
--       ∀ {eam}, MultiTyping.Dynamic am' eam context →
--       Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t1 ) )
-- := by sorry


theorem MultiSubtyping.Dynamic.concat {am cs cs'} :
  MultiSubtyping.Dynamic am cs →
  MultiSubtyping.Dynamic am cs' →
  MultiSubtyping.Dynamic am (cs ++ cs')
:= by sorry

theorem MultiSubtyping.Dynamic.union {am cs cs'} :
  MultiSubtyping.Dynamic am cs →
  MultiSubtyping.Dynamic am cs' →
  MultiSubtyping.Dynamic am (cs ∪ cs')
:= by sorry

theorem MultiSubtyping.Dynamic.concat_elim_left {am cs cs'} :
  MultiSubtyping.Dynamic am (cs ++ cs') →
  MultiSubtyping.Dynamic am cs
:= by sorry



theorem PatLifting.Static.soundness {assums context p t assums' context'} :
  PatLifting.Static assums context p t assums' context' →
  ∀ tam v, IsValue v → Typing.Dynamic tam v t →
    ∃ eam , pattern_match v p = .some eam ∧ MultiTyping.Dynamic tam eam context'
:= by sorry


theorem pattern_match_ids_containment {v p eam} :
  pattern_match v p = .some eam →
  ids_pattern p ⊆ ListPair.dom eam
:= by sorry



-- theorem PatLifting.Static.aux {assums context p t assums' context'} :
--   PatLifting.Static assums context p t assums' context' →
--   assums ⊆ assums' ∧
--   Typ.free_vars t ⊆ ListTyping.free_vars context' ∧
--   ListTyping.free_vars context'  ⊆ ListSubtyping.free_vars assums'
-- := by sorry


theorem Expr.sub_sub_removal {ids eam0 eam1 e} :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry



theorem Function.Typing.Static.subtra_soundness {
  skolems assums context f nested_zones subtra subtras skolems' assums' t
} :
  Function.Typing.Static skolems assums context  subtras f nested_zones →
  subtra ∈ subtras →
  ⟨skolems', assums', t⟩ ∈ nested_zones.flatten →
  ∀ am , ¬ Subtyping.Dynamic am t (.path subtra .top)
:= by sorry

mutual
  theorem Subtyping.Static.substance {
    skolems assums lower upper skolems' assums' am
  } :
    Subtyping.Static skolems assums lower upper skolems' (assums' ++ assums) →
    MultiSubtyping.Dynamic am assums →
    ∃ am'' ,
    ListPair.dom am'' ⊆ ListSubtyping.free_vars assums' ∧
    MultiSubtyping.Dynamic (am'' ++ am) assums'
  := by sorry
end


theorem Typ.combine_bounds_positive_soundness {id am assums e} :
  (∀ am , MultiSubtyping.Dynamic am assums → Typing.Dynamic am e (.var id)) →
  MultiSubtyping.Dynamic am assums →
  Typing.Dynamic am e (Typ.combine_bounds id true assums)
:= by sorry

theorem Typ.combine_bounds_positive_subtyping_path_conseq_soundness {id am am_skol assums t antec} :
  id ∉ ListPair.dom am_skol →
  MultiSubtyping.Dynamic (am_skol ++ am) assums →
  (∀ {am} ,
    MultiSubtyping.Dynamic (am_skol ++ am) assums →
    Subtyping.Dynamic (am_skol ++ am) t (.path antec (.var id))
  ) →
  Subtyping.Dynamic (am_skol ++ am) t (.path antec (Typ.combine_bounds id true assums))
:= by sorry

-- theorem Typ.factor_expansion_soundness {am id t label t' e'} :
--   Typ.factor id t label = some t' →
--   Typing.Dynamic am e' (.lfp id t') →
--   ∃ e ,
--     Expr.Convergence (Expr.proj e label) e' ∧
--     Typing.Dynamic am e (.lfp id t)
-- := by sorry

-- theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
--   Typ.factor id t label = some t' →
--   Typing.Dynamic am e (.lfp id t) →
--   Expr.Convergence (Expr.proj e label) e' →
--   Typing.Dynamic am e' (.lfp id t')
-- := by sorry





mutual

  theorem Zone.Interp.aux {ignore skolems assums t skolems' assums' t'} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    skolems = skolems'
  := by sorry




  theorem Zone.Interp.integrated_positive_soundness
  {ignore skolems assums t skolems' assums' t' e skolems_base assums_base context} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    (∃ tam,
      ListPair.dom tam ⊆ List.mdiff skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.mdiff skolems' skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') (List.mdiff assums' assums_base ∪ assums_base) →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry


  -- theorem Typ.Interp.positive_soundness {ignore skolems assums t t'} :
  --   Typ.Interp ignore skolems assums .true t t' →
  --   ∀ am , MultiSubtyping.Dynamic am assums → Subtyping.Dynamic am t t'
  -- := by sorry

  theorem Typ.Interp.integrated_positive_soundness
  {ignore skolems assums t t' e skolems_base context} :
    Typ.Interp ignore skolems assums .true t t' →
    (∃ tam,
      ListPair.dom tam ⊆ List.mdiff skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.mdiff skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry

end







-- set_option maxHeartbeats 1000000 in
mutual

  theorem Function.Typing.Static.soundness {
    skolems assums context f nested_zones subtras skolems''' assums'''' t
  } :
    Function.Typing.Static skolems assums context subtras f nested_zones →
    ⟨skolems''', assums'''', t⟩ ∈ nested_zones.flatten →
    ∃ tam, ListPair.dom tam ⊆ skolems''' ∧
    (∀ tam', MultiSubtyping.Dynamic (tam ++ tam') (assums'''' ∪ assums) →
      (∀ eam, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam (.function f)) t ) )
  | .nil => by intros ; contradiction
  | .cons
      pat e f assums0 context0 tp zones nested_zones subtras
      pat_lifting_static typing_static keys function_typing_static
  => by
    intro mem_con_zones
    cases (Iff.mp List.mem_append mem_con_zones) with
    | inl mem_zones =>

      have ⟨skolems'', mdiff_skolems, assums''', mdiff_assums, skolems', assums'', tr, interp⟩ := (keys _ _ _ mem_zones)
      specialize typing_static _ _ _ mem_zones skolems'' mdiff_skolems assums''' mdiff_assums skolems' assums'' tr interp
      clear keys

      rw [← mdiff_skolems]
      rw [← mdiff_assums]

      apply Zone.Interp.integrated_positive_soundness interp

      have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness typing_static

      have ⟨p24,p26,p28,p30,p32,p34⟩ := Expr.Typing.Static.aux typing_static

      exists tam0

      apply And.intro ih0l

      intros tam' subtyping_dynamic_assums
      intros eam typing_dynamic_context
      apply Typing.Dynamic.function_head_elim
      intros v p44 p46
      have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p44 p46
      exists eam0
      simp [*]
      rw [Expr.sub_sub_removal (pattern_match_ids_containment p48)]

      apply ih0r subtyping_dynamic_assums
      apply MultiTyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p28 p32 }
      { apply MultiTyping.Dynamic.dom_context_extension p50 }

    | inr p11 =>
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness function_typing_static p11
      have ⟨p20,p22,p24,p26⟩ := Function.Typing.Static.aux function_typing_static p11

      exists tam0
      simp [*]
      intros tam' p30
      intros eam p32

      apply Typing.Dynamic.function_tail_elim
      { intros v p40 p42
        have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p40 p42
        apply Exists.intro eam0 p48 }
      { apply Function.Typing.Static.subtra_soundness function_typing_static List.mem_cons_self p11 }
      { apply ih0r _ p30 _ p32 }


  theorem Record.Typing.Static.soundness {skolems assums context r t skolems' assums'} :
    Record.Typing.Static skolems assums context r t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.mdiff skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping.Dynamic (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam (.record r)) t ) )
  | .nil => by
    exists []
    simp [*, ListPair.dom]
    intros tam' p10
    intros eam p20
    simp [Expr.sub, Expr.Record.sub]
    apply Typing.Dynamic.empty_record_top

  | .single l e body p0 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    exists tam0
    simp [*]
    intros tam' p40
    intros eam p50
    apply Typing.Dynamic.entry_intro (ih0r p40 p50)

  | .cons l e r body t skolems0 assums0 p0 p1 => by

    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Record.Typing.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26,p31⟩ := Record.Typing.Static.aux p1

    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p5 ih0l p6 ih1l)

    intros tam' p40
    intros eam p50
    apply Typing.Dynamic.inter_entry_intro
    { apply Typing.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p20 p26 }
      { apply ih0r
        { apply MultiSubtyping.Dynamic.dom_reduction
          { apply List.disjoint_preservation_left ih1l p26 }
          { apply MultiSubtyping.Dynamic.reduction p11 p40 } }
        { apply p50 } } }
    { apply ih1r p40
      apply MultiTyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p15 p25 }
      { apply p50 } }


  theorem Expr.Typing.Static.soundness {skolems assums context e t skolems' assums'} :
    Expr.Typing.Static skolems assums context e t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.mdiff skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping.Dynamic (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t ) )

  | .var skolems assums context x p0 => by
    exists []
    simp [ListPair.dom, *]
    intros tam' p1
    intros eam p2
    unfold MultiTyping.Dynamic at p2
    have ⟨e,p3,p4⟩ := p2 p0
    simp [Expr.sub, p3, p4]

  | .record r p0 => by
    apply Record.Typing.Static.soundness p0

  | .function f zones p0 p1 => by
      exists []
      simp [*, ListPair.dom]
      intros tam' p2
      intros eam p3

      apply ListZone.pack_positive_soundness p1 (fun _ x => x) p2
      intros skolesm0 assums0 t0 p4
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness p0 p4
      have ⟨p10,p11,p12,p13⟩ := Function.Typing.Static.aux p0 p4
      exists tam0
      simp [*]
      intro tam''
      intros p5 p6
      apply ih0r
      { apply MultiSubtyping.Dynamic.union p6
        apply MultiSubtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih0l p11 }
        { apply MultiSubtyping.Dynamic.dom_extension p5 p2 } }
      { apply MultiTyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_right p13 p5 }
        { apply p3 } }

  | .app ef ea id tf skolems0 assums0 ta skolems1 assums1 t p0 p1 p2 interp => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p105,p7,p8,p9⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p10,p11,p107,p12,p13,p14⟩ := Expr.Typing.Static.aux p1
    have ⟨tam2,ih2l,ih2r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2

    apply Typ.Interp.integrated_positive_soundness interp

    exists tam2 ++ (tam1 ++ tam0)
    apply And.intro
    { apply dom_concat_mdiff_containment
      { intro a p30 ; apply p10 (p5 p30) }
      { apply dom_concat_mdiff_containment p5 ih0l p10 ih1l }
      { apply p15 }
      { apply ih2l } }

    { simp [*]
      intro tam' p30 eam p31
      apply Typing.Dynamic.path_elim
      {
        unfold Subtyping.Dynamic at ih2r
        apply ih2r p30
        apply Typing.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih2l p20 }
        {
          apply Typing.Dynamic.dom_extension
          {
            apply List.disjoint_preservation_left ih1l
            apply List.disjoint_preservation_right p7 p13
          }
          {
            apply ih0r
            {
              apply MultiSubtyping.Dynamic.dom_reduction
              { apply List.disjoint_preservation_left ih1l p13 }
              {
                apply MultiSubtyping.Dynamic.dom_reduction
                { apply List.disjoint_preservation_left ih2l
                  apply List.disjoint_preservation_right
                  { apply ListSubtyping.free_vars_containment p11  }
                  { exact p19 }
                }
                { apply MultiSubtyping.Dynamic.reduction p11
                  apply MultiSubtyping.Dynamic.reduction p16 p30
                }
              }
            }
            {
              apply p31
            }
          }
        }
      }
      {
        apply Typing.Dynamic.dom_extension
        {
          apply List.disjoint_preservation_left ih2l
          apply List.disjoint_preservation_right p12 p19
        }
        {
          apply ih1r
          {
            apply MultiSubtyping.Dynamic.dom_reduction
            { apply List.disjoint_preservation_left ih2l p19 }
            { apply MultiSubtyping.Dynamic.reduction p16 p30 }
          }
          {
            apply MultiTyping.Dynamic.dom_extension
            { apply List.disjoint_preservation_right p105
              exact List.disjoint_preservation_left ih0l p8 }
            { apply p31 }
          }
        }
      }
    }

  | .loop body t0 id zones id_antec id_consq p0
    no_mem_id_antec no_mem_id_consq subtyping_static keys subtyping_static_zones id_fresh
  => by


    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p0
    exists tam0
    simp [*]

    intros tam' p20
    intros eam p30


    apply Subtyping.LoopListZone.Static.soundness subtyping_static_zones p20 id_fresh
    intros skolems'''' assums''''' body' mem_zones
    have ⟨
      skolems''', mdiff_skolems, assums'''', mdiff_assums,
      assums''', loop_normal_form, skolems'', assums'',
      interp
    ⟩ := keys _ _ _ mem_zones
    apply And.intro
    { -- TODO: substance
      sorry }
    { -- TODO: soundness case
      sorry }

    ----------------------------------------------------

    -- Typ.combine_bounds id_body true assums''

    have typing_zones : ∀ {skolems1 assums1 t1}, ⟨skolems1, assums1, t1⟩ ∈ zones →
      ∃ am'' ,
        ListPair.dom am'' ⊆ ListSubtyping.free_vars assums1 ∧
        MultiSubtyping.Dynamic (am'' ++ (tam0 ++ tam')) assums1
    := by
      intros skolems1 assums1 t1 mem_zones
      apply Subtyping.Static.substance
      { have ⟨_,_,h⟩ := p1 mem_zones; exact h }
      { exact p20 }

    have typing_zones' : ∀ {skolems1 assums1 t1}, ⟨skolems1, assums1, t1⟩ ∈ zones' →
      ∃ am'' ,
        ListPair.dom am'' ⊆ ListSubtyping.free_vars assums1 ∧
        MultiSubtyping.Dynamic (am'' ++ (tam0 ++ tam')) assums1
    := by
      apply ListZone.tidy_substance p2
      intros skolems1 assums1 t1 h
      exact typing_zones h

    apply Subtyping.LoopListZone.Static.soundness p3 p20 id_fresh typing_zones'
    apply ListZone.tidy_soundness p2
    { exact List.subset_cons_of_subset id (fun _ x => x) }
    { exact p20 }

    intros skolems0 assums0 t0 p40

    have ⟨interp_eq, id_body_not_skolem, p40⟩ := p1 p40
    have ⟨tam1, h33l, h33r⟩ := Subtyping.Static.soundness p40
    have ⟨p41,p42,p43,p44,p45,p46,p47⟩ := Subtyping.Static.aux p40

    have id_body_not_skolem_dom : id_body ∉ ListPair.dom tam1 := by
      intro h
      apply id_body_not_skolem (containment_mdiff_concat_elim (h33l h))

    exists tam1
    simp [*]
    apply And.intro (fun _ p50 => containment_mdiff_concat_elim (h33l p50))
    intros tam'' p55 p56
    apply Typing.Dynamic.loop_path_elim id

    have muli_subtyping_assums :
      MultiSubtyping.Dynamic (tam1 ++ (tam'' ++ (tam0 ++ tam'))) (assums0 ++ assums')
    := by
      apply MultiSubtyping.Dynamic.concat p56
      apply MultiSubtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left h33l p45 }
      { apply MultiSubtyping.Dynamic.dom_extension p55 p20 }

    have id_body_interp_subtyping := Typ.combine_bounds_positive_subtyping_path_conseq_soundness
      id_body_not_skolem_dom muli_subtyping_assums h33r
    unfold Subtyping.Dynamic at id_body_interp_subtyping
    apply id_body_interp_subtyping
    apply Typing.Dynamic.dom_extension (List.disjoint_preservation_left h33l p46)
    apply Typing.Dynamic.dom_extension (List.disjoint_preservation_right p8 p55)
    apply ih0r p20 p30

  | .anno e ta te skolems0 assums0 p0 p1 p2 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p1
    have ⟨tam1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2
    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_mdiff_containment p5 ih0l p15 ih1l)
    intros am' p40
    intros eam p42
    apply Typing.Dynamic.anno_intro (ih1r p40)
    apply Typing.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l p20 }
    { apply ih0r
      { apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p19 }
        { apply MultiSubtyping.Dynamic.reduction p16 p40 } }
      { apply p42 } }

end
