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

expr [list[Contexts] contexts] returns [list[MultiResult] rss] : 

// Base rules

| base[contexts] {
$rss = $base.rss
}

| head = base[contexts] ',' {
headrs = flatten($head.rss)
tail_contexts = [
    Context(contexts[headr.index].enviro, headr.world)
    for headr in headrs 
] 
}
tail = expr[tail_contexts] {
$rss = [
    ExprRule(self._solver).combine_tuple(
        headers[i].index, 
        contexts[headrs[i].index].enviro, 
        tailr.world, 
        headrs[i].typ, 
        tailr.typ
    ) 
    for i, tailrs in enumerate($tail.rss)
    for tailr in tailrs 
]
}

| 'if' {
condition_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_condition, prompt)
    for prompt in prompts
]
} condition = expr[condition_prompts] {
self.guide_symbol('then')
} 'then' {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = condition_result.world,
        args = prompt.args + [condition_result.typ]
    )
    for i, prompt in enumerate(prompts)
    for condition_result in $condition.mrs[i] 
]
true_branch_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_true_branch, prompt)
    for prompt in prompts
]
} true_branch = expr[true_branch_prompts] {
self.guide_symbol('else')
} 'else' {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = prompt.world, 
        args = prompt.args + [$true_branch.mrs[i]]
    )
    for i, prompt in enumerate(prompts)
]
false_branch_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_false_branch, prompt)
    for prompt in prompts
]
} false_branch = expr[false_branch_prompts] {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = prompt.world, 
        args = prompt.args + [$false_branch.mrs[i]]
    )
    for i,prompt in enumerate(prompts)
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_ite, prompt)
    for prompt in prompts
]
self.update_sr('expr', [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')])
} 

// the rator below refers to the record being projected from
| {
rator_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_projection_rator, prompt)
    for prompt in prompts
]
} rator = base[rator_prompts] {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = rator_result.world,
        args = prompt.args + [rator_result.typ]
    )
    for i, prompt in enumerate(prompts)
    for rator_result in $rator.mrs[i]
]
keychain_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_projection_keychain, prompt)
    for prompt in prompts
]
} keychain {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = prompt.world,
        args = prompt.args + [$keychain.keys]
    )
    for prompt in prompts
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_projection, prompt) 
    for prompt in prompts
]
self.update_sr('expr', [n('base'), n('keychain')])
}

| {
cator_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_application_cator, prompt)
    for prompt in prompts
]
} cator = base[cator_prompts] {
# THIS DOESN'T MAKE SENSE
argchain_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_application_argchain, Prompt(
        enviro = prompt.enviro, 
        world = cator_result.world,
        args = prompt.args + [cator_result.typ]
    ))
    for i,prompt in enumerate(prompts)
    for cator_result in $cator.mrs[i] 
]
} argchain[argchain_prompts] {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = $argchain.attrs[i].world,
        args = prompt.args + [$argchain.attrs[i].args]
    )
    for i,prompt in enumerate(prompts)
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_application, prompt)
    for prompt in prompts
]
self.update_sr('expr', [n('base'), n('argchain')])
}

| {
arg_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_funnel_arg, prompt)
    for prompt in prompts
]
} arg = base[arg_prompts] {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = arg_result.worlds,
        args = prompt.args + [arg_result.typ]
    )
    for i,prompt in enumerate(prompts)
    for arg_result in $arg.mrs[i]
]
pipeline_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_funnel_pipeline, prompt)
    for prompt in prompts
]
} pipeline[pipeline_prompts] {
prompts = [
    Prompt(
        enviro = prompt.enviro, 
        world = pipeline_attr.worlds,
        args = prompt.args + [$pipeline.attrs[i].cators]
    )
    for i,prompt in enumerate(prompts)
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_funnel, prompts)
    for prompt in prompts
]
self.update_sr('expr', [n('base'), n('pipeline')])
}

| 'let' {
self.guide_terminal('ID')
} ID {
target_prompts = prompts
} target[target_prompts] {
self.guide_symbol('in')
} 'in' {
contin_prompts = [
    Prompt(enviro = result.enviro.set($ID.text, result.typ), world = result.world, args=[])
    for results in $target.mrs
    for result in results 
]
} contin = expr[contin_prompts] {
$mrs = $contin.mrs
self.update_sr('expr', [t('let'), ID, n('target'), t('in'), n('expr')])
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
