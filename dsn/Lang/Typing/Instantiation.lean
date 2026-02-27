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
    name ∉ Typ.free_vars lower →
    name ∉ Typ.free_vars upper →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    Subtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper) →
    Subtyping (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper)
  := by
    simp [Subtyping, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { exact Typ.wellformed_nameless_instantiation h6 wf }
    { intro e h8
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      {
        apply h7
        apply Typing.generalized_named_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h8 }
      }
    }
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])

  theorem Subtyping.generalized_named_instantiation :
    name ∉ Typ.free_vars lower →
    name ∉ Typ.free_vars upper →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    Subtyping (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper) →
    Subtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper)
  := by
    simp [Subtyping, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { exact Typ.wellformed_named_instantiation h6 name }
    { intro e h8
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      {
        apply h7
        apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h8 }
      }
    }
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])




  theorem Monotonic.generalized_nameless_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    point ∉ Prod.dom am' →
    point ≠ name →
    point ∉ Prod.dom am →
    Monotonic point (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] body) →
    Monotonic point (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] body)
  := by
    simp [Monotonic, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 h6 h7 h8 P0 P1 h9 e h10

    have h11 :
      (point, P1) :: (am' ++ (name, fun e => False) :: am) =
      ((point, P1) :: am') ++ (name, fun e => False) :: am
    := by rfl

    rw [h11]
    apply Typing.generalized_nameless_instantiation h0 h1
    {
      simp [List.Disjoint, Prod.dom]
      apply And.intro h7
      simp [List.Disjoint] at h2
      exact h2
    }
    { simp [Prod.dom]
      apply And.intro
      { intro h12 ; exact h6 (Eq.symm h12) }
      { exact h3 }
    }
    { simp [Prod.dom] ; exact h4 }
    { exact wf }
    {
      simp
      apply h8 _ _ h9

      have h12 :
        (point, P0) :: (am' ++ (name, fun e => Typing am e t) :: am) =
        ((point, P0) :: am') ++ (name, fun e => Typing am e t) :: am
      := by rfl

      rw [h12]
      apply Typing.generalized_named_instantiation h0 h1
      {
        simp [List.Disjoint, Prod.dom]
        apply And.intro h7
        simp [List.Disjoint] at h2
        exact h2
      }
      { simp [Prod.dom]
        apply And.intro
        { intro h12 ; exact h6 (Eq.symm h12) }
        { exact h3 }
      }
      { simp [Prod.dom] ; exact h4 }
      { exact wf }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem Monotonic.generalized_named_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    point ∉ Prod.dom am' →
    point ≠ name →
    point ∉ Prod.dom am →
    Monotonic point (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] body) →
    Monotonic point (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] body)
  := by
    simp [Monotonic, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 h6 h7 h8 P0 P1 h9 e h10

    have h11 :
      (point, P1) :: (am' ++ (name, fun e => Typing am e t) :: am) =
      ((point, P1) :: am') ++ (name, fun e => Typing am e t) :: am
    := by rfl

    rw [h11]
    apply Typing.generalized_named_instantiation h0 h1
    {
      simp [List.Disjoint, Prod.dom]
      apply And.intro h7
      simp [List.Disjoint] at h2
      exact h2
    }
    { simp [Prod.dom]
      apply And.intro
      { intro h12 ; exact h6 (Eq.symm h12) }
      { exact h3 }
    }
    { simp [Prod.dom] ; exact h4 }
    { exact wf }
    {
      simp
      apply h8 _ _ h9

      have h12 :
        (point, P0) :: (am' ++ (name, fun e => False) :: am) =
        ((point, P0) :: am') ++ (name, fun e => False) :: am
      := by rfl

      rw [h12]
      apply Typing.generalized_nameless_instantiation h0 h1
      {
        simp [List.Disjoint, Prod.dom]
        apply And.intro h7
        simp [List.Disjoint] at h2
        exact h2
      }
      { simp [Prod.dom]
        apply And.intro
        { intro h12 ; exact h6 (Eq.symm h12) }
        { exact h3 }
      }
      { simp [Prod.dom] ; exact h4 }
      { exact wf }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem MultiSubtyping.generalized_nameless_instantiation :
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    MultiSubtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.constraints_instantiate depth [.var name] cs) →
    MultiSubtyping (am' ++ (name,fun e => False) :: am) (Typ.constraints_instantiate depth [t] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping, Prod.dom]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping, Prod.dom, Typ.list_prod_free_vars]
    intro h0 h1 h2 h3 h4 h5 h6 wf h7 h8
    apply And.intro
    { apply Subtyping.generalized_nameless_instantiation h0 h1 h3 h4
      { simp [Prod.dom] ; exact h5 }
      { simp [Prod.dom] ; exact h6 }
      { exact wf }
      { exact h7 }
    }
    { apply MultiSubtyping.generalized_nameless_instantiation h2 h3 h4
      { simp [Prod.dom] ; exact h5 }
      { simp [Prod.dom] ; exact h6 }
      { exact wf }
      { exact h8 }
    }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])


  theorem MultiSubtyping.generalized_named_instantiation :
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    MultiSubtyping (am' ++ (name,fun e => False) :: am) (Typ.constraints_instantiate depth [t] cs) →
    MultiSubtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.constraints_instantiate depth [.var name] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping, Prod.dom, Typ.list_prod_free_vars]
    intro h0 h1 h2 h3 h4 h5 h6 wf h7 h8
    apply And.intro
    { apply Subtyping.generalized_named_instantiation h0 h1 h3 h4
      { simp [Prod.dom] ; exact h5 }
      { simp [Prod.dom] ; exact h6 }
      { exact wf }
      { exact h7 }
    }
    { apply MultiSubtyping.generalized_named_instantiation h2 h3 h4
      { simp [Prod.dom] ; exact h5 }
      { simp [Prod.dom] ; exact h6 }
      { exact wf }
      { exact h8 }
    }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])


  theorem Typing.generalized_nameless_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    Typing (am' ++ (name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body) →
    Typing (am' ++ (name,fun e => False) :: am) e (Typ.instantiate depth [t] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate, Prod.dom]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        simp [Typ.shift_vars]
        intro h2 h3 h4 h5 h6 wf
        simp [Typing]
        intro h7 P h8 h9 h10
        rw [Prod.find_append_suffix _ _] at h9
        {
          simp [Prod.find] at h9
          simp [←h9] at h10
          have h11 := Typing.instantiated h10
          rw [←Typ.instantiated_shift_vars_preservation h11]
          apply Typing.env_append_suffix_preservation (List.disjoint_of_subset_right h3 h4)
          apply Typing.env_cons_suffix_preservation
          {
            intro h12
            specialize h3 h12
            simp [Prod.dom] at h3
            have ⟨P',h13⟩ := h3
            apply h6 P' h13
          }
          { exact h10 }
        }
        { simp [Prod.dom] ; exact h5 }
      }
      { simp [h1]
        simp [Typing]
      }
    }
    { simp [h0]
      simp [Typing]
    }
  | var name' =>
    simp [Typ.instantiate, Typ.free_vars, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 P h6 h7 h8
    simp [*]
    exists P
    simp [*]
    rw [Prod.find_append_mid _ _ (Ne.symm h0)]
    rw [Prod.find_append_mid _ _ (Ne.symm h0)] at h7
    apply h7
  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_nameless_instantiation h0 h1 h2
    { simp [Prod.dom]; exact h3 }
    { simp [Prod.dom]; exact h4 }
    { exact wf }
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_nameless_instantiation h0 h1 h2
    { simp [Prod.dom]; exact h3 }
    { simp [Prod.dom]; exact h4 }
    { exact wf }
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro
    { apply Typ.wellformed_nameless_instantiation h7
      exact wf
    }
    { intro arg h9
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      {
        apply h8
        apply Typing.generalized_named_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | bot =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
  | top =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6
    cases h6 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_nameless_instantiation h0 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { apply Typing.generalized_nameless_instantiation h0 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h6 }
    }
    { apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
    }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    apply And.intro
    { apply Typ.wellformed_nameless_instantiation h6 wf }
    { apply And.intro
      { apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h7 }
      }
      { intro h9
        apply h8
        apply Typing.generalized_named_instantiation h1 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate]
    intro h0 h1 h2
    simp [Typing, Prod.dom]
    intro h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro h7
    intro am'' h9 h10 h11 h12 h13

    have h14 :
      ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
        t' = Typ.instantiate depth [t] t'
    := by
      intro t h14
      have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
      rw [←h16]
      simp [Typ.instantiate]

    rw [Typ.list_all_mem_instantiate_preservation h14]
    rw [←h9]
    rw [←List.length_map (fun x => Typ.var (Prod.fst x))]
    rw [←Typ.instantiate_zero_inside_out]

    rw [←List.append_assoc]

    apply Typing.generalized_nameless_instantiation
    {
      intro h16
      apply Typ.free_vars_instantiate_upper_bound at h16
      rw [List.mem_append] at h16
      cases h16 with
      | inl h17 =>
        apply h1
        exact h17
      | inr h16 =>
        simp [Typ.free_vars] at h16
        have ⟨P,h17⟩ := h16
        exact h11 P h17
    }
    { exact h2 }
    { simp [Prod.dom]; exact ⟨h12, h3⟩ }
    { simp [Prod.dom]; exact ⟨h11, h4⟩ }
    { simp [Prod.dom]; exact h5 }
    { exact wf }
    {
      rw [List.append_assoc]
      rw [Typ.instantiate_zero_inside_out]
      rw [List.length_map (fun x => Typ.var (Prod.fst x))]
      rw [h9]

      have h16 :
        ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
          t' = Typ.instantiate depth [.var name] t'
      := by
        intro t h16
        have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
        rw [←h18]
        simp [Typ.instantiate]


      rw [←Typ.list_all_mem_instantiate_preservation h16]
      apply h8 _ h9 h10 h11 h12
      {
        rw [←List.append_assoc]
        rw [Typ.list_all_mem_instantiate_preservation h16]
        rw [←h9]
        rw [←List.length_map (fun x => Typ.var (Prod.fst x))]
        rw [←Typ.constraints_instantiate_zero_inside_out]
        apply MultiSubtyping.generalized_named_instantiation
        {
          intro h17
          have h18 := Typ.list_prod_free_vars_instantiate_upper_bound h17
          simp [Typ.free_vars] at h18
          cases h18 with
          | inl h19 =>
            exact h0 h19
          | inr h19 =>
            have ⟨P,h20⟩ := h19
            exact h11 P h20
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h12, h3⟩ }
        { simp [Prod.dom]; exact ⟨h11, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { rw [List.append_assoc]
          rw [Typ.constraints_instantiate_zero_inside_out]
          rw [List.length_map]
          rw [h9]
          rw [←Typ.list_all_mem_instantiate_preservation h14]
          exact h13
        }
      }
    }

  | exi bs cs body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]

    intro h0 h1 h2 h3 h4 h5 wf h6 am'' h7 h8 h9 h10 h11 h12
    apply And.intro h6
    exists am''
    apply And.intro h7
    apply And.intro
    { apply And.intro h8
      apply And.intro h9
      exact h10
    }
    {
      rw [←List.append_assoc]

      have h14 :
        ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
          t' = Typ.instantiate depth [t] t'
      := by
        intro t h14
        have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
        rw [←h16]
        simp [Typ.instantiate]

      rw [Typ.list_all_mem_instantiate_preservation h14]
      rw [←h7]
      rw [←List.length_map (fun x => Typ.var (Prod.fst x))]

      apply And.intro
      {
        rw [←Typ.constraints_instantiate_zero_inside_out]
        apply MultiSubtyping.generalized_nameless_instantiation
        {
          intro h16
          apply Typ.list_prod_free_vars_instantiate_upper_bound at h16
          rw [List.mem_append] at h16
          cases h16 with
          | inl h17 =>
            exact h0 h17
          | inr h17 =>
            simp [Typ.free_vars] at h17
            have ⟨P,h18⟩ := h17
            exact h9 P h18
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h10, h3⟩ }
        { simp [Prod.dom]; exact ⟨h9, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        {
          rw [List.append_assoc]
          rw [Typ.constraints_instantiate_zero_inside_out]
          rw [List.length_map (fun x => Typ.var (Prod.fst x))]
          rw [h7]
          rw [←Typ.list_all_mem_instantiate_preservation]
          { exact h11 }
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
        {
          intro h16
          apply Typ.free_vars_instantiate_upper_bound at h16
          rw [List.mem_append] at h16
          cases h16 with
          | inl h17 =>
            apply h1
            exact h17
          | inr h17 =>
            simp [Typ.free_vars] at h17
            have ⟨P,h18⟩ := h17
            exact h9 P h18
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h10, h3⟩ }
        { simp [Prod.dom]; exact ⟨h9, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        {
          rw [List.append_assoc]
          rw [Typ.instantiate_zero_inside_out]
          rw [List.length_map (fun x => Typ.var (Prod.fst x))]
          rw [h7]

          rw [←Typ.list_all_mem_instantiate_preservation]
          { exact h12 }
          {
            intro t h16
            have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
            rw [←h18]
            simp [Typ.instantiate]
          }
        }
      }
    }

  | lfp b body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 h6 name' h7 h8 h9 h10 h11
    simp [*]
    exists name'
    simp [*]
    apply And.intro
    {
      have h12 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
      := by
        simp [Typ.instantiate]


      rw [Typ.list_all_mem_instantiate_preservation h12]
      have h13 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h13]
      rw [←Typ.instantiate_zero_inside_out]

      apply Monotonic.generalized_nameless_instantiation
      { intro h14
        apply Typ.free_vars_instantiate_upper_bound at h14
        simp [Typ.free_vars] at h14
        cases h14 with
        | inl h15 =>
          exact h0 h15
        | inr h15 =>
          exact h8 (Eq.symm h15)
      }
      { exact h1 }
      { exact h2 }
      { simp [Prod.dom]; exact h3 }
      { simp [Prod.dom]; exact h4 }
      { exact wf }
      { simp [Prod.dom]; exact h7 }
      { exact h8 }
      { simp [Prod.dom]; exact h9 }
      {
        rw [Typ.instantiate_zero_inside_out]
        rw [h13]
        have h14 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [.var name] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_all_mem_instantiate_preservation h14]
        apply h10
      }
    }
    { intro P stable h12
      apply h11 P stable
      intro e' h13
      apply h12


      have h14 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_all_mem_instantiate_preservation h14]
      have h16 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h16]

      have h17 :
        (name', P) :: (am' ++ (name, fun e => False) :: am) =
        ((name', P) :: am') ++ (name, fun e => False) :: am
      := by exact rfl
      rw [h17]

      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_nameless_instantiation
      {
        intro h18
        apply Typ.free_vars_instantiate_upper_bound at h18
        simp [Typ.free_vars] at h18
        cases h18 with
        | inl h19 =>
          exact h0 h19
        | inr h19 =>
          exact h8 (Eq.symm h19)
      }
      { exact h1 }
      { simp [Prod.dom]; exact ⟨h9, h2⟩ }
      { simp [*, Prod.dom]; intro h18 ; exact h8 (Eq.symm h18) }
      { simp [*, Prod.dom] }
      { exact wf }
      {

        have h18 :
          (name', P) :: (am' ++ (name, fun e => Typing am e t) :: am) =
          ((name', P) :: am') ++ (name, fun e => Typing am e t) :: am
        := by exact rfl
        rw [←h18]
        rw [Typ.instantiate_zero_inside_out]
        rw [h16]
        have h19 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
        := by
          simp [Typ.instantiate]
        rw [←Typ.list_all_mem_instantiate_preservation h19]
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

  theorem Typing.generalized_named_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ Prod.dom am →
    List.Disjoint (Prod.dom am') (Prod.dom am) →
    name ∉ Prod.dom am' →
    name ∉ Prod.dom am →
    Typ.wellformed t →
    Typing (am' ++ (name,fun e => False) :: am) e (Typ.instantiate depth [t] body) →
    Typing (am' ++ (name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate, Prod.dom]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        intro h2 h3 h4 h5 h6 wf h7
        simp [Typ.shift_vars]
        simp [Typing]
        apply And.intro (Typing.safety h7)
        exists (fun e => Typing am e t)
        apply And.intro
        {
          unfold Stable
          simp
          intro e e' h8
          apply Iff.intro
          { intro h9 ; exact Typing.subject_reduction h8 h9 }
          { intro h9 ; exact Typing.subject_expansion h8 h9 }
        }
        {
          apply And.intro
          { rw [Prod.find_append_suffix _ _ ]
            { simp [Prod.find] }
            { simp [Prod.dom];
              intro P
              exact h5 P
            }
          }
          { simp
            have h8 := Typing.instantiated h7
            have h9 : name ∉ Typ.free_vars t := by
              intro h10
              specialize h3 h10
              simp [Prod.dom] at h3
              have ⟨P,h11⟩ := h3
              apply h6 P h11
            apply Typing.env_cons_suffix_reflection h9

            apply Typing.env_append_suffix_reflection (List.disjoint_of_subset_right h3 h4)
            rw [← Typ.instantiated_shift_vars_reflection h8]
            exact h7

          }
        }
      }
      { simp [h1]
        simp [Typing]
      }
    }
    { simp [h0]
      simp [Typing]
    }
  | var name' =>
    simp [Typ.instantiate, Typ.free_vars, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 P h6 h7 h8
    simp [*]
    exists P
    simp [*]
    rw [Prod.find_append_mid _ _ (Ne.symm h0)]
    rw [Prod.find_append_mid _ _ (Ne.symm h0)] at h7
    apply h7
  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_named_instantiation h0 h1 h2
    { simp [Prod.dom]; exact h3 }
    { simp [Prod.dom]; exact h4 }
    { exact wf }
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_named_instantiation h0 h1 h2
    { simp [Prod.dom]; exact h3 }
    { simp [Prod.dom]; exact h4 }
    { exact wf }
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro
    { apply Typ.wellformed_named_instantiation h7 }
    { intro arg h9
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      {
        apply h8
        apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | bot =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
  | top =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6
    cases h6 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_named_instantiation h0 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { apply Typing.generalized_named_instantiation h0 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h6 }
    }
    { apply Typing.generalized_named_instantiation h1 h2 h3
      { simp [Prod.dom]; exact h4 }
      { simp [Prod.dom]; exact h5 }
      { exact wf }
      { exact h7 }
    }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    apply And.intro
    { apply Typ.wellformed_named_instantiation h6 }
    { apply And.intro
      { apply Typing.generalized_named_instantiation h0 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h7 }
      }
      { intro h9
        apply h8
        apply Typing.generalized_nameless_instantiation h1 h2 h3
        { simp [Prod.dom]; exact h4 }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate]
    intro h0 h1 h2
    simp [Typing, Prod.dom]
    intro h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro h7
    intro am'' h9 h10 h11 h12 h13

    have h14 :
      ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
        t' = Typ.instantiate depth [Typ.var name] t'
    := by
      intro t h14
      have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
      rw [←h16]
      simp [Typ.instantiate]


    rw [Typ.list_all_mem_instantiate_preservation h14]
    rw [←h9]
    rw [←List.length_map (fun x => Typ.var (Prod.fst x))]
    rw [←Typ.instantiate_zero_inside_out]

    have h15 :
      am'' ++ (am' ++ (name, fun e => Typing am e t) :: am) =
      (am'' ++ am') ++ (name, fun e => Typing am e t) :: am
    := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing am e t) :: am))
    rw [h15]

    apply Typing.generalized_named_instantiation
    {
      intro h16
      apply Typ.free_vars_instantiate_upper_bound at h16
      rw [List.mem_append] at h16
      cases h16 with
      | inl h17 =>
        apply h1
        exact h17
      | inr h16 =>
        simp [Typ.free_vars] at h16
        have ⟨P,h17⟩ := h16
        exact h11 P h17
    }
    { exact h2 }
    { simp [Prod.dom]; exact ⟨h12, h3⟩ }
    { simp [Prod.dom]; exact ⟨h11, h4⟩ }
    { simp [Prod.dom]; exact h5 }
    { exact wf }
    {
      rw [List.append_assoc]
      rw [Typ.instantiate_zero_inside_out]
      rw [List.length_map (fun x => Typ.var (Prod.fst x))]
      rw [h9]

      have h16 :
        ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
          t' = Typ.instantiate depth [t] t'
      := by
        intro t h16
        have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
        rw [←h18]
        simp [Typ.instantiate]


      rw [←Typ.list_all_mem_instantiate_preservation h16]
      apply h8 _ h9 h10 h11 h12
      {
        rw [←List.append_assoc]
        rw [Typ.list_all_mem_instantiate_preservation h16]
        rw [←h9]
        rw [←List.length_map (fun x => Typ.var (Prod.fst x))]
        rw [←Typ.constraints_instantiate_zero_inside_out]
        apply MultiSubtyping.generalized_nameless_instantiation
        {
          intro h17
          have h18 := Typ.list_prod_free_vars_instantiate_upper_bound h17
          simp [Typ.free_vars] at h18
          cases h18 with
          | inl h19 =>
            exact h0 h19
          | inr h19 =>
            have ⟨P,h20⟩ := h19
            exact h11 P h20
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h12, h3⟩ }
        { simp [Prod.dom]; exact ⟨h11, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        { rw [←h15]
          rw [Typ.constraints_instantiate_zero_inside_out]
          rw [List.length_map]
          rw [h9]
          rw [←Typ.list_all_mem_instantiate_preservation h14]
          exact h13
        }
      }
    }

  | exi bs cs body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]

    intro h0 h1 h2 h3 h4 h5 wf h6 am'' h7 h8 h9 h10 h11 h12
    apply And.intro h6
    exists am''
    apply And.intro ; exact h7
    apply And.intro
    { apply And.intro h8
      apply And.intro h9
      exact h10
    }
    {
      have h13 :
        am'' ++ (am' ++ (name, fun e => Typing am e t) :: am) =
        (am'' ++ am') ++ (name, fun e => Typing am e t) :: am
      := by exact Eq.symm (List.append_assoc am'' am' ((name, fun e => Typing am e t) :: am))
      rw [h13]

      have h14 :
        ∀ t' ∈ List.map (fun x => Typ.var (Prod.fst x)) am'',
          t' = Typ.instantiate depth [Typ.var name] t'
      := by
        intro t h14
        have ⟨p,h15,h16⟩ := Iff.mp List.mem_map h14
        rw [←h16]
        simp [Typ.instantiate]

      rw [Typ.list_all_mem_instantiate_preservation h14]
      rw [←h7]
      rw [←List.length_map (fun x => Typ.var (Prod.fst x))]

      apply And.intro
      {
        rw [←Typ.constraints_instantiate_zero_inside_out]
        apply MultiSubtyping.generalized_named_instantiation
        {
          intro h16
          apply Typ.list_prod_free_vars_instantiate_upper_bound at h16
          rw [List.mem_append] at h16
          cases h16 with
          | inl h17 =>
            exact h0 h17
          | inr h17 =>
            simp [Typ.free_vars] at h17
            have ⟨P,h18⟩ := h17
            exact h9 P h18
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h10, h3⟩ }
        { simp [Prod.dom]; exact ⟨h9, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        {
          rw [List.append_assoc]
          rw [Typ.constraints_instantiate_zero_inside_out]
          rw [List.length_map (fun x => Typ.var (Prod.fst x))]
          rw [h7]

          rw [←Typ.list_all_mem_instantiate_preservation]
          { exact h11 }
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
        {
          intro h16
          apply Typ.free_vars_instantiate_upper_bound at h16
          rw [List.mem_append] at h16
          cases h16 with
          | inl h17 =>
            apply h1
            exact h17
          | inr h17 =>
            simp [Typ.free_vars] at h17
            have ⟨P,h18⟩ := h17
            exact h9 P h18
        }
        { exact h2 }
        { simp [Prod.dom]; exact ⟨h10, h3⟩ }
        { simp [Prod.dom]; exact ⟨h9, h4⟩ }
        { simp [Prod.dom]; exact h5 }
        { exact wf }
        {
          rw [List.append_assoc]
          rw [Typ.instantiate_zero_inside_out]
          rw [List.length_map (fun x => Typ.var (Prod.fst x))]
          rw [h7]

          rw [←Typ.list_all_mem_instantiate_preservation]
          { exact h12 }
          {
            intro t h16
            have ⟨p,h17,h18⟩ := Iff.mp List.mem_map h16
            rw [←h18]
            simp [Typ.instantiate]
          }
        }
      }
    }

  | lfp b body =>
    simp [Typ.free_vars, Typ.instantiate, Typing, Prod.dom]
    intro h0 h1 h2 h3 h4 wf h5 h6 name' h7 h8 h9 h10 h11
    simp [*]
    exists name'
    simp [*]
    apply And.intro
    {
      have h12 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_all_mem_instantiate_preservation h12]
      have h13 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h13]
      rw [←Typ.instantiate_zero_inside_out]
      apply Monotonic.generalized_named_instantiation
      { intro h14
        apply Typ.free_vars_instantiate_upper_bound at h14
        simp [Typ.free_vars] at h14
        cases h14 with
        | inl h15 =>
          exact h0 h15
        | inr h15 =>
          exact h8 (Eq.symm h15)
      }
      { exact h1 }
      { exact h2 }
      { simp [Prod.dom]; exact h3 }
      { simp [Prod.dom]; exact h4 }
      { exact wf }
      { simp [Prod.dom]; exact h7 }
      { exact h8 }
      { simp [Prod.dom]; exact h9 }
      {
        rw [Typ.instantiate_zero_inside_out]
        rw [h13]
        have h14 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_all_mem_instantiate_preservation h14]
        apply h10
      }
    }
    { intro P stable h12
      apply h11 P stable
      intro e' h13
      apply h12


      have h14 :
        ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [Typ.var name] t'
      := by
        simp [Typ.instantiate]

      rw [Typ.list_all_mem_instantiate_preservation h14]
      have h16 : List.length [Typ.var name'] = 1 := by exact rfl
      rw [←h16]

      have h17 :
        (name', P) :: (am' ++ (name, fun e => Typing am e t) :: am) =
        ((name', P) :: am') ++ (name, fun e => Typing am e t) :: am
      := by exact rfl
      rw [h17]

      rw [←Typ.instantiate_zero_inside_out]
      apply Typing.generalized_named_instantiation
      {
        intro h18
        apply Typ.free_vars_instantiate_upper_bound at h18
        simp [Typ.free_vars] at h18
        cases h18 with
        | inl h19 =>
          exact h0 h19
        | inr h19 =>
          exact h8 (Eq.symm h19)
      }
      { exact h1 }
      { simp [Prod.dom]; exact ⟨h9, h2⟩ }
      { simp [*, Prod.dom]; intro h18 ; exact h8 (Eq.symm h18) }
      { simp [*, Prod.dom] }
      { exact wf }
      {

        rw [Typ.instantiate_zero_inside_out]
        have h18 :
          (name', P) :: (am' ++ (name, fun e => False) :: am) =
          ((name', P) :: am') ++ (name, fun e => False) :: am
        := by exact rfl
        rw [←h18]
        rw [h16]
        have h19 :
          ∀ t' ∈ [Typ.var name'], t' = Typ.instantiate depth [t] t'
        := by
          simp [Typ.instantiate]

        rw [←Typ.list_all_mem_instantiate_preservation h19]
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
  Typ.free_vars t ⊆ Prod.dom am →
  name ∉ Prod.dom am →
  Typ.wellformed t →
  Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body) →
  Typing am e (Typ.instantiate depth [t] body)
:= by
  simp [Prod.dom]
  intro h0 h1 h2 wf h3
  apply @Typing.env_cons_suffix_reflection _ _ (fun e => False)
  {
    intro h5
    apply Typ.free_vars_instantiate_upper_bound at h5
    simp at h5
    cases h5 with
    | inl h6 =>
      apply h0 h6
    | inr h6 =>
      specialize h1 h6
      simp at h1
      have ⟨P,h7⟩ := h1
      exact h2 P h7
  }
  {
    have h5 :
      (name, fun e => False) :: am =
      [] ++ (name, fun e => False) :: am
    := by rfl
    rw [h5]
    apply Typing.generalized_nameless_instantiation h0 h1
    { simp [Prod.dom]}
    { exact Iff.mp List.count_eq_zero rfl }
    { simp [Prod.dom]; exact h2 }
    { exact wf }
    { exact h3 }
  }

theorem Typing.named_instantiation :
  name ∉ Typ.free_vars body →
  Typ.free_vars t ⊆ Prod.dom am →
  name ∉ Prod.dom am →
  Typ.wellformed t →
  Typing am e (Typ.instantiate depth [t] body) →
  Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body)
:= by
  simp [Prod.dom]
  intro h0 h1 h2 wf h3
  have h5 :
    (name, fun e => Typing am e t) :: am =
    [] ++ (name, fun e => Typing am e t) :: am
  := by rfl
  rw [h5]
  apply Typing.generalized_named_instantiation h0 h1
  { simp [Prod.dom]}
  { exact Iff.mp List.count_eq_zero rfl }
  { simp [Prod.dom]; exact h2 }
  { exact wf }
  {
    simp
    apply Typing.env_cons_suffix_preservation _ _ (fun e => False)
    { intro h6
      apply Typ.free_vars_instantiate_upper_bound at h6
      simp at h6
      cases h6 with
      | inl h7 =>
        apply h0 h7
      | inr h7 =>
        specialize h1 h7
        simp at h1
        have ⟨P,h8⟩ := h1
        exact h2 P h8
    }
    { exact h3 }
  }



end Lang
