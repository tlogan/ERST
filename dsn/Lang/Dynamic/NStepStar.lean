import Lang.Basic
import Lang.Dynamic.NStep

set_option pp.fieldNotation false


namespace Lang.Dynamic

inductive NStepStar : Expr → Expr → Prop
| refl : NStepStar e e
| step : NStep e e' → NStepStar e' e'' → NStepStar e e''

inductive StarNStep : Expr → Expr → Prop
| refl : StarNStep e e
| step : StarNStep e e' → NStep e' e'' → StarNStep e e''

theorem StarNStep.transitive :
  StarNStep e e' → StarNStep e' e'' → StarNStep e e''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3


theorem NStepStar.transitive :
  NStepStar e e' → NStepStar e' e'' → NStepStar e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)

theorem NStepStar.reverse :
  NStepStar e e' → StarNStep e e'
:= by
  intro h0
  induction h0 with
  | refl =>
    exact StarNStep.refl
  | @step e em e' h1 h2 ih =>
    apply StarNStep.transitive
    { apply StarNStep.step StarNStep.refl h1 }
    { exact ih }


theorem NStepStar.iso :
  NStepStar body body' →
  NStepStar (Expr.iso label body) (Expr.iso label body')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply NStepStar.refl
  | step h1 h2 ih =>
    apply NStepStar.step (NStep.iso h1) ih

theorem NStepStar.iso_inversion :
  NStepStar (Expr.iso label body) e →
  ∃ body' , e = (Expr.iso label body') ∧  NStepStar body body'
:= by
  intro h0
  apply NStepStar.reverse at h0

  induction h0 with
  | refl =>
    exists body
    simp
    apply NStepStar.refl
  | step h1 h2 ih =>
    have ⟨body',h3,h4⟩ := ih
    clear ih
    rw [h3] at h2

    cases h2 with
    | @iso body' body'' _ step =>
      exists body''
      simp
      apply NStepStar.transitive h4
      apply NStepStar.step step
      exact refl


inductive NRcdStepStar : List (String × Expr) → List (String × Expr) → Prop
| refl : NRcdStepStar r r
| step : NRcdStep r r' → NRcdStepStar r' r'' → NRcdStepStar r r''

theorem NRcdStepStar.transitive :
  NRcdStepStar e e' → NRcdStepStar e' e'' → NRcdStepStar e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)


