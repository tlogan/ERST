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
    self._guidance = distillation_default 
    self._overflow = False  

def reset(self): 
    self._guidance = distillation_default
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()



def getGuidance(self):
    return self._guidance

def tokenIndex(self):
    return self.getCurrentToken().tokenIndex

def guide_nonterm(self, name : str, f : Callable, *args) -> Optional[Distillation]:
    for arg in args:
        if arg == None:
            self._overflow = True

    distillation_result = None
    if not self._overflow:
        distillation_result = f(*args)
        self._guidance = Nonterm(name, distillation_result)

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return distillation_result 



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

expr [Distillation distillation] returns [ECombo combo] : 

// Base rules

| base[distillation] {
$combo = $base.combo
}

// Introduction rules

| {
distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_head)
} head = base[distillation] {
self.guide_symbol(',')
} ',' {
distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_tuple_tail, $head.combo)
} tail = base[distillation] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, $head.combo, $tail.combo) 
}

// Elimination rules

| 'if' {
distillation_condition = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_ite_condition)
} condition = expr[distillation_condition] {
self.guide_symbol('then')
} 'then' {
distillation_true_branch = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_ite_true_branch, $condition.combo)
} true_branch = expr[distillation_true_branch] {
self.guide_symbol('else')
} 'else' {
distillation_false_branch = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_ite_false_branch, $condition.combo, $true_branch.combo)
} false_branch = expr[distillation_false_branch] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_ite, $condition.combo, $true_branch.combo, $false_branch.combo) 
} 

| {
distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_projection_cator)
} cator = base[distillation_cator] {
distillation_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, distillation).distill_projection_keychain, $cator.combo)
} keychain[distillation_keychain] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_projection, $cator.combo, $keychain.ids) 
}

| {
distillation_cator = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_application_cator)
} cator = base[distillation_cator] {
distillation_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, distillation).distill_application_argchain, $cator.combo)
} argchain[distillation_argchain] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_application, $cator.combo, $argchain.combos)
}

| {
distillation_arg = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_funnel_arg)
} cator = base[distillation_arg] {
distillation_pipeline = self.guide_nonterm('pipeline', ExprAttr(self._solver, distillation).distill_funnel_pipeline, $cator.combo)
} pipeline[distillation_pipeline] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_funnel, $cator.combo, $pipeline.combos)
}

| 'let' {
self.guide_terminal('ID')
} ID {
distillation_target = self.guide_nonterm('target', ExprAttr(self._solver, distillation).distill_let_target, $ID.text)
} target[distillation_target] {
self.guide_symbol(';')
} ';' {
distillation_contin = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_let_contin, $ID.text, $target.combo)
} contin = expr[distillation_contin] {
$combo = $contin.combo
}


// | 'let' {
// self.guide_terminal('ID')
// } ID {
// self.guide_symbol('=')
// } '=' {
// distillation_target = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_let_target, $ID.text)
// } target = expr[distillation_target] {
// self.guide_symbol(';')
// } ';' {
// distillation_body = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_let_body, $ID.text, $target.combo)
// } body = expr[distillation_body] {
// $combo = $body.combo
// }

| 'fix' {
self.guide_symbol('(')
} '(' {
distillation_body = self.guide_nonterm('expr', ExprAttr(self._solver, distillation).distill_fix_body)
} body = expr[distillation_body] {
self.guide_symbol(')')
} ')' {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_fix, $body.combo)
}

;

base [Distillation distillation] returns [ECombo combo] : 
// Introduction rules

| '@' {
$combo = self.collect(BaseAttr(self._solver, distillation).combine_unit)
} 

| ':' {
self.guide_terminal('ID')
} ID {
distillation_body = self.guide_nonterm('expr', BaseAttr(self._solver, distillation).distill_tag_body, $ID.text)
} body = expr[distillation_body] {
$combo = self.collect(BaseAttr(self._solver, distillation).combine_tag, $ID.text, $body.combo)
}

///////
// PROBLE: left-recursion not allowed
// | expr[sistillation] ',' expr[sistillation]
///////

| record[distillation] {
$combo = $record.combo
}

| function[distillation] {
$combo = $function.combo
}

// Elimination rules

| ID {
$combo = self.collect(BaseAttr(self._solver, distillation).combine_var, $ID.text)
} 

| '(' {
distillation_expr = self.guide_nonterm('expr', lambda: distillation)
} expr[distillation_expr] {
self.guide_symbol(')')
} ')' {
$combo = $expr.combo
} 

;


function [Distillation distillation] returns [ECombo combo] :

| 'case' {
distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_single_pattern)
} pattern[distillation_pattern] {
self.guide_symbol('=>')
} '=>' {
distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_single_body, $pattern.combo)
} body = expr[distillation_body] {
$combo = self.collect(FunctionAttr(self._solver, distillation).combine_single, $pattern.combo, $body.combo)
}

| 'case' {
distillation_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, distillation).distill_cons_pattern)
} pattern[distillation_pattern] {
self.guide_symbol('=>')
} '=>' {
distillation_body = self.guide_nonterm('expr', FunctionAttr(self._solver, distillation).distill_cons_body, $pattern.combo)
} body = expr[distillation_body] {
distillation_tail = self.guide_nonterm('function', FunctionAttr(self._solver, distillation).distill_cons_tail, $pattern.combo, $body.combo)
} tail = function[distillation] {
$combo = self.collect(FunctionAttr(self._solver, distillation).combine_cons, $pattern.combo, $body.combo, $tail.combo)
}

