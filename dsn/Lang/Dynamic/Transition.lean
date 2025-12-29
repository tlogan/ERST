import Lang.Basic
import Lang.Dynamic.EvalCon

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
  | (.iso l e), (.iso label p) =>
    if l == label then
      Expr.pattern_match e p
    else
      none
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



mutual
  inductive Transition : Expr → Expr → Prop
  | pattern_match :
    v.is_value →
    Expr.pattern_match v p = some m →
    Transition (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
  | skip :
    v.is_value →
    Expr.pattern_match v p = none →
    Transition (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
  | erase : ∀ {e t},
    Transition (.anno  e t) e
  | recycle id :
    Transition
      (.loop (.function [(.var id, e)]))
      (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)
  | econ :
      EvalCon E → Transition e e' →
      Transition (E e) (E e')
end


mutual
  theorem Transition.pattern_match_deterministic
    (isval : Expr.is_value arg)
    (matching : Expr.pattern_match v p = some m)
    (trans : Transition (Expr.app (.function ((p,e) :: f)) arg) e')
  : e' = (Expr.sub m e)
  := by sorry

  theorem Transition.skip_deterministic
    (isval : v.is_value)
    (nomatching : Expr.pattern_match v p = none)
    (trans : Transition (.app (.function ((p,e) :: f)) v) e')
  : e' = (.app (.function f) v)
  := by sorry

  theorem Transition.erase_deterministic
    (trans : Transition (.anno e t) e')
  : e' = e
  := by sorry

  theorem Transition.recycle_deterministic
    id
    (trans : Transition (.loop (.function [(.var id, e)])) e')
  : e' = (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)
  := by sorry

  theorem Transition.econ_deterministic
    (econ : EvalCon E)
    (trans : Transition e e')
    (trans_econ : Transition (E e) e'')
  : e'' = (E e')
  := by
    generalize h0 : (E e) = e0 at trans_econ
    cases trans_econ with
    | pattern_match isval matching =>
      cases econ with
      | hole =>
        simp at h0
        simp
        sorry
      | _ => sorry
    | _ =>
      sorry
end







theorem Transition.deterministic
  (transition : Transition e e')
  (transition' : Transition e e'')
: e' = e''
:= by sorry



end Lang.Dynamic
