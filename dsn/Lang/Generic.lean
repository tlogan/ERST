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


lemma containment_mdiff_concat_elim {α} [BEq α] {xs ys : List α}:
   List.mdiff (xs ++ ys) ys ⊆ xs
:= by sorry


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


lemma Typing.Dynamic.dom_reduction {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing.Dynamic (tam1 ++ tam0) e t →
  Typing.Dynamic tam0 e t
:= by sorry

lemma Typing.Dynamic.dom_extension {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing.Dynamic tam0 e t →
  Typing.Dynamic (tam1 ++ tam0) e t
:= by sorry


lemma MultiTyping.Dynamic.dom_reduction {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping.Dynamic (tam1 ++ tam0) eam cs →
  MultiTyping.Dynamic tam0 eam cs
:= by sorry


lemma MultiTyping.Dynamic.dom_extension {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping.Dynamic tam0 eam cs →
  MultiTyping.Dynamic (tam1 ++ tam0) eam cs
:= by sorry

lemma MultiTyping.Dynamic.dom_context_extension {tam eam cs} :
  MultiTyping.Dynamic tam eam cs →
  ∀ eam', MultiTyping.Dynamic tam (eam ++ eam') cs
:= by sorry


lemma Subtyping.Dynamic.dom_extension {am1 am0 lower upper} :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping.Dynamic am0 lower upper →
  Subtyping.Dynamic (am1 ++ am0) lower upper
:= by sorry

lemma MultiSubtyping.Dynamic.dom_single_extension {id tam0 cs} t :
  id ∉ ListSubtyping.free_vars cs →
  MultiSubtyping.Dynamic tam0 cs →
  MultiSubtyping.Dynamic ((id,t) :: tam0) cs
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

lemma Typing.Static.attributes {skolems assums context e t skolems' assums'} :
  Typing.Static skolems assums context e t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


lemma Typing.Function.Static.attributes
  {skolems assums context f zones subtras skolems' assums' t}
:
  Typing.Function.Static skolems assums context subtras f zones →
  ⟨skolems',assums',t⟩ ∈ zones →
  skolems' ∩ skolems = [] ∧
  skolems' ∩ ListSubtyping.free_vars assums = [] ∧
  skolems' ∩ ListTyping.free_vars context = [] ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums
:= by sorry

lemma Typing.Record.Static.attributes
  {skolems assums context r t skolems' assums'}
:
  Typing.Record.Static skolems assums context r t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.mdiff skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.mdiff skolems' skolems) ∩ Typ.free_vars t = []
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

lemma Subtyping.Dynamic.unio_left_intro {am t l r} :
  Subtyping.Dynamic am t l →
  Subtyping.Dynamic am t (Typ.unio l r)
:= by sorry


lemma Subtyping.Dynamic.unio_right_intro {am t l r} :
  Subtyping.Dynamic am t r →
  Subtyping.Dynamic am t (Typ.unio l r)
:= by sorry

lemma Subtyping.Dynamic.inter_left_elim {am l r t} :
  Subtyping.Dynamic am l t →
  Subtyping.Dynamic am (Typ.inter l r) t
:= by sorry

lemma Subtyping.Dynamic.inter_right_elim {am l r t} :
  Subtyping.Dynamic am r t →
  Subtyping.Dynamic am (Typ.inter l r) t
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


lemma Subtyping.Dynamic.unio_elim {am left right t} :
  Subtyping.Dynamic am left t →
  Subtyping.Dynamic am right t →
  Subtyping.Dynamic am (Typ.unio left right) t
:= by sorry


lemma Subtyping.Dynamic.inter_intro {am t left right} :
  Subtyping.Dynamic am t left →
  Subtyping.Dynamic am t right →
  Subtyping.Dynamic am t (Typ.inter left right)
:= by sorry

lemma Subtyping.Dynamic.unio_antec {am t left right upper} :
  Subtyping.Dynamic am t (Typ.path left upper) →
  Subtyping.Dynamic am t (Typ.path right upper) →
  Subtyping.Dynamic am t (Typ.path (Typ.unio left right) upper)
:= by sorry

lemma Subtyping.Dynamic.inter_conseq {am t upper left right} :
  Subtyping.Dynamic am t (Typ.path upper left) →
  Subtyping.Dynamic am t (Typ.path upper right) →
  Subtyping.Dynamic am t (Typ.path upper (Typ.inter left right))
:= by sorry

lemma Subtyping.Dynamic.inter_entry {am t l left right} :
  Subtyping.Dynamic am t (Typ.entry l left) →
  Subtyping.Dynamic am t (Typ.entry l right) →
  Subtyping.Dynamic am t (Typ.entry l (Typ.inter left right))
:= by sorry




lemma Subtyping.Dynamic.diff_elim {am left right t} :
  Subtyping.Dynamic am left (Typ.unio t right) →
  Subtyping.Dynamic am (Typ.diff left right) t
:= by sorry


lemma Subtyping.Dynamic.not_diff_elim {am t0 t1 t2} :
  Typ.toBruijn [] t1 = Typ.toBruijn [] t2 →
  ¬ Dynamic am (Typ.diff t0 t1) t2
:= by sorry

lemma Subtyping.Dynamic.not_diff_intro {am t0 t1 t2} :
  Typ.toBruijn [] t0 = Typ.toBruijn [] t2 →
  ¬ Dynamic am t0 (Typ.diff t1 t2)
:= by sorry



lemma Subtyping.Dynamic.diff_sub_elim {am lower upper} sub:
  Subtyping.Dynamic am lower sub →
  Subtyping.Dynamic am (Typ.diff lower sub) upper
:= by sorry

lemma Subtyping.Dynamic.diff_upper_elim {am lower upper} sub:
  Subtyping.Dynamic am lower upper →
  Subtyping.Dynamic am (Typ.diff lower sub) upper
:= by sorry


-- lemma Subtyping.Dynamic.exi_intro {am am' t ids quals body} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping.Dynamic (am' ++ am) quals →
--   Subtyping.Dynamic (am' ++ am) t body →
--   Subtyping.Dynamic am t (Typ.exi ids quals body)
-- := by sorry

lemma Subtyping.Dynamic.lfp_skip_elim {am id body t} :
  id ∉ Typ.free_vars body →
  Subtyping.Dynamic am body t →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry

lemma Subtyping.Dynamic.lfp_induct_elim {am id body t} :
  Typ.Monotonic.Dynamic am id body →
  Subtyping.Dynamic am (Typ.sub [(id, t)] body) t →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry

lemma Subtyping.Dynamic.lfp_factor_elim {am id lower upper l fac} :
  Typ.factor id lower l = .some fac →
  Subtyping.Dynamic am fac upper →
  Subtyping.Dynamic am (Typ.lfp id lower) (.entry l upper)
:= by sorry


lemma Subtyping.Dynamic.lfp_elim_diff_intro {am id lower upper sub n} :
  Typ.Monotonic.Dynamic am id lower →
  Subtyping.Dynamic am (Typ.lfp id lower) upper →
  ¬ Subtyping.Dynamic am (Typ.subfold id lower 1) sub →
  ¬ Subtyping.Dynamic am sub (Typ.subfold id lower n) →
  Subtyping.Dynamic am (Typ.lfp id lower) (.diff upper sub)
:= by sorry

lemma Subtyping.Dynamic.diff_intro {am t left right} :
  Subtyping.Dynamic am t left →
  ¬ (Subtyping.Dynamic am t right) →
  ¬ (Subtyping.Dynamic am right t) →
  Subtyping.Dynamic am t (Typ.diff left right)
:= by sorry


lemma Subtyping.Dynamic.lfp_peel_intro {am t id body} :
  Subtyping.Dynamic am t (Typ.sub [(id, .lfp id body)] body) →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

lemma Subtyping.Dynamic.lfp_drop_intro {am t id body} :
  Subtyping.Dynamic am t (Typ.drop id body) →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

lemma Subtyping.Dynamic.exi_intro {am t ids quals body} :
  MultiSubtyping.Dynamic am quals →
  Subtyping.Dynamic am t body →
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

-- lemma Subtyping.Dynamic.all_elim {am am' ids quals body t} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping.Dynamic (am' ++ am) quals →
--   Subtyping.Dynamic (am' ++ am) body t →
--   Subtyping.Dynamic am (Typ.all ids quals body) t
-- := by sorry

lemma Subtyping.Dynamic.all_elim {am ids quals body t} :
  MultiSubtyping.Dynamic am quals →
  Subtyping.Dynamic am body t →
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
  Typ.Monotonic.Dynamic am id body →
  Subtyping.Dynamic ((id, (Typ.lfp id body)) :: am) t body →
  Subtyping.Dynamic am t (Typ.lfp id body)
:= by sorry

lemma Subtyping.Dynamic.lfp_elim {am id body t} :
  Typ.Monotonic.Dynamic am id body →
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


lemma Typing.Dynamic.empty_record_top am :
  Typing.Dynamic am (Expr.record []) Typ.top
:= by sorry

lemma Typing.Dynamic.inter_entry_intro {am l e r body t} :
  Typing.Dynamic am e body →
  Typing.Dynamic am (.record r) t  →
  Typing.Dynamic am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry

lemma Typing.Dynamic.function_head_elim {am p e f subtras tp tr} :
  (∀ {v} ,
    IsValue v → Typing.Dynamic am v tp →
    ∃ eam , pattern_match v p = .some eam ∧ Typing.Dynamic am (Expr.sub eam e) tr
  ) →
  Typing.Dynamic am (Expr.function ((p, e) :: f)) (Typ.path (ListTyp.diff tp subtras) tr)
:= by sorry

lemma Typing.Dynamic.function_tail_elim {am p tp e f t } :
  (∀ {v} , IsValue v → Typing.Dynamic am v tp → ∃ eam , pattern_match v p = .some eam) →
  ¬ Subtyping.Dynamic am t (.path tp .top) →
  Typing.Dynamic am (.function f) t →
  Typing.Dynamic am (.function ((p,e) :: f)) t
:= by sorry


lemma Typing.Dynamic.path_elim {am ef ea t t'} :
  Typing.Dynamic am ef (.path t t') →
  Typing.Dynamic am ea t →
  Typing.Dynamic am (.app ef ea) t'
:= by sorry

lemma Typing.Dynamic.loop_path_elim {am e t} id :
  Typing.Dynamic am e (.path (.var id) t) →
  Typing.Dynamic am (.loop e) t
:= by sorry

lemma Typing.Dynamic.anno_intro {am e t ta} :
  Subtyping.Dynamic am t ta →
  Typing.Dynamic am e t →
  Typing.Dynamic am (.anno e ta) ta
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

lemma Subtyping.Dynamic.pluck {am cs lower upper} :
  MultiSubtyping.Dynamic am cs →
  (lower, upper) ∈ cs →
  Subtyping.Dynamic am lower upper
:= by sorry

lemma Subtyping.Dynamic.trans {am lower upper} t :
  Subtyping.Dynamic am lower t → Subtyping.Dynamic am t upper →
  Subtyping.Dynamic am lower upper
:= by
  simp [Subtyping.Dynamic]
  intros p0 p1
  intros e p5
  apply p1
  apply p0
  assumption

lemma Subtyping.check_completeness {am lower upper} :
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


  theorem Subtyping.Static.soundness {skolems assums lower upper skolems' assums'} :
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
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.entry_pres l (ih0r p9)

  | .path_pres lower0 lower1 upper0 upper1 skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
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
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
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

    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

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
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
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
    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

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
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (ih0r p40) (Subtyping.Dynamic.pluck p40 (p10 p1))

  | .skolem_elim t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (Subtyping.Dynamic.pluck p40 (p10 p1)) (ih0r p40)

  -------------------------------------------------------------------
  | .unio_antec a b r skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
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
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
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
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.attributes p1
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
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_skip_elim p0 (ih0r p40)

  | .lfp_induct_elim id lower p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_induct_elim (Typ.Monotonic.Static.soundness (am0 ++ am') p0) (ih0r p40)

  | .lfp_factor_elim id lower upper fac p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_factor_elim p0 (ih0r p40)

  | .lfp_elim_diff_intro id lower upper sub h p0 p1 p2 p3 p4 p5 p6 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p4
    have ⟨p10,p15,p20,p25,p30,p35,p40⟩ := Subtyping.Static.attributes p4
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
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p3
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
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_peel_intro (ih0r p40)

  | .lfp_drop_intro id body p0 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_drop_intro (ih0r p40)
  -------------------------------------------------------------------

  | .diff_sub_elim lower sub upper p0  => by

    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p10
    apply Subtyping.Dynamic.diff_sub_elim sub (ih0r p10)

  | .diff_upper_elim lower sub p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p10
    apply Subtyping.Dynamic.diff_upper_elim sub (ih0r p10)

  | .unio_left_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_left_intro (ih0r p9)

  | .unio_right_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_right_intro (ih0r p9)

  | .exi_intro ids quals upper skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.attributes p1
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
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp[*]
    intros am' p9
    exact Subtyping.Dynamic.inter_left_elim (ih0r p9)

  | .inter_right_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.attributes p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.inter_right_elim (ih0r p9)

  | .all_elim ids quals lower skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.attributes p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.attributes p1
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
  ∃ e , MultiProgression a e ∧ MultiProgression b e

lemma Expr.Convergence.typing_left_to_right {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am a t →
  Typing.Dynamic am b t
:= by sorry

lemma Expr.Convergence.typing_right_to_left {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am b t →
  Typing.Dynamic am a t
:= by sorry


lemma Typ.factor_expansion_soundness {am id t label t' e'} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e' (.lfp id t') →
  ∃ e ,
    Expr.Convergence (Expr.proj e label) e' ∧
    Typing.Dynamic am e (.lfp id t)
:= by sorry

lemma Typ.factor_reduction_soundness {am id t label t' e' e} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e (.lfp id t) →
  Expr.Convergence (Expr.proj e label) e' →
  Typing.Dynamic am e' (.lfp id t')
:= by sorry



lemma ListZone.pack_positive_soundness {pids zones t am assums e} :
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


lemma Expr.Convergence.transitivity {a b c} :
  Expr.Convergence a b →
  Expr.Convergence b c →
  Expr.Convergence a c
:= by sorry

lemma Expr.Convergence.swap {a b} :
  Expr.Convergence a b →
  Expr.Convergence b a
:= by sorry

lemma Expr.Convergence.app_arg_preservation {f a b} :
  Expr.Convergence a b →
  Expr.Convergence (.app f a) (.app f b)
:= by sorry

lemma ListZone.pack_negative_soundness {pids zones t am assums e} :
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

lemma ListZone.inversion_soundness {id zones zones' am assums} :
  ListZone.invert id zones = some zones' →
  MultiSubtyping.Dynamic am assums →
  ∀ ef,
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) ef t' ) ) )
  ↔
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


lemma Typing.Dynamic.lfp_elim_top {am e id t} :
  Typ.Monotonic.Dynamic am id t →
  Typing.Dynamic am e (.lfp id t) →
  Typing.Dynamic ((id, .top) :: am) e t
:= by sorry

lemma Typing.Dynamic.existential_top_drop {id am assums ep} {zones' : List Zone} :
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
-- ∃ skolems' assums' t',
--   { skolems := skolems', assums := assums', typ := t' } ∈ zones' ∧
--     ∀ (am'' : List (String × Typ)),
--       ListPair.dom am'' ⊆ skolems' →
--         ∃ am',
--           ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
--             MultiSubtyping.Dynamic (am'' ++ am' ++ (id, Typ.top) :: am) assums' ∧
--               Typing.Dynamic (am'' ++ am' ++ (id, Typ.top) :: am) ep t'

lemma Subtyping.LoopListZone.Static.soundness {id zones t am assums e} :
  Subtyping.LoopListZone.Static (ListSubtyping.free_vars assums) id zones t →
  MultiSubtyping.Dynamic am assums →
  id ∉ ListSubtyping.free_vars assums →
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) ) →
  Typing.Dynamic am e t
:= by
  intros p0 p1 p2 p3
  cases p0 with
  | batch zones' t' left right p4 p5 p6 p7 p8 =>
    unfold Typing.Dynamic
    intro ea
    intro p9

    have ⟨ep,p10,p11⟩ := Typ.factor_expansion_soundness p7 p9

    apply Expr.Convergence.typing_left_to_right
      (Expr.Convergence.app_arg_preservation p10)

    apply Typ.factor_reduction_soundness p8 p11

    rw [ListZone.inversion_soundness p4 p1] at p3

    apply p3 ep

    have p12 : Typing.Dynamic ((id, .top) :: am) ep t' := by
      apply Typing.Dynamic.lfp_elim_top (Typ.Monotonic.Static.soundness am p6) p11
    have p13 : MultiSubtyping.Dynamic ((id,.top) :: am) assums := by
      apply MultiSubtyping.Dynamic.dom_single_extension Typ.top p2 p1

    apply Typing.Dynamic.existential_top_drop p2
    apply ListZone.pack_negative_soundness p5
      (List.subset_cons_of_subset id (fun _ x => x)) p13 p12

  | stream
    skolems assums0 assums' idl r t' l r' l' r''
    p4 p5 p6 p7 p8 p9 p10 p11
  =>
    unfold Typing.Dynamic
    intro ea
    intro p12

    have myLemmaA : Subtyping.Dynamic am (Typ.var idl) (.lfp id l) := sorry
    have myLemmaB : Subtyping.Dynamic am (.lfp id r') (.lfp id r'') := sorry

    unfold Subtyping.Dynamic at myLemmaA
    unfold Subtyping.Dynamic at myLemmaB

    apply myLemmaA at p12
    apply myLemmaB

    have ⟨ep,p13,p14⟩ := Typ.factor_expansion_soundness p7 p12

    apply Expr.Convergence.typing_left_to_right
      (Expr.Convergence.app_arg_preservation p13)

    apply Typ.factor_reduction_soundness p8 p14

    sorry

lemma ListZone.tidy_soundness {zones0 zones1 am assums e} :
  ListZone.tidy (ListSubtyping.free_vars assums) zones0 = .some zones1 →
  MultiSubtyping.Dynamic am assums →
  (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
    (∃ am'', ListPair.dom am'' ⊆ skolems ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 →
        Typing.Dynamic (am'' ++ am' ++ am) e t0 ) ) ) →

  (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
    (∃ am'', ListPair.dom am'' ⊆ skolems ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums1 →
        Typing.Dynamic (am'' ++ am' ++ am) e t1 ) ) )
:= by sorry

lemma ListZone.tidy_soundness_alt
  {zones0 zones1 e context skolems assums1 t1}
  {assums : List (Typ × Typ)}
:
  ListZone.tidy (ListSubtyping.free_vars assums) zones0 = .some zones1 →
  ⟨skolems, assums1, t1⟩ ∈ zones1 →

  (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
    (∃ am'', ListPair.dom am'' ⊆ skolems ∧
      (∀ {am'},
        MultiSubtyping.Dynamic (am'' ++ am') (assums0 ++ assums) →
        ∀ {eam}, MultiTyping.Dynamic am' eam context →
        Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t0 ) ) ) →

  (∃ am'', ListPair.dom am'' ⊆ skolems ∧
    (∀ {am'},
      MultiSubtyping.Dynamic (am'' ++ am') (assums1 ++ assums) →
      ∀ {eam}, MultiTyping.Dynamic am' eam context →
      Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t1 ) )
:= by sorry


lemma MultiSubtyping.Dynamic.concat {am cs cs'} :
  MultiSubtyping.Dynamic am cs →
  MultiSubtyping.Dynamic am cs' →
  MultiSubtyping.Dynamic am (cs ++ cs')
:= by sorry



lemma PatLifting.Static.soundness {assums context p t assums' context'} :
  PatLifting.Static assums context p t assums' context' →
  ∀ tam v, IsValue v → Typing.Dynamic tam v t →
    ∃ eam , pattern_match v p = .some eam ∧ MultiTyping.Dynamic tam eam context'
:= by sorry


lemma pattern_match_ids_containment {v p eam} :
  pattern_match v p = .some eam →
  ids_pattern p ⊆ ListPair.dom eam
:= by sorry



-- lemma PatLifting.Static.attributes {assums context p t assums' context'} :
--   PatLifting.Static assums context p t assums' context' →
--   assums ⊆ assums' ∧
--   Typ.free_vars t ⊆ ListTyping.free_vars context' ∧
--   ListTyping.free_vars context'  ⊆ ListSubtyping.free_vars assums'
-- := by sorry


lemma Expr.sub_sub_removal {ids eam0 eam1 e} :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry



lemma Typing.Function.Static.subtra_soundness {
  skolems assums context f zones subtra subtras skolems' assums' t
} :
  Typing.Function.Static skolems assums context  subtras f zones →
  subtra ∈ subtras →
  ⟨skolems', assums', t⟩ ∈ zones →
  ∀ am , ¬ Subtyping.Dynamic am t (.path subtra .top)
:= by sorry

-- set_option maxHeartbeats 1000000 in
mutual

  theorem Typing.Function.Static.soundness {
    skolems assums context f zones subtras skolems' assums' t
  } :
    Typing.Function.Static skolems assums context subtras f zones →
    ⟨skolems', assums', t⟩ ∈ zones →
    ∃ tam, ListPair.dom tam ⊆ skolems' ∧
    (∀ {tam'}, MultiSubtyping.Dynamic (tam ++ tam') (assums' ++ assums) →
      (∀ {eam}, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam (.function f)) t ) )
  | .nil => by intros ; contradiction
  | .cons
      p e f assums0 context0 tp zones zones' zones'' subtras
      p0 p1 p2 p3 p4
  => by
    intro p10
    apply Iff.mp List.mem_append at p10
    cases p10 with
    | inl p11 =>
      clear p0
      apply ListZone.tidy_soundness_alt p4 p11
      intros skolems' assums' t p12
      have ⟨assums_ext, p20, tr, p22⟩ := p2 p12
      rw [p22] at p12
      have p23 := p3 p12

      have ⟨tam0,ih0l,ih0r⟩ := Typing.Static.soundness p23
      have ⟨p24,p26,p28,p30,p32,p34⟩ := Typing.Static.attributes p23

      exists tam0
      apply And.intro (fun _ p38 => containment_mdiff_concat_elim (ih0l p38))

      intros tam' p40
      intros eam p42
      rw [p22]

      simp [Expr.sub, Expr.Function.sub]
      apply Typing.Dynamic.function_head_elim
      intros v p44 p46
      have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness p1 (tam0 ++ tam') v p44 p46
      exists eam0
      simp [*]
      rw [Expr.sub_sub_removal (pattern_match_ids_containment p48)]
      apply ih0r p40
      apply MultiTyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p28 p32 }
      { apply MultiTyping.Dynamic.dom_context_extension p50 }

    | inr p11 =>
      have ⟨tam0,ih0l,ih0r⟩ := Typing.Function.Static.soundness p0 p11
      have ⟨p20,p22,p24,p26⟩ := Typing.Function.Static.attributes p0 p11

      exists tam0
      simp [*]
      intros tam' p30
      intros eam p32

      apply Typing.Dynamic.function_tail_elim
      { intros v p40 p42
        have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness p1 (tam0 ++ tam') v p40 p42
        apply Exists.intro eam0 p48 }
      { apply Typing.Function.Static.subtra_soundness p0 List.mem_cons_self p11 }
      { apply ih0r p30 p32 }


  theorem Typing.Record.Static.soundness {skolems assums context r t skolems' assums'} :
    Typing.Record.Static skolems assums context r t skolems' assums' →
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

  | .cons l e r body t skolems0 assums0 p0 p1 => by

    have ⟨tam0,ih0l,ih0r⟩ := Typing.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30⟩ := Typing.Static.attributes p0
    have ⟨tam1,ih1l,ih1r⟩ := Typing.Record.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26,p31⟩ := Typing.Record.Static.attributes p1

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


  theorem Typing.Static.soundness {skolems assums context e t skolems' assums'} :
    Typing.Static skolems assums context e t skolems' assums' →
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
    apply Typing.Record.Static.soundness p0

  | .function f zones p0 p1 => by
      exists []
      simp [*, ListPair.dom]
      intros tam' p2
      intros eam p3

      apply ListZone.pack_positive_soundness p1 (fun _ x => x) p2
      intros skolesm0 assums0 t0 p4
      have ⟨tam0,ih0l,ih0r⟩ := Typing.Function.Static.soundness p0 p4
      have ⟨p10,p11,p12,p13⟩ := Typing.Function.Static.attributes p0 p4
      exists tam0
      simp [*]
      intro tam''
      intros p5 p6
      apply ih0r
      { apply MultiSubtyping.Dynamic.concat  p6
        apply MultiSubtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih0l p11 }
        { apply MultiSubtyping.Dynamic.dom_extension p5 p2 } }
      { apply MultiTyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_right p13 p5 }
        { apply p3 } }

  | .app ef ea id tf skolems0 assums0 ta skolems1 assums1 p0 p1 p2 => by
    have ⟨tam0,ih0l,ih0r⟩ := Typing.Static.soundness p0
    have ⟨p5,p6,p105,p7,p8,p9⟩ := Typing.Static.attributes p0
    have ⟨tam1,ih1l,ih1r⟩ := Typing.Static.soundness p1
    have ⟨p10,p11,p107,p12,p13,p14⟩ := Typing.Static.attributes p1
    have ⟨tam2,ih2l,ih2r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.attributes p2
    exists tam2 ++ (tam1 ++ tam0)
    simp [*]
    apply And.intro
    { apply dom_concat_mdiff_containment
      { intro a p30 ; apply p10 (p5 p30) }
      { apply dom_concat_mdiff_containment p5 ih0l p10 ih1l }
      { apply p15 }
      { apply ih2l } }

    { intro tam' p30 eam p31
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

  | .loop body t0 id zones zones' p0 p1 p2 p3 => by
    have ⟨tam0,ih0l,ih0r⟩ := Typing.Static.soundness p0
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Typing.Static.attributes p0
    exists tam0
    simp [*]

    intros tam' p20
    intros eam p30
    apply Subtyping.LoopListZone.Static.soundness p3 p20
    apply ListZone.tidy_soundness p2 p20
    intros skolems0 assums0 t0 p40

    apply p1 at p40
    have ⟨tam1, h33l, h33r⟩ := Subtyping.Static.soundness p40
    have ⟨p41,p42,p43,p44,p45,p46,p47⟩ := Subtyping.Static.attributes p40
    exists tam1
    simp [*]
    apply And.intro (fun _ p50 => containment_mdiff_concat_elim (h33l p50))
    intros tam' p55 p56
    apply Typing.Dynamic.loop_path_elim id
    unfold Subtyping.Dynamic at h33r
    apply h33r
    { apply MultiSubtyping.Dynamic.concat p56
      apply MultiSubtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left h33l p45 }
      { apply MultiSubtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_right
            (ListSubtyping.free_vars_containment p6) p55 }
        { apply MultiSubtyping.Dynamic.reduction p6 p20 } }
    }
    {
      apply Typing.Dynamic.dom_extension (List.disjoint_preservation_left h33l p46)
      apply Typing.Dynamic.dom_extension (List.disjoint_preservation_right p8 p55)
      apply ih0r p20 p30
    }

  | .anno e ta te skolems0 assums0 p0 p1 p2 => by
    have ⟨tam0,ih0l,ih0r⟩ := Typing.Static.soundness p1
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Typing.Static.attributes p1
    have ⟨tam1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.attributes p2
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

  -- TODO: consider removing unit and using @ syntax to mean empty record.
end
