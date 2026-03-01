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
    Typ.wellformed left ∧
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
      (∀ e, P0 e → P1 e) →
      (∀ e , Typing ((name,P0)::am) e t → Typing ((name,P1)::am) e t)
    )
  termination_by (Typ.size t, 1)


  def Typing (am : List (String × (Expr → Prop))) (e : Expr) : Typ → Prop
  | .bvar _ => False
  | .bot => False
  | .top => Safe e
  | .iso l t => Safe e ∧ Typing am (.extract e l) t
  | .entry l t => Safe e ∧ Typing am (.project e l) t
  | .path left right =>
    Safe e ∧ Typ.wellformed left ∧
    ∀ arg , Typing am arg left → Typing am (.app e arg) right
  | .unio left right => Typing am e left ∨ Typing am e right
  | .inter left right => Typing am e left ∧ Typing am e right
  | .diff left right => Typ.wellformed right ∧ Typing am e left ∧ ¬ (Typing am e right)
  | .exi bindings constraints body =>
    (∀ a ∈ bindings , a = "") ∧
    ∃ am' ,
    List.length am' = List.length bindings ∧
    List.Disjoint (Prod.dom am') (Prod.dom am) ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name,_) => .var name) am') constraints)) ∧
    (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name,_) => .var name) am') body))
  | .all bindings constraints body =>
    Safe e ∧
    (∀ a ∈ bindings , a = "") ∧
    (∀ am' ,
      List.length am' = List.length bindings →
      List.Disjoint (Prod.dom am') (Prod.dom am) →
      (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name, _) => .var name) am') constraints)) →
      (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name, _) => .var name) am') body))
    )
  | .lfp a body =>
    Safe e ∧
    a = "" ∧
    ∃ name, name ∉ (Prod.dom am) ∧
    PosMonotonic name am (Typ.instantiate 0 [.var name] body) ∧
    /- infimum of -/
    (∀ P, Stable P →
      /- pre-fixed point -/
      (∀ e', Typing ((name,P) :: am) e' (Typ.instantiate 0 [.var name] body) → P e') →
      P e
    )
  | .var id => Safe e ∧ ∃ P, Stable P ∧ Prod.find id am = some P ∧ P e
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
    (∀ e, P0 e → P1 e) →
    (∀ e , Typing ((name,P1)::am) e t → Typing ((name,P0)::am) e t)
  )

