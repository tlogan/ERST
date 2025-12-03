import Lang.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false



mutual
  def pattern_match_entry (label : String) (pat : Pat) :
  List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (pattern_match e pat)
    else
      pattern_match_entry label pat args

  def pattern_match_record (args : List (String × Expr)):
  List (String × Pat) →
  Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.free_vars pat ∩ ListPat.free_vars pats = [] then
      let m0 ← pattern_match_entry label pat args
      let m1 ← pattern_match_record args pats
      return (m0 ++ m1)
    else
      .none

  def pattern_match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | (.record r), (.record p) => pattern_match_record r p
  | _, _ => none
end

mutual
  def ids_record_pattern : List (String × Pat) → List String
  | .nil => .nil
  | (_, p) :: r =>
    (ids_pattern p) ++ (ids_record_pattern r)

  def ids_pattern : Pat → List String
  | .var id => [id]
  | .iso l body => ids_pattern body
  | .record r => ids_record_pattern r
end


mutual
  def Expr.Record.sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.sub m e) :: (Expr.Record.sub m r)

  def Expr.Function.sub (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := ids_pattern p
    (p, Expr.sub (remove_all m ids) e) :: (Expr.Function.sub m f)

  def Expr.sub (m : List (String × Expr)): Expr → Expr
  | .var id => match (find id m) with
    | .none => (.var id)
    | .some e => e
  | .iso l body => .iso l (Expr.sub m body)
  | .record r => .record (Expr.Record.sub m r)
  | .function f => .function (Expr.Function.sub m f)
  | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
  | .anno e t => .anno (Expr.sub m e) t
  | .loop e => .loop (Expr.sub m e)
end


theorem Expr.sub_sub_removal {ids eam0 eam1 e} :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry


inductive Progression : Expr → Expr → Prop
| entry l e r e' :
  Progression e e' →
  Progression (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record : ∀ {r r' l v},
  Progression (Expr.record r) (Expr.record r') →
  v.is_value →
  Progression (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator : ∀ {ef ef' e},
  Progression ef ef' →
  Progression (.app ef e) (.app ef' e)
| applicand f e e' :
  Progression e e' →
  Progression (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  v.is_value →
  pattern_match v p = some m →
  Progression (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
| appskip : ∀ {p e f v},
  v.is_value →
  pattern_match v p = none →
  Progression (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {e t},
  Progression (.anno  e t) e
| loopbody : ∀ {e e'},
  Progression e e' →
  Progression (.loop e) (.loop e')
| looppeel : ∀ {id e},
  Progression
    (.loop (.function [(.var id, e)]))
    (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)


inductive ProgressionStar : Expr → Expr → Prop
| refl e : ProgressionStar e e
| step e e' e'' : Progression e e' → ProgressionStar e' e'' → ProgressionStar e e''


def Typing.Dynamic.Fin (e : Expr) : Typ → Prop
| .entry l τ => Typing.Dynamic.Fin (.record [(l,e)]) τ
| .path left right => ∀ e' , Typing.Dynamic.Fin e' left → Typing.Dynamic.Fin (.app e e') right
| .unio left right => Typing.Dynamic.Fin e left ∨ Typing.Dynamic.Fin e right
| .inter left right => Typing.Dynamic.Fin e left ∧ Typing.Dynamic.Fin e right
| .diff left right => Typing.Dynamic.Fin e left ∧ ¬ (Typing.Dynamic.Fin e right)
| _ => False

def Subtyping.Dynamic.Fin (left right : Typ) : Prop :=
  ∀ e, Typing.Dynamic.Fin e left → Typing.Dynamic.Fin e right


mutual
  def Subtyping.Dynamic (am : List (String × Typ)) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing.Dynamic am e left → Typing.Dynamic am e right
  termination_by Typ.size left + Typ.size right
  decreasing_by
    all_goals simp [Typ.zero_lt_size]

  def MultiSubtyping.Dynamic (am : List (String × Typ)) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping.Dynamic am left right ∧ MultiSubtyping.Dynamic am remainder
  termination_by sts => ListSubtyping.size sts
  decreasing_by
    all_goals simp [ListSubtyping.size, ListPairTyp.zero_lt_size, Typ.zero_lt_size]

def Typ.Monotonic.Dynamic (am : List (String × Typ)) (id : String) (body : Typ) : Prop :=
  (∀ t0 t1,
    Subtyping.Dynamic am t0 t1 →
    ∀ e, Typing.Dynamic ((id,t0):: am) e body → Typing.Dynamic ((id,t1):: am) e body
  )
  termination_by Typ.size body
  decreasing_by
    all_goals sorry

  def Typing.Dynamic (am : List (String × Typ)) (e : Expr) : Typ → Prop
  | .bot => False
  | .top => ∃ e',  Expr.is_value e' ∧ ProgressionStar e e'
  | .iso l τ => Typing.Dynamic am (.extract e l) τ
  | .entry l τ => Typing.Dynamic am (.proj e l) τ
  | .path left right => ∀ e' , Typing.Dynamic am e' left → Typing.Dynamic am (.app e e') right
  | .unio left right => Typing.Dynamic am e left ∨ Typing.Dynamic am e right
  | .inter left right => Typing.Dynamic am e left ∧ Typing.Dynamic am e right
  | .diff left right => Typing.Dynamic am e left ∧ ¬ (Typing.Dynamic am e right)
  | .exi ids quals body =>
    ∃ am' , (ListPair.dom am') ⊆ ids ∧
    (MultiSubtyping.Dynamic (am' ++ am) quals) ∧
    (Typing.Dynamic (am' ++ am) e body)
  | .all ids quals body =>
    ∀ am' , (ListPair.dom am') ⊆ ids →
    (MultiSubtyping.Dynamic (am' ++ am) quals) →
    (Typing.Dynamic (am' ++ am) e body)
  | .lfp id body =>
    Typ.Monotonic.Dynamic am id body ∧
    (∃ t, ∃ (h : Typ.size t < Typ.size (.lfp id body)),
      (∀ e',
        Typing.Dynamic am e' t →
        Typing.Dynamic ((id,t) :: am) e' body
      ) ∧
      Typing.Dynamic ((id,t) :: am) e  body
    )
  -----------------------
  -- TODO: remove old lfp case
  -- | .lfp id body =>
  --   Typ.Monotonic id true body ∧
  --   ∃ n, Typing.Dynamic.Fin e (Typ.sub am (Typ.subfold id body n))
  | .var id => ∃ τ, find id am = some τ ∧ Typing.Dynamic.Fin e τ
  termination_by t => (Typ.size t)
  decreasing_by
    all_goals simp_all [Typ.size]
    all_goals try linarith
end

def MultiTyping.Dynamic
  (tam : List (String × Typ)) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, find x context = .some t → ∃ e, (find x eam) = .some e ∧ Typing.Dynamic tam e t



--- TODO: consider Typ.sub and other typ manipulations as forms of static semantics
--- rename lemmas to indicate they are either soundness or (conditional) completeness properties


theorem MultiSubtyping.Dynamic.removeAll_union {tam cs' cs} :
  MultiSubtyping.Dynamic tam (List.removeAll cs' cs ∪ cs) →
  MultiSubtyping.Dynamic tam cs'
:= by sorry



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

theorem Subtyping.Dynamic.diff_intro {am t left right} :
  Subtyping.Dynamic am t left →
  ¬ (Subtyping.Dynamic am t right) →
  ¬ (Subtyping.Dynamic am right t) →
  Subtyping.Dynamic am t (Typ.diff left right)
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
:= by
  unfold Typing.Dynamic
  exists (Expr.record [])
  apply And.intro
  · exact rfl
  · apply ProgressionStar.refl

theorem Typing.Dynamic.inter_entry_intro {am l e r body t} :
  Typing.Dynamic am e body →
  Typing.Dynamic am (.record r) t  →
  Typing.Dynamic am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry


theorem ProgressionStar.record_single_elim {e l e' id}:
  ProgressionStar e e' → Expr.is_value e' →
  ProgressionStar (Expr.app (Expr.function [(Pat.record [(l, Pat.var id)], Expr.var id)]) (Expr.record [(l, e)])) e'
:= by
  intro h0 h1
  induction h0 with
  | refl e'' =>
    apply ProgressionStar.step
    { apply Progression.appmatch
      { reduce; exact h1 }
      { simp [pattern_match, pattern_match_record, Pat.free_vars, pattern_match_entry]
        reduce
        apply And.intro rfl rfl
      }
    }
    { simp [Expr.sub, find]
      apply ProgressionStar.refl
    }
  | step e e' e'' h3 h4 ih =>
    cases h5 : (Expr.is_value (Expr.record [(l,e)])) with
    | true =>
      apply ProgressionStar.step
      { apply Progression.appmatch h5
        { simp [pattern_match, pattern_match_record, Pat.free_vars, pattern_match_entry]
          reduce
          apply And.intro rfl rfl
        }
      }
      { simp [Expr.sub, find]
        exact ProgressionStar.step e e' e'' h3 h4
      }
    | false =>
      apply ProgressionStar.step
      {
        apply Progression.applicand
        apply Progression.entry
        apply h3
      }
      { apply ih h1 }

theorem Typing.Dynamic.entry_intro l am t :
  ∀ e,
  Typing.Dynamic am e t →
  Typing.Dynamic am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= match t with
| .bot => by
  intro e h0
  unfold Typing.Dynamic at h0
  exact False.elim h0
| .top => by
  intro e h0
  unfold Typing.Dynamic at h0
  have ⟨e', h1,h2⟩ := h0
  unfold Typing.Dynamic
  simp [Expr.proj]
  unfold Typing.Dynamic
  exists e'
  apply And.intro h1
  exact ProgressionStar.record_single_elim h2 h1
| .iso label body => by
  intro e h0
  unfold Typing.Dynamic at h0
  unfold Typing.Dynamic
  unfold Typing.Dynamic
  -- have ih := Typing.Dynamic.entry_intro l am body _ h0
  -- unfold Typing.Dynamic at ih
  -- simp [Expr.extract] at h0
  -- simp [Expr.proj]
  -- simp [Expr.extract]
  sorry
-- | .entry l τ => Typing.Dynamic am (.proj e l) τ
-- | .path left right => ∀ e' , Typing.Dynamic am e' left → Typing.Dynamic am (.app e e') right
-- | .unio left right => Typing.Dynamic am e left ∨ Typing.Dynamic am e right
| .inter left right => by
    intro e h0
    unfold Typing.Dynamic at h0
    have ⟨h1,h2⟩ := h0
    unfold Dynamic
    unfold Dynamic
    apply And.intro
    {
      have ih := Typing.Dynamic.entry_intro l am left _ h1
      unfold Dynamic at ih
      apply ih
    }
    {
      have ih := Typing.Dynamic.entry_intro l am right _ h2
      unfold Dynamic at ih
      apply ih
    }
-- | .diff left right => Typing.Dynamic am e left ∧ ¬ (Typing.Dynamic am e right)
-- | .exi ids quals body =>
--   ∃ am' , (ListPair.dom am') ⊆ ids ∧
--   (MultiSubtyping.Dynamic (am' ++ am) quals) ∧
--   (Typing.Dynamic (am' ++ am) e body)
-- | .all ids quals body =>
--   ∀ am' , (ListPair.dom am') ⊆ ids →
--   (MultiSubtyping.Dynamic (am' ++ am) quals) →
--   (Typing.Dynamic (am' ++ am) e body)
-- | .lfp id body =>
--   Typ.Monotonic.Dynamic am id body ∧
--   (∃ t, ∃ (h : Typ.size t < Typ.size (.lfp id body)),
--     (∀ e',
--       Typing.Dynamic am e' t →
--       Typing.Dynamic ((id,t) :: am) e' body
--     ) ∧
--     Typing.Dynamic ((id,t) :: am) e  body
--   )
-- -----------------------
-- -- TODO: remove old lfp case
-- -- | .lfp id body =>
-- --   Typ.Monotonic id true body ∧
-- --   ∃ n, Typing.Dynamic.Fin e (Typ.sub am (Typ.subfold id body n))
-- | .var id => ∃ τ, find id am = some τ ∧ Typing.Dynamic.Fin e τ
| _ => sorry


theorem Typing.Dynamic.function_head_elim {am p e f subtras tp tr} :
  (∀ {v} ,
    Expr.is_value v → Typing.Dynamic am v tp →
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
  (∀ {v} , Expr.is_value v → Typing.Dynamic am v tp → ∃ eam , pattern_match v p = .some eam) →
  ¬ Subtyping.Dynamic am t (.path tp .top) →
  Typing.Dynamic am (.function f) t →
  Typing.Dynamic am (.function ((p,e) :: f)) t
:= by sorry


theorem dummy {x : Nat} :
  x = x
:= by sorry

theorem test (p q : Prop) (hp : p) (hq : q)
: p ∧ q ∧ p := by sorry


theorem Typing.Dynamic.path_elim {am ef ea t t'} :
  Typing.Dynamic am ef (.path t t') →
  Typing.Dynamic am ea t →
  Typing.Dynamic am (.app ef ea) t'
:= by
  intro h0
  unfold Typing.Dynamic at h0
  exact fun a => h0 ea a

theorem Typing.Dynamic.loop_path_elim {am e t} id :
  Typing.Dynamic am e (.path (.var id) t) →
  Typing.Dynamic am (.loop e) t
:= by
  sorry

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


theorem MultiSubtyping.Dynamic.removeAll_removal {tam assums assums'} :
  MultiSubtyping.Dynamic tam assums →
  MultiSubtyping.Dynamic tam (List.removeAll assums' assums) →
  MultiSubtyping.Dynamic tam assums'
:= by sorry


theorem Subtyping.Dynamic.lfp_induct_elim {am id body t} :
  Typ.Monotonic.Dynamic am id body →
  (∀ e, Typing.Dynamic ((id, t) :: am) e body → Typing.Dynamic am e t) →
  Subtyping.Dynamic am (Typ.lfp id body) t
:= by sorry
