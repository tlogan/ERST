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
| unit
| entry : String → Typ → Typ
| path : Typ → Typ → Typ
| unio :  Typ → Typ → Typ
| inter :  Typ → Typ → Typ
| diff :  Typ → Typ → Typ
| all :  List String → List (Typ × Typ) → Typ → Typ
| exi :  List String → List (Typ × Typ) → Typ → Typ
| lfp :  String → Typ → Typ
deriving Repr, BEq

def Typ.bot := Typ.all ["T"] [] (Typ.var "T")
def Typ.top := Typ.exi ["T"] [] (Typ.var "T")
def Typ.pair (left right : Typ) := Typ.inter (.entry "left" left) (.entry "right" right)

instance : BEq (Typ × Typ) where
  -- beq a b := a.fst == b.fst && a.snd == b.snd
  beq | (a,b), (c,d) => a == c && b == d


inductive Typ.Bruijn
| bvar : Nat → Typ.Bruijn
| fvar : String → Typ.Bruijn
| unit
| entry : String → Typ.Bruijn → Typ.Bruijn
| path : Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| unio :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| inter :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| diff :  Typ.Bruijn → Typ.Bruijn → Typ.Bruijn
| all :  Nat → List (Typ.Bruijn × Typ.Bruijn) → Typ.Bruijn → Typ.Bruijn
| exi :  Nat → List (Typ.Bruijn × Typ.Bruijn) → Typ.Bruijn → Typ.Bruijn
| lfp :  Typ.Bruijn → Typ.Bruijn
deriving Repr, BEq


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


