import Lang.Util
import Lang.Basic
import Lang.NStep
import Lang.Safe

set_option pp.fieldNotation false

namespace Lang

def FinTyping (e : Expr) : Typ → Prop
| .top => Safe e
| .iso l body => FinTyping (.extract e l) body
| .entry l body => FinTyping (.project e l) body
| .path left right => ∀ arg ,
  FinTyping arg left → FinTyping (.app e arg) right
| .unio left right => FinTyping e left ∨ FinTyping e right
| .inter left right => FinTyping e left ∧ FinTyping e right
| .diff left right => FinTyping e left ∧ ¬ (FinTyping e right)
| _ => False


def Subtyping.Fin (left right : Typ) : Prop :=
  ∀ e, FinTyping e left → FinTyping e right


mutual
  theorem FinTyping.subject_reduction
    (transition : NStep e e')
  : FinTyping e t → FinTyping e' t
  := by cases t with
  | bot =>
    unfold FinTyping
    simp
  | top =>
    unfold FinTyping
    intro h0
    exact Safe.subject_reduction transition h0

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    { apply NStep.applicand _ transition }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    { apply NStep.applicand _ transition }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_reduction
    { apply NStep.applicator _ transition }
    { exact h0 }

  | unio left right =>
    unfold FinTyping
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply FinTyping.subject_reduction transition h2
    | inr h2 =>
      apply Or.inr
      apply FinTyping.subject_reduction transition h2

  | inter left right =>
    unfold FinTyping
    intro ⟨h0,h1⟩
    apply And.intro
    { apply FinTyping.subject_reduction transition h0 }
    { apply FinTyping.subject_reduction transition h1 }

  | diff left right =>
    unfold FinTyping
    intro ⟨h0,h1⟩
    apply And.intro
    { apply FinTyping.subject_reduction transition h0 }
    {
      intro h2
      apply h1
      apply FinTyping.subject_expansion transition h2
    }
  | _ =>
    unfold FinTyping
    simp

  theorem FinTyping.subject_expansion
    (transition : NStep e e')
  : FinTyping e' t → FinTyping e t
  := by cases t with
  | bot =>
    unfold FinTyping
    simp
  | top =>
    unfold FinTyping
    intro h0
    exact Safe.subject_expansion transition h0

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    { apply NStep.applicand _ transition }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    { apply NStep.applicand _ transition }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_expansion
    { apply NStep.applicator _ transition }
    { exact h0 }

  | unio left right =>
    unfold FinTyping
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply FinTyping.subject_expansion transition h2
    | inr h2 =>
      apply Or.inr
      apply FinTyping.subject_expansion transition h2

  | inter left right =>
    unfold FinTyping
    intro ⟨h0,h1⟩
    apply And.intro
    { apply FinTyping.subject_expansion transition h0 }
    { apply FinTyping.subject_expansion transition h1 }

  | diff left right =>
    unfold FinTyping
    intro ⟨h0,h1⟩
    apply And.intro
    { apply FinTyping.subject_expansion transition h0 }
    {
      intro h2
      apply h1
      apply FinTyping.subject_reduction transition h2
    }
  | _ =>
    unfold FinTyping
    simp
end

/- NOTE: need to prove the expression is safe so that inductive hypothesis is strong enough -/
theorem FinTyping.safety :
  FinTyping e t → Safe e
:= by cases t with
| var t =>
  simp [FinTyping]
| iso l t =>
  simp [FinTyping]
  intro h0
  have ih := FinTyping.safety h0
  sorry

-- | entry l t =>
-- | path t0 t1 =>
-- | bot =>
-- | top =>
-- | unio t0 t1 =>
-- | inter t0 t1 =>
-- | diff t0 t1 =>
| _ => sorry

theorem FinTyping.progress :
  FinTyping e t → Expr.is_value e ∨ ∃ e', NStep e e'
:= by
  intro h0
  apply Safe.progress
  apply FinTyping.safety h0


end Lang
