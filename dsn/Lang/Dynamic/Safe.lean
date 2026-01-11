import Lang.Basic
import Lang.Dynamic.NStep
import Lang.Dynamic.NStepStar

set_option pp.fieldNotation false


namespace Lang.Dynamic


def Safe (e : Expr) : Prop :=
  (∀ e', NStepStar e e' → Expr.is_value e' ∨ (∃ e'' , NStep e' e''))

theorem Safe.subject_star_reduction
  (step_star : NStepStar e e')
: Safe e → Safe e'
:= by
  unfold Safe
  intro h0 em h1
  apply h0
  apply NStepStar.transitivity step_star h1

theorem Safe.subject_star_expansion
  (step_star : NStepStar e e')
: Safe e' → Safe e
:= by
  intro h0 em h1
  have ⟨en,h2,h3⟩ := NStepStar.confluence step_star h1
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
  apply NStepStar.step
  exact step
  exact NStepStar.refl

theorem Safe.subject_expansion
  (step : NStep e e')
: Safe e' → Safe e
:= by
  apply Safe.subject_star_expansion
  apply NStepStar.step
  exact step
  exact NStepStar.refl




  -- cases h1 with
  -- | refl =>
  --   apply Or.inr


  --   sorry
  -- | step =>
  --   sorry

end Lang.Dynamic
