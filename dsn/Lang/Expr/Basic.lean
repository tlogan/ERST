import Lean

import Lang.List.Basic
import Lang.Prod.Basic
import Lang.String.Basic
import Lang.Typ.Basic

set_option pp.fieldNotation false
namespace Lang

inductive Pattern
| var : String → Pattern
| iso : String → Pattern → Pattern
| record : List (String × Pattern) → Pattern
deriving Repr

def Pattern.pair (left : Pattern) (right : Pattern) : Pattern :=
    .record [("left", left), ("right", right)]


inductive Expr
| bvar : Nat → Expr
| fvar : String → Expr
| iso : String → Expr → Expr
| record : List (String × Expr) → Expr
| function : List (Pattern × Expr) → Expr
| app : Expr → Expr → Expr
| anno : Expr → Typ → Expr
| loopi : Expr → Expr
deriving Repr

def Expr.pair (left : Expr) (right : Expr) : Expr :=
    .record [("left", left), ("right", right)]

def Expr.is_pair : Expr → Bool
| .record [( "left", _), ("right", _)] => .true
| .record [( "right", _), ("left", _)] => .true
| _ => .false

mutual
  def Expr.record_valued : List (String × Expr) → Bool
  | [] => .true
  | (l,e) :: r =>
    Prod.key_fresh l r && Expr.valued e &&
    Expr.record_valued r

  def Expr.valued : Expr → Bool
  | (.iso _ e) => Expr.valued e
  | (.record r) => Expr.record_valued r
  | (.function _) => .true
  | _ => .false
end

mutual
  def Pattern.record_index_vars : List (String × Pattern) → List String
  | [] => []
  | (l,p) :: ps =>
    Pattern.index_vars p ++ Pattern.record_index_vars ps

  def Pattern.index_vars : Pattern → List String
  | var x => [x]
  | iso l p => Pattern.index_vars p
  | record ps => Pattern.record_index_vars ps
end

mutual
  def Pattern.record_clear : List (String × Pattern) → List (String × Pattern)
  | [] => []
  | (l,p) :: ps =>
    (l, Pattern.clear p) :: Pattern.record_clear ps

  def Pattern.clear : Pattern → Pattern
  | var x => .var ""
  | iso l p => .iso l (Pattern.clear p)
  | record ps => .record (Pattern.record_clear ps)
end

def Pattern.bvar := Pattern.var ""


def Pattern.count_vars (p : Pattern) := List.length (Pattern.index_vars p)


#eval Pattern.index_vars (Pattern.record [("uno", Pattern.var "x"), ("dos", Pattern.record [("dos", Pattern.var "y"), ("tres", Pattern.var "z")])])


mutual
  def Expr.record_seal (names : List String) : List (String × Expr) → List (String × Expr)
  | [] => []
  | (l,e)::r =>
    (l, Expr.seal names e) :: (Expr.record_seal names r)

  def Expr.function_seal (names : List String) : List (Pattern × Expr) → List (Pattern × Expr)
  | [] => []
  | (p,e)::f =>
    let names' := Pattern.index_vars p
    (Pattern.clear p, Expr.seal (names' ++ names) e) :: (Expr.function_seal names f)

  def Expr.seal (names : List String) : Expr → Expr
  | .bvar i => .bvar i
  | .fvar x =>
    match List.firstIndexOf x names with
    | .some i => .bvar i
    | .none => .fvar x
  | .iso l e => .iso l (Expr.seal names e)
  | .record r => .record (Expr.record_seal names r)
  | .function f => .function (Expr.function_seal names f)
  | .app ef ea => .app (Expr.seal names ef) (Expr.seal names ea)
  | .anno e t => .anno (Expr.seal names e) t
  | .loopi e => .loopi (Expr.seal names e)
end

#eval Expr.seal [] (.function [(Pattern.var "z", .app (.function [(Pattern.iso "uno" (Pattern.var "x"), .record [("one", .fvar "x"), ("two", .fvar "z")])]) (.fvar "hello"))])

def Expr.extract (e : Expr) (l : String) : Expr :=
  .app (.function [(Pattern.iso l (Pattern.bvar), .bvar 0)]) e

def Expr.project (e : Expr) (l : String) : Expr :=
  .app (.function [(.record [(l, Pattern.bvar)], .bvar 0)]) e

def Expr.def (id : String) (top : Option Typ) (target : Expr) (contin : Expr) : Expr :=
  Expr.app
    (Expr.function [
      (
        Pattern.var id, match top with
        | .some t => .anno contin t
        | .none => contin
      )
    ])
    (target)


syntax "[brief|" brief "]" : term
syntax "[frame|" frame "]" : term
syntax "[pattern|" pat "]" : term
syntax "[record|" record "]" : term
syntax "[function|" function "]" : term
syntax "[expr|" expr "]" : term


macro_rules
| `([brief| : $i:ident ]) => `(([id| $i], Pattern.var [id| $i]) :: [])
| `([brief| : $i:ident $br:brief]) => `(([id| $i], Pattern.var [id| $i]) :: [brief| $br])

macro_rules
-- | `([frame| <$i:ident/> ]) => `(([id| $i], [pattern| @]) :: [])
| `([frame| $i:ident := $p:pat ]) => `(([id| $i], [pattern| $p]) :: [])
| `([frame| $i:ident := $p:pat ; ]) => `(([id| $i], [pattern| $p]) :: [])
| `([frame| $i:ident := $p:pat ; $pr:frame ]) => `(([id| $i], [pattern| $p]) :: [frame| $pr])

macro_rules
| `([pattern| $i:ident ]) => `(Pattern.var [id| $i])
| `([pattern| @ ]) => `(Pattern.record [])
| `([pattern| < $i:ident > $p:pat ]) => `(Pattern.iso [id| $i] [pattern| $p])
| `([pattern| < $i:ident /> ]) => `(Pattern.iso [id| $i] (Pattern.record []))
| `([pattern| $br:brief ]) => `(Pattern.record [brief| $br])
| `([pattern| $pr:frame ]) => `(Pattern.record [frame| $pr])
-- | `([pattern| $i:ident ; $p:pat ]) => `(Pattern.record ([id| $i], [pattern| $p]) :: [])
| `([pattern| $l:pat , $r:pat ]) => `(Pattern.pair [pattern| $l] [pattern| $r])

macro_rules
-- | `([record| <$i:ident/> ]) => `(([id| $i], [expr| @]) :: [])
-- | `([record| <$i:ident> $e:expr ]) => `(([id| $i], [expr| $e]) :: [])
-- | `([record| <$i:ident> $e:expr $er:record ]) => `(([id| $i], [expr| $e]) :: [record| $er])
| `([record| $i:ident := $e:expr ]) => `(([id| $i], [expr| $e]) :: [])
| `([record| $i:ident := $e:expr ; ]) => `(([id| $i], [expr| $e]) :: [])
| `([record| $i:ident := $e:expr ; $r:record]) => `(([id| $i], [expr| $e]) :: [record| $r])

macro_rules
| `([function| [ $p:pat => $e:expr ] ]) => `(([pattern| $p], [expr| $e]) :: [])
| `([function| [ $p:pat => $e:expr ] $f:function ]) =>
  `(([pattern| $p], [expr| $e]) :: [function| $f])



macro_rules
| `([expr| $i:ident ]) => `([eid| $i])
| `([expr| < $i:ident > $e:expr ]) => `(Expr.iso [id| $i] [expr| $e])
| `([expr| < $i:ident /> ]) => `(Expr.iso [id| $i] (Expr.record []))
| `([expr| $er:record ]) => `(Expr.record [record| $er])
| `([expr| $i:ident ; $e:expr ]) => `(Expr.record [([id| $i], [expr| $e])])
| `([expr| $l:expr , $r:expr ]) => `(Expr.pair [expr| $l] [expr| $r])
| `([expr| $f:function ]) => `(Expr.function [function| $f])
| `([expr| $e:expr . $i:ident ]) => `(Expr.project [expr| $e] [id| $i])
| `([expr| $f:expr ( $a:expr ) ]) => `(Expr.app [expr| $f] [expr| $a])
| `([expr| $e:expr as $t:typ ]) => `(Expr.anno [expr| $e] [typ| $t])
| `([expr| def $i:ident : $t:typ = $a:expr in $c:expr  ]) =>
  `(Expr.def [id| $i] (.some [typ| $t]) [expr| $a] [expr| $c])
| `([expr| def $i:ident = $a:expr in $c:expr  ]) =>
  `(Expr.def [id| $i] .none [expr| $a] [expr| $c])
| `([expr| loop ( $e:expr ) ]) => `(Expr.loopi [expr| $e])
| `([expr| ( $e:expr ) ]) => `([expr| $e])



#eval [expr| [:uno :dos => <output/>] ]
#eval [expr| [uno := uno ; dos := dos => <output/>] ]




mutual
  def Pattern.toRecordExpr : List (String × Pattern) → List (String × Expr)
  | .nil => .nil
  | (l, p) :: r => (l, toExpr p) :: (toRecordExpr r)

  def Pattern.toExpr : Pattern → Expr
  | .var id => .fvar id
  | .iso label body => .iso label (Pattern.toExpr body)
  | .record r => .record (toRecordExpr r)
end

instance : Coe Pattern Expr where
  coe := Pattern.toExpr

#eval [expr| ( uno := <elem/> ; dos := <elem/> ) ]
#eval [expr| ( uno := <elem/>,<elem/> ; dos := <elem/> ) ]
#eval [expr| ( uno := (<elem/>,<elem/>) , dos := <elem/> ) ]


def Expr.free_vars : Expr → List String
| _ => []

def Expr.context_free_vars : List (String × Expr) → List String
| [] => []
| (x,e) :: m => Expr.free_vars e ++ (Expr.context_free_vars m)

mutual

  def List.record_shift_vars (threshold : Nat) (offset : Nat) : List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.shift_vars threshold offset e) :: (List.record_shift_vars threshold offset r)

  def List.function_shift_vars (threshold : Nat) (offset : Nat) : List (Pattern × Expr) → List (Pattern × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let threshold' := threshold + Pattern.count_vars p
    (p, Expr.shift_vars threshold' offset e) :: (List.function_shift_vars threshold offset f)

  def Expr.shift_vars (threshold : Nat) (offset : Nat) : Expr → Expr
  | .bvar i =>
    if i >= threshold then
      (.bvar (i + offset))
    else
      (.bvar i)
  | .fvar id => .fvar id
  | .iso l body => .iso l (Expr.shift_vars threshold offset body)
  | .record r => .record (List.record_shift_vars threshold offset r)
  | .function f => .function (List.function_shift_vars threshold offset f)
  | .app ef ea => .app (Expr.shift_vars threshold offset ef) (Expr.shift_vars threshold offset ea)
  | .anno e t => .anno (Expr.shift_vars threshold offset e) t
  | .loopi e => .loopi (Expr.shift_vars threshold offset e)
end

mutual


  theorem Expr.record_shift_vars_zero r :
    List.record_shift_vars level 0 r = r
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_zero }
    { apply Expr.record_shift_vars_zero }

  theorem Expr.function_shift_vars_zero f :
    List.function_shift_vars level 0 f = f
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_zero }
    { apply Expr.function_shift_vars_zero }

  theorem Expr.shift_vars_zero e :
    Expr.shift_vars level 0 e = e
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars]
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_zero
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_zero
  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_zero
  | app ea ef =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_zero }
    { apply Expr.shift_vars_zero }
  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_zero
  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_zero
end

def Expr.list_shift_vars (threshold : Nat) (offset : Nat) : List Expr → List Expr
| .nil => .nil
| e :: es =>
  Expr.shift_vars threshold offset e :: (Expr.list_shift_vars threshold offset es)

-- mutual

--   def List.record_shift_back (threshold : Nat) (offset : Nat) : List (String × Expr) → List (String × Expr)
--   | .nil => .nil
--   | (l, e) :: r =>
--     (l, Expr.shift_back threshold offset e) :: (List.record_shift_back threshold offset r)

