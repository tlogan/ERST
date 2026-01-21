import Lang.Util
import Lang.Basic
import Lang.Pattern
import Lang.ParStep

set_option pp.fieldNotation false

namespace Lang

mutual
  inductive NRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | head l r: NStep e e' →  NRcdStep ((l, e) :: r) ((l, e') :: r)
  | tail l e : NRcdStep r r' → NRcdStep ((l,e) :: r) ((l,e) :: r')

  inductive NFunStep : List (Pat × Expr) → List (Pat × Expr) → Prop
  | head p f : NStep e e' →  NFunStep ((p, e) :: f) ((p, e') :: f)
  | tail p e : NFunStep f f' → NFunStep ((p,e) :: f) ((p,e) :: f')

  inductive NStep : Expr → Expr → Prop
  /- head normal forms -/
  | iso : NStep body body' → NStep (.iso l body) (.iso l body')
  | record : NRcdStep r r' →  NStep (.record r) (.record r')
  | function : NFunStep f f' →  NStep (.function f) (.function f')

  /- redex forms -/
  | applicator arg : NStep cator cator' → NStep (.app cator arg) (.app cator' arg)
  | applicand cator : NStep arg arg' → NStep (.app cator arg) (.app cator arg')
  | pattern_match body f :
    Pattern.match arg p = some m →
    NStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m body)
  | skip body f:
    arg.is_value →
    Pattern.match arg p = none →
    NStep (.app (.function ((p,body) :: f)) arg) (.app (.function f) arg)
  | anno : NStep body body' → NStep (.anno body t) (.anno body' t)
  | erase body t :
    NStep (.anno body t) body
  | loopi : NStep body body' → NStep (.loopi body) (.loopi body')
  | recycle x e :
    NStep
      (.loopi (.function [(.var x, e)]))
      (Expr.sub [(x, (.loopi (.function [(.var x, e)])))] e)

end

theorem NStep.not_value :
  NStep e e' → ¬ Expr.is_value e
:= by sorry


theorem NStep.project : NStep (Expr.project (Expr.record [(l, e)]) l) e := by
  unfold Expr.project
  have h0 : Pattern.match
    (Expr.record [(l, e)]) (Pat.record [(l, Pat.var "x")]) = some [("x", e)]
  := by
    simp [Pattern.match, Pattern.match_record, Pattern.match_entry,
        Inter.inter, List.inter,
        Pat.ids, List.pattern_ids,
        List.keys_unique, List.is_fresh_key
    ]
  have h1 : e = Expr.sub [("x", e)] (.var "x") := by exact rfl
  rw [h1]
  apply pattern_match
  exact h0



