import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent
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
  | .top => Convergent e ∨ Divergent e
  | .iso l t => Typing am (.extract e l) t
  | .entry l t => Typing am (.project e l) t
  | .path left right => ∀ e' , Typing am e' left → Typing am (.app e e') right
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
  theorem Typing.subject_reduction :
    Transition e e' →
    Typing am e t →
    Typing am e' t
  := by
    sorry

  theorem Typing.subject_expansion
    (transition : Transition e e')
  : Typing am e' t → Typing am e t
  := by cases t with
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      exact Convergent.subject_expansion transition h2
    | inr h2 =>
      apply Or.inr
      exact Divergent.subject_expansion transition h2

  | iso label body =>
    unfold Typing
    intro h0
    apply Typing.subject_expansion
    {
      have evalcon := EvalCon.extract label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }

  | entry label body =>
    unfold Typing
    intro h0
    apply Typing.subject_expansion
    {
      have evalcon := EvalCon.project label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }


  | path left right =>
    unfold Typing
    intro h0 e'' h1
    specialize h0 e'' h1
    apply Typing.subject_expansion
    {
      have evalcon := EvalCon.applicator e'' .hole
      apply Transition.evalcon evalcon transition
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
  unfold Convergent
  apply Or.inl
  exists Expr.record []
  apply And.intro
  { exact TransitionStar.refl (Expr.record []) }
  { exact rfl }

theorem Typing.inter_entry_intro {am l e r body t} :
  Typing am e body →
  Typing am (.record r) t  →
  Typing am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry



theorem Typing.path_determines_function
  (typing : Typing am e (.path antec consq))
: ∃ f , TransitionStar e (.function f)
:= by sorry




theorem Typing.convergent_or_divergent
  (typing : Typing am e t)
: Convergent e ∨ Divergent e
:= by cases t with
| bot =>
  unfold Typing at typing
  exact False.elim typing

| top =>
  unfold Typing at typing
  exact typing

| iso label body =>
  unfold Typing at typing
  have ih := Typing.convergent_or_divergent typing
  cases ih with
  | inl h =>
    apply Or.inl
    apply Convergent.evalcon_reflection
    { apply EvalCon.extract label .hole }
    { exact h }
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_reflection
    { apply EvalCon.extract label .hole }
    { exact h }

| entry label body =>
  unfold Typing at typing
  have ih := Typing.convergent_or_divergent typing
  cases ih with
  | inl h =>
    apply Or.inl
    apply Convergent.evalcon_reflection
    { apply EvalCon.project label .hole }
    { exact h }
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_reflection
    { apply EvalCon.project label .hole }
    { exact h }

| path left right =>
  apply Typing.path_determines_function at typing
  have ⟨f, h0⟩ := typing
  apply Or.inl
  unfold Convergent
  exists (.function f)


| unio left right =>
  unfold Typing at typing
  cases typing with
  | inl h =>
    apply Typing.convergent_or_divergent h
  | inr h =>
    apply Typing.convergent_or_divergent h

| inter left right =>
  unfold Typing at typing
  have ⟨h0,h1⟩ := typing
  apply Typing.convergent_or_divergent h0

| diff left right =>
  unfold Typing at typing
  have ⟨h0,h1⟩ := typing
  apply Typing.convergent_or_divergent h0

| exi ids quals body =>
  unfold Typing at typing
  have ⟨am',h0,h1,h2⟩ := typing
  apply Typing.convergent_or_divergent h2
| all ids quals body =>
  unfold Typing at typing
  have ⟨h0,am',h1,h2⟩ := typing
  specialize h0 am' h1 h2
  apply Typing.convergent_or_divergent h0

| lfp id body =>
  unfold Typing at typing
  have ⟨monotonic, t, lt_size, h0,h1⟩ := typing
  apply Typing.convergent_or_divergent h1

| var id =>
  unfold Typing at typing
  have ⟨t, h0,h2⟩ := typing
  exact FinTyping.convergent_or_divergent h2


theorem Expr.sub_sub_removal :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry


-- theorem EvalCon.transition_reflection :
--   EvalCon E →
--   Transition (E e) e' →
--   ∃ e'' , Transition e e''
-- := by sorry


-- theorem TransitionStar.project_record {id} :
--   TransitionStar (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)])) e
-- := by sorry