--   def List.function_shift_back (threshold : Nat) (offset : Nat) : List (Pattern × Expr) → List (Pattern × Expr)
--   | .nil => .nil
--   | (p, e) :: f =>
--     let threshold' := threshold + Pattern.count_vars p
--     (p, Expr.shift_back threshold' offset e) :: (List.function_shift_back threshold offset f)

--   def Expr.shift_back (threshold : Nat) (offset : Nat) : Expr → Expr
--   | .bvar i =>
--     if i >= threshold + offset then
--       (.bvar (i - offset))
--     else
--       (.bvar i)
--   | .fvar id => .fvar id
--   | .iso l body => .iso l (Expr.shift_back threshold offset body)
--   | .record r => .record (List.record_shift_back threshold offset r)
--   | .function f => .function (List.function_shift_back threshold offset f)
--   | .app ef ea => .app (Expr.shift_back threshold offset ef) (Expr.shift_back threshold offset ea)
--   | .anno e t => .anno (Expr.shift_back threshold offset e) t
--   | .loopi e => .loopi (Expr.shift_back threshold offset e)
-- end

-- def Expr.list_shift_back (threshold : Nat) (offset : Nat) : List Expr → List Expr
-- | .nil => .nil
-- | e :: es =>
--   Expr.shift_back threshold offset e :: (Expr.list_shift_back threshold offset es)


-- mutual
--   theorem Expr.record_shift_forward_then_back level offset r :
--     List.record_shift_back level offset (List.record_shift_vars level offset r) = r
--   := by cases r with
--   | nil =>
--     simp [List.record_shift_vars, List.record_shift_back]
--   | cons le r' =>
--     have (l,e) := le
--     simp [List.record_shift_vars, List.record_shift_back]
--     apply And.intro
--     { apply Expr.shift_forward_then_back }
--     { apply Expr.record_shift_forward_then_back }

--   theorem Expr.function_shift_forward_then_back level offset f :
--     List.function_shift_back level offset (List.function_shift_vars level offset f) = f
--   := by cases f with
--   | nil =>
--     simp [List.function_shift_vars, List.function_shift_back]
--   | cons pe f' =>
--     have (p,e) := pe
--     simp [List.function_shift_vars, List.function_shift_back]
--     apply And.intro
--     { apply Expr.shift_forward_then_back }
--     { apply Expr.function_shift_forward_then_back }



--   theorem Expr.shift_forward_then_back level offset e :
--     Expr.shift_back level offset (Expr.shift_vars level offset e) = e
--   := by cases e with
--   | bvar i =>
--     simp [Expr.shift_vars]
--     by_cases h0 : level ≤ i
--     { simp [h0]
--       simp [Expr.shift_back]
--       intro h1
--       apply False.elim
--       have h2 : ¬ level ≤ i := by exact Nat.not_le_of_lt h1
--       apply h2 h0
--     }
--     { simp [h0]
--       simp [Expr.shift_back]
--       intro h1
--       have h2 : level ≤ i := by exact Nat.le_of_add_right_le h1
--       apply False.elim
--       apply h0 h2
--     }
--   | fvar x =>
--     simp [Expr.shift_vars, Expr.shift_back]
--   | iso l body =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply Expr.shift_forward_then_back
--   | record r =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply Expr.record_shift_forward_then_back

--   | function f =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply Expr.function_shift_forward_then_back

--   | app ef ea =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply And.intro
--     { apply Expr.shift_forward_then_back }
--     { apply Expr.shift_forward_then_back }

--   | anno body t =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply Expr.shift_forward_then_back

--   | loopi body =>
--     simp [Expr.shift_vars, Expr.shift_back]
--     apply Expr.shift_forward_then_back
-- end

theorem Expr.list_shift_vars_length_eq threshold offset m:
  List.length (Expr.list_shift_vars threshold offset m) = List.length m
:= by induction m with
| nil =>
  simp [Expr.list_shift_vars]
| cons e m' ih =>
  simp [Expr.list_shift_vars]
  apply ih

-- theorem Expr.list_shift_back_length_eq threshold offset m:
--   List.length (Expr.list_shift_back threshold offset m) = List.length m
-- := by induction m with
-- | nil =>
--   simp [Expr.list_shift_back]
-- | cons e m' ih =>
--   simp [Expr.list_shift_back]
--   apply ih


theorem Expr.list_shift_vars_concat :
  (Expr.list_shift_vars threshold offset m0) ++
  (Expr.list_shift_vars threshold offset m1)
  =
  Expr.list_shift_vars threshold offset (m0 ++ m1)
:= by induction m0 with
| nil =>
  simp [Expr.list_shift_vars]
| cons e0 m0' ih =>
  simp [Expr.list_shift_vars]
  apply ih

-- theorem Expr.list_shift_back_concat :
--   (Expr.list_shift_back threshold offset m0) ++
--   (Expr.list_shift_back threshold offset m1)
--   =
--   Expr.list_shift_back threshold offset (m0 ++ m1)
-- := by induction m0 with
-- | nil =>
--   simp [Expr.list_shift_back]
-- | cons e0 m0' ih =>
--   simp [Expr.list_shift_back]
--   apply ih


theorem Expr.list_shift_vars_get_some_preservation threshold offset :
  ∀ (i : Nat),
  m[i]? = some arg →
  (Expr.list_shift_vars threshold offset m)[i]? = some (Expr.shift_vars threshold offset arg)
:= by induction m with
| nil =>
  simp
| cons e m' ih =>
  intro i
  simp [Expr.list_shift_vars]
  rw [List.getElem?_cons]
  by_cases h0 : i = 0
  { simp [h0]
    intro h1
    simp [h1]
  }
  { simp [h0]
    intro h1
    rw [List.getElem?_cons]
    simp [h0]
    apply ih _ h1
  }

-- theorem Expr.list_shift_back_get_some_preservation threshold offset :
--   ∀ (i : Nat),
--   m[i]? = some arg →
--   (Expr.list_shift_back threshold offset m)[i]? = some (Expr.shift_back threshold offset arg)
-- := by induction m with
-- | nil =>
--   simp
-- | cons e m' ih =>
--   intro i
--   simp [Expr.list_shift_back]
--   rw [List.getElem?_cons]
--   by_cases h0 : i = 0
--   { simp [h0]
--     intro h1
--     simp [h1]
--   }
--   { simp [h0]
--     intro h1
--     rw [List.getElem?_cons]
--     simp [h0]
--     apply ih _ h1
--   }


theorem Expr.list_shift_vars_get_none_preservation threshold offset :
  ∀ (i : Nat),
  m[i]? = none →
  (Expr.list_shift_vars threshold offset m)[i]? = none
:= by
  intro i h0
  apply Iff.mpr List.getElem?_eq_none_iff
  rw [Expr.list_shift_vars_length_eq]
  exact Iff.mp List.getElem?_eq_none_iff h0

-- theorem Expr.list_shift_back_get_none_preservation threshold offset :
--   ∀ (i : Nat),
--   m[i]? = none →
--   (Expr.list_shift_back threshold offset m)[i]? = none
-- := by
--   intro i h0
--   apply Iff.mpr List.getElem?_eq_none_iff
--   rw [Expr.list_shift_back_length_eq]
--   exact Iff.mp List.getElem?_eq_none_iff h0


mutual
  def List.record_instantiate (depth : Nat) (m : List Expr): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.instantiate depth m e) :: (List.record_instantiate depth m r)

  def List.function_instantiate (depth : Nat) (m : List Expr): List (Pattern × Expr) → List (Pattern × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let depth' := depth + (Pattern.count_vars p)
    (p, (Expr.instantiate depth' m e)) :: (List.function_instantiate depth m f)

  def Expr.instantiate (depth : Nat) (m : List Expr) : Expr → Expr
  | .bvar i =>
    if i >= depth then
      match m[i - depth]? with
      | some e => Expr.shift_vars 0 depth e
      | none => .bvar (i - List.length m)
    else
      .bvar i
  | .fvar id => .fvar id
  | .iso l body => .iso l (Expr.instantiate depth m body)
  | .record r => .record (List.record_instantiate depth m r)
  | .function f => .function (List.function_instantiate depth m f)
  | .app ef ea => .app (Expr.instantiate depth m ef) (Expr.instantiate depth m ea)
  | .anno e t => .anno (Expr.instantiate depth m e) t
  | .loopi e => .loopi (Expr.instantiate depth m e)
end

def Expr.list_instantiate (offset : Nat) (m : List Expr): List Expr → List Expr
| .nil => .nil
| e :: es =>
  Expr.instantiate offset m e :: (Expr.list_instantiate offset m es)

theorem Expr.list_instantiate_concat :
  (Expr.list_instantiate depth d m0) ++
  (Expr.list_instantiate depth d m1)
  =
  Expr.list_instantiate depth d (m0 ++ m1)
:= by induction m0 with
| nil =>
  simp [Expr.list_instantiate]
| cons e0 m0' ih =>
  simp [Expr.list_instantiate]
  apply ih

theorem Expr.list_instantiate_length_eq offset d m:
  List.length (Expr.list_instantiate offset d m) = List.length m
:= by induction m with
| nil =>
  simp [Expr.list_instantiate]
| cons e m' ih =>
  simp [Expr.list_instantiate]
  apply ih

theorem Expr.list_instantiate_get_some_preservation offset d :
  ∀ (i : Nat),
  m[i]? = some arg →
  (Expr.list_instantiate offset d m)[i]? = some (Expr.instantiate offset d arg)
:= by induction m with
| nil =>
  simp
| cons e m' ih =>
  intro i
  simp [Expr.list_instantiate]
  rw [List.getElem?_cons]
  by_cases h0 : i = 0
  { simp [h0]
    intro h1
    simp [h1]
  }
  { simp [h0]
    intro h1
    rw [List.getElem?_cons]
    simp [h0]
    apply ih _ h1
  }

theorem Expr.list_instantiate_get_none_preservation offset d :
  ∀ (i : Nat),
  m[i]? = none →
  (Expr.list_instantiate offset d m)[i]? = none
:= by
  intro i h0
  apply Iff.mpr List.getElem?_eq_none_iff
  rw [Expr.list_instantiate_length_eq]
  exact Iff.mp List.getElem?_eq_none_iff h0

def Expr.liberate_vars (p : Pattern) (e : Expr) : Expr :=
  let xs := Pattern.index_vars p
  let fvs := List.map (fun x => Expr.fvar x) xs
  Expr.instantiate 0 fvs e


-- mutual
--   def List.record_sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
--   | .nil => .nil
--   | (l, e) :: r =>
--     (l, Expr.sub m e) :: (List.record_sub m r)

--   def List.function_sub (m : List (String × Expr)): List (Pattern × Expr) → List (Pattern × Expr)
--   | .nil => .nil
--   | (p, e) :: f =>
--     let ids := Pattern.index_vars p
--     (p, Expr.sub (Prod.remove_all m ids) e) :: (List.function_sub m f)

--   def Expr.sub (m : List (String × Expr)): Expr → Expr
--   | .bvar i => .bvar i
--   | .fvar id => match (Prod.find id m) with
--     | .none => (.fvar id)
--     | .some e => e
--   | .iso l body => .iso l (Expr.sub m body)
--   | .record r => .record (List.record_sub m r)
--   | .function f => .function (List.function_sub m f)
--   | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
--   | .anno e t => .anno (Expr.sub m e) t
--   | .loopi e => .loopi (Expr.sub m e)
-- end

-- theorem Expr.sub_refl :
--   x ∉ ListPair.dom m →
--   (Expr.sub m (.fvar x)) = (.fvar x)
-- := by
--   intro h0
--   induction m with
--   | nil =>
--     simp [Expr.sub, find]
--   | cons pair m' ih =>
--     have ⟨x',target⟩ := pair
--     simp [ListPair.dom] at h0
--     have ⟨h1,h2⟩ := h0
--     clear h0
--     specialize ih h2
--     simp [Expr.sub, find]
--     have h3 : x' ≠ x := by exact fun h => h1 (Eq.symm h)
--     simp [h3]
--     unfold Expr.sub at ih
--     exact ih


mutual
  def Pattern.match_entry (label : String) (pat : Pattern)
  : List (String × Expr) → Option (List Expr)
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (Pattern.match e pat)
    else
      Pattern.match_entry label pat args

  def Pattern.match_record (args : List (String × Expr))
  : List (String × Pattern) → Option (List Expr)
  | .nil => some []
  | (label, pat) :: pats => do
    let m0 ← Pattern.match_entry label pat args
    let m1 ← Pattern.match_record args pats
    return (m0 ++ m1)

  def Pattern.match : Expr → Pattern → Option (List Expr)
  | e, (.var x) =>
    if x == "" then
      some [e]
    else
      none
  | (.iso l e), (.iso label p) =>
    if l == label then
      Pattern.match e p
    else
      none
  | (.record r), (.record p) =>
    if Prod.keys_unique r then
      Pattern.match_record r p
    else
      none
  | _, _ => none
end



mutual
  theorem Pattern.match_entry_count_eq :
    Pattern.match_entry l p r = some m →
    Pattern.count_vars p = List.length m
  := by cases r with
  | nil =>
    simp [Pattern.match_entry]
  | cons le r' =>
    have (l',e) := le
    simp [Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [h0]
      apply Pattern.match_count_eq
    }
    { simp [h0]
      apply Pattern.match_entry_count_eq
    }

  theorem Pattern.match_record_count_eq :
    match_record r ps = some m →
    List.length (Pattern.record_index_vars ps) = List.length m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record, Pattern.record_index_vars]
    intro h0
    rw [h0]
    simp [List.length]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record, Pattern.record_index_vars]

    match
      h0 : match_entry l p r,
      h1 : match_record r ps'
    with
    | some m0, some m1  =>
      simp
      intro h2
      have ih1 := Pattern.match_entry_count_eq h0
      have ih2 := Pattern.match_record_count_eq h1
      unfold Pattern.count_vars at ih1
      rw [ih1,ih2]
      rw [←h2]
      exact Eq.symm List.length_append
    | none,_ => simp
    | _,none => simp





  theorem Pattern.match_count_eq :
    Pattern.match e p = some m →
    Pattern.count_vars p = List.length m
  := by cases p with
  | var x =>
    simp [Pattern.match, Pattern.count_vars, Pattern.index_vars]
    intro h0 h1
    rw [←h1]
    simp [List.length]
  | iso l bp =>
    simp [Pattern.count_vars, Pattern.index_vars]
    cases e with
    | iso l' body =>
      simp [Pattern.match]
      intro h0
      apply Pattern.match_count_eq
    | _ =>
      simp [Pattern.match]

  | record ps =>
    simp [Pattern.count_vars, Pattern.index_vars]
    cases e with
    | record r =>
      simp [Pattern.match]
      intro h0
      apply Pattern.match_record_count_eq
    | _ =>
      simp [Pattern.match]
end

theorem Pattern.match_var e :
  Pattern.match e (.var "") = some [e]
:= by simp [Pattern.match]

theorem Expr.record_shift_vars_key_fresh_preservation :
  Prod.key_fresh l r →
  Prod.key_fresh l  (List.record_shift_vars threshold offset r)
:= by induction r with
| nil =>
  simp [List.record_shift_vars, Prod.key_fresh]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_shift_vars, Prod.key_fresh]
  intro h0 h1
  simp [h0]
  apply ih h1

-- theorem Expr.record_shift_back_key_fresh_preservation :
--   List.is_fresh_key l r →
--   List.is_fresh_key l  (List.record_shift_back threshold offset r)
-- := by induction r with
-- | nil =>
--   simp [List.record_shift_back, List.is_fresh_key]
-- | cons le r' ih =>
--   have (l',e) := le
--   simp [List.record_shift_back, List.is_fresh_key]
--   intro h0 h1
--   simp [h0]
--   apply ih h1

theorem Expr.record_shift_vars_key_fresh_reflection :
  Prod.key_fresh l  (List.record_shift_vars threshold offset r) →
  Prod.key_fresh l r
:= by induction r with
| nil =>
  simp [List.record_shift_vars, Prod.key_fresh]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_shift_vars, Prod.key_fresh]
  intro h0 h1
  simp [h0]
  apply ih h1

-- theorem Expr.record_shift_back_key_fresh_reflection :
--   List.is_fresh_key l  (List.record_shift_back threshold offset r) →
--   List.is_fresh_key l r
-- := by induction r with
-- | nil =>
--   simp [List.record_shift_back, List.is_fresh_key]
-- | cons le r' ih =>
--   have (l',e) := le
--   simp [List.record_shift_back, List.is_fresh_key]
--   intro h0 h1
--   simp [h0]
--   apply ih h1

theorem Expr.record_instantiate_key_fresh_reflection :
  Prod.key_fresh l  (List.record_instantiate depth d r) →
  Prod.key_fresh l r
:= by induction r with
| nil =>
  simp [List.record_instantiate, Prod.key_fresh]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_instantiate, Prod.key_fresh]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_instantiate_key_fresh_preservation :
  Prod.key_fresh l r →
  Prod.key_fresh l  (List.record_instantiate depth d r)
:= by induction r with
| nil =>
  simp [List.record_instantiate, Prod.key_fresh]
| cons le r' ih =>
  have (l',e) := le
  simp [List.record_instantiate, Prod.key_fresh]
  intro h0 h1
  simp [h0]
  apply ih h1

theorem Expr.record_instantiate_keys_unique_preservation :
  Prod.keys_unique r →
  Prod.keys_unique (List.record_instantiate depth d r)
:= by induction r with
| nil =>
  simp [List.record_instantiate, Prod.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_instantiate, Prod.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_instantiate_key_fresh_preservation h0 }
  { apply ih h1 }


theorem Expr.record_shift_vars_keys_unique_preservation :
  Prod.keys_unique r →
  Prod.keys_unique (List.record_shift_vars threshold offset r)
:= by induction r with
| nil =>
  simp [List.record_shift_vars, Prod.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_shift_vars, Prod.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_shift_vars_key_fresh_preservation h0 }
  { apply ih h1 }

-- theorem Expr.record_shift_back_keys_unique_preservation :
--   Prod.keys_unique r →
--   Prod.keys_unique (List.record_shift_back threshold offset r)
-- := by induction r with
-- | nil =>
--   simp [List.record_shift_back, Prod.keys_unique]
-- | cons le r' ih =>
--   have (l,e) := le
--   simp [List.record_shift_back, Prod.keys_unique]
--   intro h0 h1
--   apply And.intro
--   { exact record_shift_back_key_fresh_preservation h0 }
--   { apply ih h1 }

theorem Expr.record_shift_vars_keys_unique_reflection :
  Prod.keys_unique (List.record_shift_vars threshold offset r) →
  Prod.keys_unique r
:= by induction r with
| nil =>
  simp [List.record_shift_vars, Prod.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_shift_vars, Prod.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_shift_vars_key_fresh_reflection h0 }
  { apply ih h1 }

-- theorem Expr.record_shift_back_keys_unique_reflection :
--   Prod.keys_unique (List.record_shift_back threshold offset r) →
--   Prod.keys_unique r
-- := by induction r with
-- | nil =>
--   simp [List.record_shift_back, Prod.keys_unique]
-- | cons le r' ih =>
--   have (l,e) := le
--   simp [List.record_shift_back, Prod.keys_unique]
--   intro h0 h1
--   apply And.intro
--   { exact record_shift_back_key_fresh_reflection h0 }
--   { apply ih h1 }

theorem Expr.record_instantiate_keys_unique_reflection :
  Prod.keys_unique (List.record_instantiate depth d r) →
  Prod.keys_unique r
:= by induction r with
| nil =>

  simp [List.record_instantiate, Prod.keys_unique]
| cons le r' ih =>
  have (l,e) := le
  simp [List.record_instantiate, Prod.keys_unique]
  intro h0 h1
  apply And.intro
  { exact record_instantiate_key_fresh_reflection h0 }
  { apply ih h1 }



mutual

  theorem Expr.record_shift_vars_inside_out threshold depth offset level r:
    List.record_shift_vars (threshold + level + depth) offset (List.record_shift_vars level depth r)
    =
    List.record_shift_vars level depth (List.record_shift_vars (threshold + level) offset r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_inside_out }
    { apply Expr.record_shift_vars_inside_out }

  theorem Expr.function_shift_vars_inside_out threshold depth offset level f :
    List.function_shift_vars (threshold + level + depth) offset (List.function_shift_vars level depth f)
    =
    List.function_shift_vars level depth (List.function_shift_vars (threshold + level) offset f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe r =>
    have (p,e) := pe
    simp [List.function_shift_vars]

    apply And.intro
    {

      have h0 :
        threshold + level + depth + Pattern.count_vars p =
        threshold + level + Pattern.count_vars p + depth
      := by exact Nat.add_right_comm (threshold + level) depth (Pattern.count_vars p)
      rw [h0]

      have h1 :
        threshold + level + Pattern.count_vars p  =
        threshold + (level + Pattern.count_vars p)
      := by exact Nat.add_assoc threshold level (Pattern.count_vars p)
      rw [h1]
      apply Expr.shift_vars_inside_out
    }
    { apply Expr.function_shift_vars_inside_out }

  theorem Expr.shift_vars_inside_out threshold depth offset level arg :
    Expr.shift_vars (threshold + level + depth) offset (Expr.shift_vars level depth arg)
    =
    Expr.shift_vars level depth (Expr.shift_vars (threshold + level) offset arg)
  := by cases arg with
  | bvar i =>
    simp [Expr.shift_vars]
    by_cases  h0 : level ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      by_cases h1 : threshold + level ≤ i
      { simp [h1]
        simp [Expr.shift_vars]

        have h2 : level ≤  i + offset := by exact Nat.le_add_right_of_le h0
        simp [h2]
        exact Nat.add_right_comm i depth offset
      }
      { simp [h1]
        simp [Expr.shift_vars]
        intro h2
        have h3 : ¬ i < level := by
          exact Iff.mpr Nat.not_lt h0
        apply False.elim (h3 h2)
      }
    }
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : ¬ threshold + level ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]

      have h2 : ¬ threshold + level + depth ≤ i := by
        intro h
        apply h1
        exact Nat.le_of_add_right_le h
      simp [h2]

      simp [Expr.shift_vars]
      intro h3
      apply False.elim (h0 h3)
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_inside_out

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_inside_out

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_inside_out }
    { apply Expr.shift_vars_inside_out }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_inside_out
