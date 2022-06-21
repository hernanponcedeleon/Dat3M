grammar LitmusRISCV;

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
    |   lw
    |   sw
    |   fence
    |   ori
    ;

li
    :   Li register Comma constant
    ;

lw
    :   Lw register Comma offset LPar register RPar
    ;

sw
    :   Sw register Comma offset LPar register RPar
    ;
    
fence
    :   Fence fenceMode Comma fenceMode
    |   Fence Period fenceMode
    ;
    
fenceMode
    :   Read
    |   Write
    |   ReadWrite
    |   Tso
    ;
    
ori
    :   Ori register Comma register Comma constant
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

Lw
    :   'lw'
    ;

Sw
    :   'sw'
    ;

Fence
    :   'fence'
    ;

Ori
    :   'ori'
    ;

Read
    :   'r'
    ;

Write
    :   'w'
    ;

ReadWrite
    :   'rw'
    ;

Tso
    :   'tso'
    ;

Register
    :   'a' DigitSequence
    |   's' DigitSequence
    |   't' DigitSequence
    |   'x' DigitSequence
    ;

Label
    :   'LC' DigitSequence
    ;

LitmusLanguage
    :   'RISCV'
    |   'riscv'
    ;
