import Lang.Basic
import Mathlib.Data.Set.Basic

set_option pp.fieldNotation false

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

elab "custom_sorry_1" : tactic =>
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    dbg_trace f!"goal type: {goalType}"

example : 1 = 2 := by
  custom_sorry_1
-- goal type: Eq.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))
-- unsolved goals: ⊢ 1 = 2
  sorry


open Lean.Elab.Tactic in
elab "custom_let " n:ident " : " t:term " := " v:term : tactic =>
  withMainContext do
    let t ← elabTerm t none
    let v ← elabTermEnsuringType v t
    liftMetaTactic fun mvarId => do
      let mvarIdNew ← mvarId.define n.getId t v
      let (_, mvarIdNew) ← mvarIdNew.intro1P
      return [mvarIdNew]


open Lean.Elab.Tactic
#check liftMetaTactic
#check Lean.MVarId.assert

#check List.get

def foo (x : Nat) := x

#check (foo <| 2 + 3)
#check (2 + 3 |> foo)

elab "remove_goals" : tactic =>
  Lean.Elab.Tactic.withMainContext do
    let goals : List Lean.MVarId ← Lean.Elab.Tactic.getGoals
    Lean.Elab.Tactic.setGoals []
    if h : 0 < List.length goals then
      Lean.Elab.Tactic.setGoals [List.get goals ⟨0, h⟩]
    else
      Lean.Elab.Tactic.setGoals []

mutual
  partial def ff (n : Nat) : Nat :=
    if n == 0 then 0 else gg (n - 1)

  partial def gg (n : Nat) : Nat :=
    if n == 0 then 1 else ff (n - 1)
end

partial def forever : Nat → Nat
| 0 => 0
| n + 1 => forever n + 2


#eval (forever 0)

inductive Beep : Nat → Prop
| intro : Beep 0

-- lemma forever_eq : forever 0 = 0 := by
--   native_decide

-- example : ∃ n, Beep n := by
--   exists (forever 0)
--   -- simp [forever_eq]
--   apply Beep.intro

-- import Lean
open Lean

inductive Foo where
  | mk (x : Nat) (y : Bool)
deriving Lean.ToExpr, Repr


#eval Lean.toExpr (Foo.mk 1 .true)


