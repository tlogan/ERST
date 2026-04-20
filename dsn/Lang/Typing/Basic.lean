import Lean
-- import Mathlib.Tactic.Linarith

import Lang.List.Basic
import Lang.String.Basic
import Lang.ReflTrans.Basic
import Lang.Joinable.Basic
import Lang.Typ.Basic
import Lang.Expr.Basic
import Lang.NStep.Basic
import Lang.Safe.Basic

set_option pp.fieldNotation false
set_option eval.pp false

namespace Lang



def Stable (P : Expr → Prop) : Prop :=
  ∀ {e e'}, NStep e e' → (P e ↔ P e')

theorem Stable.subject_reduction :
  Stable P →
  NStep e e' →
  P e → P e'
:= by
  unfold Stable
  intro h0 h1 h2
  apply Iff.mp (h0 h1) h2


theorem Stable.subject_expansion :
  Stable P →
  NStep e e' →
  P e' → P e
:= by
  unfold Stable
  intro h0 h1 h2
  apply Iff.mpr (h0 h1) h2


mutual
  def Subtyping (tmp : String) (am : List (String × (Expr → Prop))) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing tmp am e left → Typing tmp am e right
  termination_by (Typ.size left + Typ.size right, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])


  def MultiSubtyping (tmp : String) (am : List (String × (Expr → Prop))) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping tmp am left right ∧ MultiSubtyping tmp am remainder
  termination_by sts => (List.pair_typ_size sts, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])

  def PosMonotonic (name : String) (tmp : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
    (∀ P0 P1 : Expr → Prop,
      Stable P0 → Stable P1 →
      (∀ e, P0 e → P1 e) →
      (∀ e , Typing tmp ((name,P0)::am) e t → Typing tmp ((name,P1)::am) e t)
    )
  termination_by (Typ.size t, 1)


  -- TODO: need to add a tvars field for named instantiation
  def Typing (tmp : String) (am : List (String × (Expr → Prop))) (e : Expr) : Typ → Prop
  | .var id => Safe e ∧ ∃ P, Stable P ∧ Prod.find id am = some P ∧ P e
  | .bvar _ => False
  | .bot => False
  | .top => Safe e
  | .iso l t => Safe e ∧ Typing tmp am (.extract e l) t
  | .entry l t => Safe e ∧ Typing tmp am (.project e l) t
  | .path left right =>
    Safe e ∧
    ∀ arg , Typing tmp am arg left → Typing tmp am (.app e arg) right
  | .unio left right => Typing tmp am e left ∨ Typing tmp am e right
  | .inter left right => Typing tmp am e left ∧ Typing tmp am e right
  | .diff left right => Typing tmp am e left ∧ ¬ (Typing tmp am e right)

  | .exi bs cs body =>
    (∀ a ∈ bs , a = "") ∧
    ∀ names,
    List.length names = List.length bs →
    List.Disjoint names (tmp :: Typ.list_prod_free_vars cs ++ Typ.free_vars body) →
      ∃ am' , Prod.dom am' = names ∧
      (MultiSubtyping tmp (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
      (Typing tmp (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body))

  | .all bs cs body =>
    Safe e ∧
    (∀ a ∈ bs , a = "") ∧
    ∃ names,
    List.length names = List.length bs ∧
    List.Disjoint names (tmp :: Typ.list_prod_free_vars cs ++ Typ.free_vars body) ∧
    ∀ am' , Prod.dom am' = names →
    (MultiSubtyping tmp (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) →
      (Typing tmp (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body))
  | .lfp a body =>
    Safe e ∧
    a = "" ∧
    ∀ name , name ∉ (tmp :: Typ.free_vars body) →
      PosMonotonic name tmp am (Typ.instantiate 0 [.var name] body) ∧
      /- infimum of -/
      (∀ P, Stable P →
        /- pre-fixed point -/
        (∀ e', Typing tmp ((name,P) :: am) e' (Typ.instantiate 0 [.var name] body) → P e') →
        P e
      )
  termination_by t => (Typ.size t, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.size, Typ.size_instantiate] ; try linarith)
    all_goals (
      try rw [Typ.constraints_size_instantiate] <;> (try linarith)
      try rw [Typ.size_instantiate] <;> (try linarith)
      intro e
      apply Typ.mem_map_var_size
    )

end


def NegMonotonic (name : String) (tmp : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
  (∀ P0 P1 : Expr → Prop,
    Stable P0 → Stable P1 →
    (∀ e, P0 e → P1 e) →
    (∀ e , Typing tmp ((name,P1)::am) e t → Typing tmp ((name,P0)::am) e t)
  )

def Monotonic (polarity : Bool) (name : String) (tmp : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
  (polarity = true ∧ PosMonotonic name tmp am t) ∨
  (polarity = false ∧ NegMonotonic name tmp am t)

def MultiMonotonic (polarity : Bool) (name : String) (tmp : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  ∀ lower upper, (lower,upper) ∈ cs → Monotonic (not polarity) name tmp am lower ∧ Monotonic polarity name tmp am upper

def EitherMultiMonotonic (name : String) (tmp : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  MultiMonotonic .true name tmp am cs ∨ MultiMonotonic .false name tmp am cs


def MultiTyping
  (tmp : String) (tam : List (String × (Expr → Prop))) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, Prod.find x context = .some t → ∃ e, (Prod.find x eam) = .some e ∧ Typing tmp tam e t


theorem Typing.safety :
  Typing tmp am e t → Safe e
:= by cases t with
| bvar i =>
  simp [Typing]
| var t =>
  simp [Typing]
  intro h0 P h1 h2 h3
  apply h0
| iso l t =>
  simp [Typing]
  intro h0 h1
  apply h0
| entry l t =>
  simp [Typing]
  intro h0 h1
  apply h0
| path t0 t1 =>
  simp [Typing]
  intro h0 h1 h2
  apply h0
| bot =>
  simp [Typing]
| top =>
  simp [Typing]
| unio t0 t1 =>
  simp [Typing]
  intro h0
  cases h0 with
  | inl h0 =>
    apply Typing.safety h0
  | inr h0 =>
    apply Typing.safety h0
| inter t0 t1 =>
  simp [Typing]
  intro h0 h1
  apply Typing.safety h0
| diff t0 t1 =>
  simp [Typing]
  intro h0 h1
  apply Typing.safety h0
| all bs cs body =>
  simp [Typing]
  intro h0 h1 names h2 h3 h4 h5 h6
  exact h0
| exi bs cs body =>
  simp [Typing]
  intro h0 h1 e' h2
  have ⟨names,h3,h4⟩ := String.fresh_names (List.length bs) (tmp :: Typ.list_prod_free_vars cs ++ Typ.free_vars body)
  simp at h4
  have ⟨h4A,h4B,h4C⟩ := h4


  have ⟨am',h5,h6,h7⟩ := h1 names h3 h4A h4B h4C
  apply Typing.safety h7 _ h2
| lfp x body =>
  simp [Typing]
  intro h0 h1 h2 name h4
  exact h0 name h4


termination_by Typ.size t
decreasing_by
  all_goals (simp [Typ.size] ; try linarith)
  rw [Typ.size_instantiate]
  { linarith }
  {
    intro e
    apply Typ.mem_map_var_size
  }



theorem Typing.progress :
  Typing tmp am e t → Expr.valued e ∨ ∃ e', NStep e e'
:= by
  intro h0
  apply Safe.progress
  apply Typing.safety h0


mutual
  theorem Typing.subject_reduction
    (transition : NStep e e')
  : Typing tmp am e t → Typing tmp am e' t
  := by cases t with
  | bvar i =>
    simp [Typing]
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h0
    exact Safe.subject_reduction transition h0

  | iso label body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { exact Safe.subject_reduction transition h0 }
    { apply Typing.subject_reduction
      { apply NStep.applicand _ transition }
      { exact h1 }
    }

  | entry label body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { exact Safe.subject_reduction transition h0 }
    { apply Typing.subject_reduction
      { apply NStep.applicand _ transition }
      { exact h1 }
    }


  | path left right =>
    simp [Typing]
    intro h0 h1
    apply And.intro (Safe.subject_reduction transition h0)
    -- apply And.intro h1
    intro arg h3
    apply Typing.subject_reduction
    { apply NStep.applicator _ transition }
    { exact h1 arg h3 }

  | unio left right =>
    unfold Typing
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply Typing.subject_reduction transition h2
    | inr h2 =>
      apply Or.inr
      apply Typing.subject_reduction transition h2

  | inter left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_reduction transition h0 }
    { apply Typing.subject_reduction transition h1 }

  | diff left right =>
    simp [Typing]
    intro h0 h1
    apply And.intro
    { apply Typing.subject_reduction transition h0 }
    { intro h3
      apply h1
      apply Typing.subject_expansion transition h3
    }

  | exi bs quals body =>
    simp [Typing]
    intro h0 h1
    apply And.intro h0
    intro names h3 h4A h4B h4C
    have ⟨am',h5,h6,h7⟩ := h1 names h3 h4A h4B h4C
    exists am'
    simp [*]
    apply Typing.subject_reduction transition h7

  | all bs quals body =>
    simp [Typing]
    intro h0 h1 names h2 h3A h3B h3C h4
    apply And.intro
    { apply Safe.subject_reduction transition h0 }
    { apply And.intro h1
      exists names
      simp [*]
      intro am' h5 h6
      apply Typing.subject_reduction transition
      exact h4 am' h5 h6
    }

  | lfp b body =>
    simp [Typing]
    intro safe nameless h0
    apply And.intro
    { exact Safe.subject_reduction transition safe }
    { apply And.intro nameless
      intro name h1A h1B
      have ⟨h2,h3⟩ := h0 name h1A h1B
      apply And.intro h2
      intro P h4 h5
      apply Stable.subject_reduction h4 transition
      exact h3 P h4 h5
    }

  | var id =>
    simp [Typing]
    intro h0 P h1 h2 h3
    apply And.intro
    { exact Safe.subject_reduction transition h0 }
    {
      exists P
      simp [*]
      apply Stable.subject_reduction h1 transition
      exact h3
    }
  termination_by Typ.size t
  decreasing_by
    all_goals (simp [Typ.size] ; try linarith)
    all_goals (
      try rw [Typ.constraints_size_instantiate] <;> (try linarith)
      try rw [Typ.size_instantiate] <;> (try linarith)
      intro e
      apply Typ.mem_map_var_size
    )

  theorem Typing.subject_expansion
    (transition : NStep e e')
  : Typing tmp am e' t → Typing tmp am e t
  := by cases t with
  | bvar i =>
    simp [Typing]
  | bot =>
    unfold Typing
    simp
  | top =>
    unfold Typing
    intro h0
    exact Safe.subject_expansion transition h0

  | iso label body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { exact Safe.subject_expansion transition h0 }
    { apply Typing.subject_expansion
      { apply NStep.applicand _ transition }
      { exact h1 }
    }

  | entry label body =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { exact Safe.subject_expansion transition h0 }
    { apply Typing.subject_expansion
      { apply NStep.applicand _ transition }
      { exact h1 }
    }


  | path left right =>
    simp [Typing]
    intro h0 h1
    apply And.intro (Safe.subject_expansion transition h0)
    -- apply And.intro h1
    intro arg h3
    apply Typing.subject_expansion
    { apply NStep.applicator _ transition }
    { exact h1 arg h3 }

  | unio left right =>
    unfold Typing
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply Typing.subject_expansion transition h2
    | inr h2 =>
      apply Or.inr
      apply Typing.subject_expansion transition h2

  | inter left right =>
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_expansion transition h0 }
    { apply Typing.subject_expansion transition h1 }

  | diff left right =>
    simp [Typing]
    intro h0 h1
    apply And.intro
    { apply Typing.subject_expansion transition h0 }
    { intro h3
      apply h1
      apply Typing.subject_reduction transition h3
    }

  | exi bs cs body =>
    simp [Typing]
    intro h0 h1
    apply And.intro h0
    intro names h3 h4A h4B h4C
    have ⟨am',h5,h6,h7⟩ := h1 names h3 h4A h4B h4C
    exists am'
    simp [*]
    apply Typing.subject_expansion transition h7

  | all bs cs body =>
    simp [Typing]
    intro h0 h1 names h2 h3A h3B h3C h4
    apply And.intro
    { apply Safe.subject_expansion transition h0 }
    { apply And.intro h1
      exists names
      simp [*]
      intro am' h5 h6
      apply Typing.subject_expansion transition
      exact h4 am' h5 h6
    }

  | lfp b body =>
    simp [Typing]
    intro safe nameless h0
    apply And.intro
    { exact Safe.subject_expansion transition safe }
    { apply And.intro nameless
      intro name h1A h1B
      have ⟨h2,h3⟩ := h0 name h1A h1B
      apply And.intro h2
      intro P h4 h5
      apply Stable.subject_expansion h4 transition
      exact h3 P h4 h5
    }
  | var id =>
    simp [Typing]
    intro h0 P h1 h2 h3
    apply And.intro
    { exact Safe.subject_expansion transition h0 }
    {
      exists P
      simp [*]
      apply Stable.subject_expansion h1 transition
      exact h3
    }
  termination_by Typ.size t
  decreasing_by
    all_goals (simp [Typ.size] ; try linarith)
    all_goals (
      try rw [Typ.constraints_size_instantiate] <;> (try linarith)
      try rw [Typ.size_instantiate] <;> (try linarith)
      intro e
      apply Typ.mem_map_var_size
    )
end


-- theorem Typing.free_vars_subset_env :
--   Typing env e t → Typ.free_vars t ⊆ Prod.dom env
-- := by cases t with
-- | bvar i =>
--   simp [Typing]
-- -- | var name =>
-- --   simp [Typing, Typ.free_vars]
-- --   intro h0 P h1 h2 h3
-- | _ =>
--   sorry


theorem Typing.refl_trans_left_subject_expansion
  (transition : ReflTransLeft NStep e e')
: Typing tmp am e' t → Typing tmp am e t
:= by induction transition with
| refl =>
  intro h0 ; exact h0
| @step em e' h0 h1 ih =>
  intro h2
  apply ih ; clear ih
  apply Typing.subject_expansion h1 h2

theorem Typing.refl_trans_subject_expansion
  (transition : ReflTrans NStep e e')
: Typing tmp am e' t → Typing tmp am e t
:= by
  apply Typing.refl_trans_left_subject_expansion
  exact ReflTrans.reverse transition

theorem Typing.refl_trans_subject_reduction
  (transition : ReflTrans NStep e e')
: Typing tmp am e t → Typing tmp am e' t
:= by induction transition with
| refl =>
  intro h0 ; exact h0
| @step e em e' h0 h1 ih =>
  intro h2
  apply ih ; clear ih
  apply Typing.subject_reduction h0 h2


mutual


  theorem Subtyping.env_insert_reflection :
    (name ∉ Typ.free_vars lower ∧ name ∉ Typ.free_vars upper ∨ name ∈ Prod.dom m0) →
    Subtyping tmp (m0 ++ (name,P) :: m1) lower upper →
    Subtyping tmp (m0 ++ m1) lower upper
  := by
    simp [Subtyping]
    intro h0 h1 e h2
    have ⟨h4,h5⟩ := Iff.mp and_or_right h0
    apply Typing.env_insert_reflection h5
    apply h1
    apply Typing.env_insert_preservation h4 h2
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])

  theorem Subtyping.env_insert_preservation :
    (name ∉ Typ.free_vars lower ∧ name ∉ Typ.free_vars upper ∨ name ∈ Prod.dom m0) →
    Subtyping tmp (m0 ++ m1) lower upper →
    ∀ P, Subtyping tmp (m0 ++ (name,P) :: m1) lower upper
  := by
    simp [Subtyping]
    intro h0 h1 P e h2
    have ⟨h4,h5⟩ := Iff.mp and_or_right h0
    apply Typing.env_insert_preservation h5
    apply h1
    apply Typing.env_insert_reflection h4 h2
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])


  theorem MultiSubtyping.env_insert_reflection :
    (name ∉ Typ.list_prod_free_vars cs ∨ name ∈ Prod.dom m0) →
    MultiSubtyping tmp (m0 ++ (name,P) :: m1) cs →
    MultiSubtyping tmp (m0 ++ m1) cs
  := by cases cs with
  | nil =>
    simp [MultiSubtyping]
  | cons c cs' =>
    have (lower,upper) := c
    simp [MultiSubtyping, Typ.list_prod_free_vars]
    intro h0 h1 h2
    have ⟨h4,h5⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Subtyping.env_insert_reflection h4 h1 }
    { apply MultiSubtyping.env_insert_reflection h5 h2 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals sorry

  theorem MultiSubtyping.env_insert_preservation :
    (name ∉ Typ.list_prod_free_vars cs ∨ name ∈ Prod.dom m0) →
    MultiSubtyping tmp (m0 ++ m1) cs →
    ∀ P, MultiSubtyping tmp (m0 ++ (name,P) :: m1) cs
  := by cases cs with
  | nil =>
    simp [MultiSubtyping]
  | cons c cs' =>
    have (lower,upper) := c
    simp [MultiSubtyping, Typ.list_prod_free_vars]
    intro h0 h1 h2 P
    have ⟨h4,h5⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Subtyping.env_insert_preservation h4 h1 }
    { apply MultiSubtyping.env_insert_preservation h5 h2 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals sorry


  theorem PosMonotonic.env_insert_reflection :
    (name ∉ Typ.free_vars t ∨ name = point ∨ name ∈ Prod.dom m0)  →
    PosMonotonic point tmp (m0 ++ (name,P) :: m1) t →
    PosMonotonic point tmp (m0 ++ m1) t
  := by
    simp [PosMonotonic]
    intro h0 h1 P0 P1 stable0 stable1 h3 e h5
    rw [←List.cons_append]
    apply @Typing.env_insert_reflection _ name
    { simp [Prod.dom]
      simp [Prod.dom] at h0
      exact h0
    }
    {
      rw [List.cons_append]
      apply h1 _ _ stable0 stable1 h3
      rw [←List.cons_append]
      apply Typing.env_insert_preservation
      { simp [Prod.dom]
        simp [Prod.dom] at h0
        exact h0
      }
      { exact h5 }
    }
  termination_by (Typ.size t, 1)

  theorem PosMonotonic.env_insert_preservation :
    (name ∉ Typ.free_vars t ∨ name = point ∨ name ∈ Prod.dom m0)  →
    PosMonotonic point tmp (m0 ++ m1) t →
    ∀ P, PosMonotonic point tmp (m0 ++ (name,P) :: m1) t
  := by
    simp [PosMonotonic]
    intro h0 h1 P0 P1 P stable0 stable1 h3 e h5
    rw [←List.cons_append]
    apply @Typing.env_insert_preservation _ name
    { simp [Prod.dom]
      simp [Prod.dom] at h0
      exact h0
    }
    {
      rw [List.cons_append]
      apply h1 _ _ stable0 stable1 h3
      rw [←List.cons_append]
      apply Typing.env_insert_reflection
      { simp [Prod.dom]
        simp [Prod.dom] at h0
        exact h0
      }
      { exact h5 }
    }
  termination_by (Typ.size t, 1)
  -- decreasing_by
  --   all_goals sorry

  theorem Typing.env_insert_reflection :
    (name ∉ Typ.free_vars t ∨ name ∈ Prod.dom m0) →
    Typing tmp (m0 ++ (name,P) :: m1) e t →
    Typing tmp (m0 ++ m1) e t
  := by cases t with
  | bvar i =>
    simp [Typing]
  | var name' =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 P' h2 h3 h4
    simp [*]
    exists P'
    simp [*]
    by_cases h6: name' ∈ Prod.dom m0
    { rw [Prod.find_append_prefix m1 h6]
      rw [Prod.find_append_prefix ((name,P)::m1) h6] at h3
      exact h3
    }
    { rw [Prod.find_append_suffix m1 h6]
      rw [Prod.find_append_suffix ((name, P) :: m1) h6] at h3
      simp [Prod.find] at h3
      by_cases h7 : name = name'
      {
        apply False.elim
        simp [h7] at h0
        apply h6 h0
      }
      { simp [h7] at h3
        exact h3
      }
    }
  | bot =>
    simp [Typing]
  | top =>
    simp [Typing]
  | iso l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    simp [*]
    apply Typing.env_insert_reflection h0 h2
  | entry l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    simp [*]
    apply Typing.env_insert_reflection h0 h2
  | path antec conseq =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    simp [*]
    intro arg h7
    apply Typing.env_insert_reflection h4
    apply h2
    apply Typing.env_insert_preservation h3 h7

  | unio left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1
    have ⟨h2,h3⟩ := Iff.mp and_or_right h0
    cases h1 with
    | inl h4 =>
      apply Or.inl
      apply Typing.env_insert_reflection h2 h4
    | inr h4 =>
      apply Or.inr
      apply Typing.env_insert_reflection h3 h4

  | inter left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_reflection h3 h1}
    { apply Typing.env_insert_reflection h4 h2 }

  | diff minu subtra =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_reflection h3 h1 }
    { intro h5
      apply h2
      apply Typing.env_insert_preservation h4 h5
    }

  | all bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 names h3 h4A h4B h4C h5
    simp [*]
    apply And.intro h2
    exists names
    simp [*]
    have ⟨h6,h7⟩ := Iff.mp and_or_right h0
    intro m h9 h10
    rw [←List.append_assoc]
    apply @Typing.env_insert_reflection _ name
    { cases h7 with
      | inl h8 =>
        by_cases h11 : name ∈ names
        {
          apply Or.inr
          simp [Prod.dom]
          apply Or.inl
          rw [←h9] at h11
          simp [Prod.dom] at h11
          exact h11
        }
        {
          apply Or.inl
          intro h12
          apply Typ.free_vars_instantiate_upper_bound at h12
          simp [Typ.free_vars] at h12
          cases h12 with
          | inl h13 =>
            exact h8 h13
          | inr h13 =>
            exact h11 h13
        }
      | inr h8 =>
        apply Or.inr
        simp [Prod.dom]
        simp [Prod.dom] at h8
        exact Or.inr h8
    }
    {
      rw [List.append_assoc]
      apply h5 _ h9
      rw [←List.append_assoc]
      apply MultiSubtyping.env_insert_preservation
      {
        cases h6 with
        | inl h7 =>
          by_cases h8 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h8
            simp [Prod.dom] at h8
            exact h8
          }
          { apply Or.inl
            intro h11
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h11
            simp [Typ.free_vars] at h11
            cases h11 with
            | inl h13 =>
              exact h7 h13
            | inr h13 =>
              exact h8 h13
          }
        | inr h7 =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h7
          exact Or.inr h7
      }
      { rw [List.append_assoc]
        exact h10
      }
    }
  | exi bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2
    apply And.intro h1
    intro names h5 h6A h6B h6C

    have ⟨m,h9,h10,h11⟩ := h2 names h5 h6A h6B h6C
    exists m
    simp [*]
    have ⟨h12,h13⟩ := Iff.mp and_or_right h0
    apply And.intro
    {
      rw [←List.append_assoc]
      apply @MultiSubtyping.env_insert_reflection _ name
      { cases h12 with
        | inl h14 =>
          by_cases h15 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h15
            simp [Prod.dom] at h15
            exact h15
          }
          { apply Or.inl
            intro h16
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h16
            simp [Typ.free_vars] at h16
            cases h16 with
            | inl h17 =>
              exact h14 h17
            | inr h17 =>
              exact h15 h17
          }
        | inr h14 =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h14
          exact Or.inr h14
      }
      { rw [List.append_assoc] ; exact h10}
    }
    { rw [←List.append_assoc]
      apply Typing.env_insert_reflection
      { cases h13 with
        | inl h14 =>
          by_cases h15 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h15
            simp [Prod.dom] at h15
            exact h15
          }
          { apply Or.inl
            intro h16
            apply Typ.free_vars_instantiate_upper_bound at h16
            simp [Typ.free_vars] at h16
            cases h16 with
            | inl h17 =>
              exact h14 h17
            | inr h17 =>
              exact h15 h17
          }
        | inr h1C =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h1C
          exact Or.inr h1C
      }
      { rw [List.append_assoc] ; exact h11 }
    }
  | lfp a body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3
    simp [*]
    intro name' h4A h4B

    have ⟨h6,h7⟩ := h3 name' h4A h4B

    apply And.intro
    { apply @PosMonotonic.env_insert_reflection _ name
      {
        by_cases h9 : name = name'
        { simp [h9] }
        { simp [h9]
          cases h0 with
          | inl h0A =>
            apply Or.inl
            intro h10
            apply Typ.free_vars_instantiate_upper_bound at h10
            simp at h10
            simp [h0A,h9,Typ.free_vars] at h10
          | inr h0A =>
            simp [h0A]
        }
      }
      { exact h6 }
    }
    { intro P' h9 h10
      apply h7 _ h9
      intro e' h11
      apply h10
      rw [←List.cons_append]
      apply @Typing.env_insert_reflection _ name
      {
        simp [Prod.dom]
        by_cases h9 : name = name'
        { simp [h9] }
        { simp [h9]
          cases h0 with
          | inl h0A =>
            apply Or.inl
            intro h10
            apply Typ.free_vars_instantiate_upper_bound at h10
            simp at h10
            simp [h0A,h9,Typ.free_vars] at h10
          | inr h0A =>
            simp [Prod.dom] at h0A
            simp [h0A]
        }
      }
      { exact h11}
    }
  termination_by (Typ.size t, 0)
  decreasing_by
    all_goals sorry

  theorem Typing.env_insert_preservation :
    (name ∉ Typ.free_vars t ∨ name ∈ Prod.dom m0) →
    Typing tmp (m0 ++ m1) e t →
    ∀ P, Typing tmp (m0 ++ (name,P) :: m1) e t
  := by cases t with
  | bvar i =>
    simp [Typing]
  | var name' =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 P' h2 h3 h4 P
    simp [*]
    exists P'
    simp [*]
    by_cases h6: name' ∈ Prod.dom m0
    { rw [Prod.find_append_prefix ((name,P)::m1) h6]
      rw [Prod.find_append_prefix m1 h6] at h3
      exact h3
    }
    { rw [Prod.find_append_suffix ((name, P) :: m1) h6]
      rw [Prod.find_append_suffix m1 h6] at h3
      simp [Prod.find]
      by_cases h7 : name = name'
      {
        apply False.elim
        simp [h7] at h0
        apply h6 h0
      }
      { simp [h7] ; exact h3 }
    }
  | bot =>
    simp [Typing]
  | top =>
    simp [Typing]
  | iso l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    simp [*]
    apply Typing.env_insert_preservation h0 h2
  | entry l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    simp [*]
    apply Typing.env_insert_preservation h0 h2
  | path antec conseq =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    simp [*]
    intro arg h7
    apply Typing.env_insert_preservation h4
    apply h2
    apply Typing.env_insert_reflection h3 h7

  | unio left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 P
    have ⟨h2,h3⟩ := Iff.mp and_or_right h0
    cases h1 with
    | inl h4 =>
      apply Or.inl
      apply Typing.env_insert_preservation h2 h4
    | inr h4 =>
      apply Or.inr
      apply Typing.env_insert_preservation h3 h4

  | inter left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_preservation h3 h1}
    { apply Typing.env_insert_preservation h4 h2 }

  | diff minu subtra =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    have ⟨h3,h4⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_preservation h3 h1 }
    { intro h5
      apply h2
      apply Typing.env_insert_reflection h4 h5
    }

  | all bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 names h3 h4A h4B h4C h5 P
    simp [*]
    apply And.intro h2
    exists names
    simp [*]
    have ⟨h6,h7⟩ := Iff.mp and_or_right h0
    intro m h9 h10
    rw [←List.append_assoc]
    apply @Typing.env_insert_preservation _ name
    { cases h7 with
      | inl h8 =>
        by_cases h11 : name ∈ names
        {
          apply Or.inr
          simp [Prod.dom]
          apply Or.inl
          rw [←h9] at h11
          simp [Prod.dom] at h11
          exact h11
        }
        {
          apply Or.inl
          intro h12
          apply Typ.free_vars_instantiate_upper_bound at h12
          simp [Typ.free_vars] at h12
          cases h12 with
          | inl h13 =>
            exact h8 h13
          | inr h13 =>
            exact h11 h13
        }
      | inr h8 =>
        apply Or.inr
        simp [Prod.dom]
        simp [Prod.dom] at h8
        exact Or.inr h8
    }
    {
      rw [List.append_assoc]
      apply h5 _ h9
      rw [←List.append_assoc]
      apply MultiSubtyping.env_insert_reflection
      {
        cases h6 with
        | inl h7 =>
          by_cases h8 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h8
            simp [Prod.dom] at h8
            exact h8
          }
          { apply Or.inl
            intro h11
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h11
            simp [Typ.free_vars] at h11
            cases h11 with
            | inl h13 =>
              exact h7 h13
            | inr h13 =>
              exact h8 h13
          }
        | inr h7 =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h7
          exact Or.inr h7
      }
      { rw [List.append_assoc]
        exact h10
      }
    }
  | exi bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P
    apply And.intro h1
    intro names h5 h6A h6B h6C

    have ⟨m,h9,h10,h11⟩ := h2 names h5 h6A h6B h6C
    exists m
    simp [*]
    have ⟨h12,h13⟩ := Iff.mp and_or_right h0
    apply And.intro
    {
      rw [←List.append_assoc]
      apply @MultiSubtyping.env_insert_preservation _ name
      { cases h12 with
        | inl h14 =>
          by_cases h15 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h15
            simp [Prod.dom] at h15
            exact h15
          }
          { apply Or.inl
            intro h16
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h16
            simp [Typ.free_vars] at h16
            cases h16 with
            | inl h17 =>
              exact h14 h17
            | inr h17 =>
              exact h15 h17
          }
        | inr h14 =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h14
          exact Or.inr h14
      }
      { rw [List.append_assoc] ; exact h10}
    }
    { rw [←List.append_assoc]
      apply Typing.env_insert_preservation
      { cases h13 with
        | inl h14 =>
          by_cases h15 : name ∈ names
          { apply Or.inr
            simp [Prod.dom]
            apply Or.inl
            rw [←h9] at h15
            simp [Prod.dom] at h15
            exact h15
          }
          { apply Or.inl
            intro h16
            apply Typ.free_vars_instantiate_upper_bound at h16
            simp [Typ.free_vars] at h16
            cases h16 with
            | inl h17 =>
              exact h14 h17
            | inr h17 =>
              exact h15 h17
          }
        | inr h1C =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h1C
          exact Or.inr h1C
      }
      { rw [List.append_assoc] ; exact h11 }
    }
  | lfp a body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    simp [*]
    intro name' h4A h4B

    have ⟨h6,h7⟩ := h3 name' h4A h4B

    apply And.intro
    { apply @PosMonotonic.env_insert_preservation _ name
      {
        by_cases h9 : name = name'
        { simp [h9] }
        { simp [h9]
          cases h0 with
          | inl h0A =>
            apply Or.inl
            intro h10
            apply Typ.free_vars_instantiate_upper_bound at h10
            simp at h10
            simp [h0A,h9,Typ.free_vars] at h10
          | inr h0A =>
            simp [h0A]
        }
      }
      { exact h6 }
    }
    { intro P' h9 h10
      apply h7 _ h9
      intro e' h11
      apply h10
      rw [←List.cons_append]
      apply @Typing.env_insert_preservation _ name
      {
        simp [Prod.dom]
        by_cases h9 : name = name'
        { simp [h9] }
        { simp [h9]
          cases h0 with
          | inl h0A =>
            apply Or.inl
            intro h10
            apply Typ.free_vars_instantiate_upper_bound at h10
            simp at h10
            simp [h0A,h9,Typ.free_vars] at h10
          | inr h0A =>
            simp [Prod.dom] at h0A
            simp [h0A]
        }
      }
      { exact h11}
    }
  termination_by (Typ.size t, 0)
  decreasing_by
    all_goals sorry