mutual
  def Typ.ordered_bound_vars (bounds : List String) : Typ → List String
  | .var id =>
    if id ∈ bounds then [id] else []
  | .unit => []
  | .entry _ t =>
    Typ.ordered_bound_vars bounds t
  | .path left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.diff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .unio left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.diff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .inter left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.diff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .diff left right =>
    let a := Typ.ordered_bound_vars bounds left
    let b := List.diff (Typ.ordered_bound_vars bounds right) a
    a ∪ b
  | .all ids quals body =>
    let bounds' := List.diff bounds ids
    let a := ListPairTyp.ordered_bound_vars bounds' quals
    let b := List.diff (Typ.ordered_bound_vars bounds' body) a
    a ∪ b
  | .exi ids quals body =>
    let bounds' := List.diff bounds ids
    let a := ListPairTyp.ordered_bound_vars bounds' quals
    let b := List.diff (Typ.ordered_bound_vars bounds' body) a
    a ∪ b
  | .lfp id body =>
    let bounds' := List.diff bounds [id]
    Typ.ordered_bound_vars bounds' body

  def ListPairTyp.ordered_bound_vars (bounds : List String)
  : List (Typ × Typ) → List String
  | .nil => .nil
  | .cons (l,r) remainder =>
    let a := (Typ.ordered_bound_vars bounds l)
    let b := List.diff (Typ.ordered_bound_vars bounds r) a
    let c := List.diff (ListPairTyp.ordered_bound_vars bounds remainder) (a ∪ b)
    a ∪ b ∪ c
end

mutual
  def ListPairTyp.free_vars : List (Typ × Typ) → List String
  | .nil => []
  | .cons (l,r) remainder =>
    Typ.free_vars l ∪ Typ.free_vars r ∪ ListPairTyp.free_vars remainder

  def Typ.free_vars : Typ → List String
  | .var id => [id]
  | .unit => []
  | .entry _ body => Typ.free_vars body
  | .path p q => Typ.free_vars p ∪ Typ.free_vars q
  | .unio l r => Typ.free_vars l ∪ Typ.free_vars r
  | .inter l r => Typ.free_vars l ∪ Typ.free_vars r
  | .diff l r => Typ.free_vars l ∪ Typ.free_vars r
  | .all ids quals body =>
    List.diff (
      ListPairTyp.free_vars quals ∪ Typ.free_vars body
    ) ids
  | .exi ids quals body =>
    List.diff (
      ListPairTyp.free_vars quals ∪ Typ.free_vars body
    ) ids
  | .lfp id body =>
    List.diff (Typ.free_vars body) [id]
end

mutual
  def ListPairTyp.toBruijn (base : Nat) (bids : List String)
  : List (Typ × Typ) → List (Typ.Bruijn × Typ.Bruijn)
  | .nil => .nil
  | .cons (l,r) remainder =>
    .cons
    (Typ.toBruijn base bids l, Typ.toBruijn base bids r)
    (ListPairTyp.toBruijn base bids remainder)

  def Typ.toBruijn (base : Nat) (bids : List String) : Typ → Typ.Bruijn
  | .var id =>
    match List.firstIndexOf id bids with
    | .none => .fvar id
    | .some i => .bvar (base + i)
  | .unit => .unit
  | .entry l body => .entry l (Typ.toBruijn base bids body)
  | .path left right =>
    .path
    (Typ.toBruijn base bids left)
    (Typ.toBruijn base bids right)
  | .unio left right =>
    .unio
    (Typ.toBruijn base bids left)
    (Typ.toBruijn base bids right)
  | .inter left right =>
    .inter
    (Typ.toBruijn base bids left)
    (Typ.toBruijn base bids right)
  | .diff left right =>
    .diff
    (Typ.toBruijn base bids left)
    (Typ.toBruijn base bids right)
    | .all ids quals body =>
      let bids' := ListPairTyp.ordered_bound_vars ids ((.unit, body) :: quals)
      let n := (List.length bids')
      .all n
      (ListPairTyp.toBruijn (n + base + n) (bids' ++ bids) quals)
      (Typ.toBruijn (n + base) (bids' ++ bids) body)
    | .exi ids quals body =>
      let bids' := ListPairTyp.ordered_bound_vars ids ((.unit, body) :: quals)
      let n := (List.length bids')
      .all n
      (ListPairTyp.toBruijn (n + base + n) (bids' ++ bids) quals)
      (Typ.toBruijn (n + base) (bids' ++ bids) body)
    | .lfp id body =>
      .lfp
      (Typ.toBruijn (1 + base) (id :: bids) body)
end

mutual

  def ListPairTyp.size : List (Typ × Typ) → Nat
  | .nil => 1
  | .cons (l, r) rest =>  Typ.size l + Typ.size r + ListPairTyp.size rest

  def Typ.size : Typ → Nat
  | .var id => 1
  | .unit => 1
  | .entry l body => Typ.size body + 1
  | .path left right => Typ.size left + Typ.size right + 1
  | .unio left right => Typ.size left + Typ.size right + 1
  | .inter left right => Typ.size left + Typ.size right + 1
  | .diff left right => Typ.size left + Typ.size right + 1
  | .all ids quals body => ListPairTyp.size quals + Typ.size body + 1
  | .exi ids quals body => ListPairTyp.size quals + Typ.size body + 1
  | .lfp id body => Typ.size body + 1
end

theorem Typ.zero_lt_size {t : Typ} : 0 < Typ.size t := by
cases t <;> simp [Typ.size]

theorem ListPairTyp.zero_lt_size {cs} : 0 < ListPairTyp.size cs := by
cases cs <;> simp [ListPairTyp.size, Typ.zero_lt_size]


-- instance : SizeOf Typ where
--   sizeOf := Typ.size

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

  def ListPairTyp.sub (δ : List (String × Typ)) : List (Typ × Typ) → List (Typ × Typ)
  | .nil => .nil
  | (l,r) :: remainder => (Typ.sub δ l, Typ.sub δ r) :: ListPairTyp.sub δ remainder

  def Typ.sub (δ : List (String × Typ)) : Typ → Typ
  | .var id => match find id δ with
    | .none => .var id
    | .some t => t
  | .unit => .unit
  | .entry l body => .entry l (Typ.sub δ body)
  | .path left right => .path (Typ.sub δ left) (Typ.sub δ right)
  | .unio left right => .unio (Typ.sub δ left) (Typ.sub δ right)
  | .inter left right => .inter (Typ.sub δ left) (Typ.sub δ right)
  | .diff left right => .diff (Typ.sub δ left) (Typ.sub δ right)
  | .all ids quals body =>
      let δ' := remove_all δ ids
      .all ids (ListPairTyp.sub δ' quals) (Typ.sub δ' body)
  | .exi ids quals body =>
      let δ' := remove_all δ ids
      .exi ids (ListPairTyp.sub δ' quals) (Typ.sub δ' body)
  | .lfp id body =>
      let δ' := remove id δ
      .lfp id (Typ.sub δ' body)
end


mutual

  inductive ListSubtyping.Monotonic.Consistent : List String → List (Typ × Typ) → Typ → Prop
  | nil {cs t} : ListSubtyping.Monotonic.Consistent [] cs t
  | cons {id ids cs t b} :
    ListSubtyping.Monotonic id b cs →
    Typ.Monotonic id b t →
    ListSubtyping.Monotonic.Consistent  ids cs t →
    ListSubtyping.Monotonic.Consistent (id :: ids) cs t

  inductive ListSubtyping.Monotonic : String → Bool → List (Typ × Typ) → Prop
  | nil {id b} : ListSubtyping.Monotonic id b []
  | cons {id b l r remainder} :
    Typ.Monotonic id (not b) l →
    Typ.Monotonic id b r →
    ListSubtyping.Monotonic id b ((l,r)::remainder)

  inductive Typ.Monotonic : String → Bool → Typ → Prop
  | var {id} : Typ.Monotonic id true (.var id)
  | varskip {id b id'} : id ≠ id' → Typ.Monotonic id b (.var id')
  | unit {id b}: Typ.Monotonic id b .unit
  | entry {id b l body}: Typ.Monotonic id b body →  Typ.Monotonic id b (.entry l body)
  | path {id b left right}:
    Typ.Monotonic id (not b) left →
    Typ.Monotonic id b right →
    Typ.Monotonic id b (.path left right)
  | unio {id b left right}:
    Typ.Monotonic id b left →
    Typ.Monotonic id b right →
    Typ.Monotonic id b (.unio left right)
  | inter {id b left right}:
    Typ.Monotonic id b left →
    Typ.Monotonic id b right →
    Typ.Monotonic id b (.inter left right)
  | diff {id b left right}:
    Typ.Monotonic id b left →
    Typ.Monotonic id (not b) right →
    Typ.Monotonic id b (.diff left right)

  | all {id b ids quals body} :
    id ∉ ids →
    ListSubtyping.Monotonic.Consistent ids quals body →
    Typ.Monotonic id b body →
    Typ.Monotonic id b (.all ids quals body)

  | allskip {id b ids quals body} :
    id ∈ ids →
    Typ.Monotonic id b (.all ids quals body)

  | exi {id b ids quals body} :
    id ∉ ids →
    ListSubtyping.Monotonic.Consistent ids quals (.diff .unit body) →
    Typ.Monotonic id b body →
    Typ.Monotonic id b (.exi ids quals body)

  | exiskip {id b ids quals body} :
    id ∈ ids →
    Typ.Monotonic id b (.exi ids quals body)

  | lfp {id b id' body}: id ≠ id' → Typ.Monotonic id b body → Typ.Monotonic id b (.lfp id' body)
  | lfpskip {id b body}: Typ.Monotonic id b (.lfp id body)
end

def Typ.subfold (id : String) (t : Typ) : Nat → Typ
| 0 => .exi ["T"] [] (.var "T")
| n + 1 => Typ.sub [(id, Typ.subfold id t n)] t

inductive Pat
| var : String → Pat
| unit
| record : List (String × Pat) → Pat
deriving Repr

mutual
  def ListPat.free_vars : List (String × Pat) → List String
  | .nil => []
  | .cons (l,p) remainder =>
    Pat.free_vars p ∪ ListPat.free_vars remainder

  def Pat.free_vars : Pat → List String
  | .var id => [id]
  | .unit => []
  | .record ps => ListPat.free_vars ps
end



inductive Expr
| var : String → Expr
| unit
| record : List (String × Expr) → Expr
| function : List (Pat × Expr) → Expr
| app : Expr → Expr → Expr
-- | anno : String → Typ → Expr → Expr → Expr
| anno : Expr → Typ → Expr
| loop : Expr → Expr
deriving Repr

def Expr.pair (left : Expr) (right : Expr) : Expr :=
    .record [("left", left), ("right", right)]

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

declare_syntax_cat params
declare_syntax_cat quals
declare_syntax_cat typ

declare_syntax_cat patrec
declare_syntax_cat pat
declare_syntax_cat exprrec
declare_syntax_cat function
declare_syntax_cat expr


syntax "]" : params
syntax:20 ident params : params

syntax ":" : quals
syntax "(" typ "<:" typ ")" quals : quals

syntax ident : typ
syntax "@" : typ
syntax "<" ident ">" typ : typ
syntax:50 typ:51 "->" typ:50 : typ
syntax:60 typ:61 "|" typ:60 : typ
syntax:80 typ:81 "&" typ:80 : typ
syntax typ "\\" typ : typ
syntax "ALL" "[" params quals typ : typ
syntax "EXI" "[" params quals typ : typ
syntax "ALL" "[" params typ : typ
syntax "EXI" "[" params typ : typ
syntax "BOT" : typ
syntax "TOP" : typ
syntax "(" typ ")" : typ


syntax "<" ident ">" pat : patrec
syntax "<" ident ">" pat patrec : patrec

syntax:20 ident : pat
syntax "@" : pat
syntax patrec : pat
syntax ident ";" pat : pat


syntax "<" ident ">" expr : exprrec
syntax "<" ident ">" expr exprrec : exprrec

syntax "[" pat "=>" expr "]" : function
syntax "[" pat "=>" expr "]" function : function

syntax:20 ident : expr
syntax "@" : expr
syntax exprrec : expr
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


syntax "i[" ident "]" : term
syntax "ps[" params "]" : term
syntax "qs[" quals "]" : term
syntax "t[" typ "]" : term
syntax "pr[" patrec "]" : term
syntax "p[" pat "]" : term
syntax "er[" exprrec "]" : term
syntax "f[" function "]" : term
syntax "ei[" ident "]" : term
syntax "e[" expr "]" : term



elab_rules : term
  | `(i[ $i:ident ])  => do
    let idStr := toString i.getId
    if idStr.contains '.' then
      Lean.Elab.throwUnsupportedSyntax
    return (Lean.mkStrLit idStr)


macro_rules
| `(ps[ ] ]) => `([])
| `(ps[ $i:ident $ps:params ]) => `($(Lean.quote (toString i.getId)) :: ps[$ps])

macro_rules
| `(qs[ : ]) => `([])
| `(qs[ ( $x:typ <: $y:typ ) $qs:quals ]) => `( (Constraint.subtyping t[$x] t[$y]):: qs[$qs])

macro_rules
| `(t[ $i:ident ]) => `(Typ.var i[$i])
| `(t[ @ ]) => `(Typ.unit)
| `(t[ < $i:ident > $t:typ  ]) => `(Typ.entry i[$i] t[$t])
| `(t[ $x:typ -> $y:typ ]) => `(Typ.path t[$x] t[$y])
| `(t[ $x:typ | $y:typ ]) => `(Typ.unio t[$x] t[$y])
| `(t[ $x:typ & $y:typ ]) => `(Typ.inter t[$x] t[$y])
| `(t[ $x:typ \ $y:typ ]) => `(Typ.diff t[$x] t[$y])
| `(t[ ALL [ $ps:params $qs:quals $t:typ ]) => `(Typ.all ps[$ps] qs[$qs] t[$t])
| `(t[ EXI [ $ps:params $qs:quals $t:typ ]) => `(Typ.exi ps[$ps] qs[$qs] t[$t])
| `(t[ ALL [ $ps:params $t:typ ]) => `(Typ.all ps[$ps] [] t[$t])
| `(t[ EXI [ $ps:params $t:typ ]) => `(Typ.exi ps[$ps] [] t[$t])
| `(t[ BOT ]) => `(Typ.bot)
| `(t[ TOP ]) => `(Typ.top)
| `(t[ ( $t:typ ) ]) => `(t[$t])


macro_rules
| `(pr[ <$i:ident> $p:pat ]) => `((i[$i], p[$p]) :: [])
| `(pr[ <$i:ident> $p:pat $pr:patrec ]) => `((i[$i], p[$p]) :: pr[$pr])

macro_rules
| `(p[ $i:ident ]) => `(Pat.var i[$i])
| `(p[ @ ]) => `(Pat.unit)
| `(p[ $pr:patrec ]) => `(Pat.record pr[$pr])
| `(p[ $i:ident ; $p:pat ]) => `(Pat.record (i[$i], p[$p]) :: [])

macro_rules
| `(er[ <$i:ident> $e:expr ]) => `((i[$i], e[$e]) :: [])
| `(er[ <$i:ident> $e:expr $er:exprrec ]) => `((i[$i], e[$e]) :: er[$er])

macro_rules
| `(f[ [ $p:pat => $e:expr ] ]) => `((p[$p], e[$e]) :: [])
| `(f[ [ $p:pat => $e:expr ] $f:function ]) => `((p[$p], e[$e]) :: f[$f])

partial def buildSyntaxFromDotted (parts : List Lean.Ident) : Lean.Elab.TermElabM (Lean.TSyntax `term) :=
  match parts with
  | [] => Lean.Elab.throwUnsupportedSyntax
  | [x] => `(Expr.var i[$x])
  | x :: xs => do
    let ys ← buildSyntaxFromDotted xs
    `(Expr.app
        (Expr.function [
          (Pat.record [
            (i[$x], Pat.var "x")
          ], Expr.var "x")
        ])
        $ys
    )

elab_rules : term
  | `(ei[ $i:ident ])  => do
    let name := i.getId
    let parts := name.components.map Lean.mkIdent
    let s ← buildSyntaxFromDotted parts.reverse
    Lean.Elab.Term.elabTerm s none

macro_rules
| `(e[ @ ]) => `(Expr.unit)
| `(e[ $i:ident ]) => `(ei[$i])
| `(e[ $er:exprrec ]) => `(Expr.record er[$er])
| `(e[ $i:ident ; $e:expr ]) => `(Expr.record [(i[$i], e[$e])])
| `(e[ $l:expr , $r:expr ]) => `(Expr.pair e[$l] e[$r])
| `(e[ $f:function ]) => `(Expr.function f[$f])
| `(e[ $e:expr . $i:ident ]) => `(Expr.proj e[$e] i[$i])
| `(e[ $f:expr ( $a:expr ) ]) => `(Expr.app e[$f] e[$a])
| `(e[ $e:expr as $t:typ ]) => `(Expr.anno e[$e] t[$t])
| `(e[ def $i:ident : $t:typ = $a:expr in $c:expr  ]) =>
  `(Expr.def i[$i] (.some t[$t]) e[$a] e[$c])
| `(e[ def $i:ident = $a:expr in $c:expr  ]) =>
  `(Expr.def i[$i] .none e[$a] e[$c])
| `(e[ loop ( $e:expr ) ]) => `(Expr.loop e[$e])
| `(e[ ( $e:expr ) ]) => `(e[$e])


#check ei[uno.dos.tres]

#check e[[x => x.uno]]

#check e[(uno;@).uno]

#check e[def x = @ in x]

#check e[[<uno> x => x]]


class RecordPatternOf (_ : List (String × Expr)) where
  default : List (String × Pat)

class PatternOf (_ : Expr) where
  default : Pat

instance (id : String) : PatternOf (Expr.var id) where
  default := Pat.var id

instance : PatternOf (Expr.unit) where
  default := Pat.unit

instance (entries : List (String × Expr)) [d : RecordPatternOf entries] : PatternOf (Expr.record entries) where
  default := Pat.record d.default


instance : RecordPatternOf [] where
  default := []

instance
  (label : String) (result : Expr) [pd : PatternOf result]
  (remainder : List (String × Expr)) [rpd: RecordPatternOf remainder]
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
  | .unit => .unit
  | .record r => .record (toRecordExpr r)
end

instance : Coe Pat Expr where
  coe := Pat.toExpr


def ListTyp.diff (t : Typ) : List Typ → Typ
| .nil => t
| .cons x xs => ListTyp.diff (Typ.diff t x) xs

def Typ.capture (t : Typ) : Typ :=
    let ids := Typ.free_vars t
    .exi ids [] t
