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
    |   label
    |   load
    |   local
    |   store
    ;
    
jump
    :   Jump LBracket RBracket register Label
    ;

label
    :   Label Colon
    ;

load
    :   Load LBracket mo? RBracket register location
    ;

local
    :   Local register LPar expression RPar
    ;

store
    :   Store LBracket mo? RBracket location value
    ;

fence
    :   Fence LBracket mofence? RBracket
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
    |	add
    |	eq
    |	neq
    |	xor
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
    :   'f'
    ;

Jump  
	:   'b'
    ;

Label
    :   'CTRL' DigitSequence
    | 	'LC' DigitSequence
    ;

LitmusLanguage
    :   'LISA'
    ;
    
Load  
	:   'r'
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
    |   'rcu_read_lock'
    |   'rcu_read_unlock'
    |   'sync'
    ;
    
Register
    :   'r' DigitSequence
    ;


Store
	:   'w'
    ;
    
Xor
	:   'xor'
    ;