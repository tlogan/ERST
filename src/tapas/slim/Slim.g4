grammar Slim;

@header {
from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent import m, pmap, v
from pyrsistent.typing import PMap 

}


@parser::members {

_solver : Solver 
_cache : dict[int, str] = {}

_guidance : Guidance 
_overflow = False  

def init(self): 
    self._solver = default_solver 
    self._cache = {}
    self._guidance = default_nonterm 
    self._overflow = False  

def reset(self): 
    self._guidance = default_nonterm
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()



def getGuidance(self):
    return self._guidance

def tokenIndex(self):
    return self.getCurrentToken().tokenIndex

def guide_nonterm(self, f : Callable, *args) -> Optional[Nonterm]:
    for arg in args:
        if arg == None:
            self._overflow = True

    result_nt = None
    if not self._overflow:
        result_nt = f(*args)
        self._guidance = result_nt

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return result_nt 



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

ids returns [tuple[str, ...] combo] :

| ID {
$combo = tuple([$ID.text])
}

| ID ids {
$combo = tuple([$ID.text]) + $ids.combo
}

;


typ_base returns [Typ combo] : 


| 'TOP' {
$combo = Top() 
}

| 'BOT' {
$combo = Bot() 
}

| ID {
$combo = TVar($ID.text) 
}

| '@' {
$combo = TUnit() 
}

// TTag 
| '~' ID typ_base {
$combo = TTag($ID.text, $typ_base.combo) 
}

// TField 
| ID ':' typ_base {
$combo = TField($ID.text, $typ_base.combo) 
}


| '(' typ ')' {
$combo = $typ.combo   
}

;

typ returns [Typ combo] : 

| typ_base {
$combo = $typ_base.combo
}

// NOTE: infix type combinators are right-associative  
| typ_base '|' typ {
$combo = Unio($typ_base.combo, $typ.combo) 
}

| typ_base '&' typ {
$combo = Inter($typ_base.combo, $typ.combo) 
}

| context = typ_base acc = negchain[$context.combo] {
$combo = $acc.combo 
}

| typ_base '->' typ {
$combo = Imp($typ_base.combo, $typ.combo) 
}


// Tuple 
| typ_base ',' typ {
$combo = Inter(TField('head', $typ_base.combo), TField('tail', $typ.combo)) 
}

// Existential unconstrained 
| 'EXI' '[' ids ']' typ {
$combo = Exi($ids.combo, (), $typ.combo) 
}

// Existential 
| 'EXI' '[' qualification ']' typ {
$combo = Exi((), $qualification.combo, $typ.combo) 
}

// Existential 
| 'EXI' '[' ids qualification ']' typ {
$combo = Exi($ids.combo, $qualification.combo, $typ.combo) 
}

// Universal unconstrained 
| 'ALL' '[' ID ']' body = typ {
$combo = All($ID.text, Top(), $body.combo) 
}

// Universal 
| 'ALL' '[' ID '<:' upper = typ ']' body = typ {
$combo = All($ID.text, $upper.combo, $body.combo) 
}



//induction // least fixed point; smallest set such that typ <: ID is invariant
//   
// least self with 
// :zero, :nil |  
// {n, l <: self] succ n, cons l 
| 'LFP' ID typ {
$combo = LeastFP($ID.text, $typ.combo) 
}


//co-induction // greatest fixed point; greatest set such that ID <: typ is invariant
//
// greatest self of 
// nil -> zero &  
// [self <: n -> l] cons n -> succ l 
// | 'greatest' ID 'of' typ {
// $combo = Greatest($ID.text, $typ.combo) 
// }

;

negchain [Typ context] returns [Diff combo] :

| '\\' negation = typ {
$combo = Diff(context, $negation.combo)
}

| '\\' negation = typ {
context_tail = Diff(context, $negation.combo)
} tail = negchain[context_tail] {
$combo = Diff(context, $negation.combo)
}

;

qualification returns [tuple[Subtyping, ...] combo] :

| ';' subtyping {
$combo = tuple([$subtyping.combo])
}

| ';' subtyping qualification {
$combo = tuple([$subtyping.combo]) + $qualification.combo
}

;

subtyping returns [Subtyping combo] :

| strong = typ '<:' weak = typ {
$combo = Subtyping($strong.combo, $weak.combo)
}

;

expr [Nonterm nt] returns [list[Model] models] : 

// Base rules

| base[nt] {
$models = $base.models
}

// Introduction rules

| {
head_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_head, nt)
} head = base[head_nt] {
self.guide_symbol(',')
} ',' {
nt = replace(nt, models = $head.models)
tail_nt = self.guide_nonterm(ExprRule(self._solver).distill_tuple_tail, nt, head_nt.typ_var)
} tail = expr[tail_nt] {
nt = replace(nt, models = $tail.models)
$models = self.collect(ExprRule(self._solver).combine_tuple, nt, head_nt.typ_var, tail_nt.typ_var) 
}

