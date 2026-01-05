import Lang.Basic
import Lang.Dynamic.NEvalCxt
import Lang.Dynamic.NStep
import Lang.Dynamic.NStepStar

set_option pp.fieldNotation false


namespace Lang.Dynamic


def Safe (e : Expr) : Prop :=
  (∀ e', NStepStar e e' → Expr.is_value e' ∨ (∃ e'' , NStep e' e''))

-- theorem NStepStar.function_beta_reduction
--   (value_arg : Expr.is_value arg = true)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = some eam)
--   (value_result : Expr.is_value e')
-- : NStepStar (E (Expr.app (Expr.function ((p, e) :: f)) arg)) e' →
--   NStepStar (E (Expr.sub eam e)) e'
-- := by
--   intro h0
--   cases h0 with
--   | refl _ =>
--     have h2 := NEvalCxt.app_not_value (Expr.function ((p, e) :: f)) arg necxt
--     exact False.elim (h2 value_result)
--   | step e0 em e' trans trans_star =>
--     have h0 : NStep (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--       apply NStep.pattern_match
--       { exact value_arg }
--       { exact matching }
--     have h1 := NStep.necxt_deterministic necxt h0 trans
--     rw [h1] at trans_star
--     exact trans_star


-- theorem Convergent.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Convergent (E (Expr.sub eam e))
-- := by
--   unfold Convergent
--   intro ⟨e',h0,h1⟩
--   exists e'
--   apply And.intro
--   { exact NStepStar.function_beta_reduction value_arg necxt matching h1 h0 }
--   { exact h1 }

-- theorem Convergent.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Convergent (E (Expr.sub eam e)) →
--   Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Convergent
--   intro ⟨e',h0,h1⟩
--   exists e'
--   apply And.intro
--   { apply NStepStar.step
--     { apply NStep.necxt
--       { exact necxt }
--       { apply NStep.pattern_match
--         { exact value_arg }
--         { exact matching }
--       }
--     }
--     { exact h0 }
--   }
--   { exact h1 }




-- theorem Divergent.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Divergent (E (Expr.sub eam e))
-- := by
--   unfold Divergent
--   intro h0 e' h1
--   have h2 : NStep (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--     apply NStep.pattern_match
--     { exact value_arg }
--     { exact matching }

--   have h3 : NStepStar (E (Expr.app (Expr.function ((p, e) :: f)) arg)) e' := by
--     apply NStepStar.step
--     { apply NStep.necxt necxt h2 }
--     { exact h1 }
--   exact h0 e' h3

-- theorem Divergent.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Divergent (E (Expr.sub eam e)) →
--   Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Divergent
--   intro h0 e' h1
--   cases h1 with
--   | refl _ =>
--     exists (E (Expr.sub eam e))
--     apply NStep.necxt necxt
--     apply NStep.pattern_match value_arg matching
--   | step e0 em e' trans trans_star =>
--     have h2 : NStep (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--       apply NStep.pattern_match
--       { exact value_arg }
--       { exact matching }
--     have h3 := NStep.necxt_deterministic necxt h2 trans
--     rw [h3] at trans_star
--     exact h0 e' trans_star



-- theorem Safe.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Safe (E (Expr.sub eam e))
-- := by
--   unfold Safe
--   intro h0
--   cases h0 with
--   | inl cvg =>
--     apply Or.inl
--     exact Convergent.function_beta_reduction value_arg necxt matching cvg
--   | inr dvg =>
--     apply Or.inr
--     exact Divergent.function_beta_reduction value_arg necxt matching dvg

-- theorem Safe.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (necxt : NEvalCxt E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Safe (E (Expr.sub eam e)) →
--   Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Safe
--   intro h0
--   cases h0 with
--   | inl cvg =>
--     apply Or.inl
--     exact Convergent.function_beta_expansion f value_arg necxt matching cvg
--   | inr dvg =>
--     apply Or.inr
--     exact Divergent.function_beta_expansion f value_arg necxt matching dvg

theorem Safe.function_beta_reduction
  (necxt : NEvalCxt E)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Safe (E (Expr.sub eam e))
:= by
  unfold Safe
  intro h0 e' h1
  specialize h0 e'
  apply h0
  apply NStepStar.step
  {
    apply NStep.necxt necxt
    apply NStep.pattern_match matching
  }
  { exact h1 }

theorem Safe.necxt_preservation
  (necxt : NEvalCxt E)
  (safe_cxt : Safe (E b))
:  Safe e → Safe (E e)
:= by sorry

theorem Safe.necxt_reflection
  (necxt : NEvalCxt E)
:  Safe (E e) → Safe e
:= by sorry


theorem NStepStar.universal_nexus :
  ∃ en,  ∀ em , NStepStar e em → NStepStar em en
:= by sorry


theorem Safe.subject_star_reduction
  (step_star : NStepStar e e')
: Safe e → Safe e'
:= by
  sorry

theorem Safe.subject_star_expansion
  (step_star : NStepStar e en)
  (nexus : ∀ em , NStepStar e em → NStepStar em en)
: Safe en → Safe e
:= by
  sorry

theorem Safe.subject_reduction
  (step : NStep e e')
: Safe e → Safe e'
:= by
  sorry

theorem Safe.subject_expansion
  (step : NStep e e')
: Safe e' → Safe e
:= by
  intro h0
  have ⟨en,nexus⟩ := @NStepStar.universal_nexus e
  have step_star : NStepStar e' en := by
    apply nexus
    apply NStepStar.step
    exact step
    exact NStepStar.refl e'

  have h1 := Safe.subject_star_reduction step_star h0
  apply Safe.subject_star_expansion
  {
    apply NStepStar.step
    { apply step }
    {
      apply nexus
      apply NStepStar.step
      exact step
      exact NStepStar.refl e'
    }
  }
  { exact nexus }
  { exact h1 }

end Lang.Dynamic
