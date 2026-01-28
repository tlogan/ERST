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
  : List (String × Expr) → Option (List Expr)
  | .nil => none
  | (l, e) :: args =>
    if l == label then
      (Pattern.match e pat)
    else
      Pattern.match_entry label pat args

  def Pattern.match_record (args : List (String × Expr))
  : List (String × Pat) → Option (List Expr)
  | .nil => some []
  | (label, pat) :: pats => do
    if Pat.index_vars pat ∩ Pat.record_index_vars pats == [] then
      let m0 ← Pattern.match_entry label pat args
      let m1 ← Pattern.match_record args pats
      return (m0 ++ m1)
    else
      .none

  def Pattern.match : Expr → Pat → Option (List Expr)
  | e, (.var id) => some [e]
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

theorem Pattern.match_count_eq :
  Pattern.match e p = some m →
  Pat.count_vars p = List.length m
:= by sorry

theorem Pattern.match_entry_count_eq :
  Pattern.match_entry l p r = some m →
  Pat.count_vars p = List.length m
:= by sorry

theorem Pattern.match_var e x :
  Pattern.match e (.var x) = some [e]
:= by sorry

end Lang