syntax "dumb" : tactic
elab_rules : tactic
| `(tactic| dumb) =>
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    dbg_trace f!"INPUT::: {repr goalType}"


inductive Four : Nat → Prop

-- example : Four 4  := by
--   dumb


-- syntax "witness_pat_lifting_static" : tactic
-- #check Lean.PrettyPrinter.delab

-- def extract_exists_body : Nat → Lean.Expr → Option Lean.Expr
-- | 0, e => .some e
-- | (n + 1), (.app _ (.lam _ _ target _)) => extract_exists_body n target
-- | _, _ => .none

-- def linearize_application : Lean.Expr → List Lean.Expr
-- | .app cator cand => cand :: (linearize_application cator)
-- | target => [target]


-- def delab := Lean.PrettyPrinter.delab

-- def fresh_placeholder := do
--   let u ← Lean.Meta.mkFreshLevelMVar
--   Lean.Meta.mkFreshExprMVar (.some (Lean.mkSort u))

-- mutual
--   def ListPatLifting.static
--     (base : String) (count : Nat) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : List (String × Pat) →  (Typ × List (Typ × Typ) × List (String × Typ))
--   | [] => (Typ.top, Δ, Γ)
--   | (l,p) :: [] =>
--     let (t, Δ', Γ') := PatLifting.static base (count + 1) Δ Γ p
--     (Typ.entry l t, Δ', Γ')

--   | (l,p) :: remainder =>
--     let (t, Δ', Γ') := PatLifting.static base (count + 1) Δ Γ p
--     let (t', Δ'', Γ'') := ListPatLifting.static base (count + 1) Δ' Γ' remainder
--     (Typ.inter (Typ.entry l t) t', Δ'', Γ'')

--   def PatLifting.static
--     (base : String) (count : Nat) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : Pat → (Typ × List (Typ × Typ) × List (String × Typ))
--   | .var id =>
--     let t := Typ.var (base ++ "_" ++ (toString count))
--     let Δ' := (t, Typ.top) :: Δ
--     let Γ' := ((id, t) :: (remove id Γ))
--     (t, Δ', Γ')
--   | .unit => (Typ.unit, Δ, Γ)
--   | .record items => ListPatLifting.static base (count + 1) Δ Γ items
-- end


-- elab_rules : tactic
-- | `(tactic| witness_pat_lifting_static) =>
--   mk_witness_tactic (fun x =>
--     match extract_exists_body 3 x with
--     | .some body => linearize_application body
--     | .none => []
--   ) (fun
--     | [_, _, _, p, Γ, Δ, _] => do
--       let base := Lean.mkStrLit (← Lean.mkFreshId).toString
--       let triple ← `($(Lean.mkIdent `PatLifting.static)
--         $(← delab base) 0 $(← delab Δ) $(← delab Γ) $(← delab p))
--       return [
--         ← `(($triple).fst),
--         ← `(($triple).snd.fst),
--         ← `(($triple).snd.snd)
--       ]
--     | _ => return []
--   )


-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ p[myvar] t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ .unit t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ (.record []) t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ (Pat.record [("dos", Pat.unit)]) t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ p[<uno>@ <dos>@] t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ (Pat.record [("dos", p[dos])]) t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static

-- example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ p[<uno> uno <dos> dos] t Δ' Γ' := by
--   witness_pat_lifting_static
--   prove_pat_lifting_static


-- namespace Typ
-- inductive Pat
-- | unit
-- | entry : String → Pat → Pat
-- | inter : Pat → Pat → Pat
-- | top
-- deriving Repr

-- def Pat.size : Pat → Nat
-- | .unit => 1
-- | .entry l body => size body + 1
-- | .inter left right => size left + size right + 1
-- | .top => 3

-- def Pat.toTyp : Pat → Typ
-- | .unit => .unit
-- | .entry l body => .entry l (toTyp body)
-- | .inter left right => .inter (toTyp left) (toTyp right)
-- | .top => .all ["T"] [] (.var "T")

-- theorem stf_typ_size {s} : Pat.size s = Typ.size (Pat.toTyp s) := by
-- induction s
-- case unit => rfl
-- case entry l body ih =>
--   simp [Pat.toTyp, Pat.size, ih, Typ.size]
-- case inter left right ihl ihr =>
--   simp [Pat.toTyp, Pat.size, ihl, ihr, Typ.size]
-- case top =>
--   simp [Pat.toTyp, Typ.size, ListPairTyp.size, Pat.size]


-- declare_syntax_cat stf

-- syntax "@" : stf
-- syntax "TOP" : stf
-- syntax "<" ident ">" stf : stf
-- syntax stf "&" stf : stf

-- syntax "s[" stf "]" : term

-- macro_rules
-- | `(s[ TOP ]) => `(Pat.top)
-- | `(s[ @ ]) => `(Pat.unit)
-- | `(s[ < $i:ident > $s:stf  ]) => `(Pat.entry i[$i] s[$s])
-- | `(s[ $x:stf & $y:stf]) => `(Pat.inter s[$x] s[$y])

-- class PatOf (_ : Typ) where
--   default : Pat

-- instance : PatOf t[TOP] where
--   default := s[TOP]

-- instance : PatOf t[@] where
--   default := s[@]

-- instance (label : String) (result : Typ) [s : PatOf result]
-- : PatOf (Typ.entry label result)  where
--   default := Pat.entry label s.default

-- instance
--   (left : Typ) [l : PatOf left]
--   (right : Typ) [r : PatOf right]
-- : PatOf (Typ.inter left right)  where
--   default := Pat.inter l.default r.default
-- end Typ


-- inductive Subtyping.Restricted (Θ : List String) (Δ : List (Typ × Typ)) : Typ → Typ → Prop
-- | pat_intro {lower upper}:
--   Typ.is_pattern [] upper →
--   Subtyping.Restricted Θ Δ lower upper

-- | var_elim {id i upper}:
--   id ∉ Θ →
--   Typ.interpret_one id .true Δ = i →
--   (Typ.toBruijn 0 [] i) = (Typ.toBruijn 0 [] .bot) →
--   Subtyping.Restricted Θ Δ (.var id) upper

-- | lfp_intro {lower fids id body }:
--   Typ.free_vars lower = fids →
--   Typ.is_pattern fids lower →
--   ∀ fid, fid ∈ fids → (
--     fid ∉ Θ ∧
--     ∃ i, Typ.interpret_one fid .true Δ = i ∧
--     (Typ.toBruijn 0 [] i) = (Typ.toBruijn 0 [] .bot)
--   ) →
--   Typ.Monotonic id .true body →
--   Typ.Decreasing id body →
--   Subtyping.Restricted Θ Δ lower (.lfp id body)

-- inductive ListSubtyping.Restricted (Θ : List String) (Δ : List (Typ × Typ))
-- : List (Typ × Typ) → Prop
-- | nil :
--   ListSubtyping.Restricted Θ Δ []
-- | cons {l r sts} :
--   Subtyping.Restricted Θ Δ l r →
--   ListSubtyping.Restricted Θ Δ sts →
--   ListSubtyping.Restricted Θ Δ ((l,r) :: sts)



universe u
-- instance {α : Type u} [DecidableEq α] : DecidableEq (α × α)
-- | (a1, a2), (b1, b2) =>
--   if h1 : a1 = b1 then
--     if h2 : a2 = b2 then
--       isTrue (by simp_all)
--     else
--       isFalse (by simp_all)
--   else
--     isFalse (by simp_all)


-- def List.mk_decidable {α : Type u} [DecidableEq α] : DecidableEq (List α)
-- | [], l2 =>
--   if h : l2 = [] then
--     isTrue (by simp [*])
--   else
--     isFalse (by simp [*])
-- | l1, [] =>
--   if h : l1 = [] then
--     isTrue (by simp [*])
--   else
--     isFalse (by simp [*])
-- | x1::xs1, x2::xs2 =>
--   if h1 : x1 = x2 then
--     match List.mk_decidable xs1 xs2 with
--     | isTrue h2 => isTrue (by simp [*])
--     | isFalse h2 => isFalse (by simp [*])
--   else
--     isFalse (by simp [*])

-- instance {α : Type u} [DecidableEq α] : DecidableEq (List α) := List.mk_decidable

-- def x : DecidableEq (List (String × String)) := inferInstance

-- #eval (x [("hello","hello")] [("hello","hello")])



#eval (List.foldl (fun x y => x - y) 0 [1,2,3])

def forSub (xs : List Nat) := Id.run do
  let mut total := 0
  for x in xs do
    total := total - x
  return total

#eval forSub [1,2,3]

def other (xs : List Nat) := Id.run do
  let mut total := 0
  for x in xs do
    total := x - total
  return total

#eval other [1,2,3]

inductive GEven : Nat → Prop where
  | zero : GEven 0
  | step nn : GEven nn → GEven (nn + 2)

open Even

def add_preserves_even : ∀ {n}, GEven n → GEven (n + 2) :=
  fun {n} h =>
    match h with
    | .zero => by
      exact .step 0 .zero     -- case: n = 0
    | .step nn hn => by
      exact .step (nn + 2) (.step nn hn) -- case: n = k+2


inductive NN
| zero : NN
| succ (n : NN) : NN
deriving Repr

#eval (NN.succ NN.zero)
#eval (NN.succ (NN.succ NN.zero))

def add : NN -> NN -> NN
| .zero, n => n
| .succ n, n' => .succ (add n n')


#eval add (NN.zero) (NN.succ NN.zero)
#eval add (NN.succ NN.zero) (NN.succ NN.zero)


theorem one_one_two :
  add (NN.succ NN.zero) (NN.succ NN.zero) = NN.succ (NN.succ NN.zero)
:= Eq.refl (NN.succ (NN.succ NN.zero))

#check Eq.refl (NN.succ (NN.succ NN.zero))
