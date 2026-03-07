import Lean
import Mathlib.Tactic.Linarith
import Mathlib.Algebra.Group.Basic

import Lang.List.Basic
import Lang.String.Basic
import Lang.ReflTrans.Basic
import Lang.Joinable.Basic
import Lang.Typ.Basic
import Lang.Expr.Basic
import Lang.NStep.Basic
import Lang.Safe.Basic
import Lang.Typing.Basic

set_option pp.fieldNotation false
set_option eval.pp false

namespace Lang

theorem Subtyping.refl am t :
  Subtyping am t t
:= by sorry

theorem Subtyping.transitivity :
  Subtyping am t0 t1 →
  Subtyping am t1 t2 →
  Subtyping am t0 t2
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3
  apply And.intro h0
  intro e h4
  apply h3 e
  apply h1 e
  apply h4


theorem PosMonotonic.intro :
  Monotonic true name m t →
  PosMonotonic name m t
:= by
  simp [Monotonic]

theorem NegMonotonic.intro :
  Monotonic false name m t →
  NegMonotonic name m t
:= by
  simp [Monotonic]

theorem Monotonic.bvar_intro :
  Monotonic polarity name m (Typ.bvar i)
:= by sorry

theorem Monotonic.positive_var_intro :
  Monotonic true name m (Typ.var name')
:= by sorry

theorem Monotonic.negative_var_intro :
  name ≠ name' →
  Monotonic false name m (Typ.var name')
:= by sorry

theorem Monotonic.iso_intro :
  Monotonic polarity name m t →
  Monotonic polarity name m (Typ.iso l t)
:= by sorry

theorem Monotonic.entry_intro :
  Monotonic polarity name m t →
  Monotonic polarity name m (Typ.entry l t)
:= by sorry

theorem Monotonic.path_intro :
  Monotonic (not polarity) name m tl →
  Monotonic polarity name m tr →
  Monotonic polarity name m (Typ.path tl tr)
:= by sorry

theorem Monotonic.bot_intro :
  Monotonic polarity name m (Typ.bot)
:= by sorry

theorem Monotonic.top_intro :
  Monotonic polarity name m (Typ.top)
:= by sorry

theorem Monotonic.unio_intro :
  Monotonic polarity name m tl →
  Monotonic polarity name m tr →
  Monotonic polarity name m (Typ.unio tl tr)
:= by sorry

theorem Monotonic.inter_intro :
  Monotonic polarity name m tl →
  Monotonic polarity name m tr →
  Monotonic polarity name m (Typ.unio tl tr)
:= by sorry

theorem Monotonic.diff_intro :
  Monotonic polarity name m tl →
  Monotonic (not polarity) name m tr →
  Monotonic polarity name m (Typ.diff tl tr)
:= by sorry


theorem Monotonic.all_intro :
  (∀ b ∈ bs , b = "") →
  List.length m' = List.length bs →
  List.Disjoint (Prod.dom m') (Prod.dom m) →
  (∀ name' ∈ Prod.dom m',
    EitherMultiMonotonic polarity name' (m' ++ m)
      (Typ.constraints_instantiate 0 (List.map (fun (name', P) => .var name') m') ((.bot,t) :: cs))
  ) →
  Monotonic polarity name (m' ++ m) (Typ.instantiate 0 (List.map (fun (name', P) => .var name') m') t) →
  Monotonic polarity name m (Typ.all bs cs t)
:= by sorry

theorem Monotonic.exi_intro :
  (∀ b ∈ bs , b = "") →
  List.length m' = List.length bs →
  List.Disjoint (Prod.dom m') (Prod.dom m) →
  (∀ name' ∈ Prod.dom m',
    EitherMultiMonotonic polarity name' (m' ++ m)
      (Typ.constraints_instantiate 0 (List.map (fun (name', P) => .var name') m') ((t,.top) :: cs))
  ) →
  Monotonic polarity name (m' ++ m) (Typ.instantiate 0 (List.map (fun (name', P) => .var name') m') t) →
  Monotonic polarity name m (Typ.all bs cs t)
:= by sorry


theorem Monotonic.lfp_intro :
  Monotonic polarity name m body →
  Monotonic polarity name m (Typ.lfp "" body)
:= by sorry


/-

Example of potential for generating procedures from derived rules

-- theorem Monotonic.iso_intro :
--   Monotonic polarity name m t →
--   Monotonic polarity name m (Typ.iso l t)
-- := by sorry


def Typ.compute_polarity (name : String) (m : List (String → (Expr → Prop))) : Typ → Option Bool
| .iso l t => Typ.compute_polarity name m t
| _ => none

-/


theorem Typing.var_elim :
  Typing m e (Typ.var name) →
  Safe e ∧ ∃ P, Stable P ∧ Prod.find name m = some P ∧ P e
:= by
  simp [Typing]

theorem Typing.var_intro :
  Safe e → Stable P →
  Prod.find name m = some P → P e →
  Typing m e (Typ.var name)
:= by
  simp [Typing]
  intro h0 h1 h2 h3
  simp [*]

theorem Typing.iso_elim :
  Typing am e (Typ.iso l t) →
  Safe e ∧ Typing am (Expr.extract e l) t
:= by simp [Typing]

theorem Typing.iso_intro :
  Safe e →
  Typing m (Expr.extract e l) t →
  Typing m e (Typ.iso l t)
:= by
  simp [Typing]
  intro h0 h1
  simp [*]




theorem Typing.entry_intro l :
  Prod.keys_unique r →
  Safe (.record r) →
  (l,e) ∈ r →
  Typing am e t →
  Typing am (Expr.record r) (Typ.entry l t)
:= by
  simp [Typing, Expr.project]
  intro h0 h1 h2 h3
  simp [*]
  apply subject_expansion
  { apply NStep.pattern_match
    simp [*,Pattern.match, Pattern.match_record]
    apply Pattern.match_entry_bvar h0 h2
  }
  { simp [Expr.instantiate, Expr.shift_vars_zero]
    exact h3
  }

theorem Typing.inter_intro :
  Typing am e tl →
  Typing am e tr →
  Typing am e (Typ.inter tl tr)
:= by sorry


theorem Typing.inter_left_elim  :
  Subtyping m tl upper →
  Typing m e (Typ.inter tl tr) →
  Typing m e upper
:= by sorry


theorem Typing.inter_right_elim :
  Subtyping m tr upper →
  Typing m e (Typ.inter tl tr) → Typing m e upper
:= by sorry



theorem Typing.inter_entries_intro entries :
  Prod.keys_unique r →
  Safe (.record r) →
  (∀ l t, (l,t) ∈ entries → ∃ e, (l,e) ∈ r ∧ Typing am e t) →
  Typing am (Expr.record r) (Typ.inter_entries entries)
:= by cases entries with
| nil =>
  simp [Typ.inter_entries, Typing]
| cons entry entries' =>
  have (l,t) := entry
  simp [Typ.inter_entries]
  intro h0 h1 h2
  apply Typing.inter_intro
  { specialize h2 l t
    simp [*] at h2
    have ⟨e,h3,h4⟩ := h2
    exact entry_intro l h0 h1 h3 h4
  }
  { apply Typing.inter_entries_intro _ h0 h1
    intro l' t' h3
    apply h2
    apply Or.inr h3
  }



/-
TODO: update to
theorem Typing.inter_entries_intro :

restrict type to intersection of entries
-/

-- theorem Typing.record_cons_tail_elim :
--   Safe e →
--   Prod.key_fresh l r →
--   (∀ te , Typing am e te  →
--     /- require that type (.entry l te) has not been negated in type tr -/
--     ∃ e' , Typing am e' (.inter (.entry l te) tr)
--    ) →
--   Typing am (.record r) tr  →
--   Typing am (.record ((l, e) :: r)) tr
-- := by cases tr with
-- | bvar i =>
--   simp [Typing]
-- | var name =>
--   intro h0 h1 h2
--   simp [Typing]
--   intro h3 P h4 h5 h6
--   simp [*]
--   apply And.intro (Safe.record_cons_intro h3 h0)
--   sorry
-- | _ =>
--   sorry






theorem Typing.top_elim :
  Typing m e Typ.top →
  Safe e
:= by
  simp [Typing]

theorem Typing.top_intro :
  Safe e →
  Typing m e Typ.top
:= by
  simp [Typing]



-- theorem Typing.path_intro :
--   Typ.wellformed tp →
--   (∀ ep ,
--     Typing am ep tp →
--     ∃ eam , Pattern.match ep p = .some eam ∧ Typing am (Expr.instantiate 0 eam e) te
--   ) →
--   Typing am (Expr.function ((p, e) :: f)) (Typ.path tp te)
-- := by
--   intro h0 h1
--   simp [Typing]
--   apply And.intro
--   { apply Safe.function }
--   { apply And.intro h0
--     intro arg h3
--     have ⟨eam,h5,h6⟩ := h1 arg h3
--     apply subject_expansion
--     { exact NStep.pattern_match e f h5 }
--     { exact h6 }
--   }

def FunMatchedTyping (am : List (String × (Expr → Prop))) (f : List (Pattern × Expr)) (tp te : Typ): Prop :=
  (∀ p e, (p, e) ∈ f →
    (∀ ep , Typing am ep tp →
      ∀ eam , Pattern.match ep p = .some eam → Typing am (Expr.instantiate 0 eam e) te
    )
  )

def FunMatching (am : List (String × (Expr → Prop))) (f : List (Pattern × Expr)) (tp :Typ) : Prop :=
  ∃ p e , (p,e) ∈ f ∧ (∀ ep , Typing am ep tp → Pattern.matches ep p)

theorem Typing.path_intro :
  Typ.wellformed tp →
  fp <+: f →
  FunMatchedTyping am fp tp te →
  FunMatching am fp tp →
  Typing am (Expr.function f) (Typ.path tp te)
:= by
  simp [List.IsPrefix]
  intro h0 fs h1 h2 h3
  rw [←h1]
  cases fp with
  | nil =>
    simp [FunMatching] at h3
  | cons pe fp' =>
    have (p,e) := pe
    simp [FunMatchedTyping] at h2
    simp [FunMatching] at h3
    have ⟨p',⟨e',h4⟩,h5⟩ := h3
    clear h3
    specialize h2 p' e' h4
    cases h4 with
    | inl h6 =>
      have ⟨h7,h8⟩ := h6
      rw [h7,h8] at h2
      rw [h7] at h5
      clear h7 h8
      have h9 :
        (p,e) :: fp' ++ fs  = (p,e) :: (fp' ++ fs)
      := by exact rfl
      rw [h9]
      simp [Typing]
      simp [*]
      apply And.intro
      { exact Safe.function ((p, e) :: (fp' ++ fs)) }
      {
        intro arg h10
        specialize h2 arg h10
        specialize h5 arg h10
        have ⟨m,h11⟩ := Pattern.matches_some h5
        specialize h2 m h11
        apply subject_expansion
        { apply NStep.pattern_match _ _ h11 }
        { exact h2 }
      }
    | inr h6 =>
      sorry


theorem Typing.inter_paths_intro :
  (∀ tp te, (tp,te) ∈ paths →
    Typ.wellformed tp ∧ ∃ fp , fp <+: f ∧ FunMatchedTyping am fp tp te ∧ FunMatching am fp tp
  ) →
  Typing am (Expr.function f) (Typ.inter_paths paths)
:= by cases paths with
| nil =>
  simp [Typ.inter_paths]
  apply Typing.top_intro
  exact Safe.function f
| cons path paths' =>
  have (tp,te) := path
  simp [Typ.inter_paths]
  intro h0
  apply Typing.inter_intro
  {
    specialize h0 tp te
    simp at h0
    have ⟨h1,fp,h3,h4,h5⟩ := h0
    apply Typing.path_intro h1 h3 h4 h5
  }
  { sorry }



/-
TODO: update to
theorem Typing.inter_paths_intro :

restrict type to intersection of paths
-/

-- theorem Typing.function_cons_elim :
--   Typing am (.function [(p,e)]) upper →
--   Typing am (.function f) upper  →
--   Typing am (.function ((p, e) :: f)) upper
-- := by
--   sorry

-- theorem Typing.function_cons_tail_elim :
--   (∀ {p' e'}, (p',e') ∈ f → Pattern.Disjoint p p') →
--   (∀ th , Typing am (.function [(p,e)]) th →
--     /- require that type tf has not been negated in type tf -/
--     ∃ e' , Typing am e' (.inter th tf)
--   ) →
--   Typing am (.function f) tf  →
--   Typing am (.function ((p, e) :: f)) tf
-- := by
--   sorry



theorem Typing.path_elim
  (typing_cator : Typing am ef (.path t t'))
  (typing_arg : Typing am ea t)
: Typing am (.app ef ea) t'
:= by
  simp [Typing] at typing_cator
  have ⟨h0,h1,h2⟩ := typing_cator
  exact h2 ea typing_arg





theorem Typing.unio_elim :
  Typing m e (Typ.unio tl tr) →
  Typing m e tl ∨ Typing m e tr
:= by simp [Typing]

theorem Typing.unio_left_intro tr :
  Typing am e tl →
  Typing am e (Typ.unio tl tr)
:= by sorry


theorem Typing.unio_right_intro tl :
  Typing am e tr →
  Typing am e (Typ.unio tl tr)
:= by sorry


theorem Typing.list_diff_elim :
  Typing am e (Typ.list_diff tp subtras) →
  Typing am e tp
:= by
  sorry



theorem Typing.anno_intro {am e t ta} :
  Subtyping am t ta →
  Typing am e t →
  Typing am (.anno e ta) ta
:= by sorry

theorem Typing.lfp_elim :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name am (Typ.instantiate 0 [.var name] t) →
  (Typing ((name, P) :: am) e (Typ.instantiate 0 [Typ.var name] t) → P e) →
  Typing am e (Typ.lfp "" t) → P e
:= by sorry

theorem Typing.lfp_intro :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name m (Typ.instantiate 0 [.var name] t) →
  Typing m e (Typ.instantiate 0 [(Typ.lfp "" t)] t) →
  Typing m e (Typ.lfp "" t)
:= by
  simp [Typing]
  intro h0 h1 h2 h3
  apply And.intro
  { exact Typing.safety h3 }
  { exists name
    simp [*]
    sorry
    -- intro P h4 h5

    -- apply h5
    -- have h6 := h2
    -- unfold Monotonic at h6
    -- apply h6 (fun e => Typing am e (Typ.lfp "" t)) P
    -- {
    --   intro e h7
    --   apply Typing.lfp_elim  h0 h1 h2 (h5 e)
    --   exact h7
    -- }
    -- { apply Typing.named_instantiation h0
    --   { simp [Typ.free_vars]
    --     /- TODO -/
    --     sorry
    --   }
    --   { exact h3 }
    -- }
  }






theorem Subtyping.iso_pres {am bodyl bodyu} l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.iso l bodyl) (Typ.iso l bodyu)
:= by sorry


theorem Subtyping.entry_pres :
  Subtyping am t t' →
  Subtyping am (.entry l t) (.entry l t')
:= by
  simp [Subtyping]
  simp [Typ.instantiated, Typ.wellformed, Typ.num_bound_vars, Typ.nameless]
  simp [Typing]
  intro h0 h1 h2
  apply And.intro ⟨h0,h1⟩
  intro e h3 h4
  exact ⟨h3, h2 (Expr.project e l) h4⟩



theorem Subtyping.path_pres {am p q x y} :
  Subtyping am x p →
  Subtyping am q y →
  Subtyping am (Typ.path p q) (Typ.path x y)
:= by sorry


theorem Subtyping.bot_elim {am upper} :
  Subtyping am Typ.bot upper
:= by sorry

theorem Subtyping.top_intro {am lower} :
  Subtyping am lower Typ.top
:= by sorry


theorem Subtyping.unio_elim  :
  Subtyping m tl t →
  Subtyping m tr t →
  Subtyping m (Typ.unio tl tr) t
:= by sorry

theorem Subtyping.unio_left_intro m tl tr :
  Subtyping m lower tl →
  Subtyping m lower (Typ.unio tl tr)
:= by sorry

theorem Subtyping.unio_right_intro m tr tl :
  Subtyping m lower tr →
  Subtyping m lower (Typ.unio tl tr)
:= by sorry


theorem Subtyping.inter_left_elim m tl tr :
  Subtyping m tl upper →
  Subtyping m (Typ.inter tl tr) upper
:= by sorry


theorem Subtyping.inter_right_elim m tl tr :
  Subtyping m tr upper →
  Subtyping m (Typ.inter tl tr) upper
:= by sorry

theorem Subtyping.inter_intro {am t left right} :
  Subtyping am t left →
  Subtyping am t right →
  Subtyping am t (Typ.inter left right)
:= by sorry

theorem Subtyping.unio_antec {am t left right upper} :
  Subtyping am t (Typ.path left upper) →
  Subtyping am t (Typ.path right upper) →
  Subtyping am t (Typ.path (Typ.unio left right) upper)
:= by sorry

theorem Subtyping.inter_conseq {am t upper left right} :
  Subtyping am t (Typ.path upper left) →
  Subtyping am t (Typ.path upper right) →
  Subtyping am t (Typ.path upper (Typ.inter left right))
:= by sorry

theorem Subtyping.inter_entry {am t l left right} :
  Subtyping am t (Typ.entry l left) →
  Subtyping am t (Typ.entry l right) →
  Subtyping am t (Typ.entry l (Typ.inter left right))
:= by sorry




theorem Subtyping.diff_elim {am lower sub upper} :
  Subtyping am lower (Typ.unio sub upper) →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry



theorem Subtyping.diff_sub_elim {am lower upper} sub:
  Subtyping am lower sub →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry

theorem Subtyping.diff_upper_elim {am lower upper} sub:
  Subtyping am lower upper →
  Subtyping am (Typ.diff lower sub) upper
:= by sorry



theorem Subtyping.diff_intro {am t left right} :
  Subtyping am t left →
  ¬ (Subtyping am t right) →
  ¬ (Subtyping am right t) →
  Subtyping am t (Typ.diff left right)
:= by sorry

theorem Subtyping.list_diff_elim :
  Subtyping am tp upper →
  Subtyping am (Typ.list_diff tp subtras) upper
:= by
  sorry


-- theorem Subtyping.exi_intro {am am' t ids quals body} :
--   Prod.dom am' ⊆ ids →
--   MultiSubtyping (am' ++ am) quals →
--   Subtyping (am' ++ am) t body →
--   Subtyping am t (Typ.exi ids quals body)
-- := by sorry


theorem Subtyping.exi_intro {am t ids quals body} :
  MultiSubtyping am quals →
  Subtyping am t body →
  Subtyping am t (Typ.exi ids quals body)
:= by sorry

theorem Subtyping.exi_elim {am ids quals body t} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    Prod.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) body t
  ) →
  Subtyping am (Typ.exi ids quals body) t
:= by sorry

-- theorem Subtyping.all_elim {am am' ids quals body t} :
--   Prod.dom am' ⊆ ids →
--   MultiSubtyping (am' ++ am) quals →
--   Subtyping (am' ++ am) body t →
--   Subtyping am (Typ.all ids quals body) t
-- := by sorry

theorem Subtyping.all_elim {am ids quals body t} :
  MultiSubtyping am quals →
  Subtyping am body t →
  Subtyping am (Typ.all ids quals body) t
:= by sorry

theorem Subtyping.all_intro {am t ids quals body} :
  ids ∩ Typ.free_vars t = [] →
  (∀ am',
    Prod.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) t body
  ) →
  Subtyping am t (Typ.all ids quals body)
:= by sorry


/- Subtyping induction -/
theorem Subtyping.lfp_elim :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name am (Typ.instantiate 0 [.var name] t) →
  Subtyping am (Typ.instantiate 0 [tr] t) tr →
  Subtyping am (Typ.lfp "" t) tr
:= by
  sorry


/- Subtyping recycling -/
theorem Subtyping.lfp_intro :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name am (Typ.instantiate 0 [.var name] t) →
  Subtyping am lower (Typ.instantiate 0 [(Typ.lfp "" t)] t) →
  Subtyping am lower (Typ.lfp "" t)
:= by
  sorry



end Lang
