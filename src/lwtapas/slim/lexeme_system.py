# ------------------------------------------------------------
# calclex.py
#
# tokenizer for a simple expression evaluator for
# numbers and +,-,*,/
# ------------------------------------------------------------
import ply.lex as lex

tokens = (
   'TID',
   'TUNIT',
   'TOP',
   'BOT',
   'DSLASH',

   'ID',
)

t_TID = r'[A-Z][a-zA-Z_]*'
t_UNIT = r'unit'
t_TOP = r'top'
t_BOT = r'bot'

t_DSLASH = r'//'
t_COLON = r':'
t_AMP = r'&'
t_STAR = r'\*'
t_BAR = r'\|'
t_ARROW = r'->'

t_SUBTYP = r'<:'
t_LBRACE = r'{'
t_RBRACE = r'}'
t_WITH = r'with'
t_HASH = r'#'
t_LSQ = r'['
t_RSQ = r']'
t_LPAREN = r'('
t_RPAREN = r')'

t_ID = r'[a-z][a-zA-Z_]*'
t_SEMI = r';'
t_COMMA = r';'
t_FIX = r'fix'

t_AT = r'@'
t_MATCH = r'match'
t_CASE = r'case'
t_LET = r'let'
t_IN = r'in'

t_TYPE = r'type'

t_EQ = r'='
t_THARROW = r'=>'

# def t_ID(t):
#     r'\d+'
#     r'[a-zA-Z_]+'
#     t.value = int(t.value)
#     return t

# # List of token names.   This is always required
# tokens = (
#    'NUMBER',
#    'PLUS',
#    'MINUS',
#    'TIMES',
#    'DIVIDE',
#    'LPAREN',
#    'RPAREN',
# )

# # Regular expression rules for simple tokens
# t_PLUS    = r'\+'
# t_MINUS   = r'-'
# t_TIMES   = r'\*'
# t_DIVIDE  = r'/'
# t_LPAREN  = r'\('
# t_RPAREN  = r'\)'

# # A regular expression rule with some action code
# def t_NUMBER(t):
#     r'\d+'
#     t.value = int(t.value)
#     return t

# # Define a rule so we can track line numbers
# def t_newline(t):
#     r'\n+'
#     # t.lexer.lineno += len(t.value)
#     t.lexer.lineno += 1

# # A string containing ignored characters (spaces and tabs)
# t_ignore  = ' \t'

# # Error handling rule
# def t_error(t):
#     print("Illegal character '%s'" % t.value[0])
#     t.lexer.skip(1)

# lexer = lex.lex()

# #---------------------------------------
# # Test it out
# data = '''
# 3 + 4 * 10
#   + -20 *2
# '''

# # Give the lexer some input
# lexer.input(data)

# # Tokenize
# while True:
#     tok = lexer.token()
#     if not tok:
#         break      # No more input
#     print(tok)


# print(f'lineno: {lexer.lineno}')

# # Build the lexer lexer = lex.lex()