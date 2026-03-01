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

theorem Typing.lfp_elim :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name am (Typ.instantiate 0 [.var name] t) →
  (Typing ((name, P) :: am) e (Typ.instantiate 0 [Typ.var name] t) → P e) →
  Typing am e (Typ.lfp "" t) → P e
:= by sorry

/- Subtyping induction -/
theorem Subtyping.lfp_elim :
  Typ.wellformed (Typ.lfp "" body) →
  name ∉ Typ.free_vars body →
  PosMonotonic name am (Typ.instantiate 0 [.var name] body) →
  Subtyping am (Typ.instantiate 0 [t] body) t →
  Subtyping am (Typ.lfp "" body) t
:= by
  sorry

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

/- Subtyping recycling -/
theorem Subtyping.lfp_intro :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  PosMonotonic name am (Typ.instantiate 0 [.var name] t) →
  Subtyping am (Typ.instantiate 0 [(Typ.lfp "" t)] t) (Typ.lfp "" t)
:= by
  simp [Subtyping]
  simp [Typing]
  intro h0 h1 h2
  sorry


theorem Typing.unio_elim :
  Typing m e (Typ.unio tl tr) →
  Typing m e tl ∨ Typing m e tr
:= by simp [Typing]

theorem Subtyping.unio_elim  :
  Subtyping m tl t →
  Subtyping m tr t →
  Subtyping m (Typ.unio tl tr) t
:= by sorry

theorem Typing.unio_left_intro tr :
  Typing am e tl →
  Typing am e (Typ.unio tl tr)
:= by sorry


theorem Subtyping.unio_left_intro m tl tr :
  Subtyping m tl (Typ.unio tl tr)
:= by sorry


theorem Typing.unio_right_intro tl :
  Typing am e tr →
  Typing am e (Typ.unio tl tr)
:= by sorry


theorem Subtyping.unio_right_intro m tr tl :
  Subtyping m tr (Typ.unio tl tr)
:= by sorry


theorem Subtyping.inter_left_elim m tl tr :
  Subtyping m (Typ.inter tl tr) tl
:= by sorry


theorem Subtyping.inter_right_elim m tl tr :
  Subtyping m (Typ.inter tl tr) tr
:= by sorry




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


theorem Subtyping.iso_pres {am bodyl bodyu} l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.iso l bodyl) (Typ.iso l bodyu)
:= by sorry

theorem Subtyping.entry_pres {am bodyl bodyu} l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.entry l bodyl) (Typ.entry l bodyu)
:= by sorry

theorem Subtyping.path_pres {am p q x y} :
  Subtyping am x p →
  Subtyping am q y →
  Subtyping am (Typ.path p q) (Typ.path x y)
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


