# Extrinsic Relational Subtyping
- alternate name: **Descriptive** Relational Subtyping

### TODO (Symbolic Implementation)
- in RHS existential, create witness before checking against uninterpretable (relational key) frozen variable 
- in RHS existential, use substitution of witness (which might be frozen variable)
    - instead of reducing to constraint F <: L; this introduces a strange infinite loop where
        - frozen is weakened to learnable; and learnable is strengthened to frozen;
- make sure upper bound is checked against frozen variable:
    - e.g. F <: L, L <: T; should check that F <: T  
- consider adding extraction of subtyping constraint for mutual flow of variables; see difference between `addition_rel` and `add` function
- when checking a single frozen id that is relational; factor out the column from relational assumption   
- add in  diffing; using a disjoint check to remove diffs that aren't necessary 

-------------------
- add `is_odd`, `halve` (which requires an even number), `split` (a list at index), `merge`, `sort`, and some tree (Red Black) procedures  
- test `fib`, `sumr`, and `suml` on concrete examples for sanity check
    - figure out how to clean up result for arguments of inductive case
- add relational constraint weakening (via factoring columns) to enable relational annotations
- develop example of function that calls different function expecting different records on same argument 
    - e.g. `_.uno = @` and `_.dos = @` and infers `(uno : @ & dos : @)`

- double check `test_max`
    - see if subbing into relational constraint is necessary for learnable variables
    - maybe not, since strongest interpretation is still available: T <: X, (X, Y) <: R 

- prove that the output type of `fibonacci` on any input is subtyping of a number that is greater than its input (e.g. using `leq` relational constraint).
- create `merge sort` test
- create RedBlack `tree insert` test
- write a function that operates on even numbers (e.g. div by 2) and one that operates on nats, to demonstrate power of subtyping of unions. 
- improve speed by interpreting variables and removing constraints in `combine` rules
- uncomment generalization and extrusion in `combine_function`
- in parser attributes; move nt model updates to combine step
- add negs back in `from_cases_to_choices`
- get `max` example to work
- check that combine_app rule isn't redundant with checks in distill app rules.
- develop examples with interesting semantics and test type inference
    - inferring max
    - encode fibonacci as an example to motivate 2-induction and test k-induction.
    - type annotations 
    - subtyping
- finish implementing inhabitable check
- finish implementing relational key check 
- update basic examples with test of type inference 
- implement caching for streaming parsing
    - update collect and guide_choice rules to memo(r)ize
- understand why union in super F constraints paper is defined differently
- understand what polarity types are and how they are related to relational typing

### TODO (Symbolic Paper)
- write soundness theorems and proofs.
    - define typing_ssin using subsumption rule as denotation into sets with subset inclusion
    - define (syntactic) subtyping
    - prove that syntactic subtyping is sound wrt to subset inclusion
    - define typing_st subsumption in terms of syntactic subtyping
    - prove that typing_st is sound wrt typing 
    - prove or state existence of proof that typing_ssin is sound wrt operational semantics 
- note how ERST is both general purpose and automated; compare to proof assistants (e.g. Lean) and SMT solvers (Z3)
    - SMT has automation but requires specialized theories or specific domains to work
    - Proof assistants and dependently typed systems are general purpose but their automation is not general purpose
    - Both are intrinsic and requires predicates to be defined rather than inferred/reconstructed.
- note how solving subtyping corresponds to CDCL
    - solving subtyping splits worlds when there is an intersection of implications on left or a union of patterns on the right
        - this corresponds to CDCL's splitting a variable into true or false worlds
    - after splitting worlds, solving searches for the strongest interpretation of type variable (e.g. I <: T)
        - this corresponds to CDCL's learning a clause due to a conflict
        - that is, a conflicting clause in CDCL corresponds to a lower bound in subtyping
        - CDCL uses negation for duality, while subtyping uses lower vs upper bound (therefore, union vs intersection) for duality.
- discuss the notion of freezer/skolem adjacent learnable variables (frozen <: learnable); 
- for paper, write algorithmic inference rules as a combination of combine/distill rules 
    - distill rules construct a new environment; combine rules construct a new type
