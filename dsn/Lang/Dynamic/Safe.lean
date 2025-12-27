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
  theorem Convergent.cvg_function_beta_reduction
    (econ : EvalCon E)
    (cvg : Convergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
    Convergent (E (Expr.sub eam e))
  := by sorry

  theorem Convergent.cvg_function_beta_expansion f
    (econ : EvalCon E)
    (cvg : Convergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Convergent (E (Expr.sub eam e)) →
    Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
  := by sorry
end

mutual
  theorem Convergent.dvg_function_beta_reduction
    (econ : EvalCon E)
    (dvg : Divergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
    Convergent (E (Expr.sub eam e))
  := by sorry

  theorem Convergent.dvg_function_beta_expansion f
    (econ : EvalCon E)
    (dvg : Divergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Convergent (E (Expr.sub eam e)) →
    Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
  := by sorry
end


mutual
  theorem Divergent.cvg_function_beta_reduction
    (econ : EvalCon E)
    (cvg : Convergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
    Divergent (E (Expr.sub eam e))
  := by sorry

  theorem Divergent.cvg_function_beta_expansion f
    (econ : EvalCon E)
    (cvg : Convergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Divergent (E (Expr.sub eam e)) →
    Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
  := by sorry
end

mutual
  theorem Divergent.dvg_function_beta_reduction
    (econ : EvalCon E)
    (dvg : Divergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
    Divergent (E (Expr.sub eam e))
  := by sorry

  theorem Divergent.dvg_function_beta_expansion f
    (econ : EvalCon E)
    (dvg : Divergent arg)
    (matching : Expr.pattern_match arg p = .some eam)
  : Divergent (E (Expr.sub eam e)) →
    Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
  := by sorry
end


theorem Convergent.function_beta_reduction
  (econ : EvalCon E)
  (safe : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Convergent (E (Expr.sub eam e))
:= by
  cases safe with
  | inl cvg =>
    intro h0
    exact cvg_function_beta_reduction econ cvg matching h0
  | inr dvg =>
    intro h0
    exact Convergent.dvg_function_beta_reduction econ dvg matching h0

theorem Convergent.function_beta_expansion f
  (econ : EvalCon E)
  (safe : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Convergent (E (Expr.sub eam e)) →
  Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  cases safe with
  | inl cvg =>
    intro h0
    exact Convergent.cvg_function_beta_expansion f econ cvg matching h0
  | inr dvg =>
    intro h0
    exact Convergent.dvg_function_beta_expansion f econ dvg matching h0


theorem Divergent.function_beta_reduction
  (econ : EvalCon E)
  (safe : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Divergent (E (Expr.sub eam e))
:= by
  cases safe with
  | inl cvg =>
    intro h0
    exact Divergent.cvg_function_beta_reduction econ cvg matching h0
  | inr dvg =>
    intro h0
    exact Divergent.dvg_function_beta_reduction econ dvg matching h0

theorem Divergent.function_beta_expansion f
  (econ : EvalCon E)
  (safe : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Divergent (E (Expr.sub eam e)) →
  Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  cases safe with
  | inl cvg =>
    intro h0
    exact Divergent.cvg_function_beta_expansion f econ cvg matching h0
  | inr dvg =>
    intro h0
    exact Divergent.dvg_function_beta_expansion f econ dvg matching h0



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
  (safe_arg : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Safe (E (Expr.sub eam e))
:= by
  unfold Safe
  intro cod
  cases cod with
  | inl h0 =>
    apply Or.inl
    apply Convergent.function_beta_reduction econ safe_arg matching h0
  | inr h0 =>
    apply Or.inr
    exact Divergent.function_beta_reduction econ safe_arg matching h0

theorem Safe.function_beta_expansion f
  (econ : EvalCon E)
  (safe_arg : Safe arg)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.sub eam e)) →
  Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  unfold Safe
  intro cod
  cases cod with
  | inl h0 =>
    apply Or.inl
    exact Convergent.function_beta_expansion f econ safe_arg matching h0
  | inr h0 =>
    apply Or.inr
    exact Divergent.function_beta_expansion f econ safe_arg matching h0









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
