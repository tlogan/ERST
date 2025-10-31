import Lean
import Mathlib.Data.Set.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Algebra.Order.Ring.Defs
-- import data.nat.basic
-- import algebra.order.ring

set_option pp.fieldNotation false

#check List.any
-- The English word "any" does not hold quantification meaning; it is simply a predication of a collection.
-- the quantification of "any" can be inferred to me either all or exists dependeing on context and inflection.
def List.exi.{u} {α : Type u} (l : List α) (p : α → Bool) : Bool := List.any l p


inductive Typ
| var : String → Typ
| entry : String → Typ → Typ
| path : Typ → Typ → Typ
| bot :  Typ
| top :  Typ
| unio :  Typ → Typ → Typ
| inter :  Typ → Typ → Typ
| diff :  Typ → Typ → Typ
| all :  List String → List (Typ × Typ) → Typ → Typ
| exi :  List String → List (Typ × Typ) → Typ → Typ
| lfp :  String → Typ → Typ
deriving Lean.ToExpr




def ListSubtyping := List (Typ × Typ)

instance : Membership (Typ × Typ) ListSubtyping where
  mem (xs : List (Typ × Typ)) x := x ∈ xs


instance : Membership (Typ × Typ) ListSubtyping where
  mem (xs : List (Typ × Typ)) x := x ∈ xs

mutual
  instance ListSubtyping.decidable_eq : DecidableEq (List (Typ × Typ))
  | [], [] => isTrue rfl
  | l :: ls, [] => isFalse (by simp)
  | [], r :: rs => isFalse (by simp)
  | (al,bl) :: ls, (ar,br) :: rs =>
    match Typ.decidable_eq al ar, Typ.decidable_eq bl br, ListSubtyping.decidable_eq ls rs with
    | isTrue _, isTrue _, isTrue _ => isTrue (by simp [*])
    | isFalse _, _, _ => isFalse (by simp [*])
    | _, isFalse _, _ => isFalse (by simp [*])
    | _, _, isFalse _ => isFalse (by simp [*])


  instance Typ.decidable_eq : DecidableEq Typ :=
    fun left right => match left with
    | .var idl => by cases right with
      | var idr =>
        have d : Decidable (idl = idr) := inferInstance
        cases d with
        | isFalse => apply isFalse ; simp [*]
        | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .entry ll bodyl => by cases right with
      | entry lr bodyr =>
          have dl : Decidable (ll = lr) := inferInstance
          have dbody := Typ.decidable_eq bodyl bodyr
          cases dl with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases dbody with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .path al bl => by cases right with
      | path ar br =>
          have da := Typ.decidable_eq al ar
          have db := Typ.decidable_eq bl br
          cases da with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases db with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .bot => by cases right with
      | bot => apply isTrue ; rfl
      | _ => apply isFalse ; simp
    | .top => by cases right with
      | top => apply isTrue ; rfl
      | _ => apply isFalse ; simp
    | .unio al bl => by cases right with
      | unio ar br =>
          have da := Typ.decidable_eq al ar
          have db := Typ.decidable_eq bl br
          cases da with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases db with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp[*]
      | _ => apply isFalse ; simp
    | .inter al bl => by cases right with
      | inter ar br =>
          have da := Typ.decidable_eq al ar
          have db := Typ.decidable_eq bl br
          cases da with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases db with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .diff al bl => by cases right with
      | diff ar br =>
          have da := Typ.decidable_eq al ar
          have db := Typ.decidable_eq bl br
          cases da with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases db with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .all idsl qsl bodyl => by cases right with
      | all idsr qsr bodyr =>
        have dids : Decidable (idsl = idsr) := inferInstance
        have dqs := ListSubtyping.decidable_eq qsl qsr
        have dbody := Typ.decidable_eq bodyl bodyr
        cases dids with
        | isFalse => apply isFalse; simp [*]
        | isTrue =>
          cases dqs with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases dbody with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .exi idsl qsl bodyl => by cases right with
      | exi idsr qsr bodyr =>
        have dids : Decidable (idsl = idsr) := inferInstance
        have dqs := ListSubtyping.decidable_eq qsl qsr
        have dbody := Typ.decidable_eq bodyl bodyr
        cases dids with
        | isFalse => apply isFalse; simp [*]
        | isTrue =>
          cases dqs with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases dbody with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .lfp idl bodyl => by cases right with
      | lfp idr bodyr =>
          have did : Decidable (idl = idr) := inferInstance
          have dbody := Typ.decidable_eq bodyl bodyr
          cases did with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases dbody with
            | isFalse => apply isFalse; simp [*]
            | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
end


mutual
  def ListSubtyping.beq : List (Typ × Typ) → List (Typ × Typ) → Bool
  | .nil, .nil => .true
  | (a,b) :: l, (c,d) :: r =>
    Typ.beq a c &&
    Typ.beq b d &&
    ListSubtyping.beq l r
  | _, _ => .false

  def Typ.beq : Typ → Typ → Bool
  | .var idl, .var idr => idl == idr
  | .entry ll bodyl, .entry lr bodyr => ll == lr && Typ.beq bodyl bodyr
  | .path x y, .path p q => Typ.beq x p && Typ.beq y q
  | .bot, .bot => .true
  | .top, .top => .true
  | .unio a b, .unio c d => Typ.beq a c && Typ.beq b d
  | .inter a b, .inter c d => Typ.beq a c && Typ.beq b d
  | .diff a b, .diff c d => Typ.beq a c && Typ.beq b d
  | .all idsl qsl bodyl, .all idsr qsr bodyr =>
      idsl == idsr &&
      ListSubtyping.beq qsl qsr &&
      Typ.beq bodyl bodyr
  | .exi idsl qsl bodyl, .exi idsr qsr bodyr =>
      idsl == idsr &&
      ListSubtyping.beq qsl qsr &&
      Typ.beq bodyl bodyr
  | .lfp idl bodyl, .lfp idr bodyr =>
      idl == idr && Typ.beq bodyl bodyr
  | _, _ => false
