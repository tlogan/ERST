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
    self._guidance = default_context
    self._overflow = False  
    self._light_mode = light_mode  

def reset(self): 
    self._guidance = default_context 
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

def guide_nonterm(self, f : Callable, *args) -> Optional[Context]:
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

preamble returns [PMap[str, Typ] aliasing] :

| 'alias' ID '=' typ {
$aliasing = m().set($ID.text, $typ.combo)
}

| 'alias' ID '=' typ preamble{
$aliasing = $preamble.aliasing.set($ID.text, $typ.combo)
}

;

program [context : Context] returns [Result result] :

| preamble {
self._solver = Solver($preamble.aliasing if $preamble.aliasing else m())
} expr[context] {
$result = $expr.result
}

| expr[context] {
self._solver = Solver(m())
$result = $expr.result
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

expr [Context nt] returns [Result result] : 

// Base rules

| base[nt] {
$result = $base.result
self.update_sr('expr', [n('base')])
}

// Introduction rules

| {
head_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_tuple_head, nt)
} head = base[head_nt] {
self.guide_symbol(',')
} ',' {
nt = replace(nt, worlds = $head.result.worlds)
tail_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_tuple_tail, nt, $head.result.typ)
} tail = expr[tail_nt] {
nt = replace(nt, worlds = $tail.result.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_tuple, nt, $head.result.typ, $tail.result.typ) 
self.update_sr('expr', [n('base'), t(','), n('expr')])
}

// Elimination rules

| 'if' {
condition_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_ite_condition, nt)
} condition = expr[condition_nt] {
self.guide_symbol('then')
} 'then' {
true_branch_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_ite_true_branch, nt, $condition.result.typ)
} true_branch = expr[true_branch_nt] {
self.guide_symbol('else')
} 'else' {
false_branch_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_ite_false_branch, nt, $condition.result.typ, $true_branch.result.typ)
} false_branch = expr[false_branch_nt] {
nt = replace(nt, worlds = $condition.result.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_ite, nt, $condition.result.typ, 
    $true_branch.result.worlds, $true_branch.result.typ, 
    $false_branch.result.worlds, $false_branch.result.typ
) 
self.update_sr('expr', [t('if'), n('expr'), t('then'), n('expr'), t('else'), n('expr')])
} 

// the rator below refers to the record being projected from
| {
rator_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_projection_rator, nt)
} rator = base[rator_nt] {
nt = replace(nt, worlds = $rator.result.worlds)
keychain_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_projection_keychain, nt, $rator.result.typ)
} keychain[keychain_nt] {
nt = replace(nt, worlds = keychain_nt.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_projection, nt, $rator.result.typ, $keychain.keys) 
self.update_sr('expr', [n('base'), n('keychain')])
}

| {
cator_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_application_cator, nt)
} cator = base[cator_nt] {
nt = replace(nt, worlds = $cator.result.worlds)
argchain_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_application_argchain, nt, $cator.result.typ)
} argchain[argchain_nt] {
nt = replace(nt, worlds = $argchain.attr.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_application, nt, $cator.result.typ, $argchain.attr.args)
self.update_sr('expr', [n('base'), n('argchain')])
}

| {
arg_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_funnel_arg, nt)
} arg = base[arg_nt] {
nt = replace(nt, worlds = $arg.result.worlds)
pipeline_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_funnel_pipeline, nt, $arg.result.typ)
} pipeline[pipeline_nt] {
nt = replace(nt, worlds = $pipeline.attr.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_funnel, nt, $arg.result.typ, $pipeline.attr.cators)
self.update_sr('expr', [n('base'), n('pipeline')])
}

| 'let' {
self.guide_terminal('ID')
} ID {
target_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_let_target, nt, $ID.text)
} target[target_nt] {
self.guide_symbol('in')
} 'in' {
nt = replace(nt, worlds = $target.result.worlds)
contin_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_let_contin, nt, $ID.text, $target.result.typ)
} contin = expr[contin_nt] {
$result = $contin.result
self.update_sr('expr', [t('let'), ID, n('target'), t('in'), n('expr')])
}

| 'fix' {
self.guide_symbol('(')
} '(' {
body_nt = self.guide_nonterm(ExprRule(self._solver, self._light_mode).distill_fix_body, nt)
} body = expr[body_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, worlds = $body.result.worlds)
$result = self.collect(ExprRule(self._solver, self._light_mode).combine_fix, nt, $body.result.typ)
self.update_sr('expr', [t('fix'), t('('), n('expr'), t(')')])
}

;

base [Context nt] returns [Result result] : 
// Introduction rules

