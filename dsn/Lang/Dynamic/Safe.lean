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


theorem Safe.convergent_swap
  (econ : EvalCon E)
  (safe_econ : Safe (E e))
  (cvg : Convergent e')
: Safe (E e')
:= by sorry

theorem Safe.econ_swap
  (econ : EvalCon E)
  (econ' : EvalCon E')
  (safe : Safe (E (E' e)))
: Safe (E' (E e))
:= by sorry

mutual

  theorem Safe.rcon_preservation
    (rcon : RecordCon R)
    (safe_econ : Safe (.record (R e)))
  : Safe e' → Safe (.record (R e'))
  := by sorry

  -- inductive RecSafe : List (String × Expr) → Prop
  -- | nil : RecSafe []
  -- | cons l e r :
  --   List.is_fresh_key l r → Safe e →
  --   RecSafe r → RecSafe ((l,e)::r)

  theorem Safe.econ_preservation
    (econ : EvalCon E)
    (safe_econ : Safe (E e))
    (safe : Safe e')
  : Safe (E e')
  /- TODO : induct on safe -/
  := by cases safe with
  | convergent e cvg =>
    exact convergent_swap econ safe_econ cvg
  | iso l body safe_body =>
    have econ' := EvalCon.iso l .hole
    apply Safe.econ_swap econ' econ
    apply Safe.iso l (E body)
    apply Safe.econ_preservation econ safe_econ safe_body
    -- : Safe body → Safe (.iso l body)
  -- | record r : RecSafe r → Safe (.record r)
  -- | function f : Safe (.function f)
  -- | app e e' : Safe e → Safe e' → Safe (.app e e')
  -- | loop e : Divergent (.loop e) → Safe (.loop e)
  | _ => sorry

theorem Safe.econ_reflection :
  EvalCon E →
  Safe (E e) →
  Safe e
:= by
  sorry

end






end Lang.Dynamic