theorem NStepStar.applicand :
  NStepStar e e' →
  NStepStar (.app f e) (.app f e')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply NStepStar.refl
  | step h1 h2 ih =>
    apply NStepStar.step (NStep.applicand h1) ih

theorem NStepStar.record :
  NRcdStepStar r r' →
  NStepStar (.record r) (.record r')
:= by
  intro h0
  induction h0 with
  | refl =>
    exact NStepStar.refl
  | step h1 h2 ih =>
    apply NStepStar.step
    { apply NStep.record h1 }
    { exact ih }

theorem NRcdStepStar.tail :
  NStepStar e e' →
  NRcdStepStar r r' →
  NRcdStepStar ((l,e) :: r) ((l,e') :: r')
:= by sorry


theorem NRcdStepStar.tail_inversion :
  NRcdStepStar ((l,e) :: r) r' →
  ∃ e' r'' , r' = ((l,e') :: r'')  ∧ NStepStar e e' ∧ NRcdStepStar r r''
:= by sorry


theorem NStepStar.record_inversion :
  NStepStar (.record r) e →
  ∃ r' , e = .record r' ∧ NRcdStepStar r r'
:= by
  intro h0
  apply NStepStar.reverse at h0

  induction h0 with
  | refl =>
    exists r
    simp
    exact NRcdStepStar.refl
  | step h1 h2 ih =>
    have ⟨r',h3,h4⟩ := ih
    rw [h3] at h2
    cases h2 with
    | @record r' r'' step =>
      exists r''
      simp
      apply NRcdStepStar.transitive h4
      apply NRcdStepStar.step step
      exact NRcdStepStar.refl


def Joinable (a b : Expr) :=
  ∃ e , NStepStar a e ∧ NStepStar b e

def RcdJoinable (a b : List (String × Expr)) :=
  ∃ e , NRcdStepStar a e ∧ NRcdStepStar b e

theorem Joinable.transitivity {a b c} :
  Joinable a b →
  Joinable b c →
  Joinable a c
:= by sorry

theorem Joinable.swap {a b} :
  Joinable a b →
  Joinable b a
:= by sorry

theorem Joinable.applicand {a b} f :
  Joinable a b →
  Joinable (.app f a) (.app f b)
:= by
  unfold Joinable
  intro h0
  have ⟨c,h1,h2⟩ := h0
  exists (.app f c)
  apply And.intro
  {exact NStepStar.applicand h1}
  {exact NStepStar.applicand h2}

theorem Joinable.iso :
  Joinable a b →
  Joinable (.iso l a) (.iso l b)
:= by
  unfold Joinable
  intro h0
  have ⟨c,h1,h2⟩ := h0
  exists (.iso l c)
  apply And.intro
  {exact NStepStar.iso h1}
  {exact NStepStar.iso h2}

theorem Joinable.record :
  RcdJoinable ra rb →
  Joinable (.record ra) (.record rb)
:= by
  unfold RcdJoinable
  unfold Joinable
  intro h0
  have ⟨rc,h1,h2⟩ := h0
  exists (.record rc)
  apply And.intro
  {exact NStepStar.record h1}
  {exact NStepStar.record h2}



theorem NRcdStepStar.cons_inversion :
  NRcdStepStar ((l,e)::r) r' →
  (∃ e' r'' , r' = ((l,e')::r'') ∧ NStepStar e e' ∧ NRcdStepStar r r'')
:= by sorry

theorem RcdJoinable.cons :
  Joinable ea eb →
  RcdJoinable ra rb →
  RcdJoinable ((l,ea)::ra) ((l,eb)::rb)
:= by sorry

theorem NStepStar.joinable :
  NStepStar e e' →
  Joinable e e'
:= by
  intro h0
  unfold Joinable
  exists e'
  apply And.intro h0 NStepStar.refl

theorem NRcdStepStar.joinable :
  NRcdStepStar r r' →
  RcdJoinable r r'
:= by
  intro h0
  unfold RcdJoinable
  exists r'
  apply And.intro h0 NRcdStepStar.refl

mutual
  theorem NRcdStep.semi_confluence
    (step : NRcdStep r ra)
    (step_star : NRcdStepStar r rb)
  : RcdJoinable ra rb
  := by
  cases step with
  | @head e ea l r' step' =>
    have ⟨eb,r'',h0,h1,h2⟩ := NRcdStepStar.cons_inversion step_star
    rw [h0]
    have joinable := NStep.semi_confluence step' h1
    have rjoinable := NRcdStepStar.joinable h2
    apply RcdJoinable.cons joinable rjoinable

  | @tail l r ra' e fresh step' =>
    have ⟨e',rb',h0,h1,h2⟩ := NRcdStepStar.cons_inversion step_star
    rw [h0]
    have joinable := NStepStar.joinable h1
    have rjoinable := NRcdStep.semi_confluence step' h2
    apply RcdJoinable.cons joinable rjoinable

  theorem NStep.semi_confluence
    (step : NStep e ea)
    (step_star : NStepStar e eb)
  : Joinable ea eb
  := by cases step with
  | @iso body body_a l step' =>
    have ⟨body_b,h0,step_star'⟩ := NStepStar.iso_inversion step_star
    rw [h0]
    have ih := NStep.semi_confluence step' step_star'
    exact Joinable.iso ih
  | @record r ra step' =>
    have ⟨rb,h0,step_star'⟩ := NStepStar.record_inversion step_star
    rw [h0]

    have ih := NRcdStep.semi_confluence step' step_star'
    exact Joinable.record ih
  | _ => sorry
end


theorem NStepStar.confluence :
  NStepStar e a →
  NStepStar e b →
  Joinable a b
:= by
  intro h0 h1
  apply NStepStar.reverse at h0
  induction h0 with
  | refl =>
    unfold Joinable
    exists b
    apply And.intro h1 .refl
  | @step m a h2 h3 ih =>
    have ⟨b',h4,h5⟩ := ih
    clear ih
    have ⟨n,h6,h7⟩ := NStep.semi_confluence h3 h4
    exists n
    apply And.intro h6
    apply NStepStar.transitive h5 h7

-- mutual
--   theorem NRcdStepStar.universal_nexus :
--     ∃ rn,  ∀ rm , NRcdStepStar r rm → NRcdStepStar rm rn
--   := by cases r with
--   | nil =>
--     exists []
--     intro rm h0
--     cases h0 with
--     | refl => exact NRcdStepStar.refl
--     | step h1 h2 =>
--       cases h1
--   | cons head r =>
--     have (l,e) := head
--     have ⟨e',h0⟩ := @NStepStar.universal_nexus e
--     have ⟨r',ih⟩ := @NRcdStepStar.universal_nexus r
--     exists ((l,e') :: r')
--     intro rm h1
--     have ⟨em,rm',h2,h3,h4⟩ := NRcdStepStar.tail_inversion h1
--     rw [h2]
--     apply NRcdStepStar.tail (h0 em h3) (ih rm' h4)

--   /- TODO: not sure,
--     but this definition might be too strong to prove;
--     there is a common nexus for every finite subset of paths,
--     but there may not be a way to construct a nexus for an infinite set of paths.
--     may need to switch to pair-wise (finite-paths) confluence
--   -/
--   theorem NStepStar.universal_nexus :
--     ∃ en,  ∀ em , NStepStar e em → NStepStar em en
--   := by cases e with
--   | var x =>
--     exists (Expr.var x)
--     intro em h0
--     cases h0 with
--     | refl => exact NStepStar.refl
--     | step h1 h2 =>
--       cases h1
--   | iso label body =>
--     have ⟨body',ih⟩ := @NStepStar.universal_nexus body
--     exists (.iso label body')
--     intro em h0
--     have ⟨bodym,h1,h2⟩ := NStepStar.iso_inversion h0
--     rw [h1]
--     apply NStepStar.iso (ih bodym h2)

--   | record r =>
--     have ⟨r',ih⟩ := @NRcdStepStar.universal_nexus r
--     exists (.record r')
--     intro em h0
--     have ⟨rm,h1,h2⟩ := NStepStar.record_inversion h0
--     rw [h1]
--     apply NStepStar.record (ih rm h2)
--   -- | function f =>
--   --   sorry
--   -- | app cator arg =>
--   --   sorry
--   -- | anno _ t =>
--   --   sorry
--   | _ => sorry
-- end






end Lang.Dynamic
