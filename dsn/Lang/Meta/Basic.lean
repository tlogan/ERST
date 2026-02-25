import Lean

import Lang.TSyntax.Basic

set_option pp.fieldNotation false

namespace Lang


def mk_witness_tactic
  (extract_inputs : Lean.Expr → List Lean.Expr)
  (construct_outputs : (List Lean.Expr) → (Lean.MetaM (List Lean.Term)))
: Lean.Elab.Tactic.TacticM Unit
:=
  Lean.Elab.Tactic.withMainContext do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let goalDecl ← goal.getDecl
    let goalType := goalDecl.type
    let inputs := extract_inputs goalType
    -- for input in inputs do
    --   dbg_trace f!"INPUT::: {repr input}"

    let outputs ← (construct_outputs inputs)

    let mut exists_tact ← `(tactic| skip)
    for output in outputs do
      -- dbg_trace f!"OUTPUT::: {repr output}"
      exists_tact := TSyntax.seq_as_tactic (← `(tactic| $exists_tact ; exists $output))

    -- dbg_trace f!"EXISTS TACT::: {Lean.Syntax.prettyPrint exists_tact}"

    Lean.Elab.Tactic.evalTactic (← `(tactic| $exists_tact))


end Lang
