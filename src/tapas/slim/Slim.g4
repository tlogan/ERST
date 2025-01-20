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
    self._guidance = [Prompt(default_context, [])]
    self._overflow = False  
    self._light_mode = light_mode  

def reset(self): 
    self._guidance = [Instane(default_context, [])]
    self._overflow = False
    # self.getCurrentToken()
    # self.getTokenStream()


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
    args = [Context(prompt.world, prompt.enviro)] + prompt.args
    for arg in args:
        if arg == None:
            self._overflow = True

    result_context = None
    if not self._overflow:
        result_context = f(*args)
        self._guidance = result_nt

        tok = self.getCurrentToken()
        if tok.type == self.EOF :
            self._overflow = True 

    return Prompt(result_context.world, result_context.enviro, [])



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
    args = [Context(prompt.world, prompt.enviro)] + prompt.args

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

program [list[Prompts] prompts] returns [list[MultiResult] mrs] :

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

expr [list[Prompts] prompts] returns [list[MultiResult] mrs] : 

// Base rules

| base[prompts] {
$mrs = $base.mrs
self.update_sr('expr', [n('base')])
}

| {
head_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_tuple_head, prompt)
    for prompt in prompts 
]
} head = base[head_prompts] {
self.guide_symbol(',')
} ',' {
prompts = [
    replace(prompts[i], 
        world = head_result.world,
        args = prompts[i].args + [head_result.typ]
    )
    for i in len(prompts) 
    for head_result in $head.mrs[i]
] 
tail_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_tuple_tail, prompt)
    for prompt in prompts
]
} tail = expr[tail_contexts] {
prompts = [
    replace(prompts[i], 
        world = tail_result.world,
        args = prompts[i].args + [tail_result.typ]
    )
    for i in len(prompts)
    for tail_result in $tail.mrs[i]
] 

$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_tuple, prompt) 
    for prompt in prompts
]
self.update_sr('expr', [n('base'), t(','), n('expr')])
}

| 'if' {
condition_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_condition, prompt)
    for prompt in prompt
]
} condition = expr[condition_prompts] {
self.guide_symbol('then')
} 'then' {
prompts = [
    replace(prompts[i], 
        world = condition_result.world,
        args = prompts[i].args + [condition_result.typ]
    )
    for i in len(prompts)
    for condition_result in $condition.mrs[i] 
]
true_branch_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_true_branch, prompt)
    for prompt in prompt
]
} true_branch = expr[true_branch_prompt] {
self.guide_symbol('else')
} 'else' {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$true_branch.mrs[i]]
    )
    for i in len(prompts)
]
false_branch_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_ite_false_branch, prompt)
    for prompt in prompts
]
} false_branch = expr[false_branch_prompts] {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$false_branch.mrs[i]]
    )
    for i in len(prompts)
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_ite, prompts, prompt)
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
    replace(prompts[i], 
        world = rator_result.world
        args = prompts[i].args + [rator_result.typ]
    )
    for i in len(prompts)
    for rator_result in $rator.mrs[i]
]
keychain_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_projection_keychain, prompt)
    for prompt in prompts
]
} keychain {
prompts = [
    replace(prompt, 
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
prompts = [
    replace(prompts[i], 
        worlds = caotr_result.world
        args = prompts[i].args + [cator_result.typ]
    )
    for i in len(prompts)
    for cator_result in $cator.mrs[i] 
]
argchain_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_application_argchain, prompt)
    for prompt in prompt
]
} argchain[argchain_prompts] {
prompts = [
    replace(prompts[i], 
        worlds = argchain_attr.world,
        args = prompts[i].args + [$argchain.attrs[i].args]
    )
    for i in len(prompts)
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
    replace(prompts[i], 
        world = arg_result.worlds
        args = prompts[i].args + [arg_result.typ]
    )
    for i in len(prompts)
    for arg_result in $arg.mrs[i]
]
pipeline_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_funnel_pipeline, prompts)
    for prompt in prompts
]
} pipeline[pipeline_prompts] {
prompts = [
    replace(prompts[i], 
        world = pipeline_attr.worlds
        args = prompts[i].args + [$pipeline.attrs[i].cators]
    )
    for i in len(prompts)
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
prompts = [
    replace(prompt, 
        args = prompt.args + [$ID.text]
    )
    for prompt in prompts
]
target_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_let_target, prompts)
    for prompt in prompts
]
} target[target_prompts] {
self.guide_symbol('in')
} 'in' {
prompts = [
    replace(prompts[i], 
        world = target_result.world
        args = prompts[i].args + [target_result.typ]
    )
    for i in len(prompts)
    for target_result in $target.mrs[i]
]
contin_prompts = [
    self.refine_prompt(ExprRule(self._solver, self._light_mode).distill_let_contin, prompt)
    for prompt in prompt
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
    replace(prompts[i], 
        world = body_result.world
        args = prompts[i].args + [body_result.typ]
    )
    for i in len(prompts)
    for body_result in $body.mrs[i]
]
$mrs = [
    self.collect(ExprRule(self._solver, self._light_mode).combine_fix, prompt)
    for prompt in prompts
]
self.update_sr('expr', [t('fix'), t('('), n('expr'), t(')')])
}