end

theorem Typing.env_cons_suffix_preservation :
  name ∉ Typ.free_vars t →
  Typing tmp m e t →
  ∀ P, Typing tmp ((name,P) :: m) e t
:= by
  intro h0 h1 P
  have h2 : (name,P) :: m = [] ++ (name,P) :: m  := by rfl
  rw [h2]
  apply Typing.env_insert_preservation
  { simp [Prod.dom] ; exact h0 }
  { exact h1 }

theorem Typing.env_cons_suffix_reflection :
  name ∉ Typ.free_vars t →
  Typing tmp ((name,P) :: m) e t →
  Typing tmp m e t
:= by
  intro h0 h1
  have h2 : m = [] ++ m  := by rfl
  rw [h2]
  apply Typing.env_insert_reflection
  { simp [Prod.dom] ; exact h0 }
  { exact h1 }

theorem Typing.env_append_suffix_preservation :
  List.Disjoint (Prod.dom m0) (Typ.free_vars t) →
  Typing tmp m1 e t →
  Typing tmp (m0 ++ m1) e t
:= by induction m0 with
| nil =>
  simp [List.Disjoint]
| cons item m0' ih =>
  simp [List.Disjoint, Prod.dom]
  simp [List.Disjoint, Prod.dom] at ih
  have (name,P) := item
  simp
  intro h1 h2 h3
  apply Typing.env_cons_suffix_preservation h1
  apply ih h2 h3