;



record [Distillation distillation] returns [ECombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_single_body, $ID.text)
} body = expr[distillation_body] {
$combo = self.collect(RecordAttr(self._solver, distillation).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
distillation_body = self.guide_nonterm('expr', RecordAttr(self._solver, distillation).distill_cons_body, $ID.text)
} body = expr[distillation] {
distillation_tail = self.guide_nonterm('record', RecordAttr(self._solver, distillation).distill_cons_tail, $ID.text, $body.combo)
} tail = record[distillation] {
$combo = self.collect(RecordAttr(self._solver, distillation).combine_cons, $ID.text, $body.combo, $tail.combo)
}

;

// NOTE: distillation.expect represents the type of the rator applied to the next immediate argument  
argchain [Distillation distillation] returns [list[ECombo] combos] :

| '(' {
distillation_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_single_content) 
} content = expr[distillation_content] {
self.guide_symbol(')')
} ')' {
$combos = self.collect(ArgchainAttr(self._solver, distillation).combine_single, $content.combo)
}

| '(' {
distillation_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, distillation).distill_cons_head) 
} head = expr[distillation_head] {
self.guide_symbol(')')
} ')' {
distillation_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, distillation).distill_cons_tail, $head.combo) 
} tail = argchain[distillation_tail] {
$combos = self.collect(ArgchainAttr(self._solver, distillation).combine_cons, $head.combo, $tail.combos)
}

;

pipeline [Distillation distillation] returns [list[ECombo] combos] :

| '|>' {
distillation_content = self.guide_nonterm('expr', PipelineAttr(self._solver, distillation).distill_single_content) 
} content = expr[distillation_content] {
$combos = self.collect(PipelineAttr(self._solver, distillation).combine_single, $content.combo)
}

| '|>' {
distillation_head = self.guide_nonterm('expr', PipelineAttr(self._solver, distillation).distill_cons_head) 
} head = expr[distillation_head] {
distillation_tail = self.guide_nonterm('pipeline', PipelineAttr(self._solver, distillation).distill_cons_tail, $head.combo) 
} tail = pipeline[distillation_tail] {
$combos = self.collect(ArgchainAttr(self._solver, distillation).combine_cons, $head.combo, $tail.combos)
}

;


// NOTE: distillation.expect represents the type of the rator applied to the next immediate argument  
keychain [Distillation distillation] returns [list[str] ids] :

| '.' {
self.guide_terminal('ID')
} ID {
$ids = self.collect(KeychainAttr(self._solver, distillation).combine_single, $ID.text)
}

| '.' {
self.guide_terminal('ID')
} ID {
distillation_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, distillation).distill_cons_tail, $ID.text) 
} tail = keychain[distillation_tail] {
$ids = self.collect(KeychainAttr(self._solver, distillation).combine_cons, $ID.text, $tail.ids)
}

;

target [Distillation distillation] returns [ECombo combo]:

| '=' {
distillation_expr = self.guide_nonterm('expr', lambda: distillation)
} expr[distillation_expr] {
$combo = $expr.combo
}

// TODO: add annotation case and type parsing
// | ':' {
// # TODO
// distillation_anno = self.guide_nonterm('expr', TargetAttr(self._solver, distillation).distill_target_anno)
// } anno = typ[distillation] {
// } '=' {
// # TODO
// distillation_body = self.guide_nonterm('expr', TargetAttr(self._solver, distillation).distill_target_body, $anno.combo)
// } body = expr[distillation_body] {
// $combo = $body.combo
// }

;



pattern [Distillation distillation] returns [PCombo combo]:  

| pattern_base[distillation] {
$combo = $pattern_base.combo
}

| {
distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_head)
} head = base[distillation] {
self.guide_symbol(',')
} ',' {
distillation_cator = self.guide_nonterm('expr', PatternAttr(self._solver, distillation).distill_tuple_tail, $head.combo)
} tail = base[distillation] {
$combo = self.collect(ExprAttr(self._solver, distillation).combine_tuple, $head.combo, $tail.combo) 
}

;

pattern_base [Distillation distillation] returns [PCombo combo]:  

| ID {
$combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, $ID.text)
} 

| ID {
$combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_var, $ID.text)
} 

| '@' {
$combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_unit)
} 

| ':' {
self.guide_terminal('ID')
} ID {
distillation_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, distillation).distill_tag_body, $ID.text)
} body = pattern[distillation_body] {
$combo = self.collect(PatternBaseAttr(self._solver, distillation).combine_tag, $ID.text, $body.combo)
}

| pattern_record[distillation] {
$combo = $pattern_record.combo
}

;

pattern_record [Distillation distillation] returns [PCombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_single_body, $ID.text)
} body = pattern[distillation_body] {
$combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
distillation_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, distillation).distill_cons_body, $ID.text)
} body = pattern[distillation_body] {
distillation_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, distillation).distill_cons_tail, $ID.text, $body.combo)
} tail = pattern_record[distillation_tail] {
$combo = self.collect(PatternRecordAttr(self._solver, distillation).combine_cons, $ID.text, $body.combo, $tail.combo)
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
