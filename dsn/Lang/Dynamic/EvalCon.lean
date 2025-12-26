import Mathlib.Tactic.Linarith
import Lang.Basic

set_option pp.fieldNotation false

namespace Lang.Dynamic


mutual
  inductive RecordCon : (Expr → List (String × Expr)) → Prop
  | head l r :  EvalCon E → RecordCon (fun e => (l, E e) :: r)
  | tail l :
      List.is_fresh_key l (R e) →
      Expr.is_value ev →
      RecordCon R →
      RecordCon (fun e => (l,ev) :: (R e))

  inductive EvalCon : (Expr → Expr) → Prop
  | hole : EvalCon (fun e => e)
  | iso l : EvalCon E -> EvalCon (fun e => .iso l (E e))
  | record : RecordCon R → EvalCon (fun e => .record (R e))
  | applicator e' : EvalCon E → EvalCon (fun e => .app (E e) e')
  | applicand f : EvalCon E → EvalCon (fun e => .app (.function f) (E e))
  | loopy : EvalCon E → EvalCon (fun e => Expr.loop (E e))
end



-- mutual
--   theorem RecordCon.is_value_complete
--     (rcon : RecordCon R)
--     (isrecval : List.is_record_value (R e))
--   : Expr.is_value e
--   := by cases rcon with
--   | head l r econ =>
--     simp [List.is_record_value] at isrecval

--     have ⟨⟨_,isval⟩,_⟩ := isrecval
--     apply EvalCon.is_value_complete econ isval
--   | tail l rcon' isval =>
--     simp [List.is_record_value] at isrecval
--     have ⟨_,isrecval'⟩ := isrecval
--     apply RecordCon.is_value_complete rcon' isrecval'
--   termination_by sizeOf rcon
--   decreasing_by
--     all_goals sorry


--   theorem EvalCon.is_value_complete
--     (evalcon : EvalCon E)
--     (isval : Expr.is_value (E e))
--   : Expr.is_value e
--   := by cases evalcon with
--   | hole =>
--     reduce at isval
--     exact isval
--   | record recordcon =>
--     reduce at isval
--     exact RecordCon.is_value_complete recordcon isval
--   | applicator arg evalcon' =>
--     reduce at isval
--     simp at isval
--   | applicand f evalcon' =>
--     reduce at isval
--     simp at isval
--   | loopy evalcon' =>
--     reduce at isval
--     simp at isval
--   termination_by sizeOf evalcon
--   decreasing_by
--     all_goals sorry
-- end


theorem EvalCon.extract l
  (evalcon : EvalCon E)
: EvalCon (fun e => Expr.extract (E e) l)
:= by unfold Expr.extract; cases evalcon with
| hole =>
  simp
  apply EvalCon.applicand
  apply EvalCon.hole
| iso l econ =>
  simp
  apply EvalCon.applicand
  exact iso l econ
| record rcon =>
  simp
  apply EvalCon.applicand
  exact record rcon
| applicator arg evalcon' =>
  simp
  apply EvalCon.applicand
  exact applicator arg evalcon'
| applicand f evalcon' =>
  simp
  apply EvalCon.applicand
  exact applicand f evalcon'
| loopy econ' =>
  simp
  apply EvalCon.applicand
  exact loopy econ'

theorem EvalCon.project l
  (evalcon : EvalCon E)
: EvalCon (fun e => Expr.project (E e) l)
:= by unfold Expr.project; cases evalcon with
| hole =>
  simp
  apply EvalCon.applicand
  apply EvalCon.hole
| iso l econ =>
  simp
  apply EvalCon.applicand
  exact iso l econ
| record rcon =>
  simp
  apply EvalCon.applicand
  exact record rcon
| applicator arg evalcon' =>
  simp
  apply EvalCon.applicand
  exact applicator arg evalcon'
| applicand f evalcon' =>
  simp
  apply EvalCon.applicand
  exact applicand f evalcon'
| loopy econ' =>
  simp
  apply EvalCon.applicand
  exact loopy econ'

end Lang.Dynamic
