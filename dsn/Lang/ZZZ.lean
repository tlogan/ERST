import Lang.Basic
import Mathlib.Data.Set.Basic
---------------------------------------------------------------
------ Experimental --------------------------------------------
---------------------------------------------------------------

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


#check WellFounded.fix

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
noncomputable def Even := WellFounded.fix Nat.lt_wfRel.wf Even.F

lemma even_thing {n} : Even n → n ≠ 3 := by
induction n;
case zero => sorry;
case succ n ih => sorry;
