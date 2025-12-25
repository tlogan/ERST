import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent

set_option pp.fieldNotation false


namespace Lang.Dynamic


mutual
  inductive RecSafe : List (String × Expr) → Prop
  | nil : RecSafe []
  | cons l e r :
    List.is_fresh_key l r → Safe e →
    RecSafe r → RecSafe ((l,e)::r)

  inductive Safe : Expr → Prop
  | convergent e : Convergent e → Safe e
  | iso l body : Safe body → Safe (.iso l body)
  | record r : RecSafe r → Safe (.record r)
  | function f : Safe (.function f)
  | app e e' : Safe e → Safe e' → Safe (.app e e')
  | loop e : Divergent (.loop e) → Safe (.loop e)
end


theorem Safe.subject_reduction :
  Transition e e' →
  Safe e →
  Safe e'
:= by sorry

theorem Safe.subject_expansion :
  Transition e e' →
  Safe e' →
  Safe e
:= by sorry

mutual

  theorem Safe.evalcon_preservation
    (evalcon : EvalCon E)
    (safe_evalcon : Safe (E e))
  : Safe e' → Safe (E e')
  := by cases evalcon with
  | hole =>
    intro h0
    simp
    exact h0
  | iso l econ =>
    intro h0
    simp
    simp at safe_evalcon
    have econ' := EvalCon.iso l econ
    apply Safe.evalcon_preservation econ' safe_evalcon h0
  -- | record : RecordCon R → EvalCon (fun e => .record (R e))
  -- | applicator e' : EvalCon E → EvalCon (fun e => .app (E e) e')
  -- | applicand f : EvalCon E → EvalCon (fun e => .app (.function f) (E e))
  -- | loopy : EvalCon E → EvalCon (fun e => Expr.loop (E e))
  | _ => sorry
  termination_by sizeOf evalcon
  decreasing_by sorry

  -- inductive RecordCon : (Expr → List (String × Expr)) → Prop
  -- | head l r :  EvalCon E → RecordCon (fun e => (l, E e) :: r)
  -- | tail l :
  --     RecordCon R →
  --     Expr.is_value ev →
  --     RecordCon (fun e => (l,ev) :: (R e))

theorem Safe.evalcon_reflection :
  EvalCon E →
  Safe (E e) →
  Safe e
:= by
  sorry

end






end Lang.Dynamic
