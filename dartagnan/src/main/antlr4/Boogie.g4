grammar Boogie;

import BaseLexer;

@header{
import com.dat3m.dartagnan.expression.op.*;
}

main
    :    ( line_comment | axiom_decl | const_decl | func_decl | impl_decl | proc_decl |  type_decl | var_decl )* EOF
    ;

line_comment
    :   HEADER_COMMENT
    ;

axiom_decl
    :   'axiom' attr* proposition Semi
    ;

const_decl
    :   'const' attr* 'unique'? typed_idents order_spec? Semi
    ;

func_decl
    :   'function' attr* Ident type_params? LPar (var_or_type (Comma var_or_type)*)? RPar ( 'returns' return_var_or_type | Colon type ) ( LBrace expr RBrace | Semi )
    ;

return_var_or_type
    :   LPar var_or_type RPar
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
    :   attr* Ident type_params? LPar proc_sign_in? RPar ('returns' LPar proc_sign_out? RPar)?
    ;

proc_sign_in
    :   attr_typed_idents_wheres
    ;

proc_sign_out
    :   attr_typed_idents_wheres
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
    :	modifies_spec
    |	requires_spec
    |	ensures_spec
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
    :	assert_cmd
    |	assign_cmd
    |	assume_cmd
    |	call_cmd
    |	havoc_cmd
    |	label
    |	par_call_cmd
    |	yield_cmd
    ;

transfer_cmd
    :	break_cmd
    |	if_cmd
    |	while_cmd
    ;

structured_cmd
    :	goto_cmd
    |	return_cmd
    ;

assert_cmd
    :   'assert' attr* proposition Semi
    ;

assign_cmd
    :   Ident (LBracket exprs? RBracket)* (Comma Ident (LBracket exprs? RBracket )*)* Define def_body Semi
    ;

def_body
    :   exprs
    ;

assume_cmd
    :   'assume' attr* proposition Semi
    ;

break_cmd
    :   'break' Ident? Semi
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
    :   'par' attr* call_params (Bar call_params)* Semi
    ;

return_cmd
    :   'return' Semi
    ;

while_cmd
    :   'while' guard ( 'free'? 'invariant' attr* expr Semi )* LBrace stmt_list RBrace
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
    :	type_atom
    |	Ident type_args?
    |	map_type
    ;

type_args
    :	type_atom type_args?
    |	Ident type_args?
    |	map_type
    ;

type_atom
    :   'int' | 'real' | 'bool' | LPar type RPar
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
    :   rel_expr ((and_op  and_expr) | (or_op or_expr))?
    ;

and_expr
    :   rel_expr (and_op rel_expr)*
    ;

or_expr
    :   rel_expr (or_op rel_expr)*
    ;

and_op returns [BOpBin op]
    :   '&&'		{$op = BOpBin.AND;}
    ;

or_op returns [BOpBin op]
    :   '||'		{$op = BOpBin.OR;}
    ;

rel_expr
    :   bv_term (rel_op bv_term)*
    ;

rel_op returns [COpBin op]
    :   '=='		{$op = COpBin.EQ;}
    |   '!='		{$op = COpBin.NEQ;}
    |   '<='		{$op = COpBin.LTE;}
    |   '>='		{$op = COpBin.GTE;}
    |   Less		{$op = COpBin.LT;}
    |   Greater		{$op = COpBin.GT;}
    |	'<:'
    ;

bv_term
    :   term ('++' term)*
    ;

term
    :   factor (add_op factor)*
    ;

add_op returns [IOpBin op]
    :   Plus		{$op = IOpBin.PLUS;} 
    |	Minus		{$op = IOpBin.MINUS;}
    ;

factor
    :   power (mul_op power)*
    ;

mul_op returns [IOpBin op]
    :	Ast			{$op = IOpBin.MULT;}
    |	Div			{$op = IOpBin.DIV;}
    |	Mod			{$op = IOpBin.MOD;}
    ;

power
    :   unary_expr ('**' power)*
    ;

unary_expr
    :	minus_expr
    |	neg_expr
    |	coercion_expr
    ;

minus_expr
    :   Minus unary_expr
    ;

neg_expr
    :   neg_op unary_expr
    ;

neg_op
    :   Excl
    ;

coercion_expr
    :   array_expr (Colon ( type | Int ))*
    ;

array_expr
    :   atom_expr (LBracket (exprs (Define expr)? | Define expr)? RBracket)*
    ;

atom_expr
    :	bool_lit
    |	dec
    |	int_expr
    |	bv_expr
    |	var_expr
    |	fun_expr
    |	old_expr
    |	arith_coercion_expr
    |	paren_expr
    |	forall_expr
    |	exists_expr
    |	lambda_expr
    |	if_then_else_expr
    |	code_expr
    ;

bv_expr
    :   Bv_lit
    ;

int_expr
    :   Int
    ;

var_expr
    :   Ident
    ;

fun_expr
    :   Ident LPar (expr (Comma expr)*)? RPar
    ;

bool_lit returns [Boolean value]
    :	'true'		{$value = true;}
    |	'false'		{$value = false;}
    ;

dec
    :	Decimal
    |	Dec_float
    ;

old_expr
    :   'old' LPar expr RPar
    ;

arith_coercion_expr
    :	'int' LPar expr RPar
    |	'real' LPar expr RPar
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
    :   (type_params bound_vars? | bound_vars) '::' attr_or_trigger* expr
    ;

bound_vars
    :   attr_typed_idents_wheres
    ;

if_then_else_expr
    :   'if' expr 'then' expr 'else' expr
    ;

code_expr
    :   '|{' local_vars* spec_block spec_block* '}|'
    ;

spec_block
    :   Ident Colon label_or_cmd* ('goto' idents | 'return' expr) Semi
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
    :    '<' idents '>'
    ;
    
attr
    :    attr_or_trigger
    ;
    
attr_or_trigger
    :    LBrace ( Colon Ident (attr_param (Comma attr_param)*)? | exprs ) RBrace
    ;
    
attr_param
    :	String
    |	expr
    ;
    
String
	:	'"' (ESC|.)*? '"'
	;

fragment
ESC
	:	BSlash
	|	'\\\\'
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

Define
    :   ':=' 
    ;

fragment
Non_digit
    :	Letter
    |	Tilde
    |	Num
    |	Dollar
    |	Circ
    |	Underscore
    |	Period
    |	Question
    |	'`'
    |	'\''
    |	BSlash
    ;

DBar
    :   BSlash
    ;

Mod
	:	'mod'
	|	Percent
	;	

Div
	:	'div'
	|	Slash
	;	

Ident
	:	Non_digit (Non_digit | Int)*
	;	

fragment
Letter
	: [A-Za-z]
	;

Int
	: [0-9]+
	;

Dec_float
	:   Int Period Int ('e' Minus? Int)?
    ;

Decimal
    :   Int 'e' Minus? Int
    ;

Bv_lit
    :   Int 'bv' Int
    ;

WS
	:	[ \t\r\n]+ -> skip
	;
	
HEADER_COMMENT
    :    '// generated by SMACK version' .*? '\r'? '\n'
    ;

LINE_COMMENT
    :    '//' .*? '\r'? '\n' -> skip
    ;

COMMENT
	: '/*' .*? '*/' -> skip
	;	
