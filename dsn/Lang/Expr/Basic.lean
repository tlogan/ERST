import Lang.Util
import Lang.List.Basic
import Lang.String.Basic
import Lang.Typ.Basic

set_option pp.fieldNotation false
namespace Lang

inductive Pat
| var : String → Pat
| iso : String → Pat → Pat
| record : List (String × Pat) → Pat
deriving Repr

def Pat.pair (left : Pat) (right : Pat) : Pat :=
    .record [("left", left), ("right", right)]


inductive Expr
| bvar : Nat → Expr
| fvar : String → Expr
| iso : String → Expr → Expr
| record : List (String × Expr) → Expr
| function : List (Pat × Expr) → Expr
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

def List.is_fresh_key {α} (key : String) : List (String × α) → Bool
| [] => .true
| (k,_) :: r =>
  k != key && List.is_fresh_key key r

mutual
  def List.is_record_value : List (String × Expr) → Bool
  | [] => .true
  | (l,e) :: r =>
    List.is_fresh_key l r && Expr.is_value e &&
    List.is_record_value r

  def Expr.is_value : Expr → Bool
  | (.iso _ e) => Expr.is_value e
  | (.record r) => List.is_record_value r
  | (.function _) => .true
  | _ => .false
end

mutual
  def Pat.record_index_vars : List (String × Pat) → List String
  | [] => []
  | (l,p) :: ps =>
    Pat.index_vars p ++ Pat.record_index_vars ps

  def Pat.index_vars : Pat → List String
  | var x => [x]
  | iso l p => Pat.index_vars p
  | record ps => Pat.record_index_vars ps
end

mutual
  def Pat.record_clear : List (String × Pat) → List (String × Pat)
  | [] => []
  | (l,p) :: ps =>
    (l, Pat.clear p) :: Pat.record_clear ps

  def Pat.clear : Pat → Pat
  | var x => .var ""
  | iso l p => .iso l (Pat.clear p)
  | record ps => .record (Pat.record_clear ps)
end

def Pat.bvar := Pat.var ""


def Pat.count_vars (p : Pat) := List.length (Pat.index_vars p)


#eval Pat.index_vars (Pat.record [("uno", Pat.var "x"), ("dos", Pat.record [("dos", Pat.var "y"), ("tres", Pat.var "z")])])


