import Lang.Util
import Lang.Basic
import Lang.NStep
import Lang.Safe

set_option pp.fieldNotation false
set_option eval.pp false

namespace Lang


def ExprPred := Expr → Prop

def Stable (P : ExprPred) : Prop :=
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
  def Subtyping (am : List (String × ExprPred)) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing am e left → Typing am e right
  termination_by (Typ.size left + Typ.size right, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [Typ.zero_lt_size])


  def MultiSubtyping (am : List (String × ExprPred)) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping am left right ∧ MultiSubtyping am remainder
  termination_by sts => (List.pair_typ_size sts, 0)
  decreasing_by
    all_goals (apply Prod.Lex.left ; simp [List.pair_typ_size, List.pair_typ_zero_lt_size, Typ.zero_lt_size])

  def Monotonic (name : String) (am : List (String × ExprPred)) (t : Typ) : Prop :=
    (∀ P0 P1 : ExprPred,
      (∀ e, P0 e → P1 e) →
      (∀ e , Typing ((name,P0)::am) e t → Typing ((name,P1)::am) e t)
    )
  termination_by (Typ.size t, 1)


  def Typing (am : List (String × ExprPred)) (e : Expr) : Typ → Prop
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
  | .exi bindings constraints body =>
    (∀ a ∈ bindings , a = "") ∧
    ∃ am' ,
    (List.length am') ≤ List.length bindings ∧
    ListPair.dom am' ∩ ListPair.dom am = [] ∧
    (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name,_) => .var name) am') constraints)) ∧
    (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name,_) => .var name) am') body))
  | .all bindings constraints body =>
    Safe e ∧
    (∀ a ∈ bindings , a = "") ∧
    (∀ am' ,
      (List.length am') ≤ List.length bindings →
      ListPair.dom am' ∩ ListPair.dom am = [] →
      (MultiSubtyping (am' ++ am) (Typ.constraints_instantiate 0 (List.map (fun (name, _) => .var name) am') constraints)) →
      (Typing (am' ++ am) e (Typ.instantiate 0 (List.map (fun (name, _) => .var name) am') body))
    )
  | .lfp a body =>
    Safe e ∧
    a = "" ∧
    ∃ name, name ∉ Typ.free_vars body ∧
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
  intro h0 h1
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
    unfold Typing
    intro ⟨h0,h1⟩

    apply And.intro
    { exact Safe.subject_reduction transition h0 }
    { intro e'' h2
      specialize h1 e'' h2
      apply Typing.subject_reduction
      { apply NStep.applicator _ transition }
      { exact h1 }
    }

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
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_reduction transition h0 }
    {
      intro h2
      apply h1
      apply Typing.subject_expansion transition h2
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
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { exact Safe.subject_expansion transition h0 }
    { intro e'' h2
      specialize h1 e'' h2
      apply Typing.subject_expansion
      { apply NStep.applicator _ transition }
      { exact h1 }
    }

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
    unfold Typing
    intro ⟨h0,h1⟩
    apply And.intro
    { apply Typing.subject_expansion transition h0 }
    {
      intro h2
      apply h1
      apply Typing.subject_reduction transition h2
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
  (tam : List (String × ExprPred)) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
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
  id ∉ List.pair_typ_free_vars cs →
  MultiSubtyping tam0 cs →
  MultiSubtyping ((id,t) :: tam0) cs
:= by sorry

theorem MultiSubtyping.dom_extension {am1 am0 cs} :
  (ListPair.dom am1) ∩ List.pair_typ_free_vars cs = [] →
  MultiSubtyping am0 cs →
  MultiSubtyping (am1 ++ am0) cs
:= by sorry

theorem MultiSubtyping.dom_reduction {am1 am0 cs} :
  (ListPair.dom am1) ∩ List.pair_typ_free_vars cs = [] →
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
  | .all ids subtypings body =>
      let δ' := remove_all δ ids
      .all ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .exi ids subtypings body =>
      let δ' := remove_all δ ids
      .exi ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end

theorem Subtyping.transitivity :
  Subtyping am t0 t1 →
  Subtyping am t1 t2 →
  Subtyping am t0 t2
:= by
  unfold Subtyping
  intro h0 h1 e h3
  apply h1
  specialize h0 e h3
  apply h0

mutual
  theorem Typing.shift_vars_preservation :
    Typing am e t →
    ∀ threshold offset, Typing am e (Typ.shift_vars threshold offset t)
  := by cases t with
  | _ => sorry

  theorem Typing.shift_vars_reflection :
    Typing am e (Typ.shift_vars threshold offset t) →
    Typing am e t
  := by cases t with
  | bvar i =>
    simp [Typ.shift_vars]
    by_cases h0 : threshold ≤ i
    { simp [h0] ; simp [Typing]}
    { simp [h0]}
  | var name =>
    simp [Typ.shift_vars]
  | iso l body =>
    simp [Typ.shift_vars, Typing]
    intro h0 h1
    simp [h0]
    apply Typing.shift_vars_reflection h1
  | entry l body =>
    simp [Typ.shift_vars, Typing]
    intro h0 h1
    simp [h0]
    apply Typing.shift_vars_reflection h1
  | path left right =>
    simp [Typ.shift_vars, Typing]
    intro h0 h1
    simp [*]
    intro arg h4
    apply Typing.shift_vars_reflection
    apply h1
    apply Typing.shift_vars_preservation h4
  | bot =>
    simp [Typ.shift_vars, Typing]
  | top =>
    simp [Typ.shift_vars, Typing]
  | unio left right =>
    simp [Typ.shift_vars, Typing]
    intro h0
    cases h0 with
    | inl h2 =>
      apply Or.inl
      apply Typing.shift_vars_reflection h2
    | inr h2 =>
      apply Or.inr
      apply Typing.shift_vars_reflection h2
  | inter left right =>
    simp [Typ.shift_vars, Typing]
    intro h0 h1
    apply And.intro
    { apply Typing.shift_vars_reflection h0 }
    { apply Typing.shift_vars_reflection h1 }
  | diff left right =>
    simp [Typ.shift_vars, Typing]
    intro h0 h1
    apply And.intro
    { apply Typing.shift_vars_reflection h0 }
    { intro h2
      apply h1
      apply Typing.shift_vars_preservation h2
    }
  | all bs cs body =>
    sorry
  | _ => sorry
end


mutual
  theorem Typing.nameless_instantiation :
    name ∉ Typ.free_vars body →
    Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body) →
    Typing am e (Typ.instantiate depth [t] body)
  := by sorry

  theorem Typing.named_instantiation :
    name ∉ Typ.free_vars body →
    Typing am e (Typ.instantiate depth [t] body) →
    Typing ((name,fun e => Typing am e t) :: am) e (Typ.instantiate depth [.var name] body)
  := by cases body with
  | bvar i =>
    simp [Typ.instantiate]
    by_cases h0 : depth ≤ i
    { simp [h0]
      by_cases h1 : i - depth = 0
      { simp [h1]
        intro h2 h3
        apply Typing.shift_vars_reflection at h3
        simp [Typ.shift_vars]
        simp [Typing]
        apply And.intro (safety h3)
        exists (fun e => Typing am e t)
        simp [find,h3]
        unfold Stable
        simp
        intro e e' h4
        apply Iff.intro
        { intro h5 ; exact subject_reduction h4 h5 }
        { intro h5 ; exact subject_expansion h4 h5 }
      }
      { simp [h1]
        simp [Typing]
      }
    }
    { simp [h0]
      simp [Typing]
    }
    -- by_cases h0 : i - depth = 0
    -- { simp [h0]
    --   simp [Typ.shift_vars_zero]
    --   intro h1 h2
    --   simp [Typing]
    --   apply And.intro
    --   { exact safety h2 }
    --   {
    --     exists (fun e => Typing am e t)
    --     apply And.intro
    --     { unfold Stable
    --       simp
    --       intro e e' h3
    --       apply Iff.intro
    --       { intro h4 ; exact subject_reduction h3 h4 }
    --       { intro h4 ; exact subject_expansion h3 h4 }
    --     }
    --     { apply And.intro
    --       { simp [find] }
    --       { simp [h2] }
    --     }
    --   }
    -- }
    -- { simp [h0]
    --   simp [Typing]
    -- }
  | var name' =>
    simp [Typ.instantiate, Typ.free_vars, Typing]
    intro h0 h1 P h2 h3 h4
    apply And.intro h1
    exists P
    simp [h0,h2,h3,h4,find]
  | iso l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2
    simp [h1]
    apply Typing.named_instantiation h0 h2
  | entry l body =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2
    simp [h1]
    apply Typing.named_instantiation h0 h2
  | path left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3
    simp [*]
    intro arg h4
    apply Typing.named_instantiation h1
    apply h3
    apply Typing.nameless_instantiation h0 h4
  | bot =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | top =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
  | unio left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2
    cases h2 with
    | inl h3 =>
      apply Or.inl
      apply Typing.named_instantiation h0 h3
    | inr h3 =>
      apply Or.inr
      apply Typing.named_instantiation h1 h3
  | inter left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3
    apply And.intro
    { apply Typing.named_instantiation h0 h2 }
    { apply Typing.named_instantiation h1 h3 }
  | diff left right =>
    simp [Typ.free_vars, Typ.instantiate, Typing]
    intro h0 h1 h2 h3
    apply And.intro
    { apply Typing.named_instantiation h0 h2 }
    { intro h4
      apply h3
      apply Typing.nameless_instantiation h1 h4
    }
  | all bs cs body =>
    simp [Typ.free_vars, Typ.instantiate]
    intro h0 h1
    simp [Typing]
    intro h2 h3 h4
    simp [*]
    apply And.intro h3
    intro names h5 am' h7

    sorry
    -- apply Typing.named_instantiation

    -- simp [*]
    -- apply And.intro h2
    -- intro names h4 am' h6 h7

  | exi bs cs body =>
    sorry
  | lfp b body =>
    sorry
end


theorem Typing.lfp_elim :
  name ∉ Typ.free_vars t →
  Monotonic name am (Typ.instantiate 0 [.var name] t) →
  (Typing ((name, P) :: am) e (Typ.instantiate 0 [Typ.var name] t) → P e) →
  Typing am e (Typ.lfp "" t) → P e
:= by sorry


/- Subtyping recycling -/
theorem Subtyping.lfp_intro_direct :
  name ∉ Typ.free_vars t →
  Monotonic name am (Typ.instantiate 0 [.var name] t) →
  Subtyping am (Typ.instantiate 0 [(Typ.lfp "" t)] t) (Typ.lfp "" t)
:= by
  unfold Subtyping
  simp [Typing]
  intro h0 h1 e h2
  apply And.intro
  { exact Typing.safety h2 }
  { exists name
    simp [*]
    intro P h3 h4

    apply h4
    have h5 := h1
    unfold Monotonic at h5
    apply h5 (fun e => Typing am e (Typ.lfp "" t)) P
    {
      intro e h6
      apply Typing.lfp_elim h0 h1 (h4 e) h6
    }
    { apply Typing.named_instantiation h0 h2 }
  }

theorem Subtyping.lfp_intro :
  name ∉ Typ.free_vars body →
  Monotonic name am (Typ.instantiate 0 [.var name] body) →
  Subtyping am t (Typ.instantiate 0 [(Typ.lfp "" body)] body) →
  Subtyping am t (Typ.lfp "" body)
:= by
  intro h0 h1 h2
  apply Subtyping.transitivity h2
  exact lfp_intro_direct h0 h1



theorem Subtyping.lfp_elim :
  name ∉ Typ.free_vars body →
  Monotonic name am (Typ.instantiate 0 [.var name] body) →
  Subtyping am (Typ.instantiate 0 [t] body) t →
  Subtyping am (Typ.lfp "" body) t
:= by
  unfold Subtyping
  intro h0 h1 h2 e
  apply Typing.lfp_elim
  { exact h0 }
  { exact h1 }
  { intro h4
    apply h2
    exact Typing.nameless_instantiation h0 h4
  }

set_option eval.pp false

#eval Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ]

example : Subtyping []
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ])
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> N ])
:= by
  apply Subtyping.lfp_elim
  { sorry }
  { sorry }
  { reduce
    apply Subtyping.lfp_intro
    { sorry }
    { sorry }
    { reduce
      apply Subtyping.unio_elim
      { apply Subtyping.unio_intro_left
        apply Subtyping.refl
      }
      { apply Subtyping.unio_intro_right
        apply Subtyping.iso_pres
        apply Subtyping.lfp_intro
        { sorry }
        { sorry }
        { reduce
          apply Subtyping.unio_intro_right
          apply Subtyping.iso_pres
          apply Subtyping.refl
        }
        { sorry }
      }
    }
    { sorry }
  }
  { sorry }


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
  unfold Subtyping
  intro h0 h1
  exact h0 e h1

