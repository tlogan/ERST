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
: PatLifting.Static Δ Γ .unit .unit Δ Γ
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

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| <uno/>]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| <uno/>]
  [ids| ] [subtypings|  ]
:= by Subtyping_Static_prove


---------------------------------------
----- entry preservation (over union)
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| <label> <uno/> ]
  [typ| <label> (<uno/> | <dos/>) ]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| <label> <uno/> ]
  [typ| <label> (<uno/> | <dos/>) ]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- implication preservation (over union)
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| (<uno/> | <dos/>) -> <tres/> ]
  [typ| <uno/>  -> (<dos/> | <tres/>)]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| (<uno/> | <dos/>) -> <tres/> ]
  [typ| <uno/>  -> (<dos/> | <tres/>)]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- implication preservation (over intersection)
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> -> (<dos/> & <tres/>)]
  [typ| (<uno/> & <dos/>) -> <tres/>]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| <uno/> -> (<dos/> & <tres/>)]
  [typ| (<uno/> & <dos/>) -> <tres/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- union elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
  [typ| <uno/> ]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
  [typ| <uno/> ]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- existential elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| EXI[T] [(T <: <uno/>)] T]
  [typ| <uno/> | <dos/>]

#eval Typ.interpret_one "T" .true []

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| EXI[T] [(T <: <uno/>)] T]
  [typ| <uno/> | <dos/>]
  [ids| T] [subtypings| (T <: <uno/>)]
:= by Subtyping_Static_prove

---------------------------------------
----- existential skolem placeholder elim
---------------------------------------

example : Subtyping.Static [] []
  [typ| EXI[N] [ (N <: R) ] N ]
  [typ| <whatev/> ]
  [ids| N] [subtypings| (N <: <whatev/>) (N <: R)]
:= by Subtyping_Static_prove

---------------------------------------
----- intersection intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> ]
  [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| <uno/> ]
  [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- universal intro
---------------------------------------

#eval Subtyping.restricted [] [] [typ| <uno/>] [typ| T]

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| <uno/> & <dos/>]
  [typ| ALL[T] [(<uno/> <: T)] T]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| <uno/> & <dos/>]
  [typ| ALL[T] [(<uno/> <: T)] T]
  [ids| T] [subtypings| (<uno/> <: T)]
:= by Subtyping_Static_prove

---------------------------------------
----- placeholder elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| (<uno/> & <dos/> <: T) (T <: <uno/>)]
  [typ| T]
  [typ| <dos/>]

example : Subtyping.Static
  [ids| ] [subtypings| (<uno/> & <dos/> <: T) (T <: <uno/>)]
  [typ| T]
  [typ| <dos/>]
  [ids| ] [subtypings| (T <: <dos/>) (<uno/> & <dos/> <: T) (T <: <uno/>)]
:= by Subtyping_Static_prove

---------------------------------------
----- placeholder intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| (<uno/> <: T) (T <: <uno/> | <dos/>)]
  [typ| <dos/>]
  [typ| T]

example : Subtyping.Static
  [ids| ] [subtypings| (<uno/> <: T) (T <: <uno/> | <dos/>)]
  [typ| <dos/>]
  [typ| T]
  [ids| ] [subtypings| (<dos/> <: T) (<uno/> <: T) (T <: <uno/> | <dos/>)]
:= by Subtyping_Static_prove

---------------------------------------
----- skolem placeholder intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| (X <: T)]
  [typ| <uno/>]
  [typ| T]


example : Subtyping.Static
  [ids| T] [subtypings| (X <: T)]
  [typ| <uno/>]
  [typ| T]
  [ids| T] [subtypings| (<uno/> <: T) (X <: T)]
:= by Subtyping_Static_prove

---------------------------------------
----- skolem placeholder elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| (T <: X)]
  [typ| T]
  [typ| <uno/>]

example : Subtyping.Static
  [ids| T] [subtypings| (T <: X)]
  [typ| T]
  [typ| <uno/>]
  [ids| T] [subtypings| (T <: <uno/>) (T <: X)]
:= by Subtyping_Static_prove

---------------------------------------
----- skolem elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| (T <: <uno/>) ]
  [typ| T]
  [typ| <uno/> | <dos/>]

example : Subtyping.Static
  [ids| T] [subtypings| (T <: <uno/>) ]
  [typ| T]
  [typ| <uno/> | <dos/>]
  [ids| T ] [subtypings| (T <: <uno/>) ]
:= by Subtyping_Static_prove

---------------------------------------
----- skolem intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| ( <uno/> <: T) ]
  [typ| <uno/> & <dos/>]
  [typ| T]

example : Subtyping.Static
  [ids| T] [subtypings| (<uno/> <: T) ]
  [typ| <uno/> & <dos/>]
  [typ| T]
  [ids| T] [subtypings| (<uno/> <: T) ]
:= by Subtyping_Static_prove