end

instance : BEq (List (Typ × Typ)) where
  beq := ListSubtyping.beq

instance : BEq ListSubtyping where
  beq := ListSubtyping.beq

instance Typ.instanceBEq : BEq Typ where
  beq := Typ.beq


mutual
  theorem ListSubtyping.refl_beq_true : ∀ cs : ListSubtyping, ListSubtyping.beq cs cs = true
  | .nil => rfl
  | (lower,upper) :: cs' => by
    simp [ListSubtyping.beq]
    simp [Typ.refl_beq_true]
    apply ListSubtyping.refl_beq_true

  theorem Typ.refl_beq_true : ∀ t : Typ, Typ.beq t t = true
  | .var id => by
    unfold Typ.beq
    simp
  | .entry l body => by
    unfold Typ.beq
    simp
    apply Typ.refl_beq_true
  | .path x y => by
    unfold Typ.beq
    simp
    apply And.intro
    ·  apply Typ.refl_beq_true
    ·  apply Typ.refl_beq_true
  | .bot => by
    unfold Typ.beq
    simp
  | .top => by
    unfold Typ.beq
    simp
  | .unio a b => by
    unfold Typ.beq
    simp
    apply And.intro
    · apply Typ.refl_beq_true
    · apply Typ.refl_beq_true
  | .inter a b => by
    unfold Typ.beq
    simp
    apply And.intro
    · apply Typ.refl_beq_true
    · apply Typ.refl_beq_true
  | .diff a b => by
    unfold Typ.beq
    simp
    apply And.intro
    · apply Typ.refl_beq_true
    · apply Typ.refl_beq_true

  | .all ids qs body => by
    unfold Typ.beq
    simp
    apply And.intro
    · apply ListSubtyping.refl_beq_true
    · apply Typ.refl_beq_true

  | .exi ids qs body => by
    unfold Typ.beq
    simp
    apply And.intro
    · apply ListSubtyping.refl_beq_true
    · apply Typ.refl_beq_true

  | .lfp id body => by
    unfold Typ.beq
    simp
    apply Typ.refl_beq_true
end


mutual

  theorem ListSubtyping.beq_implies_eq : ∀ ls rs, ListSubtyping.beq ls rs = true → ls = rs
  | [], [] => by simp
  | l :: ls, [] => by
    simp [ListSubtyping.beq]
  | [], r :: rs => by
    simp [ListSubtyping.beq]
  | (al,bl) :: ls, (ar,br) :: rs => by
    simp [ListSubtyping.beq]
    intros uno dos tres
    apply Typ.beq_implies_eq at uno
    apply Typ.beq_implies_eq at dos
    apply ListSubtyping.beq_implies_eq at tres
    simp [*]

  -- TODO: use mututual recursion
  theorem Typ.beq_implies_eq : ∀ l r , (Typ.beq l r) = true → l = r :=
    fun left right => match left with
    | .var idl => by cases right with
      | var idr => unfold Typ.beq; simp
      | _ => unfold Typ.beq; simp
    | .entry ll bodyl => by cases right with
      | entry lr bodyr =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
    | .path al bl => by cases right with
      | path ar br =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at uno
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
    | .bot => by cases right with
      | bot => unfold Typ.beq; simp
      | _ => unfold Typ.beq; simp
    | .top => by cases right with
      | bot => unfold Typ.beq; simp
      | _ => unfold Typ.beq; simp
    | .unio al bl => by cases right with
      | unio ar br =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at uno
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
    | .inter al bl => by cases right with
      | inter ar br =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at uno
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
    | .diff al bl => by cases right with
      | diff ar br =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at uno
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
    | .all idsl qsl bodyl => by cases right with
      | all idsr qsr bodyr =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        intro tres
        apply ListSubtyping.beq_implies_eq at dos
        apply Typ.beq_implies_eq at tres
        simp [*]
      | _ => unfold Typ.beq; simp
    | .exi idsl qsl bodyl => by cases right with
      | exi idsr qsr bodyr =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        intro tres
        apply ListSubtyping.beq_implies_eq at dos
        apply Typ.beq_implies_eq at tres
        simp [*]
      | _ => unfold Typ.beq; simp
    | .lfp idl bodyl => by cases right with
      | lfp idr bodyr =>
        unfold Typ.beq; simp
        intro uno
        intro dos
        apply Typ.beq_implies_eq at dos
        simp [*]
      | _ => unfold Typ.beq; simp
end



theorem Typ.refl_BEq_true : ∀ t : Typ, (t == t) = true := by
  apply Typ.refl_beq_true

theorem Typ.eq_implies_BEq_true : ∀  l r : Typ, (l = r) → (l == r) = true := by
  simp [Typ.refl_BEq_true]


theorem Typ.BEq_true_implies_eq : ∀  l r : Typ, (l == r) = true → l = r := by
  apply Typ.beq_implies_eq

theorem Typ.neq_implies_BEq_false : ∀ l r : Typ, l ≠ r → (l == r) = false := by
  intros l r h
  contrapose h
  simp_all
  apply Typ.BEq_true_implies_eq
  assumption




open Std.Format

def String.has_whitespace (s : String) :=
  (s.contains ' ') ||
  s.contains '\t' ||
  s.contains '\n'

