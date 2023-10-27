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
    self._guidance = plate_default 
    self._overflow = False  

def reset(self): 
    self._guidance = plate_default
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()



def getGuidance(self):
    return self._guidance

def tokenIndex(self):
    return self.getCurrentToken().tokenIndex

def guard_down(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
    for arg in args:
        if arg == None:
            self._overflow = True

    result = None
    if not self._overflow:
        result = f(plate, *args)
        self._guidance = result

        # tok = self.getCurrentToken()
        # if tok.type == self.EOF :
        #     self._overflow = True 

    return result


def shift(self, guidance : Union[Symbol, Terminal]):   
    if not self._overflow:
        self._guidance = guidance 

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 



def guard_up(self, f : Callable, plate : Plate, *args):

    if self._overflow:
        return None
    else:

        clean = next((
            False
            for arg in args
            if arg == None
        ), True)

        if clean:
            return f(plate, *args)
        else:
            return None
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

expr [Plate plate] returns [Typ typ] : 
| ID 
{
$typ = self.guard_up(self._analyzer.combine_expr_id, plate, $ID.text)
} 

| '()' 
{
$typ = self.guard_up(self._analyzer.combine_expr_unit, plate)
} 

| ':' ID body = expr[plate]
{
$typ = self.guard_up(self._analyzer.combine_expr_tag, plate, $ID.text, $body.typ)
}

| record[plate] 
{
$typ = $record.typ
}

// | expr '.' expr {
//     $result = 'hello'
// }

| 
// { \
// TODO: guide terminal
// }
ID '=>' 
{
plate_body = self.guard_down(self._analyzer.distill_expr_function_body, plate, $ID.text)
}
body = expr[plate_body] 
{
plate = plate_body
$typ = self.guard_up(self._analyzer.combine_expr_function, plate, $ID.text, $body.typ)
}

| 
'@'
// TODO: figure out left-recursion issue  
{
# TODO
plate_rator = plate
}
rator = expr[plate_rator] 
'(' 
{ \
plate_rand = self.guard_down(self._analyzer.distill_expr_application_rand, plate, $rator.typ)
}
rand = expr[plate_rand] 
// { \
// TODO: guide symbol 
// }
')' 
{ \
$typ = self.guard_up(self._analyzer.combine_expr_application, plate, $rator.typ, $rand.typ) 
}



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

| 'let' ID '=' 
{
# TODO
plate_target = plate 
}
target = expr[plate_target]
{
plate_body = self.guard_down(self._analyzer.distill_expr_let_body, plate, $ID.text, $target.typ)
}
body = expr[plate_body]
{
$typ = $body.typ
}

//////////////////////////////////

| 'fix' 
{ 
self.shift(Symbol("("))
} 
'(' 
// TODO: need to distinguish between context to distill and guidance to send out 
// need a call stack or use an implicit call stack by parameterizing expr 
{
plate_body = self.guard_down(self._analyzer.distill_expr_fix_body, plate)
}
body = expr[plate_body]
{
self.shift(Symbol(')'))
}
')' 
{
$typ = self.guard_up(self._analyzer.combine_expr_fix, plate, $body.typ)
}

// | 'let' ID ('in' typ)? '=' expr expr  {
//     $result = 'hello'
// }
// | '(' body = expr ')' 
// {
    // $result = f'(paren {$body.result})' 
// }
;

record [Plate plate] returns [Typ typ] :
| '.' ID '=' expr[plate]
{
$typ = self.guard_up(self._analyzer.combine_record_single, plate, $ID.text, $expr.typ)
}
| '.' ID '=' expr[plate] record[plate]
{
$typ = self.guard_up(self._analyzer.combine_record_cons, plate, $ID.text, $expr.typ, $record.typ)
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
