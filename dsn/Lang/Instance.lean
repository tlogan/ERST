import Lang.Util
import Lang.Basic
import Lang.Static

set_option pp.fieldNotation false

#check [expr| @]

#check [eid| x]

#check [expr| x]

#check [expr| uno.dos.tres]

#check [expr| [x => @]]

#check [expr| [x => x.uno]]

#check [expr| (uno;@).uno]

#check [expr| def x = @ in x]

#check [expr| [<uno> x => x]]



#eval [typ| <uno/> & <dos/>]

#eval [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R) ]


example : Typ.Monotonic "a" .true (.entry "uno" (.entry "dos" (.var "a"))) := by
  Typ_Monotonic_prove

example : Typ.Monotonic "a" .true (.path .bot (.inter .bot (.var "a"))) := by
  Typ_Monotonic_prove


example : Typ.Monotonic "a" .true (.exi ["G"] [] (.var "G")) := by
  Typ_Monotonic_prove

example : Typ.Monotonic "a" .true (.path .bot (.inter .top (.var "a"))) := by
  Typ_Monotonic_prove
  -- repeat (constructor; try simp)

-- example : Typ.Monotonic "a" .true (.path (.inter .unit (.var "a")) .bot) := by
--   Typ_Monotonic_prove

example : Typ.Monotonic "a" .false (.path (.inter .bot (.var "a")) .bot) := by
  Typ_Monotonic_prove

example : Typ.Monotonic "a" .false (.path (.inter .top (.var "a")) .top) := by
  Typ_Monotonic_prove


example : (if ("hello" == "hello") = true then 1 else 2) = 1 := by
  simp

example : ∃ ts , ListSubtyping.bounds "R" .true .nil = ts := by
  exists .nil


example : ListSubtyping.bounds "R" .true
  [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
  =
  [typs| (<succ> G010) (<succ> <succ> G010)]
:= by rfl

example : ∃ ts , ListSubtyping.bounds "R" .true
  [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
  = ts
:= by exists [typs| (<succ> G010) (<succ> <succ> G010) ]


example : Typ.UpperFounded "R"
  [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
  [typ| G010 | <succ> R | <succ> <succ> R ]
:= by Typ_UpperFounded_prove


example : ¬ Subtyping.check [] [] [typ| <dos/> ] [typ| <uno/>] := by
  simp [Subtyping.check]; rfl

example Δ Γ
: PatLifting.Static Δ Γ [pattern| x]
  [typ| X] -- (Typ.var "X")
  ((Typ.var "X", Typ.top) :: Δ)
  (("x", Typ.var "X") :: (remove "x" Γ))
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ .unit Typ.top Δ Γ
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ (.record [])
  Typ.top
  Δ
  Γ
:= by
  PatLifting_Static_prove


example Δ Γ
: PatLifting.Static Δ Γ
  [pattern| <dos/>]
  [typ| <dos/>]
  Δ Γ
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ
  [pattern| <uno/> <dos/>]
  [typ| <uno/> & <dos/>]
  Δ Γ
:= by
  PatLifting_Static_prove

#eval PatLifting.Static.compute [] [] [pattern| <uno> x <dos> y]
example :  ∃ t Δ' Γ', PatLifting.Static [] []
  [pattern| <uno> x <dos> y] t Δ' Γ' := by
  exists [typ| <uno> T669 & <dos> T670 ]
  exists [subtypings| (T670 <: TOP) (T669 <: TOP) ]
  exists [typings| (y : T670) (x : T669) ]
  PatLifting_Static_prove


---------------------------------------
----- reflexivity
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| <uno/>]

example : StaticSubtyping
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| <uno/>]
  [ids| ] [subtypings|  ]
:= by StaticSubtyping_prove


---------------------------------------
----- entry preservation (over union)
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| <label> <uno/> ]
  [typ| <label> (<uno/> | <dos/>) ]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| <label> <uno/> ]
  [typ| <label> (<uno/> | <dos/>) ]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- implication preservation (over union)
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| (<uno/> | <dos/>) -> <tres/> ]
  [typ| <uno/>  -> (<dos/> | <tres/>)]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| (<uno/> | <dos/>) -> <tres/> ]
  [typ| <uno/>  -> (<dos/> | <tres/>)]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- implication preservation (over intersection)
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> -> (<dos/> & <tres/>)]
  [typ| (<uno/> & <dos/>) -> <tres/>]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| <uno/> -> (<dos/> & <tres/>)]
  [typ| (<uno/> & <dos/>) -> <tres/>]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- union elim
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
  [typ| <uno/> ]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
  [typ| <uno/> ]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- existential elim
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| EXI[T] [(T <: <uno/>)] T]
  [typ| <uno/> | <dos/>]

#eval Typ.interpret_one "T" .true []

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| EXI[T] [(T <: <uno/>)] T]
  [typ| <uno/> | <dos/>]
  [ids| T] [subtypings| (T <: <uno/>)]
-- := by StaticSubtyping_prove
:= by
  apply StaticSubtyping.exi_elim
  · rfl
  · StaticListSubtyping_prove
  · StaticSubtyping_prove

