import Lang.Basic
import Lang.Util

-- import Mathlib.Data.Set.Basic
-- import Mathlib.Data.List.Basic
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



inductive Typ.UpperFounded (id : String) : Typ → Typ → Prop
| intro quals id' cases t t' :
  ListSubtyping.bounds id .true quals = cases →
  List.length cases = List.length quals →
  Typ.combine .false cases = t →
  Typ.Monotonic id' .true t →
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
  · Typ_Monotonic_prove
  · rfl
  )
)



-- NOTE: P means pattern type; if not (T <: P) and not (P <: T) then T and P are disjoint
def Typ.is_pattern (tops : List String) : Typ → Bool
  | .exi ids [] body => Typ.is_pattern (tops ++ ids) body
  | .var id => id ∈ tops
  | .unit => true
  | .entry _ body => Typ.is_pattern tops body
  | .inter left right => Typ.is_pattern tops left ∧ Typ.is_pattern tops right
  | _ => false

def Typ.height : Typ → Option Nat
  | .exi _ [] body => Typ.height body
  | .var _ => return 1
  | .unit => return 1
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
  def ListTyp.struct_less_than : List Typ → Typ → Bool
    | [], _ => .true
    | (l::ls), r =>
      Typ.struct_less_than l r && ListTyp.struct_less_than ls r

  def Typ.struct_lte (smaller bigger : Typ) : Bool :=
    smaller == bigger || Typ.struct_less_than smaller bigger

  def Typ.struct_less_than : Typ → Typ → Bool
    | (.var _), .unit => .true
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
    | _, _ => .false
