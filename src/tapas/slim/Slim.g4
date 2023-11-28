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
    self._guidance = disn_default 
    self._overflow = False  

def reset(self): 
    self._guidance = disn_default
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

    disn_result = None
    if not self._overflow:
        disn_result = f(*args)
        self._guidance = Nonterm(name, disn_result)

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return disn_result 



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

expr [Distillation disn] returns [ECombo combo] : 

// Base rules

| base[disn] {
$combo = $base.combo
}

// Introduction rules

| {
disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_head)
} head = base[disn] {
self.guide_symbol(',')
} ',' {
disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_tuple_tail, $head.combo)
} tail = base[disn] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, $head.combo, $tail.combo) 
}

// Elimination rules

| 'if' {
disn_condition = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_condition)
} condition = expr[disn_condition] {
self.guide_symbol('then')
} 'then' {
disn_true_branch = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_true_branch, $condition.combo)
} true_branch = expr[disn_true_branch] {
self.guide_symbol('else')
} 'else' {
disn_false_branch = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_ite_false_branch, $condition.combo, $true_branch.combo)
} false_branch = expr[disn_false_branch] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_ite, $condition.combo, $true_branch.combo, $false_branch.combo) 
} 

| {
disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_projection_cator)
} cator = base[disn_cator] {
disn_keychain = self.guide_nonterm('keychain', ExprAttr(self._solver, disn).distill_projection_keychain, $cator.combo)
} keychain[disn_keychain] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_projection, $cator.combo, $keychain.ids) 
}

| {
disn_cator = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_application_cator)
} cator = base[disn_cator] {
disn_argchain = self.guide_nonterm('argchain', ExprAttr(self._solver, disn).distill_application_argchain, $cator.combo)
} argchain[disn_argchain] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_application, $cator.combo, $argchain.combos)
}

| {
disn_arg = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_funnel_arg)
} cator = base[disn_arg] {
disn_pipeline = self.guide_nonterm('pipeline', ExprAttr(self._solver, disn).distill_funnel_pipeline, $cator.combo)
} pipeline[disn_pipeline] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_funnel, $cator.combo, $pipeline.combos)
}

| 'let' {
self.guide_terminal('ID')
} ID {
disn_target = self.guide_nonterm('target', ExprAttr(self._solver, disn).distill_let_target, $ID.text)
} target[disn_target] {
self.guide_symbol(';')
} ';' {
disn_contin = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_let_contin, $ID.text, $target.combo)
} contin = expr[disn_contin] {
$combo = $contin.combo
}


// | 'let' {
// self.guide_terminal('ID')
// } ID {
// self.guide_symbol('=')
// } '=' {
// disn_target = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_let_target, $ID.text)
// } target = expr[disn_target] {
// self.guide_symbol(';')
// } ';' {
// disn_body = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_let_body, $ID.text, $target.combo)
// } body = expr[disn_body] {
// $combo = $body.combo
// }

| 'fix' {
self.guide_symbol('(')
} '(' {
disn_body = self.guide_nonterm('expr', ExprAttr(self._solver, disn).distill_fix_body)
} body = expr[disn_body] {
self.guide_symbol(')')
} ')' {
$combo = self.collect(ExprAttr(self._solver, disn).combine_fix, $body.combo)
}

;

base [Distillation disn] returns [ECombo combo] : 
// Introduction rules

| '@' {
$combo = self.collect(BaseAttr(self._solver, disn).combine_unit)
} 

| ':' {
self.guide_terminal('ID')
} ID {
disn_body = self.guide_nonterm('expr', BaseAttr(self._solver, disn).distill_tag_body, $ID.text)
} body = expr[disn_body] {
$combo = self.collect(BaseAttr(self._solver, disn).combine_tag, $ID.text, $body.combo)
}

///////
// PROBLE: left-recursion not allowed
// | expr[sistillation] ',' expr[sistillation]
///////

| record[disn] {
$combo = $record.combo
}

| function[disn] {
$combo = $function.combo
}

// Elimination rules

| ID {
$combo = self.collect(BaseAttr(self._solver, disn).combine_var, $ID.text)
} 

| '(' {
disn_expr = self.guide_nonterm('expr', lambda: disn)
} expr[disn_expr] {
self.guide_symbol(')')
} ')' {
$combo = $expr.combo
} 

;


function [Distillation disn] returns [ECombo combo] :

| 'case' {
disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_single_pattern)
} pattern[disn_pattern] {
self.guide_symbol('=>')
} '=>' {
disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_single_body, $pattern.combo)
} body = expr[disn_body] {
$combo = self.collect(FunctionAttr(self._solver, disn).combine_single, $pattern.combo, $body.combo)
}

| 'case' {
disn_pattern = self.guide_nonterm('pattern', FunctionAttr(self._solver, disn).distill_cons_pattern)
} pattern[disn_pattern] {
self.guide_symbol('=>')
} '=>' {
disn_body = self.guide_nonterm('expr', FunctionAttr(self._solver, disn).distill_cons_body, $pattern.combo)
} body = expr[disn_body] {
disn_tail = self.guide_nonterm('function', FunctionAttr(self._solver, disn).distill_cons_tail, $pattern.combo, $body.combo)
} tail = function[disn] {
$combo = self.collect(FunctionAttr(self._solver, disn).combine_cons, $pattern.combo, $body.combo, $tail.combo)
}

;



