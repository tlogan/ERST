declare_syntax_cat subtra
declare_syntax_cat typ
declare_syntax_cat params
declare_syntax_cat quals
declare_syntax_cat obj




syntax "o[" obj "]" : term
syntax "t[" typ "]" : term
syntax "s[" subtra "]" : term
syntax "ps[" params "]" : term
syntax "qs[" quals "]" : term

syntax typ : obj

syntax "@" : subtra
syntax "TOP" : subtra
syntax "<" ident ">" subtra : subtra
syntax subtra "&" subtra : subtra


syntax ident : typ
syntax "@" : typ
syntax "<" ident ">" typ : typ
syntax typ "|" typ : typ
syntax typ "&" typ : typ
syntax typ "->" typ : typ
syntax typ "\\" typ : typ
syntax "ALL" "[" params quals typ : typ
syntax "EXI" "[" params quals typ : typ
syntax "ALL" "[" params typ : typ
syntax "EXI" "[" params typ : typ
syntax "BOT" : typ
syntax "TOP" : typ

syntax "]" : params
syntax ident params : params

syntax ":" : quals
syntax "(" typ "<:" typ ")" quals : quals

macro_rules
| `(o[ $t:typ ]) => `(t[ $t ])


inductive Subtra
| top
| unit
| entry : String → Subtra → Subtra
| inter : Subtra → Subtra → Subtra
deriving Repr

macro_rules
| `(s[ TOP ]) => `(Subtra.top)
| `(s[ @ ]) => `(Subtra.unit)
| `(s[ < $i:ident > $s:subtra  ]) => `(Subtra.entry $(Lean.quote (toString i.getId)) s[$s])
| `(s[ $x:subtra & $y:subtra]) => `(Subtra.inter s[$x] s[$y])

mutual
  inductive Typ
  | var : String → Typ
  | unit
  | entry : String → Typ → Typ
  | path : Typ → Typ → Typ
  | unio :  Typ → Typ → Typ
  | inter :  Typ → Typ → Typ
  | diff :  Typ → Subtra → Typ
  | all :  List String → List Constraint → Typ → Typ
  | exi :  List String → List Constraint → Typ → Typ
  | lfp :  String → Typ → Typ
  deriving Repr

  inductive Constraint
  | subtyping : Typ → Typ → Constraint
  deriving Repr

end

macro_rules
| `(t[ $i:ident ]) => `(Typ.var $(Lean.quote (toString i.getId)))
| `(t[ @ ]) => `(Typ.unit)
| `(t[ < $i:ident > $t:typ  ]) => `(Typ.entry $(Lean.quote (toString i.getId)) t[$t])
| `(t[ $x:typ -> $y:typ]) => `(Typ.path t[$x] t[$y])
| `(t[ $x:typ | $y:typ]) => `(Typ.unio t[$x] t[$y])
| `(t[ $x:typ & $y:typ]) => `(Typ.inter t[$x] t[$y])
| `(t[ $x:typ \ $y:typ]) => `(Typ.diff t[$x] t[$y])
| `(t[ ALL [ $ps:params $qs:quals $t:typ]) => `(Typ.all ps[$ps] qs[$qs] t[$t])
| `(t[ EXI [ $ps:params $qs:quals $t:typ]) => `(Typ.exi ps[$ps] qs[$qs] t[$t])
| `(t[ ALL [ $ps:params $t:typ]) => `(Typ.all ps[$ps] [] t[$t])
| `(t[ EXI [ $ps:params $t:typ]) => `(Typ.exi ps[$ps] [] t[$t])
| `(t[ BOT ]) => `(t[ALL[T]T])
| `(t[ TOP ]) => `(t[EXI[T]T])


macro_rules
| `(ps[ ] ]) => `([])
| `(ps[ $i:ident $ps:params ]) => `($(Lean.quote (toString i.getId)) :: ps[$ps])

macro_rules
| `(qs[ : ]) => `([])
| `(qs[ ( $x:typ <: $y:typ ) $qs:quals ]) => `( (Constraint.subtyping t[$x] t[$y]):: qs[$qs])



class SubtraOf (_ : Typ) where
  default : Subtra

instance : SubtraOf t[TOP] where
  default := s[TOP]

instance : SubtraOf t[@] where
  default := s[@]

instance (label : String) (result : Typ) [s : SubtraOf result]
: SubtraOf (Typ.entry label result)  where
  default := Subtra.entry label s.default

instance
  (left : Typ) [l : SubtraOf left]
  (right : Typ) [r : SubtraOf right]
: SubtraOf (Typ.inter left right)  where
  default := Subtra.inter l.default r.default


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
| proj : Expr → String → Expr
| app : Expr → Expr → Expr
| anno : String → Option Typ → Expr → Expr → Expr
deriving Repr



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


-- NOTE: type classes perform two functions
  -- first: they refine the type of the dependency
  -- second: they compute instances from some dependencies

-- NOTE: this is a really weird mechanism
-- a better design would separate concerns
-- use subtyping to allow refinements or expansions of types
-- use general purpose functions to compute from the refinement to some new form
-- use relational types to maintain the connection between forms

-- Note: inductive types also contain runtime computation
  -- they compute dependencies from all instances

-- NOTE: this means the computation of the dependency is represented by a type annotation
-- a better design would not allow type annotations to influence runtime behavior
-- Instead, runtime computation should only be specified by the expression language
-- types should be inferred from the expression language, rather than expressions being derived from types.


def foo (p : Pat) : Bool := (
  true
)

#check PatternOf.mk

#check foo

#eval foo (Expr.unit)

section
open Typ
#eval unit
end
