grammar LitmusPPC;

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
    |   b
    |   beq
    |   bne
    |   blt
    |   bgt
    |   ble
    |   bge
    |   sync
    |   lwsync
    |   isync
    |   eieio
    ;

none
    :
    ;

li
    :   'li' r1 ',' value
    ;

lwz
    :   'lwz' r1 ',' offset '(' r2 ')'
    ;

lwzx
    :   'lwzx' r1 ',' r2 ',' r3
    ;

stw
    :   'stw' r1 ',' offset '(' r2 ')'
    ;

stwx
    :   'stwx' r1 ',' r2 ',' r3
    ;

mr
    :   'mr' r1 ',' r2
    ;

addi
    :   'addi' r1 ',' r2 ',' value
    ;

xor
    :   'xor' r1 ',' r2 ',' r3
    ;

cmpw
    :   'cmpw' r1 ',' r2
    ;

label
    :   Label ':'
    ;

b
    :   'b' Label
    ;

beq
    :   'beq' Label
    ;

bne
    :   'bne' Label
    ;

blt
    :   'blt' Label
    ;

bgt
    :   'bgt' Label
    ;

ble
    :   'ble' Label
    ;

bge
    :   'bge' Label
    ;

sync
    :   'sync'
    ;

lwsync
    :   'lwsync'
    ;

isync
    :   'isync'
    ;

eieio
    :   'eieio'
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

r3
    :   Register
    ;

location
    :   Identifier
    ;

value
    :   DigitSequence
    ;

offset
    :   DigitSequence
    ;

assertionList
    :   (AssertionExists | AssertionExistsNot | AssertionForall) assertion (';')?
    |   AssertionFinal AssertionFinal (';')? assertionListExpectationList
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
    :   'PPC'
    |   'ppc'
    ;

Register
    :   'r' DigitSequence
    ;

Label
    :   'LC' DigitSequence
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