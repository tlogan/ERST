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

_solver : Solver 
_cache : dict[int, str] = {}

_guidance : Guidance 
_overflow = False  

def init(self): 
    self._solver = Solver() 
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



def collect(self, f : Callable, *args):

    if self._overflow:
        return None
    else:

        clean = next((
            False
            for arg in args
            if arg == None
        ), True)

        if clean:
            return f(*args)
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
$combo = self.collect(ExprAttr(self._solver, plate).combine_id, $ID.text)
} 

| '@' {
$combo = self.collect(ExprAttr(self._solver, plate).combine_unit)
} 

| ':' ID body = expr[plate] {
$combo = self.collect(ExprAttr(self._solver, plate).combine_tag, $ID.text, $body.combo)
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
plate_cator = self.guide_choice(ExprAttr(self._solver, plate).distill_projmulti_cator)
} cator = expr[plate_expr] {
self.guide_symbol(')')
} ')' {
plate_keychain = self.guide_choice(ExprAttr(self._solver, plate).distill_projmulti_keychain, $expr.combo)
} keychain[plate_keychain] {
$combo = self.collect(ExprAttr(self._solver, plate).combine_projmulti, $expr.combo, $keychain.ids) 
}

| ID {
plate_keychain = self.guide_choice(ExprAttr(self._solver, plate).distill_idprojmulti_keychain, $ID.text)
} keychain[plate_keychain] {
$combo = self.collect(ExprAttr(self._solver, plate).combine_idprojmulti, $ID.text, $keychain.ids) 
}

| function[plate] {
$combo = $function.combo
}


/////////////////////////////////
// | ID {
// self.guide_symbol('=>')
// } '=>' {
// plate_body = self.guide_choice(self._solver.distill_expr_function_body, plate, $ID.text)
// } body = expr[plate_body] {
// plate = plate_body
// $combo = self.collect(self._solver.combine_expr_function, plate, $ID.text, $body.combo)
// }
/////////////////////////////////

| '(' {
plate_cator = self.guide_choice(ExprAttr(self._solver, plate).distill_appmulti_cator)
} cator = expr[plate_cator] {
self.guide_symbol(')')
} ')' {
plate_argchain = self.guide_choice(ExprAttr(self._solver, plate).distill_appmulti_argchain, $cator.combo)
} content = argchain[plate_argchain] {
$combo = self.collect(ExprAttr(self._solver, plate).combine_appmulti, $cator.combo, $argchain.combos)
}

| ID {
plate_argchain = self.guide_choice(ExprAttr(self._solver, plate).distill_idappmulti_argchain, $ID.text)
} argchain[plate_argchain] {
$combo = self.collect(ExprAttr(self._solver, plate).combine_idappmulti, $ID.text, $argchain.combos) 
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
plate_target = self.guide_choice(ExprAttr(self._solver, plate).distill_let_target, $ID.text)
} target = expr[plate_target] {
self.guide_symbol(';')
} ';' {
plate_body = self.guide_choice(ExprAttr(self._solver, plate).distill_let_body, $ID.text, $target.combo)
} body = expr[plate_body] {
$combo = $body.combo
}


| 'fix' {
self.guide_symbol('(')
} '(' {
plate_body = self.guide_choice(ExprAttr(self._solver, plate).distill_fix_body)
} body = expr[plate_body] {
self.guide_symbol(')')
} ')' {
$combo = self.collect(ExprAttr(self._solver, plate).combine_fix, $body.combo)
}

;

pattern [Plate plate] returns [PCombo combo]:  

| ID {
$combo = self.collect(PatternAttr(self._solver, plate).combine_id, $ID.text)
} 

| '@' {
$combo = self.collect(PatternAttr(self._solver, plate).combine_unit)
} 

| ':' {
} ID {
plate_body = self.guide_choice(PatternAttr(self._solver, plate).distill_tag_body, $ID.text)
} body = pattern[plate_body] {
$combo = self.collect(PatternAttr(self._solver, plate).combine_tag, $body.combo)
}

