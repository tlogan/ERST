import Lang.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.List.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

structure Zone where
  Θ : List String
  Δ : List (Typ × Typ)
  t : Typ

def Typ.base : Bool → Typ
| .true => .top
| .false => .bot

def Typ.rator : Bool → Typ → Typ → Typ
| .true => .inter
| .false => .unio

def Typ.inner : Bool → List String → List (Typ × Typ) → Typ → Typ
| .true => .all
| .false => .exi

def Typ.outer : Bool → List String → List (Typ × Typ) → Typ → Typ
| .true => .exi
| .false => .all

def BiZone.wrap (b : Bool)
: List String → List (Typ × Typ) → List String → List (Typ × Typ) → Typ → Typ
| [], [], [], [], t => t
| [], [], Θ', Δ', t => Typ.inner b Θ' Δ' t
| Θ, Δ, [], [], t => Typ.outer b Θ Δ t
| Θ, Δ, Θ', Δ', t => Typ.outer b Θ Δ (Typ.outer b Θ' Δ' t)

inductive Typ.Decreasing (id : String) : Typ → Prop
--TODO
| intro {t} : Typ.Decreasing id t

def Subtyping.target_bound : Bool → (Typ × Typ) → Typ × Typ
| .false, (l,r) => (l,r)
| .true, (l,r) => (r,l)

def ListSubtyping.bounds (id : String) (b : Bool) : List (Typ × Typ) → List Typ
| [] => []
| st :: sts =>
    let (t,bd) := Subtyping.target_bound b st
    if (.var id) == t then
      bd :: ListSubtyping.bounds id b sts
    else
      ListSubtyping.bounds id b sts

def ListSubtyping.prune (pids : List String) : List (Typ × Typ) → List (Typ × Typ)
| .nil => []
| .cons (l,r) sts =>
  if (Typ.free_vars l) ∪ (Typ.free_vars r) ⊆ pids then
    (l,r) :: ListSubtyping.prune pids sts
  else
    ListSubtyping.prune pids sts

def Typ.break : Bool → Typ → List Typ
| .false, .unio l r => Typ.break .false l ++ Typ.break .false r
| .true, .inter l r => Typ.break .true l ++ Typ.break .true r
| _, t => [t]

def Typ.combine (b : Bool) : List Typ → Typ
| .nil => Typ.base b
| [t] => t
| t :: ts => Typ.rator b t (Typ.combine b ts)

def Typ.interpret_one (id : String) (b : Bool) (Δ : List (Typ × Typ)) : Typ :=
  let bds := ListSubtyping.bounds id b Δ
  if bds == [] then
    Typ.base (not b)
  else
    Typ.combine (not b) bds

def ListSubtyping.interpret_all (b : Bool) (Δ : List (Typ × Typ))
: (ids : List String) → List (String × Typ)
| .nil => []
| .cons id ids =>
  let i := Typ.interpret_one id b Δ
  if not b && (Typ.toBruijn 0 [] i) == (Typ.toBruijn 0 [] .top) then
    ListSubtyping.interpret_all b Δ ids
  else if b && (Typ.toBruijn 0 [] i) == (Typ.toBruijn 0 [] .bot) then
    ListSubtyping.interpret_all b Δ ids
  else
    (id, i) :: ListSubtyping.interpret_all b Δ ids


-- def Zone.tidy (pids : List String) : Zone → Zone
-- | ⟨Θ, Δ, t⟩ =>
--   let δ := ListSubtyping.interpret_all .true Δ (List.diff (ListPairTyp.free_vars Δ) pids)
--   let t' := Typ.sub δ t
--   let pids' := pids ∪ (Typ.free_vars t')
--   let Δ' := ListSubtyping.prune pids' Δ
--   ⟨Θ, Δ', t'⟩

-- TODO: test out the effect of interpretation in previous implementation
def Zone.tidy (pids : List String) : Zone → Option Zone
| ⟨Θ, Δ, .path l r⟩ =>
  let params := Typ.free_vars l
  let δl := ListSubtyping.interpret_all .false Δ (List.diff params pids)
  let δr := ListSubtyping.interpret_all .true Δ
    (List.diff (List.diff (Typ.free_vars r) params) pids)
  let l' := Typ.sub δl l
  let r' := Typ.sub (δl ∪ δr) r
  let Δ' := ListSubtyping.prune (pids ∪ Θ ∪ (Typ.free_vars (.path l' r'))) Δ
  .some ⟨Θ, Δ', .path l' r'⟩
| _ => .none