instance : Repr (List String) where
  reprPrec ids _ :=
    if ids.exi (fun id => id.has_whitespace) then
      repr ids
    else
      let rec loop ids := match ids with
        | [] => ""
        | id :: ids => id ++ line ++ (loop ids)
      group ("[ids|" ++ line ++ nest 2 (loop ids) ++ "]")

def append_line : List Std.Format → Std.Format
| .nil => ""
| x :: xs => x ++ line ++ append_line xs

def wrap (content : Std.Format) (p threshold : Nat) : Std.Format :=
    if p > threshold then
      "(" ++ content ++ ")"
    else
      content



#print Fin


def Typ.is_pair : Typ → Bool
| .inter (.entry "left" _) (.entry "right" _) => .true
| .inter (.entry "right" _) (.entry "left" _) => .true
| _ => .false

def Typ.pair (left right : Typ) := Typ.inter (.entry "left" left) (.entry "right" right)

#check List.map
#eval (String.intercalate (" ") ["a", "b"])
mutual
  partial def ListSubtyping.repr : ListSubtyping → Std.Format
  | [] => ""
  | (l,r) :: [] =>
      group (
        "(" ++ (Typ.reprPrec l 0) ++ " <: " ++ (Typ.reprPrec r 0) ++ ")"
      )
  | (l,r) :: remainder =>
      group (
        "(" ++ (Typ.reprPrec l 0) ++ " <: " ++ (Typ.reprPrec r 0) ++ ")"
        ++ line ++
        ListSubtyping.repr remainder
      )


  partial def Typ.reprPrec : Typ → Nat → Std.Format
  | .var id, _ => id
  | .entry l .top, _  => "<" ++ l ++ "/>"
  | .entry l body, _  =>
    "<" ++ l ++ ">"  ++ line ++ nest 2 (Typ.reprPrec body 90)
  | .path left right, p =>
    let content := Typ.reprPrec left 51 ++ " ->" ++ line ++ Typ.reprPrec right 50
    group (wrap content p 50)
  | .bot, _  => "BOT"
  | .top, _  => "TOP"
  | .unio left right, p =>
    let content := Typ.reprPrec left 61 ++ " |" ++ line ++ Typ.reprPrec right 60
    group (wrap content p 60)
  | .inter left right, p =>
    match left, right with
    | (.entry "left" l), (.entry "right" r) =>
      let content := Typ.reprPrec l 91 ++ " *" ++ line ++ Typ.reprPrec r 90
      group (wrap content p 90)
    | (.entry "right" r), (.entry "left" l) =>
      let content := Typ.reprPrec l 91 ++ " *" ++ line ++ Typ.reprPrec r 90
      group (wrap content p 90)
    | _, _ =>
      let content := Typ.reprPrec left 81 ++ " &" ++ line ++ Typ.reprPrec right 80
      group (wrap content p 80)
  | .diff left right, _ =>
    let content := Typ.reprPrec left 0 ++ " \\" ++ line ++ Typ.reprPrec right 0
    group content
  | .all ids subtypings body, _ =>
    if subtypings.isEmpty then
      group (
        "ALL[" ++ String.intercalate " " ids ++ "]" ++ line ++ nest 2 (Typ.reprPrec body 0)
      )
    else
      group (
        "ALL[" ++ String.intercalate " " ids ++ "]" ++ line ++
          nest 2 (ListSubtyping.repr subtypings) ++
          "[" ++ line ++ nest 2 (ListSubtyping.repr subtypings) ++ line ++ "]" ++ line ++
          nest 2 (Typ.reprPrec body 0)
      )
  | .exi ids subtypings body, _ =>
    if subtypings.isEmpty then
      group (
        "EXI[" ++ String.intercalate " " ids ++ "]" ++ line ++ nest 2 (Typ.reprPrec body 0)
      )
    else
      group (
        "EXI[" ++ String.intercalate " " ids ++ "]" ++ line ++
          "[" ++ line ++ nest 2 (ListSubtyping.repr subtypings) ++ line ++ "]" ++ line ++
          nest 2 (Typ.reprPrec body 0)
      )
  | .lfp id body, _ =>
    group (
      "LFP[" ++ id ++ "]" ++ line ++
        nest 2 (Typ.reprPrec body 0)
    )
end

instance : Repr ListSubtyping where
  reprPrec cs _ := group ("[subtypings|" ++ line ++ nest 2 (ListSubtyping.repr cs) ++ " ]")

instance : Repr Typ where
  reprPrec t n := group ("[typ|" ++ line ++ nest 2 (Typ.reprPrec t n) ++ " ]")

def ListTyp := List Typ
def ListTyp.repr : ListTyp → Std.Format
| .nil => ""
| t :: [] =>
    group (
      "(" ++ (Typ.reprPrec t 0) ++ ")"
    )
| t :: remainder =>
    group (
      "(" ++ (Typ.reprPrec t 0) ++ ")"
      ++ line ++
      ListTyp.repr remainder
    )

instance : Repr ListTyp where
  reprPrec t _ := group ("[typs|" ++ line ++ nest 2 (ListTyp.repr t) ++ " ]")

def ListTyping := List (String × Typ)

def ListTyping.repr : ListTyping → Std.Format
| .nil => ""
| (x,t) :: [] =>
    group (
      "(" ++ x ++ " : " ++ (Typ.reprPrec t 0) ++ ")"
    )
| (x,t) :: remainder =>
    group (
      "(" ++ x ++ " : " ++ (Typ.reprPrec t 0) ++ ")"
      ++ line ++
      ListTyping.repr remainder
    )

instance : Repr ListTyping where
  reprPrec t _ := group ("[typings|" ++ line ++ nest 2 (ListTyping.repr t) ++ " ]")


