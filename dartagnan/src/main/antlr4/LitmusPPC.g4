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
    |   variableDeclaratorPointerLocation
    |   variableDeclaratorSymbolic
    |   variableDeclaratorArray
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

variableDeclaratorPointerLocation
    :   Ast Identifier Equals location
    ;

variableDeclaratorSymbolic
    :   type SymRegister Equals location
    ;

variableDeclaratorArray
    :   type? location LBracket constant RBracket (Equals initArray)?
    ;

initArray
    :   LBrace arrayElement* (Comma arrayElement)* RBrace
    ;

arrayElement
    :   constant
    |   Ast? (Amp? location | LPar Amp? location RPar)
    ;

type
    :   Identifier
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
    |   lis
    |   ld
    |   lwa
    |   lwz
    |   lwzx
    |   lwarx
    |   stw
    |   stwx
    |   stwcx
    |   mr
    |   addi
    |   ori
    |   xor
    |   xoris
    |   cmpw
    |   cmplwi
    |   branchLabel
    |   branchCond
    |   fence
    ;

li
    :   Li register Comma constant
    ;

lis
    :   Lis register Comma constant
    ;

ld
    :   Ld register Comma offset LPar register RPar
    ;

lwa
    :   Lwa register Comma offset LPar register RPar
    ;

lwz
    :   Lwz register Comma offset LPar register RPar
    ;

lwzx
    :   Lwzx register Comma register Comma register
    ;

lwarx
    :   Lwarx register Comma register Comma register
    ;

stw
    :   Stw register Comma offset LPar register RPar
    ;

stwx
    :   Stwx register Comma register Comma register
    ;

stwcx
    :   Stwcx register Comma register Comma register
    ;

mr
    :   Mr register Comma register
    ;

addi
    :   Addi register Comma register Comma constant
    ;

ori
    :   Ori register Comma register Comma constant
    ;

xor
    :   Xor register Comma register Comma register
    ;

xoris
    :   Xoris register Comma register Comma constant
    ;

cmpw
    :   Cmpw register Comma register
    ;

cmplwi
    :   Cmplwi register Comma constant
    ;

branchLabel
    :   label Colon
    ;

branchCond
    :   cond label
    ;

fence
    :   Fence
    ;

location
    :   Period? Identifier
    |   LBracket Identifier RBracket
    ;

register
    :   Register
    |   SymRegister
    ;

offset
    :   DigitSequence
    ;

cond returns [IntCmpOp op]
    :   Beq {$op = IntCmpOp.EQ;}
    |   Bne {$op = IntCmpOp.NEQ;}
    |   Bge {$op = IntCmpOp.GTE;}
    |   Ble {$op = IntCmpOp.LTE;}
    |   Bgt {$op = IntCmpOp.GT;}
    |   Blt {$op = IntCmpOp.LT;}
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

label
    :   Identifier
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

Lis :   'lis'
    ;

Ld  :   'ld'
    ;

Lwa :   'lwa'
    ;

Lwarx:   'lwarx'
    ;

Lwzx:   'lwzx'
    ;

Lwz
    :   'lwz'
    ;

Stwcx
    :   'stwcx.'
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

Ori
    :   'ori'
    ;

Xor
    :   'xor'
    ;

Xoris
    :   'xoris'
    ;

Cmpw
    :   'cmpw'
    ;

Cmplwi
    :   'cmplwi'
    ;

Register
    :   'r' DigitSequence
    ;

SymRegister
    :   Percent Identifier
    ;

LitmusLanguage
    :   'PPC'
    |   'ppc'
    ;