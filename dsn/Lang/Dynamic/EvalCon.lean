import Lang.Basic
import Lang.Dynamic.Transition

set_option pp.fieldNotation false

namespace Lang.Dynamic


mutual
  inductive RecordCon : (Expr → List (String × Expr)) → Prop
  | head l r :  EvalCon E → RecordCon (fun e => (l, E e) :: r)
  | tail l :
      RecordCon R →
      Expr.is_value ev →
      RecordCon (fun e => (l,ev) :: (R e))

  inductive EvalCon : (Expr → Expr) → Prop
  | hole : EvalCon (fun e => e)
  | record : RecordCon R → EvalCon (fun e => .record (R e))
  | applicator e' : EvalCon E → EvalCon (fun e => .app (E e) e')
  | applicand f : EvalCon E → EvalCon (fun e => .app (.function f) (E e))
end


theorem EvalCon.soundness
  (evalcon : EvalCon E)
  (transition : Transition e e')
: Transition (E e) (E e')
:= by sorry
-- by induction evalcon with
-- | hole =>
--   simp
--   exact transition
-- | record _ =>
--   sorry
-- | applicator arg evalcon' ih =>
--   simp
--   apply Transition.applicator
--   exact ih
-- | applicand f evalcon' ih =>
--   simp
--   apply Transition.applicand
--   exact ih



theorem EvalCon.is_value_determines_hole
  (evalcon : EvalCon E)
  (isval : Expr.is_value (E e))
: E = (fun x => x)
:= by sorry
-- by cases evalcon with
-- | hole =>
--   simp
-- | applicator arg evalcon' =>
--   reduce at isval
--   simp at isval
-- | applicand f evalcon' =>
--   reduce at isval
--   simp at isval


theorem EvalCon.extract l
  (evalcon : EvalCon E)
: EvalCon (fun e => Expr.extract (E e) l)
:= by sorry
-- by unfold Expr.extract; cases evalcon with
-- | hole =>
--   simp
--   apply EvalCon.applicand
--   apply EvalCon.hole
-- | applicator arg evalcon' =>
--   simp
--   apply EvalCon.applicand
--   exact applicator arg evalcon'
-- | applicand f evalcon' =>
--   simp
--   apply EvalCon.applicand
--   exact applicand f evalcon'

theorem EvalCon.project l
  (evalcon : EvalCon E)
: EvalCon (fun e => Expr.project (E e) l)
:= by sorry
-- by unfold Expr.project; cases evalcon with
-- | hole =>
--   simp
--   apply EvalCon.applicand
--   apply EvalCon.hole
-- | applicator arg evalcon' =>
--   simp
--   apply EvalCon.applicand
--   exact applicator arg evalcon'
-- | applicand f evalcon' =>
--   simp
--   apply EvalCon.applicand
--   exact applicand f evalcon'








end Lang.Dynamic
