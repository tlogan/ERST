-- import Lang.Util
-- import Lang.Basic
-- import Lang.NStep
-- import Lang.Safe

-- set_option pp.fieldNotation false

-- namespace Lang

-- def FinTyping (e : Expr) : Typ → Prop
-- | .top => Safe e
-- | .iso l body => Safe e ∧ FinTyping (.extract e l) body
-- -- | .iso l body => FinTyping (.extract e l) body
-- | .entry l body => Safe e ∧ FinTyping (.project e l) body
-- -- | .entry l body => FinTyping (.project e l) body
-- | .path left right =>
--     Safe e ∧
--     (∀ arg , FinTyping arg left → FinTyping (.app e arg) right)
-- -- | .path left right => ∀ arg ,
-- --   FinTyping arg left → FinTyping (.app e arg) right
-- | .unio left right => FinTyping e left ∨ FinTyping e right
-- | .inter left right => FinTyping e left ∧ FinTyping e right
-- | .diff left right => FinTyping e left ∧ ¬ (FinTyping e right)
-- | _ => False

-- def FinSubtyping (l r : Typ) : Prop :=
--   ∀ e , FinTyping e l → FinTyping e r

-- def FinTyping.finiteness :
--   FinTyping e t → Typ.finite t
-- := by sorry

-- /- NOTE: need to prove the expression is safe so that inductive hypothesis is strong enough -/
-- theorem FinTyping.safety :
--   FinTyping e t → Safe e
-- := by cases t with
-- | var t =>
--   simp [FinTyping]
-- | iso l t =>
--   simp [FinTyping]
--   intro h0 h1
--   apply h0
-- | entry l t =>
--   simp [FinTyping]
--   intro h0 h1
--   apply h0
-- | path t0 t1 =>
--   simp [FinTyping]
--   intro h0 h1
--   apply h0
-- | bot =>
--   simp [FinTyping]
-- | top =>
--   simp [FinTyping]
-- | unio t0 t1 =>
--   simp [FinTyping]
--   intro h0
--   cases h0 with
--   | inl h0 =>
--     apply FinTyping.safety h0
--   | inr h0 =>
--     apply FinTyping.safety h0
-- | inter t0 t1 =>
--   simp [FinTyping]
--   intro h0 h1
--   apply FinTyping.safety h0
-- | diff t0 t1 =>
--   simp [FinTyping]
--   intro h0 h1
--   apply FinTyping.safety h0
-- | _ =>
--   simp [FinTyping]

-- theorem FinTyping.progress :
--   FinTyping e t → Expr.is_value e ∨ ∃ e', NStep e e'
-- := by
--   intro h0
--   apply Safe.progress
--   apply FinTyping.safety h0


-- def Subtyping.Fin (left right : Typ) : Prop :=
--   ∀ e, FinTyping e left → FinTyping e right


-- mutual
--   theorem FinTyping.subject_reduction
--     (transition : NStep e e')
--   : FinTyping e t → FinTyping e' t
--   := by cases t with
--   | bot =>
--     unfold FinTyping
--     simp
--   | top =>
--     unfold FinTyping
--     intro h0
--     exact Safe.subject_reduction transition h0

--   | iso label body =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_reduction transition h0 }
--     {
--       apply FinTyping.subject_reduction
--       { apply NStep.applicand _ transition }
--       { exact h1 }
--     }

--   | entry label body =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_reduction transition h0 }
--     {
--       apply FinTyping.subject_reduction
--       { apply NStep.applicand _ transition }
--       { exact h1 }
--     }


--   | path left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_reduction transition h0 }
--     { intro e'' h2
--       specialize h1 e'' h2
--       apply FinTyping.subject_reduction
--       { apply NStep.applicator _ transition }
--       { exact h1 }
--     }

--   | unio left right =>
--     unfold FinTyping
--     intro h0
--     cases h0 with
--     | inl h2 =>
--       apply Or.inl
--       apply FinTyping.subject_reduction transition h2
--     | inr h2 =>
--       apply Or.inr
--       apply FinTyping.subject_reduction transition h2

--   | inter left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { apply FinTyping.subject_reduction transition h0 }
--     { apply FinTyping.subject_reduction transition h1 }

--   | diff left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { apply FinTyping.subject_reduction transition h0 }
--     {
--       intro h2
--       apply h1
--       apply FinTyping.subject_expansion transition h2
--     }
--   | _ =>
--     unfold FinTyping
--     simp

--   theorem FinTyping.subject_expansion
--     (transition : NStep e e')
--   : FinTyping e' t → FinTyping e t
--   := by cases t with
--   | bot =>
--     unfold FinTyping
--     simp
--   | top =>
--     unfold FinTyping
--     intro h0
--     exact Safe.subject_expansion transition h0

--   | iso label body =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_expansion transition h0 }
--     {
--       apply FinTyping.subject_expansion
--       { apply NStep.applicand _ transition }
--       { exact h1 }
--     }

--   | entry label body =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_expansion transition h0 }
--     {
--       apply FinTyping.subject_expansion
--       { apply NStep.applicand _ transition }
--       { exact h1 }
--     }


--   | path left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { exact Safe.subject_expansion transition h0 }
--     { intro e'' h2
--       specialize h1 e'' h2
--       apply FinTyping.subject_expansion
--       { apply NStep.applicator _ transition }
--       { exact h1 }
--     }

--   | unio left right =>
--     unfold FinTyping
--     intro h0
--     cases h0 with
--     | inl h2 =>
--       apply Or.inl
--       apply FinTyping.subject_expansion transition h2
--     | inr h2 =>
--       apply Or.inr
--       apply FinTyping.subject_expansion transition h2

--   | inter left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { apply FinTyping.subject_expansion transition h0 }
--     { apply FinTyping.subject_expansion transition h1 }

--   | diff left right =>
--     unfold FinTyping
--     intro ⟨h0,h1⟩
--     apply And.intro
--     { apply FinTyping.subject_expansion transition h0 }
--     {
--       intro h2
--       apply h1
--       apply FinTyping.subject_reduction transition h2
--     }
--   | _ =>
--     unfold FinTyping
--     simp
-- end




-- end Lang
