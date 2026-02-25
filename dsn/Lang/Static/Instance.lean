-- import Lang.Util
-- import Lang.Basic
-- import Lang.Static

-- import Lean

-- import Mathlib.Tactic.Linarith

-- def Typ.UpperFounded.compute (id : String) : Typ → Lean.MetaM Typ
-- | .exi [] quals (.var id') => do
--   let cases := List.pair_typ_bounds id .true quals
--   if List.length cases == List.length quals then
--     let t := Typ.combine .false cases
--     let t' := Typ.sub [(id', .var id)] t
--     return (.unio (.var id') t')
--   else
--     failure
-- | _ => failure

-- #eval  [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
-- #eval Typ.UpperFounded.compute
--   "R"
--   [typ| EXI[] [(<succ> G010 <: R)  (<succ> <succ> G010 <: R)] G010 ]


-- syntax "prove_list_subtyping_monotonic_either" : tactic
-- syntax "prove_list_subtyping_monotonic" : tactic
-- syntax "Typ_Monotonic_Static_prove" : tactic

-- macro_rules
-- | `(tactic| prove_list_subtyping_monotonic_either) => `(tactic|
--   (first
--   | apply EitherMultiPolarity.nil
--   | apply EitherMultiPolarity.cons _ _ .true
--     · prove_list_subtyping_monotonic
--     · Typ_Monotonic_Static_prove
--     · prove_list_subtyping_monotonic_either
--   | apply EitherMultiPolarity.cons _ _ .false
--     · prove_list_subtyping_monotonic
--     · Typ_Monotonic_Static_prove
--     · prove_list_subtyping_monotonic_either
--   ) <;> fail
-- )

-- | `(tactic| prove_list_subtyping_monotonic) => `(tactic|
--   (first
--   | apply MultiPolarity.nil
--   | apply EitherMultiPolarity.cons
--     · Typ_Monotonic_Static_prove
--     · Typ_Monotonic_Static_prove
--     · prove_list_subtyping_monotonic
--   ) <;> fail
-- )
-- | `(tactic| Typ_Monotonic_Static_prove) => `(tactic|
--   (first
--   | apply Polarity.var
--   | apply Polarity.varskip; simp
--   | apply Polarity.entry; Typ_Monotonic_Static_prove

--   | apply Polarity.path
--     · Typ_Monotonic_Static_prove
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.bot
--   | apply Polarity.top
--   | apply Polarity.unio
--     · Typ_Monotonic_Static_prove
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.inter
--     · Typ_Monotonic_Static_prove
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.diff
--     · Typ_Monotonic_Static_prove
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.all
--     · simp
--     · prove_list_subtyping_monotonic_either
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.allskip; simp
--   | apply Polarity.bot
--     · rfl
--   | apply Polarity.exi
--     · simp
--     · prove_list_subtyping_monotonic_either
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.top
--     · rfl
--   | apply Polarity.lfp
--     · simp
--     · Typ_Monotonic_Static_prove
--   | apply Polarity.lfpskip; simp
--   ) <;> fail
-- )


-- syntax "Typ_UpperFounded_prove" : tactic
-- macro_rules
-- | `(tactic| Typ_UpperFounded_prove) => `(tactic|
--   (
--   apply Typ.UpperFounded.intro
--   · rfl
--   · rfl
--   · rfl
--   · Typ_Monotonic_Static_prove
--   · rfl
--   )
-- )




-- mutual
--   def ListPatLifting.Static.compute (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : List (String × Pat) →  Lean.MetaM (Typ × List (Typ × Typ) × List (String × Typ))
--   | [] => return (Typ.top, Δ, Γ)
--   | (l,p) :: [] => do
--     let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ p
--     return (Typ.entry l t, Δ', Γ')

--   | (l,p) :: remainder => do
--     let (t, Δ', Γ') ← PatLifting.Static.compute Δ Γ p
--     let (t', Δ'', Γ'') ← ListPatLifting.Static.compute Δ' Γ' remainder
--     return (Typ.inter (Typ.entry l t) t', Δ'', Γ'')



--   def PatLifting.Static.compute (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : Pat → Lean.MetaM (Typ × List (Typ × Typ) × List (String × Typ))
--   | .var id => do
--     let t := Typ.var (← fresh_typ_id)
--     let Δ' := (t, Typ.top) :: Δ
--     let Γ' := ((id, t) :: (remove id Γ))
--     return (t, Δ', Γ')
--   | .iso label body => do
--     let (t, Δ', Γ') ← PatLifting.Static.compute  Δ Γ body
--     return (Typ.iso label t, Δ', Γ')
--   | .record items => ListPatLifting.Static.compute Δ Γ items
-- end

-- syntax "PatLifting_Static_prove" : tactic
-- macro_rules
-- | `(tactic| PatLifting_Static_prove) => `(tactic|
--   (first
--     | apply PatLifting.Static.var
--     | apply PatLifting.Static.record_nil
--     | apply PatLifting.Static.record_single
--       · PatLifting_Static_prove
--     | apply PatLifting.Static.record_cons
--       · PatLifting_Static_prove
--       · PatLifting_Static_prove
--       · simp [Pat.free_vars, ListPat.free_vars]; rfl
--   ) <;> fail
-- )



-- mutual

--   partial def EitherMultiPolarity.decide (cs : List (Typ × Typ)) (t : Typ)
--   : List String → Bool
--   | [] => .true
--   | id :: ids =>
--     (
--       (MultiPolarity.decide id .true cs &&
--         Polarity.decide id .true t) ||
--       (MultiPolarity.decide id .false cs &&
--         Polarity.decide id .false t)) &&
--     EitherMultiPolarity.decide cs t ids

--   partial def MultiPolarity.decide (id : String) (b : Bool) : List (Typ × Typ) → Bool
--   | .nil => .true
--   | .cons (l,r) remainder =>
--     Polarity.decide id (not b) l &&
--     Polarity.decide id b r &&
--     MultiPolarity.decide id b remainder


--   partial def Polarity.decide (id : String) (b : Bool) : Typ → Bool
--   | .var id' =>
--     if id == id' then
--       b == .true
--     else
--       .true
--   | .iso _ body =>
--     Polarity.decide id b body
--   | .entry _ body =>
--     Polarity.decide id b body
--   | .path left right =>
--     Polarity.decide id (not b) left &&
--     Polarity.decide id b right
--   | .bot => .true
--   | .top => .true
--   | .unio left right =>
--     Polarity.decide id b left &&
--     Polarity.decide id b right
--   | .inter left right =>
--     Polarity.decide id b left &&
--     Polarity.decide id b right
--   | .diff left right =>
--     Polarity.decide id b left &&
--     Polarity.decide id (not b) right

--   | .all ids constraints body =>
--     ids.contains id || (
--       EitherMultiPolarity.decide constraints body ids &&
--       Polarity.decide id b body
--     )

--   | .exi ids constraints body =>
--     ids.contains id || (
--       EitherMultiPolarity.decide constraints (.diff .top body) ids &&
--       Polarity.decide id b body
--     )

--   | .lfp id' body =>
--     id == id' || Polarity.decide id b body
-- end

-- mutual

--   partial def List.pair_typ_Static.solve
--     (skolems : List String) (assums : List (Typ × Typ))
--   : List (Typ × Typ) → Lean.MetaM (List (List String × List (Typ × Typ)))
--     | [] => return [(skolems, assums)]
--     | (lower,upper) :: remainder => do
--       let worlds ← GuardedSubtyping.solve skolems assums lower upper
--       (worlds.flatMapM (fun (skolems',assums') =>
--         List.pair_typ_Static.solve skolems' assums' remainder
--       ))

--   partial def GuardedSubtyping.solve
--     (skolems : List String) (assums : List (Typ × Typ)) (lower upper : Typ )
--   : Lean.MetaM (List (List String × List (Typ × Typ)))
--   := if (Typ.toBruijn [] lower) == (Typ.toBruijn [] upper) then
--     return [(skolems,assums)]
--   else match lower, upper with
--     | (.iso ll lower), (.iso lu upper) =>
--       if ll == lu then
--         GuardedSubtyping.solve skolems assums lower upper
--       else return []
--     | (.entry ll lower), (.entry lu upper) =>
--       if ll == lu then
--         GuardedSubtyping.solve skolems assums lower upper
--       else return []

--     | (.path p q), (.path x y) => do
--       (← GuardedSubtyping.solve skolems assums x p).flatMapM (fun (skolems',assums') =>
--         (GuardedSubtyping.solve skolems' assums' q y)
--       )

--     | .bot, _ => return [(skolems,assums)]
--     | _, .top => return [(skolems,assums)]

--     | (.unio a b), t => do
--       (← GuardedSubtyping.solve skolems assums a t).flatMapM (fun (skolems',assums') =>
--         (GuardedSubtyping.solve skolems' assums' b t)
--       )

--     | (.exi ids quals body), t => do
--       if List.pair_typ_restricted skolems assums quals then do
--         let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
--         let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
--         let ids' : List String := pairs.map (fun (_, id') => id')
--         let quals' := List.pair_typ_sub subs quals
--         let body' := Typ.sub subs body
--         (← List.pair_typ_Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
--           (GuardedSubtyping.solve (ids' ∪ skolems') assums' body' t)
--         )
--       else return []


--     | t, (.inter a b) => do
--       (← GuardedSubtyping.solve skolems assums t a).flatMapM (fun (skolems',assums') =>
--         (GuardedSubtyping.solve skolems' assums' t b)
--       )

--     | t, (.all ids quals body) =>
--       if List.pair_typ_restricted skolems assums quals then do
--         let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
--         let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
--         let ids' : List String := pairs.map (fun (_, id') => id')
--         let quals' := List.pair_typ_sub subs quals
--         let body' := Typ.sub subs body
--         (← List.pair_typ_Static.solve skolems assums quals').flatMapM (fun (skolems',assums') =>
--           (GuardedSubtyping.solve (ids' ∪ skolems') assums' t body')
--         )
--       else return []

--     | (.var id), t => do
--       if id ∉ skolems then
--         let lowers_id := List.pair_typ_bounds id .true assums
--         let trans := lowers_id.map (fun lower_id => (lower_id, t))
--         (← List.pair_typ_Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
--           return (skolems', (.var id, t) :: assums')
--         )
--       else if (assums.exi (fun
--         | (.var idl, .var idu) => idl == id && not (skolems.contains idu)
--         | _ => .false
--       )) then
--         let lowers_id := List.pair_typ_bounds id .true assums
--         let trans := lowers_id.map (fun lower_id => (lower_id, t))
--         (← List.pair_typ_Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
--           return (skolems', (.var id, t) :: assums')
--         )
--       else
--         let uppers_id := List.pair_typ_bounds id .false assums
--         (uppers_id.flatMapM (fun upper_id =>
--           let pass := (match upper_id with
--             | .var id' => skolems.contains id'
--             | _ => true
--           )
--           (if pass then
--             (GuardedSubtyping.solve skolems assums upper_id t)
--           else
--             return []
--           )
--         ))

--     | t, (.var id) => do
--       if not (skolems.contains id) then
--         let uppers_id := List.pair_typ_bounds id .false assums
--         let trans := uppers_id.map (fun upper_id => (t,upper_id))
--         (← List.pair_typ_Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
--           return (skolems', (t, .var id) :: assums')
--         )
--       else if (assums.exi (fun
--         | (.var idl, .var idu) => idu == id && not (skolems.contains idl)
--         | _ => .false
--       )) then
--         let uppers_id := List.pair_typ_bounds id .false assums
--         let trans := uppers_id.map (fun upper_id => (t,upper_id))
--         (← List.pair_typ_Static.solve skolems assums trans).mapM (fun (skolems',assums') =>
--           return (skolems', (t, .var id) :: assums')
--         )
--       else do
--         let lowers_id := List.pair_typ_bounds id .true assums
--         (lowers_id.flatMapM (fun lower_id =>
--           let pass := (match lower_id with
--             | .var id' => skolems.contains id'
--             | _ => true
--           )
--           (if pass then
--             (GuardedSubtyping.solve skolems assums t lower_id)
--           else
--             return []
--           )
--         ))


--     | l, (.path (.unio a b) r) =>
--       GuardedSubtyping.solve skolems assums l (.inter (.path a r) (.path b r))


--     | l, (.path r (.inter a b)) =>
--       GuardedSubtyping.solve skolems assums l (.inter (.path r a) (.path r b))

--     | t, (.entry l (.inter a b)) =>
--       GuardedSubtyping.solve skolems assums t (.inter (.entry l a) (.entry l b))


--     | (.lfp id lower), upper =>
--       if not (lower.free_vars.contains id) then
--         GuardedSubtyping.solve skolems assums lower upper
--       else if Polarity.decide id .true lower then do
--         let result ← GuardedSubtyping.solve skolems assums (Typ.sub [(id, upper)] lower) upper
--         if not result.isEmpty then
--           return result
--         else
--           -- Lean.logInfo ("<<< lfp debug upper >>>\n" ++ (repr upper))
--           match upper with
--           | (.entry l body_upper) => match Typ.factor id lower l with
--               | .some fac  =>
--                   -- Lean.logInfo ("<<< lfp debug fac >>>\n" ++ (repr (Typ.lfp id fac)))
--                   -- Lean.logInfo ("<<< lfp debug body_upper >>>\n" ++ (repr body_upper))
--                   GuardedSubtyping.solve skolems assums (.lfp id fac) body_upper
--               | .none => return []
--           | (.diff l r) => match Typ.height r with
--               | .some h =>
--                 -- Lean.logInfo ("<<< lfp debug upper diff h(r)>>>\n" ++ (repr h))
--                 if (
--                   Typ.is_pattern [] r &&
--                   Polarity.decide id .true lower &&
--                   Typ.struct_less_than (.var id) lower &&
--                   not (Subtyping.check (Typ.subfold id lower 1) r) &&
--                   not (Subtyping.check r (Typ.subfold id lower h))
--                 ) then
--                   GuardedSubtyping.solve skolems assums lower l
--                 else return []
--               | .none => return []
--           | _ => return []
--       else return []

--     | t, (.diff l r) =>
--       if (
--         Typ.is_pattern [] r &&
--         ¬ Subtyping.check t r &&
--         ¬ Subtyping.check r t
--       ) then
--         GuardedSubtyping.solve skolems assums t l
--       else
--         return []
-- --
--     | l, (.lfp id r) =>
--       if Subtyping.peelable l r then
--         GuardedSubtyping.solve skolems assums l (.sub [(id, .lfp id r)] r)
--       else
--         let r' := Typ.drop id r
--         GuardedSubtyping.solve skolems assums l r'

--     | (.diff l r), t =>
--       GuardedSubtyping.solve skolems assums l (.unio r t)


--     | t, (.unio l r) => do
--       return (
--         (← GuardedSubtyping.solve skolems assums t l) ++
--         (← GuardedSubtyping.solve skolems assums t r)
--       )

--     | l, (.exi ids quals r) => do
--       let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
--       let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
--       let r' := Typ.sub subs r
--       let quals' := List.pair_typ_sub subs quals
--       (← GuardedSubtyping.solve skolems assums l r').flatMapM (fun (θ',assums') =>
--         List.pair_typ_Static.solve θ' assums' quals'
--       )

--     | (.inter l r), t => do
--       return (
--         (← GuardedSubtyping.solve skolems assums l t) ++
--         (← GuardedSubtyping.solve skolems assums r t)
--       )

--     | (.all ids quals l), r  => do
--       let pairs : List (String × String) ← ids.mapM (fun id => do return (id, (← fresh_typ_id)))
--       let subs : List (String × Typ) := pairs.map (fun (id, id') => (id, .var id'))
--       let l' := Typ.sub subs l
--       let quals' := List.pair_typ_sub subs quals
--       (← GuardedSubtyping.solve skolems assums l' r).flatMapM (fun (θ',assums') =>
--         List.pair_typ_Static.solve θ' assums' quals'
--       )



--     -- TODO: consider removing path merging. union antecedent rule should be sufficient
--     -- | (.inter l r), t => match t with
--     --   | .path p q => match Typ.merge_paths (.inter l r) with
--     --     | .some t' => GuardedSubtyping.solve skolems assums t' (.path p q)
--     --     | .none => return (
--     --       (← GuardedSubtyping.solve skolems assums l t) ++
--     --       (← GuardedSubtyping.solve skolems assums r t)
--     --     )
--     --   | _ => return (
--     --     (← GuardedSubtyping.solve skolems assums l t) ++
--     --     (← GuardedSubtyping.solve skolems assums r t)
--     --   )


--     | _, _ => return []

-- end

-- mutual

--   partial def Zone.interpret (ignore : List String) (b : Bool) : Zone → Lean.MetaM Zone
--   | ⟨skolems, assums, t⟩ => do
--     let t' ← Typ.interpret ignore skolems assums b t
--     let assums' := Typ.transitive_connections [] assums b t'
--     return ⟨skolems, assums', t'⟩


--   partial def Typ.interpret
--     (ignore : List String) (skolems : List String) (assums : List (Typ × Typ))
--   : Bool → Typ → Lean.MetaM Typ
--   | b, .var id => do
--     if ignore.contains id || skolems.contains id then
--       return .var id
--     else
--       let bds := (List.pair_typ_bounds id b assums).eraseDups
--       if bds == [] then
--         return .var id
--       else
--         let t := Typ.combine (not b) bds
--         if (t == .bot || t == .top) then
--           return .var id
--         else
--           Typ.interpret ([id] ∪  ignore) skolems assums b t

--   | b, .iso label body => do
--     let body' ← Typ.interpret ignore skolems assums b body
--     return .iso label body'

--   | b, .entry label body => do
--     let body' ← Typ.interpret ignore skolems assums b body
--     return .entry label body'

--   | b, .inter l r => do
--     let l' ← Typ.interpret ignore skolems assums b l
--     let r' ← Typ.interpret ignore skolems assums b r
--     return Typ.simp (Typ.inter l' r')

--   | b, .unio l r => do
--     let l' ← Typ.interpret ignore skolems assums b l
--     let r' ← Typ.interpret ignore skolems assums b r
--     return Typ.simp (Typ.unio l' r')

--   | b, .path antec consq => do
--     let antec' ← Typ.interpret ignore skolems assums (not b) antec
--     let ignore' := (Typ.free_vars antec' ∩ Typ.free_vars consq) ∪ ignore
--     let consq' ← Typ.interpret ignore' skolems assums b consq
--     return Typ.simp (Typ.path antec' consq')

--   | .true, .exi ids_exi quals_exi (.all _ quals body) => do
--     let constraints := quals_exi ++ quals

--     let zones ← (
--       ← List.pair_typ_Static.solve (ids_exi ∪ skolems) assums constraints
--     ).mapM (fun (skolems', assums') => do
--       let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
--       return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
--     )
--     return ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .true zones

--   | .true, (.all _ quals body) => do
--     let constraints := quals

--     let zones ← (
--       ← List.pair_typ_Static.solve skolems assums constraints
--     ).mapM (fun (skolems', assums') => do
--       let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .true ⟨skolems', assums', body⟩
--       return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
--     )
--     return ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .true zones

--   | .false, .all ids_all quals_all (.exi _ quals body) => do
--     let constraints := quals_all ++ quals

--     let zones ← (
--       ← List.pair_typ_Static.solve (ids_all ∪ skolems) assums constraints
--     ).mapM (fun (skolems', assums') => do
--       let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
--       return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
--     )
--     return ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .false zones


--   | .false, (.exi _ quals body) => do
--     let constraints := quals
--     let zones ← (
--       ← List.pair_typ_Static.solve skolems assums constraints
--     ).mapM (fun (skolems', assums') => do
--       let ⟨skolems'', assums'', body'⟩ ← Zone.interpret ignore .false ⟨skolems', assums', body⟩
--       return ⟨List.removeAll skolems'' skolems, List.removeAll assums'' assums, body'⟩
--     )
--     return ListZone.pack (ignore ∪ skolems ∪ List.pair_typ_free_vars assums) .false zones

--   | _, t => do
--     return t
-- end


-- mutual
--   partial def Function.Typing.Static.compute
--     (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (subtras : List Typ) :
--     List (Pat × Expr) → Lean.MetaM (List (List Zone))
--   | [] => return []

--   | (p,e)::f => do
--     let (tp, Δ', Γ') ←  PatLifting.Static.compute Δ Γ p
--     let nested_zones ← Function.Typing.Static.compute Θ Δ Γ (tp::subtras) f
--     let tl := List.typ_diff tp subtras
--     let zones ← (← GuardedTyping.compute Θ Δ' Γ' e).mapM (fun ⟨Θ', Δ'', tr ⟩ => do
--       let ⟨skolems'', assums''', t⟩ ← Zone.interpret [] .true ⟨Θ', Δ'', (.path tl tr)⟩
--       return ⟨List.diff skolems'' Θ, List.diff assums''' Δ, t⟩
--     )
--     return zones :: nested_zones

--   partial def ListZone.Typing.Static.compute
--     (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ)) (e : Expr)
--   : Lean.MetaM (List Zone)
--   := do
--     (← GuardedTyping.compute Θ Δ Γ e).mapM (fun  ⟨Θ', Δ', t⟩ =>
--       return ⟨List.diff Θ' Θ, List.diff Δ' Δ, t⟩
--     )

--   partial def LoopListZone.GuardedSubtyping.compute (pids : List String) (id : String)
--   : List Zone → Lean.MetaM Typ
--   | [⟨Θ, Δ, .path (.var idl) r⟩] =>
--     if id != idl then do
--       match (
--         (List.pair_typ_invert id Δ).bind (fun Δ' =>
--           let t' := Zone.pack (id :: idl :: pids) .false ⟨Θ, Δ', .pair (.var idl) r⟩
--           (Typ.factor id t' "left").bind (fun l =>
--           (Typ.factor id t' "right").map (fun r' => do
--             let l' ← Typ.UpperFounded.compute id l
--             let r'' := Typ.sub [(idl, .lfp id l')] r'
--             if Polarity.decide idl .true r' then
--               return (.path (.var idl) (.lfp id r''))
--             else
--               failure
--           ))
--         )
--       ) with
--         | .some result => result
--         | .none => failure
--     else failure

--   | zones => do
--     let op_result ← (ListZone.invert id zones).bindM (fun zones' => do
--       let t' := ListZone.pack (id :: pids) .false zones'
--       (Typ.factor id t' "left").bindM (fun l => do
--       (Typ.factor id t' "right").bindM (fun r => do
--         let l' ← Typ.interpret [id] [] [] .false l
--         let r' ← Typ.interpret [id] [] [] .false r
--         return Option.some (Typ.path (.lfp id l') (.lfp id r'))
--       ))
--     )
--     match op_result with
--     | .some result => return result
--     | .none => failure

--   partial def Record.Typing.Static.compute
--     (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : List (String × Expr) → Lean.MetaM (List Zone)
--   | [] => return [⟨Θ, Δ, .top⟩]
--   | (l,e) :: [] => do
--     (← (GuardedTyping.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
--       return [⟨Θ', Δ', (.entry l t)⟩]
--     )
--   | (l,e) :: r => do
--     (← (GuardedTyping.compute Θ Δ Γ e)).flatMapM (fun ⟨Θ', Δ', t⟩ => do
--     (← (Record.Typing.Static.compute Θ' Δ' Γ r)).flatMapM (fun ⟨Θ'', Δ'',t'⟩ =>
--       return [⟨Θ'', Δ'', (.inter (.entry l t) (t'))⟩]
--     ))

--   partial def GuardedTyping.compute
--     (Θ : List String) (Δ : List (Typ × Typ)) (Γ : List (String × Typ))
--   : Expr → Lean.MetaM (List Zone)
--   | .var x =>  match find x Γ with
--     | .some t => return [⟨Θ, Δ, t⟩]
--     | .none => failure

--   | .iso label body => do
--     (← GuardedTyping.compute Θ Δ Γ body).mapM (fun ⟨skolems', assums', body'⟩ =>
--       return ⟨skolems', assums', Typ.iso label body'⟩
--     )

--   | .record r =>  Record.Typing.Static.compute Θ Δ Γ r

--   | .function f => do
--     -- Lean.logInfo ("<<< assums >>>\n" ++ (repr Δ))
--     let nested_zones ← (Function.Typing.Static.compute Θ Δ Γ [] f)
--     -- Lean.logInfo ("<<< Nested Zones >>>\n" ++ (repr nested_zones))
--     let zones := (nested_zones.flatten)
--     let t := ListZone.pack (List.pair_typ_free_vars Δ) .true zones
--     return [⟨Θ, Δ, t⟩]

--   | .app ef ea => do
--     let α ← fresh_typ_id
--     (← GuardedTyping.compute Θ Δ Γ ef).flatMapM (fun ⟨Θ', Δ', tf⟩ => do
--     (← GuardedTyping.compute Θ' Δ' Γ ea).flatMapM (fun ⟨Θ'', Δ'', ta⟩ => do
--     (← GuardedSubtyping.solve Θ'' Δ'' tf (.path ta (.var α))).flatMapM (fun ⟨Θ''', Δ'''⟩ => do
--       -- NOTE: do not remove anything from global assumptions
--       let t ← Typ.interpret [] Θ''' Δ''' .true (.var α)
--       return [ ⟨Θ''', Δ''', t⟩ ]
--     )))

--   | .loopi e => do
--     let id ← fresh_typ_id
--     (← GuardedTyping.compute Θ Δ Γ e).flatMapM (fun ⟨Θ', Δ', t⟩ => do
--       let id_antec ← fresh_typ_id
--       let id_consq ← fresh_typ_id

--       let body := (Typ.path (.var id_antec) (.var id_consq))

--       let zones_local ← (
--         ← GuardedSubtyping.solve Θ' Δ' t (Typ.path (.var id) body)
--       ).flatMapM (fun (skolems'', assums'') => do
--         let ⟨skolems''', assums'', body'⟩ ← Zone.interpret [id] .true ⟨skolems'', assums'', body⟩
--         let op_assums''' := List.pair_typ_loop_normal_form id assums''
--         match op_assums''' with
--         | some assums''' =>
--           return [Zone.mk (List.removeAll skolems''' Θ) (List.removeAll assums''' Δ') body']
--         | none => return []
--       )
--       -- Lean.logInfo ("<<< LOOP ID >>>\n" ++ (repr id))
--       -- Lean.logInfo ("<<< ZONES LOCAL >>>\n" ++ (repr zones_local))
--       let t' ← LoopListZone.GuardedSubtyping.compute (List.pair_typ_free_vars Δ') id zones_local

--       return [⟨Θ', Δ', t'⟩]
--     )


--   | .anno e ta =>
--     if Typ.free_vars ta == [] then do
--       let zones ← ListZone.Typing.Static.compute Θ Δ Γ e
--       let te := ListZone.pack (List.pair_typ_free_vars Δ) .false zones
--       (← GuardedSubtyping.solve Θ Δ te ta).flatMapM (fun (Θ', Δ') =>
--         return [⟨Θ', Δ', ta⟩]
--       )
--     else
--       return []

-- end


-- syntax "ListSubtyping_Static_prove" : tactic
-- syntax "Subtyping_Static_prove" : tactic

-- macro_rules
-- | `(tactic| ListSubtyping_Static_prove) => `(tactic|
--   (first
--     | apply List.pair_typ_Static.nil
--     | apply List.pair_typ_Static.cons
--       · Subtyping_Static_prove
--       · ListSubtyping_Static_prove
--   ) <;> fail
-- )
-- | `(tactic| Subtyping_Static_prove) => `(tactic|
--   (first
--     | apply GuardedSubtyping.refl
--     | apply GuardedSubtyping.iso_pres
--       · Subtyping_Static_prove
--     | apply GuardedSubtyping.entry_pres
--       · Subtyping_Static_prove
--     | apply GuardedSubtyping.path_pres
--       · Subtyping_Static_prove
--       · Subtyping_Static_prove
--     | apply GuardedSubtyping.bot_elim
--     | apply GuardedSubtyping.top_intro
--     | apply GuardedSubtyping.unio_elim
--       · Subtyping_Static_prove
--       · Subtyping_Static_prove
--     | apply GuardedSubtyping.exi_elim
--       { rfl }
--       { rfl }
--       { simp [List.pair_typ_free_vars, Typ.free_vars, Union.union, List.union] }
--       { ListSubtyping_Static_prove }
--       { Subtyping_Static_prove }
--     | apply GuardedSubtyping.inter_intro
--       · Subtyping_Static_prove
--       · Subtyping_Static_prove
--     | apply GuardedSubtyping.all_intro
--       { rfl }
--       { rfl }
--       { simp [List.pair_typ_free_vars, Typ.free_vars, Union.union, List.union] }
--       { ListSubtyping_Static_prove }
--       { Subtyping_Static_prove }
--     | apply GuardedSubtyping.placeholder_elim
--       · simp
--       · apply lower_bound_map
--         · simp only [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--       · ListSubtyping_Static_prove

--     | apply GuardedSubtyping.placeholder_intro
--       · simp
--       · apply upper_bound_map
--         · simp only [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--       · ListSubtyping_Static_prove

--     | apply GuardedSubtyping.skolem_placeholder_intro
--       -- · simp
--       -- · simp
--       · apply List.Mem.head
--       · apply skolem_upper_bound
--         · reduce; simp
--       · apply upper_bound_map
--         · simp [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--       · ListSubtyping_Static_prove

--     | apply GuardedSubtyping.skolem_intro
--       · apply List.mem_of_elem_eq_true; rfl
--       · apply lower_bound_mem
--         · simp [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--         · simp [Typ.refl_BEq_true]; rfl
--       · simp
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.skolem_placeholder_elim
--       · apply List.Mem.head
--       · apply skolem_lower_bound
--         · reduce; simp
--       · apply lower_bound_map
--         · simp [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--       · ListSubtyping_Static_prove







--     | apply GuardedSubtyping.skolem_elim
--       · apply List.mem_of_elem_eq_true; rfl
--       · apply upper_bound_mem
--         · simp [List.pair_typ_bounds, Subtyping.target_bound]; rfl
--         · simp [Typ.refl_BEq_true]; rfl
--       · simp
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.unio_antec
--       { Subtyping_Static_prove }
--       { Subtyping_Static_prove }

--     | apply GuardedSubtyping.inter_conseq
--       { Subtyping_Static_prove }
--       { Subtyping_Static_prove }

--     | apply GuardedSubtyping.inter_entry
--       { Subtyping_Static_prove }
--       { Subtyping_Static_prove }

--     | apply GuardedSubtyping.lfp_factor_elim
--       · rfl
--       · reduce; Subtyping_Static_prove

--     | apply GuardedSubtyping.lfp_skip_elim
--       · exact Iff.mp List.count_eq_zero rfl
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.lfp_induct_elim
--       · Typ_Monotonic_Static_prove
--       · reduce; Subtyping_Static_prove

--     | apply GuardedSubtyping.lfp_elim_diff_intro
--       { rfl }
--       { simp [Typ.struct_less_than]; reduce
--         (first
--         | apply Or.inl ; rfl
--         | apply Or.inr ; rfl
--         ) <;> fail }
--       { rfl }
--       { Typ_Monotonic_Static_prove }
--       { Subtyping_Static_prove }
--       { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }
--       { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }

--     | apply GuardedSubtyping.diff_intro
--       { rfl }
--       { simp [
--           Subtyping.check, Typ.toBruijn, List.pair_typ_toBruijn,
--           ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
--         ] }
--       { simp [
--           Subtyping.check, Typ.toBruijn, List.pair_typ_toBruijn,
--           ListPairTyp.ordered_bound_vars, Typ.ordered_bound_vars,
--         ] }
--       { Subtyping_Static_prove }


--     | apply GuardedSubtyping.lfp_peel_intro
--       · simp [Subtyping.peelable, Typ.break, Subtyping.check]
--       · simp [Typ.sub, find] ; Subtyping_Static_prove

--     | apply GuardedSubtyping.lfp_drop_intro
--       { Subtyping_Static_prove }

--     | apply GuardedSubtyping.diff_elim
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.unio_left_intro
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.unio_right_intro
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.exi_intro
--       · Subtyping_Static_prove
--       · ListSubtyping_Static_prove

--     | apply GuardedSubtyping.inter_left_elim
--       · Subtyping_Static_prove

--     | apply GuardedSubtyping.inter_right_elim
--       · Subtyping_Static_prove

--     -- | apply GuardedSubtyping.inter_merge_elim
--     --   · rfl
--     --   · Subtyping_Static_prove

--     | apply GuardedSubtyping.all_elim
--       · Subtyping_Static_prove
--       · ListSubtyping_Static_prove
--   ) <;> fail
-- )



-- #check Option.mapM



-- syntax "eq_rhs_assign" : tactic

-- elab_rules : tactic
-- | `(tactic| eq_rhs_assign) => Lean.Elab.Tactic.withMainContext do
--   let goal ← Lean.Elab.Tactic.getMainGoal
--   let goalDecl ← goal.getDecl
--   let goalType := goalDecl.type

--   Lean.logInfo m!"goalType: {goalType}"

--   let mvar ← (match goalType with
--   | .app _ right => return right
--   | _ => failure
--   )

--   let left ← (match (← Lean.Meta.whnf goalType) with
--   | .app (.app _ left) _ => return left
--   | _ => failure
--   )
--   -- let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

--   Lean.logInfo m!"left: {left}"
--   Lean.logInfo m!"mvar: {mvar}"

--   Lean.MVarId.assign mvar.mvarId! left
--   let goalType_instantiated ← (Lean.instantiateMVars goalType)

-- example : ∃ t, "thing" = t
-- := by
--   use ?t
--   eq_rhs_assign
--   { rfl  }
--   { exact "" }




-- def Function.Typing.Static.extract_mvar : Lean.Expr → Lean.MetaM Lean.Expr
-- | .app x y => return y
-- | _ => failure

-- def Function.Typing.Static.extract_info : Lean.Expr → Lean.MetaM Lean.Expr
-- | .app x y => return x
-- | _ => failure

-- def Function.Typing.Static.extract_applicands :
--   Lean.Expr → Lean.MetaM (Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr × Lean.Expr)
-- | Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app _ a ) b) c) d) e =>
--     return (a,b,c,d,e)
-- | _ => failure

-- def Function.Typing.Static.to_computation :
--   Lean.Expr → Lean.MetaM Lean.Expr
-- | Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
--     (Lean.Expr.const `Function.Typing.Static [])
--   a ) b) c) d) e =>
--     return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
--       (Lean.Expr.const `Function.Typing.Static.compute [])
--     a ) b) c) d) e
-- | _ => failure



-- syntax "Function_Typing_Static_assign" : tactic

-- elab_rules : tactic
-- | `(tactic| Function_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
--   let goal ← Lean.Elab.Tactic.getMainGoal
--   let goalDecl ← goal.getDecl
--   let goalType := goalDecl.type

--   let mvar ← Function.Typing.Static.extract_mvar goalType
--   let goalInfo ← Function.Typing.Static.extract_info (← Lean.Meta.whnf goalType)

--   -- Lean.logInfo m!"mvar: {mvar}"
--   -- Lean.logInfo m!"GoalInfo: {goalInfo}"
--   let computation ← Function.Typing.Static.to_computation goalInfo

--   -- Lean.logInfo m!"Computation: {computation}"

--   let ListListZoneTypeExpr := Lean.mkApp
--     (Lean.mkConst ``Lean.MetaM)
--     (Lean.mkApp
--       (Lean.mkConst ``List [Lean.levelZero])
--       (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))
--     )
--   let metaM_result ← unsafe Lean.Meta.evalExpr
--     (Lean.MetaM (List (List Zone)))
--     ListListZoneTypeExpr computation
--   let result ← metaM_result
--   -- Lean.logInfo ("<<<result>>> " ++ (repr result))
--   let lean_expr_result := Lean.toExpr result
--   Lean.MVarId.assign mvar.mvarId! lean_expr_result
--   let goalType_instantiated ← (Lean.instantiateMVars goalType)
--   -- Lean.Elab.Tactic.replaceMainGoal [goal]

--   ---------------------------------------

-- #eval Function.Typing.Static.compute [] [] [] [] [(Pat.var "x", Expr.var "x")]

-- example  : ∃ nested_zones , Function.Typing.Static [] [] [] [] [(Pat.var "x", Expr.var "x")] nested_zones
-- := by
--   use ?nested_zones
--   { Function_Typing_Static_assign <;> sorry}
--   { sorry }


-- syntax "ListZone_Typing_Static_assign" : tactic

-- elab_rules : tactic
-- | `(tactic| ListZone_Typing_Static_assign) => Lean.Elab.Tactic.withMainContext do
--   let goal ← Lean.Elab.Tactic.getMainGoal
--   let goalDecl ← goal.getDecl
--   let goalType := goalDecl.type

--   let whnf ← Lean.Meta.whnf goalType
--   let (antec, conseq) ← (match whnf with
--   | Lean.Expr.forallE _ _ (
--       Lean.Expr.forallE _ _ (
--         Lean.Expr.forallE _ _ (
--           Lean.Expr.forallE _ antec conseq _
--         ) _
--       ) _
--     ) _ => return (antec, conseq)
--   | _ => failure
--   )


--   Lean.logInfo m!"antec: {antec}"
--   Lean.logInfo m!"conseq: {conseq}"

--   let mvar  ← (match antec with
--   | Lean.Expr.app (Lean.Expr.app _ a) _ => return a
--   | _ => failure
--   )

--   -- Lean.logInfo m!"mvar: {mvar}"

--   let pred  ← (match conseq with
--   | Lean.Expr.app (Lean.Expr.app (Lean.Expr.app a _) _ ) _ => return a
--   | _ => failure
--   )

--   let computation ← (match pred with
--   | (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
--     (Lean.Expr.const `GuardedTyping []) a) b) c) d
--   ) => return Lean.Expr.app (Lean.Expr.app (Lean.Expr.app (Lean.Expr.app
--     (Lean.Expr.const `GuardedTyping.compute []) a) b) c) d
--   | _ => failure
--   )

--   -- Lean.logInfo m!"computation: {computation}"

--   let ListZoneTypeExpr := Lean.mkApp
--     (Lean.mkConst ``Lean.MetaM)
--     (Lean.mkApp (Lean.mkConst ``List [Lean.levelZero]) (Lean.mkConst ``Zone))

--   -- Lean.logInfo m!"ListZoneTypeExpr: {ListZoneTypeExpr}"

--   let metaM_result ← unsafe Lean.Meta.evalExpr
--     (Lean.MetaM (List Zone)) ListZoneTypeExpr computation
--   let result ← metaM_result
--   -- Lean.logInfo ("<<<result>>> " ++ (repr result))
--   let lean_expr_result := Lean.toExpr result
--   Lean.MVarId.assign mvar.mvarId! lean_expr_result
--   let goalType_instantiated ← (Lean.instantiateMVars goalType)
--   -- Lean.Elab.Tactic.replaceMainGoal [goal]

-- example t : ∃ zones : List Zone ,
-- ∀ {skolems' : List String} {assums'' : List (Typ × Typ)} {tr : Typ},
--   { skolems := skolems', assums := assums'', typ := Typ.path (List.typ_diff t []) tr } ∈ zones →
--     GuardedTyping [] [] [] (Expr.record []) tr (skolems' ++ []) (assums'' ++ [])
-- := by
--   sorry
--   -- use ?_
--   -- ListZone_Typing_Static_assign
--   -- sorry
--   -- sorry


-- syntax "Function_Typing_Static_prove" : tactic
-- syntax "Record_Typing_Static_prove" : tactic
-- syntax "Subtyping_GuardedListZone_Static_prove" : tactic
-- syntax "ListZone_Typing_Static_prove" : tactic
-- syntax "LoopListZone_Subtyping_Static_prove" : tactic
-- syntax "Expr_Typing_Static_prove" : tactic


-- macro_rules
-- | `(tactic| Function_Typing_Static_prove) => `(tactic|
--   (try Function_Typing_Static_assign) ;
--   (first
--   | apply Function.Typing.Static.nil
--   | apply Function.Typing.Static.cons <;> fail
--     -- TODO: to compute and assign zones
--     -- NOTE: needs tactics to extract inputs run computation and assign results
--     -- NOTE: such tactics are extremely tedious
--     -- { apply ListZone.tidy_undo_tidy }
--     -- { simp [ListZone.undo_tidy]
--     --   intros _ _ _ _ assums_eq t_eq
--     --   simp [*, List.typ_diff]
--     --   apply And.intro
--     --   { exact? }
--     --   {
--     --     repeat (apply Typ.diff_drop (not_eq_of_beq_eq_false rfl))
--     --     rfl
--     --   }
--     -- }
--     -- { Function_Typing_Static_prove }
--     -- { PatLifting_Static_prove }
--     -- { simp; intros _ _ _ p ; simp [ListZone.undo_tidy] at p ;
--     --   simp [*]; Typing_Static_prove }
--   ) <;> fail
-- )

-- | `(tactic| Record_Typing_Static_prove) => `(tactic|
--   (first
--   | apply Record.Typing.Static.nil
--   | apply Record.Typing.Static.single
--     · Expr_Typing_Static_prove
--   | apply Record.Typing.Static.cons
--     · Expr_Typing_Static_prove
--     · Record_Typing_Static_prove
--   ) <;> fail )

-- | `(tactic| ListZone_Typing_Static_prove) => `(tactic|
--   (apply Subtyping.ListZone.Static.intro
--     · intro
--       · Expr_Typing_Static_prove
--   ) )

-- | `(tactic| LoopListZone_Subtyping_Static_prove) => `(tactic|
--   (first
--   | apply LoopListZone.GuardedSubtyping.batch
--     · rfl
--     · rfl
--     · rfl
--     · rfl
--   | apply LoopListZone.GuardedSubtyping.stream
--     · simp
--     · rfl
--     · rfl
--     · rfl
--     · rfl
--     · Typ_Monotonic_Static_prove
--     · Typ_UpperFounded_prove
--     · rfl
--   ) <;> fail )

-- | `(tactic| Expr_Typing_Static_prove) => `(tactic|
--   (first
--   | apply GuardedTyping.var
--     · rfl
--   | apply GuardedTyping.record
--     · Record_Typing_Static_prove

--   | apply GuardedTyping.function
--     { Function_Typing_Static_prove }
--     { reduce; simp_all ; try (eq_rhs_assign ; rfl) }

--   | apply GuardedTyping.app
--     · Expr_Typing_Static_prove
--     · Expr_Typing_Static_prove
--     · Subtyping_Static_prove

--   | apply GuardedTyping.loop
--     { Expr_Typing_Static_prove }
--     { apply Subtyping.ListZone.Static.intro
--       {intro; Subtyping_Static_prove}
--       {rfl} }
--     { LoopListZone_Subtyping_Static_prove }

--   | apply GuardedTyping.anno
--     · simp
--     · ListZone_Typing_Static_prove
--     · rfl
--     · Subtyping_Static_prove
--   ) <;> fail )


-- set_option pp.fieldNotation false







-- set_option eval.pp false
-- set_option pp.fieldNotation false

-- #check [expr| <elem/>]

-- #check [eid| x]

-- #check [expr| x]

-- #check [expr| uno.dos.tres]

-- #check [expr| [x => <elem/>]]

-- #check [expr| [x => x.uno]]

-- #check [expr| (uno := <uno/>).uno]

-- #check [expr| def x = <elem/> in x]

-- #check [expr| [<uno> x => x]]


-- #eval [typ| <uno/> & <dos/>]

-- #eval [constraints| (<succ> G010 <: R)  (<succ> <succ> G010 <: R) ]


-- example : Polarity "a" .true (.entry "uno" (.entry "dos" (.var "a"))) := by
--   Typ_Monotonic_Static_prove

-- example : Polarity "a" .true (.path .bot (.inter .bot (.var "a"))) := by
--   Typ_Monotonic_Static_prove


-- example : Polarity "a" .true (.exi ["G"] [] (.var "G")) := by
--   Typ_Monotonic_Static_prove

-- example : Polarity "a" .true (.path .bot (.inter .top (.var "a"))) := by
--   Typ_Monotonic_Static_prove


-- example : Polarity "a" .false (.path (.inter .bot (.var "a")) .bot) := by
--   Typ_Monotonic_Static_prove

-- example : Polarity "a" .false (.path (.inter .top (.var "a")) .top) := by
--   Typ_Monotonic_Static_prove


-- example : (if ("hello" == "hello") = true then 1 else 2) = 1 := by
--   simp

-- example : ∃ ts , List.pair_typ_bounds "R" .true .nil = ts := by
--   exists .nil


-- example : List.pair_typ_bounds "R" .true
--   [constraints| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
--   =
--   [typs| (<succ> G010) (<succ> <succ> G010)]
-- := by rfl

-- example : ∃ ts , List.pair_typ_bounds "R" .true
--   [constraints| (<succ> G010 <: R)  (<succ> <succ> G010 <: R)  ]
--   = ts
-- := by exists [typs| (<succ> G010) (<succ> <succ> G010) ]


-- example : UpperFounded "R"
--   [typ| EXI[] [(<succ> G010 <: R) (<succ> <succ> G010 <: R)] G010 ]
--   [typ| G010 | <succ> R | <succ> <succ> R ]
-- := by sorry
--   -- Typ_UpperFounded_prove


-- example : ¬ Subtyping.check [typ| <dos/> ] [typ| <uno/>] := by
--   simp [Subtyping.check]

-- example Δ Γ
-- : PatLifting.Static Δ Γ [pattern| x]
--   [typ| X] -- (Typ.var "X")
--   ((Typ.var "X", Typ.top) :: Δ)
--   (("x", Typ.var "X") :: (remove "x" Γ))
-- := by
--   PatLifting_Static_prove

-- example Δ Γ
-- : PatLifting.Static Δ Γ [pattern| @] .top Δ Γ
-- := by
--   PatLifting_Static_prove

-- example Δ Γ
-- : PatLifting.Static Δ Γ (.record [])
--   Typ.top
--   Δ
--   Γ
-- := by
--   PatLifting_Static_prove


-- example Δ Γ
-- : PatLifting.Static Δ Γ
--   [pattern| <dos/>]
--   [typ| <dos/>]
--   Δ Γ
-- := by
--   sorry
--   -- PatLifting_Static_prove

-- example Δ Γ
-- : PatLifting.Static Δ Γ
--   [pattern| uno := <elem/> ; dos := <elem/>]
--   [typ| uno : <elem/> & dos : <elem/>]
--   Δ Γ
-- := by
--   sorry
--   -- PatLifting_Static_prove

-- #eval PatLifting.Static.compute [] [] [pattern| uno := x ; dos := y ]
-- example :  ∃ t Δ' Γ', PatLifting.Static [] []
--   [pattern| uno := x ; dos := y] t Δ' Γ' := by
--   exists [typ| uno : T669 & dos : T670 ]
--   exists [constraints| (T670 <: TOP) (T669 <: TOP) ]
--   exists [typings| (y : T670) (x : T669) ]
--   PatLifting_Static_prove


-- ---------------------------------------
-- ----- reflexivity
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <uno/>]
--   [typ| <uno/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <uno/>]
--   [typ| <uno/>]
--   [ids| ] [constraints|  ]
-- := by Subtyping_Static_prove


-- ---------------------------------------
-- ----- iso preservation (over union)
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| <label> <uno/> ]
--   [typ| <label> (<uno/> | <dos/>) ]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| <label> <uno/> ]
--   [typ| <label> (<uno/> | <dos/>) ]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- entry preservation (over union)
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| label : <uno/> ]
--   [typ| label : (<uno/> | <dos/>) ]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| label : <uno/> ]
--   [typ| label : (<uno/> | <dos/>) ]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- implication preservation (over union)
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| (<uno/> | <dos/>) -> <tres/> ]
--   [typ| <uno/>  -> (<dos/> | <tres/>)]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| (<uno/> | <dos/>) -> <tres/> ]
--   [typ| <uno/>  -> (<dos/> | <tres/>)]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- implication preservation (over intersection)
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| <uno/> -> (<dos/> & <tres/>)]
--   [typ| (<uno/> & <dos/>) -> <tres/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| <uno/> -> (<dos/> & <tres/>)]
--   [typ| (<uno/> & <dos/>) -> <tres/>]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- union elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
--   [typ| <uno/> ]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| (<uno/> & <dos/>) | (<uno/> & <tres/>)]
--   [typ| <uno/> ]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- existential elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| EXI[T] [(T <: <uno/>)] T]
--   [typ| <uno/> | <dos/>]

-- #eval Typ.combine_bounds "T" .true []

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| EXI[T] [(T <: <uno/>)] T]
--   [typ| <uno/> | <dos/>]
--   [ids| T] [constraints| (T <: <uno/>)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- existential skolem placeholder elim
-- ---------------------------------------

-- example : GuardedSubtyping [] []
--   [typ| EXI[N] [ (N <: R) ] N ]
--   [typ| <whatev/> ]
--   [ids| N] [constraints| (N <: <whatev/>) (N <: R)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- intersection intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| <uno/> ]
--   [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| <uno/> ]
--   [typ| (<uno/> | <dos/>) & (<uno/> | <tres/>)]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- universal intro
-- ---------------------------------------

-- #eval Subtyping.restricted [] [] [typ| <uno/>] [typ| T]

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints|  ]
--   [typ| <uno/> & <dos/>]
--   [typ| ALL[T] [(<uno/> <: T)] T]

-- example : GuardedSubtyping
--   [ids| ] [constraints|  ]
--   [typ| <uno/> & <dos/>]
--   [typ| ALL[T] [(<uno/> <: T)] T]
--   [ids| T] [constraints| (<uno/> <: T)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- placeholder elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| (<uno/> & <dos/> <: T) (T <: <uno/>)]
--   [typ| T]
--   [typ| <dos/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints| (<uno/> & <dos/> <: T) (T <: <uno/>)]
--   [typ| T]
--   [typ| <dos/>]
--   [ids| ] [constraints| (T <: <dos/>) (<uno/> & <dos/> <: T) (T <: <uno/>)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- placeholder intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| (<uno/> <: T) (T <: <uno/> | <dos/>)]
--   [typ| <dos/>]
--   [typ| T]

-- example : GuardedSubtyping
--   [ids| ] [constraints| (<uno/> <: T) (T <: <uno/> | <dos/>)]
--   [typ| <dos/>]
--   [typ| T]
--   [ids| ] [constraints| (<dos/> <: T) (<uno/> <: T) (T <: <uno/> | <dos/>)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- skolem placeholder intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| (X <: T)]
--   [typ| <uno/>]
--   [typ| T]


-- example : GuardedSubtyping
--   [ids| T] [constraints| (X <: T)]
--   [typ| <uno/>]
--   [typ| T]
--   [ids| T] [constraints| (<uno/> <: T) (X <: T)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- skolem placeholder elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| (T <: X)]
--   [typ| T]
--   [typ| <uno/>]

-- example : GuardedSubtyping
--   [ids| T] [constraints| (T <: X)]
--   [typ| T]
--   [typ| <uno/>]
--   [ids| T] [constraints| (T <: <uno/>) (T <: X)]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- skolem elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| (T <: <uno/>) ]
--   [typ| T]
--   [typ| <uno/> | <dos/>]

-- example : GuardedSubtyping
--   [ids| T] [constraints| (T <: <uno/>) ]
--   [typ| T]
--   [typ| <uno/> | <dos/>]
--   [ids| T ] [constraints| (T <: <uno/>) ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- skolem intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| ( <uno/> <: T) ]
--   [typ| <uno/> & <dos/>]
--   [typ| T]

-- example : GuardedSubtyping
--   [ids| T] [constraints| (<uno/> <: T) ]
--   [typ| <uno/> & <dos/>]
--   [typ| T]
--   [ids| T] [constraints| (<uno/> <: T) ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- union antecedent
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| ]
--   [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
--   [typ| <uno/> | <dos/> -> <tres/>]

-- example : GuardedSubtyping
--   [ids| T] [constraints| ]
--   [typ| (<uno/> -> <tres/>) & (<dos/> -> <tres/>)]
--   [typ| <uno/> | <dos/> -> <tres/>]
--   [ids| T] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- inter consequent
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| ]
--   [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
--   [typ| <uno/> -> <dos/> & <tres/>]

-- example : GuardedSubtyping
--   [ids| T] [constraints| ]
--   [typ| (<uno/> -> <dos/>) & (<uno/> -> <tres/>)]
--   [typ| <uno/> -> <dos/> & <tres/>]
--   [ids| T] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- entry inter content
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| T] [constraints| ]
--   [typ| label : <uno/> & label : <dos/>]
--   [typ| label : (<uno/> & <dos/>)]

-- example : GuardedSubtyping
--   [ids| T] [constraints| ]
--   [typ| label : <uno/> & label : <dos/>]
--   [typ| label : (<uno/> & <dos/>)]
--   [ids| T] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- lfp induction
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R] <zero/> | (EXI[N] [ (N <: R) ] <succ> N ) ]
--   [typ| LFP[R] (<zero/> | <succ> R) ]

-- -- example : GuardedSubtyping
-- --   [] []
-- --   [typ| LFP[R] <zero/> | EXI[N] [ (N <: R) ] <succ> N ]
-- --   [typ| LFP[R] (<zero/> | <succ> R) ]
-- --   [ids| N ] [constraints| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
-- -- -- [constraints| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
-- -- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- lfp factor elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R]  (
--       (<zero/> * <nil/>) |
--       (EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L))
--   )]
--   [typ| left : LFP[R] (<zero/> | <succ> R) ]


-- example : GuardedSubtyping
--   [] []
--   [typ| LFP[R]  (
--       (<zero/> * <nil/>) |
--       (EXI [N L][(N*L <: R)] (<succ> N) * (<cons> L))
--   )]
--   [typ| left : LFP[R] (<zero/> | <succ> R) ]
--   [ids| N ] [constraints| (N <: LFP[R] <zero/> | <succ> R) (N <: R) ]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- ---------------------------------------
-- ----- lfp skip elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R] <uno/> | <dos/>]
--   [typ| <uno/> | <dos/> | <tres/>]

-- example : GuardedSubtyping
--   [] []
--   [typ| LFP[R] <uno/> | <dos/>]
--   [typ| <uno/> | <dos/> | <tres/>]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove
-- -- := by
-- --   apply GuardedSubtyping.lfp_skip_elim
-- --   · exact Iff.mp List.count_eq_zero rfl
-- --   · Subtyping_Static_prove

-- ---------------------------------------
-- ----- lfp induct elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
--   [typ| LFP[R] ((<zero/>) | (<succ> R))]

-- example : GuardedSubtyping
--   [] []
--   [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
--   [typ| LFP[R] ((<zero/>) | (<succ> R))]
--   [ids| ] [constraints| ]
-- := by
--   sorry
--   -- Subtyping_Static_prove
-- -- := by
-- --   apply GuardedSubtyping.lfp_induct_elim
-- --   · Typ_Monotonic_Static_prove
-- --   · reduce; Subtyping_Static_prove

-- ---------------------------------------
-- ----- lfp elim diff intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R] (<zero/> | <succ> <succ> R)]
--   [typ| TOP \ <succ> <zero/>]

-- --- if x is an even number then x ≠ 1
-- example : GuardedSubtyping
--   [] []
--   [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
--   [typ| TOP \ <succ> <zero/>]
--   [ids| ] [constraints| ]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- --- if x is an even number then x ≠ 3
-- #eval GuardedSubtyping.solve
--   [] []
--   [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
--   [typ| TOP \ <succ> <succ> <succ>  <zero/>]

-- example : GuardedSubtyping
--   [] []
--   [typ| LFP[R] ((<zero/>) | (<succ> <succ> R))]
--   [typ| TOP \ <succ> <succ> <succ> <zero/>]
--   [ids| ] [constraints| ]
-- := by
--   sorry
--   -- Subtyping_Static_prove
-- -- := by
-- --   apply GuardedSubtyping.lfp_elim_diff_intro
-- --   { rfl }
-- --   { simp [Typ.struct_less_than]; reduce
-- --     (first
-- --     | apply Or.inl ; rfl
-- --     | apply Or.inr ; rfl
-- --     ) <;> fail }
-- --   { rfl }
-- --   { Typ_Monotonic_Static_prove }
-- --   { Subtyping_Static_prove }
-- --   { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }
-- --   { simp [Typ.subfold, Typ.sub, Subtyping.check, find] }

-- ---------------------------------------
-- ----- diff intro
-- ---------------------------------------

-- example : GuardedSubtyping
--   [] []
--   [typ|(<zero/>) | (<succ> <succ> (TOP \ <succ> <zero/>))]
--   [typ| TOP \ <succ> <zero/>]
--   [ids| ] [constraints| ]
-- := by
--   sorry

-- ---------------------------------------
-- ----- least fixed point peel intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <succ> <succ> <zero/>]
--   [typ| LFP[R] <zero/> | <succ> R ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <succ> <succ> <zero/>]
--   [typ| LFP[R] <zero/> | <succ> R ]
--   [ids| ] [constraints|  ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- least fixed point drop intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <zero/>]
--   [typ| LFP[R] <zero/> | (R -> <uno/>) ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <zero/>]
--   [typ| LFP[R] <zero/> | (R -> <uno/>) ]
--   [ids| ] [constraints|  ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- diff elim
-- ---------------------------------------
-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| (<uno/> | <dos/>) \ <dos/>]
--   [typ| <uno/> ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| (<uno/> | <dos/>) \ <dos/>]
--   [typ| <uno/> ]
--   [ids| ] [constraints|  ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- union left intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <uno/> ]
--   [typ| <uno/> | <dos/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <uno/> ]
--   [typ| <uno/> | <dos/>]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- union right intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <dos/> ]
--   [typ| <uno/> | <dos/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <dos/> ]
--   [typ| <uno/> | <dos/>]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- existential intro
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <uno/>]
--   [typ| EXI[T] [(T <: <uno/>)] T ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <uno/>]
--   [typ| EXI[T] [(T33 <: <uno/>)] T33]
--   [ids| ] [constraints| (T33 <: <uno/>) (<uno/> <: T33) ]
-- := by
--   sorry

-- ---------------------------------------
-- ----- inter left elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <uno/> & <dos/>]
--   [typ| <uno/> ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <uno/> & <dos/>]
--   [typ| <uno/> ]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- inter right elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| <uno/> & <dos/>]
--   [typ| <dos/> ]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| <uno/> & <dos/>]
--   [typ| <dos/> ]
--   [ids| ] [constraints| ]
-- := by Subtyping_Static_prove

-- ---------------------------------------
-- ----- universal elim
-- ---------------------------------------

-- #eval GuardedSubtyping.solve
--   [ids| ] [constraints| ]
--   [typ| ALL[T] [(<uno/> <: T)] T ]
--   [typ| <uno/>]

-- example : GuardedSubtyping
--   [ids| ] [constraints| ]
--   [typ| ALL[T33] [(<uno/> <: T33)] T33 ]
--   [typ| <uno/>]
--   [ids| ] [constraints| (<uno/> <: T33) (T33 <: <uno/>) ]
-- := by
--   sorry
--   -- Subtyping_Static_prove

-- --------------------------------------------


-- ------------------------------------------------------------------------
-- -----<<<< TYPING BASICS >>>>--------------------------------------------
-- ------------------------------------------------------------------------


-- ---------------------------------------
-- ----- variable
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] [typings| (x : <uno/>)]
--   [expr| x ]

-- example : GuardedTyping
--   [ids| ] [constraints| ] [typings| (x : <uno/>)]
--   [expr| x ]
--   [typ| <uno/> ]
--   [ids| ] [constraints| ]
-- := by Expr_Typing_Static_prove

-- ---------------------------------------
-- ----- empty record
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr| <elem/> ]

-- example : GuardedTyping
--   [ids| ] [constraints| ] []
--   [expr| <elem/> ]
--   [typ| TOP ]
--   [ids| ] [constraints| ]
-- := by
--   sorry

-- ---------------------------------------
-- ----- pair record
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr| <uno/> , <dos/>]

-- example : GuardedTyping
--   [ids| ] [constraints| ] []
--   [expr| <uno/> , <dos/>]
--   [typ| <uno/> * <dos/> ]
--   [ids| ] [constraints| ]
-- := by
--   sorry

-- ---------------------------------------
-- ----- identity function
-- ---------------------------------------


-- #eval Function.Typing.Static.compute [] [] [] [] [(Pat.var "x", Expr.var "x")]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr| [x => x]]

-- -- example : ∃ T , GuardedTyping
-- --   [ids| ] [constraints| ] []
-- --   [expr| [x => x]]
-- --   [typ| ALL [{[T]}] [({.var T} <: TOP)] ({.var T}) -> {.var T}]
-- --   [ids| ] [constraints| ]
-- -- := by
-- --   use ?_
-- --   apply GuardedTyping.function
-- --   (try Function_Typing_Static_assign)
-- --   apply Function.Typing.Static.cons
-- --   { sorry }
-- --   { ListZone_Typing_Static_assign
-- --     intros
-- --     sorry }

-- ---------------------------------------
-- ----- finite isomorphism
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [<uno/> => <dos/>]
--     [<thank/> => <you/>]
--     [<hello/> => <goodbye/>]
--   ]

-- -- example : GuardedTyping
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     [<uno/> => <dos/>]
-- --   ]
-- --   [typ|
-- --     (<uno/> -> <dos/>)
-- --   ]
-- --   [ids| ] [constraints| ]
-- -- := by Expr.Typing_Static_prove

-- -- example : GuardedTyping
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     [<uno/> => <dos/>]
-- --     [<thank/> => <you/>]
-- --   ]
-- --   [typ|
-- --     (<uno/> -> <dos/>) &
-- --     (<thank/> -> <you/>)
-- --   ]
-- --   [ids| ] [constraints| ]
-- -- := by Expr.Typing_Static_prove

-- -- example : GuardedTyping
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     [<uno/> => <dos/>]
-- --     [<thank/> => <you/>]
-- --     [<hello/> => <goodbye/>]
-- --   ]
-- --   [typ|
-- --     (<uno/> -> <dos/>) &
-- --     (<thank/> -> <you/>) &
-- --     (<hello/> -> <goodbye/>)
-- --   ]
-- --   [ids| ] [constraints| ]
-- -- := by Expr.Typing_Static_prove


-- ---------------------------------------
-- ----- annotated variable
-- ---------------------------------------

-- #eval [expr| x as <uno/>]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr| [ x => x as <uno/> ] ]

-- ---------------------------------------
-- ----- definition
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def talky =
--       [<uno/> => <dos/>]
--       [<thank/> => <you/>]
--       [<hello/> => <goodbye/>]
--     in <result/>
--   ]

-- ---------------------------------------
-- ----- pair pattern
-- ---------------------------------------

-- #eval [expr|
--   [ f,x => f(x) ]
-- ]

-- ---------------------------------------
-- ----- application
-- ---------------------------------------
-- #eval [expr|
--   [ left := f ; right := x => f(x) ]
-- ]

-- ---------------------------------------
-- ----- selection
-- ---------------------------------------

-- #eval [expr|
--   def talky =
--     [<uno/> => <dos/>]
--     [<thank/> => <you/>]
--     [<hello/> => <goodbye/>]
--   in [ x =>
--     def y : <uno/> | <thank/> = x in
--     talky(y)
--   ]
-- ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def talky =
--       [<uno/> => <dos/>]
--       [<thank/> => <you/>]
--       [<hello/> => <goodbye/>]
--     in [ x =>
--       def y : <uno/> | <thank/> = x in
--       talky(y)
--     ]
--   ]

-- ---------------------------------------
-- ----- learning
-- ---------------------------------------

-- #eval [expr| [f => f(<uno/>), f(<dos/>) ] ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [f => f(<uno/>), f(<dos/>) ]
--   ]

-- ---------------------------------------
-- ----- factorization
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     loop([self =>
--       [<zero/> => <nil/>]
--       [<succ> n => <cons> (self(n))]
--     ])
--   ]


-- def repeat_expr := [expr|
--   [x => loop([self =>
--     [<zero/> => <nil/>]
--     [<succ> n => <cons> (x,self(n))]
--   ])]
-- ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   repeat_expr


-- ---------------------------------------
-- ----- scalar peeling (i.e. inflation) ; peeling open the least fixed point
-- ---------------------------------------

-- #eval [expr|
--   <succ> <succ> <zero/> as LFP[R] <zero/> | <succ> R
-- ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     <succ> <succ> <zero/> as LFP[R] <zero/> | <succ> R
--   ]


-- ---------------------------------------
-- ----- identity application
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     <uno/>
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [x => x](<uno/>)
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [u =>
--       [x => u]
--     ](<uno/>)
--   ]

-- ----------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [<zero/> => <uno/>]
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [g => g]([<zero/> => <uno/>])
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [g => g]([<zero/> => <uno/>])
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [g =>
--       [x => g]
--     ]([<zero/> => <uno/>])
--   ]


-- ---------------------------------------
-- ----- double application
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [<one/> => <zero/>]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [x =>
--       [<zero/> => <uno/>]([<one/> => <zero/>](x))
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [<zero/> => <uno/>](x)
--     ]
--   ]


-- ---------------------------------------
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       def g = [<zero/> => <uno/>] in
--       g(x)
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [g => g(x)]([<zero/> => <uno/>])
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       def g = [<zero/> => <uno/>] in
--       g
--     ]
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def g = [<zero/> => <uno/>] in
--     [ x => g(x) ]
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = [<one/> => <zero/>] in
--     def g = [<zero/> => <uno/>] in
--     g
--   ]

-- ---------------------------------------
-- ----- scalar induction
-- ---------------------------------------

-- -- NOTE: that it gives the input the stronger type
-- -- NOTE: and it gives the output the weaker type

-- -- RESULT: Even -> Nat
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr| [x =>
--     x as (
--       LFP[R] <zero/> | <succ> <succ> R
--     ) as (
--       LFP[R] <zero/> | <succ> R
--     )
--   ] ]

-- -- RESULT: Even -> Even
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = [x => x as LFP[R] <zero/> | <succ> <succ> R ] in
--     def g = [x => x as LFP[R] <zero/> | <succ> R ] in
--     [x => g(f(x))]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def g = loop ([self =>
--       [<zero/> => <uno/>]
--       [<succ> n => self(n) ]
--     ]) in
--     [x => g(x)]
--   ]

-- -- RESULT: Even -> Uno
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     -- Even -> Even
--     def f = loop ([self =>
--       [<zero/> => <zero/>]
--       [<succ> <succ> n => <succ> <succ> (self(n)) ]
--     ]) in
--     -- Nat -> Uno
--     def g = loop ([self =>
--       [<zero/> => <uno/>]
--       [<succ> n => <uno/> ]
--     ]) in
--     -- Even -> Uno
--     [x => g(f(x))]
--   ]

-- --------------------------------
-- --------------------------------
-- --------------------------------

-- #eval [expr|
--   [uno := <elem/> => one := <elem/>]
--   [dos := <elem/> => two := <elem/>]
-- ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] [typings| (x : uno : <elem/> & dos : <elem/>)]
--   [expr|
--     (
--     [uno := <elem/> => one := <elem/>]
--     [dos := <elem/> => two := <elem/>]
--     ) (x)
--   ]

-- -- NOTE: this passes because the typing assumption is absurd (<uno/> & <dos/>) <: BOT
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] [typings| (x : <uno/> & <dos/>)]
--   [expr|
--     (
--     [<uno/> => <one/>(<elem/>)]
--     [<dos/> => <two/>]
--     ) (x)
--   ]

-- --------------------------------
-- --------------------------------
-- --------------------------------

-- -- TODO: interpret further to simplify type
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     loop ([self =>
--       [<nil/> => <zero/>]
--       [<cons> n => <succ> (self(n)) ]
--     ])
--   ]

-- -- -- SHOULD FAIL
-- -- #eval GuardedTyping.compute
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     loop ([<guard> self =>
-- --       [<nil/> => <zero/>]
-- --       [<cons> n => <succ> (self(n)) ]
-- --     ])
-- --   ]

-- -- -- SHOULD FAIL
-- -- #eval GuardedTyping.compute
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     loop ([<guard> self => <guard> (
-- --       [<nil/> => <zero/>]
-- --       [<cons> n => <succ> (self(n)) ]
-- --     )])
-- --   ]

-- --------------------------------
-- --------------------------------
-- --------------------------------

-- -- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       (
--         [<zero/> => <uno/>]
--         [<succ/> => <dos/> ]
--       ) (
--         (
--           [<nil/> => <zero/>]
--           [<cons/> => <succ/>]
--         ) (x)
--       )
--     ]
--   ]


-- -- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [f => f ](
--       [<nil/> => <zero/>]
--       [<cons/> => <succ/>]
--     )
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [<nil/> => <zero/>]
--     [<cons/> => <succ/>]
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = (
--       [<nil/> => <zero/>]
--       [<cons/> => <succ/>]
--     ) in
--     [x => f(x)]
--   ]

-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [z =>
--       (
--         [<uno> y => y]
--         [<dos> y => y]
--       )(z)
--     ]
--   ]

-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     (uno := <hello/> ; dos := <bye/>)
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     (
--       [uno := x ; dos := y => (x,y)]
--     ) (uno := <hello/> ; dos := <bye/>)
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     loop([self =>
--       [<zero/> => <nil/>]
--       [<succ> n => <cons> (self(n))]
--     ])
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       def g = [<zero/> => <uno/>] in
--       g(x)
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [x => x](<uno/>)
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [u =>
--       [x => x](<uno/>)
--     ]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [u =>
--       [x => u]
--     ](<uno/>)
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [g => g(x)]([<zero/> => <uno/>])
--     ]
--   ]


-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [g => g(<zero/>)]([<zero/> => <uno/>])
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ x =>
--       [g => g(x)]
--     ]
--   ]


-- ---------------------------------------
-- ----- factorization
-- ---------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     loop([self =>
--       [<zero/> => <nil/>]
--       [<succ> n => <cons> (self(n))]
--     ])
--   ]

-- -------------------------------------------------
-- -------------------------------------------------

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [x => [<nil/> => <zero/>](x)]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = (
--       [<nil/> => <zero/>]
--     ) in
--     [x => f(x)]
--   ]

-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = (
--       [<nil/> => <zero/>]
--       [<cons/> => <succ/>]
--     ) in
--     [x => f(x)]
--   ]

-- -- RESULT: (<nil/> -> <uno/>)
-- -- TODO: construct a reachable procedure that filters constraints
-- -- to only those that are reachable from payload
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [<start/> =>
--       def g = (
--         [<zero/> => <uno/>]
--       ) in
--       [x => g([<nil/> => <zero/>](x))]
--     ]
--   ]


-- -- RESULT: (<nil/> -> <uno/>)
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     def f = (
--       [<nil/> => <zero/>]
--     ) in
--     def g = (
--       [<zero/> => <uno/>]
--     ) in
--     [x => g(f(x))]
--   ]

-- -- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--     [ <start/> =>
--       def f = (
--         [<nil/>  => <zero/>]
--         [<cons/>  => <succ/>]
--       ) in
--       def g = (
--         [<zero/> => <uno/>]
--         [<succ/> => <dos/> ]
--       ) in
--       -- f
--       [x => g(f(x))]
--     ]
--   ]

-- -- RESULT: (<nil/> -> <uno/>) & (<cons/> -> <dos/>)
-- #eval GuardedTyping.compute
--   [ids| ] [constraints| ] []
--   [expr|
--       def f = (
--         [<nil/>  => <zero/>]
--         [<cons/>  => <succ/>]
--       ) in
--       def g = (
--         [<zero/> => <uno/>]
--         [<succ/> => <dos/> ]
--       ) in
--       [x => g(f(x))]
--   ]

-- --------------------------------
-- --------------------------------
-- --------------------------------

-- -- -- RESULT: Even -> Uno | Dos
-- -- #eval GuardedTyping.compute
-- --   [ids| ] [constraints| ] []
-- --   [expr|
-- --     -- Even -> Even
-- --     def f = loop ([self =>
-- --       [<nil/> => <zero/>]
-- --       [<cons> n => <succ> (self(n)) ]
-- --     ]) in
-- --     def g = (
-- --       [<zero/> => <uno/>]
-- --       [<succ> n => <dos/> ]
-- --     ) in
-- --     [x => g(f(x))]
-- --   ]
