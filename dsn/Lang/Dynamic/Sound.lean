import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent

set_option pp.fieldNotation false


namespace Lang.Dynamic


mutual
  inductive RecSound : List (String × Expr) → Prop
  | nil : RecSound []
  | cons l e r :
    List.is_fresh_key l r → Sound e →
    RecSound r → RecSound ((l,e)::r)

  inductive Sound : Expr → Prop
  | convergent e : Convergent e → Sound e
  | iso l body : Sound body → Sound (.iso l body)
  | record r : RecSound r → Sound (.record r)
  | function f : Sound (.function f)
  | app e e' : Sound e → Sound e' → Sound (.app e e')
  | loop e : Divergent (.loop e) → Sound (.loop e)
end


theorem Sound.subject_reduction :
  Transition e e' →
  Sound e →
  Sound e'
:= by sorry

theorem Sound.subject_expansion :
  Transition e e' →
  Sound e' →
  Sound e
:= by sorry



theorem Sound.evalcon_reflection :
  EvalCon E →
  Sound (E e) →
  Sound e
:= by
  sorry

theorem Sound.evalcon_preservation :
  EvalCon E → Sound (E e) →
  Sound e' → Sound (E e')
:= by sorry


end Lang.Dynamic
