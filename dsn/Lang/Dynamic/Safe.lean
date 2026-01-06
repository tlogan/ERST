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
  apply NStepStar.transitive step_star h1

theorem Safe.nexus_expansion
  (nexus : ∀ (em : Expr), NStepStar e em → NStepStar em en)
: Safe en → Safe e
:= by
  unfold Safe
  intro h0 e' h1
  have h2 := nexus e' h1
  cases h2 with
  | refl =>
    apply h0
    exact nexus en h1
  | @step e' em en h3 h4 =>
    apply Or.inr
    exists em

theorem Safe.subject_star_expansion
  (step_star : NStepStar e e')
: Safe e' → Safe e
:= by
  have ⟨en,h0⟩ := @NStepStar.universal_nexus e
  intro h1
  have h2 : NStepStar e' en := by
    apply h0 _ step_star
  apply Safe.subject_star_reduction h2 at h1
  clear step_star
  clear h2
  exact nexus_expansion h0 h1


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
  apply NStepStar.step step NStepStar.refl

end Lang.Dynamic
