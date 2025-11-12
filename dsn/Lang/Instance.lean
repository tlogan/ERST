import Lang.Util
import Lang.Basic
import Lang.Static

set_option eval.pp false
set_option pp.fieldNotation false

#check [expr| <elem/>]

#check [eid| x]

#check [expr| x]

#check [expr| uno.dos.tres]

#check [expr| [x => <elem/>]]

#check [expr| [x => x.uno]]

#check [expr| (uno := <uno/>).uno]

#check [expr| def x = <elem/> in x]

#check [expr| [<uno> x => x]]


#eval [typ| <uno/> & <dos/>]

#eval [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R) ]


example : Typ.Monotonic.Static "a" .true (.entry "uno" (.entry "dos" (.var "a"))) := by
  Typ_Monotonic_Static_prove

example : Typ.Monotonic.Static "a" .true (.path .bot (.inter .bot (.var "a"))) := by
  Typ_Monotonic_Static_prove


example : Typ.Monotonic.Static "a" .true (.exi ["G"] [] (.var "G")) := by
  Typ_Monotonic_Static_prove

example : Typ.Monotonic.Static "a" .true (.path .bot (.inter .top (.var "a"))) := by
  Typ_Monotonic_Static_prove


example : Typ.Monotonic.Static "a" .false (.path (.inter .bot (.var "a")) .bot) := by
  Typ_Monotonic_Static_prove

example : Typ.Monotonic.Static "a" .false (.path (.inter .top (.var "a")) .top) := by
  Typ_Monotonic_Static_prove


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


example : ¬ Subtyping.check [typ| <dos/> ] [typ| <uno/>] := by
  simp [Subtyping.check]

example Δ Γ
: PatLifting.Static Δ Γ [pattern| x]
  [typ| X] -- (Typ.var "X")
  ((Typ.var "X", Typ.top) :: Δ)
  (("x", Typ.var "X") :: (remove "x" Γ))
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ [pattern| @] .top Δ Γ
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
  [pattern| uno := <elem/> ; dos := <elem/>]
  [typ| uno : <elem/> & dos : <elem/>]
  Δ Γ
:= by
  PatLifting_Static_prove

#eval PatLifting.Static.compute [] [] [pattern| uno := x ; dos := y ]
example :  ∃ t Δ' Γ', PatLifting.Static [] []
  [pattern| uno := x ; dos := y] t Δ' Γ' := by
  exists [typ| uno : T669 & dos : T670 ]
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
----- iso preservation (over union)
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
----- entry preservation (over union)
---------------------------------------

#eval Subtyping.Static.solve
  [ids| ] [subtypings|  ]
  [typ| label : <uno/> ]
  [typ| label : (<uno/> | <dos/>) ]

example : Subtyping.Static
  [ids| ] [subtypings|  ]
  [typ| label : <uno/> ]
  [typ| label : (<uno/> | <dos/>) ]
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
  [typ| label : <uno/> & label : <dos/>]
  [typ| label : (<uno/> & <dos/>)]

example : Subtyping.Static
  [ids| T] [subtypings| ]
  [typ| label : <uno/> & label : <dos/>]
  [typ| label : (<uno/> & <dos/>)]
  [ids| T] [subtypings| ]
:= by Subtyping_Static_prove

---------------------------------------
----- lfp induction
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] <zero/> | EXI[N] [ (N <: R) ] <succ> N ]
  [typ| LFP[R] (<zero/> | <succ> R) ]

-- example : Subtyping.Static
--   [] []
--   [typ| LFP[R] <zero/> | EXI[N] [ (N <: R) ] <succ> N ]
--   [typ| LFP[R] (<zero/> | <succ> R) ]
--   [ids| N ] [subtypings| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
-- -- [subtypings| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
-- := by Subtyping_Static_prove

---------------------------------------
----- lfp factor elim
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  [typ| left : LFP[R] (<zero/> | <succ> R) ]


example : Subtyping.Static
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L)
  )]
  [typ| left : LFP[R] (<zero/> | <succ> R) ]
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
--   · Typ_Monotonic_Static_prove
--   · reduce; Subtyping_Static_prove

---------------------------------------
----- lfp elim diff intro
---------------------------------------

#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] (<zero/> | <succ> <succ> R)]
  [typ| TOP \ <succ> <zero/>]

--- if x is an even number then x ≠ 1
example : Subtyping.Static
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove

--- if x is an even number then x ≠ 3
#eval Subtyping.Static.solve
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <succ> <succ>  <zero/>]

example : Subtyping.Static
  [] []
  [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
  [typ| TOP \ <succ> <succ> <succ> <zero/>]
  [ids| ] [subtypings| ]
:= by Subtyping_Static_prove
-- := by
--   apply Subtyping.Static.lfp_elim_diff_intro
--   { rfl }
--   { simp [Typ.struct_less_than]; reduce
--     (first
--     | apply Or.inl ; rfl
--     | apply Or.inr ; rfl
--     ) <;> fail }
--   { rfl }
--   { Typ_Monotonic_Static_prove }
--   { Subtyping_Static_prove }
--   { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }
--   { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }

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
----- least fixed point peel intro
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


------------------------------------------------------------------------
-----<<<< TYPING BASICS >>>>--------------------------------------------
------------------------------------------------------------------------


---------------------------------------
----- variable
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] [typings| (x : <uno/>)]
  [expr| x ]

