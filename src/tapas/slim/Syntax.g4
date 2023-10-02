grammar Syntax;
import Lexicon;

expr : 
    | ID 
    | '.' 
    | ID ';' expr 
    | ('.' ID '=' expr)+
    | ID ':' expr
    | expr '(' expr ')'
    | 'match' expr ('case' expr ':' expr)+
    | ('fun' expr ':' expr)+
    | 'if' expr 'then' expr 'else' expr
    | 'fix' '(' expr ')'
    | 'let' ID ('in' typ)? '=' expr ':' expr   
    | '(' expr ')'
    ;

typ :
    | 'unit'
    | 'top'
    | 'bot'
    | ID '//' typ 
    | ID 'in' typ 
    | typ '&' typ 
    | typ '*' typ 
    | typ '|' typ 
    | typ '->' typ 
    | '{' ID ('<:' typ)? ('with' typ '<:' typ)* ('#' (ID)+)? '}'
    | '[' ID ('<:' typ)? ']' typ 
    | 'least' ID ':' typ 
    ;