;

base [list[Prompt] prompts] returns [list[MultiResult] mrs] : 
// Introduction rules

| '@' {
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_unit, prompt)
    for prompt in prompts
]
self.update_sr('base', [t('@')])
} 

//tag
| '~' {
self.guide_terminal('ID')
} ID {
prompts = [
    replace(prompt, 
        args = prompt.args + [$ID.text]
    )
    for prompt in prompts
]
body_prompts = [
    self.refine_prompt(BaseRule(self._solver, self._light_mode).distill_tag_body, prompt)
    for prompt in prompts
]
} body = base[body_prompts] {
prompts = [
    replace(prompts[i], 
        world = body_result.world
        args = prompts[i].args + [body_result.typ]
    )
    for i in len(prompts)
    for body_result in $body.mrs[i]
]
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_tag, prompts)
    for prompt in prompts
]
self.update_sr('base', [t('~'), ID, n('base')])
}

| record[prompts] {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$record.switches[i]]
    )
    for i in len(prompts)
]
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_record, prompts)
    for prompts in prompt
]
self.update_sr('base', [n('record')])
}

| {
} function[prompts] {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$function.switches[i]]
    )
    for i in len(prompts)
]
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_function, prompts)
    for prompt in prompts
]
self.update_sr('base', [n('function')])
}

// Elimination rules

| ID {
prompts = [
    replace(prompt, 
        args = prompt.args + [$ID.text]
    )
    for prompt in prompts
]
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_var, prompt)
    for prompt in prompts
]
self.update_sr('base', [ID])
} 

| argchain[prompts] {
prompts = [
    replace(prompts[i], 
        worlds = argchain_attr.worlds,
        args = prompts[i].args + [$argchain.attrs[i].args]
    )
    for i in len(prompts)
]
$mrs = [
    self.collect(BaseRule(self._solver, self._light_mode).combine_assoc, prompt)
    for prompt in prompts
]
self.update_sr('base', [n('argchain')])
} 

;


record [list[Prompt] prompts] returns [list[RecordSwitch] switches] :
| ';' {
self.guide_terminal('ID')
} ID {
prompts = [
    replace(prompts, 
        args = prompt.args + [$ID.text]
    )
    for prompt in prompts
]
self.guide_symbol('=')
} '=' {
sub_prompts = [
    replace(prompt, args = [])
    for prompt in prompts
]
} body = expr[sub_prompts] {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$body.mrs[i]]
    )
    for i in len(prompts)
]

$switches = [
    self.collect(RecordRule(self._solver, self._light_mode).combine_single, prompt)
    for prompt in prompt
]
self.update_sr('record', [SEMI, ID, t('='), n('expr')])
}

| ';' {
self.guide_terminal('ID')
} ID {
prompts = [
    replace(prompts, 
        args = prompt.args + [$ID.text]
    )
    for prompt in prompts
]
self.guide_symbol('=')
} '=' {
sub_prompts = [
    replace(prompt, args = [])
    for prompt in prompts
]
} body = expr[sub_prompts] {

prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$body.mrs[i]]
    )
    for i in len(prompts)
]

