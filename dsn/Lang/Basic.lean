-- import Lean

-- open Lean
-- open Lean.Parser
-- open Lean.Elab
-- open Lean.Elab.Term

inductive Subtra
| top
| unit
| entry : String → Subtra → Subtra
| inter : Subtra → Subtra → Subtra
deriving Repr

mutual
  inductive Constraint
  | subtyping : Typ → Typ → Constraint
  deriving Repr

  inductive Typ
  | var : String → Typ
  | unit
  | entry : String → Typ → Typ
  | path : Typ → Typ → Typ
  | unio :  Typ → Typ → Typ
  | inter :  Typ → Typ → Typ
  | diff :  Typ → Subtra → Typ
  | all :  List String → List Constraint → Typ → Typ
  | exi :  List String → List Constraint → Typ → Typ
  | lfp :  String → Typ → Typ
  deriving Repr
end


inductive Pat
| var : String → Pat
| unit
| record : List (String × Pat) → Pat
deriving Repr

inductive Expr
| var : String → Expr
| unit
| record : List (String × Expr) → Expr
| function : List (Pat × Expr) → Expr
| proj : Expr → String → Expr
| app : Expr → Expr → Expr
| anno : String → Option Typ → Expr → Expr → Expr
deriving Repr

declare_syntax_cat subtra
declare_syntax_cat params
declare_syntax_cat quals
declare_syntax_cat typ

declare_syntax_cat patrec
declare_syntax_cat pat
declare_syntax_cat exprrec
declare_syntax_cat function
declare_syntax_cat expr


syntax "@" : subtra
syntax "TOP" : subtra
syntax "<" ident ">" subtra : subtra
syntax subtra "&" subtra : subtra

syntax "]" : params
syntax ident params : params

syntax ":" : quals
syntax "(" typ "<:" typ ")" quals : quals

syntax ident : typ
syntax "@" : typ
syntax "<" ident ">" typ : typ
syntax:50 typ:51 "->" typ:50 : typ
syntax:60 typ:61 "|" typ:60 : typ
syntax:80 typ:81 "&" typ:80 : typ
syntax typ "\\" subtra : typ
syntax "ALL" "[" params quals typ : typ
syntax "EXI" "[" params quals typ : typ
syntax "ALL" "[" params typ : typ
syntax "EXI" "[" params typ : typ
syntax "BOT" : typ
syntax "TOP" : typ
syntax "(" typ ")" : typ


syntax "<" ident ">" pat : patrec
syntax "<" ident ">" pat patrec : patrec

syntax ident : pat
syntax "@" : pat
syntax patrec : pat
syntax ident ";" pat : pat


syntax "<" ident ">" expr : exprrec
syntax "<" ident ">" expr exprrec : exprrec

syntax "[" pat "=>" expr "]" : function
syntax "[" pat "=>" expr "]" function : function

syntax ident : expr
syntax "@" : expr
syntax exprrec : expr
syntax ident ";" expr : expr
syntax:60 expr:61 "," expr:60 : expr
syntax function : expr
syntax:70 expr:70 "." ident : expr
syntax:80 expr:80 "(" expr ")" : expr
syntax "def" ident ":" typ "=" expr "in" expr : expr
syntax "def" ident "=" expr "in" expr : expr
syntax "(" expr ")" : expr


syntax "s[" subtra "]" : term
syntax "ps[" params "]" : term
syntax "qs[" quals "]" : term
syntax "t[" typ "]" : term
syntax "pr[" patrec "]" : term
syntax "p[" pat "]" : term
syntax "er[" exprrec "]" : term
syntax "f[" function "]" : term
syntax "e[" expr "]" : term


macro_rules
| `(s[ TOP ]) => `(Subtra.top)
| `(s[ @ ]) => `(Subtra.unit)
| `(s[ < $i:ident > $s:subtra  ]) => `(Subtra.entry $(Lean.quote (toString i.getId)) s[$s])
| `(s[ $x:subtra & $y:subtra]) => `(Subtra.inter s[$x] s[$y])

macro_rules
| `(ps[ ] ]) => `([])
| `(ps[ $i:ident $ps:params ]) => `($(Lean.quote (toString i.getId)) :: ps[$ps])

macro_rules
| `(qs[ : ]) => `([])
| `(qs[ ( $x:typ <: $y:typ ) $qs:quals ]) => `( (Constraint.subtyping t[$x] t[$y]):: qs[$qs])

