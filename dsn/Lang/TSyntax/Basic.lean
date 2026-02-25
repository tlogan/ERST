import Lean

namespace Lang

def TSyntax.seq_as_tactic (stx : Lean.TSyntax `tactic.seq) : Lean.TSyntax `tactic :=
  ⟨Lean.TSyntax.raw stx⟩

namespace Lang
