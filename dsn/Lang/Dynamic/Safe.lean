import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar

set_option pp.fieldNotation false


namespace Lang.Dynamic


def Convergent (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ Expr.is_value e'

def Divergent (e : Expr) : Prop :=
  (∀ e', TransitionStar e e' → ∃ e'' , Transition e' e'')

def Safe (e : Expr) : Prop := Convergent e ∨ Divergent e

mutual

  theorem Convergent.subject_reduction
    (transition : Transition e e')
  : Convergent e → Convergent e'
  := by sorry

  theorem Convergent.subject_expansion
    (transition : Transition e e')
  : Convergent e' → Convergent e
  := by sorry

end


theorem Convergent.econ_reflection :
  EvalCon E →
  Convergent (E e) →
  Convergent e
:= by
  sorry

theorem Convergent.econ_preservation :
  EvalCon E → Convergent (E e) →
  Convergent e' → Convergent (E e')
:= by sorry



mutual
  theorem Convergent.record_beta_reduction :
    EvalCon E →
    Convergent (E (Expr.project (Expr.record [(l, e)]) l)) →
    Convergent (E e)
  := by sorry

  theorem Convergent.record_beta_expansion l :
    EvalCon E →
    Convergent (E e) →
    Convergent (E (Expr.project (Expr.record [(l, e)]) l))
  := by sorry
end


mutual

  theorem Divergent.subject_reduction
    (transition : Transition e e')
  : Divergent e → Divergent e'
  := by sorry

  theorem Divergent.subject_expansion
    (transition : Transition e e')
  : Divergent e' → Divergent e
  := by sorry

end

theorem Divergent.econ_preservation :
  EvalCon E →
  Divergent e →
  Divergent (E e)
:= by
  sorry

theorem Divergent.econ_reflection :
  EvalCon E →
  Divergent (E e) →
  Divergent e
:= by
  sorry


-- theorem Divergent.swap_preservation
--   (econ : EvalCon E)
--   (isval : Expr.is_value e)
--   (dvg_econ : Divergent (E e))
-- : Divergent (E e')
-- := by sorry

mutual
  theorem Divergent.record_beta_reduction :
    EvalCon E →
    Divergent (E (Expr.project (Expr.record [(l, e)]) l)) →
    Divergent (E e)
  := by sorry

  theorem Divergent.record_beta_expansion l :
    EvalCon E →
    Divergent (E e) →
    Divergent (E (Expr.project (Expr.record [(l, e)]) l))
  := by sorry
end


theorem Safe.function_beta_reduction
  (econ : EvalCon E)
  -- (safe_arg : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Safe (E (Expr.sub eam e))
:= by
  intro safe_sub
  cases safe_sub with
  |inl cvg_sub =>
    apply Or.inl
    sorry
  |inr dvg_sub =>
    apply Or.inr
    sorry


theorem Safe.function_beta_expansion
  f
  (safe_arg : Safe arg)
  (econ : EvalCon E)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.sub eam e)) →
  Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  cases safe_arg with
  | inl cvg_arg =>
    intro safe_sub
    cases safe_sub with
    |inl cvg_sub =>
      apply Or.inl
      sorry
    |inr dvg_sub =>
      apply Or.inr
      sorry
  | inr dvg_arg =>
    intro safe_sub
    apply Or.inr
    sorry









theorem Safe.subject_reduction
  (transition : Transition e e')
: Safe e → Safe e'
:= by sorry

theorem Safe.subject_expansion
  (transition : Transition e e')
: Safe e' → Safe e
:= by sorry


theorem Safe.econ_reflection :
  EvalCon E →
  Safe (E e) →
  Safe e
:= by
  sorry

theorem Safe.econ_preservation :
  EvalCon E → Safe (E e) →
  Safe e' → Safe (E e')
:= by sorry


theorem Safe.record_beta_reduction :
  EvalCon E →
  Safe (E (Expr.project (Expr.record [(l, e)]) l)) →
  Safe (E e)
:= by sorry

theorem Safe.record_beta_expansion l :
  EvalCon E →
  Safe (E e) →
  Safe (E (Expr.project (Expr.record [(l, e)]) l))
:= by sorry

end Lang.Dynamic
