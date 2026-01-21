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
  | var x : ParStep (.var x) (.var x)
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
    ParStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m' body')
  | skip body :
    ParFunStep f f' →
    ParStep arg arg' →
    Expr.is_value arg' →
    Pattern.match arg' p = none →
    ParStep (.app (.function ((p,body) :: f)) arg) (.app (.function f') arg')
  | anno : ParStep e e' → ParStep (.anno e t) (.anno e' t)
  | erase body t :
    ParStep (.anno body t) body
  | loopi : ParStep body body' → ParStep (.loopi body) (.loopi body')
  | recycle x e :
    ParStep
      (.loopi (.function [(.var x, e)]))
      (Expr.sub [(x, (.loopi (.function [(.var x, e)])))] e)
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
  | var x =>
    exact ParStep.var x
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




-- theorem ParRcdStep.fresh_key_expansion :
--   ParRcdStep r r' →
--   List.is_fresh_key l r' →
--   List.is_fresh_key l r
-- := by
--   intro h0
--   cases h0 with
--   | refl =>
--     exact fun a => a
--   | @cons e e' rr rr' l' step_e step_rr fresh_rr  =>
--     intro fresh_r
--     simp [List.is_fresh_key] at fresh_r
--     have ⟨h1,h2⟩ := fresh_r
--     clear fresh_r
--     simp [List.is_fresh_key]
--     apply And.intro h1
--     apply ParRcdStep.fresh_key_expansion step_rr h2


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
    exists [(x,arg')]
    simp [Pattern.match]
  | iso l p' =>
    intro h0 h1
    cases h0 with
    | var x =>
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
    | var x =>
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
  | var x =>
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
    | var x =>
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
    | var x =>
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

theorem Expr.sub_refl :
  x ∉ ListPair.dom m →
  (Expr.sub m (.var x)) = (.var x)
:= by
  intro h0
  induction m with
  | nil =>
    simp [Expr.sub, find]
  | cons pair m' ih =>
    have ⟨x',target⟩ := pair
    simp [ListPair.dom] at h0
    have ⟨h1,h2⟩ := h0
    clear h0
    specialize ih h2
    simp [Expr.sub, find]
    have h3 : x' ≠ x := by exact fun h => h1 (Eq.symm h)
    simp [h3]
    unfold Expr.sub at ih
    exact ih

theorem remove_all_empty α ids:
  @remove_all α [] ids = []
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids' ih =>
  simp [remove_all, remove]
  exact ih


theorem remove_all_single_membership :
  x ∈ ids →
  remove_all [(x,c)] ids = []
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids' ih =>
  simp [remove_all]
  intro h0
  cases h0 with
  | inl h1 =>
    simp [*, remove]
    simp [remove_all_empty]
  | inr h1 =>
    specialize ih h1
    simp [remove]
    by_cases h2 : x = id
    { simp [h2,remove_all_empty] }
    { simp [h2,ih] }

theorem remove_all_single_nomem :
  x ∉ ids →
  remove_all [(x,c)] ids = [(x,c)]
:= by induction ids with
| nil =>
  simp [remove_all]
| cons id ids ih =>
  simp [remove_all,remove]
  intro h0 h1
  simp [h0]
  apply ih h1

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
    { by_cases h : x ∈ Pat.ids p
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
  | var x' =>
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
      exact ParStep.refl (Expr.var x')
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


theorem Pattern.match_disjoint_preservation :
  Pattern.match_entry l p r = some m0 →
  Pattern.match_record r rp = some m1 →
  Pat.ids p ∩ List.pattern_ids rp = [] →
  ListPair.dom m0 ∩ ListPair.dom m1 = []
:= by sorry

theorem ParStep.sub_disjoint_concat :
  ListPair.dom m0 ∩ ListPair.dom m1 = [] →
  ListPair.dom m0' ∩ ListPair.dom m1' = [] →
  ParStep (Expr.sub m0 body) (Expr.sub m0' body) →
  ParStep (Expr.sub m1 body) (Expr.sub m1' body) →
  ParStep (Expr.sub (m0 ++ m1) body) (Expr.sub (m0' ++ m1') body)
:= by sorry


mutual

  theorem ParRcdStep.pattern_match_entry_preservation
    (step : ParRcdStep r r')
    (matching : Pattern.match_entry l p r = some m)
    (matching' : Pattern.match_entry l p r' = some m')
    e
  : ParStep (Expr.sub m e) (Expr.sub m' e)
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
      apply ParStep.substitute step_ee matching matching' e
    }
    {
      simp [*] at matching
      simp [*] at matching'
      apply ParRcdStep.pattern_match_entry_preservation step_rr matching matching' e
    }

  theorem ParRcdStep.substitute
    (step : ParRcdStep r r')
    (matching : Pattern.match_record r ps = some m)
    (matching' : Pattern.match_record r' ps = some m')
    e
  : ParStep (Expr.sub m e) (Expr.sub m' e)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record] at matching
    simp [Pattern.match_record] at matching'
    rw [matching, matching']
    exact ParStep.refl (Expr.sub [] e)
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record] at matching
    simp [Pattern.match_record] at matching'

    have ⟨h1,h2⟩ := matching
    have ⟨h3,h4⟩ := matching'
    clear matching matching'

    cases h5 : (Pattern.match_entry l p r) with
    | some m0 =>
      simp [*] at h2
      cases h6 : (Pattern.match_entry l p r') with
      | some m1 =>
        simp [*] at h4
        cases h7 : (Pattern.match_record r ps') with
        | some m2 =>
          simp [*] at h2
          cases h8 : (Pattern.match_record r' ps') with
          | some m3 =>
            simp [*] at h4
            rw [←h2,←h4]
            have ih0 := ParRcdStep.pattern_match_entry_preservation step h5 h6 e
            have ih1 := ParRcdStep.substitute step h7 h8 e
            apply ParStep.sub_disjoint_concat
            { apply Pattern.match_disjoint_preservation h5 h7 h3 }
            { exact Pattern.match_disjoint_preservation h6 h8 h3 }
            { exact ih0 }
            { exact ih1 }
          | none =>
            simp [*] at h4
        | none =>
          simp [*] at h2
      | none =>
        simp [*] at h4
    | none =>
      simp [*] at h2



  theorem ParStep.substitute
    (step : ParStep arg arg')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
    e
  : ParStep (Expr.sub m e) (Expr.sub m' e)
  := by cases p with
  | var x =>
    simp [Pattern.match] at matching
    simp [Pattern.match] at matching'
    rw [←matching, ←matching']
    clear matching matching'
    exact ParStep.sub_preservation x step e
  | @iso l p_body =>
    cases step with
    | var x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.sub m e)
    | @iso body body' l' step_body =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      have ⟨h0,h1⟩ := matching ; clear matching
      have ⟨h2,h3⟩ := matching' ; clear matching'
      have ih := ParStep.substitute step_body h1 h3
      apply ih
    | _ =>
      simp [Pattern.match] at matching
  | @record ps =>
    cases step with
    | var x =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.sub m e)
    | @record r r' step_r =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      have ⟨h0,h1⟩ := matching
      have ⟨h2,h3⟩ := matching'
      apply ParRcdStep.substitute step_r h1 h3

    | _ =>
      simp [Pattern.match] at matching
end


theorem Pattern.match_sub_preservation :
  Pattern.match arg p = some m →
  ∀ mm,
  ∃ m', Pattern.match (Expr.sub mm arg) p = some m' ∧
  (∀ e,
    (Expr.sub m' (Expr.sub (remove_all mm (ListPair.dom m)) e))
    =
    (Expr.sub mm (Expr.sub m e))
  )
:= by sorry

theorem Pattern.match_skip_preservation :
  Pattern.match arg p = none →
  ∀ mm,
  Pattern.match (Expr.sub mm arg) p = none
:= by sorry

theorem Pattern.match_domain :
  Pattern.match arg p = some m →
  ∀ id, id ∈ Pat.ids p ↔ id ∈ ListPair.dom m
:= by sorry

theorem Pattern.remove_all_ids :
  (∀ id, id ∈ a ↔ id ∈ b) →
  remove_all m a = remove_all m b
:= by sorry

theorem ParStep.sub_remove_all ids :
  ParStep (Expr.sub m body) (Expr.sub m' body') →
  ParStep (Expr.sub (remove_all m ids) body) (Expr.sub (remove_all m' ids) body')
:= by sorry
mutual

  theorem ParRcdStep.sub
    (step_arg : ParStep arg arg')
    (step_body : ParRcdStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
  : ParRcdStep (List.record_sub m body) (List.record_sub m' body')
  := by sorry

  theorem ParFunStep.sub
    (step_arg : ParStep arg arg')
    (step_body : ParFunStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
  : ParFunStep (List.function_sub m body) (List.function_sub m' body')
  := by sorry

  theorem ParStep.sub
    (step_arg : ParStep arg arg')
    (step_body : ParStep body body')
    (matching : Pattern.match arg p = some m)
    (matching' : Pattern.match arg' p = some m')
  : ParStep (Expr.sub m body) (Expr.sub m' body')
  := by cases step_body with
  | var x =>
    exact ParStep.substitute step_arg matching matching' (Expr.var x)

  | @iso b b' l step_b =>
    simp [Expr.sub]
    apply ParStep.iso
    apply ParStep.sub step_arg step_b matching matching'

  | @record r r' step_r =>
    simp [Expr.sub]
    apply ParStep.record
    apply ParRcdStep.sub step_arg step_r matching matching'

  | @function f f' step_f =>
    simp [Expr.sub]
    apply ParStep.function
    apply ParFunStep.sub step_arg step_f matching matching'

  | @app cator cator' aa aa' step_cator step_aa =>
    simp [Expr.sub]
    have ih0 := ParStep.sub step_arg step_cator matching matching'
    have ih1 := ParStep.sub step_arg step_aa matching matching'
    apply ParStep.app ih0 ih1

  | @pattern_match body body' aa aa' pp mm' f step_body step_aa matching'' =>
    simp [Expr.sub, List.function_sub]
    have ⟨mm'',h0,h1⟩ := Pattern.match_sub_preservation matching'' m'
    rw [←h1]
    have h2 := Pattern.match_domain matching''
    rw [Pattern.remove_all_ids h2]
    have ih0 := ParStep.sub step_arg step_aa matching matching'
    have ih1 := ParStep.sub step_arg step_body matching matching'
    apply ParStep.pattern_match
    { apply ParStep.sub_remove_all _ ih1 }
    { exact ih0 }
    { exact h0 }

  | @skip aa pp f f' body isval nomatching step_f =>
    simp [Expr.sub, List.function_sub]
    -- have h0 := Pattern.match_skip_preservation nomatching m
    -- apply ParStep.skip
    sorry
  | _ => sorry
end


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
  := by have h := step_a ; cases h with
  | var x =>
    exact ParStep.triangle step_b
  | @iso body body_a l step_body_a =>
    cases step_b with
    | @iso _ body_b _ step_body_b =>
      clear step_a
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
        clear step_a
        have ⟨arg_c,h0,step_arg_c⟩ := ParStep.diamond step_arg_a step_arg_b
        have ⟨mc, matching'⟩ := ParStep.pattern_match_reduction step_arg_c matching
        cases step_ff with
        | @cons _ body_b _ f' _ step_body_b step_f =>
          have ⟨body_c,h1,step_body_c⟩ := ParStep.diamond step_body_a step_body_b
          unfold Joinable
          exists (Expr.sub mc body_c)
          apply And.intro
          { exact ParStep.pattern_match f' step_body_c h0 matching' }
          { apply ParStep.sub step_arg_c h1 matching matching' }

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
  | @skip  f fa arg arg_a p body step_fa step_arg_a isval nomatching =>
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
            { apply ParStep.value_reduction h3 isval }
            { exact ParStep.skip_reduction isval h3 nomatching }
          }
    | @pattern_match _ body_b _ arg_b _ m' _ step_body_b step_arg_b matching =>
      have ⟨arg_c,h3,h4⟩ := ParStep.diamond step_arg_a step_arg_b
      have h0 := ParStep.skip_reduction isval h3 nomatching
      have h1 := ParStep.pattern_match_reduction h4 matching
      simp [h0] at h1
    | skip =>
      sorry
      -- exact ParStep.joinable_refl
  | _ => sorry

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
