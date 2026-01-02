import Lang.Basic
import Lang.Dynamic.NEvalCxt

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
  inductive NStep : Expr → Expr → Prop
  | pattern_match :
    Expr.pattern_match arg p = some m →
    NStep (.app (.function ((p,e) :: f)) arg) (Expr.sub m e)
  | skip :
    arg.is_value →
    Expr.pattern_match arg p = none →
    NStep (.app (.function ((p,e) :: f)) arg) (.app (.function f) arg)
  | erase e t :
    NStep (.anno  e t) e
  | recycle id :
    NStep
      (.loop (.function [(.var id, e)]))
      (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)
  | necxt :
      NEvalCxt E → NStep e e' →
      NStep (E e) (E e')
end

theorem Expr.pattern_match_app_none
  (necxt : NEvalCxt E)
  cator arg p
: (Expr.pattern_match (E (.app cator arg)) p) = Option.none
:= by sorry

theorem Expr.pattern_match_no_app
  (necxt : NEvalCxt E)
: (Expr.pattern_match (E (.app cator arg)) p) ≠ Option.some m
:= by
  intro h0
  have h1 := Expr.pattern_match_app_none necxt cator arg p
  simp [h0] at h1

-- mutual
--   theorem NStep.pattern_match_deterministic
--     (isval : Expr.is_value arg)
--     (matching : Expr.pattern_match v p = some m)
--     (trans : NStep (Expr.app (.function ((p,e) :: f)) arg) e')
--   : e' = (Expr.sub m e)
--   := by sorry

--   theorem NStep.skip_deterministic
--     (isval : v.is_value)
--     (nomatching : Expr.pattern_match v p = none)
--     (trans : NStep (.app (.function ((p,e) :: f)) v) e')
--   : e' = (.app (.function f) v)
--   := by sorry

--   theorem NStep.erase_deterministic
--     (trans : NStep (.anno e t) e')
--   : e' = e
--   := by sorry

--   theorem NStep.recycle_deterministic
--     id
--     (trans : NStep (.loop (.function [(.var id, e)])) e')
--   : e' = (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)
--   := by sorry

--   theorem NStep.necxt_deterministic
--     (necxt : NEvalCxt E)
--     (trans : NStep e e')
--     (trans_necxt : NStep (E e) e'')
--   : e'' = (E e')
--   := by
--     generalize h0 : (E e) = e0 at trans_necxt
--     cases trans_necxt with
--     | pattern_match matching =>
--       cases necxt with
--       | hole =>
--         simp at h0
--         simp
--         sorry
--       | _ => sorry
--     | _ =>
--       sorry
-- end


end Lang.Dynamic