sub_prompts = [
    replace(prompt, args = [])
    for prompt in prompts
]
} tail = record[sub_prompts] {

prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$tail.switches[i]]
    )
    for i in len(prompts)
]
$switches = [
    self.collect(RecordRule(self._solver, self._light_mode).combine_cons, prompt) 
    for prompt in prompts
]
self.update_sr('record', [SEMI, ID, t('='), n('expr'), n('record')])
}

;


function [list[Prompt] prompts] returns [list[Switch] switches] :

| 'case' {
} pattern {
self.guide_symbol('=>')
} '=>' {
prompts = [
    replace(prompt, 
        args = prompt.args + [$pattern.attr]
    )
    for prompt in prompts
]
body_prompts = [
    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_single_body, prompt)
    for prompt in prompts
]
} body = expr[body_prompts] {
prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$body.mrs[i]]
    )
    for i in len(prompts)
]
$switches = [
    self.collect(FunctionRule(self._solver, self._light_mode).combine_single, prompt)
    for prompt in prompts
]
self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr')])
}

| 'case' {
} pattern {
self.guide_symbol('=>')
} '=>' {
prompts = [
    replace(prompt, 
        args = prompt.args + [$pattern.attr]
    )
    for prompt in prompts
]
body_prompts = [
    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_cons_body, prompt)
    for prompt in prompts
]
} body = expr[body_prompts] {

prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$body.mrs[i]]
    )
    for i in len(prompts)
]
tail_prompts = [
    self.refine_prompt(FunctionRule(self._solver, self._light_mode).distill_cons_tail, prompt)
    for prompt in prompts
]
} tail = function[tail_prompts] {

prompts = [
    replace(prompts[i], 
        args = prompts[i].args + [$tail.switches[i]]
    )
    for i in len(prompts)
]
$switches = [
    self.collect(FunctionRule(self._solver, self._light_mode).combine_cons, prompt)
    for prompt in prompts 
]
self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr'), n('function')])
}

;

// NOTE: nt.expect represents the type of the rator applied to the next immediate argument  
keychain returns [Keychain keys] :

| '.' {
self.guide_terminal('ID')
} ID {
$keys = KeychainRule(self._solver, self._light_mode).combine_single($ID.text)
self.update_sr('keychain', [t('.'), ID])
}

| '.' {
self.guide_terminal('ID')
} ID {
} tail = keychain {
$keys = KeychainRule(self._solver, self._light_mode).combine_cons($ID.text, $tail.keys)
self.update_sr('keychain', [t('.'), ID, n('keychain')])
}

;

argchain [list[Prompt] prompts] returns [list[ArgchainAttr] attrs] :

| '(' {
content_prompts = self.refine_prompt(ArgchainRule(self._solver, self._light_mode).distill_single_content, prompts) 
} content = expr[content_prompts] {
self.guide_symbol(')')
} ')' {
prompts = [
    replace(prompts[i], 
        world = content_result.world
        args = prompts[i].args + [content_result.typ]
    )
    for i in len(prompts)
    for content_result in $content.mrs[i]
]
$attrs = [
    self.collect(ArgchainRule(self._solver, self._light_mode).combine_single, prompts)
    for prompt in prompts
]
self.update_sr('argchain', [t('('), n('expr'), t(')')])
}


| '(' {
head_prompts = [
    self.refine_prompt(ArgchainRule(self._solver, self._light_mode).distill_cons_head, prompt) 
    for prompt in prompts
]
} head = expr[head_prompts] {
self.guide_symbol(')')
} ')' {
prompts = [
    replace(prompts[i], 
        world = head_result.world
        args = prompts[i].args + [head_result.typ]
    )
    for i in len(prompts)
    for head_result in $head.mrs[i]
]
tail_prompts = [
    replace(prompt, args = [])
    prompt in prompts
] 
} tail = argchain[tail_prompts] {
prompts = [
    replace(prompts[i], 
        world = tail_attr.world
        args = prompts[i].args + [$tail.attrs[i].args]
    )
    for i in len(prompts)
]
$attrs = [
    self.collect(ArgchainRule(self._solver, self._light_mode).combine_cons, prompt)
    for prompt in prompts
]
self.update_sr('argchain', [t('('), n('expr'), t(')'), n('argchain')])
}

;

pipeline [list[Prompts] prompts] returns [list[PipelineAttr] attrs] :

