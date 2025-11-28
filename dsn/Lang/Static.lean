import Lean
import Lang.Util
import Lang.Basic
import Lang.Dynamic

-- import Mathlib.Data.Set.Basic
-- import Mathlib.Data.List.Basic
import Mathlib.Tactic.Linarith

set_option eval.pp false
set_option pp.fieldNotation false

structure Zone where
  skolems : List String
  assums : List (Typ × Typ)
  typ : Typ
deriving Repr, Lean.ToExpr

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


-- def ListSubtyping.complex_vars : List (Typ × Typ) → List String
-- | [] => []
-- | (.var _ , .var _ ) :: sts => ListSubtyping.complex_vars sts
-- | (lower , .var _ ) :: sts => (Typ.free_vars lower) ++ (ListSubtyping.complex_vars sts)
-- | (.var _, upper) :: sts => (Typ.free_vars upper) ++ (ListSubtyping.complex_vars sts)
-- | (lower, upper) :: sts =>
--   (Typ.free_vars lower) ++ (Typ.free_vars upper) ++ (ListSubtyping.complex_vars sts)


def ListSubtyping.prune (pids : List String) : List (Typ × Typ) → List (Typ × Typ)
| .nil => []
| .cons (l,r) sts =>
  if (Typ.free_vars l) ∪ (Typ.free_vars r) ⊆ pids then
    (l,r) :: ListSubtyping.prune pids sts
  else
    ListSubtyping.prune pids sts

mutual
  def ListTyp.simp : List Typ → List Typ
  | [] => []
  | t :: ts => (Typ.simp t) :: (ListTyp.simp ts)
  termination_by ts => ListTyp.size ts
  decreasing_by
    all_goals simp [ListTyp.size, ListTyp.zero_lt_size, Typ.zero_lt_size]

  def Typ.simp : Typ → Typ
  | .unio l r =>
    let parts := (
      ListTyp.simp (Typ.break .false l) ++ ListTyp.simp (Typ.break .false r)
    ).eraseDups
    Typ.combine .false parts
  | .inter l r =>
    let parts := (
      ListTyp.simp (Typ.break .true l) ++ ListTyp.simp (Typ.break .true r)
    ).eraseDups
    Typ.combine .true parts
  | t => t
  termination_by t => Typ.size t
  decreasing_by
    all_goals simp [Typ.size]
    · linarith [Typ.break_size_lte .false l]
    · linarith [Typ.break_size_lte .false r]
    · linarith [Typ.break_size_lte .true l]
    · linarith [Typ.break_size_lte .true r]
end



def Subtyping.removable_lower (id_map : List (String × Bool)) : Typ → Bool
| .var idl =>
  match find idl id_map with
  | .some .false => .true
  | _ => .false
| .path (.var idl) (.var idr) =>
  match find idl id_map, find idr id_map with
  | .some .true, (.some .false) => .true
  | _,_ => .false
| _ => .false

def Subtyping.removable_upper (id_map : List (String × Bool)) : Typ → Bool
| .var idl =>
  match find idl id_map with
  | .some .true => .true
  | _ => .false
| .path (.var idl) (.var idr) =>
  match find idl id_map, find idr id_map with
  | .some .false, (.some .true) => .true
  | _,_ => .false
| _ => .false


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



mutual

  partial def ListSubtyping.Monotonic.Static.Either.decide (cs : ListSubtyping) (t : Typ)
  : List String → Bool
  | [] => .true
  | id :: ids =>
    (
      (ListSubtyping.Monotonic.Static.decide id .true cs &&
        Typ.Monotonic.Static.decide id .true t) ||
      (ListSubtyping.Monotonic.Static.decide id .false cs &&
        Typ.Monotonic.Static.decide id .false t)) &&
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
  | .iso _ body =>
    Typ.Monotonic.Static.decide id b body
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
  | .top => true
  | .exi ids [] body => Typ.is_pattern (tops ++ ids) body
  | .var id => id ∈ tops
  | .iso _ body => Typ.is_pattern tops body
  | .entry _ body => Typ.is_pattern tops body
  | .inter left right => Typ.is_pattern tops left ∧ Typ.is_pattern tops right
  | _ => false

def Typ.height : Typ → Option Nat
  | .top => return 1
  | .exi _ [] body => Typ.height body
  | .var _ => return 1
  | .iso _ body => do
    return 1 + (← Typ.height body)
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

    | (.iso ll tl), (.iso lr tr) => ll == lr && Typ.struct_less_than tl tr
    | tl, (.iso _ tr) => tl == tr || Typ.struct_less_than tl tr

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
| .iso l k, .iso l' t =>
  l == l' && Subtyping.check k t
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
    if fids ∩ Θ != [] && fids ⊆ (pids ∪ Θ) then
      -- to be an outer constraints
      -- must have at least one skolem variable
      -- and all variables must either be skolem or foreign
      ((l,r) :: outer, inner)
    else
      (outer, (l,r) :: inner)

#eval (reprStr [typ| <uno/>] > reprStr [typ| <dos/>])