---------------------------------------
----- intersection intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> ]
  [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| <uno/> ]
  [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- universal intro
---------------------------------------

#eval Subtyping.restricted [] [] [typ| <uno/>] [typ| T]

#eval StaticSubtyping.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> & <dos/>]
  [typ| ALL[T] [(<uno/> <: T)] T]

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| <uno/> & <dos/>]
  [typ| ALL[T] [(<uno/> <: T)] T]
  [ids| T] [subtypings| (<uno/> <: T)]
:= by StaticSubtyping_prove

---------------------------------------
----- placeholder elim
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings| (<uno/> & <dos/> <: T) (T <: <uno/>)]
  [typ| T]
  [typ| <dos/>]

example : StaticSubtyping
  [ids| ] [subtypings| (<uno/> & <dos/> <: T) (T <: <uno/>)]
  [typ| T]
  [typ| <dos/>]
  [ids| ] [subtypings| (T <: <dos/>) (<uno/> & <dos/> <: T) (T <: <uno/>)]
:= by StaticSubtyping_prove

---------------------------------------
----- placeholder intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings| (<uno/> <: T) (T <: <uno/> | <dos/>)]
  [typ| <dos/>]
  [typ| T]

example : StaticSubtyping
  [ids| ] [subtypings| (<uno/> <: T) (T <: <uno/> | <dos/>)]
  [typ| <dos/>]
  [typ| T]
  [ids| ] [subtypings| (<dos/> <: T) (<uno/> <: T) (T <: <uno/> | <dos/>)]
:= by StaticSubtyping_prove

---------------------------------------
----- skolem placeholder intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| (X <: T)]
  [typ| <uno/>]
  [typ| T]


example : StaticSubtyping
  [ids| T] [subtypings| (X <: T)]
  [typ| <uno/>]
  [typ| T]
  [ids| T] [subtypings| (<uno/> <: T) (X <: T)]
:= by StaticSubtyping_prove

---------------------------------------
----- skolem placeholder elim
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| (T <: X)]
  [typ| T]
  [typ| <uno/>]

example : StaticSubtyping
  [ids| T] [subtypings| (T <: X)]
  [typ| T]
  [typ| <uno/>]
  [ids| T] [subtypings| (T <: <uno/>) (T <: X)]
:= by StaticSubtyping_prove

---------------------------------------
----- skolem elim
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| (T <: <uno/>) ]
  [typ| T]
  [typ| <uno/> | <dos/>]

example : StaticSubtyping
  [ids| T] [subtypings| (T <: <uno/>) ]
  [typ| T]
  [typ| <uno/> | <dos/>]
  [ids| T ] [subtypings| (T <: <uno/>) ]
:= by StaticSubtyping_prove

---------------------------------------
----- skolem intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| ( <uno/> <: T) ]
  [typ| <uno/> & <dos/>]
  [typ| T]

example : StaticSubtyping
  [ids| T] [subtypings| (<uno/> <: T) ]
  [typ| <uno/> & <dos/>]
  [typ| T]
  [ids| T] [subtypings| (<uno/> <: T) ]
:= by StaticSubtyping_prove

---------------------------------------
----- union antecedent
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
  [typ| <uno/> | <dos/> -> <tres/>]

example : StaticSubtyping
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
  [typ| <uno/> | <dos/> -> <tres/>]
  [ids| T] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- inter consequent
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
  [typ| <uno/> -> <dos/> & <tres/>]

example : StaticSubtyping
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
  [typ| <uno/> -> <dos/> & <tres/>]
  [ids| T] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- entry inter content
---------------------------------------

#eval StaticSubtyping.solve
  [ids| T] [subtypings| ]
  [typ| <label> <uno/> & (<label> <dos/>)]
  [typ| <label> (<uno/> & <dos/>)]

example : StaticSubtyping
  [ids| T] [subtypings| ]
  [typ| <label> <uno/> & (<label> <dos/>)]
  [typ| <label> (<uno/> & <dos/>)]
  [ids| T] [subtypings| ]
:= by StaticSubtyping_prove


---------------------------------------
----- lfp factor elim
---------------------------------------

-- #eval (match [typ| (<zero/> * <nil/>)] with
-- | .inter l r => Option.some l
-- | _ => Option.none

-- )
-- #eval [typ| (<left> <zero/> & <right> <nil/>)]

-- #eval  [typ| (<zero/> * <nil/>) | (<uno/> * <dos/>)]
-- #eval Typ.factor "R"
--   [typ|(
--       (<zero/> * <nil/>) |
--       EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
--   )]
--   "left"


-- #eval Typ.Monotonic.decide "R" .true [typ| (<zero/> | EXI[N] [ (N <: R) ] <succ> N)]
-- #eval StaticSubtyping.solve [] []
--   [typ| LFP[R] (<zero/> | EXI[N] [ (N <: R) ] <succ> N) ]
--   [typ| LFP[R] (<zero/> | <succ> R) ]


-- #eval (Typ.sub [("R", [typ| LFP[R] (<zero/> | <succ> R) ])]
--   [typ| (<zero/> | EXI[N] [ (N <: R) ] <succ> N) ])