// Elimination rules

| 'if' {
condition_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_condition, nt)
} condition = expr[condition_nt] {
self.guide_symbol('then')
} 'then' {
nt = replace(nt, models = condition.models)
true_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_true_branch, nt, condition_nt.typ_var)
} true_branch = expr[true_branch_nt] {
self.guide_symbol('else')
} 'else' {
nt = replace(nt, models = true_branch.models)
false_branch_nt = self.guide_nonterm(ExprRule(self._solver).distill_ite_false_branch, nt, condition_nt.typ_var, true_branch_nt.typ_var)
} false_branch = expr[false_branch_nt] {
$models = self.collect(ExprRule(self._solver).combine_ite, nt, condition_nt.typ_var, true_branch_nt.typ_var, false_branch_nt.typ_var) 
} 

// the rator below refers to the record being projected from
| {
rator_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_rator, nt)
} rator = base[rator_nt] {
nt = replace(nt, models = $rator.models)
keychain_nt = self.guide_nonterm(ExprRule(self._solver).distill_projection_keychain, nt, rator_nt.typ_var)
} keychain[keychain_nt] {
nt = replace(nt, models = keychain_nt.models)
$models = self.collect(ExprRule(self._solver).combine_projection, nt, rator_nt.typ_var, $keychain.keys) 
}

| {
cator_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_cator, nt)
} cator = base[cator_nt] {
nt = replace(nt, models = $cator.models)
argchain_nt = self.guide_nonterm(ExprRule(self._solver).distill_application_argchain, nt, cator_nt.typ_var)
} argchain[argchain_nt] {
nt = replace(nt, models = $argchain.attr.models)
$models = self.collect(ExprRule(self._solver).combine_application, nt, cator_nt.typ_var, $argchain.attr.args)
}

| {
arg_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_arg, nt)
} cator = base[arg_nt] {
nt = replace(nt, models = $cator.models)
pipeline_nt = self.guide_nonterm(ExprRule(self._solver).distill_funnel_pipeline, nt, cator_nt.typ_var)
} pipeline[pipeline_nt] {
nt = replace(nt, models = pipeline_nt.models)
$models = self.collect(ExprRule(self._solver).combine_funnel, nt, cator.typ_var, $pipeline.cator_vars)
}

| 'let' {
self.guide_terminal('ID')
} ID {
target_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_target, nt, $ID.text)
} target[target_nt] {
self.guide_symbol(';')
} ';' {
nt = replace(nt, models = $target.models)
contin_nt = self.guide_nonterm(ExprRule(self._solver).distill_let_contin, nt, $ID.text, target_nt.typ_var)
} contin = expr[contin_nt] {
$models = $contin.models
}


| 'fix' {
self.guide_symbol('(')
} '(' {
body_nt = self.guide_nonterm(ExprRule(self._solver).distill_fix_body, nt)
} body = expr[body_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, models = $body.models)
$models = self.collect(ExprRule(self._solver).combine_fix, nt, body_nt.typ_var)
}

;

base [Nonterm nt] returns [list[Model] models] : 
// Introduction rules

| '@' {
$models = self.collect(BaseRule(self._solver).combine_unit, nt)
} 

