import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent

set_option pp.fieldNotation false

namespace Lang.Dynamic

def FinTyping (e : Expr) : Typ → Prop
| .top => Convergent e ∨ Divergent e
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
  := by sorry

  theorem FinTyping.subject_expansion
    (transition : Transition e e')
  : FinTyping e' t → FinTyping e t
  := by sorry
end


theorem FinTyping.path_determines_function
  (typing : FinTyping e (.path antec consq))
: ∃ f , TransitionStar e (.function f)
:= by sorry

theorem FinTyping.convergent_or_divergent
  (typing : FinTyping e t)
: Convergent e ∨ Divergent e
:= by cases t with
| bot =>
  unfold FinTyping at typing
  exact False.elim typing

| top =>
  unfold FinTyping at typing
  exact typing

| iso label body =>
  unfold FinTyping at typing
  have ih := FinTyping.convergent_or_divergent typing
  cases ih with
  | inl h =>
    apply Or.inl
    apply Convergent.evalcon_reflection
    { apply EvalCon.extract label .hole }
    { exact h }
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_reflection
    { apply EvalCon.extract label .hole }
    { exact h }

| entry label body =>
  unfold FinTyping at typing
  have ih := FinTyping.convergent_or_divergent typing
  cases ih with
  | inl h =>
    apply Or.inl
    apply Convergent.evalcon_reflection
    { apply EvalCon.project label .hole }
    { exact h }
  | inr h =>
    apply Or.inr
    apply Divergent.evalcon_reflection
    { apply EvalCon.project label .hole }
    { exact h }

| path left right =>
  apply FinTyping.path_determines_function at typing
  have ⟨f, h0⟩ := typing
  apply Or.inl
  unfold Convergent
  exists (.function f)


| unio left right =>
  unfold FinTyping at typing
  cases typing with
  | inl h =>
    apply FinTyping.convergent_or_divergent h
  | inr h =>
    apply FinTyping.convergent_or_divergent h

| inter left right =>
  unfold FinTyping at typing
  have ⟨h0,h1⟩ := typing
  apply FinTyping.convergent_or_divergent h0

| diff left right =>
  unfold FinTyping at typing
  have ⟨h0,h1⟩ := typing
  apply FinTyping.convergent_or_divergent h0
| _ =>
  unfold FinTyping at typing
  exact False.elim typing




end Lang.Dynamic
