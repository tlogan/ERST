import Lang.Basic
import Lang.Dynamic.NEvalCxt
import Lang.Dynamic.NStep
import Lang.Dynamic.NStepStar
import Lang.Dynamic.Safe

set_option pp.fieldNotation false

namespace Lang.Dynamic

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
    {
      have necxt := NEvalCxt.extract label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    {
      have necxt := NEvalCxt.project label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_reduction
    {
      have necxt := NEvalCxt.applicator e'' .hole
      apply NStep.necxt necxt transition
    }
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
    {
      have necxt := NEvalCxt.extract label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    {
      have necxt := NEvalCxt.project label .hole
      apply NStep.necxt necxt transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_expansion
    {
      have necxt := NEvalCxt.applicator e'' .hole
      apply NStep.necxt necxt transition
    }
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


end Lang.Dynamic