end

theorem Expr.shift_vars_zero_inside_out threshold depth offset arg :
  Expr.shift_vars (threshold + depth) offset (Expr.shift_vars 0 depth arg)
  =
  Expr.shift_vars 0 depth (Expr.shift_vars threshold offset arg)
:= by
  have h0 : threshold = threshold + 0 := by exact rfl
  rw [h0]
  apply Expr.shift_vars_inside_out

mutual
  theorem Expr.record_shift_vars_instantiate_inside_out threshold depth offset m r:
    List.record_shift_vars (threshold + depth) offset (List.record_instantiate depth m r)
    =
    List.record_instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (List.record_shift_vars (threshold + List.length m + depth) offset r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars, List.record_instantiate]
  | cons le r =>
    have (l,e) := le
    simp [List.record_shift_vars, List.record_instantiate]
    apply And.intro
    { apply Expr.shift_vars_instantiate_inside_out }
    { apply Expr.record_shift_vars_instantiate_inside_out }

  theorem Expr.function_shift_vars_instantiate_inside_out threshold depth offset m f :
    List.function_shift_vars (threshold + depth) offset
      (List.function_instantiate depth m f)
    =
    List.function_instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (List.function_shift_vars (threshold + List.length m + depth) offset f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars, List.function_instantiate]
  | cons pe r =>
    have (p,e) := pe
    simp [List.function_shift_vars, List.function_instantiate]

    apply And.intro
    {
      have h0 :
        threshold + depth + Pattern.count_vars p
        =
        threshold + (depth + Pattern.count_vars p)
      := by exact Nat.add_assoc threshold depth (Pattern.count_vars p)

      have h1 :
        threshold + List.length m + depth + Pattern.count_vars p
        =
        threshold + List.length m + (depth + Pattern.count_vars p)
      := by exact Nat.add_assoc (threshold + List.length m) depth (Pattern.count_vars p)

      rw [h0,h1]
      apply Expr.shift_vars_instantiate_inside_out
    }
    { apply Expr.function_shift_vars_instantiate_inside_out }


  theorem Expr.shift_vars_instantiate_inside_out threshold depth offset m e :
    (Expr.shift_vars (threshold + depth) offset (Expr.instantiate depth m e))
    =
    (Expr.instantiate depth
      (Expr.list_shift_vars threshold offset m)
      (Expr.shift_vars (threshold + List.length m + depth) offset e)
    )
  := by cases e with
  | bvar i =>
    simp [Expr.instantiate]

    by_cases h0 : depth ≤ i
    {
      simp [h0]
      cases h1 : m[i - depth]? with
      | some arg =>
        simp [Expr.shift_vars]

        have h2 : i - depth < List.length m := by
          have ⟨h,g⟩ := Iff.mp List.getElem?_eq_some_iff h1
          exact h
        have h3 : i - depth < threshold + List.length m := by
          exact Nat.lt_add_left threshold h2
        have h4 : i < threshold + List.length m + depth := by
          exact Iff.mp (Nat.sub_lt_iff_lt_add h0) h3
        have h5 : ¬ (threshold + List.length m + depth) ≤ i := by
          exact Nat.not_le_of_lt h4

        simp [h5]
        simp [Expr.instantiate]
        simp [h0]
        have h6 := Expr.list_shift_vars_get_some_preservation threshold offset (i - depth) h1
        simp [h6]
        apply Expr.shift_vars_zero_inside_out

      | none =>
        simp
        simp [Expr.shift_vars]
        have h2 : List.length m ≤ i - depth := by
          exact Iff.mp List.getElem?_eq_none_iff h1

        by_cases h3 : threshold + depth ≤ i - List.length m
        { simp [h3]

          have h4 : List.length m ≤ i - depth + depth := by exact Nat.le_add_right_of_le h2
          have h5 : i - depth + depth = i := by exact Nat.sub_add_cancel h0
          rw [h5] at h4

          have h6 : threshold + depth + List.length m ≤ i := by
            exact Nat.add_le_of_le_sub h4 h3

          have h7 :
            threshold + depth + List.length m =  threshold + List.length m + depth
          := by exact Nat.add_right_comm threshold depth (List.length m)

          rw [h7] at h6
          simp [h6]
          simp [Expr.instantiate]

          have h8 : depth ≤ i + offset := by exact Nat.le_add_right_of_le h0
          simp [h8]
          have h9 := List.get_none_add_preservation m (i - depth) offset h1
          have h10 := Expr.list_shift_vars_get_none_preservation threshold offset (i - depth + offset) h9
          have h11 : (i - depth + offset) = (i + offset - depth) := by
            exact Eq.symm (Nat.sub_add_comm h0)
          rw [h11] at h10
          simp [h10]
          simp [Expr.list_shift_vars_length_eq]
          exact Eq.symm (Nat.sub_add_comm h4)
        }
        {
          simp [h3]
          have h4 : ¬ threshold + depth + List.length m ≤ i := by
            intro h
            apply h3
            exact Nat.le_sub_of_add_le h

          have h5 :
            threshold + depth + List.length m = threshold + List.length m + depth
          := by exact Nat.add_right_comm threshold depth (List.length m)
          rw [h5] at h4

          simp [h4]
          simp [Expr.instantiate]
          simp [h0]
          have h6 := Expr.list_shift_vars_get_none_preservation threshold offset (i - depth) h1
          simp [h6]
          simp [Expr.list_shift_vars_length_eq]
        }
    }
    { simp [h0]
      simp [Expr.shift_vars]
      have h1 : ¬ threshold + depth ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]

      have h2 : ¬ threshold + depth + List.length m ≤ i := by
        intro h
        apply h1
        exact Nat.le_of_add_right_le h

      have h3 :
        threshold + depth + List.length m = threshold + List.length m + depth
      := by exact Nat.add_right_comm threshold depth (List.length m)
      rw [h3] at h2

      simp [h2]
      simp [Expr.instantiate]
      simp [h0]
    }

  | fvar x =>
    simp [Expr.shift_vars, Expr.instantiate]
  | iso l body =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out
  | record r =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.record_shift_vars_instantiate_inside_out

  | function f =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.function_shift_vars_instantiate_inside_out

  | app ef ea =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply And.intro
    { apply Expr.shift_vars_instantiate_inside_out }
    { apply Expr.shift_vars_instantiate_inside_out }

  | anno body t =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out

  | loopi body =>
    simp [Expr.shift_vars, Expr.instantiate]
    apply Expr.shift_vars_instantiate_inside_out
