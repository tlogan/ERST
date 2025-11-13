import Lean
import Lang.Basic
import Lang.Util

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

def Typ.base : Bool → Typ
| .true => .top
| .false => .bot


-- def Typ.rator : Bool → Typ → Typ → Typ
-- | .true => .inter
-- | .false => .unio

def Typ.rator : Bool → Typ → Typ → Typ
| .true, .top, r => r
| .true, l, .top => l
| .true, .bot, _ => .bot
| .true, _, .bot => .bot
| .true, l , r => .inter l r

| .false, .bot, r => r
| .false, l, .bot => l
| .false, .top, _ => .top
| .false, _, .top => .top
| .false, l , r => .unio l r

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

def Typ.break : Bool → Typ → List Typ
| .false, .unio l r => Typ.break .false l ++ Typ.break .false r
| .true, .inter l r => Typ.break .true l ++ Typ.break .true r
| _, t => [t]

def Typ.combine (b : Bool) : List Typ → Typ
| .nil => Typ.base b
| [t] => t

| t :: ts =>
  let t' := (Typ.combine b ts)
  if t == Typ.base b then
    t'
  else if t' == Typ.base b then
    t
  else
    Typ.rator b t t'

theorem Typ.break_false_left_size_lt {l r} :
  ListTyp.size (Typ.break false l) < Typ.size l + Typ.size r + 1
:= by sorry

theorem Typ.break_false_right_size_lt {l r} :
  ListTyp.size (Typ.break false r) < Typ.size l + Typ.size r + 1
:= by sorry

theorem Typ.break_true_left_size_lt {l r} :
  ListTyp.size (Typ.break true l) < Typ.size l + Typ.size r + 1
:= by sorry

theorem Typ.break_true_right_size_lt {l r} :
  ListTyp.size (Typ.break true r) < Typ.size l + Typ.size r + 1
:= by sorry

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
    · exact Typ.break_false_left_size_lt
    · exact Typ.break_false_right_size_lt
    · exact Typ.break_true_left_size_lt
    · exact Typ.break_true_right_size_lt
end


def Typ.interpret_one (id : String) (b : Bool) (assums : List (Typ × Typ)) : Typ :=
  let bds := (ListSubtyping.bounds id b assums).eraseDups
  if bds == [] then
    Typ.base (not b)
  else
    Typ.combine (not b) bds

def ListSubtyping.interpret_all (b : Bool) (Δ : List (Typ × Typ))
: (ids : List String) → List (String × Typ)
| .nil => []
| .cons id ids =>
  let i := Typ.interpret_one id b Δ
  if not b && i == .top then
    ListSubtyping.interpret_all b Δ ids
  else if b && i == .bot then
    ListSubtyping.interpret_all b Δ ids
  else
    (id, i) :: ListSubtyping.interpret_all b Δ ids


def Typ.interpret_path (pids : List String) (assums : List (Typ × Typ)) : Typ → Typ
| .path l r =>
  let params := Typ.free_vars l
  let δl := ListSubtyping.interpret_all .false assums (List.diff params pids)
  let δr := ListSubtyping.interpret_all .true assums
    (List.diff (List.diff (Typ.free_vars r) params) pids)
  let l' := Typ.simp (Typ.sub δl l)
  let r' := Typ.simp (Typ.sub (δl ∪ δr) r)
  .path l' r'
| t => t

def Typ.interpret_id_then_path (pids : List String) (Δ : List (Typ × Typ)) (id : String) : Typ :=
  let t := interpret_one id .true Δ
  if (t == .bot) then
    (.var id)
  else
    Typ.interpret_path pids Δ t


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

-- def Typ.mk_id_map (b : Bool) : Typ → Nat → List (String × Bool)
-- | _, 0 => []
-- | .var id, _ => [(id, b)]
-- | .path l r, n + 1 =>
--   (Typ.mk_id_map (not b) l n) ∪ (Typ.mk_id_map b r n)
-- | _, _ => []

