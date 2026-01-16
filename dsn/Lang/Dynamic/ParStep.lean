import Lang.Util
import Lang.Basic
import Lang.Dynamic.NStep

set_option pp.fieldNotation false

namespace Lang.Dynamic

mutual

  inductive ParRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | cons :
    List.is_fresh_key l r → ParStep e e' →  ParRcdStep r r' →
    ParRcdStep ((l, e) :: r) ((l, e') :: r')

  inductive ParStep : Expr → Expr → Prop
  | refl e : ParStep e e
  /- head normal forms -/
  | iso : ParStep body body' → ParStep (.iso l body) (.iso l body')
  | record : ParRcdStep r r' →  ParStep (.record r) (.record r')

  /- redex forms -/
  | app arg :
    ParStep cator cator' → ParStep arg arg' →
    ParStep (.app cator arg) (.app cator' arg)
  | pattern_match body f :
    Expr.pattern_match arg p = some m →
    ParStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m body)
  | skip body f:
    arg.is_value →
    Expr.pattern_match arg p = none →
    ParStep (.app (.function ((p,body) :: f)) arg) (.app (.function f) arg)
  | erase body t :
    ParStep (.anno body t) body
  | loopi : ParStep body body' → ParStep (.loop body) (.loop body')
  | recycle x e :
    ParStep
      (.loop (.function [(.var x, e)]))
      (Expr.sub [(x, (.loop (.function [(.var x, e)])))] e)
end


def Joinable (R : α → α → Prop) (ea eb : α) :=
  ∃ en , R ea en ∧ R eb en

mutual

  theorem ParStep.diamond
    (step_a : ParStep e ea)
    (step_b : ParStep e eb)
  : Joinable ParStep ea eb
  := by cases step_a with
  | refl =>
    exists eb
    apply And.intro step_b
    exact ParStep.refl eb
  | _ => sorry

end


theorem ReflTrans.n_step_iso :
  ReflTrans NStep body body' →
  ReflTrans NStep (Expr.iso label body) (Expr.iso label body')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply ReflTrans.refl
  | step h1 h2 ih =>
    apply ReflTrans.step (NStep.iso h1) ih

theorem ReflTrans.n_rcd_step_record :
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

theorem ReflTrans.n_rcd_step_head :
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
    { apply NRcdStep.head h0 h1 }
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

theorem ReflTrans.n_rcd_step_cons :
  List.is_fresh_key l r →
  ReflTrans NStep e e' →
  ReflTrans NRcdStep r r' →
  ReflTrans NRcdStep ((l,e)::r) ((l,e')::r')
:= by
  intro h0 h1 h2
  induction h2 with
  | @refl r =>
    exact n_rcd_step_head h0 h1
  | @step r rm r' h2 h3 ih =>
    apply ReflTrans.step
    { apply NRcdStep.tail
      { exact h0 }
      { exact h2 }
    }
    {
      apply ih
      exact List.is_fresh_key_n_rcd_step_reduction h2 h0
    }


mutual
  theorem ParRcdStep.soundness
    (step : ParRcdStep r r')
  : ReflTrans NRcdStep r r'
  := by cases step with
  | @cons l rr e e' rr' fresh step_e step_rr =>
    have ih0 := ParStep.soundness step_e
    have ih1 := ParRcdStep.soundness step_rr
    exact ReflTrans.n_rcd_step_cons fresh ih0 ih1

  theorem ParStep.soundness
    (step : ParStep e e')
  : ReflTrans NStep e e'
  := by cases step  with
  | @iso body body' l step_body =>
    have ih := ParStep.soundness step_body
    exact ReflTrans.n_step_iso ih
  | @record r r' step_r =>
    have ih := ParRcdStep.soundness step_r
    exact ReflTrans.n_rcd_step_record ih
  | _ => sorry
end

mutual
  theorem ParStep.completeness
    (n_step : NStep e e')
  : ParStep e e'
  := by sorry
end


theorem ReflTrans.par_step_soundness
  (par_step : ReflTrans ParStep e e')
: ReflTrans NStep e e'
:= by induction par_step with
| refl e =>
  exact ReflTrans.refl e
| @step e em e' h0 h1 ih =>
  apply ReflTrans.transitivity
  { exact ParStep.soundness h0 }
  { exact ih }


theorem ReflTrans.par_step_completeness
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

theorem Joinable.right_par_step_expansion :
  ParStep e e' →
  Joinable (ReflTrans ParStep) ea e' →
  Joinable (ReflTrans ParStep) ea e
:= by
  unfold Joinable
  intro h0 h1
  have ⟨en,h2,h3⟩ := h1
  clear h1
  exists en
  apply And.intro
  { exact h2 }
  { exact ReflTrans.step h0 h3 }

theorem ReflTrans.par_step_semi_confluence
  (step : ReflTrans ParStep e ea)
: ∀ {eb} , ParStep e eb → Joinable (ReflTrans ParStep) ea eb
:= by induction step with
| refl e =>
  intro eb h0
  unfold Joinable
  exists eb
  apply And.intro
  { apply ReflTrans.step
    { exact h0 }
    { exact ReflTrans.refl eb }
  }
  { exact ReflTrans.refl eb }
| @step e em ea h0 h1 ih =>
  intro eb h2
  have h3 := ParStep.diamond h0 h2
  unfold Joinable at h3
  have ⟨en,h4,h5⟩ := h3
  clear h3
  specialize ih h4
  exact Joinable.right_par_step_expansion h5 ih

theorem ReflTrans.par_step_confluence
  (step_a : ReflTrans ParStep e ea)
  (step_b : ReflTrans ParStep e eb)
: Joinable (ReflTrans ParStep) ea eb
:= by
  have h0 := ReflTrans.reverse step_a
  clear step_a
  induction h0 with
  | refl =>
    unfold Joinable
    exists eb
    apply And.intro
    { apply step_b }
    { exact ReflTrans.refl eb }
  | @step m a h2 h3 ih =>
    have ⟨b',h4,h5⟩ := ih
    clear ih
    have ⟨n,h6,h7⟩ := ReflTrans.par_step_semi_confluence h4 h3
    exists n
    apply And.intro
    { exact h7 }
    { exact ReflTrans.transitivity h5 h6 }

theorem Joinable.par_step_soundness :
  Joinable (ReflTrans ParStep) ea eb →
  Joinable (ReflTrans NStep) ea eb
:= by
  unfold Joinable
  intro h0
  have ⟨en,h1,h2⟩ := h0 ; clear h0
  exists en
  apply And.intro
  { exact ReflTrans.par_step_soundness h1 }
  { exact ReflTrans.par_step_soundness h2 }


theorem ReflTrans.n_step_confluence
  (step_a : ReflTrans NStep e ea)
  (step_b : ReflTrans NStep e eb)
: Joinable (ReflTrans NStep) ea eb
:= by
  apply Joinable.par_step_soundness
  apply ReflTrans.par_step_confluence
  { exact ReflTrans.par_step_completeness step_a }
  { exact ReflTrans.par_step_completeness step_b }



end Lang.Dynamic
