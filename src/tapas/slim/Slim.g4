grammar Slim;

@header {
from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analysis import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 

}


@parser::members {

_analyzer : Analyzer
_cache : dict[int, str] = {}

_guidance : Guidance 
_overflow = False  

def init(self): 
    self._analyzer = Analyzer() 
    self._cache = {}
    self._guidance = ExprGuide(m(), Top())
    self._overflow = False  

def reset(self): 
    self._guidance = ExprGuide(m(), Top())
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()



def getGuidance(self):
    return self._guidance

def tokenIndex(self):
    return self.getCurrentToken().tokenIndex

def guard_down(self, f : Callable, *args):
    assert isinstance(self._guidance, ExprGuide)

    for arg in args:
        if arg == None:
            self._overflow = True

    if not self._overflow:
        self._guidance = f(self._guidance, *args)

    tok = self.getCurrentToken()
    if not self._overflow and tok.type == self.EOF :
        self._overflow = True 

def guard_up(self, f : Callable, *args):

    assert isinstance(self._guidance, ExprGuide)
    
    if self._overflow:
        return None
    else:

        return f(self._guidance, *args)
        # TODO: caching is broken; tokenIndex does not change 
        # index = self.tokenIndex() 
        # cache_result = self._cache.get(index)
        # print(f"CACHE: {self._cache}")
        # if False: # cache_result:
        #     return cache_result
        # else:
        #     result = f(*args)
        #     self._cache[index] = result
        #     return result

}

expr returns [Typ typ] : 
| ID 
{
$typ = self.guard_up(self._analyzer.combine_expr_id, $ID.text)
} 

| '()' 
{
$typ = self.guard_up(self._analyzer.combine_expr_unit)
} 

| ':' ID body = expr 
{
$typ = self.guard_up(self._analyzer.combine_expr_tag, $ID.text, $body.typ)
}

| record 
{
$typ = $record.typ
}

| ID '=>' 
{
self.guard_down(self._analyzer.distill_expr_function_body, $ID.text)
}
body = expr 
{
$typ = $body.typ
}

// | expr '.' expr {
//     $result = 'hello'
// }

// | expr '(' expr ')' 
// {
//     $result = 'hello'
// }
// | 'match' switch = expr ('case' param = expr '=>' body = expr)+ 
//{
//     $result = 'hello'
// }
// | ('fun' param = expr '=>' body = expr)+ 
// {
//     prefix = '['
//     content = ''.join([
//         '(fun ' + p + ' ' + b + ')'  
//         for p, b in zip($param.result, $body.result)
//     ])
//     suffix = ']'
//     $result = prefix + content + suffix
// }
// | 'if' cond = expr 'then' t = expr 'else' f = expr 
// {
    // $result = f'(ite {$cond.result} {$t.result} {$f.result})'
// }

| 'let' ID '=' target = expr 
{
self.guard_down(self._analyzer.distill_expr_let_body, $ID.text, $target.typ)
}
body = expr
{
$typ = $body.typ
}

| 'fix' 
{ 
self.guard_down(lambda: SymbolGuide("("))
} 
'(' 
{
self.guard_down(lambda g: ExprGuide(g.env, Top()))
}
body = expr
{
self.guard_down(lambda: SymbolGuide(')'))
}
')' 
{
$typ = self.guard_up(self._analyzer.combine_expr_fix, $body.typ)
}

// | 'let' ID ('in' typ)? '=' expr expr  {
//     $result = 'hello'
// }
// | '(' body = expr ')' 
// {
    // $result = f'(paren {$body.result})' 
// }
;

record returns [Typ typ] :
| '.' ID '=' expr
{
$typ = self.guard_up(self._analyzer.combine_record_single, $ID.text, $expr.typ)
}
| '.' ID '=' expr record
{
$typ = self.guard_up(self._analyzer.combine_record_cons, $ID.text, $expr.typ, $record.typ)
}
;

// thing returns [str result]: 
//     | 'fun' param = expr '=>' body = expr {
//         $result = f'(fun {$param.result} {$body.result})'
//     }
//     ;

// things : 
//     | thing
//     | things thing
//     ;

// typ :
//     | 'unit'
//     | 'top'
//     | 'bot'
//     | ID '//' typ 
//     | ID 'in' typ 
//     | typ '&' typ 
//     | typ '*' typ 
//     | typ '|' typ 
//     | typ '->' typ 
//     | '{' ID ('<:' typ)? ('with' typ '<:' typ)* ('#' (ID)+)? '}'
//     | '[' ID ('<:' typ)? ']' typ 
//     | ID '@' typ 
//     ;


ID : [a-zA-Z]+ ;
INT : [0-9]+ ;
WS : [ \t\n\r]+ -> skip ;

////////////////////////////////////////////////////
/** Grammar from tour chapter augmented with actions */
// grammar Slim;

// @header {
// }

// @parser::members {
// @property
// def memory(self):
//     if not hasattr(self, '_map'):
//         setattr(self, '_map', {})
//     return self._map
    
// @memory.setter
// def memory_setter(self, value):
//     if not hasattr(self, '_map'):
//         setattr(self, '_map', {})
//     self._map = value
    
// def eval(self, left, op, right):
//     if   ExprParser.MUL == op.type:
//         return left * right
//     elif ExprParser.DIV == op.type:
//         return left / right
//     elif ExprParser.ADD == op.type:
//         return left + right
//     elif ExprParser.SUB == op.type:
//         return left - right
//     else:
//         return 0
// }

// stat:   e NEWLINE           {print($e.v);}
//     |   ID '=' e NEWLINE    {self.memory[$ID.text] = $e.v}
//     |   NEWLINE                   
//     ;

// e returns [int v]
//     : a=e op=('*'|'/') b=e  {$v = self.eval($a.v, $op, $b.v)}
//     | a=e op=('+'|'-') b=e  {$v = self.eval($a.v, $op, $b.v)}
//     | INT                   {$v = $INT.int}    
//     | ID
//       {
// id = $ID.text
// $v = self.memory.get(id, 0)
//       }
//     | '(' e ')'             {$v = $e.v}       
//     ; 

// MUL : '*' ;
// DIV : '/' ;
// ADD : '+' ;
// SUB : '-' ;

// ID  :   [a-zA-Z]+ ;      // match identifiers
// INT :   [0-9]+ ;         // match integers
// NEWLINE:'\r'? '\n' ;     // return newlines to parser (is end-statement signal)
// WS  :   [ \t]+ -> skip ; // toss out whitespace