-- theorem TransitionStar.record_beta_expansion {e l e' id}:
--   EvalCon E → Expr.is_value e' →
--   TransitionStar (E e) e' →
--   TransitionStar (E (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)]))) e'
-- := by
--   intro h0 h1 h2
--   generalize h3 : (E e) = e0 at h2
--   revert e
--   induction h2 with
--   | refl e0 =>
--     intro e h3
--     rw [← h3] at h1
--     rw [← h3]
--     apply TransitionStar.step
--     {
--       apply EvalCon.soundness h0
--       apply Transition.appmatch
--       { reduce ;
--         have h4 := EvalCon.is_value_determines_hole h0 h1
--         rw [h4] at h1
--         simp [*]
--       }
--       { simp [Expr.pattern_match, List.pattern_match_record, Pat.free_vars, List.pattern_match_entry]
--         reduce
--         apply And.intro rfl rfl
--       }
--     }
--     { simp [Expr.sub, find]
--       simp [*]
--       apply TransitionStar.refl
--     }
--   | step e0 em e' h3 h4 ih =>
--     intro e h5
--     rw [← h5] at h3
--     sorry
--     -- have ⟨et, h6⟩ := EvalCon.transition_reflection h0 h3
--     -- apply TransitionStar.step
--     -- {
--     --   apply EvalCon.soundness h0
--     --   apply Transition.applicand
--     --   apply Transition.entry _ _ h6
--     -- }
--     -- { apply ih h2
--     --   exact EvalCon.transition_unique h0 h6 h3
--     -- }


-- theorem FinTyping.record_beta_reduction :
--   EvalCon E →
--   FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t →
--   FinTyping (E e) t
-- := by sorry


-- theorem Convergent.record_beta_reduction :
--   EvalCon E →
--   Convergent (E (Expr.project (Expr.record [(l, e)]) l)) →
--   Convergent (E e)
-- := by sorry

-- theorem Convergent.record_beta_expansion :
--   EvalCon E →
--   Convergent (E e) →
--   Convergent (E (Expr.project (Expr.record [(l, e)]) l))
-- := by
--   unfold Convergent
--   intro h0 h1
--   have ⟨e',h2,h3⟩ := h1
--   exists e'
--   apply And.intro
--   { apply TransitionStar.record_beta_expansion h0 h3 h2 }
--   { exact h3 }

-- theorem Divergent.record_beta_reduction :
--   EvalCon E →
--   Divergent (E (Expr.project (Expr.record [(l, e)]) l)) →
--   Divergent (E e)
-- := by
--   sorry

-- theorem Divergent.record_beta_expansion :
--   EvalCon E →
--   Divergent (E e) → Divergent (E (Expr.project (Expr.record [(l, e)]) l))
-- := by
--   sorry

-- theorem FinTyping.record_beta_expansion l :
--   EvalCon E →
--   FinTyping (E e) t →
--   FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t
-- := by cases t with
-- | top =>
--   unfold FinTyping
--   intro h0 h1
--   cases h1 with
--   | inl h2 =>
--     apply Or.inl
--     exact Convergent.record_beta_expansion h0 h2
--   | inr h2 =>
--     apply Or.inr
--     exact Divergent.record_beta_expansion h0 h2

-- | iso label body =>
--   intro h0 h1
--   apply EvalCon.extract label at h0
--   apply FinTyping.record_beta_expansion l h0 h1


-- | entry label body =>
--   intro h0 h1
--   apply EvalCon.project label at h0
--   apply FinTyping.record_beta_expansion l h0 h1

-- | path left right =>
--   intro h0 h1 e' h2
--   specialize h1 e' h2
--   apply EvalCon.applicator e' at h0
--   apply FinTyping.record_beta_expansion l h0 h1


