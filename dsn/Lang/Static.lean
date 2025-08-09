import Lang.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Tactic.Linarith

set_option pp.fieldNotation false

-- NOTE: P means pattern type; if not (T <: P) and not (P <: T) then T and P are disjoint

def Typ.is_pattern (tops : List String) : Typ → Bool
| .exi ids [] body => Typ.is_pattern (tops ++ ids) body
| .var id => id ∈ tops
| .unit => true
| .entry _ body => Typ.is_pattern tops body
| .inter left right => Typ.is_pattern tops left ∧ Typ.is_pattern tops right
| _ => false

def Subtyping.inflatable (Θ : List String) (Δ : List (Typ × Typ)) (lower upper : Typ) : Bool :=
  --TODO
  false

def Typ.drop (id : String) : Typ → Option Typ
--TODO
| _ => .none

def Typ.merge_paths : Typ → Option Typ
--TODO
| _ => .none


mutual
  def Subtyping.restricted (Θ : List String) (Δ : List (Typ × Typ)) (lower upper : Typ) : Bool :=
    --TODO
    false

  def ListSubtyping.restricted (Θ : List String) (Δ : List (Typ × Typ))
  : List (Typ × Typ) → Bool
  --TODO
  | _ => false
end

def factor_column (id : String) (t : Typ) (l : String) : Option Typ :=
  .none
--TODO

mutual
  def Subtyping.check (Θ : List String) (Δ : List (Typ × Typ)) : Typ → Typ → Bool
  | _, _ => false
end

