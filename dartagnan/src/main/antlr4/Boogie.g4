grammar Boogie;

import BaseLexer;

main
    :    (axiom_decl | const_decl | func_decl | impl_decl | proc_decl |  type_decl | var_decl)* EOF
    ;

axiom_decl
    :   'axiom' attr* proposition Semi
    ;

const_decl
    :   'const' attr* 'unique'? typed_idents order_spec? Semi
    ;

func_decl
    :   'function' attr* Ident type_params? LPar (var_or_type (Comma var_or_type)*)? RPar ( 'returns' LPar var_or_type RPar | Colon type ) ( LBrace expr RBrace | Semi )
    ;

impl_decl
    :   'implementation' proc_sign impl_body
    ;

proc_decl
    :   'procedure' proc_sign ( Semi spec* | spec* impl_body )
    ;

type_decl
    :   'type' attr* Ident Ident* (Equals type)? (Comma Ident Ident* ( Equals type )? )* Semi
    ;

var_decl
    :   'var' attr* typed_idents_wheres Semi
    ;

order_spec
    :   'extends' ( 'unique'? Ident ( Comma 'unique'? Ident )* )? 'complete'?
    ;

var_or_type
    :   attr* ( type | Ident (Colon type)? )
    ;

proc_sign
    :   attr* Ident type_params? LPar attr_typed_idents_wheres? RPar ('returns' LPar attr_typed_idents_wheres? RPar)?
    ;

impl_body
    :   LBrace local_vars* stmt_list RBrace
    ;

stmt_list
    :   ( label_or_cmd | transfer_cmd | structured_cmd )*
    ;

local_vars
    :   'var' attr* typed_idents_wheres Semi
    ;

spec
    :   modifies_spec | requires_spec | ensures_spec
    ;

modifies_spec
    :   'modifies' idents? Semi
    ;

requires_spec
    :  'free'? 'requires' attr* proposition Semi
    ;

ensures_spec
    :  'free'? 'ensures' attr* proposition Semi
    ;

label_or_cmd
    :   assert_cmd | assign_cmd | assume_cmd | call_cmd | havoc_cmd | label | par_call_cmd | yield_cmd
    ;

transfer_cmd
    :   break_cmd | if_cmd | while_cmd
    ;

structured_cmd
    :   goto_cmd | return_cmd
    ;

assert_cmd
    :   'assert' attr* proposition Semi
    ;

assign_cmd
    :   Ident (LBracket exprs? RBracket)* (Comma Ident (LBracket exprs? RBracket )*)* Define exprs Semi
    ;

assume_cmd
    :   'assume' attr* proposition Semi
    ;

break_cmd
    :   'break' Ident Semi
    ;

call_cmd
    :   'async'? 'free'? 'call' attr* call_params Semi
    ;

goto_cmd
    :   'goto' idents Semi
    ;

havoc_cmd
    :   'havoc' idents Semi
    ;

if_cmd
    :   'if' guard LBrace stmt_list RBrace ('else' ( if_cmd | LBrace stmt_list RBrace ))?
    ;

label
    :   Ident Colon
    ;

par_call_cmd
    :   Par attr* call_params (Bar call_params)* Semi
    ;

return_cmd
    :   'return' Semi
    ;

while_cmd
    :   'while' guard ( 'free'? 'invariant' attr* expr Comma )* LBrace stmt_list RBrace
    ;

yield_cmd
    :   'yield' Semi
    ;

call_params
    :   Ident ( LPar exprs? RPar | (Comma idents)? Define Ident LPar exprs? RPar )
    ;

guard
    :   LPar ( Ast | expr ) RPar
    ;

type
    :   type_atom | Ident type_args? | map_type
    ;

type_args
    :   type_atom type_args? | Ident type_args? | map_type
    ;

type_atom
    :   'int' | 'real' | 'bool' | RPar type RPar
    ;

map_type
    :   type_params? LBracket (type (Comma type)*)? RBracket type
    ;

exprs
    :   expr (Comma expr)*
    ;

proposition
    :   expr
    ;

expr
    :   implies_expr (Equiv_op implies_expr)*
    ;

Equiv_op
    :   '<==>'
    ;

implies_expr
    :   logical_expr (Implies_op implies_expr | Explies_op logical_expr (Explies_op logical_expr)*)?
    ;

Implies_op
    :   '==>'
    ;

Explies_op
    :   '<=='
    ;

