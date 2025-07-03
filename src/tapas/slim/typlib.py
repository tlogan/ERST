from __future__ import annotations

from typing import *
from dataclasses import dataclass

############################################################
#### Basics ####
############################################################

Church = (f"""
(ALL[A] (A -> A) -> (A -> A))
""".strip())

Bool = (f"""
((<true> @) | (<false> @))
""".strip())

Nat = (f"""
(LFP[R] 
 (<zero> @) 
| (<succ> R)
)
""".strip())

Even = (f"""
(LFP[R] BOT
| (<zero> @) 
| (<succ> <succ> R)
)
""".strip())

def List_(T): 
    return (f"""
(LFP[R] 
 (<nil> @) 
| (<cons> (({T}) * R))
)
    """.strip())

def State(S, T): 
    return (f"""
(<state> (({S}) * ({T})))
    """.strip())


############################################################
############################################################


# nat = (f"""
# (FX N | ~zero @  | ~succ N )
# """.strip())

# even = (f"""
# (FX E | ~zero @ | ~succ ~succ E)
# """.strip())


nat = (f"""
(FX N | zero;@  | succ;N )
""".strip())

even = (f"""
(FX E | zero;@ | succ;succ;E)
""".strip())

# nat_list = (f"""
# (FX NL 
#     | (~zero @, ~nil @) 
#     | (EXI [N L ; (N, L) <: NL] (~succ N, ~cons L))
# )
# """.strip())

# even_list = (f"""
# (FX NL 
#     | (~zero @, ~nil @) 
#     | EXI [N L ; (N, L) <: NL] (~succ ~succ N, ~cons ~cons L)  
# )
# """.strip())

nat_list = (f"""
(FX NL 
    | (zero : @, nil : @) 
    | (EXI [N L ; (N, L) <: NL] (succ : N, cons : L))
)
""".strip())

even_list = (f"""
(FX NL 
    | (zero : @, nil : @) 
    | EXI [N L ; (N, L) <: NL] (succ : succ : N, cons : cons : L)  
)
""".strip())



nat_equal = (f"""
(FX SELF 
    | (~zero @, ~zero @) 
    | EXI [A B ; (A, B) <: SELF] (~succ A, ~succ B)  
)
""".strip())

addition = (f'''
FX AR 
    | (EXI [Y Z ; (Y, Z) <: ({nat_equal})] (x : ~zero @ & y : Y & z : Z))
    | (EXI [X Y Z ; (x : X & y : Y & z : Z) <: AR] (x : ~succ X & y : Y & z : ~succ Z))
''')

lte = (f"""
(FX SELF 
    | (EXI [x ; x <: ({nat})] (~zero @, x))
    | (EXI [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")

open_lte = (f"""
(FX SELF 
    | (EXI [x] (~zero @, x))
    | (EXI [a b ; (a,b) <: SELF] (~succ a, ~succ b))
)
""")


lted = (f"""
(FX self 
    | (EXI [x ; x <: ({nat})] ((~zero @, x), ~true @))
    | (EXI [a b c ; ((a,b),c) <: self] ((~succ a, ~succ b), c))
    | (EXI [x ; x <: ({nat})] ((~succ x, ~zero @), ~false @))
)
""")

nat_pair = (f"""
(FX self 
    | (EXI [n ; n <: ({nat})] (~zero @, n))
    | (EXI [m n ; (m,n) <: self] (~succ m, ~succ n))
    | (EXI [m ; m <: ({nat})] (~succ m, ~zero @))
)
""")

lted_imp = (f'''
(ALL [XY ; XY <: ({nat_pair})] (XY -> 
    (EXI [Z ; (XY, Z) <: ({lted})] Z)
))) 
''')


# (x : ~zero @ & y : Y & z : Z)
lted_xyz = (f"""
(FX SELF 
    | (EXI [Y ; Y <: ({nat})] (x : ~zero @ & y : Y & z : ~true @))
    | (EXI [X Y Z ; (x : X & y : Y & z : Z) <: SELF] (x : ~succ X & y : ~succ Y & z : Z))
    | (EXI [X ; X <: ({nat})] (x : ~succ X & y : ~zero @ & z : ~false @))
)
""")



open_nat_pair = (f"""
(FX SELF 
    | (EXI [N] (~zero @, N))
    | (EXI [N M ; (M, N) <: SELF ] (~succ M, ~succ N)) 
    | (EXI [M] (~succ M, ~zero @))
)
""")

open_lted = (f"""
(FX SELF 
    | (EXI [N] ((~zero @, N), ~true @)) 
    | (EXI [N D M ; ((M, N), D) <: SELF ] ((~succ M, ~succ N), D))
    | (EXI [M] ((~succ M, ~zero @), ~false @))
)
""")

# NOTE: max, un-simplified
max = (f"""
(ALL [G44 G45] 
    ((ALL [M N
        ; G44 <: ~true @
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
    ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44](M, N) -> N)) & 

    (ALL [M N
        ; G44 <: ~false @
        ; (M, N) <: G45 ; G45 <: {open_nat_pair} 
    ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44 ] (M, N) -> M)))
)
""")

# # NOTE: without the antecedent constraint
# max = (f"""
# (ALL [G44 G45] 
#     ((ALL [M N
#         ; G44 <: ~true @
#     ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44](M, N) -> N)) & 

#     (ALL [M N
#         ; G44 <: ~false @
#     ] (EXI [O ; ((M, N), O) <: {open_lted} ; O <: G44 ] (M, N) -> M)))
# )
# """)