-- | unio left right =>
--   intro h0 h1
--   cases h1 with
--   | inl h1 =>
--     have ih := FinTyping.record_beta_expansion l h0 h1
--     exact Or.inl ih
--   | inr h1 =>
--     have ih := FinTyping.record_beta_expansion l h0 h1
--     exact Or.inr ih

-- | inter left right =>
--   intro h0 h1
--   unfold FinTyping at h1
--   have ⟨h2,h3⟩ := h1
--   apply And.intro
--   { apply FinTyping.record_beta_expansion l h0 h2 }
--   { apply FinTyping.record_beta_expansion l h0 h3 }

-- | diff left right =>
--   intro h0 h1
--   unfold FinTyping at h1
--   have ⟨h2,h3⟩ := h1
--   apply And.intro
--   { apply FinTyping.record_beta_expansion l h0 h2 }
--   {
--     intro h4
--     apply h3
--     apply FinTyping.record_beta_reduction h0 h4
--   }

-- | _ =>
--   intro h0 h1
--   unfold FinTyping at h1
--   exact h1


-- mutual
--   theorem Typing.record_beta_reduction :
--     EvalCon E →
--     Typing am (E (Expr.project (Expr.record [(l, e)]) l)) t →
--     Typing am (E e) t
--   := match t with
--   | .bot => by
--     unfold Typing
--     intro h0 h1
--     exact h1

--   | .top => by
--     unfold Typing
--     intro h0 h1
--     cases h1 with
--     | inl h2 =>
--       apply Or.inl
--       exact Convergent.record_beta_reduction h0 h2
--     | inr h2 =>
--       apply Or.inr
--       exact Divergent.record_beta_reduction h0 h2

--   | .iso label body => by
--     unfold Typing
--     intro h0 h1
--     apply EvalCon.extract label at h0
--     apply Typing.record_beta_reduction h0 h1

--   | .entry label body => by
--     unfold Typing
--     intro h0 h1
--     apply EvalCon.project label at h0
--     apply Typing.record_beta_reduction h0 h1

--   | .path left right => by
--     unfold Typing
--     intro h0 h1 e' h2
--     specialize h1 e' h2
--     apply EvalCon.applicator e' at h0
--     apply Typing.record_beta_reduction h0 h1

--   | .unio left right => by
--     unfold Typing
--     intro h0 h1
--     cases h1 with
--     | inl h2 =>
--       apply Or.inl
--       apply Typing.record_beta_reduction h0 h2
--     | inr h2 =>
--       apply Or.inr
--       apply Typing.record_beta_reduction h0 h2

--   | .inter left right => by
--     unfold Typing
--     intro h0 h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply Typing.record_beta_reduction h0 h2 }
--     { apply Typing.record_beta_reduction h0 h3 }

--   | .diff left right => by
--     unfold Typing
--     intro h0 h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply Typing.record_beta_reduction h0 h2 }
--     {
--       intro h4
--       apply h3
--       exact Typing.record_beta_expansion l h0 h4
--     }
--   | .exi ids quals body => by
--     unfold Typing
--     intro h0 h1

--     have ⟨am', h2, h3, h4⟩ := h1
--     exists am'
--     apply And.intro h2
--     apply And.intro h3
--     apply Typing.record_beta_reduction h0 h4

--   | .all ids quals body => by
--     unfold Typing
--     intro h0 ⟨h1,h2⟩
--     apply And.intro
--     {
--       intro am' dom_subset dynamic_quals
--       specialize h1 am' dom_subset dynamic_quals
--       apply Typing.record_beta_reduction h0 h1
--     }
--     { exact h2}

--   | .lfp id body => by
--     unfold Typing
--     intro h0 h1
--     have ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩ := h1
--     apply And.intro monotonic_body
--     exists t
--     exists lt_size
--     apply And.intro imp_dynamic
--     apply Typing.record_beta_reduction h0 dynamic_body

--   | .var id => by
--     unfold Typing
--     intro h0 h1
--     have ⟨t, h2, h3⟩ := h1
--     exists t
--     apply And.intro h2
--     apply FinTyping.record_beta_reduction h0 h3