- for paper, note that much of type reconstruction is handled in solving subtyping
    - this puts intersection/union rules in subtyping instead of typing
    - indirectly in typing via subsumption
- for paper, note why both intro and elim rules are bidirectional
    - basic bidirectional typing has checking for intro rules and synthesis for elimination rules 
        - type and program are both provided
    - roundtrip typing has checking for intro rules and both checking and synthesis for elimination rules
        - program is not provided
        - checking is necessary for both as the type guides synthesis
    - contextual typing has both checking and synthesis for intro and elim rules
        - parts of type are not provided
        - parts of program are not provided
        - synthesis for intro is necessary to construct type
        - checking for elim is necessary to construct program  
- note two ways to type a function (constrained implication vs indexed intersection)
    - intersection types can be subsumed by constrained universal types with union 
        - e.g. [X <: (S | T) | U] X === ([X <: S | T] X) & U ==== ([X <: S] X) & T & U === S & U & T 
        - e.g. [X <: T | U] X -> {Y. (X, Y) <: (T, A) | (U, B)} === (T -> A) & (U -> B) 
    - constrained implication is construction from function introduction (in case a fixedpoint relation is used)
    - indexed intersection is constructed from constraint solving 
    - both reduce to the same solution in application 
    ```
    ==============================
    case _ : A => _ : T 
    case _ : B => _ : U 
    --------------------
    -- infer
    --------------------
    [X <: A | B] X -> {Y . (Z, Y) <: (A, T) | (B\A, U)} Y
    ==============================


    ==============================
    [X <: A | B] X -> {Y . (Z, Y) <: (A, T) | (B\A, U)} Y <: P -> Q
    --------------------
    -- application of constrained implication
    --------------------
    P <: A | B
    P -> {Y . (P, Y) <: (A, T) | (B\A, U)} Y <: P -> Q
    --------------------
    {Y . (P, Y) <: (A, T) | (B\A, U)} Y <: Q
    --------------------
    (P, Y) <: (A, T) | (B\A, U)  :: Y frozen 
    |-
    Y <: Q
    --------------------
    (P, Y) <: (A, T) |- Y <: Q :: Y frozen || 
    (P, Y) <: (B\A, U) |- Y <: Q :: Y frozen
    --------------------
    P <: A, T <: Q  ||  P <: B\A, U <: Q 
    ==============================


    ==============================
    (A -> T & B\A -> U) <: P -> Q
    --------------------
    -- application of intersection implication
    --------------------
    A -> T <: P -> Q  ||  B\A -> U <: P -> Q
    P <: A, T <: Q    ||  P <: B\A, U <: Q 
    ==============================
    -- P is in neg position
    -- Q is in pos position
    ------------------------------

    ```
- in paper, write rules in a declarative style that does not imply downward propagation 
- in paper, note importance of generating constraints on argument variables
- in paper, note importance of renaming and extrusion in imp-imp rule 
    - renaming to solve for conclusion under local assumption
    - extrusion to connect conclusion with other conclusions 
    - develop examples where renamed variables are everywhere to demonstrate importance of extrusion
- in paper, note the importance of flipping between weakest and strongest interpretations
    - for a return type that depends on a parameter type; the P <: T ,  P < Q; Q; strongest of Q uses weakest of P e.g. T. 
- in paper, note farfetched conjecture that relational types is a more elegant foundation for math than dependent types.
    - allows for greater automation: that is, automatic reusing of proofs across propositions across the transitive closure of subtyping. 
- in paper, note criteria of when variables are frozen (i.e. turned into skolems) 
- in paper, change subset inclusion to strict equality in subtyping rules 

### Implementation 
- avoid recursion, which has poor performance in python.
- update guidance before each part of a sequence
- update overflow after each guidance update 
- update result after entire sequence
- after each call to server, server responds with some guidance, completion status, or acknowledgment of killing.   
- inherit attributes via guide and distill methods
- synthesize attributes via collect and combine methods

### Title
- Guiding safe generation of untyped programs   


