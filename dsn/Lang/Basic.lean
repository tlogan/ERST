import Lean
import Mathlib.Data.Set.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

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
deriving Repr

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

-- instance : SizeOf Typ where
--   sizeOf := Typ.size


-- theorem Typ.zero_lt_size {t : Typ} : 0 < Typ.size t := by
-- cases t <;> simp [Typ.size]

-- theorem ListPairTyp.zero_lt_size {cs} : 0 < ListPairTyp.size cs := by
-- cases cs <;> simp [ListPairTyp.size, Typ.zero_lt_size]


def Typ.sub (δ : List (String × Typ)) : Typ → Typ
| t => t
-- TODO

inductive Polarity
| pos | neg | either | neither
deriving BEq

def Polarity.flip : Polarity → Polarity
| .pos => .neg
| .neg => .pos
| p => p

def Polarity.both : Polarity → Polarity → Polarity
| .pos, .pos => .pos
| .neg, .neg => .neg
| .either, r => r
| l, .either => l
| _, _ => .neither

mutual

  def ListSubtyping.polarity_consistent (id : String) (t : Typ) : List (Typ × Typ) → Bool
  | .nil => .true
  | (l,r) :: remainder =>
      let p := Polarity.both (.both (Typ.polar id l) (Typ.polar id r)) (Typ.polar id t)
      p != Polarity.neither ∧ ListSubtyping.polarity_consistent id t remainder

  def ListSubtyping.polarities_consistent (t : Typ) (pairs : List (Typ × Typ)) :  List String → Bool
  | .nil => .true
  | id :: remainder =>
    ListSubtyping.polarity_consistent id t pairs ∧ ListSubtyping.polarities_consistent t pairs remainder

  def Typ.polar (id : String) : Typ → Polarity
  | .var id' => if id' = id then .pos else .either
  | .unit => .either
  | .entry _ body => Typ.polar id body
  | .path left right =>
    Polarity.both (Polarity.flip (Typ.polar id left)) (Typ.polar id right)
  | .unio left right => Polarity.both (Typ.polar id left) (Typ.polar id right)
  | .inter left right => Polarity.both (Typ.polar id left) (Typ.polar id right)
  | .diff left right => Polarity.both (Typ.polar id left) (Polarity.flip (Typ.polar id right))
  | .all ids quals body =>
    if id ∈ ids then
      .either
    else if ListSubtyping.polarities_consistent body quals ids then
      Typ.polar id body
    else
      .neither
  | .exi ids quals body =>
    if id ∈ ids then
      .either
    else if ListSubtyping.polarities_consistent (Typ.diff .unit body) quals ids then
      Typ.polar id body
    else
      .neither
  | .lfp id' body =>
    if id' == id then
      .either
    else
      Typ.polar id body
end

def Typ.subfold (id : String) (t : Typ): Nat → Typ
| 0 => .exi ["T"] [] (.var "T")
| n + 1 => Typ.sub [(id, Typ.subfold id t n)] t


inductive Pat
| var : String → Pat
| unit
| record : List (String × Pat) → Pat
deriving Repr

inductive Expr
| var : String → Expr
| unit
| record : List (String × Expr) → Expr
| function : List (Pat × Expr) → Expr
| app : Expr → Expr → Expr
| anno : String → Typ → Expr → Expr → Expr
| loop : Expr → Expr
deriving Repr

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
| `(t[ BOT ]) => `(Typ.all ["T"] [] (Typ.var "T"))
| `(t[ TOP ]) => `(Typ.exi ["T"] [] (Typ.var "T"))
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
| `(e[ $l:expr , $r:expr ]) => `(Expr.record [("left", e[$l]), ("right", e[$r])])
| `(e[ $f:function ]) => `(Expr.function f[$f])
| `(e[ $e:expr . $i:ident ]) => `(Expr.app (
    Expr.function [
      (Pat.record [
        (i[$i], Pat.var "x")
      ], Expr.var "x")
    ]
) e[$e])
| `(e[ $f:expr ( $a:expr ) ]) => `(Expr.app e[$f] e[$a])
| `(e[ def $i:ident : $t:typ = $a:expr in $c:expr  ]) => `(Expr.anno
    $(Lean.quote (toString i.getId))
    t[$t]
    (e[$a])
    (e[$c])
)
| `(e[ def $i:ident = $a:expr in $c:expr  ]) => `(Expr.app
    (Expr.function [
      (Pat.var i[$i], (e[$c]))
    ])
    (e[$a])
)
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