--   theorem Typing.record_beta_expansion l :
--     EvalCon E →
--     Typing am (E e) t →
--     Typing am (E (Expr.project (Expr.record [(l, e)]) l)) t
--   :=
--   /- TODO: rewrite by leveraging evalcon_swap and typing subject expansion ; instead of inducting directly -/
--   match t with
--   | .bot => by
--     unfold Typing
--     intro h0 h1
--     exact h1

--   | .top => by
--     unfold Typing
--     intro h0 h1
--     cases h1 with
--     | inl h2 =>
--       apply Or.inl
--       exact Convergent.record_beta_expansion h0 h2
--     | inr h2 =>
--       apply Or.inr
--       exact Divergent.record_beta_expansion h0 h2

--   | .iso label body => by
--     unfold Typing
--     intro h0 h1
--     apply EvalCon.extract label at h0
--     apply Typing.record_beta_expansion l h0 h1

--   | .entry label body => by
--     unfold Typing
--     intro h0 h1
--     apply EvalCon.project label at h0
--     apply Typing.record_beta_expansion l h0 h1

--   | .path left right => by
--     unfold Typing
--     intro h0 h1 e' h2
--     specialize h1 e' h2
--     apply EvalCon.applicator e' at h0
--     apply Typing.record_beta_expansion l h0 h1

--   | .unio left right => by
--     unfold Typing
--     intro h0 h1
--     cases h1 with
--     | inl h2 =>
--       apply Or.inl
--       apply Typing.record_beta_expansion l h0 h2
--     | inr h2 =>
--       apply Or.inr
--       apply Typing.record_beta_expansion l h0 h2

--   | .inter left right => by
--     unfold Typing
--     intro h0 h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply Typing.record_beta_expansion l h0 h2 }
--     { apply Typing.record_beta_expansion l h0 h3 }

--   | .diff left right => by
--     unfold Typing
--     intro h0 h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply Typing.record_beta_expansion l h0 h2 }
--     {
--       intro h4
--       apply h3
--       exact record_beta_reduction h0 h4
--     }
--   | .exi ids quals body => by
--     unfold Typing
--     intro h0 h1

--     have ⟨am', h2, h3, h4⟩ := h1
--     exists am'
--     apply And.intro h2
--     apply And.intro h3
--     apply Typing.record_beta_expansion l h0 h4

--   | .all ids quals body => by
--     unfold Typing
--     intro h0 ⟨h1,h2⟩
--     apply And.intro
--     {
--       intro am' dom_subset dynamic_quals
--       specialize h1 am' dom_subset dynamic_quals
--       apply Typing.record_beta_expansion l h0 h1
--     }
--     {exact h2}

--   | .lfp id body => by
--     unfold Typing
--     intro h0 h1
--     have ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩ := h1
--     apply And.intro monotonic_body
--     exists t
--     exists lt_size
--     apply And.intro imp_dynamic
--     apply Typing.record_beta_expansion l h0 dynamic_body

--   | .var id => by
--     unfold Typing
--     intro h0 h1
--     have ⟨t, h2, h3⟩ := h1
--     exists t
--     apply And.intro h2
--     apply FinTyping.record_beta_expansion l h0 h3
-- end


theorem Typing.progress :
  Typing am e t →
  Expr.is_value e ∨ ∃ e' , Transition e e'
:= by
  sorry



theorem Transition.not_value :
  Transition e e' →
  ¬ Expr.is_value e
:= by sorry




theorem Divergent.transition :
  Divergent e →
  ∃ e' , Transition e e' ∧ Divergent e'
:= by sorry

theorem Divergent.evalcon_preservation :
  EvalCon E →
  Divergent e →
  Divergent (E e)
