import Lang.Basic
import Lang.Dynamic.EvalCon
import Lang.Dynamic.Transition
import Lang.Dynamic.TransitionStar
import Lang.Dynamic.Convergent
import Lang.Dynamic.Divergent
import Lang.Dynamic.FinTyping
import Lang.Dynamic.Typing

set_option pp.fieldNotation false

namespace Lang.Dynamic

def Confluent (a b : Expr) :=
  ∃ e , TransitionStar a e ∧ TransitionStar b e

theorem Confluent.transitivity {a b c} :
  Confluent a b →
  Confluent b c →
  Confluent a c
:= by sorry

theorem Confluent.swap {a b} :
  Confluent a b →
  Confluent b a
:= by sorry

theorem Confluent.app_arg_preservation {a b} f :
  Confluent a b →
  Confluent (.app f a) (.app f b)
:= by sorry

theorem Typing.confluent_preservation {a b am t} :
  Confluent a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Typing.confluent_reflection {a b am t} :
  Confluent a b →
  Typing am b t →
  Typing am a t
:= by
  intro h0 h1
  apply Typing.confluent_preservation
  apply Confluent.swap h0
  exact h1


end Lang.Dynamic
