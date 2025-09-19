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

example : StaticSubtyping
  [ids| ] [subtypings|  ]
  [typ| EXI[T] [(T <: <uno/>)] T]
  [typ| <uno/> | <dos/>]
  [ids| T] [subtypings| (T <: <uno/>)]
:= by StaticSubtyping_prove

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

--------------------------------------------

-- TODO: more subtyping instances

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

---------------------------------------
----- difference intro
---------------------------------------

example : StaticSubtyping
  [] []
  [typ| T] [typ| <uno/>]
  [ids| ] [subtypings| (T <: <uno/>) ]
:= by StaticSubtyping_prove

example : StaticSubtyping
  [] []
  [typ| LFP[R] ( (<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ (<succ> <zero/>)]
  [ids| ] [subtypings| (LFP[R] ( (<zero/>) | (<succ> <succ> R)) <: T) ]
:= by StaticSubtyping_prove
