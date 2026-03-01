import Lean

import Lang.List.Basic
import Lang.String.Basic

set_option pp.fieldNotation false
namespace Lang
open Std.Format


inductive Typ
| bvar : Nat → Typ
| var : String → Typ
| iso : String → Typ → Typ
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



-- , Ord

-- <uno> thing <dos> thing
-- {uno} thing  or {dos}thing
-- [uno] thing  or [dos] hing or [tres/]
-- uno: @  ::dos hing or [tres/]


-- instance : Membership (Typ × Typ) (List (Typ × Typ)) where
--   mem (xs : List (Typ × Typ)) x := x ∈ xs


mutual
  instance List.pair_typ_decidable_eq : DecidableEq (List (Typ × Typ))
  | [], [] => isTrue rfl
  | l :: ls, [] => isFalse (by simp)
  | [], r :: rs => isFalse (by simp)
  | (al,bl) :: ls, (ar,br) :: rs =>
    match Typ.decidable_eq al ar, Typ.decidable_eq bl br, List.pair_typ_decidable_eq ls rs with
    | isTrue _, isTrue _, isTrue _ => isTrue (by simp [*])
    | isFalse _, _, _ => isFalse (by simp [*])
    | _, isFalse _, _ => isFalse (by simp [*])
    | _, _, isFalse _ => isFalse (by simp [*])


  instance Typ.decidable_eq : DecidableEq Typ :=
    fun left right => match left with
    | .bvar idl => by cases right with
      | bvar idr =>
        have d : Decidable (idl = idr) := inferInstance
        cases d with
        | isFalse => apply isFalse ; simp [*]
        | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .var idl => by cases right with
      | var idr =>
        have d : Decidable (idl = idr) := inferInstance
        cases d with
        | isFalse => apply isFalse ; simp [*]
        | isTrue => apply isTrue; simp [*]
      | _ => apply isFalse ; simp
    | .iso ll bodyl => by cases right with
      | iso lr bodyr =>
          have dl : Decidable (ll = lr) := inferInstance
          have dbody := Typ.decidable_eq bodyl bodyr
          cases dl with
          | isFalse => apply isFalse; simp [*]
          | isTrue =>
            cases dbody with
            | isFalse => apply isFalse; simp [*]
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
        have dqs := List.pair_typ_decidable_eq qsl qsr
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
        have dqs := List.pair_typ_decidable_eq qsl qsr
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

-- mutual
--   def List.pair_typ_beq : List (Typ × Typ) → List (Typ × Typ) → Bool
--   | .nil, .nil => .true
--   | (a,b) :: l, (c,d) :: r =>
--     Typ.beq a c &&
--     Typ.beq b d &&
--     List.pair_typ_beq l r
--   | _, _ => .false

--   def Typ.beq : Typ → Typ → Bool
--   | .bvar il, .bvar ir => il == ir
--   | .var idl, .var idr => idl == idr
--   | .iso ll bodyl, .iso lr bodyr => ll == lr && Typ.beq bodyl bodyr
--   | .entry ll bodyl, .entry lr bodyr => ll == lr && Typ.beq bodyl bodyr
--   | .path x y, .path p q => Typ.beq x p && Typ.beq y q
--   | .bot, .bot => .true
--   | .top, .top => .true
--   | .unio a b, .unio c d => Typ.beq a c && Typ.beq b d
--   | .inter a b, .inter c d => Typ.beq a c && Typ.beq b d
--   | .diff a b, .diff c d => Typ.beq a c && Typ.beq b d
--   | .all idsl qsl bodyl, .all idsr qsr bodyr =>
--     idsl == idsr &&
--     List.pair_typ_beq qsl qsr &&
--     Typ.beq bodyl bodyr
--   | .exi idsl qsl bodyl, .exi idsr qsr bodyr =>
--     idsl == idsr &&
--     List.pair_typ_beq qsl qsr &&
--     Typ.beq bodyl bodyr
--   | .lfp idl bodyl, .lfp idr bodyr =>
--     idl == idr && Typ.beq bodyl bodyr
--   | _, _ => false
-- end

-- instance : BEq (List (Typ × Typ)) where
--   beq := List.pair_typ_beq

-- instance Typ.instanceBEq : BEq Typ where
--   beq := Typ.beq


-- mutual
--   theorem List.pair_typ_refl_beq_true : ∀ cs : List (Typ × Typ), List.pair_typ_beq cs cs = true
--   | .nil => rfl
--   | (lower,upper) :: cs' => by
--     simp [List.pair_typ_beq]
--     simp [Typ.refl_beq_true]
--     apply List.pair_typ_refl_beq_true

--   theorem Typ.refl_beq_true : ∀ t : Typ, Typ.beq t t = true
--   | .bvar i => by
--     unfold Typ.beq
--     simp
--   | .var id => by
--     unfold Typ.beq
--     simp
--   | .iso l body => by
--     unfold Typ.beq
--     simp
--     apply Typ.refl_beq_true
--   | .entry l body => by
--     unfold Typ.beq
--     simp
--     apply Typ.refl_beq_true
--   | .path x y => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     ·  apply Typ.refl_beq_true
--     ·  apply Typ.refl_beq_true
--   | .bot => by
--     unfold Typ.beq
--     simp
--   | .top => by
--     unfold Typ.beq
--     simp
--   | .unio a b => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     · apply Typ.refl_beq_true
--     · apply Typ.refl_beq_true
--   | .inter a b => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     · apply Typ.refl_beq_true
--     · apply Typ.refl_beq_true
--   | .diff a b => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     · apply Typ.refl_beq_true
--     · apply Typ.refl_beq_true

--   | .all ids qs body => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     · apply List.pair_typ_refl_beq_true
--     · apply Typ.refl_beq_true

--   | .exi ids qs body => by
--     unfold Typ.beq
--     simp
--     apply And.intro
--     · apply List.pair_typ_refl_beq_true
--     · apply Typ.refl_beq_true

