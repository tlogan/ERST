# ------------------------------------------------------------
# calclex.py
#
# tokenizer for a simple expression evaluator for
# numbers and +,-,*,/
# ------------------------------------------------------------
import ply.lex as lex

tokens = (
  'TID',
  'UNIT',
  'TOP',
  'BOT',
  'DSLASH',
  'COLON',
  'AMP',
  'STAR',
  'BAR',
  'ARROW',
  'INDUC',
  
  'SUBTYP',
  'LBRACE',
  'RBRACE',
  'WITH',
  'HASH',
  'LSQ',
  'RSQ',
  'LPAREN',
  'RPAREN',
  
  'ID',
  'SEMI',
  'COMMA',
  'DOT',
  'FIX',
  
  'AT',
  'MATCH',
  'CASE',
  'LET',
  'IN',
  
  'TYPE',
  
  'EQ',
  'THARROW',
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
t_INDUC = r'induc'

t_SUBTYP = r'<:'
t_LBRACE = r'\{'
t_RBRACE = r'\}'
t_WITH = r'with'
t_HASH = r'\#'
t_LSQ = r'\['
t_RSQ = r'\]'
t_LPAREN = r'\('
t_RPAREN = r'\)'

t_ID = r'[a-z][a-zA-Z_]*'
t_SEMI = r';'
t_COMMA = r';'
t_DOT = r'\.'
t_FIX = r'fix'

t_AT = r'@'
t_MATCH = r'match'
t_CASE = r'case'
t_LET = r'let'
t_IN = r'in'

t_TYPE = r'type'

t_EQ = r'='
t_THARROW = r'=>'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

lexer = lex.lex()

'''
testing
'''
data = '''
    type nat_list = induc Self . 
        (zero//unit * nil//unit) |
        {succ//N * cons//L with N * L <: Self}
'''

lexer.input(data)

while True:
    tok = lexer.token()
    if not tok:
        break      # No more input
    print(tok)


print(f'lineno: {lexer.lineno}')
