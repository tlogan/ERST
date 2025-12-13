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

theorem Typing.app_project_bubble :
  Typing am (Expr.project (Expr.app e e') l) t →
  Typing am (Expr.app (Expr.project e l) e') t
:= by sorry

theorem Typing.extract_record_bubble :
  Typing am (Expr.record [(lr, Expr.extract e li)]) t →
  Typing am (Expr.extract (Expr.record [(lr, e)]) li) t
:= by sorry

theorem Typing.extract_project_bubble :
  Typing am (Expr.project (Expr.extract e li) lr) t →
  Typing am (Expr.extract (Expr.project e lr) li) t
:= by sorry

theorem Typing.project_project_bubble :
  Typing am (Expr.project (Expr.project e l0) l1) t →
  Typing am (Expr.project (Expr.project e l1) l0) t
:= by sorry

theorem Typing.project_record_bubble :
  Typing am (Expr.record [(lr, Expr.project e l)]) t →
  Typing am (Expr.project (Expr.record [(lr, e)]) l) t
:= by sorry


theorem Typing.project_record_beta_reduction :
  Typing am (Expr.project (Expr.record [(l, e)]) l) t →
  Typing am e t
:= by sorry

theorem SimpleTyping.project_record_beta_reduction :
  SimpleTyping (Expr.project (Expr.record [(l, e)]) l) t →
  SimpleTyping e t
:= by sorry



theorem SimpleTyping.project_record.app_bubble :
  SimpleTyping (Expr.project (Expr.record [(l, Expr.app e e')]) l) body →
  SimpleTyping (Expr.app (Expr.project (Expr.record [(l, e)]) l) e') body
:= by sorry

theorem SimpleTyping.project_record_extract_bubble :
  SimpleTyping (Expr.project (Expr.record [(l, Expr.extract e label)]) l) body →
  SimpleTyping (Expr.extract (Expr.project (Expr.record [(l, e)]) l) label) body
:= by sorry

theorem SimpleTyping.project_record.project_bubble :
  SimpleTyping (Expr.project (Expr.record [(l, Expr.project e label)]) l) body →
  SimpleTyping (Expr.project (Expr.project (Expr.record [(l, e)]) l) label) body
:= by sorry



theorem Typing.project_record_app_bubble :
  Typing am (Expr.project (Expr.record [(l, Expr.app e e')]) l) body →
  Typing am (Expr.app (Expr.project (Expr.record [(l, e)]) l) e') body
:= by sorry

theorem Typing.project_record_project_bubble :
  Typing am (Expr.project (Expr.record [(l, Expr.project e label)]) l) body →
  Typing am (Expr.project (Expr.project (Expr.record [(l, e)]) l) label) body
:= by sorry

theorem Typing.project_record_extract_bubble :
  Typing am (Expr.project (Expr.record [(l, Expr.extract e label)]) l) body →
  Typing am (Expr.extract (Expr.project (Expr.record [(l, e)]) l) label) body
:= by sorry

--------------

theorem Typing.app_function_extract_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.extract e label) :: f)) v) body →
  Typing am (Expr.extract (Expr.app (Expr.function ((p, e) :: f)) v) label) body
:= by sorry

theorem Typing.app_function_project_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.project e label) :: f)) v) body →
  Typing am (Expr.project (Expr.app (Expr.function ((p, e) :: f)) v) label) body
:= by sorry

theorem Typing.app_function_app_bubble :
  Expr.is_value v →
  Expr.pattern_match v p = some eam →
  Typing am (Expr.app (Expr.function ((p, Expr.app e e') :: f)) v) body →
  Typing am (Expr.app (Expr.app (Expr.function ((p, e) :: f)) v) e') body
:= by sorry


theorem Convergent.project_record_beta_expansion :
  Convergent e → Convergent (Expr.project (Expr.record [(l, e)]) l)
:= by
  unfold Convergent
  intro h0
  have ⟨e',h1,h2⟩ := h0
  exists e'
  apply And.intro
  { apply TransitionStar.record_single_elim  h1 h2 }
  { exact h2 }

theorem Divergent.project_record_beta_expansion :
  Divergent e → Divergent (Expr.project (Expr.record [(l, e)]) l)
:= by
  sorry


theorem SimpleTyping.project_record_beta_expansion l :
  SimpleTyping e t →
  SimpleTyping (Expr.project (Expr.record [(l, e)]) l) t
:= by
  cases t with
  | top =>
    unfold SimpleTyping
    intro h0
    cases h0 with
    | inl h1 =>
      apply Or.inl
      exact Convergent.project_record_beta_expansion h1
    | inr h1 =>
      apply Or.inr
      exact Divergent.project_record_beta_expansion h1

  | iso label body =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    apply SimpleTyping.project_record_extract_bubble
    have ih := SimpleTyping.project_record_beta_expansion l h0
    apply ih

  | entry label body =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    apply SimpleTyping.project_record.project_bubble
    have ih := SimpleTyping.project_record_beta_expansion l h0
    apply ih

  | path left right =>
    intro h0
    unfold SimpleTyping at h0
    intro e' h1
    specialize h0 e' h1
    apply SimpleTyping.project_record.app_bubble
    have ih := SimpleTyping.project_record_beta_expansion l h0
    apply ih

  | unio left right =>
    intro h0
    unfold SimpleTyping at h0
    unfold SimpleTyping
    cases h0 with
    | inl h1 =>
      have ih := SimpleTyping.project_record_beta_expansion l h1
      exact Or.inl ih
    | inr h1 =>
      have ih := SimpleTyping.project_record_beta_expansion l h1
      exact Or.inr ih

  | inter left right =>
    intro h0
    unfold SimpleTyping at h0
    have ⟨h1,h2⟩ := h0
    unfold SimpleTyping
    apply And.intro
    { apply SimpleTyping.project_record_beta_expansion l h1 }
    { apply SimpleTyping.project_record_beta_expansion l h2 }

  | diff left right =>
    intro h0
    unfold SimpleTyping at h0
    have ⟨h1,h2⟩ := h0
    unfold SimpleTyping
    apply And.intro
    { apply SimpleTyping.project_record_beta_expansion l h1 }
    {
      intro h3
      apply h2
      exact SimpleTyping.project_record_beta_reduction h3
    }

  | _ =>
    intro h0
    unfold SimpleTyping at h0
    exact h0

theorem Typing.project_record_beta_expansion l :
  Typing am e t →
  Typing am (Expr.project (Expr.record [(l, e)]) l) t
:= match t with
| .bot => by
  intro h0
  unfold Typing at h0
  exact False.elim h0

| .top => by
  unfold Typing
  intro h0
  cases h0 with
  | inl h1 =>
    apply Or.inl
    exact Convergent.project_record_beta_expansion h1
  | inr h1 =>
    apply Or.inr
    exact Divergent.project_record_beta_expansion h1

| .iso label body => by
  intro h0
  unfold Typing at h0
  unfold Typing
  have ih := Typing.project_record_beta_expansion l h0
  apply Typing.project_record_extract_bubble
  apply ih

| .entry label body => by
  intro h0
  unfold Typing at h0
  unfold Typing

  apply Typing.project_record_project_bubble
  have ih := Typing.project_record_beta_expansion l h0
  apply ih

| .path left right => by
  intro h0
  unfold Typing at h0
  unfold Typing
  intro e' h1
  specialize h0 e' h1
  apply Typing.project_record_app_bubble
  have ih := Typing.project_record_beta_expansion l h0
  apply ih

| .unio left right => by
  intro h0
  unfold Typing at h0
  unfold Typing
  cases h0 with
  | inl h1 =>
    have ih := Typing.project_record_beta_expansion l h1
    exact Or.inl ih
  | inr h1 =>
    have ih := Typing.project_record_beta_expansion l h1
    exact Or.inr ih

| .inter left right => by
  intro h0
  unfold Typing at h0
  have ⟨h1,h2⟩ := h0
  unfold Typing
  apply And.intro
  { apply Typing.project_record_beta_expansion l h1 }
  { apply Typing.project_record_beta_expansion l h2 }

| .diff left right => by
  intro h0
  unfold Typing at h0
  have ⟨h1,h2⟩ := h0
  unfold Typing
  apply And.intro
  { apply Typing.project_record_beta_expansion l h1 }
  {
    intro h3
    apply h2
    exact Typing.project_record_beta_reduction h3
  }
| .exi ids quals body => by
  intro h0
  unfold Typing at h0
  have ⟨am', h1, h2, h3⟩ := h0
  unfold Typing
  exists am'
  apply And.intro h1
  apply And.intro h2
  apply Typing.project_record_beta_expansion l h3

| .all ids quals body => by
  intro h0
  unfold Typing at h0
  unfold Typing
  intro am' dom_subset dynamic_quals
  specialize h0 am' dom_subset dynamic_quals
  apply Typing.project_record_beta_expansion l h0

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
  apply Typing.project_record_beta_expansion l dynamic_body

| .var id => by
  intro h0
  unfold Typing at h0
  have ⟨t, h1, h2⟩ := h0
  unfold Typing
  exists t
  apply And.intro h1
  apply SimpleTyping.project_record_beta_expansion l h2


theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  exact project_record_beta_expansion l h0

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

theorem Typing.sub_extract_cascade :
  Typing am (Expr.extract (Expr.sub eam e) label) body →
  Typing am (Expr.sub eam (Expr.extract e label)) body
:= by sorry

theorem Typing.sub_project_cascade :
  Typing am (Expr.project (Expr.sub eam e) label) body →
  Typing am (Expr.sub eam (Expr.project e label)) body
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

theorem Convergent.app_function_value_beta_expansion f :
  Expr.is_value v → Expr.pattern_match v p = .some eam →
  Convergent (Expr.sub eam e) →
  Convergent (Expr.app (Expr.function ((p, e) :: f)) v)
:= by
  unfold Convergent
  intro h0 h1 h2
  have ⟨e',h3,h4⟩ := h2
  exists e'
  apply And.intro
  {
    apply TransitionStar.step
    { apply Transition.appmatch h0 h1 }
    { apply h3 }
  }
  { exact h4 }

theorem Divergent.app_function_value_beta_expansion f :
  Expr.is_value v → Expr.pattern_match v p = .some eam →
  Divergent (Expr.sub eam e) →
  Divergent (Expr.app (Expr.function ((p, e) :: f)) v)
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
  cases h2 with
  | inl h3 =>
    apply Or.inl
    exact Convergent.app_function_value_beta_expansion f h0 h1 h3
  | inr h3 =>
    apply Or.inr
    exact Divergent.app_function_value_beta_expansion f h0 h1 h3

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
  apply Typing.sub_project_cascade at h2
  have ih := Typing.app_function_value_beta_expansion f h0 h1 h2
  apply Typing.app_function_project_bubble h0 h1 ih

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

theorem Typing.exists_value :
  Typing am e t →
  ∃ v , Expr.is_value v ∧ Typing am v t
:= by sorry


theorem Divergent.transition :
  Divergent e →
  ∃ e' , Transition e e' ∧ Divergent e'
:= by sorry




inductive EvalContext : (Expr → Expr) → Prop
| applicator e' : EvalContext (fun e => (.app e e'))
| applicand f : EvalContext (fun e => (.app (.function f) e))
| nested E E' : EvalContext E → EvalContext E' → EvalContext (fun e => E (E' e))


theorem EvalContext.transition_preservation :
  EvalContext E →
  Transition e e'→
  Transition (E e) (E e')
:= by sorry


theorem EvalContext.transition_unique :
  EvalContext E →
  Transition e e' → Transition (E e) er →
  (E e') = er
:= by sorry

theorem EvalContext.extract_compos l :
  EvalContext E →
  EvalContext (fun e => Expr.extract (E e) l)
:= by sorry

theorem EvalContext.project_compos l :
  EvalContext E →
  EvalContext (fun e => Expr.project (E e) l)
:= by sorry



theorem EvalContext.app_compos e' :
  EvalContext E →
  EvalContext (fun e => Expr.app (E e) e')
:= by sorry




theorem Divergent.applicand :
  EvalContext E →
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
    apply EvalContext.transition_preservation h0
    exact h3

  | step eg em e' h4 h5 ih =>

    intro e h1 h2
    rw [← h2] at h4
    clear h2
    apply Divergent.transition at h1
    have ⟨et, h6,h7⟩ := h1
    apply ih h7
    apply EvalContext.transition_unique h0
    exact h6
    exact h4


theorem Typing.divergent_applicand_swap :
  Divergent e_inf →
  Typing am e t → Typing am e_inf t →
  EvalContext E →
  Typing am (E e) t' → Typing am (E e_inf) t'
:= match t' with
| .bot => by
  intro h0 h1 h2 h3
  unfold Typing
  intro h4
  exact h4

| .top => by
  intro h0 h1 h2 h3
  unfold Typing
  intro h4
  apply Or.inr
  clear h4
  exact Divergent.applicand h3 h0

| .iso label body => by
  intro h0 h1 h2 h3
  unfold Typing
  apply EvalContext.extract_compos label at h3
  intro h4

  apply Typing.divergent_applicand_swap h0 h1 h2 h3 h4

| .entry label body => by

  intro h0 h1 h2 h3
  unfold Typing
  apply EvalContext.project_compos label at h3
  intro h4
  apply Typing.divergent_applicand_swap h0 h1 h2 h3 h4

| .path left right => by
  intro h0 h1 h2 h3
  unfold Typing
  intro h4 e' h5
  apply EvalContext.app_compos e' at h3
  apply Typing.divergent_applicand_swap h0 h1 h2 h3 (h4 e' h5)

| .unio left right => by
  sorry
| .inter left right => by
  intro h0 h1 h2 h3
  unfold Typing
  intro h4
  have ⟨h5,h6⟩ := h4
  apply And.intro
  { apply Typing.divergent_applicand_swap h0 h1 h2 h3 h5 }
  { apply Typing.divergent_applicand_swap h0 h1 h2 h3 h6 }

| .diff left right => by
  sorry
| .exi ids quals body => by
  sorry
| .all ids quals body => by
  sorry
| .lfp id body => by
  sorry
| .var id => by
  sorry


theorem Typing.app_function_beta_expansion f :
  (∀ {v} ,
    Expr.is_value v → Typing am v tp →
    ∃ eam , Expr.pattern_match v p = .some eam ∧ Typing am (Expr.sub eam e) tr
  ) →
  Typing am e' tp →
  Typing am (Expr.app (Expr.function ((p, e) :: f)) e') tr
:= by
  intro h0 h1
  have h3 := Typing.soundness h1
  cases h3 with
  | inl h4 =>
    unfold Convergent at h4
    have ⟨e'', h5, h6⟩ := h4
    clear h4
    induction h5 with
    | refl e'' =>
      specialize h0 h6 h1
      have ⟨eam,h7,h8⟩ := h0
      exact app_function_value_beta_expansion f h6 h7 h8
    | step e' e'' e''' h7 h8 ih =>
      have h9 := Typing.preservation h7 h1
      apply Transition.applicand_reflection h7
      apply ih h9 h6
  | inr h4 =>
    have ⟨v, h5, h6⟩ := Typing.exists_value h1

    apply Typing.divergent_applicand_swap h4 h6 h1 (EvalContext.applicand ((p, e) :: f))
    specialize h0 h5 h6
    have ⟨eam,h7,h8⟩ := h0
    exact app_function_value_beta_expansion f h5 h7 h8


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
