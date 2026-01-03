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


#eval Expr.pattern_match
  (Expr.iso "hello" (Expr.record []))
  (Pat.iso "hello" (Pat.var "x"))


-- example : FinTyping (
--   Expr.app (
--     Expr.function [
--       (Pat.var "x", Expr.iso "hello" (Expr.var "x"))
--     ]
--   ) (
--     Expr.app (.function [(Pat.var "x", Expr.var "x")]) (.record [])
--   )
-- ) (
--   (.iso "hello" .top)
-- )
-- := by
--   unfold FinTyping
--   unfold FinTyping
--   apply Or.inl
--   unfold Convergent
--   exists (.record [])
--   apply And.intro
--   { apply NStepStar.step
--     { unfold Expr.extract
--       apply NStep.necxt
--       { apply NEvalCxt.applicand ; exact NEvalCxt.hole }
--       { apply NStep.necxt
--         { apply NEvalCxt.applicand ; exact NEvalCxt.hole }
--         {
--           apply NStep.pattern_match
--           simp [Expr.pattern_match]
--           rfl
--         }
--       }
--     }
--     { apply NStepStar.step
--       { apply NStep.necxt
--         { apply NEvalCxt.applicand ; exact NEvalCxt.hole}
--         { apply NStep.pattern_match
--           simp [Expr.pattern_match]
--           rfl
--         }
--       }
--       { apply NStepStar.step
--         {
--           apply NStep.pattern_match
--           { reduce ;  simp [Expr.pattern_match]; rfl }
--         }
--         { apply NStepStar.refl }
--       }
--     }
--   }
--   { exact rfl }



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






-- theorem FinTyping.path_determines_function
--   (typing : FinTyping e (.path antec consq))
-- : ∃ f , NStepStar e (.function f)
-- := by sorry

-- theorem FinTyping.soundness
--   (typing : FinTyping e t)
-- : Convergent e ∨ Divergent e
-- := by cases t with
-- | bot =>
--   unfold FinTyping at typing
--   exact False.elim typing

-- | top =>
--   unfold FinTyping at typing
--   exact typing

-- | iso label body =>
--   unfold FinTyping at typing

--   have ih := FinTyping.soundness typing
--   cases ih with
--   | inl h0 =>
--     apply Or.inl
--     have necxt := NEvalCxt.extract label .hole
--     apply Convergent.necxt_reflection necxt h0
--   | inr h0 =>
--     apply Or.inr
--     have necxt := NEvalCxt.extract label .hole
--     apply Divergent.necxt_reflection necxt h0

-- | entry label body =>
--   unfold FinTyping at typing
--   have ih := FinTyping.soundness typing
--   cases ih with
--   | inl h0 =>
--     apply Or.inl
--     have necxt := NEvalCxt.project label .hole
--     apply Convergent.necxt_reflection necxt h0
--   | inr h0 =>
--     apply Or.inr
--     have necxt := NEvalCxt.project label .hole
--     apply Divergent.necxt_reflection necxt h0

-- | path left right =>
--   apply FinTyping.path_determines_function at typing
--   have ⟨f, h0⟩ := typing
--   apply Or.inl
--   unfold Convergent
--   exists (.function f)

-- | unio left right =>
--   unfold FinTyping at typing
--   cases typing with
--   | inl h =>
--     apply FinTyping.soundness h
--   | inr h =>
--     apply FinTyping.soundness h

-- | inter left right =>
--   unfold FinTyping at typing
--   have ⟨h0,h1⟩ := typing
--   apply FinTyping.soundness h0

-- | diff left right =>
--   unfold FinTyping at typing
--   have ⟨h0,h1⟩ := typing
--   apply FinTyping.soundness h0
-- | _ =>
--   unfold FinTyping at typing
--   exact False.elim typing


-- theorem FinTyping.swap_safe_preservation
--   (necxt : NEvalCxt E)
--   (typing : FinTyping e t)
--   (typing' : FinTyping e' t)
--   (cod : Convergent (E e') ∨ Divergent (E e'))
-- : FinTyping (E e) t' → FinTyping (E e') t'
-- := by sorry

-- theorem FinTyping.value_swap_preservation
--   (necxt : NEvalCxt E)
--   (isval : Expr.is_value e)
--   (typing : FinTyping e t)
--   (typing' : FinTyping e' t)
-- : FinTyping (E e) t' → FinTyping (E e') t'
-- := by cases t' with
-- | bot =>
--   unfold FinTyping
--   simp

-- | top =>
--   unfold FinTyping
--   intro typing_necxt
--   apply FinTyping.soundness at typing'

--   cases typing' with
--   |inl h0 =>
--     cases typing_necxt with
--     | inl h1 =>
--       apply Or.inl
--       exact Convergent.necxt_preservation necxt h1 h0
--     | inr h1 =>
--       apply Or.inr
--       exact Divergent.swap_preservation necxt isval h1
--   | inr h0 =>
--     apply Or.inr
--     exact Divergent.necxt_preservation necxt h0

