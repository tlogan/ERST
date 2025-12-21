import Lang.Basic
import Lang.Dynamic.Transition
import Lang.Dynamic.EvalCon
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


theorem Convergent.evalcon_reflection :
  EvalCon E →
  Convergent (E e) →
  Convergent e
:= by
  sorry


end Lang.Dynamic
