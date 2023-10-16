grammar Slim;

@header {
from dataclasses import dataclass
from typing import *


@dataclass(frozen=True, eq=True)
class Symbol:
    content : str

@dataclass(frozen=True, eq=True)
class Terminal:
    content : str

@dataclass(frozen=True, eq=True)
class Nonterm: 
    content : str

}


@parser::members {

guidance : Union[Symbol, Terminal, Nonterm]
cache : dict[int, str] 
_overflow = False  

 

# _guidance : Union[Symbol, Terminal, Nonterm]
# @property
# def guidance(self) -> Union[Symbol, Terminal, Nonterm]:
#     return self._guidance
# 
# @guidance.setter
# def guidance(self, value : Union[Symbol, Terminal, Nonterm]):
#     self._guidance = value

#def getAllText(self):  # include hidden channel
#    # token_stream = ctx.parser.getTokenStream()
#    token_stream = self.getTokenStream()
#    lexer = token_stream.tokenSource
#    input_stream = lexer.inputStream
#    # start = ctx.start.start
#    start = 0
#    # stop = ctx.stop.stop
#
#    # TODO: increment token position in attributes
#    # TODO: map token position to result 
#    # TODO: figure out a way to get the current position of the parser
#    stop = self.getRuleIndex()
#    # return input_stream.getText(start, stop)
#    print(f"start: {start}")
#    print(f"stoppy poop: {stop}")
#    return "<<not yet implemented>>"
#    # return input_stream.getText(start, stop)[start:stop]


def tokenIndex(self):
    return self.getCurrentToken().tokenIndex

def updateOverflow(self):
    tok = self.getCurrentToken()
    print(f"TOK (updateOverflow): {tok}")
    print(f"_overflow: : {self._overflow}")
    if not self._overflow and tok.type == self.EOF :
        self._overflow = True 

def overflow(self) -> bool: 
    return self._overflow

}

expr returns [str result] : 
| ID 
{
$result = f'(id {$ID.text})';
} 
| '()' 
{
if self.cache.get(self.tokenIndex()):
    print("CACHE HIT")
    $result = self.cache[self.tokenIndex()]
else:
    print("COMPUTATION")
    $result = f'(unit)'
    self.cache[self.tokenIndex()] = $result
} 
| ':' ID expr  
{
$result = f'(tag {$ID.text} {$expr.result})'
}
| record 
{
$result = $record.result
}
| ID '=>' expr 
// {
//     $result = 'hello'
// }
// | expr '.' expr {
//     $result = 'hello'
// }
| expr '(' expr ')' 
// {
//     $result = 'hello'
// }
// | 'match' switch = expr ('case' param = expr '=>' body = expr)+ 
//{
//     $result = 'hello'
// }
| ('fun' param = expr '=>' body = expr)+ 
// {
//     prefix = '['
//     content = ''.join([
//         '(fun ' + p + ' ' + b + ')'  
//         for p, b in zip($param.result, $body.result)
//     ])
//     suffix = ']'
//     $result = prefix + content + suffix
// }
| 'if' cond = expr 'then' t = expr 'else' f = expr 
// {
    // $result = f'(ite {$cond.result} {$t.result} {$f.result})'
// }
| 'fix' 
{ 
self.guidance = Symbol("(")
self.updateOverflow()
} 
'(' 
{
if not self.overflow(): 
    self.guidance = Nonterm("expr")
    # print(f"GUIDANCE: {self.guidance}")

self.updateOverflow()
}
body = expr 
{
# TODO: need to detect that token index has not changed 
# lack of change indicates outofbounds  
# set token_index to -1 when out of bounds
print("REACHED HERE")
print(f"REACHED HERE overflow: {self.overflow()}")

if not self.overflow(): 
    self.guidance = Symbol(")")
    # print(f"GUIDANCE: {self.guidance}")

self.updateOverflow()
}
')' 
{
$result = f'(fix {$body.result})'
}
// | 'let' ID ('in' typ)? '=' expr expr  {
//     $result = 'hello'
// }
| '(' body = expr ')' 
// {
    // $result = f'(paren {$body.result})' 
// }
;

record returns [str result] :
| '.' ID '=' expr
{
$result = f'(field {$ID.text} {$expr.result})'
}
| '.' ID '=' expr record
{
$result = f'(field {$ID.text} {$expr.result})' + ' ' + $record.result 
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
