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

theorem StarNStep.transitivity :
  StarNStep e e' → StarNStep e' e'' → StarNStep e e''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3


theorem NStepStar.transitivity :
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
    apply StarNStep.transitivity
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
      apply NStepStar.transitivity h4
      apply NStepStar.step step
      exact refl



theorem NStepStar.app_inversion :
  NStepStar (Expr.app cator arg) e →
  (∃ cator' arg' , e = (Expr.app cator' arg') ∧
    NStepStar cator cator' ∧ NStepStar arg arg'
  ) ∨
  (∃ p body f m, e = Expr.sub m body ∧
    NStepStar cator (.function ((p,body)::f)) ∧
    Expr.pattern_match arg p = some m
  ) ∨
  (arg.is_value ∧ (∃ p body f, e = (.app (.function f) arg) ∧
    NStepStar cator (.function ((p,body)::f)) ∧
    Expr.pattern_match arg p = none
  ))
:= by
  intro h0
  have h1 := NStepStar.reverse h0
  clear h0
  induction h1 with
  | refl =>
    apply Or.inl
    exists cator
    exists arg
    apply And.intro rfl
    apply And.intro NStepStar.refl NStepStar.refl
  | @step em e h2 h3 ih =>
    cases ih with
    | inl h4 =>
      have ⟨cator',arg',h5,h6,h7⟩ := h4
      clear h4
      rw [h5] at h3
      clear h5
      cases h3 with
      | @applicator cator' cator'' _ step =>
        apply Or.inl
        exists cator''
        exists arg'
        simp
        apply And.intro
        {
          apply NStepStar.transitivity h6
          apply NStepStar.step step
          apply NStepStar.refl
        }
        { apply h7 }

      | @applicand arg' arg'' _ step =>
        apply Or.inl
        exists cator'
        exists arg''
        simp
        apply And.intro h6
        apply NStepStar.transitivity h7
        apply NStepStar.step step
        apply NStepStar.refl

      | pattern_match =>
        sorry
      | skip =>
        sorry
    | inr h4 =>
      sorry


inductive NRcdStepStar : List (String × Expr) → List (String × Expr) → Prop
| refl : NRcdStepStar r r
| step : NRcdStep r r' → NRcdStepStar r' r'' → NRcdStepStar r r''

inductive StarNRcdStep : List (String × Expr) → List (String × Expr) → Prop
| refl : StarNRcdStep r r
| step : StarNRcdStep r r' → NRcdStep r' r'' → StarNRcdStep r r''

theorem NRcdStepStar.transitivity :
  NRcdStepStar e e' → NRcdStepStar e' e'' → NRcdStepStar e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)

theorem StarNRcdStep.transitivity :
  StarNRcdStep r r' → StarNRcdStep r' r'' → StarNRcdStep r r''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3

theorem NRcdStepStar.reverse :
  NRcdStepStar r r' → StarNRcdStep r r'
:= by
  intro h0
  induction h0 with
  | refl =>
    exact StarNRcdStep.refl
  | @step e em e' h1 h2 ih =>

    apply StarNRcdStep.transitivity
    { apply StarNRcdStep.step StarNRcdStep.refl h1 }
    { exact ih }


