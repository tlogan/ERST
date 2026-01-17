import Lean
import Mathlib.Tactic.Linarith


#check Lean.mkFreshId
def fresh_typ_id {m : Type → Type} [Monad m] [Lean.MonadNameGenerator m] : m String :=
  do
  let raw := (← Lean.mkFreshId).toString
  let content :=  "T" ++ raw.drop ("_uniq.".length + 3)
  return content

def Lean.Parser.parse (cat : Lean.Name) (str : String) : Lean.CoreM (Lean.TSyntax cat) := do
  let env ← Lean.getEnv
  match Lean.Parser.runParserCategory env cat str with
  | .ok stx => return Lean.TSyntax.mk stx
  | .error err => throwError err

def seq_as_tactic (stx : Lean.TSyntax `tactic.seq) : Lean.TSyntax `tactic :=
  ⟨Lean.TSyntax.raw stx⟩

def mk_witness_tactic
  (extract_inputs : Lean.Expr → List Lean.Expr)
  (construct_outputs : (List Lean.Expr) → (Lean.MetaM (List Lean.Term)))
: Lean.Elab.Tactic.TacticM Unit
:=
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    let inputs := extract_inputs goalType
    -- for input in inputs do
    --   dbg_trace f!"INPUT::: {repr input}"

    let outputs ← (construct_outputs inputs)

    let mut exists_tact ← `(tactic| skip)
    for output in outputs do
      -- dbg_trace f!"OUTPUT::: {repr output}"
      exists_tact := seq_as_tactic (← `(tactic| $exists_tact ; exists $output))

    -- dbg_trace f!"EXISTS TACT::: {Lean.Syntax.prettyPrint exists_tact}"

    Lean.Elab.Tactic.evalTactic (← `(tactic| $exists_tact))


--------------------------


def ListPair.dom {α} {β} : List (α × β) → List α
| .nil => .nil
| (a, _) :: xs => a :: dom xs


def remove {α} (id : String) : List (String × α) →  List (String × α)
| .nil => .nil
| (key, e) :: m =>
  if key == id then
    m
  else
    (key, e) :: (remove id m)

def remove_all {α} (m : List (String × α)) : (ids : List String) →  List (String × α)
| .nil => m
| id :: remainder => remove_all (remove id m) remainder

def find {α} (id : String) : List (String × α) → Option α
| .nil => none
| (key, e) :: m =>
  if key == id then
    some e
  else
    find id m



theorem ListPair.mem_concat_disj {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom (am1 ++ am0) →
  x ∈ ListPair.dom am1 ∨ x ∈ ListPair.dom am0
:= by induction am1 with
  | nil =>
    simp [dom]
  | cons a am1' ih =>
    simp [dom]
    intro p
    cases p with
    | inl h =>
      simp [*]
    | inr h =>
      have h := ih h
      cases h with
      | inl h' =>
        simp [*]
      | inr h' =>
        simp [*]

theorem ListPair.mem_disj_concat_left {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom am1 →
  x ∈ ListPair.dom (am1 ++ am0)
:= by induction am1 with
  | nil => simp [dom]
  | cons a am1' ih =>
    simp [dom]
    intro p
    cases p with
    | inl h =>
      simp [*]
    | inr h =>
      have h := ih h
      simp [*]

theorem ListPair.mem_disj_concat_right {β}
  (x : String) (am0 am1 : List (String × β))
:
  x ∈ ListPair.dom am0 →
  x ∈ ListPair.dom (am1 ++ am0)
:= by induction am1 with
  | nil => simp
  | cons a am1' ih =>
    simp [dom]
    intro p
    have p := ih p
    simp [*]


theorem removeAll_refl {α} [BEq α] {xs ys : List α}:
   List.removeAll xs ys ⊆ xs
:= by sorry

theorem containment_removeAll_concat_elim {α} [BEq α] {xs ys : List α}:
   List.removeAll (xs ++ ys) ys ⊆ xs
:= by sorry

theorem containment_removeAll_union_elim {α} [BEq α] {xs ys : List α}:
   List.removeAll (xs ∪ ys) ys ⊆ xs
:= by sorry


theorem removeAll_right_sub_cons_eq y {xs ys : List String} :
  y ∈ ys → List.removeAll xs ys = List.removeAll xs (y :: ys)
:= by sorry

theorem removeAll_left_sub_refl_disjoint {xs ys : List String} :
  List.removeAll xs ys ∩ ys = []
:= by sorry


theorem removeAll_concat_eq {xs ys zs : List String} :
  ys ⊆ zs →
  List.removeAll xs zs = List.removeAll xs (ys ++ zs)
:= by induction ys with
  | nil =>
    simp
  | cons y ys' ih =>
    intro ss
    have p0 : y ∈ zs := by
      apply ss
      exact List.mem_cons_self
    have p1 : ys' ⊆ zs := by
      intro x m
      apply ss
      exact List.mem_cons_of_mem y m
    rw [ih p1]
    apply removeAll_right_sub_cons_eq
    exact List.mem_append_right ys' p0

theorem removeAll_concat_containment_left {xs ys zs : List String} :
  List.removeAll xs (ys ++ zs) ⊆ List.removeAll xs ys
:= by sorry

theorem removeAll_concat_containment_right {xs ys zs : List String} :
  List.removeAll xs (ys ++ zs) ⊆ List.removeAll xs zs
:= by sorry


theorem concat_right_containment {xs ys zs : List String} :
  (xs ++ ys) ⊆ zs → ys ⊆ zs
:= by
  intro p0
  intro a p1
  apply p0
  exact List.mem_append_right xs p1


theorem removeAll_decreasing_containment {xs ys zs : List String} :
ys ⊆ zs → List.removeAll xs zs ⊆ List.removeAll xs ys
:= by
  intro ss
  intro x dz
  apply removeAll_concat_containment_left
  rw [← removeAll_concat_eq] <;> assumption


theorem removeAll_increasing_containment {xs : List String} :
  ∀ ys zs, ys ⊆ zs → List.removeAll ys xs ⊆ List.removeAll zs xs
:= by induction xs with
  | nil =>
    simp [List.removeAll]
    exact fun ys zs a ↦ List.filter_subset (fun x ↦ true) a
  | cons x xs ih =>
    intro ys zs ss
    simp [List.removeAll]
    exact List.filter_subset (fun x_1 ↦ !decide (x_1 = x) && !decide (x_1 ∈ xs)) ss


theorem dom_concat_removeAll_containment {β} {am0 am1 : List (String × β)} {xs xs_im xs'} :
  xs ⊆ xs_im → ListPair.dom am0 ⊆ List.removeAll xs_im xs →
  xs_im ⊆ xs' → ListPair.dom am1 ⊆ List.removeAll xs' xs_im →
  ListPair.dom (am1 ++ am0) ⊆ List.removeAll xs' xs
:= by
  intros ss0 dd0 ss1 dd1
  induction am1 with
  | nil =>
    simp [*]
    have ss1' : List.removeAll xs_im xs ⊆ List.removeAll xs' xs := by
      apply removeAll_increasing_containment; simp [*]
    intro x p
    apply ss1'
    apply dd0
    simp [*]
  |cons a am1' ih =>
    let (x, v) := a
    simp [ListPair.dom]
    apply And.intro
    {
      apply removeAll_decreasing_containment ss0
      apply dd1
      simp [ListPair.dom]
    }
    {
      apply ih
      intro y1 p1
      apply dd1
      simp [ListPair.dom]
      apply Or.inr
      assumption
    }


theorem List.cons_containment {α} [BEq α] {x : α} {xs ys : List α} :
  x :: xs  ⊆ ys → x ∈ ys ∧ xs ⊆ ys
:= by
  intro p0
  apply And.intro
  {
    apply p0
    simp [*]
  }
  {
    intro y p1
    apply p0
    simp [*]
  }

-- #print List.inter

#print decide

example {α} [DecidableEq α] (x : α) (xs : List α) :
  List.contains xs x =  decide (x ∈ xs)
:= by exact List.contains_eq_mem x xs


theorem List.not_mem_cons {α} [BEq α] {x x': α} {xs : List α} :
  x ∉ (x' :: xs) →
  x ≠ x' ∧ x ∉ xs
:= by intro p ; exact ne_and_not_mem_of_not_mem_cons p

-- set_option pp.notation false in
theorem List.nonmem_to_disjoint_right {α} [DecidableEq α] (x : α) (xs : List α) :
  x ∉ xs → xs ∩ [x] = []
:= by
  intro h
  induction xs with
  | nil => exact rfl
  | cons y ys ih =>
    simp [Inter.inter, List.inter]

    have ⟨l,r⟩ := ne_and_not_mem_of_not_mem_cons h
    apply And.intro
    { exact id (Ne.symm l) }
    { intros x'' p ; exact (ne_of_mem_of_not_mem p r) }


theorem List.disjoint_preservation_left {α} [BEq α] {xs ys zs : List α} :
  xs ⊆ ys → ys ∩ zs = [] → xs ∩ zs = []
:= by
  simp [Inter.inter, List.inter]
  intro p0
  induction xs with
  | nil =>
    intro p1; intro a;
    intro p2
    cases p2
  | cons x xs' ih =>
    intro p1
    have ⟨p2, p3⟩ := List.cons_containment p0
    intro a
    intro p4
    cases p4 with
    | head =>
      exact p1 x p2
    | tail _ p5 =>
      apply ih p3 p1
      exact p5

theorem List.disjoint_preservation_right {α} [BEq α] {xs ys zs : List α} :
  ys ⊆ zs → xs ∩ zs = [] → xs ∩ ys = []
:= by
  simp [Inter.inter, List.inter]
  intro p0
  induction xs with
  | nil =>
    intro p1; intro a;
    intro p2
    cases p2
  | cons x xs' ih =>
    intro p1
    sorry

theorem List.disjoint_concat_right {α} [BEq α] {xs ys zs : List α} :
  xs ∩ (ys ++ zs) = [] → xs ∩ ys = [] ∧ xs ∩ zs = []
:= by sorry


theorem List.inter_empty_eq_empty {α} [BEq α] {ys : List α} :
  ys ∩ [] = []
:= by
  cases ys with
  | nil => exact rfl
  | cons x xs =>
    simp [Inter.inter, List.inter]


theorem List.disjoint_swap {α} [BEq α] {xs ys : List α} :
  xs ∩ ys = [] → ys ∩ xs = []
:= by
  intros
  induction xs with
  | nil => exact inter_empty_eq_empty
  | cons => sorry


inductive ReflTrans (R : α → α → Prop) : α → α → Prop
| refl e : ReflTrans R e e
| step : R e e' → ReflTrans R e' e'' → ReflTrans R e e''


inductive ReflTransLeft (R : α → α → Prop) : α → α → Prop
| refl e : ReflTransLeft R e e
| step : ReflTransLeft R e e' → R e' e'' → ReflTransLeft R e e''

theorem ReflTransLeft.transitivity :
  ReflTransLeft R e e' → ReflTransLeft R e' e'' → ReflTransLeft R e e''
:= by
  intro h0 h1
  induction h1 with
  | refl =>
    exact h0
  | step h2 h3 ih =>
    exact step ih h3


theorem ReflTrans.transitivity :
  ReflTrans R e e' → ReflTrans R e' e'' → ReflTrans R e e''
:= by
  intro h0 h1
  induction h0 with
  | refl =>
    exact h1
  | step h2 h3 ih =>
    exact step h2 (ih h1)

theorem ReflTrans.reverse :
  ReflTrans R e e' → ReflTransLeft R e e'
:= by
  intro h0
  induction h0 with
  | refl e =>
    exact ReflTransLeft.refl e
  | @step e em e' h1 h2 ih =>
    apply ReflTransLeft.transitivity
    {
      apply ReflTransLeft.step
      { exact ReflTransLeft.refl e }
      { exact h1 }
    }
    { exact ih }

def Joinable (R : α → α → Prop) (ea eb : α) :=
  ∃ en , R ea en ∧ R eb en

theorem Joinable.refl_trans_right_expansion :
  R e e' →
  Joinable (ReflTrans R) ea e' →
  Joinable (ReflTrans R) ea e
:= by
  unfold Joinable
  intro h0 h1
  have ⟨en,h2,h3⟩ := h1
  clear h1
  exists en
  apply And.intro
  { exact h2 }
  { exact ReflTrans.step h0 h3 }

theorem Joinable.symm {a b} :
  Joinable R a b →
  Joinable R b a
:= by
  unfold Joinable
  intro h0
  have ⟨e,h1,h2⟩ := h0
  exists e

theorem Joinable.refl e:
  Joinable (ReflTrans R) e e
:= by
  unfold Joinable
  exists e
  apply And.intro
  { exact ReflTrans.refl e}
  { exact ReflTrans.refl e}
