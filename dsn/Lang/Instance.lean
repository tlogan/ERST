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



#eval [typ| <uno> @ & <dos> @]

#eval [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R) ]

example : (if ("hello" == "hello") = true then 1 else 2) = 1 := by
  simp

example : ∃ ts , ListSubtyping.bounds "R" .true .nil = ts := by
  exists .nil


def x : BEq Typ := inferInstance
#eval (Typ.unit == Typ.unit)
example : (Typ.unit == Typ.unit) = true := by
  rfl

example : (
  if (Typ.var "R" == Typ.var "R") = true then
    Typ.entry "succ" (Typ.var "G010") ::
      if (Typ.var "R" == Typ.var "R") = true then
        [Typ.entry "succ" (Typ.entry "succ" (Typ.var "G010"))]
      else
        []
  else if (Typ.var "R" == Typ.var "R") = true then
    [Typ.entry "succ" (Typ.entry "succ" (Typ.var "G010"))]
  else
    []) =
  [Typ.entry "succ" (Typ.var "G010"), Typ.entry "succ" (Typ.entry "succ" (Typ.var "G010"))]
:= by
  simp_all
  rfl


example : ListSubtyping.bounds "R" .true
  [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
  =
  [typs| (<succ> G010) (<succ> <succ> G010)]
:= by rfl

example : ∃ ts , ListSubtyping.bounds "R" .true
  [subtypings| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
  = ts
:= by
  exists [typs| (<succ> G010) (<succ> <succ> G010) ]


example : Typ.UpperFounded "R"
  [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
  [typ| G010 | <succ> R | <succ> <succ> R ]
:= by Typ_UpperFounded_prove


example : ¬ Subtyping.check [] [] [typ| @] [typ| <uno> @] := by
  simp [Subtyping.check, Typ.toBruijn]
  rfl


example Δ Γ
: PatLifting.Static Δ Γ [pattern| x]
  [typ| X] -- (Typ.var "X")
  ((Typ.var "X", Typ.top) :: Δ)
  (("x", Typ.var "X") :: (remove "x" Γ))
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ .unit Typ.unit Δ Γ
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
  [pattern| <dos> @]
  [typ| <dos> @]
  Δ Γ
:= by
  PatLifting_Static_prove

example Δ Γ
: PatLifting.Static Δ Γ
  [pattern| <uno>@ <dos>@]
  [typ| <uno>@ & <dos>@]
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


example : StaticSubtyping [] []
  [typ| @]
  [typ| @]
  [] []
:= by
  Subtyping_Static_prove

#eval [typ| <uno> @ | <dos> @]
example : StaticSubtyping [] [] [typ| <uno> @] [typ| <uno> @ | <dos> @] [] [] := by
  Subtyping_Static_prove

#eval [subtypings| (T <: <uno> @) ]
example : StaticSubtyping [] []
  [typ| T] [typ| <uno> @]
  [ids| ] [subtypings| (T <: <uno> @) ]
:= by
  Subtyping_Static_prove

example : StaticSubtyping [] []
  [typ| LFP[R] ( (<zero> @) | (<succ> <succ> R))]
  [typ| TOP \ (<succ> <zero> @)]
  [ids| ] [subtypings| (T <: <uno> @) ]
:= by
  Subtyping_Static_prove


#eval StaticSubtyping.solve
  [ids| T] [subtypings| (X <: T)]
  [typ| @]
  [typ| T]

example : StaticSubtyping
  [ids| T] [subtypings| (X <: T)]
  [typ| @]
  [typ| T]
  [ids| T] [subtypings| (@ <: T) (X <: T)]
:= by
  Subtyping_Static_prove