macro_rules
| `(t[ $i:ident ]) => `(Typ.var $(Lean.quote (toString i.getId)))
| `(t[ @ ]) => `(Typ.unit)
| `(t[ < $i:ident > $t:typ  ]) => `(Typ.entry $(Lean.quote (toString i.getId)) t[$t])
| `(t[ $x:typ -> $y:typ ]) => `(Typ.path t[$x] t[$y])
| `(t[ $x:typ | $y:typ ]) => `(Typ.unio t[$x] t[$y])
| `(t[ $x:typ & $y:typ ]) => `(Typ.inter t[$x] t[$y])
| `(t[ $x:typ \ $y:subtra ]) => `(Typ.diff t[$x] s[$y])
| `(t[ ALL [ $ps:params $qs:quals $t:typ ]) => `(Typ.all ps[$ps] qs[$qs] t[$t])
| `(t[ EXI [ $ps:params $qs:quals $t:typ ]) => `(Typ.exi ps[$ps] qs[$qs] t[$t])
| `(t[ ALL [ $ps:params $t:typ ]) => `(Typ.all ps[$ps] [] t[$t])
| `(t[ EXI [ $ps:params $t:typ ]) => `(Typ.exi ps[$ps] [] t[$t])
| `(t[ BOT ]) => `(Typ.all ["T"] [] (Typ.var "T"))
| `(t[ TOP ]) => `(Typ.exi ["T"] [] (Typ.var "T"))
| `(t[ ( $t:typ ) ]) => `(t[$t])


macro_rules
| `(pr[ <$i:ident> $p:pat ]) => `(($(Lean.quote (toString i.getId)), p[$p]) :: [])
| `(pr[ <$i:ident> $p:pat $pr:patrec ]) => `(($(Lean.quote (toString i.getId)), p[$p]) :: pr[$pr])

macro_rules
| `(p[ $i:ident ]) => `(Pat.var $(Lean.quote (toString i.getId)))
| `(p[ @ ]) => `(Pat.unit)
| `(p[ $pr:patrec ]) => `(Pat.record pr[$pr])
| `(p[ $i:ident ; $p:pat ]) => `(Pat.record ($(Lean.quote (toString i.getId)), p[$p]) :: [])

macro_rules
| `(er[ <$i:ident> $e:expr ]) => `(($(Lean.quote (toString i.getId)), e[$e]) :: [])
| `(er[ <$i:ident> $e:expr $er:exprrec ]) => `(($(Lean.quote (toString i.getId)), e[$e]) :: er[$er])

macro_rules
| `(f[ [ $p:pat => $e:expr ] ]) => `((p[$p], e[$e]) :: [])
| `(f[ [ $p:pat => $e:expr ] $f:function ]) => `((p[$p], e[$e]) :: f[$f])

macro_rules
| `(e[ $i:ident ]) => `(Expr.var $(Lean.quote (toString i.getId)))
| `(e[ @ ]) => `(Expr.unit)
| `(e[ $er:exprrec ]) => `(Expr.record er[$er])
| `(e[ $i:ident ; $e:expr ]) => `(Expr.record ($(Lean.quote (toString i.getId)), e[$e]) :: [])
| `(e[ $l:expr , $r:expr ]) => `(Expr.record [("left", e[$l]), ("right", e[$r])])
| `(e[ $f:function ]) => `(Expr.function f[$f])
| `(e[ $e:expr . $i:ident ]) => `(Expr.proj e[$e] $(Lean.quote (toString i.getId)))
| `(e[ $f:expr ( $a:expr ) ]) => `(Expr.app e[$f] e[$a])
| `(e[ def $i:ident : $t:typ = $a:expr in $c:expr  ]) => `(Expr.anno
    $(Lean.quote (toString i.getId))
    (some t[$t])
    (e[$a])
    (e[$c])
)
| `(e[ def $i:ident = $a:expr in $c:expr  ]) => `(Expr.anno
    $(Lean.quote (toString i.getId))
    none
    (e[$a])
    (e[$c])
)
| `(e[ ( $e:expr ) ]) => `(e[$e])

class SubtraOf (_ : Typ) where
  default : Subtra

instance : SubtraOf t[TOP] where
  default := s[TOP]

instance : SubtraOf t[@] where
  default := s[@]

instance (label : String) (result : Typ) [s : SubtraOf result]
: SubtraOf (Typ.entry label result)  where
  default := Subtra.entry label s.default

instance
  (left : Typ) [l : SubtraOf left]
  (right : Typ) [r : SubtraOf right]
: SubtraOf (Typ.inter left right)  where
  default := Subtra.inter l.default r.default


class RecordPatternOf (_ : List (String × Expr)) where
  default : List (String × Pat)

class PatternOf (_ : Expr) where
  default : Pat

instance (id : String) : PatternOf (Expr.var id) where
  default := Pat.var id

instance : PatternOf (Expr.unit) where
  default := Pat.unit

instance (entries : List (String × Expr)) [d : RecordPatternOf entries] : PatternOf (Expr.record entries) where
  default := Pat.record d.default


instance : RecordPatternOf [] where
  default := []

instance
  (label : String) (result : Expr) [pd : PatternOf result]
  (remainder : List (String × Expr)) [rpd: RecordPatternOf remainder]
: RecordPatternOf ((label, result) :: remainder) where
  default := (label, pd.default) :: rpd.default


instance (e : Expr) [p : PatternOf e] : CoeDep Expr e Pat where
  coe := p.default