| '@' {
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_unit, nt)
self.update_sr('base', [t('@')])
} 

//tag
| '~' {
self.guide_terminal('ID')
} ID {
body_nt = self.guide_nonterm(BaseRule(self._solver, self._light_mode).distill_tag_body, nt, $ID.text)
} body = base[body_nt] {
nt = replace(nt, worlds = $body.result.worlds)
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_tag, nt, $ID.text, $body.result.typ)
self.update_sr('base', [t('~'), ID, n('base')])
}

| record[nt] {
branches = $record.branches
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_record, nt, branches)
self.update_sr('base', [n('record')])
}

| {
} function[nt] {
branches = $function.branches
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_function, nt, branches)
self.update_sr('base', [n('function')])
}

// Elimination rules

| ID {
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_var, nt, $ID.text)
self.update_sr('base', [ID])
} 

| argchain[nt] {
nt = replace(nt, worlds = $argchain.attr.worlds)
$result = self.collect(BaseRule(self._solver, self._light_mode).combine_assoc, nt, $argchain.attr.args)
self.update_sr('base', [n('argchain')])
} 

;



record [Context nt] returns [list[RecordBranch] branches] :

| ';' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
body_nt = self.guide_nonterm(RecordRule(self._solver, self._light_mode).distill_single_body, nt, $ID.text)
} body = expr[body_nt] {
$branches = self.collect(RecordRule(self._solver, self._light_mode).combine_single, nt, $ID.text, $body.result.worlds, $body.result.typ)
self.update_sr('record', [SEMI, ID, t('='), n('expr')])
}

| ';' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
body_nt = self.guide_nonterm(RecordRule(self._solver, self._light_mode).distill_cons_body, nt, $ID.text)
} body = expr[body_nt] {
tail_nt = self.guide_nonterm(RecordRule(self._solver, self._light_mode).distill_cons_tail, nt, $ID.text, $body.result.typ)
} tail = record[tail_nt] {
tail_branches = $tail.branches
$branches = self.collect(RecordRule(self._solver, self._light_mode).combine_cons, nt, $ID.text, $body.result.worlds, $body.result.typ, tail_branches)
self.update_sr('record', [SEMI, ID, t('='), n('expr'), n('record')])
}

;


function [Context nt] returns [list[Branch] branches] :

| 'case' {
} pattern[nt] {
self.guide_symbol('=>')
} '=>' {
body_nt = self.guide_nonterm(FunctionRule(self._solver, self._light_mode).distill_single_body, nt, $pattern.attr)
} body = expr[body_nt] {
$branches = self.collect(FunctionRule(self._solver, self._light_mode).combine_single, nt, $pattern.attr.typ, $body.result.worlds, $body.result.typ)
self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr')])
}

| 'case' {
} pattern[nt] {
self.guide_symbol('=>')
} '=>' {
body_nt = self.guide_nonterm(FunctionRule(self._solver, self._light_mode).distill_cons_body, nt, $pattern.attr)
} body = expr[body_nt] {
tail_nt = self.guide_nonterm(FunctionRule(self._solver, self._light_mode).distill_cons_tail, nt, $pattern.attr.typ, $body.result.typ)
} tail = function[tail_nt] {
tail_branches = $tail.branches
$branches = self.collect(FunctionRule(self._solver, self._light_mode).combine_cons, nt, $pattern.attr.typ, $body.result.worlds, $body.result.typ, tail_branches)
self.update_sr('function', [t('case'), n('pattern'), t('=>'), n('expr'), n('function')])
}

;

// NOTE: nt.expect represents the type of the rator applied to the next immediate argument  
keychain [Context nt] returns [list[str] keys] :

| '.' {
self.guide_terminal('ID')
} ID {
$keys = self.collect(KeychainRule(self._solver, self._light_mode).combine_single, nt, $ID.text)
self.update_sr('keychain', [t('.'), ID])
}

| '.' {
self.guide_terminal('ID')
} ID {
} tail = keychain[nt] {
$keys = self.collect(KeychainRule(self._solver, self._light_mode).combine_cons, nt, $ID.text, $tail.keys)
self.update_sr('keychain', [t('.'), ID, n('keychain')])
}

;

argchain [Context nt] returns [ArgchainAttr attr] :

| '(' {
content_nt = self.guide_nonterm(ArgchainRule(self._solver, self._light_mode).distill_single_content, nt) 
} content = expr[content_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, worlds = $content.result.worlds)
$attr = self.collect(ArgchainRule(self._solver, self._light_mode).combine_single, nt, $content.result.typ)
self.update_sr('argchain', [t('('), n('expr'), t(')')])
}