| recpat[plate] {
$combo = $recpat.combo
}

;

function [Plate plate] returns [ECombo combo] :

| 'case' {
plate_pattern = self.guide_choice(FunctionAttr(self._solver, plate).distill_single_pattern)
} pattern[plate_pattern] {
self.guide_symbol('=>')
} '=>' {
plate_body = self.guide_choice(FunctionAttr(self._solver, plate).distill_single_body, $pattern.combo)
} body = expr[plate_body] {
$combo = self.collect(FunctionAttr(self._solver, plate).combine_single, $pattern.combo, $body.combo)
}

| 'case' {
plate_pattern = self.guide_choice(FunctionAttr(self._solver, plate).distill_cons_pattern)
} pattern[plate_pattern] {
self.guide_symbol('=>')
} '=>' {
plate_body = self.guide_choice(FunctionAttr(self._solver, plate).distill_cons_body, $pattern.combo)
} body = expr[plate_body] {
plate_tail = self.guide_choice(FunctionAttr(self._solver, plate).distill_cons_tail, $pattern.combo, $body.combo)
} tail = function[plate] {
$combo = self.collect(FunctionAttr(self._solver, plate).combine_cons, $pattern.combo, $body.combo, $tail.combo)
}

;

recpat [Plate plate] returns [PCombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = self.guide_choice(RecpatAttr(self._solver, plate).distill_single_body, $ID.text)
} body = pattern[plate_body] {
$combo = self.collect(RecpatAttr(self._solver, plate).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = self.guide_choice(RecpatAttr(self._solver, plate).distill_cons_body, $ID.text)
} body = pattern[plate_body] {
plate_tail = self.guide_choice(RecpatAttr(self._solver, plate).distill_cons_tail, $ID.text, $body.combo)
} tail = recpat[plate_tail] {
$combo = self.collect(RecpatAttr(self._solver, plate).combine_cons, $ID.text, $body.combo, $tail.combo)
}

;


record [Plate plate] returns [ECombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = self.guide_choice(RecordAttr(self._solver, plate).distill_single_body, $ID.text)
} body = expr[plate_expr] {
$combo = self.collect(RecordAttr(self._solver, plate).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
plate_body = self.guide_choice(RecordAttr(self._solver, plate).distill_cons_body, $ID.text)
} body = expr[plate] {
plate_tail = self.guide_choice(RecordAttr(self._solver, plate).distill_cons_tail, $ID.text, $body.combo)
} tail = record[plate] {
$combo = self.collect(RecordAttr(self._solver, plate).combine_cons, $ID.text, $body.combo, $tail.combo)
}

;

// NOTE: plate.expect represents the type of the rator applied to the next immediate argument  
argchain [Plate plate] returns [list[ECombo] combos] :

| '(' {
plate_content = self.guide_choice(ArgchainAttr(self._solver, plate).distill_single_content) 
} content = expr[plate_content] {
self.guide_symbol(')')
} ')' {
$combos = self.collect(ArgchainAttr(self._solver, plate).combine_single, $content.combo)
}

| '(' {
plate_head = self.guide_choice(ArgchainAttr(self._solver, plate).distill_cons_head) 
} head = expr[plate_head] {
self.guide_symbol(')')
} ')' {
plate_tail = self.guide_choice(ArgchainAttr(self._solver, plate).distill_cons_tail, $head.combo) 
} tail = argchain[plate_tail] {
$combos = self.collect(ArgchainAttr(self._solver, plate).combine_cons, $head.combo, $tail.combos)
}

;


// NOTE: plate.expect represents the type of the rator applied to the next immediate argument  
keychain [Plate plate] returns [list[str] ids] :

| '.' ID {
$ids = self.collect(KeychainAttr(self._solver, plate).combine_single, $ID.text)
}

| '.' ID {
plate_tail = self.guide_choice(KeychainAttr(self._solver, plate).distill_cons_tail, $ID.text) 
} tail = keychain[plate_tail] {
$ids = self.collect(KeychainAttr(self._solver, plate).combine_cons, $ID.text, $tail.ids)
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
