import Lean

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

theorem Typ.free_vars_shift_vars_reflection :
  Typ.free_vars (Typ.shift_vars threshold offset t) =
  Typ.free_vars t
:= by sorry

theorem Typ.free_vars_instantiate_upper_bound :
  Typ.free_vars (Typ.instantiate depth m e) ⊆ (Typ.free_vars e) ++ List.flatMap Typ.free_vars m
:= by sorry

theorem Typ.free_vars_instantiate_lower_bound :
  (Typ.free_vars e) ⊆ Typ.free_vars (Typ.instantiate depth m e)
:= by sorry


theorem Typ.list_prod_free_vars_instantiate_upper_bound :
  Typ.list_prod_free_vars (Typ.constraints_instantiate depth m cs) ⊆ (Typ.list_prod_free_vars cs) ++ List.flatMap Typ.free_vars m
:= by sorry





mutual
  def Typ.constraints_num_bound_vars : List (Typ × Typ) → Nat
  | [] => 0
  | (left,right) :: cs =>
    Nat.max (Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right))
    (Typ.constraints_num_bound_vars cs)

  def Typ.num_bound_vars: Typ → Nat
  | .bvar i => i + 1
  | .var name => 0
  | .entry l body => Typ.num_bound_vars body
  | .iso l body => Typ.num_bound_vars body
  | .path left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .top => 0
  | .bot => 0
  | .unio left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .inter left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .diff left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .all bs cs body =>
    Nat.max (Typ.constraints_num_bound_vars cs) (Typ.num_bound_vars body)
    - List.length bs
  | .exi bs cs body =>
    Nat.max (Typ.constraints_num_bound_vars cs) (Typ.num_bound_vars body)
    - List.length bs
  | .lfp b body =>
    (Typ.num_bound_vars body) - 1
end


def Typ.instantiated (t: Typ) := Typ.num_bound_vars t == 0


theorem Typ.list_all_mem_instantiate_preservation :
  (∀ t ∈ ts, t = Typ.instantiate depth m t) →
  ts = Typ.list_instantiate depth m ts
:= by sorry

mutual
  def Typ.constraints_nameless : List (Typ × Typ) → Bool
  | [] => .true
  | (left,right) :: cs => Typ.nameless left && Typ.nameless right && Typ.constraints_nameless cs

  def Typ.nameless : Typ → Bool
  | .bvar _ => .true
  | .var _ => .true
  | .entry l body => Typ.nameless body
  | .iso l body => Typ.nameless body
  | .path left right =>  Typ.nameless left && Typ.nameless right
  | .top => .true
  | .bot => .true
  | .unio left right =>  Typ.nameless left && Typ.nameless right
  | .inter left right =>  Typ.nameless left && Typ.nameless right
  | .diff left right =>  Typ.nameless left && Typ.nameless right
  | .all bs cs body =>
    List.all bs (fun b => b == "") &&
    Typ.constraints_nameless cs && Typ.nameless body
  | .exi bs cs body =>
    List.all bs (fun b => b == "") &&
    Typ.constraints_nameless cs && Typ.nameless body
  | .lfp b body =>
    b == "" && Typ.nameless body
end

def Typ.wellformed (t : Typ) := Typ.instantiated t && Typ.nameless t
def Typ.list_wellformed : List Typ → Bool
| [] => true
| t :: ts => Typ.wellformed t && Typ.list_wellformed ts