mutual
  def Expr.record_seal (names : List String) : List (String × Expr) → List (String × Expr)
  | [] => []
  | (l,e)::r =>
    (l, Expr.seal names e) :: (Expr.record_seal names r)

  def Expr.function_seal (names : List String) : List (Pat × Expr) → List (Pat × Expr)
  | [] => []
  | (p,e)::f =>
    let names' := Pat.index_vars p
    (Pat.clear p, Expr.seal (names' ++ names) e) :: (Expr.function_seal names f)

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

#eval Expr.seal [] (.function [(Pat.var "z", .app (.function [(Pat.iso "uno" (Pat.var "x"), .record [("one", .fvar "x"), ("two", .fvar "z")])]) (.fvar "hello"))])

def Expr.extract (e : Expr) (l : String) : Expr :=
  .app (.function [(Pat.iso l (Pat.bvar), .bvar 0)]) e

def Expr.project (e : Expr) (l : String) : Expr :=
  .app (.function [(.record [(l, Pat.bvar)], .bvar 0)]) e

def Expr.def (id : String) (top : Option Typ) (target : Expr) (contin : Expr) : Expr :=
  Expr.app
    (Expr.function [
      (
        Pat.var id, match top with
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
| `([brief| : $i:ident ]) => `(([id| $i], Pat.var [id| $i]) :: [])
| `([brief| : $i:ident $br:brief]) => `(([id| $i], Pat.var [id| $i]) :: [brief| $br])

macro_rules
-- | `([frame| <$i:ident/> ]) => `(([id| $i], [pattern| @]) :: [])
| `([frame| $i:ident := $p:pat ]) => `(([id| $i], [pattern| $p]) :: [])
| `([frame| $i:ident := $p:pat ; ]) => `(([id| $i], [pattern| $p]) :: [])
| `([frame| $i:ident := $p:pat ; $pr:frame ]) => `(([id| $i], [pattern| $p]) :: [frame| $pr])

macro_rules
| `([pattern| $i:ident ]) => `(Pat.var [id| $i])
| `([pattern| @ ]) => `(Pat.record [])
| `([pattern| < $i:ident > $p:pat ]) => `(Pat.iso [id| $i] [pattern| $p])
| `([pattern| < $i:ident /> ]) => `(Pat.iso [id| $i] (Pat.record []))
| `([pattern| $br:brief ]) => `(Pat.record [brief| $br])
| `([pattern| $pr:frame ]) => `(Pat.record [frame| $pr])
-- | `([pattern| $i:ident ; $p:pat ]) => `(Pat.record ([id| $i], [pattern| $p]) :: [])
| `([pattern| $l:pat , $r:pat ]) => `(Pat.pair [pattern| $l] [pattern| $r])

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
  def Pat.toRecordExpr : List (String × Pat) → List (String × Expr)
  | .nil => .nil
  | (l, p) :: r => (l, toExpr p) :: (toRecordExpr r)

  def Pat.toExpr : Pat → Expr
  | .var id => .fvar id
  | .iso label body => .iso label (Pat.toExpr body)
  | .record r => .record (toRecordExpr r)
end

instance : Coe Pat Expr where
  coe := Pat.toExpr

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

  def List.function_shift_vars (threshold : Nat) (offset : Nat) : List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let threshold' := threshold + Pat.count_vars p
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

mutual

  def List.record_shift_back (threshold : Nat) (offset : Nat) : List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.shift_back threshold offset e) :: (List.record_shift_back threshold offset r)

  def List.function_shift_back (threshold : Nat) (offset : Nat) : List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let threshold' := threshold + Pat.count_vars p
    (p, Expr.shift_back threshold' offset e) :: (List.function_shift_back threshold offset f)

  def Expr.shift_back (threshold : Nat) (offset : Nat) : Expr → Expr
  | .bvar i =>
    if i >= threshold + offset then
      (.bvar (i - offset))
    else
      (.bvar i)
  | .fvar id => .fvar id
  | .iso l body => .iso l (Expr.shift_back threshold offset body)
  | .record r => .record (List.record_shift_back threshold offset r)
  | .function f => .function (List.function_shift_back threshold offset f)
  | .app ef ea => .app (Expr.shift_back threshold offset ef) (Expr.shift_back threshold offset ea)
  | .anno e t => .anno (Expr.shift_back threshold offset e) t
  | .loopi e => .loopi (Expr.shift_back threshold offset e)
end

def Expr.list_shift_back (threshold : Nat) (offset : Nat) : List Expr → List Expr
| .nil => .nil
| e :: es =>
  Expr.shift_back threshold offset e :: (Expr.list_shift_back threshold offset es)


mutual
  theorem Expr.record_shift_forward_then_back level offset r :
    List.record_shift_back level offset (List.record_shift_vars level offset r) = r
  := by cases r with
  | nil =>
    simp [List.record_shift_vars, List.record_shift_back]
  | cons le r' =>
    have (l,e) := le
    simp [List.record_shift_vars, List.record_shift_back]
    apply And.intro
    { apply Expr.shift_forward_then_back }
    { apply Expr.record_shift_forward_then_back }

  theorem Expr.function_shift_forward_then_back level offset f :
    List.function_shift_back level offset (List.function_shift_vars level offset f) = f
  := by cases f with
  | nil =>
    simp [List.function_shift_vars, List.function_shift_back]
  | cons pe f' =>
    have (p,e) := pe
    simp [List.function_shift_vars, List.function_shift_back]
    apply And.intro
    { apply Expr.shift_forward_then_back }
    { apply Expr.function_shift_forward_then_back }



  theorem Expr.shift_forward_then_back level offset e :
    Expr.shift_back level offset (Expr.shift_vars level offset e) = e
  := by cases e with
  | bvar i =>
    simp [Expr.shift_vars]
    by_cases h0 : level ≤ i
    { simp [h0]
      simp [Expr.shift_back]
      intro h1
      apply False.elim
      have h2 : ¬ level ≤ i := by exact Nat.not_le_of_lt h1
      apply h2 h0
    }
    { simp [h0]
      simp [Expr.shift_back]
      intro h1
      have h2 : level ≤ i := by exact Nat.le_of_add_right_le h1
      apply False.elim
      apply h0 h2
    }
  | fvar x =>
    simp [Expr.shift_vars, Expr.shift_back]
  | iso l body =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply Expr.shift_forward_then_back
  | record r =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply Expr.record_shift_forward_then_back

  | function f =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply Expr.function_shift_forward_then_back

  | app ef ea =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply And.intro
    { apply Expr.shift_forward_then_back }
    { apply Expr.shift_forward_then_back }

  | anno body t =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply Expr.shift_forward_then_back

  | loopi body =>
    simp [Expr.shift_vars, Expr.shift_back]
    apply Expr.shift_forward_then_back
end

theorem Expr.list_shift_vars_length_eq threshold offset m:
  List.length (Expr.list_shift_vars threshold offset m) = List.length m
:= by induction m with
| nil =>
  simp [Expr.list_shift_vars]
| cons e m' ih =>
  simp [Expr.list_shift_vars]
  apply ih

theorem Expr.list_shift_back_length_eq threshold offset m:
  List.length (Expr.list_shift_back threshold offset m) = List.length m
:= by induction m with
| nil =>
  simp [Expr.list_shift_back]
| cons e m' ih =>
  simp [Expr.list_shift_back]
  apply ih


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

theorem Expr.list_shift_back_concat :
  (Expr.list_shift_back threshold offset m0) ++
  (Expr.list_shift_back threshold offset m1)
  =
  Expr.list_shift_back threshold offset (m0 ++ m1)
:= by induction m0 with
| nil =>
  simp [Expr.list_shift_back]
| cons e0 m0' ih =>
  simp [Expr.list_shift_back]
  apply ih


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

theorem Expr.list_shift_back_get_some_preservation threshold offset :
  ∀ (i : Nat),
  m[i]? = some arg →
  (Expr.list_shift_back threshold offset m)[i]? = some (Expr.shift_back threshold offset arg)
:= by induction m with
| nil =>
  simp
| cons e m' ih =>
  intro i
  simp [Expr.list_shift_back]
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


theorem Expr.list_shift_vars_get_none_preservation threshold offset :
  ∀ (i : Nat),
  m[i]? = none →
  (Expr.list_shift_vars threshold offset m)[i]? = none
:= by
  intro i h0
  apply Iff.mpr List.getElem?_eq_none_iff
  rw [Expr.list_shift_vars_length_eq]
  exact Iff.mp List.getElem?_eq_none_iff h0

theorem Expr.list_shift_back_get_none_preservation threshold offset :
  ∀ (i : Nat),
  m[i]? = none →
  (Expr.list_shift_back threshold offset m)[i]? = none
:= by
  intro i h0
  apply Iff.mpr List.getElem?_eq_none_iff
  rw [Expr.list_shift_back_length_eq]
  exact Iff.mp List.getElem?_eq_none_iff h0


mutual
  def List.record_instantiate (depth : Nat) (m : List Expr): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.instantiate depth m e) :: (List.record_instantiate depth m r)

  def List.function_instantiate (depth : Nat) (m : List Expr): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let depth' := depth + (Pat.count_vars p)
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

def Expr.liberate_vars (p : Pat) (e : Expr) : Expr :=
  let xs := Pat.index_vars p
  let fvs := List.map (fun x => Expr.fvar x) xs
  Expr.instantiate 0 fvs e


mutual
  def List.record_sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.sub m e) :: (List.record_sub m r)

  def List.function_sub (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := Pat.index_vars p
    (p, Expr.sub (remove_all m ids) e) :: (List.function_sub m f)

  def Expr.sub (m : List (String × Expr)): Expr → Expr
  | .bvar i => .bvar i
  | .fvar id => match (find id m) with
    | .none => (.fvar id)
    | .some e => e
  | .iso l body => .iso l (Expr.sub m body)
  | .record r => .record (List.record_sub m r)
  | .function f => .function (List.function_sub m f)
  | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
  | .anno e t => .anno (Expr.sub m e) t
  | .loopi e => .loopi (Expr.sub m e)
end

theorem Expr.sub_refl :
  x ∉ ListPair.dom m →
  (Expr.sub m (.fvar x)) = (.fvar x)
:= by
  intro h0
  induction m with
  | nil =>
    simp [Expr.sub, find]
  | cons pair m' ih =>
    have ⟨x',target⟩ := pair
    simp [ListPair.dom] at h0
    have ⟨h1,h2⟩ := h0
    clear h0
    specialize ih h2
    simp [Expr.sub, find]
    have h3 : x' ≠ x := by exact fun h => h1 (Eq.symm h)
    simp [h3]
    unfold Expr.sub at ih
    exact ih

end Lang
