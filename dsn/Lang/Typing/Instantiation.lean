import Lean
import Mathlib.Tactic.Linarith

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

set_option maxHeartbeats 500000 in
mutual


  theorem Subtyping.generalized_nameless_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Subtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper) →
    Subtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper)
  := by
    simp [Subtyping]
    intro h2 h3 h4 h5 e h6
    apply Typing.generalized_nameless_instantiation h2 h3 h4
    apply h5
    apply Typing.generalized_named_instantiation h2 h3 h4 h6
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])

  theorem Subtyping.generalized_named_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Subtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper) →
    Subtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper)
  := by
    simp [Subtyping]
    intro h2 h3 h4 h5 e h6
    apply Typing.generalized_named_instantiation h2 h3 h4
    apply h5
    apply Typing.generalized_nameless_instantiation h2 h3 h4 h6
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])




  theorem PosMonotonic.generalized_nameless_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    name ≠ point →
    PosMonotonic point name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [.var name] body) →
    PosMonotonic point name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [t] body)
  := by
    simp [PosMonotonic]
    intro h1 h2 h3
    intro h5
    intro h7 P0 P1 stable_P0 stable_P1 h9 e h10
    rw [←List.cons_append]
    apply Typing.generalized_nameless_instantiation
    { simp [Prod.dom] at h1
      simp [Prod.dom,h1,h5]
    }
    { exact h2 }
    { exact h3 }
    { simp
      apply h7 _ _ stable_P0 stable_P1 h9
      rw [←List.cons_append]
      apply Typing.generalized_named_instantiation
      { simp [Prod.dom] at h1
        simp [Prod.dom,h1,h5]
      }
      { exact h2 }
      { exact h3 }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem PosMonotonic.generalized_named_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    name ≠  point →
    PosMonotonic point name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [t] body) →
    PosMonotonic point name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.instantiate depth [.var name] body)
  := by
    simp [PosMonotonic]
    intro h1 h2 h3
    intro h5
    intro h7 P0 P1 stable_P0 stable_P1 h9 e h10

    rw [←List.cons_append]
    apply Typing.generalized_named_instantiation
    { simp [Prod.dom] at h1
      simp [Prod.dom,h1,h5]
    }
    { exact h2 }
    { exact h3 }
    { simp
      apply h7 _ _ stable_P0 stable_P1 h9
      rw [←List.cons_append]
      apply Typing.generalized_nameless_instantiation
      { simp [Prod.dom] at h1
        simp [Prod.dom,h1,h5]
      }
      { exact h2 }
      { exact h3 }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem MultiSubtyping.generalized_nameless_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    MultiSubtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.constraints_instantiate depth [.var name] cs) →
    MultiSubtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.constraints_instantiate depth [t] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping]
    intro h3 h4 h5 h6 h7
    apply And.intro
    { apply Subtyping.generalized_nameless_instantiation h3 h4 h5 h6 }
    { apply MultiSubtyping.generalized_nameless_instantiation h3 h4 h5 h7 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size, List.pair_typ_size, List.pair_typ_zero_lt_size])


  theorem MultiSubtyping.generalized_named_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    MultiSubtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.constraints_instantiate depth [t] cs) →
    MultiSubtyping name (am' ++ (name,fun e => Typing name [] e t) :: am) (Typ.constraints_instantiate depth [.var name] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping]
    intro h3 h4 h5 h6 h7
    apply And.intro
    { apply Subtyping.generalized_named_instantiation h3 h4 h5 h6 }
    { apply MultiSubtyping.generalized_named_instantiation h3 h4 h5 h7 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size, List.pair_typ_size, List.pair_typ_zero_lt_size])


  theorem Typing.generalized_nameless_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Typing name (am' ++ (name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [.var name] body) →
    Typing name (am' ++ (name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [t] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        simp [Typ.shift_vars]
        intro h3 h4 h5
        simp [Typing]
        intro h7 P h8 h9 h10
        rw [Prod.find_append_suffix _ h3] at h9
        simp [Prod.find] at h9
        simp [←h9] at h10

        simp [Typ.wellformed] at h5
        have ⟨h11,_⟩ := h5
        rw [←Typ.instantiated_shift_vars_preservation h11]
        apply Typing.env_preservation h4 h10
      }
      { simp [h1] }
    }
    { simp [h0] }
  | var name' =>
    simp [Typ.instantiate, Typing]
  | iso l body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5
    simp [h4]
    apply Typing.generalized_nameless_instantiation h1 h2 h3 h5
  | entry l body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5
    simp [h4]
    apply Typing.generalized_nameless_instantiation h1 h2 h3 h5
  | path left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    simp [h5]
    { intro arg h9
      apply Typing.generalized_nameless_instantiation h2 h3 h4
      apply h6
      apply Typing.generalized_named_instantiation h2 h3 h4 h9
    }
  | bot =>
    simp [Typ.instantiate, Typing]
  | top =>
    simp [Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5
    cases h5 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_nameless_instantiation h2 h3 h4 h7
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_nameless_instantiation h2 h3 h4 h7
  | inter left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    apply And.intro
    { apply Typing.generalized_nameless_instantiation h2 h3 h4 h5 }
    { apply Typing.generalized_nameless_instantiation h2 h3 h4 h6 }
  | diff left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    apply And.intro
    { apply Typing.generalized_nameless_instantiation h2 h3 h4 h5 }
    { intro h9
      apply h6
      apply Typing.generalized_named_instantiation h2 h3 h4 h9
    }
  | all bs cs body =>
    simp [Typ.instantiate]
    intro h2
    simp [Typing]
    intro h3 h4 h5 h6 names h7 h8 h9 h10 h11
    simp [h5]
    apply And.intro h6
    exists names
    simp [*]
    apply And.intro
    {
      apply And.intro
      { simp [List.Disjoint] at h9
        simp [List.Disjoint]
        intro name' h12 h13
        apply h9 h12
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h13
        simp [h3] at h13
        apply Typ.list_prod_free_vars_instantiate_lower_bound _ _ h13
      }
      { simp [List.Disjoint] at h10
        simp [List.Disjoint]
        intro name' h12 h13
        apply h10 h12
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [h3] at h13
        apply Typ.free_vars_instantiate_lower_bound _ _ h13
      }
    }
    { intro am'' h13 h14

      have h15 :
        ∀ t' ∈ List.map Typ.var names,
          t' = Typ.instantiate depth [t] t'
      := by
        intro t h15
        have ⟨p,h16,h17⟩ := Iff.mp List.mem_map h15
        rw [←h17]
        simp [Typ.instantiate]

      rw [Typ.list_instantiate_identity h15]
      rw [←h7]
      rw [←List.length_map Typ.var]
      rw [←Typ.instantiate_zero_inside_out]

      rw [←List.append_assoc]


      have h2A : name ∉ Prod.dom (am'' ++ am') := by
        simp [Prod.dom] at h2
        simp [Prod.dom,h2]
        rw [←h13] at h8
        simp [Prod.dom] at h8
        exact h8

      apply Typing.generalized_nameless_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      {
        rw [List.append_assoc]
        rw [Typ.instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [h7]

        have h16 :
          ∀ t' ∈ List.map Typ.var names,
            t' = Typ.instantiate depth [.var name] t'
        := by
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]


        rw [←Typ.list_instantiate_identity h16]
        apply h11 _ h13
        rw [←List.append_assoc]
        rw [Typ.list_instantiate_identity h16]
        rw [←h7]
        rw [←List.length_map Typ.var]
        rw [←Typ.constraints_instantiate_zero_inside_out]
        apply MultiSubtyping.generalized_named_instantiation
        { exact h2A }
        { exact h3 }
        { exact h4 }
        { rw [List.append_assoc]
          rw [Typ.constraints_instantiate_zero_inside_out]
          rw [List.length_map]
          rw [h7]
          rw [←Typ.list_instantiate_identity h15]
          exact h14
        }
      }
    }

  | exi bs cs body =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    apply And.intro h5
    intro names h7 h8 h9 h10
    specialize h6 names h7 h8
    have h11A : List.Disjoint names (Typ.list_prod_free_vars (Typ.constraints_instantiate (depth + List.length bs) [Typ.var name] cs)) := by
      simp [List.Disjoint] at h9
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.list_prod_free_vars_instantiate_upper_bound at h12
      simp [Typ.free_vars] at h12
      cases h12 with
      | inl h13 =>
        apply h9 h11
        apply Typ.list_prod_free_vars_instantiate_lower_bound _ _ h13
      | inr h13 =>
        rw [h13] at h11
        exact h8 h11

    have h11B : List.Disjoint names (Typ.free_vars (Typ.instantiate (depth + List.length bs) [Typ.var name] body)) := by
      simp [List.Disjoint] at h10
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.free_vars_instantiate_upper_bound at h12
      simp [Typ.free_vars] at h12
      cases h12 with
      | inl h13 =>
        apply h10 h11
        apply Typ.free_vars_instantiate_lower_bound _ _ h13
      | inr h13 =>
        rw [h13] at h11
        exact h8 h11

    have ⟨am'',h12A,h12B,h12C⟩ := h6 h11A h11B


    exists am''
    simp [*]
    rw [←List.append_assoc]

    have h14 :
      ∀ t' ∈ List.map Typ.var names,
        t' = Typ.instantiate depth [t] t'
    := by
      intro t h14
      have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
      rw [←h16]
      simp [Typ.instantiate]

    rw [Typ.list_instantiate_identity h14]
    rw [←h7]
    rw [←List.length_map Typ.var]


    have h2A : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom] at h2
      simp [Prod.dom,h2]
      rw [←h12A] at h8
      simp [Prod.dom] at h8
      exact h8

    apply And.intro
    {
      rw [←Typ.constraints_instantiate_zero_inside_out]
      apply MultiSubtyping.generalized_nameless_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      {
        rw [List.append_assoc]
        rw [Typ.constraints_instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [h7]
        rw [←Typ.list_instantiate_identity]
        { exact h12B }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }
    }
    { rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_nameless_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      {
        rw [List.append_assoc]
        rw [Typ.instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [h7]

        rw [←Typ.list_instantiate_identity]
        { exact h12C }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }
    }

  | lfp b body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6
    simp [*]
    intro name' h7 h8
    specialize h6 name' h7

    have h9 : name' ∉ Typ.free_vars (Typ.instantiate (depth + 1) [Typ.var name] body) := by
      intro h9
      apply Typ.free_vars_instantiate_upper_bound at h9
      simp [Typ.free_vars] at h9
      cases h9 with
      | inl h10 =>
        apply h8
        apply Typ.free_vars_instantiate_lower_bound _ _ h10
      | inr h10 =>
        apply h7 h10

    have ⟨h11A,h11B⟩ := h6 h9
    apply And.intro
    {
      have h12 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
      := by
        simp [Typ.instantiate]


      rw [Typ.list_instantiate_identity h12]
      have h13 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h13]
      rw [←Typ.instantiate_zero_inside_out]

      apply PosMonotonic.generalized_nameless_instantiation
      { exact h1 }
      { exact h2 }
      { exact h3 }
      { intro h14
        apply h7 ((Eq.symm h14))
      }
      {
        rw [Typ.instantiate_zero_inside_out]
        rw [h13]
        have h14 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [.var name] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_instantiate_identity h14]
        apply h11A
      }
    }
    {
      intro P stable h12
      apply h11B P stable
      intro e' h13
      apply h12

      have h14 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_instantiate_identity h14]
      have h16 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h16]

      have h17 :
        (name', P) :: (am' ++ (name, fun e => Typing name [] e t) :: am) =
        ((name', P) :: am') ++ (name, fun e => Typing name [] e t) :: am
      := by exact rfl

      rw [h17]

      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_nameless_instantiation
      {
        simp [Prod.dom]
        simp [Prod.dom] at h1
        exact And.symm ⟨h1, fun h18 => h7 (Eq.symm h18)⟩
      }
      { exact h2 }
      { exact h3 }
      { have h18 :
          (name', P) :: (am' ++ (name, fun e => Typing name [] e t) :: am) =
          ((name', P) :: am') ++ (name, fun e => Typing name [] e t) :: am
        := by exact rfl
        rw [←h18]
        rw [Typ.instantiate_zero_inside_out]
        rw [h16]
        have h19 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
        := by
          simp [Typ.instantiate]
        rw [←Typ.list_instantiate_identity h19]
        exact h13
      }
    }
  termination_by (Typ.size body, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.size, Typ.size_instantiate] ; try linarith)
    all_goals (
      try rw [Typ.constraints_size_instantiate] <;> (try linarith)
      try rw [Typ.size_instantiate] <;> (try linarith)
      intro e
      apply Typ.mem_map_var_size
    )


  /-
  -- NOTE:
  -- requirement: Typ.free_vars t ⊆ Prod.dom am
  -- ensures fresh wrt am (e.g. within universal/existential rule) is transferred to freshness wrt t
  -- necessary, since the universal rule has no awareness of t directly
  -/
  /-
  -- TODO: cannot prove that name is disjoint from introduced names unless
  -- name is already in m1
  -- maybe simply shouldn't drop variables at all
  -- can simply use stable as a placeholder
  -/
  theorem Typing.generalized_named_instantiation :
    name ∉ Prod.dom am' →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Typing name (am' ++ (name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [t] body) →
    Typing name (am' ++ (name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [.var name] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        intro h3 h4 h5 h6
        simp [Typ.shift_vars]
        simp [Typing]
        apply And.intro (Typing.safety h6)
        exists (fun e => Typing name [] e t)
        apply And.intro
        {
          unfold Stable
          simp
          intro e e' h8
          apply Iff.intro
          { intro h9 ; exact Typing.subject_reduction h8 h9 }
          { intro h9 ; exact Typing.subject_expansion h8 h9 }
        }
        { apply And.intro
          { rw [Prod.find_append_suffix _ _ ]
            { simp [Prod.find] }
            { exact h3 }
          }
          { simp
            simp [Typ.wellformed] at h5
            have ⟨h8,_⟩ := h5

            apply Typing.env_reflection (by simp [h4])
            apply Typing.env_cons_suffix_reflection (by simp [h4])
            apply Typing.env_append_suffix_reflection (by simp [h4])
            rw [Typ.instantiated_shift_vars_preservation h8]
            exact h6

          }
        }
      }
      { simp [h1] }
    }
    { simp [h0] }
  | var name' =>
    simp [Typ.instantiate, Typing]
  | iso l body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5
    simp [*]
    apply Typing.generalized_named_instantiation h1 h2 h3 h5
  | entry l body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5
    simp [*]
    apply Typing.generalized_named_instantiation h1 h2 h3 h5
  | path left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    simp [*]
    intro arg h9
    apply Typing.generalized_named_instantiation h2 h3 h4
    apply h6
    apply Typing.generalized_nameless_instantiation h2 h3 h4 h9

  | bot =>
    simp [Typ.instantiate, Typing]
  | top =>
    simp [Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5
    cases h5 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_named_instantiation h2 h3 h4 h7
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_named_instantiation h2 h3 h4 h7
  | inter left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h6
    apply And.intro
    { apply Typing.generalized_named_instantiation h2 h3 h4 h5 }
    { apply Typing.generalized_named_instantiation h2 h3 h4 h6 }
  | diff left right =>
    simp [Typ.instantiate, Typing]
    intro h2 h3 h4 h5 h7
    apply And.intro
    { apply Typing.generalized_named_instantiation h2 h3 h4 h5 }
    { intro h9
      apply h7
      apply Typing.generalized_nameless_instantiation h2 h3 h4 h9
    }
  | all bs cs body =>
    simp [Typ.instantiate]
    intro h2
    simp [Typing, Prod.dom]
    intro h3 h4 h5 h6 names h7 h8 h9 h10 h11
    simp [*]
    apply And.intro h6
    exists names
    simp [*]
    apply And.intro
    { apply And.intro
      { simp [List.Disjoint] at h9
        simp [List.Disjoint]
        intro name' h12 h13
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars] at h13
        cases h13 with
        | inl h14 =>
          apply h9 h12
          apply Typ.list_prod_free_vars_instantiate_lower_bound _ _ h14
        | inr h14 =>
          rw [h14] at h12
          exact h8 h12
      }
      { simp [List.Disjoint] at h10
        simp [List.Disjoint]
        intro name' h12 h13
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars] at h13
        cases h13 with
        | inl h14 =>
          apply h10 h12
          apply Typ.free_vars_instantiate_lower_bound _ _ h14
        | inr h14 =>
          rw [h14] at h12
          exact h8 h12
      }
    }
    intro am'' h13 h14

    have h15 :
      ∀ t' ∈ List.map Typ.var names,
        t' = Typ.instantiate depth [Typ.var name] t'
    := by
      intro t h15
      have ⟨p,h16,h17⟩ := Iff.mp List.mem_map h15
      rw [←h17]
      simp [Typ.instantiate]


    rw [Typ.list_instantiate_identity h15]
    rw [←h7]
    rw [←List.length_map Typ.var]
    rw [←Typ.instantiate_zero_inside_out]

    have h16A :
      am'' ++ (am' ++ (name, fun e => Typing name [] e t) :: am) =
      (am'' ++ am') ++ (name, fun e => Typing name [] e t) :: am
    := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing name [] e t) :: am))
    rw [h16A]

    have h2A : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom] at h2
      simp [Prod.dom,h2]
      rw [←h13] at h8
      simp [Prod.dom] at h8
      exact h8

    apply Typing.generalized_named_instantiation h2A h3 h4
    { rw [List.append_assoc]
      rw [Typ.instantiate_zero_inside_out]
      rw [List.length_map Typ.var]
      rw [h7]

      have h16 :
        ∀ t' ∈ List.map Typ.var names,
          t' = Typ.instantiate depth [t] t'
      := by
        intro t h16
        have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
        rw [←h18]
        simp [Typ.instantiate]


      rw [←Typ.list_instantiate_identity h16]
      apply h11 _ h13
      rw [←List.append_assoc]
      rw [Typ.list_instantiate_identity h16]
      rw [←h7]
      rw [←List.length_map Typ.var]
      rw [←Typ.constraints_instantiate_zero_inside_out]
      apply MultiSubtyping.generalized_nameless_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      { rw [←h16A]
        rw [Typ.constraints_instantiate_zero_inside_out]
        rw [List.length_map]
        rw [h7]
        rw [←Typ.list_instantiate_identity h15]
        exact h14
      }
    }

  | exi bs cs body =>
    simp [Typ.instantiate, Typing]

    intro h2 h3 h4 h5 h6
    apply And.intro h5
    intro names h7 h8 h9 h10
    specialize h6 names h7 h8

    have h11A : List.Disjoint names (Typ.list_prod_free_vars (Typ.constraints_instantiate (depth + List.length bs) [t] cs)) := by
      simp [List.Disjoint] at h9
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.list_prod_free_vars_instantiate_upper_bound at h12
      simp [h3] at h12
      apply h9 h11
      apply Typ.list_prod_free_vars_instantiate_lower_bound _ _ h12

    have h11B : List.Disjoint names (Typ.free_vars (Typ.instantiate (depth + List.length bs) [t] body)) := by
      simp [List.Disjoint] at h10
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.free_vars_instantiate_upper_bound at h12
      simp [h3] at h12
      apply h10 h11
      apply Typ.free_vars_instantiate_lower_bound _ _ h12

    have ⟨am'', h12A, h12B, h12C⟩ := h6 h11A h11B
    exists am''
    apply And.intro h12A
    have h13 :
      am'' ++ (am' ++ (name, fun e => Typing name [] e t) :: am) =
      (am'' ++ am') ++ (name, fun e => Typing name [] e t) :: am
    := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing name [] e t) :: am))
    rw [h13]

    have h14 :
      ∀ t' ∈ List.map Typ.var names,
        t' = Typ.instantiate depth [Typ.var name] t'
    := by
      intro t h14
      have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
      rw [←h16]
      simp [Typ.instantiate]

    rw [Typ.list_instantiate_identity h14]
    rw [←h7]
    rw [←List.length_map Typ.var]

    have h2A : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom] at h2
      simp [Prod.dom,h2]
      rw [←h12A] at h8
      simp [Prod.dom] at h8
      exact h8

    apply And.intro
    {
      rw [←Typ.constraints_instantiate_zero_inside_out]
      apply MultiSubtyping.generalized_named_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      {
        rw [List.append_assoc]
        rw [Typ.constraints_instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [h7]

        rw [←Typ.list_instantiate_identity]
        { exact h12B }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }
    }
    { rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_named_instantiation
      { exact h2A }
      { exact h3 }
      { exact h4 }
      {
        rw [List.append_assoc]
        rw [Typ.instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [h7]

        rw [←Typ.list_instantiate_identity]
        { exact h12C }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }
    }

  | lfp b body =>
    simp [Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6
    simp [*]
    intro name' h7 h8
    specialize h6 name' h7


    have h9 : name' ∉ Typ.free_vars (Typ.instantiate (depth + 1) [t] body)  := by
      intro h9
      apply Typ.free_vars_instantiate_upper_bound at h9
      simp [h2] at h9
      apply h8
      apply Typ.free_vars_instantiate_lower_bound _ _ h9


    have ⟨h11A,h11B⟩ := h6 h9
    apply And.intro
    {
      have h12 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_instantiate_identity h12]
      have h13 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h13]
      rw [←Typ.instantiate_zero_inside_out]
      apply PosMonotonic.generalized_named_instantiation
      { exact h1 }
      { exact h2 }
      { exact h3 }
      { intro h14 ; apply h7 ; simp [h14] }
      {
        rw [Typ.instantiate_zero_inside_out]
        rw [h13]
        have h14 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_instantiate_identity h14]
        apply h11A
      }
    }
    { intro P stable h12
      apply h11B P stable
      intro e' h13
      apply h12

      have h14 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_instantiate_identity h14]
      have h16 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h16]

      have h17 :
        (name', P) :: (am' ++ (name, fun e => Typing name [] e t) :: am) =
        ((name', P) :: am') ++ (name, fun e => Typing name [] e t) :: am
      := by exact rfl
      rw [h17]

      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_named_instantiation
      { simp [Prod.dom]
        simp [Prod.dom] at h1
        simp [*]
        intro h18
        apply h7 ; simp [h18]
      }
      { exact h2 }
      { exact h3 }
      {

        rw [Typ.instantiate_zero_inside_out]
        have h18 :
          (name', P) :: (am' ++ (name, fun e => Typing name [] e t) :: am) =
          ((name', P) :: am') ++ (name, fun e => Typing name [] e t) :: am
        := by exact rfl
        rw [←h18]
        rw [h16]
        have h19 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_instantiate_identity h19]
        exact h13
      }
    }
  termination_by (Typ.size body, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.size, Typ.size_instantiate] ; try linarith)
    all_goals (
      try rw [Typ.constraints_size_instantiate] <;> (try linarith)
      try rw [Typ.size_instantiate] <;> (try linarith)
      intro e
      apply Typ.mem_map_var_size
    )