---------------------------------------
----- union antecedent
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
  [typ| <uno/> | <dos/> -> <tres/>]

example : Subtyping.Static
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
  [typ| <uno/> | <dos/> -> <tres/>]
  [ids| T] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- inter consequent
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
  [typ| <uno/> -> <dos/> & <tres/>]

example : Subtyping.Static
  [ids| T] [subtypings| ]
  [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
  [typ| <uno/> -> <dos/> & <tres/>]
  [ids| T] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- entry inter content
---------------------------------------

#eval Subtyping.Static.solve
  [ids| T] [subtypings| ]
  [typ| <label> <uno/> & (<label> <dos/>)]
  [typ| <label> (<uno/> & <dos/>)]

example : Subtyping.Static
  [ids| T] [subtypings| ]
  [typ| <label> <uno/> & (<label> <dos/>)]
  [typ| <label> (<uno/> & <dos/>)]
  [ids| T] [subtypings| ]
:= by Subtyping_Static_prove


---------------------------------------
----- lfp factor elim
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  [typ| <left> LFP[R] (<zero/> | <succ> R) ]


example : Subtyping.Static
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  [typ| <left> LFP[R] (<zero/> | <succ> R) ]
  [ids| N ] [subtypings| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
:= by Subtyping_Static_prove

---------------------------------------
----- lfp skip elim
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] <uno/> | <dos/>]
  [typ| <uno/> | <dos/> | <tres/>]

example : Subtyping.Static
  [] []
  [typ| LFP[R] <uno/> | <dos/>]
  [typ| <uno/> | <dos/> | <tres/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove
-- := by
--   apply Subtyping.Static.lfp_skip_elim
--   · exact Iff.mp List.count_eq_zero rfl
--   · Subtyping_Static_prove

---------------------------------------
----- lfp induct elim
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| LFP[R] ((<zero/>) | (<succ> R))]

example : Subtyping.Static
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| LFP[R] ((<zero/>) | (<succ> R))]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove
-- := by
--   apply Subtyping.Static.lfp_induct_elim
--   · Typ_Monotonic_prove
--   · reduce; Subtyping_Static_prove

---------------------------------------
----- lfp elim diff intro
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <zero/>]

--- if x is an even number then x ≠ 1
example : Subtyping.Static
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

--- if x is an even number then x ≠ 3
example : Subtyping.Static
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <succ> <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- diff intro
---------------------------------------

example : Subtyping.Static
  [] []
  [typ|(<zero/>) | (<succ> <succ> (TOP \ <succ> <zero/>))]
  [typ| TOP \ <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- least fixed point inflate intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <succ> <succ> <zero/>]
  [typ| LFP[R] <zero/> | <succ> R ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <succ> <succ> <zero/>]
  [typ| LFP[R] <zero/> | <succ> R ]
  [ids| ] [subtypings|  ]
:= by Subtyping_Static_prove

---------------------------------------
----- least fixed point drop intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <zero/>]
  [typ| LFP[R] <zero/> | (R -> <uno/>) ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <zero/>]
  [typ| LFP[R] <zero/> | (R -> <uno/>) ]
  [ids| ] [subtypings|  ]
:= by Subtyping_Static_prove

---------------------------------------
----- diff elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| (<uno/> | <dos/>) \ <dos/>]
  [typ| <uno/> ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| (<uno/> | <dos/>) \ <dos/>]
  [typ| <uno/> ]
  [ids| ] [subtypings|  ]
:= by Subtyping_Static_prove

---------------------------------------
----- union left intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <uno/> ]
  [typ| <uno/> | <dos/>]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <uno/> ]
  [typ| <uno/> | <dos/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- union right intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <dos/> ]
  [typ| <uno/> | <dos/>]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <dos/> ]
  [typ| <uno/> | <dos/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- existential intro
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| EXI[T] [(T <: <uno/>)] T ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <uno/>]
  [typ| EXI[T] [(T33 <: <uno/>)] T33]
  [ids| ] [subtypings| (T33 <: <uno/>) (<uno/> <: T33) ]
:= by
  Subtyping_Static_prove

---------------------------------------
----- inter left elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <uno/> & <dos/>]
  [typ| <uno/> ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <uno/> & <dos/>]
  [typ| <uno/> ]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- inter right elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| <uno/> & <dos/>]
  [typ| <dos/> ]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| <uno/> & <dos/>]
  [typ| <dos/> ]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- universal elim
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings| ]
  [typ| ALL[T] [(<uno/> <: T)] T ]
  [typ| <uno/>]

example : Subtyping.Static
  [ids| ] [subtypings| ]
  [typ| ALL[T33] [(<uno/> <: T33)] T33 ]
  [typ| <uno/>]
  [ids| ] [subtypings| (<uno/> <: T33) (T33 <: <uno/>) ]
:= by
  -- TODO: remove renaming
  Subtyping_Static_prove

--------------------------------------------

-- TODO: more subtyping instances
