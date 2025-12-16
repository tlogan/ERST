import Lang.Basic

set_option pp.fieldNotation false



mutual
  def List.pattern_match_entry (label : String) (pat : Pat)
  : List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (Expr.pattern_match e pat)
    else
      List.pattern_match_entry label pat args

  def List.pattern_match_record (args : List (String × Expr))
  : List (String × Pat) → Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.free_vars pat ∩ ListPat.free_vars pats == [] then
      let m0 ← List.pattern_match_entry label pat args
      let m1 ← List.pattern_match_record args pats
      return (m0 ++ m1)
    else
      .none

  def Expr.pattern_match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | (.record r), (.record p) => List.pattern_match_record r p
  | _, _ => none
end


mutual
  def List.pattern_ids : List (String × Pat) → List String
  | .nil => .nil
  | (_, p) :: r =>
    (Pat.ids p) ++ (List.pattern_ids r)

  def Pat.ids : Pat → List String
  | .var id => [id]
  | .iso l body => Pat.ids body
  | .record r => List.pattern_ids r
end


mutual
  def List.record_sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.sub m e) :: (List.record_sub m r)

  def List.function_sub (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := Pat.ids p
    (p, Expr.sub (remove_all m ids) e) :: (List.function_sub m f)

  def Expr.sub (m : List (String × Expr)): Expr → Expr
  | .var id => match (find id m) with
    | .none => (.var id)
    | .some e => e
  | .iso l body => .iso l (Expr.sub m body)
  | .record r => .record (List.record_sub m r)
  | .function f => .function (List.function_sub m f)
  | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
  | .anno e t => .anno (Expr.sub m e) t
  | .loop e => .loop (Expr.sub m e)
end


theorem Expr.sub_sub_removal :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry


inductive Transition : Expr → Expr → Prop
| entry l r :
  Transition e e' →
  Transition (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record :
  Transition (Expr.record r) (Expr.record r') →
  v.is_value →
  Transition (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator :
  Transition ef ef' →
  Transition (.app ef e) (.app ef' e)
| applicand f e e' :
  Transition e e' →
  Transition (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  v.is_value →
  Expr.pattern_match v p = some m →
  Transition (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
| appskip :
  v.is_value →
  Expr.pattern_match v p = none →
  Transition (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {e t},
  Transition (.anno  e t) e
| loopbody :
  Transition e e' →
  Transition (.loop e) (.loop e')
| looppeel : ∀ {id e},
  Transition
    (.loop (.function [(.var id, e)]))
    (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)


inductive TransitionStar : Expr → Expr → Prop
| refl e : TransitionStar e e
| step e e' e'' : Transition e e' → TransitionStar e' e'' → TransitionStar e e''


inductive EvalCon : (Expr → Expr) → Prop
| hole : EvalCon (fun e => e)
| applicator e' : EvalCon E → EvalCon (fun e => .app (E e) e')
| applicand f : EvalCon E → EvalCon (fun e => .app (.function f) (E e))


theorem EvalCon.transition_preservation :
  EvalCon E →
  Transition e e'→
  Transition (E e) (E e')
:= by sorry

theorem EvalCon.is_value_reflection :
  EvalCon E →
  Expr.is_value (E e) →
  Expr.is_value e
:= by sorry


theorem EvalCon.transition :
  EvalCon E →
  Transition (E e) e' →
  ∃ e'' , Transition e e''
:= by sorry


theorem EvalCon.transition_unique :
  EvalCon E →
  Transition e e' → Transition (E e) er →
  (E e') = er
:= by sorry

theorem EvalCon.extract l :
  EvalCon E →
  EvalCon (fun e => Expr.extract (E e) l)
:= by sorry

theorem EvalCon.project l :
  EvalCon E →
  EvalCon (fun e => Expr.project (E e) l)
:= by sorry






def Convergent (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ Expr.is_value e'

def Divergent (e : Expr) : Prop :=
  (∀ e', TransitionStar e e' → ∃ e'' , Transition e' e'')


def NonDivergent (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ ¬ (∃ e'' , Transition e' e'')

theorem NonDivergent.elim :
  NonDivergent e → ¬ Divergent e
:= by sorry

theorem NonDivergent.intro :
  ¬ Divergent e → NonDivergent e
:= by sorry


def Stuck (e : Expr) : Prop :=
  ¬ Expr.is_value e ∧ ¬ ∃ e', Transition e e'

def Fails (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ Stuck e'


def SimpleTyping (e : Expr) : Typ → Prop
| .top => Convergent e ∨ Divergent e
| .iso l body => SimpleTyping (.extract e l) body
| .entry l body => SimpleTyping (.project e l) body
| .path left right => ∀ e' , SimpleTyping e' left → SimpleTyping (.app e e') right
| .unio left right => SimpleTyping e left ∨ SimpleTyping e right
| .inter left right => SimpleTyping e left ∧ SimpleTyping e right
| .diff left right => SimpleTyping e left ∧ ¬ (SimpleTyping e right)
| _ => False


def Subtyping.Fin (left right : Typ) : Prop :=
  ∀ e, SimpleTyping e left → SimpleTyping e right

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
    ∀ am' , (ListPair.dom am') ⊆ ids →
    (MultiSubtyping (am' ++ am) quals) →
    (Typing (am' ++ am) e body)
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
  --   ∃ n, SimpleTyping e (Typ.sub am (Typ.subfold id body n))
  | .var id => ∃ t, find id am = some t ∧ SimpleTyping e t
  termination_by t => (Typ.size t)
  decreasing_by
    all_goals simp_all [Typ.size]
    all_goals try linarith
end

def MultiTyping
  (tam : List (String × Typ)) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, find x context = .some t → ∃ e, (find x eam) = .some e ∧ Typing tam e t



--- TODO: consider Typ.sub and other typ manipulations as forms of static semantics
--- rename lemmas to indicate they are either soundness or (conditional) completeness properties


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


theorem TransitionStar.project_record {id} :
  TransitionStar (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)])) e
:= by sorry


theorem TransitionStar.project_record_beta_expansion {e l e' id}:
  EvalCon E →
  TransitionStar (E e) e' → Expr.is_value e' →
  TransitionStar (E (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)]))) e'
:= by
  intro h0 h1 h2
  generalize h3 : (E e) = e0 at h1
  revert e
  induction h1 with
  | refl e0 =>
    intro e h3
    rw [← h3] at h2
    rw [← h3]
    apply TransitionStar.step
    {
      apply EvalCon.transition_preservation h0
      apply Transition.appmatch
      { reduce ; apply EvalCon.is_value_reflection h0 h2 }
      { simp [Expr.pattern_match, List.pattern_match_record, Pat.free_vars, List.pattern_match_entry]
        reduce
        apply And.intro rfl rfl
      }
    }
    { simp [Expr.sub, find]
      simp [*]
      apply TransitionStar.refl
    }
  | step e0 em e' h3 h4 ih =>
    intro e h5
    rw [← h5] at h3

    have ⟨et, h6⟩ := EvalCon.transition h0 h3
    apply TransitionStar.step
    {

      apply EvalCon.transition_preservation h0
      apply Transition.applicand
      apply Transition.entry _ _ h6
    }
    { apply ih h2
      exact EvalCon.transition_unique h0 h6 h3
    }


theorem Typing.project_record_beta_reduction :
  EvalCon E →
  Typing am (E (Expr.project (Expr.record [(l, e)]) l)) t →
  Typing am (E e) t
:= by sorry

theorem SimpleTyping.project_record_beta_reduction :
  EvalCon E →
  SimpleTyping (E (Expr.project (Expr.record [(l, e)]) l)) t →
  SimpleTyping (E e) t
:= by sorry


theorem Convergent.project_record_beta_expansion :
  EvalCon E →
  Convergent (E e) →
  Convergent (E (Expr.project (Expr.record [(l, e)]) l))
:= by
  unfold Convergent
  intro h0 h1
  have ⟨e',h2,h3⟩ := h1
  exists e'
  apply And.intro
  { exact TransitionStar.project_record_beta_expansion h0 h2 h3 }
  { exact h3 }

theorem Divergent.project_record_beta_expansion :
  EvalCon E →
  Divergent (E e) → Divergent (E (Expr.project (Expr.record [(l, e)]) l))
:= by
  sorry

theorem SimpleTyping.project_record_beta_expansion l :
  EvalCon E →
  SimpleTyping (E e) t →
  SimpleTyping (E (Expr.project (Expr.record [(l, e)]) l)) t
:= by cases t with
| top =>
  unfold SimpleTyping
  intro h0 h1
  cases h1 with
  | inl h2 =>
    apply Or.inl
    exact Convergent.project_record_beta_expansion h0 h2
  | inr h2 =>
    apply Or.inr
    exact Divergent.project_record_beta_expansion h0 h2

| iso label body =>
  intro h0 h1
  apply EvalCon.extract label at h0
  apply SimpleTyping.project_record_beta_expansion l h0 h1


| entry label body =>
  intro h0 h1
  apply EvalCon.project label at h0
  apply SimpleTyping.project_record_beta_expansion l h0 h1

| path left right =>
  intro h0 h1 e' h2
  specialize h1 e' h2
  apply EvalCon.applicator e' at h0
  apply SimpleTyping.project_record_beta_expansion l h0 h1


| unio left right =>
  intro h0 h1
  cases h1 with
  | inl h1 =>
    have ih := SimpleTyping.project_record_beta_expansion l h0 h1
    exact Or.inl ih
  | inr h1 =>
    have ih := SimpleTyping.project_record_beta_expansion l h0 h1
    exact Or.inr ih

| inter left right =>
  intro h0 h1
  unfold SimpleTyping at h1
  have ⟨h2,h3⟩ := h1
  apply And.intro
  { apply SimpleTyping.project_record_beta_expansion l h0 h2 }
  { apply SimpleTyping.project_record_beta_expansion l h0 h3 }

| diff left right =>
  intro h0 h1
  unfold SimpleTyping at h1
  have ⟨h2,h3⟩ := h1
  apply And.intro
  { apply SimpleTyping.project_record_beta_expansion l h0 h2 }
  {
    intro h4
    apply h3
    apply SimpleTyping.project_record_beta_reduction h0 h4
  }

| _ =>
  intro h0 h1
  unfold SimpleTyping at h1
  exact h1

theorem Typing.project_record_beta_expansion l :
  EvalCon E →
  Typing am (E e) t →
  Typing am (E (Expr.project (Expr.record [(l, e)]) l)) t
:= match t with
| .bot => by
  unfold Typing
  intro h0 h1
  exact h1

| .top => by
  unfold Typing
  intro h0 h1
  cases h1 with
  | inl h2 =>
    apply Or.inl
    exact Convergent.project_record_beta_expansion h0 h2
  | inr h2 =>
    apply Or.inr
    exact Divergent.project_record_beta_expansion h0 h2

| .iso label body => by
  unfold Typing
  intro h0 h1
  apply EvalCon.extract label at h0
  apply Typing.project_record_beta_expansion l h0 h1

| .entry label body => by
  unfold Typing
  intro h0 h1
  apply EvalCon.project label at h0
  apply Typing.project_record_beta_expansion l h0 h1

| .path left right => by
  unfold Typing
  intro h0 h1 e' h2
  specialize h1 e' h2
  apply EvalCon.applicator e' at h0
  apply Typing.project_record_beta_expansion l h0 h1

| .unio left right => by
  unfold Typing
  intro h0 h1
  cases h1 with
  | inl h2 =>
    apply Or.inl
    apply Typing.project_record_beta_expansion l h0 h2
  | inr h2 =>
    apply Or.inr
    apply Typing.project_record_beta_expansion l h0 h2

| .inter left right => by
  unfold Typing
  intro h0 h1
  have ⟨h2,h3⟩ := h1
  apply And.intro
  { apply Typing.project_record_beta_expansion l h0 h2 }
  { apply Typing.project_record_beta_expansion l h0 h3 }

| .diff left right => by
  unfold Typing
  intro h0 h1
  have ⟨h2,h3⟩ := h1
  apply And.intro
  { apply Typing.project_record_beta_expansion l h0 h2 }
  {
    intro h4
    apply h3
    exact project_record_beta_reduction h0 h4
  }
| .exi ids quals body => by
  unfold Typing
  intro h0 h1

  have ⟨am', h2, h3, h4⟩ := h1
  exists am'
  apply And.intro h2
  apply And.intro h3
  apply Typing.project_record_beta_expansion l h0 h4

| .all ids quals body => by
  unfold Typing
  intro h0 h1 am' dom_subset dynamic_quals
  specialize h1 am' dom_subset dynamic_quals
  apply Typing.project_record_beta_expansion l h0 h1

| .lfp id body => by
  unfold Typing
  intro h0 h1
  have ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩ := h1
  apply And.intro monotonic_body
  exists t
  exists lt_size
  apply And.intro imp_dynamic
  apply Typing.project_record_beta_expansion l h0 dynamic_body

| .var id => by
  unfold Typing
  intro h0 h1
  have ⟨t, h2, h3⟩ := h1
  exists t
  apply And.intro h2
  apply SimpleTyping.project_record_beta_expansion l h0 h3


theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  exact project_record_beta_expansion l .hole h0

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


theorem Typing.progress :
  Typing am e t →
  Expr.is_value e ∨ ∃ e' , Transition e e'
:= by
  sorry


theorem Typing.preservation :
  Transition e e' →
  Typing am e t →
  Typing am e' t
:= by
  sorry

theorem Typing.soundness :
  Typing am e t →
  Convergent e ∨ Divergent e
:= by sorry


theorem Transition.not_value :
  Transition e e' →
  ¬ Expr.is_value e
:= by sorry

theorem Convergent.app_value_beta_reduction
  (evalcon : EvalCon E)
  (isval : Expr.is_value v)
  (matching : Expr.pattern_match v p = .some eam)
  f
: Convergent (E (Expr.app (Expr.function ((p, e) :: f)) v)) →
  Convergent (E (Expr.sub eam e))
:= by
  sorry

theorem Convergent.app_value_beta_expansion
  (evalcon : EvalCon E)
  (isval : Expr.is_value v)
  (matching : Expr.pattern_match v p = .some eam)
  f
: Convergent (E (Expr.sub eam e)) →
  Convergent (E (Expr.app (Expr.function ((p, e) :: f)) v))
:= by
  unfold Convergent
  intro h2
  have ⟨e',h3,h4⟩ := h2
  exists e'
  apply And.intro
  {
    apply TransitionStar.step
    {
      apply EvalCon.transition_preservation  evalcon
      apply Transition.appmatch isval matching
    }
    { apply h3 }
  }
  { exact h4 }

theorem Divergent.app_value_beta_reduction
  (evalcon : EvalCon E)
  (isval : Expr.is_value v)
  (matching : Expr.pattern_match v p = .some eam)
  f
:
  Divergent (E (Expr.app (Expr.function ((p, e) :: f)) v)) →
  Divergent (E (Expr.sub eam e))
:= by sorry

theorem Divergent.app_value_beta_expansion
  (evalcon : EvalCon E)
  (isval : Expr.is_value v)
  (matching : Expr.pattern_match v p = .some eam)
  f
:
  Divergent (E (Expr.sub eam e)) →
  Divergent (E (Expr.app (Expr.function ((p, e) :: f)) v))
:= by sorry


mutual
  theorem SimpleTyping.app_value_beta_reduction
    (evalcon : EvalCon E)
    (isval : Expr.is_value v)
    (matching : Expr.pattern_match v p = .some eam)
    f
  : SimpleTyping (E (Expr.app (Expr.function ((p, e) :: f)) v)) tr →
    SimpleTyping (E (Expr.sub eam e)) tr
  := by sorry



  theorem SimpleTyping.app_value_beta_expansion
    (evalcon : EvalCon E)
    (isval : Expr.is_value v)
    (matching : Expr.pattern_match v p = .some eam)
    f
  : SimpleTyping (E (Expr.sub eam e)) tr →
    SimpleTyping (E (Expr.app (Expr.function ((p, e) :: f)) v)) tr
  := by cases tr with
  | bot =>
    unfold SimpleTyping
    simp
  | top =>
    unfold SimpleTyping
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      apply Convergent.app_value_beta_expansion evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      apply Divergent.app_value_beta_expansion evalcon isval matching f h3

  | iso label body =>
    unfold SimpleTyping
    intro h2
    apply EvalCon.extract label at evalcon
    apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h2

  | entry label body =>
    unfold SimpleTyping
    intro h2
    apply EvalCon.project label at evalcon
    apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h2

  | path left right =>
    unfold SimpleTyping
    intro h2 e' h3
    specialize h2 e' h3
    apply EvalCon.applicator e' at evalcon
    apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h2

  | unio left right =>
    unfold SimpleTyping
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h3

  | inter left right =>
    unfold SimpleTyping
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h3 }
    { apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h4 }

  | diff left right =>
    unfold SimpleTyping
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply SimpleTyping.app_value_beta_expansion evalcon isval matching f h3 }
    {
      intro h5
      apply h4

      apply SimpleTyping.app_value_beta_reduction evalcon isval matching f h5
    }

  | _ =>
    unfold SimpleTyping
    simp
end


mutual
  theorem Typing.app_value_beta_reduction
    (evalcon : EvalCon E)
    (isval : Expr.is_value v)
    (matching : Expr.pattern_match v p = .some eam)
    f
  : Typing am (E (Expr.app (Expr.function ((p, e) :: f)) v)) tr →
    Typing am (E (Expr.sub eam e)) tr
  := by cases tr with
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      exact Convergent.app_value_beta_reduction evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      exact Divergent.app_value_beta_reduction evalcon isval matching f h3

  | iso label body =>
    unfold Typing
    intro h2
    apply EvalCon.extract label at evalcon
    apply Typing.app_value_beta_reduction evalcon isval matching f h2

  | entry label body =>
    unfold Typing
    intro h2
    apply EvalCon.project label at evalcon
    apply Typing.app_value_beta_reduction evalcon isval matching f h2

  | path left right =>
    unfold Typing
    intro h2 e' h3
    specialize h2 e' h3
    apply EvalCon.applicator e' at evalcon
    apply Typing.app_value_beta_reduction evalcon isval matching f h2

  | unio left right =>
    unfold Typing
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      apply Typing.app_value_beta_reduction evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      apply Typing.app_value_beta_reduction evalcon isval matching f h3

  | inter left right =>
    unfold Typing
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply Typing.app_value_beta_reduction evalcon isval matching f h3 }
    { apply Typing.app_value_beta_reduction evalcon isval matching f h4 }

  | diff left right =>
    unfold Typing
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply Typing.app_value_beta_reduction evalcon isval matching f h3 }
    {
      intro h5
      apply h4

      apply Typing.app_value_beta_expansion evalcon isval matching f h5
    }

  | exi ids quals body =>
    unfold Typing
    intro h2
    have ⟨am', h3, h4, h5⟩ := h2
    exists am'
    apply And.intro h3
    apply And.intro h4
    apply Typing.app_value_beta_reduction evalcon isval matching f h5

  | all ids quals body =>
    unfold Typing
    intro h2 am' h3 h4
    specialize h2 am' h3 h4
    apply Typing.app_value_beta_reduction evalcon isval matching f h2

  | lfp id body =>
    unfold Typing
    intro h2
    have ⟨h3,t,h4,h5,h6⟩ := h2
    apply And.intro h3
    exists t
    exists h4
    apply And.intro h5
    apply Typing.app_value_beta_reduction evalcon isval matching f h6

  | var id =>
    unfold Typing
    intro h2
    have ⟨t,h3,h4⟩ := h2
    exists t
    apply And.intro h3
    exact SimpleTyping.app_value_beta_reduction evalcon isval matching f h4



  theorem Typing.app_value_beta_expansion
    (evalcon : EvalCon E)
    (isval : Expr.is_value v)
    (matching : Expr.pattern_match v p = .some eam)
    f
  : Typing am (E (Expr.sub eam e)) tr →
    Typing am (E (Expr.app (Expr.function ((p, e) :: f)) v)) tr
  := match tr with
  | .bot => by
    unfold Typing
    simp
  | .top => by
    unfold Typing
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      exact Convergent.app_value_beta_expansion evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      exact Divergent.app_value_beta_expansion evalcon isval matching f h3

  | .iso label body => by
    unfold Typing
    intro h2
    apply EvalCon.extract label at evalcon
    apply Typing.app_value_beta_expansion evalcon isval matching f h2

  | .entry label body => by
    unfold Typing
    intro h2
    apply EvalCon.project label at evalcon
    apply Typing.app_value_beta_expansion evalcon isval matching f h2

  | .path left right => by
    unfold Typing
    intro h2 e' h3
    specialize h2 e' h3
    apply EvalCon.applicator e' at evalcon
    apply Typing.app_value_beta_expansion evalcon isval matching f h2

  | .unio left right => by
    unfold Typing
    intro h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      apply Typing.app_value_beta_expansion evalcon isval matching f h3
    | inr h3 =>
      apply Or.inr
      apply Typing.app_value_beta_expansion evalcon isval matching f h3

  | .inter left right => by
    unfold Typing
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply Typing.app_value_beta_expansion evalcon isval matching f h3 }
    { apply Typing.app_value_beta_expansion evalcon isval matching f h4 }

  | .diff left right => by
    unfold Typing
    intro h2
    have ⟨h3,h4⟩ := h2
    apply And.intro
    { apply Typing.app_value_beta_expansion evalcon isval matching f h3 }
    {
      intro h5
      apply h4
      apply Typing.app_value_beta_reduction evalcon isval matching f h5
    }

  | .exi ids quals body => by
    unfold Typing
    intro h2
    have ⟨am', h3, h4, h5⟩ := h2
    exists am'
    apply And.intro h3
    apply And.intro h4
    apply Typing.app_value_beta_expansion evalcon isval matching f h5

  | .all ids quals body => by
    unfold Typing
    intro h2 am' h3 h4
    specialize h2 am' h3 h4
    apply Typing.app_value_beta_expansion evalcon isval matching f h2

  | .lfp id body => by
    unfold Typing
    intro h2
    have ⟨h3,t,h4,h5,h6⟩ := h2
    apply And.intro h3
    exists t
    exists h4
    apply And.intro h5
    apply Typing.app_value_beta_expansion evalcon isval matching f h6

  | .var id => by
    unfold Typing
    intro h2
    have ⟨t,h3,h4⟩ := h2
    exists t
    apply And.intro h3
    exact SimpleTyping.app_value_beta_expansion evalcon isval matching f h4
end


theorem Transition.applicand_reflection :
  Transition e' e'' →
  Typing am (Expr.app e e'') t →
  Typing am (Expr.app e e') t
:= by sorry

theorem Typing.exists_value :
  Typing am e t →
  ∃ v , Expr.is_value v ∧ Typing am v t
:= by sorry


theorem Divergent.transition :
  Divergent e →
  ∃ e' , Transition e e' ∧ Divergent e'
:= by sorry

theorem Convergent.evalcon :
  EvalCon E →
  Convergent e →
  Convergent (E e)
:= by sorry

theorem Divergent.evalcon :
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
    apply EvalCon.transition_preservation h0
    exact h3

  | step eg em e' h4 h5 ih =>

    intro e h1 h2
    rw [← h2] at h4
    clear h2
    apply Divergent.transition at h1
    have ⟨et, h6,h7⟩ := h1
    apply ih h7

    apply EvalCon.transition_unique h0
    exact h6
    exact h4

theorem SimpleTyping.evalcon_swap
  (evalcon : EvalCon E)
  (typing : Typing am e t)
  (typing' : Typing am e' t)
: SimpleTyping (E e) t' →  SimpleTyping (E e') t'
:= by sorry


theorem Typing.convergent_or_divergent
  (typing : Typing am e t)
: Convergent e ∨ Divergent e
:= sorry


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
    apply Convergent.evalcon evalcon h
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon evalcon h

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
  intro h4 am'' h5 h6
  apply Typing.evalcon_swap evalcon typing typing' (h4 am'' h5 h6)
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
  apply SimpleTyping.evalcon_swap evalcon typing typing' h6



theorem Typing.app_function_beta_expansion f :
  (∀ {v} ,
    Expr.is_value v → Typing am v tp →
    ∃ eam , Expr.pattern_match v p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am e' tp →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) e') tr
:= by
  intro h0 h1
  have ⟨v, h5, h6⟩ := Typing.exists_value h1
  apply Typing.evalcon_swap (EvalCon.applicand ((p, e) :: f) .hole) h6 h1
  specialize h0 h5 h6
  have ⟨eam,h7,h8⟩ := h0
  exact app_value_beta_expansion .hole h5 h7 f h8


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
  exact app_function_beta_expansion f h0 h2

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


def Confluent (a b : Expr) :=
  ∃ e , TransitionStar a e ∧ TransitionStar b e

theorem Confluent.typing_left_to_right {a b am t} :
  Confluent a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Expr.Confluent.typing_right_to_left {a b am t} :
  Confluent a b →
  Typing am b t →
  Typing am a t
:= by sorry

theorem Confluent.transitivity {a b c} :
  Confluent a b →
  Confluent b c →
  Confluent a c
:= by sorry

theorem Confluent.swap {a b} :
  Confluent a b →
  Confluent b a
:= by sorry

theorem Confluent.app_arg_preservation {a b} f :
  Confluent a b →
  Confluent (.app f a) (.app f b)
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
