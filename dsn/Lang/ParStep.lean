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

  inductive ParStep : Expr → Expr → Prop
  | refl e : ParStep e e
  /- head normal forms -/
  | iso : ParStep body body' → ParStep (.iso l body) (.iso l body')
  | record : ParRcdStep r r' →  ParStep (.record r) (.record r')

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