//tag
| '~' {
self.guide_terminal('ID')
} ID {
body_nt = self.guide_nonterm(BaseRule(self._solver).distill_tag_body, nt, $ID.text)
} body = base[body_nt] {
nt = replace(nt, models = $body.models)
$models = self.collect(BaseRule(self._solver).combine_tag, nt, $ID.text, body_nt.typ_var)
}

| record[nt] {
$models = $record.models
}

| {
} function[nt] {
(models, branches) = $function.models_branches
nt = replace(nt, models = models)
$models = self.collect(BaseRule(self._solver).combine_function, nt, branches)
}

// Elimination rules

| ID {
$models = self.collect(BaseRule(self._solver).combine_var, nt, $ID.text)
} 

| argchain[nt] {
nt = replace(nt, models = $argchain.attr.models)
$models = self.collect(BaseRule(self._solver).combine_assoc, nt, $argchain.attr.args)
} 

;


function [Nonterm nt] returns [tuple[lsit[Model], list[Imp]] models_branches] :

| 'case' {
pattern_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_pattern, nt)
} pattern[pattern_nt] {
self.guide_symbol('=>')
} '=>' {
nt = replace(nt, enviro =  $pattern.attr.enviro, models = $pattern.attr.models)
body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_single_body, nt, $pattern.attr.typ)
} body = expr[body_nt] {
nt = replace(nt, models = $body.models)
$models_branches = ($body.models, self.collect(FunctionRule(self._solver).combine_single, nt, $pattern.attr.typ, body_nt.typ_var))
}

| 'case' {
pattern_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_pattern, nt)
} pattern[pattern_nt] {
self.guide_symbol('=>')
} '=>' {
nt = replace(nt, enviro =  $pattern.attr.enviro, models = $pattern.attr.models)
body_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_body, nt, $pattern.attr.typ)
} body = expr[body_nt] {
nt = replace(nt, models = $body.models)
tail_nt = self.guide_nonterm(FunctionRule(self._solver).distill_cons_tail, nt, $pattern.attr.typ, body_nt.typ_var)
} tail = function[tail_nt] {
(models, branches) = $tail.models_branches
$models_branches = (models, self.collect(FunctionRule(self._solver).combine_cons, nt, $pattern.attr.typ, body_nt.typ_var, branches))
}

;



record [Nonterm nt] returns [list[Model] models] :

| '_.' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
body_nt = self.guide_nonterm(RecordRule(self._solver).distill_single_body, nt, $ID.text)
} body = expr[body_nt] {
nt = replace(nt, models = $body.models)
$models = self.collect(RecordRule(self._solver).combine_single, nt, $ID.text, body_nt.typ_var)
}

| '_.' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
body_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_body, nt, $ID.text)
} body = expr[body_nt] {
nt = replace(nt, models = $body.models)
tail_nt = self.guide_nonterm(RecordRule(self._solver).distill_cons_tail, nt, $ID.text, body_nt.typ_var)
} tail = record[tail_nt] {
nt = replace(nt, models = $tail.models)
$models = self.collect(RecordRule(self._solver).combine_cons, nt, $ID.text, body_nt.typ_var, tail_nt.typ_var)
}

;

argchain [Nonterm nt] returns [ArgchainAttr attr] :

| '(' {
content_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_single_content, nt) 
} content = expr[content_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, models = $content.models)
$attr = self.collect(ArgchainRule(self._solver).combine_single, nt, content_nt.typ_var)
}


| '(' {
head_nt = self.guide_nonterm(ArgchainRule(self._solver).distill_cons_head, nt) 
} head = expr[head_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, models = $head.models)
} tail = argchain[nt] {
nt = replace(nt, models = $tail.attr.models)
$attr = self.collect(ArgchainRule(self._solver).combine_cons, nt, head_nt.typ_var, $tail.attr.args)
}

;

pipeline [Nonterm nt] returns [list[TVar] cator_vars] :

| '|>' {
content_nt = self.guide_nonterm(PipelineRule(self._solver).distill_single_content, nt) 
} content = expr[content_nt] {
nt = replace(nt, models = content.models)
$cator_vars = self.collect(PipelineRule(self._solver).combine_single, nt, content_nt.typ_var)
}

