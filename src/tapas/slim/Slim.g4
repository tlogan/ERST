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

def guide_choice(self, f : Callable, plate : Plate, *args) -> Optional[Plate]:
    for arg in args:
        if arg == None:
            self._overflow = True

    result = None
    if not self._overflow:
        result = f(plate, *args)
        self._guidance = result

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return result



def guide_lex(self, guidance : Union[Symbol, Terminal]):   
    if not self._overflow:
        self._guidance = guidance 

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 


def guide_symbol(self, text : str):
    self.guide_lex(Symbol(text))

def guide_terminal(self, text : str):
    self.guide_lex(Terminal(text))



def mem(self, f : Callable, plate : Plate, *args):

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

expr [Plate plate] returns [ECombo combo] : 
| ID {
$combo = self.mem(self._analyzer.combine_expr_id, plate, $ID.text)
} 

| '@' {
$combo = self.mem(self._analyzer.combine_expr_unit, plate)
} 

| ':' ID body = expr[plate] {
$combo = self.mem(self._analyzer.combine_expr_tag, plate, $ID.text, $body.combo)
}

| record[plate] {
$combo = $record.combo
}

| '(' {
} expr[plate] {
self.guide_symbol(')')
} ')' {
$combo = $expr.combo
} 

| '(' {
plate_cator = self.guide_choice(self._analyzer.distill_expr_projmulti_cator, plate)
} cator = expr[plate_expr] {
self.guide_symbol(')')
} ')' {
plate_keychain = self.guide_choice(self._analyzer.distill_expr_projmulti_keychain, plate, $expr.combo)
} keychain[plate_keychain] {
$combo = self.mem(self._analyzer.combine_expr_projmulti, plate, $expr.combo, $keychain.ids) 
}

| ID {
plate_keychain = self.guide_choice(self._analyzer.distill_expr_idprojmulti_keychain, plate, $ID.text)
} keychain[plate_keychain] {
$combo = self.mem(self._analyzer.combine_expr_idprojmulti, plate, $ID.text, $keychain.ids) 
}

| function[plate] {
$combo = $function.combo
}


/////////////////////////////////
// | ID {
// self.guide_symbol('=>')
// } '=>' {
// plate_body = self.guide_choice(self._analyzer.distill_expr_function_body, plate, $ID.text)
// } body = expr[plate_body] {
// plate = plate_body
// $combo = self.mem(self._analyzer.combine_expr_function, plate, $ID.text, $body.combo)
// }
/////////////////////////////////

| '(' {
plate_cator = self.guide_choice(self._analyzer.distill_expr_appmulti_cator, plate)
} cator = expr[plate_cator] {
self.guide_symbol(')')
} ')' {
plate_argchain = self.guide_choice(self._analyzer.distill_expr_appmulti_argchain, plate, $cator.combo)
} content = argchain[plate_argchain] {
$combo = self.mem(self._analyzer.combine_expr_appmulti, plate, $cator.combo, $argchain.combos)
}

| ID {
plate_argchain = self.guide_choice(self._analyzer.distill_expr_idappmulti_argchain, plate, $ID.text)
} argchain[plate_argchain] {
$combo = self.mem(self._analyzer.combine_expr_idappmulti, plate, $ID.text, $argchain.combos) 
}

//////////////////////////

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

// TODO: add type annotation syntax
// | 'let' ID (';' typ)? '=' expr ; expr 
////////
| 'let' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_target = plate #TODO
} target = expr[plate_target] {
self.guide_symbol(';')
} ';' {
plate_body = self.guide_choice(self._analyzer.distill_expr_let_body, plate, $ID.text, $target.combo)
} body = expr[plate_body] {
$combo = $body.combo
}


| 'fix' {
self.guide_symbol('(')
} '(' {
plate_body = self.guide_choice(self._analyzer.distill_expr_fix_body, plate)
} body = expr[plate_body] {
self.guide_symbol(')')
} ')' {
$combo = self.mem(self._analyzer.combine_expr_fix, plate, $body.combo)
}

