# ------------------------------------------------------------
# calclex.py
#
# tokenizer for a simple expression evaluator for
# numbers and +,-,*,/
# ------------------------------------------------------------
from __future__ import annotations
from typing import Iterator, Optional, Coroutine
import ply.lex as lex
from ply.lex import LexToken

from core.abstract_token_system import AbstractToken, Grammar
from core.language_system import Syntax, Rule

import asyncio

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
##########################################################################
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
    tok : LexToken = lexer.token()
    if not tok:
        break      # No more input
    print(tok)


print(f'lineno: {lexer.lineno}')

##########################################################################

def choose(syntax : Syntax, options : str, token : LexToken) -> str:
    raise Exception("TODO")

async def parse(
    syntax : Syntax, 
    input : asyncio.Queue[LexToken], 
    output : asyncio.Queue[AbstractToken]
):
    '''
    TODO: construct a stack of abstract tokens
    '''

    '''
    stack keeps track of grammatical abstract token and child index to work on 
    '''
    token_init = await input.get()
    options_init = syntax.start
    selection_init = choose(syntax, options_init, token_init)
    gram_init = Grammar(options_init, selection_init)

    '''
    stack keeps track of grammatical abstract token and index of child being worked on 
    '''
    await output.put(gram_init)
    stack : list[tuple[Grammar, int]] = [(gram_init, 0)]

    backtrack_signal : bool = False


    while stack:
        (gram, child_index) = stack.pop()


        if backtrack_signal:
            '''
            return the result from the sub procedure in the stack
            '''
            child_index += 1
            backtrack_signal = False 

        rule : Rule = syntax.map[gram.options][gram.selection]
        if child_index == len(rule.content):
            backtrack_signal = True 

        else:
            pass
            '''
            TODO: parse according to child index
            '''