grammar Slim;

@header {
from asyncio import Queue
}

@parser::members {


@property
def output(self):
    return self._output

@output.setter
def output(self, value : Queue):
    self._output = value

}


expr returns [str synth_attr] : 
| ID 
{
$synth_attr = f'(id {$ID.text})';
self.output.put_nowait($synth_attr);
} 
| '()' 
{
$synth_attr = f'(unit)'
self.output.put_nowait($synth_attr);
} 
| ':' ID expr  
{
$synth_attr = f'(tag {$ID.text} {$expr.synth_attr})'
self.output.put_nowait($synth_attr);
}
| record 
{
$synth_attr = $record.synth_attr
self.output.put_nowait($synth_attr);
}
| ID '=>' expr 
// {
//     $synth_attr = 'hello'
// }
// | expr '.' expr {
//     $synth_attr = 'hello'
// }
| expr '(' expr ')' 
// {
//     $synth_attr = 'hello'
// }
// | 'match' switch = expr ('case' param = expr '=>' body = expr)+ 
//{
//     $synth_attr = 'hello'
// }
| ('fun' param = expr '=>' body = expr)+ 
// {
//     prefix = '['
//     content = ''.join([
//         '(fun ' + p + ' ' + b + ')'  
//         for p, b in zip($param.synth_attr, $body.synth_attr)
//     ])
//     suffix = ']'
//     $synth_attr = prefix + content + suffix
// }
| 'if' cond = expr 'then' t = expr 'else' f = expr 
// {
    // $synth_attr = f'(ite {$cond.synth_attr} {$t.synth_attr} {$f.synth_attr})'
// }
| 'fix' '(' body = expr ')' 
{
$synth_attr = f'(fix {$body.synth_attr})'
self.output.put_nowait($synth_attr);
}
// | 'let' ID ('in' typ)? '=' expr expr  {
//     $synth_attr = 'hello'
// }
| '(' body = expr ')' 
// {
    // $synth_attr = f'(paren {$body.synth_attr})' 
// }
;

record returns [str synth_attr] :
| '.' ID '=' expr
{
$synth_attr = f'(field {$ID.text} {$expr.synth_attr})'
}
| '.' ID '=' expr record
{
$synth_attr = f'(field {$ID.text} {$expr.synth_attr})' + ' ' + $record.synth_attr 
}
;

// thing returns [str synth_attr]: 
//     | 'fun' param = expr '=>' body = expr {
//         $synth_attr = f'(fun {$param.synth_attr} {$body.synth_attr})'
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
