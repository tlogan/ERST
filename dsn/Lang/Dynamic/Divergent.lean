
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


theorem Divergent.swap_preservation
  (econ : EvalCon E)
  (isval : Expr.is_value e)
  (dvg_econ : Divergent (E e))
: Divergent (E e')
:= by sorry


end Lang.Dynamic