theorem Typing.env_append_suffix_reflection :
  List.Disjoint (Prod.dom m0) (Typ.free_vars t) →
  Typing tmp (m0 ++ m1) e t →
  Typing tmp m1 e t
:= by induction m0 with
| nil =>
  simp [List.Disjoint]
| cons item m0' ih =>
  simp [List.Disjoint, Prod.dom]
  simp [List.Disjoint, Prod.dom] at ih
  have (name,P) := item
  simp
  intro h1 h2 h3
  apply ih h2
  apply Typing.env_cons_suffix_reflection h1 h3


theorem Typing.env_preservation :
  Typ.free_vars t = [] →
  Typing tmp [] e t →
  Typing tmp m e t
:= by
  intro h0 h1
  have h2 : m = m ++ [] := by exact Eq.symm (List.append_nil m)
  rw [h2]
  apply Typing.env_append_suffix_preservation
  { simp [h0] }
  { exact h1 }

theorem Typing.env_reflection :
  Typ.free_vars t = [] →
  Typing tmp m e t →
  Typing tmp [] e t
:= by
  intro h0 h1
  have h2 : m = m ++ [] := by exact Eq.symm (List.append_nil m)
  rw [h2] at h1
  apply Typing.env_append_suffix_reflection
  { simp [h0] }
  { exact h1 }





end Lang
