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
    self._guidance = [default_prompt]
    self._overflow = False  
    self._light_mode = light_mode  

def reset(self): 
    self._guidance = [default_prompt]
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()

def flatten(rss):
    return [
        r 
        for rs in rss 
        for r in rs 
    ]

def filter(i, rs):
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

def refine_prompt(self, f : Callable, prompt : Prompt) -> Optional[Prompt]:
    args = [Context(prompt.enviro, prompt.world)] + prompt.args
    for arg in args:
        if arg == None:
            self._overflow = True

    result_context = None
    if not self._overflow:
        result_context = f(*args)
        prompt = Prompt(result_context.enviro, result_context.world, [])
        self._guidance = prompt 

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return prompt




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



def collect(self, f : Callable, prompt : Prompt):
    args = [Context(prompt.enviro, prompt.world)] + prompt.args

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

preamble returns [PMap[str, Typ] aliasing] :

| 'alias' ID '=' typ {
$aliasing = m().set($ID.text, $typ.combo)
}

| 'alias' ID '=' typ preamble{
$aliasing = $preamble.aliasing.set($ID.text, $typ.combo)
}

;

program [list[Prompt] prompts] returns [list[MultiResult] mrs] :

| preamble {
self._solver = Solver($preamble.aliasing if $preamble.aliasing else m())
} expr[prompts] {
$mrs = $expr.mrs
}

| expr[prompts] {
self._solver = Solver(m())
$mrs = $expr.mrs
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



//induction // least fixed point; smallest set such that typ <: ID is invariant
//   
// least self with 
// :zero, :nil |  
// {n, l <: self] succ n, cons l 
| 'FX' ID '|' typ {
$combo = Fixpoint($ID.text, $typ.combo) 
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

expr [list[Contexts] contexts] returns [list[Result] results] : 

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
    r
    for tail_result in $tail.results 
    for head_result in [$head.results[tail_result.pid]]
    for pid in [head_result.pid]
    for r in ExprRule(self._solver).combine_tuple(
        pid, 
        contexts[pid].enviro, 
        tail_result.world, 
        head_result.typ, 
        tail_result.typ
    ) 
]
}

| 'if' condition = expr[contexts] 'then' {
branch_contexts = [
    Context(contexts[conditionr.pid].enviro, conditionr.world)
    for conditionr in $condition.rs
]
} 
true_branch = expr[branch_contexts]
'else'
false_branch = expr[branch_contexts] {
$results = [
    result
    for i, condition_result in enumerate($condition.results)
    for true_branch_results = [filter(i,$true_branch.results)]
    for false_branch_results = [filter(i,$false_branch.results)]
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
    for result in ExprRule(self._solver).combine_projection(
        contexts[rator_result.pid].enviro,
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
    ExprRule(self._solver).combine_application(
        pid,
        contexts[pid].enviro,
        argchain_result.world,
        cator_result.typ,
        argchain_result.typs,
    )
    for argchain_result in $argchain.results
    for cator_result  in [cator_result[argchain_result.pid]]
    for pid in [cator_result.pid]
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
        contexts[pid].enviro,
        pipeline_result.word,
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
    Result(pid, continr.world, continr.typ)
    for contin_result in $contin.results
    for target_result in [$target.results[contin_result.pid]]
    for pid in [target_result.pid]
]
}

| 'fix' {
self.guide_symbol('(')
} '(' {
body_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_fix_body, prompt)
    for prompt in prompts
]
} body = expr[body_prompts] {
self.guide_symbol(')')
} ')' {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = body_result.world,
        args = prompt.args + [body_result.typ]
    )
    for i,prompt in enumerate(prompts)
    for body_result in $body.mrs[i]
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_fix, prompt)
    for prompt in prompts
]
self.update_sr('expr', [t('fix'), t('('), n('expr'), t(')')])
}

;

base [list[Context] contexts] returns [list[MultiEnviroTyp] mets] : 
// Introduction rules

| '@' {
$mets = [
    BaseRule(self._solver).combine_unit(context)
    for context in contexts 
]
self.update_sr('base', [t('@')])
} 

//tag
| '~' {
self.guide_terminal('ID')
} ID {
} body = base[contexts] {
$mets = [
    BaseRule(self._solver).combine_tag, prompt(Context(body_et.enviro, body_et.world), $ID.text, body_et.typ)
    for body_met in $body.mets 
    for body_et in body_met 
]
self.update_sr('base', [t('~'), ID, n('base')])
}

| record[contexts] {
$mets = [
    BaseRule(self._solver).combine_record(Context(switch.enviro, switch.world), switch.branches)
    for switch in $record.switches 
]
self.update_sr('base', [n('record')])
}