--   | .lfp id body => by
--     unfold Typ.beq
--     simp
--     apply Typ.refl_beq_true
-- end


-- mutual

--   theorem List.pair_typ_beq_implies_eq : ∀ ls rs, List.pair_typ_beq ls rs = true → ls = rs
--   | [], [] => by simp
--   | l :: ls, [] => by
--     simp [List.pair_typ_beq]
--   | [], r :: rs => by
--     simp [List.pair_typ_beq]
--   | (al,bl) :: ls, (ar,br) :: rs => by
--     simp [List.pair_typ_beq]
--     intros uno dos tres
--     apply Typ.beq_implies_eq at uno
--     apply Typ.beq_implies_eq at dos
--     apply List.pair_typ_beq_implies_eq at tres
--     simp [*]

--   -- TODO: use mututual recursion
--   theorem Typ.beq_implies_eq : ∀ l r , (Typ.beq l r) = true → l = r :=
--     fun left right => match left with
--     | .bvar idl => by cases right with
--       | bvar idr => unfold Typ.beq; simp
--       | _ => unfold Typ.beq; simp
--     | .var idl => by cases right with
--       | var idr => unfold Typ.beq; simp
--       | _ => unfold Typ.beq; simp
--     | .iso ll bodyl => by cases right with
--       | iso lr bodyr =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .entry ll bodyl => by cases right with
--       | entry lr bodyr =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .path al bl => by cases right with
--       | path ar br =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at uno
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .bot => by cases right with
--       | bot => unfold Typ.beq; simp
--       | _ => unfold Typ.beq; simp
--     | .top => by cases right with
--       | bot => unfold Typ.beq; simp
--       | _ => unfold Typ.beq; simp
--     | .unio al bl => by cases right with
--       | unio ar br =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at uno
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .inter al bl => by cases right with
--       | inter ar br =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at uno
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .diff al bl => by cases right with
--       | diff ar br =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at uno
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .all idsl qsl bodyl => by cases right with
--       | all idsr qsr bodyr =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         intro tres
--         apply List.pair_typ_beq_implies_eq at dos
--         apply Typ.beq_implies_eq at tres
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .exi idsl qsl bodyl => by cases right with
--       | exi idsr qsr bodyr =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         intro tres
--         apply List.pair_typ_beq_implies_eq at dos
--         apply Typ.beq_implies_eq at tres
--         simp [*]
--       | _ => unfold Typ.beq; simp
--     | .lfp idl bodyl => by cases right with
--       | lfp idr bodyr =>
--         unfold Typ.beq; simp
--         intro uno
--         intro dos
--         apply Typ.beq_implies_eq at dos
--         simp [*]
--       | _ => unfold Typ.beq; simp
-- end



-- theorem Typ.refl_BEq_true : ∀ t : Typ, (t == t) = true := by
--   apply Typ.refl_beq_true

-- theorem Typ.eq_implies_BEq_true : ∀  l r : Typ, (l = r) → (l == r) = true := by
--   simp [Typ.refl_BEq_true]


-- theorem Typ.BEq_true_implies_eq : ∀  l r : Typ, (l == r) = true → l = r := by
--   apply Typ.beq_implies_eq

-- theorem Typ.neq_implies_BEq_false : ∀ l r : Typ, l ≠ r → (l == r) = false := by
--   intros l r h
--   contrapose h
--   simp_all
--   apply Typ.BEq_true_implies_eq
--   assumption


def Typ.is_pair : Typ → Bool
| .inter (.entry "left" _) (.entry "right" _) => .true
| .inter (.entry "right" _) (.entry "left" _) => .true
| _ => .false

def Typ.pair (left right : Typ) := Typ.inter (.entry "left" left) (.entry "right" right)

#check List.map
#eval (String.intercalate (" ") ["a", "b"])
mutual
  partial def List.pair_typ_repr : List (Typ × Typ) → Std.Format
  | [] => ""
  | (l,r) :: [] =>
      group (
        "(" ++ (Typ.reprPrec l 0) ++ " <: " ++ (Typ.reprPrec r 0) ++ ")"
      )
  | (l,r) :: remainder =>
      group (
        "(" ++ (Typ.reprPrec l 0) ++ " <: " ++ (Typ.reprPrec r 0) ++ ")"
        ++ line ++
        List.pair_typ_repr remainder
      )


  partial def Typ.reprPrec : Typ → Nat → Std.Format
  | .bvar i, _ => s!"_{i}"
  | .var id, _ => id
  | .iso l .top, _ =>
    "<" ++ l ++ "/>"
  | .iso l body, _ =>
    "<" ++ l ++ ">"  ++ line ++ nest 2 (Typ.reprPrec body 100)
  | .entry l body, _ =>
    l ++ " :"  ++ line ++ nest 2 (Typ.reprPrec body 100)
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
  | .all ids constraints body, p =>
    let content := (
      if constraints.isEmpty then
        group (
          "ALL[" ++ String.intercalate " " ids ++ "]" ++ line ++ nest 2 (Typ.reprPrec body 0)
        )
      else
        group (
          "ALL[" ++ String.intercalate " " ids ++ "]" ++ line ++
            "[" ++ line ++ nest 2 (List.pair_typ_repr constraints) ++ line ++ "]" ++ line ++
            nest 2 (Typ.reprPrec body 0)
        )
    )
    group (wrap content p 40)
  | .exi ids constraints body, p =>
    let content := (
      if constraints.isEmpty then
        group (
          "EXI[" ++ String.intercalate " " ids ++ "]" ++ line ++ nest 2 (Typ.reprPrec body 0)
        )
      else
        group (
          "EXI[" ++ String.intercalate " " ids ++ "]" ++ line ++
            "[" ++ line ++ nest 2 (List.pair_typ_repr constraints) ++ line ++ "]" ++ line ++
            nest 2 (Typ.reprPrec body 0)
        )
    )
    group (wrap content p 40)
  | .lfp id body, _ =>
    group (
      "(" ++
      "LFP[" ++ id ++ "]" ++ line ++
        nest 2 (Typ.reprPrec body 0) ++
      ")"
    )
