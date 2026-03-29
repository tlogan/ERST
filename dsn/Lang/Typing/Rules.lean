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
import Lang.Typing.Instantiation

set_option pp.fieldNotation false
set_option eval.pp false

namespace Lang

theorem Subtyping.refl am t :
  Typ.wellformed t →
  Subtyping am t t
:= by
  simp [Subtyping]


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

theorem PosMonotonic.bvar_intro :
  PosMonotonic name m (Typ.bvar i)
:= by
  simp [PosMonotonic, Typing]



theorem PosMonotonic.var_intro :
  PosMonotonic name m (Typ.var name')
:= by
  simp [PosMonotonic]
  intro P0 P1 stable_P0 stable_P1 h0
  clear stable_P0
  simp [Typing, Prod.find]
  by_cases h1 : name = name'
  { simp [h1] ; clear h1
    intro e h2 P h3 h4 h5
    simp [*]
  }
  { simp [h1] ; clear h1
    intro e h1 P h2 h3 h4
    simp [*]
  }

theorem NegMonotonic.var_intro :
  name ≠ name' →
  NegMonotonic name m (Typ.var name')
:= by
  intro h0
  simp [NegMonotonic]
  simp [Typing, Prod.find, h0]


theorem Typing.env_weakening_generalizaiton :
  (Typing m e t → Typing m' e t) →
  (∀ e , Typing m e t → Typing m' e t)
:= by sorry

theorem PosMonotonic.iso_elim :
  PosMonotonic name m (Typ.iso l t) →
  PosMonotonic name m t
:= by
  simp [PosMonotonic,Typing, Expr.extract]
  intro h0 P0 P1 stable_P0 stable_P1 h4 e h5
  specialize h0 P0 P1 stable_P0 stable_P1 h4 e (Typing.safety h5)
  simp [Typing.safety h5] at h0
  apply Typing.env_weakening_generalizaiton h0 e h5

theorem PosMonotonic.iso_intro :
  PosMonotonic name m t →
  PosMonotonic name m (Typ.iso l t)
:= by
  simp [PosMonotonic]
  intro h0 P0 P1 stable_P0 stable_P1 h4 e
  simp [Typing]
  intro h5 h6
  simp [*]
  apply h0 P0 P1 stable_P0 stable_P1 h4 _ h6

theorem Monotonic.entry_intro :
  PosMonotonic name m t →
  PosMonotonic name m (Typ.entry l t)
:= by
  simp [PosMonotonic]
  intro h0 P0 P1 stable_P0 stable_P1 h4 e
  simp [Typing]
  intro h5 h6
  simp [*]
  apply h0 P0 P1 stable_P0 stable_P1 h4 _ h6

theorem PosMonotonic.path_intro :
  NegMonotonic name m tl →
  PosMonotonic name m tr →
  PosMonotonic name m (Typ.path tl tr)
:= by
  simp [NegMonotonic,PosMonotonic]
  intro h0 h1 P0 P1 stable_P0 stable_P1 h2 e
  simp [Typing]
  intro h3 h4 h5
  simp [*]
  intro arg h6
  apply h1 P0 P1 stable_P0 stable_P1 h2
  apply h5 arg
  apply h0 P0 P1 stable_P0 stable_P1 h2
  apply h6

theorem PosMonotonic.bot_intro :
  PosMonotonic name m (Typ.bot)
:= by
  simp [PosMonotonic,Typing]

theorem PosMonotonic.top_intro :
  PosMonotonic name m (Typ.top)
:= by
  simp [PosMonotonic, Typing]


theorem PosMonotonic.unio_intro :
  PosMonotonic name m tl →
  PosMonotonic name m tr →
  PosMonotonic name m (Typ.unio tl tr)
:= by
  simp [PosMonotonic]
  intro h0 h1 P0 P1 stable_P0 stable_P1 h2 e
  simp [Typing]
  intro h3
  cases h3 with
  | inl h4 =>
    apply Or.inl
    apply h0 P0 P1 stable_P0 stable_P1 h2 e h4
  | inr h4 =>
    apply Or.inr
    apply h1 P0 P1 stable_P0 stable_P1 h2 e h4

theorem PosMonotonic.inter_intro :
  PosMonotonic name m tl →
  PosMonotonic name m tr →
  PosMonotonic name m (Typ.inter tl tr)
:= by
  simp [PosMonotonic]
  intro h0 h1 P0 P1 stable_P0 stable_P1 h2 e
  simp [Typing]
  intro h3 h4
  apply And.intro
  { apply h0 P0 P1 stable_P0 stable_P1 h2 e h3 }
  { apply h1 P0 P1 stable_P0 stable_P1 h2 e h4  }

theorem PosMonotonic.diff_intro :
  PosMonotonic name m tl →
  NegMonotonic name m tr →
  PosMonotonic name m (Typ.diff tl tr)
:= by
  simp [PosMonotonic,NegMonotonic]
  intro h0 h1 P0 P1 stable_P0 stable_P1 h2 e
  simp [Typing]
  intro h3 h4 h5
  simp [*]
  apply And.intro
  { apply h0 P0 P1 stable_P0 stable_P1 h2 e h4 }
  { intro h6
    apply h5
    apply h1 P0 P1 stable_P0 stable_P1 h2 e h6
  }

theorem PosMonotonic.all_intro :
  (∀ b ∈ bs , b = "") →
  List.length m' = List.length bs →
  List.Disjoint (Prod.dom m') (Prod.dom m) →
  (∀ name' ∈ Prod.dom m',
    EitherMultiMonotonic name' (m' ++ m)
      (Typ.constraints_instantiate 0 (List.map (fun (name', P) => .var name') m') ((.bot,t) :: cs))
  ) →
  PosMonotonic name (m' ++ m) (Typ.instantiate 0 (List.map (fun (name', P) => .var name') m') t) →
  PosMonotonic name m (Typ.all bs cs t)
:= by sorry

-- theorem PosMonotonic.exi_intro :
--   (∀ b ∈ bs , b = "") →
--   List.length m' = List.length bs →
--   List.Disjoint (Prod.dom m') (Prod.dom m) →
--   (∀ name' ∈ Prod.dom m',
--     EitherMultiMonotonic name' (m' ++ m)
--       (Typ.constraints_instantiate 0 (List.map (fun (name', P) => .var name') m') ((t,.top) :: cs))
--   ) →
--   PosMonotonic name (m' ++ m) (Typ.instantiate 0 (List.map (fun (name', P) => .var name') m') t) →
--   PosMonotonic name m (Typ.exi bs cs t)
-- := by sorry

mutual
  theorem PosMonotonic.env_generalization :
    PosMonotonic name ((name',P) :: m) t →
    ∀ P, PosMonotonic name ((name',P) :: m) t
  := by cases t with
  | bvar i =>
    simp [PosMonotonic,Typing]
  | var name'' =>
    simp [PosMonotonic,Typing]
    intro h0 P' P0 P1 stable_P0 stable_P1 h2 e h3 P'' stable''
    simp [Prod.find]
    by_cases h4 : name = name''
    { simp [h4]
      intro h5 h6
      simp [*]
    }
    { simp [h4]
      by_cases h5 : name' = name''
      { simp [h5]
        intro h6 h7
        simp [*]
      }
      { simp [h5]
        intro h6 h7
        simp [*]
      }
    }
  | bot =>
    simp [PosMonotonic,Typing]
  | top =>
    simp [PosMonotonic,Typing]

  | iso l body =>
    intro h0 P'
    apply PosMonotonic.iso_intro
    apply PosMonotonic.env_generalization
    apply PosMonotonic.iso_elim h0
  | lfp a body =>
    intro h0 P'
    apply PosMonotonic.lfp_intro
    intro name'' P''
    apply PosMonotonic.lfp_elim at h0
    apply PosMonotonic.env_cons_swap
    { sorry }
    apply PosMonotonic.env_generalization
    apply PosMonotonic.env_cons_swap
    { sorry }
    apply h0 name'' P''

  | _ => sorry
  termination_by (Typ.size t)
  decreasing_by
    all_goals sorry

  theorem PosMonotonic.lfp_elim :
    PosMonotonic name m (Typ.lfp a body) →
    (∀ name' P,
      PosMonotonic name
        ((name',P) :: m)
        (Typ.instantiate 0 [Typ.var name'] body)
    )
  := by
    sorry
  termination_by (Typ.size body)
  decreasing_by
    sorry

  theorem PosMonotonic.lfp_intro :
    (∀ name' P,
      PosMonotonic name
        ((name',P) :: m)
        (Typ.instantiate 0 [Typ.var name'] body)
    ) →
    PosMonotonic name m (Typ.lfp a body)
  := by
    simp [PosMonotonic]
    intro h0 P0 P1 stable_P0 stable_P1 h1 e
    simp [Typing]
    intro h2 h3
    simp [*]
    intro h4 name' h5
    simp [Prod.dom] at h4 h5
    have ⟨h6,h7⟩ := h5 ; clear h5
    have ⟨h8,h9⟩ := h4 name' h6 h7
    apply And.intro
    { exact PosMonotonic.env_generalization h8 P1 }
    {
      intro P stable h10
      apply h9 P stable
      intro  e' h11
      apply h10
      apply Typing.env_cons_swap
      { intro h12 ; apply h6 (Eq.symm h12) }
      apply h0 name' P P0 P1 stable_P0 stable_P1 h1
      apply Typing.env_cons_swap
      { intro h12 ; exact h6 h12 }
      exact h11
    }
  termination_by (Typ.size body)
  decreasing_by
    sorry

end




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

theorem Typing.unio_left_intro  :
  Typing m e tl →
  Typing m e (Typ.unio tl tr)
:= by
  simp [Typing]
  apply Or.inl

theorem Typing.unio_right_intro  :
  Typing m e tr →
  Typing m e (Typ.unio tl tr)
:= by
  simp [Typing]
  apply Or.inr

theorem Typing.unio_elim :
  (Typing am e tl → Typing am e upper) →
  (Typing am e tr → Typing am e upper) →
  Typing am e (Typ.unio tl tr) → Typing am e upper
:= by
  simp [Typing]
  intro h0 h1 h2
  cases h2 with
  | inl h3 =>
    exact h0 h3
  | inr h3 =>
    exact h1 h3


theorem Typing.inter_intro :
  Typing am e tl →
  Typing am e tr →
  Typing am e (Typ.inter tl tr)
:= by
  simp [Typing]
  intro h0 h1
  exact ⟨h0, h1⟩


theorem Typing.inter_left_elim  :
  (Typing m e tl → Typing m e upper) →
  Typing m e (Typ.inter tl tr) → Typing m e upper
:= by
  simp [Typing]
  intro h0 h1 h2
  exact h0 h1



theorem Typing.inter_right_elim :
  (Typing m e tr → Typing m e upper) →
  Typing m e (Typ.inter tl tr) → Typing m e upper
:= by
  simp [Typing]
  intro h0 h1 h2
  exact h0 h2


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


def FunMatchedTyping (am : List (String × (Expr → Prop))) (f : List (Pattern × Expr)) (tp te : Typ): Prop :=
  ∀ p e, (p, e) ∈ f →
  ∀ ep , Typing am ep tp →
  ∀ ep', ReflTrans NStep ep ep' →
  (
    (∃ eam , Pattern.match ep' p = .some eam  ∧ Typing am (Expr.instantiate 0 eam e) te)
    ∨
    (Pattern.match ep' p = none ∧ Expr.valued ep')
  )

theorem FunMatchedTyping.cons_reflection :
  FunMatchedTyping m ((p,e) :: f) tp te →
  FunMatchedTyping m f tp te
:= by
  simp [FunMatchedTyping]
  intro h0 p' e' h1 arg h2 arg' h3
  apply h0 p' e' (Or.inr h1) arg h2 arg' h3


def FunMatching (am : List (String × (Expr → Prop))) (f : List (Pattern × Expr)) (tp :Typ) : Prop :=
  ∃ p e , (p,e) ∈ f ∧ (∀ ep , Typing am ep tp → ∃ ep', ReflTrans NStep ep ep' ∧ Pattern.matches ep' p)

theorem FunMatching.cons_reflection :
  Typing m arg tp →
  Pattern.match arg p = none →
  Expr.valued arg →
  FunMatching m ((p,e) :: f) tp →
  FunMatching m f tp
:= by
  simp [FunMatching]
  intro h0 h1 h2 p' e' h3 h4
  cases h3 with
  | inl h5 =>
    have ⟨h6,h7⟩ := h5
    apply False.elim
    specialize h4 arg h0
    have ⟨arg',h8,h9⟩ := h4
    clear h4
    have ⟨m',h10⟩ := Pattern.matches_some h9
    have h11 := NStep.refl_trans_skip_reduction h2 h8 h1
    rw [←h6] at h11
    rw [h11] at h10
    contradiction
  | inr h5 =>
    exists p'
    apply And.intro
    { exists e' }
    { exact fun ep a => h4 ep a }


theorem Typing.path_elim
  (typing_cator : Typing am ef (.path t t'))
  (typing_arg : Typing am ea t)
: Typing am (.app ef ea) t'
:= by
  simp [Typing] at typing_cator
  have ⟨h0,h1,h2⟩ := typing_cator
  exact h2 ea typing_arg


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
    have fmt := h2
    simp [FunMatchedTyping] at h2
    have fm := h3
    simp [FunMatching] at h3
    have ⟨p',⟨e',h4⟩,h5⟩ := h3
    clear h3
    simp [Typing]
    simp [*]
    apply And.intro
    { exact Safe.function ((p, e) :: (fp' ++ fs)) }
    { intro arg h6
      specialize h5 arg h6
      have ⟨arg',h7,h8⟩ := h5
      clear h5
      cases h4 with
      | inl h9 =>
        have ⟨h10,h11⟩ := h9
        rw [←h10,←h11]
        specialize h2 p' e' (Or.inl h9) arg h6 arg' h7
        clear h9 h10 h11
        have ⟨m,h13⟩ := Pattern.matches_some h8
        simp [h13] at h2
        apply Typing.refl_trans_subject_expansion
        { apply NStep.refl_trans_applicand _ h7 }
        {
          apply Typing.subject_expansion
          { apply NStep.pattern_match _ _ h13 }
          { exact h2 }
        }
      | inr h9 =>
        have h10 := h2 p e (Or.inl (And.intro rfl rfl)) arg h6 arg' h7
        have h11 := h2 p' e' (Or.inr h9) arg h6 arg' h7
        have ⟨m',h13⟩ := Pattern.matches_some h8
        simp [h13] at h11
        cases h10 with
        | inl h14 =>
          have ⟨m,h15,h16⟩ := h14
          clear h14
          apply Typing.refl_trans_subject_expansion
          { apply NStep.refl_trans_applicand _ h7 }
          {
            apply Typing.subject_expansion
            { apply NStep.pattern_match _ _ h15 }
            { exact h16 }
          }
        | inr h14 =>
          have ⟨h15,h16⟩ := h14
          clear h14
          apply Typing.refl_trans_subject_expansion
          { apply NStep.refl_trans_applicand _ h7 }
          {
            apply Typing.subject_expansion
            { apply NStep.skip _ _ h16 h15 }
            {
              apply Typing.path_elim
              {
                apply Typing.path_intro h0 (List.prefix_append fp' fs)
                { exact FunMatchedTyping.cons_reflection fmt }
                { apply FunMatching.cons_reflection
                  { apply Typing.refl_trans_subject_reduction h7 h6 }
                  { exact h15 }
                  { exact h16 }
                  { exact fm }
                }
              }
              { exact refl_trans_subject_reduction h7 h6 }
            }
          }

    }


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
  { apply Typing.inter_paths_intro
    intro tp' te' h1
    specialize h0 tp' te'
    simp [*]
  }


theorem Typing.diff_intro :
  Typ.wellformed right → Typing am e left →
  ¬ (Typing am e right) →
  Typing am e (Typ.diff left right)
:= by
  simp [Typing]
  intro h0 h1 h2
  simp [*]

theorem Typing.diff_minu_elim :
  (Typing am e minu → Typing am e upper) →
  Typing am e (Typ.diff minu subtra) →
  Typing am e upper
:= by
  simp [Typing]
  intro h0 h1 h2 h3
  exact h0 h2

theorem Typing.diff_subtra_elim :
  (Typing am e left → Typing am e subtra) →
  Typing am e (Typ.diff left subtra) →
  Typing am e upper
:= by
  simp [Typing]
  intro h0 h1 h2 h3
  exact False.elim (h3 (h0 h2))


theorem Typing.do_diff_minu_elim :
  (Typing am e minu → Typing am e upper) →
  Typing am e (Typ.do_diff minu subtra) →
  Typing am e upper
:= by sorry


theorem Typing.list_diff_minu_elim :
  (Typing am e minu → Typing am e upper) →
  Typing am e (Typ.list_diff minu subtras) →
  Typing am e upper
:= by cases subtras with
| nil =>
  simp [Typ.list_diff]
| cons subtra subtras' =>
  simp [Typ.list_diff]
  intro h0 h1
  apply Typing.list_diff_minu_elim
  {
    intro h2
    apply Typing.do_diff_minu_elim h0 h2
    exact (Typ.capture subtra)
  }
  { exact h1 }



theorem Typing.exi_intro :
  (∀ a ∈ bs , a = "") →
  (∀ names, List.length names = List.length bs → List.Disjoint names (Prod.dom am) →
    ∃ am' , Prod.dom am' = names ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
    (Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body))
  ) →
  Typing am e (Typ.exi bs cs body)
:= by
  simp [Typing]
  intro h0 h1
  apply And.intro h0
  intro names h2 h3
  have ⟨am',h4,h5,h6⟩ := h1 names h2 h3
  exists am'

theorem Typing.exi_elim :
  List.length names = List.length bs →
  List.Disjoint names (Prod.dom am) →
  (∀ am',
    Prod.dom am' = names →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs) →
    Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body) →
    Typing am e upper
  ) →
  Typing am e (Typ.exi bs cs body) → Typing am e upper
:= by
  simp [Typing]
  intro h0 h1 h2 h3 h4
  have ⟨am',h5,h6,h7⟩ := h4 names h0 h1
  apply h2 _ h5 h6 h7


theorem Typing.all_intro :
  Safe e →
  (∀ a ∈ bs , a = "") →
  List.length names = List.length bs →
  List.Disjoint names (Prod.dom am) →
  (∀ am',
    Prod.dom am' = names →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs) →
    Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body)
  ) →
  Typing am e (Typ.all bs cs body)
:= by
  simp [Typing]
  intro h0 h1 h2 h3 h4
  simp [*]
  apply And.intro h1
  exists names

theorem Typing.all_elim :
  (∀ a ∈ bs , a = "") →
  (∀ names, List.length names = List.length bs → List.Disjoint names (Prod.dom am) →
    ∃ am' , Prod.dom am' = names ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
    (
      Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body) →
      Typing am e upper
    )
  ) →
  Typing am e (Typ.all bs cs body) →
  Typing am e upper
:= by
  simp [Typing]
  intro h0 h1 h2 h3 names h5 h6 h7
  have ⟨am',h8,h9,h10⟩ :=  h1 names h5 h6
  apply h10
  exact h7 am' h8 h9

theorem Typing.lfp_elim name :
  Typ.wellformed (Typ.lfp "" t) →
  Stable P →
  name ∉ Prod.dom m →
  PosMonotonic name m (Typ.instantiate 0 [.var name] t) →
  (∀ e, Typing ((name, P) :: m) e (Typ.instantiate 0 [Typ.var name] t) → P e) →
  Typing m e (Typ.lfp "" t) → P e
:= by
  intro h0 stable h1 h2 h3 h4
  have typing := h4
  simp [Typing] at h4
  have ⟨h6,h7⟩ := h4
  clear h4
  have ⟨h8,h9⟩ := h7 name h1
  apply h9 P stable h3


theorem Typing.lfp_intro :
  Typ.wellformed (Typ.lfp "" t) →
  (∀ name ∉ Prod.dom m , PosMonotonic name m (Typ.instantiate 0 [.var name] t)) →
  Typing m e (Typ.instantiate 0 [(Typ.lfp "" t)] t) →
  Typing m e (Typ.lfp "" t)
:= by
  simp [Typing]
  intro h0 h1 h2
  apply And.intro
  { exact Typing.safety h2 }
  {
    intro name fresh
    apply And.intro (h1 name fresh)
    intro P stable h3
    apply h3
    have h6 := (h1 name fresh)
    simp [PosMonotonic] at h6
    apply h6 (fun e => Typing m e (Typ.lfp "" t)) P
    {
      simp [Stable]
      intro e e' h7
      apply Iff.intro
      { intro h8
        exact subject_reduction h7 h8
      }
      { intro h8
        exact subject_expansion h7 h8
      }
    }
    { exact stable }
    {
      intro e' h7
      apply Typing.lfp_elim name h0 stable fresh (h1 name fresh) h3 h7
    }
    {
      apply Typing.named_instantiation
      {
        intro h8
        apply fresh
        apply Typing.free_vars_subset_env h2
        apply Typ.free_vars_instantiate_lower_bound _ _ h8
      }
      {
        simp [Typ.free_vars]
        intro fv h7
        apply Typing.free_vars_subset_env h2
        apply Typ.free_vars_instantiate_lower_bound _ _ h7
      }
      { exact fresh }
      { exact h0 }
      { exact h2 }
    }
  }



theorem Subtyping.iso_pres l :
  Subtyping am bodyl bodyu →
  Subtyping am (Typ.iso l bodyl) (Typ.iso l bodyu)
:= by
  simp [Subtyping]
  simp [Typ.instantiated, Typ.wellformed, Typ.num_bound_vars, Typ.nameless]
  simp [Typing]
  intro h0 h1 h2
  apply And.intro ⟨h0,h1⟩
  intro e h3 h4
  exact ⟨h3, h2 (Expr.extract e l) h4⟩


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
  Typ.wellformed p →
  Subtyping am x p →
  Subtyping am q y →
  Subtyping am (Typ.path p q) (Typ.path x y)
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3 h4
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h3
    simp [Typ.wellformed]
    simp [Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h5,h6⟩ := h0
    have ⟨h7,h8⟩ := h3
    apply And.intro ⟨h5, h7⟩ ⟨h6, h8⟩
  }
  { simp [Typing]
    intro e h5 h6 h7
    simp [*]
    intro arg h8
    exact h4 (Expr.app e arg) (h7 arg (h2 arg h8))
  }


theorem Subtyping.bot_elim {am upper} :
  Subtyping am Typ.bot upper
:= by
  simp [Subtyping]
  simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
  simp [Typing]


theorem Subtyping.top_intro {am lower} :
  Typ.wellformed lower →
  Subtyping am lower Typ.top
:= by
  simp [Subtyping]
  intro h0
  simp [*]
  simp [Typing]
  intro e h1
  exact Typing.safety h1


theorem Subtyping.unio_elim  :
  Subtyping m tl t →
  Subtyping m tr t →
  Subtyping m (Typ.unio tl tr) t
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h2
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h5,h6⟩ := h0
    have ⟨h7,h8⟩ := h2
    apply And.intro ⟨h5, h7⟩ ⟨h6, h8⟩

  }
  { simp [Typing]
    intro e h6
    cases h6 with
    | inl h7 =>
      exact h1 e h7
    | inr h7 =>
      exact h3 e h7
  }

theorem Subtyping.unio_left_intro tr :
  Subtyping m lower tl →
  Subtyping m lower (Typ.unio tl tr)
:= by
  simp [Subtyping]
  intro h0 h1
  simp [*]
  simp [Typing]
  intro e h2
  apply Or.inl (h1 e h2)

theorem Subtyping.unio_right_intro tl :
  Subtyping m lower tr →
  Subtyping m lower (Typ.unio tl tr)
:= by
  simp [Subtyping]
  intro h0 h1
  simp [*]
  simp [Typing]
  intro e h2
  apply Or.inr (h1 e h2)


theorem Subtyping.inter_left_elim :
  Typ.wellformed tr →
  Subtyping m tl upper →
  Subtyping m (Typ.inter tl tr) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h1
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h5,h6⟩ := h0
    have ⟨h7,h8⟩ := h1
    apply And.intro ⟨h7, h5⟩ ⟨h8, h6⟩
  }
  { simp [Typing]
    intro e h4 h5
    exact h2 e h4
  }



theorem Subtyping.inter_right_elim :
  Typ.wellformed tl →
  Subtyping m tr upper →
  Subtyping m (Typ.inter tl tr) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h1
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h5,h6⟩ := h0
    have ⟨h7,h8⟩ := h1
    apply And.intro ⟨h5, h7⟩ ⟨h6, h8⟩
  }
  { simp [Typing]
    intro e h4 h5
    exact h2 e h5
  }

theorem Subtyping.inter_intro :
  Subtyping am t left →
  Subtyping am t right →
  Subtyping am t (Typ.inter left right)
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3
  simp [*]
  simp [Typing]
  intro e h4
  exact ⟨h1 e h4, h3 e h4⟩

theorem Subtyping.unio_antec :
  Subtyping am t (Typ.path left upper) →
  Subtyping am t (Typ.path right upper) →
  Subtyping am t (Typ.path (Typ.unio left right) upper)
:= by
  simp [Subtyping, Typing]
  intro h0 h1 h2 h3
  simp [*]
  intro e h4
  have ⟨h5,h6,h7⟩ := h1 e h4
  clear h1
  have ⟨h8,h9,h10⟩ := h3 e h4
  clear h3
  simp [*]
  apply And.intro
  {

    simp [Typ.wellformed, Typ.instantiated] at h6 h9
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]

    have ⟨h10,h11⟩ := h6
    have ⟨h12,h13⟩ := h9
    apply And.intro ⟨h10, h12⟩ ⟨h11, h13⟩
  }
  {
    intro arg h7
    cases h7 with
    | inl h8 =>
      exact h7 arg h8
    | inr h8 =>
      exact h10 arg h8
  }

theorem Subtyping.inter_conseq :
  Subtyping am t (Typ.path upper left) →
  Subtyping am t (Typ.path upper right) →
  Subtyping am t (Typ.path upper (Typ.inter left right))
:= by
  simp [Subtyping, Typing]
  intro h0 h1 h2 h3
  simp [*]
  intro e h4
  simp [*]
  have ⟨h5,h6,h7⟩ := h1 e h4
  have ⟨h8,h9,h10⟩ := h3 e h4
  simp [*]
  intro arg h11
  exact ⟨h7 arg h11, h10 arg h11⟩

theorem Subtyping.inter_entry :
  Subtyping am t (Typ.entry l left) →
  Subtyping am t (Typ.entry l right) →
  Subtyping am t (Typ.entry l (Typ.inter left right))
:= by
  simp [Subtyping, Typing]
  intro h0 h1 h2 h3
  simp [*]
  intro e h4
  simp [*]


theorem Subtyping.diff_minu_elim :
  Typ.wellformed subtra →
  Subtyping am minu upper →
  Subtyping am (Typ.diff minu subtra) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h1
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h3,h4⟩ := h0
    have ⟨h5,h6⟩ := h1
    apply And.intro ⟨h5, h3⟩ ⟨h6, h4⟩
  }
  {
    intro e h3
    exact Typing.diff_minu_elim (h2 e) h3
  }


theorem Subtyping.diff_subtra_elim upper :
  Typ.wellformed subtra →
  Subtyping am minu subtra →
  Subtyping am (Typ.diff minu subtra) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  apply And.intro
  {
    simp [Typ.wellformed, Typ.instantiated] at h0 h1
    simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless]
    have ⟨h3,h4⟩ := h0
    have ⟨h5,h6⟩ := h1
    apply And.intro ⟨h5, h3⟩ ⟨h6, h4⟩
  }
  {
    intro e h4
    exact Typing.diff_subtra_elim (h2 e) h4
  }



theorem Subtyping.diff_intro :
  Typ.wellformed subtra →
  Subtyping am lower minu →
  (∀ e, Typing am e lower → ¬ Typing am e subtra) →
  Subtyping am lower (Typ.diff minu subtra)
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3
  simp [*]
  intro e h4
  apply Typing.diff_intro h0 (h2 e h4)
  exact h3 e h4



-- theorem Typing.list_diff_minu_elim :
--   (Typing am e minu → Typing am e upper) →
--   Typing am e (Typ.list_diff minu subtras) →
--   Typing am e upper

theorem Subtyping.list_diff_minu_elim :
  Typ.list_wellformed subtras →
  Subtyping am minu upper →
  Subtyping am (Typ.list_diff minu subtras) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  apply And.intro
  {
    simp [Typ.wellformed_list_diff]
    simp [*]
  }
  { intro e h3
    exact Typing.list_diff_minu_elim (h2 e) h3
  }


theorem Subtyping.exi_intro :
  Typ.wellformed lower →
  (∀ a ∈ bs , a = "") →
  (∀ names, List.length names = List.length bs → List.Disjoint names (Prod.dom am) →
    ∃ am' , Prod.dom am' = names ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
    (∀ e,
      Typing am e lower →
      Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body)
    )
  ) →
  Subtyping am lower (Typ.exi bs cs body)
:= by
  simp [Subtyping]
  intro h0 h1 h2
  simp [*]
  intro e h4
  apply Typing.exi_intro h1
  intro names h5 h6
  have ⟨am',h7,h8,h9⟩ := h2 names h5 h6
  exists am'
  simp [*]


theorem Subtyping.exi_elim :
  Typ.wellformed (Typ.exi bs cs body) →
  List.length names = List.length bs →
  List.Disjoint names (Prod.dom am) →
  (∀ am',
    Prod.dom am' = names →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs) →
    ∀ e,
    Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body) →
    Typing am e upper
  ) →
  Subtyping am (Typ.exi bs cs body) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3
  simp [*]
  intro e h4
  apply Typing.exi_elim h1 h2
  {
    intro am' h5 h6 h7
    exact h3 am' h5 h6 e h7
  }
  { exact h4 }


theorem Subtyping.all_intro :
  Typ.wellformed lower →
  (∀ a ∈ bs , a = "") →
  List.length names = List.length bs →
  List.Disjoint names (Prod.dom am) →
  (∀ am',
    Prod.dom am' = names →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs) →
    ∀ e,
    Typing am e lower →
    Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body)
  ) →
  Subtyping am lower (Typ.all bs cs body)
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3 h4
  simp [*]
  intro e h6
  simp [Typing]
  apply And.intro (Typing.safety h6)
  apply And.intro h1
  exists names
  simp [*]
  intro am' h7 h8
  exact h4 am' h7 h8 e h6

theorem Subtyping.all_elim :
  Typ.wellformed (Typ.all bs cs body) →
  (∀ a ∈ bs , a = "") →
  (∀ names, List.length names = List.length bs → List.Disjoint names (Prod.dom am) →
    ∃ am' , Prod.dom am' = names ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
    (∀ e,
      Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body) →
      Typing am e upper
    )
  ) →
  Subtyping am (Typ.all bs cs body) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2
  simp [*]
  intro e h3
  apply Typing.all_elim h1
  {
    intro names h4 h5
    have ⟨am',h6,h7,h8⟩ := h2 names h4 h5
    exists am'
    simp [*]
    exact ⟨h7, h8 e⟩
  }
  { exact h3 }

/- Subtyping induction -/
theorem Subtyping.lfp_elim name :
  Typ.wellformed (Typ.lfp "" t) →
  Typ.wellformed upper →
  Typ.free_vars upper ⊆ Prod.dom m →
  name ∉ Prod.dom m →
  PosMonotonic name m (Typ.instantiate 0 [.var name] t) →
  Subtyping m (Typ.instantiate 0 [upper] t) upper →
  Subtyping m (Typ.lfp "" t) upper
:= by
  simp [Subtyping]
  intro h0 h1 h2 h3 h4 h5 h6
  simp [*]
  intro e h7
  have h8 : Typing m e upper = (fun e => Typing m e upper) e := by rfl
  rw [h8]
  generalize h9 : (fun e => Typing m e upper) = P
  apply Typing.lfp_elim name h0
  {
    simp [Stable]
    intro e' e'' h10
    rw [←h9]
    simp
    apply Iff.intro
    { intro h11 ; exact Typing.subject_reduction h10 h11 }
    { intro h11 ; exact Typing.subject_expansion h10 h11 }
  }
  { exact h3 }
  { exact h4 }
  { intro e' h11
    rw [←h9]
    simp
    apply h6
    simp [PosMonotonic] at h4

    have h12 : name ∉ Typ.free_vars t := by
      intro h12
      apply h3
      apply Typing.free_vars_subset_env h7
      exact h12

    apply Typing.nameless_instantiation h12 h2 h3 h1
    apply h4 P
    { rw [←h9]
      simp [Stable]
      intro e e' h13
      apply Iff.intro
      { intro h14
        exact Typing.subject_reduction h13 h14
      }
      { intro h14
        exact Typing.subject_expansion h13 h14
      }
    }
    { simp [Stable]
      intro e e' h13
      apply Iff.intro
      { intro h14
        exact Typing.subject_reduction h13 h14
      }
      { intro h14
        exact Typing.subject_expansion h13 h14
      }
    }
    { simp [←h9] }
    { exact h11 }

  }
  { exact h7 }


/- Subtyping recycling -/
theorem Subtyping.lfp_intro :
  Typ.wellformed (Typ.lfp "" t) →
  (∀ name ∉ Prod.dom m, PosMonotonic name m (Typ.instantiate 0 [.var name] t)) →
  Subtyping m lower (Typ.instantiate 0 [(Typ.lfp "" t)] t) →
  Subtyping m lower (Typ.lfp "" t)
:= by
  simp [Subtyping]
  intro wf_lfp monotonic wf_lower subtyping
  simp [*]
  intro e typing_lower
  apply Typing.lfp_intro wf_lfp monotonic (subtyping e typing_lower)

end Lang
