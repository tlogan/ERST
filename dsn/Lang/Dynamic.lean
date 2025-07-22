import Lang.Basic
import Mathlib.Data.Set.Basic


mutual
  inductive IsFreshLabel : List (String × Expr) → String → Prop
  | nil : ∀ {l}, IsFreshLabel [] l
  | cons : ∀ {l e r l'},
    l' ≠ l →
    IsFreshLabel r l' →
    IsFreshLabel ((l,e)::r) l'

  inductive IsRecordValue : List (String × Expr) → Prop
  | nil : IsRecordValue []
  | cons : ∀ {l e r},
    IsFreshLabel r l → IsValue e →
    IsRecordValue ((l,e)::r)

  inductive IsValue : Expr → Prop
  | unit : IsValue (.unit)
  | record : ∀ {r}, IsRecordValue r → IsValue (.record r)
  | function : ∀ {f}, IsValue (.function f)
end


mutual
  def pattern_match_entry (label :String) (pat : Pat):
  List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (pattern_match e pat)
    else
      pattern_match_entry label pat args

  def pattern_match_record (args : List (String × Expr)):
  List (String × Pat) →
  Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    let m0 ← pattern_match_entry label pat args
    let m1 ← pattern_match_record args pats
    return (m0 ++ m1)

  def pattern_match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | .unit, .unit => some []
  | (.record r), (.record p) => pattern_match_record r p
  | _, _ => none
end

def dom {α} {β} : List (α × β) → List α
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
  def ids_record_pattern : List (String × Pat) → List String
  | .nil => .nil
  | (_, p) :: r =>
    (ids_pattern p) ++ (ids_record_pattern r)

  def ids_pattern : Pat → List String
  | .var id => [id]
  | .unit => []
  | .record r => ids_record_pattern r
end

mutual
  def sub_record (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, sub m e) :: (sub_record m r)

  def sub_function (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := ids_pattern p
    (p, sub (remove_all m ids) e) :: (sub_function m f)

  def sub (m : List (String × Expr)): Expr → Expr
  | .var id => match (find id m) with
    | .none => (.var id)
    | .some e => e
  | .unit => .unit
  | .record r => .record (sub_record m r)
  | .function f => .function (sub_function m f)
  | .app ef ea => .app (sub m ef) (sub m ea)
  | .anno id t ea ec => .anno id t (sub m ea) (sub (remove id m) ec)
  | .loop e => .loop (sub m e)
end

inductive Progression : Expr → Expr → Prop
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
  pattern_match v p = some m →
  Progression (.app (.function ((p,e) :: f)) v) (sub m e)
| appskip : ∀ {p e f v},
  IsValue v →
  pattern_match v p = none →
  Progression (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {id t ea ec},
  Progression (.anno id t ea ec) (.app (.function [(.var id, ec)]) ea)
| loopbody : ∀ {e e'},
  Progression e e' →
  Progression (.loop e) (.loop e')
| loopinflate : ∀ {id e},
  Progression (.loop (.function [(.var id, e)])) (sub [(id, (.loop (.function [(.var id, e)])))] e)



mutual

  inductive Dynamic.Typing : List (String × Typ) → Expr → Typ → Prop
  | expan : ∀ {δ e τ e'},
    Progression e e' → Typing δ e' τ → Typing δ e τ
  | record : ∀ {δ r l τ v},
    IsValue (.record r) → (l, v) ∈ r → Typing δ v τ →
    Typing δ (.record r) (.entry l τ)
  | funhead : ∀ {δ p e f left right},
    -- (∀ σ, Typing δ (sub σ (Pat.toExpr p)) left → Typing δ (sub σ e) right) →
    Typing δ (.function ((p,e)::f)) (.path left right)
end


-- TODO: define progression and dynamic typing
-- TODO: create tactic to construct proof of progression to a value
-- TODO: create tactic to construct proof of dynamic values for given expression and type
