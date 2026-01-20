import Lang.Util
import Lang.Basic
import Lang.Pattern

set_option pp.fieldNotation false

namespace Lang

mutual

  inductive ParRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | refl r : ParRcdStep r r
  | cons :
    ParStep e e' →  ParRcdStep r r' →
    List.is_fresh_key l r →
    ParRcdStep ((l, e) :: r) ((l, e') :: r')

  inductive ParFunStep : List (Pat × Expr) → List (Pat × Expr) → Prop
  | refl f : ParFunStep f f
  | cons :
    ParStep e e' →  ParFunStep f f' →
    ParFunStep ((p, e) :: f) ((p, e') :: f')

  inductive ParStep : Expr → Expr → Prop
  | refl e : ParStep e e
  /- head normal forms -/
  | iso : ParStep body body' → ParStep (.iso l body) (.iso l body')
  | record : ParRcdStep r r' →  ParStep (.record r) (.record r')
  | function : ParFunStep f f' → ParStep (.function f) (.function f')

  /- redex forms -/
  | app :
    ParStep cator cator' → ParStep arg arg' →
    ParStep (.app cator arg) (.app cator' arg')
  | pattern_match body f :
    Pattern.match arg p = some m →
    ParStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m body)
  | skip body f:
    arg.is_value →
    Pattern.match arg p = none →
    ParStep (.app (.function ((p,body) :: f)) arg) (.app (.function f) arg)
  | erase body t :
    ParStep (.anno body t) body
  | loopi : ParStep body body' → ParStep (.loop body) (.loop body')
  | recycle x e :
    ParStep
      (.loop (.function [(.var x, e)]))
      (Expr.sub [(x, (.loop (.function [(.var x, e)])))] e)
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


theorem ParRcdStep.fresh_key_reduction :
  ParRcdStep r r' →
  List.is_fresh_key l r →
  List.is_fresh_key l r'
:= by
  intro h0
  cases h0 with
  | refl  =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr fresh_rr =>
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
  | refl =>
    exact fun a => a
  | @cons e e' rr rr' l' step_e step_rr fresh_rr  =>
    intro fresh_r
    simp [List.is_fresh_key] at fresh_r
    have ⟨h1,h2⟩ := fresh_r
    clear fresh_r
    simp [List.is_fresh_key]
    apply And.intro h1
    apply ParRcdStep.fresh_key_expansion step_rr h2


theorem ParRcdStep.joinable_cons :
  (List.is_fresh_key l ra ∨ List.is_fresh_key l rb) →
  Joinable ParStep ea eb →
  Joinable ParRcdStep ra rb →
  Joinable ParRcdStep ((l,ea)::ra) ((l,eb)::rb)
:= by
  unfold Joinable
  intro h0 h1 h2
  have ⟨ec,h4,h5⟩ := h1
  have ⟨rc,h6,h7⟩ := h2
  exists ((l,ec)::rc)
  cases h0 with
  | inl h8 =>
    apply And.intro
    { exact ParRcdStep.cons h4 h6 h8 }
    {
      have h9 := ParRcdStep.fresh_key_reduction h6 h8
      have h10 := ParRcdStep.fresh_key_expansion h7 h9
      exact ParRcdStep.cons h5 h7 h10
    }
  | inr h8 =>
    apply And.intro
    {
      have h9 := ParRcdStep.fresh_key_reduction h7 h8
      have h10 := ParRcdStep.fresh_key_expansion h6 h9
      exact ParRcdStep.cons h4 h6 h10
    }
    { exact ParRcdStep.cons h5 h7 h8 }

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
    | refl =>
      exact Exists.intro m h1
    | @cons e e' rr rr' l' step_e step_rr fresh =>
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
        have ⟨h6,h7⟩ := h3
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
    | refl =>
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
    | refl =>
      exact Exists.intro m h1
    | iso =>
      simp [Pattern.match] at h1
    | @record r r' step =>
      simp [Pattern.match] at h1
      have ⟨m',ih⟩ := ParRcdStep.pattern_match_reduction step h1
      exists m'
      simp [Pattern.match]
      exact ih
    | _ =>
      simp [Pattern.match] at h1
end

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


