import Lang.Basic


mutual
  inductive IsFreshLabel : List (String × Expr) → String → Prop
  | nil : ∀ {l}, IsFreshLabel [] l
  | cons : ∀ {l e r l'},
    l' ≠ l →
    IsFreshLabel r l' →
    IsFreshLabel ((l,e)::r) l'

  inductive IsRecordValue : List (String × Expr) -> Prop
  | nil : IsRecordValue []
  | cons : ∀ {l e r},
    IsFreshLabel r l → IsValue e →
    IsRecordValue ((l,e)::r)

  inductive IsValue : Expr -> Prop
  | unit : IsValue (.unit)
  | record : ∀ {r}, IsRecordValue r → IsValue (.record r)
  | function : ∀ {f}, IsValue (.function f)
  -- TODO: check that there are no free variables
end


inductive PatternMatch : Expr → Pat → List (String × Expr) → Prop
--TODO

def sub (m : List (String × Expr)): Expr → Expr
| e => e
-- TODO


inductive Progression : Expr -> Expr -> Prop
| entry : ∀ {r l e e'},
  Progression e e' →
  Progression (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record : ∀ {r r' l v},
  Progression (Expr.record r) (Expr.record r') →
  IsValue v →
  Progression (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator : ∀ {ef ef' e},
  Progression ef ef' →
  Progression (.app ef e) (.app ef' e)
| applicand : ∀ {f e e'},
  Progression e e' →
  Progression (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  IsValue v →
  PatternMatch v p m →
  Progression (.app (.function ((p,e) :: f)) v) (sub m e)


-- TODO: define progression and dynamic typing
-- TODO: create tactic to construct proof of progression to a value
-- TODO: create tactic to construct proof of dynamic values for given expression and type