:= by
  intro h0 h1 e' h2
  generalize h3 : (E e) = eg at h1
  rw [h3] at h2
  revert e

  induction h2 with
  | refl eg =>
    intro e h1 h2
    rw [← h2]
    specialize h1 e (TransitionStar.refl e)
    have ⟨e', h3⟩ := h1
    exists (E e')
    exact Transition.evalcon h0 h3

  | step eg em e' h4 h5 ih =>

    intro e h1 h2
    rw [← h2] at h4
    clear h2
    apply Divergent.transition at h1
    have ⟨et, h6,h7⟩ := h1
    apply ih h7
    apply Transition.deterministic
    { exact Transition.evalcon h0 h6 }
    { exact h4 }




theorem FinTyping.evalcon_swap
  (evalcon : EvalCon E)
  (typing : Typing am e t)
  (typing' : Typing am e' t)
: FinTyping (E e) t' → FinTyping (E e') t'
:= by cases t' with
| bot =>
  unfold FinTyping
  simp

| top =>
  unfold FinTyping
  intro typing_evalcon
  apply Typing.convergent_or_divergent at typing'
  cases typing' with
  | inl h =>
    apply Or.inl
    sorry
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_preservation evalcon h

| iso label body =>
  unfold FinTyping
  apply EvalCon.extract label at evalcon
  intro typing_evalcon
  apply FinTyping.evalcon_swap  evalcon typing typing' typing_evalcon


| entry label body =>
  unfold FinTyping
  apply EvalCon.project label at evalcon
  intro typing_evalcon
  apply FinTyping.evalcon_swap evalcon typing typing' typing_evalcon

| path left right =>
  unfold FinTyping
  intro h4 e' h5
  apply EvalCon.applicator e' at evalcon
  apply FinTyping.evalcon_swap evalcon typing typing' (h4 e' h5)


| unio left right =>
  unfold FinTyping
  intro h4
  cases h4 with
  | inl h5 =>
    apply Or.inl
    apply FinTyping.evalcon_swap evalcon typing typing' h5
  | inr h5 =>
    apply Or.inr
    apply FinTyping.evalcon_swap evalcon typing typing' h5