mutual

  theorem ParStep.sub_record_preservation
    x
    (step : ParStep arg arg')
    r
  : ParRcdStep (List.record_sub [(x,arg)] r) (List.record_sub [(x,arg')] r)
  := by sorry

  theorem ParStep.sub_preservation
    x
    (step : ParStep arg arg')
    body
  : ParStep (Expr.sub [(x,arg)] body) (Expr.sub [(x,arg')] body)
  := by cases body with
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
  | iso l target =>
    simp [Expr.sub]
    have ih := ParStep.sub_preservation x step target
    exact ParStep.iso ih
  | record r =>
    simp [Expr.sub]
    have ih := ParStep.sub_record_preservation x step r
    exact ParStep.record ih
  | function f =>
    simp [Expr.sub]
    sorry
  | _ => sorry
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
  | refl =>
    rw [matching] at matching'
    simp at matching'
    rw [matching']
    exact ParStep.refl (Expr.sub m' e)
  | @cons ee ee' rr rr' l' step_ee step_rr =>
    simp [Pattern.match_entry] at matching
    simp [Pattern.match_entry] at matching'
    by_cases h0 : l' = l
    {
      simp [*] at matching
      simp [*] at matching'
      apply ParStep.pattern_match_preservation step_ee matching matching' e
    }
    {
      simp [*] at matching
      simp [*] at matching'
      apply ParRcdStep.pattern_match_entry_preservation step_rr matching matching' e
    }

  theorem ParRcdStep.pattern_match_preservation
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
            have ⟨h9,h10⟩ := h2
            rw [←h10,←h4]
            have ih0 := ParRcdStep.pattern_match_entry_preservation step h5 h6 e
            have ih1 := ParRcdStep.pattern_match_preservation step h7 h8 e
            apply ParStep.sub_disjoint_concat
            { exact Pattern.match_disjoint_preservation h5 h7 h9 }
            { exact Pattern.match_disjoint_preservation h6 h8 h9 }
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


  theorem ParStep.pattern_match_preservation
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
    | refl =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.sub m e)
    | @iso body body' l' step_body =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      have ⟨h0,h1⟩ := matching ; clear matching
      have ⟨h2,h3⟩ := matching' ; clear matching'
      have ih := ParStep.pattern_match_preservation step_body h1 h3
      apply ih
    | _ =>
      simp [Pattern.match] at matching
  | @record ps =>
    cases step with
    | refl =>
      simp [matching'] at matching
      simp [*]
      exact ParStep.refl (Expr.sub m e)
    | @record r r' step_r =>
      simp [Pattern.match] at matching
      simp [Pattern.match] at matching'
      apply ParRcdStep.pattern_match_preservation step_r matching matching'
    | _ =>
      simp [Pattern.match] at matching
end



theorem ParStep.value_inversion :
  ParStep a b → Expr.is_value a → b = a
:= by sorry


mutual

  theorem ParRcdStep.diamond
    (step_a : ParRcdStep r ra)
    (step_b : ParRcdStep r rb)
  : Joinable ParRcdStep ra rb
  := by have h := step_a ; cases h with
  | refl =>
    exact ParRcdStep.triangle step_b
  | @cons e ea rr rra l step_ea step_rra fresh =>
    cases step_b with
    | refl =>
      apply Joinable.symm
      exact ParRcdStep.triangle step_a
    | @cons _ eb _ rrb _ step_eb step_rrb fresh' =>
      clear fresh'
      have ih0 := ParStep.diamond step_ea step_eb
      have ih1 := ParRcdStep.diamond step_rra step_rrb
      have fresh_rra := ParRcdStep.fresh_key_reduction step_rra fresh
      apply ParRcdStep.joinable_cons (Or.inl fresh_rra) ih0 ih1

  theorem ParStep.diamond
    (step_a : ParStep e ea)
    (step_b : ParStep e eb)
  : Joinable ParStep ea eb
  := by have h := step_a ; cases h with
  | refl =>
    exact ParStep.triangle step_b
  | @iso body body_a l step_body_a =>
    cases step_b with
    | @refl e =>
      apply Joinable.symm
      exact ParStep.triangle step_a
    | @iso _ body_b _ step_body_b =>
      clear step_a
      have ih := ParStep.diamond step_body_a step_body_b
      exact ParStep.joinable_iso ih
  | @record r ra step_ra =>
    cases step_b with
    | @refl e =>
      apply Joinable.symm
      exact ParStep.triangle step_a
    | @record _ rb step_rb =>
      have ih := ParRcdStep.diamond step_ra step_rb
      exact ParStep.joinable_record ih
  | @function f f' step_f=>
    sorry
  | @app cator cator_a arg arg_a step_cator_a step_arg_a =>
    cases step_b with
    | @refl e =>
      apply Joinable.symm
      exact ParStep.triangle step_a
    | @app _ cator_b _ arg_b step_cator_b step_arg_b =>
      have ih0 := ParStep.diamond step_cator_a step_cator_b
      have ih1 := ParStep.diamond step_arg_a step_arg_b
      exact Joinable.app ih0 ih1
    | @pattern_match _ p m body f matching =>

      cases step_cator_a with
      | refl =>
        clear step_a
        have ⟨ma, matching_a⟩ := ParStep.pattern_match_reduction step_arg_a matching
        unfold Joinable
        exists (Expr.sub ma body)
        apply And.intro
        { exact ParStep.pattern_match body f matching_a }
        { exact ParStep.pattern_match_preservation step_arg_a matching matching_a body }
      | _ => sorry
    | @skip _ p body f isval nomatching =>
      cases step_cator_a with
      | refl =>
        have h0 := ParStep.value_inversion step_arg_a isval
        rw [h0] ; clear h0
        exists (Expr.app (Expr.function f) arg)
        apply And.intro
        { exact ParStep.skip body f isval nomatching }
        { exact ParStep.refl (Expr.app (Expr.function f) arg) }
      | _ => sorry
  | @skip arg p body f isval nomatching =>
    cases step_b with
    | refl =>
      apply Joinable.symm
      exact ParStep.triangle step_a
    | @app _ cator_b _ arg_b step_cator_b step_arg_b =>
      have h0 := ParStep.value_inversion step_arg_b isval
      rw [h0]
      cases step_cator_b with
      | refl =>
        apply Joinable.symm
        exact ParStep.triangle step_a
      | _ => sorry
    | @pattern_match _ _ m _ _ matching =>
      rw [matching] at nomatching
      simp at nomatching
    | skip =>
      exact ParStep.joinable_refl
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