example : Expr.Typing.Static
  [ids| ] [subtypings| ] [typings| (x : <uno/>)]
  [expr| x ]
  [typ| <uno/> ]
  [ids| ] [subtypings| ]
:= by Expr_Typing_Static_prove

---------------------------------------
----- empty record
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr| <elem/> ]

example : Expr.Typing.Static
  [ids| ] [subtypings| ] []
  [expr| <elem/> ]
  [typ| TOP ]
  [ids| ] [subtypings| ]
:= by Expr_Typing_Static_prove

---------------------------------------
----- pair record
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr| <uno/> , <dos/>]

example : Expr.Typing.Static
  [ids| ] [subtypings| ] []
  [expr| <uno/> , <dos/>]
  [typ| <uno/> * <dos/> ]
  [ids| ] [subtypings| ]
:= by Expr_Typing_Static_prove

---------------------------------------
----- identity function
---------------------------------------


#eval Function.Typing.Static.compute [] [] [] [] [(Pat.var "x", Expr.var "x")]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr| [x => x]]

-- example : ∃ T , Expr.Typing.Static
--   [ids| ] [subtypings| ] []
--   [expr| [x => x]]
--   [typ| ALL [{[T]}] [({.var T} <: TOP)] ({.var T}) -> {.var T}]
--   [ids| ] [subtypings| ]
-- := by
--   use ?_
--   apply Expr.Typing.Static.function
--   (try Function_Typing_Static_assign)
--   apply Function.Typing.Static.cons
--   { sorry }
--   { ListZone_Typing_Static_assign
--     intros
--     sorry }

---------------------------------------
----- finite isomorphism
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [<uno/> => <dos/>]
    [<thank/> => <you/>]
    [<hello/> => <goodbye/>]
  ]

-- example : Expr.Typing.Static
--   [ids| ] [subtypings| ] []
--   [expr|
--     [<uno/> => <dos/>]
--   ]
--   [typ|
--     (<uno/> -> <dos/>)
--   ]
--   [ids| ] [subtypings| ]
-- := by Expr.Typing_Static_prove

-- example : Expr.Typing.Static
--   [ids| ] [subtypings| ] []
--   [expr|
--     [<uno/> => <dos/>]
--     [<thank/> => <you/>]
--   ]
--   [typ|
--     (<uno/> -> <dos/>) &
--     (<thank/> -> <you/>)
--   ]
--   [ids| ] [subtypings| ]
-- := by Expr.Typing_Static_prove

-- example : Expr.Typing.Static
--   [ids| ] [subtypings| ] []
--   [expr|
--     [<uno/> => <dos/>]
--     [<thank/> => <you/>]
--     [<hello/> => <goodbye/>]
--   ]
--   [typ|
--     (<uno/> -> <dos/>) &
--     (<thank/> -> <you/>) &
--     (<hello/> -> <goodbye/>)
--   ]
--   [ids| ] [subtypings| ]
-- := by Expr.Typing_Static_prove


---------------------------------------
----- annotated variable
---------------------------------------

#eval [expr| x as <uno/>]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr| [ x => x as <uno/> ] ]

---------------------------------------
----- definition
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def talky =
      [<uno/> => <dos/>]
      [<thank/> => <you/>]
      [<hello/> => <goodbye/>]
    in <result/>
  ]

---------------------------------------
----- pair pattern
---------------------------------------

#eval [expr|
  [ f,x => f(x) ]
]

---------------------------------------
----- application
---------------------------------------
#eval [expr|
  [ left := f ; right := x => f(x) ]
]

---------------------------------------
----- selection
---------------------------------------

#eval [expr|
  def talky =
    [<uno/> => <dos/>]
    [<thank/> => <you/>]
    [<hello/> => <goodbye/>]
  in [ x =>
    def y : <uno/> | <thank/> = x in
    talky(y)
  ]
]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def talky =
      [<uno/> => <dos/>]
      [<thank/> => <you/>]
      [<hello/> => <goodbye/>]
    in [ x =>
      def y : <uno/> | <thank/> = x in
      talky(y)
    ]
  ]

---------------------------------------
----- learning
---------------------------------------

#eval [expr| [f => f(<uno/>), f(<dos/>) ] ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [f => f(<uno/>), f(<dos/>) ]
  ]

---------------------------------------
----- factorization
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    loop([self =>
      [<zero/> => <nil/>]
      [<succ> n => <cons> (self(n))]
    ])
  ]


def repeat_expr := [expr|
  [x => loop([self =>
    [<zero/> => <nil/>]
    [<succ> n => <cons> (x,self(n))]
  ])]
]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  repeat_expr


---------------------------------------
----- scalar peeling (i.e. inflation) ; peeling open the least fixed point
---------------------------------------

#eval [expr|
  <succ> <succ> <zero/> as LFP[R] <zero/> | <succ> R
]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    <succ> <succ> <zero/> as LFP[R] <zero/> | <succ> R
  ]