-- def ListSubtyping.expand_id_map (id_map : List (String × Bool))
-- : List (Typ × Typ) → List (String × Bool)
-- | [] => id_map
-- | (lower, upper) :: cs =>
--   let id_map' := ListSubtyping.expand_id_map id_map cs
--   if (
--     Subtyping.removable_lower id_map lower &&
--     Subtyping.removable_lower id_map upper
--   ) then
--     (Typ.mk_id_map .false upper 2) ∪ (Typ.mk_id_map .true lower 2) ∪ id_map'
--   else if (Subtyping.removable_lower id_map lower) then
--     (Typ.mk_id_map .false upper 2) ∪ id_map'
--   else if (Subtyping.removable_upper id_map upper) then
--     (Typ.mk_id_map .true lower 2) ∪ id_map'
--   else
--     id_map'

-- def ListSubtyping.remove_by_bounds
--   (id_map : List (String × Bool)) (cs : List (Typ × Typ))
-- : List (Typ × Typ) :=
--   let id_map := ListSubtyping.expand_id_map id_map cs
--   match cs with
--   | [] => []
--   | (lower, upper) :: cs' =>
--     if (
--       Subtyping.removable_lower id_map lower ||
--       Subtyping.removable_upper id_map upper
--     ) then
--       ListSubtyping.remove_by_bounds id_map cs'
--     else
--       (lower, upper) :: ListSubtyping.remove_by_bounds id_map cs'

def ListSubtyping.remove_by_bounds (id_map : List (String × Bool)) : List (Typ × Typ) →
 List (Typ × Typ)
| [] => []
| (lower, upper) :: cs' =>
  if (
    Subtyping.removable_lower id_map lower ||
    Subtyping.removable_upper id_map upper
  ) then
    ListSubtyping.remove_by_bounds id_map cs'
  else
    (lower, upper) :: ListSubtyping.remove_by_bounds id_map cs'


def Typ.try_interpret_new
  (b : Bool) (skolems : List String) (assums : List (Typ × Typ)) (id : String)
: (Typ × List (String × Bool)) :=
  let t := interpret_one id b assums
  if (t == .top || t == .bot || id ∈ skolems) then
    (.var id, [])
  else
    let id_map := [(id,b)]
    (t, id_map)

def Typ.try_interpret_path_var (skolems : List String) (assums : List (Typ × Typ))
: Typ → (Typ × List (String × Bool))
| .path (.var idl) (.var idr) =>
  let (l', id_map_l) := Typ.try_interpret_new .false skolems assums idl
  let (r', id_map_r) := Typ.try_interpret_new .true skolems assums idr
  (.path l' r', id_map_l ++ id_map_r)
| t => (t, [])

-- TODO: test out the effect of interpretation in previous implementation
def Zone.tidy (pids : List String) : Zone → Option Zone
| ⟨skolems, assums, .path l r⟩ =>
  let t' := Typ.interpret_path pids assums (.path l r)
  let assums' := ListSubtyping.prune (pids ∪ skolems ∪ (Typ.free_vars t')) assums
  .some ⟨skolems, assums', t'⟩
| _ => failure

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
    if fids ∩ Θ != [] && fids ⊆ (pids ∪ Θ) then
      -- to be an outer constraints
      -- must have at least one skolem variable
      -- and all variables must either be skolem or foreign
      ((l,r) :: outer, inner)
    else
      (outer, (l,r) :: inner)


#eval ["a"] ∪ ["a"]

