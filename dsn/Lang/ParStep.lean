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


mutual

  theorem ParStep.diamond
    (step_a : ParStep e ea)
    (step_b : ParStep e eb)
  : Joinable ParStep ea eb
  := by cases step_a with
  | refl =>
    exists eb
    apply And.intro step_b
    exact ParStep.refl eb
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