### Context
- Generation of programs one token at a time from left to right
- Generation can be parameterized by analysis of previous results 

- inductive invariant for expressions is a property that holds for every possible expression that can be constructed according to a recursion 

- Constraints are symbolic representations of interpretations

- Predicates are symbolic representations of sets of expressions

- CEGAR abstracts the model and iteratively refines it  
    - makes the problem hard and iteratively makes it easier
    - refutation of a counter-example is a necessary condition of the concrete model 
        - the necessary condition refines the abstract model, making verification easier

- SYNGAR abstracts the specification and iteratively refines it
    - makes the problem easy and iteratively makes it harder 
    - spuriousness/incorrectness on an I/O example is a sufficient condition for negating the concrete specification
        - the sufficient condition refines the abstract specification, making verification harder

- interpolation is the construction of an interpretation and a valid formula from an instance/derivation constrained by a specification      
    - interpolation is simply used to find a generalizable refinement from some instance
    - e.g. `P_instance <: P_interp <: P_spec`
    - an interpolant's upper and lower bounds are based on the constraints and interpolants above and below it 
    - for a node in a tree, the interpolant's:
        - lower bound is the local constraint and the child interpolants
            - e.g. `C(n) /\ I(n_m_1) ... /\ I(n_m_n) ==> I(n)`
        - upper bound is the above level's interpolant minus the above level's local constraints and the sibling interpolants  
            - e.g. `I(n) = I(o_m_i)`, `C(o) /\ I(o_m_1) ... /\ I(o_m_n) ==> I(o)`
            - into `I(n) ==> I(o) \ C(o) \ I(o_m_1) ... \ I(o_m_i-1) \ I(o_m_i+1) ... \ I(o_m_n)`
    - construction of formulas with disjunction and conjunction represents construction of an interpolant 
    - updating the interpretation propagates the interpolant to higher levels 

- duality interpolation
    - finding a derivation tree for cyclic (i.e. inductive) constraints corresponds to unwinding cyclic constraints into DAG-like constraints.
    - in other words, a DAG-like problem has exactly one derivation tree (per query)
    - keeps track of interpolant for each node, and conjuctive merges at the end
    - solve by one or more iterations of unwinding, interpolating, and refining the inductive subset  
    - the inductive subset is a subset of the solution for the unwinding that constitutes a sufficient solution for the original problem
    - an inductive subset is the uncovered subset of the solution
    - a covered predicate is one that depends on a covered predicate or that is covered predicate or is weaker than a predicate created before it 
        - this is sufficient because covered predicates should have no effect since all (transitively) imply a single query predicate.  
    - a forced covering is (partially defined as) a covering between two instances of a predicate 
    - TODO: does covering make sense for predicates that are not unioned? 
    - A solution to the unwinding may not always contain a solution to the original problem, since the unwinding may not capture some inductive aspects
    - if there is no solution to the original problem, then the non-solution points to where the next unwinding should occur. 
    - the predicate P_i for a particular unwinding is the intersection of the I(n) where hd(n) = P_i for all n 
    - the predicate P for a particular unwinding is the union of P_i for all i
    - interpolation is used when unwinding adds the query to the set of constraints
    - solving terminates with failure when no derivation of query is found 
    - solving terminates with solution when inductive subset found 


### Gap
- Pure statical-learning methods (LLMs) generate unsafe programs
- Symbolic generation methods (Synquid) are limited to intrinsically typed languages 
- Left-to-right guidance (Neural Program Generation Modulo Static Analysis) is limited to heavily annotated programming languages
- CHC solving methods cannot provide inference to guide program completion 

### Innovation 
- Guidance of program synthesis from context a la duality interpolation 
    - related to NSG in left-to-right guidance, but for extrinsically typed and unannotated expression languages 
    - related to Synquid in bidirectional typing and expressive relations, but with duality-based unification rather tha predicate abstraction
    - no pre-defined universe of predicates or logical qualifiers or types to choose from for abstracting