;

pattern [Plate plate] returns [PCombo combo]:  
| ID {
$combo = self.mem(self._analyzer.combine_pattern_id, plate, $ID.text)
} 
| '@' {
$combo = self.mem(self._analyzer.combine_pattern_unit, plate)
} 
| ':' {
} ID {
plate_body = plate # TODO
} body = pattern[plate_body] {
$combo = self.mem(self._analyzer.combine_pattern_tag, plate, $body.combo)
}
| recpat[plate] {
$combo = $recpat.combo
}
;

function [Plate plate] returns [ECombo combo] :
| 'case' {
# TODO
plate_pattern = self.guide_choice(self._analyzer.distill_function_single_pattern, plate)
} pattern[plate_pattern] {
self.guide_symbol('=>')
} '=>' {
# TODO
plate_body = self.guide_choice(self._analyzer.distill_function_single_body, plate, $pattern.combo)
} body = expr[plate_body] {
$combo = self.mem(self._analyzer.combine_function_single, plate, $pattern.combo, $body.combo)
}

| 'case' {
# TODO
plate_pattern = self.guide_choice(self._analyzer.distill_function_cons_pattern, plate)
} pattern[plate_pattern] {
self.guide_symbol('=>')
} '=>' {
# TODO
plate_body = self.guide_choice(self._analyzer.distill_function_cons_body, plate, $pattern.combo)
} body = expr[plate_body] {
plate_function = plate # TODO
} function[plate] {
$combo = self.mem(self._analyzer.combine_function_cons, plate, $pattern.combo, $body.combo, $function.combo)
}
;

recpat [Plate plate] returns [PCombo combo] :
| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = plate # TODO
} body = pattern[plate_body] {
$combo = self.mem(self._analyzer.combine_recpat_single, plate, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = plate # TODO
} body = pattern[plate_body] {
plate_tail = plate # TODO
} tail = recpat[plate_tail] {
$combo = self.mem(self._analyzer.combine_recpat_cons, plate, $ID.text, $body.combo, $tail.combo)
}
;




record [Plate plate] returns [ECombo combo] :
| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_expr = plate # TODO
} expr[plate_expr] {
$combo = self.mem(self._analyzer.combine_record_single, plate, $ID.text, $expr.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_expr = plate # TODO
} expr[plate] {
plate_record = plate # TODO
} record[plate] {
$combo = self.mem(self._analyzer.combine_record_cons, plate, $ID.text, $expr.combo, $record.combo)
}
;

// NOTE: plate.expect represents the type of the rator applied to the next immediate argument  
argchain [Plate plate] returns [list[ECombo] combos] :
| '(' {
plate_content = self.guide_choice(self._analyzer.distill_argchain_single_content, plate) 
} content = expr[plate_content] {
self.guide_symbol(')')
} ')' {
$combos = self.mem(self._analyzer.combine_argchain_single, plate, $content.combo)
}


| '(' {
plate_head = self.guide_choice(self._analyzer.distill_argchain_cons_head, plate) 
} head = expr[plate_head] {
self.guide_symbol(')')
} ')' {
plate_tail = self.guide_choice(self._analyzer.distill_argchain_cons_tail, plate, $head.combo) 
} tail = argchain[plate_tail] {
$combos = self.mem(self._analyzer.combine_argchain_cons, plate, $head.combo, $tail.combos)
}
;

// NOTE: plate.expect represents the type of the rator applied to the next immediate argument  
keychain [Plate plate] returns [list[str] ids] :
| '.' ID {
$ids = self.mem(self._analyzer.combine_keychain_single, plate, $ID.text)
}

| '.' ID {
plate_tail = self.guide_choice(self._analyzer.distill_keychain_cons_tail, plate, $ID.text) 
} tail = keychain[plate_tail] {
$ids = self.mem(self._analyzer.combine_keychain_cons, plate, $ID.text, $tail.ids)
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
