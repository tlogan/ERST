import Lang.Basic
import Lang.Util

-- import Mathlib.Data.Set.Basic
-- import Mathlib.Data.List.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

structure Zone where
  skolems : List String
  assums : List (Typ × Typ)
  typ : Typ

def Typ.base : Bool → Typ
| .true => .top
| .false => .bot

def Typ.rator : Bool → Typ → Typ → Typ
| .true => .inter
| .false => .unio

def Typ.inner : Bool → List String → ListSubtyping → Typ → Typ
| .true => .all
| .false => .exi

def Typ.outer : Bool → List String → ListSubtyping → Typ → Typ
| .true => .exi
| .false => .all

def BiZone.wrap (b : Bool)
: List String → ListSubtyping → List String → ListSubtyping → Typ → Typ
| [], .nil, [], .nil, t => t
| [], .nil, Θ', Δ', t => Typ.inner b Θ' Δ' t
| Θ, Δ, [], .nil, t => Typ.outer b Θ Δ t
| Θ, Δ, Θ', Δ', t => Typ.outer b Θ Δ (Typ.outer b Θ' Δ' t)

def Subtyping.target_bound : Bool → (Typ × Typ) → Typ × Typ
| .false, (l,r) => (l,r)
| .true, (l,r) => (r,l)

def ListSubtyping.bounds (id : String) (b : Bool) : ListSubtyping → List Typ
| .nil => []
| .cons st sts =>
    let (t,bd) := Subtyping.target_bound b st
    if (.var id) == t then
      bd :: ListSubtyping.bounds id b sts
    else
      ListSubtyping.bounds id b sts

#eval [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
#eval (ListSubtyping.bounds "R" .true [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ])



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
  if not b && (Typ.toBruijn [] i) == (Typ.toBruijn [] .top) then
    ListSubtyping.interpret_all b Δ ids
  else if b && (Typ.toBruijn [] i) == (Typ.toBruijn [] .bot) then
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


mutual

  partial def ListSubtyping.Monotonic.Static.Either.decide (cs : ListSubtyping) (t : Typ)
  : List String → Bool
  | [] => .true
  | id :: ids =>
    (
      (ListSubtyping.Monotonic.Static.decide id .true cs && Typ.Monotonic.Static.decide id .true t) ||
      (ListSubtyping.Monotonic.Static.decide id .false cs && Typ.Monotonic.Static.decide id .false t)
    ) &&
    ListSubtyping.Monotonic.Static.Either.decide cs t ids

  partial def ListSubtyping.Monotonic.Static.decide (id : String) (b : Bool) : ListSubtyping → Bool
  | .nil => .true
  | .cons (l,r) remainder =>
    Typ.Monotonic.Static.decide id (not b) l &&
    Typ.Monotonic.Static.decide id b r &&
    ListSubtyping.Monotonic.Static.decide id b remainder


  partial def Typ.Monotonic.Static.decide (id : String) (b : Bool) : Typ → Bool
  | .var id' =>
    if id == id' then
      b == .true
    else
      .true
  | .unit => .true
  | .entry _ body =>
    Typ.Monotonic.Static.decide id b body
  | .path left right =>
    Typ.Monotonic.Static.decide id (not b) left &&
    Typ.Monotonic.Static.decide id b right
  | .bot => .true
  | .top => .true
  | .unio left right =>
    Typ.Monotonic.Static.decide id b left &&
    Typ.Monotonic.Static.decide id b right
  | .inter left right =>
    Typ.Monotonic.Static.decide id b left &&
    Typ.Monotonic.Static.decide id b right
  | .diff left right =>
    Typ.Monotonic.Static.decide id b left &&
    Typ.Monotonic.Static.decide id (not b) right

  | .all ids subtypings body =>
    ids.contains id || (
      ListSubtyping.Monotonic.Static.Either.decide subtypings body ids &&
      Typ.Monotonic.Static.decide id b body
    )

  | .exi ids subtypings body =>
    ids.contains id || (
      ListSubtyping.Monotonic.Static.Either.decide subtypings (.diff .top body) ids &&
      Typ.Monotonic.Static.decide id b body
    )

  | .lfp id' body =>
    id == id' || Typ.Monotonic.Static.decide id b body
end