def Monotonic (polarity : Bool) (name : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
  (polarity = true ∧ PosMonotonic name am t) ∨
  (polarity = false ∧ NegMonotonic name am t)

def MultiMonotonic (polarity : Bool) (name : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  ∀ lower upper, (lower,upper) ∈ cs → Monotonic (not polarity) name am lower ∧ Monotonic polarity name am upper

def EitherMultiMonotonic (polarity : Bool) (name : String) (am : List (String × (Expr → Prop))) (cs : List (Typ × Typ)) : Prop :=
  MultiMonotonic polarity name am cs


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
  intro h0 h1 h2
  apply Typing.safety h1
| all bs cs body =>
  simp [Typing]
  intro h0 h1 h2
  apply h0
| exi bs cs body =>
  simp [Typing]
  intro h0 am h1 h2 h3 h4 e' h5
  apply Typing.safety h4
  apply h5
| lfp x body =>
  simp [Typing]
  intro h0 h1 h2 name h3 h4
  apply h0

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
    intro h0 h1 h2
    apply And.intro (Safe.subject_reduction transition h0)
    apply And.intro h1
    intro arg h3
    apply Typing.subject_reduction
    { apply NStep.applicator _ transition }
    { exact h2 arg h3 }

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
    intro h0 h1 h2
    apply And.intro h0
    apply And.intro
    { apply Typing.subject_reduction transition h1 }
    {
      intro h3
      apply h2
      apply Typing.subject_expansion transition h3
    }

  | exi bs quals body =>
    simp [Typing]
    intro h0 am' h1 h2 h3 h4
    apply And.intro h0
    exists am'
    simp [*]
    apply Typing.subject_reduction transition h4

  | all bs quals body =>
    simp [Typing]
    intro h0 h1 h2
    apply And.intro
    { apply Safe.subject_reduction transition h0 }
    { apply And.intro h1
      intro am' h3 h4 h5
      apply Typing.subject_reduction transition
      exact h2 am' h3 h4 h5

    }

  | lfp b body =>
    simp [Typing]
    intro safe nameless name fresh monotonic h0
    apply And.intro
    { exact Safe.subject_reduction transition safe }
    {
      apply And.intro nameless
      exists name
      apply And.intro fresh
      apply And.intro monotonic
      intro P h2 h3
      apply Stable.subject_reduction h2 transition
      exact h0 P h2 h3
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
    intro h0 h1 h2
    apply And.intro (Safe.subject_expansion transition h0)
    apply And.intro h1
    intro arg h3
    apply Typing.subject_expansion
    { apply NStep.applicator _ transition }
    { exact h2 arg h3 }

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
    intro h0 h1 h2
    apply And.intro h0
    apply And.intro
    { apply Typing.subject_expansion transition h1 }
    {
      intro h3
      apply h2
      apply Typing.subject_reduction transition h3
    }

  | exi bs quals body =>
    simp [Typing]
    intro h0 am' h1 h2 h3 h4
    apply And.intro h0
    exists am'
    simp [*]
    apply Typing.subject_expansion transition h4

  | all bs quals body =>
    simp [Typing]
    intro h0 h1 h2
    apply And.intro
    { apply Safe.subject_expansion transition h0 }
    { apply And.intro h1
      intro am' h3 h4 h5
      apply Typing.subject_expansion transition
      exact h2 am' h3 h4 h5

    }

  | lfp b body =>
    simp [Typing]
    intro safe nameless name fresh monotonic h0
    apply And.intro
    { exact Safe.subject_expansion transition safe }
    {
      apply And.intro nameless
      exists name
      apply And.intro fresh
      apply And.intro monotonic
      intro P h2 h3
      apply Stable.subject_expansion h2 transition
      exact h0 P h2 h3
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


mutual
  theorem Typing.instantiated :
    Typing am e t → Typ.instantiated t
  := by sorry
end

mutual
  theorem Typing.env_cons_suffix_reflection :
    name ∉ Typ.free_vars t →
    Typing ((name,P) :: m) e t →
    Typing m e t
  := by sorry

  theorem Typing.env_cons_suffix_preservation :
    name ∉ Typ.free_vars t →
    Typing m e t →
    ∀ P, Typing ((name,P) :: m) e t
  := by sorry
end


mutual
  theorem Typing.env_append_suffix_reflection :
    List.Disjoint (Prod.dom m0) (Typ.free_vars t) →
    Typing (m0 ++ m1) e t →
    Typing m1 e t
  := by
    sorry

  theorem Typing.env_append_suffix_preservation :
    List.Disjoint (Prod.dom m0) (Typ.free_vars t) →
    Typing m1 e t →
    Typing (m0 ++ m1) e t
  := by
    sorry
end



theorem Typing.env_cons_append_prefix_swap :
  name ∉ Prod.dom m0 →
  Typing ((name,P) :: (m0 ++ m1)) e t →
  Typing (m0 ++ (name,item) :: m1) e t
:= by sorry

theorem Subtyping.env_append_suffix_reflection :
  List.Disjoint (Prod.dom m0) (Typ.free_vars lower) →
  List.Disjoint (Prod.dom m0) (Typ.free_vars upper) →
  Subtyping (m0 ++ m1) lower upper →
  Subtyping m1 lower upper
:= by
  sorry

theorem Subtyping.env_append_suffix_preservation :
  List.Disjoint (Prod.dom m0) (Typ.free_vars lower) →
  List.Disjoint (Prod.dom m0) (Typ.free_vars upper) →
  Subtyping m1 lower upper →
  Subtyping (m0 ++ m1) lower upper
:= by
  sorry

theorem MultiSubtyping.env_append_suffix_reflection :
  List.Disjoint (Prod.dom m0) (Typ.list_prod_free_vars cs) →
  MultiSubtyping (m0 ++ m1) cs →
  MultiSubtyping m1 cs
:= by sorry

theorem MultiSubtyping.env_append_suffix_preservation :
  List.Disjoint (Prod.dom m0) (Typ.list_prod_free_vars cs) →
  MultiSubtyping m1 cs →
  MultiSubtyping (m0 ++ m1) cs
:= by sorry

theorem MultiSubtyping.subset_preservation {am cs cs'} :
  cs ⊆ cs' →
  MultiSubtyping am cs'  →
  MultiSubtyping am cs
:= by sorry


theorem MultiTyping.pred_env_append_suffix_preservation :
  List.Disjoint (Prod.dom predEnv0) (ListTyping.free_vars vts) →
  MultiTyping predEnv1 exprEnv vts →
  MultiTyping (predEnv0 ++ predEnv1) exprEnv vts
:= by sorry

theorem MultiTyping.expr_env_append_prefix_preservation :
  MultiTyping predEnv exprEnv0 vts →
  ∀ exprEnv1, MultiTyping tam (exprEnv0 ++ exprEnv1) vts
:= by sorry



end Lang
