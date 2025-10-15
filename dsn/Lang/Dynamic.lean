import Lang.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false


mutual
  inductive IsFreshLabel : List (String × Expr) → String → Prop
  | nil : ∀ {l}, IsFreshLabel [] l
  | cons : ∀ {l e r l'},
    l' ≠ l →
    IsFreshLabel r l' →
    IsFreshLabel ((l,e)::r) l'

  inductive IsRecordValue : List (String × Expr) → Prop
  | nil : IsRecordValue []
  | cons : ∀ {l e r},
    IsFreshLabel r l → IsValue e →
    IsRecordValue ((l,e)::r)

  inductive IsValue : Expr → Prop
  | unit : IsValue (.unit)
  | record : ∀ {r}, IsRecordValue r → IsValue (.record r)
  | function : ∀ {f}, IsValue (.function f)
end


mutual
  def pattern_match_entry (label : String) (pat : Pat) :
  List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (pattern_match e pat)
    else
      pattern_match_entry label pat args

  def pattern_match_record (args : List (String × Expr)):
  List (String × Pat) →
  Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.free_vars pat ∩ ListPat.free_vars pats = [] then
      let m0 ← pattern_match_entry label pat args
      let m1 ← pattern_match_record args pats
      return (m0 ++ m1)
    else
      .none

  def pattern_match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | .unit, .unit => some []
  | (.record r), (.record p) => pattern_match_record r p
  | _, _ => none
end

mutual
  def ids_record_pattern : List (String × Pat) → List String
  | .nil => .nil
  | (_, p) :: r =>
    (ids_pattern p) ++ (ids_record_pattern r)

  def ids_pattern : Pat → List String
  | .var id => [id]
  | .unit => []
  | .record r => ids_record_pattern r
end

mutual
  def Expr.Record.sub (m : List (String × Expr)): List (String × Expr) → List (String × Expr)
  | .nil => .nil
  | (l, e) :: r =>
    (l, Expr.sub m e) :: (Expr.Record.sub m r)

  def Expr.Function.sub (m : List (String × Expr)): List (Pat × Expr) → List (Pat × Expr)
  | .nil => .nil
  | (p, e) :: f =>
    let ids := ids_pattern p
    (p, Expr.sub (remove_all m ids) e) :: (Expr.Function.sub m f)

  def Expr.sub (m : List (String × Expr)): Expr → Expr
  | .var id => match (find id m) with
    | .none => (.var id)
    | .some e => e
  | .unit => .unit
  | .record r => .record (Expr.Record.sub m r)
  | .function f => .function (Expr.Function.sub m f)
  | .app ef ea => .app (Expr.sub m ef) (Expr.sub m ea)
  | .anno e t => .anno (Expr.sub m e) t
  | .loop e => .loop (Expr.sub m e)
end

inductive Progression : Expr → Expr → Prop
| entry : ∀ {r l e e'},
  Progression e e' →
  Progression (Expr.record ((l, e) :: r)) (Expr.record ((l, e') :: r))
| record : ∀ {r r' l v},
  Progression (Expr.record r) (Expr.record r') →
  IsValue v →
  Progression (Expr.record ((l, v) :: r)) (Expr.record ((l, v) :: r'))
| applicator : ∀ {ef ef' e},
  Progression ef ef' →
  Progression (.app ef e) (.app ef' e)
| applicand : ∀ {f e e'},
  Progression e e' →
  Progression (.app (.function f) e) (.app (.function f) e')
| appmatch : ∀ {p e f v m},
  IsValue v →
  pattern_match v p = some m →
  Progression (.app (.function ((p,e) :: f)) v) (Expr.sub m e)
| appskip : ∀ {p e f v},
  IsValue v →
  pattern_match v p = none →
  Progression (.app (.function ((p,e) :: f)) v) (.app (.function f) v)
| anno : ∀ {e t},
  Progression (.anno  e t) e
| loopbody : ∀ {e e'},
  Progression e e' →
  Progression (.loop e) (.loop e')
| looppeel : ∀ {id e},
  Progression
    (.loop (.function [(.var id, e)]))
    (Expr.sub [(id, (.loop (.function [(.var id, e)])))] e)


inductive MultiProgression : Expr → Expr → Prop
| refl {e} : MultiProgression e e
| step {e e' e''} : MultiProgression e e' → MultiProgression e e'' → MultiProgression e e''


def Typing.Dynamic.Fin (e : Expr) : Typ → Prop
| .entry l τ => Typing.Dynamic.Fin (.record [(l,e)]) τ
| .path left right => ∀ e' , Typing.Dynamic.Fin e' left → Typing.Dynamic.Fin (.app e e') right
| .unio left right => Typing.Dynamic.Fin e left ∨ Typing.Dynamic.Fin e right
| .inter left right => Typing.Dynamic.Fin e left ∧ Typing.Dynamic.Fin e right
| .diff left right => Typing.Dynamic.Fin e left ∧ ¬ (Typing.Dynamic.Fin e right)
| _ => False

def Subtyping.Dynamic.Fin (left right : Typ) : Prop :=
  ∀ e, Typing.Dynamic.Fin e left → Typing.Dynamic.Fin e right


mutual
  def Subtyping.Dynamic (am : List (String × Typ)) (left : Typ) (right : Typ) : Prop :=
    ∀ e, Typing.Dynamic am e left → Typing.Dynamic am e right
  termination_by Typ.size left + Typ.size right
  decreasing_by
    all_goals simp [Typ.zero_lt_size]

  def MultiSubtyping.Dynamic (am : List (String × Typ)) : List (Typ × Typ) → Prop
  | .nil => True
  | .cons (left, right) remainder =>
    Subtyping.Dynamic am left right ∧ MultiSubtyping.Dynamic am remainder
  termination_by sts => ListSubtyping.size sts
  decreasing_by
    all_goals simp [ListSubtyping.size, ListPairTyp.zero_lt_size, Typ.zero_lt_size]

def Typ.Monotonic.Dynamic (am : List (String × Typ)) (id : String) (body : Typ) : Prop :=
  (∀ t0 t1,
    Subtyping.Dynamic am t0 t1 →
    ∀ e, Typing.Dynamic ((id,t0):: am) e body → Typing.Dynamic ((id,t1):: am) e body
  )
  termination_by Typ.size body
  decreasing_by
    all_goals sorry

  def Typing.Dynamic (am : List (String × Typ)) (e : Expr) : Typ → Prop
  | .bot => False
  | .top => ∃ e',  Expr.is_value e' ∧ MultiProgression e e'
  | .unit => Progression e .unit
  | .entry l τ => Typing.Dynamic am (.proj e l) τ
  | .path left right => ∀ e' , Typing.Dynamic am e' left → Typing.Dynamic am (.app e e') right
  | .unio left right => Typing.Dynamic am e left ∨ Typing.Dynamic am e right
  | .inter left right => Typing.Dynamic am e left ∧ Typing.Dynamic am e right
  | .diff left right => Typing.Dynamic am e left ∧ ¬ (Typing.Dynamic am e right)
  | .exi ids quals body =>
    ∃ am' , (ListPair.dom am') ⊆ ids ∧
    (MultiSubtyping.Dynamic (am' ++ am) quals) ∧
    (Typing.Dynamic (am' ++ am) e body)
  | .all ids quals body =>
    ∀ am' , (ListPair.dom am') ⊆ ids →
    (MultiSubtyping.Dynamic (am' ++ am) quals) →
    (Typing.Dynamic (am' ++ am) e body)
  | .lfp id body =>
    Typ.Monotonic.Dynamic am id body ∧
    (∃ t, ∃ (h : Typ.size t < Typ.size (.lfp id body)),
      (∀ e',
        Typing.Dynamic am e' t →
        Typing.Dynamic ((id,t) :: am) e' body
      ) ∧
      Typing.Dynamic ((id,t) :: am) e  body
    )
  -----------------------
  -- TODO: remove old lfp case
  -- | .lfp id body =>
  --   Typ.Monotonic id true body ∧
  --   ∃ n, Typing.Dynamic.Fin e (Typ.sub am (Typ.subfold id body n))
  | .var id => ∃ τ, find id am = some τ ∧ Typing.Dynamic.Fin e τ
  termination_by t => (Typ.size t)
  decreasing_by
    all_goals simp_all [Typ.size]
    all_goals try linarith
end

def MultiTyping.Dynamic
  (tam : List (String × Typ)) (eam : List (String × Expr)) (context : List (String × Typ)) : Prop
:= ∀ {x t}, find x context = .some t → ∃ e, (find x eam) = .some e ∧ Typing.Dynamic tam e t