mutual
  theorem Typ.wellformed_nameless_instantiation :
    Typ.wellformed (Typ.instantiate depth [.var name] t') →
    Typ.wellformed t → Typ.wellformed (Typ.instantiate depth [t] t')
  := by sorry

  theorem Typ.wellformed_named_instantiation :
    Typ.wellformed (Typ.instantiate depth [t] t') →
    ∀ name , Typ.wellformed (Typ.instantiate depth [.var name] t')
  := by sorry
end

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

  def Monotonic (name : String) (am : List (String × (Expr → Prop))) (t : Typ) : Prop :=
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
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name,_) => .var name) am') constraints)) ∧
    (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name,_) => .var name) am') body))
  | .all bindings constraints body =>
    Safe e ∧
    (∀ a ∈ bindings , a = "") ∧
    (∀ am' ,
      List.length am' = List.length bindings →
      List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
      (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name, _) => .var name) am') constraints)) →
      (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name, _) => .var name) am') body))
    )
  | .lfp a body =>
    Safe e ∧
    a = "" ∧
    ∃ name, name ∉ (List.map Prod.fst am) ∧
    Monotonic name am (Typ.instantiate 0 [.var name] body) ∧
    /- infimum of -/
    (∀ P, Stable P →
      /- pre-fixed point -/
      (∀ e', Typing ((name,P) :: am) e' (Typ.instantiate 0 [.var name] body) → P e') →
      P e
    )
  | .var id => Safe e ∧ ∃ P, Stable P ∧ find id am = some P ∧ P e
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


mutual
  theorem Typing.cons_reflection :
    name ∉ Typ.free_vars t →
    Typing ((name,P) :: m) e t →
    Typing m e t
  := by sorry

  theorem Typing.cons_preservation :
    name ∉ Typ.free_vars t →
    Typing m e t →
    ∀ P, Typing ((name,P) :: m) e t
  := by sorry
end


mutual
  theorem Typing.prepend_reflection :
    List.Disjoint (List.map Prod.fst m0) (Typ.free_vars t) →
    Typing (m0 ++ m1) e t →
    Typing m1 e t
  := by
    sorry

  theorem Typing.prepend_preservation :
    List.Disjoint (List.map Prod.fst m0) (Typ.free_vars t) →
    Typing m1 e t →
    Typing (m0 ++ m1) e t
  := by
    sorry
end


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



theorem Typing.wellformed :
  Typing am e t → Typ.wellformed t
:= by sorry



theorem Typing.progress :
  Typing am e t → Expr.is_value e ∨ ∃ e', NStep e e'
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





def MultiTyping
  (tam : List (String × (Expr → Prop))) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, find x context = .some t → ∃ e, (find x eam) = .some e ∧ Typing tam e t



theorem MultiSubtyping.removeAll_union {tam cs' cs} :
  MultiSubtyping tam (List.removeAll cs' cs ∪ cs) →
  MultiSubtyping tam cs'
:= by sorry



theorem Typing.dom_reduction {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing (tam1 ++ tam0) e t →
  Typing tam0 e t
:= by sorry

theorem Typing.dom_extension {tam1 tam0 e t} :
  (ListPair.dom tam1) ∩ Typ.free_vars t = [] →
  Typing tam0 e t →
  Typing (tam1 ++ tam0) e t
:= by sorry

-- theorem Typing.dom_single_extension {id am e t t'} :
--   id ∉ Typ.free_vars t →
--   Typing am e t' →
--   Typing ((id,t) :: am) e t'
-- := by sorry


theorem MultiTyping.dom_reduction {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping (tam1 ++ tam0) eam cs →
  MultiTyping tam0 eam cs
:= by sorry


theorem MultiTyping.dom_extension {tam1 tam0 eam cs} :
  (ListPair.dom tam1) ∩ ListTyping.free_vars cs = [] →
  MultiTyping tam0 eam cs →
  MultiTyping (tam1 ++ tam0) eam cs
:= by sorry

theorem MultiTyping.dom_context_extension {tam eam cs} :
  MultiTyping tam eam cs →
  ∀ eam', MultiTyping tam (eam ++ eam') cs
:= by sorry


theorem Subtyping.dom_extension {am1 am0 lower upper} :
  (ListPair.dom am1) ∩ Typ.free_vars lower = [] →
  (ListPair.dom am1) ∩ Typ.free_vars upper = [] →
  Subtyping am0 lower upper →
  Subtyping (am1 ++ am0) lower upper
:= by sorry

theorem MultiSubtyping.dom_single_extension {id tam0 t cs} :
  id ∉ Typ.list_prod_free_vars cs →
  MultiSubtyping tam0 cs →
  MultiSubtyping ((id,t) :: tam0) cs
:= by sorry

theorem MultiSubtyping.dom_extension {am1 am0 cs} :
  (ListPair.dom am1) ∩ Typ.list_prod_free_vars cs = [] →
  MultiSubtyping am0 cs →
  MultiSubtyping (am1 ++ am0) cs
:= by sorry

theorem MultiSubtyping.dom_reduction {am1 am0 cs} :
  (ListPair.dom am1) ∩ Typ.list_prod_free_vars cs = [] →
  MultiSubtyping (am1 ++ am0) cs →
  MultiSubtyping am0 cs
:= by sorry

theorem MultiSubtyping.reduction {am cs cs'} :
  cs ⊆ cs' →
  MultiSubtyping am cs'  →
  MultiSubtyping am cs
:= by sorry

theorem Subtyping.refl am t :
  Subtyping am t t
:= by sorry

theorem Subtyping.unio_left_intro {am t l r} :
  Subtyping am t l →
  Subtyping am t (Typ.unio l r)
:= by sorry


theorem Subtyping.unio_right_intro {am t l r} :
  Subtyping am t r →
  Subtyping am t (Typ.unio l r)
:= by sorry

theorem Subtyping.inter_left_elim {am l r t} :
  Subtyping am l t →
  Subtyping am (Typ.inter l r) t
:= by sorry

theorem Subtyping.inter_right_elim {am l r t} :
  Subtyping am r t →
  Subtyping am (Typ.inter l r) t
:= by sorry


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


theorem Subtyping.unio_elim {am left right t} :
  Subtyping am left t →
  Subtyping am right t →
  Subtyping am (Typ.unio left right) t
:= by sorry

theorem Subtyping.unio_intro_left right :
  Subtyping am t left →
  Subtyping am t (Typ.unio left right)
:= by sorry

theorem Subtyping.unio_intro_right left :
  Subtyping am t right →
  Subtyping am t (Typ.unio left right)
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
--   ListPair.dom am' ⊆ ids →
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
    ListPair.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) body t
  ) →
  Subtyping am (Typ.exi ids quals body) t
:= by sorry

-- theorem Subtyping.all_elim {am am' ids quals body t} :
--   ListPair.dom am' ⊆ ids →
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
    ListPair.dom am' ⊆ ids →
    MultiSubtyping (am' ++ am) quals →
    Subtyping (am' ++ am) t body
  ) →
  Subtyping am t (Typ.all ids quals body)
:= by sorry

mutual
  def List.pair_typ_sub (δ : List (String × Typ)) : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder => .cons (Typ.sub δ l, Typ.sub δ r) (List.pair_typ_sub δ remainder)

  def Typ.sub (δ : List (String × Typ)) : Typ → Typ
  | .bvar i => .bvar i
  | .var id => match find id δ with
    | .none => .var id
    | .some t => t
  | .iso l body => .iso l (Typ.sub δ body)
  | .entry l body => .entry l (Typ.sub δ body)
  | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
  | .bot => .bot
  | .top => .top
  | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
  | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
  | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
  | .all ids constraints body =>
      let δ' := remove_all δ ids
      .all ids (List.pair_typ_sub δ' constraints) (Typ.sub δ' body)
  | .exi ids constraints body =>
      let δ' := remove_all δ ids
      .exi ids (List.pair_typ_sub δ' constraints) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end

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


mutual
  theorem Typing.instantiated :
    Typing am e t → Typ.instantiated t
  := by sorry
end

mutual
  theorem Typ.instantiated_shift_vars_preservation :
    Typ.instantiated t →
    t = Typ.shift_vars threshold offset t
  := by sorry

  theorem Typ.instantiated_shift_vars_reflection :
    Typ.instantiated (Typ.shift_vars threshold offset t) →
    Typ.shift_vars threshold offset t = t
  := by sorry
end



mutual
  theorem Typ.instantiate_inside_out offset depth ma mb e:
    (Typ.instantiate (offset + depth) ma (Typ.instantiate depth mb e)) =
    (Typ.instantiate depth
      (Typ.list_instantiate offset ma mb)
      (Typ.instantiate (offset + List.length mb + depth) ma e)
    )
  := by sorry
end

theorem Typ.constraints_instantiate_zero_inside_out offset ma mb cs:
  (Typ.constraints_instantiate (offset) ma (Typ.constraints_instantiate 0 mb cs)) =
  (Typ.constraints_instantiate 0
    (Typ.list_instantiate offset ma mb)
    (Typ.constraints_instantiate (offset + List.length mb) ma cs)
  )
:= by sorry

theorem Typ.instantiate_zero_inside_out offset ma mb e:
  (Typ.instantiate (offset) ma (Typ.instantiate 0 mb e)) =
  (Typ.instantiate 0
    (Typ.list_instantiate offset ma mb)
    (Typ.instantiate (offset + List.length mb) ma e)
  )
:= by sorry


-- theorem Typing.disjoint_assignment_map_rotate_preservation :
--   name ∉ ListPair.dom m0 →
--   Typing ((name,item) :: (m0 ++ m1)) e t →
--   Typing (m0 ++ (name,item) :: m1) e t
-- := by sorry

theorem find_prune o m1 :
  name ∉ List.map Prod.fst m0 →
  find name (m0 ++ (name,o) :: m1)
  =
  find name ((name,o) :: m1)
:= by sorry

theorem find_drop o m1 :
  name ≠ name' →
  find name' (m0 ++ (name,o) :: m1)
  =
  find name' (m0 ++ m1)
:= by sorry



set_option maxHeartbeats 500000 in
mutual


  theorem Subtyping.generalized_nameless_instantiation :
    name ∉ Typ.free_vars lower →
    name ∉ Typ.free_vars upper →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    Subtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper) →
    Subtyping (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper)
  := by
    simp [Subtyping]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { exact Typ.wellformed_nameless_instantiation h6 wf }
    { intro e h8
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp; exact h4 }
      { simp; exact h5 }
      { exact wf }
      {
        apply h7
        apply Typing.generalized_named_instantiation h0 h2 h3
        { simp; exact h4 }
        { simp; exact h5 }
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
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    Subtyping (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] lower) (Typ.instantiate depth [t] upper) →
    Subtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] lower) (Typ.instantiate depth [.var name] upper)
  := by
    simp [Subtyping]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { exact Typ.wellformed_named_instantiation h6 name }
    { intro e h8
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp; exact h4 }
      { simp; exact h5 }
      { exact wf }
      {
        apply h7
        apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp; exact h4 }
        { simp; exact h5 }
        { exact wf }
        { exact h8 }
      }
    }
  termination_by (Typ.size lower + Typ.size upper, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])




  theorem Monotonic.generalized_nameless_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    point ∉ List.map Prod.fst am' →
    point ≠ name →
    point ∉ List.map Prod.fst am →
    Monotonic point (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] body) →
    Monotonic point (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] body)
  := by
    simp [Monotonic]
    intro h0 h1 h2 h3 h4 wf h5 h6 h7 h8 P0 P1 h9 e h10

    have h11 :
      (point, P1) :: (am' ++ (name, fun e => False) :: am) =
      ((point, P1) :: am') ++ (name, fun e => False) :: am
    := by rfl

    rw [h11]
    apply Typing.generalized_nameless_instantiation h0 h1
    {
      simp [List.Disjoint]
      apply And.intro h7
      simp [List.Disjoint] at h2
      exact h2
    }
    { simp
      apply And.intro
      { intro h12 ; exact h6 (Eq.symm h12) }
      { exact h3 }
    }
    { simp ; exact h4 }
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
        simp [List.Disjoint]
        apply And.intro h7
        simp [List.Disjoint] at h2
        exact h2
      }
      { simp
        apply And.intro
        { intro h12 ; exact h6 (Eq.symm h12) }
        { exact h3 }
      }
      { simp ; exact h4 }
      { exact wf }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem Monotonic.generalized_named_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    point ∉ List.map Prod.fst am' →
    point ≠ name →
    point ∉ List.map Prod.fst am →
    Monotonic point (am' ++ (name,fun e => False) :: am) (Typ.instantiate depth [t] body) →
    Monotonic point (am' ++ (name,fun e => Typing am e t) :: am) (Typ.instantiate depth [.var name] body)
  := by
    simp [Monotonic]
    intro h0 h1 h2 h3 h4 wf h5 h6 h7 h8 P0 P1 h9 e h10

    have h11 :
      (point, P1) :: (am' ++ (name, fun e => Typing am e t) :: am) =
      ((point, P1) :: am') ++ (name, fun e => Typing am e t) :: am
    := by rfl

    rw [h11]
    apply Typing.generalized_named_instantiation h0 h1
    {
      simp [List.Disjoint]
      apply And.intro h7
      simp [List.Disjoint] at h2
      exact h2
    }
    { simp
      apply And.intro
      { intro h12 ; exact h6 (Eq.symm h12) }
      { exact h3 }
    }
    { simp ; exact h4 }
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
        simp [List.Disjoint]
        apply And.intro h7
        simp [List.Disjoint] at h2
        exact h2
      }
      { simp
        apply And.intro
        { intro h12 ; exact h6 (Eq.symm h12) }
        { exact h3 }
      }
      { simp ; exact h4 }
      { exact wf }
      { exact h10 }
    }
  termination_by (Typ.size body, 1)

  theorem MultiSubtyping.generalized_nameless_instantiation :
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    MultiSubtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.constraints_instantiate depth [.var name] cs) →
    MultiSubtyping (am' ++ (name,fun e => False) :: am) (Typ.constraints_instantiate depth [t] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping, Typ.list_prod_free_vars]
    intro h0 h1 h2 h3 h4 h5 h6 wf h7 h8
    apply And.intro
    { apply Subtyping.generalized_nameless_instantiation h0 h1 h3 h4
      { simp ; exact h5 }
      { simp ; exact h6 }
      { exact wf }
      { exact h7 }
    }
    { apply MultiSubtyping.generalized_nameless_instantiation h2 h3 h4
      { simp ; exact h5 }
      { simp ; exact h6 }
      { exact wf }
      { exact h8 }
    }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])


  theorem MultiSubtyping.generalized_named_instantiation :
    name ∉ Typ.list_prod_free_vars cs →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    MultiSubtyping (am' ++ (name,fun e => False) :: am) (Typ.constraints_instantiate depth [t] cs) →
    MultiSubtyping (am' ++ (name,fun e => Typing am e t) :: am) (Typ.constraints_instantiate depth [.var name] cs)
  := by cases cs with
  | nil =>
    simp [Typ.constraints_instantiate, MultiSubtyping]
  | cons c cs' =>
    have (left,right) := c
    simp [Typ.constraints_instantiate, MultiSubtyping, Typ.list_prod_free_vars]
    intro h0 h1 h2 h3 h4 h5 h6 wf h7 h8
    apply And.intro
    { apply Subtyping.generalized_named_instantiation h0 h1 h3 h4
      { simp ; exact h5 }
      { simp ; exact h6 }
      { exact wf }
      { exact h7 }
    }
    { apply MultiSubtyping.generalized_named_instantiation h2 h3 h4
      { simp ; exact h5 }
      { simp ; exact h6 }
      { exact wf }
      { exact h8 }
    }
  termination_by (List.pair_typ_size cs, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])


  theorem Typing.generalized_nameless_instantiation :
    name ∉ Typ.free_vars body →
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    Typing (am' ++ (name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body) →
    Typing (am' ++ (name,fun e => False) :: am) e (Typ.instantiate depth [t] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        simp [Typ.shift_vars]
        intro h2 h3 h4 h5 h6 wf
        simp [Typing]
        intro h7 P h8 h9 h10
        rw [find_prune _ _] at h9
        {
          simp [find] at h9
          simp [←h9] at h10
          have h11 := Typing.instantiated h10
          rw [←Typ.instantiated_shift_vars_preservation h11]
          apply Typing.prepend_preservation (List.disjoint_of_subset_right h3 h4)
          apply Typing.cons_preservation
          {
            intro h12
            specialize h3 h12
            simp at h3
            have ⟨P',h13⟩ := h3
            apply h6 P' h13
          }
          { exact h10 }
        }
        { simp ; exact h5 }
      }
      { simp [h1]
        simp [Typing]
      }
    }
    { simp [h0]
      simp [Typing]
    }
  | var name' =>
    simp [Typ.instantiate, Typ.free_vars, Typing]
    intro h0 h1 h2 h3 h4 wf h5 P h6 h7 h8
    simp [*]
    exists P
    simp [*]
    rw [find_drop _ _ h0]
    rw [find_drop _ _ h0] at h7
    apply h7
  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_nameless_instantiation h0 h1 h2
    { simp ; exact h3 }
    { simp ; exact h4 }
    { exact wf }
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_nameless_instantiation h0 h1 h2
    { simp ; exact h3 }
    { simp ; exact h4 }
    { exact wf }
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro
    { apply Typ.wellformed_nameless_instantiation h7
      exact wf
    }
    { intro arg h9
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      {
        apply h8
        apply Typing.generalized_named_instantiation h0 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | bot =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | top =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6
    cases h6 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_nameless_instantiation h0 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { apply Typing.generalized_nameless_instantiation h0 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h6 }
    }
    { apply Typing.generalized_nameless_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
    }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    apply And.intro
    { apply Typ.wellformed_nameless_instantiation h6 wf }
    { apply And.intro
      { apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h7 }
      }
      { intro h9
        apply h8
        apply Typing.generalized_named_instantiation h1 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate]
    intro h0 h1 h2
    simp [Typing]
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
    { simp ; exact ⟨h12, h3⟩ }
    { simp ; exact ⟨h11, h4⟩ }
    { simp ; exact h5 }
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
        { simp ; exact ⟨h12, h3⟩ }
        { simp ; exact ⟨h11, h4⟩ }
        { simp ; exact h5 }
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
    simp [Typ.free_vars, Typ.instantiate, Typing]

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
        { simp ; exact ⟨h10, h3⟩ }
        { simp ; exact ⟨h9, h4⟩ }
        { simp ; exact h5 }
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
        { simp ; exact ⟨h10, h3⟩ }
        { simp ; exact ⟨h9, h4⟩ }
        { simp ; exact h5 }
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
    simp [Typ.free_vars, Typ.instantiate, Typing]
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
      { simp ; exact h3 }
      { simp ; exact h4 }
      { exact wf }
      { simp ; exact h7 }
      { exact h8 }
      { simp ; exact h9 }
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
      { simp; exact ⟨h9, h2⟩ }
      { simp [*]; intro h18 ; exact h8 (Eq.symm h18) }
      { simp [*] }
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
    Typ.free_vars t ⊆ List.map Prod.fst am →
    List.Disjoint (List.map Prod.fst am') (List.map Prod.fst am) →
    name ∉ List.map Prod.fst am' →
    name ∉ List.map Prod.fst am →
    Typ.wellformed t →
    Typing (am' ++ (name,fun e => False) :: am) e (Typ.instantiate depth [t] body) →
    Typing (am' ++ (name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
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
          { rw [find_prune _ _ ]
            { simp [find] }
            { simp ;
              intro P
              exact h5 P
            }
          }
          { simp
            have h8 := Typing.instantiated h7
            have h9 : name ∉ Typ.free_vars t := by
              intro h10
              specialize h3 h10
              simp at h3
              have ⟨P,h11⟩ := h3
              apply h6 P h11
            apply Typing.cons_reflection h9

            apply Typing.prepend_reflection (List.disjoint_of_subset_right h3 h4)
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
    simp [Typ.instantiate, Typ.free_vars, Typing]
    intro h0 h1 h2 h3 h4 wf h5 P h6 h7 h8
    simp [*]
    exists P
    simp [*]
    rw [find_drop _ _ h0]
    rw [find_drop _ _ h0] at h7
    apply h7
  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_named_instantiation h0 h1 h2
    { simp ; exact h3 }
    { simp ; exact h4 }
    { exact wf }
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 wf h5
    simp [*]
    apply Typing.generalized_named_instantiation h0 h1 h2
    { simp ; exact h3 }
    { simp ; exact h4 }
    { exact wf }
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    simp [*]
    apply And.intro
    { apply Typ.wellformed_named_instantiation h7 }
    { intro arg h9
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      {
        apply h8
        apply Typing.generalized_nameless_instantiation h0 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | bot =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | top =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6
    cases h6 with
    | inl h7 =>
      apply Or.inl
      apply Typing.generalized_named_instantiation h0 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
    | inr h7 =>
      apply Or.inr
      apply Typing.generalized_named_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7
    apply And.intro
    { apply Typing.generalized_named_instantiation h0 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h6 }
    }
    { apply Typing.generalized_named_instantiation h1 h2 h3
      { simp ; exact h4 }
      { simp ; exact h5 }
      { exact wf }
      { exact h7 }
    }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3 h4 h5 wf h6 h7 h8
    apply And.intro
    { apply Typ.wellformed_named_instantiation h6 }
    { apply And.intro
      { apply Typing.generalized_named_instantiation h0 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h7 }
      }
      { intro h9
        apply h8
        apply Typing.generalized_nameless_instantiation h1 h2 h3
        { simp ; exact h4 }
        { simp ; exact h5 }
        { exact wf }
        { exact h9 }
      }
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate]
    intro h0 h1 h2
    simp [Typing]
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
    { simp ; exact ⟨h12, h3⟩ }
    { simp ; exact ⟨h11, h4⟩ }
    { simp ; exact h5 }
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
        { simp ; exact ⟨h12, h3⟩ }
        { simp ; exact ⟨h11, h4⟩ }
        { simp ; exact h5 }
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
    simp [Typ.free_vars, Typ.instantiate, Typing]

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
        { simp ; exact ⟨h10, h3⟩ }
        { simp ; exact ⟨h9, h4⟩ }
        { simp ; exact h5 }
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
        { simp ; exact ⟨h10, h3⟩ }
        { simp ; exact ⟨h9, h4⟩ }
        { simp ; exact h5 }
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
    simp [Typ.free_vars, Typ.instantiate, Typing]
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
      { simp ; exact h3 }
      { simp ; exact h4 }
      { exact wf }
      { simp ; exact h7 }
      { exact h8 }
      { simp ; exact h9 }
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
      { simp; exact ⟨h9, h2⟩ }
      { simp [*]; intro h18 ; exact h8 (Eq.symm h18) }
      { simp [*] }
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
  Typ.free_vars t ⊆ List.map Prod.fst am →
  name ∉ List.map Prod.fst am →
  Typ.wellformed t →
  Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body) →
  Typing am e (Typ.instantiate depth [t] body)
:= by
  simp
  intro h0 h1 h2 wf h3
  apply @Typing.cons_reflection _ _ (fun e => False)
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
    { simp }
    { exact Iff.mp List.count_eq_zero rfl }
    { simp ; exact h2 }
    { exact wf }
    { exact h3 }
  }

theorem Typing.named_instantiation :
  name ∉ Typ.free_vars body →
  Typ.free_vars t ⊆ List.map Prod.fst am →
  name ∉ List.map Prod.fst am →
  Typ.wellformed t →
  Typing am e (Typ.instantiate depth [t] body) →
  Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body)
:= by
  simp
  intro h0 h1 h2 wf h3
  have h5 :
    (name, fun e => Typing am e t) :: am =
    [] ++ (name, fun e => Typing am e t) :: am
  := by rfl
  rw [h5]
  apply Typing.generalized_named_instantiation h0 h1
  { simp }
  { exact Iff.mp List.count_eq_zero rfl }
  { simp ; exact h2 }
  { exact wf }
  {
    simp
    apply Typing.cons_preservation _ _ (fun e => False)
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




theorem Typing.lfp_elim :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  Monotonic name am (Typ.instantiate 0 [.var name] t) →
  (Typing ((name, P) :: am) e (Typ.instantiate 0 [Typ.var name] t) → P e) →
  Typing am e (Typ.lfp "" t) → P e
:= by sorry


/- Subtyping recycling -/
theorem Subtyping.lfp_intro_direct :
  Typ.wellformed (Typ.lfp "" t) →
  name ∉ Typ.free_vars t →
  Monotonic name am (Typ.instantiate 0 [.var name] t) →
  Subtyping am (Typ.instantiate 0 [(Typ.lfp "" t)] t) (Typ.lfp "" t)
:= by
  simp [Subtyping]
  simp [Typing]
  intro h0 h1 h2
  apply And.intro sorry
  intro e h3
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

theorem Subtyping.lfp_intro :
  Typ.wellformed (Typ.lfp "" body) →
  name ∉ Typ.free_vars body →
  Monotonic name am (Typ.instantiate 0 [.var name] body) →
  Subtyping am t (Typ.instantiate 0 [(Typ.lfp "" body)] body) →
  Subtyping am t (Typ.lfp "" body)
:= by
  sorry
  -- intro h0 h1 h2
  -- apply Subtyping.transitivity h2
  -- exact lfp_intro_direct h0 h1



theorem Subtyping.lfp_elim :
  name ∉ Typ.free_vars body →
  Monotonic name am (Typ.instantiate 0 [.var name] body) →
  Subtyping am (Typ.instantiate 0 [t] body) t →
  Subtyping am (Typ.lfp "" body) t
:= by
  sorry
  -- simp [Subtyping]
  -- intro h0 h1 h2 e
  -- apply Typing.lfp_elim
  -- { exact h0 }
  -- { exact h1 }
  -- { intro h4
  --   apply h2
  --   exact Typing.nameless_instantiation h0 h4
  -- }

set_option eval.pp false

#eval Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ]

example : Subtyping []
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ])
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> N ])
:= by
  sorry
  -- apply Subtyping.lfp_elim
  -- { sorry }
  -- { sorry }
  -- { reduce
  --   apply Subtyping.lfp_intro
  --   { sorry }
  --   { sorry }
  --   { reduce
  --     apply Subtyping.unio_elim
  --     { apply Subtyping.unio_intro_left
  --       apply Subtyping.refl
  --     }
  --     { apply Subtyping.unio_intro_right
  --       apply Subtyping.iso_pres
  --       apply Subtyping.lfp_intro
  --       { sorry }
  --       { sorry }
  --       { reduce
  --         apply Subtyping.unio_intro_right
  --         apply Subtyping.iso_pres
  --         apply Subtyping.refl
  --       }
  --       { sorry }
  --     }
  --   }
  --   { sorry }
  -- }
  -- { sorry }


-- theorem Subtyping.lfp_induct_elim {am id body t} :
--   Monotonic am id body →
--   (∀ e, Typing ((id, t) :: am) e body → Typing am e t) →
--   Subtyping am (Typ.lfp id body) t
-- := by sorry


-- theorem Typing.lfp_elim_top {am e id t} :
--   Monotonic am id t →
--   Typing am e (.lfp id t) →
--   Typing ((id, .top) :: am) e t
-- := by sorry

-- theorem Typing.lfp_intro_bot {am e id t} :
--   Monotonic am id t →
--   Typing ((id, .bot) :: am) e t →
--   Typing am e (.lfp id t)
-- := by sorry



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



theorem Typing.path_determines_function
  (typing : Typing am e (.path antec consq))
: ∃ f , ReflTrans NStep e (.function f)
:= by sorry



theorem Expr.sub_sub_removal :
  ids ⊆ ListPair.dom eam0 →
  (Expr.sub eam0 (Expr.sub (remove_all eam1 ids) e)) =
  (Expr.sub (eam0 ++ eam1) e)
:= by sorry





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
  ∃ v , Expr.is_value v ∧ Typing am v t
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