end

theorem Expr.shift_vars_instantiate_zero_inside_out threshold offset m e :
  (Expr.shift_vars threshold offset (Expr.instantiate 0 m e))
  =
  (Expr.instantiate 0
    (Expr.list_shift_vars threshold offset m)
    (Expr.shift_vars (threshold + List.length m) offset e)
  )
:= by
  have h0 : threshold = threshold + 0 := by
    exact rfl
  rw [h0]
  rw [Expr.shift_vars_instantiate_inside_out threshold 0 offset m e]
  rfl


-- mutual
--   theorem Expr.record_shift_back_shift_vars_inside_out threshold depth offset level r:
--     List.record_shift_back (threshold + level + depth) offset (List.record_shift_vars level depth r) =
--     List.record_shift_vars level depth (List.record_shift_back (threshold + level) offset r)
--   := by cases r with
--   | nil =>
--     simp [List.record_shift_vars, List.record_shift_back]
--   | cons le f' =>
--     have (l,e) := le
--     simp [List.record_shift_vars, List.record_shift_back]
--     apply And.intro
--     { apply Expr.shift_back_shift_vars_inside_out }
--     { apply Expr.record_shift_back_shift_vars_inside_out }

--   theorem Expr.function_shift_back_shift_vars_inside_out threshold depth offset level f:
--     List.function_shift_back (threshold + level + depth) offset (List.function_shift_vars level depth f) =
--     List.function_shift_vars level depth (List.function_shift_back (threshold + level) offset f)
--   := by cases f with
--   | nil =>
--     simp [List.function_shift_vars, List.function_shift_back]
--   | cons pe f' =>
--     have (p,e) := pe
--     simp [List.function_shift_vars, List.function_shift_back]
--     apply And.intro
--     {
--       have h0 :
--        threshold + level + depth + Pattern.count_vars p =
--        threshold + level + Pattern.count_vars p + depth
--       := by exact Nat.add_right_comm (threshold + level) depth (Pattern.count_vars p)
--       rw [h0]

--       have h1 :
--        threshold + level + Pattern.count_vars p =
--        threshold + (level + Pattern.count_vars p)
--       := by exact Nat.add_assoc threshold level (Pattern.count_vars p)
--       rw [h1]
--       apply Expr.shift_back_shift_vars_inside_out
--     }
--     { apply Expr.function_shift_back_shift_vars_inside_out }

--   theorem Expr.shift_back_shift_vars_inside_out threshold depth offset level e:
--     Expr.shift_back (threshold + level + depth) offset (Expr.shift_vars level depth e) =
--     Expr.shift_vars level depth (Expr.shift_back (threshold + level) offset e)
--   := by cases e with
--   | bvar i =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     by_cases h0 : level ≤ i
--     { simp [h0]
--       simp [Expr.shift_back]
--       by_cases h1 : threshold + level + offset ≤ i
--       { simp [h1]
--         simp [Expr.shift_vars]

--         have h2 :
--           threshold + level + offset + depth ≤ i + depth
--         := by exact Nat.add_le_add_right h1 depth

--         have h3 :
--           threshold + level + offset + depth =
--           threshold + level + depth + offset
--         := by exact Nat.add_right_comm (threshold + level) offset depth

--         rw [h3] at h2
--         simp [h2]

--         rw [Nat.add_assoc] at h1
--         have h4 : level + offset ≤ i := by exact Nat.le_of_add_left_le h1

--         have h5 :  level ≤ i - offset := by exact Nat.le_sub_of_add_le h4
--         simp [h5]

--         have h6 : offset ≤ i := by exact Nat.le_of_add_left_le h4

--         exact Nat.sub_add_comm h6
--       }
--       { simp [h1]
--         simp [Expr.shift_vars]
--         simp [h0]
--         intro h2
--         apply False.elim
--         apply h1
--         have h3 :
--           threshold + level + depth + offset =
--           threshold + level + offset + depth
--         := by exact Nat.add_right_comm (threshold + level) depth offset

--         rw[h3] at h2
--         exact Iff.mp Nat.add_le_add_iff_right h2
--       }
--     }
--     { simp [h0]
--       simp [Expr.shift_back]
--       have h1 :  ¬ threshold + level ≤ i := by
--         intro h
--         apply h0
--         exact Nat.le_of_add_left_le h

--       have h2 :  ¬ threshold + level + offset ≤ i := by
--         intro h
--         apply h1
--         exact Nat.le_of_add_right_le h

--       simp [h2]
--       simp [Expr.shift_vars]
--       simp [h0]
--       intro h3
--       apply False.elim
--       apply h2
--       have h4 :
--         threshold + level + depth + offset =
--         threshold + level + offset + depth
--       := by exact Nat.add_right_comm (threshold + level) depth offset
--       rw [h4] at h3
--       exact Nat.le_of_add_right_le h3
--     }
--   | fvar x =>
--     simp [Expr.shift_back, Expr.shift_vars]
--   | iso l body =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply Expr.shift_back_shift_vars_inside_out
--   | record r =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply Expr.record_shift_back_shift_vars_inside_out

--   | function f =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply Expr.function_shift_back_shift_vars_inside_out

--   | app ef ea =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply And.intro
--     { apply Expr.shift_back_shift_vars_inside_out }
--     { apply Expr.shift_back_shift_vars_inside_out }

--   | anno body t =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply Expr.shift_back_shift_vars_inside_out

--   | loopi body =>
--     simp [Expr.shift_back, Expr.shift_vars]
--     apply Expr.shift_back_shift_vars_inside_out
-- end

-- theorem Expr.shift_back_shift_vars_zero_inside_out threshold depth offset e:
--   Expr.shift_back (threshold + depth) offset (Expr.shift_vars 0 depth e) =
--   Expr.shift_vars 0 depth (Expr.shift_back threshold offset e)
-- := by exact shift_back_shift_vars_inside_out threshold depth offset 0 e




-- mutual
--   theorem Expr.record_shift_back_instantiate_inside_out threshold depth offset m r:
--     List.record_shift_back (threshold + depth) offset (List.record_instantiate depth m r)
--     =
--     List.record_instantiate depth
--       (Expr.list_shift_back threshold offset m)
--       (List.record_shift_back (threshold + List.length m + depth) offset r)
--   := by cases r with
--   | nil =>
--     simp [List.record_shift_back, List.record_instantiate]
--   | cons le r =>
--     have (l,e) := le
--     simp [List.record_shift_back, List.record_instantiate]
--     apply And.intro
--     { apply Expr.shift_back_instantiate_inside_out }
--     { apply Expr.record_shift_back_instantiate_inside_out }

--   theorem Expr.function_shift_back_instantiate_inside_out threshold depth offset m f :
--     List.function_shift_back (threshold + depth) offset
--       (List.function_instantiate depth m f)
--     =
--     List.function_instantiate depth
--       (Expr.list_shift_back threshold offset m)
--       (List.function_shift_back (threshold + List.length m + depth) offset f)
--   := by cases f with
--   | nil =>
--     simp [List.function_shift_back, List.function_instantiate]
--   | cons pe r =>
--     have (p,e) := pe
--     simp [List.function_shift_back, List.function_instantiate]

--     apply And.intro
--     {
--       have h0 :
--         threshold + depth + Pattern.count_vars p
--         =
--         threshold + (depth + Pattern.count_vars p)
--       := by exact Nat.add_assoc threshold depth (Pattern.count_vars p)

--       have h1 :
--         threshold + List.length m + depth + Pattern.count_vars p
--         =
--         threshold + List.length m + (depth + Pattern.count_vars p)
--       := by exact Nat.add_assoc (threshold + List.length m) depth (Pattern.count_vars p)

--       rw [h0,h1]
--       apply Expr.shift_back_instantiate_inside_out
--     }
--     { apply Expr.function_shift_back_instantiate_inside_out }