def ListZone.tidy (pids : List String) : List Zone → Option (List Zone)
| .nil => .some []
| .cons zone zones => do
    let z ← (Zone.tidy pids zone)
    let zs ← (ListZone.tidy pids zones)
    return z :: zs


def ListSubtyping.invert (id : String) : List (Typ × Typ) → Option (List (Typ × Typ))
| .nil => return []
| .cons (.var id', .path l r) sts =>
    if id' == id then do
      let sts' ← ListSubtyping.invert id sts
      return (.pair l r, .var id') :: sts'
    else
      failure
| _ => failure

def ListZone.invert (id : String) : List Zone → Option (List Zone)
| .nil => return []
| .cons ⟨Θ, Δ, .path l r⟩ zones => do
    let zones' ← ListZone.invert id zones
    let Δ' ← ListSubtyping.invert id Δ
    return ⟨Θ, Δ', .pair l r⟩ :: zones'
| _ => failure


-- def ListSubtyping.flows_into (id : String) : List (Typ × Typ) → Option (List Typ)
-- | .nil => return []
-- | .cons (l,r) sts =>
--   if (r == .var id) then do
--     let ls ← ListSubtyping.flows_into id sts
--     return l::ls
--   else
--     failure

-- ListSubtyping.flows_into id quals = .some cases →

inductive Typ.Found (id : String) : Typ → Typ → Prop
| intro {quals id' cases t t'} :
  ListSubtyping.bounds id .true quals = cases →
  List.length cases = List.length quals →
  Typ.combine .false ((.var id') :: cases) = t →
  Typ.Monotonic id' .true t →
  Typ.sub [(id', .var id)] t = t' →
  Typ.Found id (.exi [] quals (.var id')) (.unio (.var id') t')


-- NOTE: P means pattern type; if not (T <: P) and not (P <: T) then T and P are disjoint
def Typ.is_pattern (tops : List String) : Typ → Bool
| .exi ids [] body => Typ.is_pattern (tops ++ ids) body
| .var id => id ∈ tops
| .unit => true
| .entry _ body => Typ.is_pattern tops body
| .inter left right => Typ.is_pattern tops left ∧ Typ.is_pattern tops right
| _ => false

def Typ.height : Typ → Option Nat
-- TODO
| _ => .none

-- NOTE: this should be complete, but not sound
def Subtyping.shallow_match : Typ → Typ → Bool
| .entry l k, .entry l' t =>
  l == l' && Subtyping.shallow_match k t
| k, .diff left right =>
  Subtyping.shallow_match k left && not (Subtyping.shallow_match k right)
| k, .exi _ _ t => Subtyping.shallow_match k t
| k, .inter left right =>
  Subtyping.shallow_match k left && Subtyping.shallow_match k right
| .inter left right, t =>
  Subtyping.shallow_match left t || Subtyping.shallow_match right t
| _,_ => .true

-- TODO: must prove that if inflatable holds then subtyping is sound and complete
def Subtyping.inflatable (key target : Typ) : Bool :=
  let ts := Typ.break .false target
  not (List.all ts (fun t => Subtyping.shallow_match key t))

def Typ.drop (id : String) (t : Typ) : Typ :=
  let cases := Typ.break .false t
  let cases' := List.filter (fun c => id ∉ Typ.free_vars c) cases
  Typ.combine .false cases'


def Typ.break_paths : List Typ → Option (List Typ × List Typ)
| .nil => return ([], [])
| .cons (.path l r) ts => do
  let (ls, rs) ← Typ.break_paths ts
  return (l::ls, r::rs)
| _ => failure

def Typ.merge_paths (t : Typ) : Option Typ :=
  let cases := Typ.break .true t
  do
  let (ls, rs) ← Typ.break_paths cases
  return .path (Typ.combine .false ls) (Typ.combine .false rs)



def ListSubtyping.partition (pids : List String) (Θ : List String)
: List (Typ × Typ) → List (Typ × Typ) × List (Typ × Typ)
| .nil => ([],[])
| .cons (l,r) remainder =>
    let (outer, inner) := ListSubtyping.partition pids Θ remainder
    let fids := Typ.free_vars l ∪  Typ.free_vars r
    if fids ∩ Θ ≠ [] && fids ⊆ (pids ∪ Θ) then
      ((l,r) :: outer, inner)
    else
      (outer, (l,r) :: inner)

def Zone.pack (pids : List String) (b : Bool) : Zone → Typ
| ⟨Θ, Δ, t⟩ =>
  let fids := Typ.free_vars t
  let (outer, inner) := ListSubtyping.partition pids Θ Δ
  let outer_ids := (ListPairTyp.free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (ListPairTyp.free_vars inner ∪ fids) (Θ ∪ pids)
  BiZone.wrap b outer_ids outer inner_ids inner t

def ListZone.pack (pids : List String) (b : Bool) : List Zone → Typ
| .nil => Typ.base b
| .cons zone zones =>
  let l := Zone.pack pids .true zone
  let r := ListZone.pack pids .true zones
  Typ.rator b l r

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

def Subtyping.restricted (Θ : List String) (Δ : List (Typ × Typ)) (lower upper : Typ) : Bool :=
  Typ.is_pattern [] upper ||
  (match lower, upper with
  | .var id, _ =>
    if id ∉ Θ then
      let i := Typ.interpret_one id .true Δ
      (Typ.toBruijn 0 [] i) == (Typ.toBruijn 0 [] .bot)
    else
      .false
  | _, _ => .false
  )

def ListSubtyping.restricted (Θ : List String) (Δ : List (Typ × Typ))
: List (Typ × Typ) → Bool
| .nil => .true
| .cons (l,r) sts =>
  Subtyping.restricted Θ Δ l r &&
  ListSubtyping.restricted Θ Δ  sts

mutual
  def Subtyping.proj (id : String) (l : String) : (Typ × Typ) → Option (Typ × Typ)
  | (key,.var id') =>
    if id == id' then do
      let p ← Typ.proj id l key
      return (p, .var id)
    else
      failure
  | st => return st

  def ListSubtyping.proj (id : String) (l : String) : List (Typ × Typ) → Option (List (Typ × Typ))
  | .nil => return []
  | .cons st sts => do
    let st' ← Subtyping.proj id l st
    let sts' ← ListSubtyping.proj id l sts
    return st' :: sts'

  def Typ.proj (id : String) (l : String) : Typ → Option Typ
  | .entry l' body =>
    if l == l' then
      return body
    else
      failure
  | .inter left right =>
    let ts := (Option.toList (Typ.proj id l left)) ++ (Option.toList (Typ.proj id l right))
    return .combine .true ts
  | .diff left right => do
    let left' ← Typ.proj id l left
    let right' ← Typ.proj id l right
    return .diff left' right'
  | .exi ids quals body =>
    if id ∈ ids then
      failure
    else do
      let quals' ← ListSubtyping.proj id l quals
      let body' ← Typ.proj id l body
      let ids' := ids ∩ (ListPairTyp.free_vars quals' ∪ Typ.free_vars body')
      return .exi ids' quals' body'
  | _ => .none
end

def ListTyp.factor (id : String) (l : String) : List Typ → Option (List Typ)
| .nil => .some []
| .cons t ts => do
  let t' ← Typ.proj id l t
  let ts' ← ListTyp.factor id l ts
  return t' :: ts'

def Typ.factor (id : String) (t : Typ) (l : String) : Option Typ :=
  let cases := Typ.break .false t
  do
  let ts ← ListTyp.factor id l cases
  return Typ.combine .false ts

mutual
  -- TODO: check needs to be complete and well founded
  def Subtyping.check (Θ : List String) (Δ : List (Typ × Typ)) : Typ → Typ → Bool
  -- TODO: only consider cases where left is pattern and right is anything
  -- or right is pattern left is anything
  -- TODO: if right is LFP; how to ensure well founded?
  -- we know left is finite; prove that one of the two inputs is decreasing;
  -- the left must be decreasing when we inflate the right
  --------------------------------------------------
  | .unit, .unit => true
  | .entry l body, .entry l' body' =>
    l = l' && Subtyping.check Θ Δ body body'

  | _, .var id =>
    if id ∉ Θ then
      let i := Typ.interpret_one id .false Δ
      (Typ.toBruijn 0 [] i) == (Typ.toBruijn 0 [] .top)
    else
      .false
  | lower, .inter left right =>
    Subtyping.check Θ Δ lower left && Subtyping.check Θ Δ lower right
  | lower, .exi _ [] body => Subtyping.check Θ Δ lower body

  | .var id, _ =>
    if id ∈ Θ then
      let i := Typ.interpret_one id .true Δ
      (Typ.toBruijn 0 [] i) == (Typ.toBruijn 0 [] .bot)
    else
      .false
  | .inter left right, upper =>
    Subtyping.check Θ Δ left upper || Subtyping.check Θ Δ right upper
  | .exi ids [] body, upper => Subtyping.check (ids ∪ Θ) Δ body upper
  --------------------------------------------------
  -- TODO: handle LFP on rhs
  --------------------------------------------------
  -- | lower, .unit => true
  -- | lower, .var id => false
  -- | lower, .entry _ body => false
  -- | lower, .inter left right => false
  -- | lower, .exi ids [] body => false
  --------------------------------------------------
  -- | .unit, upper => true
  -- | .var id, upper => false
  -- | .entry _ body, upper => false
  -- | .inter left right, upper => false
  -- | .exi ids [] body, upper => false
  --------------------------------------------------
  | lower, _ =>  (Typ.toBruijn 0 [] lower) == (Typ.toBruijn 0 [] .bot)
  -- | _, _ => false
end

-- the weakest type t such that every inhabitant matches pattern p
inductive PatLifting.Static
: List (Typ × Typ) → List (String × Typ) →
  Pat → Typ → List (Typ × Typ) → List (String × Typ) → Prop

| var Δ Γ id id' :
  PatLifting.Static
  Δ Γ (.var id) (.var id')
  ((.var id', Typ.top) :: Δ)  ((id, .var id') :: (remove id Γ))

| unit Δ Γ :
  PatLifting.Static Δ Γ .unit .unit Δ Γ

| record_nil Δ Γ :
  PatLifting.Static Δ Γ (.record []) .top Δ Γ

| record_single Δ Γ l p t Δ' Γ' :
  PatLifting.Static Δ Γ p t Δ' Γ' →
  PatLifting.Static Δ Γ (.record ((l,p) :: []))
    (.entry l t) Δ' Γ'

| record_cons Δ Γ l p remainder t t' Δ' Γ' Δ'' Γ'' :
  PatLifting.Static Δ Γ p t Δ' Γ' →
  PatLifting.Static Δ' Γ' (.record remainder) t' Δ'' Γ'' →
  Pat.free_vars p ∩ ListPat.free_vars remainder = [] →
  PatLifting.Static Δ Γ (.record ((l,p) :: remainder))
    (.inter (.entry l t) t') Δ'' Γ''



syntax "prove_pat_lifting_static" : tactic
syntax "witness_pat_lifting_static" : tactic

macro_rules
| `(tactic| prove_pat_lifting_static) => `(tactic|
  (first
  | apply PatLifting.Static.var
  | apply PatLifting.Static.unit
  | apply PatLifting.Static.record_nil
  | apply PatLifting.Static.record_single
    · prove_pat_lifting_static
  | apply PatLifting.Static.record_cons
    · prove_pat_lifting_static
    · prove_pat_lifting_static
    · simp [Pat.free_vars, ListPat.free_vars]; rfl
  ) <;> fail
)

elab_rules : tactic
| `(tactic| witness_pat_lifting_static) =>
  open Lean Elab Tactic in
  open Lean.Expr in
  open Lean Elab Command in
  open Lean Elab Term in
  open Lean.Meta in
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    match goalType with
    ------------ TODO ----------------
    | app _ (lam _ _ (app (app _ input) _) _ ) => do
      let output ← Lean.PrettyPrinter.delab input
      evalTactic (← `(tactic|
        exists $output ; prove_pat_lifting_static)
      )
    | _ => dbg_trace f!"Other: goal type: {goalType}"

example Δ Γ
: PatLifting.Static Δ Γ p[x]
  (Typ.var "X")
  ((Typ.var "X", Typ.top) :: Δ)
  (("x", Typ.var "X") :: (remove "x" Γ))
:= by
  prove_pat_lifting_static

example Δ Γ
: PatLifting.Static Δ Γ .unit
  Typ.unit
  Δ
  Γ
:= by
  prove_pat_lifting_static

example Δ Γ
: PatLifting.Static Δ Γ (.record [])
  Typ.top
  Δ
  Γ
:= by
  prove_pat_lifting_static


example Δ Γ
: PatLifting.Static Δ Γ (Pat.record [("dos", Pat.unit)]) (Typ.entry "dos" Typ.unit) Δ Γ
:= by
  prove_pat_lifting_static
  -- apply PatLifting.Static.record_single
  -- apply PatLifting.Static.unit

example Δ Γ
: PatLifting.Static Δ Γ p[<uno>@ <dos>@]
  (.inter (.entry "uno" .unit) (.entry "dos" .unit))
  Δ
  Γ
:= by
  prove_pat_lifting_static
  -- apply PatLifting.Static.record_cons
  -- apply PatLifting.Static.unit
  -- apply PatLifting.Static.record_single
  -- apply PatLifting.Static.unit
  -- simp [Pat.free_vars, ListPat.free_vars]
  -- rfl

example Δ Γ : ∃ t Δ' Γ', PatLifting.Static Δ Γ p[x] t Δ' Γ' := by
  let t := (Typ.var "X")
  let Δ' : List (Typ × Typ) := (Typ.var "X", Typ.top) :: Δ
  let Γ' := ("x", Typ.var "X") :: (remove "x" Γ)

  exists t, Δ', Γ'
  apply PatLifting.Static.var


---------------------------------------------------------------
section
-- NOTE: template for solving for predicate and using solution to construct proof
inductive MyPredicate : String → String → Prop
| intro x : MyPredicate x x

syntax "witness_my_predicate" : tactic
syntax "prove_my_predicate" : tactic

def Lean.Parser.parse (cat : Lean.Name) (str : String) : Lean.CoreM (Lean.TSyntax cat) := do
  let x ← Lean.getEnv
  match Lean.Parser.runParserCategory x cat str with
  | .ok stx => return Lean.TSyntax.mk stx
  | .error err => throwError err

#check Lean.Parser.parse

-- def mk_witness_tactic
--   (mk_witness : Lean.Expr → Lean.Expr)
--   (tact : String)
-- : Lean.Elab.Tactic.TacticM Unit
-- :=
--   open Lean Elab Tactic in
--   open Lean.Expr in
--   open Lean Elab Command in
--   open Lean Elab Term in
--   open Lean.Meta in
--   Lean.Elab.Tactic.withMainContext do
--     let goal ← Lean.Elab.Tactic.getMainGoal
--     let goalDecl ← goal.getDecl
--     let goalType := goalDecl.type
--     match goalType with
--     | app _ (lam _ _ (app (app _ input) _) _ ) => do
--       let output ← Lean.PrettyPrinter.delab (mk_witness input)
--       evalTactic (← `(tactic|
--         exists $output ; $(← stringToSyntax `tactic tact)
--       ))
--     | _ => dbg_trace f!"Other: goal type: {goalType}"


elab_rules : tactic
| `(tactic| witness_my_predicate) =>
  open Lean Elab Tactic in
  open Lean.Expr in
  open Lean Elab Command in
  open Lean Elab Term in
  open Lean.Meta in
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    match goalType with
    | app _ (lam _ _ (app (app _ input) _) _ ) => do
      let output ← Lean.PrettyPrinter.delab input
      evalTactic (← `(tactic|
        exists $output ; prove_my_predicate)
      )
    | _ => dbg_trace f!"Other: goal type: {goalType}"

macro_rules
| `(tactic| prove_my_predicate) => `(tactic|
  apply MyPredicate.intro
)

example : ∃ x , MyPredicate "x" x := by
  witness_my_predicate
end
---------------------------------------------------------------


mutual

  inductive Subtyping.Static
  : List String → List (Typ × Typ) → Typ → Typ →
    List String → List (Typ × Typ) → Prop
  | refl {Θ Δ t} :
    Subtyping.Static Θ Δ t t Θ Δ

  | rename_left {Θ Δ left left' right} :
    (Typ.toBruijn 0 [] left) = (Typ.toBruijn 0 [] left') →
    Subtyping.Static Θ Δ left' right Θ Δ →
    Subtyping.Static Θ Δ left right Θ Δ

  | rename_right {Θ Δ left right right'} :
    (Typ.toBruijn 0 [] right) = (Typ.toBruijn 0 [] right') →
    Subtyping.Static Θ Δ left right' Θ Δ →
    Subtyping.Static Θ Δ left right Θ Δ

  -- implication preservation
  | entry_pres {Θ Δ l left right Θ' Δ'} :
    Subtyping.Static Θ Δ (.entry l left) (.entry l right) Θ' Δ'
  | path_pres {Θ Δ p q  Θ' Δ' x y Θ'' Δ''} :
    Subtyping.Static Θ Δ x p Θ' Δ' → Subtyping.Static Θ' Δ' q y Θ'' Δ'' →
    Subtyping.Static Θ Δ (.path p q) (.path x y) Θ'' Δ''

  -- expansion elimination
  | unio_elim {Θ Δ a t b Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ a t Θ' Δ' → Subtyping.Static Θ' Δ' b t Θ'' Δ'' →
    Subtyping.Static Θ Δ (.unio a b) t Θ'' Δ''
  | exi_elim {Θ Δ ids quals body t Θ' Δ' Θ'' Δ''} :
    ListSubtyping.restricted Θ Δ quals →
    ListSubtyping.Static Θ Δ quals Θ' Δ' →
    Subtyping.Static (ids ∪ Θ') Δ' body t Θ'' Δ'' →
    Subtyping.Static Θ Δ (.exi ids quals body) t Θ'' Δ''

  -- refinement introduction
  | inter_intro {Θ Δ t a  b Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ t a Θ' Δ' → Subtyping.Static Θ' Δ' t b Θ'' Δ'' →
    Subtyping.Static Θ Δ t (.inter a b) Θ'' Δ''
  | all_intro {Θ Δ ids quals body t Θ' Δ' Θ'' Δ''} :
    ListSubtyping.restricted Θ Δ quals →
    ListSubtyping.Static Θ Δ quals Θ' Δ' →
    Subtyping.Static (ids ∪ Θ') Δ' t body Θ'' Δ'' →
    Subtyping.Static Θ Δ t (.all ids quals body) Θ'' Δ''

  -- placeholder elimination
  | placeholder_elim {Θ Δ id t trans Θ' Δ' } :
    id ∉ Θ →
    (∀ t', (t', .var id) ∈ Δ → (t', t) ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- placeholder introduction
  | placeholder_intro {Θ Δ t id trans Θ' Δ' } :
    id ∉ Θ →
    (∀ t', (.var id, t') ∈ Δ → (t, t') ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' ((t, .var id) :: Δ')

  -- skolem placeholder introduction
  | skolem_placeholder_intro {Θ Δ t id trans Θ' Δ' } :
    id ∈ Θ →
    (∃ id', (.var id', .var id) ∈ Δ ∧ id' ∉ Θ) →
    (∀ t', (.var id, t') ∈ Δ → (t, t') ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' ((t, .var id) :: Δ')

  -- skolem introduction
  | skolem_intro {Θ Δ t id t' Θ' Δ' } :
    id ∈ Θ →
    (t', .var id) ∈ Δ →
    (∀ id', (.var id') = t' → id ∈ Θ) →
    Subtyping.Static Θ Δ t t' Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' Δ'

  -- skolem placeholder elimination
  | skolem_placeholder_elim {Θ Δ id t trans Θ' Δ' } :
    id ∈ Θ →
    (∃ id', (.var id, .var id') ∈ Δ ∧ id' ∉ Θ) →
    (∀ t', (t', .var id) ∈ Δ → (t', t) ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- skolem elimination
  | skolem_elim {Θ Δ id t t' Θ' Δ'} :
    id ∈ Θ →
    (.var id, t') ∈ Δ →
    (∀ id', (.var id') = t → id' ∈ Θ) →
    Subtyping.Static Θ Δ t' t Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- implication rewriting
  | unio_antec {Θ Δ l a b r Θ' Δ'} :
    Subtyping.Static Θ Δ l (.inter (.path a r) (.path b r)) Θ' Δ' →
    Subtyping.Static Θ Δ l (.path (.unio a b) r) Θ' Δ'

  | inter_conseq {Θ Δ l a b r Θ' Δ'} :
    Subtyping.Static Θ Δ l (.inter (.path r a) (.path r b)) Θ' Δ' →
    Subtyping.Static Θ Δ l (.path r (.inter a b)) Θ' Δ'

  | inter_entry {Θ Δ t l a b Θ' Δ'} :
    Subtyping.Static Θ Δ t (.inter (.entry l a) (.entry l b)) Θ' Δ' →
    Subtyping.Static Θ Δ t (.entry l (.inter a b)) Θ' Δ'

  -- least fixed point elimination
  | lfp_factor_elim {Θ Δ id left l right fac Θ' Δ'} :
    Typ.factor id left l = .some fac →
    Subtyping.Static Θ Δ fac right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) (.entry l right) Θ' Δ'
  | lfp_skip_elim {Θ Δ id left right Θ' Δ'} :
    id ∉ Typ.free_vars left →
    Subtyping.Static Θ Δ left right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) right Θ' Δ'
  | lfp_induct_elim {Θ Δ id left right Θ' Δ'} :
    Typ.Monotonic id .true left →
    Subtyping.Static Θ Δ (Typ.sub [(id, right)] left) right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) right Θ' Δ'

  -- difference introduction
  | diff_intro {Θ Δ t l r Θ' Δ'} :
    Typ.is_pattern [] r →
    ¬ Subtyping.check Θ Δ t r →
    ¬ Subtyping.check Θ Δ r t →
    Subtyping.Static Θ Δ t (.diff l r) Θ' Δ'

  -- difference introduction
  | diff_fold_intro {Θ Δ id t l r h Θ' Δ'} :
    Typ.is_pattern [] r →
    Typ.Monotonic id .true t →
    Typ.Decreasing id t →
    ¬ (Subtyping.check Θ Δ (Typ.subfold id t 1) r) →
    Typ.height r = .some h →
    ¬ (Subtyping.check Θ Δ r (Typ.subfold id t h)) →
    Subtyping.Static Θ Δ (.lfp id t) (.diff l r) Θ' Δ'

  -- least fixed point introduction
  | lfp_inflate_intro {Θ Δ l id r Θ' Δ'} :
    -- TODO: inflatable is a heuristic;
    -- it's not necessary for soundness
    -- consider merely using it in tactic
    Subtyping.inflatable l r →
    Subtyping.Static Θ Δ l (.sub [(id, .lfp id r)] r) Θ' Δ' →
    Subtyping.Static Θ Δ l (.lfp id r) Θ' Δ'

  | lfp_drop_intro {Θ Δ l id r r' Θ' Δ'} :
    Typ.drop id r = r' →
    Subtyping.Static Θ Δ l r' Θ' Δ' →
    Subtyping.Static Θ Δ l (.lfp id r) Θ' Δ'

  -- difference elimination
  | diff_elim {Θ Δ l r t Θ' Δ'} :
    Subtyping.Static Θ Δ l (.unio r t) Θ' Δ' →
    Subtyping.Static Θ Δ (.diff l r) t Θ' Δ'

  -- expansion introduction
  | unio_left_intro {θ δ t l r θ' δ'} :
    Subtyping.Static θ δ t l θ' δ' →
    Subtyping.Static θ δ t (.unio l r) θ' δ'

  | unio_right_intro {θ δ t l r θ' δ'} :
    Subtyping.Static θ δ t r θ' δ' →
    Subtyping.Static θ δ t (.unio l r) θ' δ'

  | exi_intro {θ δ l ids quals r θ' δ' θ'' δ''} :
    Subtyping.Static θ δ l r θ' δ' →
    ListSubtyping.Static θ' δ' quals θ' δ' →
    Subtyping.Static θ δ l (.exi ids quals r)  θ'' δ''

  -- refinement elimination
  | inter_left_elim {θ δ l r t θ' δ'} :
    Subtyping.Static θ δ l t θ' δ' →
    Subtyping.Static θ δ (.inter l r) t θ' δ'

  | inter_right_elim {θ δ l r t θ' δ'} :
    Subtyping.Static θ δ r t θ' δ' →
    Subtyping.Static θ δ (.inter l r) t θ' δ'

  | inter_merge_elim {θ δ l r p q t θ' δ'} :
    Typ.merge_paths (.inter l r) = .some t →
    Subtyping.Static θ δ t (.path p q) θ' δ' →
    Subtyping.Static θ δ (.inter l r) (.path p q) θ' δ'

  | all_elim {θ δ ids quals l r θ' δ' θ'' δ''} :
    Subtyping.Static θ δ l r θ' δ' →
    ListSubtyping.Static θ' δ' quals θ' δ' →
    Subtyping.Static θ δ (.all ids quals l) r θ'' δ''

  inductive ListSubtyping.Static
  : List String → List (Typ × Typ) → List (Typ × Typ) →
    List String → List (Typ × Typ) → Prop
  | nil {Θ Δ Θ' Δ'} : ListSubtyping.Static Θ Δ [] Θ' Δ'
  | cons {Θ Δ l r cs Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ l r Θ' Δ' →
    ListSubtyping.Static Θ' Δ' cs Θ'' Δ'' →
    ListSubtyping.Static Θ Δ ((l,r) :: cs) Θ'' Δ''


  inductive Typing.ListPath.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    List (Pat × Expr) → List Zone → List Typ → Prop
  | nil {Θ Δ Γ} :
    Typing.ListPath.Static Θ Δ Γ [] [] []
  | cons {Θ Δ Γ p e f zones subtras Δ' Γ' tp tl zones' zones'' subtra} :
    Typing.ListPath.Static Θ Δ Γ f zones subtras →
    PatLifting.Static Δ Γ p tp Δ' Γ' →
    ListTyp.diff tp subtras = tl →
    (∀ Θ' Δ'' tr,
      ⟨List.diff Θ' Θ, List.diff Δ'' Δ', (.path tl tr)⟩ ∈ zones' →
      Typing.Static Θ Δ' Γ' e tr Θ' Δ''
    ) →
    ListZone.tidy (ListPairTyp.free_vars Δ) zones' = .some zones'' →
    Typ.capture tp = subtra →
    Typing.ListPath.Static Θ Δ Γ ((p,e)::f) (zones'' ++ zones) (subtra :: subtras)

  inductive Subtyping.GuardedListZone.Static
  : List String → List (Typ × Typ) →
    Typ → Typ → List Zone → Prop
  | intro {Θ Δ t id zones zones'} :
    (∀ Θ' Δ' t',
      ⟨List.diff Θ' Θ, List.diff Δ' Δ, t'⟩ ∈ zones →
      Subtyping.Static Θ Δ t (.path (.var id) t') Θ' Δ'
    ) →
    ListZone.tidy (ListPairTyp.free_vars Δ) zones = .some zones' →
    Subtyping.GuardedListZone.Static Θ Δ t (.var id) zones'

  inductive Typing.ListZone.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    Expr → List Zone → Prop
  | intro {Θ Δ Γ e zones} :
    (∀ Θ' Δ' t,
      ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩ ∈ zones →
      Typing.Static Θ Δ Γ e t Θ' Δ'
    ) →
    Typing.ListZone.Static Θ Δ Γ e zones

  inductive Subtyping.LoopListZone.Static
  : List String → String → List Zone → Typ → Prop
  | batch {pids id zones zones' t' l r} :
    ListZone.invert id zones = .some zones' →
    ListZone.pack (id :: pids) .false zones' = t' →
    Typ.factor id t' "left" = .some l →
    Typ.factor id t' "right" = .some r →
    Subtyping.LoopListZone.Static pids id zones (.path (.lfp id l) (.lfp id r))

  | stream {pids id Θ Δ Δ' idl r t' l r' l' r''} :
    id ≠ idl →
    ListSubtyping.invert id Δ = .some Δ' →
    Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩ = t' →
    Typ.factor id t' "left" = .some l →
    Typ.factor id t' "right" = .some r' →
    Typ.Monotonic idl .true r' →
    Typ.Found id l l' →
    Typ.sub [(idl, .lfp id l')] r' = r'' →
    Subtyping.LoopListZone.Static
    pids id [⟨Θ, Δ, .path (.var idl) r⟩]
    (.path (.var idl) (.lfp id r''))

  inductive Typing.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    Expr → Typ →
    List String → List (Typ × Typ) → Prop
  | unit {Θ Δ Γ} : Typing.Static Θ Δ Γ .unit .unit Θ Δ
  | var {Θ Δ Γ x t} :
    find x Γ = .some t →
    Typing.Static Θ Δ Γ (.var x) t Θ Δ

  | record_nil {Θ Δ Γ} :
    Typing.Static Θ Δ Γ (.record []) .top Θ Δ
  | record_cons {Θ Δ Γ r l e t t'  Θ' Δ' Θ'' Δ''} :
    Typing.Static Θ Δ Γ e t Θ' Δ' →
    Typing.Static Θ Δ Γ (.record r) t' Θ'' Δ'' →
    Typing.Static Θ Δ Γ (.record ((l,e) :: r)) (.inter (.entry l t) (t')) Θ'' Δ''

  | function {Θ Δ Γ f zones t subtras} :
    Typing.ListPath.Static Θ Δ Γ f zones subtras →
    ListZone.pack (ListPairTyp.free_vars Δ) .true zones = t →
    Typing.Static Θ Δ Γ (.function f) t Θ Δ

  | app {Θ Δ Γ ef ea α tf Θ' Δ' ta Θ'' Δ'' Θ''' Δ'''} :
    Typing.Static Θ Δ Γ ef tf Θ' Δ' →
    Typing.Static Θ' Δ' Γ ea ta Θ'' Δ'' →
    Subtyping.Static Θ Δ tf (.path ta (.var α)) Θ''' Δ''' →
    Typing.Static Θ Δ Γ (.app ef ea) (.var α) Θ''' Δ'''

  | loop {Θ Δ Γ e t id zones t' Θ' Δ'} :
    Typing.Static Θ Δ Γ e t Θ' Δ' →
    Subtyping.GuardedListZone.Static Θ' Δ' t (.var id) zones →
    Subtyping.LoopListZone.Static (ListPairTyp.free_vars Δ') id zones t' →
    Typing.Static Θ Δ Γ (.loop e) t' Θ' Δ'


  | anno {Θ Δ Γ e ta zones te Θ' Δ'} :
    Typ.free_vars ta ⊆ [] →
    Typing.ListZone.Static Θ Δ Γ e zones →
    ListZone.pack (ListPairTyp.free_vars Δ) .false zones = te →
    Subtyping.Static Θ Δ te ta Θ' Δ' →
    Typing.Static Θ Δ Γ (.anno e ta) ta Θ Δ


end

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