| '|>' {
head_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_head, nt) 
} head = expr[head_nt] {
nt = replace(nt, models = $head.models)
tail_nt = self.guide_nonterm(PipelineRule(self._solver).distill_cons_tail, nt, head_nt.typ_var) 
} tail = pipeline[tail_nt] {
$cator_vars = self.collect(ArgchainRule(self._solver, nt).combine_cons, nt, head_nt.typ_var, $tail.cator_vars)
}

;


// NOTE: nt.expect represents the type of the rator applied to the next immediate argument  
keychain [Nonterm nt] returns [list[str] keys] :

| '.' {
self.guide_terminal('ID')
} ID {
$keys = self.collect(KeychainRule(self._solver).combine_single, nt, $ID.text)
}

| '.' {
self.guide_terminal('ID')
} ID {
} tail = keychain[nt] {
$keys = self.collect(KeychainRule(self._solver).combine_cons, nt, $ID.text, $tail.keys)
}

;

target [Nonterm nt] returns [list[Models] models]:

| '=' {
expr_nt = self.guide_nonterm(lambda: nt)
} expr[expr_nt] {
$models = $expr.models
}

;



pattern [Nonterm nt] returns [PatternAttr attr]:  

| base_pattern[nt] {
$attr = $base_pattern.attr
}

| {
head_nt = self.guide_nonterm(PatternRule(self._solver).distill_tuple_head, nt)
} head = base_pattern[head_nt] {
self.guide_symbol(',')
} ',' {
nt = replace(nt, enviro =  $head.attr.enviro, models = $head.attr.models)
tail_nt = self.guide_nonterm(PatternRule(self._solver).distill_tuple_tail, nt, $head.attr.typ)
} tail = pattern[tail_nt] {
$attr = self.collect(PatternRule(self._solver, nt).combine_tuple, $head.attr.typ, $tail.attr.typ) 
}

;

base_pattern [Nonterm nt] returns [PatternAttr attr]:  

| ID {
$attr = self.collect(BasePatternRule(self._solver).combine_var, nt, $ID.text)
} 

| ID {
$attr = self.collect(BasePatternRule(self._solver).combine_var, nt, $ID.text)
} 

| '@' {
$attr = self.collect(BasePatternRule(self._solver).combine_unit, nt)
} 

| '~' {
self.guide_terminal('ID')
} ID {
body_nt = self.guide_nonterm(BasePatternRule(self._solver).distill_tag_body, nt, $ID.text)
} body = base_pattern[body_nt] {

nt = replace(nt, enviro =  $body.attr.enviro, models = $body.attr.models)
$attr = self.collect(BasePatternRule(self._solver).combine_tag, nt, $ID.text, $body.attr.typ)
}

| record_pattern[nt] {
$attr = $record_pattern.attr
}

| '(' pattern[nt] ')' {
$attr = $pattern.attr
}


;

record_pattern [Nonterm nt] returns [PatternAttr attr] :

| '_.' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
body_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_single_body, nt, $ID.text)
} body = pattern[body_nt] {
nt = replace(nt, enviro = $body.attr.enviro, models = $body.attr.models)
$attr = self.collect(RecordPatternRule(self._solver).combine_single, nt, $ID.text, $body.attr.typ)
}

| '_.' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {

body_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_cons_body, nt, $ID.text)
} body = pattern[body_nt] {

nt = replace(nt, enviro = $body.attr.enviro, models = $body.attr.models)
tail_nt = self.guide_nonterm(RecordPatternRule(self._solver).distill_cons_tail, nt, $ID.text, $body.attr.typ)
} tail = record_pattern[tail_nt] {

nt = replace(nt, enviro = $tail.attr.enviro, models = $tail.attr.models)
$attr = self.collect(RecordPatternRule(self._solver, nt).combine_cons, nt, $ID.text, $body.attr.typ, $tail.attr.typ)
}

;



ID : [a-zA-Z][_a-zA-Z]* ;
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
