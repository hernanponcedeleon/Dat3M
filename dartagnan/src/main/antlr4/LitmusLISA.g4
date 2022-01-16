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
    :   Locations LBracket variable (Semi variable)* Semi? RBracket
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
    :   Fence mofence? RBracket
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
    |	location
    |	add
    |	eq
    |	neq
    |	xor
    |   paraExpr
    ;

paraExpr
    : LPar expression RPar
    ;

add
	: Add expression expression
	;

mo
    :   Mo
    ;

mofence
    :   Mofence
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

Mo
    :   'once'
    |   'acquire'
    |   'release'
    |   'assign'
    |   'deref'
    ;

Mofence
    :   'mb'
    |   'rmb'
    |   'wmb'
    |   'rcu_read_lock'
    |   'rcu_read_unlock'
    |   'sync'
    ;
    
Register
    :   'r' DigitSequence
    ;


Store
    :   'w' LBracket
    ;
    
Rmw
    :   'rmw' LBracket
    ;
    
Xor
	:   'xor'
    ;