def Zone.pack (pids : List String) (b : Bool) : Zone → Typ
| ⟨Θ, Δ, t⟩ =>
  let fids := Typ.free_vars t
  let (outer, inner) := ListSubtyping.partition pids Θ Δ
  -- TODO: make sure exapmles work with the outer_ids
  let outer_ids := [] -- (ListSubtyping.free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (ListSubtyping.free_vars inner ∪ fids) (Θ ∪ pids)

  let outer' := outer.eraseDups.mergeSort (fun a b => reprStr a <= reprStr b)
  let inner' := inner.eraseDups.mergeSort (fun a b => reprStr a <= reprStr b)

  let outer_ids' := outer_ids.eraseDups.mergeSort
  let inner_ids' := inner_ids.eraseDups.mergeSort
  BiZone.wrap b outer_ids' outer' inner_ids' inner' t


def ListZone.pack (pids : List String) (b : Bool) : List Zone → Typ
| .nil => Typ.base b
| .cons zone [] =>
  Zone.pack pids b zone
| .cons zone zones =>
  let l := Zone.pack pids b zone
  let r := ListZone.pack pids b zones
  Typ.rator b l r


def Typ.combine_bounds (id : String) (b : Bool) (assums : List (Typ × Typ)) : Typ :=
  let bds := (ListSubtyping.bounds id b assums).eraseDups
  if bds == [] then
    Typ.base (not b)
  else
    Typ.combine (not b) bds

def Subtyping.restricted
  (skolems : List String) (assums : List (Typ × Typ)) (lower upper : Typ) : Bool
:=
  Typ.is_pattern [] upper ||
  (match lower, upper with
  | .var id, _ =>
    if id ∉ skolems then
      Typ.combine_bounds id .true assums == Typ.bot
      -- (Typ.toBruijn [] i) == (Typ.toBruijn [] .bot)
    else
      .false
  | _, .var id =>
    if id ∉ skolems then
      Typ.combine_bounds id .false assums == Typ.top
      -- (Typ.toBruijn [] i) == (Typ.toBruijn [] .top)
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

-- set_option eval.pp true
#eval Typ.proj "T970" "left"
[typ| (<succ> T976) * (<cons> T977) ]
#eval Typ.proj "T970" "left"
[typ| EXI[T976 T977] [ (T976 * T977 <: T970) ] <succ> T976 * <cons> T977 ]

#eval Typ.factor "T970"
  [typ| <zero/> * <nil/> | (EXI[T976 T977] [ (T976 * T977 <: T970) ] <succ> T976 * <cons> T977) ]
  "left"


-- the weakest type t such that every inhabitant matches pattern p
inductive PatLifting.Static
: List (Typ × Typ) → List (String × Typ) →
  Pat → Typ → List (Typ × Typ) → List (String × Typ) → Prop

| var Δ Γ id tid :
  PatLifting.Static
  Δ Γ (.var id) (.var tid)
  ((.var tid, Typ.top) :: Δ)  ((id, .var tid) :: (remove id Γ))

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
  | .iso label body => do
    let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ body
    return (Typ.iso label t, Δ', Γ')
  | .record items => ListPatLifting.Static.compute Δ Γ items
end

syntax "PatLifting_Static_prove" : tactic
macro_rules
| `(tactic| PatLifting_Static_prove) => `(tactic|
  (first
    | apply PatLifting.Static.var
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
    | (.iso ll lower), (.iso lu upper) =>
      if ll == lu then
        Subtyping.Static.solve skolems assums lower upper
      else return []
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


    | (.lfp id lower), upper =>
      if not (lower.free_vars.contains id) then
        Subtyping.Static.solve skolems assums lower upper
      else if Typ.Monotonic.Static.decide id .true lower then do
        let result ← Subtyping.Static.solve skolems assums (Typ.sub [(id, upper)] lower) upper
        if not result.isEmpty then
          return result
        else
          -- Lean.logInfo ("<<< lfp debug upper >>>\n" ++ (repr upper))
          match upper with
          | (.entry l body_upper) => match Typ.factor id lower l with
              | .some fac  =>
                  -- Lean.logInfo ("<<< lfp debug fac >>>\n" ++ (repr (Typ.lfp id fac)))
                  -- Lean.logInfo ("<<< lfp debug body_upper >>>\n" ++ (repr body_upper))
                  Subtyping.Static.solve skolems assums (.lfp id fac) body_upper
              | .none => return []
          | (.diff l r) => match Typ.height r with
              | .some h =>
                -- Lean.logInfo ("<<< lfp debug upper diff h(r)>>>\n" ++ (repr h))
                if (
                  Typ.is_pattern [] r &&
                  Typ.Monotonic.Static.decide id .true lower &&
                  Typ.struct_less_than (.var id) lower &&
                  not (Subtyping.check (Typ.subfold id lower 1) r) &&
                  not (Subtyping.check r (Typ.subfold id lower h))
                ) then
                  Subtyping.Static.solve skolems assums lower l
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


    | _, _ => return []

end

theorem lower_bound_map id (cs : ListSubtyping) (t : Typ) : ∀ ts,
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


theorem upper_bound_map id (cs : ListSubtyping) (t : Typ) : ∀ ts,
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

theorem skolem_lower_bound id (assums : ListSubtyping) (skolems : List String) :
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


theorem skolem_upper_bound id (assums : ListSubtyping) (skolems : List String) :
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

theorem lower_bound_mem id cs t : ∀ ts,
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

theorem upper_bound_mem id cs t : ∀ ts,
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

-- theorem zones_todo_uno :
--   (∀ {skolems' assums'' t},
--     ⟨skolems', assums'', t⟩ ∈ zones' →
--     ∃ assums_ext, assums'' = assums_ext ++ assums' ∧
--     ∃ tr , t = (.path (ListTyp.diff tp subtras) tr)
--   )
-- := by sorry

-- theorem zones_todo_dos :
--   (∀ {skolems' assums'' tr},
--     ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ∈ zones' →
--     Typing.Static skolems assums' context' e tr (skolems' ++ skolems) (assums'' ++ assums)
--   )
-- := by sorry

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
  | refl {skolems assums t} :
    Subtyping.Static skolems assums t t skolems assums

  -- implication preservation
  | iso_pres {skolems assums skolems' assums' } l lower upper :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    Subtyping.Static skolems assums (.iso l lower) (.iso l upper) skolems' assums'

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

  -- difference elimination
  | diff_elim {skolems assums skolems' assums'} lower sub upper :
    Subtyping.Static skolems assums lower (.unio sub upper) skolems' assums' →
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
      | apply Subtyping.Static.iso_pres
        · Subtyping_Static_prove
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
        { rfl }
        { rfl }
        { simp [ListSubtyping.free_vars, Typ.free_vars, Union.union, List.union] }
        { ListSubtyping_Static_prove }
        { Subtyping_Static_prove }
      | apply Subtyping.Static.inter_intro
        · Subtyping_Static_prove
        · Subtyping_Static_prove
      | apply Subtyping.Static.all_intro
        { rfl }
        { rfl }
        { simp [ListSubtyping.free_vars, Typ.free_vars, Union.union, List.union] }
        { ListSubtyping_Static_prove }
        { Subtyping_Static_prove }
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
        { Subtyping_Static_prove }
        { Subtyping_Static_prove }

      | apply Subtyping.Static.inter_conseq
        { Subtyping_Static_prove }
        { Subtyping_Static_prove }

      | apply Subtyping.Static.inter_entry
        { Subtyping_Static_prove }
        { Subtyping_Static_prove }

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
        { rfl }
        { simp [Typ.struct_less_than]; reduce
          (first
          | apply Or.inl ; rfl
          | apply Or.inr ; rfl
          ) <;> fail }
        { rfl }
        { Typ_Monotonic_Static_prove }
        { Subtyping_Static_prove }
        { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }
        { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }

      | apply Subtyping.Static.diff_intro
        { rfl }
        { simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ] }
        { simp [
            Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
            ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
          ] }
        { Subtyping_Static_prove }


      | apply Subtyping.Static.lfp_peel_intro
        · simp [Subtyping.peelable, Typ.break, Subtyping.check]
        · simp [Typ.sub, find] ; Subtyping_Static_prove

      | apply Subtyping.Static.lfp_drop_intro
        { Subtyping_Static_prove }

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
  def ListSubtyping.polar_var (b : Bool) (id : String) : List (Typ × Typ) → Bool
  | [] => .false
  | (lower, upper) :: rest =>
    Typ.polar_var (not b) id lower || Typ.polar_var b id upper ||
    ListSubtyping.polar_var b id rest

  def Typ.polar_var (b : Bool) (id : String) : Typ → Bool
  | .var id' => b && id == id'
  | .iso _ body => Typ.polar_var b id body
  | .entry _ body => Typ.polar_var b id body
  | .path antec consq =>
    Typ.polar_var (not b) id antec || Typ.polar_var b id consq
  | .bot => .false
  | .top => .false
  | .unio left right =>
    Typ.polar_var b id left || Typ.polar_var b id right
  | .inter left right =>
    Typ.polar_var b id left || Typ.polar_var b id right
  | .diff minu subtra =>
    Typ.polar_var b id minu || Typ.polar_var (not b) id subtra
  | .all ids quals body =>
    not (ids.contains id) && (
      ListSubtyping.polar_var (not b) id quals ||
      Typ.polar_var b id body
    )
  | .exi ids quals body =>
    not (ids.contains id) && (
      ListSubtyping.polar_var b id quals ||
      Typ.polar_var b id body
    )
  | .lfp id' body =>
    id' != id && Typ.polar_var b id body
end

mutual
  def ListSubtyping.has_connection (ignore : List String) (b : Bool) (t : Typ)
  : List (Typ × Typ) → Bool
  | [] => .false
  | (lower, upper) :: rest =>
    Typ.has_connection ignore (not b) t lower || Typ.has_connection ignore b t upper ||
    ListSubtyping.has_connection ignore b t rest

  def Typ.has_connection (ignore : List String) (b : Bool) (t : Typ) : Typ → Bool
  | .var id => not (ignore.contains id) && Typ.polar_var b id t
  | .iso _ body => Typ.has_connection ignore b t body
  | .entry _ body => Typ.has_connection ignore b t body
  | .path antec consq =>
    Typ.has_connection ignore (not b) t antec || Typ.has_connection ignore b t consq
  | .bot => .false
  | .top => .false
  | .unio left right =>
    Typ.has_connection ignore b t left || Typ.has_connection ignore b t right
  | .inter left right =>
    Typ.has_connection ignore b t left || Typ.has_connection ignore b t right
  | .diff minu subtra =>
    Typ.has_connection ignore b t minu || Typ.has_connection ignore (not b) t subtra
  | .all ids quals body =>
      ListSubtyping.has_connection (ids ∪ ignore) (not b) t quals ||
      Typ.has_connection (ids ∪ ignore) b t body
  | .exi ids quals body =>
      ListSubtyping.has_connection (ids ∪ ignore) b t quals ||
      Typ.has_connection (ids ∪ ignore) b t body
  | .lfp id body =>
    Typ.has_connection ([id] ∪ ignore) b t body
end

def Typ.connections (b : Bool) (t : Typ) :  List (Typ × Typ) → List (Typ × Typ × Bool)
| [] => []
| (lower, upper) :: rest =>
  let lower_connections :=
    if Typ.has_connection [] (not b) t lower then
      [(lower, upper, (not b))]
    else
      []

  let upper_connections :=
    if Typ.has_connection [] b t upper then
      [(lower, upper, b)]
    else
      []

  lower_connections ∪ upper_connections ∪ (Typ.connections b t rest)

def Typ.transitive_connections
  (explored : List (Bool × Typ))
  (constraints : List (Typ × Typ))
  (b : Bool) (t : Typ) : List (Typ × Typ)
:=
  if explored.contains (b,t) then
    []
  else if explored.length < 1 + 4 * constraints.length  then
    let conns := Typ.connections b t constraints
    (conns.flatMap (fun (lower, upper, b') =>
      let tcs_lower := Typ.transitive_connections ((b,t) :: explored) constraints (not b') lower
      let tcs_upper := Typ.transitive_connections ((b,t) :: explored) constraints b' upper
      ([(lower,upper)] ∪ tcs_lower ∪ tcs_upper)
    )).eraseDups
  else
    []


mutual

  partial def Zone.interpret (ignore : List String) (b : Bool) : Zone → Lean.MetaM Zone
  | ⟨skolems, assums, t⟩ => do
    let t' ← Typ.interpret ignore skolems assums b t
    let assums' := Typ.transitive_connections [] assums b t'
    return ⟨skolems, assums', t'⟩


  partial def Typ.interpret
    (ignore : List String) (skolems : List String) (assums : List (Typ × Typ))
  : Bool → Typ → Lean.MetaM Typ
  | b, .var id => do
    if ignore.contains id || skolems.contains id then
      return .var id
    else
      let bds := (ListSubtyping.bounds id b assums).eraseDups
      if bds == [] then
        return .var id
      else
        let t := Typ.combine (not b) bds
        if (t == .bot || t == .top) then
          return .var id
        else
          Typ.interpret ([id] ∪  ignore) skolems assums b t

  | b, .iso label body => do
    let body' ← Typ.interpret ignore skolems assums b body
    return .iso label body'

  | b, .entry label body => do
    let body' ← Typ.interpret ignore skolems assums b body
    return .entry label body'

  | b, .inter l r => do
    let l' ← Typ.interpret ignore skolems assums b l
    let r' ← Typ.interpret ignore skolems assums b r
    return Typ.simp (Typ.inter l' r')

  | b, .unio l r => do
    let l' ← Typ.interpret ignore skolems assums b l
    let r' ← Typ.interpret ignore skolems assums b r
    return Typ.simp (Typ.unio l' r')

  | b, .path antec consq => do
    let antec' ← Typ.interpret ignore skolems assums (not b) antec
    let ignore' := (Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore
    let consq' ← Typ.interpret ignore' skolems assums b consq
    return Typ.simp (Typ.path antec' consq')

  | .true, .exi ids_exi quals_exi (.all _ quals body) => do
    let constraints := quals_exi ++ quals

    let zones ← (
      ← ListSubtyping.Static.solve (ids_exi ∪ skolems) assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones

  | .true, (.all _ quals body) => do
    let constraints := quals

    let zones ← (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones

  | .false, .all ids_all quals_all (.exi _ quals body) => do
    let constraints := quals_all ++ quals

    let zones ← (
      ← ListSubtyping.Static.solve (ids_all ∪ skolems) assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones


  | .false, (.exi _ quals body) => do
    let constraints := quals
    let zones ← (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones

  | _, t => do
    return t
end

mutual

  inductive Zone.Interp
  : List String → Bool → Zone → Zone → Prop
  | intro {ignore b} skolems assums t assums' t':
    Typ.Interp ignore skolems assums b t t' →
    Typ.transitive_connections [] assums b t' = assums' →
    Zone.Interp ignore b ⟨skolems,assums,t⟩ ⟨skolems, assums,t'⟩

  inductive Typ.Interp
  : List String → List String → List (Typ × Typ) → Bool → Typ → Typ → Prop
  | refl {ignore skolems assums b t} :
    Typ.Interp ignore skolems assums b t t

  | var {ignore skolems assums b t'} bds id t:
    id ∉ ignore →
    id ∉ skolems →
    (ListSubtyping.bounds id b assums).eraseDups = bds →
    bds ≠ [] →
    Typ.combine (not b) bds = t →
    t ≠ Typ.bot →
    t ≠ Typ.top →
    Typ.Interp ([id] ∪ ignore) skolems assums b t t' →
    Typ.Interp ignore skolems assums b (.var id) t'

  | iso {ignore skolems assums b} label body body' :
    Typ.Interp ignore skolems assums b body body' →
    Typ.Interp ignore skolems assums b (.iso label body) (.iso label body')

  | entry {ignore skolems assums b} label body body' :
    Typ.Interp ignore skolems assums b body body' →
    Typ.Interp ignore skolems assums b (.entry label body) (.entry label body')

  | inter {ignore skolems assums b} l l' r r'  :
    Typ.Interp ignore skolems assums b l l' →
    Typ.Interp ignore skolems assums b r r' →
    Typ.Interp ignore skolems assums b (.inter l r) (Typ.simp (Typ.inter l' r'))

  | unio {ignore skolems assums b} l l' r r'  :
    Typ.Interp ignore skolems assums b l l' →
    Typ.Interp ignore skolems assums b r r' →
    Typ.Interp ignore skolems assums b (.unio l r) (Typ.simp (Typ.unio l' r'))

  | path {ignore skolems assums b} antec antec' consq consq'  :
    Typ.Interp ignore skolems assums b antec antec' →
    Typ.Interp ((Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore)
      skolems assums b consq consq' →
    Typ.Interp ignore skolems assums b (Typ.path antec consq) (Typ.path antec' consq')

  | exi_all_positive {ignore skolems assums} ids_exi quals_exi quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        ListSubtyping.Static (ids_exi ∪ skolems) assums (quals_exi ∪ quals) skolems' assums' →
        Zone.Interp ignore .true ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        ListSubtyping.Static (ids_exi ∪ skolems) assums (quals_exi ∪ quals) skolems' assums')
    ) →

    Typ.Interp ignore skolems assums .true
      (.exi ids_exi quals_exi (.all _ quals body))
      (ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones)


  | all_positive {ignore skolems assums} ids_exi quals body zones:
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        ListSubtyping.Static (ids_exi ∪ skolems) assums quals skolems' assums' →
        Zone.Interp ignore .true ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' , ListSubtyping.Static skolems assums quals skolems' assums')
    ) →

    Typ.Interp ignore skolems assums .true
      (.all _ quals body)
      (ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones)

  | all_exi_negative {ignore skolems assums} ids_all quals_all quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        ListSubtyping.Static (ids_all ∪ skolems) assums (quals_all ∪ quals) skolems' assums' →
        Zone.Interp ignore .false ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        ListSubtyping.Static (ids_all ∪ skolems) assums (quals_all ∪ quals) skolems' assums')
    ) →

    Typ.Interp ignore skolems assums .false
      (.all ids_all quals_all (.exi _ quals body))
      (ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones)

  | exi_negative {ignore skolems assums} quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        ListSubtyping.Static skolems assums quals skolems' assums' →
        Zone.Interp ignore .false ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        ListSubtyping.Static skolems assums quals skolems' assums')
    ) →

    Typ.Interp ignore skolems assums .false
      (.exi _ quals body)
      (ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones)

end

def ListSubtyping.loop_split : List Typ → (List String) × (List Typ)
| [] => ([], [])
| (.var id) :: ts =>
    let (ids, ts') := ListSubtyping.loop_split ts
    (id :: ids, ts')
| t :: ts =>
    let (ids, ts') := ListSubtyping.loop_split ts
    (ids, t :: ts')

def List.to_option {α} : List α → Option α
| [] => .none
| x :: [] => .some x
| _ => .none

def ListSubtyping.remove_by_var (id : String)
: List (Typ × Typ) → List (Typ × Typ)
| [] => []
| (.var idl, .var idu) :: cs =>
  if idl == id || idu == id then
    ListSubtyping.remove_by_var id cs
  else
    (.var idl, .var idu) :: ListSubtyping.remove_by_var id cs
| (.var idl, upper) :: cs =>
  if idl == id  then
    ListSubtyping.remove_by_var id cs
  else
    (.var idl, upper) :: ListSubtyping.remove_by_var id cs

| (lower, .var idu) :: cs =>
  if idu == id then
    ListSubtyping.remove_by_var id cs
  else
    (lower, .var idu) :: ListSubtyping.remove_by_var id cs
| c :: cs =>
    c :: ListSubtyping.remove_by_var id cs


def ListSubtyping.loop_normal_form (id : String) (assums : List (Typ × Typ))
: Option (List (Typ × Typ)) :=
  let bds :=  ListSubtyping.bounds id .false assums
  let (ids, ts) := ListSubtyping.loop_split bds
  let all_are_paths := ts.all (fun t =>
    match t with
    | Typ.path _ _ => true
    | _ => true
  )
  if assums.isEmpty then
    Option.some []
  else if all_are_paths then
    match List.to_option ids with
    | some id => .some (ListSubtyping.remove_by_var id assums)
    | none => .none
  else
    Option.none


mutual
  partial def Function.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (subtras : List Typ) :
    List (Pat × Expr) → Lean.MetaM (List (List Zone))
  | [] => return []

  | (p,e)::f => do
    let (tp, Δ', Γ') ←  PatLifting.Static.compute Δ Γ p
    let nested_zones ← Function.Typing.Static.compute Θ Δ Γ (tp::subtras) f
    let tl := ListTyp.diff tp subtras
    let zones ← (← Expr.Typing.Static.compute Θ Δ' Γ' e).mapM (fun ⟨Θ', Δ'', tr ⟩ => do
      let ⟨skolems'', assums''', t⟩ ← Zone.interpret [] .true ⟨Θ', Δ'', (.path tl tr)⟩
      return ⟨List.diff skolems'' Θ, List.diff assums''' Δ, t⟩
    )
    return zones :: nested_zones


  partial def ListZone.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (e : Expr) :
  Lean.MetaM (List Zone) := do
    (← Expr.Typing.Static.compute Θ Δ Γ e).mapM (fun  ⟨Θ', Δ', t⟩ =>
      return ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩
    )

  partial def LoopListZone.Subtyping.Static.compute
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

  | zones => do
    let op_result ← (ListZone.invert id zones).bindM (fun zones' => do
      let t' := ListZone.pack (id :: pids) .false zones'
      (Typ.factor id t' "left").bindM (fun l => do
      (Typ.factor id t' "right").bindM (fun r => do
        let l' ← Typ.interpret [id] [] [] .false l
        let r' ← Typ.interpret [id] [] [] .false r
        return Option.some (Typ.path (.lfp id l') (.lfp id r'))
      ))
    )
    match op_result with
    | .some result => return result
    | .none => failure

  partial def Record.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
  : List (String × Expr) → Lean.MetaM (List Zone)
  | [] => return [⟨Θ, Δ, .top⟩]
  | (l,e) :: [] => do
    (← (Expr.Typing.Static.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      return [⟨Θ', Δ', (.entry l t)⟩]
    )
  | (l,e) :: r => do
    (← (Expr.Typing.Static.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
    (← (Record.Typing.Static.compute Θ' Δ' Γ r)).flatMapM (fun ⟨Θ'', Δ'',t'⟩ =>
      return [⟨Θ'', Δ'', (.inter (.entry l t) (t'))⟩]
    ))

  partial def Expr.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
  : Expr → Lean.MetaM (List Zone)
  | .var x =>  match find x Γ with
    | .some t => return [⟨Θ, Δ, t⟩]
    | .none => failure

  | .iso label body => do
    (← Expr.Typing.Static.compute Θ Δ Γ body).mapM (fun ⟨skolems', assums', body'⟩ =>
      return ⟨skolems', assums', Typ.iso label body'⟩
    )

  | .record r =>  Record.Typing.Static.compute Θ Δ Γ r

  | .function f => do
    -- Lean.logInfo ("<<< assums >>>\n" ++ (repr Δ))
    let nested_zones ← (Function.Typing.Static.compute Θ Δ Γ [] f)
    -- Lean.logInfo ("<<< Nested Zones >>>\n" ++ (repr nested_zones))
    let zones := (nested_zones.flatten)
    let t := ListZone.pack (ListSubtyping.free_vars Δ) .true zones
    return [⟨Θ, Δ, t⟩]

  | .app ef ea => do
    let α ← fresh_typ_id
    (← Expr.Typing.Static.compute Θ Δ Γ ef).flatMapM (fun ⟨Θ', Δ', tf⟩ => do
    (← Expr.Typing.Static.compute Θ' Δ' Γ ea).flatMapM (fun ⟨Θ'', Δ'', ta⟩ => do
    (← Subtyping.Static.solve Θ'' Δ'' tf (.path ta (.var α))).flatMapM (fun ⟨Θ''', Δ'''⟩ => do
      -- NOTE: do not remove anything from global assumptions
      let t ← Typ.interpret [] Θ''' Δ''' .true (.var α)
      return [ ⟨Θ''', Δ''', t⟩ ]
    )))

  | .loop e => do
    let id ← fresh_typ_id
    (← Expr.Typing.Static.compute Θ Δ Γ e).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      let id_antec ← fresh_typ_id
      let id_consq ← fresh_typ_id

      let body := (Typ.path (.var id_antec) (.var id_consq))

      let zones_local ← (
        ← Subtyping.Static.solve Θ' Δ' t (Typ.path (.var id) body)
      ).flatMapM (fun (skolems'', assums'') => do
        let ⟨skolems''', assums'', body'⟩ ← Zone.interpret [id] .true ⟨skolems'', assums'', body⟩
        let op_assums''' := ListSubtyping.loop_normal_form id assums''
        match op_assums''' with
        | some assums''' =>
          return [Zone.mk (List.removeAll skolems''' Θ) (List.removeAll assums''' Δ') body']
        | none => return []
      )
      -- Lean.logInfo ("<<< LOOP ID >>>\n" ++ (repr id))
      -- Lean.logInfo ("<<< ZONES LOCAL >>>\n" ++ (repr zones_local))
      let t' ← LoopListZone.Subtyping.Static.compute (ListSubtyping.free_vars Δ') id zones_local

      return [⟨Θ', Δ', t'⟩]
    )


  | .anno e ta =>
    if Typ.free_vars ta == [] then do
      let zones ← ListZone.Typing.Static.compute Θ Δ Γ e
      let te := ListZone.pack (ListSubtyping.free_vars Δ) .false zones
      (← Subtyping.Static.solve Θ Δ te ta).flatMapM (fun (Θ', Δ') =>
        return [⟨Θ', Δ', ta⟩]
      )
    else
      return []

end


inductive LoopListZone.Subtyping.Static : List String → String → List Zone → Typ → Prop
| batch {pids id zones} zones' t' left right :
  ListZone.invert id zones = .some zones' →
  ListZone.pack (id :: pids) .false zones' = t' →
  -- TODO; consider if monotonicity can be derived from invert and pack
  Typ.Monotonic.Static id .true t' →
  Typ.factor id t' "left" = .some left →
  Typ.factor id t' "right" = .some right →
  LoopListZone.Subtyping.Static pids id zones (.path (.lfp id left) (.lfp id right))

| stream {pids id} skolems assums assums' idl r t' l r' l' r'' :
  id ≠ idl →
  idl ∉ ListSubtyping.free_vars assums →
  ListSubtyping.invert id assums = .some assums' →
  Zone.pack (id :: idl :: pids) .false ⟨skolems, assums', .pair (.var idl) r⟩ = t' →
  Typ.Monotonic.Static id .true t' →
  Typ.factor id t' "left" = .some l →
  Typ.factor id t' "right" = .some r' →
  Typ.Monotonic.Static idl .true (.lfp id r') →
  Typ.UpperFounded id l l' → -- TODO; this should imply Monotonic.Dynamic
  Typ.sub [(idl, .lfp id l')] (.lfp id r') = r'' →
  LoopListZone.Subtyping.Static
  pids id [⟨skolems, assums, .path (.var idl) r⟩]
  (.path (.var idl) r'')

mutual
  inductive Function.Typing.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    List Typ → -- subtras
    List (Pat × Expr) → List (List Zone) → Prop
  | nil {skolems assums context subtras} :
    Function.Typing.Static skolems assums context subtras [] []

  | cons {skolems context } {assums : List (Typ × Typ)}
    p e f assums' context' tp zones nested_zones subtras
  :
    PatLifting.Static assums context p tp assums' context' →
    (∀ skolems''' assums'''' t , ⟨skolems''', assums'''', t⟩ ∈ zones →
      ∀ skolems'' , List.removeAll skolems'' skolems = skolems''' →
      ∀ assums''' , List.removeAll assums''' assums = assums'''' →
      ∀ skolems' assums'' tr ,
        Zone.Interp [] .true
          ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ⟨skolems'', assums''', t⟩ →
        Expr.Typing.Static skolems assums' context' e tr skolems' assums''
    ) →

    (∀ skolems''' assums'''' t, ⟨skolems''', assums'''', t⟩ ∈ zones →
      ∃ skolems'' , List.removeAll skolems'' skolems = skolems''' ∧
      ∃ assums''' , List.removeAll assums''' assums = assums'''' ∧
      ∃ skolems' assums'' tr ,
        Zone.Interp [] .true
          ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ⟨skolems'', assums''', t⟩
    ) →
    Function.Typing.Static skolems assums context (tp :: subtras) f nested_zones →
    Function.Typing.Static skolems assums context subtras ((p,e)::f) (zones :: nested_zones)


  inductive Record.Typing.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    List (String × Expr) → Typ → List String → List (Typ × Typ) → Prop
  | nil {skolems assums context} :
    Record.Typing.Static skolems assums context [] .top skolems assums

  | single {skolems assums context  skolems' assums'} l e body :
    Expr.Typing.Static skolems assums context e body skolems' assums' →
    Record.Typing.Static skolems assums context
      ((l,e) :: []) (.entry l body) skolems' assums'

  | cons {skolems assums context  skolems'' assums''} l e r body t skolems' assums' :
    Expr.Typing.Static skolems assums context e body skolems' assums' →
    Record.Typing.Static skolems' assums' context r t skolems'' assums'' →
    Record.Typing.Static skolems assums context
      ((l,e) :: r) (.inter (.entry l body) (t))
      skolems'' assums''

  inductive Expr.Typing.Static :
    List String → List (Typ × Typ) → List (String × Typ) →
    Expr → Typ → List String → List (Typ × Typ) → Prop
  | var {t} skolems assums context x :
    find x context = .some t →
    Expr.Typing.Static skolems assums context (.var x) t skolems assums

  | record {skolems assums context t} r :
    Record.Typing.Static skolems assums context r t skolems assums →
    Expr.Typing.Static skolems assums context (.record r) t skolems assums

  | function {skolems assums context t} f nested_zones :
    Function.Typing.Static skolems assums context [] f nested_zones →
    ListZone.pack (ListSubtyping.free_vars assums) .true (nested_zones.flatten) = t →
    Expr.Typing.Static skolems assums context (.function f) t skolems assums


  | app {skolems assums context skolems''' assums'''}
    ef ea id tf skolems' assums' ta skolems'' assums'' t:
    Expr.Typing.Static skolems assums context ef tf skolems' assums' →
    Expr.Typing.Static skolems' assums' context ea ta skolems'' assums'' →
    Subtyping.Static skolems'' assums'' tf (.path ta (.var id)) skolems''' assums''' →
    Typ.Interp [] skolems''' assums''' .true (.var id) t →
    Expr.Typing.Static skolems assums context (.app ef ea) t skolems''' assums'''

  | loop {skolems assums context t' skolems' assums'} e t id zones id_antec id_consq  :
    Expr.Typing.Static skolems assums context e t skolems' assums' →
    (∀ skolems'''' assums''''' body', ⟨skolems'''', assums''''', body'⟩ ∈ zones →
      ∀ skolems''' , List.removeAll skolems''' skolems' = skolems'''' →
      ∀ assums'''' , List.removeAll assums'''' assums' = assums''''' →
      ∀ assums''' , ListSubtyping.loop_normal_form id assums''' = .some assums'''' →
      ∀ skolems'' assums'',
      Zone.Interp [id] .true
        ⟨skolems'', assums'', (Typ.path (.var id_antec) (.var id_consq))⟩
        ⟨skolems''', assums''', body'⟩ →
      Subtyping.Static skolems' assums' t (.path (.var id)
        (Typ.path (.var id_antec) (.var id_consq)))
        skolems'' assums''
    ) →

    (∀ skolems'''' assums''''' body', ⟨skolems'''', assums''''', body'⟩ ∈ zones →
      ∃ skolems''' , List.removeAll skolems''' skolems' = skolems'''' ∧
      ∃ assums'''' , List.removeAll assums'''' assums' = assums''''' ∧
      ∃ assums''' , ListSubtyping.loop_normal_form id assums''' = .some assums'''' ∧
      ∃ skolems'' assums'',
      Zone.Interp [id] .true
        ⟨skolems'', assums'', (Typ.path (.var id_antec) (.var id_consq))⟩
        ⟨skolems''', assums''', body'⟩
    ) →
    LoopListZone.Subtyping.Static (ListSubtyping.free_vars assums') id zones t' →
    id ∉ ListSubtyping.free_vars assums' →
    Expr.Typing.Static skolems assums context (.loop e) t' skolems' assums'

  | anno {skolems assums context skolems'' assums''} e ta te skolems' assums' :
    Typ.free_vars ta ⊆ [] →
    Expr.Typing.Static skolems assums context e te skolems' assums' →
    Subtyping.Static skolems' assums' te ta skolems'' assums'' →
    Expr.Typing.Static skolems assums context (.anno e ta) ta skolems'' assums''


end


syntax "eq_rhs_assign" : tactic

elab_rules : tactic
| `(tactic| eq_rhs_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  Lean.logInfo m!"goalType: {goalType}"

  let mvar ← (match goalType with
  | .app _ right => return right
  | _ => failure
  )

  let left ← (match (← Lean.Meta.whnf goalType) with
  | .app (.app _ left) _ => return left
  | _ => failure
  )
  -- let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

  Lean.logInfo m!"left: {left}"
  Lean.logInfo m!"mvar: {mvar}"

  Lean.MVarId.assign mvar.mvarId! left
  let goalType_instantiated ← (Lean.instantiateMVars goalType)

example : ∃ t, "thing" = t
:= by
  use ?t
  eq_rhs_assign
  { rfl  }
  { exact "" }




def Function.Typing.Static.extract_mvar : Lean.Expr → Lean.MetaM Lean.Expr
| .app x y => return y
| _ => failure

def Function.Typing.Static.extract_info : Lean.Expr → Lean.MetaM Lean.Expr
| .app x y => return x
| _ => failure

def Function.Typing.Static.extract_applicands :
  Lean.Expr → Lean.MetaM (Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr)
| Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app _ a ) b) c) d) e =>
    return (a,b,c,d,e)
| _ => failure

def Function.Typing.Static.to_computation :
  Lean.Expr → Lean.MetaM Lean.Expr
| Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Function.Typing.Static [])
  a ) b) c) d) e =>
    return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
      (Lean.Expr.const `Function.Typing.Static.compute [])
    a ) b) c) d) e
| _ => failure



syntax "Function_Typing_Static_assign" : tactic

elab_rules : tactic
| `(tactic| Function_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  let mvar ← Function.Typing.Static.extract_mvar goalType
  let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

  -- Lean.logInfo m!"mvar: {mvar}"
  -- Lean.logInfo m!"GoalInfo: {goalInfo}"
  let computation ← Function.Typing.Static.to_computation goalInfo

  -- Lean.logInfo m!"Computation: {computation}"

  let ListListZoneTypeExpr := Lean.mkApp
    (Lean.mkConst ``Lean.MetaM)
    (Lean.mkApp
      (Lean.mkConst ``List [Lean.levelZero])
      (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))
    )
  let metaM_result ← unsafe Lean.Meta.evalExpr
    (Lean.MetaM (List (List Zone)))
    ListListZoneTypeExpr computation
  let result ← metaM_result
  -- Lean.logInfo ("<<<result>>> " ++ (repr result))
  let lean_expr_result := Lean.toExpr result
  Lean.MVarId.assign mvar.mvarId! lean_expr_result
  let goalType_instantiated ← (Lean.instantiateMVars goalType)
  -- Lean.Elab.Tactic.replaceMainGoal [goal]

  ---------------------------------------

#eval Function.Typing.Static.compute [] [] [] [] [(Pat.var "x", Expr.var "x")]

example  : ∃ nested_zones , Function.Typing.Static [] [] [] [] [(Pat.var "x", Expr.var "x")] nested_zones
:= by
  use ?nested_zones
  { Function_Typing_Static_assign <;> sorry}
  { sorry }


syntax "ListZone_Typing_Static_assign" : tactic

elab_rules : tactic
| `(tactic| ListZone_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  let whnf ← Lean.Meta.whnf goalType
  let (antec, conseq) ← (match whnf with
  | Lean.Expr.forallE _ _ (
      Lean.Expr.forallE _ _ (
        Lean.Expr.forallE _ _ (
          Lean.Expr.forallE _ antec conseq _
        ) _
      ) _
    ) _ => return (antec, conseq)
  | _ => failure
  )


  Lean.logInfo m!"antec: {antec}"
  Lean.logInfo m!"conseq: {conseq}"

  let mvar  ← (match antec with
  | Lean.Expr.app (Lean.Expr.app _ a) _ => return a
  | _ => failure
  )

  -- Lean.logInfo m!"mvar: {mvar}"

  let pred  ← (match conseq with
  | Lean.Expr.app (Lean.Expr.app (Lean.Expr.app a _) _ ) _ => return a
  | _ => failure
  )

  let computation ← (match pred with
  | (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Expr.Typing.Static []) a) b) c) d
  ) => return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Expr.Typing.Static.compute []) a) b) c) d
  | _ => failure
  )

  -- Lean.logInfo m!"computation: {computation}"

  let ListZoneTypeExpr := Lean.mkApp
    (Lean.mkConst ``Lean.MetaM)
    (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))

  -- Lean.logInfo m!"ListZoneTypeExpr: {ListZoneTypeExpr}"

  let metaM_result ← unsafe Lean.Meta.evalExpr
    (Lean.MetaM (List Zone)) ListZoneTypeExpr computation
  let result ← metaM_result
  -- Lean.logInfo ("<<<result>>> " ++ (repr result))
  let lean_expr_result := Lean.toExpr result
  Lean.MVarId.assign mvar.mvarId! lean_expr_result
  let goalType_instantiated ← (Lean.instantiateMVars goalType)
  -- Lean.Elab.Tactic.replaceMainGoal [goal]

example t : ∃ zones : List Zone ,
∀ {skolems' : List String} {assums'' : List (Typ × Typ)} {tr : Typ},
  { skolems := skolems', assums := assums'', typ := Typ.path (ListTyp.diff t []) tr } ∈ zones →
    Expr.Typing.Static [] [] [] (Expr.record []) tr (skolems' ++ []) (assums'' ++ [])
:= by
  use ?_
  ListZone_Typing_Static_assign
  sorry
  sorry


syntax "Function_Typing_Static_prove" : tactic
syntax "Record_Typing_Static_prove" : tactic
syntax "Subtyping_GuardedListZone_Static_prove" : tactic
syntax "ListZone_Typing_Static_prove" : tactic
syntax "LoopListZone_Subtyping_Static_prove" : tactic
syntax "Expr_Typing_Static_prove" : tactic


macro_rules
| `(tactic| Function_Typing_Static_prove) => `(tactic|
  (try Function_Typing_Static_assign) ;
  (first
  | apply Function.Typing.Static.nil
  | apply Function.Typing.Static.cons <;> fail
    -- TODO: to compute and assign zones
    -- NOTE: needs tactics to extract inputs run computation and assign results
    -- NOTE: such tactics are extremely tedious
    -- { apply ListZone.tidy_undo_tidy }
    -- { simp [ListZone.undo_tidy]
    --   intros _ _ _ _ assums_eq t_eq
    --   simp [*, ListTyp.diff]
    --   apply And.intro
    --   { exact? }
    --   {
    --     repeat (apply Typ.diff_drop (not_eq_of_beq_eq_false rfl))
    --     rfl
    --   }
    -- }
    -- { Function_Typing_Static_prove }
    -- { PatLifting_Static_prove }
    -- { simp; intros _ _ _ p ; simp [ListZone.undo_tidy] at p ;
    --   simp [*]; Typing_Static_prove }
  ) <;> fail
)

| `(tactic| Record_Typing_Static_prove) => `(tactic|
  (first
  | apply Record.Typing.Static.nil
  | apply Record.Typing.Static.single
    · Expr_Typing_Static_prove
  | apply Record.Typing.Static.cons
    · Expr_Typing_Static_prove
    · Record_Typing_Static_prove
  ) <;> fail )

| `(tactic| ListZone_Typing_Static_prove) => `(tactic|
  (apply Subtyping.ListZone.Static.intro
    · intro
      · Expr_Typing_Static_prove
  ) )

| `(tactic| LoopListZone_Subtyping_Static_prove) => `(tactic|
  (first
  | apply LoopListZone.Subtyping.Static.batch
    · rfl
    · rfl
    · rfl
    · rfl
  | apply LoopListZone.Subtyping.Static.stream
    · simp
    · rfl
    · rfl
    · rfl
    · rfl
    · Typ_Monotonic_Static_prove
    · Typ_UpperFounded_prove
    · rfl
  ) <;> fail )

| `(tactic| Expr_Typing_Static_prove) => `(tactic|
  (first
  | apply Expr.Typing.Static.var
    · rfl
  | apply Expr.Typing.Static.record
    · Record_Typing_Static_prove

  | apply Expr.Typing.Static.function
    { Function_Typing_Static_prove }
    { reduce; simp_all ; try (eq_rhs_assign ; rfl) }

  | apply Expr.Typing.Static.app
    · Expr_Typing_Static_prove
    · Expr_Typing_Static_prove
    · Subtyping_Static_prove

  | apply Expr.Typing.Static.loop
    { Expr_Typing_Static_prove }
    { apply Subtyping.ListZone.Static.intro
      {intro; Subtyping_Static_prove}
      {rfl} }
    { LoopListZone_Subtyping_Static_prove }

  | apply Expr.Typing.Static.anno
    · simp
    · ListZone_Typing_Static_prove
    · rfl
    · Subtyping_Static_prove
  ) <;> fail )


set_option pp.fieldNotation false



theorem Typ.lfp_factor_elim_soundness {am id lower upper l fac} :
  Typ.factor id lower l = .some fac →
  Subtyping.Dynamic am fac upper →
  Subtyping.Dynamic am (Typ.lfp id lower) (.entry l upper)
:= by sorry


theorem ListSubtyping.Static.aux {skolems assums cs skolems' assums'} :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListSubtyping.free_vars cs ⊆ ListSubtyping.free_vars assums' ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars cs = []
:= by sorry

theorem Subtyping.Static.aux {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums' ∧
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars lower = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars upper = []
:= by sorry

theorem Expr.Typing.Static.aux {skolems assums context e t skolems' assums'} :
  Expr.Typing.Static skolems assums context e t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem Function.Typing.Static.aux
  {skolems assums context f nested_zones subtras skolems' assums' t}
:
  Function.Typing.Static skolems assums context subtras f nested_zones →
  ⟨skolems',assums',t⟩ ∈ nested_zones.flatten →
  skolems' ∩ skolems = [] ∧
  skolems' ∩ ListSubtyping.free_vars assums = [] ∧
  skolems' ∩ ListTyping.free_vars context = [] ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums
:= by sorry

theorem Record.Typing.Static.aux
  {skolems assums context r t skolems' assums'}
:
  Record.Typing.Static skolems assums context r t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem Subtyping.Static.upper_containment {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'
:= by
  intro h
  have ⟨p0, p1, p2, p3,_,_,_⟩ := Subtyping.Static.aux h
  apply p3



theorem ListSubtyping.restricted_rename {skolems assums ids quals ids' quals'} :
  ListSubtyping.toBruijn ids quals = ListSubtyping.toBruijn ids' quals' →
  ListSubtyping.restricted skolems assums quals →
  ListSubtyping.restricted skolems assums quals'
:= by sorry


theorem ListSubtyping.solution_completeness {skolems assums cs skolems' assums' am am'} :
  ListSubtyping.restricted skolems assums cs →
  ListSubtyping.Static skolems assums cs skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  MultiSubtyping.Dynamic (am' ++ am) cs →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry


theorem List.disjoint_swap {α} [BEq α] {xs ys : List α} :
  xs ∩ ys = [] → ys ∩ xs = []
:= by sorry

theorem ListSubtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' cs} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  MultiSubtyping.Dynamic (am ++ (am' ++ am'')) cs →
  MultiSubtyping.Dynamic (am' ++ (am ++ am'')) cs
:= by sorry

theorem Subtyping.Dynamic.dom_disjoint_concat_reorder {am am' am'' lower upper} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  Subtyping.Dynamic (am ++ (am' ++ am'')) lower upper →
  Subtyping.Dynamic (am' ++ (am ++ am'')) lower upper
:= by sorry

theorem Subtyping.assumptions_independence
  {skolems assums lower upper skolems' assums' am am'}
:
  Subtyping.Static skolems assums lower upper skolems' assums' →
  MultiSubtyping.Dynamic am assums' →
  ListPair.dom am' ⊆ ListSubtyping.free_vars assums →
  MultiSubtyping.Dynamic (am' ++ am) assums →
  MultiSubtyping.Dynamic (am' ++ am) assums'
:= by sorry

theorem Subtyping.Dynamic.pluck {am cs lower upper} :
  MultiSubtyping.Dynamic am cs →
  (lower, upper) ∈ cs →
  Subtyping.Dynamic am lower upper
:= by sorry

theorem Subtyping.Dynamic.trans {am lower upper} t :
  Subtyping.Dynamic am lower t → Subtyping.Dynamic am t upper →
  Subtyping.Dynamic am lower upper
:= by
  simp [Subtyping.Dynamic]
  intros p0 p1
  intros e p5
  apply p1
  apply p0
  assumption

theorem Subtyping.check_completeness {am lower upper} :
  Subtyping.Dynamic am lower upper →
  Subtyping.check lower upper
:= by sorry

theorem Typ.Monotonic.Static.soundness {id t} am :
  Typ.Monotonic.Static id true t →
  Typ.Monotonic.Dynamic am id t
:= by sorry

set_option maxHeartbeats 500000 in
mutual
  theorem ListSubtyping.Static.soundness {skolems assums cs skolems' assums'} :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping.Dynamic (am ++ am') assums' →
      MultiSubtyping.Dynamic (am ++ am') cs
    )
  | .nil => by
    exists []
    simp
    apply And.intro
    case left =>
      simp [ListPair.dom]
    case right =>
      intro am'
      intro md
      simp [MultiSubtyping.Dynamic]
  | .cons l r cs' skolems_im assums_im ss lss => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness ss
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness lss
    have ⟨p0,p1,p2,p3,p4,p5,p6⟩ := Subtyping.Static.aux ss
    have ⟨p7,p8,p9,p10,p11⟩ := ListSubtyping.Static.aux lss
    exists (am1 ++ am0)
    simp [*]
    apply And.intro
    { exact dom_concat_removeAll_containment p0 ih0l p7 ih1l }
    { intro am' p12
      simp [MultiSubtyping.Dynamic]
      apply And.intro
      { apply Subtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p2
          apply p10 }
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p3
          apply p10 }
        { apply ih0r
          apply MultiSubtyping.Dynamic.dom_reduction
          { apply List.disjoint_preservation_left ih1l p10 }
          { apply MultiSubtyping.Dynamic.reduction p8 p12 } } }
      { exact ih1r p12 }
    }


  theorem Subtyping.Static.soundness {skolems assums lower upper skolems' assums'} :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper)
  | .refl => by
    exists []
    simp [*]
    apply And.intro (by simp [ListPair.dom])
    intros am0 p1
    exact Subtyping.Dynamic.refl am0 lower

  | .iso_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.iso_pres l (ih0r p9)

  | .entry_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.entry_pres l (ih0r p9)

  | .path_pres lower0 lower1 upper0 upper1 skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.path_pres
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }
  | .bot_elim skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.Dynamic.bot_elim

  | .top_intro skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.Dynamic.top_intro

  | .unio_elim left right t skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.unio_elim
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .exi_elim ids quals body t skolems0 assums0 p0 p4 p5 p1 p2 => by

    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_removeAll_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply removeAll_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.Dynamic.exi_elim p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply removeAll_concat_containment_left
        apply removeAll_left_sub_refl_disjoint

      apply Subtyping.Dynamic.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.Dynamic.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.Dynamic.reduction p18 p24) p26 } }

  | .inter_intro t left right skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.Dynamic.inter_intro
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .all_intro t ids quals body skolems0 assums0 p0 p4 p5 p1 p2 => by
    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_removeAll_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply removeAll_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.Dynamic.all_intro p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply removeAll_concat_containment_left
        apply removeAll_left_sub_refl_disjoint

      apply Subtyping.Dynamic.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.Dynamic.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.Dynamic.reduction p18 p24) p26 } }

  | .placeholder_elim id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .placeholder_intro id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .skolem_placeholder_elim id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .skolem_placeholder_intro id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping.Dynamic] at p30
    simp [*]

  | .skolem_intro t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (ih0r p40) (Subtyping.Dynamic.pluck p40 (p10 p1))

  | .skolem_elim t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.trans t' (Subtyping.Dynamic.pluck p40 (p10 p1)) (ih0r p40)

  -------------------------------------------------------------------
  | .unio_antec a b r skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.unio_antec
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .inter_conseq upper a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.inter_conseq
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .inter_entry l a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.Dynamic.inter_entry
    { apply Subtyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.Dynamic.reduction p10 p16 } } }
    { exact ih1r p16 }

  -------------------------------------------------------------------
  | .lfp_skip_elim id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_skip_elim p0 (ih0r p40)

  | .lfp_induct_elim id lower p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_induct_elim (Typ.Monotonic.Static.soundness (am0 ++ am') p0) (ih0r p40)

  | .lfp_factor_elim id lower upper fac p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Typ.lfp_factor_elim_soundness p0 (ih0r p40)

  | .lfp_elim_diff_intro id lower upper sub h p0 p1 p2 p3 p4 p5 p6 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p4
    have ⟨p10,p15,p20,p25,p30,p35,p40⟩ := Subtyping.Static.aux p4
    exists am0
    simp [*]
    intros am' p45
    apply Subtyping.Dynamic.lfp_elim_diff_intro (Typ.Monotonic.Static.soundness (am0 ++ am') p3) (ih0r p45)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  | .diff_intro upper sub p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intro am' p40
    apply Subtyping.Dynamic.diff_intro (ih0r p40)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  -------------------------------------------------------------------
  | .lfp_peel_intro id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_peel_intro (ih0r p40)

  | .lfp_drop_intro id body p0 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.Dynamic.lfp_drop_intro (ih0r p40)
  -------------------------------------------------------------------

  | .diff_elim lower sub upper p0  => by

    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p10
    apply Subtyping.Dynamic.diff_elim (ih0r p10)

  | .unio_left_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_left_intro (ih0r p9)

  | .unio_right_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.unio_right_intro (ih0r p9)

  | .exi_intro ids quals upper skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.Dynamic.exi_intro (ih1r p40)
    apply Subtyping.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.Dynamic.reduction p11 p40 } }

  | .inter_left_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp[*]
    intros am' p9
    exact Subtyping.Dynamic.inter_left_elim (ih0r p9)

  | .inter_right_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.Dynamic.inter_right_elim (ih0r p9)

  | .all_elim ids quals lower skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.Dynamic.all_elim (ih1r p40)
    apply Subtyping.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.Dynamic.reduction p11 p40 } }

end


def Expr.Convergence (a b : Expr) :=
  ∃ e , ProgressionStar a e ∧ ProgressionStar b e

theorem Expr.Convergence.typing_left_to_right {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am a t →
  Typing.Dynamic am b t
:= by sorry

theorem Expr.Convergence.typing_right_to_left {a b am t} :
  Expr.Convergence a b →
  Typing.Dynamic am b t →
  Typing.Dynamic am a t
:= by sorry


theorem Typ.factor_expansion_soundness {am id t label t' e'} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e' (.lfp id t') →
  ∃ e ,
    Expr.Convergence (Expr.proj e label) e' ∧
    Typing.Dynamic am e (.lfp id t)
:= by sorry

theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
  Typ.factor id t label = some t' →
  Typing.Dynamic am e (.lfp id t) →
  Expr.Convergence (Expr.proj e label) e' →
  Typing.Dynamic am e' (.lfp id t')
:= by sorry



theorem ListZone.pack_positive_soundness {pids zones t am assums e} :
  ListZone.pack pids .true zones = t →
  -- ListZone.pack (ListSubtyping.free_vars assums) .true zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) ) →
  Typing.Dynamic am e t
:= by sorry


theorem Expr.Convergence.transitivity {a b c} :
  Expr.Convergence a b →
  Expr.Convergence b c →
  Expr.Convergence a c
:= by sorry

theorem Expr.Convergence.swap {a b} :
  Expr.Convergence a b →
  Expr.Convergence b a
:= by sorry

theorem Expr.Convergence.app_arg_preservation {a b} f :
  Expr.Convergence a b →
  Expr.Convergence (.app f a) (.app f b)
:= by sorry

theorem ListZone.pack_negative_soundness {pids zones t am assums e} :
  ListZone.pack pids .false zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  -- ListZone.pack (id :: ListSubtyping.free_vars assums) .false zones = t →
  MultiSubtyping.Dynamic am assums →
  Typing.Dynamic am e t →
  (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones ∧
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) )
:= by sorry

theorem Zone.pack_negative_soundness {pids t am assums skolems' assums' t'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  ∀ e, Typing.Dynamic am e t →
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) )
:= by sorry


example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  apply h0
  intro h2
  exact h1

example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  specialize h0 (by exact fun a ↦ h1)
  exact h0



theorem Zone.pack_negative_completeness {pids t am assums skolems' assums' t' e am'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping.Dynamic am assums →
  MultiSubtyping.Dynamic (am' ++ am) assums' →
  Typing.Dynamic (am' ++ am) e t' →
  Typing.Dynamic am e t
:= by sorry
--   Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
--   ListSubtyping.free_vars assums ⊆ pids →
--   MultiSubtyping.Dynamic am assums →
--   ∀ e,
--     (∀ am'', ListPair.dom am'' ⊆ skolems' →
--       (∃ am',
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
--         Typing.Dynamic (am'' ++ am' ++ am) e t' ) ) →
--     Typing.Dynamic am e t
-- := by sorry

theorem ListZone.inversion_soundness {id zones zones' am assums} :
  ListZone.invert id zones = some zones' →
  MultiSubtyping.Dynamic am assums →
  ∀ ef,
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) ef t' ) ) )
  →
  (∀ ep ,
    (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones' ∧
      (∀ am'', ListPair.dom am'' ⊆ skolems' →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep t' ) )
    ) →
    Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
  )
:= by sorry


theorem ListSubtyping.inversion_soundness {id am assums assums0 assums0'} skolems tl tr :
  ListSubtyping.invert id assums0 = some assums0' →
  MultiSubtyping.Dynamic am assums →
  ∀ ef,
    (∃ am'',
      ListPair.dom am'' ⊆ skolems ∧
      ∀ {am' : List (String × Typ)},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 →
            Typing.Dynamic (am'' ++ am' ++ am) ef (.path tl tr))
    →
    (∀ ep,
      (∀ am'', ListPair.dom am'' ⊆ skolems →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep (.pair tl tr) )
      ) →
      Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
    )
:= by sorry

theorem ListSubtyping.inversion_top_extension {id am assums0 assums1} am' :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping.Dynamic (am' ++ am) assums0 →
  MultiSubtyping.Dynamic (am' ++ (id,.top)::am) assums0
:= by sorry

theorem ListSubtyping.inversion_substance {id am am' assums0 assums1} :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping.Dynamic (am' ++ (id,.top)::am) assums0 →
  MultiSubtyping.Dynamic (am' ++ (id,.bot)::am) assums1
:= by sorry



theorem Typing.Dynamic.lfp_elim_top {am e id t} :
  Typ.Monotonic.Dynamic am id t →
  Typing.Dynamic am e (.lfp id t) →
  Typing.Dynamic ((id, .top) :: am) e t
:= by sorry

theorem Typing.Dynamic.lfp_intro_bot {am e id t} :
  Typ.Monotonic.Dynamic am id t →
  Typing.Dynamic ((id, .bot) :: am) e t →
  Typing.Dynamic am e (.lfp id t)
:= by sorry

theorem Typing.Dynamic.existential_top_drop
  {id am skolems' assums assums0 ep}
  tl tr
:
  id ∉ (ListSubtyping.free_vars assums) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping.Dynamic (am'' ++ am' ++ (id,.top)::am) assums0 ∧
      Typing.Dynamic (am'' ++ am' ++ (id,.top)::am) ep (.pair tl tr)) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 ∧
      Typing.Dynamic (am'' ++ am' ++ am) ep (.pair tl tr) )


:= by sorry

theorem Typing.ListZone.Dynamic.existential_top_drop {id am assums ep} {zones' : List Zone} :
  id ∉ (ListSubtyping.free_vars assums) →
  (∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ (id,.top)::am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ (id,.top)::am) ep t'
  ) →
  ∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' ∧
          Typing.Dynamic (am'' ++ am' ++ am) ep t'


:= by sorry



theorem Typ.factor_imp_typing_covariant {am0 am1 id label t0 t0' t1 t1'} :
  Typ.factor id t0 label = .some t0' →
  Typ.factor id t1 label = .some t1' →
  (∀ e , Typing.Dynamic am0 e t0 → Typing.Dynamic am1 e t1) →
  (∀ e , Typing.Dynamic am0 e t0' → Typing.Dynamic am1 e t1')
:= by sorry

-- theorem Typ.factor_subtyping_soundness {am id label t0 t0' t1 t1'} :
--   Typ.factor id t0 label = .some t0' →
--   Typ.factor id t1 label = .some t1' →
--   Subtyping.Dynamic am t0 t1 →
--   Subtyping.Dynamic am t0' t1'
-- := by sorry

theorem Typ.Monotonic.Dynamic.pair {am id t0 t1} :
  Typ.Monotonic.Dynamic am id t0 →
  Typ.Monotonic.Dynamic am id t1 →
  Typ.Monotonic.Dynamic am id (.pair t0 t1)
:= by sorry

theorem Typ.factor_monotonic {am id label t t'} :
  Typ.factor id t label = .some t' →
  Typ.Monotonic.Dynamic am id t →
  Typ.Monotonic.Dynamic am id t'
:= by sorry


theorem Typ.UpperFounded.soundness {id l l'} am :
  Typ.UpperFounded id l l' →
  Subtyping.Dynamic am (.lfp id l) (.lfp id l')
:= by sorry

theorem Typ.sub_weaken_soundness {am idl t0 t1 t2} :
  Typ.sub [(idl, t0)] t1 = t2 →
  Typ.Monotonic.Dynamic am idl t1 →
  Subtyping.Dynamic am (.var idl) t0 →
  Subtyping.Dynamic am t1 t2
:= by sorry


theorem Subtyping.LoopListZone.Static.soundness {id zones t am assums e} :
  LoopListZone.Subtyping.Static (ListSubtyping.free_vars assums) id zones t →
  MultiSubtyping.Dynamic am assums →
  id ∉ ListSubtyping.free_vars assums →
  ------------------------------
  -- substance
  ------------------------------
  -- (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
  --   ∃ am' ,
  --   ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
  --   MultiSubtyping.Dynamic (am' ++ am) assums'
  -- ) →
  ------------------------------
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    -------------
    -- substance
    -------------
    (∃ am' ,
      ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
      MultiSubtyping.Dynamic (am' ++ am) assums'
    ) ∧
    -------------
    -- soundness
    -------------
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums' →
        Typing.Dynamic (am'' ++ am' ++ am) e t' ) )
  ) →
  ------------------------------
  Typing.Dynamic am e t
:= by
  intros p0 p1 p2 substance_and_soundness
  cases p0 with
  | batch zones' t' left right p4 p5 p6 p7 p8 =>
    unfold Typing.Dynamic
    intro ea
    intro p9

    have ⟨ep,p10,p11⟩ := Typ.factor_expansion_soundness p7 p9

    apply Expr.Convergence.typing_left_to_right
      (Expr.Convergence.app_arg_preservation e p10)

    apply Typ.factor_reduction_soundness p8 p11

    have p3 := (fun {x y z} mem_zones =>
      let ⟨substance, soundness⟩ := @substance_and_soundness x y z mem_zones
      soundness
    )
    apply ListZone.inversion_soundness p4 p1 at p3

    apply p3 ep

    have p12 : Typing.Dynamic ((id, .top) :: am) ep t' := by
      apply Typing.Dynamic.lfp_elim_top (Typ.Monotonic.Static.soundness am p6) p11
    have p13 : MultiSubtyping.Dynamic ((id,.top) :: am) assums := by
      apply MultiSubtyping.Dynamic.dom_single_extension p2 p1

    apply Typing.ListZone.Dynamic.existential_top_drop p2

    apply ListZone.pack_negative_soundness p5
      (List.subset_cons_of_subset id (fun _ x => x)) p13 p12


  | stream
    skolems assums0 assums0' idl r t' l r' l' r''
    p4 idl_fresh p5 p6 p7 p8 p9 p10 upper_founded sub_eq
  =>
    unfold Typing.Dynamic
    intro ea
    intro p13

    have ⟨substance, soundness⟩ := substance_and_soundness (Iff.mpr List.mem_singleton rfl)
    have ⟨am', dom_local_assums, subtyping_local_assums⟩ := substance

    have subtyping_assums0'_bot : MultiSubtyping.Dynamic (am' ++ (id,.bot)::am) assums0' := by
      apply ListSubtyping.inversion_substance p5
      apply ListSubtyping.inversion_top_extension am' p5 subtyping_local_assums

    have factor_pair : Typ.factor id (.pair (.var idl) r) "left" = some (Typ.var idl) := by
      reduce; rfl

    have monotonic_packed : Typ.Monotonic.Dynamic ((id, Typ.bot) :: am) id t' := by
      exact Typ.Monotonic.Static.soundness ((id, Typ.bot) :: am) p7

    have imp_typing_pair_to_packed :
      ∀ e ,
        Typing.Dynamic (am' ++ (id,.bot)::am) e (Typ.pair (Typ.var idl) r) →
        Typing.Dynamic ((id,.bot)::am) e t'
    := by
      intros e_pair typing_pair
      apply Zone.pack_negative_completeness p6
        (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
        (MultiSubtyping.Dynamic.dom_single_extension p2 p1)
        subtyping_assums0'_bot
        typing_pair

    have imp_typing_factored_left :
      ∀ e ,
        Typing.Dynamic (am' ++ (id,.bot)::am) e (Typ.var idl) →
        Typing.Dynamic ((id,.bot)::am) e l
    := by
      exact fun e a ↦ Typ.factor_imp_typing_covariant factor_pair p8 imp_typing_pair_to_packed e a

    have subtyping_idl_left : Subtyping.Dynamic ((id,.bot)::am) (Typ.var idl) l := by
      unfold Subtyping.Dynamic
      intros el typing_idl
      apply imp_typing_factored_left
      apply Typing.Dynamic.dom_extension
      { simp [Typ.free_vars]
        apply List.disjoint_preservation_left dom_local_assums
        exact List.nonmem_to_disjoint_right idl (ListSubtyping.free_vars assums0) idl_fresh }
      { exact typing_idl }

    have typing_idl_bot : Typing.Dynamic ((id,.bot)::am) ea (Typ.var idl) := by
      apply Typing.Dynamic.dom_single_extension (Iff.mp List.count_eq_zero rfl) p13

    have typing_factor_left_bot : Typing.Dynamic ((id,.bot)::am) ea l := by
      unfold Subtyping.Dynamic at subtyping_idl_left
      exact subtyping_idl_left ea typing_idl_bot

    have monotonic_left : Typ.Monotonic.Dynamic am id l := by
      apply Typ.factor_monotonic p8 (Typ.Monotonic.Static.soundness am p7)

    have typing_factor_left : Typing.Dynamic am ea (.lfp id l) :=
      Typing.Dynamic.lfp_intro_bot monotonic_left typing_factor_left_bot


    have subtyping_left_pre := Typ.UpperFounded.soundness am upper_founded
    unfold Subtyping.Dynamic at subtyping_left_pre

    have subtyping_left : Subtyping.Dynamic am (Typ.var idl) (Typ.lfp id l') := by
      unfold Subtyping.Dynamic
      intro el typing_idl
      apply subtyping_left_pre
      apply Typing.Dynamic.lfp_intro_bot monotonic_left
      unfold Subtyping.Dynamic at subtyping_idl_left
      apply subtyping_idl_left
      apply Typing.Dynamic.dom_single_extension (Iff.mp List.count_eq_zero rfl)
      exact typing_idl

    have subtyping_right : Subtyping.Dynamic am (.lfp id r') r'' := by
      apply Typ.sub_weaken_soundness sub_eq
        (Typ.Monotonic.Static.soundness am p10) subtyping_left

    unfold Subtyping.Dynamic at subtyping_right
    apply subtyping_right

    have ⟨ep,p14,p15⟩ := Typ.factor_expansion_soundness p8 typing_factor_left

    apply Expr.Convergence.typing_left_to_right (Expr.Convergence.app_arg_preservation e p14)
    apply Typ.factor_reduction_soundness p9 p15

    apply ListSubtyping.inversion_soundness skolems (Typ.var idl) r p5 p1 at soundness

    apply soundness ep

    have p20 : Typing.Dynamic ((id, .top) :: am) ep t' := by
      apply Typing.Dynamic.lfp_elim_top (Typ.Monotonic.Static.soundness am p7) p15

    have p22 : MultiSubtyping.Dynamic ((id,.top) :: am) assums := by
      apply MultiSubtyping.Dynamic.dom_single_extension p2 p1

    apply Typing.Dynamic.existential_top_drop (Typ.var idl) r p2

    apply Zone.pack_negative_soundness p6
      (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
      p22 ep p20

-- theorem ListZone.tidy_substance {pids zones0 zones1 am} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums0 ∧
--         MultiSubtyping.Dynamic (am'' ++ am) assums0)
--   →
--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums1 ∧
--         MultiSubtyping.Dynamic (am'' ++ am) assums1)
-- := by sorry


-- theorem ListZone.tidy_soundness {pids zones0 zones1 am assums e} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (ListSubtyping.free_vars assums) ⊆ pids →
--   MultiSubtyping.Dynamic am assums →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums0 →
--         Typing.Dynamic (am'' ++ am' ++ am) e t0 ) ) ) →

--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping.Dynamic (am'' ++ am' ++ am) assums1 →
--         Typing.Dynamic (am'' ++ am' ++ am) e t1 ) ) )
-- := by sorry

-- theorem ListZone.tidy_soundness_alt
--   {zones0 zones1 e context skolems assums1 t1}
--   {assums : List (Typ × Typ)}
-- :
--   ListZone.tidy (ListSubtyping.free_vars assums) zones0 = .some zones1 →
--   ⟨skolems, assums1, t1⟩ ∈ zones1 →

--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         MultiSubtyping.Dynamic (am'' ++ am') (assums0 ++ assums) →
--         ∀ {eam}, MultiTyping.Dynamic am' eam context →
--         Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t0 ) ) ) →

--   (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--     (∀ {am'},
--       MultiSubtyping.Dynamic (am'' ++ am') (assums1 ++ assums) →
--       ∀ {eam}, MultiTyping.Dynamic am' eam context →
--       Typing.Dynamic (am'' ++ am') (Expr.sub eam e) t1 ) )
-- := by sorry


theorem MultiSubtyping.Dynamic.concat {am cs cs'} :
  MultiSubtyping.Dynamic am cs →
  MultiSubtyping.Dynamic am cs' →
  MultiSubtyping.Dynamic am (cs ++ cs')
:= by sorry

theorem MultiSubtyping.Dynamic.union {am cs cs'} :
  MultiSubtyping.Dynamic am cs →
  MultiSubtyping.Dynamic am cs' →
  MultiSubtyping.Dynamic am (cs ∪ cs')
:= by sorry

theorem MultiSubtyping.Dynamic.concat_elim_left {am cs cs'} :
  MultiSubtyping.Dynamic am (cs ++ cs') →
  MultiSubtyping.Dynamic am cs
:= by sorry



theorem PatLifting.Static.soundness {assums context p t assums' context'} :
  PatLifting.Static assums context p t assums' context' →
  ∀ tam v, IsValue v → Typing.Dynamic tam v t →
    ∃ eam , pattern_match v p = .some eam ∧ MultiTyping.Dynamic tam eam context'
:= by sorry


theorem pattern_match_ids_containment {v p eam} :
  pattern_match v p = .some eam →
  ids_pattern p ⊆ ListPair.dom eam
:= by sorry



-- theorem PatLifting.Static.aux {assums context p t assums' context'} :
--   PatLifting.Static assums context p t assums' context' →
--   assums ⊆ assums' ∧
--   Typ.free_vars t ⊆ ListTyping.free_vars context' ∧
--   ListTyping.free_vars context'  ⊆ ListSubtyping.free_vars assums'
-- := by sorry

theorem Function.Typing.Static.subtra_soundness {
  skolems assums context f nested_zones subtra subtras skolems' assums' t
} :
  Function.Typing.Static skolems assums context  subtras f nested_zones →
  subtra ∈ subtras →
  ⟨skolems', assums', t⟩ ∈ nested_zones.flatten →
  ∀ am , ¬ Subtyping.Dynamic am t (.path subtra .top)
:= by sorry

mutual
  theorem Subtyping.Static.substance {
    skolems assums lower upper skolems' assums' am
  } :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    MultiSubtyping.Dynamic am assums →
    ∃ am'' ,
    ListPair.dom am'' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping.Dynamic (am'' ++ am) (List.removeAll assums' assums)
  := by sorry
end


theorem Typ.combine_bounds_positive_soundness {id am assums e} :
  (∀ am , MultiSubtyping.Dynamic am assums → Typing.Dynamic am e (.var id)) →
  MultiSubtyping.Dynamic am assums →
  Typing.Dynamic am e (Typ.combine_bounds id true assums)
:= by sorry

theorem Typ.combine_bounds_positive_subtyping_path_conseq_soundness {id am am_skol assums t antec} :
  id ∉ ListPair.dom am_skol →
  MultiSubtyping.Dynamic (am_skol ++ am) assums →
  (∀ {am} ,
    MultiSubtyping.Dynamic (am_skol ++ am) assums →
    Subtyping.Dynamic (am_skol ++ am) t (.path antec (.var id))
  ) →
  Subtyping.Dynamic (am_skol ++ am) t (.path antec (Typ.combine_bounds id true assums))
:= by sorry

-- theorem Typ.factor_expansion_soundness {am id t label t' e'} :
--   Typ.factor id t label = some t' →
--   Typing.Dynamic am e' (.lfp id t') →
--   ∃ e ,
--     Expr.Convergence (Expr.proj e label) e' ∧
--     Typing.Dynamic am e (.lfp id t)
-- := by sorry

-- theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
--   Typ.factor id t label = some t' →
--   Typing.Dynamic am e (.lfp id t) →
--   Expr.Convergence (Expr.proj e label) e' →
--   Typing.Dynamic am e' (.lfp id t')
-- := by sorry





mutual

  theorem Zone.Interp.aux {ignore skolems assums t skolems' assums' t'} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    skolems = skolems'
  := by sorry




  theorem Zone.Interp.integrated_positive_soundness
  {ignore skolems assums t skolems' assums' t' e skolems_base assums_base context} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems' skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') (List.removeAll assums' assums_base ∪ assums_base) →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry


  -- theorem Typ.Interp.positive_soundness {ignore skolems assums t t'} :
  --   Typ.Interp ignore skolems assums .true t t' →
  --   ∀ am , MultiSubtyping.Dynamic am assums → Subtyping.Dynamic am t t'
  -- := by sorry

  theorem Typ.Interp.integrated_positive_soundness
  {ignore skolems assums t t' e skolems_base context} :
    Typ.Interp ignore skolems assums .true t t' →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping.Dynamic (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping.Dynamic tam' eam context →
                Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry

end


theorem  ListSubtyping.loop_normal_form_integrated_completeness
{id am assums assums' assums''} :
  ListSubtyping.loop_normal_form id assums' = some assums'' →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping.Dynamic (am' ++ am) (List.removeAll assums' assums)
  ) →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums'' assums) ∧
      MultiSubtyping.Dynamic (am' ++ am) (List.removeAll assums'' assums)
  )
:= by sorry


theorem  Zone.Interp.assums_integrated_completeness
{ignore b am assums skolems' assums' t' skolems'' assums'' t''} :
  Zone.Interp ignore b ⟨skolems', assums', t'⟩ ⟨skolems'', assums'', t''⟩ →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping.Dynamic (am' ++ am) (List.removeAll assums' assums)
  ) →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums'' assums) ∧
      MultiSubtyping.Dynamic (am' ++ am) (List.removeAll assums'' assums)
  )
:= by sorry





theorem  ListSubtyping.loop_normal_form_integrated_soundness
{id am_base skolems skolems' assums assums' assums'' e t} :
  ListSubtyping.loop_normal_form id assums' = some assums'' →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping.Dynamic (am'' ++ am' ++ am_base) (List.removeAll assums' assums) →
      Typing.Dynamic (am'' ++ am' ++ am_base) e t
  ) →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping.Dynamic (am'' ++ am' ++ am_base) (List.removeAll assums'' assums) →
      Typing.Dynamic (am'' ++ am' ++ am_base) e t
  )
:= by sorry



theorem  Zone.Interp.integrated_soundness
{ignore b am_base skolems skolems' skolems'' assums assums' assums'' e t' t''} :
  Zone.Interp ignore b ⟨skolems', assums', t'⟩ ⟨skolems'', assums'', t''⟩ →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping.Dynamic (am'' ++ am' ++ am_base) (List.removeAll assums' assums) →
      Typing.Dynamic (am'' ++ am' ++ am_base) e t'
  ) →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems'' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping.Dynamic (am'' ++ am' ++ am_base) (List.removeAll assums'' assums) →
      Typing.Dynamic (am'' ++ am' ++ am_base) e t''
  )
:= by sorry


-- set_option maxHeartbeats 1000000 in
mutual

  theorem Function.Typing.Static.soundness {
    skolems assums context f nested_zones subtras skolems''' assums'''' t
  } :
    Function.Typing.Static skolems assums context subtras f nested_zones →
    ⟨skolems''', assums'''', t⟩ ∈ nested_zones.flatten →
    ∃ tam, ListPair.dom tam ⊆ skolems''' ∧
    (∀ tam', MultiSubtyping.Dynamic (tam ++ tam') (assums'''' ∪ assums) →
      (∀ eam, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam (.function f)) t ) )
  | .nil => by intros ; contradiction
  | .cons
      pat e f assums0 context0 tp zones nested_zones subtras
      pat_lifting_static typing_static keys function_typing_static
  => by
    intro mem_con_zones
    cases (Iff.mp List.mem_append mem_con_zones) with
    | inl mem_zones =>

      have ⟨skolems'', removeAll_skolems, assums''', removeAll_assums, skolems', assums'', tr, interp⟩ := (keys _ _ _ mem_zones)
      specialize typing_static _ _ _ mem_zones skolems'' removeAll_skolems assums''' removeAll_assums skolems' assums'' tr interp
      clear keys

      rw [← removeAll_skolems]
      rw [← removeAll_assums]

      apply Zone.Interp.integrated_positive_soundness interp

      have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness typing_static

      have ⟨p24,p26,p28,p30,p32,p34⟩ := Expr.Typing.Static.aux typing_static

      exists tam0

      apply And.intro ih0l

      intros tam' subtyping_dynamic_assums
      intros eam typing_dynamic_context
      apply Typing.Dynamic.function_head_elim
      intros v p44 p46
      have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p44 p46
      exists eam0
      simp [*]
      rw [Expr.sub_sub_removal (pattern_match_ids_containment p48)]

      apply ih0r subtyping_dynamic_assums
      apply MultiTyping.Dynamic.dom_reduction
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p28 p32 }
      { apply MultiTyping.Dynamic.dom_context_extension p50 }

    | inr p11 =>
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness function_typing_static p11
      have ⟨p20,p22,p24,p26⟩ := Function.Typing.Static.aux function_typing_static p11

      exists tam0
      simp [*]
      intros tam' p30
      intros eam p32

      apply Typing.Dynamic.function_tail_elim
      { intros v p40 p42
        have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p40 p42
        apply Exists.intro eam0 p48 }
      { apply Function.Typing.Static.subtra_soundness function_typing_static List.mem_cons_self p11 }
      { apply ih0r _ p30 _ p32 }


  theorem Record.Typing.Static.soundness {skolems assums context r t skolems' assums'} :
    Record.Typing.Static skolems assums context r t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping.Dynamic (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam (.record r)) t ) )
  | .nil => by
    exists []
    simp [*, ListPair.dom]
    intros tam' p10
    intros eam p20
    simp [Expr.sub, Expr.Record.sub]
    apply Typing.Dynamic.empty_record_top

  | .single l e body p0 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    exists tam0
    simp [*]
    intros tam' p40
    intros eam p50
    apply Typing.Dynamic.entry_intro (ih0r p40 p50)

  | .cons l e r body t skolems0 assums0 p0 p1 => by

    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Record.Typing.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26,p31⟩ := Record.Typing.Static.aux p1

    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)

    intros tam' p40
    intros eam p50
    apply Typing.Dynamic.inter_entry_intro
    { apply Typing.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p20 p26 }
      { apply ih0r
        { apply MultiSubtyping.Dynamic.dom_reduction
          { apply List.disjoint_preservation_left ih1l p26 }
          { apply MultiSubtyping.Dynamic.reduction p11 p40 } }
        { apply p50 } } }
    { apply ih1r p40
      apply MultiTyping.Dynamic.dom_extension
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p15 p25 }
      { apply p50 } }


  theorem Expr.Typing.Static.soundness {skolems assums context e t skolems' assums'} :
    Expr.Typing.Static skolems assums context e t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping.Dynamic (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping.Dynamic tam' eam context →
        Typing.Dynamic (tam ++ tam') (Expr.sub eam e) t ) )

  | .var skolems assums context x p0 => by
    exists []
    simp [ListPair.dom, *]
    intros tam' p1
    intros eam p2
    unfold MultiTyping.Dynamic at p2
    have ⟨e,p3,p4⟩ := p2 p0
    simp [Expr.sub, p3, p4]

  | .record r p0 => by
    apply Record.Typing.Static.soundness p0

  | .function f zones p0 p1 => by
      exists []
      simp [*, ListPair.dom]
      intros tam' p2
      intros eam p3

      apply ListZone.pack_positive_soundness p1 (fun _ x => x) p2
      intros skolesm0 assums0 t0 p4
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness p0 p4
      have ⟨p10,p11,p12,p13⟩ := Function.Typing.Static.aux p0 p4
      exists tam0
      simp [*]
      intro tam''
      intros p5 p6
      apply ih0r
      { apply MultiSubtyping.Dynamic.union p6
        apply MultiSubtyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih0l p11 }
        { apply MultiSubtyping.Dynamic.dom_extension p5 p2 } }
      { apply MultiTyping.Dynamic.dom_extension
        { apply List.disjoint_preservation_right p13 p5 }
        { apply p3 } }

  | .app ef ea id tf skolems0 assums0 ta skolems1 assums1 t p0 p1 p2 interp => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p105,p7,p8,p9⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p10,p11,p107,p12,p13,p14⟩ := Expr.Typing.Static.aux p1
    have ⟨tam2,ih2l,ih2r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2

    apply Typ.Interp.integrated_positive_soundness interp

    exists tam2 ++ (tam1 ++ tam0)
    apply And.intro
    { apply dom_concat_removeAll_containment
      { intro a p30 ; apply p10 (p5 p30) }
      { apply dom_concat_removeAll_containment p5 ih0l p10 ih1l }
      { apply p15 }
      { apply ih2l } }

    { simp [*]
      intro tam' p30 eam p31
      apply Typing.Dynamic.path_elim
      {
        unfold Subtyping.Dynamic at ih2r
        apply ih2r p30
        apply Typing.Dynamic.dom_extension
        { apply List.disjoint_preservation_left ih2l p20 }
        {
          apply Typing.Dynamic.dom_extension
          {
            apply List.disjoint_preservation_left ih1l
            apply List.disjoint_preservation_right p7 p13
          }
          {
            apply ih0r
            {
              apply MultiSubtyping.Dynamic.dom_reduction
              { apply List.disjoint_preservation_left ih1l p13 }
              {
                apply MultiSubtyping.Dynamic.dom_reduction
                { apply List.disjoint_preservation_left ih2l
                  apply List.disjoint_preservation_right
                  { apply ListSubtyping.free_vars_containment p11  }
                  { exact p19 }
                }
                { apply MultiSubtyping.Dynamic.reduction p11
                  apply MultiSubtyping.Dynamic.reduction p16 p30
                }
              }
            }
            {
              apply p31
            }
          }
        }
      }
      {
        apply Typing.Dynamic.dom_extension
        {
          apply List.disjoint_preservation_left ih2l
          apply List.disjoint_preservation_right p12 p19
        }
        {
          apply ih1r
          {
            apply MultiSubtyping.Dynamic.dom_reduction
            { apply List.disjoint_preservation_left ih2l p19 }
            { apply MultiSubtyping.Dynamic.reduction p16 p30 }
          }
          {
            apply MultiTyping.Dynamic.dom_extension
            { apply List.disjoint_preservation_right p105
              exact List.disjoint_preservation_left ih0l p8 }
            { apply p31 }
          }
        }
      }
    }

  | .loop body t0 id zones id_antec id_consq p0
    subtyping_static keys subtyping_static_zones id_fresh
  => by

    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p0
    exists tam0
    simp [*]

    intros tam' p20
    intros eam p30

    apply Subtyping.LoopListZone.Static.soundness subtyping_static_zones p20 id_fresh
    intros skolems'''' assums''''' body' mem_zones
    have ⟨
      skolems''', removeAll_skolems, assums'''', removeAll_assums,
      assums''', loop_normal_form, skolems'', assums'', interp
    ⟩ := keys _ _ _ mem_zones

    specialize subtyping_static _ _ _ mem_zones
      skolems''' removeAll_skolems assums'''' removeAll_assums
      assums''' loop_normal_form skolems'' assums'' interp

    rw [← removeAll_skolems]
    rw [← removeAll_assums]

    clear keys

    apply And.intro
    { -- substance / conditional completeness
      apply ListSubtyping.loop_normal_form_integrated_completeness loop_normal_form
      apply Zone.Interp.assums_integrated_completeness interp
      apply Subtyping.Static.substance subtyping_static p20
    }
    { -- soundness
      apply ListSubtyping.loop_normal_form_integrated_soundness loop_normal_form
      apply Zone.Interp.integrated_soundness interp

      have ⟨tam1, h33l, h33r⟩ := Subtyping.Static.soundness subtyping_static
      have ⟨p41,p42,p43,p44,p45,p46,p47⟩ := Subtyping.Static.aux subtyping_static
      exists tam1
      simp [*]

      intros tam'' p55 p56
      apply Typing.Dynamic.loop_path_elim id

      unfold Subtyping.Dynamic at h33r
      apply h33r
      {
        apply MultiSubtyping.Dynamic.removeAll_removal
        {
          apply MultiSubtyping.Dynamic.dom_extension
          { apply List.disjoint_preservation_left h33l p45 }
          { apply MultiSubtyping.Dynamic.dom_extension p55 p20 }
        }
        { exact p56 }
      }
      {
        apply Typing.Dynamic.dom_extension (List.disjoint_preservation_left h33l p46)
        apply Typing.Dynamic.dom_extension (List.disjoint_preservation_right p8 p55)
        apply ih0r p20 p30
      }
    }

  | .anno e ta te skolems0 assums0 p0 p1 p2 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p1
    have ⟨tam1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2
    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p15 ih1l)
    intros am' p40
    intros eam p42
    apply Typing.Dynamic.anno_intro (ih1r p40)
    apply Typing.Dynamic.dom_extension
    { apply List.disjoint_preservation_left ih1l p20 }
    { apply ih0r
      { apply MultiSubtyping.Dynamic.dom_reduction
        { apply List.disjoint_preservation_left ih1l p19 }
        { apply MultiSubtyping.Dynamic.reduction p16 p40 } }
      { apply p42 } }

end