| '|>' {
content_prompts = [
    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_single_content, prompt)
    for prompt in prompts
]
} content = expr[content_prompts] {
prompts = [
    replace(prompts[i], 
        worlds = content_result.world,
        args = prompts[i].args + [content_result.typ]
    )
    for i in len(prompts)
    for content_result in $content.mrs[i]
]
$attrs = [
    self.collect(PipelineRule(self._solver, self._light_mode).combine_single, prompt)
    for prompt in prompts
]
self.update_sr('pipeline', [t('|>'), n('expr')])
}

| '|>' {
head_prompts = [
    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_cons_head, prompt) 
    for prompt in prompts
]
} head = expr[head_prompts] {
prompts = [
    replace(prompts[i], 
        worlds = head_result.world,
        args = prompts[i].args + [head_result.typ]
    )
    for i in len(prompts)
    for head_result in $head.mrs[i]
]
tail_prompts = [
    self.refine_prompt(PipelineRule(self._solver, self._light_mode).distill_cons_tail, prompt) 
    for prompt in prompts
]
} tail = pipeline[tail_prompts] {
prompts = [
    replace(prompts[i], 
        worlds = tail_attr.world,
        args = prompts[i].args + [$tail.attrs[i].cators]
    )
    for i in len(prompts)
]
$attrs = [
    self.collect(ArgchainRule(self._solver, self._light_mode, prompts).combine_cons, prompt)
    for prompt in prompt
]
self.update_sr('pipeline', [t('|>'), n('expr'), n('pipeline')])
}

;


target [list[Prompt] prompts] returns [list[MultiResult] mrs]:

| '=' {
} expr[prompts] {
$mrs = $expr.mrs
self.update_sr('target', [t('='), n('expr')])
}

| ':' typ '=' {
} expr[prompts] {
prompts = [
    replace(prompts[i], 
        worlds = expr_result.world,
        args = prompts[i].args + [$typ.combo]
    )
    for i in len(prompts)
    for expr_result in $expr.mrs[i]
]
$mrs = [
    self.collect(TargetRule(self._solver, self._light_mode).combine_anno, prompts) 
    for prompt in prompts
]
self.update_sr('target', [t(':'), TID, t('='), n('expr')])
}
;



pattern returns [PatternAttr attr]:  

| base_pattern {
$attr = $base_pattern.attr
self.update_sr('pattern', [n('basepat')])
}

| {
} head = base_pattern {
self.guide_symbol(',')
} ',' {
} tail = pattern {
$attr = PatternRule(self._solver, self._light_mode).combine_tuple($head.attr, $tail.attr)
self.update_sr('pattern', [n('basepat'), t(','), n('pattern')])
}

;

base_pattern returns [PatternAttr attr]:  

| ID {
$attr = BasePatternRule(self._solver, self._light_mode).combine_var($ID.text)
self.update_sr('basepat', [ID])
} 

| '@' {
$attr = BasePatternRule(self._solver, self._light_mode).combine_unit()
self.update_sr('basepat', [t('@')])
} 

| '~' {
self.guide_terminal('ID')
} ID {
} body = base_pattern {
$attr = BasePatternRule(self._solver, self._light_mode).combine_tag($ID.text, $body.attr)
self.update_sr('basepat', [t('~'), ID, n('basepat')])
}

| record_pattern {
$attr = $record_pattern.attr
self.update_sr('basepat', [n('recpat')])
}

| '(' pattern ')' {
$attr = $pattern.attr
self.update_sr('basepat', [t('('), n('pattern'), t(')')])
}


;

record_pattern returns [PatternAttr attr] :

| ';' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
} body = pattern {
$attr = RecordPatternRule(self._solver, self._light_mode).combine_single($ID.text, $body.attr)
self.update_sr('recpat', [SEMI, ID, t('='), n('pattern')])
}

| ';' {
self.guide_terminal('ID')
} ID {
} '=' {
} body = pattern {
} tail = record_pattern {
$attr = RecordPatternRule(self._solver, self._light_mode, prompts).combine_cons($ID.text, $body.attr, $tail.attr)
self.update_sr('recpat', [SEMI, ID, t('='), n('pattern'), n('recpat')])
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
