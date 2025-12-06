import Lean
import Lang.Util
import Lang.Basic
import Lang.Dynamic

-- import Mathlib.Data.Set.Basic
-- import Mathlib.Data.List.Basic
import Mathlib.Tactic.Linarith

set_option eval.pp false
set_option pp.fieldNotation false

mutual


  def List.pair_typ_sub (δ : List (String × Typ)) : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder => .cons (Typ.sub δ l, Typ.sub δ r) (List.pair_typ_sub δ remainder)

  def Typ.sub (δ : List (String × Typ)) : Typ → Typ
  | .var id => match find id δ with
    | .none => .var id
    | .some t => t
  | .iso l body => .iso l (Typ.sub δ body)
  | .entry l body => .entry l (Typ.sub δ body)
  | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
  | .bot => .bot
  | .top => .top
  | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
  | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
  | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
  | .all ids subtypings body =>
      let δ' := remove_all δ ids
      .all ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .exi ids subtypings body =>
      let δ' := remove_all δ ids
      .exi ids (List.pair_typ_sub δ' subtypings) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end

def Typ.subfold (id : String) (t : Typ) : Nat → Typ
| 0 => .exi ["T"] .nil (.var "T")
| n + 1 => Typ.sub [(id, Typ.subfold id t n)] t

def Typ.break : Bool → Typ → List Typ
| .false, .unio l r => Typ.break .false l ++ Typ.break .false r
| .true, .inter l r => Typ.break .true l ++ Typ.break .true r
| _, t => [t]


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

theorem Typ.break_size_lte b t :
  ListTyp.size (Typ.break b t) ≤ Typ.size t
:= by sorry

def Typ.drop (id : String) (t : Typ) : Typ :=
  let cases := Typ.break .false t
  let cases' := List.filter (fun c => id ∉ Typ.free_vars c) cases
  Typ.combine .false cases'


theorem Typ.sub.typing.completeness {am id body e t} :
  Typing ((id, t) :: am) e body →
  Typing am e (Typ.sub [(id, t)] body)
:= by sorry


-- theorem Subtyping.lfp_elim_diff_intro {am id lower upper sub n} :
theorem Typ.subfold.subtyping.soundness_and_completeness {am id lower upper sub n} :
  Monotonic am id lower →
  Subtyping am (Typ.lfp id lower) upper →
  ¬ Subtyping am (Typ.subfold id lower 1) sub →
  ¬ Subtyping am sub (Typ.subfold id lower n) →
  Subtyping am (Typ.lfp id lower) (.diff upper sub)
:= by sorry


theorem Typ.sub.lfp.soundness {am t id body} :
  Subtyping am t (Typ.sub [(id, .lfp id body)] body) →
  Subtyping am t (Typ.lfp id body)
:= by sorry

theorem Typ.drop.lfp.soundness {am t id body} :
  Subtyping am t (Typ.drop id body) →
  Subtyping am t (Typ.lfp id body)
:= by sorry



structure Zone where
  skolems : List String
  assums : List (Typ × Typ)
  typ : Typ
deriving Repr, Lean.ToExpr

def Typ.inner : Bool → List String → List (Typ × Typ) → Typ → Typ
| .true => .all
| .false => .exi

def Typ.outer : Bool → List String → List (Typ × Typ) → Typ → Typ
| .true => .exi
| .false => .all

def BiZone.wrap (b : Bool)
: List String → List (Typ × Typ) → List String → List (Typ × Typ) → Typ → Typ
| [], .nil, [], .nil, t => t
| [], .nil, Θ', Δ', t => Typ.inner b Θ' Δ' t
| Θ, Δ, [], .nil, t => Typ.outer b Θ Δ t
| Θ, Δ, Θ', Δ', t => Typ.outer b Θ Δ (Typ.outer b Θ' Δ' t)

def Subtyping.target_bound : Bool → (Typ × Typ) → Typ × Typ
| .false, (l,r) => (l,r)
| .true, (l,r) => (r,l)


def List.pair_typ_bounds (id : String) (b : Bool) : List (Typ × Typ) → List Typ
| .nil => []
| .cons st sts =>
    let (t,bd) := Subtyping.target_bound b st
    if (.var id) == t then
      bd :: List.pair_typ_bounds id b sts
    else
      List.pair_typ_bounds id b sts

#eval [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
#eval (List.pair_typ_bounds "R" .true [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ])


-- def List.pair_typ_complex_vars : List (Typ × Typ) → List String
-- | [] => []
-- | (.var _ , .var _ ) :: sts => List.pair_typ_complex_vars sts
-- | (lower , .var _ ) :: sts => (Typ.free_vars lower) ++ (List.pair_typ_complex_vars sts)
-- | (.var _, upper) :: sts => (Typ.free_vars upper) ++ (List.pair_typ_complex_vars sts)
-- | (lower, upper) :: sts =>
--   (Typ.free_vars lower) ++ (Typ.free_vars upper) ++ (List.pair_typ_complex_vars sts)


def List.pair_typ_prune (pids : List String) : List (Typ × Typ) → List (Typ × Typ)
| .nil => []
| .cons (l,r) sts =>
  if (Typ.free_vars l) ∪ (Typ.free_vars r) ⊆ pids then
    (l,r) :: List.pair_typ_prune pids sts
  else
    List.pair_typ_prune pids sts

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


def List.pair_typ_invert (id : String) : List (Typ × Typ) → Option (List (Typ × Typ))
| .nil => return []
| .cons (.var id', .path l r) sts =>
    if id' == id then do
      let sts' ← List.pair_typ_invert id sts
      return (.pair l r, .var id') :: sts'
    else
      failure
| _ => failure

def ListZone.invert (id : String) : List Zone → Option (List Zone)
| .nil => return []
| .cons ⟨Θ, Δ, .path l r⟩ zones => do
    let zones' ← ListZone.invert id zones
    let Δ' ← List.pair_typ_invert id Δ
    return ⟨Θ, Δ', .pair l r⟩ :: zones'
| _ => failure



mutual

  inductive EitherMultiPolarity : List (Typ × Typ) → Typ → List String → Prop
  | nil cs t : EitherMultiPolarity cs t []
  | cons cs t b id ids :
    MultiPolarity id b cs →
    Polarity id b t →
    EitherMultiPolarity cs t ids →
    EitherMultiPolarity cs t (id :: ids)

  inductive MultiPolarity : String → Bool → List (Typ × Typ) → Prop
  | nil id b : MultiPolarity id b .nil
  | cons id b l r remainder :
    Polarity id (not b) l →
    Polarity id b r →
    MultiPolarity id b remainder →
    MultiPolarity id b (.cons (l,r) remainder)

  inductive Polarity : String → Bool → Typ → Prop
  | var id : Polarity id true (.var id)
  | varskip id b id' : id ≠ id' → Polarity id b (.var id')
  | entry id b l body : Polarity id b body →  Polarity id b (.entry l body)
  | path id b left right :
    Polarity id (not b) left →
    Polarity id b right →
    Polarity id b (.path left right)

  | bot id b:
    Polarity id b .bot

  | top id b :
    Polarity id b .top

  | unio id b left right :
    Polarity id b left →
    Polarity id b right →
    Polarity id b (.unio left right)
  | inter id b left right :
    Polarity id b left →
    Polarity id b right →
    Polarity id b (.inter left right)
  | diff id b left right :
    Polarity id b left →
    Polarity id (not b) right →
    Polarity id b (.diff left right)

  | all id b ids subtypings body :
    id ∉ ids →
    EitherMultiPolarity subtypings body ids →
    Polarity id b body →
    Polarity id b (.all ids subtypings body)

  | allskip id b ids subtypings body :
    id ∈ ids →
    Polarity id b (.all ids subtypings body)

  | exi id b ids subtypings body :
    id ∉ ids →
    EitherMultiPolarity subtypings (.diff .top body) ids →
    Polarity id b body →
    Polarity id b (.exi ids subtypings body)

  | exiskip id b ids subtypings body :
    id ∈ ids →
    Polarity id b (.exi ids subtypings body)


  | lfp id b id' body : id ≠ id' → Polarity id b body → Polarity id b (.lfp id' body)
  | lfpskip id b body : Polarity id b (.lfp id body)

end

-- TODO, could define as a structure or multi-And
inductive UpperFounded (id : String) : Typ → Typ → Prop
| intro quals id' cases t t' :
  List.pair_typ_bounds id .true quals = cases →
  List.length cases = List.length quals →
  Typ.combine .false cases = t →
  Polarity id' .true t →
  Typ.sub [(id', .var id)] t = t' →
  UpperFounded id (.exi [] quals (.var id')) (.unio (.var id') t')


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


def List.pair_typ_var_restricted (id : String) : List (Typ × Typ) → Bool
  | [] => .true
  | (l,r) :: remainder =>
    id ∉ (Typ.free_vars l) &&
    (r == (.var id) || id ∉ (Typ.free_vars r)) &&
    List.pair_typ_var_restricted id remainder

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
      let bs := List.pair_typ_bounds id .true qs
      List.pair_typ_var_restricted id qs &&
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



def List.pair_typ_partition (pids : List String) (Θ : List String)
: List (Typ × Typ) → List (Typ × Typ) × List (Typ × Typ)
| .nil => ([],[])
| .cons (l,r) remainder =>
    let (outer, inner) := List.pair_typ_partition pids Θ remainder
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
  let (outer, inner) := List.pair_typ_partition pids Θ Δ
  -- TODO: make sure exapmles work with the outer_ids
  let outer_ids := [] -- (List.pair_typ_free_vars Δ ∪ fids) ∩ Θ
  let inner_ids := List.diff (List.pair_typ_free_vars inner ∪ fids) (Θ ∪ pids)

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
  let bds := (List.pair_typ_bounds id b assums).eraseDups
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

def List.pair_typ_restricted (Θ : List String) (Δ : List (Typ × Typ))
: List (Typ × Typ) → Bool
| .nil => .true
| .cons (l,r) sts =>
  Subtyping.restricted Θ Δ l r &&
  List.pair_typ_restricted Θ Δ  sts

mutual
  def Subtyping.proj (id : String) (l : String) : (Typ × Typ) → Option (Typ × Typ)
  | (key,.var id') =>
    if id == id' then do
      let p ← Typ.proj id l key
      return (p, .var id)
    else
      failure
  | st => return st

  def List.pair_typ_proj (id : String) (l : String) : List (Typ × Typ) → Option (List (Typ × Typ))
  | .nil => return []
  | .cons st sts => do
    let st' ← Subtyping.proj id l st
    let sts' ← List.pair_typ_proj id l sts
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
      let quals' ← List.pair_typ_proj id l quals
      let body' ← Typ.proj id l body
      let ids' := ids ∩ (List.pair_typ_free_vars quals' ∪ Typ.free_vars body')
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

theorem lower_bound_map id (cs : List (Typ × Typ)) (t : Typ) : ∀ ts,
      List.pair_typ_bounds id .true cs = ts →
      (∀ t', (t', Typ.var id) ∈ cs → (t', t) ∈ ts.map (fun t' => (t', t)))
:= by induction cs with
| nil =>
  simp [List.pair_typ_bounds]
| cons head tail ih =>
  simp [List.pair_typ_bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  intro t' m
  cases m with
  | inl h =>
    simp [*, Typ.refl_BEq_true]
  | inr h =>
    cases (Typ.var id == upper) with
    | false =>
      apply ih
      assumption
    | true =>
      simp
      apply Or.inr
      apply ih
      assumption


theorem upper_bound_map id (cs : List (Typ × Typ)) (t : Typ) : ∀ ts,
  List.pair_typ_bounds id .false cs = ts →
  (∀ t', (Typ.var id, t') ∈ cs → (t, t') ∈ ts.map (fun t' => (t, t')))
:= by induction cs with
| nil =>
  simp [List.pair_typ_bounds]
| cons head tail ih =>
  simp [List.pair_typ_bounds, Subtyping.target_bound]
  let (lower,upper) := head
  simp_all
  intro t' m
  cases m with
  | inl h =>
    simp [*, Typ.refl_BEq_true]
  | inr h =>
    cases (Typ.var id == lower) with
    | false =>
      apply ih
      assumption
    | true =>
      simp
      apply Or.inr
      apply ih
      assumption

theorem skolem_lower_bound id (assums : List (Typ × Typ)) (skolems : List String) :
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


theorem skolem_upper_bound id (assums : List (Typ × Typ)) (skolems : List String) :
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
  List.pair_typ_bounds id .true cs = ts →
  t ∈ ts → (t, .var id) ∈ cs
:= by induction cs with
| nil =>
  simp [List.pair_typ_bounds]
| cons head tail ih =>
  simp [List.pair_typ_bounds, Subtyping.target_bound]
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
      exact Or.inl rfl
    | inr d =>
      apply ih at d
      rw [← b]
      exact (Or.intro_right (t = lower) d)
  | false =>
    simp
    intro h
    apply ih at h
    exact Or.inr h

theorem upper_bound_mem id cs t : ∀ ts,
  List.pair_typ_bounds id .false cs = ts →
  t ∈ ts → (.var id, t) ∈ cs
:= by induction cs with
| nil =>
  simp [List.pair_typ_bounds]
| cons head tail ih =>
  simp [List.pair_typ_bounds, Subtyping.target_bound]
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
      exact Or.inl rfl
    | inr d =>
      apply ih at d
      rw [← b]
      exact (Or.intro_right (t = upper) d)
  | false =>
    simp
    intro h
    apply ih at h
    exact Or.inr h

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
  inductive GuardedMultiSubtyping
  : List String → List (Typ × Typ) → List (Typ × Typ)
  → List String → List (Typ × Typ) → Prop
  | nil {skolems assums} : GuardedMultiSubtyping skolems assums [] skolems assums
  | cons {skolems assums skolems'' assums''} l r cs skolems' assums' :
    GuardedSubtyping skolems assums l r skolems' assums' →
    GuardedMultiSubtyping skolems' assums' cs skolems'' assums'' →
    GuardedMultiSubtyping skolems assums ((l,r) :: cs) skolems'' assums''


  /-
  -- NOTE: the guard on the right contains all skolems and constraints,
  -- while the skolems and constraints on the left are optional, non strictly necessary
  -- the necessary constraints/skolems represent the solution to solving the subtyping constraints
  -/
  inductive GuardedSubtyping
  : List String → List (Typ × Typ)
  → Typ → Typ
  → List String → List (Typ × Typ) → Prop
  | refl {skolems assums t} :
    GuardedSubtyping skolems assums t t skolems assums

  -- implication preservation
  | iso_pres {skolems assums skolems' assums' } l lower upper :
    GuardedSubtyping skolems assums lower upper skolems' assums' →
    GuardedSubtyping skolems assums (.iso l lower) (.iso l upper) skolems' assums'

  | entry_pres {skolems assums skolems' assums' } l lower upper :
    GuardedSubtyping skolems assums lower upper skolems' assums' →
    GuardedSubtyping skolems assums (.entry l lower) (.entry l upper) skolems' assums'

  | path_pres {skolems assums skolems'' assums''} p q x y  skolems' assums' :
    GuardedSubtyping skolems assums x p skolems' assums' →
    GuardedSubtyping skolems' assums' q y skolems'' assums'' →
    GuardedSubtyping skolems assums (.path p q) (.path x y) skolems'' assums''

  -- bottom elimination
  | bot_elim skolems assums t :
    GuardedSubtyping skolems assums .bot t skolems assums

  -- top introduction
  | top_intro skolems assums t :
    GuardedSubtyping skolems assums t .top skolems assums

  -- expansion elimination
  | unio_elim {skolems assums skolems'' assums''} left right t skolems' assums' :
    GuardedSubtyping skolems assums left t skolems' assums' →
    GuardedSubtyping skolems' assums' right t skolems'' assums'' →
    GuardedSubtyping skolems assums (.unio left right) t skolems'' assums''

  | exi_elim {skolems assums skolems'' assums''} ids quals body t skolems' assums' :
    List.pair_typ_restricted skolems assums quals →
    ids ∩ Typ.free_vars t = [] →
    -- NOTE: require quals to contain all bound variables so we can use it for freshness guarantees
    ids ⊆ List.pair_typ_free_vars quals →
    GuardedMultiSubtyping skolems assums quals skolems' assums' →
    GuardedSubtyping (ids ++ skolems') assums' body t skolems'' assums'' →
    GuardedSubtyping skolems assums (.exi ids quals body) t skolems'' assums''

  -- refinement introduction
  | inter_intro {skolems assums skolems'' assums''} t left right skolems' assums' :
    GuardedSubtyping skolems assums t left skolems' assums' →
    GuardedSubtyping skolems' assums' t right skolems'' assums'' →
    GuardedSubtyping skolems assums t (.inter left right) skolems'' assums''

  | all_intro {skolems assums skolems'' assums''} t ids quals body skolems' assums' :
    List.pair_typ_restricted skolems assums quals →
    ids ∩ Typ.free_vars t = [] →
    ids ⊆ List.pair_typ_free_vars quals →
    GuardedMultiSubtyping skolems assums quals skolems' assums' →
    GuardedSubtyping (ids ++ skolems') assums' t body skolems'' assums'' →
    GuardedSubtyping skolems assums t (.all ids quals body) skolems'' assums''

  -- placeholder elimination
  | placeholder_elim {skolems assums t skolems'} id cs assums' :
    id ∉ skolems →
    (∀ t', (t', .var id) ∈ assums → (t', t) ∈ cs) →
    GuardedMultiSubtyping skolems assums cs skolems' assums' →
    GuardedSubtyping skolems assums (.var id) t skolems' ((.var id, t) :: assums')

  -- placeholder introduction
  | placeholder_intro {skolems assums t skolems'} id cs assums' :
    id ∉ skolems →
    (∀ t', (.var id, t') ∈ assums → (t, t') ∈ cs) →
    GuardedMultiSubtyping skolems assums cs skolems' assums' →
    GuardedSubtyping skolems assums t (.var id) skolems' ((t, .var id) :: assums')

  -- skolem placeholder introduction
  | skolem_placeholder_intro {skolems assums t skolems'} id cs assums' :
    id ∈ skolems →
    (∃ id', (.var id', .var id) ∈ assums ∧ id' ∉ skolems) →
    (∀ t', (.var id, t') ∈ assums → (t, t') ∈ cs) →
    GuardedMultiSubtyping skolems assums cs skolems' assums' →
    GuardedSubtyping skolems assums t (.var id) skolems' ((t, .var id) :: assums')

  -- skolem introduction
  | skolem_intro {skolems assums t skolems' assums'} t' id :
    id ∈ skolems →
    (t', .var id) ∈ assums →
    (∀ id', (.var id') = t' → id' ∈ skolems) →
    GuardedSubtyping skolems assums t t' skolems' assums' →
    GuardedSubtyping skolems assums t (.var id) skolems' assums'

  -- skolem placeholder elimination
  | skolem_placeholder_elim {skolems assums t skolems'} id cs assums':
    id ∈ skolems →
    (∃ id', (.var id, .var id') ∈ assums ∧ id' ∉ skolems) →
    (∀ t', (t', .var id) ∈ assums → (t', t) ∈ cs) →
    GuardedMultiSubtyping skolems assums cs skolems' assums' →
    GuardedSubtyping skolems assums (.var id) t skolems' ((.var id, t) :: assums')

  -- skolem elimination
  | skolem_elim {skolems assums t skolems' assums'} t' id :
    id ∈ skolems →
    (.var id, t') ∈ assums →
    (∀ id', (.var id') = t → id' ∈ skolems) →
    GuardedSubtyping skolems assums t' t skolems' assums' →
    GuardedSubtyping skolems assums (.var id) t skolems' assums'

  | unio_antec {skolems assums l skolems'' assums''} a b upper assums' skolems' :
    GuardedSubtyping skolems assums l (.path a upper) skolems' assums' →
    GuardedSubtyping skolems' assums' l (.path b upper) skolems'' assums'' →
    GuardedSubtyping skolems assums l (.path (.unio a b) upper) skolems'' assums''

  | inter_conseq {skolems assums l skolems'' assums''} upper a b skolems' assums':
    GuardedSubtyping skolems assums l (.path upper a) skolems' assums' →
    GuardedSubtyping skolems' assums' l (.path upper b) skolems'' assums'' →
    GuardedSubtyping skolems assums l (.path upper (.inter a b)) skolems'' assums''

  | inter_entry {skolems assums t skolems'' assums''} l a b skolems' assums':
    GuardedSubtyping skolems assums t (.entry l a) skolems' assums' →
    GuardedSubtyping skolems' assums' t (.entry l b) skolems'' assums'' →
    GuardedSubtyping skolems assums t (.entry l (.inter a b)) skolems'' assums''

  -- least fixed point elimination
  | lfp_skip_elim {skolems assums right skolems' assums'} id body :
    id ∉ Typ.free_vars body →
    GuardedSubtyping skolems assums body right skolems' assums' →
    GuardedSubtyping skolems assums (.lfp id body) right skolems' assums'

  | lfp_induct_elim {skolems assums upper skolems' assums'} id lower :
    Polarity id .true lower →
    GuardedSubtyping skolems assums (Typ.sub [(id, upper)] lower) upper skolems' assums' →
    GuardedSubtyping skolems assums (.lfp id lower) upper skolems' assums'

  | lfp_factor_elim {skolems assums l skolems' assums'} id lower upper fac :
    Typ.factor id lower l = .some fac →
    GuardedSubtyping skolems assums fac upper skolems' assums' →
    GuardedSubtyping skolems assums (.lfp id lower) (.entry l upper) skolems' assums'

  | lfp_elim_diff_intro {skolems assums skolems' assums'} id lower upper sub h :
    -- TODO: check if is_pattern is subsumed by check
    Typ.is_pattern [] sub →
    -- TODO: struct_less_than might not be necessary
    Typ.struct_less_than (.var id) lower →
    Typ.height sub = .some h →
    Polarity id .true lower →
    GuardedSubtyping skolems assums (.lfp id lower) upper skolems' assums' →
    ¬ (Subtyping.check (Typ.subfold id lower 1) sub) →
    ¬ (Subtyping.check sub (Typ.subfold id lower h)) →
    GuardedSubtyping skolems assums (.lfp id lower) (.diff upper sub) skolems' assums'

  -- difference introduction
  | diff_intro {skolems assums lower skolems' assums'} upper sub:
    Typ.is_pattern [] sub →
    ¬ Subtyping.check lower sub →
    ¬ Subtyping.check sub lower →
    GuardedSubtyping skolems assums lower upper skolems' assums' →
    GuardedSubtyping skolems assums lower (.diff upper sub) skolems' assums'


  -- least fixed point introduction
  | lfp_peel_intro {skolems assums lower skolems' assums'} id body :
    -- TODO: peelable is a heuristic;
    -- it's not necessary for soundness
    -- consider merely using it in tactic
    Subtyping.peelable lower body →
    GuardedSubtyping skolems assums lower (.sub [(id, .lfp id body)] body) skolems' assums' →
    GuardedSubtyping skolems assums lower (.lfp id body) skolems' assums'

  | lfp_drop_intro {skolems assums lower skolems' assums'} id body :
    GuardedSubtyping skolems assums lower (Typ.drop id body) skolems' assums' →
    GuardedSubtyping skolems assums lower (.lfp id body) skolems' assums'

  -- difference elimination
  | diff_elim {skolems assums skolems' assums'} lower sub upper :
    GuardedSubtyping skolems assums lower (.unio sub upper) skolems' assums' →
    GuardedSubtyping skolems assums (.diff lower sub) upper skolems' assums'

  -- expansion introduction
  | unio_left_intro {skolems assums skolems' assums'} t l r:
    GuardedSubtyping skolems assums t l skolems' assums' →
    GuardedSubtyping skolems assums t (.unio l r) skolems' assums'

  | unio_right_intro {skolems assums skolems' assums'} t l r :
    GuardedSubtyping skolems assums t r skolems' assums' →
    GuardedSubtyping skolems assums t (.unio l r) skolems' assums'

  | exi_intro {skolems assums lower skolems'' assums''} ids quals upper skolems' assums' :
    GuardedSubtyping skolems assums lower upper skolems' assums' →
    GuardedMultiSubtyping skolems' assums' quals skolems'' assums'' →
    GuardedSubtyping skolems assums lower (.exi ids quals upper)  skolems'' assums''

  -- refinement elimination
  | inter_left_elim {skolems assums skolems' assums'} l r t :
    GuardedSubtyping skolems assums l t skolems' assums' →
    GuardedSubtyping skolems assums (.inter l r) t skolems' assums'

  | inter_right_elim {skolems assums skolems' assums'} l r t :
    GuardedSubtyping skolems assums r t skolems' assums' →
    GuardedSubtyping skolems assums (.inter l r) t skolems' assums'

  -- | inter_merge_elim skolems assums l r p q t skolems' assums' :
  --   Typ.merge_paths (.inter l r) = .some t →
  --   GuardedSubtyping skolems assums t (.path p q) skolems' assums' →
  --   GuardedSubtyping skolems assums (.inter l r) (.path p q) skolems' assums'

  | all_elim {skolems assums upper skolems'' assums''} ids quals lower skolems' assums' :
    GuardedSubtyping skolems assums lower upper skolems' assums' →
    GuardedMultiSubtyping skolems' assums' quals skolems'' assums'' →
    GuardedSubtyping skolems assums (.all ids quals lower) upper skolems'' assums''

end


mutual
  def List.pair_typ_polar_var (b : Bool) (id : String) : List (Typ × Typ) → Bool
  | [] => .false
  | (lower, upper) :: rest =>
    Typ.polar_var (not b) id lower || Typ.polar_var b id upper ||
    List.pair_typ_polar_var b id rest

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
      List.pair_typ_polar_var (not b) id quals ||
      Typ.polar_var b id body
    )
  | .exi ids quals body =>
    not (ids.contains id) && (
      List.pair_typ_polar_var b id quals ||
      Typ.polar_var b id body
    )
  | .lfp id' body =>
    id' != id && Typ.polar_var b id body
end

mutual
  def List.pair_typ_has_connection (ignore : List String) (b : Bool) (t : Typ)
  : List (Typ × Typ) → Bool
  | [] => .false
  | (lower, upper) :: rest =>
    Typ.has_connection ignore (not b) t lower || Typ.has_connection ignore b t upper ||
    List.pair_typ_has_connection ignore b t rest

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
      List.pair_typ_has_connection (ids ∪ ignore) (not b) t quals ||
      Typ.has_connection (ids ∪ ignore) b t body
  | .exi ids quals body =>
      List.pair_typ_has_connection (ids ∪ ignore) b t quals ||
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

  inductive ZoneInterp
  : List String → Bool → Zone → Zone → Prop
  | intro {ignore b} skolems assums t assums' t':
    TypInterp ignore skolems assums b t t' →
    Typ.transitive_connections [] assums b t' = assums' →
    ZoneInterp ignore b ⟨skolems,assums,t⟩ ⟨skolems, assums,t'⟩

  inductive TypInterp
  : List String → List String → List (Typ × Typ) → Bool → Typ → Typ → Prop
  | refl {ignore skolems assums b t} :
    TypInterp ignore skolems assums b t t

  | var {ignore skolems assums b t'} bds id t:
    id ∉ ignore →
    id ∉ skolems →
    (List.pair_typ_bounds id b assums).eraseDups = bds →
    bds ≠ [] →
    Typ.combine (not b) bds = t →
    t ≠ Typ.bot →
    t ≠ Typ.top →
    TypInterp ([id] ∪ ignore) skolems assums b t t' →
    TypInterp ignore skolems assums b (.var id) t'

  | iso {ignore skolems assums b} label body body' :
    TypInterp ignore skolems assums b body body' →
    TypInterp ignore skolems assums b (.iso label body) (.iso label body')

  | entry {ignore skolems assums b} label body body' :
    TypInterp ignore skolems assums b body body' →
    TypInterp ignore skolems assums b (.entry label body) (.entry label body')

  | inter {ignore skolems assums b} l l' r r'  :
    TypInterp ignore skolems assums b l l' →
    TypInterp ignore skolems assums b r r' →
    TypInterp ignore skolems assums b (.inter l r) (Typ.simp (Typ.inter l' r'))

  | unio {ignore skolems assums b} l l' r r'  :
    TypInterp ignore skolems assums b l l' →
    TypInterp ignore skolems assums b r r' →
    TypInterp ignore skolems assums b (.unio l r) (Typ.simp (Typ.unio l' r'))

  | path {ignore skolems assums b} antec antec' consq consq'  :
    TypInterp ignore skolems assums b antec antec' →
    TypInterp ((Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore)
      skolems assums b consq consq' →
    TypInterp ignore skolems assums b (Typ.path antec consq) (Typ.path antec' consq')

  | exi_all_positive {ignore skolems assums} ids_exi quals_exi quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        GuardedMultiSubtyping (ids_exi ∪ skolems) assums (quals_exi ∪ quals) skolems' assums' →
        ZoneInterp ignore .true ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        GuardedMultiSubtyping (ids_exi ∪ skolems) assums (quals_exi ∪ quals) skolems' assums')
    ) →

    TypInterp ignore skolems assums .true
      (.exi ids_exi quals_exi (.all _ quals body))
      (ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .true zones)


  | all_positive {ignore skolems assums} ids_exi quals body zones:
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        GuardedMultiSubtyping (ids_exi ∪ skolems) assums quals skolems' assums' →
        ZoneInterp ignore .true ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' , GuardedMultiSubtyping skolems assums quals skolems' assums')
    ) →

    TypInterp ignore skolems assums .true
      (.all _ quals body)
      (ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .true zones)

  | all_exi_negative {ignore skolems assums} ids_all quals_all quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        GuardedMultiSubtyping (ids_all ∪ skolems) assums (quals_all ∪ quals) skolems' assums' →
        ZoneInterp ignore .false ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        GuardedMultiSubtyping (ids_all ∪ skolems) assums (quals_all ∪ quals) skolems' assums')
    ) →

    TypInterp ignore skolems assums .false
      (.all ids_all quals_all (.exi _ quals body))
      (ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .false zones)

  | exi_negative {ignore skolems assums} quals body zones:

    -- TODO: replace List.removeAll with List.remove_all
    (∀ skolems'' assums'' body',
      ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩ ∈ zones →
      (∀ skolems' assums' ,
        GuardedMultiSubtyping skolems assums quals skolems' assums' →
        ZoneInterp ignore .false ⟨skolems', assums', body⟩ ⟨skolems', assums', body⟩
      )
    ) →

    (∀ skolems''' assums''' , ⟨skolems''', assums''', _⟩ ∈ zones →
      (∃ skolems'' , List.removeAll skolems'' skolems = skolems''') ∧
      (∃ assums'', List.removeAll assums'' assums = assums''') ∧
      (∃ skolems' assums' ,
        GuardedMultiSubtyping skolems assums quals skolems' assums')
    ) →

    TypInterp ignore skolems assums .false
      (.exi _ quals body)
      (ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .false zones)

end

def List.pair_typ_loop_split : List Typ → (List String) × (List Typ)
| [] => ([], [])
| (.var id) :: ts =>
    let (ids, ts') := List.pair_typ_loop_split ts
    (id :: ids, ts')
| t :: ts =>
    let (ids, ts') := List.pair_typ_loop_split ts
    (ids, t :: ts')

def List.to_option {α} : List α → Option α
| [] => .none
| x :: [] => .some x
| _ => .none

def List.pair_typ_remove_by_var (id : String)
: List (Typ × Typ) → List (Typ × Typ)
| [] => []
| (.var idl, .var idu) :: cs =>
  if idl == id || idu == id then
    List.pair_typ_remove_by_var id cs
  else
    (.var idl, .var idu) :: List.pair_typ_remove_by_var id cs
| (.var idl, upper) :: cs =>
  if idl == id  then
    List.pair_typ_remove_by_var id cs
  else
    (.var idl, upper) :: List.pair_typ_remove_by_var id cs

| (lower, .var idu) :: cs =>
  if idu == id then
    List.pair_typ_remove_by_var id cs
  else
    (lower, .var idu) :: List.pair_typ_remove_by_var id cs
| c :: cs =>
    c :: List.pair_typ_remove_by_var id cs


def List.pair_typ_loop_normal_form (id : String) (assums : List (Typ × Typ))
: Option (List (Typ × Typ)) :=
  let bds :=  List.pair_typ_bounds id .false assums
  let (ids, ts) := List.pair_typ_loop_split bds
  let all_are_paths := ts.all (fun t =>
    match t with
    | Typ.path _ _ => true
    | _ => true
  )
  if assums.isEmpty then
    Option.some []
  else if all_are_paths then
    match List.to_option ids with
    | some id => .some (List.pair_typ_remove_by_var id assums)
    | none => .none
  else
    Option.none



inductive LoopSubtyping : List String → String → List Zone → Typ → Prop
| batch {pids id zones} zones' t' left right :
  ListZone.invert id zones = .some zones' →
  ListZone.pack (id :: pids) .false zones' = t' →
  -- TODO; consider if monotonicity can be derived from invert and pack
  Polarity id .true t' →
  Typ.factor id t' "left" = .some left →
  Typ.factor id t' "right" = .some right →
  LoopSubtyping pids id zones (.path (.lfp id left) (.lfp id right))

| stream {pids id} skolems assums assums' idl r t' l r' l' r'' :
  id ≠ idl →
  idl ∉ List.pair_typ_free_vars assums →
  List.pair_typ_invert id assums = .some assums' →
  Zone.pack (id :: idl :: pids) .false ⟨skolems, assums', .pair (.var idl) r⟩ = t' →
  Polarity id .true t' →
  Typ.factor id t' "left" = .some l →
  Typ.factor id t' "right" = .some r' →
  Polarity idl .true (.lfp id r') →
  UpperFounded id l l' → -- TODO; this should imply Monotonic
  Typ.sub [(idl, .lfp id l')] (.lfp id r') = r'' →
  LoopSubtyping
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
        ZoneInterp [] .true
          ⟨skolems', assums'', (.path (ListTyp.diff tp subtras) tr)⟩ ⟨skolems'', assums''', t⟩ →
        GuardedTyping skolems assums' context' e tr skolems' assums''
    ) →

    (∀ skolems''' assums'''' t, ⟨skolems''', assums'''', t⟩ ∈ zones →
      ∃ skolems'' , List.removeAll skolems'' skolems = skolems''' ∧
      ∃ assums''' , List.removeAll assums''' assums = assums'''' ∧
      ∃ skolems' assums'' tr ,
        ZoneInterp [] .true
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
    GuardedTyping skolems assums context e body skolems' assums' →
    Record.Typing.Static skolems assums context
      ((l,e) :: []) (.entry l body) skolems' assums'

  | cons {skolems assums context  skolems'' assums''} l e r body t skolems' assums' :
    GuardedTyping skolems assums context e body skolems' assums' →
    Record.Typing.Static skolems' assums' context r t skolems'' assums'' →
    Record.Typing.Static skolems assums context
      ((l,e) :: r) (.inter (.entry l body) (t))
      skolems'' assums''

  inductive GuardedTyping :
    List String → List (Typ × Typ) → List (String × Typ) →
    Expr → Typ → List String → List (Typ × Typ) → Prop
  | var {t} skolems assums context x :
    find x context = .some t →
    GuardedTyping skolems assums context (.var x) t skolems assums

  | record {skolems assums context t} r :
    Record.Typing.Static skolems assums context r t skolems assums →
    GuardedTyping skolems assums context (.record r) t skolems assums

  | function {skolems assums context t} f nested_zones :
    Function.Typing.Static skolems assums context [] f nested_zones →
    ListZone.pack (List.pair_typ_free_vars assums) .true (nested_zones.flatten) = t →
    GuardedTyping skolems assums context (.function f) t skolems assums


  | app {skolems assums context skolems''' assums'''}
    ef ea id tf skolems' assums' ta skolems'' assums'' t:
    GuardedTyping skolems assums context ef tf skolems' assums' →
    GuardedTyping skolems' assums' context ea ta skolems'' assums'' →
    GuardedSubtyping skolems'' assums'' tf (.path ta (.var id)) skolems''' assums''' →
    TypInterp [] skolems''' assums''' .true (.var id) t →
    GuardedTyping skolems assums context (.app ef ea) t skolems''' assums'''

  | loop {skolems assums context t' skolems' assums'} e t id zones id_antec id_consq  :
    GuardedTyping skolems assums context e t skolems' assums' →
    (∀ skolems'''' assums''''' body', ⟨skolems'''', assums''''', body'⟩ ∈ zones →
      ∀ skolems''' , List.removeAll skolems''' skolems' = skolems'''' →
      ∀ assums'''' , List.removeAll assums'''' assums' = assums''''' →
      ∀ assums''' , List.pair_typ_loop_normal_form id assums''' = .some assums'''' →
      ∀ skolems'' assums'',
      ZoneInterp [id] .true
        ⟨skolems'', assums'', (Typ.path (.var id_antec) (.var id_consq))⟩
        ⟨skolems''', assums''', body'⟩ →
      GuardedSubtyping skolems' assums' t (.path (.var id)
        (Typ.path (.var id_antec) (.var id_consq)))
        skolems'' assums''
    ) →

    (∀ skolems'''' assums''''' body', ⟨skolems'''', assums''''', body'⟩ ∈ zones →
      ∃ skolems''' , List.removeAll skolems''' skolems' = skolems'''' ∧
      ∃ assums'''' , List.removeAll assums'''' assums' = assums''''' ∧
      ∃ assums''' , List.pair_typ_loop_normal_form id assums''' = .some assums'''' ∧
      ∃ skolems'' assums'',
      ZoneInterp [id] .true
        ⟨skolems'', assums'', (Typ.path (.var id_antec) (.var id_consq))⟩
        ⟨skolems''', assums''', body'⟩
    ) →
    LoopSubtyping (List.pair_typ_free_vars assums') id zones t' →
    id ∉ List.pair_typ_free_vars assums' →
    GuardedTyping skolems assums context (.loop e) t' skolems' assums'

  | anno {skolems assums context skolems'' assums''} e ta te skolems' assums' :
    Typ.free_vars ta ⊆ [] →
    GuardedTyping skolems assums context e te skolems' assums' →
    GuardedSubtyping skolems' assums' te ta skolems'' assums'' →
    GuardedTyping skolems assums context (.anno e ta) ta skolems'' assums''


end