| inter left right =>
  unfold FinTyping
  intro h4
  have ⟨h5,h6⟩ := h4
  apply And.intro
  { apply FinTyping.evalcon_swap evalcon typing typing' h5 }
  { apply FinTyping.evalcon_swap evalcon typing typing' h6 }

| diff left right =>
  unfold FinTyping
  intro h4
  have ⟨h5,h6⟩ := h4
  clear h4
  apply And.intro
  { apply FinTyping.evalcon_swap evalcon typing typing' h5 }
  {
    intro h7
    apply h6
    clear h6
    apply FinTyping.evalcon_swap evalcon typing' typing h7
  }
| _ =>
  unfold FinTyping
  simp


theorem Typing.evalcon_swap
  (evalcon : EvalCon E)
  (typing : Typing am e t)
  (typing' : Typing am e' t)
: Typing am' (E e) t' →  Typing am' (E e') t'
:= by cases t' with
| bot =>
  unfold Typing
  simp

| top =>
  unfold Typing
  intro typing_evalcon
  apply Typing.convergent_or_divergent at typing'
  cases typing' with
  | inl h =>
    apply Or.inl
    sorry
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_preservation evalcon h

| iso label body =>
  unfold Typing
  apply EvalCon.extract label at evalcon
  intro typing_evalcon
  apply Typing.evalcon_swap  evalcon typing typing' typing_evalcon


| entry label body =>
  unfold Typing
  apply EvalCon.project label at evalcon
  intro typing_evalcon
  apply Typing.evalcon_swap evalcon typing typing' typing_evalcon

| path left right =>
  unfold Typing
  intro h4 e' h5
  apply EvalCon.applicator e' at evalcon
  apply Typing.evalcon_swap evalcon typing typing' (h4 e' h5)


| unio left right =>
  unfold Typing
  intro h4
  cases h4 with
  | inl h5 =>
    apply Or.inl
    apply Typing.evalcon_swap evalcon typing typing' h5
  | inr h5 =>
    apply Or.inr
    apply Typing.evalcon_swap evalcon typing typing' h5

| inter left right =>
  unfold Typing
  intro h4
  have ⟨h5,h6⟩ := h4
  apply And.intro
  { apply Typing.evalcon_swap evalcon typing typing' h5 }
  { apply Typing.evalcon_swap evalcon typing typing' h6 }

| diff left right =>
  unfold Typing
  intro h4
  have ⟨h5,h6⟩ := h4
  clear h4
  apply And.intro
  { apply Typing.evalcon_swap evalcon typing typing' h5 }
  {
    intro h7
    apply h6
    clear h6
    apply Typing.evalcon_swap evalcon typing' typing h7
  }
| exi ids quals body =>
  unfold Typing
  intro h4
  have ⟨am',h5,h6,h7⟩ := h4
  clear h4
  exists am'
  apply And.intro h5
  apply And.intro h6
  apply Typing.evalcon_swap evalcon typing typing' h7
| all ids quals body =>
  unfold Typing
  intro ⟨h4,h5⟩
  apply And.intro
  {
    intro am'' h6 h7
    apply Typing.evalcon_swap evalcon typing typing' (h4 am'' h6 h7)
  }
  { exact h5 }
| lfp id body =>
  unfold Typing
  intro h4
  have ⟨h5,t'',h6,h7,h8⟩ := h4
  apply And.intro h5
  exists t''
  exists h6
  apply And.intro h7
  apply Typing.evalcon_swap evalcon typing typing' h8
| var id =>
  unfold Typing
  intro h4
  have ⟨t',h5,h6⟩ := h4
  clear h4
  simp [*]
  apply FinTyping.evalcon_swap evalcon typing typing' h6




theorem Typing.exists_value :
  Typing am e t →
  ∃ v , Expr.is_value v ∧ Typing am v t
:= by sorry


theorem Typing.record_beta_expansion l :
  Typing am e t →
  Typing am (Expr.project (Expr.record [(l, e)]) l) t
:= by
  intro h0
  have ⟨ev, h1, h2⟩ := Typing.exists_value h0
  have evalcon : EvalCon (fun e => (Expr.project (Expr.record [(l, e)]) l)) := by
    apply EvalCon.project
    apply EvalCon.record
    apply RecordCon.head
    apply EvalCon.hole
  apply Typing.evalcon_swap evalcon h2 h0
  { apply Typing.subject_expansion
    {
      unfold Expr.project
      apply Transition.pattern_match
      { reduce ; exact h1 }
      { simp [
          Expr.pattern_match, List.pattern_match_record,
          List.pattern_match_entry, Pat.free_vars,
          ListPat.free_vars
        ];
        reduce
        simp
        rfl
      }
    }
    { exact h2 }
  }


theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  exact record_beta_expansion l h0

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



theorem Typing.function_beta_expansion f :
  (∀ {ev} ,
    Expr.is_value ev → Typing am ev tp →
    ∃ eam , Expr.pattern_match ev p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am e' tp →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) e') tr
:= by
  intro h0 h1
  have ⟨v, h5, h6⟩ := Typing.exists_value h1

  apply Typing.evalcon_swap (EvalCon.applicand ((p, e) :: f) .hole) h6 h1
  specialize h0 h5 h6
  have ⟨eam,h7,h8⟩ := h0
  apply Typing.subject_expansion
  { apply Transition.pattern_match h5 h7}
  { exact h8 }


theorem Typing.path_intro :
  (∀ {v} ,
    Expr.is_value v → Typing am v tp →
    ∃ eam , Expr.pattern_match v p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am (Expr.function ((p, e) :: f)) (Typ.path (List.typ_diff tp subtras) tr)
:= by
  intro h0
  unfold Typing
  intro e' h1
  have h2 := Subtyping.elimination Subtyping.list_typ_diff_elim h1
  exact function_beta_expansion f h0 h2

theorem Typing.function_preservation {am p tp e f t } :
  (∀ {v} , Expr.is_value v → Typing am v tp → ∃ eam , Expr.pattern_match v p = .some eam) →
  ¬ Subtyping am t (.path tp .top) →
  Typing am (.function f) t →
  Typing am (.function ((p,e) :: f)) t
:= by sorry


theorem Typing.path_elim {am ef ea t t'} :
  Typing am ef (.path t t') →
  Typing am ea t →
  Typing am (.app ef ea) t'
:= by
  intro h0
  unfold Typing at h0
  exact fun a => h0 ea a

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




end Lang.Dynamic
