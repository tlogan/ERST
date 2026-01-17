import Lang.Util
import Lang.Basic
import Lang.NStep

set_option pp.fieldNotation false


namespace Lang


def Safe (e : Expr) : Prop :=
  (∀ e', ReflTrans NStep e e' → Expr.is_value e' ∨ (∃ e'' , NStep e' e''))

theorem Safe.subject_star_reduction
  (step_star : ReflTrans NStep e e')
: Safe e → Safe e'
:= by
  unfold Safe
  intro h0 em h1
  apply h0
  apply ReflTrans.transitivity step_star h1

theorem Safe.subject_star_expansion
  (step_star : ReflTrans NStep e e')
: Safe e' → Safe e
:= by
  intro h0 em h1
  have ⟨en,h2,h3⟩ := NStep.confluence step_star h1
  cases h3 with
  | refl =>
    apply h0
    exact h2
  | @step em em' e' h4 h5 =>
    apply Or.inr
    exists em'

theorem Safe.subject_reduction
  (step : NStep e e')
: Safe e → Safe e'
:= by
  apply Safe.subject_star_reduction
  apply ReflTrans.step
  exact step
  exact ReflTrans.refl e'

theorem Safe.subject_expansion
  (step : NStep e e')
: Safe e' → Safe e
:= by
  apply Safe.subject_star_expansion
  apply ReflTrans.step
  exact step
  exact ReflTrans.refl e'

end Lang
