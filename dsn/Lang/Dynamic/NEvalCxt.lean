import Mathlib.Tactic.Linarith
import Lang.Basic

set_option pp.fieldNotation false

namespace Lang.Dynamic


mutual
  inductive NRcdCxt : (Expr → List (String × Expr)) → Prop
  | head l r :  NEvalCxt E → NRcdCxt (fun e => (l, E e) :: r)
  | tail l ev :
      List.is_fresh_key l (R e) →
      NRcdCxt R →
      NRcdCxt (fun e => (l,ev) :: (R e))

  inductive NEvalCxt : (Expr → Expr) → Prop
  | hole : NEvalCxt (fun e => e)
  | iso l : NEvalCxt E -> NEvalCxt (fun e => .iso l (E e))
  | record : NRcdCxt R → NEvalCxt (fun e => .record (R e))
  | applicator arg : NEvalCxt E → NEvalCxt (fun e => .app (E e) arg)
  | applicand cator : NEvalCxt E → NEvalCxt (fun e => .app cator (E e))
  | loopy : NEvalCxt E → NEvalCxt (fun e => Expr.loop (E e))
end


theorem NEvalCxt.app_not_value
  e arg
  (necxt : NEvalCxt E)
: ¬ Expr.is_value (E (Expr.app e arg))
:= by sorry



-- mutual
--   theorem NRcdCxt.is_value_complete
--     (rcon : NRcdCxt R)
--     (isrecval : List.is_record_value (R e))
--   : Expr.is_value e
--   := by cases rcon with
--   | head l r necxt =>
--     simp [List.is_record_value] at isrecval

--     have ⟨⟨_,isval⟩,_⟩ := isrecval
--     apply NEvalCxt.is_value_complete necxt isval
--   | tail l rcon' isval =>
--     simp [List.is_record_value] at isrecval
--     have ⟨_,isrecval'⟩ := isrecval
--     apply NRcdCxt.is_value_complete rcon' isrecval'
--   termination_by sizeOf rcon
--   decreasing_by
--     all_goals sorry


--   theorem NEvalCxt.is_value_complete
--     (evalcon : NEvalCxt E)
--     (isval : Expr.is_value (E e))
--   : Expr.is_value e
--   := by cases evalcon with
--   | hole =>
--     reduce at isval
--     exact isval
--   | record recordcon =>
--     reduce at isval
--     exact NRcdCxt.is_value_complete recordcon isval
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


theorem NEvalCxt.extract l
  (evalcon : NEvalCxt E)
: NEvalCxt (fun e => Expr.extract (E e) l)
:= by unfold Expr.extract; cases evalcon with
| hole =>
  simp
  apply NEvalCxt.applicand
  apply NEvalCxt.hole
| iso l necxt =>
  simp
  apply NEvalCxt.applicand
  exact iso l necxt
| record rcon =>
  simp
  apply NEvalCxt.applicand
  exact record rcon
| applicator arg evalcon' =>
  simp
  apply NEvalCxt.applicand
  exact applicator arg evalcon'
| applicand f evalcon' =>
  simp
  apply NEvalCxt.applicand
  exact applicand f evalcon'
| loopy necxt' =>
  simp
  apply NEvalCxt.applicand
  exact loopy necxt'

theorem NEvalCxt.project l
  (evalcon : NEvalCxt E)
: NEvalCxt (fun e => Expr.project (E e) l)
:= by unfold Expr.project; cases evalcon with
| hole =>
  simp
  apply NEvalCxt.applicand
  apply NEvalCxt.hole
| iso l necxt =>
  simp
  apply NEvalCxt.applicand
  exact iso l necxt
| record rcon =>
  simp
  apply NEvalCxt.applicand
  exact record rcon
| applicator arg evalcon' =>
  simp
  apply NEvalCxt.applicand
  exact applicator arg evalcon'
| applicand f evalcon' =>
  simp
  apply NEvalCxt.applicand
  exact applicand f evalcon'
| loopy necxt' =>
  simp
  apply NEvalCxt.applicand
  exact loopy necxt'

end Lang.Dynamic