instance : BEq (Typ × Typ) where
  -- beq a b := a.fst == b.fst && a.snd == b.snd
  beq | (a,b), (c,d) => a == c && b == d


inductive Typ.Bruijn
| bvar : Nat → Typ.Bruijn
| fvar : String → Typ.Bruijn
| entry : String → Typ.Bruijn → Typ.Bruijn
| path : Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| bot : Typ.Bruijn
| top : Typ.Bruijn
| unio :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| inter :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| diff :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| all :  Nat → List (Typ.Bruijn × Typ.Bruijn) → Typ.Bruijn → Typ.Bruijn
| exi :  Nat → List (Typ.Bruijn × Typ.Bruijn) → Typ.Bruijn → Typ.Bruijn
| lfp :  Typ.Bruijn → Typ.Bruijn
deriving Repr

mutual
  def ListSubtyping.Bruijn.beq
  : List (Typ.Bruijn × Typ.Bruijn) → List (Typ.Bruijn × Typ.Bruijn)
  → Bool
  | .nil, .nil => .true
  | (a,b) :: l, (c,d) :: r =>
    Typ.Bruijn.beq a c &&
    Typ.Bruijn.beq b d &&
    ListSubtyping.Bruijn.beq l r
  | _, _ => .false

  def Typ.Bruijn.beq : Typ.Bruijn → Typ.Bruijn → Bool
  | .bvar il, .bvar ir => il == ir
  | .fvar idl, .fvar idr => idl == idr
  | .entry ll bodyl, .entry lr bodyr => ll == lr && Typ.Bruijn.beq bodyl bodyr
  | .path x y, .path p q => Typ.Bruijn.beq x p && Typ.Bruijn.beq y q
  | .top, .top => .true
  | .bot, .bot => .true
  | .unio a b, .unio c d => Typ.Bruijn.beq a c && Typ.Bruijn.beq b d
  | .inter a b, .inter c d => Typ.Bruijn.beq a c && Typ.Bruijn.beq b d
  | .diff a b, .diff c d => Typ.Bruijn.beq a c && Typ.Bruijn.beq b d
  | .all idsl qsl bodyl, .all idsr qsr bodyr =>
      idsl == idsr &&
      ListSubtyping.Bruijn.beq qsl qsr &&
      Typ.Bruijn.beq bodyl bodyr
  | .exi idsl qsl bodyl, .exi idsr qsr bodyr =>
      idsl == idsr &&
      ListSubtyping.Bruijn.beq qsl qsr &&
      Typ.Bruijn.beq bodyl bodyr
  | .lfp bodyl, .lfp bodyr =>
      Typ.Bruijn.beq bodyl bodyr
  | _, _ => false
end

instance : BEq Typ.Bruijn where
  beq := Typ.Bruijn.beq


def List.firstIndexOf {α} [BEq α] (target : α) (l : List α) : Option Nat :=
  let ns := List.indexesOf target l
  if h : List.length ns > 0 then
      let i : Fin (List.length ns) := {
        val := 0,
        isLt := by simp [h]
      }
      .some (List.get ns i)
  else
    .none

def List.merase {α} [BEq α] (x : α) : List α → List α
| .nil => .nil
| .cons y ys =>
  if x == y then
    (List.merase x ys)
  else
    y :: (List.merase x ys)

def List.mdiff {α} [BEq α] (xs : List α) : List α → List α
| .nil => xs
| .cons y ys =>
  List.mdiff (List.merase y xs) ys

#eval List.merase 3 [1,2,3,3]
#eval List.mdiff [1,2, 3] [2]



