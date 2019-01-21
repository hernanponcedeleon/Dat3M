grammar LitmusX86;

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
    |   loadValueToRegister
    |   loadLocationToRegister
    |   storeValueToLocation
    |   storeRegisterToLocation
    |   fence
    |   exchangeRegisterLocation
    |   incrementLocation
    |   compareRegisterValue
    |   compareLocationValue
    |   addRegisterRegister
    |   addRegisterValue
    ;

loadValueToRegister
    :   Mov register Comma Dollar? constant
    ;

loadLocationToRegister
    :   Mov register Comma LBracket? location RBracket?
    ;

storeValueToLocation
    :   Mov LBracket? location RBracket? Comma Dollar? constant
    ;

storeRegisterToLocation
    :   Mov LBracket? location RBracket? Comma register
    ;

fence
    :   Mfence
    |   Lfence
    |   Sfence
    ;

exchangeRegisterLocation
    :   Xchg register Comma LBracket? location RBracket?
    |   Xchg LBracket? location RBracket? Comma register
    ;

incrementLocation
    :   Inc LBracket? location RBracket?
    ;

compareRegisterValue
    :   Cmp register Comma Dollar? constant
    ;

compareLocationValue
    :   Cmp LBracket? location RBracket? Comma Dollar? constant
    ;

addRegisterRegister
    :   Add register Comma register
    ;

addRegisterValue
    :   Add register Comma Dollar? constant
    ;

location
    :   Identifier
    ;

register
    :   Register
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

Locations
    :   'locations'
    ;

Mov
    :   'MOV'
    |   'mov'
    ;

Xchg
    :   'XCHG'
    |   'xchg'
    ;

Mfence
    :   'MFENCE'
    |   'mfence'
    ;

Lfence
    :   'LFENCE'
    |   'lfence'
    ;

Sfence
    :   'SFENCE'
    |   'sfence'
    ;

Inc
    :   'INC'
    |   'inc'
    ;

Cmp
    :   'CMP'
    |   'cmp'
    ;

Add
    :   'ADD'
    |   'add'
    ;

Register
    :   'EAX'
    |   'EBX'
    |   'ECX'
    |   'EDX'
    |   'ESP'
    |   'EBP'
    |   'ESI'
    |   'EDI'
    ;

LitmusLanguage
    :   'X86'
    |   'x86'
    ;