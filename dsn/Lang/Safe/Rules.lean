import Lean

import Lang.List.Basic
import Lang.String.Basic
import Lang.ReflTrans.Basic
import Lang.Joinable.Basic
import Lang.Typ.Basic
import Lang.Expr.Basic
import Lang.NStep.Basic
import Lang.Safe.Basic

set_option pp.fieldNotation false


namespace Lang

theorem Safe.iso_intro l :
  Safe e → Safe (Expr.iso l e)
:= by sorry

end Lang
