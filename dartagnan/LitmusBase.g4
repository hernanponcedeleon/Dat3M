grammar LitmusBase;

import BaseLexer;

threadId
    :   ThreadIdentifier
    |   DigitSequence
    ;

assertionList
    :   (AssertionExists | AssertionExistsNot | AssertionForall) assertion Semi?
    |   AssertionFinal assertion Semi? assertionListExpectationList
    ;

assertion
    :   LPar assertion RPar                                                 # assertionParenthesis
    |   AssertionNot assertion                                              # assertionNot
    |   assertion AssertionAnd assertion                                    # assertionAnd
    |   assertion AssertionOr assertion                                     # assertionOr
    |   assertionValue assertionCompare assertionValue                      # assertionBasic
    ;

assertionListExpectationList
    :   AssertionWith (assertionListExpectation)+
    ;

assertionListExpectation
    :   AssertionListExpectationTest Colon (AssertionExists | AssertionExistsNot) Semi
    ;

assertionCompare
    :   (Equals | EqualsEquals)
    |   NotEquals
    |   LessEquals
    |   GreaterEquals
    |   Less
    |   Greater
    ;

assertionValue
    :   'DummyAssertionValue'
    ;

AssertionListExpectationTest
    :   'tso'
    |   'cc'
    |   'optic'
    |   'default'
    ;

AssertionAnd
    :   '/\\'
    |   '&&'
    ;

AssertionOr
    :   '\\/'
    |   '||'
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

AssertionFilter
    :   'filter'
    ;

AssertionNot
    :   Tilde
    |   'not'
    ;

AssertionWith
    :   'with'
    ;

Locations
    :   'locations'
    ;

EqualsEquals
    :   '=='
    ;

NotEquals
    :   '!='
    ;

LessEquals
    :   '<='
    ;

GreaterEquals
    :   '>='
    ;

ThreadIdentifier
    :   'P' DigitSequence
    ;

Identifier
    :   (Letter)+ (Letter | Digit)*
    ;

DigitSequence
    :   Digit+
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
Letter
    :   [A-Za-z]
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