end

instance : Repr (List (Typ × Typ)) where
  reprPrec cs _ := group ("[constraints|" ++ line ++ nest 2 (List.pair_typ_repr cs) ++ " ]")

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
  beq | (a,b),(c,d) => a == c && b == d

-- def List.merase {α} [BEq α] (x : α) : List α → List α
-- | .nil => .nil
-- | .cons y ys =>
--   if x == y then
--     (List.merase x ys)
--   else
--     y :: (List.merase x ys)

-- -- TODO: replace with List.removeAll
-- def List.removeAll {α} [BEq α] (xs : List α) : List α → List α
-- | .nil => xs
-- | .cons y ys =>
--   List.removeAll (List.merase y xs) ys

-- #eval List.merase 3 [1,2,3,3]
-- #eval List.removeAll [1,2, 3] [2]



-- mutual
--   def Typ.ordered_bound_vars (bounds : List String) : Typ → List String
--   | .bvar _ => []
--   | .var id =>
--     if id ∈ bounds then [id] else []
--   | .iso _ t =>
--     Typ.ordered_bound_vars bounds t
--   | .entry _ t =>
--     Typ.ordered_bound_vars bounds t
--   | .path left right =>
--     let a := Typ.ordered_bound_vars bounds left
--     let b := List.removeAll (Typ.ordered_bound_vars bounds right) a
--     a ∪ b
--   | .bot => []
--   | .top => []
--   | .unio left right =>
--     let a := Typ.ordered_bound_vars bounds left
--     let b := List.removeAll (Typ.ordered_bound_vars bounds right) a
--     a ∪ b
--   | .inter left right =>
--     let a := Typ.ordered_bound_vars bounds left
--     let b := List.removeAll (Typ.ordered_bound_vars bounds right) a
--     a ∪ b
--   | .diff left right =>
--     let a := Typ.ordered_bound_vars bounds left
--     let b := List.removeAll (Typ.ordered_bound_vars bounds right) a
--     a ∪ b
--   | .all ids constraints body =>
--     let bounds' := List.removeAll bounds ids
--     let a := List.pair_typ_ordered_bound_vars bounds' constraints
--     let b := List.removeAll (Typ.ordered_bound_vars bounds' body) a
--     a ∪ b
--   | .exi ids constraints body =>
--     let bounds' := List.removeAll bounds ids
--     let a := List.pair_typ_ordered_bound_vars bounds' constraints
--     let b := List.removeAll (Typ.ordered_bound_vars bounds' body) a
--     a ∪ b
--   | .lfp id body =>
--     let bounds' := List.removeAll bounds [id]
--     Typ.ordered_bound_vars bounds' body

--   def List.pair_typ_ordered_bound_vars (bounds : List String)
--   : (List (Typ × Typ)) → List String
--   | .nil => .nil
--   | .cons (l,r) remainder =>
--     let a := (Typ.ordered_bound_vars bounds l)
--     let b := List.removeAll (Typ.ordered_bound_vars bounds r) a
--     let c := List.removeAll (List.pair_typ_ordered_bound_vars bounds remainder) (a ∪ b)
--     a ∪ b ∪ c
-- end

#eval List.removeAll [1,2,3] [1]

mutual
  def Typ.list_prod_free_vars : List (Typ × Typ) → List String
  | [] => []
  | (left,right) :: ps =>
    Typ.free_vars left ∪ Typ.free_vars right ∪ Typ.list_prod_free_vars ps

  def Typ.free_vars : Typ → List String
  | .bvar _ => []
  | .var id => [id]
  | .iso _ body => Typ.free_vars body
  | .entry _ body => Typ.free_vars body
  | .path p q => Typ.free_vars p ∪ Typ.free_vars q
  | .bot => []
  | .top => []
  | .unio l r => Typ.free_vars l ∪ Typ.free_vars r
  | .inter l r => Typ.free_vars l ∪ Typ.free_vars r
  | .diff l r => Typ.free_vars l ∪ Typ.free_vars r
  | .all bs constraints body =>
    /- NOTE: ignore content of bs; bound variable names have no semantics after seal -/
    Typ.list_prod_free_vars constraints ∪ Typ.free_vars body
  | .exi bs constraints body =>
    /- NOTE: ignore content of bs; bound variable names have no semantics after seal -/
    Typ.list_prod_free_vars constraints ∪ Typ.free_vars body
  | .lfp b body =>
    /- NOTE: ignore content of bs; bound variable names have no semantics after seal -/
    Typ.free_vars body
end


def ListTyping.free_vars : List (String × Typ) → List String
| [] => []
| (_,t) :: ts => Typ.free_vars t ∪ ListTyping.free_vars ts

-- inductive Token
-- | num : Nat → Token
-- | str : String → Token
-- deriving BEq


-- def List.toBruijn (bids : List String) : List String → List Token
-- | .nil => .nil
-- | .cons x xs =>
--     match List.firstIndexOf x bids with
--     | .none => (Token.str x) :: List.toBruijn bids xs
--     | .some n => Token.num (bids.length + n) :: List.toBruijn bids xs

mutual
  def Typ.constraints_seal (names : List String)
  : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder =>
    .cons
    (Typ.seal names l, Typ.seal names r)
    (Typ.constraints_seal names remainder)

  def Typ.seal (names : List String) : Typ → Typ
  | .bvar i => .bvar i
  | .var x =>
    match List.firstIndexOf x names with
    | .some i => .bvar i
    | .none => .var x
  | .iso l body => .iso l (Typ.seal names body)
  | .entry l body => .entry l (Typ.seal names body)
  | .path left right =>
    .path
    (Typ.seal names left)
    (Typ.seal names right)
  | .bot => .bot
  | .top => .top
  | .unio left right =>
    .unio
    (Typ.seal names left)
    (Typ.seal names right)
  | .inter left right =>
    .inter
    (Typ.seal names left)
    (Typ.seal names right)
  | .diff left right =>
    .diff
    (Typ.seal names left)
    (Typ.seal names right)
  | .all names' constraints body =>
    (.all (List.map (fun _ => "") names')
      (Typ.constraints_seal (names' ++ names) constraints)
      (Typ.seal (names' ++ names) body)
    )
  | .exi names' constraints body =>
    (.exi (List.map (fun _ => "") names')
      (Typ.constraints_seal (names' ++ names) constraints)
      (Typ.seal (names' ++ names) body)
    )
  | .lfp id body =>
    .lfp "" (Typ.seal (id :: names) body)
end


mutual
  def Typ.constraints_shift_vars (threshold : Nat) (offset : Nat)
  : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder =>
    .cons
    (Typ.shift_vars threshold offset l, Typ.shift_vars threshold offset r)
    (Typ.constraints_shift_vars threshold offset remainder)

  def Typ.shift_vars (threshold : Nat) (offset : Nat) : Typ → Typ
  | .bvar i =>
    if i >= threshold then
      (.bvar (i + offset))
    else
      (.bvar i)
  | .var x => .var x
  | .iso l body => .iso l (Typ.shift_vars threshold offset body)
  | .entry l body => .entry l (Typ.shift_vars threshold offset body)
  | .path left right =>
    .path
    (Typ.shift_vars threshold offset left)
    (Typ.shift_vars threshold offset right)
  | .bot => .bot
  | .top => .top
  | .unio left right =>
    .unio
    (Typ.shift_vars threshold offset left)
    (Typ.shift_vars threshold offset right)
  | .inter left right =>
    .inter
    (Typ.shift_vars threshold offset left)
    (Typ.shift_vars threshold offset right)
  | .diff left right =>
    .diff
    (Typ.shift_vars threshold offset left)
    (Typ.shift_vars threshold offset right)
  | .all bindings constraints body =>
    let threshold' := threshold + List.length bindings
    (.all bindings
      (Typ.constraints_shift_vars threshold' offset constraints)
      (Typ.shift_vars threshold' offset body)
    )
  | .exi bindings constraints body =>
    let threshold' := threshold + List.length bindings
    (.exi bindings
      (Typ.constraints_shift_vars threshold' offset constraints)
      (Typ.shift_vars threshold' offset body)
    )
  | .lfp a body =>
    .lfp a (Typ.shift_vars (threshold + 1) offset body)
end



def Typ.list_shift_vars (threshold : Nat) (offset : Nat) : List Typ → List Typ
| .nil => .nil
| e :: es =>
  Typ.shift_vars threshold offset e :: (Typ.list_shift_vars threshold offset es)



mutual
  theorem Typ.shift_vars_zero level t :
    Typ.shift_vars level 0 t = t
  := by sorry
end


mutual
  def Typ.constraints_instantiate (depth : Nat) (m : List Typ)
  : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | .cons (l,r) remainder =>
    .cons
    (Typ.instantiate depth m l, Typ.instantiate depth m r)
    (Typ.constraints_instantiate depth m remainder)

  def Typ.instantiate (depth : Nat) (m : List Typ) : Typ → Typ
  | .bvar i =>
    if i >= depth then
      match m[i - depth]? with
      | some e => Typ.shift_vars 0 depth e
      | none => .bvar (i - List.length m)
    else
      .bvar i
  | .var x => .var x
  | .iso l body => .iso l (Typ.instantiate depth m body)
  | .entry l body => .entry l (Typ.instantiate depth m body)
  | .path left right =>
    .path
    (Typ.instantiate depth m left)
    (Typ.instantiate depth m right)
  | .bot => .bot
  | .top => .top
  | .unio left right =>
    .unio
    (Typ.instantiate depth m left)
    (Typ.instantiate depth m right)
  | .inter left right =>
    .inter
    (Typ.instantiate depth m left)
    (Typ.instantiate depth m right)
  | .diff left right =>
    .diff
    (Typ.instantiate depth m left)
    (Typ.instantiate depth m right)
  | .all bindings constraints body =>
    let depth' := depth + List.length bindings
    (.all bindings
      (Typ.constraints_instantiate depth' m constraints)
      (Typ.instantiate depth' m body)
    )
  | .exi bindings constraints body =>
    let depth' := depth + List.length bindings
    (.exi bindings
      (Typ.constraints_instantiate depth' m constraints)
      (Typ.instantiate depth' m body)
    )
  | .lfp a body =>
    .lfp a (Typ.instantiate (depth + 1) m body)
end

def Typ.list_instantiate (depth : Nat) (m : List Typ) : List Typ → List Typ
| .nil => .nil
| t :: ts =>
  Typ.instantiate depth (m : List Typ) t :: (Typ.list_instantiate depth (m : List Typ) ts)




-- mutual
--   def List.record_instantiate (depth : Nat) (m : List Expr): List (String × Expr) → List (String × Expr)
--   | .nil => .nil
--   | (l, e) :: r =>
--     (l, Expr.instantiate depth m e) :: (List.record_instantiate depth m r)

--   def List.function_instantiate (depth : Nat) (m : List Expr): List (Pat × Expr) → List (Pat × Expr)
--   | .nil => .nil
--   | (p, e) :: f =>
--     let depth' := depth + (Pat.count_vars p)
--     (p, (Expr.instantiate depth' m e)) :: (List.function_instantiate depth m f)

--   def Expr.instantiate (depth : Nat) (m : List Expr) : Expr → Expr
--   | .bvar i =>
--     if i >= depth then
--       match m[i - depth]? with
--       | some e => Expr.shift_vars 0 depth e
--       | none => .bvar (i - List.length m)
--     else
--       .bvar i
--   | .fvar id => .fvar id
--   | .iso l body => .iso l (Expr.instantiate depth m body)
--   | .record r => .record (List.record_instantiate depth m r)
--   | .function f => .function (List.function_instantiate depth m f)
--   | .app ef ea => .app (Expr.instantiate depth m ef) (Expr.instantiate depth m ea)
--   | .anno e t => .anno (Expr.instantiate depth m e) t
--   | .loopi e => .loopi (Expr.instantiate depth m e)
-- end





mutual

  def List.pair_typ_size : List (Typ × Typ) → Nat
  | .nil => 1
  | .cons (l,r) rest =>  Typ.size l + Typ.size r + List.pair_typ_size rest

  def Typ.size : Typ → Nat
  | .bvar i => 1
  | .var id => 1
  | .iso l body => Typ.size body + 1
  | .entry l body => Typ.size body + 1
  | .path left right => Typ.size left + Typ.size right + 1
  | .bot => 1
  | .top => 1
  | .unio left right => Typ.size left + Typ.size right + 1
  | .inter left right => Typ.size left + Typ.size right + 1
  | .diff left right => Typ.size left + Typ.size right + 1
  | .all ids constraints body => List.pair_typ_size constraints + Typ.size body + 1
  | .exi ids constraints body => List.pair_typ_size constraints + Typ.size body + 1
  | .lfp id body => (Typ.size body) + 1
end

def ListTyp.size : List Typ → Nat
| [] => 1
| t :: ts => Typ.size t + ListTyp.size ts



mutual
  theorem Typ.constraints_size_instantiate constraints :
    (∀ e ∈ m, Typ.size e = 1) →
    List.pair_typ_size (Typ.constraints_instantiate depth m constraints) =
    List.pair_typ_size constraints
  := by sorry

  theorem Typ.size_instantiate t :
    (∀ e ∈ m, Typ.size e = 1) →
    Typ.size (Typ.instantiate depth m t) =
    Typ.size t
  := by sorry
end


theorem Typ.mem_map_var_size (f : α → String) :
  e ∈ List.map (fun x => Typ.var (f x)) am →
  Typ.size e = 1
:= by
  intro h0
  have ⟨x,h1,h2⟩ := Iff.mp List.mem_map h0
  rw [←h2]
  simp [Typ.size]



theorem Typ.zero_lt_size {t : Typ} : 0 < Typ.size t := by
cases t <;> simp [Typ.size]

theorem List.pair_typ_zero_lt_size {cs} : 0 < List.pair_typ_size cs := by
cases cs <;> simp [List.pair_typ_size, Typ.zero_lt_size]

theorem ListTyp.zero_lt_size {ts : List Typ} : 0 < ListTyp.size ts := by
cases ts <;> simp [ListTyp.size, Typ.zero_lt_size]


declare_syntax_cat constraints
-- declare_syntax_cat box_constraints
declare_syntax_cat typings
-- declare_syntax_cat box_typings
declare_syntax_cat typ

declare_syntax_cat typs
-- declare_syntax_cat box_typs

declare_syntax_cat frame
declare_syntax_cat brief
declare_syntax_cat pat
declare_syntax_cat record
declare_syntax_cat function
declare_syntax_cat expr


syntax "(" typ "<:" typ ")" : constraints
syntax "(" typ "<:" typ ")" constraints : constraints

-- syntax "[" "]" : box_constraints
-- syntax "[" constraints "]" : box_constraints

syntax "(" ident ":" typ ")" : typings
syntax "(" ident ":" typ ")" typings : typings

-- syntax "[" "]" : box_typings
-- syntax "[" typings "]" : box_typings

syntax ident : typ
syntax:50 typ:51 "->" typ:50 : typ
syntax:60 typ:61 "|" typ:60 : typ
syntax:80 typ:81 "&" typ:80 : typ
syntax:90 typ:91 "*" typ:90 : typ


-- syntax "nil :: " typ:100 : typ
-- syntax "//" typ:100 : typ
-- {}
-- {uno := _, }
-- {uno := _, dos := _,} : (uno : _ & dos : _ )
-- syntax "<" ident "/>" typ:100 : typ
syntax "<" ident "/>" : typ
syntax "<" ident ">" typ:100 : typ
syntax ident ":" typ:100 : typ
syntax typ "\\" typ : typ
syntax:40 "ALL" "[" ids "]" "[" constraints "]" typ : typ
syntax:40 "EXI" "[" ids "]" "[" constraints "]" typ : typ
syntax:40 "ALL" "[" ids "]" typ : typ
syntax:40 "EXI" "[" ids "]" typ : typ
syntax:40 "ALL" "[" "]" "[" constraints "]" typ : typ
syntax:40 "EXI" "[" "]" "[" constraints "]" typ : typ
syntax "LFP" "[" ident "]" typ : typ
syntax "BOT" : typ
syntax "TOP" : typ
syntax "(" typ ")" : typ

syntax typ : typs
syntax typ typs : typs

-- syntax "[" "]" : box_typs
-- syntax "[" typs "]" : box_typs



-- syntax "<" ident "/>" : frame
-- syntax "<" ident "/>" frame : frame
-- syntax "<" ident ">" pat : frame
-- syntax "<" ident ">" pat frame : frame

syntax ident ":=" pat : frame
syntax ident ":=" pat ";" : frame
syntax ident ":=" pat ";" frame : frame

syntax ":" ident : brief
syntax ":" ident brief : brief

syntax ident : pat
syntax "@" : pat
syntax "<" ident ">" pat : pat
syntax "<" ident "/>" : pat
syntax brief : pat
syntax frame : pat
-- syntax ident ";" pat : pat
syntax "(" pat ")" : pat
syntax:60 pat:61 "," pat:60 :pat

-- syntax "<" ident "/>" : record
-- syntax "<" ident "/>" record : record
-- syntax "<" ident ">" expr : record
-- syntax "<" ident ">" expr record : record

-- syntax "}" : record
-- syntax ident ":=" expr "}" : record
-- syntax ident ":=" expr "," record : record

syntax ident ":=" expr : record
syntax ident ":=" expr ";" : record
syntax ident ":=" expr ";" record : record

-- syntax ident ":=" expr ";" : record
-- syntax ident ":=" expr : record
-- syntax ident ":=" expr ";" record : record



syntax "[" pat "=>" expr "]" : function
syntax "[" pat "=>" expr "]" function : function

syntax ident : expr
syntax "<" ident ">" expr : expr
syntax "<" ident "/>" : expr
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

-- syntax "[box_ids|" box_ids "]": term


-- syntax "[subtyping|" typ "<:" typ "]" : term

syntax "[constraints|" "]" : term
syntax "[constraints|" constraints "]" : term
-- syntax "[box_constraints|" box_constraints "]" : term

syntax "[typings|" "]" : term
syntax "[typings|" typings "]": term
-- syntax "[box_typings|" box_typings "]": term


syntax "[typ|" typ "]" : term

syntax "[typs|" "]" : term
syntax "[typs|" typs "]" : term

-- syntax "[box_typs|" "[""]" "]" : term
-- syntax "[box_typs|" "[" typs "]" "]" : term


-- | `([ids| { $t:term } ]) => pure t

-- | `([box_ids| [] ]) => `([])
-- | `([box_ids| [ $ps:ids ] ]) => `([ids| $ps])

-- macro_rules
-- | `([subtyping| $x:typ <: $y:typ ]) =>
--   `(([typ| $x],[typ| $y]))

macro_rules
| `([constraints| ]) => `([])
| `([constraints| ( $x:typ <: $y:typ ) ]) =>
  `(([typ| $x],[typ| $y]) :: [])
| `([constraints| ( $x:typ <: $y:typ ) $qs:constraints ]) =>
  `(([typ| $x],[typ| $y]) :: [constraints| $qs])
-- | `([box_constraints| [] ]) => `([])
-- | `([box_constraints| [ $qs:constraints ] ]) => `([constraints| $qs])



macro_rules
| `([typings| ]) => `([])
| `([typings| ( $x:ident : $y:typ ) ]) =>
  `(([id| $x], [typ| $y]):: [])
| `([typings| ( $x:ident : $y:typ ) $ts:typings ]) =>
  `(([id| $x], [typ| $y]):: [typings| $ts])

-- | `([box_typings| [] ]) => `([])
-- | `([box_typings| [ $ts:typings] ]) => `([ [typings| $ts]])


-- syntax "{" term "}"  : typ


macro_rules
| `([typ| $i:ident ]) => `(Typ.var [id| $i])
| `([typ| < $i:ident > $t:typ  ]) => `(Typ.iso [id| $i] [typ| $t])
| `([typ| < $i:ident /> ]) => `(Typ.iso [id| $i] .top)
-- | `([typ| < $i:ident > $t:typ  ]) => `(Typ.entry [id| $i] [typ| $t])
| `([typ| $i:ident : $t:typ  ]) => `(Typ.entry [id| $i] [typ| $t])
| `([typ| $x:typ -> $y:typ ]) => `(Typ.path [typ| $x] [typ| $y])
| `([typ| $x:typ | $y:typ ]) => `(Typ.unio [typ| $x] [typ| $y])
| `([typ| $x:typ & $y:typ ]) => `(Typ.inter [typ| $x] [typ| $y])
| `([typ| $x:typ * $y:typ ]) => `(Typ.pair [typ| $x] [typ| $y])
| `([typ| $x:typ \ $y:typ ]) => `(Typ.diff [typ| $x] [typ| $y])
| `([typ| ALL [ $ps:ids ] [ $qs:constraints ] $t:typ ]) =>
  `(Typ.all [ids| $ps] [constraints| $qs] [typ| $t])
| `([typ| EXI [ $ps:ids ] [ $qs:constraints ] $t:typ ]) =>
  `(Typ.exi [ids| $ps] [constraints| $qs] [typ| $t])
| `([typ| ALL [ $ps:ids ] $t:typ ]) => `(Typ.all [ids| $ps] [] [typ| $t])
| `([typ| EXI [ $ps:ids ] $t:typ ]) => `(Typ.exi [ids| $ps] [] [typ| $t])

| `([typ| ALL [ ] [ $qs:constraints ] $t:typ ]) =>
  `(Typ.all [] [constraints| $qs] [typ| $t])
| `([typ| EXI [  ] [ $qs:constraints ] $t:typ ]) =>
  `(Typ.exi [] [constraints| $qs] [typ| $t])

| `([typ| LFP [ $i:ident ] $t:typ ]) => `(Typ.lfp [id| $i] [typ| $t])
| `([typ| BOT ]) => `(Typ.bot)
| `([typ| TOP ]) => `(Typ.top)
| `([typ| ( $t:typ ) ]) => `([typ| $t])
-- | `([typ| { $t:term } ]) => pure t


macro_rules
| `([typs| ]) => `([])
| `([typs| $y:typ ]) =>
  `([typ| $y]::[])
| `([typs| $y:typ $ts:typs ]) =>
  `([typ| $y] :: [typs| $ts])

-- | `([box_typs| [] ]) => `([])
-- | `([box_typs| [ $ts:typs] ]) => `([ [typs| $ts]])


def Typ.capture (t : Typ) : Typ :=
    let ids := Typ.free_vars t
    if List.isEmpty ids then
      t
    else
      .exi (List.map (fun _ => "") ids) [] (Typ.seal ids t)

def Typ.do_diff : Typ → Typ → Typ
| (.iso l body), (.iso l_subtra body_subtra) =>
  if l != l_subtra then
    (.iso l body)
  else
    (.iso l (Typ.do_diff body body_subtra))

| (.iso l body), (.exi ids [] (.iso l_subtra body_subtra)) =>
  if l != l_subtra then
    (.iso l body)
  else
    (.iso l (Typ.do_diff body (.exi ids [] body_subtra)))
| t, subtra => .diff t subtra

theorem Typ.diff_drop {l body t l_sub body_sub} :
  l ≠ l_sub →
  (.iso l body) = t →
  (.iso l body) = Typ.do_diff t (Typ.capture (Typ.iso l_sub body_sub))
:= by
  intro h0 h1
  rw [←h1]
  simp [Typ.capture, Typ.free_vars]
  by_cases h2 : Typ.free_vars body_sub = []

  { simp [h2]
    simp [Typ.do_diff]
    intro h3
    apply False.elim
    apply h0 h3
  }
  {
    simp [h2, Typ.seal]
    simp [Typ.do_diff]
    intro h3
    apply False.elim
    apply h0 h3
  }

def Typ.list_diff (t : Typ) : List Typ → Typ
| .nil => t
| .cons x xs => Typ.list_diff (Typ.do_diff t (Typ.capture x)) xs



#eval (Typ.free_vars [typ| X * <uno/>]).map (fun typ => (typ, Typ.top)) -- .map(fun typ => (typ, .top))


@[reducible]
def Typ.enrich : Typ → Typ
| .all ids cs t =>
  .all ids ((List.map (fun id => (Typ.var id, Typ.top)) (Typ.free_vars t ∩ ids)) ∪ cs) t
| .exi ids cs t =>
  .exi ids ((List.map (fun id => (Typ.var id, Typ.top)) (Typ.free_vars t ∩ ids)) ∪ cs) t
| t => t


#eval [typ| <elem/> ]

#eval [typ| uno : TOP & dos : TOP ]

theorem Typ.free_vars_containment_left :
  (l,r) ∈ ys → Typ.free_vars l ⊆ Typ.list_prod_free_vars ys
:= by induction ys with
| nil =>
  simp
| cons y ys' ih =>
  simp [Typ.list_prod_free_vars]
  intro h0 id h1
  simp
  cases h0 with
  | inl h2 =>
    apply Or.inl
    rw [←h2]
    apply Or.inl h1
  | inr h2 =>
    apply Or.inr
    apply ih h2 h1

theorem Typ.free_vars_containment_right :
  (l,r) ∈ ys → Typ.free_vars r ⊆ Typ.list_prod_free_vars ys
:= by induction ys with
| nil =>
  simp
| cons y ys' ih =>
  simp [Typ.list_prod_free_vars]
  intro h0 id h1
  simp
  cases h0 with
  | inl h2 =>
    apply Or.inl
    rw [←h2]
    apply Or.inr h1
  | inr h2 =>
    apply Or.inr
    apply ih h2 h1




def Typ.finite : Typ → Bool
| .top => true
| .iso l body => Typ.finite body
| .entry l body => Typ.finite body
| .path left right =>
  Typ.finite left && Typ.finite right
| .unio left right =>
  Typ.finite left && Typ.finite right
| .inter left right =>
  Typ.finite left && Typ.finite right
| .diff left right =>
  Typ.finite left && Typ.finite right
| _ => False

def Typ.kleene_loop (t : Typ) : Nat → Typ
| 0 => Typ.bot
| n + 1 => Typ.instantiate 0 [(Typ.kleene_loop t n)] t


def Typ.fresh_var (t : Typ) : String :=
  String.join ("_fresh_" :: Typ.free_vars t)


theorem Typ.fresh_var_free_vars_exclusion t :
  (Typ.fresh_var t) ∉ Typ.free_vars t
:= by
  sorry



mutual
  theorem Typ.constraints_shift_vars_instantiate_zero_inside_out threshold offset m e :
    (Typ.constraints_shift_vars threshold offset (Typ.constraints_instantiate 0 m e))
    =
    (Typ.constraints_instantiate 0
      (Typ.list_shift_vars threshold offset m)
      (Typ.constraints_shift_vars (threshold + List.length m) offset e)
    )
  := by sorry

  theorem Typ.shift_vars_instantiate_zero_inside_out threshold offset m e :
    (Typ.shift_vars threshold offset (Typ.instantiate 0 m e))
    =
    (Typ.instantiate 0
      (Typ.list_shift_vars threshold offset m)
      (Typ.shift_vars (threshold + List.length m) offset e)
    )
  := by sorry
end


theorem Typ.free_vars_shift_vars_reflection :
  Typ.free_vars (Typ.shift_vars threshold offset t) =
  Typ.free_vars t
:= by sorry

theorem Typ.free_vars_instantiate_upper_bound :
  Typ.free_vars (Typ.instantiate depth m e) ⊆ (Typ.free_vars e) ++ List.flatMap Typ.free_vars m
:= by sorry

theorem Typ.free_vars_instantiate_lower_bound :
  (Typ.free_vars e) ⊆ Typ.free_vars (Typ.instantiate depth m e)
:= by sorry


theorem Typ.list_prod_free_vars_instantiate_upper_bound :
  Typ.list_prod_free_vars (Typ.constraints_instantiate depth m cs) ⊆ (Typ.list_prod_free_vars cs) ++ List.flatMap Typ.free_vars m
:= by sorry





mutual
  def Typ.constraints_num_bound_vars : List (Typ × Typ) → Nat
  | [] => 0
  | (left,right) :: cs =>
    Nat.max (Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right))
    (Typ.constraints_num_bound_vars cs)

  def Typ.num_bound_vars: Typ → Nat
  | .bvar i => i + 1
  | .var name => 0
  | .entry l body => Typ.num_bound_vars body
  | .iso l body => Typ.num_bound_vars body
  | .path left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .top => 0
  | .bot => 0
  | .unio left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .inter left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .diff left right =>
    Nat.max (Typ.num_bound_vars left) (Typ.num_bound_vars right)
  | .all bs cs body =>
    Nat.max (Typ.constraints_num_bound_vars cs) (Typ.num_bound_vars body)
    - List.length bs
  | .exi bs cs body =>
    Nat.max (Typ.constraints_num_bound_vars cs) (Typ.num_bound_vars body)
    - List.length bs
  | .lfp b body =>
    (Typ.num_bound_vars body) - 1
end


def Typ.instantiated (t: Typ) := Typ.num_bound_vars t == 0


theorem Typ.list_all_mem_instantiate_preservation :
  (∀ t ∈ ts, t = Typ.instantiate depth m t) →
  ts = Typ.list_instantiate depth m ts
:= by sorry

mutual
  def Typ.constraints_nameless : List (Typ × Typ) → Bool
  | [] => .true
  | (left,right) :: cs => Typ.nameless left && Typ.nameless right && Typ.constraints_nameless cs

  def Typ.nameless : Typ → Bool
  | .bvar _ => .true
  | .var _ => .true
  | .entry l body => Typ.nameless body
  | .iso l body => Typ.nameless body
  | .path left right =>  Typ.nameless left && Typ.nameless right
  | .top => .true
  | .bot => .true
  | .unio left right =>  Typ.nameless left && Typ.nameless right
  | .inter left right =>  Typ.nameless left && Typ.nameless right
  | .diff left right =>  Typ.nameless left && Typ.nameless right
  | .all bs cs body =>
    List.all bs (fun b => b == "") &&
    Typ.constraints_nameless cs && Typ.nameless body
  | .exi bs cs body =>
    List.all bs (fun b => b == "") &&
    Typ.constraints_nameless cs && Typ.nameless body
  | .lfp b body =>
    b == "" && Typ.nameless body
end

def Typ.wellformed (t : Typ) := Typ.instantiated t && Typ.nameless t
def Typ.list_wellformed : List Typ → Bool
| [] => true
| t :: ts => Typ.wellformed t && Typ.list_wellformed ts


theorem Typ.wellformed_capture t:
  Typ.wellformed (Typ.capture t) = (Typ.wellformed t)
:= by sorry

theorem Typ.wellformed_do_diff tl tr :
  Typ.wellformed (Typ.do_diff tl tr) = (Typ.wellformed tl && Typ.wellformed tr)
:= by sorry

theorem Typ.wellformed_list_diff t subtras :
  Typ.wellformed (Typ.list_diff t subtras) = (Typ.wellformed t && Typ.list_wellformed subtras)
:= by cases subtras with
| nil =>
  simp [Typ.list_diff, Typ.list_wellformed]
| cons subt subtras' =>
  simp [Typ.list_diff, Typ.list_wellformed]
  rw [Typ.wellformed_list_diff (Typ.do_diff t (Typ.capture subt)) subtras']
  rw [Typ.wellformed_do_diff]
  rw [Typ.wellformed_capture]
  apply Bool.and_assoc


mutual
  theorem Typ.wellformed_nameless_instantiation :
    Typ.wellformed (Typ.instantiate depth [.var name] t') →
    Typ.wellformed t → Typ.wellformed (Typ.instantiate depth [t] t')
  := by sorry

  theorem Typ.wellformed_named_instantiation :
    Typ.wellformed (Typ.instantiate depth [t] t') →
    ∀ name , Typ.wellformed (Typ.instantiate depth [.var name] t')
  := by sorry
end


mutual
  theorem Typ.instantiated_shift_vars_preservation :
    Typ.instantiated t →
    t = Typ.shift_vars threshold offset t
  := by sorry

  theorem Typ.instantiated_shift_vars_reflection :
    Typ.instantiated (Typ.shift_vars threshold offset t) →
    Typ.shift_vars threshold offset t = t
  := by sorry
end



mutual
  theorem Typ.instantiate_inside_out offset depth ma mb e:
    (Typ.instantiate (offset + depth) ma (Typ.instantiate depth mb e)) =
    (Typ.instantiate depth
      (Typ.list_instantiate offset ma mb)
      (Typ.instantiate (offset + List.length mb + depth) ma e)
    )
  := by sorry
end

theorem Typ.constraints_instantiate_zero_inside_out offset ma mb cs:
  (Typ.constraints_instantiate (offset) ma (Typ.constraints_instantiate 0 mb cs)) =
  (Typ.constraints_instantiate 0
    (Typ.list_instantiate offset ma mb)
    (Typ.constraints_instantiate (offset + List.length mb) ma cs)
  )
:= by sorry

theorem Typ.instantiate_zero_inside_out offset ma mb e:
  (Typ.instantiate (offset) ma (Typ.instantiate 0 mb e)) =
  (Typ.instantiate 0
    (Typ.list_instantiate offset ma mb)
    (Typ.instantiate (offset + List.length mb) ma e)
  )
:= by sorry


-- mutual
--   def List.pair_typ_sub (δ : List (String × Typ)) : List (Typ × Typ) → List (Typ × Typ)
--   | .nil => .nil
--   | .cons (l,r) remainder => .cons (Typ.sub δ l, Typ.sub δ r) (List.pair_typ_sub δ remainder)

--   def Typ.sub (δ : List (String × Typ)) : Typ → Typ
--   | .bvar i => .bvar i
--   | .var id => match Prod.find id δ with
--     | .none => .var id
--     | .some t => t
--   | .iso l body => .iso l (Typ.sub δ body)
--   | .entry l body => .entry l (Typ.sub δ body)
--   | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
--   | .bot => .bot
--   | .top => .top
--   | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
--   | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
--   | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
--   | .all ids constraints body =>
--       let δ' := Prod.remove_all δ ids
--       .all ids (List.pair_typ_sub δ' constraints) (Typ.sub δ' body)
--   | .exi ids constraints body =>
--       let δ' := Prod.remove_all δ ids
--       .exi ids (List.pair_typ_sub δ' constraints) (Typ.sub δ' body)
--   | .lfp id body =>
--       let δ' := Prod.remove id δ
--       .lfp id (Typ.sub δ' body)
-- end

end Lang
