import Lean

import Lang.List.Basic
import Lang.String.Basic
import Lang.ReflTrans.Basic
import Lang.Joinable.Basic
import Lang.Typ.Basic
import Lang.Expr.Basic
import Lang.NStep.Basic

set_option pp.fieldNotation false


namespace Lang


def Safe (e : Expr) : Prop :=
  (∀ e', ReflTrans NStep e e' → Expr.valued e' ∨ (∃ e'' , NStep e' e''))


theorem Safe.progress :
  Safe e → Expr.valued e ∨ ∃ e', NStep e e'
:= by
  unfold Safe
  intro h0
  apply h0
  exact ReflTrans.refl e

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

theorem Safe.record_nil_intro :
  Safe (.record [])
:= by sorry

theorem Safe.record_cons_intro :
  Safe (.record r) →
  Safe e →
  Safe (.record ((l,e) :: r))
:= by sorry

theorem Safe.record_keys_uniqueness :
  Safe (.record r) →
  Prod.keys_unique r
:= by sorry


theorem Safe.function f :
  Safe (.function f)
:= by
  unfold Safe
  intro e' h0
  apply Or.inl
  have ⟨f',h1⟩ := NStep.refl_trans_function_inversion f h0
  rw [h1]
  simp [Expr.valued]






end Lang