- Connection of bidirectional typing with unions and intersection to interpolation via the duality algorithm
    - the program represents an instance/derivation tree and its type under the interpretation constructed by bidirectional typing represents the interpolation   
    - construction of types with unions or intersections represents construction of an interpolant 
    - updating the interpretation propagates the interpolant to higher levels 
    - e.g. for `foo(e)`, `foo : A -> B`, `e : T`, the interpolant is `I` where `T <: I <: A`
    - intersection from T <: spec corresponds to P_i as intersection of I(n) across nodes in derivation to bidirectional typing's intersection
    - union from model <: T corresponds to P as union of P_i across i to bidirectional typing's union
- simple subtyping is handled by unification at program and type language levels
- relational subtyping is handled by horn clause solving
    - unwinds and creates fresh predicates 
    - unrolling an inductive type corresponds to unwinding cyclic constraints into DAG-like constraints
- Bidirectional/Duality analysis on streaming/partial programs 
    - bidirectional/duality analysis on recursive-decent parse-tree 
    - bidirectional/duality analysis of top-down parse-tree (without left-recursion) for left-associative semantics. 
    - adds layer of complexity that's not apparent in a normalized AST
    - checking without the overhead of reconstruction requires propagating types downward
- Relational types
    - extrinsic types 
    - unifies/decides/solves subtyping without base types refined by qualifiers
    - second order qualifiers allow natural expression of relational co-induction
    - lack of sorts prevents general propositions over proofs
    - the inhabitation of types/predicates may be viewed as existential propositions 
    - the inhabitation of a function type may be viewed as an implication between the inhabitation of each of the two subparts

    - Syntactic encoding: horn clause represents the subtyping semantics: M |= T1 <: T2 is defined by rules: T1 <: T2 :- body 
        - type inference would then be encoded as the query: solve(T1 <: T2) is sat  
        - subtyping rules should be partially evaluated before sending to z3 solver
        - https://www-kb.is.s.u-tokyo.ac.jp/~koba/papers/pldi11.pdf
        - offers way to represent the learned type symbolically and compactly.   
    - Semantic encoding: horn clause represents the meaning of types: M |= T is defined by rules T(x) :- body(x)     
        - the solution represents set of all possible inhabitants of type P.        
        - type verification (M |= T1 <: T2) would then be encoded as the query:  solve(T1(x) and not T2(x)) is unsat  
        - represents types as a set of terms belonging the Value ADT sort 
        - a record type could be encoded using uninterpreted functions 
        - e.g. maybe `P = {m1 : T1, m2 : T2}` could become `P(Record(x)) :- T1(m1(x)), T2(m2(x))`
        - a record type could be encoded using uninterpreted functions over domain StringSort
        - e.g. maybe `P = {m1 : T1, m2 : T2}` could become `P(Record(x)) :- T1(x(m1)), T2(x(m2))`
        - a record type could be encoded using pairs 
        - e.g. maybe `P = {m1 : T1, m2 : T2}` could become `P(Record(Field(m1, y1)::Field(m2, y2))) :- T1(y1), T2(y2)`
        - there is no way to represent the type other than as infinite set of values or the constraints themselves.   

    - could use intersection on the fly in order to guide synthesis rather than conjunctive merging at the end

    - typing/subtyping behave like constraints, which are symbolic representations of sets of interpretations

    - types behave like predicates, which are symbolic representations of sets of expressions

    - horn clauses map to relational subtyping
        - e.g. `P(y, y') /\ z = y' + 1 => P(y,z)`
        - into `(y, y') : P /\ (z, y' + 1) : Eq => (y,z) : P`
        - into `{Y * Z with (Y * Y') <: P, (Z * Y' + 1) <: Eq} <: P`
        - into `{Y * Z with (Y * Y') <: P, (Z * (:succ? Y')) <: Eq} <: P`
    - TODO: what's the advantage of relational subtyping over horn clauses?
        - provides a more compact representation for annotating programs
