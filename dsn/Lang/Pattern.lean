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


mutual
  theorem Pattern.match_entry_count_eq :
    Pattern.match_entry l p r = some m →
    Pat.count_vars p = List.length m
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
    List.length (Pat.record_index_vars ps) = List.length m
  := by cases ps with
  | nil =>
    simp [Pattern.match_record, Pat.record_index_vars]
    intro h0
    rw [h0]
    simp [List.length]
  | cons lp ps' =>
    have (l,p) := lp
    simp [Pattern.match_record, Pat.record_index_vars]

    match
      h0 : match_entry l p r,
      h1 : match_record r ps'
    with
    | some m0, some m1  =>
      simp
      intro h2 h3
      rw [←h3]
      have ih1 := Pattern.match_entry_count_eq h0
      have ih2 := Pattern.match_record_count_eq h1
      unfold Pat.count_vars at ih1
      rw [ih1,ih2]
      exact Eq.symm List.length_append
    | none,_ => simp
    | _,none => simp




  theorem Pattern.match_count_eq :
    Pattern.match e p = some m →
    Pat.count_vars p = List.length m
  := by cases p with
  | var x =>
    simp [Pattern.match, Pat.count_vars, Pat.index_vars]
    intro h0
    rw [←h0]
    simp [List.length]
  | iso l bp =>
    simp [Pat.count_vars, Pat.index_vars]
    cases e with
    | iso l' body =>
      simp [Pattern.match]
      intro h0
      apply Pattern.match_count_eq
    | _ =>
      simp [Pattern.match]

  | record ps =>
    simp [Pat.count_vars, Pat.index_vars]
    cases e with
    | record r =>
      simp [Pattern.match]
      intro h0
      apply Pattern.match_record_count_eq
    | _ =>
      simp [Pattern.match]
end

theorem Pattern.match_var e x :
  Pattern.match e (.var x) = some [e]
:= by simp [Pattern.match]

end Lang