end

theorem Typing.nameless_instantiation :
  name ∉ Typ.free_vars body →
  Typ.free_vars t = [] →
  Typ.wellformed t →
  Typing name ((name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [.var name] body) →
  Typing name am e (Typ.instantiate depth [t] body)
:= by
  intro h0 h1 h2 h3
  apply @Typing.env_cons_suffix_reflection _ _ _ (fun e => Typing name [] e t)
  {
    intro h5
    apply Typ.free_vars_instantiate_upper_bound at h5
    simp [h1] at h5
    apply h0 h5
  }
  {
    have h5 :
      (name, fun e => Typing name [] e t) :: am =
      [] ++ (name, fun e => Typing name [] e t) :: am
    := by rfl
    rw [h5]
    apply Typing.generalized_nameless_instantiation
    { simp [Prod.dom] }
    { exact h1 }
    { exact h2 }
    { exact h3 }
  }

theorem Typing.named_instantiation :
  name ∉ Typ.free_vars body →
  Typ.free_vars t = [] →
  Typ.wellformed t →
  Typing name am e (Typ.instantiate depth [t] body) →
  Typing name ((name,fun e => Typing name [] e t) :: am) e (Typ.instantiate depth [.var name] body)
:= by
  intro h0 h1 h2 h3
  have h5 :
    (name, fun e => Typing name [] e t) :: am =
    [] ++ (name, fun e => Typing name [] e t) :: am
  := by rfl
  rw [h5]
  apply Typing.generalized_named_instantiation
  { simp [Prod.dom]}
  { exact h1 }
  { exact h2 }
  {
    simp
    apply Typing.env_cons_suffix_preservation _ _ (fun e => Typing name [] e t)
    { intro h6
      apply Typ.free_vars_instantiate_upper_bound at h6
      simp [h1] at h6
      apply h0 h6
    }
    { exact h3 }
  }


end Lang
