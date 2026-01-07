import Lang.Basic
import Lang.Dynamic.NStep

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive NStepStar : Expr → Expr → Prop
| refl : NStepStar e e
| step : NStep e e' → NStepStar e' e'' → NStepStar e e''

inductive StarNStep : Expr → Expr → Prop
| refl : StarNStep e e
| step : StarNStep e e' → NStep e' e'' → StarNStep e e''

theorem StarNStep.transitive :
  StarNStep e e' → StarNStep e' e'' → StarNStep e e''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3


theorem NStepStar.transitive :
  NStepStar e e' → NStepStar e' e'' → NStepStar e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)

theorem NStepStar.reverse :
  NStepStar e e' → StarNStep e e'
:= by
  intro h0
  induction h0 with
  | refl =>
    exact StarNStep.refl
  | @step e em e' h1 h2 ih =>
    apply StarNStep.transitive
    { apply StarNStep.step StarNStep.refl h1 }
    { exact ih }


theorem NStepStar.iso :
  NStepStar body body' →
  NStepStar (Expr.iso label body) (Expr.iso label body')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply NStepStar.refl
  | step h1 h2 ih =>
    apply NStepStar.step (NStep.iso h1) ih

theorem NStepStar.iso_inversion :
  NStepStar (Expr.iso label body) e →
  ∃ body' , e = (Expr.iso label body') ∧  NStepStar body body'
:= by
  intro h0
  apply NStepStar.reverse at h0

  induction h0 with
  | refl =>
    exists body
    simp
    apply NStepStar.refl
  | @step em en h1 h2 ih =>
    have ⟨body',h3,h4⟩ := ih
    clear ih
    rw [h3] at h2

    cases h2 with
    | @iso body' body'' _ step =>
      exists body''
      simp
      apply NStepStar.transitive h4
      apply NStepStar.step step
      exact refl


inductive NRcdStepStar : List (String × Expr) → List (String × Expr) → Prop
| refl : NRcdStepStar r r
| step : NRcdStep r r' → NRcdStepStar r' r'' → NRcdStepStar r r''

inductive StarNRcdStep : List (String × Expr) → List (String × Expr) → Prop
| refl : StarNRcdStep r r
| step : StarNRcdStep r r' → NRcdStep r' r'' → StarNRcdStep r r''

-- inductive NStepStar : Expr → Expr → Prop

-- inductive StarNStep : Expr → Expr → Prop
-- | refl : StarNStep e e
-- | step : StarNStep e e' → NStep e' e'' → StarNStep e e''



theorem NStepStar.record :
  NRcdStepStar r r' →
  NStepStar (.record r) (.record r')
:= by sorry

theorem NStepStar.record_inversion :
  NStepStar (.record r) e →
  ∃ r' , e = .record r' ∧ NRcdStepStar r r'
:= by sorry

mutual
  theorem NRcdStepStar.universal_nexus :
    ∃ rn,  ∀ rm , NRcdStepStar r rm → NRcdStepStar rm rn
  := by sorry

  theorem NStepStar.universal_nexus :
    ∃ en,  ∀ em , NStepStar e em → NStepStar em en
  := by cases e with
  | var x =>
    exists (Expr.var x)
    intro em h0
    cases h0 with
    | refl => exact NStepStar.refl
    | step h1 h2 =>
      cases h1
  | iso label body =>
    have ⟨body',ih⟩ := @NStepStar.universal_nexus body
    exists (.iso label body')
    intro em h0
    have ⟨bodym,h1,h2⟩ := NStepStar.iso_inversion h0
    rw [h1]
    apply NStepStar.iso (ih bodym h2)

  | record r =>
    have ⟨r',ih⟩ := @NRcdStepStar.universal_nexus r
    exists (.record r')
    intro em h0
    have ⟨rm,h1,h2⟩ := NStepStar.record_inversion h0
    rw [h1]
    apply NStepStar.record (ih rm h2)

  | _ => sorry
  -- | function : List (Pat × Expr) → Expr
  -- | app : Expr → Expr → Expr
  -- | anno : Expr → Typ → Expr
  -- | loop : Expr → Expr
end



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
