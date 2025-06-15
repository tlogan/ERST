grammar Slim;

@header {
from dataclasses import dataclass
from typing import *
from tapas.util_system import box, unbox
from contextlib import contextmanager

from tapas.slim.analyzer import * 

from pyrsistent.typing import PMap, PSet 
from pyrsistent import m, s, pmap, pset

}


@parser::members {

_solver : Solver 
_cache : dict[int, str] = {}

_guidance : Guidance 
_overflow = False  
_light_mode : bool  

_syntax_rules : PSet[SyntaxRule] = s() 

def init(self, light_mode = False): 
    self._cache = {}
    self._guidance = [default_context]
    self._overflow = False  
    self._light_mode = light_mode  

def reset(self): 
    self._guidance = [default_context]
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()

def filter(self, i, rs):
    return [
        r
        for r in rs  
        if r.pid == i
    ]


def get_syntax_rules(self):
    return self._syntax_rules

def update_sr(self, head : str, body : list[Union[Nonterm, Termin]]):
    rule = SyntaxRule(head, tuple(body))
    self._syntax_rules = self._syntax_rules.add(rule)

def getGuidance(self):
    return self._guidance

def getSolver(self):
    return self._solver

def tokenIndex(self):
    return self.getCurrentToken().tokenIndex


}


ids returns [tuple[str, ...] combo] :

| ID {
$combo = tuple([$ID.text])
}

| ID ids {
$combo = tuple([$ID.text]) + $ids.combo
}

;

preamble returns [PMap[str, Typ] aliasing] :

| 'alias' ID '=' typ {
$aliasing = m().set($ID.text, $typ.combo)
}

| 'alias' ID '=' typ preamble{
$aliasing = $preamble.aliasing.set($ID.text, $typ.combo)
}

;

program [list[Context] contexts] returns [list[Result] results] :

| preamble {
self._solver = Solver($preamble.aliasing if $preamble.aliasing else m())
} expr[contexts] {
$results = $expr.results
}