logical_expr
    :   rel_expr (And_op rel_expr (And_op rel_expr)* | Or_op rel_expr (Or_op rel_expr)*)?
    ;

And_op
    :   '&&'
    ;

Or_op
    :   '||'
    ;

rel_expr
    :   bv_term (Rel_op bv_term)*
    ;

Rel_op
    :   '==' | Greater | Less | '<=' | '>=' | '!=' | '<:'
    ;

bv_term
    :   term ('++' term)*
    ;

term
    :   factor (add_op factor)*
    ;

add_op
    :   Plus | Minus
    ;

factor
    :   power (mul_op power)*
    ;

mul_op
    :   Ast | Slash | 'div' | 'mod'
    ;

power
    :   unary_expr ('**' power)*
    ;

unary_expr
    :   Minus unary_expr | neg_op unary_expr | coercion_expr
    ;

neg_op
    :   Excl
    ;

coercion_expr
    :   array_expr (Colon ( type | Digit+ ))*
    ;

array_expr
    :   atom_expr (LBracket (exprs (Define expr)? | Define expr)? RBracket)*
    ;

atom_expr
    :   bool_lit | dec | Digit+ | bv_lit | Ident (LPar expr RPar)? | old_expr | arith_coercion_expr | paren_expr | forall_expr | exists_expr | lambda_expr | if_then_else_expr | code_expr
    ;

bool_lit
    :   'true' | 'false'
    ;

dec
//    :   decimal | dec_float
    :   dec_float    
    ;

//decimal
//    :   Digits 'e' Minus? Digits
//    ;

dec_float
    //:   Digits Period Digits ('e' Minus? Digits)?
	:   Digit* Period Digit+
    ;

bv_lit
    :   Digit+ 'bv' Digit+
    ;

old_expr
    :   'old' LPar expr RPar
    ;

arith_coercion_expr
    :   'int' LPar expr RPar | 'real' LPar expr RPar
    ;

paren_expr
    :   LPar expr RPar
    ;

forall_expr
    :   LPar Forall quant_body RPar
    ;

exists_expr
    :   LPar Exists quant_body RPar
    ;

lambda_expr
    :   LPar Lambda quant_body RPar
    ;

quant_body
    :   (type_params bound_vars? | bound_vars) Qsep attr_or_trigger* expr
    ;

bound_vars
    :   attr_typed_idents_wheres
    ;

Qsep
    :   '::'
    ;

if_then_else_expr
    :   'if' expr 'then' expr 'else' expr
    ;

code_expr
    :   '|{' local_vars* spec_block spec_block* '}|'
    ;

spec_block
    :   Ident Comma label_or_cmd* ('goto' idents | 'return' expr) Semi
    ;

attr_typed_idents_wheres
    :    attr_typed_idents_where (Comma attr_typed_idents_where)*
    ;

attr_typed_idents_where
    :    attr* typed_idents_where
    ;

typed_idents_wheres
    :    attr_typed_idents_where (Comma attr_typed_idents_where)*
    ;
    
typed_idents_where
    :    typed_idents ('where' expr)?
    ;

typed_idents
    :    idents Colon type
    ;
    
idents
    :    Ident (Comma Ident)*
    ;
    
type_params
    :    Less idents Greater
    ;
    
attr
    :    attr_or_trigger
    ;
    
attr_or_trigger
    :    LBrace ( Colon Ident (attr_param (Comma attr_param)*)? | exprs ) RBrace
    ;
    
attr_param
    :    String | expr
    ;
    
String
    :    Quote (Letter | '\\"')* Quote
    ;
    
Forall
    :   'forall'
    ;

Exists
    :   'exists'
    ;

Lambda
    :   'lambda'
    ;

Quote
    :    '"'
    ;
    
Define
    :   ':=' 
    ;


Non_digit
//    :   Letter | Tilde | Num | Dollar | Circ | Underscore | Period | Question 
	:   Tilde | Num | Dollar | Circ | Underscore | Period | Question
    ;

//Digits
//    :   ([0-9])+
//    ;

DBar
    :   '\\'
    ;

//Letter
//    :   [A-Za-z]
//    ;

//Ident
//    :    DBar? Non_digit (Digits | Non_digit)*
//    ;
   
Ident
	:	Letter (Letter | Digit)*
	;	

fragment
Letter
	: [A-Za-z]
	;

fragment
Digit
	: [0-9]
	;

WS
	:	[ \t\r\n]+ -> skip ;