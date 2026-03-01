import Lean
import Mathlib.Tactic.Linarith
-- import Mathlib.Algebra.Group.Basic

import Lang.List.Basic
import Lang.String.Basic
import Lang.ReflTrans.Basic
import Lang.Joinable.Basic
import Lang.Typ.Basic
import Lang.Expr.Basic
import Lang.NStep.Basic
import Lang.Safe.Basic
import Lang.Typing.Basic
import Lang.Typing.Instantiation
import Lang.Typing.Rules

set_option pp.fieldNotation false
set_option eval.pp false

namespace Lang


#eval Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ]

example : NegMonotonic "SELF" [] (.path (.var SELF) .top) := by
  apply NegMonotonic.intro
  apply Monotonic.path_intro
  { simp ; apply Monotonic.positive_var_intro}
  { apply Monotonic.top_intro }

example : Subtyping []
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> <succ> N ])
  (Typ.seal [] [typ| LFP [N] <zero/> | <succ> N ])
:= by
  simp [Typ.seal, List.firstIndexOf, List.indexesOf, List.findIdxs]
  apply @Subtyping.lfp_elim _ "SELF"
  { simp [Typ.wellformed, Typ.instantiated, Typ.num_bound_vars, Typ.nameless] }
  { simp [Typ.free_vars] }
  { simp [Typ.instantiate, Typ.shift_vars]
    apply PosMonotonic.intro
    apply Monotonic.unio_intro
    { apply Monotonic.iso_intro
      apply Monotonic.top_intro
    }
    {
      apply Monotonic.iso_intro
      apply Monotonic.iso_intro
      apply Monotonic.positive_var_intro
    }
  }
  { simp [Typ.instantiate, Typ.shift_vars_zero]
    apply Subtyping.unio_elim
    { sorry }
    { sorry }
  }

end Lang
