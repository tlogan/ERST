# Lightweight Tapas

## TODO
- use lexer library (PLY) and define lexing rules 
- write recursive descent streaming parser 
- write base class for schema definitions
- use nameless indexing lazily (just for equality modulo alpha renaming)

## Story

### Title
- Guiding safe generation of untyped programs   

### Context
- Generation of programs one token at a time from left to right
- Generation can be parameterized by analysis of previous results 

### Gap
- Pure statical-learning methods (LLMs) generate unsafe programs
- Symbolic generation methods (Synquid) are limited to intrinsically typed languages 
- CHC solving methods cannot provide inference to guide program completion 

### Innovation 
- Type inference for programs with the following combination of features: 
    - streaming/partial programs 
    - extrinsic types 
    - relational types
    - upper bound of program completion 
    - context for program completion 

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


