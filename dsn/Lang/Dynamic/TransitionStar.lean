import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive TransitionStar : Expr → Expr → Prop
| refl e : TransitionStar e e
| step e e' e'' : Transition e e' → TransitionStar e' e'' → TransitionStar e e''



theorem TransitionStar.econ_preservation
  (econ : EvalCon E)
  (transition_star : TransitionStar e e')
: TransitionStar (E e) (E e')
:= by induction transition_star with
| refl e =>
  exact refl (E e)
| step e e' e'' h0 h1 ih =>
  apply TransitionStar.step
  { exact Transition.econ econ h0 }
  { exact ih }


end Lang.Dynamic
