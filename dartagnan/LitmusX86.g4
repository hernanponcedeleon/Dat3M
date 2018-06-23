grammar LitmusX86;

@header{
package dartagnan;
}

main
    :    header variableDeclaratorList threadDeclaratorList instructionList (variableList)? assertionList EOF
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
    :   'locations' '[' (variable ';')+ ']'
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
    :   Inc '[' location ']'
    ;

thread
    :   ThreadIdentifier
    |   DigitSequence
    ;

r1
    :   Register
    ;

location
    :   Identifier
    ;

value
    :   DigitSequence
    ;

assertionList
    :   (AssertionExists | AssertionExistsNot) assertionClauseOrWithParenthesis (';')?
    |   AssertionFinal assertionClauseOrWithParenthesis (';')? assertionListExpectationList
    |   AssertionForall  (assertionClauseOrWithParenthesis | assertionClauseOr) (';')?
    ;

assertionClauseOrWithParenthesis
    :   '(' assertionClauseAnd ')' (LogicOr '(' assertionClauseAnd ')')*
    ;

assertionClauseOr
    :   (assertion | assertionClauseAnd) (LogicOr (assertion | assertionClauseAnd))*
    ;

assertionClauseAnd
    :   (assertion | '(' assertionClauseOr ')') (LogicAnd (assertion | '(' assertionClauseOr ')'))+
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
    :   (   '+'
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
        )
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