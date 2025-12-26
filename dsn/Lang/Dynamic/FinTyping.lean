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
  := by cases t with
  | bot =>
    unfold FinTyping
    simp
  | top =>
    unfold FinTyping
    intro h0
    cases h0 with
    | inl h1 =>
      apply Or.inl
      exact Convergent.subject_reduction transition h1
    | inr h1 =>
      apply Or.inr
      exact Divergent.subject_reduction transition h1

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    {
      have econ := EvalCon.extract label .hole
      apply Transition.econ econ transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_reduction
    {
      have econ := EvalCon.project label .hole
      apply Transition.econ econ transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_reduction
    {
      have econ := EvalCon.applicator e'' .hole
      apply Transition.econ econ transition
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
    cases h0 with
    | inl h1 =>
      apply Or.inl
      exact Convergent.subject_expansion transition h1
    | inr h1 =>
      apply Or.inr
      exact Divergent.subject_expansion transition h1

  | iso label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    {
      have econ := EvalCon.extract label .hole
      apply Transition.econ econ transition
    }
    { exact h0 }

  | entry label body =>
    unfold FinTyping
    intro h0
    apply FinTyping.subject_expansion
    {
      have econ := EvalCon.project label .hole
      apply Transition.econ econ transition
    }
    { exact h0 }


  | path left right =>
    unfold FinTyping
    intro h0 e'' h1
    specialize h0 e'' h1
    apply FinTyping.subject_expansion
    {
      have econ := EvalCon.applicator e'' .hole
      apply Transition.econ econ transition
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

  have ih := FinTyping.soundness typing
  cases ih with
  | inl h0 =>
    apply Or.inl
    have econ := EvalCon.extract label .hole
    apply Convergent.econ_reflection econ h0
  | inr h0 =>
    apply Or.inr
    have econ := EvalCon.extract label .hole
    apply Divergent.econ_reflection econ h0

| entry label body =>
  unfold FinTyping at typing
  have ih := FinTyping.soundness typing
  cases ih with
  | inl h0 =>
    apply Or.inl
    have econ := EvalCon.project label .hole
    apply Convergent.econ_reflection econ h0
  | inr h0 =>
    apply Or.inr
    have econ := EvalCon.project label .hole
    apply Divergent.econ_reflection econ h0

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


theorem FinTyping.swap_safe_preservation
  (econ : EvalCon E)
  (typing : FinTyping e t)
  (typing' : FinTyping e' t)
  (cod : Convergent (E e') ∨ Divergent (E e'))
: FinTyping (E e) t' → FinTyping (E e') t'
:= by sorry

theorem FinTyping.value_swap_preservation
  (econ : EvalCon E)
  (isval : Expr.is_value e)
  (typing : FinTyping e t)
  (typing' : FinTyping e' t)
: FinTyping (E e) t' → FinTyping (E e') t'
:= by cases t' with
| bot =>
  unfold FinTyping
  simp

| top =>
  unfold FinTyping
  intro typing_econ
  apply FinTyping.soundness at typing'

  cases typing' with
  |inl h0 =>
    cases typing_econ with
    | inl h1 =>
      apply Or.inl
      exact Convergent.econ_preservation econ h1 h0
    | inr h1 =>
      apply Or.inr
      exact Divergent.swap_preservation econ isval h1
  | inr h0 =>
    apply Or.inr
    exact Divergent.econ_preservation econ h0

| iso label body =>
  unfold FinTyping
  apply EvalCon.extract label at econ
  intro typing_econ
  apply FinTyping.value_swap_preservation econ isval typing typing' typing_econ


| entry label body =>
  unfold FinTyping
  apply EvalCon.project label at econ
  intro typing_econ
  apply FinTyping.value_swap_preservation econ isval typing typing' typing_econ

| path left right =>
  unfold FinTyping
  intro h4 e' h5
  apply EvalCon.applicator e' at econ
  apply FinTyping.value_swap_preservation econ isval typing typing' (h4 e' h5)


| unio left right =>
  unfold FinTyping
  intro h4
  cases h4 with
  | inl h5 =>
    apply Or.inl
    apply FinTyping.value_swap_preservation econ isval typing typing' h5
  | inr h5 =>
    apply Or.inr
    apply FinTyping.value_swap_preservation econ isval typing typing' h5

| inter left right =>
  unfold FinTyping
  intro h4
  have ⟨h5,h6⟩ := h4
  apply And.intro
  { apply FinTyping.value_swap_preservation econ isval typing typing' h5 }
  { apply FinTyping.value_swap_preservation econ isval typing typing' h6 }

| diff left right =>
  unfold FinTyping
  intro h4
  have ⟨h5,h6⟩ := h4
  clear h4

  apply And.intro
  { apply FinTyping.value_swap_preservation econ isval typing typing' h5 }
  {
    intro h7
    apply h6
    clear h6

    apply FinTyping.swap_safe_preservation
    { exact econ }
    { exact typing' }
    { exact typing }
    { exact soundness h5 }
    { exact h7 }
  }
| _ =>
  unfold FinTyping
  simp



-- mutual
--   theorem FinTyping.function_beta_reduction :
--     (∀ {ev} ,
--       Expr.is_value ev → FinTyping ev tp →
--       ∃ eam , Expr.pattern_match ev p = .some eam ∧ FinTyping (Expr.sub eam e) tr
--     ) →
--     FinTyping (Expr.app (Expr.function ((p, e) :: f)) e') tr →
--     FinTyping e' tp
--   := by sorry

--   theorem FinTyping.function_beta_expansion f :
--     (∀ {ev} ,
--       Expr.is_value ev → FinTyping ev tp →
--       ∃ eam , Expr.pattern_match ev p = .some eam ∧ FinTyping (Expr.sub eam e) tr
--     ) →
--     FinTyping e' tp →
--     FinTyping (Expr.app (Expr.function ((p, e) :: f)) e') tr
--   := by sorry
-- end

-- mutual
--   theorem FinTyping.record_beta_reduction :
--     EvalCon E →
--     FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t →
--     FinTyping (E e) t
--   := by
--     sorry

--   theorem FinTyping.record_beta_expansion l :
--     EvalCon E →
--     FinTyping (E e) t →
--     FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t
--   := by cases t with
--   | top =>
--     unfold FinTyping
--     intro h0 h1
--     cases h1 with
--     | inl h2 =>
--       apply Or.inl
--       sorry
--       -- exact Convergent.record_beta_expansion h0 h2
--     | inr h2 =>
--       apply Or.inr
--       sorry
--       -- exact Divergent.record_beta_expansion h0 h2
--   | iso label body =>
--     intro h0 h1
--     apply EvalCon.extract label at h0
--     apply FinTyping.record_beta_expansion l h0 h1

--   | entry label body =>
--     intro h0 h1
--     apply EvalCon.project label at h0
--     apply FinTyping.record_beta_expansion l h0 h1

--   | path left right =>
--     intro h0 h1 e' h2
--     specialize h1 e' h2
--     apply EvalCon.applicator e' at h0
--     apply FinTyping.record_beta_expansion l h0 h1


--   | unio left right =>
--     intro h0 h1
--     cases h1 with
--     | inl h1 =>
--       have ih := FinTyping.record_beta_expansion l h0 h1
--       exact Or.inl ih
--     | inr h1 =>
--       have ih := FinTyping.record_beta_expansion l h0 h1
--       exact Or.inr ih

--   | inter left right =>
--     intro h0 h1
--     unfold FinTyping at h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply FinTyping.record_beta_expansion l h0 h2 }
--     { apply FinTyping.record_beta_expansion l h0 h3 }

--   | diff left right =>
--     intro h0 h1
--     unfold FinTyping at h1
--     have ⟨h2,h3⟩ := h1
--     apply And.intro
--     { apply FinTyping.record_beta_expansion l h0 h2 }
--     {
--       intro h4
--       apply h3

--       apply FinTyping.record_beta_reduction h0 h4
--     }

--   | _ =>
--     intro h0 h1
--     unfold FinTyping at h1
--     exact h1
-- end



end Lang.Dynamic