- Propagation of types
    - checking and guiding via propagation 
    - checking/solving via horn-clause solver when subtyping at leaves
    - uses both distill and combine in introduction rules, since specification may need to be extracted from program.
        - Synquid does not need to propagate up the type (i.e. combine) in introduction rules
    - uses both distill and combine in elimination rules.
        - Synquid's roundtrip typing also propagates in both directions for elimination rules. 
        - the original bidirectional typing only propagates up for elimination rules.
    - calls to solve are used in both distill/inheriting rules and combine/synthesizing rules.
        - solves for new prescription in distill
            - allows for input type to be rewritten into a decomposable form
            - in contrast to Synquid rules, which have a strict syntactic requirement
            - places more complexity in subtyping rules and less complexity in typing rules
        - solves for new description in combine
        - in other words, solve is called in introduction/distill rules and elimination/combine rules
    - type inference of application of cases without a specified upper bound:
        ```
        P <: A | C 
        Q <: {B with A <: P} | {D with C <: P}
        ---------------------------------------
        (A -> B) & (C -> D) <: (P -> Q)
        ```
        - syntactic check at unification; make sure that lhs antecedents are associated with rhs consequent's subparts 

    - Bidirectional
        - propagating types down corresponds to CDCL or back-jumping
        - propagating types up corresponds to BCP or unit-propagation
    - Solving for types directly without SMT
        - solving for variables on left vs variables on right of subtyping might correspond to a conflict driven dialectic a la CDCL or CEGAR
        - constructing/unrolling a derivation on the LHS of subtyping corresponds to finding a counterexample derivation in CEGAR/interpolation.  
        - we use backward reasoning on subtyping to construct a subtyping derivation. 
            - If there is a satisfying type variable assignment that could allow the derivation to hold, then we update the assignment. 
            - then we repeat the process of constructing derivations until no more new assignments are found or the derivation fails.
            - type variables on the LHS can be assigned and strengthened with intersection in terms of the types on the RHS
            - type variables on the RHS are not assigned or adjusted
            - union types are constructed from combining solutions from multiple reasoning branches (e.g. solving cases from pattern matching)
        - failure to find assignment satisfying subtyping unification corresponds to CEGAR's counter-example derivation having only consistent assignments  
        - success in finding a satisfying assignment for subtyping unification corresponds to CEGAR's counter-example derivation having in an inconsistent assignment
        - there is a correspondence between model-based satisfaction and proof-based entailment for typing and subtyping 
            - `T |= T` type satisfaction represents subset inclusion of interpretations for types inhabited by some term
            - `x : T |= x : T` typing satisfaction represents subset inclusion of interpretations for types inhabited by then given term
            - `T <: T |= T <: T`subtyping satisfaction represents subset inclusion of interpretations for subtyping
            - `M |- T <: T` subtyping entailment represents subset inclusion of terms that inhabit types for some interpretation
            - `M |- x : T` typing entailment represents inhabitation of a term in a types for some interpretation
            - ```
                A |= P
                P -> Q, A |= B  
                -- corresponds to --
                (A <: P) |= (B <: Q) 
                -- corresponds to --
                M |- A <: P
                ----------------
                M |- Q <: B
                -- corresponds to --
                M |- (P -> Q) <: (A -> B) 
                ```



### Future work
- use statistical learning to find necessary types 
    - verify that the found type is actually necessary (of the concrete model): i.e. `T_model <: T_nc`, `T_nc <: T_spec`
    - (analogous to finding and verifying refutation of a counter-example in CEGAR)
- use statistical learning to find interpolants, e.g. `T_nc <: T_i <: T_spec` 
- extend language to handle mutable references in synthesis from context


### Hypothesis
- Type information must be leniently extracted from programs based on compositions
- Type reasoning must be performed directly with the program 
    - in order to construct upper bound of program completion 

### Motivating examples

#### Heterogeneous generics
```
let x = [] 

let first : list[str] * top -> list[str] 
let first = (a , b) => a 

let _ = first (x, x)  

let y = x ++ [4]
```

After `let x`, the system infers
```
x : list[T]
```

After `let first`, the system infers
```
first : (list[str] * top) -> list[str]
```

After `let _ = first (x, x)`, the system infers
```
x : list[str] 
ok 
treat first as a constraint on the type of x
```

