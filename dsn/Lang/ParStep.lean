import Lang.Util
import Lang.Basic
import Lang.Pattern

set_option pp.fieldNotation false

namespace Lang

mutual

  inductive ParRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | nil : ParRcdStep [] []
  | cons l :
    ParStep e e' →  ParRcdStep r r' →
    ParRcdStep ((l, e) :: r) ((l, e') :: r')

  inductive ParFunStep : List (Pat × Expr) → List (Pat × Expr) → Prop
  | nil : ParFunStep [] []
  | cons p :
    ParStep e e' →  ParFunStep f f' →
    ParFunStep ((p, e) :: f) ((p, e') :: f')

  inductive ParStep : Expr → Expr → Prop
  | bvar i x : ParStep (.bvar i x) (.bvar i x)
  | fvar x : ParStep (.fvar x) (.fvar x)

  /- head normal forms -/
  | iso : ParStep body body' → ParStep (.iso l body) (.iso l body')
  | record : ParRcdStep r r' →  ParStep (.record r) (.record r')
  | function : ParFunStep f f' → ParStep (.function f) (.function f')

  /- redex forms -/
  | app :
    ParStep cator cator' → ParStep arg arg' →
    ParStep (.app cator arg) (.app cator' arg')
  | pattern_match f :
    ParStep body body' →
    ParStep arg arg' →
    Pattern.match arg' p = some m' →
    ParStep (.app (.function ((p,body) :: f)) arg) (Expr.instantiate 0 m' body')
  | skip body :
    ParFunStep f f' →
    ParStep arg arg' →
    Expr.is_value arg' →
    Pattern.match arg' p = none →
    ParStep (.app (.function ((p,body) :: f)) arg) (.app (.function f') arg')
  | anno : ParStep e e' → ParStep (.anno e t) (.anno e' t)
  | erase t :
    ParStep body body' →
    ParStep (.anno body t) body'
  | loopi : ParStep body body' → ParStep (.loopi body) (.loopi body')
  | recycle x :
    ParStep e e' →
    ParStep
      (.loopi (.function [(.var x, e)]))
      (Expr.instantiate 0 [(.loopi (.function [(.var x, e')]))] e')
end

mutual
  theorem ParRcdStep.refl r :
    ParRcdStep r r
  := by cases r with
  | nil =>
    exact ParRcdStep.nil
  | cons le r'' =>
    apply ParRcdStep.cons
    { exact ParStep.refl (Prod.snd le) }
    { apply ParRcdStep.refl }

  theorem ParFunStep.refl f :
    ParFunStep f f
  := by cases f with
  | nil =>
    exact ParFunStep.nil
  | cons le r'' =>
    apply ParFunStep.cons
    { exact ParStep.refl (Prod.snd le) }
    { apply ParFunStep.refl }

  theorem ParStep.refl e :
    ParStep e e
  := by cases e with
  | bvar i x =>
    exact ParStep.bvar i x
  | fvar x =>
    exact ParStep.fvar x
  | iso l body =>
    apply ParStep.iso
    apply ParStep.refl
  | record r =>
    apply ParStep.record
    apply ParRcdStep.refl
  | function f =>
    apply ParStep.function
    apply ParFunStep.refl
  | app ef ea =>
    apply ParStep.app
    { apply ParStep.refl }
    { apply ParStep.refl }
  | anno body t =>
    apply ParStep.anno
    apply ParStep.refl
  | loopi body =>
    apply ParStep.loopi
    apply ParStep.refl
end

theorem ParStep.joinable_iso :
  Joinable ParStep a b →
  Joinable ParStep (.iso l a) (.iso l b)
:= by
  unfold Joinable
  intro h0
  have ⟨c,h1,h2⟩ := h0
  exists (.iso l c)
  apply And.intro
  { exact iso h1 }
  { exact iso h2 }

theorem ParRcdStep.triangle :
  ParRcdStep a b →
  Joinable ParRcdStep a b
:= by
  intro step
  unfold Joinable
  exists b
  apply And.intro step
  exact ParRcdStep.refl b

theorem ParFunStep.triangle :
  ParFunStep a b →
  Joinable ParFunStep a b
:= by
  intro step
  unfold Joinable
  exists b
  apply And.intro step
  exact ParFunStep.refl b


theorem ParStep.triangle :
  ParStep a b →
  Joinable ParStep a b
:= by
  intro step
  unfold Joinable
  exists b
  apply And.intro step
  exact ParStep.refl b

theorem ParStep.joinable_refl :
  Joinable ParStep e e
:= by
  unfold Joinable
  exists e
  apply And.intro (refl e) (refl e)

theorem ParStep.joinable_record :
  Joinable ParRcdStep ra rb →
  Joinable ParStep (.record ra) (.record rb)
:= by
  unfold Joinable
  intro h0
  have ⟨rc,h1,h2⟩ := h0
  exists (.record rc)
  apply And.intro
  { exact record h1 }
  { exact record h2 }

theorem ParStep.joinable_function :
  Joinable ParFunStep ra rb →
  Joinable ParStep (.function ra) (.function rb)
:= by
  unfold Joinable
  intro h0
  have ⟨rc,h1,h2⟩ := h0
  exists (.function rc)
  apply And.intro
  { exact function h1 }
  { exact function h2 }

theorem ParRcdStep.fresh_key_reduction :
  ParRcdStep r r' →
  List.is_fresh_key l r →
  List.is_fresh_key l r'
:= by
  intro h0
  cases h0 with
  | nil =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr =>
    intro fresh_r
    simp [List.is_fresh_key] at fresh_r
    have ⟨h1,h2⟩ := fresh_r
    clear fresh_r
    simp [List.is_fresh_key]
    apply And.intro h1
    apply ParRcdStep.fresh_key_reduction step_rr h2

theorem ParRcdStep.fresh_key_expansion :
  ParRcdStep r r' →
  List.is_fresh_key l r' →
  List.is_fresh_key l r
:= by
  intro h0
  cases h0 with
  | nil =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr =>
    intro fresh_r
    simp [List.is_fresh_key] at fresh_r
    have ⟨h1,h2⟩ := fresh_r
    clear fresh_r
    simp [List.is_fresh_key]
    apply And.intro h1
    apply ParRcdStep.fresh_key_expansion step_rr h2

theorem ParRcdStep.keys_unique_reduction :
  ParRcdStep r r' →
  List.keys_unique r →
  List.keys_unique r'
:= by
  intro h0
  cases h0 with
  | nil  =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr=>
    intro h1
    simp [List.keys_unique] at h1
    have ⟨h2,h3⟩ := h1
    simp [List.keys_unique]
    apply And.intro
    { exact fresh_key_reduction step_rr h2 }
    { exact ParRcdStep.keys_unique_reduction step_rr h3 }


theorem ParRcdStep.keys_unique_expansion :
  ParRcdStep r r' →
  List.keys_unique r' →
  List.keys_unique r
:= by
  intro h0
  cases h0 with
  | nil  =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr=>
    intro h1
    simp [List.keys_unique] at h1
    have ⟨h2,h3⟩ := h1
    simp [List.keys_unique]
    apply And.intro
    { exact fresh_key_expansion step_rr h2 }
    { exact ParRcdStep.keys_unique_expansion step_rr h3 }




theorem ParRcdStep.joinable_cons :
  Joinable ParStep ea eb →
  Joinable ParRcdStep ra rb →
  Joinable ParRcdStep ((l,ea)::ra) ((l,eb)::rb)
:= by
  unfold Joinable
  intro h1 h2
  have ⟨ec,h4,h5⟩ := h1
  have ⟨rc,h6,h7⟩ := h2
  exists ((l,ec)::rc)
  apply And.intro (cons l h4 h6) (cons l h5 h7)

theorem ParFunStep.joinable_cons :
  Joinable ParStep ea eb →
  Joinable ParFunStep ra rb →
  Joinable ParFunStep ((l,ea)::ra) ((l,eb)::rb)
:= by
  unfold Joinable
  intro h1 h2
  have ⟨ec,h4,h5⟩ := h1
  have ⟨rc,h6,h7⟩ := h2
  exists ((l,ec)::rc)
  apply And.intro (cons l h4 h6) (cons l h5 h7)

theorem Joinable.app :
  Joinable ParStep fa fb →
  Joinable ParStep arg_a arg_b →
  Joinable ParStep (Expr.app fa arg_a) (Expr.app fb arg_b)
:= by
  unfold Joinable
  intro h0 h1
  have ⟨fc,h2,h3⟩ := h0
  have ⟨arg_c,h4,h5⟩ := h1
  clear h0 h1
  exists (.app fc arg_c)
  apply And.intro
  { exact ParStep.app h2 h4 }
  { exact ParStep.app h3 h5 }

mutual

  theorem ParRcdStep.pattern_match_entry_reduction :
    ParRcdStep r r' →
    Pattern.match_entry l p r = some m →
    ∃ m' , Pattern.match_entry l p r' = some m'
  := by
    intro h0 h1
    cases h0 with
    | nil =>
      exact Exists.intro m h1
    | @cons e e' rr rr' l' step_e step_rr =>
      simp [Pattern.match_entry] at h1
      by_cases h3 : l' = l
      {
        simp [*] at h1
        have ⟨m',ih⟩ := ParStep.pattern_match_reduction step_e h1
        exists m'
        simp [Pattern.match_entry, *]
      }
      {
        simp [*] at h1
        have ⟨m',ih⟩ := ParRcdStep.pattern_match_entry_reduction step_rr h1
        exists m'
        simp [Pattern.match_entry, *]
      }

  theorem ParRcdStep.pattern_match_reduction :
    ParRcdStep r r' →
    Pattern.match_record r rp = some m →
    ∃ m' , Pattern.match_record r' rp = some m'
  := by cases rp with
  | nil =>
    intro h0 h1
    simp [Pattern.match_record]
  | cons lp rp' =>
    have (l,p) := lp
    intro h0 h1
    simp [Pattern.match_record] at h1
    have ⟨h2,h3⟩ := h1
    clear h1

    cases h4 : (Pattern.match_entry l p r) with
    | some m0 =>
      simp [h4] at h3
      cases h5 : (Pattern.match_record r rp') with
      | some m1 =>
        simp [h5] at h3
        have ⟨m0',h8⟩ := ParRcdStep.pattern_match_entry_reduction h0 h4
        have ⟨m1',h9⟩ := ParRcdStep.pattern_match_reduction h0 h5
        exists (m0' ++ m1')
        simp [Pattern.match_record, *]

      | none =>
        simp [h5] at h3
    | none =>
      simp [h4] at h3


  theorem ParStep.pattern_match_reduction :
    ParStep arg arg' →
    Pattern.match arg p = some m →
    ∃ m' , Pattern.match arg' p = some m'
  := by cases p with
  | var x =>
    intro h0 h1
    exists [arg']
    simp [Pattern.match]
  | iso l p' =>
    intro h0 h1
    cases h0 with
    | bvar i x =>
      exact Exists.intro m h1
    | fvar x =>
      exact Exists.intro m h1
    | @iso e e' l' step =>
      simp [Pattern.match] at h1
      have ⟨h2,h3⟩ := h1
      clear h1
      have ⟨m',ih⟩ := ParStep.pattern_match_reduction step h3
      exists m'
      simp [Pattern.match]
      exact ⟨h2, ih⟩
    | _ =>
      simp [Pattern.match] at h1
  | record ps =>
    intro h0 h1
    cases h0 with
    | bvar ix =>
      exact Exists.intro m h1
    | fvar x =>
      exact Exists.intro m h1
    | iso =>
      simp [Pattern.match] at h1
    | @record r r' step =>
      simp [Pattern.match] at h1
      have ⟨h2,h3⟩ := h1
      have ⟨m',ih⟩ := ParRcdStep.pattern_match_reduction step h3
      exists m'
      simp [Pattern.match]
      apply And.intro
      { exact ParRcdStep.keys_unique_reduction step h2 }
      { exact ih }
    | _ =>
      simp [Pattern.match] at h1
end


mutual

  theorem ParRcdStep.value_reduction
    (step : ParRcdStep r r')
  : List.is_record_value r → List.is_record_value r'
  := by cases step with
  | nil =>
    exact fun a => a
  | @cons e e' rr rr' l step_e step_rr =>
    simp [List.is_record_value]
    intro h0 h1 h2
    apply And.intro
    { apply And.intro
      { apply ParRcdStep.fresh_key_reduction step_rr h0}
      { apply ParStep.value_reduction step_e h1 }
    }
    { apply ParRcdStep.value_reduction step_rr h2 }

  theorem ParStep.value_reduction
    (step : ParStep e e')
  : Expr.is_value e → Expr.is_value e'
  := by cases step with
  | bvar i x =>
    exact fun a => a
  | fvar x =>
    exact fun a => a
  | @iso body body' l step_body =>
    simp [Expr.is_value]
    intro h0
    apply ParStep.value_reduction step_body h0
  | @record r r' step_r =>
    simp [Expr.is_value]
    intro h0
    apply ParRcdStep.value_reduction step_r h0
  | @function f f' step_f =>
    simp [Expr.is_value]
  | _ => simp [Expr.is_value]
end

mutual
  theorem ParRcdStep.pattern_match_entry_expansion
    (isval : List.is_record_value r)
    (step : ParRcdStep r r')
  : Pattern.match_entry l p r' = some m' → ∃ m , Pattern.match_entry l p r = some m
  := by cases step with
  | nil =>
    intro h0
    exact Exists.intro m' h0
  | @cons e e' rr rr' l' step_e step_rr =>
    simp [Pattern.match_entry]
    simp [List.is_record_value] at isval
    have ⟨⟨h0,h1⟩,h2⟩ := isval
    intro h3
    by_cases h4 : l' = l
    {
      simp [*] at h3
      have ⟨m,ih⟩ := ParStep.pattern_match_expansion h1 step_e h3
      exists m
      simp [*]
    }
    {
      simp [*] at h3
      have ⟨m,ih⟩ := ParRcdStep.pattern_match_entry_expansion h2 step_rr h3
      exists m
      simp [*]
    }

  theorem ParRcdStep.pattern_match_expansion
    (isval : List.is_record_value r)
    (step : ParRcdStep r r')
  : Pattern.match_record r' ps = some m' → ∃ m , Pattern.match_record r ps = some m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp rp' =>
    have (l,p) := lp
    intro h0
    simp [Pattern.match_record] at h0
    have ⟨h2,h3⟩ := h0
    clear h0

    cases h4 : (Pattern.match_entry l p r') with
    | some m0' =>
      simp [h4] at h3
      cases h5 : (Pattern.match_record r' rp') with
      | some m1' =>
        simp [h5] at h3
        have ⟨m0,h8⟩ := ParRcdStep.pattern_match_entry_expansion isval step h4
        have ⟨m1,h9⟩ := ParRcdStep.pattern_match_expansion isval step h5
        exists (m0 ++ m1)
        simp [Pattern.match_record, *]
      | none =>
        simp [h5] at h3
    | none =>
      simp [h4] at h3

  theorem ParStep.pattern_match_expansion
    (isval : Expr.is_value e)
    (step : ParStep e e')
  : Pattern.match e' p = some m' → ∃ m , Pattern.match e p = some m
  := by cases p with
  | var x =>
    simp [Pattern.match]
  | iso l p' =>
    cases step with
    | bvar i x =>
      intro h0
      exact Exists.intro m' h0
    | fvar x =>
      intro h0
      exact Exists.intro m' h0
    | @iso body body' l' step_body =>
      simp [Pattern.match]
      simp [Expr.is_value] at isval
      intro h0 h1
      apply And.intro h0
      have ⟨m,ih⟩ := ParStep.pattern_match_expansion isval step_body h1
      exists m
    | _ =>
      simp [Pattern.match] <;> simp [Expr.is_value] at isval
  | record ps =>
    cases step with
    | bvar i x =>
      intro h0
      exact Exists.intro m' h0
    | fvar x =>
      intro h0
      exact Exists.intro m' h0
    | iso =>
      simp [Pattern.match]
    | @record r r' step =>
      simp [Pattern.match]
      simp [Expr.is_value] at isval
      intro h0 h1
      have ⟨m,ih⟩ := ParRcdStep.pattern_match_expansion isval step h1
      apply And.intro (ParRcdStep.keys_unique_expansion step h0)
      exists m
    | _ =>
      simp [Pattern.match] <;> simp [Expr.is_value] at isval
end

theorem ParRcdStep.skip_reduction
  (isval : List.is_record_value r)
  (step : ParRcdStep r r')
: Pattern.match_record r ps = none → Pattern.match_record r' ps = none
:= by cases ps with
| nil =>
  simp [Pattern.match_record]
| cons lp ps' =>
  have (l,p) := lp
  simp [Pattern.match_record]
  intro h0 h1 m0' h3 m1' h5

  have ⟨m0,h6⟩ := ParRcdStep.pattern_match_entry_expansion isval step h3
  have ⟨m1,h7⟩ := ParRcdStep.pattern_match_expansion isval step h5
  exact h0 h1 m0 h6 m1 h7

theorem Expr.record_shift_vars_keys_is_fresh_key_preservation :
  List.is_fresh_key l r →
  List.is_fresh_key l  (List.record_shift_vars threshold offset r)
:= by induction r with
| nil =>
  simp [List.record_shift_vars, List.is_fresh_key]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_shift_vars, List.is_fresh_key]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_shift_vars_keys_is_fresh_key_reflection :
  List.is_fresh_key l  (List.record_shift_vars threshold offset r) →
  List.is_fresh_key l r
:= by induction r with
| nil =>
  simp [List.record_shift_vars, List.is_fresh_key]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_shift_vars, List.is_fresh_key]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_instantiate_keys_is_fresh_key_reflection :
  List.is_fresh_key l  (List.record_instantiate depth d r) →
  List.is_fresh_key l r
:= by induction r with
| nil =>
  simp [List.record_instantiate, List.is_fresh_key]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_instantiate, List.is_fresh_key]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_instantiate_keys_is_fresh_key_preservation :
  List.is_fresh_key l r →
  List.is_fresh_key l  (List.record_instantiate depth d r)
:= by induction r with
| nil =>
  simp [List.record_instantiate, List.is_fresh_key]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_instantiate, List.is_fresh_key]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_instantiate_keys_unique_preservation :
  List.keys_unique r →
  List.keys_unique (List.record_instantiate depth d r)
:= by induction r with
| nil =>
  simp [List.record_instantiate, List.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_instantiate, List.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_instantiate_keys_is_fresh_key_preservation h0 }
  { apply ih h1 }


theorem Expr.record_shift_vars_keys_unique_preservation :
  List.keys_unique r →
  List.keys_unique (List.record_shift_vars threshold offset r)
:= by induction r with
| nil =>
  simp [List.record_shift_vars, List.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_shift_vars, List.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_shift_vars_keys_is_fresh_key_preservation h0 }
  { apply ih h1 }

theorem Expr.record_shift_vars_keys_unique_reflection :
  List.keys_unique (List.record_shift_vars threshold offset r) →
  List.keys_unique r
:= by induction r with
| nil =>
  simp [List.record_shift_vars, List.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_shift_vars, List.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_shift_vars_keys_is_fresh_key_reflection h0 }
  { apply ih h1 }

theorem Expr.record_instantiate_keys_unique_reflection :
  List.keys_unique (List.record_instantiate depth d r) →
  List.keys_unique r
:= by induction r with
| nil =>

  simp [List.record_instantiate, List.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_instantiate, List.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_instantiate_keys_is_fresh_key_reflection h0 }
  { apply ih h1 }

theorem ParStep.skip_reduction
  (isval : Expr.is_value e)
  (step : ParStep e e')
: Pattern.match e p = none → Pattern.match e' p = none
:= by cases p with
| var x =>
  simp [Pattern.match]
| iso l pbody =>
  cases step with
  | @iso body body' l' step_body =>
    simp [Pattern.match]
    simp [Expr.is_value] at isval
    intro h0 h1
    apply ParStep.skip_reduction isval step_body (h0 h1)
  | _ =>
    simp [Pattern.match] <;>
    simp [Expr.is_value] at isval
| record ps =>
  cases step with
  | @record r r' step_r =>
    simp [Pattern.match]
    simp [Expr.is_value] at isval
    intro h0 h1
    apply ParRcdStep.skip_reduction isval step_r
    apply h0
    apply ParRcdStep.keys_unique_expansion step_r h1
  | _ =>
    simp [Pattern.match] <;>
    simp [Expr.is_value] at isval

mutual

  theorem Expr.record_shift_vars_inside_out threshold depth offset level r:
    List.record_shift_vars (threshold + level + depth) offset (List.record_shift_vars level depth r)
    =
    List.record_shift_vars level depth (List.record_shift_vars (threshold + level) offset r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_inside_out }
    { apply Expr.record_shift_vars_inside_out }

  theorem Expr.function_shift_vars_inside_out threshold depth offset level f :
    List.function_shift_vars (threshold + level + depth) offset (List.function_shift_vars level depth f)
    =
    List.function_shift_vars level depth (List.function_shift_vars (threshold + level) offset f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe r =>
    have (p,e) := pe
    simp [List.function_shift_vars]

    apply And.intro
    {

      have h0 :
        threshold + level + depth + Pat.count_vars p =
        threshold + level + Pat.count_vars p + depth
      := by exact Nat.add_right_comm (threshold + level) depth (Pat.count_vars p)
      rw [h0]

      have h1 :
        threshold + level + Pat.count_vars p  =
        threshold + (level + Pat.count_vars p)
      := by exact Nat.add_assoc threshold level (Pat.count_vars p)
      rw [h1]
      apply Expr.shift_vars_inside_out
    }
    { apply Expr.function_shift_vars_inside_out }

  theorem Expr.shift_vars_inside_out threshold depth offset level arg :
    Expr.shift_vars (threshold + level + depth) offset (Expr.shift_vars level depth arg)
    =
    Expr.shift_vars level depth (Expr.shift_vars (threshold + level) offset arg)
  := by cases arg with
  | bvar i x =>
    simp [Expr.shift_vars]
    by_cases  h0 : level ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      by_cases h1 : threshold + level ≤ i
      { simp [h1]
        simp [Expr.shift_vars]

        have h2 : level ≤  i + offset := by exact Nat.le_add_right_of_le h0
        simp [h2]
        exact Nat.add_right_comm i depth offset
      }
      { simp [h1]
        simp [Expr.shift_vars]
        intro h2
        have h3 : ¬ i < level := by
          exact Iff.mpr Nat.not_lt h0
        apply False.elim (h3 h2)
      }
    }
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : ¬ threshold + level ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]

      have h2 : ¬ threshold + level + depth ≤ i := by
        intro h
        apply h1
        exact Nat.le_of_add_right_le h
      simp [h2]

      simp [Expr.shift_vars]
      intro h3
      apply False.elim (h0 h3)
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_inside_out

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_inside_out

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_inside_out }
    { apply Expr.shift_vars_inside_out }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out
end

theorem Expr.shift_vars_zero_inside_out threshold depth offset arg :
  Expr.shift_vars (threshold + depth) offset (Expr.shift_vars 0 depth arg)
  =
  Expr.shift_vars 0 depth (Expr.shift_vars threshold offset arg)
:= by
  have h0 : threshold = threshold + 0 := by exact rfl
  rw [h0]
  apply Expr.shift_vars_inside_out

mutual
  theorem Expr.record_shift_vars_instantiate_inside_out threshold depth offset m r:
    List.record_shift_vars (threshold + depth) offset (List.record_instantiate depth m r)
    =
    List.record_instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (List.record_shift_vars (threshold + List.length m + depth) offset r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars, List.record_instantiate]
  | cons le r =>
    have (l,e) := le
    simp [List.record_shift_vars, List.record_instantiate]
    apply And.intro
    { apply Expr.shift_vars_instantiate_inside_out }
    { apply Expr.record_shift_vars_instantiate_inside_out }

  theorem Expr.function_shift_vars_instantiate_inside_out threshold depth offset m f :
    List.function_shift_vars (threshold + depth) offset
      (List.function_instantiate depth m f)
    =
    List.function_instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (List.function_shift_vars (threshold + List.length m + depth) offset f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars, List.function_instantiate]
  | cons pe r =>
    have (p,e) := pe
    simp [List.function_shift_vars, List.function_instantiate]

    apply And.intro
    {
      have h0 :
        threshold + depth + Pat.count_vars p
        =
        threshold + (depth + Pat.count_vars p)
      := by exact Nat.add_assoc threshold depth (Pat.count_vars p)

      have h1 :
        threshold + List.length m + depth + Pat.count_vars p
        =
        threshold + List.length m + (depth + Pat.count_vars p)
      := by exact Nat.add_assoc (threshold + List.length m) depth (Pat.count_vars p)

      rw [h0,h1]
      apply Expr.shift_vars_instantiate_inside_out
    }
    { apply Expr.function_shift_vars_instantiate_inside_out }


  theorem Expr.shift_vars_instantiate_inside_out threshold depth offset m e :
    (Expr.shift_vars (threshold + depth) offset (Expr.instantiate depth m e))
    =
    (Expr.instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (Expr.shift_vars (threshold + List.length m + depth) offset e)
    )
  := by cases e with
  | bvar i x =>
    simp [Expr.instantiate]

    by_cases h0 : depth ≤ i
    {
      simp [h0]
      cases h1 : m[i - depth]? with
      | some arg =>
        simp [Expr.shift_vars]

        have h2 : i - depth < List.length m := by
          have ⟨h,g⟩ := Iff.mp List.getElem?_eq_some_iff h1
          exact h
        have h3 : i - depth < threshold + List.length m := by
          exact Nat.lt_add_left threshold h2
        have h4 : i < threshold + List.length m + depth := by
          exact Iff.mp (Nat.sub_lt_iff_lt_add h0) h3
        have h5 : ¬ (threshold + List.length m + depth) ≤ i := by
          exact Nat.not_le_of_lt h4

        simp [h5]
        simp [Expr.instantiate]
        simp [h0]
        have h6 := Expr.list_shift_vars_get_some_preservation threshold offset (i - depth) h1
        simp [h6]
        apply Expr.shift_vars_zero_inside_out

      | none =>
        simp
        simp [Expr.shift_vars]
        have h2 : List.length m ≤ i - depth := by
          exact Iff.mp List.getElem?_eq_none_iff h1

        by_cases h3 : threshold + depth ≤ i - List.length m
        { simp [h3]

          have h4 : List.length m ≤ i - depth + depth := by exact Nat.le_add_right_of_le h2
          have h5 : i - depth + depth = i := by exact Nat.sub_add_cancel h0
          rw [h5] at h4

          have h6 : threshold + depth + List.length m ≤ i := by
            exact Nat.add_le_of_le_sub h4 h3

          have h7 :
            threshold + depth + List.length m =  threshold + List.length m + depth
          := by exact Nat.add_right_comm threshold depth (List.length m)

          rw [h7] at h6
          simp [h6]
          simp [Expr.instantiate]

          have h8 : depth ≤ i + offset := by exact Nat.le_add_right_of_le h0
          simp [h8]
          have h9 := List.get_none_add_preservation m (i - depth) offset h1
          have h10 := Expr.list_shift_vars_get_none_preservation threshold offset (i - depth + offset) h9
          have h11 : (i - depth + offset) = (i + offset - depth) := by
            exact Eq.symm (Nat.sub_add_comm h0)
          rw [h11] at h10
          simp [h10]
          simp [Expr.list_shift_vars_length_eq]
          exact Eq.symm (Nat.sub_add_comm h4)
        }
        {
          simp [h3]
          have h4 : ¬ threshold + depth + List.length m ≤ i := by
            intro h
            apply h3
            exact Nat.le_sub_of_add_le h

          have h5 :
            threshold + depth + List.length m = threshold + List.length m + depth
          := by exact Nat.add_right_comm threshold depth (List.length m)
          rw [h5] at h4

          simp [h4]
          simp [Expr.instantiate]
          simp [h0]
          have h6 := Expr.list_shift_vars_get_none_preservation threshold offset (i - depth) h1
          simp [h6]
          simp [Expr.list_shift_vars_length_eq]
        }
    }
    { simp [h0]
      simp [Expr.shift_vars]
      have h1 : ¬ threshold + depth ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]

      have h2 : ¬ threshold + depth + List.length m ≤ i := by
        intro h
        apply h1
        exact Nat.le_of_add_right_le h

      have h3 :
        threshold + depth + List.length m = threshold + List.length m + depth
      := by exact Nat.add_right_comm threshold depth (List.length m)
      rw [h3] at h2

      simp [h2]
      simp [Expr.instantiate]
      simp [h0]
    }

  | fvar x =>
    simp [Expr.shift_vars, Expr.instantiate]
  | iso l body =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out
  | record r =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.record_shift_vars_instantiate_inside_out

  | function f =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.function_shift_vars_instantiate_inside_out

  | app ef ea =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply And.intro
    { apply Expr.shift_vars_instantiate_inside_out }
    { apply Expr.shift_vars_instantiate_inside_out }

  | anno body t =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out

  | loopi body =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out
end

theorem Expr.shift_vars_instantiate_zero_inside_out threshold offset m e :
  (Expr.shift_vars threshold offset (Expr.instantiate 0 m e))
  =
  (Expr.instantiate 0
    (Expr.list_shift_vars threshold offset m)
    (Expr.shift_vars (threshold + List.length m) offset e)
  )
:= by
  have h0 : threshold = threshold + 0 := by
    exact rfl
  rw [h0]
  rw [Expr.shift_vars_instantiate_inside_out threshold 0 offset m e]
  rfl

mutual
  theorem Pattern.match_entry_shift_vars_preservation :
    Pattern.match_entry l p r = some m →
    ∀ threshold offset,
    Pattern.match_entry l p (List.record_shift_vars threshold offset r)
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases r with
  | nil =>
    simp [Pattern.match_entry]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.record_shift_vars, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_shift_vars_preservation h1
    }
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_entry_shift_vars_preservation h1
    }

  theorem Pattern.match_record_shift_vars_preservation :
    Pattern.match_record r ps = some m →
    ∀ threshold offset,
    Pattern.match_record (List.record_shift_vars threshold offset r) ps
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
    intro h0
    simp [*, Expr.list_shift_vars]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (Pattern.match_entry l p r),
      h1 : (Pattern.match_record r ps')
    with
    | some m0, some m1 =>
      simp
      intro h3 h4 threshold offset
      simp [h3]

      have ih0 := Pattern.match_entry_shift_vars_preservation h0 threshold offset
      have ih1 := Pattern.match_record_shift_vars_preservation h1 threshold offset
      simp [ih0,ih1,←h4]
      exact Expr.list_shift_vars_concat
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_shift_vars_preservation :
    Pattern.match arg p = some m →
    ∀ threshold offset,
    Pattern.match (Expr.shift_vars threshold offset arg) p
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases p with
  | var x  =>
    simp [Pattern.match]
    intro h0
    simp [←h0]
    simp [Expr.list_shift_vars]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Pattern.match, Expr.shift_vars]
      intro h0 h1 threshold offset
      simp [*]
      apply Pattern.match_shift_vars_preservation h1 threshold offset
    | _ =>
      simp [Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Pattern.match, Expr.shift_vars]
      intro h0 h1 threshold offset
      apply And.intro
      { exact Expr.record_shift_vars_keys_unique_preservation h0 }
      { apply Pattern.match_record_shift_vars_preservation h1}
    | _ =>
      simp [Pattern.match]
end

mutual
  theorem Pattern.match_entry_shift_vars_reflection :
    List.is_record_value r →
    Pattern.match_entry l p (List.record_shift_vars threshold offset r) = some m' →
    ∃ m, Pattern.match_entry l p r = some m
  := by cases r with
  | nil =>
    simp [List.is_record_value, Pattern.match_entry, List.record_shift_vars]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.is_record_value, List.record_shift_vars, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_shift_vars_reflection h2
    }
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_entry_shift_vars_reflection h3
    }

  theorem Pattern.match_record_shift_vars_reflection :
    List.is_record_value r →
    Pattern.match_record (List.record_shift_vars threshold offset r) ps = some m' →
    ∃ m , Pattern.match_record r ps = some m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (match_entry l p (List.record_shift_vars threshold offset r)),
      h1 : (Pattern.match_record (List.record_shift_vars threshold offset r) ps')
    with
    | some m0', some m1' =>
      simp
      intro isval h3 h4
      simp [h3]

      have ⟨m0,ih0⟩ := Pattern.match_entry_shift_vars_reflection isval h0
      have ⟨m1,ih1⟩ := Pattern.match_record_shift_vars_reflection isval h1
      simp [ih0,ih1]
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_shift_vars_reflection :
    Expr.is_value arg →
    Pattern.match (Expr.shift_vars threshold offset arg) p = some m' →
    ∃ m, Pattern.match arg p = some m
  := by cases p with
  | var x  =>
    simp [Pattern.match]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Expr.is_value, Pattern.match, Expr.shift_vars]
      intro isval h0 h1
      simp [*]
      apply Pattern.match_shift_vars_reflection isval h1
    | _ =>
      simp [Expr.is_value, Pattern.match, Expr.shift_vars]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.is_value, Pattern.match, Expr.shift_vars]
      intro ival h0 h1
      apply And.intro
      { exact Expr.record_shift_vars_keys_unique_reflection h0 }
      { apply Pattern.match_record_shift_vars_reflection ival h1 }
    | _ =>
      simp [Expr.is_value, Pattern.match, Expr.shift_vars]
end

mutual

  theorem Expr.record_is_value_shift_vars_preservation :
    List.is_record_value r = true →
    ∀ (threshold offset : ℕ), List.is_record_value (List.record_shift_vars threshold offset r) = true
  := by cases r with
  | nil =>
    simp [List.is_record_value, List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.is_record_value, List.record_shift_vars]
    intro h0 h1 h2 threshold offset
    apply And.intro
    {
      apply And.intro
      { exact record_shift_vars_keys_is_fresh_key_preservation h0 }
      { apply Expr.is_value_shift_vars_preservation h1 }
    }
    { apply Expr.record_is_value_shift_vars_preservation h2 }


  theorem Expr.is_value_shift_vars_preservation :
    (Expr.is_value e) →
    ∀ threshold offset, (Expr.is_value (Expr.shift_vars threshold offset e))
  := by cases e with
  | bvar i x =>
    simp [Expr.is_value]
  | fvar x =>
    simp [Expr.is_value]
  | iso l body =>
    simp [Expr.is_value]
    intro isval threshold offset
    apply Expr.is_value_shift_vars_preservation isval
  | record r =>
    simp [Expr.is_value, Expr.shift_vars]
    apply Expr.record_is_value_shift_vars_preservation
  | function f =>
    simp [Expr.is_value, Expr.shift_vars]
  | _ =>
    simp [Expr.is_value, Expr.shift_vars]
end

mutual

  theorem Pattern.record_skip_shift_vars_preservation :
    List.is_record_value r →
    match_record r ps = none →
    ∀ (threshold offset : ℕ),
    match_record (List.record_shift_vars threshold offset r) ps = none
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    intro isval h0 threshold offset h1 m0' h2 m1' h3
    have ⟨m0,h4⟩ := Pattern.match_entry_shift_vars_reflection isval h2
    have ⟨m1,h5⟩ := Pattern.match_record_shift_vars_reflection isval h3
    apply h0 h1 _ h4 _ h5


  theorem Pattern.skip_shift_vars_preservation :
    Expr.is_value arg →
    Pattern.match arg p = none →
    ∀ threshold offset, Pattern.match (Expr.shift_vars threshold offset arg) p = none
  := by cases p with
  | var x =>
    simp [Pattern.match]
  | iso l bp =>
    cases arg with
    | iso l' body =>
      simp [Expr.is_value, Expr.shift_vars, Pattern.match]
      intro isval h0 threshold offset h1
      apply Pattern.skip_shift_vars_preservation isval (h0 h1)
    | _ =>
      simp [Expr.is_value, Expr.shift_vars, Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.is_value, Expr.shift_vars, Pattern.match]
      intro isval h0 threshold offset h2
      apply Pattern.record_skip_shift_vars_preservation isval
      apply h0
      exact Expr.record_shift_vars_keys_unique_reflection h2
    | _ =>
      simp [Expr.is_value, Expr.shift_vars, Pattern.match]
end


mutual

  theorem ParRcdStep.shift_vars_preservation
    threshold
    offset
    (step : ParRcdStep r r')
  : ParRcdStep
    (List.record_shift_vars threshold offset r)
    (List.record_shift_vars threshold offset r')
  := by cases step with
  | nil =>
    simp [List.record_shift_vars]
    exact ParRcdStep.nil
  | @cons e e' rr rr' l step_e step_rr =>
    simp [List.record_shift_vars]
    apply ParRcdStep.cons
    { apply ParStep.shift_vars_preservation _ _ step_e}
    { apply ParRcdStep.shift_vars_preservation _ _ step_rr }

  theorem ParFunStep.shift_vars_preservation
    threshold
    offset
    (step : ParFunStep f f')
  : ParFunStep
    (List.function_shift_vars threshold offset f)
    (List.function_shift_vars threshold offset f')
  := by cases step with
  | nil =>
    simp [List.function_shift_vars]
    exact ParFunStep.nil
  | @cons e e' ff ff' p step_e step_ff =>
    simp [List.function_shift_vars]
    apply ParFunStep.cons
    { apply ParStep.shift_vars_preservation _ _ step_e }
    { apply ParFunStep.shift_vars_preservation _ _ step_ff}



  theorem ParStep.shift_vars_preservation
    threshold
    offset
    (step : ParStep e e')
  : ParStep (Expr.shift_vars threshold offset e) (Expr.shift_vars threshold offset e')
  := by cases step with
  | bvar i x =>
    exact ParStep.refl (Expr.shift_vars threshold offset (Expr.bvar i x))
  | fvar x =>
    exact ParStep.refl (Expr.shift_vars threshold offset (Expr.fvar x))
  | @iso body body' l step_body =>
    simp [Expr.shift_vars]
    apply ParStep.iso
    apply ParStep.shift_vars_preservation _ _ step_body
  | @record r r' step_r =>
    simp [Expr.shift_vars]
    apply ParStep.record
    apply ParRcdStep.shift_vars_preservation _ _ step_r
  | @function f f' step_f =>
    simp [Expr.shift_vars]
    apply ParStep.function
    apply ParFunStep.shift_vars_preservation _ _ step_f
  | @app cator cator' arg arg' step_cator step_arg =>
    simp [Expr.shift_vars]
    apply ParStep.app
    { apply ParStep.shift_vars_preservation _ _ step_cator }
    { apply ParStep.shift_vars_preservation _ _ step_arg }
  | @pattern_match body body' arg arg' p m' f step_body step_arg matching' =>
    simp [Expr.shift_vars, List.function_shift_vars]

    rw [Expr.shift_vars_instantiate_zero_inside_out]
    apply ParStep.pattern_match
    { rw [←Pattern.match_count_eq matching']
      apply ParStep.shift_vars_preservation _ _ step_body
    }
    { apply ParStep.shift_vars_preservation _ _ step_arg }
    { exact Pattern.match_shift_vars_preservation matching' threshold offset }
  | @skip f f' arg arg' p body step_f step_arg isval nomatching' =>
    simp [Expr.shift_vars]
    apply ParStep.skip
    { apply ParFunStep.shift_vars_preservation _ _ step_f }
    { apply ParStep.shift_vars_preservation _ _  step_arg }
    { exact Expr.is_value_shift_vars_preservation isval threshold offset }
    { exact Pattern.skip_shift_vars_preservation isval nomatching' threshold offset }
  | @anno e e' t step_e =>
    simp [Expr.shift_vars]
    apply ParStep.anno
    apply ParStep.shift_vars_preservation _ _ step_e
  | @erase e e' t step_e =>
    simp [Expr.shift_vars]
    apply ParStep.erase
    apply ParStep.shift_vars_preservation _ _ step_e
  | @loopi body body' step_body =>
    simp [Expr.shift_vars]
    apply ParStep.loopi
    apply ParStep.shift_vars_preservation _ _ step_body
  | @recycle e e' x step_e =>
    simp [Expr.shift_vars]

    rw [Expr.shift_vars_instantiate_zero_inside_out]
    apply ParStep.recycle
    apply ParStep.shift_vars_preservation _ _ step_e
end


mutual
  theorem ParStep.shift_vars_reflection
  (step : ParStep (Expr.shift_vars threshold offset e) (Expr.shift_vars threshold offset e'))
  : ParStep e e'
  := by sorry
end


mutual

  theorem ParStep.sub_record_preservation
    x
    (step : ParStep arg arg')
    r
  : ParRcdStep (List.record_sub [(x,arg)] r) (List.record_sub [(x,arg')] r)
  := by cases r with
  | nil =>
    simp [List.record_sub]
    exact ParRcdStep.refl []
  | cons le r' =>
    have (l,e) := le
    simp [List.record_sub]
    apply ParRcdStep.cons
    { apply ParStep.sub_preservation _ step }
    { apply ParStep.sub_record_preservation _ step}

  theorem ParStep.sub_function_preservation
    x
    (step : ParStep arg arg')
    f
  : ParFunStep (List.function_sub [(x,arg)] f) (List.function_sub [(x,arg')] f)
  := by cases f with
  | nil =>
    simp [List.function_sub]
    exact ParFunStep.refl []
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_sub]
    apply ParFunStep.cons
    { by_cases h : x ∈ Pat.index_vars p
      { simp [remove_all_single_membership h]
        exact refl (Expr.sub [] e)
      }
      { simp [remove_all_single_nomem h]
        apply ParStep.sub_preservation x step e
      }
    }
    { apply ParStep.sub_function_preservation _ step }

  theorem ParStep.sub_preservation
    x
    (step : ParStep arg arg')
    e
  : ParStep (Expr.sub [(x,arg)] e) (Expr.sub [(x,arg')] e)
  := by cases e with
  | bvar i x' =>
    simp [Expr.sub]
    exact bvar i x'
  | fvar x' =>
    by_cases h0 : x' = x
    {
      simp [Expr.sub,find,h0]
      exact step
    }
    {
      have h1 : x' ∉ ListPair.dom [(x,arg)] := by
        simp [ListPair.dom] ; exact h0
      have h2 : x' ∉ ListPair.dom [(x,arg')] := by
        simp [ListPair.dom] ; exact h0
      have h3 := Expr.sub_refl h1
      have h4 := Expr.sub_refl h2
      rw [h3,h4]
      exact ParStep.refl (Expr.fvar x')
    }
  | iso l body =>
    simp [Expr.sub]
    have ih := ParStep.sub_preservation x step body
    exact ParStep.iso ih
  | record r =>
    simp [Expr.sub]
    have ih := ParStep.sub_record_preservation x step r
    exact ParStep.record ih
  | function f =>
    simp [Expr.sub]
    have ih := ParStep.sub_function_preservation x step f
    exact function ih
  | app ef ea =>
    simp [Expr.sub]
    have ih0 := ParStep.sub_preservation x step ef
    have ih1 := ParStep.sub_preservation x step ea
    exact app ih0 ih1
  | anno e t =>
    simp [Expr.sub]
    have ih := ParStep.sub_preservation x step e
    exact anno ih
  | loopi e =>
    simp [Expr.sub]
    have ih := ParStep.sub_preservation x step e
    exact loopi ih
end

mutual
  theorem ParStep.instantiate_record_preservation
    offset
    (step : ParStep arg arg')
    r
  : ParRcdStep
    (List.record_instantiate offset [arg] r)
    (List.record_instantiate offset [arg'] r)
  := by cases r with
  | nil =>
    simp [List.record_instantiate]
    exact ParRcdStep.refl []
  | cons le r' =>
    have (l,e) := le
    simp [List.record_instantiate]
    apply ParRcdStep.cons
    { apply ParStep.instantiator_preservation _ step }
    { apply ParStep.instantiate_record_preservation _ step}

  theorem ParStep.instantiate_function_preservation
    offset
    (step : ParStep arg arg')
    f
  : ParFunStep
    (List.function_instantiate offset [arg] f)
    (List.function_instantiate offset [arg'] f)
  := by cases f with
  | nil =>
    simp [List.function_instantiate]
    exact ParFunStep.refl []
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_instantiate]
    apply ParFunStep.cons
    { apply ParStep.instantiator_preservation _ step }
    { apply ParStep.instantiate_function_preservation _ step }

  theorem ParStep.instantiator_preservation
    offset
    (step : ParStep arg arg')
    e
  : ParStep (Expr.instantiate offset [arg] e) (Expr.instantiate offset [arg'] e)
  := by cases e with
  | bvar i x =>
    simp [Expr.instantiate]
    by_cases h0 : offset ≤ i
    { simp [*]
      by_cases h1 : i - offset = 0
      { simp [*] ;
        exact shift_vars_preservation 0 offset step
      }
      { simp [*] ; exact bvar (i - 1) x }
    }
    { simp [*] ; exact bvar i x }
  | fvar x =>
    simp [Expr.instantiate]
    apply ParStep.fvar x
  | iso l body =>
    simp [Expr.instantiate]
    apply ParStep.iso
    apply ParStep.instantiator_preservation _ step body
  | record r =>
    simp [Expr.instantiate]
    apply ParStep.record
    apply ParStep.instantiate_record_preservation offset step r
  | function f =>
    simp [Expr.instantiate]
    apply function
    apply ParStep.instantiate_function_preservation offset step f
  | app ef ea =>
    simp [Expr.instantiate]
    apply ParStep.app
    { apply ParStep.instantiator_preservation offset step ef }
    { apply ParStep.instantiator_preservation offset step ea }
  | anno e t =>
    simp [Expr.instantiate]
    apply ParStep.anno
    apply ParStep.instantiator_preservation offset step e
  | loopi e =>
    simp [Expr.instantiate]
    apply loopi
    apply ParStep.instantiator_preservation offset step e
end



mutual

  theorem Expr.record_shift_vars_add threshold o d r :
    List.record_shift_vars threshold (o + d) r =
    List.record_shift_vars threshold d (List.record_shift_vars threshold o r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.record_shift_vars_add }

  theorem Expr.function_shift_vars_add threshold o d f :
    List.function_shift_vars threshold (o + d) f =
    List.function_shift_vars threshold d (List.function_shift_vars threshold o f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.function_shift_vars_add }

  theorem Expr.shift_vars_add threshold o d e :
    Expr.shift_vars threshold (o + d) e =
    Expr.shift_vars threshold d (Expr.shift_vars threshold o e)
  := by cases e with
  | bvar i x =>
    simp [Expr.shift_vars]
    by_cases h0 : threshold ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : threshold ≤ i + o := by exact Nat.le_add_right_of_le h0
      simp [h1]
      exact Eq.symm (Nat.add_assoc i o d)
    }
    { simp [h0]
      simp [Expr.shift_vars]
      intro h1
      apply False.elim
      apply h0 h1
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_add

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_add

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.shift_vars_add }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add
end

mutual
  theorem ParStep.instantiate_concat_preservation :
    List.length m0 = List.length m0' →
    List.length m1 = List.length m1' →
    ParStep (Expr.instantiate offset m0 e) (Expr.instantiate offset m0' e) →
    ParStep
      (Expr.instantiate (offset + List.length m0) m1 e)
      (Expr.instantiate (offset + List.length m0') m1' e) →
    ParStep (Expr.instantiate offset (m0 ++ m1) e) (Expr.instantiate offset (m0' ++ m1') e)
  := by cases e with
  | bvar i x =>
    intro len0 len1
    by_cases hh0 : (offset + List.length m0) ≤ i
    {

      simp [Expr.instantiate]
      simp [hh0]
      have hh1 : offset + List.length m0' ≤ i := by
        exact le_of_eq_of_le (congrArg (HAdd.hAdd offset) (id (Eq.symm len0))) hh0
      simp [hh1]
      have hh2 : offset ≤ i := by exact Nat.le_of_add_right_le hh0
      simp [hh2]
      match
        h0 : m0[i - offset]?,
        h0' : m0'[i - offset]?
      with
      | some e0, some e0' =>
        simp
        intro step0
        sorry
      | some e0, none =>
        simp
        intro step0
        apply False.elim
        have h1 : i - offset < List.length m0 := by
          have ⟨h,eq⟩ := Iff.mp List.getElem?_eq_some_iff h0
          apply h

        have h2: List.length m0' ≤ i - offset:= by
          exact Iff.mp List.getElem?_eq_none_iff h0'

        rw [len0] at h1
        have ⟨h3,h4⟩ := Iff.mp Nat.lt_iff_le_and_not_ge h1
        apply h4 h2

      | none, some e0 =>
        simp
        intro step0
        apply False.elim

        have h1: List.length m0 ≤ i - offset := by
          exact Iff.mp List.getElem?_eq_none_iff h0

        have h2 : i - offset < List.length m0' := by
          have ⟨h,eq⟩ := Iff.mp List.getElem?_eq_some_iff h0'
          apply h

        rw [len0] at h1
        have ⟨h3,h4⟩ := Iff.mp Nat.lt_iff_le_and_not_ge h2
        apply h4 h1

      | none , none =>
        simp
        intro step0
        have h2: List.length m0 ≤ i - offset := by
          exact Iff.mp List.getElem?_eq_none_iff h0

        have h2': List.length m0' ≤ i - offset := by
          exact Iff.mp List.getElem?_eq_none_iff h0'

        match
          h1 : m1[i- (offset + List.length m0)]?,
          h1' : m1'[i - (offset + List.length m0')]?
        with
        | some e1, some e1' =>
          simp
          intro step1


          have h3 : ¬ i - offset < List.length m0 := by exact Iff.mpr Nat.not_lt h2
          have h3' : ¬ i - offset < List.length m0' := by exact Iff.mpr Nat.not_lt h2'

          rw [List.getElem?_append]
          rw [List.getElem?_append]

          simp [h3,h3']

          have h4 :
            i - offset - List.length m0 =
            i - (offset + List.length m0)
          := by exact Nat.sub_sub i offset (List.length m0)

          have h4' :
            i - offset - List.length m0' =
            i - (offset + List.length m0')
          := by exact Nat.sub_sub i offset (List.length m0')

          rw [h4,h4']
          simp [h1,h1']
          rw [len0] at step1

          rw [Expr.shift_vars_add] at step1
          rw [Expr.shift_vars_add] at step1

          apply ParStep.shift_vars_reflection step1

        | some e1, none =>
          simp
          intro step1

          apply False.elim
          have h3 : i - (offset + List.length m0) < List.length m1 := by
            have ⟨h,eq⟩ := Iff.mp List.getElem?_eq_some_iff h1
            apply h

          have h3': List.length m1' ≤ i- (offset + List.length m0'):= by
            exact Iff.mp List.getElem?_eq_none_iff h1'

          rw [len0,len1] at h3
          have ⟨h4,h5⟩ := Iff.mp Nat.lt_iff_le_and_not_ge h3
          apply h5 h3'

        | none , some e1 =>
          simp
          intro step1

          apply False.elim

          have h3: List.length m1 ≤ i - (offset + List.length m0) := by
            exact Iff.mp List.getElem?_eq_none_iff h1

          have h3' : i - (offset + List.length m0') < List.length m1' := by
            have ⟨h,eq⟩ := Iff.mp List.getElem?_eq_some_iff h1'
            apply h


          rw [len0,len1] at h3
          have ⟨h4,h5⟩ := Iff.mp Nat.lt_iff_le_and_not_ge h3'
          apply h5 h3

        | none , none =>
          simp
          intro step1

          have h3: List.length m1 ≤ i - (offset + List.length m0) := by
            exact Iff.mp List.getElem?_eq_none_iff h1

          have h3': List.length m1' ≤ i - (offset + List.length m0') := by
            exact Iff.mp List.getElem?_eq_none_iff h1'

          rw [Nat.sub_add_eq] at h3
          rw [Nat.sub_add_eq] at h3'

          have h4  : List.length m0 + List.length m1 ≤ i - offset := by
            exact Iff.mp (Nat.le_sub_iff_add_le' h2) h3

          have h4' : List.length m0' + List.length m1'  ≤ i - offset := by
            exact Iff.mp (Nat.le_sub_iff_add_le' h2') h3'

          rw [←List.length_append] at h4
          rw [←List.length_append] at h4'

          have h6 : (m0 ++ m1)[i - offset]? = none := by
            exact Iff.mpr List.getElem?_eq_none_iff h4

          have h6' : (m0' ++ m1')[i - offset]? = none := by
            exact Iff.mpr List.getElem?_eq_none_iff h4'

          simp [h6,h6']
          rw [len0,len1]
          apply ParStep.refl
    }
    {
      simp [Expr.instantiate]
      simp [hh0]
      by_cases hh1 : offset ≤ i
      { simp [hh1]
        sorry
      }
      { simp [hh1]
        intro h0 h1
        apply ParStep.refl
      }
    }


  | _ => sorry
end

mutual

  theorem ParRcdStep.entry_instantiator
    (step : ParRcdStep r r')
    (matching : Pattern.match_entry l p r = some m)
    (matching' : Pattern.match_entry l p r' = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m' e)
  := by cases step with
  | nil =>
    simp [Pattern.match_entry] at matching
  | @cons ee ee' rr rr' l' step_ee step_rr =>
    simp [Pattern.match_entry] at matching
    simp [Pattern.match_entry] at matching'
    by_cases h0 : l' = l
    {
      simp [*] at matching
      simp [*] at matching'

      apply ParStep.instantiator step_ee matching matching'
    }
    {
      simp [*] at matching
      simp [*] at matching'
      apply ParRcdStep.entry_instantiator step_rr matching matching'
    }

  theorem ParRcdStep.instantiator
    (step : ParRcdStep r r')
    (matching : Pattern.match_record r ps = some m)
    (matching' : Pattern.match_record r' ps = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m'  e)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record] at matching
    simp [Pattern.match_record] at matching'
    rw [matching, matching']
    exact ParStep.refl (Expr.instantiate offset [] e)
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record] at matching
    simp [Pattern.match_record] at matching'

    have ⟨h1,h2⟩ := matching
    have ⟨h3,h4⟩ := matching'
    clear matching matching'

    match
      h5 : (Pattern.match_entry l p r),
      h6 : (Pattern.match_record r ps'),
      h7 : (Pattern.match_entry l p r'),
      h8 : (Pattern.match_record r' ps')
    with
    | some m0, some m1, some m2, some m3 =>
      simp [*] at h2
      simp [*] at h4
      rw [←h2,←h4]

      have h9 : List.length m0 = List.length m2 := by
        rw [←Pattern.match_entry_count_eq]
        { apply Pattern.match_entry_count_eq h7 }
        { apply h5 }

      have h10 : List.length m1 = List.length m3 := by
        rw [←Pattern.match_record_count_eq]
        { apply Pattern.match_record_count_eq h8 }
        { exact h6 }

      apply ParStep.instantiate_concat_preservation h9 h10
      { apply ParRcdStep.entry_instantiator step h5 h7 }
      {
        rw [← Pattern.match_entry_count_eq h5]
        rw [← Pattern.match_entry_count_eq h7]
        apply ParRcdStep.instantiator step h6 h8
      }

    | none,_,_,_ =>
      simp [*] at h2
    | _,none,_,_ =>
      simp [*] at h2
    | _,_,none,_ =>
      simp [*] at h4
    | _,_,_,none =>
      simp [*] at h4

  theorem ParStep.instantiator
    (step : ParStep arg arg')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m' e)
  := by cases p with
  | var x =>
    simp [Pattern.match] at matching
    simp [Pattern.match] at matching'
    rw [←matching, ←matching']
    clear matching matching'

    apply ParStep.instantiator_preservation _ step
  | @iso l p_body =>
    cases step with
    | bvar i x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.instantiate offset m e)
    | fvar x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.instantiate offset m e)
    | @iso body body' l' step_body =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      have ⟨h0,h1⟩ := matching ; clear matching
      have ⟨h2,h3⟩ := matching' ; clear matching'
      apply ParStep.instantiator step_body h1 h3
    | _ =>
      simp [Pattern.match] at matching
  | @record ps =>
    cases step with
    | bvar i x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.instantiate offset m e)
    | fvar x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.instantiate offset m e)
    | @record r r' step_r =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      have ⟨h0,h1⟩ := matching
      have ⟨h2,h3⟩ := matching'
      apply ParRcdStep.instantiator step_r h1 h3
    | _ =>
      simp [Pattern.match] at matching
end


mutual
  theorem Pattern.match_entry_instantiate_preservation :
    Pattern.match_entry l p r = some m →
    ∀ depth d,
    Pattern.match_entry l p (List.record_instantiate depth d r)
    =
    some (Expr.list_instantiate depth d m)
  := by cases r with
  | nil =>
    simp [Pattern.match_entry]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.record_instantiate, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_instantiate_preservation h1
    }
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_entry_instantiate_preservation h1
    }

  theorem Pattern.match_record_instantiate_preservation :
    Pattern.match_record r ps = some m →
    ∀ depth d,
    Pattern.match_record (List.record_instantiate depth d r) ps
    =
    some (Expr.list_instantiate depth d m)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
    intro h0
    simp [*, Expr.list_instantiate]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (Pattern.match_entry l p r),
      h1 : (Pattern.match_record r ps')
    with
    | some m0, some m1 =>
      simp
      intro h3 h4 threshold offset
      simp [h3]

      have ih0 := Pattern.match_entry_instantiate_preservation h0 threshold offset
      have ih1 := Pattern.match_record_instantiate_preservation h1 threshold offset
      simp [ih0,ih1,←h4]
      exact Expr.list_instantiate_concat
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_instantiate_preservation :
    Pattern.match arg p = some m →
    ∀ depth d,
    Pattern.match (Expr.instantiate depth d arg) p
    =
    some (Expr.list_instantiate depth d m)
  := by cases p with
  | var x  =>
    simp [Pattern.match]
    intro h0
    simp [←h0]
    simp [Expr.list_instantiate]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Pattern.match, Expr.instantiate]
      intro h0 h1 threshold offset
      simp [*]
      apply Pattern.match_instantiate_preservation h1 threshold offset
    | _ =>
      simp [Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Pattern.match, Expr.instantiate]
      intro h0 h1 threshold offset
      apply And.intro
      { exact Expr.record_instantiate_keys_unique_preservation h0 }
      { apply Pattern.match_record_instantiate_preservation h1}
    | _ =>
      simp [Pattern.match]
end


mutual
  theorem Pattern.match_entry_instantiate_reflection :
    List.is_record_value r →
    Pattern.match_entry l p (List.record_instantiate depth d r) = some m' →
    ∃ m, Pattern.match_entry l p r = some m
  := by cases r with
  | nil =>
    simp [List.is_record_value, Pattern.match_entry, List.record_instantiate]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.is_record_value, List.record_instantiate, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_instantiate_reflection h2
    }
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_entry_instantiate_reflection h3
    }

  theorem Pattern.match_record_instantiate_reflection :
    List.is_record_value r →
    Pattern.match_record (List.record_instantiate depth d r) ps = some m' →
    ∃ m , Pattern.match_record r ps = some m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (match_entry l p (List.record_instantiate depth d r)),
      h1 : (Pattern.match_record (List.record_instantiate depth d r) ps')
    with
    | some m0', some m1' =>
      simp
      intro isval h3 h4
      simp [h3]

      have ⟨m0,ih0⟩ := Pattern.match_entry_instantiate_reflection isval h0
      have ⟨m1,ih1⟩ := Pattern.match_record_instantiate_reflection isval h1
      simp [ih0,ih1]
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_instantiate_reflection :
    Expr.is_value arg →
    Pattern.match (Expr.instantiate offset d arg) p = some m' →
    ∃ m, Pattern.match arg p = some m
  := by cases p with
  | var x  =>
    simp [Pattern.match]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Expr.is_value, Pattern.match, Expr.instantiate]
      intro isval h0 h1
      simp [*]
      apply Pattern.match_instantiate_reflection isval h1
    | _ =>
      simp [Expr.is_value, Pattern.match, Expr.instantiate]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.is_value, Pattern.match, Expr.instantiate]
      intro ival h0 h1
      apply And.intro
      { exact Expr.record_instantiate_keys_unique_reflection h0 }
      { apply Pattern.match_record_instantiate_reflection ival h1 }
    | _ =>
      simp [Expr.is_value, Pattern.match, Expr.instantiate]
end


mutual

  theorem Pattern.record_skip_instantiate_preservation :
    List.is_record_value r →
    match_record r ps = none →
    ∀ depth d,
    match_record (List.record_instantiate depth d r) ps = none
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    intro isval h0 depth d h1 m0' h2 m1' h3
    have ⟨m0,h4⟩ := Pattern.match_entry_instantiate_reflection isval h2
    have ⟨m1,h5⟩ := Pattern.match_record_instantiate_reflection isval h3
    apply h0 h1 _ h4 _ h5


  theorem Pattern.skip_instantiate_preservation :
    Expr.is_value arg →
    Pattern.match arg p = none →
    ∀ depth d, Pattern.match (Expr.instantiate depth d arg) p = none
  := by cases p with
  | var x =>
    simp [Pattern.match]
  | iso l bp =>
    cases arg with
    | iso l' body =>
      simp [Expr.is_value, Expr.instantiate, Pattern.match]
      intro isval h0 depth d h1
      apply Pattern.skip_instantiate_preservation isval (h0 h1)
    | _ =>
      simp [Expr.is_value, Expr.instantiate, Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.is_value, Expr.instantiate, Pattern.match]
      intro isval h0 depth d h2
      apply Pattern.record_skip_instantiate_preservation isval
      apply h0
      exact Expr.record_instantiate_keys_unique_reflection h2
    | _ =>
      simp [Expr.is_value, Expr.instantiate, Pattern.match]
end

mutual

  theorem Expr.record_is_value_instantiate_preservation :
    List.is_record_value r = true →
    ∀ depth d, List.is_record_value (List.record_instantiate depth d r) = true
  := by cases r with
  | nil =>
    simp [List.is_record_value, List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [List.is_record_value, List.record_instantiate]
    intro h0 h1 h2 depth d
    apply And.intro
    {
      apply And.intro
      { exact record_instantiate_keys_is_fresh_key_preservation h0 }
      { apply Expr.is_value_instantiate_preservation h1 }
    }
    { apply Expr.record_is_value_instantiate_preservation h2 }


  theorem Expr.is_value_instantiate_preservation :
    (Expr.is_value e) →
    ∀ depth d, (Expr.is_value (Expr.instantiate depth d e))
  := by cases e with
  | bvar i x =>
    simp [Expr.is_value]
  | fvar x =>
    simp [Expr.is_value]
  | iso l body =>
    simp [Expr.is_value]
    intro isval depth d
    apply Expr.is_value_instantiate_preservation isval
  | record r =>
    simp [Expr.is_value, Expr.instantiate]
    apply Expr.record_is_value_instantiate_preservation
  | function f =>
    simp [Expr.is_value, Expr.instantiate]
  | _ =>
    simp [Expr.is_value, Expr.instantiate]
end



mutual
  theorem Expr.record_shift_vars_level_drop level z depth offset r :
    List.record_shift_vars (level + z) depth (List.record_shift_vars z (offset + level) r) =
    List.record_shift_vars z depth (List.record_shift_vars z (offset + level) r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_level_drop }
    { apply Expr.record_shift_vars_level_drop }

  theorem Expr.function_shift_vars_level_drop level z depth offset f :
    List.function_shift_vars (level + z) depth (List.function_shift_vars z (offset + level) f) =
    List.function_shift_vars z depth (List.function_shift_vars z (offset + level) f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars]
    apply And.intro
    {
      have h0 : level + z + Pat.count_vars p = level + (z + Pat.count_vars p) := by
        exact Nat.add_assoc level z (Pat.count_vars p)
      rw [h0]
      apply Expr.shift_vars_level_drop
    }
    { apply Expr.function_shift_vars_level_drop }


  theorem Expr.shift_vars_level_drop level z depth offset e :
    Expr.shift_vars (level + z) depth (Expr.shift_vars z (offset + level) e) =
    Expr.shift_vars z depth (Expr.shift_vars z (offset + level) e)
  := by cases e with
  | bvar i x =>
    simp [Expr.shift_vars]
    by_cases h0 : z ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : z ≤ i + (offset + level) := by exact Nat.le_add_right_of_le h0
      simp [h1]
      intro h2

      apply False.elim

      have h3 : i + (offset + level) = i + offset + level := by
        exact Eq.symm (Nat.add_assoc i offset level)
      rw [h3] at h2

      have h4 : i + offset + level = level + (i + offset) := by
        exact Eq.symm (Nat.add_comm level (i + offset))
      rw [h4] at h2

      have h5 : i + offset < z := by exact Nat.lt_of_add_lt_add_left h2

      have  h6 : i < z := by exact Nat.lt_of_add_right_lt h5

      have h7 : ¬ z ≤ i := by exact Nat.not_le_of_lt h6

      apply h7 h0

    }
    { simp [h0]
      simp [Expr.shift_vars]
      simp [h0]
      intro h1
      apply False.elim
      have h2 : z ≤ i := by exact Nat.le_of_add_left_le h1
      apply h0 h2
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_level_drop

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_level_drop

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_level_drop }
    { apply Expr.shift_vars_level_drop }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop
end

theorem Expr.shift_vars_level_drop_to_zero :
  Expr.shift_vars level depth (Expr.shift_vars 0 (offset + level) e) =
  Expr.shift_vars 0 depth (Expr.shift_vars 0 (offset + level) e)
:= by
  have h0 : level = level + 0 := rfl
  rw [h0]
  rw [←Nat.add_assoc]
  exact shift_vars_level_drop level 0 depth offset e

mutual

  theorem Expr.record_instantiate_shift_vars_inside_out offset depth level m r :
    List.record_instantiate (offset + depth + level) m (List.record_shift_vars level depth r)
    =
    List.record_shift_vars level depth (List.record_instantiate (offset + level) m r)
  := by cases r with
  | nil =>
    simp [List.record_instantiate, List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_instantiate,List.record_shift_vars]
    apply And.intro
    { apply Expr.instantiate_shift_vars_inside_out
    }
    { apply Expr.record_instantiate_shift_vars_inside_out }


  theorem Expr.function_instantiate_shift_vars_inside_out offset depth level m f :
    List.function_instantiate (offset + depth + level) m (List.function_shift_vars level depth f)
    =
    List.function_shift_vars level depth (List.function_instantiate (offset + level) m f)
  := by cases f with
  | nil =>
    simp [List.function_instantiate, List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_instantiate,List.function_shift_vars]
    apply And.intro
    {

      have h0 :
        offset + depth + level + Pat.count_vars p
        =
        offset + depth + (level + Pat.count_vars p)
      := by exact Nat.add_assoc (offset + depth) level (Pat.count_vars p)
      rw [h0]

      have h1 :
        offset + level + Pat.count_vars p
        =
        offset + (level + Pat.count_vars p)
      := by exact Nat.add_assoc offset level (Pat.count_vars p)
      rw [h1]



      apply Expr.instantiate_shift_vars_inside_out
    }
    { apply Expr.function_instantiate_shift_vars_inside_out }



  theorem Expr.instantiate_shift_vars_inside_out offset depth level m e :
    Expr.instantiate (offset + depth + level) m (Expr.shift_vars level depth e)
    =
    Expr.shift_vars level depth (Expr.instantiate (offset + level) m e)
  := by cases e with
  | bvar i x =>
    simp [Expr.shift_vars, Expr.instantiate]
    by_cases h0 : level ≤ i
    { simp [h0]
      simp [Expr.instantiate]
      by_cases h1 : offset + depth + level ≤ i + depth
      { simp [h1]

        have h2 :
          offset + depth + level - depth ≤ i
        := by exact Nat.sub_le_of_le_add h1

        have h3 :
          offset + depth + level =
          offset + level + depth
        := by exact Nat.add_right_comm offset depth level
        rw [h3] at h2

        have h4 :
          offset + level + depth - depth =
          offset + level
        := by exact Nat.add_sub_self_right (offset + level) depth

        rw [h4] at h2
        simp [h2]

        rw [h3]
        have h5 :
          i + depth - (offset + level + depth) =
          i - (offset + level)
        := by exact Nat.add_sub_add_right i depth (offset + level)
        simp [h5]

        cases h6 : m[i - (offset + level)]? with
        | some e =>
          simp
          rw [Expr.shift_vars_level_drop_to_zero]
          apply Expr.shift_vars_add
        | none =>
          simp
          simp [Expr.shift_vars]
          have h7 : List.length m ≤ i - (offset + level) := by
            exact Iff.mp List.getElem?_eq_none_iff h6


          have h8 : List.length m + (offset + level) ≤ i := by
            exact Nat.add_le_of_le_sub h2 h7

          have h9 :
              (offset + level) =
              (level + offset)
          := by exact Nat.add_comm offset level
          rw [h9] at  h8

          rw [←Nat.add_assoc] at h8

          have h10 : List.length m + level ≤ i := by
            exact Nat.le_of_add_right_le h8

          have h11 : level ≤ i -  List.length m := by
            exact Nat.le_sub_of_add_le' h10

          simp [h11]

          have h12 : List.length m ≤ i := by exact Nat.le_of_add_right_le h10

          exact Nat.sub_add_comm h12

      }
      { simp [h1]
        have h2 : offset + depth + level =  offset + level + depth := by
          exact Nat.add_right_comm offset depth level
        rw [h2] at  h1

        have h3 : ¬ offset + level ≤ i := by
          intro h
          apply h1
          exact Nat.add_le_add_right h depth

        simp [h3]
        simp [Expr.shift_vars]
        intro h4

        have h5 : ¬ level ≤ i := by exact Nat.not_le_of_lt h4
        apply False.elim
        apply h5 h0

      }
    }
    { simp [h0]
      simp [Expr.instantiate]

      have h1 : ¬ offset + level ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]
      simp [Expr.shift_vars]
      simp [h0]
      intro h2
      apply False.elim
      have  h3 : offset + depth + level = offset + level + depth := by
        exact Nat.add_right_comm offset depth level
      rw [h3] at h2
      have h4 : offset + level ≤ i := by exact Nat.le_of_add_right_le h2
      apply h1 h4
    }
  | fvar x =>
    simp [Expr.instantiate, Expr.shift_vars]
  | iso l body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out
  | record r =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.record_instantiate_shift_vars_inside_out

  | function f =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.function_instantiate_shift_vars_inside_out

  | app ef ea =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply And.intro
    { apply Expr.instantiate_shift_vars_inside_out }
    { apply Expr.instantiate_shift_vars_inside_out }

  | anno body t =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out

  | loopi body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out

end


theorem Expr.instantiate_shift_vars_zero_inside_out offset depth m e :
  Expr.instantiate (offset + depth) m (Expr.shift_vars 0 depth e) =
  Expr.shift_vars 0 depth (Expr.instantiate offset m e)
:= by
  have h0 : offset + depth = offset + depth + 0 := by exact rfl
  have h1 : offset = offset + 0 := by exact rfl
  rw [h0,h1]
  exact instantiate_shift_vars_inside_out (offset + 0) depth 0 m e


mutual

  theorem Expr.record_instantiate_miss depth level m offset r :
    List.record_instantiate (depth + level) m (List.record_shift_vars level (offset + depth + List.length m) r) =
    List.record_shift_vars level (offset + depth) r
  := by cases r with
  | nil =>
    simp [List.record_shift_vars, List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars, List.record_instantiate]
    apply And.intro
    { apply Expr.instantiate_miss
    }
    { apply Expr.record_instantiate_miss }

  theorem Expr.function_instantiate_miss depth level m offset f :
    List.function_instantiate (depth + level) m (List.function_shift_vars level (offset + depth + List.length m) f) =
    List.function_shift_vars level (offset + depth) f
  := by cases f with
  | nil =>
    simp [List.function_shift_vars, List.function_instantiate]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars, List.function_instantiate]
    apply And.intro
    {

      have h0 :
        depth + level + Pat.count_vars p
        =
        depth + (level + Pat.count_vars p)
      := by exact Nat.add_assoc depth level (Pat.count_vars p)
      rw [h0] ; clear h0

      apply Expr.instantiate_miss
    }
    { apply Expr.function_instantiate_miss }

  theorem Expr.instantiate_miss depth level m offset e :
    Expr.instantiate (depth + level) m (Expr.shift_vars level (offset + depth + List.length m) e)
    =
    (Expr.shift_vars level (offset + depth) e)
  := by cases e with
  | bvar i x =>
    simp [Expr.shift_vars]
    by_cases h0 : level ≤ i
    { simp [h0]
      simp [Expr.instantiate]

      have h1 : depth + level ≤ depth + i := by exact Iff.mpr Nat.add_le_add_iff_left h0
      have h2 : depth + level ≤ depth + i + (offset + List.length m) := by
        exact Nat.le_add_right_of_le h1

      have h3 : depth + i = i + depth := by exact Nat.add_comm depth i

      rw [h3] at h2

      have h4 :
        i + depth + (offset + List.length m) =
        i + (depth + (offset + List.length m))
      := by exact Nat.add_assoc i depth (offset + List.length m)

      rw [h4] at h2

      have h5 :
        (depth + (offset + List.length m)) =
        (depth + offset + List.length m)
      := by exact Eq.symm (Nat.add_assoc depth offset (List.length m))

      rw [h5] at h2
      have h6 :
        depth + offset =
        offset + depth
      := by exact Nat.add_comm depth offset
      rw [h6] at h2
      simp [h2]

      have h7 : List.length m ≤  List.length m + (i + (offset + depth) - (depth + level))  := by
        exact Nat.le_add_right (List.length m) (i + (offset + depth) - (depth + level))

      have h8 : (depth + level) ≤ i + depth := by exact le_of_le_of_eq h1 h3
      have h9 : (depth + level) ≤ i + depth + offset := by exact Nat.le_add_right_of_le h8


      rw [Nat.add_assoc] at h9

      have h10 :
         depth + offset = offset + depth
      := by exact h6

      have h11 : (depth + level) ≤ i + (offset + depth) := by
        exact le_of_le_of_eq h9 (congrArg (HAdd.hAdd i) h6)

      have h12 :
        List.length m + (i + (offset + depth) - (depth + level))
        =
        List.length m + (i + (offset + depth)) - (depth + level)
      := by exact Eq.symm (Nat.add_sub_assoc h11 (List.length m))

      rw [h12] at h7


      have h13 :
        List.length m + (i + (offset + depth)) =
        i + (List.length m + (offset + depth))
      := by exact Nat.add_left_comm (List.length m) i (offset + depth)
      rw [h13] at h7

      have h14 :
        List.length m + (offset + depth) =
        offset + depth + List.length m
      := by exact Nat.add_comm (List.length m) (offset + depth)

      rw [h14] at h7

      have h15 : m[i + (offset + depth + List.length m) - (depth + level)]? = none := by
        apply List.getElem?_eq_none h7

      simp [h15]

      have h17 :
        List.length m ≤ offset + depth + List.length m
      := by exact Nat.le_add_left (List.length m) (offset + depth)

      have h18 :
        i + (offset + depth + List.length m) - List.length m =
        i + ((offset + depth + List.length m) - List.length m)
      := by exact Nat.add_sub_assoc h17 i

      simp [h18]
    }
    { simp [h0]
      simp [Expr.instantiate]
      intro h1
      apply False.elim
      have h2 : level ≤ i := by exact Nat.le_of_add_left_le h1
      apply h0 h2
    }

  | fvar x =>
    simp [Expr.instantiate, Expr.shift_vars]
  | iso l body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss
  | record r =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.record_instantiate_miss

  | function f =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.function_instantiate_miss

  | app ef ea =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply And.intro
    { apply Expr.instantiate_miss }
    { apply Expr.instantiate_miss }

  | anno body t =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss

  | loopi body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss

end

theorem Expr.instantiate_miss_zero depth m offset e :
  Expr.instantiate depth m (Expr.shift_vars 0 (offset + depth + List.length m) e)
  =
  (Expr.shift_vars 0 (offset + depth) e)
:= by
  have h0 : depth = depth + 0 := rfl
  rw [h0]
  exact instantiate_miss depth 0 m offset e

mutual

  theorem  Expr.record_instantiate_inside_out offset depth ma mb r :
    (List.record_instantiate (offset + depth) ma (List.record_instantiate depth mb r)) =
    (List.record_instantiate depth
      (Expr.list_instantiate offset ma mb)
      (List.record_instantiate (offset + List.length mb + depth) ma r)
    )
  := by cases r with
  | nil =>
    simp [List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_instantiate]
    apply And.intro
    { apply Expr.instantiate_inside_out }
    { apply Expr.record_instantiate_inside_out }

  theorem  Expr.function_instantiate_inside_out offset depth ma mb f :
    (List.function_instantiate (offset + depth) ma (List.function_instantiate depth mb f)) =
    (List.function_instantiate depth
      (Expr.list_instantiate offset ma mb)
      (List.function_instantiate (offset + List.length mb + depth) ma f)
    )
  := by cases f with
  | nil =>
    simp [List.function_instantiate]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_instantiate]
    apply And.intro
    {

      have h0 :
        offset + depth + Pat.count_vars p =
        offset + (depth + Pat.count_vars p)
      := by exact Nat.add_assoc offset depth (Pat.count_vars p)
      rw [h0]

      have h1 :
        offset + List.length mb + depth + Pat.count_vars p =
        offset + List.length mb + (depth + Pat.count_vars p)
      := by exact Nat.add_assoc (offset + List.length mb) depth (Pat.count_vars p)
      rw [h1]

      apply Expr.instantiate_inside_out
    }
    { apply Expr.function_instantiate_inside_out }

  theorem  Expr.instantiate_inside_out offset depth ma mb e:
    (Expr.instantiate (offset + depth) ma (Expr.instantiate depth mb e)) =
    (Expr.instantiate depth
      (Expr.list_instantiate offset ma mb)
      (Expr.instantiate (offset + List.length mb + depth) ma e)
    )
  := by cases e with
  | bvar i x =>
    simp [Expr.instantiate]

    by_cases h0 : offset + List.length mb + depth ≤ i
    { simp [h0]

      have h1 : depth ≤ i := by exact Nat.le_of_add_left_le h0
      simp [h1]

      have h2 :
        offset + List.length mb + depth =  offset + (List.length mb + depth)
      := by exact
        Nat.add_assoc offset (List.length mb) depth

      rw [h2] at h0
      have h4 : List.length mb + depth ≤ i := by exact Nat.le_of_add_left_le h0
      have h5 : List.length mb ≤ i - depth := by exact Nat.le_sub_of_add_le h4
      have h6 : mb[i - depth]? = none := by exact Iff.mpr List.getElem?_eq_none_iff h5
      simp [h6]
      simp [Expr.instantiate]

      rw [←h2] at h0
      have h9 : offset + List.length mb + depth = offset + depth + List.length mb := by
        exact Nat.add_right_comm offset (List.length mb) depth

      rw [h9] at h0

      have h10 : offset + depth ≤ i - List.length mb := by exact Nat.le_sub_of_add_le h0
      simp [h10]

      rw [Nat.sub_add_eq]
      rw [Nat.sub_add_eq]
      rw [Nat.sub_add_eq]

      have h11 : i - List.length mb - offset = i - offset - List.length mb := by
        exact Nat.sub_right_comm i (List.length mb) offset

      rw [h11]

      cases h12 : ma[i - offset - List.length mb - depth]? with
      | some ea =>
        simp
        rw [h9]
        rw [←Expr.list_instantiate_length_eq]
        rw [Expr.instantiate_miss_zero]

      | none =>
        simp
        have h13 : List.length ma ≤ i - offset - List.length mb - depth
        := by exact Iff.mp List.getElem?_eq_none_iff h12

        rw [←Nat.sub_add_eq] at h13
        rw [←Nat.sub_add_eq] at h13
        rw [←h2] at h13

        have h14 :
          offset + List.length mb + depth
          =
          offset + depth + List.length mb
        := by exact h9
        rw [h14] at h13

        simp [Expr.instantiate]

        have h15 : List.length ma + (offset + depth + List.length mb) ≤ i := by
          exact Nat.add_le_of_le_sub h0 h13

        have h17 : offset + depth = depth + offset := by
          exact Nat.add_comm offset depth

        rw [h17] at h15

        have h18 : depth + offset + List.length mb
          = depth + (offset + List.length mb)
        := by exact Nat.add_assoc depth offset (List.length mb)
        rw [h18] at h15

        simp [←Nat.add_assoc] at h15
        have h19 : List.length ma + depth + offset ≤ i := by
          exact Nat.le_of_add_right_le h15

        have h20 : List.length ma + depth ≤ i := by
          exact Nat.le_of_add_right_le h19


        have h21 : depth ≤ i - List.length ma := by
          exact Nat.le_sub_of_add_le' h20

        simp [h21]

        rw [Expr.list_instantiate_length_eq]

        have h22 :
          List.length ma + depth + offset + List.length mb =
          List.length ma + depth + List.length mb  + offset
        := by exact Nat.add_right_comm (List.length ma + depth) offset (List.length mb)

        rw [h22] at h15

        have h23 : List.length ma + depth + List.length mb ≤ i := by
          exact Nat.le_of_add_right_le h15

        rw [Nat.add_assoc] at h23

        have h24 : depth + List.length mb ≤ i - List.length ma := by
          exact Nat.le_sub_of_add_le' h23

        have h25 : List.length mb ≤ i - List.length ma - depth := by
          exact Iff.mpr (Nat.le_sub_iff_add_le' h21) h24

        have h26 : mb[i - List.length ma - depth]? = none := by
          exact Iff.mpr List.getElem?_eq_none_iff h25

        have h27 : (Expr.list_instantiate offset ma mb)[i - List.length ma - depth]? = none := by
          exact Expr.list_instantiate_get_none_preservation offset ma (i - List.length ma - depth) h26

        simp [h27]
        exact Nat.sub_right_comm i (List.length mb) (List.length ma)

    }
    { simp [h0]
      simp [Expr.instantiate]
      by_cases h1 : depth ≤ i
      { simp [h1]

        cases h2 : mb[i - depth]? with
        | some eb =>
          simp
          have h3 := Expr.list_instantiate_get_some_preservation offset ma (i - depth) h2
          simp [h3]
          apply Expr.instantiate_shift_vars_zero_inside_out
        | none =>
          simp
          have h3 := Expr.list_instantiate_get_none_preservation offset ma (i - depth) h2
          simp [h3]

          rw [Expr.list_instantiate_length_eq]
          simp [Expr.instantiate]
          intro h4
          apply False.elim
          apply h0 ; clear h0

          have h5 : List.length mb ≤ i - depth := by
            exact Iff.mp List.getElem?_eq_none_iff h2
          have h6 : List.length mb + depth ≤ i := by exact Nat.add_le_of_le_sub h1 h5

          have h7 : List.length mb ≤ i := by exact Nat.le_of_add_right_le h6

          have h8 : offset + depth + List.length mb ≤ i := by
            exact Nat.add_le_of_le_sub h7 h4

          have h9 :
            offset + depth + List.length mb =
            offset + List.length mb  + depth
          := by exact Nat.add_right_comm offset depth (List.length mb)

          exact le_of_eq_of_le (Eq.symm h9) h8
      }
      { simp [h1]
        simp [Expr.instantiate]
        intro h2
        apply False.elim
        apply h1
        exact Nat.le_of_add_left_le h2
      }
    }
  | fvar x =>
    simp [Expr.instantiate]
  | iso l body =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out
  | record r =>
    simp [Expr.instantiate]
    apply Expr.record_instantiate_inside_out

  | function f =>
    simp [Expr.instantiate]
    apply Expr.function_instantiate_inside_out

  | app ef ea =>
    simp [Expr.instantiate]
    apply And.intro
    { apply Expr.instantiate_inside_out }
    { apply Expr.instantiate_inside_out }

  | anno body t =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out

  | loopi body =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out
end

theorem  Expr.instantiate_zero_inside_out offset ma mb e:
  (Expr.instantiate offset ma (Expr.instantiate 0 mb e)) =
  (Expr.instantiate 0
    (Expr.list_instantiate offset ma mb)
    (Expr.instantiate (offset + List.length mb) ma e)
  )
:= by
  have h0 : offset = offset + 0 := by rfl
  rw [h0]
  apply Expr.instantiate_inside_out

mutual

  theorem ParRcdStep.instantiate
    (step_arg : ParStep arg arg')
    (step_body : ParRcdStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
    offset
  : ParRcdStep
    (List.record_instantiate offset m body)
    (List.record_instantiate offset m' body')
  := by cases step_body with
  | nil =>
    exact ParRcdStep.refl (List.record_instantiate offset m [])
  | @cons e e' r r' l step_e step_r =>
    simp [List.record_instantiate]
    apply ParRcdStep.cons
    { apply ParStep.instantiate step_arg step_e matching matching'}
    { apply ParRcdStep.instantiate step_arg step_r matching matching' }

  theorem ParFunStep.instantiate
    (step_arg : ParStep arg arg')
    (step_body : ParFunStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
    offset
  : ParFunStep
    (List.function_instantiate offset m body)
    (List.function_instantiate offset m' body')
  := by cases step_body with
  | nil =>
    exact ParFunStep.refl (List.function_instantiate offset m [])
  | @cons e e' f f' p' step_e step_f =>
    simp [List.function_instantiate]
    apply ParFunStep.cons
    { apply ParStep.instantiate step_arg step_e matching matching' }
    { apply ParFunStep.instantiate step_arg step_f matching matching' }

  theorem ParStep.instantiate
    (step_arg : ParStep arg arg')
    (step_body : ParStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
    offset
  : ParStep (Expr.instantiate offset m body) (Expr.instantiate offset m' body')
  := by cases step_body with
  | bvar i x =>
    exact ParStep.instantiator step_arg matching matching' offset (Expr.bvar i x)
  | fvar x =>
    exact ParStep.instantiator step_arg matching matching' offset (Expr.fvar x)
  | @iso b b' l step_b =>
    simp [Expr.instantiate]
    apply ParStep.iso
    apply ParStep.instantiate step_arg step_b matching matching'

  | @record r r' step_r =>
    simp [Expr.instantiate]
    apply ParStep.record
    apply ParRcdStep.instantiate step_arg step_r matching matching'

  | @function f f' step_f =>
    simp [Expr.instantiate]
    apply ParStep.function
    apply ParFunStep.instantiate step_arg step_f matching matching'

  | @app cator cator' aa aa' step_cator step_aa =>
    simp [Expr.instantiate]
    apply ParStep.app
    { apply ParStep.instantiate step_arg step_cator matching matching' }
    { apply ParStep.instantiate step_arg step_aa matching matching' }

  | @pattern_match body body' aa aa' pp mm' f step_body step_aa matching'' =>
    simp [Expr.instantiate, List.function_instantiate]
    rw [Expr.instantiate_zero_inside_out]
    rw [← Pattern.match_count_eq]
    apply ParStep.pattern_match
    { apply ParStep.instantiate step_arg step_body matching matching' }
    { apply ParStep.instantiate step_arg step_aa matching matching' }
    { apply Pattern.match_instantiate_preservation matching'' offset m' }
    { exact matching'' }

  | @skip f f' aa aa' pp bb step_f step_aa isval nomatching  =>
    simp [Expr.instantiate, List.function_instantiate]
    apply ParStep.skip
    { apply ParFunStep.instantiate step_arg step_f matching matching' }
    { apply ParStep.instantiate step_arg step_aa matching matching'}
    { apply Expr.is_value_instantiate_preservation isval }
    { apply Pattern.skip_instantiate_preservation isval nomatching }
  | @anno e e' t step_e =>
    simp [Expr.instantiate]
    apply ParStep.anno
    apply ParStep.instantiate step_arg step_e matching matching'
  | @erase body body' t step_body =>
    simp [Expr.instantiate]
    apply ParStep.erase
    apply ParStep.instantiate step_arg step_body matching matching'
  | @loopi body body' step_body =>
    simp [Expr.instantiate]
    apply ParStep.loopi
    apply ParStep.instantiate step_arg step_body matching matching'
  | @recycle e e' x step_e =>
    simp [Expr.instantiate, List.function_instantiate]
    rw [Expr.instantiate_zero_inside_out]
    apply ParStep.recycle
    apply ParStep.instantiate step_arg step_e matching matching'

end


set_option maxHeartbeats 1000000 in
mutual

  theorem ParRcdStep.diamond
    (step_a : ParRcdStep r ra)
    (step_b : ParRcdStep r rb)
  : Joinable ParRcdStep ra rb
  := by have h := step_a ; cases h with
  | nil =>
    exact ParRcdStep.triangle step_b
  | @cons e ea rr rra l step_ea step_rra =>
    cases step_b with
    | @cons _ eb _ rrb _ step_eb step_rrb =>
      have ih0 := ParStep.diamond step_ea step_eb
      have ih1 := ParRcdStep.diamond step_rra step_rrb
      exact ParRcdStep.joinable_cons ih0 ih1

  theorem ParFunStep.diamond
    (step_a : ParFunStep r ra)
    (step_b : ParFunStep r rb)
  : Joinable ParFunStep ra rb
  := by have h := step_a ; cases h with
  | nil =>
    exact ParFunStep.triangle step_b
  | @cons e ea rr rra l step_ea step_rra =>
    cases step_b with
    | @cons _ eb _ rrb _ step_eb step_rrb =>
      have ih0 := ParStep.diamond step_ea step_eb
      have ih1 := ParFunStep.diamond step_rra step_rrb

      exact ParFunStep.joinable_cons ih0 ih1

  theorem ParStep.diamond
    (step_a : ParStep e ea)
    (step_b : ParStep e eb)
  : Joinable ParStep ea eb
  := by cases step_a with
  | bvar i x =>
    exact ParStep.triangle step_b
  | fvar x =>
    exact ParStep.triangle step_b
  | @iso body body_a l step_body_a =>
    cases step_b with
    | @iso _ body_b _ step_body_b =>
      have ih := ParStep.diamond step_body_a step_body_b
      exact ParStep.joinable_iso ih
  | @record r ra step_ra =>
    cases step_b with
    | @record _ rb step_rb =>
      have ih := ParRcdStep.diamond step_ra step_rb
      exact ParStep.joinable_record ih
  | @function f fa step_fa =>
    cases step_b with
    | @function _ fb step_fb =>
      have ih := ParFunStep.diamond step_fa step_fb
      exact ParStep.joinable_function ih
  | @app cator cator_a arg arg_a step_cator_a step_arg_a =>
    cases step_b with
    | @app _ cator_b _ arg_b step_cator_b step_arg_b =>
      have ih0 := ParStep.diamond step_cator_a step_cator_b
      have ih1 := ParStep.diamond step_arg_a step_arg_b
      exact Joinable.app ih0 ih1
    | @pattern_match body body_a _ arg_b p mb f  step_body_a step_arg_b matching =>
      cases step_cator_a with
      | @function _ ff step_ff =>
        have ⟨arg_c,h0,step_arg_c⟩ := ParStep.diamond step_arg_a step_arg_b
        have ⟨mc, matching'⟩ := ParStep.pattern_match_reduction step_arg_c matching
        cases step_ff with
        | @cons _ body_b _ f' _ step_body_b step_f =>
          have ⟨body_c,h1,step_body_c⟩ := ParStep.diamond step_body_a step_body_b
          unfold Joinable

          exists (Expr.instantiate 0 mc body_c)
          apply And.intro
          { exact ParStep.pattern_match f' step_body_c h0 matching' }
          { apply ParStep.instantiate step_arg_c h1 matching matching' }

    | @skip  f fa _ arg_b p body step_fa step_arg_b isval nomatching =>
      cases step_cator_a with
      | @function _ ff step_ff =>
        cases step_ff with
        | @cons _ body' _ fb _ step_body step_fb =>
          have ⟨fc,h1,h2⟩ := ParFunStep.diamond step_fa step_fb
          have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
          exists (Expr.app (Expr.function fc) arg_c)
          apply And.intro
          { apply ParStep.skip _ h2 h3
            { exact ParStep.value_reduction h4 isval }
            { exact ParStep.skip_reduction isval h4 nomatching }
          }
          { apply ParStep.app
            { exact ParStep.function h1 }
            { exact h4 }
          }
  | @pattern_match body body_a arg arg_a p ma f step_body_a step_arg_a matching_a =>
    cases step_b with
    | @app _ cator _ arg_b step_cator step_arg_b =>
      cases step_cator with
      | @function _ ff step_ff =>
        cases step_ff with
        | @cons _ body_b _ f' _ step_body_b step_f =>
          have ⟨body_c,h1,h2⟩ := ParStep.diamond step_body_a step_body_b
          have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
          have ⟨mc, matching_c⟩ := ParStep.pattern_match_reduction h3 matching_a

          exists (Expr.instantiate 0 mc body_c)
          apply And.intro
          { apply ParStep.instantiate h3 h1 matching_a matching_c }
          { exact ParStep.pattern_match f' h2 h4 matching_c }
    | @pattern_match _ body_b _ arg_b _  mb _ step_body_b step_arg_b matching_b =>
      have ⟨body_c,h1,h2⟩ := ParStep.diamond step_body_a step_body_b
      have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
      have ⟨mc, matching_c⟩ := ParStep.pattern_match_reduction h3 matching_a
      exists (Expr.instantiate 0 mc body_c)
      apply And.intro
      { apply ParStep.instantiate h3 h1 matching_a matching_c }
      { apply ParStep.instantiate h4 h2 matching_b matching_c }
    | @skip _ fa _ arg_b _ _ step_fa step_arg_b isval_b nomatching_b =>
      have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
      have h0 := ParStep.skip_reduction isval_b h4 nomatching_b
      have h1 := ParStep.pattern_match_reduction h3 matching_a
      simp [h0] at h1

  | @skip  f fa arg arg_a p body step_fa step_arg_a isval_a nomatching_a =>
    cases step_b with
    | @app _ cator_b _ arg_b step_cator_b step_arg_b =>
      cases step_cator_b with
      | @function _ ff step_ff =>
        cases step_ff with
        | @cons _ body' _ fb _ step_body step_fb =>
          have ⟨fc,h1,h2⟩ := ParFunStep.diamond step_fa step_fb
          have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b

          exists (Expr.app (Expr.function fc) arg_c)
          apply And.intro
          { apply ParStep.app
            { exact ParStep.function h1 }
            { exact h3 }
          }
          {
            apply ParStep.skip _ h2 h4
            { apply ParStep.value_reduction h3 isval_a }
            { exact ParStep.skip_reduction isval_a h3 nomatching_a }
          }
    | @pattern_match _ body_b _ arg_b _ m' _ step_body_b step_arg_b matching =>
      have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
      have h0 := ParStep.skip_reduction isval_a h3 nomatching_a
      have h1 := ParStep.pattern_match_reduction h4 matching
      simp [h0] at h1
    | @skip _ fb _ arg_b _ _ step_fb step_arg_b isval_b nomatching_b =>
      have ⟨fc,h1,h2⟩ := ParFunStep.diamond step_fa step_fb
      have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b

      exists (Expr.app (Expr.function fc) arg_c)
      apply And.intro
      {
        apply ParStep.app
        { apply ParStep.function h1 }
        { apply h3 }
      }
      {
        apply ParStep.app
        { apply ParStep.function h2 }
        { apply h4 }
      }
  | @anno e ea t step_ea =>
    cases step_b with
    | @anno _ eb _ step_eb =>
      have ⟨ec,h1,h2⟩ := ParStep.diamond step_ea step_eb
      exists (Expr.anno ec t)
      apply And.intro
      { exact ParStep.anno h1 }
      { exact ParStep.anno h2 }
    | @erase _ eb _ step_eb =>
      have ⟨ec,h1,h2⟩ := ParStep.diamond step_ea step_eb
      exists ec
      apply And.intro
      { exact ParStep.erase t h1 }
      { exact h2 }
  | @erase e ea t step_ea =>
    cases step_b with
    | @anno _ eb _ step_eb =>
      have ⟨ec,h1,h2⟩ := ParStep.diamond step_ea step_eb
      exists ec
      apply And.intro
      { exact h1 }
      { exact ParStep.erase t h2 }
    | @erase _ eb _ step_eb =>
      have ⟨ec,h1,h2⟩ := ParStep.diamond step_ea step_eb
      exists ec
  | @loopi body body_a step_body_a =>
    cases step_b with
    | @loopi _ body_b step_body_b =>
      have ⟨body_c,h1,h2⟩ := ParStep.diamond step_body_a step_body_b
      exists (Expr.loopi body_c)
      apply And.intro
      { exact ParStep.loopi h1 }
      { exact ParStep.loopi h2 }
    | @recycle ee eea x step_eea =>
      cases step_body_a with
      | @function _ f' step_f =>
        cases step_f with
        | @cons _ eeb _ ff _ step_eeb step_ff =>
          cases step_ff with
          | nil =>
            have ⟨eec,h1,h2⟩ := ParStep.diamond step_eea step_eeb
            exists (Expr.instantiate 0 [Expr.loopi (Expr.function [(Pat.var x, eec)])] eec)
            apply And.intro
            { exact ParStep.recycle x h2 }
            {
              have h3 : ParStep
                (Expr.loopi (Expr.function [(Pat.var x, eea)]))
                (Expr.loopi (Expr.function [(Pat.var x, eec)]))
              := by
                apply ParStep.loopi
                apply ParStep.function
                apply ParFunStep.cons _ h1
                apply ParFunStep.nil

              apply ParStep.instantiate h3 h1
              { apply Pattern.match_var _ x }
              { apply Pattern.match_var}
            }
  | @recycle ee eea x step_eea =>
    cases step_b with
    | @loopi _ body_b step_body_b =>
      cases step_body_b with
      | @function _ f step_f =>
        cases step_f with
        | @cons _ eeb _ ff _ step_eeb step_ff =>
          cases step_ff with
          | nil =>
            have ⟨eec,h1,h2⟩ := ParStep.diamond step_eea step_eeb
            exists (Expr.instantiate 0 [Expr.loopi (Expr.function [(Pat.var x, eec)])] eec)
            apply And.intro
            {
              have h3 : ParStep
                (Expr.loopi (Expr.function [(Pat.var x, eea)]))
                (Expr.loopi (Expr.function [(Pat.var x, eec)]))
              := by
                apply ParStep.loopi
                apply ParStep.function
                apply ParFunStep.cons _ h1
                apply ParFunStep.nil

              apply ParStep.instantiate h3 h1
              { apply Pattern.match_var _ x}
              { apply Pattern.match_var }
            }
            { exact ParStep.recycle x h2 }
    | @recycle _ eeb _ step_eeb =>
      have ⟨eec,h1,h2⟩ := ParStep.diamond step_eea step_eeb
      exists (Expr.instantiate 0 [Expr.loopi (Expr.function [(Pat.var x, eec)])] eec)
      apply And.intro
      {
        have h3 : ParStep
          (Expr.loopi (Expr.function [(Pat.var x, eea)]))
          (Expr.loopi (Expr.function [(Pat.var x, eec)]))
        := by
          apply ParStep.loopi
          apply ParStep.function
          apply ParFunStep.cons _ h1
          apply ParFunStep.nil
        apply ParStep.instantiate h3 h1
        { apply Pattern.match_var _ x}
        { apply Pattern.match_var }
      }
      {
        have h3 : ParStep
          (Expr.loopi (Expr.function [(Pat.var x, eeb)]))
          (Expr.loopi (Expr.function [(Pat.var x, eec)]))
        := by
          apply ParStep.loopi
          apply ParStep.function
          apply ParFunStep.cons _ h2
          apply ParFunStep.nil
        apply ParStep.instantiate h3 h2
        { apply Pattern.match_var _ x}
        { apply Pattern.match_var }
      }

end

theorem ParStep.semi_confluence
  (step : ReflTrans ParStep e ea)
: ∀ {eb} , ParStep e eb → Joinable (ReflTrans ParStep) ea eb
:= by induction step with
| refl e =>
  intro eb h0
  unfold Joinable
  exists eb
  apply And.intro
  { apply ReflTrans.step
    { exact h0 }
    { exact ReflTrans.refl eb }
  }
  { exact ReflTrans.refl eb }
| @step e em ea h0 h1 ih =>
  intro eb h2
  have h3 := ParStep.diamond h0 h2
  unfold Joinable at h3
  have ⟨en,h4,h5⟩ := h3
  clear h3
  specialize ih h4
  exact Joinable.refl_trans_right_expansion h5 ih

theorem ParStep.confluence
  (step_a : ReflTrans ParStep e ea)
  (step_b : ReflTrans ParStep e eb)
: Joinable (ReflTrans ParStep) ea eb
:= by
  have h0 := ReflTrans.reverse step_a
  clear step_a
  induction h0 with
  | refl =>
    unfold Joinable
    exists eb
    apply And.intro
    { apply step_b }
    { exact ReflTrans.refl eb }
  | @step m a h2 h3 ih =>
    have ⟨b',h4,h5⟩ := ih
    clear ih
    have ⟨n,h6,h7⟩ := ParStep.semi_confluence h4 h3
    exists n
    apply And.intro
    { exact h7 }
    { exact ReflTrans.transitivity h5 h6 }



end Lang
