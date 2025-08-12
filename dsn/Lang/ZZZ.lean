import Lang.Basic
import Mathlib.Data.Set.Basic
---------------------------------------------------------------
------ Experimental --------------------------------------------
---------------------------------------------------------------
theorem test (p q : Prop) (hp : p) (hq : q) : p ∧ q ∧ p := by
  apply And.intro
  case left => exact hp
  case right =>
    apply And.intro
    case left => exact hq
    case right => exact hp

#check And.intro

theorem testB (p q : Prop) (hp : p) (hq : q) : p ∧ q ∧ p := by
  apply And.intro
  . exact hp
  . apply And.intro
    . exact hq
    . exact hp

example (p q r : Prop) : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) := by
  apply Iff.intro
  . intro h
    apply Or.elim (And.right h)
    . intro hq
      apply Or.inl
      apply And.intro
      . exact And.left h
      . exact hq
    . intro hr
      apply Or.inr
      apply And.intro
      . exact And.left h
      . exact hr
  . intro h
    apply Or.elim h
    . intro hpq
      apply And.intro
      . exact And.left hpq
      . apply Or.inl
        exact And.right hpq
    . intro hpr
      apply And.intro
      . exact And.left hpr
      . apply Or.inr
        exact And.right hpr

example : ∀ a b c : Nat, a = b → a = c → c = b := by unhygienic
  intros
  apply Eq.trans
  apply Eq.symm
  exact a_2
  exact a_1

example : ∀ a b c : Nat, a = b → a = c → c = b := by
  intros
  apply Eq.trans
  apply Eq.symm
  . assumption
  . assumption

  repeat assumption

example : ℕ := by
exact 0

example (x : Nat) : x = x := by
  revert x
  intro y
  rfl

example : 3 = 3 := by
  generalize 3 = x
  revert x
  intro y
  rfl
example : 2 + 3 = 5 := by
  generalize h : 3 = x
  rw [← h]

example (p q : Prop) : p ∨ q → q ∨ p := by
  intro h
  cases h with
  | inl hp => apply Or.inr; exact hp
  | inr hq => apply Or.inl; exact hq

example {α} (p q : α → Prop) : (∃ x, p x ∨ q x) → ∃ x, q x ∨ p x := by
  intro
  | ⟨w, Or.inl h⟩ => exact ⟨w, Or.inr h⟩
  | ⟨w, Or.inr h⟩ => exact ⟨w, Or.inl h⟩

example (p q : Prop) : p ∨ q → q ∨ p := by
  intro
  | Or.inl hp => apply Or.inr; exact hp
  | Or.inr hq => apply Or.inl; exact hq

example (p q : Nat → Prop) : (∃ x, p x) → ∃ x, p x ∨ q x := by

  intro h
  cases h with
  | intro x px =>
    constructor;
    apply Or.inl;
    exact px

example (n : Nat) : n + 1 = Nat.succ n := by
  -- show Nat.succ n = Nat.succ n
  change Nat.succ n = Nat.succ n
  rfl

#check (Nat.add_comm)
#check (fun b => (Nat.add_comm b))

example (a b c : Nat) : a + b + c = a + c + b := by
  rw [Nat.add_assoc, Nat.add_comm b]
  rw [ ← Nat.add_assoc]

#check Nat.add_assoc

example (a b c : Nat) : a + b + c = a + c + b := by
  rw [Nat.add_assoc, Nat.add_assoc, Nat.add_comm b]

example (a b c : Nat) : a + b + c = a + c + b := by
  rw [Nat.add_assoc, Nat.add_assoc, Nat.add_comm _ b]

def f (x y z : Nat) : Nat :=
  match x, y, z with
  | 5, _, _ => y
  | _, 5, _ => y
  | _, _, 5 => y
  | _, _, _ => 1

example (w x y z : Nat) : x ≠ 5 → y ≠ 5 → z ≠ 5 → z = w → f x y w = 1 := by
  intros
  simp [f]
  split
  . contradiction
  . contradiction
  . contradiction
  . rfl

example (w x y z : Nat) : x ≠ 5 → y ≠ 5 → z ≠ 5 → z = w → f x y w = 1 := by
  intros
  simp [f]
  split
  . contradiction
  . contradiction
  . contradiction
  . rfl





def x : List String := ["x"]
def y := ["y"]
#check x ++ y

inductive MyAcc.{u} {α : Sort u} (r : α -> α -> Prop) : α -> Prop
| intro (x : α): (∀ y, r y x -> MyAcc r y) -> MyAcc r x

open Nat

theorem div_lemma {x y : Nat} : 0 < y ∧ y ≤ x → x - y < x :=
  fun h => sub_lt (Nat.lt_of_lt_of_le h.left h.right) h.left

def div.F (x : Nat) (f : (x₁ : Nat) → x₁ < x → Nat → Nat) (y : Nat) : Nat :=
  if h : 0 < y ∧ y ≤ x then
    f (x - y) (div_lemma h) y + 1
  else
    zero

-- noncomputable def div := WellFounded.fix (measure id).wf div.F
noncomputable def div := WellFounded.fix (Nat.lt_wfRel.wf) div.F


-- def div (x y : Nat) : Nat :=
--   if h : 0 < y ∧ y ≤ x then
--     have : x - y < x := Nat.sub_lt (Nat.lt_of_lt_of_le h.1 h.2) h.1
--     (div (x - y) y) + 1
--   else
--     0

-- #eval div 8 2

lemma div_thing (x y z) : div x y = z → x ≠ 3 := by
intro d
induction d;
sorry


lemma h : ∀ n : Nat, n < .succ (.succ n) := sorry

def is_even.F (x : Nat) (f : (x' : Nat) -> x' < x -> Bool) : Bool :=
match x with
| .zero => true
| .succ .zero  => false
| .succ (.succ n)  =>
    f n (h n)

noncomputable def is_even := WellFounded.fix (Nat.lt_wfRel.wf) is_even.F

lemma is_even_thing (n z) : is_even n = z → n ≠ 3 := by
induction n
case zero => sorry;
case succ n ih => sorry;


-- inductive Even.F : ∀ x : Nat, (∀ x' : Nat, x' < x -> Prop) → Prop
-- | z P : Even.F Nat.zero P
-- | ss n P: P n (h n) -> Even.F (.succ (.succ n)) P

--NOTE: well-founded defs should use def instead of inductive definition

def Even.F (x : Nat) (P : ∀ x' : Nat, x' < x -> Prop) : Prop :=
match x with
| .zero => True
| .succ .zero => False
| .succ (.succ n)  =>
    P n (h n)

#check Nat.lt_wfRel
#check Nat.lt_wfRel.wf
#check id
#check measure id
#check WellFoundedRelation
#check WellFounded.fix
noncomputable def even := WellFounded.fix Nat.lt_wfRel.wf Even.F

lemma even_thing {n} : Even n → n ≠ 3 := by
induction n;
case zero => sorry;
case succ n ih => sorry;


structure Thing where
  mk ::
  uno : String

inductive T
| base (base : String)
| step (step : T)

def p := T.base "uno"
#eval p
def pt : Thing := ⟨"uno"⟩
#eval p.step
#eval pt.uno