end

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
  let outer_ids := (ListSubtyping.free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (ListSubtyping.free_vars inner ∪ fids) (Θ ∪ pids)
  BiZone.wrap b outer_ids outer inner_ids inner t

def ListZone.pack (pids : List String) (b : Bool) : List Zone → Typ
| .nil => Typ.base b
| .cons zone zones =>
  let l := Zone.pack pids .true zone
  let r := ListZone.pack pids .true zones
  Typ.rator b l r

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

mutual
  -- NOTE: check needs to be complete and well founded
  def Subtyping.check (Θ : List String) (Δ : List (Typ × Typ)) : Typ → Typ → Bool
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
  | lower, _ =>  (Typ.toBruijn 0 [] lower) == (Typ.toBruijn 0 [] .bot)
end


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
  | .unit => return (Typ.unit, Δ, Γ)
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


  partial def StaticListSubtyping.solve
    (skolems : List String) (assums : ListSubtyping)
  : ListSubtyping → Lean.MetaM (List (List String × ListSubtyping))
    | [] => return [(skolems, assums)]
    | (lower,upper) :: remainder => do
      let worlds ← StaticSubtyping.solve skolems assums lower upper
      (worlds.flatMapM (fun (skolems',assums') =>
        StaticListSubtyping.solve skolems' assums' remainder
      ))

  partial def StaticSubtyping.solve (Θ : List String) (Δ : ListSubtyping) (lower upper : Typ )
  : Lean.MetaM (List (List String × ListSubtyping))
  := if (Typ.toBruijn 0 [] lower) == (Typ.toBruijn 0 [] upper) then
    return [(Θ,Δ)]
  else match lower, upper with
    | (.entry ll lower), (.entry lu upper) =>
      if ll == lu then
        StaticSubtyping.solve Θ Δ lower upper
      else return []

    | (.path p q), (.path x y) => do
      (← StaticSubtyping.solve Θ Δ x p).flatMapM (fun (Θ',Δ') =>
        (StaticSubtyping.solve Θ' Δ' q y)
      )

    | (.unio a b), t => do
      (← StaticSubtyping.solve Θ Δ a t).flatMapM (fun (Θ',Δ') =>
        (StaticSubtyping.solve Θ' Δ' b t)
      )

    | (.exi ids quals body), t => do
      if ListSubtyping.restricted Θ Δ quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← StaticListSubtyping.solve Θ Δ quals').flatMapM (fun (Θ',Δ') =>
          (StaticSubtyping.solve (ids' ∪ Θ') Δ' body' t)
        )
      else return []


    | t, (.inter a b) => do
      (← StaticSubtyping.solve Θ Δ t a).flatMapM (fun (Θ',Δ') =>
        (StaticSubtyping.solve Θ' Δ' t b)
      )

    | t, (.all ids quals body) =>
      if ListSubtyping.restricted Θ Δ quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← StaticListSubtyping.solve Θ Δ quals').flatMapM (fun (Θ',Δ') =>
          (StaticSubtyping.solve (ids' ∪ Θ') Δ' t body')
        )
      else return []

    | (.var id), t => do
      if id ∉ Θ then
        let lowers_id := ListSubtyping.bounds id .true Δ
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← StaticListSubtyping.solve Θ Δ trans).mapM (fun (Θ',Δ') =>
          return (Θ', (.var id, t) :: Δ')
        )
      else if (Δ.exi (fun
        | (.var idl, .var idu) => idl == id && idu ∉ Θ
        | _ => .false
      )) then
        let lowers_id := ListSubtyping.bounds id .true Δ
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← StaticListSubtyping.solve Θ Δ trans).mapM (fun (Θ',Δ') =>
          return (Θ', (t, .var id) :: Δ')
        )
      else
        let uppers_id := ListSubtyping.bounds id .false Δ
        (uppers_id.flatMapM (fun upper_id =>
          let pass := (match upper_id with
            | .var id' => Θ.contains id'
            | _ => true
          )
          (if pass then
            (StaticSubtyping.solve Θ Δ upper_id t)
          else
            return []
          )
        ))

    | t, (.var id) => do
      if not (Θ.contains id) then
        let uppers_id := ListSubtyping.bounds id .false Δ
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← StaticListSubtyping.solve Θ Δ trans).mapM (fun (Θ',Δ') =>
          return (Θ', (t, .var id) :: Δ')
        )
      else if (Δ.exi (fun
        | (.var idl, .var idu) => idu == id && idl ∉ Θ
        | _ => .false
      )) then
        let uppers_id := ListSubtyping.bounds id .false Δ
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← StaticListSubtyping.solve Θ Δ trans).mapM (fun (Θ',Δ') =>
          return (Θ', (t, .var id) :: Δ')
        )
      else do
        let lowers_id := ListSubtyping.bounds id .true Δ
        (lowers_id.flatMapM (fun lower_id =>
          let pass := (match lower_id with
            | .var id' => Θ.contains id'
            | _ => true
          )
          (if pass then
            (StaticSubtyping.solve Θ Δ t lower_id)
          else
            return []
          )
        ))


    | l, (.path (.unio a b) r) =>
      StaticSubtyping.solve Θ Δ l (.inter (.path a r) (.path b r))


    | l, (.path r (.inter a b)) =>
      StaticSubtyping.solve Θ Δ l (.inter (.path r a) (.path r b))

    | t, (.entry l (.inter a b)) =>
      StaticSubtyping.solve Θ Δ t (.inter (.entry l a) (.entry l b))


    | (.lfp id left), upper =>
      if not (left.free_vars.contains id) then
        StaticSubtyping.solve Θ Δ left upper
      else if Typ.Monotonic.decide id .true left then
        StaticSubtyping.solve Θ Δ (Typ.sub [(id, upper)] left) upper
      else match upper with
        | (.entry l right) => match Typ.factor id left l with
            | .some fac  => StaticSubtyping.solve Θ Δ fac right
            | .none => failure
        | (.diff l r) => match Typ.height r with
            | .some h =>
              if (
                Typ.is_pattern [] r &&
                Typ.Monotonic.decide id .true left &&
                Typ.struct_less_than (.var id) left &&
                not (Subtyping.check Θ Δ (Typ.subfold id left 1) r) &&
                not (Subtyping.check Θ Δ r (Typ.subfold id left h))
              ) then
                StaticSubtyping.solve Θ Δ left l
              else
                failure
            | .none => failure
        | _ => failure


    | t, (.diff l r) =>
      if (
        Typ.is_pattern [] r &&
        ¬ Subtyping.check Θ Δ t r &&
        ¬ Subtyping.check Θ Δ r t
      ) then
        StaticSubtyping.solve Θ Δ t l
      else
        failure

    | l, (.lfp id r) =>
      if Subtyping.inflatable l r then
        StaticSubtyping.solve Θ Δ l (.sub [(id, .lfp id r)] r)
      else
        let r' := Typ.drop id r
        StaticSubtyping.solve Θ Δ l r'

    | (.diff l r), t =>
      StaticSubtyping.solve Θ Δ l (.unio r t)


    | t, (.unio l r) => do
      return (
        (← StaticSubtyping.solve Θ Δ t l) ++
        (← StaticSubtyping.solve Θ Δ t r)
      )

    | l, (.exi ids quals r) => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let r' := Typ.sub subs r
      let quals' := ListSubtyping.sub subs quals
      (← StaticSubtyping.solve Θ Δ l r').flatMapM (fun (θ',Δ') =>
        StaticListSubtyping.solve θ' Δ' quals'
      )


    | (.inter l r), t => match t with
      | .path p q => match Typ.merge_paths (.inter l r) with
        | .some t' => StaticSubtyping.solve Θ Δ t' (.path p q)
        | .none => return (
          (← StaticSubtyping.solve Θ Δ l t) ++
          (← StaticSubtyping.solve Θ Δ r t)
        )
      | _ => return (
        (← StaticSubtyping.solve Θ Δ l t) ++
        (← StaticSubtyping.solve Θ Δ r t)
      )



    | (.all ids quals l), r  => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let l' := Typ.sub subs l
      let quals' := ListSubtyping.sub subs quals
      (← StaticSubtyping.solve Θ Δ l' r).flatMapM (fun (θ',Δ') =>
        StaticListSubtyping.solve θ' Δ' quals'
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
    simp [Typ.BEq_eq_true]
  | tail _ m'' =>
    cases b : (Typ.var id == upper) with
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
    simp [Typ.BEq_eq_true]
  | tail _ m'' =>
    cases b : (Typ.var id == lower) with
      | false =>
        apply ih
        assumption
      | true =>
        simp
        apply Or.inr
        apply ih
        assumption




lemma lower_bound_mem id cs ts t :
  ListSubtyping.bounds id .true cs = ts →
  t ∈ ts → (t, .var id) ∈ cs
:= by sorry

lemma upper_bound_mem id cs ts t :
  ListSubtyping.bounds id .false cs = ts →
  t ∈ ts → (.var id, t) ∈ cs
:= by sorry

mutual
  inductive StaticListSubtyping
  : List String → List (Typ × Typ) → List (Typ × Typ)
  → List String → List (Typ × Typ) → Prop
    | nil skolems assums : StaticListSubtyping skolems assums [] skolems assums
    | cons skolems assums l r cs skolems' assums' skolems'' assums'' :
      StaticSubtyping skolems assums l r skolems' assums' →
      StaticListSubtyping skolems' assums' cs skolems'' assums'' →
      StaticListSubtyping skolems assums ((l,r) :: cs) skolems'' assums''


  inductive StaticSubtyping
  : List String → List (Typ × Typ)
  → Typ → Typ
  → List String → List (Typ × Typ) → Prop
    | refl skolems assums lower upper :
      (Typ.toBruijn 0 [] lower) = (Typ.toBruijn 0 [] upper) →
      StaticSubtyping skolems assums lower upper skolems assums

    | rename_left skolems assums left left' right skolems' assums':
      (Typ.toBruijn 0 [] left) = (Typ.toBruijn 0 [] left') →
      StaticSubtyping skolems assums left' right skolems' assums' →
      StaticSubtyping skolems assums left right skolems' assums'

    | rename_right skolems assums left right right' skolems' assums' :
      (Typ.toBruijn 0 [] right) = (Typ.toBruijn 0 [] right') →
      StaticSubtyping skolems assums left right' skolems' assums' →
      StaticSubtyping skolems assums left right skolems' assums'

    -- implication preservation
    | entry_pres skolems assums l left right skolems' assums' :
      StaticSubtyping skolems assums left right skolems' assums' →
      StaticSubtyping skolems assums (.entry l left) (.entry l right) skolems' assums'

    | path_pres skolems assums p q  skolems' assums' x y skolems'' assums'' :
      StaticSubtyping skolems assums x p skolems' assums' →
      StaticSubtyping skolems' assums' q y skolems'' assums'' →
      StaticSubtyping skolems assums (.path p q) (.path x y) skolems'' assums''

    -- expansion elimination
    | unio_elim skolems assums a t b skolems' assums' skolems'' assums'' :
      StaticSubtyping skolems assums a t skolems' assums' →
      StaticSubtyping skolems' assums' b t skolems'' assums'' →
      StaticSubtyping skolems assums (.unio a b) t skolems'' assums''

    | exi_elim skolems assums ids quals body t skolems' assums' skolems'' assums'' :
      ListSubtyping.restricted skolems assums quals →
      StaticListSubtyping skolems assums quals skolems' assums' →
      StaticSubtyping (ids ∪ skolems') assums' body t skolems'' assums'' →
      StaticSubtyping skolems assums (.exi ids quals body) t skolems'' assums''

    -- refinement introduction
    | inter_intro skolems assums t a  b skolems' assums' skolems'' assums'' :
      StaticSubtyping skolems assums t a skolems' assums' →
      StaticSubtyping skolems' assums' t b skolems'' assums'' →
      StaticSubtyping skolems assums t (.inter a b) skolems'' assums''

    | all_intro skolems assums ids quals body t skolems' assums' skolems'' assums'' :
      ListSubtyping.restricted skolems assums quals →
      StaticListSubtyping skolems assums quals skolems' assums' →
      StaticSubtyping (ids ∪ skolems') assums' t body skolems'' assums'' →
      StaticSubtyping skolems assums t (.all ids quals body) skolems'' assums''

    -- placeholder elimination
    | placeholder_elim skolems assums id t trans skolems' assums'  :
      id ∉ skolems →
      (∀ t', (t', .var id) ∈ assums → (t', t) ∈ trans) →
      StaticListSubtyping skolems assums trans skolems' assums' →
      StaticSubtyping skolems assums (.var id) t skolems' ((.var id, t) :: assums')

    -- placeholder introduction
    | placeholder_intro skolems assums t id trans skolems' assums'  :
      id ∉ skolems →
      (∀ t', (.var id, t') ∈ assums → (t, t') ∈ trans) →
      StaticListSubtyping skolems assums trans skolems' assums' →
      StaticSubtyping skolems assums t (.var id) skolems' ((t, .var id) :: assums')

    -- skolem placeholder introduction
    | skolem_placeholder_intro skolems assums t id trans skolems' assums'  :
      id ∈ skolems →
      (∃ id', (.var id', .var id) ∈ assums ∧ id' ∉ skolems) →
      (∀ t', (.var id, t') ∈ assums → (t, t') ∈ trans) →
      StaticListSubtyping skolems assums trans skolems' assums' →
      StaticSubtyping skolems assums t (.var id) skolems' ((t, .var id) :: assums')

    -- skolem introduction
    | skolem_intro skolems assums t id t' skolems' assums'  :
      id ∈ skolems →
      (t', .var id) ∈ assums →
      (∀ id', (.var id') = t' → id' ∈ skolems) →
      StaticSubtyping skolems assums t t' skolems' assums' →
      StaticSubtyping skolems assums t (.var id) skolems' assums'

    -- skolem placeholder elimination
    | skolem_placeholder_elim skolems assums id t trans skolems' assums'  :
      id ∈ skolems →
      (∃ id', (.var id, .var id') ∈ assums ∧ id' ∉ skolems) →
      (∀ t', (t', .var id) ∈ assums → (t', t) ∈ trans) →
      StaticListSubtyping skolems assums trans skolems' assums' →
      StaticSubtyping skolems assums (.var id) t skolems' ((.var id, t) :: assums')

    -- skolem elimination
    | skolem_elim skolems assums id t t' skolems' assums' :
      id ∈ skolems →
      (.var id, t') ∈ assums →
      (∀ id', (.var id') = t → id' ∈ skolems) →
      StaticSubtyping skolems assums t' t skolems' assums' →
      StaticSubtyping skolems assums (.var id) t skolems' assums'

    -- implication rewriting
    | unio_antec skolems assums l a b r skolems' assums' :
      StaticSubtyping skolems assums l (.inter (.path a r) (.path b r)) skolems' assums' →
      StaticSubtyping skolems assums l (.path (.unio a b) r) skolems' assums'

    | inter_conseq skolems assums l a b r skolems' assums' :
      StaticSubtyping skolems assums l (.inter (.path r a) (.path r b)) skolems' assums' →
      StaticSubtyping skolems assums l (.path r (.inter a b)) skolems' assums'

    | inter_entry skolems assums t l a b skolems' assums' :
      StaticSubtyping skolems assums t (.inter (.entry l a) (.entry l b)) skolems' assums' →
      StaticSubtyping skolems assums t (.entry l (.inter a b)) skolems' assums'

    -- least fixed point elimination
    | lfp_skip_elim skolems assums id left right skolems' assums' :
      id ∉ Typ.free_vars left →
      StaticSubtyping skolems assums left right skolems' assums' →
      StaticSubtyping skolems assums (.lfp id left) right skolems' assums'

    | lfp_induct_elim skolems assums id left right skolems' assums' :
      Typ.Monotonic id .true left →
      StaticSubtyping skolems assums (Typ.sub [(id, right)] left) right skolems' assums' →
      StaticSubtyping skolems assums (.lfp id left) right skolems' assums'

    | lfp_factor_elim skolems assums id left l right fac skolems' assums' :
      Typ.factor id left l = .some fac →
      StaticSubtyping skolems assums fac right skolems' assums' →
      StaticSubtyping skolems assums (.lfp id left) (.entry l right) skolems' assums'

    -- difference introduction
    | diff_intro skolems assums t l r skolems' assums' :
      Typ.is_pattern [] r →
      ¬ Subtyping.check skolems assums t r →
      ¬ Subtyping.check skolems assums r t →
      StaticSubtyping skolems assums t l skolems' assums' →
      StaticSubtyping skolems assums t (.diff l r) skolems' assums'

    | diff_fold_intro skolems assums id t l r h skolems' assums' :
      Typ.is_pattern [] r →
      Typ.Monotonic id .true t →
      Typ.struct_less_than (.var id) t →
      ¬ (Subtyping.check skolems assums (Typ.subfold id t 1) r) →
      Typ.height r = .some h →
      ¬ (Subtyping.check skolems assums r (Typ.subfold id t h)) →
      StaticSubtyping skolems assums (.lfp id t) l skolems' assums' →
      StaticSubtyping skolems assums (.lfp id t) (.diff l r) skolems' assums'

    -- least fixed point introduction
    | lfp_inflate_intro skolems assums l id r skolems' assums' :
      -- TODO: inflatable is a heuristic;
      -- it's not necessary for soundness
      -- consider merely using it in tactic
      Subtyping.inflatable l r →
      StaticSubtyping skolems assums l (.sub [(id, .lfp id r)] r) skolems' assums' →
      StaticSubtyping skolems assums l (.lfp id r) skolems' assums'

    | lfp_drop_intro skolems assums l id r r' skolems' assums' :
      Typ.drop id r = r' →
      StaticSubtyping skolems assums l r' skolems' assums' →
      StaticSubtyping skolems assums l (.lfp id r) skolems' assums'

    -- difference elimination
    | diff_elim skolems assums l r t skolems' assums' :
      StaticSubtyping skolems assums l (.unio r t) skolems' assums' →
      StaticSubtyping skolems assums (.diff l r) t skolems' assums'

    -- expansion introduction
    | unio_left_intro skolems assums t l r skolems' assums' :
      StaticSubtyping skolems assums t l skolems' assums' →
      StaticSubtyping skolems assums t (.unio l r) skolems' assums'

    | unio_right_intro skolems assums t l r skolems' assums' :
      StaticSubtyping skolems assums t r skolems' assums' →
      StaticSubtyping skolems assums t (.unio l r) skolems' assums'

    | exi_intro skolems assums l ids quals r skolems' assums' skolems'' assums'' :
      StaticSubtyping skolems assums l r skolems' assums' →
      StaticListSubtyping skolems' assums' quals skolems'' assums'' →
      StaticSubtyping skolems assums l (.exi ids quals r)  skolems'' assums''

    -- refinement elimination
    | inter_left_elim skolems assums l r t skolems' assums' :
      StaticSubtyping skolems assums l t skolems' assums' →
      StaticSubtyping skolems assums (.inter l r) t skolems' assums'

    | inter_right_elim skolems assums l r t skolems' assums' :
      StaticSubtyping skolems assums r t skolems' assums' →
      StaticSubtyping skolems assums (.inter l r) t skolems' assums'

    | inter_merge_elim skolems assums l r p q t skolems' assums' :
      Typ.merge_paths (.inter l r) = .some t →
      StaticSubtyping skolems assums t (.path p q) skolems' assums' →
      StaticSubtyping skolems assums (.inter l r) (.path p q) skolems' assums'

    | all_elim skolems assums ids quals l r skolems' assums' skolems'' assums'' :
      StaticSubtyping skolems assums l r skolems' assums' →
      StaticListSubtyping skolems' assums' quals skolems'' assums'' →
      StaticSubtyping skolems assums (.all ids quals l) r skolems'' assums''


end

syntax "StaticListSubtyping_prove" : tactic
syntax "StaticSubtyping_prove" : tactic
syntax "StaticSubtyping_rename_left" term : tactic
syntax "StaticSubtyping_rename_right" term: tactic

macro_rules
  | `(tactic| StaticSubtyping_rename_left $t:term) => `(tactic|
    (apply StaticSubtyping.rename_left _ _ _ $t:term ; rfl)
  )

  | `(tactic| StaticSubtyping_rename_right $t:term) => `(tactic|
    (apply StaticSubtyping.rename_right  _ _ _ _ $t:term; rfl)
  )

  | `(tactic| StaticListSubtyping_prove) => `(tactic|
    (first
      | apply StaticListSubtyping.nil
      | apply StaticListSubtyping.cons
        · StaticSubtyping_prove
        · StaticListSubtyping_prove
    ) <;> fail
  )
  | `(tactic| StaticSubtyping_prove) => `(tactic|
    (first
      | apply StaticSubtyping.refl
        · rfl
      | apply StaticSubtyping.entry_pres
        · StaticSubtyping_prove
      | apply StaticSubtyping.path_pres
        · StaticSubtyping_prove
        · StaticSubtyping_prove
      | apply StaticSubtyping.unio_elim
        · StaticSubtyping_prove
        · StaticSubtyping_prove
      | apply StaticSubtyping.exi_elim
        · rfl
        · StaticListSubtyping_prove
        · StaticSubtyping_prove
      | apply StaticSubtyping.inter_intro
        · StaticSubtyping_prove
        · StaticSubtyping_prove
      | apply StaticSubtyping.all_intro
        · rfl
        · StaticListSubtyping_prove
        · StaticSubtyping_prove
      | apply StaticSubtyping.placeholder_elim
        · simp
        · apply lower_bound_map
          · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · StaticListSubtyping_prove

      | apply StaticSubtyping.placeholder_intro
        · simp
        · apply upper_bound_map
          · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · StaticListSubtyping_prove

      | apply StaticSubtyping.skolem_placeholder_intro
        · simp
        · simp
        · apply upper_bound_map
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · StaticListSubtyping_prove

      | apply StaticSubtyping.skolem_intro
        · simp
        · apply lower_bound_mem
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
          · simp [Typ.BEq_eq_true]; rfl
        · simp
        · StaticSubtyping_prove

      | apply StaticSubtyping.skolem_placeholder_elim
        · simp
        · simp
        · apply lower_bound_map
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · StaticListSubtyping_prove

      | apply StaticSubtyping.skolem_elim
        · simp
        · apply upper_bound_mem
          · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
          · simp [Typ.BEq_eq_true]; rfl
        · simp
        · StaticSubtyping_prove

      | apply StaticSubtyping.unio_antec
        · StaticSubtyping_prove

      | apply StaticSubtyping.inter_conseq
        · StaticSubtyping_prove

      | apply StaticSubtyping.inter_entry
        · StaticSubtyping_prove

      | apply StaticSubtyping.lfp_factor_elim
        · rfl
        · StaticSubtyping_prove

      | apply StaticSubtyping.lfp_skip_elim
        · simp
        · StaticSubtyping_prove

      | apply StaticSubtyping.lfp_induct_elim
        · Typ_Monotonic_prove
        · StaticSubtyping_prove

      | apply StaticSubtyping.diff_intro
        · rfl
        · simp [Subtyping.check, Typ.toBruijn]; rfl
        · simp [Subtyping.check, Typ.toBruijn]; rfl
        · StaticSubtyping_prove

      | apply StaticSubtyping.diff_fold_intro
        · rfl
        · Typ_Monotonic_prove
        · simp only [Typ.struct_less_than, Bool.or] ; rfl
        · simp [Typ.subfold, Typ.sub, Subtyping.check, Typ.toBruijn]; rfl
        · rfl
        · simp [Typ.subfold, Typ.sub, Subtyping.check, Typ.toBruijn]; rfl
        · StaticSubtyping_prove

      | apply StaticSubtyping.lfp_inflate_intro
        · simp [Subtyping.inflatable, Typ.break, Subtyping.shallow_match]
        · simp [Typ.sub, find] ; StaticSubtyping_prove

      | apply StaticSubtyping.lfp_drop_intro
        · rfl
        · StaticSubtyping_prove

      | apply StaticSubtyping.diff_elim
        · StaticSubtyping_prove

      | apply StaticSubtyping.unio_left_intro
        · StaticSubtyping_prove

      | apply StaticSubtyping.unio_right_intro
        · StaticSubtyping_prove

      | apply StaticSubtyping.exi_intro
        · StaticSubtyping_prove
        · StaticListSubtyping_prove

      | apply StaticSubtyping.inter_left_elim
        · StaticSubtyping_prove

      | apply StaticSubtyping.inter_right_elim
        · StaticSubtyping_prove

      | apply StaticSubtyping.inter_merge_elim
        · rfl
        · StaticSubtyping_prove

      | apply StaticSubtyping.all_elim
        · StaticSubtyping_prove
        · StaticListSubtyping_prove
    ) <;> fail
  )





#check Option.mapM

mutual
  partial def Typing.ListPath.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
  : List (Pat × Expr) → Lean.MetaM (List Zone × List Typ)
      | [] => return ([], [])

      | (p,e)::f => do
        let (zones, subtras) ← Typing.ListPath.Static.infer Θ Δ Γ f
        let (tp, Δ', Γ') ←  PatLifting.Static.compute Δ Γ p
        let tl := ListTyp.diff tp subtras
        let zones' := (← Typing.Static.infer Θ Δ' Γ' e).map (fun ⟨Θ', Δ'', tr ⟩ =>
          ⟨List.diff Θ' Θ, List.diff Δ'' Δ', (.path tl tr)⟩
        )
        let subtra := Typ.capture tp
        match ListZone.tidy (ListSubtyping.free_vars Δ) zones' with
          | .some zones'' => return (zones'' ++ zones, subtra :: subtras)
          | .none => failure


  partial def Subtyping.GuardedListZone.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ))
  : Typ → Typ → Lean.MetaM (List Zone)
    | t, .var id => do
      let id' ← fresh_typ_id
      let t' := .var id'
      let zones := (← StaticSubtyping.solve Θ Δ t (.path (.var id) t')).map (fun (Θ', Δ') =>
        ⟨List.diff Θ' Θ, List.diff Δ' Δ, t'⟩
      )
      match (ListZone.tidy (ListSubtyping.free_vars Δ) zones) with
        | .some zones' => return zones'
        | .none => failure
    | _, _ => failure

  partial def Typing.ListZone.Static.infer
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (e : Expr)
  : Lean.MetaM (List Zone) := do
    (← Typing.Static.infer Θ Δ Γ e).mapM (fun  ⟨Θ', Δ', t⟩ =>
      return ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩
    )

    partial def Subtyping.LoopListZone.Static.infer
      (pids : List String) (id : String)
    : List Zone → Lean.MetaM Typ

      | [⟨Θ, Δ, .path (.var idl) r⟩] =>
        if id != idl then do
          match (
            (ListSubtyping.invert id Δ).bind (fun Δ' =>
              let t' := Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩
              (Typ.factor id t' "left").bind (fun l =>
              (Typ.factor id t' "right").map (fun r' => do
                let l' ← Typ.UpperFounded.compute id l
                let r'' := Typ.sub [(idl, .lfp id l')] r'
                if Typ.Monotonic.decide idl .true r' then
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
      (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
    : Expr → Lean.MetaM (List Zone)
      | .unit => return [⟨Θ, Δ, .unit⟩]
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
        (← StaticSubtyping.solve Θ'' Δ'' tf (.path ta (.var α))).flatMapM (fun ⟨Θ''', Δ'''⟩ =>
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
          (← StaticSubtyping.solve Θ Δ te ta).flatMapM (fun (Θ', Δ') =>
            return [⟨Θ', Δ', ta⟩]
          )
        else
          return []

end

mutual
  inductive Typing.ListPath.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    List (Pat × Expr) → List Zone → List Typ → Prop
    | nil Θ Δ Γ :
      Typing.ListPath.Static Θ Δ Γ [] [] []
    | cons Θ Δ Γ p e f zones subtras Δ' Γ' tp tl zones' zones'' subtra :
      Typing.ListPath.Static Θ Δ Γ f zones subtras →
      PatLifting.Static Δ Γ p tp Δ' Γ' →
      ListTyp.diff tp subtras = tl →
      (∀ Θ' Δ'' tr,
        ⟨List.diff Θ' Θ, List.diff Δ'' Δ', (.path tl tr)⟩ ∈ zones' →
        Typing.Static Θ Δ' Γ' e tr Θ' Δ''
      ) →
      ListZone.tidy (ListSubtyping.free_vars Δ) zones' = .some zones'' →
      Typ.capture tp = subtra →
      Typing.ListPath.Static Θ Δ Γ ((p,e)::f) (zones'' ++ zones) (subtra :: subtras)


  inductive Subtyping.GuardedListZone.Static
  : List String → List (Typ × Typ) →
    Typ → Typ → List Zone → Prop
    | intro Θ Δ t id zones zones' :
      (∀ Θ' Δ' t',
        ⟨List.diff Θ' Θ, List.diff Δ' Δ, t'⟩ ∈ zones →
        StaticSubtyping Θ Δ t (.path (.var id) t') Θ' Δ'
      ) →
      ListZone.tidy (ListSubtyping.free_vars Δ) zones = .some zones' →
      Subtyping.GuardedListZone.Static Θ Δ t (.var id) zones'

  inductive Typing.ListZone.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    Expr → List Zone → Prop
    | intro Θ Δ Γ e zones :
      (∀ Θ' Δ' t,
        ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩ ∈ zones →
        Typing.Static Θ Δ Γ e t Θ' Δ'
      ) →
      Typing.ListZone.Static Θ Δ Γ e zones

  inductive Subtyping.LoopListZone.Static
  : List String → String → List Zone → Typ → Prop
    | batch pids id zones zones' t' l r :
      ListZone.invert id zones = .some zones' →
      ListZone.pack (id :: pids) .false zones' = t' →
      Typ.factor id t' "left" = .some l →
      Typ.factor id t' "right" = .some r →
      Subtyping.LoopListZone.Static pids id zones (.path (.lfp id l) (.lfp id r))

    | stream pids id Θ Δ Δ' idl r t' l r' l' r'' :
      id ≠ idl →
      ListSubtyping.invert id Δ = .some Δ' →
      Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩ = t' →
      Typ.factor id t' "left" = .some l →
      Typ.factor id t' "right" = .some r' →
      Typ.Monotonic idl .true r' →
      Typ.UpperFounded id l l' →
      Typ.sub [(idl, .lfp id l')] r' = r'' →
      Subtyping.LoopListZone.Static
      pids id [⟨Θ, Δ, .path (.var idl) r⟩]
      (.path (.var idl) (.lfp id r''))

  inductive Typing.Static
  : List String → List (Typ × Typ) → List (String × Typ)
  → Expr → Typ → List String → List (Typ × Typ) → Prop
    | unit Θ Δ Γ : Typing.Static Θ Δ Γ .unit .unit Θ Δ
    | var Θ Δ Γ x t :
      find x Γ = .some t →
      Typing.Static Θ Δ Γ (.var x) t Θ Δ

    | record_nil Θ Δ Γ :
      Typing.Static Θ Δ Γ (.record []) .top Θ Δ

    | record_cons Θ Δ Γ r l e t t'  Θ' Δ' Θ'' Δ'' :
      Typing.Static Θ Δ Γ e t Θ' Δ' →
      Typing.Static Θ' Δ' Γ (.record r) t' Θ'' Δ'' →
      Typing.Static Θ Δ Γ (.record ((l,e) :: r)) (.inter (.entry l t) (t')) Θ'' Δ''

    | function Θ Δ Γ f zones t subtras :
      Typing.ListPath.Static Θ Δ Γ f zones subtras →
      ListZone.pack (ListSubtyping.free_vars Δ) .true zones = t →
      Typing.Static Θ Δ Γ (.function f) t Θ Δ

    | app Θ Δ Γ ef ea α tf Θ' Δ' ta Θ'' Δ'' Θ''' Δ''' :
      Typing.Static Θ Δ Γ ef tf Θ' Δ' →
      Typing.Static Θ' Δ' Γ ea ta Θ'' Δ'' →
      StaticSubtyping Θ'' Δ'' tf (.path ta (.var α)) Θ''' Δ''' →
      Typing.Static Θ Δ Γ (.app ef ea) (.var α) Θ''' Δ'''

    | loop Θ Δ Γ e t id zones t' Θ' Δ' :
      Typing.Static Θ Δ Γ e t Θ' Δ' →
      Subtyping.GuardedListZone.Static Θ' Δ' t (.var id) zones →
      Subtyping.LoopListZone.Static (ListSubtyping.free_vars Δ') id zones t' →
      Typing.Static Θ Δ Γ (.loop e) t' Θ' Δ'


    | anno Θ Δ Γ e ta zones te Θ' Δ' :
      Typ.free_vars ta ⊆ [] →
      Typing.ListZone.Static Θ Δ Γ e zones →
      ListZone.pack (ListSubtyping.free_vars Δ) .false zones = te →
      StaticSubtyping Θ Δ te ta Θ' Δ' →
      Typing.Static Θ Δ Γ (.anno e ta) ta Θ' Δ'


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
        · StaticSubtyping_prove
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
        · Typ_Monotonic_prove
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
        · StaticSubtyping_prove

      | apply Typing.Static.loop
        · Typing_Static_prove
        · Subtyping_GuardedListZone_Static_prove
        · Subtyping_LoopListZone_Static_prove

      | apply Typing.Static.anno
        · simp
        · Subtyping_ListZone_Static_prove
        · rfl
        · StaticSubtyping_prove

    ) <;> fail
  )
