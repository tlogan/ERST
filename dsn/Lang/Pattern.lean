import Lang.Basic

set_option pp.fieldNotation false

namespace Lang

def List.keys_unique {α} : List (String × α) → Bool
| .nil =>
  true
| .cons (k,o) kos =>
  List.is_fresh_key k kos && List.keys_unique kos

mutual
  def Pattern.match_entry (label : String) (pat : Pat)
  : List (String × Expr) → Option (List (String × Expr))
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (Pattern.match e pat)
    else
      Pattern.match_entry label pat args

  def Pattern.match_record (args : List (String × Expr))
  : List (String × Pat) → Option (List (String × Expr))
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.ids pat ∩ List.pattern_ids pats == [] then
      let m0 ← Pattern.match_entry label pat args
      let m1 ← Pattern.match_record args pats
      return (m0 ++ m1)
    else
      .none

  def Pattern.match : Expr → Pat → Option (List (String × Expr))
  | e, (.var id) => some [(id, e)]
  | (.iso l e), (.iso label p) =>
    if l == label then
      Pattern.match e p
    else
      none
  | (.record r), (.record p) =>
    if List.keys_unique r then
      Pattern.match_record r p
    else
      none
  | _, _ => none
end

def Pattern.match_nameless (e : Expr) (p : Pat) : Option (List Expr) := do
  let m ← Pattern.match e p
  let names := Pat.index_vars p
  return List.flatMap (fun name =>
    match find name m with
    | some e => [e]
    | none => []
  ) names


theorem Pattern.match_index_membership :
  Pattern.match e p = some m →
  (∀ name, name ∈ ListPair.dom m ↔ name ∈ Pat.index_vars p)
:= by sorry


theorem Pattern.match_var :
  Pattern.match e (.var x) = some [(x,e)]
:= by sorry


end Lang
