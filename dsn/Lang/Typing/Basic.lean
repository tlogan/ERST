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
  def Subtyping (am : List (String × (Expr → Prop))) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing am e left → Typing am e right
  termination_by (Typ.size left + Typ.size right, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])


  def MultiSubtyping (am : List (String × (Expr → Prop))) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping am left right ∧ MultiSubtyping am remainder
  termination_by sts => (List.pair_typ_size sts, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])

  def PosMonotonic (name : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
    (∀ P0 P1 : Expr → Prop,
      Stable P0 → Stable P1 →
      (∀ e, P0 e → P1 e) →
      (∀ e , Typing ((name,P0)::am) e t → Typing ((name,P1)::am) e t)
    )
  termination_by (Typ.size t, 1)


  -- TODO: need to switch back to using recursive namespace;
  def Typing (am : List (String × (Expr → Prop))) (e : Expr) : Typ → Prop
  | .var id => Safe e ∧ ∃ P, Stable P ∧ Prod.find id am = some P ∧ P e
  | .bvar _ => False
  | .bot => False
  | .top => Safe e
  | .iso l t => Safe e ∧ Typing am (.extract e l) t
  | .entry l t => Safe e ∧ Typing am (.project e l) t
  | .path left right =>
    Safe e ∧
    ∀ arg , Typing am arg left → Typing am (.app e arg) right
  | .unio left right => Typing am e left ∨ Typing am e right
  | .inter left right => Typing am e left ∧ Typing am e right
  | .diff left right => Typing am e left ∧ ¬ (Typing am e right)

  | .exi bs cs body =>
    (∀ a ∈ bs , a = "") ∧
    ∀ names,
    List.length names = List.length bs →
    String.no_namespace_recursive names →
    List.Disjoint names (Prod.dom am) →
      ∃ am' , Prod.dom am' = names ∧
      (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) ∧
      (Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body))

  | .all bs cs body =>
    Safe e ∧
    (∀ a ∈ bs , a = "") ∧
    ∃ names,
    List.length names = List.length bs ∧
    String.no_namespace_recursive names ∧
    List.Disjoint names (Prod.dom am) ∧
    ∀ am' , Prod.dom am' = names →
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map Typ.var names) cs)) →
      (Typing (am' ++ am) e (Typ.instantiate 0 (List.map Typ.var names) body))
  | .lfp a body =>
    Safe e ∧
    a = "" ∧
    String.no_namespace_recursive (Typ.free_vars body) ∧
    ∀ name , String.namespace_recursive name →
      PosMonotonic name am (Typ.instantiate 0 [.var name] body) ∧
      /- infimum of -/
      (∀ P, Stable P →
        /- pre-fixed point -/
        (∀ e', Typing ((name,P) :: am) e' (Typ.instantiate 0 [.var name] body) → P e') →
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


def NegMonotonic (name : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
  (∀ P0 P1 : Expr → Prop,
    Stable P0 → Stable P1 →
    (∀ e, P0 e → P1 e) →
    (∀ e , Typing ((name,P1)::am) e t → Typing ((name,P0)::am) e t)
  )

def Monotonic (polarity : Bool) (name : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
  (polarity = true ∧ PosMonotonic name am t) ∨
  (polarity = false ∧ NegMonotonic name am t)

def MultiMonotonic (polarity : Bool) (name : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  ∀ lower upper, (lower,upper) ∈ cs → Monotonic (not polarity) name am lower ∧ Monotonic polarity name am upper

def EitherMultiMonotonic (name : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  MultiMonotonic .true name am cs ∨ MultiMonotonic .false name am cs


def MultiTyping
  (tam : List (String × (Expr → Prop))) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, Prod.find x context = .some t → ∃ e, (Prod.find x eam) = .some e ∧ Typing tam e t


theorem Typing.safety :
  Typing am e t → Safe e
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
  intro h0 h1 names h2 h3 h4 h5
  exact h0
| exi bs cs body =>
  simp [Typing]
  intro h0 h1 e' h2
  have ⟨names,h3,h4A, h4B⟩ := String.fresh_names (List.length bs) (Prod.dom am) String.quantified_prefix

  have h4 : String.no_namespace_recursive names := by
    simp [String.no_namespace_recursive, String.namespace_recursive, String.recursive_prefix]
    simp [String.IsPrefix, List.IsPrefix]
    intro name h5 xs
    specialize h4B name h5
    simp [String.quantified_prefix, String.IsPrefix, List.IsPrefix] at h4B
    have ⟨ys,h6⟩ := h4B
    rw [←h6]
    simp

  have ⟨am',h5,h6,h7⟩ := h1 names h3 h4 h4A
  apply Typing.safety h7 _ h2
| lfp x body =>
  simp [Typing]
  intro h0 h1 h2 h3 name h4
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
  Typing am e t → Expr.valued e ∨ ∃ e', NStep e e'
:= by
  intro h0
  apply Safe.progress
  apply Typing.safety h0


mutual
  theorem Typing.subject_reduction
    (transition : NStep e e')
  : Typing am e t → Typing am e' t
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
    intro names h3 h4A h4B
    have ⟨am',h5,h6,h7⟩ := h1 names h3 h4A h4B
    exists am'
    simp [*]
    apply Typing.subject_reduction transition h7

  | all bs quals body =>
    simp [Typing]
    intro h0 h1 names h2 h3A h3B h4
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
    intro safe nameless body_no_rec_namespace h0
    apply And.intro
    { exact Safe.subject_reduction transition safe }
    { apply And.intro nameless
      apply And.intro body_no_rec_namespace
      intro name name_no_rec_namespace
      have ⟨h1,h2⟩ := h0 name name_no_rec_namespace
      apply And.intro h1
      intro P h3 h4
      apply Stable.subject_reduction h3 transition
      exact h2 P h3 h4
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
  : Typing am e' t → Typing am e t
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
    intro names h3 h4A h4B
    have ⟨am',h5,h6,h7⟩ := h1 names h3 h4A h4B
    exists am'
    simp [*]
    apply Typing.subject_expansion transition h7

  | all bs cs body =>
    simp [Typing]
    intro h0 h1 names h2 h3A h3B h4
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
    intro safe nameless body_no_rec_namespace h0
    apply And.intro
    { exact Safe.subject_expansion transition safe }
    { apply And.intro nameless
      apply And.intro body_no_rec_namespace
      intro name name_no_rec_namespace
      have ⟨h1,h2⟩ := h0 name name_no_rec_namespace
      apply And.intro h1
      intro P h3 h4
      apply Stable.subject_expansion h3 transition
      exact h2 P h3 h4
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
: Typing am e' t → Typing am e t
:= by induction transition with
| refl =>
  intro h0 ; exact h0
| @step em e' h0 h1 ih =>
  intro h2
  apply ih ; clear ih
  apply Typing.subject_expansion h1 h2

theorem Typing.refl_trans_subject_expansion
  (transition : ReflTrans NStep e e')
: Typing am e' t → Typing am e t
:= by
  apply Typing.refl_trans_left_subject_expansion
  exact ReflTrans.reverse transition

theorem Typing.refl_trans_subject_reduction
  (transition : ReflTrans NStep e e')
: Typing am e t → Typing am e' t
:= by induction transition with
| refl =>
  intro h0 ; exact h0
| @step e em e' h0 h1 ih =>
  intro h2
  apply ih ; clear ih
  apply Typing.subject_reduction h0 h2

mutual

  theorem MultiSubtyping.env_insert_reflection :
    (name ∉ Typ.list_prod_free_vars cs ∨ name ∈ Prod.dom m0) →
    String.namespace_recursive name →
    MultiSubtyping (m0 ++ (name,P) :: m1) cs →
    MultiSubtyping (m0 ++ m1) cs
  := by sorry
  termination_by sts => (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals sorry

  theorem MultiSubtyping.env_insert_preservation :
    (name ∉ Typ.list_prod_free_vars cs ∨ name ∈ Prod.dom m0) →
    String.namespace_recursive name →
    MultiSubtyping (m0 ++ m1) cs →
    ∀ P, MultiSubtyping (m0 ++ (name,P) :: m1) cs
  := by sorry
  termination_by sts => (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals sorry


  theorem PosMonotonic.env_insert_reflection :
    (name ∉ Typ.free_vars t ∨ name = point ∨ name ∈ Prod.dom m0)  →
    String.namespace_recursive name →
    PosMonotonic point (m0 ++ (name,P) :: m1) t →
    PosMonotonic point (m0 ++ m1) t
  := by sorry
  termination_by sts => (Typ.size t, 1)
  decreasing_by
    all_goals sorry

  theorem PosMonotonic.env_insert_preservation :
    (name ∉ Typ.free_vars t ∨ name = point ∨ name ∈ Prod.dom m0)  →
    String.namespace_recursive name →
    PosMonotonic point (m0 ++ m1) t →
    ∀ P, PosMonotonic point (m0 ++ (name,P) :: m1) t
  := by sorry
  termination_by sts => (Typ.size t, 1)
  decreasing_by
    all_goals sorry


  theorem Typing.env_insert_reflection :
    (name ∉ Typ.free_vars t ∨ name ∈ Prod.dom m0)  →
    String.namespace_recursive name →
    Typing (m0 ++ (name,P) :: m1) e t →
    Typing (m0 ++ m1) e t
  := by sorry
  termination_by (Typ.size t, 0)
  decreasing_by
    all_goals sorry

  theorem Typing.env_insert_preservation :
    (name ∉ Typ.free_vars t ∨ name ∈ Prod.dom m0)  →
    String.namespace_recursive name →
    Typing (m0 ++ m1) e t →
    ∀ P, Typing (m0 ++ (name,P) :: m1) e t
  := by cases t with
  | bvar i =>
    simp [Typing]
  | var name' =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P h3 h4 h5 P'
    simp [*]
    exists P
    simp [*]
    by_cases h6: name' ∈ Prod.dom m0
    { rw [Prod.find_append_prefix ((name, P') :: m1) h6]
      rw [Prod.find_append_prefix m1 h6] at h4
      exact h4
    }
    { rw [Prod.find_append_suffix ((name, P') :: m1) h6]
      rw [Prod.find_append_suffix m1 h6] at h4
      simp [Prod.find]
      by_cases h7 : name = name'
      {
        apply False.elim
        simp [h7] at h0
        apply h6 h0
      }
      { simp [h7]; exact h4 }
    }
  | bot =>
    simp [Typing]
  | top =>
    simp [Typing]
  | iso l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    simp [*]
    apply Typing.env_insert_preservation h0 h1 h3
  | entry l body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    simp [*]
    apply Typing.env_insert_preservation h0 h1 h3
  | path antec conseq =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    simp [*]
    intro arg h7

    have ⟨h9,h10⟩ := Iff.mp and_or_right h0
    apply Typing.env_insert_preservation h10 h1
    apply h3
    apply Typing.env_insert_reflection h9 h1 h7

  | unio left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 P

    have ⟨h3A,h3B⟩ := Iff.mp and_or_right h0
    cases h2 with
    | inl h4 =>
      apply Or.inl
      apply Typing.env_insert_preservation h3A h1 h4
    | inr h4 =>
      apply Or.inr
      apply Typing.env_insert_preservation h3B h1 h4

  | inter left right =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    have ⟨h4A,h4B⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_preservation h4A h1 h2}
    { apply Typing.env_insert_preservation h4B h1 h3 }


  | diff minu subtra =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 P
    have ⟨h4A,h4B⟩ := Iff.mp and_or_right h0
    apply And.intro
    { apply Typing.env_insert_preservation h4A h1 h2 }
    { intro h5
      apply h3
      apply Typing.env_insert_reflection h4B h1 h5
    }

  | all bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 names h5 h6 h7 h8 P
    simp [*]
    apply And.intro h3
    exists names
    simp [*]
    have ⟨h0A,h0B⟩ := Iff.mp and_or_right h0
    apply And.intro
    {
      simp [List.Disjoint]
      intro name' h9
      simp [Prod.dom]
      apply And.intro
      {
        simp [List.Disjoint, Prod.dom] at h7
        intro P' h10
        have ⟨h11,h12⟩ := h7 h9
        exact h11 P' h10
      }
      apply And.intro
      {
        intro h10
        simp [String.no_namespace_recursive] at h6
        apply h6 name
        { rw [←h10] ; exact h9 }
        { exact h1 }
      }
      {
        simp [List.Disjoint, Prod.dom] at h7
        intro P' h10
        have ⟨h11,h12⟩ := h7 h9
        exact h12 P' h10
      }
    }
    {
      intro m h9 h10
      rw [←List.append_assoc]
      apply Typing.env_insert_preservation
      { cases h0B with
        | inl h0C =>
          apply Or.inl
          intro h11
          apply Typ.free_vars_instantiate_upper_bound at h11
          simp at h11
          cases h11 with
          | inl h12 =>
            exact h0C h12
          | inr h12 =>
            simp [Typ.free_vars] at h12
            simp [String.no_namespace_recursive] at h6
            apply h6 name h12
            exact h1
        | inr h0C =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h0C
          exact Or.inr h0C
      }
      { exact h1 }
      {
        rw [List.append_assoc]
        apply h8 _ h9
        rw [←List.append_assoc]
        apply MultiSubtyping.env_insert_reflection
        {
          cases h0A with
          | inl h0C =>
            apply Or.inl
            intro h11
            apply Typ.list_prod_free_vars_instantiate_upper_bound at h11
            simp at h11
            cases h11 with
            | inl h12 =>
              exact h0C h12
            | inr h12 =>
              simp [Typ.free_vars] at h12
              simp [String.no_namespace_recursive] at h6
              apply h6 name h12
              exact h1
          | inr h0C =>
            apply Or.inr
            simp [Prod.dom]
            simp [Prod.dom] at h0C
            exact Or.inr h0C
        }
        { exact h1 }
        { rw [List.append_assoc]
          exact h10
        }
      }
    }
  | exi bs cs body =>
    simp [Typing, Typ.free_vars]
    intro h0 h2 h3 h4 P
    apply And.intro h3
    intro names h5 h6 h7

    have h8 : List.Disjoint names (Prod.dom (m0 ++ m1)) := by
      simp [List.Disjoint, Prod.dom]
      simp [List.Disjoint, Prod.dom] at h7
      intro name' h9
      have ⟨h10,h11,h12⟩ :=  h7 h9
      exact ⟨h10, h12⟩

    have ⟨m,h9,h10,h11⟩ := h4 names h5 h6 h8
    exists m
    simp [*]
    have ⟨h1A,h1B⟩ := Iff.mp and_or_right h0
    apply And.intro
    {
      rw [←List.append_assoc]
      apply MultiSubtyping.env_insert_preservation
      {
        cases h1A with
        | inl h1C =>
          apply Or.inl
          intro h12
          apply Typ.list_prod_free_vars_instantiate_upper_bound at h12
          simp [Typ.free_vars] at h12
          cases h12 with
          | inl h13 =>
            exact h1C h13
          | inr h13 =>
            simp [String.no_namespace_recursive] at h6
            apply h6 name h13 h2
        | inr h1C =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h1C
          exact Or.inr h1C
      }
      { exact h2 }
      { rw [List.append_assoc] ; exact h10}
    }
    { rw [←List.append_assoc]
      apply Typing.env_insert_preservation
      { cases h1B with
        | inl h1C =>
          apply Or.inl
          intro h12
          apply Typ.free_vars_instantiate_upper_bound at h12
          simp [Typ.free_vars] at h12
          cases h12 with
          | inl h13 =>
            exact h1C h13
          | inr h13 =>
            simp [String.no_namespace_recursive] at h6
            apply h6 name h13 h2
        | inr h1C =>
          apply Or.inr
          simp [Prod.dom]
          simp [Prod.dom] at h1C
          exact Or.inr h1C
      }
      { exact h2 }
      { rw [List.append_assoc] ; exact h11 }
    }
  | lfp a body =>
    simp [Typing, Typ.free_vars]
    intro h0 h1 h2 h3 h4 h5 P
    simp [*]
    intro name' h6
    have ⟨h7,h8⟩ := h5 name' h6

    apply And.intro
    { apply PosMonotonic.env_insert_preservation
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
      { exact h1 }
      { exact h7 }
    }
    { intro P' h9 h10
      apply h8 _ h9
      intro e' h11
      apply h10
      rw [←List.cons_append]
      apply Typing.env_insert_preservation
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
      { exact h1 }
      { exact h11 }
    }
  termination_by (Typ.size t, 0)
  decreasing_by
    all_goals sorry
end



-- theorem Typing.env_cons_swap :
--   name ≠ name' →
--   Typing ((name,P) :: (name',P') :: m) e t →
--   Typing ((name',P') :: (name,P) :: m) e t
-- := by sorry

-- theorem PosMonotonic.env_cons_swap :
--   PosMonotonic point ((name,P) :: (name',P') :: m) t →
--   PosMonotonic point ((name',P') :: (name,P) :: m) t
-- := by sorry


-- theorem Typing.env_cons_append_swap_in :
--   name ∉ Prod.dom m0 →
--   Typing ((name,P) :: (m0 ++ m1)) e t →
--   Typing (m0 ++ (name,P) :: m1) e t
-- := by sorry

-- theorem Typing.env_cons_append_swap_out :
--   name ∉ Prod.dom m0 →
--   Typing (m0 ++ (name,P) :: m1) e t →
--   Typing ((name,P) :: (m0 ++ m1)) e t
-- := by sorry

-- theorem Subtyping.env_append_suffix_reflection :
--   List.Disjoint (Prod.dom m0) (Typ.free_vars lower) →
--   List.Disjoint (Prod.dom m0) (Typ.free_vars upper) →
--   Subtyping (m0 ++ m1) lower upper →
--   Subtyping m1 lower upper
-- := by
--   sorry

-- theorem Subtyping.env_append_suffix_preservation :
--   List.Disjoint (Prod.dom m0) (Typ.free_vars lower) →
--   List.Disjoint (Prod.dom m0) (Typ.free_vars upper) →
--   Subtyping m1 lower upper →
--   Subtyping (m0 ++ m1) lower upper
-- := by
--   sorry

-- theorem MultiSubtyping.env_append_suffix_reflection :
--   List.Disjoint (Prod.dom m0) (Typ.list_prod_free_vars cs) →
--   MultiSubtyping (m0 ++ m1) cs →
--   MultiSubtyping m1 cs
-- := by sorry

-- theorem MultiSubtyping.env_append_suffix_preservation :
--   List.Disjoint (Prod.dom m0) (Typ.list_prod_free_vars cs) →
--   MultiSubtyping m1 cs →
--   MultiSubtyping (m0 ++ m1) cs
-- := by sorry

-- theorem MultiSubtyping.subset_preservation {am cs cs'} :
--   cs ⊆ cs' →
--   MultiSubtyping am cs'  →
--   MultiSubtyping am cs
-- := by sorry


-- theorem MultiTyping.pred_env_append_suffix_preservation :
--   List.Disjoint (Prod.dom predEnv0) (ListTyping.free_vars vts) →
--   MultiTyping predEnv1 exprEnv vts →
--   MultiTyping (predEnv0 ++ predEnv1) exprEnv vts
-- := by sorry

-- theorem MultiTyping.expr_env_append_prefix_preservation :
--   MultiTyping predEnv exprEnv0 vts →
--   ∀ exprEnv1, MultiTyping tam (exprEnv0 ++ exprEnv1) vts
-- := by sorry



-- theorem Typing.joinable_preservation {a b am t} :
--   Joinable (ReflTrans NStep) a b →
--   Typing am a t →
--   Typing am b t
-- := by sorry

-- theorem Typing.joinable_reflection {a b am t} :
--   Joinable (ReflTrans NStep) a b →
--   Typing am b t →
--   Typing am a t
-- := by
--   intro h0 h1
--   apply Typing.joinable_preservation
--   { apply Joinable.symm h0 }
--   { exact h1 }


#check List.length_map


end Lang
