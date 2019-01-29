grammar LitmusPPC;

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

li
    :   Li register Comma constant
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
    :   Addi register Comma register Comma constant
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
    :   cond Label
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

offset
    :   DigitSequence
    ;

cond returns [COpBin op]
    :   Beq {$op = COpBin.EQ;}
    |   Bne {$op = COpBin.NEQ;}
    |   Bge {$op = COpBin.GTE;}
    |   Ble {$op = COpBin.LTE;}
    |   Bgt {$op = COpBin.GT;}
    |   Blt {$op = COpBin.LT;}
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

Locations
    :   'locations'
    ;

Fence
    :   'sync'
    |   'lwsync'
    |   'isync'
    |   'eieio'
    ;

Beq
    :   'beq'
    ;

Bne
    :   'bne'
    ;

Blt
    :   'blt'
    ;

Bgt
    :   'bgt'
    ;

Ble
    :   'ble'
    ;

Bge
    :   'bge'
    ;

Li  :   'li'
    ;

Lwzx:   'lwzx'
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