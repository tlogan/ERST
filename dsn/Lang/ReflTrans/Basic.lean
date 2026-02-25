import Lean

set_option pp.fieldNotation false

namespace Lang

inductive ReflTrans (R : α → α → Prop) : α → α → Prop
| refl e : ReflTrans R e e
| step : R e e' → ReflTrans R e' e'' → ReflTrans R e e''


inductive ReflTransLeft (R : α → α → Prop) : α → α → Prop
| refl e : ReflTransLeft R e e
| step : ReflTransLeft R e e' → R e' e'' → ReflTransLeft R e e''

theorem ReflTransLeft.transitivity :
  ReflTransLeft R e e' → ReflTransLeft R e' e'' → ReflTransLeft R e e''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3


theorem ReflTrans.transitivity :
  ReflTrans R e e' → ReflTrans R e' e'' → ReflTrans R e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)

theorem ReflTrans.reverse :
  ReflTrans R e e' → ReflTransLeft R e e'
:= by
  intro h0
  induction h0 with
  | refl e =>
    exact ReflTransLeft.refl e
  | @step e em e' h1 h2 ih =>
    apply ReflTransLeft.transitivity
    {
      apply ReflTransLeft.step
      { exact ReflTransLeft.refl e }
      { exact h1 }
    }
    { exact ih }

end Lang