---------------------------------------
----- identity application
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    <uno/>
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [x => x](<uno/>)
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [u =>
      [x => u]
    ](<uno/>)
  ]

----------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [<zero/> => <uno/>]
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [g => g]([<zero/> => <uno/>])
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [g => g]([<zero/> => <uno/>])
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [g =>
      [x => g]
    ]([<zero/> => <uno/>])
  ]


---------------------------------------
----- double application
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [<one/> => <zero/>]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [x =>
      [<zero/> => <uno/>]([<one/> => <zero/>](x))
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [<zero/> => <uno/>](x)
    ]
  ]


---------------------------------------
---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      def g = [<zero/> => <uno/>] in
      g(x)
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [g => g(x)]([<zero/> => <uno/>])
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      def g = [<zero/> => <uno/>] in
      g
    ]
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def g = [<zero/> => <uno/>] in
    [ x => g(x) ]
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = [<one/> => <zero/>] in
    def g = [<zero/> => <uno/>] in
    g
  ]

---------------------------------------
----- scalar induction
---------------------------------------

-- NOTE: that it gives the input the stronger type
-- NOTE: and it gives the output the weaker type

-- RESULT: Even -> Nat
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr| [x =>
    x as (
      LFP[R] <zero/> | <succ> <succ> R
    ) as (
      LFP[R] <zero/> | <succ> R
    )
  ] ]

-- RESULT: Even -> Even
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = [x => x as LFP[R] <zero/> | <succ> <succ> R ] in
    def g = [x => x as LFP[R] <zero/> | <succ> R ] in
    [x => g(f(x))]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def g = loop ([self =>
      [<zero/> => <uno/>]
      [<succ> n => self(n) ]
    ]) in
    [x => g(x)]
  ]

-- RESULT: Even -> Uno
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    -- Even -> Even
    def f = loop ([self =>
      [<zero/> => <zero/>]
      [<succ> <succ> n => <succ> <succ> (self(n)) ]
    ]) in
    -- Nat -> Uno
    def g = loop ([self =>
      [<zero/> => <uno/>]
      [<succ> n => <uno/> ]
    ]) in
    -- Even -> Uno
    [x => g(f(x))]
  ]

--------------------------------
--------------------------------
--------------------------------

#eval [expr|
  [uno := <elem/> => one := <elem/>]
  [dos := <elem/> => two := <elem/>]
]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] [typings| (x : uno : <elem/> & dos : <elem/>)]
  [expr|
    (
    [uno := <elem/> => one := <elem/>]
    [dos := <elem/> => two := <elem/>]
    ) (x)
  ]

-- NOTE: this passes because the typing assumption is absurd (<uno/> & <dos/>) <: BOT
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] [typings| (x : <uno/> & <dos/>)]
  [expr|
    (
    [<uno/> => <one/>(<elem/>)]
    [<dos/> => <two/>]
    ) (x)
  ]

--------------------------------
--------------------------------
--------------------------------

-- TODO: interpret further to simplify type
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    loop ([self =>
      [<nil/> => <zero/>]
      [<cons> n => <succ> (self(n)) ]
    ])
  ]

-- -- SHOULD FAIL
-- #eval Expr.Typing.Static.compute
--   [ids| ] [subtypings| ] []
--   [expr|
--     loop ([<guard> self =>
--       [<nil/> => <zero/>]
--       [<cons> n => <succ> (self(n)) ]
--     ])
--   ]

-- -- SHOULD FAIL
-- #eval Expr.Typing.Static.compute
--   [ids| ] [subtypings| ] []
--   [expr|
--     loop ([<guard> self => <guard> (
--       [<nil/> => <zero/>]
--       [<cons> n => <succ> (self(n)) ]
--     )])
--   ]

--------------------------------
--------------------------------
--------------------------------

-- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      (
        [<zero/> => <uno/>]
        [<succ/> => <dos/> ]
      ) (
        (
          [<nil/> => <zero/>]
          [<cons/> => <succ/>]
        ) (x)
      )
    ]
  ]


-- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [f => f ](
      [<nil/> => <zero/>]
      [<cons/> => <succ/>]
    )
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [<nil/> => <zero/>]
    [<cons/> => <succ/>]
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
      [<cons/> => <succ/>]
    ) in
    [x => f(x)]
  ]

---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [z =>
      (
        [<uno> y => y]
        [<dos> y => y]
      )(z)
    ]
  ]

---------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    (uno := <hello/> ; dos := <bye/>)
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    (
      [uno := x ; dos := y => (x,y)]
    ) (uno := <hello/> ; dos := <bye/>)
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    loop([self =>
      [<zero/> => <nil/>]
      [<succ> n => <cons> (self(n))]
    ])
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      def g = [<zero/> => <uno/>] in
      g(x)
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [x => x](<uno/>)
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [u =>
      [x => x](<uno/>)
    ]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [u =>
      [x => u]
    ](<uno/>)
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [g => g(x)]([<zero/> => <uno/>])
    ]
  ]


#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [g => g(<zero/>)]([<zero/> => <uno/>])
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ x =>
      [g => g(x)]
    ]
  ]
