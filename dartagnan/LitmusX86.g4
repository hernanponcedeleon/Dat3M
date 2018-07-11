grammar LitmusX86;

@header{
package dartagnan;
}

main
    :    header variableDeclaratorList threadDeclaratorList instructionList (variableList)? (assertionList)? EOF
    ;

header
    :   LitmusLanguage headerComment
    ;

headerComment
    :   ~('{')*
    ;

variableDeclaratorList
    :   '{' (variableDeclarator)? (';' variableDeclarator)* (';')? '}' (';')?
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    ;

variableDeclaratorLocation
    :   location '=' value
    ;

variableDeclaratorRegister
    :   thread ':' r1 '=' value
    ;

variableDeclaratorRegisterLocation
    :   thread ':' r1 '=' location
    ;

variableList
    :   'locations' '[' variable (';' variable)* (';')? ']'
    ;

variable
    :   location
    |   thread ':' r1
    ;

threadDeclaratorList
    :   thread ('|' thread)* ';'
    ;

instructionList
    :   (instructionRow)+
    ;

instructionRow
    :   instruction ('|' instruction)* ';'
    ;

instruction
    :   none
    |   loadValueToRegister
    |   loadLocationToRegister
    |   storeValueToLocation
    |   storeRegisterToLocation
    |   mfence
    |   lfence
    |   sfence
    |   exchangeRegisterLocation
    |   incrementLocation
    |   compareRegisterValue
    |   compareLocationValue
    |   addRegisterRegister
    |   addRegisterValue
    ;

none
    :
    ;

loadValueToRegister
    :   Mov r1 ',' ('$')? value
    ;

loadLocationToRegister
    :   Mov r1 ',' ('[')? location (']')?
    ;

storeValueToLocation
    :   Mov ('[')? location (']')? ',' ('$')? value
    ;

storeRegisterToLocation
    :   Mov ('[')? location (']')? ',' r1
    ;

mfence
    :   Mfence
    ;

lfence
    :   Lfence
    ;

sfence
    :   Sfence
    ;

exchangeRegisterLocation
    :   Xchg r1 ',' ('[')? location (']')?
    |   Xchg ('[')? location (']')? ',' r1
    ;

incrementLocation
    :   Inc ('[')? location (']')?
    ;

compareRegisterValue
    :   Cmp r1 ',' ('$')? value
    ;

compareLocationValue
    :   Cmp ('[')? location (']')? ',' ('$')? value
    ;

addRegisterRegister
    :   Add r1 ',' r2
    ;

addRegisterValue
    :   Add r1 ',' ('$')? value
    ;

thread
    :   ThreadIdentifier
    |   DigitSequence
    ;

r1
    :   Register
    ;

r2
    :   Register
    ;

location
    :   Identifier
    ;

value
    :   DigitSequence
    ;

assertionList
    :   (AssertionExists | AssertionExistsNot | AssertionForall) assertion (';')?
    |   AssertionFinal assertion (';')? assertionListExpectationList
    ;

assertion
    :   '(' assertion ')'               # assertionParenthesis
    |   assertion LogicAnd assertion    # assertionAnd
    |   assertion LogicOr assertion     # assertionOr
    |   location '=' value              # assertionLocation
    |   thread ':' r1 '=' value         # assertionRegister
    ;

assertionListExpectationList
    :   'with' (assertionListExpectation)+
    ;

assertionListExpectation
    :   assertionListExpectationTest ':' (AssertionExists | AssertionExistsNot) ';'
    ;

assertionListExpectationTest
    :   'tso'
    |   'cc'
    |   'optic'
    |   'default'
    ;

LitmusLanguage
    :   'X86'
    |   'x86'
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

ThreadIdentifier
    :   'P' DigitSequence
    ;

AssertionExistsNot
    :   '~exists'
    |   '~ exists'
    ;

AssertionExists
    :   'exists'
    ;

AssertionFinal
    :   'final'
    ;

AssertionForall
    :   'forall'
    ;

LogicAnd
    :   '/\\'
    ;

LogicOr
    :   '\\/'
    ;

Identifier
    :   (Letter)+ (Letter | Digit)*
    ;

DigitSequence
    :   Digit+
    ;

Word
    :   (Letter | Digit | Symbol)+
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
Letter
    :   [A-Za-z]
    ;

fragment
Symbol
    :   '+'
    |   '-'
    |   '*'
    |   '/'
    |   '"'
    |   '.'
    |   '?'
    |   '@'
    |   '&'
    |   '\''
    |   '\\'
    |   '_'
    ;

Whitespace
    :   [ \t]+
        -> skip
    ;

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> skip
    ;

BlockComment
    :   '(*' .*? '*)'
        -> skip
    ;

ExecConfig
    :   '<<' .*? '>>'
        -> skip
    ;