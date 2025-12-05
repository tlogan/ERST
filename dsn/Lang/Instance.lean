import Lean
import Lang.Util
import Lang.Basic
import Lang.Static

import Mathlib.Tactic.Linarith

def Typ.UpperFounded.compute (id : String) : Typ → Lean.MetaM Typ
| .exi [] quals (.var id') => do
  let cases := ListSubtyping.bounds id .true quals
  if List.length cases == List.length quals then
    let t := Typ.combine .false cases
    let t' := Typ.sub [(id', .var id)] t
    return (.unio (.var id') t')
  else
    failure
| _ => failure

#eval  [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
#eval Typ.UpperFounded.compute
  "R"
  [typ| EXI[] [(<succ> G010 <: R)  (<succ> <succ> G010 <: R)] G010 ]

syntax "Typ_UpperFounded_prove" : tactic
macro_rules
| `(tactic| Typ_UpperFounded_prove) => `(tactic|
  (
  apply Typ.UpperFounded.intro
  · rfl
  · rfl
  · rfl
  · Typ_Monotonic_Static_prove
  · rfl
  )
)


syntax "prove_list_subtyping_monotonic_either" : tactic
syntax "prove_list_subtyping_monotonic" : tactic
syntax "Typ_Monotonic_Static_prove" : tactic

macro_rules
| `(tactic| prove_list_subtyping_monotonic_either) => `(tactic|
  (first
  | apply EitherMultiPolarity.nil
  | apply EitherMultiPolarity.cons _ _ .true
    · prove_list_subtyping_monotonic
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic_either
  | apply EitherMultiPolarity.cons _ _ .false
    · prove_list_subtyping_monotonic
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic_either
  ) <;> fail
)

| `(tactic| prove_list_subtyping_monotonic) => `(tactic|
  (first
  | apply MultiPolarity.nil
  | apply EitherMultiPolarity.cons
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
    · prove_list_subtyping_monotonic
  ) <;> fail
)
| `(tactic| Typ_Monotonic_Static_prove) => `(tactic|
  (first
  | apply Polarity.var
  | apply Polarity.varskip; simp
  | apply Polarity.entry; Typ_Monotonic_Static_prove

  | apply Polarity.path
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Polarity.bot
  | apply Polarity.top
  | apply Polarity.unio
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Polarity.inter
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Polarity.diff
    · Typ_Monotonic_Static_prove
    · Typ_Monotonic_Static_prove
  | apply Polarity.all
    · simp
    · prove_list_subtyping_monotonic_either
    · Typ_Monotonic_Static_prove
  | apply Polarity.allskip; simp
  | apply Polarity.bot
    · rfl
  | apply Polarity.exi
    · simp
    · prove_list_subtyping_monotonic_either
    · Typ_Monotonic_Static_prove
  | apply Polarity.top
    · rfl
  | apply Polarity.lfp
    · simp
    · Typ_Monotonic_Static_prove
  | apply Polarity.lfpskip; simp
  ) <;> fail
)




mutual
  def ListPatLifting.Static.compute (Δ : ListSubtyping) (Γ : List (String × Typ))
  : List (String × Pat) →  Lean.MetaM (Typ × ListSubtyping × List (String × Typ))
  | [] => return (Typ.top, Δ, Γ)
  | (l,p) :: [] => do
    let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ p
    return (Typ.entry l t, Δ', Γ')

  | (l,p) :: remainder => do
    let (t, Δ', Γ') ← PatLifting.Static.compute Δ Γ p
    let (t', Δ'', Γ'') ← ListPatLifting.Static.compute Δ' Γ' remainder
    return (Typ.inter (Typ.entry l t) t', Δ'', Γ'')



  def PatLifting.Static.compute (Δ : ListSubtyping) (Γ : ListTyping)
  : Pat → Lean.MetaM (Typ × ListSubtyping × ListTyping)
  | .var id => do
    let t := Typ.var (← fresh_typ_id)
    let Δ' := (t, Typ.top) :: Δ
    let Γ' := ((id, t) :: (remove id Γ))
    return (t, Δ', Γ')
  | .iso label body => do
    let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ body
    return (Typ.iso label t, Δ', Γ')
  | .record items => ListPatLifting.Static.compute Δ Γ items
end

syntax "PatLifting_Static_prove" : tactic
macro_rules
| `(tactic| PatLifting_Static_prove) => `(tactic|
  (first
    | apply PatLifting.Static.var
    | apply PatLifting.Static.record_nil
    | apply PatLifting.Static.record_single
      · PatLifting_Static_prove
    | apply PatLifting.Static.record_cons
      · PatLifting_Static_prove
      · PatLifting_Static_prove
      · simp [Pat.free_vars, ListPat.free_vars]; rfl
  ) <;> fail
)



mutual

  partial def EitherMultiPolarity.decide (cs : ListSubtyping) (t : Typ)
  : List String → Bool
  | [] => .true
  | id :: ids =>
    (
      (MultiPolarity.decide id .true cs &&
        Polarity.decide id .true t) ||
      (MultiPolarity.decide id .false cs &&
        Polarity.decide id .false t)) &&
    EitherMultiPolarity.decide cs t ids

  partial def MultiPolarity.decide (id : String) (b : Bool) : ListSubtyping → Bool
  | .nil => .true
  | .cons (l,r) remainder =>
    Polarity.decide id (not b) l &&
    Polarity.decide id b r &&
    MultiPolarity.decide id b remainder


  partial def Polarity.decide (id : String) (b : Bool) : Typ → Bool
  | .var id' =>
    if id == id' then
      b == .true
    else
      .true
  | .iso _ body =>
    Polarity.decide id b body
  | .entry _ body =>
    Polarity.decide id b body
  | .path left right =>
    Polarity.decide id (not b) left &&
    Polarity.decide id b right
  | .bot => .true
  | .top => .true
  | .unio left right =>
    Polarity.decide id b left &&
    Polarity.decide id b right
  | .inter left right =>
    Polarity.decide id b left &&
    Polarity.decide id b right
  | .diff left right =>
    Polarity.decide id b left &&
    Polarity.decide id (not b) right

  | .all ids subtypings body =>
    ids.contains id || (
      EitherMultiPolarity.decide subtypings body ids &&
      Polarity.decide id b body
    )

  | .exi ids subtypings body =>
    ids.contains id || (
      EitherMultiPolarity.decide subtypings (.diff .top body) ids &&
      Polarity.decide id b body
    )

  | .lfp id' body =>
    id == id' || Polarity.decide id b body
end

mutual

  partial def ListSubtyping.Static.solve
    (skolems : List String) (assums : ListSubtyping)
  : ListSubtyping → Lean.MetaM (List (List String × ListSubtyping))
    | [] => return [(skolems, assums)]
    | (lower,upper) :: remainder => do
      let worlds ← Subtyping.Static.solve skolems assums lower upper
      (worlds.flatMapM (fun (skolems',assums') =>
        ListSubtyping.Static.solve skolems' assums' remainder
      ))

  partial def Subtyping.Static.solve
    (skolems : List String) (assums : ListSubtyping) (lower upper : Typ )
  : Lean.MetaM (List (List String × ListSubtyping))
  := if (Typ.toBruijn [] lower) == (Typ.toBruijn [] upper) then
    return [(skolems,assums)]
  else match lower, upper with
    | (.iso ll lower), (.iso lu upper) =>
      if ll == lu then
        Subtyping.Static.solve skolems assums lower upper
      else return []
    | (.entry ll lower), (.entry lu upper) =>
      if ll == lu then
        Subtyping.Static.solve skolems assums lower upper
      else return []

    | (.path p q), (.path x y) => do
      (← Subtyping.Static.solve skolems assums x p).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' q y)
      )

    | .bot, _ => return [(skolems,assums)]
    | _, .top => return [(skolems,assums)]

    | (.unio a b), t => do
      (← Subtyping.Static.solve skolems assums a t).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' b t)
      )

    | (.exi ids quals body), t => do
      if ListSubtyping.restricted skolems assums quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← ListSubtyping.Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
          (Subtyping.Static.solve (ids' ∪ skolems') assums' body' t)
        )
      else return []


    | t, (.inter a b) => do
      (← Subtyping.Static.solve skolems assums t a).flatMapM (fun (skolems',assums') =>
        (Subtyping.Static.solve skolems' assums' t b)
      )

    | t, (.all ids quals body) =>
      if ListSubtyping.restricted skolems assums quals then do
        let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
        let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
        let ids' : List String := pairs.map (fun (_, id') => id')
        let quals' := ListSubtyping.sub subs quals
        let body' := Typ.sub subs body
        (← ListSubtyping.Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
          (Subtyping.Static.solve (ids' ∪ skolems') assums' t body')
        )
      else return []

    | (.var id), t => do
      if id ∉ skolems then
        let lowers_id := ListSubtyping.bounds id .true assums
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (.var id, t) :: assums')
        )
      else if (assums.exi (fun
        | (.var idl, .var idu) => idl == id && not (skolems.contains idu)
        | _ => .false
      )) then
        let lowers_id := ListSubtyping.bounds id .true assums
        let trans := lowers_id.map (fun lower_id => (lower_id, t))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (.var id, t) :: assums')
        )
      else
        let uppers_id := ListSubtyping.bounds id .false assums
        (uppers_id.flatMapM (fun upper_id =>
          let pass := (match upper_id with
            | .var id' => skolems.contains id'
            | _ => true
          )
          (if pass then
            (Subtyping.Static.solve skolems assums upper_id t)
          else
            return []
          )
        ))

    | t, (.var id) => do
      if not (skolems.contains id) then
        let uppers_id := ListSubtyping.bounds id .false assums
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (t, .var id) :: assums')
        )
      else if (assums.exi (fun
        | (.var idl, .var idu) => idu == id && not (skolems.contains idl)
        | _ => .false
      )) then
        let uppers_id := ListSubtyping.bounds id .false assums
        let trans := uppers_id.map (fun upper_id => (t,upper_id))
        (← ListSubtyping.Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
          return (skolems', (t, .var id) :: assums')
        )
      else do
        let lowers_id := ListSubtyping.bounds id .true assums
        (lowers_id.flatMapM (fun lower_id =>
          let pass := (match lower_id with
            | .var id' => skolems.contains id'
            | _ => true
          )
          (if pass then
            (Subtyping.Static.solve skolems assums t lower_id)
          else
            return []
          )
        ))


    | l, (.path (.unio a b) r) =>
      Subtyping.Static.solve skolems assums l (.inter (.path a r) (.path b r))


    | l, (.path r (.inter a b)) =>
      Subtyping.Static.solve skolems assums l (.inter (.path r a) (.path r b))

    | t, (.entry l (.inter a b)) =>
      Subtyping.Static.solve skolems assums t (.inter (.entry l a) (.entry l b))


    | (.lfp id lower), upper =>
      if not (lower.free_vars.contains id) then
        Subtyping.Static.solve skolems assums lower upper
      else if Polarity.decide id .true lower then do
        let result ← Subtyping.Static.solve skolems assums (Typ.sub [(id, upper)] lower) upper
        if not result.isEmpty then
          return result
        else
          -- Lean.logInfo ("<<< lfp debug upper >>>\n" ++ (repr upper))
          match upper with
          | (.entry l body_upper) => match Typ.factor id lower l with
              | .some fac  =>
                  -- Lean.logInfo ("<<< lfp debug fac >>>\n" ++ (repr (Typ.lfp id fac)))
                  -- Lean.logInfo ("<<< lfp debug body_upper >>>\n" ++ (repr body_upper))
                  Subtyping.Static.solve skolems assums (.lfp id fac) body_upper
              | .none => return []
          | (.diff l r) => match Typ.height r with
              | .some h =>
                -- Lean.logInfo ("<<< lfp debug upper diff h(r)>>>\n" ++ (repr h))
                if (
                  Typ.is_pattern [] r &&
                  Polarity.decide id .true lower &&
                  Typ.struct_less_than (.var id) lower &&
                  not (Subtyping.check (Typ.subfold id lower 1) r) &&
                  not (Subtyping.check r (Typ.subfold id lower h))
                ) then
                  Subtyping.Static.solve skolems assums lower l
                else return []
              | .none => return []
          | _ => return []
      else return []

    | t, (.diff l r) =>
      if (
        Typ.is_pattern [] r &&
        ¬ Subtyping.check t r &&
        ¬ Subtyping.check r t
      ) then
        Subtyping.Static.solve skolems assums t l
      else
        return []
