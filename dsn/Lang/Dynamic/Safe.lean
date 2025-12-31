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
  /- NOTE:
  - given that the transition is NOT call-by-value
  - then app diverges iff the function body diverges
  -/
  /- TODO: safe_arg not necessary for transition without CBV
  - dvg(app) then dvg(sub)
  - cvg(app) then cvg(sub)
  -/
  (safe_arg : Safe arg)
  (necxt : NEvalCxt E)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
  Safe (E (Expr.sub eam e))
:= by
  sorry

theorem Safe.function_beta_expansion
  f
  /- NOTE:
  - given that the transition is NOT call-by-value
  - then app diverges iff the function body diverges
  -/
  /- TODO:
  - dvg(arg) and dvg(sub) then dvg(app)
  - cvg(arg) and dvg(sub) then dvg(app)
  - dvg(arg) and cvg(sub) then dvg(app) or cvg(app)
  - cvg(arg) and cvg(sub) then cvg(app)
  -/
  (safe_arg : Safe arg)
  (necxt : NEvalCxt E)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.sub eam e)) →
  Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  sorry


theorem Safe.subject_reduction
  (transition : NStep e e')
: Safe e → Safe e'
:= by sorry

theorem Safe.subject_expansion
  (transition : NStep e e')
: Safe e' → Safe e
:= by sorry


theorem Safe.necxt_reflection :
  NEvalCxt E →
  Safe (E e) →
  Safe e
:= by
  sorry

theorem Safe.necxt_preservation :
  NEvalCxt E → Safe (E e) →
  Safe e' → Safe (E e')
:= by sorry


theorem Safe.record_beta_reduction :
  NEvalCxt E →
  Safe (E (Expr.project (Expr.record [(l, e)]) l)) →
  Safe (E e)
:= by sorry

theorem Safe.record_beta_expansion l :
  NEvalCxt E →
  Safe (E e) →
  Safe (E (Expr.project (Expr.record [(l, e)]) l))
:= by sorry

end Lang.Dynamic
