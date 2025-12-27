
import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar

set_option pp.fieldNotation false


namespace Lang.Dynamic


def Divergent (e : Expr) : Prop :=
  (∀ e', TransitionStar e e' → ∃ e'' , Transition e' e'')


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

mutual
  theorem Divergent.function_beta_reduction
    (econ : EvalCon E)
    (isval : Expr.is_value ev)
    (matching : Expr.pattern_match ev p = .some eam)
  : Divergent (E (Expr.app (Expr.function ((p, e) :: f)) ev)) →
    Divergent (E (Expr.sub eam e))
  := by sorry

  theorem Divergent.function_beta_expansion f
    (econ : EvalCon E)
    (isval : Expr.is_value ev)
    (matching : Expr.pattern_match ev p = .some eam)
  : Divergent (E (Expr.sub eam e)) →
    Divergent (E (Expr.app (Expr.function ((p, e) :: f)) ev))
  := by sorry
end


end Lang.Dynamic
