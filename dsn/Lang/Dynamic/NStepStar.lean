import Lang.Basic
import Lang.Dynamic.NStep

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive NStepStar : Expr → Expr → Prop
| refl : NStepStar e e
| step : NStep e e' → NStepStar e' e'' → NStepStar e e''


theorem NStepStar.transitive :
  NStepStar e e' → NStepStar e' e'' → NStepStar e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)


theorem NStepStar.iso :
  NStepStar body body' →
  NStepStar (Expr.iso label body) (Expr.iso label body')
:= by sorry


theorem NStepStar.iso_choice :
  NStepStar (Expr.iso label body) e →
  ∃ body_choice , e = (Expr.iso label body_choice) ∧  NStepStar body body_choice
:= by sorry


theorem NStepStar.universal_nexus :
  ∃ en,  ∀ em , NStepStar e em → NStepStar em en
:= by cases e with
| var x =>
  exists (Expr.var x)
  intro em h0
  cases h0 with
  | refl => exact refl
  | step h1 h2 =>
    cases h1
| iso label body =>
  have ⟨body',ih⟩ := @NStepStar.universal_nexus body
  exists (.iso label body')
  intro em h0
  have ⟨bodym,h1,h2⟩ := NStepStar.iso_choice h0
  rw [h1]
  specialize ih bodym h2
  apply NStepStar.iso ih

| _ => sorry
-- | record : List (String × Expr) → Expr
-- | function : List (Pat × Expr) → Expr
-- | app : Expr → Expr → Expr
-- | anno : Expr → Typ → Expr
-- | loop : Expr → Expr



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
