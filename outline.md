# Extrinsic Relational Subtyping

## Subtyping 
- enables flexible use of data constructors without requiring users to write data transliteration to pass type checking.
- an expression can can have strict bounds in one use case but can weaken to be used in more lenient applications. 
- General purpose automated reasoning 
    - allows reasoning about arbitrary domains defined by users' programs and type annotations. 
    - by contrast, SMT relies on domain specific theories 
    - by contrast, general proof systems can in check in general, but only automatically prove with specialized reasoning. 
- mechanisms
    - split subtyping constraint into sub problems by decomposing types, such as intersection and union. 
    - when a standalone variable is found on one side of subtyping and the upper bound is inhabitable, 
        - then learn the subtyping constraint to use is subsequent sub problems.
        - unlike, CDCL, it does not preemptively assign a type to a variable and discover conflicts.
    - learning upper bound constraints of variables enables interpreting the variable as weakest upper bound via intersection  
    - learning lower bound constraints of variables enables interpreting the variable as the strongest lower bound via union  
    - unrolling; solve for variable included in a least fixed-point type 
    - shape testing; identify an infinite recursion than can't fail 
        - save constraint that can't be solved but also can't fail.
- soundness
    - show that there exists a denotation into sets that is sound wrt set theory

## Extrinsic 
- types describe how data constructors are composed
- by contrast, intrinsic typing have data constructors that are prescribed with an upper bound
- without intrinsic typing, inference must learn strongest upper bounds via unions
- by contrast, with intrinsic typing, inference can learn upper bounds by refining prescribed upper bound via intersection

## Relational 
- Types specify both the shape of data and constraints on crossing two or more data constructions.   
- like the where clause in a SQL join. 
- constrain crossings of data via constraints in existential types
- mechanisms
    - relational normalization; including a subset of columns 
    - relational factoring; weakening by extracting a single column

## Typing 
- mechanisms
    - generalization 
    - extrusion
    - least fixed point construction 
    - constraint localization in branches (cases/fields) 
- soundness
    - progress and preservation with subset inclusion rule
    - composition of subtyping soundness