mutual

  inductive ListSubtyping.Monotonic.Static.Either : ListSubtyping → Typ → List String → Prop
  | nil cs t : ListSubtyping.Monotonic.Static.Either cs t []
  | cons cs t b id ids :
    ListSubtyping.Monotonic.Static id b cs →
    Typ.Monotonic.Static id b t →
    ListSubtyping.Monotonic.Static.Either cs t ids →
    ListSubtyping.Monotonic.Static.Either cs t (id :: ids)

  inductive ListSubtyping.Monotonic.Static : String → Bool → ListSubtyping → Prop
  | nil id b : ListSubtyping.Monotonic.Static id b .nil
  | cons id b l r remainder :
    Typ.Monotonic.Static id (not b) l →
    Typ.Monotonic.Static id b r →
    ListSubtyping.Monotonic.Static id b remainder →
    ListSubtyping.Monotonic.Static id b (.cons (l,r) remainder)

  inductive Typ.Monotonic.Static : String → Bool → Typ → Prop
  | var id : Typ.Monotonic.Static id true (.var id)
  | varskip id b id' : id ≠ id' → Typ.Monotonic.Static id b (.var id')
    | unit id b : Typ.Monotonic.Static id b .unit
  | entry id b l body : Typ.Monotonic.Static id b body →  Typ.Monotonic.Static id b (.entry l body)
  | path id b left right :
    Typ.Monotonic.Static id (not b) left →
    Typ.Monotonic.Static id b right →
    Typ.Monotonic.Static id b (.path left right)

  | bot id b:
    Typ.Monotonic.Static id b .bot

  | top id b :
    Typ.Monotonic.Static id b .top

  | unio id b left right :
    Typ.Monotonic.Static id b left →
    Typ.Monotonic.Static id b right →
    Typ.Monotonic.Static id b (.unio left right)
  | inter id b left right :
    Typ.Monotonic.Static id b left →
    Typ.Monotonic.Static id b right →
    Typ.Monotonic.Static id b (.inter left right)
  | diff id b left right :
    Typ.Monotonic.Static id b left →
    Typ.Monotonic.Static id (not b) right →
    Typ.Monotonic.Static id b (.diff left right)

  | all id b ids subtypings body :
    id ∉ ids →
    ListSubtyping.Monotonic.Static.Either subtypings body ids →
    Typ.Monotonic.Static id b body →
    Typ.Monotonic.Static id b (.all ids subtypings body)

  | allskip id b ids subtypings body :
    id ∈ ids →
    Typ.Monotonic.Static id b (.all ids subtypings body)

  | exi id b ids subtypings body :
    id ∉ ids →
    ListSubtyping.Monotonic.Static.Either subtypings (.diff .top body) ids →
    Typ.Monotonic.Static id b body →
    Typ.Monotonic.Static id b (.exi ids subtypings body)

  | exiskip id b ids subtypings body :
    id ∈ ids →
    Typ.Monotonic.Static id b (.exi ids subtypings body)


  | lfp id b id' body : id ≠ id' → Typ.Monotonic.Static id b body → Typ.Monotonic.Static id b (.lfp id' body)
  | lfpskip id b body : Typ.Monotonic.Static id b (.lfp id body)

end


syntax "prove_list_subtyping_monotonic_either" : tactic
syntax "prove_list_subtyping_monotonic" : tactic
syntax "Typ_Monotonic_Static_prove" : tactic

macro_rules
| `(tactic| prove_list_subtyping_monotonic_either) => `(tactic|
  (first
  | apply ListSubtyping.Monotonic.Static.Either.nil
  | apply ListSubtyping.Monotonic.Static.Either.cons _ _ .true
    · prove_list_subtyping_monotonic
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic_either
  | apply ListSubtyping.Monotonic.Static.Either.cons _ _ .false
    · prove_list_subtyping_monotonic
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic_either
  ) <;> fail
)

| `(tactic| prove_list_subtyping_monotonic) => `(tactic|
  (first
  | apply ListSubtyping.Monotonic.Static.nil
  | apply ListSubtyping.Monotonic.Static.Either.cons
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic
  ) <;> fail
)
| `(tactic| Typ_Monotonic_Static_prove) => `(tactic|
  (first
  | apply Typ.Monotonic.Static.var
  | apply Typ.Monotonic.Static.varskip; simp
  | apply Typ.Monotonic.Static.unit
  | apply Typ.Monotonic.Static.entry; Typ_Monotonic_Static_prove

  | apply Typ.Monotonic.Static.path
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.bot
  | apply Typ.Monotonic.Static.top
  | apply Typ.Monotonic.Static.unio
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.inter
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.diff
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.all
    · simp
    · prove_list_subtyping_monotonic_either
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.allskip; simp
  | apply Typ.Monotonic.Static.bot
    · rfl
  | apply Typ.Monotonic.Static.exi
    · simp
    · prove_list_subtyping_monotonic_either
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.top
    · rfl
  | apply Typ.Monotonic.Static.lfp
    · simp
    · Typ_Monotonic_Static_prove
  | apply Typ.Monotonic.Static.lfpskip; simp
  ) <;> fail
)




-- TODO, could define as a structure or multi-And
inductive Typ.UpperFounded (id : String) : Typ → Typ → Prop
| intro quals id' cases t t' :
  ListSubtyping.bounds id .true quals = cases →
  List.length cases = List.length quals →
  Typ.combine .false cases = t →
  Typ.Monotonic.Static id' .true t →
  Typ.sub [(id', .var id)] t = t' →
  Typ.UpperFounded id (.exi [] quals (.var id')) (.unio (.var id') t')

def Typ.UpperFounded.compute (id : String) : Typ → Lean.MetaM Typ
| .exi [] quals (.var id') => do
  let cases := ListSubtyping.bounds id .true quals
  if List.length cases == List.length quals then
    let t := Typ.combine .false cases
    let t' := Typ.sub [(id', .var id)] t
    return (.unio (.var id') t')
  else
    failure
| _ => failure

#eval  [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
#eval Typ.UpperFounded.compute
  "R"
  [typ| EXI[] [(<succ> G010 <: R)  (<succ> <succ> G010 <: R)] G010 ]

syntax "Typ_UpperFounded_prove" : tactic
macro_rules
| `(tactic| Typ_UpperFounded_prove) => `(tactic|
  (
  apply Typ.UpperFounded.intro
  · rfl
  · rfl
  · rfl
  · Typ_Monotonic_Static_prove
  · rfl
  )
)



-- NOTE: P means pattern type; if not (T <: P) and not (P <: T) then T and P are disjoint
def Typ.is_pattern (tops : List String) : Typ → Bool
  | .unit => true
  | .top => true
  | .exi ids [] body => Typ.is_pattern (tops ++ ids) body
  | .var id => id ∈ tops
  | .entry _ body => Typ.is_pattern tops body
  | .inter left right => Typ.is_pattern tops left ∧ Typ.is_pattern tops right
  | _ => false

def Typ.height : Typ → Option Nat
  | .top => return 1
  | .unit => return 1
  | .exi _ [] body => Typ.height body
  | .var _ => return 1
  | .entry _ body => do
    return 1 + (← Typ.height body)
  | .inter left right => do
    return Nat.max (← Typ.height left) (← Typ.height right)
  | _ => failure


def ListSubtyping.var_restricted (id : String) : List (Typ × Typ) → Bool
  | [] => .true
  | (l,r) :: remainder =>
    id ∉ (Typ.free_vars l) &&
    (r == (.var id) || id ∉ (Typ.free_vars r)) &&
    ListSubtyping.var_restricted id remainder

mutual
  -- NOTE: check that recursive type is structurally decreasing
  -- NOTE: not necessary for soundness
  def ListTyp.struct_less_than : List Typ → Typ → Bool
    | [], _ => .true
    | (l::ls), r =>
      Typ.struct_less_than l r && ListTyp.struct_less_than ls r

  def Typ.struct_lte (smaller bigger : Typ) : Bool :=
    smaller == bigger || Typ.struct_less_than smaller bigger

  def Typ.struct_less_than : Typ → Typ → Bool
    | (.entry ll tl), (.entry lr tr) => ll == lr && Typ.struct_less_than tl tr
    | tl, (.entry _ tr) => tl == tr || Typ.struct_less_than tl tr

    | (.inter a b), c =>
      (Typ.struct_less_than a c && Typ.struct_lte b c) ||
      (Typ.struct_lte a c && Typ.struct_less_than b c)
    | a, (.inter b c) => Typ.struct_less_than a b || Typ.struct_less_than a c
    | a, (.unio b c) => Typ.struct_less_than a b && Typ.struct_less_than a c

    | (.var id), (.exi _ qs body )  =>
      let bs := ListSubtyping.bounds id .true qs
      ListSubtyping.var_restricted id qs &&
      ListTyp.struct_less_than bs body
    | (.var _), .top => .true
    | (.var _), .unit => .true
    | _, _ => .false
end

  -- def Subtyping.check
  --   (skolems : List String) (assums : List (Typ × Typ)) (lower upper : Typ) : Bool
  -- :=
  --   ((Typ.toBruijn [] lower) == (Typ.toBruijn [] upper)) || match lower, upper with
  --   | .entry l body, .entry l' body' =>
  --     l = l' && Subtyping.check skolems assums body body'
  --   | lower, .inter left right =>
  --     Subtyping.check skolems assums lower left && Subtyping.check skolems assums lower right
  --   | lower, .exi _ [] body => Subtyping.check skolems assums lower body
  --   | .unio left right, upper =>
  --     (Subtyping.check skolems assums left upper) && (Subtyping.check skolems assums right upper)
  --   | .inter left right, upper =>
  --     Subtyping.check skolems assums left upper || Subtyping.check skolems assums right upper
  --   | lower, .unio left right =>
  --     Subtyping.check skolems assums lower left || Subtyping.check skolems assums lower right
  --   | .exi ids [] body, upper => Subtyping.check (ids ∪ skolems) assums body upper
  --   | _, _ => .true

-- NOTE: this should be complete, but not sound
-- TODO: see if Subtyping.check and Subtyping.check can become one
def Subtyping.check : Typ → Typ → Bool
| .entry l k, .entry l' t =>
  l == l' && Subtyping.check k t
| k, .diff left right =>
  Subtyping.check k left && not (Subtyping.check k right)
| k, .exi _ _ t => Subtyping.check k t
| .exi _ _ k, t => Subtyping.check k t
| k, .inter left right =>
  Subtyping.check k left && Subtyping.check k right
| .unio left right, t =>
  Subtyping.check left t && Subtyping.check right t
| .inter left right, t =>
  Subtyping.check left t || Subtyping.check right t
| k, .unio left right =>
  Subtyping.check k left || Subtyping.check k right
| _,_ => .true



-- TODO: must prove that if peelable holds then subtyping is sound and complete
def Subtyping.peelable (key target : Typ) : Bool :=
  let ts := Typ.break .false target
  not (List.all ts (fun t => Subtyping.check key t))
  -- not (List.all ts (fun t => Subtyping.check [] [] key t))

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

-- def Typ.merge_paths (t : Typ) : Option Typ :=
--   let cases := Typ.break .true t
--   do
--   let (ls, rs) ← Typ.break_paths cases
--   return .path (Typ.combine .false ls) (Typ.combine .false rs)



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
  let outer_ids := (ListSubtyping.free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (ListSubtyping.free_vars inner ∪ fids) (Θ ∪ pids)
  BiZone.wrap b outer_ids outer inner_ids inner t

def ListZone.pack (pids : List String) (b : Bool) : List Zone → Typ
| .nil => Typ.base b
| .cons zone zones =>
  let l := Zone.pack pids .true zone
  let r := ListZone.pack pids .true zones
  Typ.rator b l r

def Subtyping.restricted
  (skolems : List String) (assums : List (Typ × Typ)) (lower upper : Typ) : Bool
:=
  Typ.is_pattern [] upper ||
  (match lower, upper with
  | .var id, _ =>
    if id ∉ skolems then
      let i := Typ.interpret_one id .true assums
      (Typ.toBruijn [] i) == (Typ.toBruijn [] .bot)
    else
      .false
  | _, .var id =>
    if id ∉ skolems then
      let i := Typ.interpret_one id .false assums
      (Typ.toBruijn [] i) == (Typ.toBruijn [] .top)
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
      let ids' := ids ∩ (ListSubtyping.free_vars quals' ∪ Typ.free_vars body')
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


-- the weakest type t such that every inhabitant matches pattern p
inductive PatLifting.Static
: List (Typ × Typ) → List (String × Typ) →
  Pat → Typ → List (Typ × Typ) → List (String × Typ) → Prop

| var Δ Γ id tid :
  PatLifting.Static
  Δ Γ (.var id) (.var tid)
  ((.var tid, Typ.top) :: Δ)  ((id, .var tid) :: (remove id Γ))

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

mutual
  def ListPatLifting.Static.compute (Δ : ListSubtyping) (Γ : List (String × Typ))
  : List (String × Pat) →  Lean.MetaM (Typ × ListSubtyping × List (String × Typ))
  | [] => return (Typ.top, Δ, Γ)
  | (l,p) :: [] => do
    let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ p
    return (Typ.entry l t, Δ', Γ')

  | (l,p) :: remainder => do
    let (t, Δ', Γ') ← PatLifting.Static.compute Δ Γ p
    let (t', Δ'', Γ'') ← ListPatLifting.Static.compute Δ' Γ' remainder
    return (Typ.inter (Typ.entry l t) t', Δ'', Γ'')



  def PatLifting.Static.compute (Δ : ListSubtyping) (Γ : ListTyping)
  : Pat → Lean.MetaM (Typ × ListSubtyping × ListTyping)
  | .var id => do
    let t := Typ.var (← fresh_typ_id)
    let Δ' := (t, Typ.top) :: Δ
    let Γ' := ((id, t) :: (remove id Γ))
    return (t, Δ', Γ')
  | .unit => return (Typ.top, Δ, Γ)
  | .record items => ListPatLifting.Static.compute Δ Γ items
end

syntax "PatLifting_Static_prove" : tactic
macro_rules
| `(tactic| PatLifting_Static_prove) => `(tactic|
  (first
    | apply PatLifting.Static.var
    | apply PatLifting.Static.unit
    | apply PatLifting.Static.record_nil
    | apply PatLifting.Static.record_single
      · PatLifting_Static_prove
    | apply PatLifting.Static.record_cons
      · PatLifting_Static_prove
      · PatLifting_Static_prove
      · simp [Pat.free_vars, ListPat.free_vars]; rfl
  ) <;> fail
)

mutual


  partial def ListSubtyping.Static.solve
    (skolems : List String) (assums : ListSubtyping)
  : ListSubtyping → Lean.MetaM (List (List String × ListSubtyping))
    | [] => return [(skolems, assums)]
    | (lower,upper) :: remainder => do
      let worlds ← Subtyping.Static.solve skolems assums lower upper
      (worlds.flatMapM (fun (skolems',assums') =>
        ListSubtyping.Static.solve skolems' assums' remainder
      ))

  partial def Subtyping.Static.solve
    (skolems : List String) (assums : ListSubtyping) (lower upper : Typ )
  : Lean.MetaM (List (List String × ListSubtyping))
  := if (Typ.toBruijn [] lower) == (Typ.toBruijn [] upper) then
    return [(skolems,assums)]
  else match lower, upper with
    | (.entry ll lower), (.entry lu upper) =>
      if ll == lu then
        Subtyping.Static.solve skolems assums lower upper
      else return []

    | (.path p q), (.path x y) => do
      (← Subtyping.Static.solve skolems assums x p).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' q y)
      )

    | .bot, _ => return [(skolems,assums)]
    | _, .top => return [(skolems,assums)]

    | (.unio a b), t => do
      (← Subtyping.Static.solve skolems assums a t).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' b t)
      )

    | (.exi ids quals body), t => do
      if ListSubtyping.restricted skolems assums quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← ListSubtyping.Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
          (Subtyping.Static.solve (ids' ∪ skolems') assums' body' t)
        )
      else return []


    | t, (.inter a b) => do
      (← Subtyping.Static.solve skolems assums t a).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' t b)
      )

    | t, (.all ids quals body) =>
      if ListSubtyping.restricted skolems assums quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← ListSubtyping.Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
          (Subtyping.Static.solve (ids' ∪ skolems') assums' t body')
        )
      else return []

    | (.var id), t => do
      if id ∉ skolems then
        let lowers_id := ListSubtyping.bounds id .true assums
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (.var id, t) :: assums')
        )
      else if (assums.exi (fun
        | (.var idl, .var idu) => idl == id && not (skolems.contains idu)
        | _ => .false
      )) then
        let lowers_id := ListSubtyping.bounds id .true assums
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (.var id, t) :: assums')
        )
      else
        let uppers_id := ListSubtyping.bounds id .false assums
        (uppers_id.flatMapM (fun upper_id =>
          let pass := (match upper_id with
            | .var id' => skolems.contains id'
            | _ => true
          )
          (if pass then
            (Subtyping.Static.solve skolems assums upper_id t)
          else
            return []
          )
        ))

    | t, (.var id) => do
      if not (skolems.contains id) then
        let uppers_id := ListSubtyping.bounds id .false assums
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (t, .var id) :: assums')
        )
      else if (assums.exi (fun
        | (.var idl, .var idu) => idu == id && not (skolems.contains idl)
        | _ => .false
      )) then
        let uppers_id := ListSubtyping.bounds id .false assums
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (t, .var id) :: assums')
        )
      else do
        let lowers_id := ListSubtyping.bounds id .true assums
        (lowers_id.flatMapM (fun lower_id =>
          let pass := (match lower_id with
            | .var id' => skolems.contains id'
            | _ => true
          )
          (if pass then
            (Subtyping.Static.solve skolems assums t lower_id)
          else
            return []
          )
        ))


    | l, (.path (.unio a b) r) =>
      Subtyping.Static.solve skolems assums l (.inter (.path a r) (.path b r))


    | l, (.path r (.inter a b)) =>
      Subtyping.Static.solve skolems assums l (.inter (.path r a) (.path r b))

    | t, (.entry l (.inter a b)) =>
      Subtyping.Static.solve skolems assums t (.inter (.entry l a) (.entry l b))


    | (.lfp id left), upper =>
      if not (left.free_vars.contains id) then
        Subtyping.Static.solve skolems assums left upper
      else if Typ.Monotonic.Static.decide id .true left then do
        let result ← Subtyping.Static.solve skolems assums (Typ.sub [(id, upper)] left) upper
        if not result.isEmpty then
          return result
        else
          match upper with
          | (.entry l right) => match Typ.factor id left l with
              | .some fac  => Subtyping.Static.solve skolems assums (.lfp id fac) right
              | .none => return []
          | (.diff l r) => match Typ.height r with
              | .some h =>
                if (
                  Typ.is_pattern [] r &&
                  Typ.Monotonic.Static.decide id .true left &&
                  Typ.struct_less_than (.var id) left &&
                  not (Subtyping.check (Typ.subfold id left 1) r) &&
                  not (Subtyping.check r (Typ.subfold id left h))
                ) then
                  Subtyping.Static.solve skolems assums left l
                else return []
              | .none => return []
          | _ => return []
      else return []

    | t, (.diff l r) =>
      if (
        Typ.is_pattern [] r &&
        ¬ Subtyping.check t r &&
        ¬ Subtyping.check r t
      ) then
        Subtyping.Static.solve skolems assums t l
      else
        return []
