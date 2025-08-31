import Lang.Basic

-- import Mathlib.Data.Set.Basic
-- import Mathlib.Data.List.Basic
import Mathlib.Tactic.Linarith

#check Lean.mkFreshId
def fresh_string {m : Type → Type} [Monad m] [Lean.MonadNameGenerator m] : m String :=
  do
  let raw := (← Lean.mkFreshId).toString
  let content :=  "X" ++ raw.drop ("_uniq.".length + 3)
  return content

def Lean.Parser.parse (cat : Lean.Name) (str : String) : Lean.CoreM (Lean.TSyntax cat) := do
  let env ← Lean.getEnv
  match Lean.Parser.runParserCategory env cat str with
  | .ok stx => return Lean.TSyntax.mk stx
  | .error err => throwError err

def seq_as_tactic (stx : Lean.TSyntax `tactic.seq) : Lean.TSyntax `tactic :=
  ⟨Lean.TSyntax.raw stx⟩

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
      exists_tact := seq_as_tactic (← `(tactic| $exists_tact ; exists $output))

    -- dbg_trace f!"EXISTS TACT::: {Lean.Syntax.prettyPrint exists_tact}"

    Lean.Elab.Tactic.evalTactic (← `(tactic| $exists_tact))
