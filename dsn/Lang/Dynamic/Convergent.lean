import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar

set_option pp.fieldNotation false


namespace Lang.Dynamic

def Convergent (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ Expr.is_value e'

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
  theorem Convergent.function_beta_reduction
    (econ : EvalCon E)
    (isval : Expr.is_value ev)
    (matching : Expr.pattern_match ev p = .some eam)
  : Convergent (E (Expr.app (Expr.function ((p, e) :: f)) ev)) →
    Convergent (E (Expr.sub eam e))
  := by sorry

  theorem Convergent.function_beta_expansion f
    (econ : EvalCon E)
    (isval : Expr.is_value ev)
    (matching : Expr.pattern_match ev p = .some eam)
  : Convergent (E (Expr.sub eam e)) →
    Convergent (E (Expr.app (Expr.function ((p, e) :: f)) ev))
  := by sorry
end


end Lang.Dynamic
