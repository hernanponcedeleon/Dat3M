grammar LitmusLISA;

import LitmusAssertions;

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace variableDeclarator? (Semi variableDeclarator)* Semi? RBrace Semi?
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    |   variableDeclaratorLocationLocation
    ;

variableDeclaratorLocation
    :   location Equals constant
    ;

variableDeclaratorRegister
    :   threadId Colon register Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location
    ;

variableList
    :   Locations LBracket variable Ast? (Semi variable Ast?)* Semi? RBracket
    ;

variable
    :   location
    |   threadId Colon register
    ;

program
    :   threadDeclaratorList instructionList
    ;

threadDeclaratorList
    :   threadId (Bar threadId)* Semi
    ;

instructionList
    :   (instructionRow)+
    ;

instructionRow
    :   instruction (Bar instruction)* Semi
    ;

instruction
    :
    |   fence
    |   jump
    |   load
    |   local
    |   store
    |   rmw
    |   label
    ;
    
jump
    :   Jump register labelName
    ;

label
    :   labelName Colon
    ;

labelName
    :   Identifier
    ;

load
    :   Load mo? RBracket register expression
    ;

local
    :   Local register expression
    ;

store
    :   Store mo? RBracket expression value
    ;

rmw
    :   Rmw mo? RBracket register value expression
    ;

fence
    :   Fence mo? RBracket
    ;

value
    :   register
    |	constant
    ;

location
    :   Identifier
    ;

expression
    :   value
    |   location
    |   paraExpr
    |   arrayAccess
    |	eq
    |	neq
    |   add
    |   sub
    |   xor
    |   and
    |   or
    ;

arrayAccess
    : location Plus value
    ;

paraExpr
    : LPar expression RPar
    ;

add
    : Add expression expression
    ;

sub
    : Sub expression expression
    ;

and
    : And expression expression
    ;

eq
    : Eq expression expression
    ;

neq
    : Neq expression expression
    ;

xor
    : Xor expression expression
    ;

or
    : Or expression expression
    ;

mo
    :   Identifier (Period Identifier)*
    ;

register
    :   Register
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

Add
    :   'add'
    ;

And
    :   'and'
    ;

Eq
    :   'eq'
    ;

Neq
    :   'neq'
    ;

Fence
    :   'f' LBracket
    ;

Jump  
	:   'b' LBracket RBracket
    ;

LitmusLanguage
    :   'LISA'
    ;
    
Load  
	:   'r' LBracket
    ;

Local  
	:   'mov'
    ;

Locations
    :   'locations'
    ;

Or
    :   'or'
    ;

Register
    :   'r' DigitSequence
    ;

Rmw
    :   'rmw' LBracket
    ;
    
Store
    :   'w' LBracket
    ;
    
Sub
    :   'sub'
    ;
    
Xor
	:   'xor'
    ;