--
    | l, (.lfp id r) =>
      if Subtyping.peelable l r then
        Subtyping.Static.solve skolems assums l (.sub [(id, .lfp id r)] r)
      else
        let r' := Typ.drop id r
        Subtyping.Static.solve skolems assums l r'

    | (.diff l r), t =>
      Subtyping.Static.solve skolems assums l (.unio r t)


    | t, (.unio l r) => do
      return (
        (← Subtyping.Static.solve skolems assums t l) ++
        (← Subtyping.Static.solve skolems assums t r)
      )

    | l, (.exi ids quals r) => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let r' := Typ.sub subs r
      let quals' := ListSubtyping.sub subs quals
      (← Subtyping.Static.solve skolems assums l r').flatMapM (fun (θ',assums') =>
        ListSubtyping.Static.solve θ' assums' quals'
      )

    | (.inter l r), t => do
      return (
        (← Subtyping.Static.solve skolems assums l t) ++
        (← Subtyping.Static.solve skolems assums r t)
      )

    | (.all ids quals l), r  => do
      let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
      let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
      let l' := Typ.sub subs l
      let quals' := ListSubtyping.sub subs quals
      (← Subtyping.Static.solve skolems assums l' r).flatMapM (fun (θ',assums') =>
        ListSubtyping.Static.solve θ' assums' quals'
      )



    -- TODO: consider removing path merging. union antecedent rule should be sufficient
    -- | (.inter l r), t => match t with
    --   | .path p q => match Typ.merge_paths (.inter l r) with
    --     | .some t' => Subtyping.Static.solve skolems assums t' (.path p q)
    --     | .none => return (
    --       (← Subtyping.Static.solve skolems assums l t) ++
    --       (← Subtyping.Static.solve skolems assums r t)
    --     )
    --   | _ => return (
    --     (← Subtyping.Static.solve skolems assums l t) ++
    --     (← Subtyping.Static.solve skolems assums r t)
    --   )


    | _, _ => return []

end

