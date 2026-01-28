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