theorem NStepStar.applicand ef :
  NStepStar e e' →
  NStepStar (.app ef e) (.app ef e')
:= by
  intro h0
  induction h0 with
  | refl =>
    apply NStepStar.refl
  | step h1 h2 ih =>
    apply NStepStar.step (NStep.applicand _ h1) ih

theorem NStepStar.app :
  NStepStar ef ef' →
  NStepStar e e' →
  NStepStar (.app ef e) (.app ef' e')
:= by
  intro h0 h1

  induction h0 with
  | @refl e =>
    exact applicand e h1
  | @step ef em ef' h1 h2 ih =>
    apply NStepStar.transitivity
    { apply NStepStar.step (NStep.applicator _ h1) ih }
    { exact refl }


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
      apply NRcdStepStar.transitivity h4
      apply NRcdStepStar.step step
      exact NRcdStepStar.refl

theorem NStepStar.function_inversion :
  NStepStar (.function f) e →
  e = (.function f)
:= by
  intro h0
  cases h0 with
  | refl =>
    rfl
  | step h1 h2 =>
    cases h1

theorem NStepStar.value_inversion :
  e.is_value →
  NStepStar e e' →
  e' = e
:= by
  intro h0 h1
  cases h1 with
  | refl =>
    rfl
  | step h2 h3 =>
    have h4 := NStep.not_value h2 h0
    exact False.elim h4


def Joinable (a b : Expr) :=
  ∃ e , NStepStar a e ∧ NStepStar b e

def RcdJoinable (a b : List (String × Expr)) :=
  ∃ e , NRcdStepStar a e ∧ NRcdStepStar b e


theorem Joinable.swap {a b} :
  Joinable a b →
  Joinable b a
:= by
  unfold Joinable
  intro h0
  have ⟨e,h1,h2⟩ := h0
  exists e

theorem Joinable.refl e:
  Joinable e e
:= by
  unfold Joinable
  exists e
  apply And.intro NStepStar.refl NStepStar.refl

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


theorem Joinable.applicand f :
  Joinable a b →
  Joinable (.app f a) (.app f b)
:= by
  unfold Joinable
  intro h0
  have ⟨c,h1,h2⟩ := h0
  exists (.app f c)
  apply And.intro
  {exact NStepStar.applicand f h1}
  {exact NStepStar.applicand f h2}

theorem Joinable.app :
  Joinable fa fb →
  Joinable arg_a arg_b →
  Joinable (.app fa arg_a) (.app fb arg_b)
:= by
  unfold Joinable
  intro h0 h1
  have ⟨fc,h2,h3⟩ := h0
  have ⟨arg_c,h4,h5⟩ := h1
  clear h0 h1
  exists (.app fc arg_c)
  apply And.intro
  {apply NStepStar.app h2 h4 }
  {exact NStepStar.app h3 h5}



theorem NStepStar.pattern_match :
  Expr.pattern_match arg p = some m →
  NStepStar cator (Expr.function ((p, body) :: f)) →
  NStepStar (Expr.app cator arg) (Expr.sub m body)
:= by
  intro h0 h1
  generalize h2 : (Expr.function ((p, body) :: f)) = cator' at h1
  induction h1 with
  | refl =>
    rw [← h2]
    apply NStepStar.step
    { apply NStep.pattern_match ; exact h0 }
    { exact .refl }
  | step h3 h4 ih =>
    specialize ih h2
    apply NStepStar.step
    { apply NStep.applicator ; exact h3 }
    { exact ih }

theorem Joinable.pattern_match :
  Expr.pattern_match arg p = some m →
  Joinable cator (Expr.function ((p, body) :: f)) →
  Joinable (Expr.app cator arg) (Expr.sub m body)
:= by
  unfold Joinable
  intro h0 h1
  have ⟨en,h2,h3⟩ := h1
  clear h1
  have h4 := NStepStar.function_inversion h3
  rw [h4] at h2
  clear h3 h4
  exists (Expr.sub m body)
  apply And.intro
  { exact NStepStar.pattern_match h0 h2 }
  { exact NStepStar.refl }



theorem NStepStar.skip :
  arg.is_value →
  Expr.pattern_match arg p = none →
  NStepStar cator (Expr.function ((p, body) :: f)) →
  NStepStar (Expr.app cator arg) (Expr.app (Expr.function f) arg)
:= by
  intro h0 h1 h2
  generalize h3 : (Expr.function ((p, body) :: f)) = cator' at h2
  induction h2 with
  | refl =>
    rw [← h3]
    apply NStepStar.step
    { apply NStep.skip body f h0 h1}
    { exact .refl }
  | step h4 h5 ih =>
    specialize ih h3
    apply NStepStar.step
    { apply NStep.applicator ; exact h4 }
    { exact ih }

theorem Joinable.skip :
  arg.is_value →
  Expr.pattern_match arg p = none →
  Joinable cator (Expr.function ((p, body) :: f)) →
  Joinable (Expr.app cator arg) (Expr.app (Expr.function f) arg)
:= by
  unfold Joinable
  intro h0 h1 h2
  have ⟨en,h3,h4⟩ := h2
  have h5 := NStepStar.function_inversion h4
  rw [h5] at h3
  clear h4 h5
  exists ((Expr.app (Expr.function f) arg))
  apply And.intro
  { exact NStepStar.skip h0 h1 h3}
  { exact NStepStar.refl }


theorem NRcdStepStar.cons_inversion :
  NRcdStepStar ((l,e)::r) r' →
  (∃ e' r'' , r' = ((l,e')::r'') ∧ NStepStar e e' ∧ NRcdStepStar r r'')
:= by
  intro h0
  apply NRcdStepStar.reverse at h0
  induction h0 with
  | refl =>
    exists e
    exists r
    simp
    apply And.intro NStepStar.refl NRcdStepStar.refl
  | step h1 h2 ih =>
    have ⟨e',r'',h3,h4,h5⟩ := ih
    rw [h3] at h2
    cases h2 with
    | @head l r''' e' e'' fresh step' =>
      exists e''
      exists r''
      simp
      apply And.intro
      {
        apply NStepStar.transitivity h4
        apply NStepStar.step step' NStepStar.refl
      }
      { exact h5 }
    | @tail l r'' r''' ev fresh step' =>
      exists e'
      exists r'''
      simp
      apply And.intro h4
      apply NRcdStepStar.transitivity h5
      apply NRcdStepStar.step step' NRcdStepStar.refl


theorem NRcdStepStar.head :
  List.is_fresh_key l r →
  NStepStar e e' →
  NRcdStepStar ((l,e)::r) ((l,e')::r)
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact NRcdStepStar.refl
  | @step e em e' h1 h2 ih =>
    apply NRcdStepStar.step
    { apply NRcdStep.head h0 h1 }
    { exact ih }

theorem List.is_fresh_key_nrcd_reduction :
  NRcdStep r r' →
  ∀ {l},
  List.is_fresh_key l r →
  List.is_fresh_key l r'
:= by
  intro h0
  cases h0 with
  | head step' =>
    intro l fresh
    exact fresh
  | tail fresh' step' =>
    intro l fresh
    have ih := @List.is_fresh_key_nrcd_reduction _ _ step'
    simp [List.is_fresh_key] at fresh
    have ⟨h1,h2⟩ := fresh
    clear fresh
    simp [List.is_fresh_key]
    apply And.intro h1
    exact ih h2


theorem List.is_fresh_key_nrcd_star_reduction :
  NRcdStepStar r r' →
  List.is_fresh_key l r →
  List.is_fresh_key l r'
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    apply ih
    exact is_fresh_key_nrcd_reduction h2 h1


theorem List.is_fresh_key_nrcd_expansion :
  NRcdStep r r' →
  ∀ {l},
  List.is_fresh_key l r' →
  List.is_fresh_key l r
:= by
  intro h0
  cases h0 with
  | head step' =>
    intro l fresh
    exact fresh
  | tail fresh' step' =>
    intro l fresh
    have ih := @List.is_fresh_key_nrcd_expansion _ _ step'
    simp [List.is_fresh_key] at fresh
    have ⟨h1,h2⟩ := fresh
    clear fresh
    simp [List.is_fresh_key]
    apply And.intro h1
    exact ih h2

theorem List.is_fresh_key_nrcd_star_expansion :
  NRcdStepStar r r' →
  List.is_fresh_key l r' →
  List.is_fresh_key l r
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    apply List.is_fresh_key_nrcd_expansion
    { exact h2 }
    { exact ih h1 }


theorem NRcdStepStar.cons :
  List.is_fresh_key l r →
  NStepStar e e' →
  NRcdStepStar r r' →
  NRcdStepStar ((l,e)::r) ((l,e')::r')
:= by
  intro h0 h1 h2
  induction h2 with
  | @refl r =>
    exact NRcdStepStar.head h0 h1
  | @step r rm r' h2 h3 ih =>
    apply NRcdStepStar.step
    { apply NRcdStep.tail
      { exact h0 }
      { exact h2 }
    }
    {
      apply ih
      exact List.is_fresh_key_nrcd_reduction h2 h0
    }

theorem NRcdStepStar.tail :
  List.is_fresh_key l r →
  NRcdStepStar r r' →
  NRcdStepStar ((l,e)::r) ((l,e)::r')
:= by
  intro h0 h1
  apply NRcdStepStar.cons h0 NStepStar.refl h1

theorem RcdJoinable.cons :
  (List.is_fresh_key l ra ∨ List.is_fresh_key l rb) →
  Joinable ea eb →
  RcdJoinable ra rb →
  RcdJoinable ((l,ea)::ra) ((l,eb)::rb)
:= by
  unfold Joinable
  unfold RcdJoinable
  intro h0 h1 h2
  have ⟨ec,h4,h5⟩ := h1
  have ⟨rc,h6,h7⟩ := h2
  exists ((l,ec)::rc)
  cases h0 with
  | inl h8 =>
    apply And.intro
    { exact NRcdStepStar.cons h8 h4 h6 }
    {
      have h9 := List.is_fresh_key_nrcd_star_reduction h6 h8
      have h10 := List.is_fresh_key_nrcd_star_expansion h7 h9
      exact NRcdStepStar.cons h10 h5 h7
    }
  | inr h8 =>
    apply And.intro
    {
      have h9 := List.is_fresh_key_nrcd_star_reduction h7 h8
      have h10 := List.is_fresh_key_nrcd_star_expansion h6 h9
      exact NRcdStepStar.cons h10 h4 h6
    }
    { exact NRcdStepStar.cons h8 h5 h7 }


theorem NStep.joinable :
  NStep e e' →
  Joinable e e'
:= by
  intro h0
  unfold Joinable
  exists e'
  apply And.intro
  { apply NStepStar.step h0 NStepStar.refl }
  { exact NStepStar.refl}

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

  theorem List.pattern_match_entry_subject_reduction :
    NRcdStep r r' →
    List.pattern_match_entry l p r = some m →
    ∃ m' , List.pattern_match_entry l p r' = some m'
  := by
    intro h0 h1
    cases h0 with
    | @head l' r e e' fresh step =>
      simp [List.pattern_match_entry] at h1
      by_cases h3 : l' = l
      {
        simp [*] at h1
        have ⟨m',ih⟩ := Expr.pattern_match_subject_reduction step h1
        exists m'
        simp [List.pattern_match_entry, *]
      }
      {
        simp [*] at h1
        exists m
        simp [List.pattern_match_entry, *]
      }

    | @tail l' r r' e fresh step =>
      simp [List.pattern_match_entry] at h1
      by_cases h3 : l' = l
      {
        simp [*] at h1
        exists m
        simp [List.pattern_match_entry, *]

      }
      {
        simp [*] at h1
        have ⟨m',ih⟩ := List.pattern_match_entry_subject_reduction step h1
        exists m'
        simp [List.pattern_match_entry, *]
      }



  theorem List.pattern_match_record_subject_reduction :
    NRcdStep r r' →
    List.pattern_match_record r rp = some m →
    ∃ m' , List.pattern_match_record r' rp = some m'
  := by cases rp with
  | nil =>
    intro h0 h1
    simp [List.pattern_match_record]
  | cons lp rp' =>
    have (l,p) := lp
    intro h0 h1
    simp [List.pattern_match_record] at h1
    have ⟨h2,h3⟩ := h1
    clear h1

    cases h4 : (List.pattern_match_entry l p r) with
    | some m0 =>
      simp [h4] at h3
      cases h5 : (List.pattern_match_record r rp') with
      | some m1 =>
        simp [h5] at h3
        have ⟨h6,h7⟩ := h3
        have ⟨m0',h8⟩ := List.pattern_match_entry_subject_reduction h0 h4
        have ⟨m1',h9⟩ := List.pattern_match_record_subject_reduction h0 h5
        exists (m0' ++ m1')
        simp [List.pattern_match_record, *]

      | none =>
        simp [h5] at h3
    | none =>
      simp [h4] at h3


  theorem Expr.pattern_match_subject_reduction :
    NStep arg arg' →
    Expr.pattern_match arg p = some m →
    ∃ m' , Expr.pattern_match arg' p = some m'
  := by cases p with
  | var x =>
    intro h0 h1
    exists [(x,arg')]
    simp [Expr.pattern_match]
  | iso l p' =>
    intro h0 h1
    cases h0 with
    | @iso e e' l' step =>
      simp [Expr.pattern_match] at h1
      have ⟨h2,h3⟩ := h1
      clear h1
      have ⟨m',ih⟩ := Expr.pattern_match_subject_reduction step h3
      exists m'
      simp [Expr.pattern_match]
      exact ⟨h2, ih⟩
    | _ =>
      simp [Expr.pattern_match] at h1
  | record ps =>
    intro h0 h1
    cases h0 with
    | iso =>
      simp [Expr.pattern_match] at h1
    | @record r r' step =>
      simp [Expr.pattern_match] at h1
      have ⟨m',ih⟩ := List.pattern_match_record_subject_reduction step h1
      exists m'
      simp [Expr.pattern_match]
      exact ih
    | _ =>
      simp [Expr.pattern_match] at h1
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


theorem Expr.pattern_match_subject_star_reduction :
  NStepStar arg arg' →
  ∀ {m},
  Expr.pattern_match arg p = some m →
  ∃ m' , Expr.pattern_match arg' p = some m'
:= by
  intro h0
  induction h0 with
  | refl =>
    intro m h1
    exists m
  | @step arg argm arg' h1 h2 ih =>
    intro m h3
    have ⟨m',h4⟩ := Expr.pattern_match_subject_reduction h1 h3
    apply ih h4

theorem NStep.sub_context_preservation
  m
  (step : NStep body body')
: NStepStar (Expr.sub m body) (Expr.sub m body')
:= sorry


theorem NStepStar.sub_context_preservation
  m
  (step_star : NStepStar body body')
: NStepStar (Expr.sub m body) (Expr.sub m body')
:= by induction step_star with
| @refl body =>
  apply NStepStar.refl
| step h1 h2 ih =>
  have h3 := NStep.sub_context_preservation m h1
  apply NStepStar.transitivity h3 ih


mutual
  theorem NStep.sub_preservation
    x
    (step_arg : NStep arg arg')
    body
  : NStepStar (Expr.sub [(x,arg)] body) (Expr.sub [(x,arg')] body)
  := by cases body with
  | var x' =>
    by_cases h0 : x' = x
    {
      simp [Expr.sub,find,h0]
      apply NStepStar.step step_arg NStepStar.refl
    }
    {
      have h1 : x' ∉ ListPair.dom [(x,arg)] := by
        simp [ListPair.dom] ; exact h0
      have h2 : x' ∉ ListPair.dom [(x,arg')] := by
        simp [ListPair.dom] ; exact h0
      have h3 := Expr.sub_refl h1
      have h4 := Expr.sub_refl h2
      rw [h3,h4]
      apply NStepStar.refl
    }
  | iso l target =>
    simp [Expr.sub]
    have ih := NStep.sub_preservation x step_arg target
    apply NStepStar.iso ih
  | _ => sorry
end

theorem Eq.disjoint_pattern_match_preservation :
  List.pattern_match_entry l p r = some m0 →
  List.pattern_match_record r rp = some m1 →
  Pat.ids p ∩ List.pattern_ids rp = [] →
  ListPair.dom m0 ∩ ListPair.dom m1 = []
:= by sorry

theorem NStepStar.sub_disjoint_concat :
  ListPair.dom m0 ∩ ListPair.dom m1 = [] →
  ListPair.dom m0' ∩ ListPair.dom m1' = [] →
  NStepStar (Expr.sub m0 body) (Expr.sub m0' body) →
  NStepStar (Expr.sub m1 body) (Expr.sub m1' body) →
  NStepStar (Expr.sub (m0 ++ m1) body) (Expr.sub (m0' ++ m1') body)
:= by sorry

mutual

  theorem NStep.pattern_match_entry_preservation
    (step_r : NRcdStep r r')
    (matching_arg : List.pattern_match_entry l p r = some m)
    (matching_arg' : List.pattern_match_entry l p r' = some m')
    body
  : NStepStar (Expr.sub m body) (Expr.sub m' body)
  := by cases step_r with
  | @head l' r'' target target' fresh step' =>
    simp [List.pattern_match_entry] at matching_arg
    simp [List.pattern_match_entry] at matching_arg'
    by_cases h0 : l' = l
    {
      simp [*] at matching_arg
      simp [*] at matching_arg'
      apply NStep.pattern_match_preservation step' matching_arg matching_arg'
    }
    {
      simp [*] at matching_arg
      simp [*] at matching_arg'
      simp [*]
      exact NStepStar.refl
    }
  | @tail l' r'' r''' target fresh step' =>
    simp [List.pattern_match_entry] at matching_arg
    simp [List.pattern_match_entry] at matching_arg'
    by_cases h0 : l' = l
    {
      simp [*] at matching_arg
      simp [*] at matching_arg'
      simp [*]
      exact NStepStar.refl
    }
    {
      simp [*] at matching_arg
      simp [*] at matching_arg'
      apply NStep.pattern_match_entry_preservation step' matching_arg matching_arg'
    }


  theorem NStep.pattern_match_record_preservation
    (step_r : NRcdStep r r')
    (matching_arg : List.pattern_match_record r rp = some m)
    (matching_arg' : List.pattern_match_record r' rp = some m')
    body
  : NStepStar (Expr.sub m body) (Expr.sub m' body)
  := by cases rp with
  | nil =>
    unfold List.pattern_match_record at matching_arg
    simp at matching_arg
    unfold List.pattern_match_record at matching_arg'
    simp at matching_arg'
    simp [*]
    exact NStepStar.refl
  | cons pp rp' =>
    have ⟨l,p⟩ := pp
    simp [List.pattern_match_record] at matching_arg
    simp [List.pattern_match_record] at matching_arg'
    have ⟨h0,h1⟩ := matching_arg
    have ⟨h2,h3⟩ := matching_arg'
    clear matching_arg matching_arg' h0 h2
    cases h4 : (List.pattern_match_entry l p r) with
    | some m0 =>
      cases h5 : (List.pattern_match_record r rp') with
      | some m1 =>
        simp [*] at h1

        have ⟨h6,h7⟩:= h1

        cases h8 : (List.pattern_match_entry l p r') with
        | some m0' =>
          cases h9 : (List.pattern_match_record r' rp') with
          | some m1' =>
            simp [*] at h3
            rw [←h7,←h3]

            have h10 := Eq.disjoint_pattern_match_preservation h4 h5 h6
            have h11 := Eq.disjoint_pattern_match_preservation h8 h9 h6

            have h12 := NStep.pattern_match_entry_preservation step_r h4 h8 body
            have h13 := NStep.pattern_match_record_preservation step_r h5 h9 body

            exact NStepStar.sub_disjoint_concat h10 h11 h12 h13

          | none =>
            simp [*] at h3
        | none =>
          simp [*] at h3
      | none =>
        simp [*] at h1
    | none =>
      simp [*] at h1


  theorem NStep.pattern_match_preservation
    (step_arg : NStep arg arg')
    (matching_arg : Expr.pattern_match arg p = some m)
    (matching_arg' : Expr.pattern_match arg' p = some m')
    body
  : NStepStar (Expr.sub m body) (Expr.sub m' body)
  := by cases p with
  | var x' =>
    simp [Expr.pattern_match] at matching_arg
    simp [Expr.pattern_match] at matching_arg'
    rw [←matching_arg,←matching_arg']
    exact sub_preservation _ step_arg body
  | iso l p' =>
    cases step_arg with
    | @iso target target' l' step_target =>
      simp [Expr.pattern_match] at matching_arg
      simp [Expr.pattern_match] at matching_arg'
      have ⟨h0,h1⟩ := matching_arg
      have ⟨h2,h3⟩ := matching_arg'
      clear h2 matching_arg matching_arg'
      have ih := NStep.pattern_match_preservation step_target h1 h3
      apply ih
    | _ => simp [Expr.pattern_match] at matching_arg
  | record rp =>
    cases step_arg with
    | iso =>
      simp [Expr.pattern_match] at matching_arg
    | @record r r' step_r =>
      simp [Expr.pattern_match] at matching_arg
      simp [Expr.pattern_match] at matching_arg'
      apply NStep.pattern_match_record_preservation step_r matching_arg matching_arg'
    | _ => simp [Expr.pattern_match] at matching_arg
end

theorem NStepStar.pattern_match_preservation :
  NStepStar arg arg' →
  ∀ {m m'},
  Expr.pattern_match arg p = some m →
  Expr.pattern_match arg' p = some m' →
  ∀ body, NStepStar (Expr.sub m body) (Expr.sub m' body)
:= by
  intro h0
  induction h0 with
  | @refl arg =>
    intro m m' h1 h2 body
    rw [h1] at h2
    simp at h2
    rw [← h2]
    apply NStepStar.refl
  | @step arg argm arg' h1 h2 ih =>
    intro m m' h3 h4 body
    have ⟨mm,h5⟩ := Expr.pattern_match_subject_reduction h1 h3
    have h6 := NStep.pattern_match_preservation h1 h3 h5 body
    apply NStepStar.transitivity h6
    apply ih h5
    apply h4

theorem Joinable.subject_star_expansion :
  NStepStar b b' →
  Joinable a b' →
  Joinable a b
:= by
  unfold Joinable
  intro h0 h1
  have ⟨c,h2,h3⟩ := h1
  exists c
  apply And.intro h2
  apply NStepStar.transitivity h0 h3


mutual
  theorem NRcdStep.semi_confluence
    (step : NRcdStep r ra)
    (step_star : NRcdStepStar r rb)
  : RcdJoinable ra rb
  := by
  cases step with
  | @head l r' e ea fresh step' =>
    have ⟨eb,r'',h0,h1,h2⟩ := NRcdStepStar.cons_inversion step_star
    rw [h0]
    have joinable := NStep.semi_confluence step' h1
    have rjoinable := NRcdStepStar.joinable h2
    apply RcdJoinable.cons (Or.inl fresh) joinable rjoinable

  | @tail l r ra' e fresh step' =>
    have ⟨e',rb',h0,h1,h2⟩ := NRcdStepStar.cons_inversion step_star
    rw [h0]
    have joinable := NStepStar.joinable h1
    have rjoinable := NRcdStep.semi_confluence step' h2
    have h4 := List.is_fresh_key_nrcd_star_reduction h2 fresh
    apply RcdJoinable.cons (Or.inr h4) joinable rjoinable

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
  | @applicator cator cator_a arg step' =>
    cases NStepStar.app_inversion step_star with
    | inl h0 =>
      have ⟨cator_b,arg',h1,h2,h3⟩ := h0
      rw [h1]
      clear h0 h1 step_star
      have joinable_cator := NStep.semi_confluence step' h2
      have joinable_arg := NStepStar.joinable h3
      exact Joinable.app joinable_cator joinable_arg
    | inr h0 =>
      cases h0 with
      | inl h1 =>
        have ⟨p,body,f,m,h2,h3,h4⟩ := h1
        rw [h2]
        clear h1 h2 step_star
        have joinable_cator := NStep.semi_confluence step' h3
        exact Joinable.pattern_match h4 joinable_cator

      | inr h1 =>
        have ⟨isval, p, body, f,h2,h3,h4⟩ := h1
        rw [h2]
        clear h1 h2 step_star
        have joinable_cator := NStep.semi_confluence step' h3
        exact Joinable.skip isval h4 joinable_cator

  | @applicand arg arg_a cator step' =>
    cases NStepStar.app_inversion step_star with
    | inl h0 =>
      have ⟨cator',arg_b,h1,h2,h3⟩ := h0
      clear h0
      rw [h1]
      clear h1 step_star
      have joinable_cator := NStepStar.joinable h2
      have joinable_arg := NStep.semi_confluence step' h3
      exact Joinable.app joinable_cator joinable_arg
    | inr h0 =>
      cases h0 with
      | inl h1 =>
        have ⟨p,body,f,m,h2,h3,h4⟩ := h1
        rw [h2]
        clear h1 h2 step_star
        have ⟨m',h5⟩ := Expr.pattern_match_subject_reduction step' h4
        have h6 := NStep.pattern_match_preservation step' h4 h5 body
        apply Joinable.subject_star_expansion h6
        have joinable_cator := NStepStar.joinable h3
        exact Joinable.pattern_match h5 joinable_cator

      | inr h1 =>
        have ⟨isval, p, body, f,h2,h3,h4⟩ := h1
        have h5 := NStep.not_value step' isval
        exact False.elim h5

  | @pattern_match arg p m body f matching =>
    cases NStepStar.app_inversion step_star with
    | inl h0 =>
      have ⟨cator,arg',h1,h2,h3⟩ := h0
      rw [h1]
      clear step_star h0 h1
      have h4 := NStepStar.function_inversion h2
      rw [h4]
      clear h2 h4

      have ⟨m',h5⟩ := Expr.pattern_match_subject_star_reduction h3 matching
      have h6 := NStepStar.pattern_match_preservation h3 matching h5 body
      apply Joinable.swap
      apply Joinable.subject_star_expansion h6
      apply Joinable.pattern_match h5
      apply Joinable.refl

    | inr h0 =>
      cases h0 with
      | inl h1 =>
        have ⟨p',body',f',m',h2,h3,h4⟩ := h1
        rw [h2]
        clear step_star h1 h2
        have h5 := NStepStar.function_inversion h3
        simp at h5
        have ⟨⟨h6,h7⟩,h8⟩ := h5
        clear h5
        rw [h7]
        clear h7
        rw [h6] at h4
        clear h6 h8
        rw [matching] at h4
        simp at h4
        rw [← h4]
        apply Joinable.refl

      | inr h1 =>
        have ⟨isval,p',body',f',h2,h3,h4⟩ := h1
        rw [h2]
        clear step_star h1 h2
        have h5 := NStepStar.function_inversion h3
        simp at h5
        have ⟨⟨h6,h7⟩,h8⟩ := h5
        clear h5
        rw [h6] at h4
        simp [matching] at h4

  | @skip arg p body f isval h0 =>
    cases NStepStar.app_inversion step_star with
    | inl h1 =>
      have ⟨cator,arg',h2,h3,h4⟩ := h1
      rw [h2]
      clear step_star h1 h2
      apply NStepStar.value_inversion isval at h4
      rw [h4]
      clear h4
      have h5 := NStepStar.function_inversion h3
      rw [h5]
      clear h5
      apply Joinable.swap
      apply Joinable.skip isval h0
      apply Joinable.refl
    | inr h1 =>
      cases h1 with
      | inl h2 =>
        have ⟨p',body',f',m,h3,h4,h5⟩ := h2
        rw [h3]
        clear step_star h2 h3

        have h6 := NStepStar.function_inversion h4
        simp at h6
        have ⟨⟨h7,h8⟩,h9⟩ := h6
        clear h4 h6
        rw [h8]
        rw [h7] at h5
        rw [h0] at h5
        simp at h5

      | inr h2 =>
        have ⟨isval',p',body',f',h3,h4,h5⟩ := h2
        rw [h3]
        clear step_star h2 h3
        have h6 := NStepStar.function_inversion h4
        simp at h6
        have ⟨⟨h7,h8⟩,h9⟩ := h6
        rw [h9]
        apply Joinable.refl

  -- | @loopi body body' step=>

    -- have ⟨body_b,h0,step_star'⟩ := NStepStar.loop_inversion step_star
    -- rw [h0]
    -- have ih := NStep.semi_confluence step' step_star'
    -- exact Joinable.iso ih
    -- sorry
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
    apply NStepStar.transitivity h5 h7



theorem NStep.local_confluence :
  NStep e a →
  NStep e b →
  Joinable a b
:= by
  intro h0 h1
  apply NStep.semi_confluence
  { exact h0 }
  { apply NStepStar.step h1 NStepStar.refl }


theorem Joinable.transitivity {a b c} :
  Joinable a b →
  Joinable b c →
  Joinable a c
:= by
  unfold Joinable
  intro h0 h1
  have ⟨e0,h2,h3⟩ := h0
  have ⟨e1,h4,h5⟩ := h1
  have ⟨e',h6,h7⟩ := NStepStar.confluence h3 h4
  exists e'
  apply And.intro
  { exact NStepStar.transitivity h2 h6 }
  { exact NStepStar.transitivity h5 h7 }

end Lang.Dynamic
