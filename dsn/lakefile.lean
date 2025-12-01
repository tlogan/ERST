import Lake
open Lake DSL

package flubber

-- Lean standard library (comes with Lean toolchain)
-- No explicit "require" needed for Lean itself.

-- Std library (std4)
require batteries from git
  "https://github.com/leanprover/std4" @ "v4.23.0"

-- Mathlib4
require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.23.0"

@[default_target]
lean_lib Lang
