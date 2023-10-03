grammar Slim;

expr returns [str $result] :
    | ID {
        $result = f'(id)'
    } 
    | '()' {
        $result = f'(unit)'
    } 
    // | ':' ID expr  {
    //     $result = 'hello'
    // }
    // | ('.' ID '=' expr)+ {
    //     $result = 'hello'
    // }
    // | ID '=>' expr {
    //     $result = 'hello'
    // }
    // | expr '.' expr {
    //     $result = 'hello'
    // }
    // | expr '(' expr ')' {
    //     $result = 'hello'
    // }
    // | 'match' switch = expr ('case' param = expr '=>' body = expr)+ {
    //     $result = 'hello'
    // }
    | ('fun' param = expr '=>' body = expr) + {
        prefix = '['
        content = ''.join([
            '(fun ' + p + ' ' + b + ')'  
            for p, b in zip($param.result, $body.result)
        ])
        suffix = ']'
        $result = prefix + content + suffix
    }
    | 'if' cond = expr 'then' t = expr 'else' f = expr {
        $result = f'(ite {$cond.result} {$t.result} {$f.result})'
    }
    | 'fix' '(' body = expr ')' {
        $result = f'(fix {$body.result})'
    }
    // | 'let' ID ('in' typ)? '=' expr expr  {
    //     $result = 'hello'
    // }
    | '(' body = expr ')' {
        $result = f'(paren {$body.result})' 
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