| {
} function[prompts] {
$mets = [
    BaseRule(self._solver).combine_function(Context(switch.enviro, switch.world), switch.branches)
    for switch in $function.switches 
]
self.update_sr('base', [n('function')])
}

// Elimination rules

| ID {
$mets = [
    BaseRule(self._solver).combine_var(context, $ID.text)
    for context in contexts 
]
self.update_sr('base', [ID])
} 

| argchain[contexts] {

$mets = [
    BaseRule(self._solver).combine_assoc(Context(attr.enviro,  attr.world), attr.args)
    for attr in $argchain.attrs
]
self.update_sr('base', [n('argchain')])
} 

;


record [list[Context] contexts] returns [list[RecordSwitch] switches] :
| ';'  ID '=' 
body = expr[contexts] {
$switches = [
    RecordRule(self._solver).combine_single($ID.text, met)
    for met in $body.mets 
]
}

| ';' ID '=' 
body = expr[sub_prompts] 
tail = record[sub_prompts] {
$switches = [
    RecordRule(self._solver).combine_cons($ID.text, met, switch) 
    for met in $body.mets 
    for switch in $tail.switches
]
}

;


function [list[Context] contexts] returns [list[Switch] switches] :

| 'case' pattern '=>' {
body_contexts = [
    Context(context.enviro.update($pattern.attr.enviro), prompt.world)
    for context in contexts 
]
} body = expr[body_contexts] {
$switches = [
    FunctionRule(self._solver).combine_single(met)
    for met in $body.mets 
]
}

| 'case' pattern  '=>' {
body_contexts = [
    Context(context.enviro.update($pattern.attr.enviro), prompt.world)
    for context in contexts 
]
} 
body = expr[body_prompts]
tail = function[tail_prompts] 
{

$switches = [
    FunctionRule(self._solver).combine_cons($pattern, met, switch)
    for met in $body.mets 
    for switch in $tail.switches
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

argchain [list[Context] contexts] returns [list[ArgchainAttr] attrs] :

| '(' content = expr[contexts] ')' {
$attrs = [
    ArgchainRule(self._solver).combine_single(et.enviro, et.world, et.typ)
    for met in $content.mets 
    for et in met 
]
}


| '(' head = expr[contexts] ')'  
tail = argchain[tail_prompts] {
$attrs = [
    ArgchainRule(self._solver).combine_cons(et, attr)
    for met in $content.mets 
    for et in met 
    for attr in $tail.attrs
]
}

;

pipeline [list[Context] contexts] returns [list[PipelineAttr] attrs] :

| '|>' content = expr[contexts] {
$attrs = [
    PipelineRule(self._solver).combine_single(et)
    for met in $content.mets
    for et in met 
]
}

| '|>' {
} 
head = expr[head_prompts]
tail = pipeline[tail_prompts] 
{
$attrs = [
    PipelineRule(self._solver).combine_cons(et, attr)
    for met in $content.mets
    for et in met 
    for attr in $tail.attrs
]
}

;


target [list[Context] contexts] returns [list[MultiEnviroTyp] mets]:

| '=' expr[contexts] {
$mets = $expr.mets
}

| ':' typ '=' expr[contexts] {
$mets = [
    TargetRule(self._solver).combine_anno(et) 
    for met in $expr.mets 
    for et in met
]
}
;



pattern returns [PatternAttr attr]:  

| base_pattern {
$attr = $base_pattern.attr
}

| {
} 
head = base_pattern  ',' 
tail = pattern {
$attr = PatternRule(self._solver).combine_tuple($head.attr, $tail.attr)
}

;

base_pattern returns [PatternAttr attr]:  

| ID {
$attr = BasePatternRule(self._solver).combine_var($ID.text)
} 

| '@' {
$attr = BasePatternRule(self._solver).combine_unit()
} 

| '~' ID
body = base_pattern {
$attr = BasePatternRule(self._solver).combine_tag($ID.text, $body.attr)
}

| record_pattern {
$attr = $record_pattern.attr
}

| '(' pattern ')' {
$attr = $pattern.attr
}


;

record_pattern returns [PatternAttr attr] :

| ';' ID '=' body = pattern {
$attr = RecordPatternRule(self._solver, self._light_mode).combine_single($ID.text, $body.attr)
}

| ';' ID '=' 
body = pattern
tail = record_pattern {
$attr = RecordPatternRule(self._solver, self._light_mode, prompts).combine_cons($ID.text, $body.attr, $tail.attr)
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