theorem NStep.refl_trans_iso :
  ReflTrans NStep body body' →
  ReflTrans NStep (Expr.iso label body) (Expr.iso label body')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply ReflTrans.refl
  | step h1 h2 ih =>
    apply ReflTrans.step (NStep.iso h1) ih

theorem NStep.refl_trans_record :
  ReflTrans NRcdStep r r' →
  ReflTrans NStep (.record r) (.record r')
:= by
  intro h0
  induction h0 with
  | refl r =>
    exact ReflTrans.refl (Expr.record r)
  | step h1 h2 ih =>
    apply ReflTrans.step
    { apply NStep.record h1 }
    { exact ih }

theorem NStep.refl_trans_function :
  ReflTrans NFunStep f f' →
  ReflTrans NStep (.function f) (.function f')
:= by
  intro h0
  induction h0 with
  | refl f =>
    exact ReflTrans.refl (Expr.function f)
  | step h1 h2 ih =>
    apply ReflTrans.step
    { apply NStep.function h1 }
    { exact ih }

theorem NStep.refl_trans_anno :
  ReflTrans NStep e e' →
  ReflTrans NStep (Expr.anno e t) (Expr.anno e' t)
:= by
  intro h0
  induction h0 with
  | refl =>
    apply ReflTrans.refl
  | step h1 h2 ih =>
    apply ReflTrans.step (NStep.anno h1) ih

theorem NRcdStep.refl_trans_head :
  ReflTrans NStep e e' →
  ReflTrans NRcdStep ((l,e)::r) ((l,e')::r)
:= by
  intro h1
  induction h1 with
  | refl e =>
    exact ReflTrans.refl ((l, e) :: r)
  | @step e em e' h1 h2 ih =>
    apply ReflTrans.step
    { apply NRcdStep.head _ _ h1 }
    { exact ih }

-- theorem List.is_fresh_key_n_rcd_step_reduction :
--   NRcdStep r r' →
--   ∀ {l},
--   List.is_fresh_key l r →
--   List.is_fresh_key l r'
-- := by
--   intro h0
--   cases h0 with
--   | head step' =>
--     intro l fresh
--     exact fresh
--   | tail fresh' step' =>
--     intro l fresh
--     have ih := @List.is_fresh_key_n_rcd_step_reduction _ _ step'
--     simp [List.is_fresh_key] at fresh
--     have ⟨h1,h2⟩ := fresh
--     clear fresh
--     simp [List.is_fresh_key]
--     apply And.intro h1
--     exact ih h2

theorem NRcdStep.refl_trans_cons :
  ReflTrans NStep e e' →
  ReflTrans NRcdStep r r' →
  ReflTrans NRcdStep ((l,e)::r) ((l,e')::r')
:= by
  intro h1 h2
  induction h2 with
  | @refl r =>
    apply NRcdStep.refl_trans_head h1
  | @step r rm r' h2 h3 ih =>
    apply ReflTrans.step
    { apply NRcdStep.tail _ _ h2 }
    { apply ih }

theorem NFunStep.refl_trans_head :
  ReflTrans NStep e e' →
  ReflTrans NFunStep ((p,e)::f) ((p,e')::f)
:= by
  intro h1
  induction h1 with
  | refl e =>
    exact ReflTrans.refl ((p, e) :: f)
  | @step e em e' h1 h2 ih =>
    apply ReflTrans.step
    { apply NFunStep.head p f h1 }
    { exact ih }

theorem NFunStep.refl_trans_cons :
  ReflTrans NStep e e' →
  ReflTrans NFunStep r r' →
  ReflTrans NFunStep ((p,e)::r) ((p,e')::r')
:= by
  intro h1 h2
  induction h2 with
  | @refl r =>
    apply NFunStep.refl_trans_head h1
  | @step r rm r' h2 h3 ih =>
    apply ReflTrans.step
    { apply NFunStep.tail _ _ h2 }
    { apply ih }

theorem NStep.refl_trans_applicand ef :
  ReflTrans NStep e e' →
  ReflTrans NStep (.app ef e) (.app ef e')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply ReflTrans.refl
  | step h1 h2 ih =>
    apply ReflTrans.step (NStep.applicand _ h1) ih


theorem NStep.joinable_applicand f :
  Joinable (ReflTrans NStep) a b →
  Joinable (ReflTrans NStep) (.app f a) (.app f b)
:= by
  unfold Joinable
  intro h0
  have ⟨c,h1,h2⟩ := h0
  exists (.app f c)
  apply And.intro
  { exact refl_trans_applicand f h1 }
  { exact refl_trans_applicand f h2 }


theorem NStep.refl_trans_app :
  ReflTrans NStep ef ef' →
  ReflTrans NStep  e e' →
  ReflTrans NStep  (.app ef e) (.app ef' e')
:= by
  intro h0 h1

  induction h0 with
  | @refl e =>
    exact NStep.refl_trans_applicand e h1
  | @step ef em ef' h1 h2 ih =>
    apply ReflTrans.transitivity
    { apply ReflTrans.step (NStep.applicator _ h1) ih }
    { exact ReflTrans.refl (Expr.app ef' e') }

theorem NStep.refl_trans_pattern_matcher
  (step_arg : ReflTrans NStep arg arg')
  (matching' : Pattern.match arg' p = some m')
: ReflTrans NStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m' body)
:= by induction step_arg with
| refl arg =>
  apply ReflTrans.step
  { apply NStep.pattern_match _ _ matching' }
  { exact ReflTrans.refl (Expr.sub m' body) }
| @step arg argm arg' h0 h1 ih =>
  apply ReflTrans.step
  { apply NStep.applicand _ h0 }
  { apply ih matching' }

theorem NStep.refl_trans_pattern_match
  (step_body : ReflTrans NStep body body')
  (step_arg : ReflTrans NStep arg arg')
  (matching' : Pattern.match arg' p = some m')
: ReflTrans NStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m' body')
:= by induction step_body with
| refl =>
  exact refl_trans_pattern_matcher step_arg matching'
| @step body bodym body' h0 h1 ih =>
  apply ReflTrans.step
  { apply NStep.applicator
    apply NStep.function
    apply NFunStep.head _ _ h0
  }
  { exact ih }

theorem NStep.refl_trans_skip
  (step_f : ReflTrans NFunStep f f')
  (step_arg : ReflTrans NStep arg arg')
  (nomatching : Pattern.match arg' p = none)
  (isval : Expr.is_value arg')
: ReflTrans NStep (.app (.function ((p,body) :: f)) arg) (.app (.function f') arg)
:= by induction step_f with
| _ => sorry

theorem NStep.refl_trans_loopi :
  ReflTrans NStep body body' →
  ReflTrans NStep (Expr.loopi body) (Expr.loopi body')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply ReflTrans.refl
  | step h1 h2 ih =>
    apply ReflTrans.step
    { apply NStep.loopi h1 }
    { exact ih }


mutual
  theorem NRcdStep.semi_completeness
    (step : ParRcdStep r r')
  : ReflTrans NRcdStep r r'
  := by cases step with
  | nil =>
    exact ReflTrans.refl []
  | @cons l  e e' rr rr' step_e step_rr =>
    have ih0 := NStep.semi_completeness step_e
    have ih1 := NRcdStep.semi_completeness step_rr
    exact NRcdStep.refl_trans_cons ih0 ih1

  theorem NFunStep.semi_completeness
    (step : ParFunStep f f')
  : ReflTrans NFunStep f f'
  := by cases step with
  | nil =>
    exact ReflTrans.refl []
  | @cons e e' ff ff' p step_e step_ff =>
    have ih0 := NStep.semi_completeness step_e
    have ih1 := NFunStep.semi_completeness step_ff
    exact NFunStep.refl_trans_cons ih0 ih1

  theorem NStep.semi_completeness
    (step : ParStep e e')
  : ReflTrans NStep e e'
  := by cases step  with
  | var x =>
    exact ReflTrans.refl (Expr.var x)
  | @iso body body' l step_body =>
    have ih := NStep.semi_completeness step_body
    exact NStep.refl_trans_iso ih
  | @record r r' step_r =>
    have ih := NRcdStep.semi_completeness step_r
    exact NStep.refl_trans_record ih
  | @function f f' step_f =>
    have ih := NFunStep.semi_completeness step_f
    exact NStep.refl_trans_function ih
  | @app cator cator' arg arg' step_cator step_arg =>
    have ih0 := NStep.semi_completeness step_cator
    have ih1 := NStep.semi_completeness step_arg
    exact NStep.refl_trans_app ih0 ih1
  | @pattern_match body body' arg arg' p m' f  step_body step_arg matching' =>
    have ih0 := NStep.semi_completeness step_arg
    have ih1 := NStep.semi_completeness step_body
    exact NStep.refl_trans_pattern_match ih1 ih0 matching'
  | @skip f f' arg arg' p body step_f step_arg isval nomatching =>
    have ih0 := NFunStep.semi_completeness step_f
    have ih1 := NStep.semi_completeness step_arg
    exact NStep.refl_trans_skip ih0 ih1 nomatching isval
  | @anno e e' t step_e =>
    have ih := NStep.semi_completeness step_e
    exact NStep.refl_trans_anno ih

  | erase =>
    apply ReflTrans.step
    { apply NStep.erase }
    { exact ReflTrans.refl e' }
  | @loopi body body' step_body =>
    have ih := NStep.semi_completeness step_body
    exact NStep.refl_trans_loopi ih
  | @recycle x e =>
    apply ReflTrans.step
    { apply NStep.recycle }
    { exact ReflTrans.refl (Expr.sub [(x, Expr.loopi (Expr.function [(Pat.var x, e)]))] e)}
end

mutual
  theorem ParRcdStep.completeness
    (step : NRcdStep r r')
  : ParRcdStep r r'
  := by cases step with
  | @head e e' l r step_e =>
    have ih := ParStep.completeness step_e
    apply ParRcdStep.cons _ ih (ParRcdStep.refl r)
  | @tail r r' l e step_r =>
    have ih := ParRcdStep.completeness step_r
    apply ParRcdStep.cons _ (ParStep.refl e) ih

  theorem ParFunStep.completeness
    (step : NFunStep f f')
  : ParFunStep f f'
  := by cases step with
  | @head e e' p f step_e =>
    have ih := ParStep.completeness step_e
    apply ParFunStep.cons _ ih (ParFunStep.refl f)

  | @tail f f' p e step_f =>
    have ih := ParFunStep.completeness step_f
    apply ParFunStep.cons _ (ParStep.refl e) ih

  theorem ParStep.completeness
    (step : NStep e e')
  : ParStep e e'
  := by cases step with
  | @iso body body' l step_body =>
    have ih := ParStep.completeness step_body
    exact ParStep.iso ih
  | @record r r' step_r =>
    have ih := ParRcdStep.completeness step_r
    exact ParStep.record ih
  | @function f f' step_f =>
    have ih := ParFunStep.completeness step_f
    exact ParStep.function ih
  | @applicator cator cator' arg step_cator =>
    have ih := ParStep.completeness step_cator
    apply ParStep.app ih
    exact ParStep.refl arg
  | @applicand cator arg arg' step_arg =>
    have ih := ParStep.completeness step_arg
    apply ParStep.app (ParStep.refl arg') ih
  | @pattern_match arg p m body f matching =>
    apply ParStep.pattern_match _ (ParStep.refl body) (ParStep.refl arg) matching
  | @skip arg p body f isval nomatching =>
    apply ParStep.skip _ (ParFunStep.refl f) (ParStep.refl arg) isval nomatching
  | @anno body body' t step_body =>
    have ih := ParStep.completeness step_body
    exact ParStep.anno ih
  | @erase e' t =>
    exact ParStep.erase e' t
  | @loopi body body' step_body =>
    have ih := ParStep.completeness step_body
    exact ParStep.loopi ih
  | @recycle x body =>
    exact ParStep.recycle x body
end


theorem NStep.refl_trans_completeness
  (par_step : ReflTrans ParStep e e')
: ReflTrans NStep e e'
:= by induction par_step with
| refl e =>
  exact ReflTrans.refl e
| @step e em e' h0 h1 ih =>
  apply ReflTrans.transitivity
  { exact NStep.semi_completeness h0 }
  { exact ih }


theorem NStep.refl_trans_soundness
  (n_step : ReflTrans NStep e e')
: ReflTrans ParStep e e'
:= by induction n_step with
| refl e =>
  exact ReflTrans.refl e
| @step e em e' h0 h1 ih =>

  apply ReflTrans.transitivity
  { apply ReflTrans.step
    { apply ParStep.completeness h0}
    { exact ih }
  }
  { exact ReflTrans.refl e' }

theorem NStep.joinable_completeness :
  Joinable (ReflTrans ParStep) ea eb →
  Joinable (ReflTrans NStep) ea eb
:= by
  unfold Joinable
  intro h0
  have ⟨en,h1,h2⟩ := h0 ; clear h0
  exists en
  apply And.intro
  { exact NStep.refl_trans_completeness h1 }
  { exact NStep.refl_trans_completeness h2 }


theorem NStep.confluence
  (step_a : ReflTrans NStep e ea)
  (step_b : ReflTrans NStep e eb)
: Joinable (ReflTrans NStep) ea eb
:= by
  apply NStep.joinable_completeness
  apply ParStep.confluence
  { exact NStep.refl_trans_soundness step_a }
  { exact NStep.refl_trans_soundness step_b }


end Lang