theorem Subtyping.list_typ_diff_elim :
  Subtyping am (List.typ_diff tp subtras) tp
:= by
  sorry


theorem Typing.path_intro :
  (∀ e' ,
    Typing am e' tp →
    ∃ eam , Pattern.match e' p = .some eam ∧ Typing am (Expr.instantiate 0 eam e) tr
  ) →
  Typing am (Expr.function ((p, e) :: f)) (Typ.path (List.typ_diff tp subtras) tr)
:= by
  intro h0
  unfold Typing
  apply And.intro
  { apply Safe.function }
  {
    intro e' h1
    have h3 := Subtyping.elimination Subtyping.list_typ_diff_elim h1
    have ⟨eam,h4,h5⟩ := h0 e' h3

    have h1 : NStep (Expr.app (Expr.function ((p, e) :: f)) e') (Expr.instantiate 0 eam e) := by
      exact NStep.pattern_match e f h4
    exact subject_expansion h1 h5
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
  unfold Typing at typing_cator
  have ⟨h0,h1⟩ := typing_cator
  exact h1 ea typing_arg

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
  unfold Subtyping
  intro h0 e h1
  unfold Typing
  unfold Typing at h1
  have ⟨h2,h3⟩ := h1
  apply And.intro h2
  apply h0
  exact h3



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