-- theorem Subtyping.exi_intro {am am' t ids quals body} :
--   Prod.dom am' ⊆ ids →
--   MultiSubtyping (am' ++ am) quals →
--   Subtyping (am' ++ am) t body →
--   Subtyping am t (Typ.exi ids quals body)
-- := by sorry

theorem Subtyping.lfp_skip_elim {am id body t} :
  id ∉ Typ.free_vars body →
  Subtyping am body t →
  Subtyping am (Typ.lfp id body) t
:= by sorry

theorem Subtyping.diff_intro {am t left right} :
  Subtyping am t left →
  ¬ (Subtyping am t right) →
  ¬ (Subtyping am right t) →
  Subtyping am t (Typ.diff left right)
:= by sorry


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





theorem Subtyping.bot_elim {am upper} :
  Subtyping am Typ.bot upper
:= by sorry

theorem Subtyping.top_intro {am lower} :
  Subtyping am lower Typ.top
:= by sorry


theorem Typing.empty_record_top am :
  Typing am (Expr.record []) Typ.top
:= by
  unfold Typing
  sorry
  -- apply Safe.record
  -- apply RecSafe.nil

theorem Typing.inter_entry_intro {am l e r body t} :
  Typing am e body →
  Typing am (.record r) t  →
  Typing am (Expr.record ((l, e) :: r)) (Typ.inter (Typ.entry l body) t)
:= by sorry



-- theorem Typing.path_determines_function
--   (typing : Typing am e (.path antec consq))
-- : ∃ f , ReflTrans NStep e (.function f)
-- := by sorry



-- theorem Expr.sub_sub_removal :
--   ids ⊆ Prod.dom eam0 →
--   (Expr.sub eam0 (Expr.sub (Prod.remove_all eam1 ids) e)) =
--   (Expr.sub (eam0 ++ eam1) e)
-- := by sorry





-- theorem Divergent.necxt_preservation :
--   NEvalCxt E →
--   Divergent e →
--   Divergent (E e)
-- := by
--   intro h0 h1 e' h2
--   generalize h3 : (E e) = eg at h1
--   rw [h3] at h2
--   revert e

--   induction h2 with
--   | refl eg =>
--     intro e h1 h2
--     rw [← h2]
--     specialize h1 e (NStepStar.refl e)
--     have ⟨e', h3⟩ := h1
--     exists (E e')
--     exact NStep.necxt h0 h3

--   | step eg em e' h4 h5 ih =>

--     intro e h1 h2
--     rw [← h2] at h4
--     clear h2
--     apply Divergent.transition at h1
--     have ⟨et, h6,h7⟩ := h1
--     apply ih h7
--     apply NStep.deterministic
--     { exact NStep.necxt h0 h6 }
--     { exact h4 }


theorem Typing.exists_value :
  Typing am e t →
  ∃ v , Expr.valued v ∧ Typing am v t
:= by sorry



theorem Typing.entry_intro l :
  Typing am e t →
  Typing am (Expr.record ((l, e) :: [])) (Typ.entry l t)
:= by
  intro h0
  unfold Typing
  apply And.intro
  { apply Safe.entry_intro _ (Typing.safety h0) }
  { exact subject_expansion NStep.project h0 }

theorem Subtyping.elimination :
  Subtyping am t0 t1 →
  Typing am e t0 →
  Typing am e t1
:= by
  simp [Subtyping]
  intro h0 h1 h2
  exact h1 e h2

theorem Subtyping.list_typ_diff_elim :
  Subtyping am (List.typ_diff tp subtras) tp
:= by
  sorry


theorem Typing.path_intro :
  Typ.wellformed tp →
  Typ.list_wellformed subtras →
  (∀ e' ,
    Typing am e' tp →
    ∃ eam , Pattern.match e' p = .some eam ∧ Typing am (Expr.instantiate 0 eam e) tr
  ) →
  Typing am (Expr.function ((p, e) :: f)) (Typ.path (List.typ_diff tp subtras) tr)
:= by
  intro h0 h1 h2
  simp [Typing]
  apply And.intro
  { apply Safe.function }
  {
    apply And.intro sorry

    intro arg h3
    have h4 := Subtyping.elimination Subtyping.list_typ_diff_elim h3
    have ⟨eam,h5,h6⟩ := h2 arg h4

    have h1 : NStep (Expr.app (Expr.function ((p, e) :: f)) arg) (Expr.instantiate 0 eam e) := by
      exact NStep.pattern_match e f h5
    exact subject_expansion h1 h6
  }


theorem Typing.function_preservation {am p tp e f t } :
  (∀ {v} , Typing am v tp → ∃ eam , Pattern.match v p = .some eam) →
  ¬ Subtyping am t (.path tp .top) →
  Typing am (.function f) t →
  Typing am (.function ((p,e) :: f)) t
:= by sorry


theorem Typing.star_preservation :
  ReflTrans NStep e e' →
  Typing am e t →
  Typing am e' t
:= by sorry


theorem Typing.path_elim
  (typing_cator : Typing am ef (.path t t'))
  (typing_arg : Typing am ea t)
: Typing am (.app ef ea) t'
:= by
  simp [Typing] at typing_cator
  have ⟨h0,h1,h2⟩ := typing_cator
  exact h2 ea typing_arg

theorem Typing.loop_path_elim {am e t} id :
  Typing am e (.path (.var id) t) →
  Typing am (.loopi e) t
:= by
  sorry

theorem Typing.anno_intro {am e t ta} :
  Subtyping am t ta →
  Typing am e t →
  Typing am (.anno e ta) ta
:= by sorry


theorem fresh_ids n (ignore : List String) :
  ∃ ids , ids.length = n ∧ ids ∩ ignore = []
:= by sorry
-- TODO: concat all the existing strings together and add numbers

theorem fresh_id (ignore : List String) :
  ∃ id ,id ∉ ignore
:= by sorry


theorem MultiSubtyping.removeAll_removal {tam assums assums'} :
  MultiSubtyping tam assums →
  MultiSubtyping tam (List.removeAll assums' assums) →
  MultiSubtyping tam assums'
:= by sorry



theorem Subtyping.entry_preservation :
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



theorem Typing.joinable_preservation {a b am t} :
  Joinable (ReflTrans NStep) a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Typing.joinable_reflection {a b am t} :
  Joinable (ReflTrans NStep) a b →
  Typing am b t →
  Typing am a t
:= by
  intro h0 h1
  apply Typing.joinable_preservation
  { apply Joinable.symm h0 }
  { exact h1 }



end Lang