mutual

  inductive Subtyping.Static
  : List String → List (Typ × Typ) → Typ → Typ →
    List String → List (Typ × Typ) → Prop
  | refl {Θ Δ left right} :
    (Typ.toBruijn 0 [] left) = (Typ.toBruijn 0 [] right) →
    Subtyping.Static Θ Δ left right Θ Δ

  -- implication preservation
  | entry_pres {Θ Δ l left right Θ' Δ'} :
    Subtyping.Static Θ Δ (.entry l left) (.entry l right) Θ' Δ'
  | path_pres {Θ Δ p q  Θ' Δ' x y Θ'' Δ''} :
    Subtyping.Static Θ Δ x p Θ' Δ' → Subtyping.Static Θ' Δ' q y Θ'' Δ'' →
    Subtyping.Static Θ Δ (.path p q) (.path x y) Θ'' Δ''

  -- expansion elimination
  | unio_elim {Θ Δ a t b Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ a t Θ' Δ' → Subtyping.Static Θ' Δ' b t Θ'' Δ'' →
    Subtyping.Static Θ Δ (.unio a b) t Θ'' Δ''
  | exi_elim {Θ Δ ids quals body t Θ' Δ' Θ'' Δ''} :
    ListSubtyping.restricted Θ Δ quals →
    ListSubtyping.Static Θ Δ quals Θ' Δ' →
    Subtyping.Static (ids ∪ Θ') Δ' body t Θ'' Δ'' →
    Subtyping.Static Θ Δ (.exi ids quals body) t Θ'' Δ''

  -- refinement introduction
  | inter_intro {Θ Δ t a  b Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ t a Θ' Δ' → Subtyping.Static Θ' Δ' t b Θ'' Δ'' →
    Subtyping.Static Θ Δ t (.inter a b) Θ'' Δ''
  | all_intro {Θ Δ ids quals body t Θ' Δ' Θ'' Δ''} :
    ListSubtyping.restricted Θ Δ quals →
    ListSubtyping.Static Θ Δ quals Θ' Δ' →
    Subtyping.Static (ids ∪ Θ') Δ' t body Θ'' Δ'' →
    Subtyping.Static Θ Δ t (.all ids quals body) Θ'' Δ''

  -- placeholder elimination
  | placeholder_elim {Θ Δ id t trans Θ' Δ' } :
    id ∉ Θ →
    (∀ t', (t', .var id) ∈ Δ → (t', t) ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- placeholder introduction
  | placeholder_intro {Θ Δ t id trans Θ' Δ' } :
    id ∉ Θ →
    (∀ t', (.var id, t') ∈ Δ → (t, t') ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' ((t, .var id) :: Δ')

  -- skolem placeholder introduction
  | skolem_placeholder_intro {Θ Δ t id trans Θ' Δ' } :
    id ∈ Θ →
    (∃ id', (.var id', .var id) ∈ Δ ∧ id' ∉ Θ) →
    (∀ t', (.var id, t') ∈ Δ → (t, t') ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' ((t, .var id) :: Δ')

  -- skolem introduction
  | skolem_intro {Θ Δ t id t' Θ' Δ' } :
    id ∈ Θ →
    (t', .var id) ∈ Δ →
    (∀ id', (.var id') = t' → id ∈ Θ) →
    Subtyping.Static Θ Δ t t' Θ' Δ' →
    Subtyping.Static Θ Δ t (.var id) Θ' Δ'

  -- skolem placeholder elimination
  | skolem_placeholder_elim {Θ Δ id t trans Θ' Δ' } :
    id ∈ Θ →
    (∃ id', (.var id, .var id') ∈ Δ ∧ id' ∉ Θ) →
    (∀ t', (t', .var id) ∈ Δ → (t', t) ∈ trans) →
    ListSubtyping.Static Θ Δ trans Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- skolem elimination
  | skolem_elim {Θ Δ id t t' Θ' Δ'} :
    id ∈ Θ →
    (.var id, t') ∈ Δ →
    (∀ id', (.var id') = t → id' ∈ Θ) →
    Subtyping.Static Θ Δ t' t Θ' Δ' →
    Subtyping.Static Θ Δ (.var id) t Θ' ((.var id, t) :: Δ')

  -- implication rewriting
  | unio_antec {Θ Δ l a b r Θ' Δ'} :
    Subtyping.Static Θ Δ l (.inter (.path a r) (.path b r)) Θ' Δ' →
    Subtyping.Static Θ Δ l (.path (.unio a b) r) Θ' Δ'

  | inter_conseq {Θ Δ l a b r Θ' Δ'} :
    Subtyping.Static Θ Δ l (.inter (.path r a) (.path r b)) Θ' Δ' →
    Subtyping.Static Θ Δ l (.path r (.inter a b)) Θ' Δ'

  | inter_entry {Θ Δ t l a b Θ' Δ'} :
    Subtyping.Static Θ Δ t (.inter (.entry l a) (.entry l b)) Θ' Δ' →
    Subtyping.Static Θ Δ t (.entry l (.inter a b)) Θ' Δ'

  -- least fixed point elimination
  | lfp_factor_elim {Θ Δ id left l right fac Θ' Δ'} :
    factor_column id left l = .some fac →
    Subtyping.Static Θ Δ fac right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) (.entry l right) Θ' Δ'
  | lfp_skip_elim {Θ Δ id left right Θ' Δ'} :
    id ∉ Typ.free_vars left →
    Subtyping.Static Θ Δ left right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) right Θ' Δ'
  | lfp_induct_elim {Θ Δ id left right Θ' Δ'} :
    Typ.Polar id True left →
    Subtyping.Static Θ Δ (Typ.sub [(id, right)] left) right Θ' Δ' →
    Subtyping.Static Θ Δ (.lfp id left) right Θ' Δ'

  -- difference introduction
  | diff_intro {Θ Δ t l r Θ' Δ'} :
    Typ.is_pattern [] r →
    Subtyping.restricted Θ Δ r t →
    ¬ Subtyping.check Θ Δ t r →
    ¬ Subtyping.check Θ Δ r t →
    Subtyping.Static Θ Δ t (.diff l r) Θ' Δ'

  -- least fixed point introduction
  | lfp_inflate_intro {Θ Δ l id r Θ' Δ'} :
    Subtyping.inflatable Θ Δ l (.lfp id r) →
    Subtyping.Static Θ Δ l (.sub [(id, .lfp id r)] r) Θ' Δ' →
    Subtyping.Static Θ Δ l (.lfp id r) Θ' Δ'

  | lfp_drop_intro {Θ Δ l id r r' Θ' Δ'} :
    Typ.drop id r = .some r' →
    Subtyping.Static Θ Δ l r' Θ' Δ' →
    Subtyping.Static Θ Δ l (.lfp id r) Θ' Δ'

  -- difference elimination
  | diff_elim {Θ Δ l r t Θ' Δ'} :
    Subtyping.Static Θ Δ l (.unio r t) Θ' Δ' →
    Subtyping.Static Θ Δ (.diff l r) t Θ' Δ'

  -- expansion introduction
  | unio_left_intro {θ δ t l r θ' δ'} :
    Subtyping.Static θ δ t l θ' δ' →
    Subtyping.Static θ δ t (.unio l r) θ' δ'

  | unio_right_intro {θ δ t l r θ' δ'} :
    Subtyping.Static θ δ t r θ' δ' →
    Subtyping.Static θ δ t (.unio l r) θ' δ'

  | exi_intro {θ δ l ids quals r θ' δ' θ'' δ''} :
    Subtyping.Static θ δ l r θ' δ' →
    ListSubtyping.Static θ' δ' quals θ' δ' →
    Subtyping.Static θ δ l (.exi ids quals r)  θ'' δ''

  -- refinement elimination
  | inter_left_elim {θ δ l r t θ' δ'} :
    Subtyping.Static θ δ l t θ' δ' →
    Subtyping.Static θ δ (.inter l r) t θ' δ'

  | inter_right_elim {θ δ l r t θ' δ'} :
    Subtyping.Static θ δ r t θ' δ' →
    Subtyping.Static θ δ (.inter l r) t θ' δ'

  | inter_merge_elim {θ δ l r p q t θ' δ'} :
    Typ.merge_paths (.inter l r) = .some t →
    Subtyping.Static θ δ t (.path p q) θ' δ' →
    Subtyping.Static θ δ (.inter l r) (.path p q) θ' δ'

  | all_elim {θ δ ids quals l r θ' δ' θ'' δ''} :
    Subtyping.Static θ δ l r θ' δ' →
    ListSubtyping.Static θ' δ' quals θ' δ' →
    Subtyping.Static θ δ (.all ids quals l) r θ'' δ''

  inductive ListSubtyping.Static
  : List String → List (Typ × Typ) → List (Typ × Typ) →
    List String → List (Typ × Typ) → Prop
  | nil {Θ Δ Θ' Δ'} : ListSubtyping.Static Θ Δ [] Θ' Δ'
  | cons {Θ Δ l r cs Θ' Δ' Θ'' Δ''} :
    Subtyping.Static Θ Δ l r Θ' Δ' →
    ListSubtyping.Static Θ' Δ' cs Θ'' Δ'' →
    ListSubtyping.Static Θ Δ ((l,r) :: cs) Θ'' Δ''

  inductive Typing.Static
  : List String → List (Typ × Typ) → List (String × Typ) →
    Expr → Typ →
    List String → List (Typ × Typ) → Prop
  | unit {Θ Δ Γ} : Typing.Static Θ Δ Γ .unit .unit Θ Δ
  | var {Θ Δ Γ x t} :
    find x Γ = .some t →
    Typing.Static Θ Δ Γ (.var x) t Θ Δ

  | record_nil {Θ Δ Γ} :
    Typing.Static Θ Δ Γ (.record []) t[TOP] Θ Δ
  | record_cons {Θ Δ Γ r l e t t'  Θ' Δ' Θ'' Δ''} :
    Typing.Static Θ Δ Γ e t Θ' Δ' →
    Typing.Static Θ Δ Γ (.record r) t' Θ'' Δ'' →
    Typing.Static Θ Δ Γ (.record ((l,e) :: r)) (.inter (.entry l t) (t')) Θ'' Δ''



end


-- namespace Typ
-- inductive Pat
-- | unit
-- | entry : String → Pat → Pat
-- | inter : Pat → Pat → Pat
-- | top
-- deriving Repr

-- def Pat.size : Pat → Nat
-- | .unit => 1
-- | .entry l body => size body + 1
-- | .inter left right => size left + size right + 1
-- | .top => 3

-- def Pat.toTyp : Pat → Typ
-- | .unit => .unit
-- | .entry l body => .entry l (toTyp body)
-- | .inter left right => .inter (toTyp left) (toTyp right)
-- | .top => .all ["T"] [] (.var "T")

-- theorem stf_typ_size {s} : Pat.size s = Typ.size (Pat.toTyp s) := by
-- induction s
-- case unit => rfl
-- case entry l body ih =>
--   simp [Pat.toTyp, Pat.size, ih, Typ.size]
-- case inter left right ihl ihr =>
--   simp [Pat.toTyp, Pat.size, ihl, ihr, Typ.size]
-- case top =>
--   simp [Pat.toTyp, Typ.size, ListPairTyp.size, Pat.size]


-- declare_syntax_cat stf

-- syntax "@" : stf
-- syntax "TOP" : stf
-- syntax "<" ident ">" stf : stf
-- syntax stf "&" stf : stf

-- syntax "s[" stf "]" : term

-- macro_rules
-- | `(s[ TOP ]) => `(Pat.top)
-- | `(s[ @ ]) => `(Pat.unit)
-- | `(s[ < $i:ident > $s:stf  ]) => `(Pat.entry i[$i] s[$s])
-- | `(s[ $x:stf & $y:stf]) => `(Pat.inter s[$x] s[$y])

-- class PatOf (_ : Typ) where
--   default : Pat

-- instance : PatOf t[TOP] where
--   default := s[TOP]

-- instance : PatOf t[@] where
--   default := s[@]

-- instance (label : String) (result : Typ) [s : PatOf result]
-- : PatOf (Typ.entry label result)  where
--   default := Pat.entry label s.default

-- instance
--   (left : Typ) [l : PatOf left]
--   (right : Typ) [r : PatOf right]
-- : PatOf (Typ.inter left right)  where
--   default := Pat.inter l.default r.default
-- end Typ
