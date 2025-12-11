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
| entry l e r e' :
  Transition e e' →
  Transition (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record : ∀ {r r' l v},
  Transition (Expr.record r) (Expr.record r') →
  v.is_value →
  Transition (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator : ∀ {ef ef' e},
  Transition ef ef' →
  Transition (.app ef e) (.app ef' e)
| applicand f e e' :
  Transition e e' →
  Transition (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  v.is_value →
  Expr.pattern_match v p = some m →
  Transition (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
| appskip : ∀ {p e f v},
  v.is_value →
  Expr.pattern_match v p = none →
  Transition (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {e t},
  Transition (.anno  e t) e
| loopbody : ∀ {e e'},
  Transition e e' →
  Transition (.loop e) (.loop e')
| looppeel : ∀ {id e},
  Transition
    (.loop (.function [(.var id, e)]))
    (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)


inductive TransitionStar : Expr → Expr → Prop
| refl e : TransitionStar e e
| step e e' e'' : Transition e e' → TransitionStar e' e'' → TransitionStar e e''


def SimpleTyping (e : Expr) : Typ → Prop
| .iso l body => SimpleTyping (.extract e l) body
| .entry l body => SimpleTyping (.proj e l) body
| .path left right => ∀ e' , SimpleTyping e' left → SimpleTyping (.app e e') right
| .unio left right => SimpleTyping e left ∨ SimpleTyping e right
| .inter left right => SimpleTyping e left ∧ SimpleTyping e right
| .diff left right => SimpleTyping e left ∧ ¬ (SimpleTyping e right)
| _ => False


def Subtyping.Fin (left right : Typ) : Prop :=
  ∀ e, SimpleTyping e left → SimpleTyping e right

inductive Sound : Expr → Prop
| fin e e' : TransitionStar e e' → Expr.is_value e' → Sound e
| inf e : (∀ e', TransitionStar e e' → ∃ e'' , Transition e' e'') → Sound e

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
  | .top => ∃ e',  Expr.is_value e' ∧ TransitionStar e e'
  /-  TODO :  update typing TOP with Sound -/
  -- | .top => Sound e
  | .iso l τ => Typing am (.extract e l) τ
  | .entry l τ => Typing am (.proj e l) τ
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
  | .var id => ∃ τ, find id am = some τ ∧ SimpleTyping e τ
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
  exists (Expr.record [])
  apply And.intro
  · exact rfl
  · apply TransitionStar.refl

theorem Typing.inter_entry_intro {am l e r body t} :
  Typing am e body →
  Typing am (.record r) t  →
  Typing am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry


theorem TransitionStar.record_single_elim {e l e' id}:
  TransitionStar e e' → Expr.is_value e' →
  TransitionStar (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)])) e'
:= by
  intro h0 h1
  induction h0 with
  | refl e'' =>
    apply TransitionStar.step
    { apply Transition.appmatch
      { reduce; exact h1 }
      { simp [Expr.pattern_match, List.pattern_match_record, Pat.free_vars, List.pattern_match_entry]
        reduce
        apply And.intro rfl rfl
      }
    }
    { simp [Expr.sub, find]
      apply TransitionStar.refl
    }
  | step e e' e'' h3 h4 ih =>
    cases h5 : (Expr.is_value (Expr.record [(l,e)])) with
    | true =>
      apply TransitionStar.step
      { apply Transition.appmatch h5
        { simp [Expr.pattern_match, List.pattern_match_record, Pat.free_vars, List.pattern_match_entry]
          reduce
          apply And.intro rfl rfl
        }
      }
      { simp [Expr.sub, find]
        exact TransitionStar.step e e' e'' h3 h4
      }
    | false =>
      apply TransitionStar.step
      {
        apply Transition.applicand
        apply Transition.entry
        apply h3
      }
      { apply ih h1 }

theorem Typing.app_record_bubble :
  Typing am (Expr.record [(lr, Expr.app e e')]) t →
  Typing am (Expr.app (Expr.record [(lr, e)]) e') t
:= by sorry

theorem Typing.app_proj_bubble :
  Typing am (Expr.proj (Expr.app e e') l) t →
  Typing am (Expr.app (Expr.proj e l) e') t
:= by sorry

theorem Typing.extract_record_bubble :
  Typing am (Expr.record [(lr, Expr.extract e li)]) t →
  Typing am (Expr.extract (Expr.record [(lr, e)]) li) t
:= by sorry

theorem Typing.extract_proj_bubble :
  Typing am (Expr.proj (Expr.extract e li) lr) t →
  Typing am (Expr.extract (Expr.proj e lr) li) t
:= by sorry

theorem Typing.proj_proj_bubble :
  Typing am (Expr.proj (Expr.proj e l0) l1) t →
  Typing am (Expr.proj (Expr.proj e l1) l0) t
:= by sorry

theorem Typing.proj_record_bubble :
  Typing am (Expr.record [(lr, Expr.proj e l)]) t →
  Typing am (Expr.proj (Expr.record [(lr, e)]) l) t
:= by sorry


theorem Typing.proj_record_beta_reduction :
  Typing am (Expr.proj (Expr.record [(l, e)]) l) t →
  Typing am e t
:= by sorry

theorem SimpleTyping.proj_record_beta_reduction :
  SimpleTyping (Expr.proj (Expr.record [(l, e)]) l) t →
  SimpleTyping e t
:= by sorry



theorem SimpleTyping.proj_record.app_bubble :
  SimpleTyping (Expr.proj (Expr.record [(l, Expr.app e e')]) l) body →
  SimpleTyping (Expr.app (Expr.proj (Expr.record [(l, e)]) l) e') body
:= by sorry

theorem SimpleTyping.proj_record_extract_bubble :
  SimpleTyping (Expr.proj (Expr.record [(l, Expr.extract e label)]) l) body →
  SimpleTyping (Expr.extract (Expr.proj (Expr.record [(l, e)]) l) label) body
:= by sorry

theorem SimpleTyping.proj_record.proj_bubble :
  SimpleTyping (Expr.proj (Expr.record [(l, Expr.proj e label)]) l) body →
  SimpleTyping (Expr.proj (Expr.proj (Expr.record [(l, e)]) l) label) body
:= by sorry



theorem Typing.proj_record_app_bubble :
  Typing am (Expr.proj (Expr.record [(l, Expr.app e e')]) l) body →
  Typing am (Expr.app (Expr.proj (Expr.record [(l, e)]) l) e') body
:= by sorry

theorem Typing.proj_record_proj_bubble :
  Typing am (Expr.proj (Expr.record [(l, Expr.proj e label)]) l) body →
  Typing am (Expr.proj (Expr.proj (Expr.record [(l, e)]) l) label) body
:= by sorry

theorem Typing.proj_record_extract_bubble :
  Typing am (Expr.proj (Expr.record [(l, Expr.extract e label)]) l) body →
  Typing am (Expr.extract (Expr.proj (Expr.record [(l, e)]) l) label) body
:= by sorry

--------------

theorem Typing.app_function_extract_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.extract e label) :: f)) v) body →
  Typing am (Expr.extract (Expr.app (Expr.function ((p, e) :: f)) v) label) body
:= by sorry

theorem Typing.app_function_proj_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.proj e label) :: f)) v) body →
  Typing am (Expr.proj (Expr.app (Expr.function ((p, e) :: f)) v) label) body
:= by sorry

theorem Typing.app_function_app_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.app e e') :: f)) v) body →
  Typing am (Expr.app (Expr.app (Expr.function ((p, e) :: f)) v) e') body
:= by sorry


theorem SimpleTyping.proj_record_beta_expansion l :
  SimpleTyping e t →
  SimpleTyping (Expr.proj (Expr.record [(l, e)]) l) t
:= by
  cases t with
  | iso label body =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    apply SimpleTyping.proj_record_extract_bubble
    have ih := SimpleTyping.proj_record_beta_expansion l h0
    apply ih

  | entry label body =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    apply SimpleTyping.proj_record.proj_bubble
    have ih := SimpleTyping.proj_record_beta_expansion l h0
    apply ih

  | path left right =>
    intro h0
    unfold SimpleTyping at h0
    intro e' h1
    specialize h0 e' h1
    apply SimpleTyping.proj_record.app_bubble
    have ih := SimpleTyping.proj_record_beta_expansion l h0
    apply ih

  | unio left right =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    cases h0 with
    | inl h1 =>
      have ih := SimpleTyping.proj_record_beta_expansion l h1
      exact Or.inl ih
    | inr h1 =>
      have ih := SimpleTyping.proj_record_beta_expansion l h1
      exact Or.inr ih

  | inter left right =>
    intro h0
    unfold SimpleTyping at h0
    have ⟨h1,h2⟩ := h0
    unfold SimpleTyping
    apply And.intro
    { apply SimpleTyping.proj_record_beta_expansion l h1 }
    { apply SimpleTyping.proj_record_beta_expansion l h2 }

  | diff left right =>
    intro h0
    unfold SimpleTyping at h0
    have ⟨h1,h2⟩ := h0
    unfold SimpleTyping
    apply And.intro
    { apply SimpleTyping.proj_record_beta_expansion l h1 }
    {
      intro h3
      apply h2
      exact SimpleTyping.proj_record_beta_reduction h3
    }

  | _ =>
    intro h0
    unfold SimpleTyping at h0
    exact h0

theorem Typing.proj_record_beta_expansion l :
  Typing am e t →
  Typing am (Expr.proj (Expr.record [(l, e)]) l) t
:= match t with
| .bot => by
  intro h0
  unfold Typing at h0
  exact False.elim h0

| .top => by
  intro h0
  unfold Typing at h0
  have ⟨e',h1,h2⟩ := h0
  unfold Typing
  exists e'
  apply And.intro h1
  exact TransitionStar.record_single_elim h2 h1

| .iso label body => by
  intro h0
  unfold Typing at h0
  unfold Typing
  have ih := Typing.proj_record_beta_expansion l h0
  apply Typing.proj_record_extract_bubble
  apply ih

| .entry label body => by
  intro h0
  unfold Typing at h0
  unfold Typing

  apply Typing.proj_record_proj_bubble
  have ih := Typing.proj_record_beta_expansion l h0
  apply ih

| .path left right => by
  intro h0
  unfold Typing at h0
  unfold Typing
  intro e' h1
  specialize h0 e' h1
  apply Typing.proj_record_app_bubble
  have ih := Typing.proj_record_beta_expansion l h0
  apply ih

| .unio left right => by
  intro h0
  unfold Typing at h0
  unfold Typing
  cases h0 with
  | inl h1 =>
    have ih := Typing.proj_record_beta_expansion l h1
    exact Or.inl ih
  | inr h1 =>
    have ih := Typing.proj_record_beta_expansion l h1
    exact Or.inr ih

| .inter left right => by
  intro h0
  unfold Typing at h0
  have ⟨h1,h2⟩ := h0
  unfold Typing
  apply And.intro
  { apply Typing.proj_record_beta_expansion l h1 }
  { apply Typing.proj_record_beta_expansion l h2 }

| .diff left right => by
  intro h0
  unfold Typing at h0
  have ⟨h1,h2⟩ := h0
  unfold Typing
  apply And.intro
  { apply Typing.proj_record_beta_expansion l h1 }
  {
    intro h3
    apply h2
    exact Typing.proj_record_beta_reduction h3
  }
| .exi ids quals body => by
  intro h0
  unfold Typing at h0
  have ⟨am', h1, h2, h3⟩ := h0
  unfold Typing
  exists am'
  apply And.intro h1
  apply And.intro h2
  apply Typing.proj_record_beta_expansion l h3

| .all ids quals body => by
  intro h0
  unfold Typing at h0
  unfold Typing
  intro am' dom_subset dynamic_quals
  specialize h0 am' dom_subset dynamic_quals
  apply Typing.proj_record_beta_expansion l h0

| .lfp id body => by
  intro h0
  unfold Typing at h0
  have ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩ := h0
  clear h0
  unfold Typing
  apply And.intro monotonic_body
  exists t
  exists lt_size
  apply And.intro imp_dynamic
  apply Typing.proj_record_beta_expansion l dynamic_body

| .var id => by
  intro h0
  unfold Typing at h0
  have ⟨t, h1, h2⟩ := h0
  unfold Typing
  exists t
  apply And.intro h1
  apply SimpleTyping.proj_record_beta_expansion l h2


theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  exact proj_record_beta_expansion l h0

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



theorem Typing.soundness :
  Typing am e t →
  Sound e
:= by sorry



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

theorem Transition.not_value :
  Transition e e' →
  ¬ Expr.is_value e
:= by sorry

theorem Typing.sub_extract_cascade :
  Typing am (Expr.extract (Expr.sub eam e) label) body →
  Typing am (Expr.sub eam (Expr.extract e label)) body
:= by sorry

theorem Typing.sub_proj_cascade :
  Typing am (Expr.proj (Expr.sub eam e) label) body →
  Typing am (Expr.sub eam (Expr.proj e label)) body
:= by sorry

theorem Typing.sub_app_cascade :
  Typing am (Expr.app (Expr.sub eam e) e') body →
  Typing am (Expr.sub eam (Expr.app e e')) body
:= by sorry

theorem Typing.app_function_value_beta_reduction f :
  Expr.is_value v → Expr.pattern_match v p = .some eam →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) v) tr →
  Typing am (Expr.sub eam e) tr
:= by sorry

theorem SimpleTyping.app_function_value_beta_expansion f :
  Expr.is_value v → Expr.pattern_match v p = .some eam →
  SimpleTyping (Expr.sub eam e) tr →
  SimpleTyping (Expr.app (Expr.function ((p, e) :: f)) v) tr
:= by sorry

theorem Typing.app_function_value_beta_expansion f :
  Expr.is_value v → Expr.pattern_match v p = .some eam →
  Typing am (Expr.sub eam e) tr →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) v) tr
:= match tr with
| .bot => by
  intro h0 h1
  unfold Typing
  simp
| .top => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨e', h3, h4⟩ := h2
  exists e'
  apply And.intro h3
  apply TransitionStar.step
  { apply Transition.appmatch h0 h1 }
  { exact h4 }

| .iso label body => by
  intro h0 h1
  unfold Typing
  intro h2
  apply Typing.sub_extract_cascade at h2
  have ih := Typing.app_function_value_beta_expansion f h0 h1 h2
  apply Typing.app_function_extract_bubble h0 h1 ih

| .entry label body => by
  intro h0 h1
  unfold Typing
  intro h2
  apply Typing.sub_proj_cascade at h2
  have ih := Typing.app_function_value_beta_expansion f h0 h1 h2
  apply Typing.app_function_proj_bubble h0 h1 ih

| .path left right => by
  intro h0 h1
  unfold Typing
  intro h2 e' h3
  specialize h2 e' h3
  apply Typing.sub_app_cascade at h2
  have ih := Typing.app_function_value_beta_expansion f h0 h1 h2
  apply Typing.app_function_app_bubble h0 h1 ih

| .unio left right => by
  intro h0 h1
  unfold Typing
  intro h2
  cases h2 with
  | inl h3 =>
    have ih := Typing.app_function_value_beta_expansion f h0 h1 h3
    exact Or.inl ih
  | inr h3 =>
    have ih := Typing.app_function_value_beta_expansion f h0 h1 h3
    exact Or.inr ih

| .inter left right => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨h3,h4⟩ := h2
  apply And.intro
  { apply Typing.app_function_value_beta_expansion f h0 h1 h3 }
  { apply Typing.app_function_value_beta_expansion f h0 h1 h4 }

| .diff left right => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨h3,h4⟩ := h2
  apply And.intro
  { apply Typing.app_function_value_beta_expansion f h0 h1 h3 }
  {
    intro h5
    apply h4
    apply Typing.app_function_value_beta_reduction f h0 h1 h5
  }

| .exi ids quals body => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨am', h3, h4, h5⟩ := h2
  exists am'
  apply And.intro h3
  apply And.intro h4
  apply Typing.app_function_value_beta_expansion f h0 h1 h5

| .all ids quals body => by
  intro h0 h1
  unfold Typing
  intro h2 am' h3 h4
  specialize h2 am' h3 h4
  apply Typing.app_function_value_beta_expansion f h0 h1 h2

| .lfp id body => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨h3,t,h4,h5,h6⟩ := h2
  apply And.intro h3
  exists t
  exists h4
  apply And.intro h5
  apply Typing.app_function_value_beta_expansion f h0 h1 h6

| .var id => by
  intro h0 h1
  unfold Typing
  intro h2
  have ⟨t,h3,h4⟩ := h2
  exists t
  apply And.intro h3
  exact SimpleTyping.app_function_value_beta_expansion f h0 h1 h4


theorem Transition.applicand_reflection :
  Transition e' e'' →
  Typing am (Expr.app e e'') t →
  Typing am (Expr.app e e') t
:= by sorry


theorem Typing.app_function_beta_expansion f :
  (∀ {v} ,
    Expr.is_value v → Typing am v tp →
    ∃ eam , Expr.pattern_match v p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am e' tp →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) e') tr
:= by
  intro h0 h1

  cases h2 : (Expr.is_value e') with
  | true =>
    have ⟨eam, h3, h4⟩ := h0 h2 h1
    exact app_function_value_beta_expansion f h2 h3 h4
  | false =>
    /- TODO: figure out how to -/
    -----------------------
    -- have h3 := Typing.progress h1
    -- simp [*] at h3
    -- have ⟨e'', h4⟩ := h3
    -- clear h3
    -----------------------
    -- have h4 := Typing.preservation h2 h1
    -- specialize ih h4
    -- exact Transition.applicand_reflection h2 ih
    sorry

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


def Convergence (a b : Expr) :=
  ∃ e , TransitionStar a e ∧ TransitionStar b e

theorem Convergence.typing_left_to_right {a b am t} :
  Convergence a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Expr.Convergence.typing_right_to_left {a b am t} :
  Convergence a b →
  Typing am b t →
  Typing am a t
:= by sorry

theorem Convergence.transitivity {a b c} :
  Convergence a b →
  Convergence b c →
  Convergence a c
:= by sorry

theorem Convergence.swap {a b} :
  Convergence a b →
  Convergence b a
:= by sorry

theorem Convergence.app_arg_preservation {a b} f :
  Convergence a b →
  Convergence (.app f a) (.app f b)
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
