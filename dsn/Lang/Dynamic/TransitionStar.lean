import Lang.Basic
import Lang.Dynamic.Transition
import Lang.Dynamic.EvalCon

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive TransitionStar : Expr → Expr → Prop
| refl e : TransitionStar e e
| step e e' e'' : Transition e e' → TransitionStar e' e'' → TransitionStar e e''



theorem TransitionStar.evalcon_preservation
  (evalcon : EvalCon E)
  (transition_star : TransitionStar e e')
: TransitionStar (E e) (E e')
:= by induction transition_star with
| refl e =>
  exact refl (E e)
| step e e' e'' h0 h1 ih =>
  apply TransitionStar.step
  { exact Transition.evalcon evalcon h0 }
  { exact ih }


end Lang.Dynamic