--   theorem Expr.shift_back_instantiate_inside_out threshold depth offset m e :
--     (Expr.shift_back (threshold + depth) offset (Expr.instantiate depth m e))
--     =
--     (Expr.instantiate depth
--       (Expr.list_shift_back threshold offset m)
--       (Expr.shift_back (threshold + List.length m + depth) offset e)
--     )
--   := by cases e with
--   | bvar i =>
--     simp [Expr.instantiate]
--     by_cases h0 : depth ≤ i
--     {
--       simp [h0]
--       cases h1 : m[i - depth]? with
--       | some arg =>
--         simp [Expr.shift_back]

--         have h2 : i - depth < List.length m := by
--           have ⟨h,g⟩ := Iff.mp List.getElem?_eq_some_iff h1
--           exact h
--         have h3 : i - depth < threshold + List.length m := by
--           exact Nat.lt_add_left threshold h2
--         have h4 : i < threshold + List.length m + depth := by
--           exact Iff.mp (Nat.sub_lt_iff_lt_add h0) h3

--         have h5 : i < threshold + List.length m + depth + offset := by
--           exact Nat.lt_add_right offset h4

--         have h6 : ¬ (threshold + List.length m + depth + offset) ≤ i := by
--           exact Nat.not_le_of_lt h5

--         simp [h6]
--         simp [Expr.instantiate]
--         simp [h0]
--         have h7 := Expr.list_shift_back_get_some_preservation threshold offset (i - depth) h1
--         simp [h7]
--         exact shift_back_shift_vars_zero_inside_out threshold depth offset arg

--       | none =>
--         simp
--         simp [Expr.shift_back]
--         have h2 : List.length m ≤ i - depth := by
--           exact Iff.mp List.getElem?_eq_none_iff h1

--         by_cases h3 : threshold + depth + offset ≤ i - List.length m
--         { simp [h3]

--           have h4 : List.length m ≤ i - depth + depth := by exact Nat.le_add_right_of_le h2
--           have h5 : i - depth + depth = i := by exact Nat.sub_add_cancel h0
--           rw [h5] at h4

--           have h6 : threshold + depth + offset + List.length m ≤ i := by
--             exact Nat.add_le_of_le_sub h4 h3

--           have h7 :
--             threshold + depth + offset + List.length m =  threshold + depth + List.length m + offset
--           := by exact Nat.add_right_comm (threshold + depth) offset (List.length m)
--           rw [h7] at h6

--           have h8 :
--              threshold + depth + List.length m =
--              threshold + List.length m + depth
--           := by exact Nat.add_right_comm threshold depth (List.length m)

--           rw [h8] at h6
--           simp [h6]
--           simp [Expr.instantiate]


--           have h9 : threshold + List.length m + depth  ≤ i - offset := by
--             exact Nat.le_sub_of_add_le h6

--           have h10 : depth  ≤ i - offset := by
--             exact Nat.le_of_add_left_le h9

--           simp [h10]


--           have h11 : threshold + List.length m ≤ i - offset - depth := by
--             exact Nat.le_sub_of_add_le h9

--           have h12 : List.length m ≤ i - offset - depth := by
--             exact Nat.le_of_add_left_le h11

--           have h13 : m[i - offset - depth]? = none := by
--             exact Iff.mpr List.getElem?_eq_none_iff h12

--           apply Expr.list_shift_back_get_none_preservation threshold offset at h13

--           simp [h13]
--           rw [Expr.list_shift_back_length_eq]
--           exact Nat.sub_right_comm i (List.length m) offset
--         }
--         {
--           simp [h3]

--           have h4 : ¬ threshold + depth + offset +List.length m ≤ i := by
--             intro h
--             apply h3
--             exact Nat.le_sub_of_add_le h

--           have h5 :
--             threshold + depth + offset + List.length m = threshold + depth + List.length m + offset
--           := by exact Nat.add_right_comm (threshold + depth) offset (List.length m)
--           rw [h5] at h4

--           have h6 :
--             threshold + depth + List.length m = threshold + List.length m + depth
--           := by exact Nat.add_right_comm threshold depth (List.length m)
--           rw [h6] at h4

--           simp [h4]
--           simp [Expr.instantiate]
--           simp [h0]
--           have h6 := Expr.list_shift_back_get_none_preservation threshold offset (i - depth) h1
--           simp [h6]
--           simp [Expr.list_shift_back_length_eq]
--         }
--     }
--     { simp [h0]
--       simp [Expr.shift_back]
--       have h1 : ¬ threshold + depth ≤ i := by
--         intro h
--         apply h0
--         exact Nat.le_of_add_left_le h

--       have h2 : ¬ threshold + depth + offset ≤ i := by
--         intro h
--         apply h1
--         exact Nat.le_of_add_right_le h
--       simp [h2]

--       have h3 : ¬ threshold + depth + offset + List.length m ≤ i := by
--         intro h
--         apply h2
--         exact Nat.le_of_add_right_le h

--       have h4 :
--         threshold + depth + offset + List.length m =
--         threshold + depth + List.length m + offset
--       := by exact Nat.add_right_comm (threshold + depth) offset (List.length m)
--       rw [h4] at h3

--       have h5 :
--         threshold + depth + List.length m =
--         threshold + List.length m + depth
--       := by exact Nat.add_right_comm threshold depth (List.length m)
--       rw [h5] at h3

--       simp [h3]
--       simp [Expr.instantiate]
--       simp [h0]
--     }

--   | fvar x =>
--     simp [Expr.shift_back, Expr.instantiate]
--   | iso l body =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply Expr.shift_back_instantiate_inside_out
--   | record r =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply Expr.record_shift_back_instantiate_inside_out

--   | function f =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply Expr.function_shift_back_instantiate_inside_out

--   | app ef ea =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply And.intro
--     { apply Expr.shift_back_instantiate_inside_out }
--     { apply Expr.shift_back_instantiate_inside_out }

--   | anno body t =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply Expr.shift_back_instantiate_inside_out

--   | loopi body =>
--     simp [Expr.shift_back, Expr.instantiate]
--     apply Expr.shift_back_instantiate_inside_out
-- end


-- theorem Expr.shift_back_instantiate_zero_inside_out threshold offset m e :
--   (Expr.shift_back threshold offset (Expr.instantiate 0 m e))
--   =
--   (Expr.instantiate 0
--     (Expr.list_shift_back threshold offset m)
--     (Expr.shift_back (threshold + List.length m) offset e)
--   )
-- := by
--   have h0 : threshold = threshold + 0 := by
--     exact rfl
--   rw [h0]
--   rw [Expr.shift_back_instantiate_inside_out threshold 0 offset m e]
--   rfl


mutual
  theorem Pattern.match_entry_shift_vars_preservation :
    Pattern.match_entry l p r = some m →
    ∀ threshold offset,
    Pattern.match_entry l p (List.record_shift_vars threshold offset r)
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases r with
  | nil =>
    simp [Pattern.match_entry]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.record_shift_vars, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_shift_vars_preservation h1
    }
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_entry_shift_vars_preservation h1
    }

  theorem Pattern.match_record_shift_vars_preservation :
    Pattern.match_record r ps = some m →
    ∀ threshold offset,
    Pattern.match_record (List.record_shift_vars threshold offset r) ps
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
    intro h0
    simp [*, Expr.list_shift_vars]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (Pattern.match_entry l p r),
      h1 : (Pattern.match_record r ps')
    with
    | some m0, some m1 =>
      simp
      intro h3 threshold offset
      rw [←h3]

      have ih0 := Pattern.match_entry_shift_vars_preservation h0 threshold offset
      have ih1 := Pattern.match_record_shift_vars_preservation h1 threshold offset
      simp [ih0,ih1]
      exact Expr.list_shift_vars_concat
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_shift_vars_preservation :
    Pattern.match arg p = some m →
    ∀ threshold offset,
    Pattern.match (Expr.shift_vars threshold offset arg) p
    =
    some (Expr.list_shift_vars threshold offset m)
  := by cases p with
  | var x =>
    simp [Pattern.match]
    intro h0 h1
    simp [←h1]
    simp [Expr.list_shift_vars,h0]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Pattern.match, Expr.shift_vars]
      intro h0 h1 threshold offset
      simp [*]
      apply Pattern.match_shift_vars_preservation h1 threshold offset
    | _ =>
      simp [Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Pattern.match, Expr.shift_vars]
      intro h0 h1 threshold offset
      apply And.intro
      { exact Expr.record_shift_vars_keys_unique_preservation h0 }
      { apply Pattern.match_record_shift_vars_preservation h1}
    | _ =>
      simp [Pattern.match]
end