def Zone.pack (pids : List String) (b : Bool) : Zone → Typ
| ⟨Θ, Δ, t⟩ =>
  let fids := Typ.free_vars t
  let (outer, inner) := ListSubtyping.partition pids Θ Δ
  -- TODO: make sure exapmles work with the outer_ids
  let outer_ids := [] -- (ListSubtyping.free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (ListSubtyping.free_vars inner ∪ fids) (Θ ∪ pids)
  BiZone.wrap b outer_ids (outer.eraseDups) inner_ids (inner.eraseDups) t

def ListZone.pack (pids : List String) (b : Bool) : List Zone → Typ
| .nil => Typ.base b
| .cons zone [] =>
  Zone.pack pids b zone
| .cons zone zones =>
  let l := Zone.pack pids b zone
  let r := ListZone.pack pids b zones
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

-- set_option eval.pp true
#eval Typ.proj "T970" "left"
[typ| (<succ> T976) * (<cons> T977) ]
#eval Typ.proj "T970" "left"
[typ| EXI[T976 T977] [ (T976 * T977 <: T970) ] <succ> T976 * <cons> T977 ]

#eval Typ.factor "T970"
  [typ| <zero/> * <nil/> | EXI[T976 T977] [ (T976 * T977 <: T970) ] <succ> T976 * <cons> T977 ]
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
    | refl skolems assums t :
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

  partial def Zone.interpret (b : Bool) : Zone → Lean.MetaM (Zone × List (String × Bool))
  | ⟨skolems, assums, t⟩ => do
    let (t', id_map) ← Typ.repeat_interpret [] skolems assums t b 3
    let assums' := ListSubtyping.remove_by_bounds id_map assums
    return (⟨skolems, assums', t'⟩, id_map)

  partial def ListZone.interpret (b : Bool)
  : List Zone → Lean.MetaM (List Zone × List (String × Bool))
  | .nil => return ([], [])
  | .cons zone zones => do
    let (z, id_map) ← (Zone.interpret b zone)
    let (zs, id_map') ← (ListZone.interpret b zones)
    return (z :: zs, id_map ∪ id_map')


  partial def Typ.repeat_interpret
    (ignore : List String) (skolems : List String) (assums : List (Typ × Typ))
    (t : Typ) (b : Bool) :  Nat → Lean.MetaM (Typ × List (String × Bool))
  | 0 => Typ.interpret ignore skolems assums t b
  | n + 1 => do
    let (t', id_map') ← Typ.interpret ignore skolems assums t b
    if (t == t') then
      return (t, id_map')
    else
      let (t'', id_map'') ← Typ.repeat_interpret ignore skolems assums t' b n
      return (t'', id_map' ++ id_map'')

  partial def Typ.interpret
    (ignore : List String) (skolems : List String) (assums : List (Typ × Typ))
  : Typ → Bool → Lean.MetaM (Typ × List (String × Bool))
  | .var id, b => do
    if ignore.contains id || skolems.contains id then
      return (.var id, [])
    else
      let bds := (ListSubtyping.bounds id b assums).eraseDups
      if bds == [] then
        return (.var id, [])
      else
        let t := Typ.combine (not b) bds
        if (t == .bot || t == .top) then
          return (.var id, [])
        else
          return (t, [(id, b)])

  | .iso label body, b => do
    let (body', idm_body) ← Typ.interpret ignore skolems assums body b
    return (.iso label body', idm_body)

  | .entry label body, b => do
    let (body', idm_body) ← Typ.interpret ignore skolems assums body b
    return (.entry label body', idm_body)

  | .inter l r, b => do
    let (l', idm_l) ← Typ.interpret ignore skolems assums l b
    let (r', idm_r) ← Typ.interpret ignore skolems assums r b
    return (Typ.simp (Typ.inter l' r'), idm_l ∪ idm_r)

  | .unio l r, b => do
    let (l', idm_l) ← Typ.interpret ignore skolems assums l b
    let (r', idm_r) ← Typ.interpret ignore skolems assums r b
    return (Typ.simp (Typ.unio l' r'), idm_l ∪ idm_r)

  | .path antec consq, b => do
    let (antec', idm_antec) ← Typ.interpret ignore skolems assums antec (not b)
    let ignore' := (Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore
    let (consq', idm_consq) ← Typ.interpret ignore' skolems assums consq b
    return (Typ.simp (Typ.path antec' consq'), idm_antec ∪ idm_consq)

  | .exi ids_exi quals_exi (.all _ quals body), .true => do
    let constraints := quals_exi ++ quals
    let zones := (
      ← ListSubtyping.Static.solve (ids_exi ∪ skolems) assums constraints
    ).map (fun (skolems, assums) => Zone.mk skolems assums body)

    let (zones_full, id_map) ← ListZone.interpret .true zones

    let zones_local : List Zone := zones_full.map (fun ⟨skolems', assums', body'⟩ =>
      ⟨List.mdiff skolems' skolems, List.mdiff assums' assums, body'⟩
    )

    let t := ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones_local
    return (t, id_map)

  | (.all _ quals body), .true => do
    let constraints := quals
    let zones := (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).map (fun (skolems, assums) => Zone.mk skolems assums body)

    let (zones_full, id_map) ← ListZone.interpret .true zones

    let zones_local : List Zone := zones_full.map (fun ⟨skolems', assums', body'⟩ =>
      ⟨List.mdiff skolems' skolems, List.mdiff assums' assums, body'⟩
    )

    let t := ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones_local
    return (t, id_map)

  | .all ids_all quals_all (.exi _ quals body), .false => do
    let constraints := quals_all ++ quals
    let zones := (
      ← ListSubtyping.Static.solve (ids_all ∪ skolems) assums constraints
    ).map (fun (skolems, assums) => Zone.mk skolems assums body)

    let (zones_full, id_map) ← ListZone.interpret .false zones

    let zones_local : List Zone := zones_full.map (fun ⟨skolems', assums', body'⟩ =>
      ⟨List.mdiff skolems' skolems, List.mdiff assums' assums, body'⟩
    )

    let t := ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones_local
    return (t, id_map)

  | (.exi _ quals body), .false => do
    let constraints := quals
    let zones := (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).map (fun (skolems, assums) => Zone.mk skolems assums body)

    let (zones_full, id_map) ← ListZone.interpret .false zones

    let zones_local : List Zone := zones_full.map (fun ⟨skolems', assums', body'⟩ =>
      ⟨List.mdiff skolems' skolems, List.mdiff assums' assums, body'⟩
    )

    let t := ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones_local
    return (t, id_map)

  | t, _ => do
    return (t, [])
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

def ListSubtyping.remove_by_var (id :String)
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


def ListSubtyping.loop_normal_form (assums : List (Typ × Typ)) (id : String)
: Option (List (Typ × Typ)) :=
  let bds :=  ListSubtyping.bounds id .false assums
  let (ids, ts) := ListSubtyping.loop_split bds
  let all_are_paths := ts.all (fun t =>
    match t with
    | Typ.path _ _ => true
    | _ => true
  )
  if all_are_paths then
    match List.to_option ids with
    | some id => .some (ListSubtyping.remove_by_var id assums)
    | none => .none
  else
    Option.none

def ListZone.loop_normal_form (id : String) :
List Zone → Lean.MetaM (List Zone)
| [] => return []
| zone :: zones => do
  let (⟨skolems, assums, body⟩, _) ← Zone.interpret .true zone
  let zones_normal ← ListZone.loop_normal_form id zones
  match ListSubtyping.loop_normal_form assums id with
  | .some assums' =>
    return ⟨skolems, assums', body⟩ :: zones_normal
  | .none => return zones_normal


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
      let (zone, _) ← Zone.interpret .true ⟨List.diff Θ' Θ, List.diff Δ'' Δ, (.path tl tr)⟩
      return zone
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
        let (l', _) ← Typ.repeat_interpret [id] [] [] l .false 3
        let (r', _) ← Typ.repeat_interpret [id] [] [] r .false 3
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
      -- Lean.logInfo ("<<< APP TF  >>>\n" ++ (repr tf))
      -- Lean.logInfo ("<<< APP VAR  >>>\n" ++ (repr α))
      let (t, id_map) ← Typ.repeat_interpret [] Θ''' Δ''' (.var α) .true 10
      Lean.logInfo ("<<< APP ID MAP  >>>\n" ++ (repr id_map))
      -- Lean.logInfo ("<<< APP RESULT  >>>\n" ++ (repr t))
      let Δ'''' := ListSubtyping.remove_by_bounds id_map Δ'''
      -- return [ ⟨Θ''', Δ'''', t⟩ ]
      ------------------------------------
      return [ ⟨Θ''', Δ''', (.var α)⟩ ]
    )))

  | .loop e => do
    let id ← fresh_typ_id
    (← Expr.Typing.Static.compute Θ Δ Γ e).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      let id_antec ← fresh_typ_id
      let id_consq ← fresh_typ_id

      -----------------------------------------------------
      ---- NEW
      -----------------------------------------------------
      let body := (Typ.path (.var id_antec) (.var id_consq))

      let zones_local := (
        ← Subtyping.Static.solve Θ' Δ' t (Typ.path (.var id) body)
      ).map (fun (skolems'', assums'') =>
        Zone.mk (List.mdiff skolems'' Θ) (List.mdiff assums'' Δ) body
      )

      -- Lean.logInfo ("<<< ZONES LOCAL >>>\n" ++ (repr zones_local))

      let zones_normal ← ListZone.loop_normal_form id zones_local

      -- Lean.logInfo ("<<< ZONES NORMAL >>>\n" ++ (repr zones_normal))

      let t' ← LoopListZone.Subtyping.Static.compute (ListSubtyping.free_vars Δ') id zones_normal
      return [⟨Θ', Δ', t'⟩]


      -----------------------------------------------------
      -----------------------------------------------------
      ----------------------------------------------------------------

      -- Lean.logInfo ("<<< INPUT t >>>\n" ++ (repr t))

      -- Lean.logInfo ("<<< ID >>>\n" ++ id)

      -- NOTE: we expect the body of each zone to be a Typ.path
      -- let zones : List Zone :=
      --   (← Subtyping.Static.solve Θ' Δ' t (.path (.var id) (.path (.var id_antec) (.var id_consq)))).map (
      --     fun (Θ'', Δ'') =>
      --       let (interp, id_map) := Typ.try_interpret_path_var Θ'' Δ'' (Typ.path (.var id_antec) (.var id_consq))
      --       let Δ''' := ListSubtyping.remove_by_bounds id_map Δ''
      --       ⟨List.diff Θ'' Θ, List.diff Δ''' Δ, interp⟩
      --   )
      -- -- Lean.logInfo ("<<< ID >>>\n" ++ id)
      -- Lean.logInfo ("<<< ZONES ORIG >>>\n" ++ (repr zones))

      -- match (ListZone.tidy (id :: (ListSubtyping.free_vars Δ)) zones) with
      -- | .some zones' =>

      --   Lean.logInfo ("<<< ZONES TIDIED >>>\n" ++ (repr zones'))
      --   -- Lean.logInfo ("<<< ID >>>\n" ++ id)
      --   -- Lean.logInfo ("<<< BEFORE LOOP LIST ZONE >>>\n" ++ (repr zones'))
      --   -- Lean.logInfo ("<<< free vars >>>\n" ++ (repr (ListSubtyping.free_vars Δ')))
      --   let t' ← LoopListZone.Subtyping.Static.compute (ListSubtyping.free_vars Δ') id zones'
      --   -- Lean.logInfo ("<<< t' >>>\n" ++ (repr t'))
      --   return [⟨Θ', Δ', t'⟩]
      -- | .none =>
      --   failure
      ----------------------------------------------------------------
      ----------------------------------------------------------------
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


def ListSubtyping.get_lowers : List (Typ × Typ) → List Typ
| [] => []
| (lower, _) :: rest => lower :: (ListSubtyping.get_lowers rest)

def ListSubtyping.get_uppers : List (Typ × Typ) → List Typ
| [] => []
| (_, upper) :: rest => upper :: (ListSubtyping.get_uppers rest)


def Typ.connections (b : Bool) (t : Typ) :  List (Typ × Typ) → List (Typ × Typ)
| [] => []
| (lower, upper) :: rest =>
  if Typ.has_connection [] (not b) t lower ||  Typ.has_connection [] b t upper then
    (lower, upper) :: (Typ.connections b t rest)
  else
    (Typ.connections b t rest)

def ListTyp.transitive_connections
(explored : List (Bool × Typ))
(constraints : List (Typ × Typ))
(b : Bool) : List Typ → List (Typ × Typ)
| [] => []
| t :: ts =>
  if 1 + ts.length + 4 * constraints.length <= explored.length then
    []
  else if explored.contains (b,t) then
    let conns := Typ.connections b t constraints
    let lowers := ListSubtyping.get_lowers conns
    let uppers := ListSubtyping.get_uppers conns
    let tcs_lower := ListTyp.transitive_connections ((b,t) :: explored) constraints (not b) lowers
    let tcs_upper := ListTyp.transitive_connections ((b,t) :: explored) constraints b uppers
    let tcs_rest := ListTyp.transitive_connections ((b,t) :: explored) constraints b ts
    tcs_lower ∪ tcs_upper ∪ tcs_rest
  else
    ListTyp.transitive_connections ((b,t) :: explored) constraints b ts
termination_by ts => (ts.length + 4 * constraints.length) - explored.length
decreasing_by
· simp [*, List.length];  sorry
· sorry
· sorry
· sorry


-------------------------
---- NOTE: packaged constraint
-------------------------
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
    ) in
    [x => f(x)]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
      [<cons/> => <succ/>]
    ) in
    [x => f(x)]
  ]

-- RESULT: (<nil/> -> <uno/>)
-- TODO: construct a reachable procedure that filters constraints
-- to only those that are reachable from payload
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    -- def f = (
    --   [<nil/> => <zero/>]
    -- ) in
    def g = (
      [<zero/> => <uno/>]
    ) in
    -- f
    [x => g([<nil/> => <zero/>](x))]
  ]

-- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
      -- [<cons/> => <succ/>]
    ) in
    def g = (
      [<zero/> => <uno/>]
      -- [<succ/> => <dos/> ]
    ) in
    -- f
    [x => g(f(x))]
  ]

--------------------------------
--------------------------------
--------------------------------

-- -- RESULT: Even -> Uno | Dos
-- #eval Expr.Typing.Static.compute
--   [ids| ] [subtypings| ] []
--   [expr|
--     -- Even -> Even
--     def f = loop ([self =>
--       [<nil/> => <zero/>]
--       [<cons> n => <succ> (self(n)) ]
--     ]) in
--     def g = (
--       [<zero/> => <uno/>]
--       [<succ> n => <dos/> ]
--     ) in
--     [x => g(f(x))]
--   ]


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
    p e f assums' context' tp zones_tidied nested_zones zones subtras
  :
    PatLifting.Static assums context p tp assums' context' →
    (∀ {skolems' assums'' tr},
      ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ∈ zones →
      Expr.Typing.Static skolems assums' context' e tr (skolems' ++ skolems) (assums'' ++ assums)
    ) →
    (∀ {skolems' assums'' t},
      ⟨skolems', assums'', t⟩ ∈ zones →
      ∃ assums_ext, assums'' = assums_ext ++ assums' ∧
      ∃ tr , t = (.path (ListTyp.diff tp subtras) tr)
    ) →
    ListZone.tidy (ListSubtyping.free_vars assums) zones = .some zones_tidied →
    Function.Typing.Static skolems assums context (tp :: subtras) f nested_zones →
    Function.Typing.Static skolems assums context subtras ((p,e)::f) (zones_tidied :: nested_zones)

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
    ef ea id tf skolems' assums' ta skolems'' assums'' :
    Expr.Typing.Static skolems assums context ef tf skolems' assums' →
    Expr.Typing.Static skolems' assums' context ea ta skolems'' assums'' →
    Subtyping.Static skolems'' assums'' tf (.path ta (.var id)) skolems''' assums''' →
    -- TODO: update to match procedure with interp and repack
    Expr.Typing.Static skolems assums context (.app ef ea) (.var id) skolems''' assums'''

  | loop {skolems assums context t' skolems' assums'} e t id zones zones' id_body :
    -- TODO: update to match procedure
    -- let id_antec ← fresh_typ_id
    -- let id_consq ← fresh_typ_id
    Expr.Typing.Static skolems assums context e t skolems' assums' →
    (∀ {skolems'' assums'' t''},
      ⟨skolems'', assums'', t''⟩ ∈ zones →
      t'' = (Typ.interpret_one id_body .true (assums'' ++ assums')) ∧
      id_body ∉ skolems'' ∧
      Subtyping.Static skolems' assums' t (.path (.var id) (.var id_body))
        (skolems'' ++ skolems') (assums'' ++ assums')
    ) →
    ListZone.tidy (id :: (ListSubtyping.free_vars assums')) zones = .some zones' →
    LoopListZone.Subtyping.Static (ListSubtyping.free_vars assums') id zones' t' →
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