-- #eval StaticSubtyping.solve [] []
--   [typ| (<zero/> | EXI[N] [ (N <: (LFP[R] (<zero/> | <succ> R))) ] <succ> N) ]
--   [typ| LFP[R] (<zero/> | <succ> R) ]

#eval StaticSubtyping.solve
  [ids| ] [subtypings| ]
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  -- [typ| <left> LFP[R] (<zero/> | EXI[N] [ (N <: R) ] <succ> N) ]
  [typ| <left> LFP[R] (<zero/> | <succ> R) ]


-- #eval Subtyping.inflatable
--   [typ| EXI[N] [ (N <: R) ] <succ> N ]
--   [typ| <zero/> | <succ> R ]

-- #eval Typ.break .false [typ| <zero/> | <succ> R ]

-- #eval Subtyping.shallow_match
--   [typ| EXI[N] [ (N <: R) ] <succ> N ]
--   [typ| <zero/> ]

#eval (Typ.exi ["N"] [(Typ.var "N", Typ.var "R")] (Typ.entry "succ" (Typ.var "N")))

#eval (Typ.unio (Typ.entry "zero" Typ.top)
    (Typ.entry "succ" (Typ.lfp "R" (Typ.unio (Typ.entry "zero" Typ.top) (Typ.entry "succ" (Typ.var "R"))))))

example : StaticSubtyping [] []
  [typ| <succ> R]
  [typ| <succ> LFP[R] <zero/> | <succ> R ]
  [] [subtypings| (R <: LFP[R] <zero/> | <succ> R)]
:= by StaticSubtyping_prove

#eval StaticSubtyping.solve [] []
  [typ| EXI[N] [ (N <: R) ] <succ> N ]
  [typ| <succ> LFP[R] <zero/> | <succ> R ]

example : StaticSubtyping [] []
  [typ| EXI[N] [ (N <: R) ] N ]
  [typ| <whatev/> ]
  [ids| N] [subtypings| (N <: <whatev/>) (N <: R)]
-- := by StaticSubtyping_prove
:= by
  apply StaticSubtyping.exi_elim
  · reduce; rfl
  · StaticListSubtyping_prove
  · apply StaticSubtyping.skolem_placeholder_elim
    · apply List.Mem.head
    · sorry -- consider upper_bound_mem/lower_bound_mem and use of existential
    · apply lower_bound_map
      · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
    · StaticListSubtyping_prove



example : StaticSubtyping [] []
  [typ| <zero/> | EXI[N] [ (N <: R) ] <succ> N ]
  [typ| LFP[R] <zero/> | <succ> R ]
  -- [typ| LFP[R] <zero/> | EXI[N] [ (N <: R) ] <succ> N ]
  [] []
:= by
  apply StaticSubtyping.unio_elim
  · apply StaticSubtyping.lfp_inflate_intro
    · simp [Subtyping.inflatable, Typ.break, Subtyping.shallow_match]
    · simp [Typ.sub, find] ; StaticSubtyping_prove
  · apply StaticSubtyping.lfp_inflate_intro
    · simp [Subtyping.inflatable, Typ.break, Subtyping.shallow_match]
    · simp [Typ.sub, find] ; reduce; StaticSubtyping_prove


example : StaticSubtyping
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  [typ| <left> LFP[R] (<zero/> | EXI[N] [ (N <: R) ] <succ> N) ]
  -- [typ| <left> LFP[R] (<zero/> | <succ> R) ]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove
-- := by
--   apply StaticSubtyping.lfp_factor_elim
--   · rfl
--   · reduce


--------------------------------------------

-- TODO: more subtyping instances
-- TODO: lfp elim instances

---------------------------------------
----- lfp diff
---------------------------------------

#eval StaticSubtyping.solve
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <zero/>]

--- if x is an even number then x ≠ 1
example : StaticSubtyping
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

--- if x is an even number then x ≠ 3
example : StaticSubtyping
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <succ> <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- diff intro
---------------------------------------

example : StaticSubtyping
  [] []
  [typ|(<zero/>) | (<succ> <succ> (TOP \ <succ> <zero/>))]
  [typ| TOP \ <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by StaticSubtyping_prove

---------------------------------------
----- least fixed point inflate intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings| ]
  [typ| <succ> <succ> <zero/>]
  [typ| LFP[R] <zero/> | <succ> R ]

example : StaticSubtyping
  [ids| ] [subtypings| ]
  [typ| <succ> <succ> <zero/>]
  [typ| LFP[R] <zero/> | <succ> R ]
  [ids| ] [subtypings|  ]
:= by StaticSubtyping_prove

---------------------------------------
----- existential intro
---------------------------------------

#eval StaticSubtyping.solve
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| EXI[T] [(T <: <uno/>)] T ]

example : StaticSubtyping
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| EXI[T] [(T <: <uno/>)] T ]
  [ids| ] [subtypings| (T33 <: <uno/>) (<uno/> <: T33) ]
:= by
  StaticSubtyping_rename_right [typ| EXI[T33] [(T33 <: <uno/>)] T33 ]
  StaticSubtyping_prove