-- mutual
--   theorem Pattern.match_entry_shift_back_preservation :
--     Pattern.match_entry l p r = some m →
--     ∀ threshold offset,
--     Pattern.match_entry l p (List.record_shift_back threshold offset r)
--     =
--     some (Expr.list_shift_back threshold offset m)
--   := by cases r with
--   | nil =>
--     simp [Pattern.match_entry]
--   | cons le r' =>
--     have (l',e) := le
--     simp [*,List.record_shift_back, Pattern.match_entry]
--     by_cases h0 : l' = l
--     { simp [*]
--       intro h1 threshold offset
--       apply Pattern.match_shift_back_preservation h1
--     }
--     { simp [*]
--       intro h1 threshold offset
--       apply Pattern.match_entry_shift_back_preservation h1
--     }

--   theorem Pattern.match_record_shift_back_preservation :
--     Pattern.match_record r ps = some m →
--     ∀ threshold offset,
--     Pattern.match_record (List.record_shift_back threshold offset r) ps
--     =
--     some (Expr.list_shift_back threshold offset m)
--   := by cases ps with
--   | nil =>
--     simp [Pattern.match_record]
--     intro h0
--     simp [*, Expr.list_shift_back]
--   | cons lp ps' =>
--     have (l,p) := lp
--     simp [Pattern.match_record]

--     match
--       h0 : (Pattern.match_entry l p r),
--       h1 : (Pattern.match_record r ps')
--     with
--     | some m0, some m1 =>
--       simp
--       intro h3 threshold offset
--       rw [←h3]

--       have ih0 := Pattern.match_entry_shift_back_preservation h0 threshold offset
--       have ih1 := Pattern.match_record_shift_back_preservation h1 threshold offset
--       simp [ih0,ih1]
--       exact Expr.list_shift_back_concat
--     | none,_ =>
--       simp
--     | _,none =>
--       simp

--   theorem Pattern.match_shift_back_preservation :
--     Pattern.match arg p = some m →
--     ∀ threshold offset,
--     Pattern.match (Expr.shift_back threshold offset arg) p
--     =
--     some (Expr.list_shift_back threshold offset m)
--   := by cases p with
--   | var x  =>
--     simp [Pattern.match]
--     intro h0 h1
--     simp [←h1]
--     simp [Expr.list_shift_back,h0]
--   | iso l pb =>
--     cases arg with
--     | iso l' b =>
--       simp [Pattern.match, Expr.shift_back]
--       intro h0 h1 threshold offset
--       simp [*]
--       apply Pattern.match_shift_back_preservation h1 threshold offset
--     | _ =>
--       simp [Pattern.match]
--   | record ps =>
--     cases arg with
--     | record r =>
--       simp [Pattern.match, Expr.shift_back]
--       intro h0 h1 threshold offset
--       apply And.intro
--       { exact Expr.record_shift_back_keys_unique_preservation h0 }
--       { apply Pattern.match_record_shift_back_preservation h1}
--     | _ =>
--       simp [Pattern.match]
-- end


mutual
  theorem Pattern.match_entry_shift_vars_reflection :
    Expr.record_valued r →
    Pattern.match_entry l p (List.record_shift_vars threshold offset r) = some m' →
    ∃ m, Pattern.match_entry l p r = some m
  := by cases r with
  | nil =>
    simp [Expr.record_valued, Pattern.match_entry, List.record_shift_vars]
  | cons le r' =>
    have (l',e) := le
    simp [*,Expr.record_valued, List.record_shift_vars, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_shift_vars_reflection h2
    }
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_entry_shift_vars_reflection h3
    }

  theorem Pattern.match_record_shift_vars_reflection :
    Expr.record_valued r →
    Pattern.match_record (List.record_shift_vars threshold offset r) ps = some m' →
    ∃ m , Pattern.match_record r ps = some m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (match_entry l p (List.record_shift_vars threshold offset r)),
      h1 : (Pattern.match_record (List.record_shift_vars threshold offset r) ps')
    with
    | some m0', some m1' =>
      simp
      intro isval h3
      have ⟨m0,ih0⟩ := Pattern.match_entry_shift_vars_reflection isval h0
      have ⟨m1,ih1⟩ := Pattern.match_record_shift_vars_reflection isval h1
      simp [ih0,ih1]
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_shift_vars_reflection :
    Expr.valued arg →
    Pattern.match (Expr.shift_vars threshold offset arg) p = some m' →
    ∃ m, Pattern.match arg p = some m
  := by cases p with
  | var x  =>
    simp [Pattern.match]
    intro h0 h1
    simp [h1]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Expr.valued, Pattern.match, Expr.shift_vars]
      intro isval h0 h1
      simp [*]
      apply Pattern.match_shift_vars_reflection isval h1
    | _ =>
      simp [Expr.valued, Pattern.match, Expr.shift_vars]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.valued, Pattern.match, Expr.shift_vars]
      intro ival h0 h1
      apply And.intro
      { exact Expr.record_shift_vars_keys_unique_reflection h0 }
      { apply Pattern.match_record_shift_vars_reflection ival h1 }
    | _ =>
      simp [Expr.valued, Pattern.match, Expr.shift_vars]
end

-- mutual
--   theorem Pattern.match_entry_shift_back_reflection :
--     Expr.record_valued r →
--     Pattern.match_entry l p (List.record_shift_back threshold offset r) = some m' →
--     ∃ m, Pattern.match_entry l p r = some m
--   := by cases r with
--   | nil =>
--     simp [Expr.record_valued, Pattern.match_entry, List.record_shift_back]
--   | cons le r' =>
--     have (l',e) := le
--     simp [*,Expr.record_valued, List.record_shift_back, Pattern.match_entry]
--     by_cases h0 : l' = l
--     { simp [*]
--       intro h1 h2 h3
--       apply Pattern.match_shift_back_reflection h2
--     }
--     { simp [*]
--       intro h1 h2 h3
--       apply Pattern.match_entry_shift_back_reflection h3
--     }

--   theorem Pattern.match_record_shift_back_reflection :
--     Expr.record_valued r →
--     Pattern.match_record (List.record_shift_back threshold offset r) ps = some m' →
--     ∃ m , Pattern.match_record r ps = some m
--   := by cases ps with
--   | nil =>
--     simp [Pattern.match_record]
--   | cons lp ps' =>
--     have (l,p) := lp
--     simp [Pattern.match_record]

--     match
--       h0 : (match_entry l p (List.record_shift_back threshold offset r)),
--       h1 : (Pattern.match_record (List.record_shift_back threshold offset r) ps')
--     with
--     | some m0', some m1' =>
--       simp
--       intro isval h3

--       have ⟨m0,ih0⟩ := Pattern.match_entry_shift_back_reflection isval h0
--       have ⟨m1,ih1⟩ := Pattern.match_record_shift_back_reflection isval h1
--       simp [ih0,ih1]
--     | none,_ =>
--       simp
--     | _,none =>
--       simp

--   theorem Pattern.match_shift_back_reflection :
--     Expr.valued arg →
--     Pattern.match (Expr.shift_back threshold offset arg) p = some m' →
--     ∃ m, Pattern.match arg p = some m
--   := by cases p with
--   | var x  =>
--     simp [Pattern.match]
--     intro h0 h1
--     simp [h1]
--   | iso l pb =>
--     cases arg with
--     | iso l' b =>
--       simp [Expr.valued, Pattern.match, Expr.shift_back]
--       intro isval h0 h1
--       simp [*]
--       apply Pattern.match_shift_back_reflection isval h1
--     | _ =>
--       simp [Expr.valued, Pattern.match, Expr.shift_back]
--   | record ps =>
--     cases arg with
--     | record r =>
--       simp [Expr.valued, Pattern.match, Expr.shift_back]
--       intro ival h0 h1
--       apply And.intro
--       { exact Expr.record_shift_back_keys_unique_reflection h0 }
--       { apply Pattern.match_record_shift_back_reflection ival h1 }
--     | _ =>
--       simp [Expr.valued, Pattern.match, Expr.shift_back]
-- end

mutual

  theorem Expr.record_valued_shift_vars_preservation :
    Expr.record_valued r = true →
    ∀ (threshold offset : ℕ), Expr.record_valued (List.record_shift_vars threshold offset r) = true
  := by cases r with
  | nil =>
    simp [Expr.record_valued, List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [Expr.record_valued, List.record_shift_vars]
    intro h0 h1 h2 threshold offset
    apply And.intro
    {
      apply And.intro
      { exact record_shift_vars_key_fresh_preservation h0 }
      { apply Expr.valued_shift_vars_preservation h1 }
    }
    { apply Expr.record_valued_shift_vars_preservation h2 }


  theorem Expr.valued_shift_vars_preservation :
    (Expr.valued e) →
    ∀ threshold offset, (Expr.valued (Expr.shift_vars threshold offset e))
  := by cases e with
  | bvar i =>
    simp [Expr.valued]
  | fvar x =>
    simp [Expr.valued]
  | iso l body =>
    simp [Expr.valued]
    intro isval threshold offset
    apply Expr.valued_shift_vars_preservation isval
  | record r =>
    simp [Expr.valued, Expr.shift_vars]
    apply Expr.record_valued_shift_vars_preservation
  | function f =>
    simp [Expr.valued, Expr.shift_vars]
  | _ =>
    simp [Expr.valued, Expr.shift_vars]
end

-- mutual

--   theorem Expr.record_valued_shift_back_preservation :
--     Expr.record_valued r = true →
--     ∀ (threshold offset : ℕ), Expr.record_valued (List.record_shift_back threshold offset r) = true
--   := by cases r with
--   | nil =>
--     simp [Expr.record_valued, List.record_shift_back]
--   | cons le r' =>
--     have (l,e) := le
--     simp [Expr.record_valued, List.record_shift_back]
--     intro h0 h1 h2 threshold offset
--     apply And.intro
--     {
--       apply And.intro
--       { exact record_shift_back_key_fresh_preservation h0 }
--       { apply Expr.valued_shift_back_preservation h1 }
--     }
--     { apply Expr.record_valued_shift_back_preservation h2 }


--   theorem Expr.valued_shift_back_preservation :
--     (Expr.valued e) →
--     ∀ threshold offset, (Expr.valued (Expr.shift_back threshold offset e))
--   := by cases e with
--   | bvar i =>
--     simp [Expr.valued]
--   | fvar x =>
--     simp [Expr.valued]
--   | iso l body =>
--     simp [Expr.valued]
--     intro isval threshold offset
--     apply Expr.valued_shift_back_preservation isval
--   | record r =>
--     simp [Expr.valued, Expr.shift_back]
--     apply Expr.record_valued_shift_back_preservation
--   | function f =>
--     simp [Expr.valued, Expr.shift_back]
--   | _ =>
--     simp [Expr.valued, Expr.shift_back]
-- end

mutual

  theorem Pattern.record_skip_shift_vars_preservation :
    Expr.record_valued r →
    match_record r ps = none →
    ∀ (threshold offset : ℕ),
    match_record (List.record_shift_vars threshold offset r) ps = none
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    intro isval h0 threshold offset m0' h2 m1' h3
    have ⟨m0,h4⟩ := Pattern.match_entry_shift_vars_reflection isval h2
    have ⟨m1,h5⟩ := Pattern.match_record_shift_vars_reflection isval h3
    apply h0 _ h4 _ h5


  theorem Pattern.skip_shift_vars_preservation :
    Expr.valued arg →
    Pattern.match arg p = none →
    ∀ threshold offset, Pattern.match (Expr.shift_vars threshold offset arg) p = none
  := by cases p with
  | var x =>
    simp [Pattern.match]
  | iso l bp =>
    cases arg with
    | iso l' body =>
      simp [Expr.valued, Expr.shift_vars, Pattern.match]
      intro isval h0 threshold offset h1
      apply Pattern.skip_shift_vars_preservation isval (h0 h1)
    | _ =>
      simp [Expr.valued, Expr.shift_vars, Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.valued, Expr.shift_vars, Pattern.match]
      intro isval h0 threshold offset h2
      apply Pattern.record_skip_shift_vars_preservation isval
      apply h0
      exact Expr.record_shift_vars_keys_unique_reflection h2
    | _ =>
      simp [Expr.valued, Expr.shift_vars, Pattern.match]
end

-- mutual

--   theorem Pattern.record_skip_shift_back_preservation :
--     Expr.record_valued r →
--     match_record r ps = none →
--     ∀ (threshold offset : ℕ),
--     match_record (List.record_shift_back threshold offset r) ps = none
--   := by cases ps with
--   | nil =>
--     simp [Pattern.match_record]
--   | cons lp ps' =>
--     have (l,p) := lp
--     simp [Pattern.match_record]

--     intro isval h0 threshold offset m0' h2 m1' h3
--     have ⟨m0,h4⟩ := Pattern.match_entry_shift_back_reflection isval h2
--     have ⟨m1,h5⟩ := Pattern.match_record_shift_back_reflection isval h3
--     apply h0 _ h4 _ h5


--   theorem Pattern.skip_shift_back_preservation :
--     Expr.valued arg →
--     Pattern.match arg p = none →
--     ∀ threshold offset, Pattern.match (Expr.shift_back threshold offset arg) p = none
--   := by cases p with
--   | var x =>
--     simp [Pattern.match]
--   | iso l bp =>
--     cases arg with
--     | iso l' body =>
--       simp [Expr.valued, Expr.shift_back, Pattern.match]
--       intro isval h0 threshold offset h1
--       apply Pattern.skip_shift_back_preservation isval (h0 h1)
--     | _ =>
--       simp [Expr.valued, Expr.shift_back, Pattern.match]
--   | record ps =>
--     cases arg with
--     | record r =>
--       simp [Expr.valued, Expr.shift_back, Pattern.match]
--       intro isval h0 threshold offset h2
--       apply Pattern.record_skip_shift_back_preservation isval
--       apply h0
--       exact Expr.record_shift_back_keys_unique_reflection h2
--     | _ =>
--       simp [Expr.valued, Expr.shift_back, Pattern.match]
-- end


mutual

  theorem Expr.record_valued_instantiate_preservation :
    Expr.record_valued r = true →
    ∀ depth d, Expr.record_valued (List.record_instantiate depth d r) = true
  := by cases r with
  | nil =>
    simp [Expr.record_valued, List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [Expr.record_valued, List.record_instantiate]
    intro h0 h1 h2 depth d
    apply And.intro
    {
      apply And.intro
      { exact record_instantiate_key_fresh_preservation h0 }
      { apply Expr.valued_instantiate_preservation h1 }
    }
    { apply Expr.record_valued_instantiate_preservation h2 }


  theorem Expr.valued_instantiate_preservation :
    (Expr.valued e) →
    ∀ depth d, (Expr.valued (Expr.instantiate depth d e))
  := by cases e with
  | bvar i =>
    simp [Expr.valued]
  | fvar x =>
    simp [Expr.valued]
  | iso l body =>
    simp [Expr.valued]
    intro isval depth d
    apply Expr.valued_instantiate_preservation isval
  | record r =>
    simp [Expr.valued, Expr.instantiate]
    apply Expr.record_valued_instantiate_preservation
  | function f =>
    simp [Expr.valued, Expr.instantiate]
  | _ =>
    simp [Expr.valued, Expr.instantiate]
end

mutual

  theorem Expr.record_shift_vars_add threshold o d r :
    List.record_shift_vars threshold (o + d) r =
    List.record_shift_vars threshold d (List.record_shift_vars threshold o r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.record_shift_vars_add }

  theorem Expr.function_shift_vars_add threshold o d f :
    List.function_shift_vars threshold (o + d) f =
    List.function_shift_vars threshold d (List.function_shift_vars threshold o f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.function_shift_vars_add }

  theorem Expr.shift_vars_add threshold o d e :
    Expr.shift_vars threshold (o + d) e =
    Expr.shift_vars threshold d (Expr.shift_vars threshold o e)
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars]
    by_cases h0 : threshold ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : threshold ≤ i + o := by exact Nat.le_add_right_of_le h0
      simp [h1]
      exact Eq.symm (Nat.add_assoc i o d)
    }
    { simp [h0]
      simp [Expr.shift_vars]
      intro h1
      apply False.elim
      apply h0 h1
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_add

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_add

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_add }
    { apply Expr.shift_vars_add }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_add
end



mutual
  theorem Pattern.match_entry_instantiate_preservation :
    Pattern.match_entry l p r = some m →
    ∀ depth d,
    Pattern.match_entry l p (List.record_instantiate depth d r)
    =
    some (Expr.list_instantiate depth d m)
  := by cases r with
  | nil =>
    simp [Pattern.match_entry]
  | cons le r' =>
    have (l',e) := le
    simp [*,List.record_instantiate, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_instantiate_preservation h1
    }
    { simp [*]
      intro h1 threshold offset
      apply Pattern.match_entry_instantiate_preservation h1
    }

  theorem Pattern.match_record_instantiate_preservation :
    Pattern.match_record r ps = some m →
    ∀ depth d,
    Pattern.match_record (List.record_instantiate depth d r) ps
    =
    some (Expr.list_instantiate depth d m)
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
    intro h0
    simp [*, Expr.list_instantiate]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (Pattern.match_entry l p r),
      h1 : (Pattern.match_record r ps')
    with
    | some m0, some m1 =>
      simp
      intro h3 threshold offset
      rw [←h3]

      have ih0 := Pattern.match_entry_instantiate_preservation h0 threshold offset
      have ih1 := Pattern.match_record_instantiate_preservation h1 threshold offset
      simp [ih0,ih1]
      exact Expr.list_instantiate_concat
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_instantiate_preservation :
    Pattern.match arg p = some m →
    ∀ depth d,
    Pattern.match (Expr.instantiate depth d arg) p
    =
    some (Expr.list_instantiate depth d m)
  := by cases p with
  | var x  =>
    simp [Pattern.match]
    intro h0 h1
    simp [←h1]
    simp [Expr.list_instantiate,h0]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Pattern.match, Expr.instantiate]
      intro h0 h1 threshold offset
      simp [*]
      apply Pattern.match_instantiate_preservation h1 threshold offset
    | _ =>
      simp [Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Pattern.match, Expr.instantiate]
      intro h0 h1 threshold offset
      apply And.intro
      { exact Expr.record_instantiate_keys_unique_preservation h0 }
      { apply Pattern.match_record_instantiate_preservation h1}
    | _ =>
      simp [Pattern.match]
end


mutual
  theorem Pattern.match_entry_instantiate_reflection :
    Expr.record_valued r →
    Pattern.match_entry l p (List.record_instantiate depth d r) = some m' →
    ∃ m, Pattern.match_entry l p r = some m
  := by cases r with
  | nil =>
    simp [Expr.record_valued, Pattern.match_entry, List.record_instantiate]
  | cons le r' =>
    have (l',e) := le
    simp [*,Expr.record_valued, List.record_instantiate, Pattern.match_entry]
    by_cases h0 : l' = l
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_instantiate_reflection h2
    }
    { simp [*]
      intro h1 h2 h3
      apply Pattern.match_entry_instantiate_reflection h3
    }

  theorem Pattern.match_record_instantiate_reflection :
    Expr.record_valued r →
    Pattern.match_record (List.record_instantiate depth d r) ps = some m' →
    ∃ m , Pattern.match_record r ps = some m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    match
      h0 : (match_entry l p (List.record_instantiate depth d r)),
      h1 : (Pattern.match_record (List.record_instantiate depth d r) ps')
    with
    | some m0', some m1' =>
      simp
      intro isval h3

      have ⟨m0,ih0⟩ := Pattern.match_entry_instantiate_reflection isval h0
      have ⟨m1,ih1⟩ := Pattern.match_record_instantiate_reflection isval h1
      simp [ih0,ih1]
    | none,_ =>
      simp
    | _,none =>
      simp

  theorem Pattern.match_instantiate_reflection :
    Expr.valued arg →
    Pattern.match (Expr.instantiate offset d arg) p = some m' →
    ∃ m, Pattern.match arg p = some m
  := by cases p with
  | var x  =>
    simp [Pattern.match]
    intro h0 h1
    simp [h1]
  | iso l pb =>
    cases arg with
    | iso l' b =>
      simp [Expr.valued, Pattern.match, Expr.instantiate]
      intro isval h0 h1
      simp [*]
      apply Pattern.match_instantiate_reflection isval h1
    | _ =>
      simp [Expr.valued, Pattern.match, Expr.instantiate]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.valued, Pattern.match, Expr.instantiate]
      intro ival h0 h1
      apply And.intro
      { exact Expr.record_instantiate_keys_unique_reflection h0 }
      { apply Pattern.match_record_instantiate_reflection ival h1 }
    | _ =>
      simp [Expr.valued, Pattern.match, Expr.instantiate]
end


mutual

  theorem Pattern.record_skip_instantiate_preservation :
    Expr.record_valued r →
    match_record r ps = none →
    ∀ depth d,
    match_record (List.record_instantiate depth d r) ps = none
  := by cases ps with
  | nil =>
    simp [Pattern.match_record]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record]

    intro isval h0 depth d m0' h2 m1' h3
    have ⟨m0,h4⟩ := Pattern.match_entry_instantiate_reflection isval h2
    have ⟨m1,h5⟩ := Pattern.match_record_instantiate_reflection isval h3
    apply h0 _ h4 _ h5


  theorem Pattern.skip_instantiate_preservation :
    Expr.valued arg →
    Pattern.match arg p = none →
    ∀ depth d, Pattern.match (Expr.instantiate depth d arg) p = none
  := by cases p with
  | var x =>
    simp [Pattern.match]
  | iso l bp =>
    cases arg with
    | iso l' body =>
      simp [Expr.valued, Expr.instantiate, Pattern.match]
      intro isval h0 depth d h1
      apply Pattern.skip_instantiate_preservation isval (h0 h1)
    | _ =>
      simp [Expr.valued, Expr.instantiate, Pattern.match]
  | record ps =>
    cases arg with
    | record r =>
      simp [Expr.valued, Expr.instantiate, Pattern.match]
      intro isval h0 depth d h2
      apply Pattern.record_skip_instantiate_preservation isval
      apply h0
      exact Expr.record_instantiate_keys_unique_reflection h2
    | _ =>
      simp [Expr.valued, Expr.instantiate, Pattern.match]
end



mutual
  theorem Expr.record_shift_vars_level_drop level z depth offset r :
    List.record_shift_vars (level + z) depth (List.record_shift_vars z (offset + level) r) =
    List.record_shift_vars z depth (List.record_shift_vars z (offset + level) r)
  := by cases r with
  | nil =>
    simp [List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars]
    apply And.intro
    { apply Expr.shift_vars_level_drop }
    { apply Expr.record_shift_vars_level_drop }

  theorem Expr.function_shift_vars_level_drop level z depth offset f :
    List.function_shift_vars (level + z) depth (List.function_shift_vars z (offset + level) f) =
    List.function_shift_vars z depth (List.function_shift_vars z (offset + level) f)
  := by cases f with
  | nil =>
    simp [List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars]
    apply And.intro
    {
      have h0 : level + z + Pattern.count_vars p = level + (z + Pattern.count_vars p) := by
        exact Nat.add_assoc level z (Pattern.count_vars p)
      rw [h0]
      apply Expr.shift_vars_level_drop
    }
    { apply Expr.function_shift_vars_level_drop }


  theorem Expr.shift_vars_level_drop level z depth offset e :
    Expr.shift_vars (level + z) depth (Expr.shift_vars z (offset + level) e) =
    Expr.shift_vars z depth (Expr.shift_vars z (offset + level) e)
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars]
    by_cases h0 : z ≤ i
    { simp [h0]
      simp [Expr.shift_vars]

      have h1 : z ≤ i + (offset + level) := by exact Nat.le_add_right_of_le h0
      simp [h1]
      intro h2

      apply False.elim

      have h3 : i + (offset + level) = i + offset + level := by
        exact Eq.symm (Nat.add_assoc i offset level)
      rw [h3] at h2

      have h4 : i + offset + level = level + (i + offset) := by
        exact Eq.symm (Nat.add_comm level (i + offset))
      rw [h4] at h2

      have h5 : i + offset < z := by exact Nat.lt_of_add_lt_add_left h2

      have  h6 : i < z := by exact Nat.lt_of_add_right_lt h5

      have h7 : ¬ z ≤ i := by exact Nat.not_le_of_lt h6

      apply h7 h0

    }
    { simp [h0]
      simp [Expr.shift_vars]
      simp [h0]
      intro h1
      apply False.elim
      have h2 : z ≤ i := by exact Nat.le_of_add_left_le h1
      apply h0 h2
    }
  | fvar x =>
    simp [Expr.shift_vars]
  | iso l body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop
  | record r =>
    simp [Expr.shift_vars]
    apply Expr.record_shift_vars_level_drop

  | function f =>
    simp [Expr.shift_vars]
    apply Expr.function_shift_vars_level_drop

  | app ef ea =>
    simp [Expr.shift_vars]
    apply And.intro
    { apply Expr.shift_vars_level_drop }
    { apply Expr.shift_vars_level_drop }

  | anno body t =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop

  | loopi body =>
    simp [Expr.shift_vars]
    apply Expr.shift_vars_level_drop
end

theorem Expr.shift_vars_level_drop_to_zero :
  Expr.shift_vars level depth (Expr.shift_vars 0 (offset + level) e) =
  Expr.shift_vars 0 depth (Expr.shift_vars 0 (offset + level) e)
:= by
  have h0 : level = level + 0 := rfl
  rw [h0]
  rw [←Nat.add_assoc]
  exact shift_vars_level_drop level 0 depth offset e

mutual

  theorem Expr.record_instantiate_shift_vars_inside_out offset depth level m r :
    List.record_instantiate (offset + depth + level) m (List.record_shift_vars level depth r)
    =
    List.record_shift_vars level depth (List.record_instantiate (offset + level) m r)
  := by cases r with
  | nil =>
    simp [List.record_instantiate, List.record_shift_vars]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_instantiate,List.record_shift_vars]
    apply And.intro
    { apply Expr.instantiate_shift_vars_inside_out
    }
    { apply Expr.record_instantiate_shift_vars_inside_out }


  theorem Expr.function_instantiate_shift_vars_inside_out offset depth level m f :
    List.function_instantiate (offset + depth + level) m (List.function_shift_vars level depth f)
    =
    List.function_shift_vars level depth (List.function_instantiate (offset + level) m f)
  := by cases f with
  | nil =>
    simp [List.function_instantiate, List.function_shift_vars]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_instantiate,List.function_shift_vars]
    apply And.intro
    {

      have h0 :
        offset + depth + level + Pattern.count_vars p
        =
        offset + depth + (level + Pattern.count_vars p)
      := by exact Nat.add_assoc (offset + depth) level (Pattern.count_vars p)
      rw [h0]

      have h1 :
        offset + level + Pattern.count_vars p
        =
        offset + (level + Pattern.count_vars p)
      := by exact Nat.add_assoc offset level (Pattern.count_vars p)
      rw [h1]



      apply Expr.instantiate_shift_vars_inside_out
    }
    { apply Expr.function_instantiate_shift_vars_inside_out }



  theorem Expr.instantiate_shift_vars_inside_out offset depth level m e :
    Expr.instantiate (offset + depth + level) m (Expr.shift_vars level depth e)
    =
    Expr.shift_vars level depth (Expr.instantiate (offset + level) m e)
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars, Expr.instantiate]
    by_cases h0 : level ≤ i
    { simp [h0]
      simp [Expr.instantiate]
      by_cases h1 : offset + depth + level ≤ i + depth
      { simp [h1]

        have h2 :
          offset + depth + level - depth ≤ i
        := by exact Nat.sub_le_of_le_add h1

        have h3 :
          offset + depth + level =
          offset + level + depth
        := by exact Nat.add_right_comm offset depth level
        rw [h3] at h2

        have h4 :
          offset + level + depth - depth =
          offset + level
        := by exact Nat.add_sub_self_right (offset + level) depth

        rw [h4] at h2
        simp [h2]

        rw [h3]
        have h5 :
          i + depth - (offset + level + depth) =
          i - (offset + level)
        := by exact Nat.add_sub_add_right i depth (offset + level)
        simp [h5]

        cases h6 : m[i - (offset + level)]? with
        | some e =>
          simp
          rw [Expr.shift_vars_level_drop_to_zero]
          apply Expr.shift_vars_add
        | none =>
          simp
          simp [Expr.shift_vars]
          have h7 : List.length m ≤ i - (offset + level) := by
            exact Iff.mp List.getElem?_eq_none_iff h6


          have h8 : List.length m + (offset + level) ≤ i := by
            exact Nat.add_le_of_le_sub h2 h7

          have h9 :
              (offset + level) =
              (level + offset)
          := by exact Nat.add_comm offset level
          rw [h9] at  h8

          rw [←Nat.add_assoc] at h8

          have h10 : List.length m + level ≤ i := by
            exact Nat.le_of_add_right_le h8

          have h11 : level ≤ i -  List.length m := by
            exact Nat.le_sub_of_add_le' h10

          simp [h11]

          have h12 : List.length m ≤ i := by exact Nat.le_of_add_right_le h10

          exact Nat.sub_add_comm h12

      }
      { simp [h1]
        have h2 : offset + depth + level =  offset + level + depth := by
          exact Nat.add_right_comm offset depth level
        rw [h2] at  h1

        have h3 : ¬ offset + level ≤ i := by
          intro h
          apply h1
          exact Nat.add_le_add_right h depth

        simp [h3]
        simp [Expr.shift_vars]
        intro h4

        have h5 : ¬ level ≤ i := by exact Nat.not_le_of_lt h4
        apply False.elim
        apply h5 h0

      }
    }
    { simp [h0]
      simp [Expr.instantiate]

      have h1 : ¬ offset + level ≤ i := by
        intro h
        apply h0
        exact Nat.le_of_add_left_le h
      simp [h1]
      simp [Expr.shift_vars]
      simp [h0]
      intro h2
      apply False.elim
      have  h3 : offset + depth + level = offset + level + depth := by
        exact Nat.add_right_comm offset depth level
      rw [h3] at h2
      have h4 : offset + level ≤ i := by exact Nat.le_of_add_right_le h2
      apply h1 h4
    }
  | fvar x =>
    simp [Expr.instantiate, Expr.shift_vars]
  | iso l body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out
  | record r =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.record_instantiate_shift_vars_inside_out

  | function f =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.function_instantiate_shift_vars_inside_out

  | app ef ea =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply And.intro
    { apply Expr.instantiate_shift_vars_inside_out }
    { apply Expr.instantiate_shift_vars_inside_out }

  | anno body t =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out

  | loopi body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_shift_vars_inside_out