After `let y = x ++ [4]`, the system infers
```
++ : [T] list[T] * list[T] -> list[T]
strict option. error: list[int] ≤ list[str] 
lenient option. x : list[str | T], y : list[str | int | T]
```


#### Parameter refinement 
```
let g : (uno : G) -> unit = _ in 
let h : (dos : H) -> unit = _ in 
let f  = (x => g(x), h(x))
```

After `let f`, the system infers
```
f : (uno : G) & (dos : H) -> unit * unit
```

#### Overlapping pattern matching
```
let g : A -> G
let h : B -> H
let k : C -> K

def foo(x) =  
    match x 
    case uno;a => g(a)  
    case dos;b => h(b)

def boo(x) =  
    match x 
    case dos;b => h(b)
    case tres;c => k(c)  


let hplus : (H * H) -> nat 


def client(x) =
    let y = foo(x) in
    match y 
    case <pattern : H> => hplus(y, boo(x))
```

After `def foo`, the system infers
```
foo : [X] X -> {G with X <: uno//A} | {H with X <: dos//B}  
```

After `def boo`, the system infers
```
boo : [X] X -> {H with X <: dos//B} | {K with X <: tres//C}
```

In `def client`, the system infers
```
x : X 
X <: uno//A | dos//B  
y : Y
Y <: {G with X <: uno//A} | {H with X <: dos//B} 
-- OR ----
union [ X <: uno//A |- Y <: G,  X <: dos//B |- H ]
```

Towards the end, the system infers 
```
client : (uno//A | dos//B) & (dos//B) -> unit
client : dos//B -> nat 
```



<!-- 
--------
OLD
--------
--------

consider:

```
let x = [1]
-- x : list[int]

let first : (list[str] ; ?) -> list[str]
let first = (a , b) => a 
-- first : (list[str] ; ?) -> list[str]

let _ = first (x, ... 
-- error: list[int] ≤ list[str]
```


basic typing: <br> 
`Γ ⊢ t : τ` <br>

variable
```
(x : τ) ∈ Γ 
---------------------------                        
Γ ⊢ x : τ
```
 

application
```
Γ ⊢ t₁ : τ₂ -> τ₁
Γ ⊢ t₂ : τ₂'
Γ ⊩ τ₂' ≤ τ₂
------------------------------- 
Γ ⊢ t₁ t₂ : τ₁
```


example: is `first (x, ...` well-typed?
```
Γ ⊢ first : (list[str] ; ?) -> list[str] 
Γ ⊢ (x, ... : ... 
Γ ⊩ ... ≤ (list[str] ; ?)
--------------------------------------------------
Γ ⊢ first (x, ... : ...
```


basic supertyping: <br>
`Γ ⊢ t : τ ≥ τ` <br>

variable
```
(x : τ') ∈ Γ 
Γ ⊩ τ' ≤ τ
---------------------------                        
Γ ⊢ x : τ ≥ τ' 
```

application
```
Γ ⊢ t₁ : ? -> τ₁ ≥ τ₂ -> τ₁'
Γ ⊢ t₂ : τ₂ ≥ _ 
------------------------------- 
Γ ⊢ t₁ t₂ : τ₁ ≥ τ₁'
```


example: is `first (x, ...` well-typed?
```
(x : list[int]) ∈ Γ 
Γ ⊩ list[int] ≤ list[str]
--------------------------------------------------------------------
Γ ⊢ x : list[str] ≥ list[int]
```

consider:
```
let x = [] 
-- x : (∀ α ≤ ? . list[α])

let first : list[str] ; ? -> list[str] 
let first = (a , b) => a 
-- first : (list[str] ; ?) -> list[str]

let _ = first (x, x)  
-- ok 
```

polymorphic supertyping: <br>
`Γ ⊢ t : τ ≥ τ` <br>

variable
```
(x : ∀ Δ . τ') ∈ Γ 
Γ ⊩ (forall Δ . τ') ≤ τ
---------------------------                        
Γ ⊢ x : τ ≥ forall Δ . τ'
```