record [Distillation disn] returns [ECombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_single_body, $ID.text)
} body = expr[disn_body] {
$combo = self.collect(RecordAttr(self._solver, disn).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
disn_body = self.guide_nonterm('expr', RecordAttr(self._solver, disn).distill_cons_body, $ID.text)
} body = expr[disn] {
disn_tail = self.guide_nonterm('record', RecordAttr(self._solver, disn).distill_cons_tail, $ID.text, $body.combo)
} tail = record[disn] {
$combo = self.collect(RecordAttr(self._solver, disn).combine_cons, $ID.text, $body.combo, $tail.combo)
}

;

// NOTE: disn.expect represents the type of the rator applied to the next immediate argument  
argchain [Distillation disn] returns [list[ECombo] combos] :

| '(' {
disn_content = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_single_content) 
} content = expr[disn_content] {
self.guide_symbol(')')
} ')' {
$combos = self.collect(ArgchainAttr(self._solver, disn).combine_single, $content.combo)
}

| '(' {
disn_head = self.guide_nonterm('expr', ArgchainAttr(self._solver, disn).distill_cons_head) 
} head = expr[disn_head] {
self.guide_symbol(')')
} ')' {
disn_tail = self.guide_nonterm('argchain', ArgchainAttr(self._solver, disn).distill_cons_tail, $head.combo) 
} tail = argchain[disn_tail] {
$combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, $head.combo, $tail.combos)
}

;

pipeline [Distillation disn] returns [list[ECombo] combos] :

| '|>' {
disn_content = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_single_content) 
} content = expr[disn_content] {
$combos = self.collect(PipelineAttr(self._solver, disn).combine_single, $content.combo)
}

| '|>' {
disn_head = self.guide_nonterm('expr', PipelineAttr(self._solver, disn).distill_cons_head) 
} head = expr[disn_head] {
disn_tail = self.guide_nonterm('pipeline', PipelineAttr(self._solver, disn).distill_cons_tail, $head.combo) 
} tail = pipeline[disn_tail] {
$combos = self.collect(ArgchainAttr(self._solver, disn).combine_cons, $head.combo, $tail.combos)
}

;


// NOTE: disn.expect represents the type of the rator applied to the next immediate argument  
keychain [Distillation disn] returns [list[str] ids] :

| '.' {
self.guide_terminal('ID')
} ID {
$ids = self.collect(KeychainAttr(self._solver, disn).combine_single, $ID.text)
}

| '.' {
self.guide_terminal('ID')
} ID {
disn_tail = self.guide_nonterm('keychain', KeychainAttr(self._solver, disn).distill_cons_tail, $ID.text) 
} tail = keychain[disn_tail] {
$ids = self.collect(KeychainAttr(self._solver, disn).combine_cons, $ID.text, $tail.ids)
}

;

target [Distillation disn] returns [ECombo combo]:

| '=' {
disn_expr = self.guide_nonterm('expr', lambda: disn)
} expr[disn_expr] {
$combo = $expr.combo
}

// TODO: add annotation case and type parsing
// | ':' {
// # TODO
// disn_anno = self.guide_nonterm('expr', TargetAttr(self._solver, disn).distill_target_anno)
// } anno = typ[disn] {
// } '=' {
// # TODO
// disn_body = self.guide_nonterm('expr', TargetAttr(self._solver, disn).distill_target_body, $anno.combo)
// } body = expr[disn_body] {
// $combo = $body.combo
// }

;



pattern [Distillation disn] returns [PCombo combo]:  

| pattern_base[disn] {
$combo = $pattern_base.combo
}

| {
disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_head)
} head = base[disn] {
self.guide_symbol(',')
} ',' {
disn_cator = self.guide_nonterm('expr', PatternAttr(self._solver, disn).distill_tuple_tail, $head.combo)
} tail = base[disn] {
$combo = self.collect(ExprAttr(self._solver, disn).combine_tuple, $head.combo, $tail.combo) 
}

;

pattern_base [Distillation disn] returns [PCombo combo]:  

| ID {
$combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, $ID.text)
} 

| ID {
$combo = self.collect(PatternBaseAttr(self._solver, disn).combine_var, $ID.text)
} 

| '@' {
$combo = self.collect(PatternBaseAttr(self._solver, disn).combine_unit)
} 

| ':' {
self.guide_terminal('ID')
} ID {
disn_body = self.guide_nonterm('pattern', PatternBaseAttr(self._solver, disn).distill_tag_body, $ID.text)
} body = pattern[disn_body] {
$combo = self.collect(PatternBaseAttr(self._solver, disn).combine_tag, $ID.text, $body.combo)
}

| pattern_record[disn] {
$combo = $pattern_record.combo
}

;

pattern_record [Distillation disn] returns [PCombo combo] :

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_single_body, $ID.text)
} body = pattern[disn_body] {
$combo = self.collect(PatternRecordAttr(self._solver, disn).combine_single, $ID.text, $body.combo)
}

| ':' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
disn_body = self.guide_nonterm('pattern', PatternRecordAttr(self._solver, disn).distill_cons_body, $ID.text)
} body = pattern[disn_body] {
disn_tail = self.guide_nonterm('pattern_record', PatternRecordAttr(self._solver, disn).distill_cons_tail, $ID.text, $body.combo)
} tail = pattern_record[disn_tail] {
$combo = self.collect(PatternRecordAttr(self._solver, disn).combine_cons, $ID.text, $body.combo, $tail.combo)
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
