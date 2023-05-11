grammar LitmusAssertions;

import BaseLexer;

@header{
import com.dat3m.dartagnan.expression.op.COpBin;
}

assertionFilter
    :   AssertionFilter a = assertion Semi?
    ;

assertionList
    :   AssertionExists a = assertion Semi?
    |   AssertionNot AssertionExists a = assertion Semi?
    |   AssertionForall a = assertion Semi?
    |   AssertionFinal a = assertion Semi? assertionListExpectationList
    ;

assertion
    :   LPar assertion RPar                                 # assertionParenthesis
    |   AssertionNot assertion                              # assertionNot
    |   assertion AssertionAnd assertion                    # assertionAnd
    |   assertion AssertionOr assertion                     # assertionOr
    |   assertionValue assertionCompare assertionValue      # assertionBasic
    ;

assertionValue
    :   varName LBracket DigitSequence RBracket
    |   varName
    |   threadId Colon varName
    |   constant
    ;

varName
    :    Underscore* Identifier (Identifier | DigitSequence | Underscore)*
    ;

constant
    :   Minus? DigitSequence
    ;

assertionListExpectationList
    :   AssertionWith (assertionListExpectation)+
    ;

assertionListExpectation
    :   AssertionListExpectationTest Colon AssertionNot? AssertionExists Semi
    ;

assertionCompare returns [COpBin op]
    :   (Equals | EqualsEquals) {$op = COpBin.EQ;}
    |   NotEquals               {$op = COpBin.NEQ;}
    |   GreaterEquals           {$op = COpBin.GTE;}
    |   LessEquals              {$op = COpBin.LTE;}
    |   Less                    {$op = COpBin.LT;}
    |   Greater                 {$op = COpBin.GT;}
    ;

threadId returns [int id]
    :   t = ThreadIdentifier {$id = Integer.parseInt($t.text.replace("P", ""));}
    |   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

AssertionListExpectationTest
    :   'tso'
    |   'cc'
    |   'optic'
    |   'default'
    ;

AssertionAnd
    :   '/\\'
    ;

AssertionOr
    :   '\\/'
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

ThreadIdentifier
    :   'P' DigitSequence
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

Identifier
    :   Underscore* Letter+ (Letter | Digit | Underscore)*
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