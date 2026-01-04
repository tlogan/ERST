import Lang.Basic
import Lang.Dynamic.NEvalCxt
import Lang.Dynamic.NStep
import Lang.Dynamic.NStepStar
import Lang.Dynamic.Safe
import Lang.Dynamic.FinTyping

set_option pp.fieldNotation false

namespace Lang.Dynamic


mutual
  def Subtyping (am : List (String × Typ)) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing am e left → Typing am e right
  termination_by Typ.size left + Typ.size right
  decreasing_by
    all_goals simp [Typ.zero_lt_size]

  def MultiSubtyping (am : List (String × Typ)) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping am left right ∧ MultiSubtyping am remainder
  termination_by sts => List.pair_typ_size sts
  decreasing_by
    all_goals simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size]

  def Monotonic (am : List (String × Typ)) (id : String) (body : Typ) : Prop :=
    (∀ t0 t1,
      Subtyping am t0 t1 →
      ∀ e, Typing ((id,t0):: am) e body → Typing ((id,t1):: am) e body
    )
  termination_by Typ.size body
  decreasing_by
    all_goals sorry

  def Typing (am : List (String × Typ)) (e : Expr) : Typ → Prop
  | .bot => False
  | .top => Safe e
  | .iso l t => Typing am (.extract e l) t
  | .entry l t => Typing am (.project e l) t
  | .path left right => ∀ arg ,
    Typing am arg left → Typing am (.app e arg) right
  | .unio left right => Typing am e left ∨ Typing am e right
  | .inter left right => Typing am e left ∧ Typing am e right
  | .diff left right => Typing am e left ∧ ¬ (Typing am e right)
  | .exi ids quals body =>
    ∃ am' , (ListPair.dom am') ⊆ ids ∧
    (MultiSubtyping (am' ++ am) quals) ∧
    (Typing (am' ++ am) e body)
  | .all ids quals body =>
    (∀ am' , (ListPair.dom am') ⊆ ids → (MultiSubtyping (am' ++ am) quals) →
      (Typing (am' ++ am) e body)
    ) ∧
    (∃ am' , (ListPair.dom am') ⊆ ids ∧ (MultiSubtyping (am' ++ am) quals))
  | .lfp id body =>
    Monotonic am id body ∧
    (∃ t, ∃ (h : Typ.size t < Typ.size (.lfp id body)),
      (∀ e',
        Typing am e' t →
        Typing ((id,t) :: am) e' body
      ) ∧
      Typing ((id,t) :: am) e  body
    )
  -----------------------
  -- TODO: remove old lfp case
  -- | .lfp id body =>
  --   Typ.Monotonic id true body ∧
  --   ∃ n, FinTyping e (Typ.sub am (Typ.subfold id body n))
  | .var id => ∃ t, find id am = some t ∧ FinTyping e t
  termination_by t => (Typ.size t)
  decreasing_by
    all_goals simp_all [Typ.size]
    all_goals try linarith
end


mutual
  theorem Typing.subject_reduction
    (transition : NStep e e')
  : Typing am e t → Typing am e' t
  := by cases t with
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h0
    sorry
    -- exact Safe.subject_reduction transition h0

  | iso label body =>
    unfold Typing
    intro h0
    apply Typing.subject_reduction
    {
      have necxt := NEvalCxt.extract label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | entry label body =>
    unfold Typing
    intro h0
    apply Typing.subject_reduction
    {
      have necxt := NEvalCxt.project label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }


  | path left right =>
    unfold Typing
    intro h0 e'' h1
    specialize h0 e'' h1
    apply Typing.subject_reduction
    {
      have necxt := NEvalCxt.applicator e'' .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | unio left right =>
    unfold Typing
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply Typing.subject_reduction transition h2
    | inr h2 =>
      apply Or.inr
      apply Typing.subject_reduction transition h2

  | inter left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_reduction transition h0 }
    { apply Typing.subject_reduction transition h1 }

  | diff left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_reduction transition h0 }
    {
      intro h2
      apply h1
      apply Typing.subject_expansion transition h2
    }

  | exi ids quals body =>
    unfold Typing
    intro ⟨am',h0,h1,h2⟩
    exists am'
    apply And.intro h0
    apply And.intro h1
    apply Typing.subject_reduction transition h2

  | all ids quals body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    {
      intro am' h2 h3
      apply Typing.subject_reduction transition (h0 am' h2 h3)
    }
    { exact h1 }

  | lfp id body =>
    unfold Typing
    intro ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩
    apply And.intro monotonic_body
    exists t
    exists lt_size
    apply And.intro imp_dynamic
    apply Typing.subject_reduction transition dynamic_body

  | var id =>
    unfold Typing
    intro ⟨t, h1, h2⟩
    exists t
    apply And.intro h1
    apply FinTyping.subject_reduction transition h2

  theorem Typing.subject_expansion
    (transition : NStep e e')
  : Typing am e' t → Typing am e t
  := by cases t with
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h0
    sorry
    -- exact Safe.subject_expansion transition h0

  | iso label body =>
    unfold Typing
    intro h0
    apply Typing.subject_expansion
    {
      have necxt := NEvalCxt.extract label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | entry label body =>
    unfold Typing
    intro h0
    apply Typing.subject_expansion
    {
      have necxt := NEvalCxt.project label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }


  | path left right =>
    unfold Typing
    intro h0 e'' h1
    specialize h0 e'' h1
    apply Typing.subject_expansion
    {
      have necxt := NEvalCxt.applicator e'' .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | unio left right =>
    unfold Typing
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply Typing.subject_expansion transition h2
    | inr h2 =>
      apply Or.inr
      apply Typing.subject_expansion transition h2

  | inter left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_expansion transition h0 }
    { apply Typing.subject_expansion transition h1 }

  | diff left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_expansion transition h0 }
    {
      intro h2
      apply h1
      apply Typing.subject_reduction transition h2
    }

  | exi ids quals body =>
    unfold Typing
    intro ⟨am',h0,h1,h2⟩
    exists am'
    apply And.intro h0
    apply And.intro h1
    apply Typing.subject_expansion transition h2

  | all ids quals body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    {
      intro am' h2 h3
      apply Typing.subject_expansion transition (h0 am' h2 h3)
    }
    { exact h1 }

  | lfp id body =>
    unfold Typing
    intro ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩
    apply And.intro monotonic_body
    exists t
    exists lt_size
    apply And.intro imp_dynamic
    apply Typing.subject_expansion transition dynamic_body

  | var id =>
    unfold Typing
    intro ⟨t, h1, h2⟩
    exists t
    apply And.intro h1
    apply FinTyping.subject_expansion transition h2
end





def MultiTyping
  (tam : List (String × Typ)) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, find x context = .some t → ∃ e, (find x eam) = .some e ∧ Typing tam e t



theorem MultiSubtyping.removeAll_union {tam cs' cs} :
  MultiSubtyping tam (List.removeAll cs' cs ∪ cs) →
  MultiSubtyping tam cs'
:= by sorry



theorem Typing.dom_reduction {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing (tam1 ++ tam0) e t →
  Typing tam0 e t
:= by sorry

theorem Typing.dom_extension {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing tam0 e t →
  Typing (tam1 ++ tam0) e t
:= by sorry

theorem Typing.dom_single_extension {id am e t t'} :
  id ∉ Typ.free_vars t →
  Typing am e t' →
  Typing ((id,t) :: am) e t'
:= by sorry


theorem MultiTyping.dom_reduction {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping (tam1 ++ tam0) eam cs →
  MultiTyping tam0 eam cs
:= by sorry


theorem MultiTyping.dom_extension {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping tam0 eam cs →
  MultiTyping (tam1 ++ tam0) eam cs
:= by sorry

theorem MultiTyping.dom_context_extension {tam eam cs} :
  MultiTyping tam eam cs →
  ∀ eam', MultiTyping tam (eam ++ eam') cs
:= by sorry


theorem Subtyping.dom_extension {am1 am0 lower upper} :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping am0 lower upper →
  Subtyping (am1 ++ am0) lower upper
:= by sorry

theorem MultiSubtyping.dom_single_extension {id tam0 t cs} :
  id ∉ List.pair_typ_free_vars cs →
  MultiSubtyping tam0 cs →
  MultiSubtyping ((id,t) :: tam0) cs
:= by sorry

theorem MultiSubtyping.dom_extension {am1 am0 cs} :
  (ListPair.dom am1) ∩ List.pair_typ_free_vars cs = [] →
  MultiSubtyping am0 cs →
  MultiSubtyping (am1 ++ am0) cs
:= by sorry

theorem MultiSubtyping.dom_reduction {am1 am0 cs} :
  (ListPair.dom am1) ∩ List.pair_typ_free_vars cs = [] →
  MultiSubtyping (am1 ++ am0) cs →
  MultiSubtyping am0 cs
:= by sorry

theorem MultiSubtyping.reduction {am cs cs'} :
  cs ⊆ cs' →
  MultiSubtyping am cs'  →
  MultiSubtyping am cs
:= by sorry

theorem Subtyping.refl am t :
  Subtyping am t t
:= by sorry

theorem Subtyping.unio_left_intro {am t l r} :
  Subtyping am t l →
  Subtyping am t (Typ.unio l r)
:= by sorry


theorem Subtyping.unio_right_intro {am t l r} :
  Subtyping am t r →
  Subtyping am t (Typ.unio l r)
:= by sorry

theorem Subtyping.inter_left_elim {am l r t} :
  Subtyping am l t →
  Subtyping am (Typ.inter l r) t
:= by sorry

theorem Subtyping.inter_right_elim {am l r t} :
  Subtyping am r t →
  Subtyping am (Typ.inter l r) t
:= by sorry


theorem Subtyping.iso_pres {am bodyl bodyu} l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.iso l bodyl) (Typ.iso l bodyu)
:= by sorry

theorem Subtyping.entry_pres {am bodyl bodyu} l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.entry l bodyl) (Typ.entry l bodyu)
:= by sorry

theorem Subtyping.path_pres {am p q x y} :
  Subtyping am x p →
  Subtyping am q y →
  Subtyping am (Typ.path p q) (Typ.path x y)
:= by sorry


theorem Subtyping.unio_elim {am left right t} :
  Subtyping am left t →
  Subtyping am right t →
  Subtyping am (Typ.unio left right) t
:= by sorry


theorem Subtyping.inter_intro {am t left right} :
  Subtyping am t left →
  Subtyping am t right →
  Subtyping am t (Typ.inter left right)
:= by sorry

theorem Subtyping.unio_antec {am t left right upper} :
  Subtyping am t (Typ.path left upper) →
  Subtyping am t (Typ.path right upper) →
  Subtyping am t (Typ.path (Typ.unio left right) upper)
:= by sorry

theorem Subtyping.inter_conseq {am t upper left right} :
  Subtyping am t (Typ.path upper left) →
  Subtyping am t (Typ.path upper right) →
  Subtyping am t (Typ.path upper (Typ.inter left right))
:= by sorry

theorem Subtyping.inter_entry {am t l left right} :
  Subtyping am t (Typ.entry l left) →
  Subtyping am t (Typ.entry l right) →
  Subtyping am t (Typ.entry l (Typ.inter left right))
:= by sorry




theorem Subtyping.diff_elim {am lower sub upper} :
  Subtyping am lower (Typ.unio sub upper) →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry


theorem Subtyping.not_diff_elim {am t0 t1 t2} :
  Typ.toBruijn [] t1 = Typ.toBruijn [] t2 →
  ¬ Subtyping am (Typ.diff t0 t1) t2
:= by sorry

theorem Subtyping.not_diff_intro {am t0 t1 t2} :
  Typ.toBruijn [] t0 = Typ.toBruijn [] t2 →
  ¬ Subtyping am t0 (Typ.diff t1 t2)
:= by sorry



theorem Subtyping.diff_sub_elim {am lower upper} sub:
  Subtyping am lower sub →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry

theorem Subtyping.diff_upper_elim {am lower upper} sub:
  Subtyping am lower upper →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry


-- theorem Subtyping.exi_intro {am am' t ids quals body} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping (am' ++ am) quals →
--   Subtyping (am' ++ am) t body →
--   Subtyping am t (Typ.exi ids quals body)
-- := by sorry

theorem Subtyping.lfp_skip_elim {am id body t} :
  id ∉ Typ.free_vars body →
  Subtyping am body t →
  Subtyping am (Typ.lfp id body) t
:= by sorry

theorem Subtyping.diff_intro {am t left right} :
  Subtyping am t left →
  ¬ (Subtyping am t right) →
  ¬ (Subtyping am right t) →
  Subtyping am t (Typ.diff left right)
:= by sorry


theorem Subtyping.exi_intro {am t ids quals body} :
  MultiSubtyping am quals →
  Subtyping am t body →
  Subtyping am t (Typ.exi ids quals body)
:= by sorry

theorem Subtyping.exi_elim {am ids quals body t} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) body t
  ) →
  Subtyping am (Typ.exi ids quals body) t
:= by sorry

-- theorem Subtyping.all_elim {am am' ids quals body t} :
--   ListPair.dom am' ⊆ ids →
--   MultiSubtyping (am' ++ am) quals →
--   Subtyping (am' ++ am) body t →
--   Subtyping am (Typ.all ids quals body) t
-- := by sorry

theorem Subtyping.all_elim {am ids quals body t} :
  MultiSubtyping am quals →
  Subtyping am body t →
  Subtyping am (Typ.all ids quals body) t
:= by sorry

theorem Subtyping.all_intro {am t ids quals body} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    ListPair.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) t body
  ) →
  Subtyping am t (Typ.all ids quals body)
:= by sorry

theorem Subtyping.lfp_intro {am t id body} :
  Monotonic am id body →
  Subtyping ((id, (Typ.lfp id body)) :: am) t body →
  Subtyping am t (Typ.lfp id body)
:= by sorry

theorem Subtyping.lfp_elim {am id body t} :
  Monotonic am id body →
  id ∉ Typ.free_vars t →
  Subtyping ((id, t) :: am) t body →
  Subtyping am (Typ.lfp id body) t
:= by sorry


theorem Subtyping.rename_lower {am lower lower' upper} :
  Typ.toBruijn [] lower = Typ.toBruijn [] lower' →
  Subtyping am lower upper →
  Subtyping am lower' upper
:= by sorry

theorem Subtyping.rename_upper {am lower upper upper'} :
  Typ.toBruijn [] upper = Typ.toBruijn [] upper' →
  Subtyping am lower upper →
  Subtyping am lower upper'
:= by sorry

theorem Subtyping.bot_elim {am upper} :
  Subtyping am Typ.bot upper
:= by sorry

theorem Subtyping.top_intro {am lower} :
  Subtyping am lower Typ.top
:= by sorry


theorem Typing.empty_record_top am :
  Typing am (Expr.record []) Typ.top
:= by
  unfold Typing
  sorry
  -- apply Safe.record
  -- apply RecSafe.nil

theorem Typing.inter_entry_intro {am l e r body t} :
  Typing am e body →
  Typing am (.record r) t  →
  Typing am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry



theorem Typing.path_determines_function
  (typing : Typing am e (.path antec consq))
: ∃ f , NStepStar e (.function f)
:= by sorry



theorem Expr.sub_sub_removal :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry





theorem Typing.progress :
  Typing am e t →
  Expr.is_value e ∨ ∃ e' , NStep e e'
:= by
  sorry



theorem NStep.not_value :
  NStep e e' →
  ¬ Expr.is_value e
:= by sorry




-- theorem Divergent.necxt_preservation :
--   NEvalCxt E →
--   Divergent e →
--   Divergent (E e)
-- := by
--   intro h0 h1 e' h2
--   generalize h3 : (E e) = eg at h1
--   rw [h3] at h2
--   revert e

--   induction h2 with
--   | refl eg =>
--     intro e h1 h2
--     rw [← h2]
--     specialize h1 e (NStepStar.refl e)
--     have ⟨e', h3⟩ := h1
--     exists (E e')
--     exact NStep.necxt h0 h3

--   | step eg em e' h4 h5 ih =>

--     intro e h1 h2
--     rw [← h2] at h4
--     clear h2
--     apply Divergent.transition at h1
--     have ⟨et, h6,h7⟩ := h1
--     apply ih h7
--     apply NStep.deterministic
--     { exact NStep.necxt h0 h6 }
--     { exact h4 }

mutual
  def List.pair_typ_sub (δ : List (String × Typ)) : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder => .cons (Typ.sub δ l, Typ.sub δ r) (List.pair_typ_sub δ remainder)

  def Typ.sub (δ : List (String × Typ)) : Typ → Typ
  | .var id => match find id δ with
    | .none => .var id
    | .some t => t
  | .iso l body => .iso l (Typ.sub δ body)
  | .entry l body => .entry l (Typ.sub δ body)
  | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
  | .bot => .bot
  | .top => .top
  | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
  | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
  | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
  | .all ids subtypings body =>
      let δ' := remove_all δ ids
      .all ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .exi ids subtypings body =>
      let δ' := remove_all δ ids
      .exi ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end



theorem Typing.exists_value :
  Typing am e t →
  ∃ v , Expr.is_value v ∧ Typing am v t
:= by sorry



theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  exact subject_expansion NStep.project h0

theorem Subtyping.elimination :
  Subtyping am t0 t1 →
  Typing am e t0 →
  Typing am e t1
:= by
  unfold Subtyping
  intro h0 h1
  exact h0 e h1

theorem Subtyping.list_typ_diff_elim :
  Subtyping am (List.typ_diff tp subtras) tp
:= by
  sorry


theorem Typing.path_intro :
  (∀ e' ,
    Typing am e' tp →
    ∃ eam , Expr.pattern_match e' p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am (Expr.function ((p, e) :: f)) (Typ.path (List.typ_diff tp subtras) tr)
:= by
  intro h0
  unfold Typing
  intro e' h1
  have h3 := Subtyping.elimination Subtyping.list_typ_diff_elim h1
  have ⟨eam,h4,h5⟩ := h0 e' h3

  have h1 : NStep (Expr.app (Expr.function ((p, e) :: f)) e') (Expr.sub eam e) := by
    apply NStep.pattern_match h4
  exact subject_expansion h1 h5


theorem Typing.function_preservation {am p tp e f t } :
  (∀ {v} , Typing am v tp → ∃ eam , Expr.pattern_match v p = .some eam) →
  ¬ Subtyping am t (.path tp .top) →
  Typing am (.function f) t →
  Typing am (.function ((p,e) :: f)) t
:= by sorry


theorem Typing.star_preservation :
  NStepStar e e' →
  Typing am e t →
  Typing am e' t
:= by sorry


theorem Typing.path_elim
  (typing_cator : Typing am ef (.path t t'))
  (typing_arg : Typing am ea t)
: Typing am (.app ef ea) t'
:= by
  unfold Typing at typing_cator
  exact typing_cator ea typing_arg


theorem Typing.loop_path_elim {am e t} id :
  Typing am e (.path (.var id) t) →
  Typing am (.loop e) t
:= by
  sorry

theorem Typing.anno_intro {am e t ta} :
  Subtyping am t ta →
  Typing am e t →
  Typing am (.anno e ta) ta
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

  -- theorem List.pair_typ_bruijn_eq_imp_dynamic {am} :
  --   ∀ {lower upper},
  --   List.pair_typ_toBruijn 0 [] lower = List.pair_typ_toBruijn 0 [] upper →
  --   MultiSubtyping am lower →
  --   MultiSubtyping am upper
  -- := by sorry

theorem Subtyping.bruijn_eq {lower upper} am :
  Typ.toBruijn [] lower = Typ.toBruijn [] upper →
  Subtyping am lower upper
:= by
  intro p0
  apply Subtyping.rename_upper p0
  apply Subtyping.refl am lower



theorem List.pair_typ_toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  List.pair_typ_toBruijn ids' quals' = List.pair_typ_toBruijn ids quals
:= by sorry

theorem Typ.toBruijn_exi_injection {ids' quals' body' ids quals body} :
  Typ.toBruijn [] (.exi ids' quals' body') = Typ.toBruijn [] (.exi ids quals body) →
  Typ.toBruijn ids' body' = Typ.toBruijn ids body
:= by sorry


theorem MultiSubtyping.removeAll_removal {tam assums assums'} :
  MultiSubtyping tam assums →
  MultiSubtyping tam (List.removeAll assums' assums) →
  MultiSubtyping tam assums'
:= by sorry


theorem Subtyping.lfp_induct_elim {am id body t} :
  Monotonic am id body →
  (∀ e, Typing ((id, t) :: am) e body → Typing am e t) →
  Subtyping am (Typ.lfp id body) t
:= by sorry


theorem Typing.lfp_elim_top {am e id t} :
  Monotonic am id t →
  Typing am e (.lfp id t) →
  Typing ((id, .top) :: am) e t
:= by sorry

theorem Typing.lfp_intro_bot {am e id t} :
  Monotonic am id t →
  Typing ((id, .bot) :: am) e t →
  Typing am e (.lfp id t)
:= by sorry



theorem Subtyping.entry_preservation :
  Subtyping am t t' →
  Subtyping am (.entry l t) (.entry l t')
:= by
  unfold Subtyping
  intro h0 e h1
  unfold Typing
  apply h0
  unfold Typing at h1
  apply h1

theorem Subtyping.transitivity :
  Subtyping am t0 t1 →
  Subtyping am t1 t2 →
  Subtyping am t0 t2
:= by
  unfold Subtyping
  intro h0 h1 e h3
  apply h1
  specialize h0 e h3
  apply h0



theorem Typing.confluent_preservation {a b am t} :
  Confluent a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Typing.confluent_reflection {a b am t} :
  Confluent a b →
  Typing am b t →
  Typing am a t
:= by
  intro h0 h1
  apply Typing.confluent_preservation
  apply Confluent.swap h0
  exact h1





end Lang.Dynamic