mutual

  partial def Zone.interpret (ignore : List String) (b : Bool) : Zone → Lean.MetaM Zone
  | ⟨skolems, assums, t⟩ => do
    let t' ← Typ.interpret ignore skolems assums b t
    let assums' := Typ.transitive_connections [] assums b t'
    return ⟨skolems, assums', t'⟩


  partial def Typ.interpret
    (ignore : List String) (skolems : List String) (assums : List (Typ × Typ))
  : Bool → Typ → Lean.MetaM Typ
  | b, .var id => do
    if ignore.contains id || skolems.contains id then
      return .var id
    else
      let bds := (ListSubtyping.bounds id b assums).eraseDups
      if bds == [] then
        return .var id
      else
        let t := Typ.combine (not b) bds
        if (t == .bot || t == .top) then
          return .var id
        else
          Typ.interpret ([id] ∪  ignore) skolems assums b t

  | b, .iso label body => do
    let body' ← Typ.interpret ignore skolems assums b body
    return .iso label body'

  | b, .entry label body => do
    let body' ← Typ.interpret ignore skolems assums b body
    return .entry label body'

  | b, .inter l r => do
    let l' ← Typ.interpret ignore skolems assums b l
    let r' ← Typ.interpret ignore skolems assums b r
    return Typ.simp (Typ.inter l' r')

  | b, .unio l r => do
    let l' ← Typ.interpret ignore skolems assums b l
    let r' ← Typ.interpret ignore skolems assums b r
    return Typ.simp (Typ.unio l' r')

  | b, .path antec consq => do
    let antec' ← Typ.interpret ignore skolems assums (not b) antec
    let ignore' := (Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore
    let consq' ← Typ.interpret ignore' skolems assums b consq
    return Typ.simp (Typ.path antec' consq')

  | .true, .exi ids_exi quals_exi (.all _ quals body) => do
    let constraints := quals_exi ++ quals

    let zones ← (
      ← ListSubtyping.Static.solve (ids_exi ∪ skolems) assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones

  | .true, (.all _ quals body) => do
    let constraints := quals

    let zones ← (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .true zones

  | .false, .all ids_all quals_all (.exi _ quals body) => do
    let constraints := quals_all ++ quals

    let zones ← (
      ← ListSubtyping.Static.solve (ids_all ∪ skolems) assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones


  | .false, (.exi _ quals body) => do
    let constraints := quals
    let zones ← (
      ← ListSubtyping.Static.solve skolems assums constraints
    ).mapM (fun (skolems', assums') => do
      let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
      return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
    )
    return ListZone.pack (ignore ∪ skolems ∪ ListSubtyping.free_vars assums) .false zones

  | _, t => do
    return t
end


mutual
  partial def Function.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (subtras : List Typ) :
    List (Pat × Expr) → Lean.MetaM (List (List Zone))
  | [] => return []

  | (p,e)::f => do
    let (tp, Δ', Γ') ←  PatLifting.Static.compute Δ Γ p
    let nested_zones ← Function.Typing.Static.compute Θ Δ Γ (tp::subtras) f
    let tl := ListTyp.diff tp subtras
    let zones ← (← Expr.Typing.Static.compute Θ Δ' Γ' e).mapM (fun ⟨Θ', Δ'', tr ⟩ => do
      let ⟨skolems'', assums''', t⟩ ← Zone.interpret [] .true ⟨Θ', Δ'', (.path tl tr)⟩
      return ⟨List.diff skolems'' Θ, List.diff assums''' Δ, t⟩
    )
    return zones :: nested_zones

  partial def ListZone.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (e : Expr)
  : Lean.MetaM (List Zone)
  := do
    (← Expr.Typing.Static.compute Θ Δ Γ e).mapM (fun  ⟨Θ', Δ', t⟩ =>
      return ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩
    )

  partial def LoopListZone.Subtyping.Static.compute (pids : List String) (id : String)
  : List Zone → Lean.MetaM Typ
  | [⟨Θ, Δ, .path (.var idl) r⟩] =>
    if id != idl then do
      match (
        (ListSubtyping.invert id Δ).bind (fun Δ' =>
          let t' := Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩
          (Typ.factor id t' "left").bind (fun l =>
          (Typ.factor id t' "right").map (fun r' => do
            let l' ← Typ.UpperFounded.compute id l
            let r'' := Typ.sub [(idl, .lfp id l')] r'
            if Polarity.decide idl .true r' then
              return (.path (.var idl) (.lfp id r''))
            else
              failure
          ))
        )
      ) with
        | .some result => result
        | .none => failure
    else failure

  | zones => do
    let op_result ← (ListZone.invert id zones).bindM (fun zones' => do
      let t' := ListZone.pack (id :: pids) .false zones'
      (Typ.factor id t' "left").bindM (fun l => do
      (Typ.factor id t' "right").bindM (fun r => do
        let l' ← Typ.interpret [id] [] [] .false l
        let r' ← Typ.interpret [id] [] [] .false r
        return Option.some (Typ.path (.lfp id l') (.lfp id r'))
      ))
    )
    match op_result with
    | .some result => return result
    | .none => failure

  partial def Record.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
  : List (String × Expr) → Lean.MetaM (List Zone)
  | [] => return [⟨Θ, Δ, .top⟩]
  | (l,e) :: [] => do
    (← (Expr.Typing.Static.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      return [⟨Θ', Δ', (.entry l t)⟩]
    )
  | (l,e) :: r => do
    (← (Expr.Typing.Static.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
    (← (Record.Typing.Static.compute Θ' Δ' Γ r)).flatMapM (fun ⟨Θ'', Δ'',t'⟩ =>
      return [⟨Θ'', Δ'', (.inter (.entry l t) (t'))⟩]
    ))

  partial def Expr.Typing.Static.compute
    (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
  : Expr → Lean.MetaM (List Zone)
  | .var x =>  match find x Γ with
    | .some t => return [⟨Θ, Δ, t⟩]
    | .none => failure

  | .iso label body => do
    (← Expr.Typing.Static.compute Θ Δ Γ body).mapM (fun ⟨skolems', assums', body'⟩ =>
      return ⟨skolems', assums', Typ.iso label body'⟩
    )

  | .record r =>  Record.Typing.Static.compute Θ Δ Γ r

  | .function f => do
    -- Lean.logInfo ("<<< assums >>>\n" ++ (repr Δ))
    let nested_zones ← (Function.Typing.Static.compute Θ Δ Γ [] f)
    -- Lean.logInfo ("<<< Nested Zones >>>\n" ++ (repr nested_zones))
    let zones := (nested_zones.flatten)
    let t := ListZone.pack (ListSubtyping.free_vars Δ) .true zones
    return [⟨Θ, Δ, t⟩]

  | .app ef ea => do
    let α ← fresh_typ_id
    (← Expr.Typing.Static.compute Θ Δ Γ ef).flatMapM (fun ⟨Θ', Δ', tf⟩ => do
    (← Expr.Typing.Static.compute Θ' Δ' Γ ea).flatMapM (fun ⟨Θ'', Δ'', ta⟩ => do
    (← Subtyping.Static.solve Θ'' Δ'' tf (.path ta (.var α))).flatMapM (fun ⟨Θ''', Δ'''⟩ => do
      -- NOTE: do not remove anything from global assumptions
      let t ← Typ.interpret [] Θ''' Δ''' .true (.var α)
      return [ ⟨Θ''', Δ''', t⟩ ]
    )))

  | .loop e => do
    let id ← fresh_typ_id
    (← Expr.Typing.Static.compute Θ Δ Γ e).flatMapM (fun ⟨Θ', Δ', t⟩ => do
      let id_antec ← fresh_typ_id
      let id_consq ← fresh_typ_id

      let body := (Typ.path (.var id_antec) (.var id_consq))

      let zones_local ← (
        ← Subtyping.Static.solve Θ' Δ' t (Typ.path (.var id) body)
      ).flatMapM (fun (skolems'', assums'') => do
        let ⟨skolems''', assums'', body'⟩ ← Zone.interpret [id] .true ⟨skolems'', assums'', body⟩
        let op_assums''' := ListSubtyping.loop_normal_form id assums''
        match op_assums''' with
        | some assums''' =>
          return [Zone.mk (List.removeAll skolems''' Θ) (List.removeAll assums''' Δ') body']
        | none => return []
      )
      -- Lean.logInfo ("<<< LOOP ID >>>\n" ++ (repr id))
      -- Lean.logInfo ("<<< ZONES LOCAL >>>\n" ++ (repr zones_local))
      let t' ← LoopListZone.Subtyping.Static.compute (ListSubtyping.free_vars Δ') id zones_local

      return [⟨Θ', Δ', t'⟩]
    )


  | .anno e ta =>
    if Typ.free_vars ta == [] then do
      let zones ← ListZone.Typing.Static.compute Θ Δ Γ e
      let te := ListZone.pack (ListSubtyping.free_vars Δ) .false zones
      (← Subtyping.Static.solve Θ Δ te ta).flatMapM (fun (Θ', Δ') =>
        return [⟨Θ', Δ', ta⟩]
      )
    else
      return []

end


syntax "ListSubtyping_Static_prove" : tactic
syntax "Subtyping_Static_prove" : tactic

macro_rules
| `(tactic| ListSubtyping_Static_prove) => `(tactic|
  (first
    | apply ListSubtyping.Static.nil
    | apply ListSubtyping.Static.cons
      · Subtyping_Static_prove
      · ListSubtyping_Static_prove
  ) <;> fail
)
| `(tactic| Subtyping_Static_prove) => `(tactic|
  (first
    | apply Subtyping.Static.refl
    | apply Subtyping.Static.iso_pres
      · Subtyping_Static_prove
    | apply Subtyping.Static.entry_pres
      · Subtyping_Static_prove
    | apply Subtyping.Static.path_pres
      · Subtyping_Static_prove
      · Subtyping_Static_prove
    | apply Subtyping.Static.bot_elim
    | apply Subtyping.Static.top_intro
    | apply Subtyping.Static.unio_elim
      · Subtyping_Static_prove
      · Subtyping_Static_prove
    | apply Subtyping.Static.exi_elim
      { rfl }
      { rfl }
      { simp [ListSubtyping.free_vars, Typ.free_vars, Union.union, List.union] }
      { ListSubtyping_Static_prove }
      { Subtyping_Static_prove }
    | apply Subtyping.Static.inter_intro
      · Subtyping_Static_prove
      · Subtyping_Static_prove
    | apply Subtyping.Static.all_intro
      { rfl }
      { rfl }
      { simp [ListSubtyping.free_vars, Typ.free_vars, Union.union, List.union] }
      { ListSubtyping_Static_prove }
      { Subtyping_Static_prove }
    | apply Subtyping.Static.placeholder_elim
      · simp
      · apply lower_bound_map
        · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
      · ListSubtyping_Static_prove

    | apply Subtyping.Static.placeholder_intro
      · simp
      · apply upper_bound_map
        · simp only [ListSubtyping.bounds, Subtyping.target_bound]; rfl
      · ListSubtyping_Static_prove

    | apply Subtyping.Static.skolem_placeholder_intro
      -- · simp
      -- · simp
      · apply List.Mem.head
      · apply skolem_upper_bound
        · reduce; simp
      · apply upper_bound_map
        · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
      · ListSubtyping_Static_prove

    | apply Subtyping.Static.skolem_intro
      · apply List.mem_of_elem_eq_true; rfl
      · apply lower_bound_mem
        · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · simp [Typ.refl_BEq_true]; rfl
      · simp
      · Subtyping_Static_prove

    | apply Subtyping.Static.skolem_placeholder_elim
      · apply List.Mem.head
      · apply skolem_lower_bound
        · reduce; simp
      · apply lower_bound_map
        · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
      · ListSubtyping_Static_prove







    | apply Subtyping.Static.skolem_elim
      · apply List.mem_of_elem_eq_true; rfl
      · apply upper_bound_mem
        · simp [ListSubtyping.bounds, Subtyping.target_bound]; rfl
        · simp [Typ.refl_BEq_true]; rfl
      · simp
      · Subtyping_Static_prove

    | apply Subtyping.Static.unio_antec
      { Subtyping_Static_prove }
      { Subtyping_Static_prove }

    | apply Subtyping.Static.inter_conseq
      { Subtyping_Static_prove }
      { Subtyping_Static_prove }

    | apply Subtyping.Static.inter_entry
      { Subtyping_Static_prove }
      { Subtyping_Static_prove }

    | apply Subtyping.Static.lfp_factor_elim
      · rfl
      · reduce; Subtyping_Static_prove

    | apply Subtyping.Static.lfp_skip_elim
      · exact Iff.mp List.count_eq_zero rfl
      · Subtyping_Static_prove

    | apply Subtyping.Static.lfp_induct_elim
      · Typ_Monotonic_Static_prove
      · reduce; Subtyping_Static_prove

    | apply Subtyping.Static.lfp_elim_diff_intro
      { rfl }
      { simp [Typ.struct_less_than]; reduce
        (first
        | apply Or.inl ; rfl
        | apply Or.inr ; rfl
        ) <;> fail }
      { rfl }
      { Typ_Monotonic_Static_prove }
      { Subtyping_Static_prove }
      { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }
      { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }

    | apply Subtyping.Static.diff_intro
      { rfl }
      { simp [
          Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
          ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
        ] }
      { simp [
          Subtyping.check, Typ.toBruijn, ListSubtyping.toBruijn,
          ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
        ] }
      { Subtyping_Static_prove }


    | apply Subtyping.Static.lfp_peel_intro
      · simp [Subtyping.peelable, Typ.break, Subtyping.check]
      · simp [Typ.sub, find] ; Subtyping_Static_prove

    | apply Subtyping.Static.lfp_drop_intro
      { Subtyping_Static_prove }

    | apply Subtyping.Static.diff_elim
      · Subtyping_Static_prove

    | apply Subtyping.Static.unio_left_intro
      · Subtyping_Static_prove

    | apply Subtyping.Static.unio_right_intro
      · Subtyping_Static_prove

    | apply Subtyping.Static.exi_intro
      · Subtyping_Static_prove
      · ListSubtyping_Static_prove

    | apply Subtyping.Static.inter_left_elim
      · Subtyping_Static_prove

    | apply Subtyping.Static.inter_right_elim
      · Subtyping_Static_prove

    -- | apply Subtyping.Static.inter_merge_elim
    --   · rfl
    --   · Subtyping_Static_prove

    | apply Subtyping.Static.all_elim
      · Subtyping_Static_prove
      · ListSubtyping_Static_prove
  ) <;> fail
)



#check Option.mapM



syntax "eq_rhs_assign" : tactic

elab_rules : tactic
| `(tactic| eq_rhs_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  Lean.logInfo m!"goalType: {goalType}"

  let mvar ← (match goalType with
  | .app _ right => return right
  | _ => failure
  )

  let left ← (match (← Lean.Meta.whnf goalType) with
  | .app (.app _ left) _ => return left
  | _ => failure
  )
  -- let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

  Lean.logInfo m!"left: {left}"
  Lean.logInfo m!"mvar: {mvar}"

  Lean.MVarId.assign mvar.mvarId! left
  let goalType_instantiated ← (Lean.instantiateMVars goalType)

example : ∃ t, "thing" = t
:= by
  use ?t
  eq_rhs_assign
  { rfl  }
  { exact "" }




def Function.Typing.Static.extract_mvar : Lean.Expr → Lean.MetaM Lean.Expr
| .app x y => return y
| _ => failure

def Function.Typing.Static.extract_info : Lean.Expr → Lean.MetaM Lean.Expr
| .app x y => return x
| _ => failure

def Function.Typing.Static.extract_applicands :
  Lean.Expr → Lean.MetaM (Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr)
| Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app _ a ) b) c) d) e =>
    return (a,b,c,d,e)
| _ => failure

def Function.Typing.Static.to_computation :
  Lean.Expr → Lean.MetaM Lean.Expr
| Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Function.Typing.Static [])
  a ) b) c) d) e =>
    return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
      (Lean.Expr.const `Function.Typing.Static.compute [])
    a ) b) c) d) e
| _ => failure



syntax "Function_Typing_Static_assign" : tactic

elab_rules : tactic
| `(tactic| Function_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  let mvar ← Function.Typing.Static.extract_mvar goalType
  let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

  -- Lean.logInfo m!"mvar: {mvar}"
  -- Lean.logInfo m!"GoalInfo: {goalInfo}"
  let computation ← Function.Typing.Static.to_computation goalInfo

  -- Lean.logInfo m!"Computation: {computation}"

  let ListListZoneTypeExpr := Lean.mkApp
    (Lean.mkConst ``Lean.MetaM)
    (Lean.mkApp
      (Lean.mkConst ``List [Lean.levelZero])
      (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))
    )
  let metaM_result ← unsafe Lean.Meta.evalExpr
    (Lean.MetaM (List (List Zone)))
    ListListZoneTypeExpr computation
  let result ← metaM_result
  -- Lean.logInfo ("<<<result>>> " ++ (repr result))
  let lean_expr_result := Lean.toExpr result
  Lean.MVarId.assign mvar.mvarId! lean_expr_result
  let goalType_instantiated ← (Lean.instantiateMVars goalType)
  -- Lean.Elab.Tactic.replaceMainGoal [goal]

  ---------------------------------------

#eval Function.Typing.Static.compute [] [] [] [] [(Pat.var "x", Expr.var "x")]

example  : ∃ nested_zones , Function.Typing.Static [] [] [] [] [(Pat.var "x", Expr.var "x")] nested_zones
:= by
  use ?nested_zones
  { Function_Typing_Static_assign <;> sorry}
  { sorry }


syntax "ListZone_Typing_Static_assign" : tactic

elab_rules : tactic
| `(tactic| ListZone_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
  let goal ← Lean.Elab.Tactic.getMainGoal
  let goalDecl ← goal.getDecl
  let goalType := goalDecl.type

  let whnf ← Lean.Meta.whnf goalType
  let (antec, conseq) ← (match whnf with
  | Lean.Expr.forallE _ _ (
      Lean.Expr.forallE _ _ (
        Lean.Expr.forallE _ _ (
          Lean.Expr.forallE _ antec conseq _
        ) _
      ) _
    ) _ => return (antec, conseq)
  | _ => failure
  )


  Lean.logInfo m!"antec: {antec}"
  Lean.logInfo m!"conseq: {conseq}"

  let mvar  ← (match antec with
  | Lean.Expr.app (Lean.Expr.app _ a) _ => return a
  | _ => failure
  )

  -- Lean.logInfo m!"mvar: {mvar}"

  let pred  ← (match conseq with
  | Lean.Expr.app (Lean.Expr.app (Lean.Expr.app a _) _ ) _ => return a
  | _ => failure
  )

  let computation ← (match pred with
  | (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Expr.Typing.Static []) a) b) c) d
  ) => return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
    (Lean.Expr.const `Expr.Typing.Static.compute []) a) b) c) d
  | _ => failure
  )

  -- Lean.logInfo m!"computation: {computation}"

  let ListZoneTypeExpr := Lean.mkApp
    (Lean.mkConst ``Lean.MetaM)
    (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))

  -- Lean.logInfo m!"ListZoneTypeExpr: {ListZoneTypeExpr}"

  let metaM_result ← unsafe Lean.Meta.evalExpr
    (Lean.MetaM (List Zone)) ListZoneTypeExpr computation
  let result ← metaM_result
  -- Lean.logInfo ("<<<result>>> " ++ (repr result))
  let lean_expr_result := Lean.toExpr result
  Lean.MVarId.assign mvar.mvarId! lean_expr_result
  let goalType_instantiated ← (Lean.instantiateMVars goalType)
  -- Lean.Elab.Tactic.replaceMainGoal [goal]

example t : ∃ zones : List Zone ,
∀ {skolems' : List String} {assums'' : List (Typ × Typ)} {tr : Typ},
  { skolems := skolems', assums := assums'', typ := Typ.path (ListTyp.diff t []) tr } ∈ zones →
    Expr.Typing.Static [] [] [] (Expr.record []) tr (skolems' ++ []) (assums'' ++ [])
:= by
  use ?_
  ListZone_Typing_Static_assign
  sorry
  sorry


syntax "Function_Typing_Static_prove" : tactic
syntax "Record_Typing_Static_prove" : tactic
syntax "Subtyping_GuardedListZone_Static_prove" : tactic
syntax "ListZone_Typing_Static_prove" : tactic
syntax "LoopListZone_Subtyping_Static_prove" : tactic
syntax "Expr_Typing_Static_prove" : tactic


macro_rules
| `(tactic| Function_Typing_Static_prove) => `(tactic|
  (try Function_Typing_Static_assign) ;
  (first
  | apply Function.Typing.Static.nil
  | apply Function.Typing.Static.cons <;> fail
    -- TODO: to compute and assign zones
    -- NOTE: needs tactics to extract inputs run computation and assign results
    -- NOTE: such tactics are extremely tedious
    -- { apply ListZone.tidy_undo_tidy }
    -- { simp [ListZone.undo_tidy]
    --   intros _ _ _ _ assums_eq t_eq
    --   simp [*, ListTyp.diff]
    --   apply And.intro
    --   { exact? }
    --   {
    --     repeat (apply Typ.diff_drop (not_eq_of_beq_eq_false rfl))
    --     rfl
    --   }
    -- }
    -- { Function_Typing_Static_prove }
    -- { PatLifting_Static_prove }
    -- { simp; intros _ _ _ p ; simp [ListZone.undo_tidy] at p ;
    --   simp [*]; Typing_Static_prove }
  ) <;> fail
)

| `(tactic| Record_Typing_Static_prove) => `(tactic|
  (first
  | apply Record.Typing.Static.nil
  | apply Record.Typing.Static.single
    · Expr_Typing_Static_prove
  | apply Record.Typing.Static.cons
    · Expr_Typing_Static_prove
    · Record_Typing_Static_prove
  ) <;> fail )

| `(tactic| ListZone_Typing_Static_prove) => `(tactic|
  (apply Subtyping.ListZone.Static.intro
    · intro
      · Expr_Typing_Static_prove
  ) )

| `(tactic| LoopListZone_Subtyping_Static_prove) => `(tactic|
  (first
  | apply LoopListZone.Subtyping.Static.batch
    · rfl
    · rfl
    · rfl
    · rfl
  | apply LoopListZone.Subtyping.Static.stream
    · simp
    · rfl
    · rfl
    · rfl
    · rfl
    · Typ_Monotonic_Static_prove
    · Typ_UpperFounded_prove
    · rfl
  ) <;> fail )

| `(tactic| Expr_Typing_Static_prove) => `(tactic|
  (first
  | apply Expr.Typing.Static.var
    · rfl
  | apply Expr.Typing.Static.record
    · Record_Typing_Static_prove

  | apply Expr.Typing.Static.function
    { Function_Typing_Static_prove }
    { reduce; simp_all ; try (eq_rhs_assign ; rfl) }

  | apply Expr.Typing.Static.app
    · Expr_Typing_Static_prove
    · Expr_Typing_Static_prove
    · Subtyping_Static_prove

  | apply Expr.Typing.Static.loop
    { Expr_Typing_Static_prove }
    { apply Subtyping.ListZone.Static.intro
      {intro; Subtyping_Static_prove}
      {rfl} }
    { LoopListZone_Subtyping_Static_prove }

  | apply Expr.Typing.Static.anno
    · simp
    · ListZone_Typing_Static_prove
    · rfl
    · Subtyping_Static_prove
  ) <;> fail )


set_option pp.fieldNotation false



theorem Typ.lfp_factor_elim_soundness {am id lower upper l fac} :
  Typ.factor id lower l = .some fac →
  Subtyping am fac upper →
  Subtyping am (Typ.lfp id lower) (.entry l upper)
:= by sorry


theorem ListSubtyping.Static.aux {skolems assums cs skolems' assums'} :
  ListSubtyping.Static skolems assums cs skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListSubtyping.free_vars cs ⊆ ListSubtyping.free_vars assums' ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars cs = []
:= by sorry

theorem Subtyping.Static.aux {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  Typ.free_vars lower ⊆ ListSubtyping.free_vars assums' ∧
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars lower = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars upper = []
:= by sorry

theorem Expr.Typing.Static.aux {skolems assums context e t skolems' assums'} :
  Expr.Typing.Static skolems assums context e t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem Function.Typing.Static.aux
  {skolems assums context f nested_zones subtras skolems' assums' t}
:
  Function.Typing.Static skolems assums context subtras f nested_zones →
  ⟨skolems',assums',t⟩ ∈ nested_zones.flatten →
  skolems' ∩ skolems = [] ∧
  skolems' ∩ ListSubtyping.free_vars assums = [] ∧
  skolems' ∩ ListTyping.free_vars context = [] ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums
:= by sorry

theorem Record.Typing.Static.aux
  {skolems assums context r t skolems' assums'}
:
  Record.Typing.Static skolems assums context r t skolems' assums' →
  skolems ⊆ skolems' ∧
  assums ⊆ assums' ∧
  ListTyping.free_vars context ⊆ ListSubtyping.free_vars assums ∧
  Typ.free_vars t ⊆ ListSubtyping.free_vars assums'  ∧
  (List.removeAll skolems' skolems) ∩ ListSubtyping.free_vars assums = [] ∧
  (List.removeAll skolems' skolems) ∩ Typ.free_vars t = []
:= by sorry


theorem Subtyping.Static.upper_containment {skolems assums lower upper skolems' assums'} :
  Subtyping.Static skolems assums lower upper skolems' assums' →
  Typ.free_vars upper ⊆ ListSubtyping.free_vars assums'
:= by
  intro h
  have ⟨p0, p1, p2, p3,_,_,_⟩ := Subtyping.Static.aux h
  apply p3



theorem ListSubtyping.restricted_rename {skolems assums ids quals ids' quals'} :
  ListSubtyping.toBruijn ids quals = ListSubtyping.toBruijn ids' quals' →
  ListSubtyping.restricted skolems assums quals →
  ListSubtyping.restricted skolems assums quals'
:= by sorry


theorem ListSubtyping.solution_completeness {skolems assums cs skolems' assums' am am'} :
  ListSubtyping.restricted skolems assums cs →
  ListSubtyping.Static skolems assums cs skolems' assums' →
  MultiSubtyping am assums' →
  MultiSubtyping (am' ++ am) cs →
  MultiSubtyping (am' ++ am) assums'
:= by sorry


theorem ListSubtyping.dom_disjoint_concat_reorder {am am' am'' cs} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  MultiSubtyping (am ++ (am' ++ am'')) cs →
  MultiSubtyping (am' ++ (am ++ am'')) cs
:= by sorry

theorem Subtyping.dom_disjoint_concat_reorder {am am' am'' lower upper} :
  ListPair.dom am ∩ ListPair.dom am' = [] →
  Subtyping (am ++ (am' ++ am'')) lower upper →
  Subtyping (am' ++ (am ++ am'')) lower upper
:= by sorry

theorem Subtyping.assumptions_independence
  {skolems assums lower upper skolems' assums' am am'}
:
  Subtyping.Static skolems assums lower upper skolems' assums' →
  MultiSubtyping am assums' →
  ListPair.dom am' ⊆ ListSubtyping.free_vars assums →
  MultiSubtyping (am' ++ am) assums →
  MultiSubtyping (am' ++ am) assums'
:= by sorry

theorem Subtyping.pluck {am cs lower upper} :
  MultiSubtyping am cs →
  (lower, upper) ∈ cs →
  Subtyping am lower upper
:= by sorry

theorem Subtyping.trans {am lower upper} t :
  Subtyping am lower t → Subtyping am t upper →
  Subtyping am lower upper
:= by
  simp [Subtyping]
  intros p0 p1
  intros e p5
  apply p1
  apply p0
  assumption

theorem Subtyping.check_completeness {am lower upper} :
  Subtyping am lower upper →
  Subtyping.check lower upper
:= by sorry

theorem Polarity.soundness {id t} am :
  Polarity id true t →
  Monotonic am id t
:= by sorry

set_option maxHeartbeats 500000 in
mutual
  theorem ListSubtyping.Static.soundness {skolems assums cs skolems' assums'} :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping (am ++ am') assums' →
      MultiSubtyping (am ++ am') cs
    )
  | .nil => by
    exists []
    simp
    apply And.intro
    case left =>
      simp [ListPair.dom]
    case right =>
      intro am'
      intro md
      simp [MultiSubtyping]
  | .cons l r cs' skolems_im assums_im ss lss => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness ss
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness lss
    have ⟨p0,p1,p2,p3,p4,p5,p6⟩ := Subtyping.Static.aux ss
    have ⟨p7,p8,p9,p10,p11⟩ := ListSubtyping.Static.aux lss
    exists (am1 ++ am0)
    simp [*]
    apply And.intro
    { exact dom_concat_removeAll_containment p0 ih0l p7 ih1l }
    { intro am' p12
      simp [MultiSubtyping]
      apply And.intro
      { apply Subtyping.dom_extension
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p2
          apply p10 }
        { apply List.disjoint_preservation_left ih1l
          apply List.disjoint_preservation_right p3
          apply p10 }
        { apply ih0r
          apply MultiSubtyping.dom_reduction
          { apply List.disjoint_preservation_left ih1l p10 }
          { apply MultiSubtyping.reduction p8 p12 } } }
      { exact ih1r p12 }
    }


  theorem Subtyping.Static.soundness {skolems assums lower upper skolems' assums'} :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {am'},
      MultiSubtyping (am ++ am') assums' →
      Subtyping (am ++ am') lower upper)
  | .refl => by
    exists []
    simp [*]
    apply And.intro (by simp [ListPair.dom])
    intros am0 p1
    exact Subtyping.refl am0 lower

  | .iso_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.iso_pres l (ih0r p9)

  | .entry_pres l lower0 upper0 p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.entry_pres l (ih0r p9)

  | .path_pres lower0 lower1 upper0 upper1 skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.path_pres
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }
  | .bot_elim skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.bot_elim

  | .top_intro skolems0 assums0 t => by
    exists []
    simp [*]
    apply And.intro; simp [ListPair.dom]
    intros am' p0
    exact Subtyping.top_intro

  | .unio_elim left right t skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (by exact dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.unio_elim
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .exi_elim ids quals body t skolems0 assums0 p0 p4 p5 p1 p2 => by

    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_removeAll_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply removeAll_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.exi_elim p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply removeAll_concat_containment_left
        apply removeAll_left_sub_refl_disjoint

      apply Subtyping.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.reduction p18 p24) p26 } }

  | .inter_intro t left right skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16
    apply Subtyping.inter_intro
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .all_intro t ids quals body skolems0 assums0 p0 p4 p5 p1 p2 => by
    have ⟨am0,ih0l,ih0r⟩ := ListSubtyping.Static.soundness p1
    have ⟨am1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2

    have ⟨p12,p13,p14,p15,p16⟩ := ListSubtyping.Static.aux p1

    have ⟨p17,p18,p19,p20,p21,p22,p23⟩ := Subtyping.Static.aux p2

    exists (am1 ++ am0)
    simp [*]

    apply And.intro
    { apply dom_concat_removeAll_containment p12 ih0l (concat_right_containment p17)
      intros x p24
      apply removeAll_concat_containment_right (ih1l p24) }
    { intros am' p24
      apply Subtyping.all_intro p4
      intros am2 p25 p26

      have p27 : ListPair.dom am1 ∩ ListPair.dom am2 = [] := by
        apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p25
        apply List.disjoint_preservation_left
        apply removeAll_concat_containment_left
        apply removeAll_left_sub_refl_disjoint

      apply Subtyping.dom_disjoint_concat_reorder p27
      apply ih1r
      apply ListSubtyping.dom_disjoint_concat_reorder (List.disjoint_swap p27)

      apply Subtyping.assumptions_independence p2 p24
      { intros x p28
        exact p14 (p5 (p25 p28)) }
      { apply ListSubtyping.solution_completeness p0 p1
          (MultiSubtyping.reduction p18 p24) p26 } }

  | .placeholder_elim id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping] at p30
    simp [*]

  | .placeholder_intro id cs assums' p0 p1 p2 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping] at p30
    simp [*]

  | .skolem_placeholder_elim id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping] at p30
    simp [*]

  | .skolem_placeholder_intro id cs assums' p0 p1 p2 p3 => by
    exists []
    simp [ListPair.dom, *]
    intros am' p30
    simp [MultiSubtyping] at p30
    simp [*]

  | .skolem_intro t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.trans t' (ih0r p40) (Subtyping.pluck p40 (p10 p1))

  | .skolem_elim t' id p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.trans t' (Subtyping.pluck p40 (p10 p1)) (ih0r p40)

  -------------------------------------------------------------------
  | .unio_antec a b r skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.unio_antec
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .inter_conseq upper a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.inter_conseq
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }

  | .inter_entry l a b skolems0 assums0 p0 p1 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    have ⟨am1, ih1l, ih1r⟩ := Subtyping.Static.soundness p1
    have ⟨p9,p10,p11,p12,p13,p14,p15⟩ := Subtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p2 ih0l p9 ih1l)
    intros am' p16

    apply Subtyping.inter_entry
    { apply Subtyping.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p4 p13 }
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p5 p13 }
      { apply ih0r
        apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p13 }
        { apply MultiSubtyping.reduction p10 p16 } } }
    { exact ih1r p16 }

  -------------------------------------------------------------------
  | .lfp_skip_elim id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Subtyping.lfp_skip_elim p0 (ih0r p40)

  | .lfp_induct_elim id lower p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40

    apply Subtyping.lfp_induct_elim (Polarity.soundness (am0 ++ am') p0)
    intro e typing_dynamic_lower
    apply Typ.sub.typing.completeness at typing_dynamic_lower
    unfold Subtyping at ih0r
    apply ih0r p40 _ typing_dynamic_lower

  | .lfp_factor_elim id lower upper fac p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Typ.lfp_factor_elim_soundness p0 (ih0r p40)

  | .lfp_elim_diff_intro id lower upper sub h p0 p1 p2 p3 p4 p5 p6 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p4
    have ⟨p10,p15,p20,p25,p30,p35,p40⟩ := Subtyping.Static.aux p4
    exists am0
    simp [*]
    intros am' p45
    apply Typ.subfold.subtyping.soundness_and_completeness (Polarity.soundness (am0 ++ am') p3) (ih0r p45)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  | .diff_intro upper sub p0 p1 p2 p3 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p3
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p3
    exists am0
    simp [*]
    intro am' p40
    apply Subtyping.diff_intro (ih0r p40)
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }
    { intros p50
      apply Subtyping.check_completeness at p50
      contradiction }

  -------------------------------------------------------------------
  | .lfp_peel_intro id body p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p1
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p1
    exists am0
    simp [*]
    intros am' p40
    apply Typ.sub.lfp.soundness (ih0r p40)

  | .lfp_drop_intro id body p0 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p40
    apply Typ.drop.lfp.soundness (ih0r p40)
  -------------------------------------------------------------------

  | .diff_elim lower sub upper p0  => by

    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p10
    apply Subtyping.diff_elim (ih0r p10)

  | .unio_left_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.unio_left_intro (ih0r p9)

  | .unio_right_intro t l r p0  => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.unio_right_intro (ih0r p9)

  | .exi_intro ids quals upper skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.exi_intro (ih1r p40)
    apply Subtyping.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.reduction p11 p40 } }

  | .inter_left_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp[*]
    intros am' p9
    exact Subtyping.inter_left_elim (ih0r p9)

  | .inter_right_elim l r t p0 => by
    have ⟨am0, ih0l, ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p2,p3,p4,p5,p6,p7,p8⟩ := Subtyping.Static.aux p0
    exists am0
    simp [*]
    intros am' p9
    exact Subtyping.inter_right_elim (ih0r p9)

  | .all_elim ids quals lower skolems0 assums0 p0 p1 => by
    have ⟨am0,ih0l,ih0r⟩ := Subtyping.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30,p35⟩ := Subtyping.Static.aux p0
    have ⟨am1,ih1l,ih1r⟩ := ListSubtyping.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26⟩ := ListSubtyping.Static.aux p1
    exists (am1 ++ am0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)
    intros am' p40
    apply Subtyping.all_elim (ih1r p40)
    apply Subtyping.dom_extension
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p15 p21
     }
    { apply List.disjoint_preservation_left ih1l
      apply List.disjoint_preservation_right p20 p21 }
    { apply ih0r
      apply MultiSubtyping.dom_reduction
      { apply List.disjoint_preservation_left ih1l p21 }
      { apply MultiSubtyping.reduction p11 p40 } }

end


def Expr.Convergence (a b : Expr) :=
  ∃ e , ProgressionStar a e ∧ ProgressionStar b e

theorem Expr.Convergence.typing_left_to_right {a b am t} :
  Expr.Convergence a b →
  Typing am a t →
  Typing am b t
:= by sorry

theorem Expr.Convergence.typing_right_to_left {a b am t} :
  Expr.Convergence a b →
  Typing am b t →
  Typing am a t
:= by sorry


theorem Typ.factor_expansion_soundness {am id t label t' e'} :
  Typ.factor id t label = some t' →
  Typing am e' (.lfp id t') →
  ∃ e ,
    Expr.Convergence (Expr.proj e label) e' ∧
    Typing am e (.lfp id t)
:= by sorry

theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
  Typ.factor id t label = some t' →
  Typing am e (.lfp id t) →
  Expr.Convergence (Expr.proj e label) e' →
  Typing am e' (.lfp id t')
:= by sorry



theorem ListZone.pack_positive_soundness {pids zones t am assums e} :
  ListZone.pack pids .true zones = t →
  -- ListZone.pack (ListSubtyping.free_vars assums) .true zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping am assums →
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping (am'' ++ am' ++ am) assums' →
        Typing (am'' ++ am' ++ am) e t' ) ) ) →
  Typing am e t
:= by sorry


theorem Expr.Convergence.transitivity {a b c} :
  Expr.Convergence a b →
  Expr.Convergence b c →
  Expr.Convergence a c
:= by sorry

theorem Expr.Convergence.swap {a b} :
  Expr.Convergence a b →
  Expr.Convergence b a
:= by sorry

theorem Expr.Convergence.app_arg_preservation {a b} f :
  Expr.Convergence a b →
  Expr.Convergence (.app f a) (.app f b)
:= by sorry

theorem ListZone.pack_negative_soundness {pids zones t am assums e} :
  ListZone.pack pids .false zones = t →
  ListSubtyping.free_vars assums ⊆ pids →
  -- ListZone.pack (id :: ListSubtyping.free_vars assums) .false zones = t →
  MultiSubtyping am assums →
  Typing am e t →
  (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones ∧
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping (am'' ++ am' ++ am) assums' ∧
        Typing (am'' ++ am' ++ am) e t' ) ) )
:= by sorry

theorem Zone.pack_negative_soundness {pids t am assums skolems' assums' t'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping am assums →
  ∀ e, Typing am e t →
    (∀ am'', ListPair.dom am'' ⊆ skolems' →
      (∃ am',
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
        MultiSubtyping (am'' ++ am' ++ am) assums' ∧
        Typing (am'' ++ am' ++ am) e t' ) )
:= by sorry


example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  apply h0
  intro h2
  exact h1

example {P Q R} :
  ((P -> Q) -> R) -> Q -> R
:= by
  intros h0 h1
  specialize h0 (by exact fun a ↦ h1)
  exact h0



theorem Zone.pack_negative_completeness {pids t am assums skolems' assums' t' e am'} :
  Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
  ListSubtyping.free_vars assums ⊆ pids →
  MultiSubtyping am assums →
  MultiSubtyping (am' ++ am) assums' →
  Typing (am' ++ am) e t' →
  Typing am e t
:= by sorry
--   Zone.pack pids .false ⟨skolems', assums', t'⟩ = t →
--   ListSubtyping.free_vars assums ⊆ pids →
--   MultiSubtyping am assums →
--   ∀ e,
--     (∀ am'', ListPair.dom am'' ⊆ skolems' →
--       (∃ am',
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
--         MultiSubtyping (am'' ++ am' ++ am) assums' ∧
--         Typing (am'' ++ am' ++ am) e t' ) ) →
--     Typing am e t
-- := by sorry

theorem ListZone.inversion_soundness {id zones zones' am assums} :
  ListZone.invert id zones = some zones' →
  MultiSubtyping am assums →
  ∀ ef,
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping (am'' ++ am' ++ am) assums' →
        Typing (am'' ++ am' ++ am) ef t' ) ) )
  →
  (∀ ep ,
    (∃ skolems' assums' t', ⟨skolems', assums', t'⟩ ∈ zones' ∧
      (∀ am'', ListPair.dom am'' ⊆ skolems' →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping (am'' ++ am' ++ am) assums' ∧
          Typing (am'' ++ am' ++ am) ep t' ) )
    ) →
    Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
  )
:= by sorry


theorem ListSubtyping.inversion_soundness {id am assums assums0 assums0'} skolems tl tr :
  ListSubtyping.invert id assums0 = some assums0' →
  MultiSubtyping am assums →
  ∀ ef,
    (∃ am'',
      ListPair.dom am'' ⊆ skolems ∧
      ∀ {am' : List (String × Typ)},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
          MultiSubtyping (am'' ++ am' ++ am) assums0 →
            Typing (am'' ++ am' ++ am) ef (.path tl tr))
    →
    (∀ ep,
      (∀ am'', ListPair.dom am'' ⊆ skolems →
        (∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping (am'' ++ am' ++ am) assums0' ∧
          Typing (am'' ++ am' ++ am) ep (.pair tl tr) )
      ) →
      Expr.Convergence (.proj ep "right") (.app ef (.proj ep "left"))
    )
:= by sorry

theorem ListSubtyping.inversion_top_extension {id am assums0 assums1} am' :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping (am' ++ am) assums0 →
  MultiSubtyping (am' ++ (id,.top)::am) assums0
:= by sorry

theorem ListSubtyping.inversion_substance {id am am' assums0 assums1} :
  ListSubtyping.invert id assums0 = some assums1 →
  MultiSubtyping (am' ++ (id,.top)::am) assums0 →
  MultiSubtyping (am' ++ (id,.bot)::am) assums1
:= by sorry


theorem Typing.existential_top_drop
  {id am skolems' assums assums0 ep}
  tl tr
:
  id ∉ (ListSubtyping.free_vars assums) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping (am'' ++ am' ++ (id,.top)::am) assums0 ∧
      Typing (am'' ++ am' ++ (id,.top)::am) ep (.pair tl tr)) →
  (∀ (am'' : List (String × Typ)),
    ListPair.dom am'' ⊆ skolems' →
    ∃ am',
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
      MultiSubtyping (am'' ++ am' ++ am) assums0 ∧
      Typing (am'' ++ am' ++ am) ep (.pair tl tr) )


:= by sorry

theorem Typing.ListZone.existential_top_drop {id am assums ep} {zones' : List Zone} :
  id ∉ (ListSubtyping.free_vars assums) →
  (∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping (am'' ++ am' ++ (id,.top)::am) assums' ∧
          Typing (am'' ++ am' ++ (id,.top)::am) ep t'
  ) →
  ∃ skolems' assums' t',
      ⟨skolems',assums', t'⟩ ∈ zones' ∧
      ∀ (am'' : List (String × Typ)),
        ListPair.dom am'' ⊆ skolems' →
        ∃ am',
          ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] ∧
          MultiSubtyping (am'' ++ am' ++ am) assums' ∧
          Typing (am'' ++ am' ++ am) ep t'


:= by sorry



theorem Typ.factor_imp_typing_covariant {am0 am1 id label t0 t0' t1 t1'} :
  Typ.factor id t0 label = .some t0' →
  Typ.factor id t1 label = .some t1' →
  (∀ e , Typing am0 e t0 → Typing am1 e t1) →
  (∀ e , Typing am0 e t0' → Typing am1 e t1')
:= by sorry

-- theorem Typ.factor_subtyping_soundness {am id label t0 t0' t1 t1'} :
--   Typ.factor id t0 label = .some t0' →
--   Typ.factor id t1 label = .some t1' →
--   Subtyping am t0 t1 →
--   Subtyping am t0' t1'
-- := by sorry

theorem Monotonic.pair {am id t0 t1} :
  Monotonic am id t0 →
  Monotonic am id t1 →
  Monotonic am id (.pair t0 t1)
:= by sorry

theorem Typ.factor_monotonic {am id label t t'} :
  Typ.factor id t label = .some t' →
  Monotonic am id t →
  Monotonic am id t'
:= by sorry


theorem Typ.UpperFounded.soundness {id l l'} am :
  Typ.UpperFounded id l l' →
  Subtyping am (.lfp id l) (.lfp id l')
:= by sorry

theorem Typ.sub_weaken_soundness {am idl t0 t1 t2} :
  Typ.sub [(idl, t0)] t1 = t2 →
  Monotonic am idl t1 →
  Subtyping am (.var idl) t0 →
  Subtyping am t1 t2
:= by sorry


theorem Subtyping.LoopListZone.Static.soundness {id zones t am assums e} :
  LoopListZone.Subtyping.Static (ListSubtyping.free_vars assums) id zones t →
  MultiSubtyping am assums →
  id ∉ ListSubtyping.free_vars assums →
  ------------------------------
  -- substance
  ------------------------------
  -- (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
  --   ∃ am' ,
  --   ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
  --   MultiSubtyping (am' ++ am) assums'
  -- ) →
  ------------------------------
  (∀ {skolems' assums' t'}, ⟨skolems', assums', t'⟩ ∈ zones →
    -------------
    -- substance
    -------------
    (∃ am' ,
      ListPair.dom am' ⊆ ListSubtyping.free_vars assums' ∧
      MultiSubtyping (am' ++ am) assums'
    ) ∧
    -------------
    -- soundness
    -------------
    (∃ am'', ListPair.dom am'' ⊆ skolems' ∧
      (∀ {am'},
        ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
        MultiSubtyping (am'' ++ am' ++ am) assums' →
        Typing (am'' ++ am' ++ am) e t' ) )
  ) →
  ------------------------------
  Typing am e t
:= by
  intros p0 p1 p2 substance_and_soundness
  cases p0 with
  | batch zones' t' left right p4 p5 p6 p7 p8 =>
    unfold Typing
    intro ea
    intro p9

    have ⟨ep,p10,p11⟩ := Typ.factor_expansion_soundness p7 p9

    apply Expr.Convergence.typing_left_to_right
      (Expr.Convergence.app_arg_preservation e p10)

    apply Typ.factor_reduction_soundness p8 p11

    have p3 := (fun {x y z} mem_zones =>
      let ⟨substance, soundness⟩ := @substance_and_soundness x y z mem_zones
      soundness
    )
    apply ListZone.inversion_soundness p4 p1 at p3

    apply p3 ep

    have p12 : Typing ((id, .top) :: am) ep t' := by
      apply Typing.lfp_elim_top (Polarity.soundness am p6) p11
    have p13 : MultiSubtyping ((id,.top) :: am) assums := by
      apply MultiSubtyping.dom_single_extension p2 p1

    apply Typing.ListZone.existential_top_drop p2

    apply ListZone.pack_negative_soundness p5
      (List.subset_cons_of_subset id (fun _ x => x)) p13 p12


  | stream
    skolems assums0 assums0' idl r t' l r' l' r''
    p4 idl_fresh p5 p6 p7 p8 p9 p10 upper_founded sub_eq
  =>
    unfold Typing
    intro ea
    intro p13

    have ⟨substance, soundness⟩ := substance_and_soundness (Iff.mpr List.mem_singleton rfl)
    have ⟨am', dom_local_assums, subtyping_local_assums⟩ := substance

    have subtyping_assums0'_bot : MultiSubtyping (am' ++ (id,.bot)::am) assums0' := by
      apply ListSubtyping.inversion_substance p5
      apply ListSubtyping.inversion_top_extension am' p5 subtyping_local_assums

    have factor_pair : Typ.factor id (.pair (.var idl) r) "left" = some (Typ.var idl) := by
      reduce; rfl

    have monotonic_packed : Monotonic ((id, Typ.bot) :: am) id t' := by
      exact Polarity.soundness ((id, Typ.bot) :: am) p7

    have imp_typing_pair_to_packed :
      ∀ e ,
        Typing (am' ++ (id,.bot)::am) e (Typ.pair (Typ.var idl) r) →
        Typing ((id,.bot)::am) e t'
    := by
      intros e_pair typing_pair
      apply Zone.pack_negative_completeness p6
        (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
        (MultiSubtyping.dom_single_extension p2 p1)
        subtyping_assums0'_bot
        typing_pair

    have imp_typing_factored_left :
      ∀ e ,
        Typing (am' ++ (id,.bot)::am) e (Typ.var idl) →
        Typing ((id,.bot)::am) e l
    := by
      exact fun e a ↦ Typ.factor_imp_typing_covariant factor_pair p8 imp_typing_pair_to_packed e a

    have subtyping_idl_left : Subtyping ((id,.bot)::am) (Typ.var idl) l := by
      unfold Subtyping
      intros el typing_idl
      apply imp_typing_factored_left
      apply Typing.dom_extension
      { simp [Typ.free_vars]
        apply List.disjoint_preservation_left dom_local_assums
        exact List.nonmem_to_disjoint_right idl (ListSubtyping.free_vars assums0) idl_fresh }
      { exact typing_idl }

    have typing_idl_bot : Typing ((id,.bot)::am) ea (Typ.var idl) := by
      apply Typing.dom_single_extension (Iff.mp List.count_eq_zero rfl) p13

    have typing_factor_left_bot : Typing ((id,.bot)::am) ea l := by
      unfold Subtyping at subtyping_idl_left
      exact subtyping_idl_left ea typing_idl_bot

    have monotonic_left : Monotonic am id l := by
      apply Typ.factor_monotonic p8 (Polarity.soundness am p7)

    have typing_factor_left : Typing am ea (.lfp id l) :=
      Typing.lfp_intro_bot monotonic_left typing_factor_left_bot


    have subtyping_left_pre := Typ.UpperFounded.soundness am upper_founded
    unfold Subtyping at subtyping_left_pre

    have subtyping_left : Subtyping am (Typ.var idl) (Typ.lfp id l') := by
      unfold Subtyping
      intro el typing_idl
      apply subtyping_left_pre
      apply Typing.lfp_intro_bot monotonic_left
      unfold Subtyping at subtyping_idl_left
      apply subtyping_idl_left
      apply Typing.dom_single_extension (Iff.mp List.count_eq_zero rfl)
      exact typing_idl

    have subtyping_right : Subtyping am (.lfp id r') r'' := by
      apply Typ.sub_weaken_soundness sub_eq
        (Polarity.soundness am p10) subtyping_left

    unfold Subtyping at subtyping_right
    apply subtyping_right

    have ⟨ep,p14,p15⟩ := Typ.factor_expansion_soundness p8 typing_factor_left

    apply Expr.Convergence.typing_left_to_right (Expr.Convergence.app_arg_preservation e p14)
    apply Typ.factor_reduction_soundness p9 p15

    apply ListSubtyping.inversion_soundness skolems (Typ.var idl) r p5 p1 at soundness

    apply soundness ep

    have p20 : Typing ((id, .top) :: am) ep t' := by
      apply Typing.lfp_elim_top (Polarity.soundness am p7) p15

    have p22 : MultiSubtyping ((id,.top) :: am) assums := by
      apply MultiSubtyping.dom_single_extension p2 p1

    apply Typing.existential_top_drop (Typ.var idl) r p2

    apply Zone.pack_negative_soundness p6
      (List.subset_cons_of_subset id (List.subset_cons_of_subset idl (fun _ x => x)))
      p22 ep p20

-- theorem ListZone.tidy_substance {pids zones0 zones1 am} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums0 ∧
--         MultiSubtyping (am'' ++ am) assums0)
--   →
--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--       ∃ am'' ,
--         ListPair.dom am'' ⊆ ListSubtyping.free_vars assums1 ∧
--         MultiSubtyping (am'' ++ am) assums1)
-- := by sorry


-- theorem ListZone.tidy_soundness {pids zones0 zones1 am assums e} :
--   ListZone.tidy pids zones0 = .some zones1 →
--   (ListSubtyping.free_vars assums) ⊆ pids →
--   MultiSubtyping am assums →
--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping (am'' ++ am' ++ am) assums0 →
--         Typing (am'' ++ am' ++ am) e t0 ) ) ) →

--   (∀ {skolems assums1 t1}, ⟨skolems, assums1, t1⟩ ∈ zones1 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
--         MultiSubtyping (am'' ++ am' ++ am) assums1 →
--         Typing (am'' ++ am' ++ am) e t1 ) ) )
-- := by sorry

-- theorem ListZone.tidy_soundness_alt
--   {zones0 zones1 e context skolems assums1 t1}
--   {assums : List (Typ × Typ)}
-- :
--   ListZone.tidy (ListSubtyping.free_vars assums) zones0 = .some zones1 →
--   ⟨skolems, assums1, t1⟩ ∈ zones1 →

--   (∀ {skolems assums0 t0}, ⟨skolems, assums0, t0⟩ ∈ zones0 →
--     (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--       (∀ {am'},
--         MultiSubtyping (am'' ++ am') (assums0 ++ assums) →
--         ∀ {eam}, MultiTyping am' eam context →
--         Typing (am'' ++ am') (Expr.sub eam e) t0 ) ) ) →

--   (∃ am'', ListPair.dom am'' ⊆ skolems ∧
--     (∀ {am'},
--       MultiSubtyping (am'' ++ am') (assums1 ++ assums) →
--       ∀ {eam}, MultiTyping am' eam context →
--       Typing (am'' ++ am') (Expr.sub eam e) t1 ) )
-- := by sorry


theorem MultiSubtyping.concat {am cs cs'} :
  MultiSubtyping am cs →
  MultiSubtyping am cs' →
  MultiSubtyping am (cs ++ cs')
:= by sorry

theorem MultiSubtyping.union {am cs cs'} :
  MultiSubtyping am cs →
  MultiSubtyping am cs' →
  MultiSubtyping am (cs ∪ cs')
:= by sorry

theorem MultiSubtyping.concat_elim_left {am cs cs'} :
  MultiSubtyping am (cs ++ cs') →
  MultiSubtyping am cs
:= by sorry



theorem PatLifting.Static.soundness {assums context p t assums' context'} :
  PatLifting.Static assums context p t assums' context' →
  ∀ tam v, Expr.is_value v → Typing tam v t →
    ∃ eam , Expr.pattern_match v p = .some eam ∧ MultiTyping tam eam context'
:= by sorry


theorem pattern_match_ids_containment {v p eam} :
  Expr.pattern_match v p = .some eam →
  Pat.ids p ⊆ ListPair.dom eam
:= by sorry



-- theorem PatLifting.Static.aux {assums context p t assums' context'} :
--   PatLifting.Static assums context p t assums' context' →
--   assums ⊆ assums' ∧
--   Typ.free_vars t ⊆ ListTyping.free_vars context' ∧
--   ListTyping.free_vars context'  ⊆ ListSubtyping.free_vars assums'
-- := by sorry

theorem Function.Typing.Static.subtra_soundness {
  skolems assums context f nested_zones subtra subtras skolems' assums' t
} :
  Function.Typing.Static skolems assums context  subtras f nested_zones →
  subtra ∈ subtras →
  ⟨skolems', assums', t⟩ ∈ nested_zones.flatten →
  ∀ am , ¬ Subtyping am t (.path subtra .top)
:= by sorry

mutual
  theorem Subtyping.Static.substance {
    skolems assums lower upper skolems' assums' am
  } :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    MultiSubtyping am assums →
    ∃ am'' ,
    ListPair.dom am'' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping (am'' ++ am) (List.removeAll assums' assums)
  := by sorry
end


theorem Typ.combine_bounds_positive_soundness {id am assums e} :
  (∀ am , MultiSubtyping am assums → Typing am e (.var id)) →
  MultiSubtyping am assums →
  Typing am e (Typ.combine_bounds id true assums)
:= by sorry

theorem Typ.combine_bounds_positive_subtyping_path_conseq_soundness {id am am_skol assums t antec} :
  id ∉ ListPair.dom am_skol →
  MultiSubtyping (am_skol ++ am) assums →
  (∀ {am} ,
    MultiSubtyping (am_skol ++ am) assums →
    Subtyping (am_skol ++ am) t (.path antec (.var id))
  ) →
  Subtyping (am_skol ++ am) t (.path antec (Typ.combine_bounds id true assums))
:= by sorry

-- theorem Typ.factor_expansion_soundness {am id t label t' e'} :
--   Typ.factor id t label = some t' →
--   Typing am e' (.lfp id t') →
--   ∃ e ,
--     Expr.Convergence (Expr.proj e label) e' ∧
--     Typing am e (.lfp id t)
-- := by sorry

-- theorem Typ.factor_reduction_soundness {am id t label t' e' e} :
--   Typ.factor id t label = some t' →
--   Typing am e (.lfp id t) →
--   Expr.Convergence (Expr.proj e label) e' →
--   Typing am e' (.lfp id t')
-- := by sorry





mutual

  theorem Zone.Interp.aux {ignore skolems assums t skolems' assums' t'} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    skolems = skolems'
  := by sorry




  theorem Zone.Interp.integrated_positive_soundness
  {ignore skolems assums t skolems' assums' t' e skolems_base assums_base context} :
    Zone.Interp ignore .true ⟨skolems, assums, t⟩ ⟨skolems', assums', t'⟩ →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping tam' eam context →
                Typing (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems' skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping (tam ++ tam') (List.removeAll assums' assums_base ∪ assums_base) →
            ∀ (eam : List (String × Expr)),
              MultiTyping tam' eam context →
                Typing (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry


  -- theorem Typ.Interp.positive_soundness {ignore skolems assums t t'} :
  --   Typ.Interp ignore skolems assums .true t t' →
  --   ∀ am , MultiSubtyping am assums → Subtyping am t t'
  -- := by sorry

  theorem Typ.Interp.integrated_positive_soundness
  {ignore skolems assums t t' e skolems_base context} :
    Typ.Interp ignore skolems assums .true t t' →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping tam' eam context →
                Typing (tam ++ tam') (Expr.sub eam e) t
    ) →
    (∃ tam,
      ListPair.dom tam ⊆ List.removeAll skolems skolems_base ∧
        ∀ (tam' : List (String × Typ)),
          MultiSubtyping (tam ++ tam') assums →
            ∀ (eam : List (String × Expr)),
              MultiTyping tam' eam context →
                Typing (tam ++ tam') (Expr.sub eam e) t'
    )
  := by sorry

end


theorem  ListSubtyping.loop_normal_form_integrated_completeness
{id am assums assums' assums''} :
  ListSubtyping.loop_normal_form id assums' = some assums'' →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping (am' ++ am) (List.removeAll assums' assums)
  ) →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums'' assums) ∧
      MultiSubtyping (am' ++ am) (List.removeAll assums'' assums)
  )
:= by sorry


theorem  Zone.Interp.assums_integrated_completeness
{ignore b am assums skolems' assums' t' skolems'' assums'' t''} :
  Zone.Interp ignore b ⟨skolems', assums', t'⟩ ⟨skolems'', assums'', t''⟩ →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums' assums) ∧
    MultiSubtyping (am' ++ am) (List.removeAll assums' assums)
  ) →
  (∃ am',
    ListPair.dom am' ⊆ ListSubtyping.free_vars (List.removeAll assums'' assums) ∧
      MultiSubtyping (am' ++ am) (List.removeAll assums'' assums)
  )
:= by sorry





theorem  ListSubtyping.loop_normal_form_integrated_soundness
{id am_base skolems skolems' assums assums' assums'' e t} :
  ListSubtyping.loop_normal_form id assums' = some assums'' →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping (am'' ++ am' ++ am_base) (List.removeAll assums' assums) →
      Typing (am'' ++ am' ++ am_base) e t
  ) →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping (am'' ++ am' ++ am_base) (List.removeAll assums'' assums) →
      Typing (am'' ++ am' ++ am_base) e t
  )
:= by sorry



theorem  Zone.Interp.integrated_soundness
{ignore b am_base skolems skolems' skolems'' assums assums' assums'' e t' t''} :
  Zone.Interp ignore b ⟨skolems', assums', t'⟩ ⟨skolems'', assums'', t''⟩ →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping (am'' ++ am' ++ am_base) (List.removeAll assums' assums) →
      Typing (am'' ++ am' ++ am_base) e t'
  ) →
  (∃ am'',
    ListPair.dom am'' ⊆ List.removeAll skolems'' skolems ∧
    ∀ {am' : List (String × Typ)},
      ListPair.dom am' ∩ ListSubtyping.free_vars assums = [] →
      MultiSubtyping (am'' ++ am' ++ am_base) (List.removeAll assums'' assums) →
      Typing (am'' ++ am' ++ am_base) e t''
  )
:= by sorry


-- set_option maxHeartbeats 1000000 in
mutual

  theorem Function.Typing.Static.soundness {
    skolems assums context f nested_zones subtras skolems''' assums'''' t
  } :
    Function.Typing.Static skolems assums context subtras f nested_zones →
    ⟨skolems''', assums'''', t⟩ ∈ nested_zones.flatten →
    ∃ tam, ListPair.dom tam ⊆ skolems''' ∧
    (∀ tam', MultiSubtyping (tam ++ tam') (assums'''' ∪ assums) →
      (∀ eam, MultiTyping tam' eam context →
        Typing (tam ++ tam') (Expr.sub eam (.function f)) t ) )
  | .nil => by intros ; contradiction
  | .cons
      pat e f assums0 context0 tp zones nested_zones subtras
      pat_lifting_static typing_static keys function_typing_static
  => by
    intro mem_con_zones
    cases (Iff.mp List.mem_append mem_con_zones) with
    | inl mem_zones =>

      have ⟨skolems'', removeAll_skolems, assums''', removeAll_assums, skolems', assums'', tr, interp⟩ := (keys _ _ _ mem_zones)
      specialize typing_static _ _ _ mem_zones skolems'' removeAll_skolems assums''' removeAll_assums skolems' assums'' tr interp
      clear keys

      rw [← removeAll_skolems]
      rw [← removeAll_assums]

      apply Zone.Interp.integrated_positive_soundness interp

      have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness typing_static

      have ⟨p24,p26,p28,p30,p32,p34⟩ := Expr.Typing.Static.aux typing_static

      exists tam0

      apply And.intro ih0l

      intros tam' subtyping_dynamic_assums
      intros eam typing_dynamic_context
      apply Typing.function_head_elim
      intros v p44 p46
      have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p44 p46
      exists eam0
      simp [*]
      rw [Expr.sub_sub_removal (pattern_match_ids_containment p48)]

      apply ih0r subtyping_dynamic_assums
      apply MultiTyping.dom_reduction
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p28 p32 }
      { apply MultiTyping.dom_context_extension p50 }

    | inr p11 =>
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness function_typing_static p11
      have ⟨p20,p22,p24,p26⟩ := Function.Typing.Static.aux function_typing_static p11

      exists tam0
      simp [*]
      intros tam' p30
      intros eam p32

      apply Typing.function_tail_elim
      { intros v p40 p42
        have ⟨eam0,p48,p50⟩ := PatLifting.Static.soundness pat_lifting_static (tam0 ++ tam') v p40 p42
        apply Exists.intro eam0 p48 }
      { apply Function.Typing.Static.subtra_soundness function_typing_static List.mem_cons_self p11 }
      { apply ih0r _ p30 _ p32 }


  theorem Record.Typing.Static.soundness {skolems assums context r t skolems' assums'} :
    Record.Typing.Static skolems assums context r t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping tam' eam context →
        Typing (tam ++ tam') (Expr.sub eam (.record r)) t ) )
  | .nil => by
    exists []
    simp [*, ListPair.dom]
    intros tam' p10
    intros eam p20
    simp [Expr.sub, List.record_sub]
    apply Typing.empty_record_top

  | .single l e body p0 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    exists tam0
    simp [*]
    intros tam' p40
    intros eam p50
    apply Typing.entry_intro _ (ih0r p40 p50)

  | .cons l e r body t skolems0 assums0 p0 p1 => by

    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p10,p15,p20,p25,p30⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Record.Typing.Static.soundness p1
    have ⟨p6,p11,p16,p21,p26,p31⟩ := Record.Typing.Static.aux p1

    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p6 ih1l)

    intros tam' p40
    intros eam p50
    apply Typing.inter_entry_intro
    { apply Typing.dom_extension
      { apply List.disjoint_preservation_left ih1l
        apply List.disjoint_preservation_right p20 p26 }
      { apply ih0r
        { apply MultiSubtyping.dom_reduction
          { apply List.disjoint_preservation_left ih1l p26 }
          { apply MultiSubtyping.reduction p11 p40 } }
        { apply p50 } } }
    { apply ih1r p40
      apply MultiTyping.dom_extension
      { apply List.disjoint_preservation_left ih0l
        apply List.disjoint_preservation_right p15 p25 }
      { apply p50 } }


  theorem Expr.Typing.Static.soundness {skolems assums context e t skolems' assums'} :
    Expr.Typing.Static skolems assums context e t skolems' assums' →
    ∃ tam, ListPair.dom tam ⊆ (List.removeAll skolems' skolems) ∧
    (∀ {tam'}, MultiSubtyping (tam ++ tam') assums' →
      (∀ {eam}, MultiTyping tam' eam context →
        Typing (tam ++ tam') (Expr.sub eam e) t ) )

  | .var skolems assums context x p0 => by
    exists []
    simp [ListPair.dom, *]
    intros tam' p1
    intros eam p2
    unfold MultiTyping at p2
    have ⟨e,p3,p4⟩ := p2 p0
    simp [Expr.sub, p3, p4]

  | .record r p0 => by
    apply Record.Typing.Static.soundness p0

  | .function f zones p0 p1 => by
      exists []
      simp [*, ListPair.dom]
      intros tam' p2
      intros eam p3

      apply ListZone.pack_positive_soundness p1 (fun _ x => x) p2
      intros skolesm0 assums0 t0 p4
      have ⟨tam0,ih0l,ih0r⟩ := Function.Typing.Static.soundness p0 p4
      have ⟨p10,p11,p12,p13⟩ := Function.Typing.Static.aux p0 p4
      exists tam0
      simp [*]
      intro tam''
      intros p5 p6
      apply ih0r
      { apply MultiSubtyping.union p6
        apply MultiSubtyping.dom_extension
        { apply List.disjoint_preservation_left ih0l p11 }
        { apply MultiSubtyping.dom_extension p5 p2 } }
      { apply MultiTyping.dom_extension
        { apply List.disjoint_preservation_right p13 p5 }
        { apply p3 } }

  | .app ef ea id tf skolems0 assums0 ta skolems1 assums1 t p0 p1 p2 interp => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p105,p7,p8,p9⟩ := Expr.Typing.Static.aux p0
    have ⟨tam1,ih1l,ih1r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p10,p11,p107,p12,p13,p14⟩ := Expr.Typing.Static.aux p1
    have ⟨tam2,ih2l,ih2r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2

    apply Typ.Interp.integrated_positive_soundness interp

    exists tam2 ++ (tam1 ++ tam0)
    apply And.intro
    { apply dom_concat_removeAll_containment
      { intro a p30 ; apply p10 (p5 p30) }
      { apply dom_concat_removeAll_containment p5 ih0l p10 ih1l }
      { apply p15 }
      { apply ih2l } }

    { simp [*]
      intro tam' p30 eam p31
      apply Typing.path_elim
      {
        unfold Subtyping at ih2r
        apply ih2r p30
        apply Typing.dom_extension
        { apply List.disjoint_preservation_left ih2l p20 }
        {
          apply Typing.dom_extension
          {
            apply List.disjoint_preservation_left ih1l
            apply List.disjoint_preservation_right p7 p13
          }
          {
            apply ih0r
            {
              apply MultiSubtyping.dom_reduction
              { apply List.disjoint_preservation_left ih1l p13 }
              {
                apply MultiSubtyping.dom_reduction
                { apply List.disjoint_preservation_left ih2l
                  apply List.disjoint_preservation_right
                  { apply ListSubtyping.free_vars_containment p11  }
                  { exact p19 }
                }
                { apply MultiSubtyping.reduction p11
                  apply MultiSubtyping.reduction p16 p30
                }
              }
            }
            {
              apply p31
            }
          }
        }
      }
      {
        apply Typing.dom_extension
        {
          apply List.disjoint_preservation_left ih2l
          apply List.disjoint_preservation_right p12 p19
        }
        {
          apply ih1r
          {
            apply MultiSubtyping.dom_reduction
            { apply List.disjoint_preservation_left ih2l p19 }
            { apply MultiSubtyping.reduction p16 p30 }
          }
          {
            apply MultiTyping.dom_extension
            { apply List.disjoint_preservation_right p105
              exact List.disjoint_preservation_left ih0l p8 }
            { apply p31 }
          }
        }
      }
    }

  | .loop body t0 id zones id_antec id_consq p0
    subtyping_static keys subtyping_static_zones id_fresh
  => by

    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p0
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p0
    exists tam0
    simp [*]

    intros tam' p20
    intros eam p30

    apply Subtyping.LoopListZone.Static.soundness subtyping_static_zones p20 id_fresh
    intros skolems'''' assums''''' body' mem_zones
    have ⟨
      skolems''', removeAll_skolems, assums'''', removeAll_assums,
      assums''', loop_normal_form, skolems'', assums'', interp
    ⟩ := keys _ _ _ mem_zones

    specialize subtyping_static _ _ _ mem_zones
      skolems''' removeAll_skolems assums'''' removeAll_assums
      assums''' loop_normal_form skolems'' assums'' interp

    rw [← removeAll_skolems]
    rw [← removeAll_assums]

    clear keys

    apply And.intro
    { -- substance / conditional completeness
      apply ListSubtyping.loop_normal_form_integrated_completeness loop_normal_form
      apply Zone.Interp.assums_integrated_completeness interp
      apply Subtyping.Static.substance subtyping_static p20
    }
    { -- soundness
      apply ListSubtyping.loop_normal_form_integrated_soundness loop_normal_form
      apply Zone.Interp.integrated_soundness interp

      have ⟨tam1, h33l, h33r⟩ := Subtyping.Static.soundness subtyping_static
      have ⟨p41,p42,p43,p44,p45,p46,p47⟩ := Subtyping.Static.aux subtyping_static
      exists tam1
      simp [*]

      intros tam'' p55 p56
      apply Typing.loop_path_elim id

      unfold Subtyping at h33r
      apply h33r
      {
        apply MultiSubtyping.removeAll_removal
        {
          apply MultiSubtyping.dom_extension
          { apply List.disjoint_preservation_left h33l p45 }
          { apply MultiSubtyping.dom_extension p55 p20 }
        }
        { exact p56 }
      }
      {
        apply Typing.dom_extension (List.disjoint_preservation_left h33l p46)
        apply Typing.dom_extension (List.disjoint_preservation_right p8 p55)
        apply ih0r p20 p30
      }
    }

  | .anno e ta te skolems0 assums0 p0 p1 p2 => by
    have ⟨tam0,ih0l,ih0r⟩ := Expr.Typing.Static.soundness p1
    have ⟨p5,p6,p7,p8,p9,p10⟩ := Expr.Typing.Static.aux p1
    have ⟨tam1,ih1l,ih1r⟩ := Subtyping.Static.soundness p2
    have ⟨p15,p16,p17,p18,p19,p20,p21⟩ := Subtyping.Static.aux p2
    exists (tam1 ++ tam0)
    simp [*]
    apply And.intro (dom_concat_removeAll_containment p5 ih0l p15 ih1l)
    intros am' p40
    intros eam p42
    apply Typing.anno_intro (ih1r p40)
    apply Typing.dom_extension
    { apply List.disjoint_preservation_left ih1l p20 }
    { apply ih0r
      { apply MultiSubtyping.dom_reduction
        { apply List.disjoint_preservation_left ih1l p19 }
        { apply MultiSubtyping.reduction p16 p40 } }
      { apply p42 } }

end






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

#eval Typ.combine_bounds "T" .true []

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
  [typ| LFP[R] <zero/> | (EXI[N] [ (N <: R) ] <succ> N ) ]
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
      (EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L))
  )]
  [typ| left : LFP[R] (<zero/> | <succ> R) ]


example : Subtyping.Static
  [] []
  [typ| LFP[R]  (
      (<zero/> * <nil/>) |
      (EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L))
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

-------------------------------------------------
-------------------------------------------------

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [x => [<nil/> => <zero/>](x)]
  ]

#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
    ) in
    [x => f(x)]
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

-- RESULT: (<nil/> -> <uno/>)
-- TODO: construct a reachable procedure that filters constraints
-- to only those that are reachable from payload
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [<start/> =>
      def g = (
        [<zero/> => <uno/>]
      ) in
      [x => g([<nil/> => <zero/>](x))]
    ]
  ]


-- RESULT: (<nil/> -> <uno/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    def f = (
      [<nil/> => <zero/>]
    ) in
    def g = (
      [<zero/> => <uno/>]
    ) in
    [x => g(f(x))]
  ]

-- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
    [ <start/> =>
      def f = (
        [<nil/>  => <zero/>]
        [<cons/>  => <succ/>]
      ) in
      def g = (
        [<zero/> => <uno/>]
        [<succ/> => <dos/> ]
      ) in
      -- f
      [x => g(f(x))]
    ]
  ]

-- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
#eval Expr.Typing.Static.compute
  [ids| ] [subtypings| ] []
  [expr|
      def f = (
        [<nil/>  => <zero/>]
        [<cons/>  => <succ/>]
      ) in
      def g = (
        [<zero/> => <uno/>]
        [<succ/> => <dos/> ]
      ) in
      [x => g(f(x))]
  ]

--------------------------------
--------------------------------
--------------------------------

-- -- RESULT: Even -> Uno | Dos
-- #eval Expr.Typing.Static.compute
--   [ids| ] [subtypings| ] []
--   [expr|
--     -- Even -> Even
--     def f = loop ([self =>
--       [<nil/> => <zero/>]
--       [<cons> n => <succ> (self(n)) ]
--     ]) in
--     def g = (
--       [<zero/> => <uno/>]
--       [<succ> n => <dos/> ]
--     ) in
--     [x => g(f(x))]
--   ]