| expr[contexts] {
self._solver = Solver(m())
$results = $expr.results
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
// | '~' ID typ_base {
// $combo = TTag($ID.text, $typ_base.combo) 
// }

// TEntry 
// | ID ':' typ_base {
// $combo = TEntry($ID.text, $typ_base.combo) 
// }

// TEntry 
| '<' ID '>' typ_base {
$combo = TEntry($ID.text, $typ_base.combo) 
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
$combo = Inter(TEntry('head', $typ_base.combo), TEntry('tail', $typ.combo)) 
}

// Existential unconstrained 
| 'EXI' '[' ids ']' typ {
$combo = Exi($ids.combo, (), $typ.combo) 
}

// // Existential 
// | 'EXI' '[' qualification ']' typ {
// $combo = Exi((), $qualification.combo, $typ.combo) 
// }

// Existential 
| 'EXI' '[' ids qualification ']' typ {
$combo = Exi($ids.combo, $qualification.combo, $typ.combo) 
}

// // Universal unconstrained 
// | 'ALL' '[' ID ']' body = typ {
// $combo = All($ID.text, Top(), $body.combo) 
// }

// // Universal 
// | 'ALL' '[' ID '<:' upper = typ ']' body = typ {
// $combo = All($ID.text, $upper.combo, $body.combo) 
// }

///////////////

// Universal unconstrained 
| 'ALL' '[' ids ']' typ {
$combo = All($ids.combo, (), $typ.combo) 
}

// Universal 
| 'ALL' '[' ids qualification ']' typ {
$combo = All($ids.combo, $qualification.combo, $typ.combo) 
}



| 'LFP' '[' ID ']' typ {
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

expr [list[Context] contexts] returns [list[Result] results] : 

// Base rules

| base[contexts] {
$results = $base.results
}

| head = base[contexts] ',' {
tail_contexts = [
    Context(contexts[head_result.pid].enviro, head_result.world)
    for head_result in $head.results 
] 
}
tail = expr[tail_contexts] {
$results = [
    ExprRule(self._solver).combine_tuple(
        pid, 
        tail_result.world, 
        head_result.typ, 
        tail_result.typ
    ) 
    for tail_result in $tail.results 
    for head_result in [$head.results[tail_result.pid]]
    for pid in [head_result.pid]
]
}

| 'if' condition = expr[contexts] 'then' {
branch_contexts = [
    Context(contexts[conditionr.pid].enviro, conditionr.world)
    for conditionr in $condition.results
]
} 
true_branch = expr[branch_contexts]
'else'
false_branch = expr[branch_contexts] {
$results = [
    result
    for condition_id, condition_result in enumerate($condition.results)
    for true_branch_results in [self.filter(condition_id, $true_branch.results)]
    for false_branch_results in [self.filter(condition_id, $false_branch.results)]
    for pid in [condition_result.pid]
    for result in ExprRule(self._solver).combine_ite(
        pid,  
        contexts[pid].enviro,
        condition_result.world,
        condition_result.typ,
        true_branch_results,
        false_branch_results,
    )
]
} 

// the rator below refers to the record being projected from
| rator = base[contexts] keychain {
$results = [
    result
    for rator_result in $rator.results
    for pid in [rator_result.pid]
    for result in ExprRule(self._solver).combine_projection(
        pid,
        rator_result.world,
        rator_result.typ,
        $keychain.keys
    ) 
]
}

| cator = base[contexts] {
argchain_contexts = [
    Context(contexts[cator_result.pid].enviro, cator_result.world)
    for cator_result in $cator.results 
]
} argchain[argchain_contexts] {
$results = [
    result 
    for argchain_result in $argchain.results
    for cator_result in [$cator.results[argchain_result.pid]]
    for pid in [cator_result.pid]
    for result in ExprRule(self._solver).combine_application(
        pid,
        argchain_result.world,
        cator_result.typ,
        argchain_result.typs,
    )
]
}

| arg = base[contexts] {
pipeline_contexts = [
    Context(contexts[arg_result.pid].enviro, arg_result.world)
    for arg_result in $arg.results 
]
} pipeline[pipeline_contexts] {
$results = [
    result
    for pipeline_result in $pipeline.results 
    for arg_result in [$arg.results[pipeline_result.pid]]
    for pid in [arg_result.pid]
    for result in ExprRule(self._solver).combine_funnel(
        pid,
        pipeline_result.world,
        arg_result.typ,
        pipeline_result.typs
    )
]
}

| 'let' ID target[contexts] 'in' {
contin_contexts = [
    Context(enviro, world)
    for target_result in $target.results
    for enviro in [contexts[target_result.pid].enviro.set($ID.text, target_result.typ)]
    for world in [target_result.world]
]
} contin = expr[contin_contexts] {
$results = [
    Result(pid, contin_result.world, contin_result.typ)
    for contin_result in $contin.results
    for target_result in [$target.results[contin_result.pid]]
    for pid in [target_result.pid]
]
}

| 'fix' '(' body = expr[contexts] ')' {
$results = [
    ExprRule(self._solver).combine_fix(
        pid,
        contexts[pid].enviro,
        body_result.world,
        body_result.typ
    )
    for body_result in $body.results 
    for pid in [body_result.pid]
]
}

;

base [list[Context] contexts] returns [list[Result] results] : 
// Introduction rules

| '@' {
$results = [
    BaseRule(self._solver).combine_unit(pid, context.world)
    for pid, context in enumerate(contexts)
]
} 

//tag
| '~' ID body = base[contexts] {
$results = [
    BaseRule(self._solver).combine_tag(pid, body_result.world, $ID.text, body_result.typ)
    for body_result in $body.results
    for pid in [body_result.pid]
]
}

| record[contexts] {
$results = $record.results 
}

| {
} function[contexts] {
$results = [
    BaseRule(self._solver).combine_function(pid, contexts[pid].enviro, function_result.world, function_result.branches)
    for function_result in $function.results
    for pid in [function_result.pid]
]
}

// Elimination rules

| ID {
$results = [
    result
    for pid, context in enumerate(contexts)
    for result in BaseRule(self._solver).combine_var(pid, context.enviro, context.world, $ID.text)
]
} 

| argchain[contexts] {
$results = [
    result
    for argchain_result in $argchain.results
    for pid in [argchain_result.pid]
    for result in BaseRule(self._solver).combine_assoc(pid, argchain_result.world, argchain_result.typs)
]
} 

;


record [list[Context] contexts] returns [list[Result] results] :
| ';'  ID '=' 
body = expr[contexts] {
$results = [
    RecordRule(self._solver).combine_single(pid, contexts[pid].enviro, body_result.world, $ID.text, body_result.typ)
    for body_result in $body.results
    for pid in [body_result.pid]
]
}

| ';' ID '=' 
body = expr[contexts] {
tail_contexts = [
    Context(contexts[body_result.pid].enviro, body_result.world)
    for body_result in $body.results
]
} 
tail = record[tail_contexts] {
$results = [
    RecordRule(self._solver).combine_cons(pid, contexts[pid].enviro, tail_result.world, $ID.text, body_result.typ, tail_result.branches) 
    for tail_result in $tail.results
    for body_result in [$body.results[tail_result.pid]]
    for pid in [body_result.pid]
]
}

;


function [list[Context] contexts] returns [list[Switch] results] :

| 'case' pattern '=>' {
body_contexts = [
    Context(context.enviro.update($pattern.result.enviro), context.world)
    for context in contexts 
]
} body = expr[body_contexts] {
$results = [
    FunctionRule(self._solver).combine_single(pid, context.world, $pattern.result.typ, body_results)
    for pid, context in enumerate(contexts)
    for body_results in [self.filter(pid, $body.results)]
]
}

| 'case' pattern  '=>' {
body_contexts = [
    Context(context.enviro.update($pattern.result.enviro), context.world)
    for context in contexts 
]
} 
body = expr[body_contexts]
tail = function[contexts] 
{
$results = [
    FunctionRule(self._solver).combine_cons(pid, context.world, $pattern.result.typ, body_results, tail_result)
    for pid, context in enumerate(contexts)
    for body_results in [self.filter(pid, $body.results)]
    for tail_result in [$tail.results[pid]]
]
}

;

// NOTE: nt.expect represents the type of the rator applied to the next immediate argument  
keychain returns [Keychain keys] :

| '.'  ID {
$keys = KeychainRule(self._solver).combine_single($ID.text)
}

| '.' ID {
} tail = keychain {
$keys = KeychainRule(self._solver).combine_cons($ID.text, $tail.keys)
}

;

argchain [list[Context] contexts] returns [list[ArgchainResult] results] :

| '(' content = expr[contexts] ')' {
$results = [
    ArgchainRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
    for content_result in $content.results 
    for pid in [content_result.pid]
]
}


| '(' head = expr[contexts] ')' {
tail_contexts = [
    Context(contexts[head_result.pid].enviro, head_result.world)
    for head_result in $head.results
]
} tail = argchain[tail_contexts] {
$results = [
    ArgchainRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
    for tail_result in $tail.results 
    for head_result in [$head.results[tail_result.pid]]
    for pid in [head_result.pid]
]
}

;

pipeline [list[Context] contexts] returns [list[PipelineResult] results] :

| '|>' content = expr[contexts] {
$results = [
    PipelineRule(self._solver).combine_single(pid, content_result.world, content_result.typ)
    for content_result in $content.results 
    for pid in [content_result.pid]
]
}

| '|>' head = expr[contexts] {
tail_contexts = [
    Context(contexts[head_result.pid].enviro, head_result.world)
    for head_result in $head.results
]
} tail = pipeline[tail_contexts] 
{
$results = [
    PipelineRule(self._solver).combine_cons(pid, tail_result.world, head_result.typ, tail_result.typs)
    for tail_result in $tail.results 
    for head_result in [$head.results[tail_result.pid]]
    for pid in [head_result.pid]
]
}

;


target [list[Context] contexts] returns [list[Result] results]:

| '=' expr[contexts] {
$results = $expr.results
}

| ':' typ '=' expr[contexts] {
$results = [
    Result(expr_result.pid, expr_result.world, expr_result.typ)
    for expr_result in $expr.results 
]
}
;



pattern returns [PatternResult result]:  

| base_pattern {
$result = $base_pattern.result
}

| {
} 
head = base_pattern  ',' 
tail = pattern {
$result = PatternRule(self._solver).combine_tuple($head.result, $tail.result)
}

;

base_pattern returns [PatternResult result]:  

| ID {
$result = BasePatternRule(self._solver).combine_var($ID.text)
} 

| '@' {
$result = BasePatternRule(self._solver).combine_unit()
} 

| '~' ID
body = base_pattern {
$result = BasePatternRule(self._solver).combine_tag($ID.text, $body.result)
}

| record_pattern {
$result = $record_pattern.result
}

| '(' pattern ')' {
$result = $pattern.result
}


;

record_pattern returns [PatternResult result] :

| ';' ID '=' body = pattern {
$result = RecordPatternRule(self._solver, self._light_mode).combine_single($ID.text, $body.result)
}

| ';' ID '=' 
body = pattern
tail = record_pattern {
$result = RecordPatternRule(self._solver).combine_cons($ID.text, $body.result, $tail.result)
}

;



ID : [a-zA-Z][0-9_a-zA-Z]* ;
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
//     if not hasresult(self, '_map'):
//         setresult(self, '_map', {})
//     return self._map
    
// @memory.setter
// def memory_setter(self, value):
//     if not hasresult(self, '_map'):
//         setresult(self, '_map', {})
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
