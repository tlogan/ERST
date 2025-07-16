
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


-- NOTE: think of a type class as a type that can compute instances from some dependencies
-- NOTE: think of a inductive type as a type that can compute dependencies from all instances
-- NOTE: type classes have the effect of refinement types with respect to relations,
  -- where they refine the type of the dependency to the subtype where the dependent type is inhabited

-- NOTE: relational types subsumes both; makes no distinction between instances vs dependencies
-- NOTE: relational types can use constraint solving to infer missing arguments

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