-- | iso label body =>
--   unfold FinTyping
--   apply NEvalCxt.extract label at necxt
--   intro typing_necxt
--   apply FinTyping.value_swap_preservation necxt isval typing typing' typing_necxt


-- | entry label body =>
--   unfold FinTyping
--   apply NEvalCxt.project label at necxt
--   intro typing_necxt
--   apply FinTyping.value_swap_preservation necxt isval typing typing' typing_necxt

-- | path left right =>
--   unfold FinTyping
--   intro h4 e' h5
--   apply NEvalCxt.applicator e' at necxt
--   apply FinTyping.value_swap_preservation necxt isval typing typing' (h4 e' h5)


-- | unio left right =>
--   unfold FinTyping
--   intro h4
--   cases h4 with
--   | inl h5 =>
--     apply Or.inl
--     apply FinTyping.value_swap_preservation necxt isval typing typing' h5
--   | inr h5 =>
--     apply Or.inr
--     apply FinTyping.value_swap_preservation necxt isval typing typing' h5

-- | inter left right =>
--   unfold FinTyping
--   intro h4
--   have ⟨h5,h6⟩ := h4
--   apply And.intro
--   { apply FinTyping.value_swap_preservation necxt isval typing typing' h5 }
--   { apply FinTyping.value_swap_preservation necxt isval typing typing' h6 }

-- | diff left right =>
--   unfold FinTyping
--   intro h4
--   have ⟨h5,h6⟩ := h4
--   clear h4

--   apply And.intro
--   { apply FinTyping.value_swap_preservation necxt isval typing typing' h5 }
--   {
--     intro h7
--     apply h6
--     clear h6

--     apply FinTyping.swap_safe_preservation
--     { exact necxt }
--     { exact typing' }
--     { exact typing }
--     { exact soundness h5 }
--     { exact h7 }
--   }
-- | _ =>
--   unfold FinTyping
--   simp

mutual
  theorem FinTyping.function_beta_reduction
    (safe_arg : Safe arg)
    (necxt : NEvalCxt E)
    (matching : Expr.pattern_match arg p = .some eam)
  : FinTyping (E (Expr.app (Expr.function ((p, e) :: f)) arg)) t →
    FinTyping (E (Expr.sub eam e)) t
  := by cases t with
  | top =>
    unfold FinTyping
    intro h0
    exact Safe.function_beta_reduction necxt matching h0
  | iso label body =>
    intro h0
    apply NEvalCxt.extract label at necxt
    apply FinTyping.function_beta_reduction safe_arg necxt matching h0

  | entry label body =>
    intro h0
    apply NEvalCxt.project label at necxt
    apply FinTyping.function_beta_reduction safe_arg necxt matching h0

  | path left right =>
    intro h0 e' h1
    specialize h0 e' h1
    apply NEvalCxt.applicator e' at necxt
    apply FinTyping.function_beta_reduction safe_arg necxt matching h0

  | unio left right =>
    intro h0
    cases h0 with
    | inl h1 =>
      apply Or.inl
      apply FinTyping.function_beta_reduction safe_arg necxt matching h1

    | inr h1 =>
      apply Or.inr
      apply FinTyping.function_beta_reduction safe_arg necxt matching h1

  | inter left right =>
    intro h0
    have ⟨h1,h2⟩ := h0
    apply And.intro
    { apply FinTyping.function_beta_reduction safe_arg necxt matching h1 }
    { apply FinTyping.function_beta_reduction safe_arg necxt matching h2 }

  | diff left right =>
    intro h0
    have ⟨h1,h2⟩ := h0
    apply And.intro
    { apply FinTyping.function_beta_reduction safe_arg necxt matching h1 }
    {
      intro h3
      apply h2
      apply FinTyping.function_beta_expansion f safe_arg necxt matching h3
    }

  | _ =>
    exact fun a => a

  theorem FinTyping.function_beta_expansion
    f
    (safe_arg : Safe arg)
    (necxt : NEvalCxt E)
    (matching : Expr.pattern_match arg p = .some eam)
  : FinTyping (E (Expr.sub eam e)) t →
    FinTyping (E (Expr.app (Expr.function ((p, e) :: f)) arg)) t
  := by cases t with
  | top =>
    unfold FinTyping
    intro h0
    exact Safe.contextual_function_beta_expansion f safe_arg necxt matching h0

  | iso label body =>
    intro h0
    apply NEvalCxt.extract label at necxt
    apply FinTyping.function_beta_expansion f safe_arg necxt matching h0

  | entry label body =>
    intro h0
    apply NEvalCxt.project label at necxt
    apply FinTyping.function_beta_expansion f safe_arg necxt matching h0

  | path left right =>
    intro h0 e' h1
    specialize h0 e' h1
    apply NEvalCxt.applicator e' at necxt
    apply FinTyping.function_beta_expansion f safe_arg necxt matching h0

  | unio left right =>
    intro h0
    cases h0 with
    | inl h1 =>
      apply Or.inl
      apply FinTyping.function_beta_expansion f safe_arg necxt matching h1

    | inr h1 =>
      apply Or.inr
      apply FinTyping.function_beta_expansion f safe_arg necxt matching h1

  | inter left right =>
    intro h0
    have ⟨h1,h2⟩ := h0
    apply And.intro
    { apply FinTyping.function_beta_expansion f safe_arg necxt matching h1 }
    { apply FinTyping.function_beta_expansion f safe_arg necxt matching h2 }

  | diff left right =>
    intro h0
    have ⟨h1,h2⟩ := h0
    apply And.intro
    { apply FinTyping.function_beta_expansion f safe_arg necxt matching h1 }
    {
      intro h3
      apply h2
      apply FinTyping.function_beta_reduction safe_arg necxt matching h3
    }

  | _ =>
    exact fun a => a



end

mutual
  theorem FinTyping.record_beta_reduction :
    NEvalCxt E →
    FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t →
    FinTyping (E e) t
  := by cases t with
  | top =>
    unfold FinTyping
    intro h0 h1
    exact Safe.record_beta_reduction h0 h1

  | iso label body =>
    intro h0 h1
    apply NEvalCxt.extract label at h0
    apply FinTyping.record_beta_reduction h0 h1

  | entry label body =>
    intro h0 h1
    apply NEvalCxt.project label at h0
    apply FinTyping.record_beta_reduction h0 h1

  | path left right =>
    intro h0 h1 e' h2
    specialize h1 e' h2
    apply NEvalCxt.applicator e' at h0
    apply FinTyping.record_beta_reduction h0 h1


  | unio left right =>
    intro h0 h1
    cases h1 with
    | inl h1 =>
      have ih := FinTyping.record_beta_reduction h0 h1
      exact Or.inl ih
    | inr h1 =>
      have ih := FinTyping.record_beta_reduction h0 h1
      exact Or.inr ih

  | inter left right =>
    intro h0 h1
    unfold FinTyping at h1
    have ⟨h2,h3⟩ := h1
    apply And.intro
    { apply FinTyping.record_beta_reduction h0 h2 }
    { apply FinTyping.record_beta_reduction h0 h3 }

  | diff left right =>
    intro h0 h1
    unfold FinTyping at h1
    have ⟨h2,h3⟩ := h1
    apply And.intro
    { apply FinTyping.record_beta_reduction h0 h2 }
    {
      intro h4
      apply h3
      apply FinTyping.record_beta_expansion l h0 h4
    }

  | _ =>
    intro h0 h1
    unfold FinTyping at h1
    exact h1

  theorem FinTyping.record_beta_expansion l :
    NEvalCxt E →
    FinTyping (E e) t →
    FinTyping (E (Expr.project (Expr.record [(l, e)]) l)) t
  := by cases t with
  | top =>
    unfold FinTyping
    intro h0 h1
    exact Safe.record_beta_expansion l h0 h1
  | iso label body =>
    intro h0 h1
    apply NEvalCxt.extract label at h0
    apply FinTyping.record_beta_expansion l h0 h1

  | entry label body =>
    intro h0 h1
    apply NEvalCxt.project label at h0
    apply FinTyping.record_beta_expansion l h0 h1

  | path left right =>
    intro h0 h1 e' h2
    specialize h1 e' h2
    apply NEvalCxt.applicator e' at h0
    apply FinTyping.record_beta_expansion l h0 h1


  | unio left right =>
    intro h0 h1
    cases h1 with
    | inl h1 =>
      have ih := FinTyping.record_beta_expansion l h0 h1
      exact Or.inl ih
    | inr h1 =>
      have ih := FinTyping.record_beta_expansion l h0 h1
      exact Or.inr ih

  | inter left right =>
    intro h0 h1
    unfold FinTyping at h1
    have ⟨h2,h3⟩ := h1
    apply And.intro
    { apply FinTyping.record_beta_expansion l h0 h2 }
    { apply FinTyping.record_beta_expansion l h0 h3 }

  | diff left right =>
    intro h0 h1
    unfold FinTyping at h1
    have ⟨h2,h3⟩ := h1
    apply And.intro
    { apply FinTyping.record_beta_expansion l h0 h2 }
    {
      intro h4
      apply h3

      apply FinTyping.record_beta_reduction h0 h4
    }

  | _ =>
    intro h0 h1
    unfold FinTyping at h1
    exact h1
end



end Lang.Dynamic
