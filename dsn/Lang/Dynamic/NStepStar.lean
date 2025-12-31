import Lang.Basic
import Lang.Dynamic.NEvalCxt
import Lang.Dynamic.NStep

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive NStepStar : Expr → Expr → Prop
| refl e : NStepStar e e
| step e e' e'' : NStep e e' → NStepStar e' e'' → NStepStar e e''



theorem NStepStar.necxt_preservation
  (necxt : NEvalCxt E)
  (transition_star : NStepStar e e')
: NStepStar (E e) (E e')
:= by induction transition_star with
| refl e =>
  exact refl (E e)
| step e e' e'' h0 h1 ih =>
  apply NStepStar.step
  { exact NStep.necxt necxt h0 }
  { exact ih }



def Confluent (a b : Expr) :=
  ∃ e , NStepStar a e ∧ NStepStar b e

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
