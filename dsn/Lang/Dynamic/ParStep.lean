import Lang.Util
import Lang.Basic
import Lang.Dynamic.NStep

set_option pp.fieldNotation false

namespace Lang.Dynamic

mutual

  inductive ParRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | cons :
    List.is_fresh_key l r → ParStep e e' →  NRcdStep r r' →
    ParRcdStep ((l, e) :: r) ((l, e') :: r)

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


theorem ReflTrans.par_step_soundness :
  ReflTrans ParStep e e' → ReflTrans NStep e e'
:= by sorry


theorem ReflTrans.par_step_completeness :
  ReflTrans NStep e e' → ReflTrans ParStep e e'
:= by sorry

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
