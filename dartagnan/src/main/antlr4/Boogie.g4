grammar Boogie;

import BaseLexer;

main
    :    (axiom_decl | const_decl | func_decl | impl_decl | proc_decl |  type_decl | var_decl)* EOF
    ;

axiom_decl
    :   Axiom attr* proposition Semi
    ;

const_decl
    :   Const attr* Unique? typed_idents order_spec? Semi
    ;

func_decl
    :   Function attr* ident type_params? LPar (var_or_type (Comma var_or_type)*)? RPar ( Returns LPar var_or_type RPar | Colon type ) ( LBrace expr RBrace | Semi )
    ;

impl_decl
    :   Implementation proc_sign impl_body
    ;

proc_decl
    :   Procedure proc_sign ( Semi spec* | spec* impl_body )
    ;

type_decl
    :   Type attr* ident ident* (Equals type)? (Comma ident ident* ( Equals type )? )* Semi
    ;

var_decl
    :   Var attr* typed_idents_wheres Semi
    ;

order_spec
    :   Extends ( Unique? ident ( Comma Unique? ident )* )? Complete?
    ;

var_or_type
    :   attr* ( type | ident (Colon type)? )
    ;

proc_sign
    :   attr* ident type_params? LPar attr_typed_idents_wheres? RPar (Returns LPar attr_typed_idents_wheres? RPar)?
    ;

impl_body
    :   LBrace local_vars* stmt_list RBrace
    ;

stmt_list
    :   ( label_or_cmd | transfer_cmd | structured_cmd )*
    ;

local_vars
    :   Var attr* typed_idents_wheres Semi
    ;

spec
    :   modifies_spec | requires_spec | ensures_spec
    ;

modifies_spec
    :   Modifies idents? Semi
    ;

requires_spec
    :  Free? Requires attr* proposition Semi
    ;

ensures_spec
    :  Free? Ensures attr* proposition Semi
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
    :   Assert attr* proposition Semi
    ;

assign_cmd
    :   ident (LBracket exprs? RBracket)* (Comma ident (LBracket exprs? RBracket )*)* Define exprs Semi
    ;

assume_cmd
    :   Assume attr* proposition Semi
    ;

break_cmd
    :   Break ident Semi
    ;

call_cmd
    :   Async? Free? Call attr* call_params Semi
    ;

goto_cmd
    :   Goto idents Semi
    ;

havoc_cmd
    :   Havoc idents Semi
    ;

if_cmd
    :   If guard LBrace stmt_list RBrace (Else ( if_cmd | LBrace stmt_list RBrace ))?
    ;

label
    :   ident Colon
    ;

par_call_cmd
    :   Par attr* call_params (Bar call_params)* Semi
    ;

return_cmd
    :   Return Semi
    ;

while_cmd
    :   While guard ( Free? Invariant attr* expr Comma )* LBrace stmt_list RBrace
    ;

yield_cmd
    :   Yield Semi
    ;

call_params
    :   ident ( LPar exprs? RPar | (Comma idents)? Define ident LPar exprs? RPar )
    ;

guard
    :   LPar ( Ast | expr ) RPar
    ;

type
    :   type_atom | ident type_args? | map_type
    ;

type_args
    :   type_atom type_args? | ident type_args? | map_type
    ;

type_atom
    :   Int | Real | Bool | RPar type RPar
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
    :   Ast | Slash | Div | Mod
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
    :   array_expr (Colon ( type | Digits ))*
    ;

array_expr
    :   atom_expr (LBracket (exprs (Define expr)? | Define expr)? RBracket)*
    ;

atom_expr
    :   bool_lit | dec | Digits | bv_lit | ident (LPar expr RPar)? | old_expr | arith_coercion_expr | paren_expr | forall_expr | exists_expr | lambda_expr | if_then_else_expr | code_expr
    ;

bool_lit
    :   True | False
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
	:   Digits Period Digits
    ;

bv_lit
    :   Digits Bv Digits
    ;

old_expr
    :   Old LPar expr RPar
    ;

arith_coercion_expr
    :   Int LPar expr RPar | Real LPar expr RPar
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
    :   If expr Then expr Else expr
    ;

code_expr
    :   '|{' local_vars* spec_block spec_block* '}|'
    ;

spec_block
    :   ident Comma label_or_cmd* (Goto idents | Return expr) Semi
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
    :    typed_idents (Where expr)?
    ;

typed_idents
    :    idents Colon type
    ;
    
idents
    :    ident (Comma ident)*
    ;
    
type_params
    :    Less idents Greater
    ;
    
attr
    :    attr_or_trigger
    ;
    
attr_or_trigger
    :    LBrace ( Colon ident (attr_param (Comma attr_param)*)? | exprs ) RBrace
    ;
    
attr_param
    :    string | expr
    ;
    
string
    :    Quote (Letter | '\\"')* Quote
    ;
    
ident
    :    DBar? Non_digit (Digits | Non_digit)*
    ;

// Key words /////////////////

If
    :    'if'
    ;
    
Then
    :    'then'
    ;
    
Else
    :    'else'
    ;
    
Axiom
    :    'axiom'
    ;
    
Const
    :    'const'
    ;
    
Function
    :    'function'
    ;
    
Implementation
    :    'implementation'
    ;
    
Procedure
    :    'procedure'
    ;
    
Type
    :    'type'
    ;
    
Var
    :    'var'
    ;
    
Extends
    :    'extends'
    ;
    
Unique
    :    'unique'
    ;
    
Complete
    :    'complete'
    ;
    
Returns
    :    'returns'
    ;
    
Modifies
    :    'modifies'
    ;
    
Free
    :    'free'
    ;
    
Requires
    :    'requires'
    ;
    
Ensures
    :    'ensures'
    ;
    
Assert
    :    'assert'
    ;
    
Assume
    :    'assume'
    ;
    
Break
    :    'break'
    ;
    
Async
    :    'async'
    ;
    
Call
    :    'call'
    ;
    
Goto
    :    'goto'
    ;
    
Havoc
    :    'havoc'
    ;
    
Par
    :    'par'
    ;
    
Return
    :    'return'
    ;
    
While
    :    'while'
    ;
    
Yield
    :    'yield'
    ;
    
Int
    :    'Int'
    ;
    
Real
    :    'real'
    ;
    
Bool
    :    'bool'
    ;
    
Div
    :    'div'
    ;
    
Mod
    :    'mod'
    ;
    
True
    :    'true'
    ;
    
False
    :    'false'
    ;
    
Bv
    :    'bv'
    ;
    
Old
    :    'old'
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

Invariant
    :   'invariant'
    ;

Where
    :   'where'
    ;
////////////////////////

Quote
    :    '"'
    ;
    
Define
    :   ':=' 
    ;


Non_digit
    :   Letter | Tilde | Num | Dollar | Circ | Underscore | Period | Question 
    ;

Digits
    :   ([0-9])+
    ;

DBar
    :   '\\'
    ;

Letter
    :   [A-Za-z]
    ;