import Lang.Util
import Lang.Basic
import Lang.Pattern
import Lang.ParStep

set_option pp.fieldNotation false

namespace Lang

mutual
  inductive NRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | head : NStep e e' →  List.is_fresh_key l r → NRcdStep ((l, e) :: r) ((l, e') :: r)
  | tail e : NRcdStep r r' → List.is_fresh_key l r → NRcdStep ((l,e) :: r) ((l,e) :: r')

  inductive NStep : Expr → Expr → Prop
  /- head normal forms -/
  | iso : NStep body body' → NStep (.iso l body) (.iso l body')
  | record : NRcdStep r r' →  NStep (.record r) (.record r')

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
  | erase body t :
    NStep (.anno body t) body
  | loopi : NStep body body' → NStep (.loop body) (.loop body')
  | recycle x e :
    NStep
      (.loop (.function [(.var x, e)]))
      (Expr.sub [(x, (.loop (.function [(.var x, e)])))] e)

end

theorem NStep.not_value :
  NStep e e' → ¬ Expr.is_value e
:= by sorry


theorem NStep.project : NStep (Expr.project (Expr.record [(l, e)]) l) e := by
  unfold Expr.project
  have h0 : Pattern.match
    (Expr.record [(l, e)]) (Pat.record [(l, Pat.var "x")]) = some [("x", e)]
  := by
    simp [Pattern.match, Pattern.match_record, Pattern.match_entry, Inter.inter, List.inter, ListPat.free_vars, Pat.ids, List.pattern_ids]
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

theorem NRcdStep.refl_trans_head :
  List.is_fresh_key l r →
  ReflTrans NStep e e' →
  ReflTrans NRcdStep ((l,e)::r) ((l,e')::r)
:= by
  intro h0 h1
  induction h1 with
  | refl e =>
    exact ReflTrans.refl ((l, e) :: r)
  | @step e em e' h1 h2 ih =>
    apply ReflTrans.step
    { apply NRcdStep.head h1 h0 }
    { exact ih }

theorem List.is_fresh_key_n_rcd_step_reduction :
  NRcdStep r r' →
  ∀ {l},
  List.is_fresh_key l r →
  List.is_fresh_key l r'
:= by
  intro h0
  cases h0 with
  | head step' =>
    intro l fresh
    exact fresh
  | tail fresh' step' =>
    intro l fresh
    have ih := @List.is_fresh_key_n_rcd_step_reduction _ _ step'
    simp [List.is_fresh_key] at fresh
    have ⟨h1,h2⟩ := fresh
    clear fresh
    simp [List.is_fresh_key]
    apply And.intro h1
    exact ih h2

theorem NRcdStep.refl_trans_cons :
  List.is_fresh_key l r →
  ReflTrans NStep e e' →
  ReflTrans NRcdStep r r' →
  ReflTrans NRcdStep ((l,e)::r) ((l,e')::r')
:= by
  intro h0 h1 h2
  induction h2 with
  | @refl r =>
    exact NRcdStep.refl_trans_head h0 h1
  | @step r rm r' h2 h3 ih =>
    apply ReflTrans.step
    { apply NRcdStep.tail _ h2 h0 }
    {
      apply ih
      exact List.is_fresh_key_n_rcd_step_reduction h2 h0
    }

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

theorem NStep.refl_trans_loopi :
  ReflTrans NStep body body' →
  ReflTrans NStep (Expr.loop body) (Expr.loop body')
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
  | refl =>
    exact ReflTrans.refl r
  | @cons l  e e' rr rr' step_e step_rr fresh =>
    have ih0 := NStep.semi_completeness step_e
    have ih1 := NRcdStep.semi_completeness step_rr
    exact NRcdStep.refl_trans_cons fresh ih0 ih1

  theorem NStep.semi_completeness
    (step : ParStep e e')
  : ReflTrans NStep e e'
  := by cases step  with
  | refl =>
    exact ReflTrans.refl e
  | @iso body body' l step_body =>
    have ih := NStep.semi_completeness step_body
    exact NStep.refl_trans_iso ih
  | @record r r' step_r =>
    have ih := NRcdStep.semi_completeness step_r
    exact NStep.refl_trans_record ih
  | @app cator cator' arg arg' step_cator step_arg =>
    have ih0 := NStep.semi_completeness step_cator
    have ih1 := NStep.semi_completeness step_arg
    exact NStep.refl_trans_app ih0 ih1
  | @pattern_match arg p m body f matching =>
    apply ReflTrans.step
    { apply NStep.pattern_match
      exact matching
    }
    { exact ReflTrans.refl (Expr.sub m body) }
  | @skip arg p body f isval nomatching =>
    apply ReflTrans.step
    { apply NStep.skip _ _ isval nomatching }
    { exact ReflTrans.refl (Expr.app (Expr.function f) arg)}
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
    { exact ReflTrans.refl (Expr.sub [(x, Expr.loop (Expr.function [(Pat.var x, e)]))] e)}
end

mutual
  theorem ParRcdStep.completeness
    (step : NRcdStep r r')
  : ParRcdStep r r'
  := by cases step with
  | @head e e' l r step_e fresh =>
    have ih := ParStep.completeness step_e
    apply ParRcdStep.cons ih (ParRcdStep.refl r) fresh
  | @tail r r' l e step_r fresh =>
    have ih := ParRcdStep.completeness step_r
    apply ParRcdStep.cons (ParStep.refl e) ih fresh

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
  | @applicator cator cator' arg step_cator =>
    have ih := ParStep.completeness step_cator
    apply ParStep.app ih
    exact ParStep.refl arg
  | @applicand cator arg arg' step_arg =>
    have ih := ParStep.completeness step_arg
    apply ParStep.app (ParStep.refl arg') ih
  | @pattern_match arg p m body f matching =>
    exact ParStep.pattern_match body f matching
  | @skip arg p body f isval nomatching =>
    exact ParStep.skip body f isval nomatching
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
