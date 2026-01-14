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
  inductive NRcdStep : List (String × Expr) → List (String × Expr) → Prop
  | head : List.is_fresh_key l r → NStep e e' →  NRcdStep ((l, e) :: r) ((l, e') :: r)
  | tail : List.is_fresh_key l r → NRcdStep r r' → NRcdStep ((l,ev) :: r) ((l,ev) :: r')

  inductive NStep : Expr → Expr → Prop
  /- head normal forms -/
  | iso : NStep body body' → NStep (.iso l body) (.iso l body')
  | record : NRcdStep r r' →  NStep (.record r) (.record r')

  /- redex forms -/
  | applicator arg : NStep cator cator' → NStep (.app cator arg) (.app cator' arg)
  | applicand cator : NStep arg arg' → NStep (.app cator arg) (.app cator arg')
  | pattern_match body f :
    Expr.pattern_match arg p = some m →
    NStep (.app (.function ((p,body) :: f)) arg) (Expr.sub m body)
  | skip body f:
    arg.is_value →
    Expr.pattern_match arg p = none →
    NStep (.app (.function ((p,body) :: f)) arg) (.app (.function f) arg)
  | erase body t :
    NStep (.anno body t) body
  | loopi : NStep body body' → NStep (.loop body) (.loop body')
  | recycle x e :
    NStep
      (.loop (.function [(.var x, e)]))
      (Expr.sub [(x, (.loop (.function [(.var x, e)])))] e)

end

theorem NStep.not_value :
  NStep e e' → ¬ Expr.is_value e
:= by sorry


theorem NStep.project : NStep (Expr.project (Expr.record [(l, e)]) l) e := by
  unfold Expr.project
  have h0 : Expr.pattern_match
    (Expr.record [(l, e)]) (Pat.record [(l, Pat.var "x")]) = some [("x", e)]
  := by
    simp [Expr.pattern_match, List.pattern_match_record, List.pattern_match_entry]
    rfl
  have h1 : e = Expr.sub [("x", e)] (.var "x") := by exact rfl
  rw [h1]
  apply pattern_match
  exact h0

end Lang.Dynamic