mutual
  def Typ.ordered_bound_vars (bounds : List String) : Typ → List String
  | .var id =>
    if id ∈ bounds then [id] else []
  | .entry _ t =>
    Typ.ordered_bound_vars bounds t
  | .path left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.mdiff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .bot => []
  | .top => []
  | .unio left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.mdiff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .inter left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.mdiff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .diff left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.mdiff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .all ids subtypings body =>
    let bounds' := List.mdiff bounds ids
    let a := ListPairTyp.ordered_bound_vars bounds' subtypings
    let b := List.mdiff (Typ.ordered_bound_vars bounds' body) a
    a ∪ b
  | .exi ids subtypings body =>
    let bounds' := List.mdiff bounds ids
    let a := ListPairTyp.ordered_bound_vars bounds' subtypings
    let b := List.mdiff (Typ.ordered_bound_vars bounds' body) a
    a ∪ b
  | .lfp id body =>
    let bounds' := List.mdiff bounds [id]
    Typ.ordered_bound_vars bounds' body

  def ListPairTyp.ordered_bound_vars (bounds : List String)
  : ListSubtyping → List String
  | .nil => .nil
  | .cons (l,r) remainder =>
    let a := (Typ.ordered_bound_vars bounds l)
    let b := List.mdiff (Typ.ordered_bound_vars bounds r) a
    let c := List.mdiff (ListPairTyp.ordered_bound_vars bounds remainder) (a ∪ b)
    a ∪ b ∪ c
end

#eval List.mdiff [1,2,3] [1]

mutual
  def ListSubtyping.free_vars : ListSubtyping → List String
  | .nil => []
  | .cons (l,r) remainder =>
    Typ.free_vars l ∪ Typ.free_vars r ∪ ListSubtyping.free_vars remainder

  def Typ.free_vars : Typ → List String
  | .var id => [id]
  | .entry _ body => Typ.free_vars body
  | .path p q => Typ.free_vars p ∪ Typ.free_vars q
  | .bot => []
  | .top => []
  | .unio l r => Typ.free_vars l ∪ Typ.free_vars r
  | .inter l r => Typ.free_vars l ∪ Typ.free_vars r
  | .diff l r => Typ.free_vars l ∪ Typ.free_vars r
  | .all ids subtypings body =>
    List.mdiff (
      ListSubtyping.free_vars subtypings ∪ Typ.free_vars body
    ) ids
  | .exi ids subtypings body =>
    List.mdiff (
      ListSubtyping.free_vars subtypings ∪ Typ.free_vars body
    ) ids
  | .lfp id body =>
    List.mdiff (Typ.free_vars body) [id]
end


def ListTyping.free_vars : List (String × Typ) → List String
| [] => []
| (_,t) :: ts => Typ.free_vars t ∪ ListTyping.free_vars ts

inductive Token
| num : Nat → Token
| str : String → Token
deriving BEq


def List.toBruijn (bids : List String) : List String → List Token
| .nil => .nil
| .cons x xs =>
    match List.firstIndexOf x bids with
    | .none => (Token.str x) :: List.toBruijn bids xs
    | .some n => Token.num (bids.length + n) :: List.toBruijn bids xs

mutual
  def ListSubtyping.toBruijn (bids : List String)
  : ListSubtyping → List (Typ.Bruijn × Typ.Bruijn)
  | .nil => .nil
  | .cons (l,r) remainder =>
    .cons
    (Typ.toBruijn bids l, Typ.toBruijn bids r)
    (ListSubtyping.toBruijn bids remainder)

  def Typ.toBruijn (bids : List String) : Typ → Typ.Bruijn
  | .var id =>
    match List.firstIndexOf id bids with
    | .none => .fvar id
    | .some i => .bvar (bids.length + i)
  | .entry l body => .entry l (Typ.toBruijn bids body)
  | .path left right =>
    .path
    (Typ.toBruijn bids left)
    (Typ.toBruijn bids right)
  | .bot => .bot
  | .top => .top
  | .unio left right =>
    .unio
    (Typ.toBruijn bids left)
    (Typ.toBruijn bids right)
  | .inter left right =>
    .inter
    (Typ.toBruijn bids left)
    (Typ.toBruijn bids right)
  | .diff left right =>
    .diff
    (Typ.toBruijn bids left)
    (Typ.toBruijn bids right)
  | .all ids subtypings body =>
    let bids' := ListPairTyp.ordered_bound_vars ids (.cons (.bot,body) subtypings)
    let n := (List.length bids')
    (.all n
      (ListSubtyping.toBruijn (bids' ++ bids) subtypings)
      (Typ.toBruijn (bids' ++ bids) body)
    )
  | .exi ids subtypings body =>
    let bids' := ListPairTyp.ordered_bound_vars ids (.cons (.bot,body) subtypings)
    let n := (List.length bids')
    (.exi n
      (ListSubtyping.toBruijn (bids' ++ bids) subtypings)
      (Typ.toBruijn (bids' ++ bids) body)
    )
  | .lfp id body =>
    .lfp
    (Typ.toBruijn (id :: bids) body)
end

mutual

  def ListSubtyping.size : ListSubtyping → Nat
  | .nil => 1
  | .cons (l,r) rest =>  Typ.size l + Typ.size r + ListSubtyping.size rest

  def Typ.size : Typ → Nat
  | .var id => 1
  | .entry l body => Typ.size body + 1
  | .path left right => Typ.size left + Typ.size right + 1
  | .bot => 1
  | .top => 1
  | .unio left right => Typ.size left + Typ.size right + 1
  | .inter left right => Typ.size left + Typ.size right + 1
  | .diff left right => Typ.size left + Typ.size right + 1
  | .all ids subtypings body => ListSubtyping.size subtypings + Typ.size body + 1
  | .exi ids subtypings body => ListSubtyping.size subtypings + Typ.size body + 1
  | .lfp id body => (Typ.size body) * 600 + 1
end

theorem Typ.zero_lt_size {t : Typ} : 0 < Typ.size t := by
cases t <;> simp [Typ.size]

theorem ListPairTyp.zero_lt_size {cs} : 0 < ListSubtyping.size cs := by
cases cs <;> simp [ListSubtyping.size, Typ.zero_lt_size]


def ListPair.dom {α} {β} : List (α × β) → List α
| .nil => .nil
| (a, _) :: xs => a :: dom xs


def remove {α} (id : String) : List (String × α) →  List (String × α)
| .nil => .nil
| (key, e) :: m =>
  if key == id then
    m
  else
    (key, e) :: (remove id m)

def remove_all {α} (m : List (String × α)) : (ids : List String) →  List (String × α)
| .nil => m
| id :: remainder => remove_all (remove id m) remainder

def find {α} (id : String) : List (String × α) → Option α
| .nil => none
| (key, e) :: m =>
  if key == id then
    some e
  else
    find id m

mutual

  def ListSubtyping.sub (δ : List (String × Typ)) : ListSubtyping → ListSubtyping
  | .nil => .nil
  | .cons (l,r) remainder => .cons (Typ.sub δ l, Typ.sub δ r) (ListSubtyping.sub δ remainder)

  def Typ.sub (δ : List (String × Typ)) : Typ → Typ
  | .var id => match find id δ with
    | .none => .var id
    | .some t => t
  | .entry l body => .entry l (Typ.sub δ body)
  | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
  | .bot => .bot
  | .top => .top
  | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
  | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
  | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
  | .all ids subtypings body =>
      let δ' := remove_all δ ids
      .all ids (ListSubtyping.sub δ' subtypings) (Typ.sub δ' body)
  | .exi ids subtypings body =>
      let δ' := remove_all δ ids
      .exi ids (ListSubtyping.sub δ' subtypings) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end



def Typ.subfold (id : String) (t : Typ) : Nat → Typ
| 0 => .exi ["T"] .nil (.var "T")
| n + 1 => Typ.sub [(id, Typ.subfold id t n)] t

inductive Pat
| var : String → Pat
| record : List (String × Pat) → Pat
deriving Repr

mutual
  def ListPat.free_vars : List (String × Pat) → List String
  | .nil => []
  | .cons (l,p) remainder =>
    Pat.free_vars p ∪ ListPat.free_vars remainder

  def Pat.free_vars : Pat → List String
  | .var id => [id]
  | .record ps => ListPat.free_vars ps
end

inductive Expr
| var : String → Expr
| record : List (String × Expr) → Expr
| function : List (Pat × Expr) → Expr
| app : Expr → Expr → Expr
-- | anno : String → Typ → Expr → Expr → Expr
| anno : Expr → Typ → Expr
| loop : Expr → Expr
deriving Repr

def Expr.pair (left : Expr) (right : Expr) : Expr :=
    .record [("left", left), ("right", right)]

def Expr.is_pair : Expr → Bool
| .record [( "left", _), ("right", _)] => .true
| .record [( "right", _), ("left", _)] => .true
| _ => .false

mutual
  def Expr.Record.is_value : List (String × Expr) → Bool
  | .nil => .true
  | .cons (l,e) r =>  Expr.is_value e && Expr.Record.is_value r

  def Expr.is_value : Expr → Bool
  | .record r => Expr.Record.is_value r
  | .function _ => .true
  | _ => .false
end


def Expr.proj (e : Expr) (l : String) : Expr :=
  .app (.function [(.record [(l, .var "x")], .var "x")]) e

def Expr.def (id : String) (top : Option Typ) (target : Expr) (contin : Expr) : Expr :=
  Expr.app
    (Expr.function [
      (
        Pat.var id, match top with
        | .some t => .anno contin t
        | .none => contin
      )
    ])
    (target)

declare_syntax_cat ids
-- declare_syntax_cat box_ids
declare_syntax_cat subtypings
-- declare_syntax_cat box_subtypings
declare_syntax_cat typings
-- declare_syntax_cat box_typings
declare_syntax_cat typ

declare_syntax_cat typs
-- declare_syntax_cat box_typs

declare_syntax_cat frame
declare_syntax_cat pat
declare_syntax_cat record
declare_syntax_cat function
declare_syntax_cat expr


syntax:20 ident : ids
syntax:20 ident ids : ids

-- syntax "[" "]" : box_ids
-- syntax "[" ids "]" : box_ids

syntax "(" typ "<:" typ ")" : subtypings
syntax "(" typ "<:" typ ")" subtypings : subtypings

-- syntax "[" "]" : box_subtypings
-- syntax "[" subtypings "]" : box_subtypings

syntax "(" ident ":" typ ")" : typings
syntax "(" ident ":" typ ")" typings : typings

-- syntax "[" "]" : box_typings
-- syntax "[" typings "]" : box_typings

syntax ident : typ
syntax:50 typ:51 "->" typ:50 : typ
syntax:60 typ:61 "|" typ:60 : typ
syntax:80 typ:81 "&" typ:80 : typ
syntax:90 typ:91 "*" typ:90 : typ

syntax "<" ident ">" typ:90 : typ
syntax "<" ident "/>" : typ
-- syntax "@" : typ
syntax typ "\\" typ : typ
syntax "ALL" "[" ids "]" "[" subtypings "]" typ : typ
syntax "EXI" "[" ids "]" "[" subtypings "]" typ : typ
syntax "ALL" "[" ids "]" typ : typ
syntax "EXI" "[" ids "]" typ : typ
syntax "ALL" "[" "]" "[" subtypings "]" typ : typ
syntax "EXI" "[" "]" "[" subtypings "]" typ : typ
syntax "LFP" "[" ident "]" typ : typ
syntax "BOT" : typ
syntax "TOP" : typ
syntax "(" typ ")" : typ

syntax typ : typs
syntax typ typs : typs

-- syntax "[" "]" : box_typs
-- syntax "[" typs "]" : box_typs



syntax "<" ident "/>" : frame
syntax "<" ident "/>" frame : frame
syntax "<" ident ">" pat : frame
syntax "<" ident ">" pat frame : frame

syntax:20 ident : pat
syntax "@" : pat
syntax frame : pat
syntax ident ";" pat : pat


syntax "<" ident "/>" : record
syntax "<" ident "/>" record : record
syntax "<" ident ">" expr : record
syntax "<" ident ">" expr record : record

syntax "[" pat "=>" expr "]" : function
syntax "[" pat "=>" expr "]" function : function

syntax:20 ident : expr
syntax "@" : expr
syntax record : expr
syntax ident ";" expr : expr
syntax:60 expr:61 "," expr:60 : expr
syntax function : expr
syntax:70 expr:70 "." ident : expr
syntax:80 expr:80 "(" expr ")" : expr
syntax "def" ident ":" typ "=" expr "in" expr : expr
syntax "def" ident "=" expr "in" expr : expr
syntax "loop" "(" expr ")" : expr
syntax "(" expr ")" : expr
syntax  expr "as" typ : expr


syntax "[eid|" ident "]" : term
syntax "[id|" ident "]" : term

syntax "[ids|" "]": term
syntax "[ids|" ids "]": term
-- syntax "[box_ids|" box_ids "]": term


-- syntax "[subtyping|" typ "<:" typ "]" : term

syntax "[subtypings|" "]" : term
syntax "[subtypings|" subtypings "]" : term
-- syntax "[box_subtypings|" box_subtypings "]" : term

syntax "[typings|" "]" : term
syntax "[typings|" typings "]": term
-- syntax "[box_typings|" box_typings "]": term


syntax "[typ|" typ "]" : term

syntax "[typs|" "]" : term
syntax "[typs|" typs "]" : term

-- syntax "[box_typs|" "[""]" "]" : term
-- syntax "[box_typs|" "[" typs "]" "]" : term

syntax "[frame|" frame "]" : term
syntax "[pattern|" pat "]" : term
syntax "[record|" record "]" : term
syntax "[function|" function "]" : term
syntax "[expr|" expr "]" : term




elab_rules : term
  | `([id| $i:ident ])  => do
    let idStr := toString i.getId
    if idStr.contains '.' then
      Lean.Elab.throwUnsupportedSyntax
    return (Lean.mkStrLit idStr)

partial def buildSyntaxFromDotted (parts : List Lean.Ident)
: Lean.Elab.TermElabM (Lean.TSyntax `term) :=
  match parts with
  | [] => Lean.Elab.throwUnsupportedSyntax
  | [x] => `(Expr.var [id| $x])
  | x :: xs => do
    let ys ← buildSyntaxFromDotted xs
    `(Expr.app
        (Expr.function [
          (Pat.record [
            ([id| $x], Pat.var "x")
          ], Expr.var "x")
        ])
        $ys
    )

elab_rules : term
  | `([eid| $i:ident ])  => do
    let name := i.getId
    let parts := name.components.map Lean.mkIdent
    let s ← buildSyntaxFromDotted parts.reverse
    Lean.Elab.Term.elabTerm s none


syntax "{" term "}"  : ids

macro_rules
| `([ids| ]) => `([])
| `([ids| $i:ident ]) => `([id| $i] :: [])
| `([ids| $i:ident $ps:ids ]) => `([id| $i] :: [ids| $ps])

| `([ids| { $t:term } ]) => pure t

-- | `([box_ids| [] ]) => `([])
-- | `([box_ids| [ $ps:ids ] ]) => `([ids| $ps])

-- macro_rules
-- | `([subtyping| $x:typ <: $y:typ ]) =>
--   `(([typ| $x],[typ| $y]))

macro_rules
| `([subtypings| ]) => `([])
| `([subtypings| ( $x:typ <: $y:typ ) ]) =>
  `(([typ| $x],[typ| $y]) :: [])
| `([subtypings| ( $x:typ <: $y:typ ) $qs:subtypings ]) =>
  `(([typ| $x],[typ| $y]) :: [subtypings| $qs])
-- | `([box_subtypings| [] ]) => `([])
-- | `([box_subtypings| [ $qs:subtypings ] ]) => `([subtypings| $qs])



macro_rules
| `([typings| ]) => `([])
| `([typings| ( $x:ident : $y:typ ) ]) =>
  `(([id| $x], [typ| $y]):: [])
| `([typings| ( $x:ident : $y:typ ) $ts:typings ]) =>
  `(([id| $x], [typ| $y]):: [typings| $ts])

-- | `([box_typings| [] ]) => `([])
-- | `([box_typings| [ $ts:typings] ]) => `([ [typings| $ts]])


syntax "{" term "}"  : typ


macro_rules
| `([typ| $i:ident ]) => `(Typ.var [id| $i])
| `([typ| < $i:ident /> ]) => `(Typ.entry [id| $i] .top)
| `([typ| < $i:ident > $t:typ  ]) => `(Typ.entry [id| $i] [typ| $t])
| `([typ| $x:typ -> $y:typ ]) => `(Typ.path [typ| $x] [typ| $y])
| `([typ| $x:typ | $y:typ ]) => `(Typ.unio [typ| $x] [typ| $y])
| `([typ| $x:typ & $y:typ ]) => `(Typ.inter [typ| $x] [typ| $y])
| `([typ| $x:typ * $y:typ ]) => `(Typ.pair [typ| $x] [typ| $y])
| `([typ| $x:typ \ $y:typ ]) => `(Typ.diff [typ| $x] [typ| $y])
| `([typ| ALL [ $ps:ids ] [ $qs:subtypings ] $t:typ ]) =>
  `(Typ.all [ids| $ps] [subtypings| $qs] [typ| $t])
| `([typ| EXI [ $ps:ids ] [ $qs:subtypings ] $t:typ ]) =>
  `(Typ.exi [ids| $ps] [subtypings| $qs] [typ| $t])
| `([typ| ALL [ $ps:ids ] $t:typ ]) => `(Typ.all [ids| $ps] [] [typ| $t])
| `([typ| EXI [ $ps:ids ] $t:typ ]) => `(Typ.exi [ids| $ps] [] [typ| $t])

| `([typ| ALL [ ] [ $qs:subtypings ] $t:typ ]) =>
  `(Typ.all [] [subtypings| $qs] [typ| $t])
| `([typ| EXI [  ] [ $qs:subtypings ] $t:typ ]) =>
  `(Typ.exi [] [subtypings| $qs] [typ| $t])

| `([typ| LFP [ $i:ident ] $t:typ ]) => `(Typ.lfp [id| $i] [typ| $t])
| `([typ| BOT ]) => `(Typ.bot)
| `([typ| TOP ]) => `(Typ.top)
| `([typ| ( $t:typ ) ]) => `([typ| $t])
| `([typ| { $t:term } ]) => pure t


macro_rules
| `([typs| ]) => `([])
| `([typs| $y:typ ]) =>
  `([typ| $y]::[])
| `([typs| $y:typ $ts:typs ]) =>
  `([typ| $y] :: [typs| $ts])

-- | `([box_typs| [] ]) => `([])
-- | `([box_typs| [ $ts:typs] ]) => `([ [typs| $ts]])



macro_rules
| `([frame| <$i:ident/> ]) => `(([id| $i], [pattern| @]) :: [])
| `([frame| <$i:ident/> $pr:frame ]) => `(([id| $i], [pattern| @]) :: [frame| $pr])
| `([frame| <$i:ident> $p:pat ]) => `(([id| $i], [pattern| $p]) :: [])
| `([frame| <$i:ident> $p:pat $pr:frame ]) => `(([id| $i], [pattern| $p]) :: [frame| $pr])

macro_rules
| `([pattern| $i:ident ]) => `(Pat.var [id| $i])
| `([pattern| @ ]) => `(Pat.record [])
| `([pattern| $pr:frame ]) => `(Pat.record [frame| $pr])
| `([pattern| $i:ident ; $p:pat ]) => `(Pat.record ([id| $i], [pattern| $p]) :: [])

macro_rules
| `([record| <$i:ident/> ]) => `(([id| $i], [expr| @]) :: [])
| `([record| <$i:ident/> $er:record ]) => `(([id| $i], [expr| @]) :: [record| $er])
| `([record| <$i:ident> $e:expr ]) => `(([id| $i], [expr| $e]) :: [])
| `([record| <$i:ident> $e:expr $er:record ]) => `(([id| $i], [expr| $e]) :: [record| $er])

macro_rules
| `([function| [ $p:pat => $e:expr ] ]) => `(([pattern| $p], [expr| $e]) :: [])
| `([function| [ $p:pat => $e:expr ] $f:function ]) =>
  `(([pattern| $p], [expr| $e]) :: [function| $f])



macro_rules
| `([expr| @ ]) => `(Expr.record [])
| `([expr| $i:ident ]) => `([eid| $i])
| `([expr| $er:record ]) => `(Expr.record [record| $er])
| `([expr| $i:ident ; $e:expr ]) => `(Expr.record [([id| $i], [expr| $e])])
| `([expr| $l:expr , $r:expr ]) => `(Expr.pair [expr| $l] [expr| $r])
| `([expr| $f:function ]) => `(Expr.function [function| $f])
| `([expr| $e:expr . $i:ident ]) => `(Expr.proj [expr| $e] [id| $i])
| `([expr| $f:expr ( $a:expr ) ]) => `(Expr.app [expr| $f] [expr| $a])
| `([expr| $e:expr as $t:typ ]) => `(Expr.anno [expr| $e] [typ| $t])
| `([expr| def $i:ident : $t:typ = $a:expr in $c:expr  ]) =>
  `(Expr.def [id| $i] (.some [typ| $t]) [expr| $a] [expr| $c])
| `([expr| def $i:ident = $a:expr in $c:expr  ]) =>
  `(Expr.def [id| $i] .none [expr| $a] [expr| $c])
| `([expr| loop ( $e:expr ) ]) => `(Expr.loop [expr| $e])
| `([expr| ( $e:expr ) ]) => `([expr| $e])






class RecordPatternOf (_ : List (String × Expr)) where
  default : List (String × Pat)

class PatternOf (_ : Expr) where
  default : Pat

instance (id : String) : PatternOf (Expr.var id) where
  default := Pat.var id

instance (entries : List (String × Expr)) [d : RecordPatternOf entries]
: PatternOf (Expr.record entries) where
  default := Pat.record d.default


instance : RecordPatternOf [] where
  default := []

instance
  (label : String) (result : Expr) [pd : PatternOf result]
  (remainder : List (String × Expr)) [rpd : RecordPatternOf remainder]
: RecordPatternOf ((label, result) :: remainder) where
  default := (label, pd.default) :: rpd.default


instance (e : Expr) [p : PatternOf e] : CoeDep Expr e Pat where
  coe := p.default


mutual
  def Pat.toRecordExpr : List (String × Pat) → List (String × Expr)
  | .nil => .nil
  | (l, p) :: r => (l, toExpr p) :: (toRecordExpr r)

  def Pat.toExpr : Pat → Expr
  | .var id => .var id
  | .record r => .record (toRecordExpr r)
end

instance : Coe Pat Expr where
  coe := Pat.toExpr


def Typ.capture (t : Typ) : Typ :=
    let ids := Typ.free_vars t
    if List.isEmpty ids then
      t
    else
      .exi ids .nil t

def Typ.do_diff : Typ → Typ → Typ

| (.entry l body), (.entry l_subtra body_subtra) =>
  if l != l_subtra then
    (.entry l body)
  else
    (.entry l (Typ.do_diff body body_subtra))

| (.entry l body), (.exi _ [] (.entry l_subtra body_subtra)) =>
  if l != l_subtra then
    (.entry l body)
  else
    (.entry l (Typ.do_diff body body_subtra))

| t, subtra => .diff t subtra

theorem Typ.diff_drop {l body t l_sub body_sub} :
  l ≠ l_sub →
  (.entry l body) = t →
  (.entry l body) = Typ.do_diff t (Typ.capture (Typ.entry l_sub body_sub))
:= by sorry

def ListTyp.diff (t : Typ) : List Typ → Typ
| .nil => t
| .cons x xs => ListTyp.diff (Typ.do_diff t (Typ.capture x)) xs


#eval (Typ.free_vars [typ| X * <uno/>]).map (fun typ => (typ, Typ.top)) -- .map(fun typ => (typ, .top))


@[reducible]
def Typ.enrich : Typ → Typ
| .all ids cs t =>
  .all ids ((List.map (fun id => (Typ.var id, Typ.top)) (Typ.free_vars t ∩ ids)) ∪ cs) t
| .exi ids cs t =>
  .exi ids ((List.map (fun id => (Typ.var id, Typ.top)) (Typ.free_vars t ∩ ids)) ∪ cs) t
| t => t


#eval [typ| <uno/>]
