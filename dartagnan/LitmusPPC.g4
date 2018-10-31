grammar LitmusPPC;

@header{
package dartagnan;
}

import LitmusBase;

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionList? EOF
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
    :   location Equals value
    ;

variableDeclaratorRegister
    :   threadId Colon register Equals value
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals location
    ;

variableDeclaratorLocationLocation
    :   location Equals location
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
    :   none
    |   li
    |   lwz
    |   lwzx
    |   stw
    |   stwx
    |   mr
    |   addi
    |   xor
    |   cmpw
    |   label
    |   branchCond
    |   fence
    ;

none
    :
    ;

li
    :   Li register Comma value
    ;

lwz
    :   Lwz register Comma offset LPar register RPar
    ;

lwzx
    :   Lwzx register Comma register Comma register
    ;

stw
    :   Stw register Comma offset LPar register RPar
    ;

stwx
    :   Stwx register Comma register Comma register
    ;

mr
    :   Mr register Comma register
    ;

addi
    :   Addi register Comma register Comma value
    ;

xor
    :   Xor register Comma register Comma register
    ;

cmpw
    :   Cmpw register Comma register
    ;

label
    :   Label Colon
    ;

branchCond
    :   BranchCondInstruction Label
    ;

fence
    :   Fence
    ;

location
    :   Identifier
    ;

register
    :   Register
    ;

value
    :   DigitSequence
    ;

offset
    :   DigitSequence
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   value
    ;

Fence
    :   'sync'
    |   'lwsync'
    |   'isync'
    |   'eieio'
    ;

BranchCondInstruction
    :   'beq'
    |   'bne'
    |   'blt'
    |   'bgt'
    |   'ble'
    |   'bge'
    ;

Li
    :   'li'
    ;

Lwzx
    :   'lwzx'
    ;

Lwz
    :   'lwz'
    ;

Stwx
    :   'stwx'
    ;

Stw
    :   'stw'
    ;

Mr
    :   'mr'
    ;

Addi
    :   'addi'
    ;

Xor
    :   'xor'
    ;

Cmpw
    :   'cmpw'
    ;

Register
    :   'r' DigitSequence
    ;

Label
    :   'LC' DigitSequence
    ;

LitmusLanguage
    :   'PPC'
    |   'ppc'
    ;