example: is `first(x, x)` well-typed?
```
(x : ∀ α ≤ ? . list[α]) ∈ Γ 
Γ ⊩ (forall α ≤ ? . list[α]) ≤ list[str]
--------------------------------------------------------------------
Γ ⊢ x : list[str] ≥ (forall α ≤ ? . list[α])
```



consider:
```
let x = [] 
-- x : (∀ α ≤ ? . list[α])

let first : list[str] ; ? -> list[str] 
let first = (a , b) => a 
-- first : (list[str] ; ?) -> list[str]

let _ = first (x, x)  
-- ok 
-- treat first as a constraint on the type of x
-- x : list[str] 

let y = x ++ [4]
-- ++ : ∀ {α} . list[α] ; list[α] -> list[α]
-- strict option. error: list[int] ≤ list[str] 
-- lenient option. x : forall α . list[str | α]
-- list[str] <: α ==> {a -> str | b, b -> ?}
-- [4] <: α ==> [4] <: {str | b} ==> 4 <: str \/ [4] <: b ==> {b -> [4] | c}
```

supertyping + constraints: <br>
`Γ ; C ⊢ t : τ ≥ τ ; C` <br>
`Γ ; C ⊩ C` <br>

variable
```
(x : ∀ Δ ⟨D⟩. τ') ∈ Γ 
Γ ; C ⊩ forall Δ ⟨D ∧ τ' ≤ τ⟩
-----------------------------------------------------             
Γ ; C ⊢ x : τ ≥ forall Δ . τ' ; (forall Δ ⟨D ∧ τ' ≤ τ⟩)
```
Note: cumbersome redundancy between supertyping and constraints
Note: type information may not be readable from constraints

supertyping * constraints, simple: <br>
`Γ ; C ⊢ t : τ ≥ τ` <br>
`Γ ; C ⊩ τ ≤ τ` <br>

variable
```
(x : ∀ Δ ⟨D⟩. τ') ∈ Γ 
Γ ; C ⊩ (forall Δ ⟨D⟩ .τ') ≤ τ
-----------------------------------------------------             
Γ ; C ⊢ x : τ ≥ forall Δ ⟨D ∧ τ' ≤ τ₁⟩ . τ'
```
Note: cumbersome redundancy between supertyping and constraints
Note: type information may not be readable from constraints


supertyping * constraints, eager unification: <br>
`Γ ; C ⊢ t : τ ≥ τ` <br>
`Γ ; C ⊩ τ ≤ τ ~> Δ ; D` <br>

variable
```
(x : ∀ Δ ⟨D⟩. τ') ∈ Γ 
Γ ; C ⊩ (forall Δ ⟨D⟩ .τ') ≤ τ ~> Δ' ; D'
-----------------------------------------------------             
Γ ; C ⊢ x : τ ≥ forall Δ' ⟨D'⟩ . τ'
```
Note: type information readable in incomplete program 


example: strict option
```
(x : forall α ≤ ? . list[α]) ∈ Γ 
Γ ⊩ (forall α ≤ ? . list[α]) ≤ list[str] ~> α ≤ str
--------------------------------------------------------------------
Γ ⊢ x : list[str] ≥ (forall α ≤ str . list[α])
```


example: lenient option
```
(x : forall α ≤ ? . list[α]) ∈ Γ 
Γ ⊩ (forall α ≤ ? . list[α]) ≤ list[str] ~> α ≤ (str | α)
--------------------------------------------------------------------
Γ ⊢ x : list[str] ≥ (forall α ≤ (str | α) . list[α])
``` -->


## Artifacts 

### Representation
- qualifiers 
    - second order (subtyping) vs first order (typing)
    - 2nd order makes annotations more uniform 
    - can express union types over existing type definitions or primitive constructors 
    - relies on subtyping qualifiers

### Token processing thread
- Parsing:
    - recursive descent; streaming left to right
- Analysis:
    - using single stack instead of mutual recursion
    - bidirectional/roundtrip propagation of types

### Token generation thread
- Testing 
    - feed in correct or incorrect 
- Neural model 