end


theorem Expr.instantiate_shift_vars_zero_inside_out offset depth m e :
  Expr.instantiate (offset + depth) m (Expr.shift_vars 0 depth e) =
  Expr.shift_vars 0 depth (Expr.instantiate offset m e)
:= by
  have h0 : offset + depth = offset + depth + 0 := by exact rfl
  have h1 : offset = offset + 0 := by exact rfl
  rw [h0,h1]
  exact instantiate_shift_vars_inside_out (offset + 0) depth 0 m e



mutual

  theorem Expr.record_instantiate_miss depth level m offset r :
    List.record_instantiate (depth + level) m (List.record_shift_vars level (offset + depth + List.length m) r) =
    List.record_shift_vars level (offset + depth) r
  := by cases r with
  | nil =>
    simp [List.record_shift_vars, List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars, List.record_instantiate]
    apply And.intro
    { apply Expr.instantiate_miss
    }
    { apply Expr.record_instantiate_miss }

  theorem Expr.function_instantiate_miss depth level m offset f :
    List.function_instantiate (depth + level) m (List.function_shift_vars level (offset + depth + List.length m) f) =
    List.function_shift_vars level (offset + depth) f
  := by cases f with
  | nil =>
    simp [List.function_shift_vars, List.function_instantiate]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars, List.function_instantiate]
    apply And.intro
    {

      have h0 :
        depth + level + Pattern.count_vars p
        =
        depth + (level + Pattern.count_vars p)
      := by exact Nat.add_assoc depth level (Pattern.count_vars p)
      rw [h0] ; clear h0

      apply Expr.instantiate_miss
    }
    { apply Expr.function_instantiate_miss }

  theorem Expr.instantiate_miss depth level m offset e :
    Expr.instantiate (depth + level) m (Expr.shift_vars level (offset + depth + List.length m) e)
    =
    (Expr.shift_vars level (offset + depth) e)
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars]
    by_cases h0 : level ≤ i
    { simp [h0]
      simp [Expr.instantiate]

      have h1 : depth + level ≤ depth + i := by exact Iff.mpr Nat.add_le_add_iff_left h0
      have h2 : depth + level ≤ depth + i + (offset + List.length m) := by
        exact Nat.le_add_right_of_le h1

      have h3 : depth + i = i + depth := by exact Nat.add_comm depth i

      rw [h3] at h2

      have h4 :
        i + depth + (offset + List.length m) =
        i + (depth + (offset + List.length m))
      := by exact Nat.add_assoc i depth (offset + List.length m)

      rw [h4] at h2

      have h5 :
        (depth + (offset + List.length m)) =
        (depth + offset + List.length m)
      := by exact Eq.symm (Nat.add_assoc depth offset (List.length m))

      rw [h5] at h2
      have h6 :
        depth + offset =
        offset + depth
      := by exact Nat.add_comm depth offset
      rw [h6] at h2
      simp [h2]

      have h7 : List.length m ≤  List.length m + (i + (offset + depth) - (depth + level))  := by
        exact Nat.le_add_right (List.length m) (i + (offset + depth) - (depth + level))

      have h8 : (depth + level) ≤ i + depth := by exact le_of_le_of_eq h1 h3
      have h9 : (depth + level) ≤ i + depth + offset := by exact Nat.le_add_right_of_le h8


      rw [Nat.add_assoc] at h9

      have h10 :
         depth + offset = offset + depth
      := by exact h6

      have h11 : (depth + level) ≤ i + (offset + depth) := by
        exact le_of_le_of_eq h9 (congrArg (HAdd.hAdd i) h6)

      have h12 :
        List.length m + (i + (offset + depth) - (depth + level))
        =
        List.length m + (i + (offset + depth)) - (depth + level)
      := by exact Eq.symm (Nat.add_sub_assoc h11 (List.length m))

      rw [h12] at h7


      have h13 :
        List.length m + (i + (offset + depth)) =
        i + (List.length m + (offset + depth))
      := by exact Nat.add_left_comm (List.length m) i (offset + depth)
      rw [h13] at h7

      have h14 :
        List.length m + (offset + depth) =
        offset + depth + List.length m
      := by exact Nat.add_comm (List.length m) (offset + depth)

      rw [h14] at h7

      have h15 : m[i + (offset + depth + List.length m) - (depth + level)]? = none := by
        apply List.getElem?_eq_none h7

      simp [h15]

      have h17 :
        List.length m ≤ offset + depth + List.length m
      := by exact Nat.le_add_left (List.length m) (offset + depth)

      have h18 :
        i + (offset + depth + List.length m) - List.length m =
        i + ((offset + depth + List.length m) - List.length m)
      := by exact Nat.add_sub_assoc h17 i

      simp [h18]
    }
    { simp [h0]
      simp [Expr.instantiate]
      intro h1
      apply False.elim
      have h2 : level ≤ i := by exact Nat.le_of_add_left_le h1
      apply h0 h2
    }

  | fvar x =>
    simp [Expr.instantiate, Expr.shift_vars]
  | iso l body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss
  | record r =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.record_instantiate_miss

  | function f =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.function_instantiate_miss

  | app ef ea =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply And.intro
    { apply Expr.instantiate_miss }
    { apply Expr.instantiate_miss }

  | anno body t =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss

  | loopi body =>
    simp [Expr.instantiate, Expr.shift_vars]
    apply Expr.instantiate_miss

