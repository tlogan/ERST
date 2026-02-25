import Lean
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

namespace Lang


def Lean.Parser.parse (cat : Lean.Name) (str : String) : Lean.CoreM (Lean.TSyntax cat) := do
  let env ← Lean.getEnv
  match Lean.Parser.runParserCategory env cat str with
  | .ok stx => return Lean.TSyntax.mk stx
  | .error err => throwError err

end Lang
