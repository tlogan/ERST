import Lang.Basic
import Lang.Dynamic.NEvalCxt
import Lang.Dynamic.NStep

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive NStepStar : Expr → Expr → Prop
| refl : NStepStar e e
| step : NStep e e' → NStepStar e' e'' → NStepStar e e''



theorem NStepStar.necxt_preservation
  (necxt : NEvalCxt E)
  (transition_star : NStepStar e e')
: NStepStar (E e) (E e')
:= by induction transition_star with
| @refl e =>
  exact refl
| @step e e' e'' h0 h1 ih =>
  apply NStepStar.step
  { exact NStep.necxt necxt h0 }
  { exact ih }


inductive StarNStep : Expr → Expr → Prop
| refl : StarNStep e e
| step : StarNStep e e' → NStep e' e'' → StarNStep e e''

theorem NStepStar.reverse :
  NStepStar e e' → StarNStep e e'
:= by sorry

theorem StarNStep.reverse :
  StarNStep e e' → NStepStar e e'
:= by sorry



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
