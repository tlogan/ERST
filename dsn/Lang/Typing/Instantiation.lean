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

----------------------------------------------
-- mutual
--   theorem Typing.instantiate_name_generalization :
--     name ∉ Prod.dom am' →
--     name ∉ Typ.free_vars body →
--     Typing (am' ++ (name,P) :: am) e (Typ.instantiate depth [.var name] body) →
--     ∀ {name'},
--     name' ∉ Prod.dom am' →
--     name' ∉ Typ.free_vars body →
--     Typing (am' ++ (name',P) :: am) e (Typ.instantiate depth [.var name'] body)
--   := by sorry
-- end


mutual
  theorem Typing.generalized_instantiate_names_generalization :
    List.length names = List.length preds →
    List.Disjoint names (Prod.dom m') →
    List.Disjoint names (Typ.free_vars body) →
    Typing (m' ++ (List.zip names preds) ++ m) e (Typ.instantiate depth (List.map .var names) body) →
    ∀ {names'},
    List.length names' = List.length preds →
    List.Disjoint names' (Prod.dom m') →
    List.Disjoint names' (Typ.free_vars body) →
    Typing (m' ++ (List.zip names' preds) ++ m) e (Typ.instantiate depth (List.map .var names') body)
  := by sorry
end

theorem MultiSubtyping.instantiate_names_generalization :
  List.length names = List.length preds →
  List.Disjoint names (Typ.list_prod_free_vars cs) →
  MultiSubtyping ((List.zip names preds) ++ m) (Typ.constraints_instantiate depth (List.map .var names) cs) →
  ∀ {names'},
  List.length names' = List.length preds →
  List.Disjoint names' (Typ.list_prod_free_vars cs) →
  MultiSubtyping ((List.zip names' preds) ++ m) (Typ.constraints_instantiate depth (List.map .var names') cs)
:= by sorry

theorem Typing.instantiate_names_generalization :
  List.length names = List.length preds →
  List.Disjoint names (Typ.free_vars body) →
  Typing ((List.zip names preds) ++ m) e (Typ.instantiate depth (List.map .var names) body) →
  ∀ {names'},
  List.length names' = List.length preds →
  List.Disjoint names' (Typ.free_vars body) →
  Typing ((List.zip names' preds) ++ m) e (Typ.instantiate depth (List.map .var names') body)
:= by sorry


theorem PosMonotonic.instantiate_name_generalization :
  name ∉ (Typ.free_vars body) →
  PosMonotonic name m (Typ.instantiate depth [.var name] body) →
  ∀ {name'},
  name' ∉ (Typ.free_vars body) →
  PosMonotonic name' m (Typ.instantiate depth [.var name'] body)
:= by sorry

theorem Typing.instantiate_name_generalization :
  name ∉ (Typ.free_vars body) →
  Typing ((name,P) :: m) e (Typ.instantiate depth [.var name] body) →
  ∀ {name'},
  name' ∉ (Typ.free_vars body) →
  Typing ((name',P) :: m) e (Typ.instantiate depth [.var name'] body)
:= by sorry



----------------------------------------------


/-
-- TODO: can we prove name_instantiate_generalization
-- TODO: can we use name_instantiate_generalization
-- to prove name_instantiate_


-- PROBLEM: why would name_generalization be provable but not naming?
-- seems like it would have the same issue:
-- it needs to use bound variables names that are disjoint from the new name
----------
-- THE DIFFERENCE: with name generalization, you have the induction hypothesis
-- which allows you to swap out the names
-- then we can use name generalization directly inside the naming proof.
----------
-- wait, wait, wait: could we just combine the naming/anonymization to get name_generalization?
-- actually no; name generalization doesn't require the predicate to contain a syntactic typing judgment;
----------
-- TODO: get rid of the tmp vars
-- TODO: try to prove naming/anonymization using instantiate_name_generalization

--
-/

-- /- TODO: maybe this isn't necessary -/
-- theorem Typing.tmpvar_generalization :
--   Typing tmp m e t →
--   ∀ tmp' , Typing tmp' m e t
-- := by sorry



set_option maxHeartbeats 500000 in
mutual


  theorem Subtyping.generalized_instantiate_anonymization :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars lower →
    name ∉ Typ.free_vars upper →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Subtyping (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper) →
    Subtyping (am' ++ am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper)
  := by
    simp [Subtyping]
    intro h0 h1 h2 h3 h4 h5 e h6
    apply Typing.generalized_instantiate_anonymization h0 h2 h3 h4
    apply h5
    apply Typing.generalized_instantiate_naming h0 h1 h3 h4 h6
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])

  theorem Subtyping.generalized_instantiate_naming :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars lower →
    name ∉ Typ.free_vars upper →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Subtyping (am' ++ am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper) →
    Subtyping (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper)
  := by
    simp [Subtyping]
    intro h0 h1 h2 h3 h4 h5 e h6
    apply Typing.generalized_instantiate_naming h0 h2 h3 h4
    apply h5
    apply Typing.generalized_instantiate_anonymization h0 h1 h3 h4 h6
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])




  theorem PosMonotonic.generalized_instantiate_anonymization :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars body →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    name ≠ point →
    PosMonotonic point (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.instantiate depth [.var name] body) →
    PosMonotonic point (am' ++ am) (Typ.instantiate depth [t] body)
  := by
    simp [PosMonotonic]
    intro h0 h1 h2 h3
    intro h5
    intro h7 P0 P1 stable_P0 stable_P1 h9 e h10
    rw [←List.cons_append]
    apply @Typing.generalized_instantiate_anonymization _ name
    { simp [Prod.dom] at h0
      simp [Prod.dom,h0,h5]
    }
    { exact h1 }
    { exact h2 }
    { exact h3 }
    { simp
      apply h7 _ _ stable_P0 stable_P1 h9
      rw [←List.cons_append]
      apply Typing.generalized_instantiate_naming
      { simp [Prod.dom] at h0
        simp [Prod.dom,h0,h5]
      }
      { exact h1 }
      { exact h2 }
      { exact h3 }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem PosMonotonic.generalized_instantiate_naming :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars body →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    name ≠  point →
    PosMonotonic point (am' ++ am) (Typ.instantiate depth [t] body) →
    PosMonotonic point (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.instantiate depth [.var name] body)
  := by
    simp [PosMonotonic]
    intro h0 h1 h2 h3 h5
    intro h7 P0 P1 stable_P0 stable_P1 h9 e h10

    rw [←List.cons_append]
    apply Typing.generalized_instantiate_naming
    { simp [Prod.dom] at h0
      simp [Prod.dom,h0,h5]
    }
    { exact h1 }
    { exact h2 }
    { exact h3 }
    { simp
      apply h7 _ _ stable_P0 stable_P1 h9
      rw [←List.cons_append]
      apply @Typing.generalized_instantiate_anonymization _ name
      { simp [Prod.dom] at h0
        simp [Prod.dom,h0,h5]
      }
      { exact h1 }
      { exact h2 }
      { exact h3 }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem MultiSubtyping.generalized_instantiate_anonymization :
    name ∉ Prod.dom am' →
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    MultiSubtyping (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.constraints_instantiate depth [.var name] cs) →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate depth [t] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.list_prod_free_vars,Typ.constraints_instantiate, MultiSubtyping]
    intro h3 h4 h5 h6 h7 h8 h9 h10
    apply And.intro
    { apply Subtyping.generalized_instantiate_anonymization h3 h4 h5 h7 h8 h9 }
    { apply MultiSubtyping.generalized_instantiate_anonymization h3 h6 h7 h8 h10 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size, List.pair_typ_size, List.pair_typ_zero_lt_size])


  theorem MultiSubtyping.generalized_instantiate_naming :
    name ∉ Prod.dom am' →
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    MultiSubtyping (am' ++ am) (Typ.constraints_instantiate depth [t] cs) →
    MultiSubtyping (am' ++ (name,fun e => Typing [] e t) :: am) (Typ.constraints_instantiate depth [.var name] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.list_prod_free_vars,Typ.constraints_instantiate, MultiSubtyping]
    intro h3 h4 h5 h6 h7 h8 h9 h10
    apply And.intro
    { apply Subtyping.generalized_instantiate_naming h3 h4 h5 h7 h8 h9 }
    { apply MultiSubtyping.generalized_instantiate_naming h3 h6 h7 h8 h10 }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size, List.pair_typ_size, List.pair_typ_zero_lt_size])


  theorem Typing.generalized_instantiate_anonymization :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars body →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Typing (am' ++ (name,fun e => Typing [] e t) :: am) e (Typ.instantiate depth [.var name] body) →
    Typing (am' ++ am) e (Typ.instantiate depth [t] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        simp [Typ.shift_vars]
        intro h3 h4 h5 h6
        simp [Typing]
        intro h7 P h8 h9 h10
        rw [Prod.find_append_suffix _ h3] at h9
        simp [Prod.find] at h9
        simp [←h9] at h10

        simp [Typ.wellformed] at h6
        have ⟨h11,_⟩ := h6
        rw [←Typ.instantiated_shift_vars_preservation h11]
        apply Typing.env_preservation h5 h10
      }
      { simp [h1,Typing] }
    }
    { simp [h0,Typing] }
  | var name' =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 P stable h5 h6
    simp [*]
    exists P
    simp [*]
    by_cases h7 : name' ∈ Prod.dom am'
    {
      rw [Prod.find_append_prefix _ h7] at h5
      rw [Prod.find_append_prefix _ h7]
      exact h5
    }
    {
      rw [Prod.find_append_suffix _ h7] at h5
      rw [Prod.find_append_suffix _ h7]
      simp [Prod.find] at h5
      simp [h1] at h5
      exact h5
    }
  | iso l body =>
    simp [Typ.instantiate, Typing, Typ.free_vars]
    intro h0 h1 h2 h3 h4 h5
    simp [h4]
    apply Typing.generalized_instantiate_anonymization h0 h1 h2 h3 h5
  | entry l body =>
    simp [Typ.instantiate, Typing, Typ.free_vars]
    intro h0 h1 h2 h3 h4 h5
    simp [h4]
    apply Typing.generalized_instantiate_anonymization h0 h1 h2 h3 h5
  | path left right =>
    simp [Typ.instantiate, Typing, Typ.free_vars]
    intro h0 h2 h3 h4 h5 h6 h7
    simp [*]
    { intro arg h9
      apply Typing.generalized_instantiate_anonymization h0 h3 h4 h5
      apply h7
      apply Typing.generalized_instantiate_naming h0 h2 h4 h5 h9
    }
  | bot =>
    simp [Typ.instantiate, Typing]
  | top =>
    simp [Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6
    cases h6 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_instantiate_anonymization h1 h2 h4 h5 h7
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_instantiate_anonymization h1 h3 h4 h5 h7
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6 h7
    apply And.intro
    { apply Typing.generalized_instantiate_anonymization h1 h2 h4 h5 h6 }
    { apply Typing.generalized_instantiate_anonymization h1 h3 h4 h5 h7 }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6 h7
    apply And.intro
    { apply Typing.generalized_instantiate_anonymization h1 h2 h4 h5 h6 }
    { intro h9
      apply h7
      apply Typing.generalized_instantiate_naming h1 h3 h4 h5 h9
    }
  | all bs cs body =>
    simp [Typ.free_vars,Typ.instantiate]
    intro h1 h2A h2B
    simp [Typing]
    intro h3 h4 h5 h6 names h7 h8 h9 h10
    simp [h5]
    apply And.intro h6
    exists names
    simp [*]
    apply And.intro
    {
      apply And.intro
      { simp [List.Disjoint] at h8
        simp [List.Disjoint]
        intro name' h12 h13
        apply h8 h12
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h13
        simp [h3] at h13
        apply Typ.list_prod_free_vars_instantiate_lower_bound _ _ h13
      }
      { simp [List.Disjoint] at h9
        simp [List.Disjoint]
        intro name' h12 h13
        apply h9 h12
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [h3] at h13
        apply Typ.free_vars_instantiate_lower_bound _ _ h13
      }
    }
    { intro am'' h13 h14
      by_cases h15 : Typ.list_prod_instantiated cs ∧ Typ.instantiated body
      { have ⟨h15A,h15B⟩ := h15
        rw [Typ.instantiated_instantiate_identity h15B]
        rw [Typ.instantiated_instantiate_identity h15B]

        rw [←List.append_assoc]

        apply Typing.env_insert_reflection (Or.inl h2B)
        rw [←Typ.instantiated_instantiate_identity h15B]
        rw [←Typ.instantiated_instantiate_identity h15B]
        rw [List.append_assoc]
        apply h10 _ h13
        rw [Typ.list_prod_instantiated_instantiate_identity h15A]
        rw [Typ.list_prod_instantiated_instantiate_identity h15A]

        rw [←List.append_assoc]
        apply MultiSubtyping.env_insert_preservation (Or.inl h2A)
        rw [←Typ.list_prod_instantiated_instantiate_identity h15A]
        rw [←Typ.list_prod_instantiated_instantiate_identity h15A]
        rw [List.append_assoc]
        exact h14
      }
      {

        have h1A : name ∉ names := by
          simp at h15
          by_cases h17 : Typ.list_prod_instantiated cs
          {
            specialize h15 h17
            simp [List.Disjoint] at h9
            intro h18
            apply h9 h18
            apply Typ.free_vars_instantiator_lower_bound
            { exact ne_true_of_eq_false h15 }
            { simp [Typ.list_free_vars, Typ.free_vars] }
          }
          {
            simp [List.Disjoint] at h8
            intro h18
            apply h8 h18
            apply Typ.list_prod_free_vars_instantiator_lower_bound _ _ h17
            simp [Typ.list_free_vars, Typ.free_vars]
          }

        have h1B : name ∉ Prod.dom (am'' ++ am') := by
          simp [Prod.dom]
          simp [Prod.dom] at h1
          rw [←h13] at h1A
          simp [Prod.dom] at h1A
          exact ⟨h1A, h1⟩

        have h16A :
          ∀ t' ∈ List.map Typ.var names,
            t' = Typ.instantiate depth [t] t'
        := by
          intro t h16
          have ⟨p,h16A,h16B⟩ := Iff.mp List.mem_map h16
          rw [←h16B]
          simp [Typ.instantiate]

        rw [Typ.list_instantiate_identity h16A]
        rw [←h7]
        rw [←List.length_map Typ.var]
        rw [←Typ.instantiate_zero_inside_out]
        rw [←List.append_assoc]

        apply Typing.generalized_instantiate_anonymization
        { exact h1B }
        { intro h17
          apply Typ.free_vars_instantiate_upper_bound at h17
          simp at h17
          simp [h2B, Typ.free_vars] at h17
          exact h1A h17
        }
        { exact h3 }
        { exact h4 }
        {
          rw [List.append_assoc]
          rw [Typ.instantiate_zero_inside_out]
          rw [List.length_map Typ.var]
          rw [h7]

          have h16B :
            ∀ t' ∈ List.map Typ.var names,
              t' = Typ.instantiate depth [.var name] t'
          := by
            intro t h16
            have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
            rw [←h18]
            simp [Typ.instantiate]


          rw [←Typ.list_instantiate_identity h16B]
          apply h10 _ h13
          rw [←List.append_assoc]
          rw [Typ.list_instantiate_identity h16B]
          rw [←h7]
          rw [←List.length_map Typ.var]
          rw [←Typ.constraints_instantiate_zero_inside_out]

          apply MultiSubtyping.generalized_instantiate_naming
          { exact h1B }
          { intro h17
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h17
            simp at h17
            simp [h2A, Typ.free_vars] at h17
            exact h1A h17
          }
          { exact h3 }
          { exact h4 }
          { rw [List.append_assoc]
            rw [Typ.constraints_instantiate_zero_inside_out]
            rw [List.length_map]
            rw [h7]
            rw [←Typ.list_instantiate_identity h16A]
            exact h14
          }
        }
      }
    }

  | exi bs cs body =>
    simp [Typ.free_vars,Typ.instantiate,Typing]
    intro h2 h3A h3B h4 h5 h6 h7
    apply And.intro h6
    intro names h8 h9 h10

    have ⟨names',length_eq,disjointness⟩ := String.fresh_names (List.length bs) (name :: Typ.list_prod_free_vars cs ++ Typ.free_vars body)

    specialize h7 names' length_eq
    have h11A : List.Disjoint names' (Typ.list_prod_free_vars (Typ.constraints_instantiate (depth + List.length bs) [Typ.var name] cs)) := by
      simp [List.Disjoint] at disjointness
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.list_prod_free_vars_instantiate_upper_bound at h12
      simp [Typ.free_vars] at h12
      have ⟨h14,h15,h16⟩ := disjointness h11
      simp [h14] at h12
      exact h15 h12

    have h11B : List.Disjoint names' (Typ.free_vars (Typ.instantiate (depth + List.length bs) [Typ.var name] body)) := by
      simp [List.Disjoint] at disjointness
      simp [List.Disjoint]
      intro name' h11 h12
      apply Typ.free_vars_instantiate_upper_bound at h12
      simp [Typ.free_vars] at h12
      have ⟨h14,h15,h16⟩ := disjointness h11
      simp [h14] at h12
      exact h16 h12

    have ⟨am'',h12A,h12B,h12C⟩ := h7 h11A h11B


    have h12D :
      ∀ t' ∈ List.map Typ.var names',
        t' = Typ.instantiate depth [t] t'
    := by
      intro t h14
      have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
      rw [←h16]
      simp [Typ.instantiate]



    have h2A : name ∉ names' := by
      simp [List.Disjoint] at disjointness
      intro h13
      specialize disjointness h13
      simp at disjointness


    have h2B : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom]
      simp [Prod.dom] at h2
      simp [h2]
      rw [←h12A] at h2A
      simp [Prod.dom] at h2A
      exact h2A


    have h12B' : MultiSubtyping (am'' ++ (am' ++ am))
      (Typ.constraints_instantiate 0 (List.map Typ.var names')
      (Typ.constraints_instantiate (depth + List.length bs) [t] cs))
    := by
      rw [←List.append_assoc]
      rw [Typ.list_instantiate_identity h12D]
      rw [←length_eq]
      rw [←List.length_map Typ.var]
      rw [←Typ.constraints_instantiate_zero_inside_out]
      apply MultiSubtyping.generalized_instantiate_anonymization
      { exact h2B }
      {
        intro h13
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars,h2A,h3A] at h13
      }
      { exact h4 }
      { exact h5 }
      {
        rw [List.append_assoc]
        rw [Typ.constraints_instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [length_eq]
        rw [←Typ.list_instantiate_identity]
        { exact h12B }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }


    have h12C' : Typing (am'' ++ (am' ++ am)) e
      (Typ.instantiate 0 (List.map Typ.var names')
      (Typ.instantiate (depth + List.length bs) [t] body))
    := by
      rw [←List.append_assoc]
      rw [Typ.list_instantiate_identity h12D]
      rw [←length_eq]
      rw [←List.length_map Typ.var]
      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_instantiate_anonymization
      { exact h2B }
      {
        intro h13
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars,h2A,h3B] at h13
      }
      { exact h4 }
      { exact h5 }
      {
        rw [List.append_assoc]
        rw [Typ.instantiate_zero_inside_out]
        rw [List.length_map Typ.var]
        rw [length_eq]

        rw [←Typ.list_instantiate_identity]
        { exact h12C }
        {
          intro t h16
          have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
          rw [←h18]
          simp [Typ.instantiate]
        }
      }

    have h13 : am'' = List.zip names' (Prod.range am'') := by
      rw [←h12A]
      simp [Prod.dom, Prod.range]
      apply List.zip_of_prod rfl rfl

    rw [h13] at h12B'
    rw [h13] at h12C'

    have h14 : List.length names' = List.length (Prod.range am'') := by
      simp [Prod.range]
      apply congrArg List.length at h12A
      simp [Prod.dom] at h12A
      simp [h12A]

    have h15 : List.length names = List.length (Prod.range am'') := by
      simp [Prod.range]
      apply congrArg List.length at h12A
      simp [Prod.dom] at h12A
      rw [h12A]
      simp [h8,length_eq]

    exists (List.zip names (Prod.range am''))
    apply And.intro
    { rw [Prod.dom_zip_eq h15] }
    apply And.intro
    {
      apply MultiSubtyping.instantiate_names_generalization h14
      {
        simp [List.Disjoint]
        simp [List.Disjoint] at disjointness
        intro name'' h16 h17
        have ⟨h18,h19,h20⟩ := disjointness h16
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h17
        simp at h17
        simp [h19,h4] at h17
      }
      { exact h12B' }
      { exact h15 }
      { exact h9 }
    }
    {
      apply Typing.instantiate_names_generalization h14
      {
        simp [List.Disjoint]
        simp [List.Disjoint] at disjointness
        intro name'' h16 h17
        have ⟨h18,h19,h20⟩ := disjointness h16
        apply Typ.free_vars_instantiate_upper_bound at h17
        simp at h17
        simp [h20,h4] at h17
      }
      { exact h12C' }
      { exact h15 }
      { exact h10 }
    }



  | lfp b body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 h6
    simp [*]
    intro name' h7



    have ⟨name'',h8⟩ := String.fresh_name (name :: Typ.free_vars body)
    simp at h8
    have ⟨h8A,h8B⟩ := h8

    specialize h6 name''

    have h9 : name'' ∉ Typ.free_vars (Typ.instantiate (depth + 1) [Typ.var name] body) := by
      intro h9
      apply Typ.free_vars_instantiate_upper_bound at h9
      simp [Typ.free_vars] at h9
      simp [*] at h9



    have ⟨h11A,h11B⟩ := h6 h9

    have h11A' : PosMonotonic name'' (am' ++ am)
      (Typ.instantiate 0 [Typ.var name''] (Typ.instantiate (depth + 1) [t] body))
    := by
      have h12 :
        ∀ t' ∈ [Typ.var name''], t' = Typ.instantiate depth [t] t'
      := by
        simp [Typ.instantiate]


      rw [Typ.list_instantiate_identity h12]
      have h13 : List.length [Typ.var name''] = 1 := by exact rfl
      rw [←h13]
      rw [←Typ.instantiate_zero_inside_out]

      apply PosMonotonic.generalized_instantiate_anonymization
      { exact h0 }
      {
        intro h14
        apply Typ.free_vars_instantiate_upper_bound at h14
        simp [Typ.free_vars,h1] at h14
        apply h8A
        simp [h14]
      }
      { exact h2 }
      { exact h3 }
      { intro h14
        exact h8A (Eq.symm h14)
      }
      {
        rw [Typ.instantiate_zero_inside_out]
        rw [h13]
        have h14 :
          ∀ t' ∈ [Typ.var name''], t' = Typ.instantiate depth [.var name] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_instantiate_identity h14]
        apply h11A
      }


    apply And.intro
    {

      apply @PosMonotonic.instantiate_name_generalization _ name''
      {
        intro h13
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [h2,h8B] at h13
      }
      { exact h11A' }
      { exact h7 }
    }
    {
      intro P stable h12
      apply h11B P stable
      intro e' h13
      apply h12

      have h11B' : Typing ((name'', P) :: (am' ++ am)) e'
        (Typ.instantiate 0 [Typ.var name''] (Typ.instantiate (depth + 1) [t] body))
      := by

        have h14 :
          ∀ t' ∈ [Typ.var name''], t' = Typ.instantiate depth [t] t'
        := by
          simp [Typ.instantiate]

        rw [Typ.list_instantiate_identity h14]
        have h16 : List.length [Typ.var name''] = 1 := by exact rfl
        rw [←h16]

        have h17 :
          (name'', P) :: (am' ++ am) =
          ((name'', P) :: am') ++ am
        := by exact rfl

        rw [h17]

        rw [←Typ.instantiate_zero_inside_out]
        apply @Typing.generalized_instantiate_anonymization _ name
        {
          simp [Prod.dom]
          simp [Prod.dom] at h0
          apply And.intro
          { intro h18 ; exact h8A (Eq.symm h18) }
          { intro P ; exact h0 P }
        }
        {
          intro h18
          apply Typ.free_vars_instantiate_upper_bound at h18
          simp [Typ.free_vars,h1] at h18
          apply h8A
          simp [h18]
        }
        { exact h2 }
        { exact h3 }
        { have h18 :
            (name'', P) :: (am' ++ (name, fun e => Typing [] e t) :: am) =
            ((name'', P) :: am') ++ (name, fun e => Typing [] e t) :: am
          := by exact rfl
          rw [←h18]
          rw [Typ.instantiate_zero_inside_out]
          rw [h16]
          have h19 :
            ∀ t' ∈ [Typ.var name''], t' = Typ.instantiate depth [Typ.var name] t'
          := by
            simp [Typ.instantiate]
          rw [←Typ.list_instantiate_identity h19]
          exact h13
        }

      apply @Typing.instantiate_name_generalization _ name''
      {
        intro h13
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [h2,h8B] at h13
      }
      { exact h11B'  }
      { exact h7  }
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


  theorem Typing.generalized_instantiate_naming :
    name ∉ Prod.dom am' →
    name ∉ Typ.free_vars body →
    Typ.free_vars t = [] →
    Typ.wellformed t →
    Typing (am' ++ am) e (Typ.instantiate depth [t] body) →
    Typing (am' ++ (name,fun e => Typing [] e t) :: am) e (Typ.instantiate depth [.var name] body)
  := by cases body with
  | bvar i =>
    simp [Typ.free_vars,Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        intro h3 h4 h5 h6
        simp [Typ.shift_vars]
        simp [Typing]
        apply And.intro (Typing.safety h6)
        exists (fun e => Typing [] e t)
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
            apply Typing.env_append_suffix_reflection (by simp [h4])
            rw [Typ.instantiated_shift_vars_preservation h8]
            exact h6

          }
        }
      }
      { simp [h1,Typing] }
    }
    { simp [h0,Typing] }
  | var name' =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 P stable h5 h6
    simp [*]
    exists P
    simp [*]
    by_cases h7 : name' ∈ Prod.dom am'
    {
      rw [Prod.find_append_prefix _ h7] at h5
      rw [Prod.find_append_prefix _ h7]
      exact h5
    }
    {
      rw [Prod.find_append_suffix _ h7] at h5
      rw [Prod.find_append_suffix _ h7]
      simp [Prod.find]
      simp [h1]
      exact h5
    }

  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5
    simp [*]
    apply Typing.generalized_instantiate_naming h0 h1 h2 h3 h5
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5
    simp [*]
    apply Typing.generalized_instantiate_naming h0 h1 h2 h3 h5
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h1 h2 h3 h4 h5 h6 h7
    simp [*]
    intro arg h9
    apply Typing.generalized_instantiate_naming h1 h3 h4 h5
    apply h7
    apply Typing.generalized_instantiate_anonymization h1 h2 h4 h5 h9

  | bot =>
    simp [Typ.instantiate, Typing]
  | top =>
    simp [Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5
    cases h5 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_instantiate_naming h0 h1 h3 h4 h7
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_instantiate_naming h0 h2 h3 h4 h7
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 h6
    apply And.intro
    { apply Typing.generalized_instantiate_naming h0 h1 h3 h4 h5 }
    { apply Typing.generalized_instantiate_naming h0 h2 h3 h4 h6 }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 h7
    apply And.intro
    { apply Typing.generalized_instantiate_naming h0 h1 h3 h4 h5 }
    { intro h9
      apply h7
      apply Typing.generalized_instantiate_anonymization h0 h2 h3 h4 h9
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate,Typing]
    intro h1 h2 h3 h4 h5 h6 h7 names h8 h9 h10 h11
    simp [*]
    apply And.intro h7

    have ⟨names',length_eq,disjointness⟩ := String.fresh_names (List.length bs) (name :: Typ.list_prod_free_vars cs ++ Typ.free_vars body)
    exists names'
    simp [*]
    apply And.intro
    { apply And.intro
      { simp [List.Disjoint] at disjointness
        simp [List.Disjoint]
        intro name' h12 h13
        have ⟨h14,h15,h16⟩ := disjointness h12
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars,h14,h15] at h13
      }
      { simp [List.Disjoint] at disjointness
        simp [List.Disjoint]
        intro name' h12 h13
        have ⟨h14,h15,h16⟩ := disjointness h12
        apply Typ.free_vars_instantiate_upper_bound at h13
        simp [Typ.free_vars,h14,h16] at h13
      }
    }

    intro am'' h13 h14


    have h15 :
      ∀ t' ∈ List.map Typ.var names',
        t' = Typ.instantiate depth [Typ.var name] t'
    := by
      intro t h15
      have ⟨p,h16,h17⟩ := Iff.mp List.mem_map h15
      rw [←h17]
      simp [Typ.instantiate]


    rw [Typ.list_instantiate_identity h15]
    rw [←length_eq]
    rw [←List.length_map Typ.var]
    rw [←Typ.instantiate_zero_inside_out]

    have h16A :
      am'' ++ (am' ++ (name, fun e => Typing [] e t) :: am) =
      (am'' ++ am') ++ (name, fun e => Typing [] e t) :: am
    := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing [] e t) :: am))
    rw [h16A]

    have h2A : name ∉ names' := by
      simp [List.Disjoint] at disjointness
      intro h17
      specialize disjointness h17
      simp at disjointness

    have h2B : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom] at h1
      simp [Prod.dom,h1]
      rw [←h13] at h2A
      simp [Prod.dom] at h2A
      exact h2A




    apply Typing.generalized_instantiate_naming h2B
    {
      intro h15
      apply Typ.free_vars_instantiate_upper_bound at h15
      simp [Typ.free_vars,h2A,h3] at h15
    }
    { exact h4 }
    { exact h5 }
    { rw [List.append_assoc]
      rw [Typ.instantiate_zero_inside_out]
      rw [List.length_map Typ.var]
      rw [length_eq]

      have h16 :
        ∀ t' ∈ List.map Typ.var names',
          t' = Typ.instantiate depth [t] t'
      := by
        intro t h16
        have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
        rw [←h18]
        simp [Typ.instantiate]


      rw [←Typ.list_instantiate_identity h16]

      have h17 : am'' = List.zip names' (Prod.range am'') := by
        rw [←h13]
        simp [Prod.dom, Prod.range]
        apply List.zip_of_prod rfl rfl

      rw [h17]

      have h18A : List.length names = List.length (Prod.range am'') := by
        simp [Prod.range]
        apply congrArg List.length at h13
        simp [Prod.dom] at h13
        simp [h13]
        simp [h8,length_eq]

      have h18B : List.length names' = List.length (Prod.range am'') := by
        simp [Prod.range]
        apply congrArg List.length at h13
        simp [Prod.dom] at h13
        simp [h13]

      apply @Typing.instantiate_names_generalization names
      { exact h18A }
      { exact h10 }
      {
        apply h11 _ (Prod.dom_zip_eq h18A)

        apply @MultiSubtyping.instantiate_names_generalization names'
        { exact h18B }
        { simp [List.Disjoint]
          simp [List.Disjoint] at disjointness
          intro name' h19
          have ⟨h20,h21,h22⟩ := disjointness h19
          intro h23
          apply Typ.list_prod_free_vars_instantiate_upper_bound at h23
          simp [h4,h21] at h23
        }
        {
          rw [←h17]
          rw [←List.append_assoc]
          rw [Typ.list_instantiate_identity h16]
          rw [←length_eq]
          rw [←List.length_map Typ.var]
          rw [←Typ.constraints_instantiate_zero_inside_out]
          apply MultiSubtyping.generalized_instantiate_anonymization
          { exact h2B }
          {
            intro h19
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h19
            simp [Typ.free_vars,h2A,h2] at h19
          }
          { exact h4 }
          { exact h5 }
          { rw [←h16A]
            rw [Typ.constraints_instantiate_zero_inside_out]
            rw [List.length_map]
            rw [length_eq]
            rw [←Typ.list_instantiate_identity h15]
            exact h14
          }
        }
        { exact h18A }
        { exact h9 }
      }
      { exact h18B }
      {
        simp [List.Disjoint]
        simp [List.Disjoint] at disjointness
        intro name' h19
        intro h20
        apply Typ.free_vars_instantiate_upper_bound at h20
        simp at h20
        have ⟨h21,h22,h23⟩ := disjointness h19
        simp [h4,h23] at h20
      }

    }

  | exi bs cs body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]

    intro h0 h1 h2 h3 h4 h5 h6
    apply And.intro h5
    intro names h7 h8 h9

    have h11A : List.Disjoint names
      (Typ.list_prod_free_vars (Typ.constraints_instantiate (depth + List.length bs) [t] cs))
    := by
      simp [List.Disjoint]
      simp [List.Disjoint] at h8
      intro name' h10 h11
      apply h8 h10
      apply Typ.list_prod_free_vars_instantiate_upper_bound at h11
      simp [h3] at h11
      apply Typ.list_prod_free_vars_instantiate_lower_bound
      exact h11

    have h11B : List.Disjoint names
      (Typ.free_vars (Typ.instantiate (depth + List.length bs) [t] body))
    := by
      simp [List.Disjoint]
      simp [List.Disjoint] at h9
      intro name' h10 h11
      apply h9 h10
      apply Typ.free_vars_instantiate_upper_bound at h11
      simp [h3] at h11
      apply Typ.free_vars_instantiate_lower_bound
      exact h11

    have ⟨am'',h12A,h12B,h12C⟩ := h6 names h7 h11A h11B

    exists am''

    by_cases h13 : Typ.list_prod_instantiated cs ∧ Typ.instantiated body
    { have ⟨h13A,h13B⟩ := h13

      apply And.intro h12A
      apply And.intro
      {

        rw [Typ.list_prod_instantiated_instantiate_identity h13A]
        rw [Typ.list_prod_instantiated_instantiate_identity h13A]

        rw [←List.append_assoc]

        apply MultiSubtyping.env_insert_preservation (Or.inl h1)

        rw [Typ.list_prod_instantiated_instantiate_identity h13A] at h12B
        rw [Typ.list_prod_instantiated_instantiate_identity h13A] at h12B
        rw [List.append_assoc]
        exact h12B
      }
      {
        rw [Typ.instantiated_instantiate_identity h13B]
        rw [Typ.instantiated_instantiate_identity h13B]

        rw [←List.append_assoc]

        apply Typing.env_insert_preservation (Or.inl h2)

        rw [Typ.instantiated_instantiate_identity h13B] at h12C
        rw [Typ.instantiated_instantiate_identity h13B] at h12C
        rw [List.append_assoc]
        exact h12C
      }

    }

    have h0A : name ∉ names := by
      simp at h13
      by_cases h14 : Typ.list_prod_instantiated cs
      {
        specialize h13 h14
        simp [List.Disjoint] at h9
        intro h18
        apply h9 h18
        apply Typ.free_vars_instantiator_lower_bound
        { exact ne_true_of_eq_false h13 }
        { simp [Typ.list_free_vars, Typ.free_vars] }
      }
      {
        simp [List.Disjoint] at h8
        intro h18
        apply h8 h18
        apply Typ.list_prod_free_vars_instantiator_lower_bound _ _ h14
        simp [Typ.list_free_vars, Typ.free_vars]
      }

    have h0B : name ∉ Prod.dom (am'' ++ am') := by
      simp [Prod.dom]
      simp [Prod.dom] at h0
      simp [h0]
      rw [←h12A] at h0A
      simp [Prod.dom] at h0A
      exact h0A

    apply And.intro h12A
    have h13 :
      am'' ++ (am' ++ (name, fun e => Typing [] e t) :: am) =
      (am'' ++ am') ++ (name, fun e => Typing [] e t) :: am
    := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing [] e t) :: am))
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


    apply And.intro
    {
      rw [←Typ.constraints_instantiate_zero_inside_out]
      apply MultiSubtyping.generalized_instantiate_naming
      { exact h0B }
      {
        intro h15
        apply Typ.list_prod_free_vars_instantiate_upper_bound at h15
        simp [Typ.free_vars,h0A,h1] at h15
      }
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
      apply Typing.generalized_instantiate_naming
      { exact h0B }
      {
        intro h15
        apply Typ.free_vars_instantiate_upper_bound at h15
        simp [Typ.free_vars,h0A,h2] at h15
      }
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
      apply PosMonotonic.generalized_instantiate_naming
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
        (name', P) :: (am' ++ (name, fun e => Typing [] e t) :: am) =
        ((name', P) :: am') ++ (name, fun e => Typing [] e t) :: am
      := by exact rfl
      rw [h17]

      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_instantiate_naming
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
          (name', P) :: (am' ++ (name, fun e => Typing [] e t) :: am) =
          ((name', P) :: am') ++ (name, fun e => Typing [] e t) :: am
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

theorem Typing.instantiate_anonymization :
  name ∉ Typ.free_vars body →
  Typ.free_vars t = [] →
  Typ.wellformed t →
  Typing ((name,fun e => Typing [] e t) :: am) e (Typ.instantiate depth [.var name] body) →
  Typing am e (Typ.instantiate depth [t] body)
:= by
  intro h0 h1 h2 h3
  have h5 :
    am = [] ++ am
  := by rfl
  rw [h5]
  apply Typing.generalized_instantiate_anonymization
  { simp [Prod.dom] }
  { exact h0 }
  { exact h1 }
  { exact h2 }
  { exact h3 }

theorem Typing.instantiate_naming :
  name ∉ Typ.free_vars body →
  Typ.free_vars t = [] →
  Typ.wellformed t →
  Typing am e (Typ.instantiate depth [t] body) →
  Typing ((name,fun e => Typing [] e t) :: am) e (Typ.instantiate depth [.var name] body)
:= by
  intro h0 h1 h2 h3
  have h5 :
    (name, fun e => Typing [] e t) :: am =
    [] ++ (name, fun e => Typing [] e t) :: am
  := by rfl
  rw [h5]
  apply Typing.generalized_instantiate_naming
  { simp [Prod.dom]}
  { exact h0 }
  { exact h1 }
  { exact h2 }
  { exact h3 }


end Lang