end

theorem Expr.instantiate_miss_zero depth m offset e :
  Expr.instantiate depth m (Expr.shift_vars 0 (offset + depth + List.length m) e)
  =
  (Expr.shift_vars 0 (offset + depth) e)
:= by
  have h0 : depth = depth + 0 := rfl
  rw [h0]
  exact instantiate_miss depth 0 m offset e

mutual

  theorem  Expr.record_instantiate_inside_out offset depth ma mb r :
    (List.record_instantiate (offset + depth) ma (List.record_instantiate depth mb r)) =
    (List.record_instantiate depth
      (Expr.list_instantiate offset ma mb)
      (List.record_instantiate (offset + List.length mb + depth) ma r)
    )
  := by cases r with
  | nil =>
    simp [List.record_instantiate]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_instantiate]
    apply And.intro
    { apply Expr.instantiate_inside_out }
    { apply Expr.record_instantiate_inside_out }

  theorem  Expr.function_instantiate_inside_out offset depth ma mb f :
    (List.function_instantiate (offset + depth) ma (List.function_instantiate depth mb f)) =
    (List.function_instantiate depth
      (Expr.list_instantiate offset ma mb)
      (List.function_instantiate (offset + List.length mb + depth) ma f)
    )
  := by cases f with
  | nil =>
    simp [List.function_instantiate]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_instantiate]
    apply And.intro
    {

      have h0 :
        offset + depth + Pattern.count_vars p =
        offset + (depth + Pattern.count_vars p)
      := by exact Nat.add_assoc offset depth (Pattern.count_vars p)
      rw [h0]

      have h1 :
        offset + List.length mb + depth + Pattern.count_vars p =
        offset + List.length mb + (depth + Pattern.count_vars p)
      := by exact Nat.add_assoc (offset + List.length mb) depth (Pattern.count_vars p)
      rw [h1]

      apply Expr.instantiate_inside_out
    }
    { apply Expr.function_instantiate_inside_out }

  theorem  Expr.instantiate_inside_out offset depth ma mb e:
    (Expr.instantiate (offset + depth) ma (Expr.instantiate depth mb e)) =
    (Expr.instantiate depth
      (Expr.list_instantiate offset ma mb)
      (Expr.instantiate (offset + List.length mb + depth) ma e)
    )
  := by cases e with
  | bvar i =>
    simp [Expr.instantiate]

    by_cases h0 : offset + List.length mb + depth ≤ i
    { simp [h0]

      have h1 : depth ≤ i := by exact Nat.le_of_add_left_le h0
      simp [h1]

      have h2 :
        offset + List.length mb + depth =  offset + (List.length mb + depth)
      := by exact
        Nat.add_assoc offset (List.length mb) depth

      rw [h2] at h0
      have h4 : List.length mb + depth ≤ i := by exact Nat.le_of_add_left_le h0
      have h5 : List.length mb ≤ i - depth := by exact Nat.le_sub_of_add_le h4
      have h6 : mb[i - depth]? = none := by exact Iff.mpr List.getElem?_eq_none_iff h5
      simp [h6]
      simp [Expr.instantiate]

      rw [←h2] at h0
      have h9 : offset + List.length mb + depth = offset + depth + List.length mb := by
        exact Nat.add_right_comm offset (List.length mb) depth

      rw [h9] at h0

      have h10 : offset + depth ≤ i - List.length mb := by exact Nat.le_sub_of_add_le h0
      simp [h10]

      rw [Nat.sub_add_eq]
      rw [Nat.sub_add_eq]
      rw [Nat.sub_add_eq]

      have h11 : i - List.length mb - offset = i - offset - List.length mb := by
        exact Nat.sub_right_comm i (List.length mb) offset

      rw [h11]

      cases h12 : ma[i - offset - List.length mb - depth]? with
      | some ea =>
        simp
        rw [h9]
        rw [←Expr.list_instantiate_length_eq]
        rw [Expr.instantiate_miss_zero]

      | none =>
        simp
        have h13 : List.length ma ≤ i - offset - List.length mb - depth
        := by exact Iff.mp List.getElem?_eq_none_iff h12

        rw [←Nat.sub_add_eq] at h13
        rw [←Nat.sub_add_eq] at h13
        rw [←h2] at h13

        have h14 :
          offset + List.length mb + depth
          =
          offset + depth + List.length mb
        := by exact h9
        rw [h14] at h13

        simp [Expr.instantiate]

        have h15 : List.length ma + (offset + depth + List.length mb) ≤ i := by
          exact Nat.add_le_of_le_sub h0 h13

        have h17 : offset + depth = depth + offset := by
          exact Nat.add_comm offset depth

        rw [h17] at h15

        have h18 : depth + offset + List.length mb
          = depth + (offset + List.length mb)
        := by exact Nat.add_assoc depth offset (List.length mb)
        rw [h18] at h15

        simp [←Nat.add_assoc] at h15
        have h19 : List.length ma + depth + offset ≤ i := by
          exact Nat.le_of_add_right_le h15

        have h20 : List.length ma + depth ≤ i := by
          exact Nat.le_of_add_right_le h19


        have h21 : depth ≤ i - List.length ma := by
          exact Nat.le_sub_of_add_le' h20

        simp [h21]

        rw [Expr.list_instantiate_length_eq]

        have h22 :
          List.length ma + depth + offset + List.length mb =
          List.length ma + depth + List.length mb  + offset
        := by exact Nat.add_right_comm (List.length ma + depth) offset (List.length mb)

        rw [h22] at h15

        have h23 : List.length ma + depth + List.length mb ≤ i := by
          exact Nat.le_of_add_right_le h15

        rw [Nat.add_assoc] at h23

        have h24 : depth + List.length mb ≤ i - List.length ma := by
          exact Nat.le_sub_of_add_le' h23

        have h25 : List.length mb ≤ i - List.length ma - depth := by
          exact Iff.mpr (Nat.le_sub_iff_add_le' h21) h24

        have h26 : mb[i - List.length ma - depth]? = none := by
          exact Iff.mpr List.getElem?_eq_none_iff h25

        have h27 : (Expr.list_instantiate offset ma mb)[i - List.length ma - depth]? = none := by
          exact Expr.list_instantiate_get_none_preservation offset ma (i - List.length ma - depth) h26

        simp [h27]
        exact Nat.sub_right_comm i (List.length mb) (List.length ma)

    }
    { simp [h0]
      simp [Expr.instantiate]
      by_cases h1 : depth ≤ i
      { simp [h1]

        cases h2 : mb[i - depth]? with
        | some eb =>
          simp
          have h3 := Expr.list_instantiate_get_some_preservation offset ma (i - depth) h2
          simp [h3]
          apply Expr.instantiate_shift_vars_zero_inside_out
        | none =>
          simp
          have h3 := Expr.list_instantiate_get_none_preservation offset ma (i - depth) h2
          simp [h3]

          rw [Expr.list_instantiate_length_eq]
          simp [Expr.instantiate]
          intro h4
          apply False.elim
          apply h0 ; clear h0

          have h5 : List.length mb ≤ i - depth := by
            exact Iff.mp List.getElem?_eq_none_iff h2
          have h6 : List.length mb + depth ≤ i := by exact Nat.add_le_of_le_sub h1 h5

          have h7 : List.length mb ≤ i := by exact Nat.le_of_add_right_le h6

          have h8 : offset + depth + List.length mb ≤ i := by
            exact Nat.add_le_of_le_sub h7 h4

          have h9 :
            offset + depth + List.length mb =
            offset + List.length mb  + depth
          := by exact Nat.add_right_comm offset depth (List.length mb)

          exact le_of_eq_of_le (Eq.symm h9) h8
      }
      { simp [h1]
        simp [Expr.instantiate]
        intro h2
        apply False.elim
        apply h1
        exact Nat.le_of_add_left_le h2
      }
    }
  | fvar x =>
    simp [Expr.instantiate]
  | iso l body =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out
  | record r =>
    simp [Expr.instantiate]
    apply Expr.record_instantiate_inside_out

  | function f =>
    simp [Expr.instantiate]
    apply Expr.function_instantiate_inside_out

  | app ef ea =>
    simp [Expr.instantiate]
    apply And.intro
    { apply Expr.instantiate_inside_out }
    { apply Expr.instantiate_inside_out }

  | anno body t =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out

  | loopi body =>
    simp [Expr.instantiate]
    apply Expr.instantiate_inside_out
end

theorem  Expr.instantiate_zero_inside_out offset ma mb e:
  (Expr.instantiate offset ma (Expr.instantiate 0 mb e)) =
  (Expr.instantiate 0
    (Expr.list_instantiate offset ma mb)
    (Expr.instantiate (offset + List.length mb) ma e)
  )
:= by
  have h0 : offset = offset + 0 := by rfl
  rw [h0]
  apply Expr.instantiate_inside_out




end Lang
