
def hello := "world"

#check hello


mutual
  inductive Typ
  | var : String → Typ
  | unit
  | entry : String → Typ → Typ
  | path : Typ → Typ → Typ
  | unio :  Typ → Typ → Typ
  | inter :  Typ → Typ → Typ
  | diff :  Typ → Typ → Typ
  | all :  List String → List Constraint → Typ → Typ
  | exi :  List String → List Constraint → Typ → Typ
  | lfp :  String → Typ → Typ
  deriving Repr

  inductive Constraint
  | subtyping : Typ → Typ → Constraint
  deriving Repr

end

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
