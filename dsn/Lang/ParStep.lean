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
  (Expr.sub m (.fvar x)) = (.fvar x)
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


-- theorem ListPair.dom_remove_all_disjoint :
--   ListPair.dom m0 ∩ ListPair.dom m1 = [] →
--   ListPair.dom (remove_all m0 ids) ∩ ListPair.dom (remove_all m1 ids) = []
-- := by sorry

-- theorem Pattern.match_disjoint_preservation :
--   Pattern.match_entry l p r = some m0 →
--   Pattern.match_record r rp = some m1 →
--   Pat.ids p ∩ List.pattern_ids rp = [] →
--   ListPair.dom m0 ∩ ListPair.dom m1 = []
-- := by sorry

-- theorem ParStep.sub_disjoint_concat :
--   ListPair.dom m0 ∩ ListPair.dom m1 = [] →
--   ListPair.dom m0' ∩ ListPair.dom m1' = [] →
--   ParStep (Expr.sub m0 body) (Expr.sub m0' body) →
--   ParStep (Expr.sub m1 body) (Expr.sub m1' body) →
--   ParStep (Expr.sub (m0 ++ m1) body) (Expr.sub (m0' ++ m1') body)
-- := by sorry

-- theorem remove_all_concat :
--   remove_all (m0 ++ m1) ids =
--   remove_all m0 ids ++ remove_all m1 ids
-- := by sorry


-- mutual

--   theorem ParRcdStep.pattern_match_entry_preservation
--     (step : ParRcdStep r r')
--     (matching : Pattern.match_entry l p r = some m)
--     (matching' : Pattern.match_entry l p r' = some m')
--     ids
--     e
--   : ParStep (Expr.sub (remove_all m ids) e) (Expr.sub (remove_all m' ids) e)
--   := by cases step with
--   | nil =>
--     simp [Pattern.match_entry] at matching
--   | @cons ee ee' rr rr' l' step_ee step_rr =>
--     simp [Pattern.match_entry] at matching
--     simp [Pattern.match_entry] at matching'
--     by_cases h0 : l' = l
--     {
--       simp [*] at matching
--       simp [*] at matching'
--       apply ParStep.substitute step_ee matching matching' ids e
--     }
--     {
--       simp [*] at matching
--       simp [*] at matching'
--       apply ParRcdStep.pattern_match_entry_preservation step_rr matching matching' ids e
--     }

--   theorem ParRcdStep.substitute
--     (step : ParRcdStep r r')
--     (matching : Pattern.match_record r ps = some m)
--     (matching' : Pattern.match_record r' ps = some m')
--     ids
--     e
--   : ParStep (Expr.sub (remove_all m ids) e) (Expr.sub (remove_all m' ids) e)
--   := by cases ps with
--   | nil =>
--     simp [Pattern.match_record] at matching
--     simp [Pattern.match_record] at matching'
--     rw [matching, matching']
--     exact ParStep.refl (Expr.sub (remove_all [] ids) e)
--   | cons lp ps' =>
--     have (l,p) := lp
--     simp [Pattern.match_record] at matching
--     simp [Pattern.match_record] at matching'

--     have ⟨h1,h2⟩ := matching
--     have ⟨h3,h4⟩ := matching'
--     clear matching matching'

--     cases h5 : (Pattern.match_entry l p r) with
--     | some m0 =>
--       simp [*] at h2
--       cases h6 : (Pattern.match_entry l p r') with
--       | some m1 =>
--         simp [*] at h4
--         cases h7 : (Pattern.match_record r ps') with
--         | some m2 =>
--           simp [*] at h2
--           cases h8 : (Pattern.match_record r' ps') with
--           | some m3 =>
--             simp [*] at h4
--             rw [←h2,←h4]

--             have ih0 := ParRcdStep.pattern_match_entry_preservation step h5 h6 ids e
--             have ih1 := ParRcdStep.substitute step h7 h8 ids e

--             rw [remove_all_concat]
--             rw [remove_all_concat]
--             apply ParStep.sub_disjoint_concat
--             {
--               apply ListPair.dom_remove_all_disjoint
--               apply Pattern.match_disjoint_preservation h5 h7 h3
--             }
--             {
--               apply ListPair.dom_remove_all_disjoint
--               exact Pattern.match_disjoint_preservation h6 h8 h3
--             }
--             { exact ih0 }
--             { exact ih1 }
--           | none =>
--             simp [*] at h4
--         | none =>
--           simp [*] at h2
--       | none =>
--         simp [*] at h4
--     | none =>
--       simp [*] at h2



--   theorem ParStep.substitute
--     (step : ParStep arg arg')
--     (matching : Pattern.match arg p = some m)
--     (matching' : Pattern.match arg' p = some m')
--     ids
--     e
--   : ParStep (Expr.sub (remove_all m ids) e) (Expr.sub (remove_all m' ids) e)
--   := by cases p with
--   | var x =>
--     simp [Pattern.match] at matching
--     simp [Pattern.match] at matching'
--     rw [←matching, ←matching']
--     clear matching matching'

--     by_cases h : x ∈ ids
--     {
--       rw [remove_all_single_membership h]
--       rw [remove_all_single_membership h]
--       exact ParStep.refl (Expr.sub [] e)
--     }
--     {
--       rw [remove_all_single_nomem h]
--       rw [remove_all_single_nomem h]
--       exact ParStep.sub_preservation x step e
--     }
--   | @iso l p_body =>
--     cases step with
--     | bvar i x =>
--       simp [matching'] at matching
--       simp [*]
--       exact ParStep.refl (Expr.sub (remove_all m ids) e)
--     | fvar x =>
--       simp [matching'] at matching
--       simp [*]
--       exact ParStep.refl (Expr.sub (remove_all m ids) e)
--     | @iso body body' l' step_body =>
--       simp [Pattern.match] at matching
--       simp [Pattern.match] at matching'
--       have ⟨h0,h1⟩ := matching ; clear matching
--       have ⟨h2,h3⟩ := matching' ; clear matching'
--       have ih := ParStep.substitute step_body h1 h3
--       apply ih
--     | _ =>
--       simp [Pattern.match] at matching
--   | @record ps =>
--     cases step with
--     | bvar i x =>
--       simp [matching'] at matching
--       simp [*]
--       exact ParStep.refl (Expr.sub (remove_all m ids) e)
--     | fvar x =>
--       simp [matching'] at matching
--       simp [*]
--       exact ParStep.refl (Expr.sub (remove_all m ids) e)
--     | @record r r' step_r =>
--       simp [Pattern.match] at matching
--       simp [Pattern.match] at matching'
--       have ⟨h0,h1⟩ := matching
--       have ⟨h2,h3⟩ := matching'
--       apply ParRcdStep.substitute step_r h1 h3

--     | _ =>
--       simp [Pattern.match] at matching
-- end

mutual

  theorem ParRcdStep.entry_instantiator
    (step : ParRcdStep r r')
    (matching : Pattern.match_entry l p r = some m)
    (matching' : Pattern.match_entry l p r' = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m e)
  := by cases step with
  | _ => sorry
  -- | nil =>
  --   simp [Pattern.match_entry] at matching
  -- | @cons ee ee' rr rr' l' step_ee step_rr =>
  --   simp [Pattern.match_entry] at matching
  --   simp [Pattern.match_entry] at matching'
  --   by_cases h0 : l' = l
  --   {
  --     simp [*] at matching
  --     simp [*] at matching'
  --     apply ParStep.substitute step_ee matching matching' ids e
  --   }
  --   {
  --     simp [*] at matching
  --     simp [*] at matching'
  --     apply ParRcdStep.pattern_match_entry_preservation step_rr matching matching' ids e
  --   }

  theorem ParRcdStep.instantiator
    (step : ParRcdStep r r')
    (matching : Pattern.match_record r ps = some m)
    (matching' : Pattern.match_record r' ps = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m'  e)
  := by cases ps with
  | _ => sorry
  -- | nil =>
  --   simp [Pattern.match_record] at matching
  --   simp [Pattern.match_record] at matching'
  --   rw [matching, matching']
  --   exact ParStep.refl (Expr.sub (remove_all [] ids) e)
  -- | cons lp ps' =>
  --   have (l,p) := lp
  --   simp [Pattern.match_record] at matching
  --   simp [Pattern.match_record] at matching'

  --   have ⟨h1,h2⟩ := matching
  --   have ⟨h3,h4⟩ := matching'
  --   clear matching matching'

  --   cases h5 : (Pattern.match_entry l p r) with
  --   | some m0 =>
  --     simp [*] at h2
  --     cases h6 : (Pattern.match_entry l p r') with
  --     | some m1 =>
  --       simp [*] at h4
  --       cases h7 : (Pattern.match_record r ps') with
  --       | some m2 =>
  --         simp [*] at h2
  --         cases h8 : (Pattern.match_record r' ps') with
  --         | some m3 =>
  --           simp [*] at h4
  --           rw [←h2,←h4]

  --           have ih0 := ParRcdStep.pattern_match_entry_preservation step h5 h6 ids e
  --           have ih1 := ParRcdStep.substitute step h7 h8 ids e

  --           rw [remove_all_concat]
  --           rw [remove_all_concat]
  --           apply ParStep.sub_disjoint_concat
  --           {
  --             apply ListPair.dom_remove_all_disjoint
  --             apply Pattern.match_disjoint_preservation h5 h7 h3
  --           }
  --           {
  --             apply ListPair.dom_remove_all_disjoint
  --             exact Pattern.match_disjoint_preservation h6 h8 h3
  --           }
  --           { exact ih0 }
  --           { exact ih1 }
  --         | none =>
  --           simp [*] at h4
  --       | none =>
  --         simp [*] at h2
  --     | none =>
  --       simp [*] at h4
  --   | none =>
  --     simp [*] at h2



  theorem ParStep.instantiator
    (step : ParStep arg arg')
    (matching' : Pattern.match arg' p = some m')
    offset
    e
  : ParStep (Expr.instantiate offset m e) (Expr.instantiate offset m' e)
  := by cases p with
  | _ => sorry
  -- | var x =>
  --   simp [Pattern.match] at matching
  --   simp [Pattern.match] at matching'
  --   rw [←matching, ←matching']
  --   clear matching matching'

  --   by_cases h : x ∈ ids
  --   {
  --     rw [remove_all_single_membership h]
  --     rw [remove_all_single_membership h]
  --     exact ParStep.refl (Expr.sub [] e)
  --   }
  --   {
  --     rw [remove_all_single_nomem h]
  --     rw [remove_all_single_nomem h]
  --     exact ParStep.sub_preservation x step e
  --   }
  -- | @iso l p_body =>
  --   cases step with
  --   | bvar i x =>
  --     simp [matching'] at matching
  --     simp [*]
  --     exact ParStep.refl (Expr.sub (remove_all m ids) e)
  --   | fvar x =>
  --     simp [matching'] at matching
  --     simp [*]
  --     exact ParStep.refl (Expr.sub (remove_all m ids) e)
  --   | @iso body body' l' step_body =>
  --     simp [Pattern.match] at matching
  --     simp [Pattern.match] at matching'
  --     have ⟨h0,h1⟩ := matching ; clear matching
  --     have ⟨h2,h3⟩ := matching' ; clear matching'
  --     have ih := ParStep.substitute step_body h1 h3
  --     apply ih
  --   | _ =>
  --     simp [Pattern.match] at matching
  -- | @record ps =>
  --   cases step with
  --   | bvar i x =>
  --     simp [matching'] at matching
  --     simp [*]
  --     exact ParStep.refl (Expr.sub (remove_all m ids) e)
  --   | fvar x =>
  --     simp [matching'] at matching
  --     simp [*]
  --     exact ParStep.refl (Expr.sub (remove_all m ids) e)
  --   | @record r r' step_r =>
  --     simp [Pattern.match] at matching
  --     simp [Pattern.match] at matching'
  --     have ⟨h0,h1⟩ := matching
  --     have ⟨h2,h3⟩ := matching'
  --     apply ParRcdStep.substitute step_r h1 h3

  --   | _ =>
  --     simp [Pattern.match] at matching
end


-- theorem Pattern.match_sub_preservation :
--   Pattern.match arg p = some m →
--   ∀ mm,
--   ∃ m', Pattern.match (Expr.sub mm arg) p = some m' ∧
--   (∀ e,
--     (Expr.sub m' (Expr.sub (remove_all mm (ListPair.dom m)) e))
--     =
--     (Expr.sub mm (Expr.sub m e))
--   )
-- := by sorry

-- theorem Pattern.match_skip_preservation :
--   Pattern.match arg p = none →
--   ∀ mm,
--   Pattern.match (Expr.sub mm arg) p = none
-- := by sorry

-- theorem Pattern.match_domain :
--   Pattern.match arg p = some m →
--   ∀ id, id ∈ Pat.ids p ↔ id ∈ ListPair.dom m
-- := by sorry

-- theorem Pattern.remove_all_ids :
--   (∀ id, id ∈ a ↔ id ∈ b) →
--   remove_all m a = remove_all m b
-- := by sorry

-- theorem sub_var_remove_all_membership :
--   x ∈ ids →
--   Expr.sub (remove_all m ids) (.fvar x) = (.fvar x)
-- := by sorry

-- theorem sub_var_remove_all_nomem :
--   x ∉ ids →
--   Expr.sub (remove_all m ids) (.fvar x) = Expr.sub m (.fvar x)
-- := by sorry


-- theorem find_remove_refl α x m:
--   @find α x (remove x m) = Option.none
-- := by sorry

-- theorem find_remove_neq α x m:
--   x ≠ x' →
--   @find α x (remove x' m) = find x m
-- := by sorry

-- theorem find_fresh_var_preservation :
--     find x m = some e →
--     x' ∉ Expr.context_free_vars m →
--     x' ∉ Expr.free_vars e
-- := by sorry

-- theorem Expr.sub_fresh :
--   x ∉ Expr.free_vars e →
--   Expr.sub [(x,c)] e = e
-- := by sorry

-- mutual
--   /- TODO: requires that m does not point to expression containing x -/
--   theorem Expr.sub_inside_out :
--     x ∉ (Expr.context_free_vars m) →
--     Expr.sub m (Expr.sub [(x,c)] e)
--     =
--     Expr.sub [(x,(Expr.sub m c))] (Expr.sub (remove x m) e)
--   := by intro h0; cases e with
--   | bvar i x' =>
--     sorry
--   | fvar x' =>
--     by_cases h1 : x = x'
--     {
--       simp [Expr.sub,find,h1]
--       simp [find_remove_refl]
--       simp [Expr.sub,find]
--     }
--     {
--       simp [Expr.sub]
--       simp [find]
--       simp [h1]

--       rw [find_remove_neq _ _ _ (fun a => h1 (Eq.symm a))]

--       cases h2 : find x' m with
--       | none =>
--         simp [*]
--         simp [Expr.sub,find,h1,h2]
--       | some e =>
--         simp [*, Expr.sub]
--         apply Eq.symm
--         apply Expr.sub_fresh
--         apply find_fresh_var_preservation h2 h0

--     }
--   | _ => sorry
-- end

-- theorem List.is_fresh_key_sub_preservation :
--   List.is_fresh_key l r →
--   List.is_fresh_key l (List.record_sub m r)
-- := by induction r with
-- | nil =>
--   simp [List.is_fresh_key, List.record_sub]
-- | cons le r' ih =>
--   have (l',e) := le
--   simp [List.is_fresh_key, List.record_sub]
--   intro h0 h1
--   apply And.intro h0
--   apply ih h1

-- mutual

--   theorem Expr.is_record_value_sub_preservation :
--     List.is_record_value r →
--     List.is_record_value (List.record_sub m r)
--   := by cases r with
--   | nil =>
--     simp [List.is_record_value, List.record_sub]
--   | cons le r' =>
--     have (l,e) := le
--     simp [List.is_record_value, List.record_sub]
--     intro h0 h1 h2
--     apply And.intro
--     {
--       apply And.intro
--       { exact List.is_fresh_key_sub_preservation h0 }
--       { apply Expr.is_value_sub_preservation h1 }
--     }
--     { apply Expr.is_record_value_sub_preservation h2 }

--   theorem Expr.is_value_sub_preservation :
--     Expr.is_value e →
--     Expr.is_value (Expr.sub m e)
--   := by cases e with
--   | bvar i x =>
--     simp [Expr.is_value]
--   | fvar x =>
--     simp [Expr.is_value]
--   | iso l body =>
--     simp [Expr.is_value, Expr.sub]
--     intro h0
--     apply Expr.is_value_sub_preservation h0
--   | record r =>
--     simp [Expr.is_value, Expr.sub]
--     intro h0
--     apply Expr.is_record_value_sub_preservation h0
--   | function f =>
--     simp [Expr.is_value, Expr.sub]
--   | _ =>
--     simp [Expr.is_value]
-- end

-- theorem remove_remove_all_nesting :
--   ∀ α m ,
--   @remove α x (remove_all m ids) =
--   @remove_all α m (ids ++ [x])
-- := by induction ids with
-- | nil =>
--   simp [remove_all]
-- | cons id ids' ih =>
--   intro α m
--   simp [remove_all]
--   apply ih

-- theorem remove_all_nesting :
--   ∀ α m,
--   @remove_all α (remove_all m ids) ids' =
--   @remove_all α m (ids ++ ids')
-- := by induction ids with
-- | nil =>
--   simp [remove_all]
-- | cons id ids'' ih =>
--   intro α m
--   simp [remove_all]
--   apply ih

-- mutual

--   theorem ParRcdStep.sub_partial
--     (step_arg : ParStep arg arg')
--     (step_body : ParRcdStep body body')
--     (matching : Pattern.match arg p = some m)
--     (matching' : Pattern.match arg' p = some m')
--     ids
--   : ParRcdStep
--     (List.record_sub (remove_all m ids) body)
--     (List.record_sub (remove_all m' ids) body')
--   := by cases step_body with
--   | nil =>
--     exact ParRcdStep.refl (List.record_sub m [])
--   | @cons e e' r r' l step_e step_r =>
--     simp [List.record_sub]
--     apply ParRcdStep.cons
--     { apply ParStep.sub_partial step_arg step_e matching matching'}
--     { apply ParRcdStep.sub_partial step_arg step_r matching matching' }

--   theorem ParFunStep.sub_partial
--     (step_arg : ParStep arg arg')
--     (step_body : ParFunStep body body')
--     (matching : Pattern.match arg p = some m)
--     (matching' : Pattern.match arg' p = some m')
--     ids
--   : ParFunStep (List.function_sub (remove_all m ids) body)
--     (List.function_sub (remove_all m' ids) body')
--   := by cases step_body with
--   | nil =>
--     exact ParFunStep.refl (List.function_sub m [])
--   | @cons e e' f f' p' step_e step_f =>
--     simp [List.function_sub]
--     apply ParFunStep.cons
--     {
--       rw [remove_all_nesting]
--       rw [remove_all_nesting]
--       apply ParStep.sub_partial step_arg step_e matching matching'
--     }
--     { apply ParFunStep.sub_partial step_arg step_f matching matching' }

--   theorem ParStep.sub_partial
--     (step_arg : ParStep arg arg')
--     (step_body : ParStep body body')
--     (matching : Pattern.match arg p = some m)
--     (matching' : Pattern.match arg' p = some m')
--     ids
--   : ParStep (Expr.sub (remove_all m ids) body) (Expr.sub (remove_all m' ids) body')
--   := by cases step_body with
--   | bvar i x =>
--     exact ParStep.substitute step_arg matching matching' _ (Expr.bvar i x)
--   | fvar x =>
--     exact ParStep.substitute step_arg matching matching' _ (Expr.fvar x)

--   | @iso b b' l step_b =>
--     simp [Expr.sub]
--     apply ParStep.iso
--     apply ParStep.sub_partial step_arg step_b matching matching'

--   | @record r r' step_r =>
--     simp [Expr.sub]
--     apply ParStep.record
--     apply ParRcdStep.sub_partial step_arg step_r matching matching'

--   | @function f f' step_f =>
--     simp [Expr.sub]
--     apply ParStep.function
--     apply ParFunStep.sub_partial step_arg step_f matching matching'

--   | @app cator cator' aa aa' step_cator step_aa =>
--     simp [Expr.sub]
--     have ih0 := ParStep.sub_partial step_arg step_cator matching matching' ids
--     have ih1 := ParStep.sub_partial step_arg step_aa matching matching' ids
--     apply ParStep.app ih0 ih1

--   | @pattern_match body body' aa aa' pp mm' f step_body step_aa matching'' =>
--     simp [Expr.sub, List.function_sub]

--     have ⟨mm'',h0,h1⟩ := Pattern.match_sub_preservation matching'' (remove_all m' ids)
--     rw [←h1]
--     have h2 := Pattern.match_domain matching''
--     rw [Pattern.remove_all_ids h2]
--     have ih0 := ParStep.sub_partial step_arg step_aa matching matching'
--     have ih1 := ParStep.sub_partial step_arg step_body matching matching'
--     rw [remove_all_nesting]
--     rw [remove_all_nesting]
--     apply ParStep.pattern_match
--     { apply ih1 }
--     { exact ih0 ids }
--     { exact h0 }

--   | @skip f f' aa aa' pp bb step_f step_aa isval nomatching  =>
--     simp [Expr.sub, List.function_sub]
--     apply ParStep.skip
--     { apply ParFunStep.sub_partial step_arg step_f matching matching' }
--     { apply ParStep.sub_partial step_arg step_aa matching matching'}
--     { exact Expr.is_value_sub_preservation isval }
--     { exact Pattern.match_skip_preservation nomatching (remove_all m' ids) }
--   | @anno e e' t step_e =>
--     simp [Expr.sub]
--     apply ParStep.anno
--     apply ParStep.sub_partial step_arg step_e matching matching'
--   | @erase body body' t step_body =>
--     simp [Expr.sub]
--     apply ParStep.erase
--     apply ParStep.sub_partial step_arg step_body matching matching'
--   | @loopi body body' step_body =>
--     simp [Expr.sub]
--     apply ParStep.loopi
--     apply ParStep.sub_partial step_arg step_body matching matching'
--   | @recycle e e' x step_e =>
--     simp [Expr.sub, List.function_sub]
--     simp [Pat.ids, remove_all]

--     have fresh : x ∉ Expr.context_free_vars (remove_all m' ids) := by
--       sorry

--     rw [Expr.sub_inside_out fresh]

--     simp [Expr.sub, List.function_sub, Pat.ids, remove_all]
--     apply ParStep.recycle
--     rw [remove_remove_all_nesting]
--     rw [remove_remove_all_nesting]
--     apply ParStep.sub_partial step_arg step_e matching matching'

-- end


-- theorem remove_none α m:
--   @remove_all α m [] = m
-- := by
--   simp [remove_all]

-- theorem ParStep.sub
--   (step_arg : ParStep arg arg')
--   (step_body : ParStep body body')
--   (matching : Pattern.match arg p = some m)
--   (matching' : Pattern.match arg' p = some m')
-- : ParStep (Expr.sub m body) (Expr.sub m' body')
-- := by
--   rw [←remove_none _ m]
--   rw [←remove_none _ m]
--   apply ParStep.sub_partial step_arg step_body matching matching'

theorem Pattern.match_instantiate_preservation :
  Pattern.match arg p = some m →
  ∀ offset d,
  ∃ mi, Pattern.match (Expr.instantiate offset d arg) p = some mi ∧
  (∀ e,
    (Expr.instantiate 0 mi (Expr.instantiate (offset + Pat.count_vars p) d e))
    =
    (Expr.instantiate offset d (Expr.instantiate 0 m e))
  )
:= by sorry

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
    exact ParStep.instantiator step_arg matching' offset (Expr.bvar i x)
  | fvar x =>
    exact ParStep.instantiator step_arg matching' offset (Expr.fvar x)
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

    have ⟨mm'',h0,h1⟩ := Pattern.match_instantiate_preservation matching'' offset m'
    rw [← h1 body']
    apply ParStep.pattern_match
    { apply ParStep.instantiate step_arg step_body matching matching' }
    { apply ParStep.instantiate step_arg step_aa matching matching' }
    { exact h0 }

  -- | @skip f f' aa aa' pp bb step_f step_aa isval nomatching  =>
  --   simp [Expr.sub, List.function_sub]
  --   apply ParStep.skip
  --   { apply ParFunStep.sub_partial step_arg step_f matching matching' }
  --   { apply ParStep.sub_partial step_arg step_aa matching matching'}
  --   { exact Expr.is_value_sub_preservation isval }
  --   { exact Pattern.match_skip_preservation nomatching (remove_all m' ids) }
  -- | @anno e e' t step_e =>
  --   simp [Expr.sub]
  --   apply ParStep.anno
  --   apply ParStep.sub_partial step_arg step_e matching matching'
  -- | @erase body body' t step_body =>
  --   simp [Expr.sub]
  --   apply ParStep.erase
  --   apply ParStep.sub_partial step_arg step_body matching matching'
  -- | @loopi body body' step_body =>
  --   simp [Expr.sub]
  --   apply ParStep.loopi
  --   apply ParStep.sub_partial step_arg step_body matching matching'
  -- | @recycle e e' x step_e =>
  --   simp [Expr.sub, List.function_sub]
  --   simp [Pat.ids, remove_all]

  --   have fresh : x ∉ Expr.context_free_vars (remove_all m' ids) := by
  --     sorry

  --   rw [Expr.sub_inside_out fresh]

  --   simp [Expr.sub, List.function_sub, Pat.ids, remove_all]
  --   apply ParStep.recycle
  --   rw [remove_remove_all_nesting]
  --   rw [remove_remove_all_nesting]
  --   apply ParStep.sub_partial step_arg step_e matching matching'
  | _ => sorry

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