--
    | l, (.lfp id r) =>
      if Subtyping.peelable l r then
        Subtyping.Static.solve skolems assums l (.sub [(id, .lfp id r)] r)
      else
        let r' := Typ.drop id r
        Subtyping.Static.solve skolems assums l r'

    | (.diff l r), t =>
      Subtyping.Static.solve skolems assums l (.unio r t)


    | t, (.unio l r) => do
      return (
        (← Subtyping.Static.solve skolems assums t l) ++
        (← Subtyping.Static.solve skolems assums t r)
      )

    | l, (.exi ids quals r) => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let r' := Typ.sub subs r
      let quals' := ListSubtyping.sub subs quals
      (← Subtyping.Static.solve skolems assums l r').flatMapM (fun (θ',assums') =>
        ListSubtyping.Static.solve θ' assums' quals'
      )


    -- TODO: consider removing path merging. union antecedent rule should be sufficient
    -- | (.inter l r), t => match t with
    --   | .path p q => match Typ.merge_paths (.inter l r) with
    --     | .some t' => Subtyping.Static.solve skolems assums t' (.path p q)
    --     | .none => return (
    --       (← Subtyping.Static.solve skolems assums l t) ++
    --       (← Subtyping.Static.solve skolems assums r t)
    --     )
    --   | _ => return (
    --     (← Subtyping.Static.solve skolems assums l t) ++
    --     (← Subtyping.Static.solve skolems assums r t)
    --   )

    | (.inter l r), t => do
      return (
        (← Subtyping.Static.solve skolems assums l t) ++
        (← Subtyping.Static.solve skolems assums r t)
      )

    | (.all ids quals l), r  => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let l' := Typ.sub subs l
      let quals' := ListSubtyping.sub subs quals
      (← Subtyping.Static.solve skolems assums l' r).flatMapM (fun (θ',assums') =>
        ListSubtyping.Static.solve θ' assums' quals'
      )

    | _, _ => return []

