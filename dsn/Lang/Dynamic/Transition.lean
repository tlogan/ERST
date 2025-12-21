import Lang.Basic

set_option pp.fieldNotation false

namespace Lang.Dynamic

mutual
  def List.pattern_match_entry (label : String) (pat : Pat)
  : List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (Expr.pattern_match e pat)
    else
      List.pattern_match_entry label pat args

  def List.pattern_match_record (args : List (String × Expr))
  : List (String × Pat) → Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.free_vars pat ∩ ListPat.free_vars pats == [] then
      let m0 ← List.pattern_match_entry label pat args
      let m1 ← List.pattern_match_record args pats
      return (m0 ++ m1)
    else
      .none

  def Expr.pattern_match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | (.record r), (.record p) => List.pattern_match_record r p
  | _, _ => none
end

mutual
  def List.pattern_ids : List (String × Pat) → List String
  | .nil => .nil
  | (_, p) :: r =>
    (Pat.ids p) ++ (List.pattern_ids r)

  def Pat.ids : Pat → List String
  | .var id => [id]
  | .iso l body => Pat.ids body
  | .record r => List.pattern_ids r
end


mutual
  def List.record_sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.sub m e) :: (List.record_sub m r)

  def List.function_sub (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := Pat.ids p
    (p, Expr.sub (remove_all m ids) e) :: (List.function_sub m f)

  def Expr.sub (m : List (String × Expr)): Expr → Expr
  | .var id => match (find id m) with
    | .none => (.var id)
    | .some e => e
  | .iso l body => .iso l (Expr.sub m body)
  | .record r => .record (List.record_sub m r)
  | .function f => .function (List.function_sub m f)
  | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
  | .anno e t => .anno (Expr.sub m e) t
  | .loop e => .loop (Expr.sub m e)
end



inductive Transition : Expr → Expr → Prop
| entry l r :
  Transition e e' →
  Transition (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record :
  Transition (Expr.record r) (Expr.record r') →
  v.is_value →
  Transition (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator :
  Transition ef ef' →
  Transition (.app ef e) (.app ef' e)
| applicand f e e' :
  Transition e e' →
  Transition (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  v.is_value →
  Expr.pattern_match v p = some m →
  Transition (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
| appskip :
  v.is_value →
  Expr.pattern_match v p = none →
  Transition (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {e t},
  Transition (.anno  e t) e
| loopbody :
  Transition e e' →
  Transition (.loop e) (.loop e')
| looppeel : ∀ {id e},
  Transition
    (.loop (.function [(.var id, e)]))
    (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)



theorem Transition.deterministic
  (transition : Transition e e')
  (transition' : Transition e e'')
: e' = e''
:= by sorry



end Lang.Dynamic
