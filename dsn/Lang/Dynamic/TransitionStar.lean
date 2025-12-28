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



def Confluent (a b : Expr) :=
  ∃ e , TransitionStar a e ∧ TransitionStar b e

theorem Confluent.transitivity {a b c} :
  Confluent a b →
  Confluent b c →
  Confluent a c
:= by sorry

theorem Confluent.swap {a b} :
  Confluent a b →
  Confluent b a
:= by sorry

theorem Confluent.app_arg_preservation {a b} f :
  Confluent a b →
  Confluent (.app f a) (.app f b)
:= by sorry


end Lang.Dynamic