| '(' {
head_nt = self.guide_nonterm(ArgchainRule(self._solver, self._light_mode).distill_cons_head, nt) 
} head = expr[head_nt] {
self.guide_symbol(')')
} ')' {
nt = replace(nt, worlds = $head.result.worlds)
} tail = argchain[nt] {
nt = replace(nt, worlds = $tail.attr.worlds)
$attr = self.collect(ArgchainRule(self._solver, self._light_mode).combine_cons, nt, $head.result.typ, $tail.attr.args)
self.update_sr('argchain', [t('('), n('expr'), t(')'), n('argchain')])
}

;

pipeline [Context nt] returns [PipelineAttr attr] :

| '|>' {
content_nt = self.guide_nonterm(PipelineRule(self._solver, self._light_mode).distill_single_content, nt) 
} content = expr[content_nt] {
nt = replace(nt, worlds = $content.result.worlds)
$attr = self.collect(PipelineRule(self._solver, self._light_mode).combine_single, nt, $content.result.typ)
self.update_sr('pipeline', [t('|>'), n('expr')])
}

| '|>' {
head_nt = self.guide_nonterm(PipelineRule(self._solver, self._light_mode).distill_cons_head, nt) 
} head = expr[head_nt] {
nt = replace(nt, worlds = $head.result.worlds)
tail_nt = self.guide_nonterm(PipelineRule(self._solver, self._light_mode).distill_cons_tail, nt, $head.result.typ) 
} tail = pipeline[tail_nt] {
nt = replace(nt, worlds = $tail.attr.worlds)
$attr = self.collect(ArgchainRule(self._solver, self._light_mode, nt).combine_cons, nt, $head.result.typ, $tail.attr.cators)
self.update_sr('pipeline', [t('|>'), n('expr'), n('pipeline')])
}

;


target [Context nt] returns [Result result]:

| '=' {
expr_nt = self.guide_nonterm(lambda: nt)
} expr[expr_nt] {
$result = $expr.result
self.update_sr('target', [t('='), n('expr')])
}

| ':' typ '=' {
expr_nt = self.guide_nonterm(lambda: nt)
} expr[expr_nt] {
nt = replace(nt, worlds = $expr.result.worlds)
$result = self.collect(TargetRule(self._solver, self._light_mode).combine_anno, nt, $typ.combo) 
self.update_sr('target', [t(':'), TID, t('='), n('expr')])
}
;



pattern [Context nt] returns [PatternAttr attr]:  

| base_pattern[nt] {
$attr = $base_pattern.attr
self.update_sr('pattern', [n('basepat')])
}

| {
} head = base_pattern[nt] {
self.guide_symbol(',')
} ',' {
} tail = pattern[nt] {
$attr = self.collect(PatternRule(self._solver, self._light_mode).combine_tuple, nt, $head.attr, $tail.attr) 
self.update_sr('pattern', [n('basepat'), t(','), n('pattern')])
}

;

base_pattern [Context nt] returns [PatternAttr attr]:  

| ID {
$attr = self.collect(BasePatternRule(self._solver, self._light_mode).combine_var, nt, $ID.text)
self.update_sr('basepat', [ID])
} 

| '@' {
$attr = self.collect(BasePatternRule(self._solver, self._light_mode).combine_unit, nt)
self.update_sr('basepat', [t('@')])
} 

| '~' {
self.guide_terminal('ID')
} ID {
} body = base_pattern[nt] {
$attr = self.collect(BasePatternRule(self._solver, self._light_mode).combine_tag, nt, $ID.text, $body.attr)
self.update_sr('basepat', [t('~'), ID, n('basepat')])
}

| record_pattern[nt] {
$attr = $record_pattern.attr
self.update_sr('basepat', [n('recpat')])
}

| '(' pattern[nt] ')' {
$attr = $pattern.attr
self.update_sr('basepat', [t('('), n('pattern'), t(')')])
}


;

record_pattern [Context nt] returns [PatternAttr attr] :

| ';' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
} body = pattern[nt] {
$attr = self.collect(RecordPatternRule(self._solver, self._light_mode).combine_single, nt, $ID.text, $body.attr)
self.update_sr('recpat', [SEMI, ID, t('='), n('pattern')])
}

| ';' {
self.guide_terminal('ID')
} ID {
self.guide_symbol('=')
} '=' {
} body = pattern[nt] {
} tail = record_pattern[nt] {
$attr = self.collect(RecordPatternRule(self._solver, self._light_mode, nt).combine_cons, nt, $ID.text, $body.attr, $tail.attr)
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
