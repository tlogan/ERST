import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent
import Lang.Dynamic.Sound

set_option pp.fieldNotation false

namespace Lang.Dynamic

def FinTyping (e : Expr) : Typ → Prop
| .top => Sound e
| .iso l body => FinTyping (.extract e l) body
| .entry l body => FinTyping (.project e l) body
| .path left right => ∀ e' , FinTyping e' left → FinTyping (.app e e') right
| .unio left right => FinTyping e left ∨ FinTyping e right
| .inter left right => FinTyping e left ∧ FinTyping e right
| .diff left right => FinTyping e left ∧ ¬ (FinTyping e right)
| _ => False


def Subtyping.Fin (left right : Typ) : Prop :=
  ∀ e, FinTyping e left → FinTyping e right


mutual
  theorem FinTyping.subject_reduction
    (transition : Transition e e')
  : FinTyping e t → FinTyping e' t
  := by cases t with
  | bot =>
    unfold FinTyping
    simp
  | top =>
    unfold FinTyping
    intro h0
    exact Sound.subject_reduction transition h0

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    {
      have evalcon := EvalCon.extract label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    {
      have evalcon := EvalCon.project label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_reduction
    {
      have evalcon := EvalCon.applicator e'' .hole
      apply Transition.evalcon evalcon transition
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
    (transition : Transition e e')
  : FinTyping e' t → FinTyping e t
  := by cases t with
  | bot =>
    unfold FinTyping
    simp
  | top =>
    unfold FinTyping
    intro h0
    exact Sound.subject_expansion transition h0

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    {
      have evalcon := EvalCon.extract label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    {
      have evalcon := EvalCon.project label .hole
      apply Transition.evalcon evalcon transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_expansion
    {
      have evalcon := EvalCon.applicator e'' .hole
      apply Transition.evalcon evalcon transition
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


--   | exi ids quals body =>
--     unfold Typing
--     intro ⟨am',h0,h1,h2⟩
--     exists am'
--     apply And.intro h0
--     apply And.intro h1
--     apply Typing.subject_expansion transition h2

--   | all ids quals body =>
--     unfold Typing
--     intro ⟨h0,h1⟩
--     apply And.intro
--     {
--       intro am' h2 h3
--       apply Typing.subject_expansion transition (h0 am' h2 h3)
--     }
--     { exact h1 }

--   | lfp id body =>
--     unfold Typing
--     intro ⟨monotonic_body,t, lt_size, imp_dynamic, dynamic_body⟩
--     apply And.intro monotonic_body
--     exists t
--     exists lt_size
--     apply And.intro imp_dynamic
--     apply Typing.subject_expansion transition dynamic_body

--   | var id =>
--     unfold Typing
--     intro ⟨t, h1, h2⟩
--     exists t
--     apply And.intro h1
--     apply FinTyping.subject_expansion transition h2
-- end


theorem FinTyping.path_determines_function
  (typing : FinTyping e (.path antec consq))
: ∃ f , TransitionStar e (.function f)
:= by sorry

theorem FinTyping.soundness
  (typing : FinTyping e t)
: Sound e
:= by cases t with
| bot =>
  unfold FinTyping at typing
  exact False.elim typing

| top =>
  unfold FinTyping at typing
  exact typing

| iso label body =>
  unfold FinTyping at typing
  have ih := FinTyping.soundness typing
  apply Sound.evalcon_reflection
  { apply EvalCon.extract label .hole }
  { exact ih }

| entry label body =>
  unfold FinTyping at typing
  have ih := FinTyping.soundness typing
  apply Sound.evalcon_reflection
  { apply EvalCon.project label .hole }
  { exact ih }


| path left right =>
  apply FinTyping.path_determines_function at typing
  have ⟨f, h0⟩ := typing
  apply Sound.convergent
  unfold Convergent
  exists (.function f)


| unio left right =>
  unfold FinTyping at typing
  cases typing with
  | inl h =>
    apply FinTyping.soundness h
  | inr h =>
    apply FinTyping.soundness h

| inter left right =>
  unfold FinTyping at typing
  have ⟨h0,h1⟩ := typing
  apply FinTyping.soundness h0

| diff left right =>
  unfold FinTyping at typing
  have ⟨h0,h1⟩ := typing
  apply FinTyping.soundness h0
| _ =>
  unfold FinTyping at typing
  exact False.elim typing







end Lang.Dynamic
