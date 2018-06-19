grammar LitmusPPC;

@header{
package dartagnan;
}

main
    :    header variableDeclaratorList threadDeclaratorList instructionList assertionComment assertionList
    ;

header
    :   'PPC' headerComment
    ;

headerComment
    :   ~('{')*
    ;

variableDeclaratorList
    :   '{' variableDeclarator* '}'
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    ;

variableDeclaratorLocation
    :   location '=' value ';'
    ;

variableDeclaratorRegister
    :   thread ':' r1 '=' value ';'
    ;

variableDeclaratorRegisterLocation
    :   thread ':' r1 '=' location ';'
    ;

threadDeclaratorList
    :   thread ('|' thread)* ';'
    ;

instructionList
    :   (instructionRow)*
    ;

instructionRow
    :   instruction ('|' instruction)* ';'
    ;

assertionComment
    :   ~('exists')*
    ;

assertionList
    :   'exists' ('(')+ assertion ('/\\' assertion)* (')')+
    ;

assertion
    :   variableAssertionLocation
    |   variableAssertionRegister
    ;

variableAssertionLocation
    :   location '=' value
    ;

variableAssertionRegister
    :   thread ':' r1 '=' value
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
    :   ThreadDeclarator
    |   DigitSequence
    ;

r1
    :   'r' DigitSequence
    ;

r2
    :   'r' DigitSequence
    ;

r3
    :   'r' DigitSequence
    ;

location
    :   Location
    ;

value
    :   DigitSequence
    ;

offset
    :   DigitSequence
    ;

fragment
NoRegisterFirstChar
    :   [a-qs-zA-Z_]
    ;

fragment
IdentifierChars
    :   [0-9a-qs-zA-Z_]
    ;

fragment
Digit
    :   [0-9]
    ;

Label
    :   'LC' DigitSequence
    ;

ThreadDeclarator
    :   'P' DigitSequence
    ;

Location
    :   NoRegisterFirstChar (IdentifierChars)*
    ;

DigitSequence
    :   Digit+
    ;

SkipSymbols
    :   (   '+'
        |   '-'
        |   '*'
        |   '/'
        |   '"'
        |   '.'
        |   '['
        |   ']'
        |   '?'
        |   '@'
        |   '\''
        |   '\\'
        )
        -> skip
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
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;