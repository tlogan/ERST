import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar

set_option pp.fieldNotation false


namespace Lang.Dynamic


def Expr.is_head_normal : Expr → Bool
| .iso l body => .true
| .record r => .true
| .function f => .true
| _ => .false

def Convergent (e : Expr) : Prop :=
  ∃ e' , TransitionStar e e' ∧ Expr.is_head_normal e'

def Divergent (e : Expr) : Prop :=
  (∀ e', TransitionStar e e' → ∃ e'' , Transition e' e'')

def Safe (e : Expr) : Prop := Convergent e ∨ Divergent e

mutual

  theorem Convergent.subject_reduction
    (transition : Transition e e')
  : Convergent e → Convergent e'
  := by sorry

  theorem Convergent.subject_expansion
    (transition : Transition e e')
  : Convergent e' → Convergent e
  := by sorry

end


theorem Convergent.econ_reflection :
  EvalCon E →
  Convergent (E e) →
  Convergent e
:= by
  sorry

theorem Convergent.econ_preservation :
  EvalCon E → Convergent (E e) →
  Convergent e' → Convergent (E e')
:= by sorry



mutual
  theorem Convergent.record_beta_reduction :
    EvalCon E →
    Convergent (E (Expr.project (Expr.record [(l, e)]) l)) →
    Convergent (E e)
  := by sorry

  theorem Convergent.record_beta_expansion l :
    EvalCon E →
    Convergent (E e) →
    Convergent (E (Expr.project (Expr.record [(l, e)]) l))
  := by sorry
end


mutual

  theorem Divergent.subject_reduction
    (transition : Transition e e')
  : Divergent e → Divergent e'
  := by sorry

  theorem Divergent.subject_expansion
    (transition : Transition e e')
  : Divergent e' → Divergent e
  := by sorry

end

theorem Divergent.econ_preservation :
  EvalCon E →
  Divergent e →
  Divergent (E e)
:= by
  sorry

theorem Divergent.econ_reflection :
  EvalCon E →
  Divergent (E e) →
  Divergent e
:= by
  sorry


-- theorem Divergent.swap_preservation
--   (econ : EvalCon E)
--   (isval : Expr.is_value e)
--   (dvg_econ : Divergent (E e))
-- : Divergent (E e')
-- := by sorry

mutual
  theorem Divergent.record_beta_reduction :
    EvalCon E →
    Divergent (E (Expr.project (Expr.record [(l, e)]) l)) →
    Divergent (E e)
  := by sorry

  theorem Divergent.record_beta_expansion l :
    EvalCon E →
    Divergent (E e) →
    Divergent (E (Expr.project (Expr.record [(l, e)]) l))
  := by sorry
end


-- theorem TransitionStar.function_beta_reduction
--   (value_arg : Expr.is_value arg = true)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = some eam)
--   (value_result : Expr.is_value e')
-- : TransitionStar (E (Expr.app (Expr.function ((p, e) :: f)) arg)) e' →
--   TransitionStar (E (Expr.sub eam e)) e'
-- := by
--   intro h0
--   cases h0 with
--   | refl _ =>
--     have h2 := EvalCon.app_not_value (Expr.function ((p, e) :: f)) arg econ
--     exact False.elim (h2 value_result)
--   | step e0 em e' trans trans_star =>
--     have h0 : Transition (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--       apply Transition.pattern_match
--       { exact value_arg }
--       { exact matching }
--     have h1 := Transition.econ_deterministic econ h0 trans
--     rw [h1] at trans_star
--     exact trans_star


-- theorem Convergent.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Convergent (E (Expr.sub eam e))
-- := by
--   unfold Convergent
--   intro ⟨e',h0,h1⟩
--   exists e'
--   apply And.intro
--   { exact TransitionStar.function_beta_reduction value_arg econ matching h1 h0 }
--   { exact h1 }

-- theorem Convergent.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Convergent (E (Expr.sub eam e)) →
--   Convergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Convergent
--   intro ⟨e',h0,h1⟩
--   exists e'
--   apply And.intro
--   { apply TransitionStar.step
--     { apply Transition.econ
--       { exact econ }
--       { apply Transition.pattern_match
--         { exact value_arg }
--         { exact matching }
--       }
--     }
--     { exact h0 }
--   }
--   { exact h1 }




-- theorem Divergent.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Divergent (E (Expr.sub eam e))
-- := by
--   unfold Divergent
--   intro h0 e' h1
--   have h2 : Transition (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--     apply Transition.pattern_match
--     { exact value_arg }
--     { exact matching }

--   have h3 : TransitionStar (E (Expr.app (Expr.function ((p, e) :: f)) arg)) e' := by
--     apply TransitionStar.step
--     { apply Transition.econ econ h2 }
--     { exact h1 }
--   exact h0 e' h3

-- theorem Divergent.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Divergent (E (Expr.sub eam e)) →
--   Divergent (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Divergent
--   intro h0 e' h1
--   cases h1 with
--   | refl _ =>
--     exists (E (Expr.sub eam e))
--     apply Transition.econ econ
--     apply Transition.pattern_match value_arg matching
--   | step e0 em e' trans trans_star =>
--     have h2 : Transition (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.sub eam e) := by
--       apply Transition.pattern_match
--       { exact value_arg }
--       { exact matching }
--     have h3 := Transition.econ_deterministic econ h2 trans
--     rw [h3] at trans_star
--     exact h0 e' trans_star



-- theorem Safe.function_beta_reduction
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg)) →
--   Safe (E (Expr.sub eam e))
-- := by
--   unfold Safe
--   intro h0
--   cases h0 with
--   | inl cvg =>
--     apply Or.inl
--     exact Convergent.function_beta_reduction value_arg econ matching cvg
--   | inr dvg =>
--     apply Or.inr
--     exact Divergent.function_beta_reduction value_arg econ matching dvg

-- theorem Safe.function_beta_expansion
--   f
--   (value_arg : Expr.is_value arg)
--   (econ : EvalCon E)
--   (matching : Expr.pattern_match arg p = .some eam)
-- : Safe (E (Expr.sub eam e)) →
--   Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
-- := by
--   unfold Safe
--   intro h0
--   cases h0 with
--   | inl cvg =>
--     apply Or.inl
--     exact Convergent.function_beta_expansion f value_arg econ matching cvg
--   | inr dvg =>
--     apply Or.inr
--     exact Divergent.function_beta_expansion f value_arg econ matching dvg

theorem Safe.function_beta_reduction
  /- NOTE:
  - given that the transition is NOT call-by-value
  - then app diverges iff the function body diverges
  -/
  /- TODO: safe_arg not necessary for transition without CBV -/
  (safe_arg : Safe arg)
  (econ : EvalCon E)
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
  /- TODO: safe_arg not necessary for transition without CBV -/
  (safe_arg : Safe arg)
  (econ : EvalCon E)
  (matching : Expr.pattern_match arg p = .some eam)
: Safe (E (Expr.sub eam e)) →
  Safe (E (Expr.app (Expr.function ((p, e) :: f)) arg))
:= by
  sorry


theorem Safe.subject_reduction
  (transition : Transition e e')
: Safe e → Safe e'
:= by sorry

theorem Safe.subject_expansion
  (transition : Transition e e')
: Safe e' → Safe e
:= by sorry


theorem Safe.econ_reflection :
  EvalCon E →
  Safe (E e) →
  Safe e
:= by
  sorry

theorem Safe.econ_preservation :
  EvalCon E → Safe (E e) →
  Safe e' → Safe (E e')
:= by sorry


theorem Safe.record_beta_reduction :
  EvalCon E →
  Safe (E (Expr.project (Expr.record [(l, e)]) l)) →
  Safe (E e)
:= by sorry

theorem Safe.record_beta_expansion l :
  EvalCon E →
  Safe (E e) →
  Safe (E (Expr.project (Expr.record [(l, e)]) l))
:= by sorry

end Lang.Dynamic