end




lemma lower_bound_map id (cs : ListSubtyping) (t : Typ) : ∀ ts,
      ListSubtyping.bounds id .true cs = ts →
      (∀ t', (t', Typ.var id) ∈ cs → (t', t) ∈ ts.map (fun t' => (t', t)))
:= by induction cs with
| nil =>
  simp [ListSubtyping.bounds]
  intros
  intro
  contradiction
| cons head tail ih =>
  simp [ListSubtyping.bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  intro t'
  intro m
  cases m with
  | head =>
    simp [Typ.refl_BEq_true]
  | tail _ m'' =>
    cases (Typ.var id == upper) with
      | false =>
        apply ih
        assumption
      | true =>
        simp
        apply Or.inr
        apply ih
        assumption


lemma upper_bound_map id (cs : ListSubtyping) (t : Typ) : ∀ ts,
      ListSubtyping.bounds id .false cs = ts →
      (∀ t', (Typ.var id, t') ∈ cs → (t, t') ∈ ts.map (fun t' => (t, t')))
:= by induction cs with
| nil =>
  simp [ListSubtyping.bounds]
  intros
  intro
  contradiction
| cons head tail ih =>
  simp [ListSubtyping.bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  intro t'
  intro m
  cases m with
  | head =>
    simp [Typ.refl_BEq_true]
  | tail _ m'' =>
    cases (Typ.var id == lower) with
    | false =>
      apply ih
      assumption
    | true =>
      simp
      apply Or.inr
      apply ih
      assumption

lemma skolem_lower_bound id (assums : ListSubtyping) (skolems : List String) :
  assums.exi (fun
  | (.var idl, .var idu) => idl == id && not (skolems.contains idu)
  | _ => .false
  )
  →
  ∃ idu, (Typ.var id, Typ.var idu) ∈ assums ∧ idu ∉ skolems
:= by
  simp_all [List.exi]
  intros l u m
  cases l with
  | var idl => cases u with
    | var idu =>
      simp [*]
      intro e
      intro p
      exists idu
      simp [*]
      rw [← e]
      assumption
    | _ => simp
  | _ => simp


lemma skolem_upper_bound id (assums : ListSubtyping) (skolems : List String) :
  assums.exi (fun
  | (.var idl, .var idu) => idu == id && not (skolems.contains idl)
  | _ => .false
  )
  →
  ∃ idl, (Typ.var idl, Typ.var id) ∈ assums ∧ idl ∉ skolems
:= by
  simp_all [List.exi]
  intros l u m
  cases l with
  | var idl => cases u with
    | var idu =>
      simp [*]
      intro e
      intro p
      exists idl
      simp [*]
      rw [← e]
      assumption
    | _ => simp
  | _ => simp

      -- else if (assums.exi (fun
      --   | (.var idl, .var idu) => idu == id && idl ∉ skolems
      --   | _ => .false
      -- )) then

lemma lower_bound_mem id cs t : ∀ ts,
  ListSubtyping.bounds id .true cs = ts →
  t ∈ ts → (t, .var id) ∈ cs
:= by induction cs with
| nil =>
  simp [ListSubtyping.bounds]
| cons head tail ih =>
  simp [ListSubtyping.bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  cases b : (Typ.var id == upper) with
  | true =>
    apply Typ.BEq_true_implies_eq at b
    simp [*]
    intro c
    cases c with
    | inl d =>
      rw [d]
      apply List.mem_cons_self
    | inr d =>
      apply ih at d
      rw [← b]
      apply List.mem_cons_of_mem
      assumption
  | false =>
    simp
    intro h
    apply ih at h
    apply List.mem_cons_of_mem
    assumption

lemma upper_bound_mem id cs t : ∀ ts,
  ListSubtyping.bounds id .false cs = ts →
  t ∈ ts → (.var id, t) ∈ cs
:= by induction cs with
| nil =>
  simp [ListSubtyping.bounds]
| cons head tail ih =>
  simp [ListSubtyping.bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  cases b : (Typ.var id == lower) with
  | true =>
    apply Typ.BEq_true_implies_eq at b
    simp [*]
    intro c
    cases c with
    | inl d =>
      rw [d]
      apply List.mem_cons_self
    | inr d =>
      apply ih at d
      rw [← b]
      apply List.mem_cons_of_mem
      assumption
  | false =>
    simp
    intro h
    apply ih at h
    apply List.mem_cons_of_mem
    assumption


mutual
  inductive ListSubtyping.Static
  : List String → List (Typ × Typ) → List (Typ × Typ)
  → List String → List (Typ × Typ) → Prop
    | nil {skolems assums} : ListSubtyping.Static skolems assums [] skolems assums
    | cons {skolems assums skolems'' assums''} l r cs skolems' assums' :
      Subtyping.Static skolems assums l r skolems' assums' →
      ListSubtyping.Static skolems' assums' cs skolems'' assums'' →
      ListSubtyping.Static skolems assums ((l,r) :: cs) skolems'' assums''


  inductive Subtyping.Static
  : List String → List (Typ × Typ)
  → Typ → Typ
  → List String → List (Typ × Typ) → Prop
    | refl skolems assums t :
      Subtyping.Static skolems assums t t skolems assums

    -- implication preservation
    | entry_pres {skolems assums skolems' assums' } l lower upper :
      Subtyping.Static skolems assums lower upper skolems' assums' →
      Subtyping.Static skolems assums (.entry l lower) (.entry l upper) skolems' assums'

    | path_pres {skolems assums skolems'' assums''} p q x y  skolems' assums' :
      Subtyping.Static skolems assums x p skolems' assums' →
      Subtyping.Static skolems' assums' q y skolems'' assums'' →
      Subtyping.Static skolems assums (.path p q) (.path x y) skolems'' assums''

    -- bottom elimination
    | bot_elim skolems assums t :
      Subtyping.Static skolems assums .bot t skolems assums

    -- top introduction
    | top_intro skolems assums t :
      Subtyping.Static skolems assums t .top skolems assums

    -- expansion elimination
    | unio_elim {skolems assums skolems'' assums''} left right t skolems' assums' :
      Subtyping.Static skolems assums left t skolems' assums' →
      Subtyping.Static skolems' assums' right t skolems'' assums'' →
      Subtyping.Static skolems assums (.unio left right) t skolems'' assums''

    | exi_elim {skolems assums skolems'' assums''} ids quals body t skolems' assums' :
      ListSubtyping.restricted skolems assums quals →
      ids ∩ Typ.free_vars t = [] →
      -- NOTE: require quals to contain all bound variables so we can use it for freshness guarantees
      ids ⊆ ListSubtyping.free_vars quals →
      ListSubtyping.Static skolems assums quals skolems' assums' →
      Subtyping.Static (ids ++ skolems') assums' body t skolems'' assums'' →
      Subtyping.Static skolems assums (.exi ids quals body) t skolems'' assums''

    -- refinement introduction
    | inter_intro {skolems assums skolems'' assums''} t left right skolems' assums' :
      Subtyping.Static skolems assums t left skolems' assums' →
      Subtyping.Static skolems' assums' t right skolems'' assums'' →
      Subtyping.Static skolems assums t (.inter left right) skolems'' assums''

    | all_intro {skolems assums skolems'' assums''} t ids quals body skolems' assums' :
      ListSubtyping.restricted skolems assums quals →
      ids ∩ Typ.free_vars t = [] →
      ids ⊆ ListSubtyping.free_vars quals →
      ListSubtyping.Static skolems assums quals skolems' assums' →
      Subtyping.Static (ids ++ skolems') assums' t body skolems'' assums'' →
      Subtyping.Static skolems assums t (.all ids quals body) skolems'' assums''

    -- placeholder elimination
    | placeholder_elim {skolems assums t skolems'} id cs assums' :
      id ∉ skolems →
      (∀ t', (t', .var id) ∈ assums → (t', t) ∈ cs) →
      ListSubtyping.Static skolems assums cs skolems' assums' →
      Subtyping.Static skolems assums (.var id) t skolems' ((.var id, t) :: assums')

    -- placeholder introduction
    | placeholder_intro {skolems assums t skolems'} id cs assums' :
      id ∉ skolems →
      (∀ t', (.var id, t') ∈ assums → (t, t') ∈ cs) →
      ListSubtyping.Static skolems assums cs skolems' assums' →
      Subtyping.Static skolems assums t (.var id) skolems' ((t, .var id) :: assums')

    -- skolem placeholder introduction
    | skolem_placeholder_intro {skolems assums t skolems'} id cs assums' :
      id ∈ skolems →
      (∃ id', (.var id', .var id) ∈ assums ∧ id' ∉ skolems) →
      (∀ t', (.var id, t') ∈ assums → (t, t') ∈ cs) →
      ListSubtyping.Static skolems assums cs skolems' assums' →
      Subtyping.Static skolems assums t (.var id) skolems' ((t, .var id) :: assums')

    -- skolem introduction
    | skolem_intro {skolems assums t skolems' assums'} t' id :
      id ∈ skolems →
      (t', .var id) ∈ assums →
      (∀ id', (.var id') = t' → id' ∈ skolems) →
      Subtyping.Static skolems assums t t' skolems' assums' →
      Subtyping.Static skolems assums t (.var id) skolems' assums'

    -- skolem placeholder elimination
    | skolem_placeholder_elim {skolems assums t skolems'} id cs assums':
      id ∈ skolems →
      (∃ id', (.var id, .var id') ∈ assums ∧ id' ∉ skolems) →
      (∀ t', (t', .var id) ∈ assums → (t', t) ∈ cs) →
      ListSubtyping.Static skolems assums cs skolems' assums' →
      Subtyping.Static skolems assums (.var id) t skolems' ((.var id, t) :: assums')

    -- skolem elimination
    | skolem_elim {skolems assums t skolems' assums'} t' id :
      id ∈ skolems →
      (.var id, t') ∈ assums →
      (∀ id', (.var id') = t → id' ∈ skolems) →
      Subtyping.Static skolems assums t' t skolems' assums' →
      Subtyping.Static skolems assums (.var id) t skolems' assums'

    | unio_antec {skolems assums l skolems'' assums''} a b upper assums' skolems' :
      Subtyping.Static skolems assums l (.path a upper) skolems' assums' →
      Subtyping.Static skolems' assums' l (.path b upper) skolems'' assums'' →
      Subtyping.Static skolems assums l (.path (.unio a b) upper) skolems'' assums''

    | inter_conseq {skolems assums l skolems'' assums''} upper a b skolems' assums':
      Subtyping.Static skolems assums l (.path upper a) skolems' assums' →
      Subtyping.Static skolems' assums' l (.path upper b) skolems'' assums'' →
      Subtyping.Static skolems assums l (.path upper (.inter a b)) skolems'' assums''

    | inter_entry {skolems assums t skolems'' assums''} l a b skolems' assums':
      Subtyping.Static skolems assums t (.entry l a) skolems' assums' →
      Subtyping.Static skolems' assums' t (.entry l b) skolems'' assums'' →
      Subtyping.Static skolems assums t (.entry l (.inter a b)) skolems'' assums''

    -- least fixed point elimination
    | lfp_skip_elim {skolems assums right skolems' assums'} id body :
      id ∉ Typ.free_vars body →
      Subtyping.Static skolems assums body right skolems' assums' →
      Subtyping.Static skolems assums (.lfp id body) right skolems' assums'

    | lfp_induct_elim {skolems assums upper skolems' assums'} id lower :
      Typ.Monotonic.Static id .true lower →
      Subtyping.Static skolems assums (Typ.sub [(id, upper)] lower) upper skolems' assums' →
      Subtyping.Static skolems assums (.lfp id lower) upper skolems' assums'

    | lfp_factor_elim {skolems assums l skolems' assums'} id lower upper fac :
      Typ.factor id lower l = .some fac →
      Subtyping.Static skolems assums fac upper skolems' assums' →
      Subtyping.Static skolems assums (.lfp id lower) (.entry l upper) skolems' assums'

    | lfp_elim_diff_intro {skolems assums skolems' assums'} id lower upper sub h :
      -- TODO: check if is_pattern is subsumed by check
      Typ.is_pattern [] sub →
      -- TODO: struct_less_than might not be necessary
      Typ.struct_less_than (.var id) lower →
      Typ.height sub = .some h →
      Typ.Monotonic.Static id .true lower →
      Subtyping.Static skolems assums (.lfp id lower) upper skolems' assums' →
      ¬ (Subtyping.check (Typ.subfold id lower 1) sub) →
      ¬ (Subtyping.check sub (Typ.subfold id lower h)) →
      Subtyping.Static skolems assums (.lfp id lower) (.diff upper sub) skolems' assums'

    -- difference introduction
    | diff_intro {skolems assums lower skolems' assums'} upper sub:
      Typ.is_pattern [] sub →
      ¬ Subtyping.check lower sub →
      ¬ Subtyping.check sub lower →
      Subtyping.Static skolems assums lower upper skolems' assums' →
      Subtyping.Static skolems assums lower (.diff upper sub) skolems' assums'


    -- least fixed point introduction
    | lfp_peel_intro {skolems assums lower skolems' assums'} id body :
      -- TODO: peelable is a heuristic;
      -- it's not necessary for soundness
      -- consider merely using it in tactic
      Subtyping.peelable lower body →
      Subtyping.Static skolems assums lower (.sub [(id, .lfp id body)] body) skolems' assums' →
      Subtyping.Static skolems assums lower (.lfp id body) skolems' assums'

    | lfp_drop_intro {skolems assums lower skolems' assums'} id body :
      Subtyping.Static skolems assums lower (Typ.drop id body) skolems' assums' →
      Subtyping.Static skolems assums lower (.lfp id body) skolems' assums'

    -- difference sub elimination
    | diff_sub_elim {skolems assums skolems' assums'} lower sub upper :
      Subtyping.Static skolems assums lower sub skolems' assums' →
      Subtyping.Static skolems assums (.diff lower sub) upper skolems' assums'

    -- difference upper elimination
    | diff_upper_elim {skolems assums upper skolems' assums'} lower sub :
      Subtyping.Static skolems assums lower upper skolems' assums' →
      Subtyping.Static skolems assums (.diff lower sub) upper skolems' assums'


    -- expansion introduction
    | unio_left_intro {skolems assums skolems' assums'} t l r:
      Subtyping.Static skolems assums t l skolems' assums' →
      Subtyping.Static skolems assums t (.unio l r) skolems' assums'

    | unio_right_intro {skolems assums skolems' assums'} t l r :
      Subtyping.Static skolems assums t r skolems' assums' →
      Subtyping.Static skolems assums t (.unio l r) skolems' assums'

    | exi_intro {skolems assums lower skolems'' assums''} ids quals upper skolems' assums' :
      Subtyping.Static skolems assums lower upper skolems' assums' →
      ListSubtyping.Static skolems' assums' quals skolems'' assums'' →
      Subtyping.Static skolems assums lower (.exi ids quals upper)  skolems'' assums''

    -- refinement elimination
    | inter_left_elim {skolems assums skolems' assums'} l r t :
      Subtyping.Static skolems assums l t skolems' assums' →
      Subtyping.Static skolems assums (.inter l r) t skolems' assums'

    | inter_right_elim {skolems assums skolems' assums'} l r t :
      Subtyping.Static skolems assums r t skolems' assums' →
      Subtyping.Static skolems assums (.inter l r) t skolems' assums'

    -- | inter_merge_elim skolems assums l r p q t skolems' assums' :
    --   Typ.merge_paths (.inter l r) = .some t →
    --   Subtyping.Static skolems assums t (.path p q) skolems' assums' →
    --   Subtyping.Static skolems assums (.inter l r) (.path p q) skolems' assums'

    | all_elim {skolems assums upper skolems'' assums''} ids quals lower skolems' assums' :
      Subtyping.Static skolems assums lower upper skolems' assums' →
      ListSubtyping.Static skolems' assums' quals skolems'' assums'' →
      Subtyping.Static skolems assums (.all ids quals lower) upper skolems'' assums''

end


syntax "ListSubtyping_Static_prove" : tactic
syntax "Subtyping_Static_prove" : tactic

macro_rules
  | `(tactic| ListSubtyping_Static_prove) => `(tactic|
    (first
      | apply ListSubtyping.Static.nil
      | apply ListSubtyping.Static.cons
        · Subtyping_Static_prove
        · ListSubtyping_Static_prove
    ) <;> fail
  )
  | `(tactic| Subtyping_Static_prove) => `(tactic|
    (first
      | apply Subtyping.Static.refl
      | apply Subtyping.Static.entry_pres
        · Subtyping_Static_prove
      | apply Subtyping.Static.path_pres
        · Subtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.bot_elim
      | apply Subtyping.Static.top_intro
      | apply Subtyping.Static.unio_elim
        · Subtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.exi_elim
        · rfl
        · ListSubtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.inter_intro
        · Subtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.all_intro
        · rfl
        · ListSubtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.placeholder_elim
        · simp
        · apply lower_bound_map
          · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · ListSubtyping_Static_prove

      | apply Subtyping.Static.placeholder_intro
        · simp
        · apply upper_bound_map
          · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · ListSubtyping_Static_prove

      | apply Subtyping.Static.skolem_placeholder_intro
        -- · simp
        -- · simp
        · apply List.Mem.head
        · apply skolem_upper_bound
          · reduce; simp
        · apply upper_bound_map
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · ListSubtyping_Static_prove

      | apply Subtyping.Static.skolem_intro
        · apply List.mem_of_elem_eq_true; rfl
        · apply lower_bound_mem
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
          · simp [Typ.refl_BEq_true]; rfl
        · simp
        · Subtyping_Static_prove

      | apply Subtyping.Static.skolem_placeholder_elim
        · apply List.Mem.head
        · apply skolem_lower_bound
          · reduce; simp
        · apply lower_bound_map
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · ListSubtyping_Static_prove







      | apply Subtyping.Static.skolem_elim
        · apply List.mem_of_elem_eq_true; rfl
        · apply upper_bound_mem
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
          · simp [Typ.refl_BEq_true]; rfl
        · simp
        · Subtyping_Static_prove

      | apply Subtyping.Static.unio_antec
        · Subtyping_Static_prove

      | apply Subtyping.Static.inter_conseq
        · Subtyping_Static_prove

      | apply Subtyping.Static.inter_entry
        · Subtyping_Static_prove

      | apply Subtyping.Static.lfp_factor_elim
        · rfl
        · reduce; Subtyping_Static_prove

      | apply Subtyping.Static.lfp_skip_elim
        · exact Iff.mp List.count_eq_zero rfl
        · Subtyping_Static_prove

      | apply Subtyping.Static.lfp_induct_elim
        · Typ_Monotonic_Static_prove
        · reduce; Subtyping_Static_prove

      | apply Subtyping.Static.lfp_elim_diff_intro
        · reduce; rfl
        · Typ_Monotonic_Static_prove
        · simp [
            Typ.struct_less_than, Typ.top, ListSubtyping.var_restricted,
            ListSubtyping.bounds, ListTyp.struct_less_than,
            Typ.refl_BEq_true
          ]
        · simp; reduce
          simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ]; reduce
          simp
        · reduce; rfl
        · simp; reduce
          simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ]; reduce
          simp
        · Subtyping_Static_prove

      | apply Subtyping.Static.diff_intro
        · rfl
        · simp; reduce
          simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ]; reduce
          simp
        · simp; reduce
          simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ]; reduce
          simp
        · Subtyping_Static_prove


      | apply Subtyping.Static.lfp_peel_intro
        · simp [Subtyping.peelable, Typ.break, Subtyping.check]
        · simp [Typ.sub, find] ; Subtyping_Static_prove

      | apply Subtyping.Static.lfp_drop_intro
        · rfl
        · Subtyping_Static_prove

      | apply Subtyping.Static.diff_elim
        · Subtyping_Static_prove

      | apply Subtyping.Static.unio_left_intro
        · Subtyping_Static_prove

      | apply Subtyping.Static.unio_right_intro
        · Subtyping_Static_prove

      | apply Subtyping.Static.exi_intro
        · Subtyping_Static_prove
        · ListSubtyping_Static_prove

      | apply Subtyping.Static.inter_left_elim
        · Subtyping_Static_prove

      | apply Subtyping.Static.inter_right_elim
        · Subtyping_Static_prove

      -- | apply Subtyping.Static.inter_merge_elim
      --   · rfl
      --   · Subtyping_Static_prove

      | apply Subtyping.Static.all_elim
        · Subtyping_Static_prove
        · ListSubtyping_Static_prove
    ) <;> fail
  )





#check Option.mapM

mutual
  partial def Typing.ListPath.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) :
    List (Pat × Expr) → Lean.MetaM (List Zone × List Typ)
  | [] => return ([], [])

  | (p,e)::f => do
    let (zones, subtras) ← Typing.ListPath.Static.infer Θ Δ Γ f
    let (tp, Δ', Γ') ←  PatLifting.Static.compute Δ Γ p
    let tl := ListTyp.diff tp subtras
    let zones' := (← Typing.Static.infer Θ Δ' Γ' e).map (fun ⟨Θ', Δ'', tr ⟩ =>
      ⟨List.diff Θ' Θ, List.diff Δ'' Δ', (.path tl tr)⟩ )
    let subtra := Typ.capture tp
    match ListZone.tidy (ListSubtyping.free_vars Δ) zones' with
    | .some zones'' => return (zones'' ++ zones, subtra :: subtras)
    | .none => failure


  partial def Subtyping.GuardedListZone.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ)) :
    Typ → Typ → Lean.MetaM (List Zone)
  | t, .var id => do
    let id' ← fresh_typ_id
    let t' := .var id'
    let zones := (← Subtyping.Static.solve Θ Δ t (.path (.var id) t')).map (fun (Θ', Δ') =>
      ⟨List.diff Θ' Θ, List.diff Δ' Δ, t'⟩
    )
    match (ListZone.tidy (ListSubtyping.free_vars Δ) zones) with
      | .some zones' => return zones'
      | .none => failure
  | _, _ => failure

  partial def Typing.ListZone.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (e : Expr) :
  Lean.MetaM (List Zone) := do
    (← Typing.Static.infer Θ Δ Γ e).mapM (fun  ⟨Θ', Δ', t⟩ =>
      return ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩
    )

    partial def Subtyping.LoopListZone.Static.infer
      (pids : List String) (id : String) :
      List Zone →
    Lean.MetaM Typ
    | [⟨Θ, Δ, .path (.var idl) r⟩] =>
      if id != idl then do
        match (
          (ListSubtyping.invert id Δ).bind (fun Δ' =>
            let t' := Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩
            (Typ.factor id t' "left").bind (fun l =>
            (Typ.factor id t' "right").map (fun r' => do
              let l' ← Typ.UpperFounded.compute id l
              let r'' := Typ.sub [(idl, .lfp id l')] r'
              if Typ.Monotonic.Static.decide idl .true r' then
                return (.path (.var idl) (.lfp id r''))
              else
                failure
            ))
          )
        ) with
          | .some result => result
          | .none => failure
      else failure

    | zones => match (
      (ListZone.invert id zones).bind (fun zones' =>
        let t' := ListZone.pack (id :: pids) .false zones'
        (Typ.factor id t' "left").bind (fun l =>
        (Typ.factor id t' "right").map (fun r =>
          return (.path (.lfp id l) (.lfp id r))
        ))
      )
    ) with
      | .some result => result
      | .none => failure


    partial def Typing.Static.infer
      (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) :
      Expr → Lean.MetaM (List Zone)
    | .unit => return [⟨Θ, Δ, .top⟩]
    | .var x =>  match find x Γ with
      | .some t => return [⟨Θ, Δ, t⟩]
      | .none => failure

    | .record [] =>  return [⟨Θ, Δ, .top⟩]

    | .record ((l,e) :: r) => do
      (← (Typing.Static.infer Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      (← (Typing.Static.infer Θ' Δ' Γ (.record r))).flatMapM (fun ⟨Θ'', Δ'',t'⟩ =>
        return [⟨Θ'', Δ'', (.inter (.entry l t) (t'))⟩]
      ))

    | (.function f) => do
      let (zones, _) ← (Typing.ListPath.Static.infer Θ Δ Γ f)
      let t := ListZone.pack (ListSubtyping.free_vars Δ) .true zones
      return [⟨Θ, Δ, t⟩]


    | (.app ef ea) => do
      let α ← fresh_typ_id
      (← Typing.Static.infer Θ Δ Γ ef).flatMapM (fun ⟨Θ', Δ', tf⟩ => do
      (← Typing.Static.infer Θ' Δ' Γ ea).flatMapM (fun ⟨Θ'', Δ'', ta⟩ => do
      (← Subtyping.Static.solve Θ'' Δ'' tf (.path ta (.var α))).flatMapM (fun ⟨Θ''', Δ'''⟩ =>
        return [⟨Θ''', Δ''', (.var α)⟩]
        )))

    | (.loop e) => do
      let id ← fresh_typ_id
      (← Typing.Static.infer Θ Δ Γ e).flatMapM (fun ⟨Θ', Δ', t⟩ => do
        let zones ← Subtyping.GuardedListZone.Static.infer Θ' Δ' t (.var id)
        let t' ← Subtyping.LoopListZone.Static.infer (ListSubtyping.free_vars Δ') id zones
        return [⟨Θ', Δ', t'⟩]
      )



    | (.anno e ta) =>
      if Typ.free_vars ta == [] then do
        let zones ← Typing.ListZone.Static.infer Θ Δ Γ e
        let te := ListZone.pack (ListSubtyping.free_vars Δ) .false zones
        (← Subtyping.Static.solve Θ Δ te ta).flatMapM (fun (Θ', Δ') =>
          return [⟨Θ', Δ', ta⟩]
        )
      else
        return []

end


inductive Subtyping.LoopListZone.Static : List String → String → List Zone → Typ → Prop
| batch {pids id zones} zones' t' left right :
  ListZone.invert id zones = .some zones' →
  ListZone.pack (id :: pids) .false zones' = t' →
  -- TODO; consider if monotonicity can be derived from invert and pack
  Typ.Monotonic.Static id .true t' →
  Typ.factor id t' "left" = .some left →
  Typ.factor id t' "right" = .some right →
  Subtyping.LoopListZone.Static pids id zones (.path (.lfp id left) (.lfp id right))

| stream {pids id} skolems assums assums' idl r t' l r' l' r'' :
  id ≠ idl →
  ListSubtyping.invert id assums = .some assums' →
  Zone.pack (id :: idl :: pids) .false ⟨skolems, assums', .pair (.var idl) r⟩ = t' →
  Typ.Monotonic.Static id .true t' →
  Typ.factor id t' "left" = .some l →
  Typ.factor id t' "right" = .some r' →
  Typ.Monotonic.Static idl .true r' → -- TODO: rationale for the monotonic check with left id?
  Typ.UpperFounded id l l' → -- TODO; this should imply Monotonic.Dynamic
  Typ.sub [(idl, .lfp id l')] r' = r'' →
  Subtyping.LoopListZone.Static
  pids id [⟨skolems, assums, .path (.var idl) r⟩]
  (.path (.var idl) (.lfp id r''))

mutual
  inductive Typing.Function.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    List Typ →  -- subtras
    List (Pat × Expr) → List Zone → Prop
  | nil {skolems assums context subtras} :
    Typing.Function.Static skolems assums context subtras [] []

  | cons {skolems assums context }
    p e f assums' context' tp zones zones' zones'' subtras
  :
    Typing.Function.Static skolems assums context (tp :: subtras) f zones →
    PatLifting.Static assums context p tp assums' context' →
    (∀ {skolems' assums'' t},
      ⟨skolems', assums'', t⟩ ∈ zones' →
      ∃ assums_ext, assums'' = assums_ext ++ assums' ∧
      ∃ tr , t = (.path (ListTyp.diff tp subtras) tr)
    ) →
    (∀ {skolems' assums'' tr},
      ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ∈ zones' →
      Typing.Static skolems assums' context' e tr (skolems' ++ skolems) (assums'' ++ assums)
    ) →
    ListZone.tidy (ListSubtyping.free_vars assums) zones' = .some zones'' →
    Typing.Function.Static skolems assums context
      subtras
      ((p,e)::f) (zones'' ++ zones)

  inductive Typing.Record.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    List (String × Expr) → Typ → List String → List (Typ × Typ) → Prop
  | nil {skolems assums context} :
    Typing.Record.Static skolems assums context [] .top skolems assums

  | cons {skolems assums context  skolems'' assums''} l e r body t skolems' assums' :
    Typing.Static skolems assums context e body skolems' assums' →
    Typing.Record.Static skolems' assums' context r t skolems'' assums'' →
    Typing.Record.Static skolems assums context
      ((l,e) :: r) (.inter (.entry l body) (t))
      skolems'' assums''

  inductive Typing.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    Expr → Typ → List String → List (Typ × Typ) → Prop
  -- | unit {skolems assums context} :
  --   Typing.Static skolems assums context .unit .unit skolems assums
  | var {t} skolems assums context x :
    find x context = .some t →
    Typing.Static skolems assums context (.var x) t skolems assums

  | record {skolems assums context t} r :
    Typing.Record.Static skolems assums context r t skolems assums →
    Typing.Static skolems assums context (.record r) t skolems assums

  | function {skolems assums context t} f zones :
    Typing.Function.Static skolems assums context [] f zones →
    ListZone.pack (ListSubtyping.free_vars assums) .true zones = t →
    Typing.Static skolems assums context (.function f) t skolems assums

  | app {skolems assums context skolems''' assums'''}
    ef ea id tf skolems' assums' ta skolems'' assums'' :
    Typing.Static skolems assums context ef tf skolems' assums' →
    Typing.Static skolems' assums' context ea ta skolems'' assums'' →
    Subtyping.Static skolems'' assums'' tf (.path ta (.var id)) skolems''' assums''' →
    Typing.Static skolems assums context (.app ef ea) (.var id) skolems''' assums'''

  | loop {skolems assums context t' skolems' assums'} e t id zones zones' :
    Typing.Static skolems assums context e t skolems' assums' →
    (∀ {skolems'' assums'' t''},
      ⟨skolems'', assums'', t''⟩ ∈ zones →
      Subtyping.Static skolems assums t (.path (.var id) t'')
        (skolems'' ++ skolems) (assums'' ++ assums)
    ) →
    ListZone.tidy (ListSubtyping.free_vars assums') zones = .some zones' →
    Subtyping.LoopListZone.Static (ListSubtyping.free_vars assums') id zones' t' →
    Typing.Static skolems assums context (.loop e) t' skolems' assums'

  | anno {skolems assums context skolems'' assums''} e ta te skolems' assums' :
    Typ.free_vars ta ⊆ [] →
    Typing.Static skolems assums context e te skolems' assums' →
    Subtyping.Static skolems' assums' te ta skolems'' assums'' →
    Typing.Static skolems assums context (.anno e ta) ta skolems'' assums''


end

syntax "Typing_ListPath_Static_prove" : tactic
syntax "Subtyping_GuardedListZone_Static_prove" : tactic
syntax "Subtyping_ListZone_Static_prove" : tactic
syntax "Subtyping_LoopListZone_Static_prove" : tactic
syntax "Typing_Static_prove" : tactic



macro_rules

  | `(tactic| Typing_ListPath_Static_prove) => `(tactic|
    (first
      | apply Typing.ListPath.Static.nil
      | apply Typing.ListPath.Static.cons
        · Typing_ListPath_Static_prove
        · PatLifting_Static_prove
        · rfl
        · intro
          · Typing_Static_prove
        · rfl
        · rfl
    ) <;> fail
  )

  | `(tactic| Subtyping_GuardedListZone_Static_prove) => `(tactic|
    (apply Subtyping.ListZone.Static.intro
      · intro
        · Subtyping_Static_prove
      · rfl
    )
  )

  | `(tactic| Subtyping_ListZone_Static_prove) => `(tactic|
    (apply Subtyping.ListZone.Static.intro
      · intro
        · Typing_Static_prove
    )
  )

  | `(tactic| Subtyping_LoopListZone_Static_prove) => `(tactic|
    (first
      | apply Subtyping.LoopListZone.Static.batch
        · rfl
        · rfl
        · rfl
        · rfl
      | apply Subtyping.LoopListZone.Static.stream
        · simp
        · rfl
        · rfl
        · rfl
        · rfl
        · Typ_Monotonic_Static_prove
        · Typ_UpperFounded_prove
        · rfl
    ) <;> fail
  )

  | `(tactic| Typing_Static_prove) => `(tactic|
    (first
      | apply Typing.Static.unit
      | apply Typing.Static.var
        · rfl
      | apply Typing.Static.record_nil
      | apply Typing.Static.record_cons
        · Typing_Static_prove
        · Typing_Static_prove


      | apply Typing.Static.function
        · Typing_ListPath_Static_prove
        · rfl

      | apply Typing.Static.app
        · Typing_Static_prove
        · Typing_Static_prove
        · Subtyping_Static_prove

      | apply Typing.Static.loop
        · Typing_Static_prove
        · Subtyping_GuardedListZone_Static_prove
        · Subtyping_LoopListZone_Static_prove

      | apply Typing.Static.anno
        · simp
        · Subtyping_ListZone_Static_prove
        · rfl
        · Subtyping_Static_prove

    ) <;> fail
  )
