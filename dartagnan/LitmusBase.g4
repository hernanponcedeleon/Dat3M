grammar LitmusBase;

import BaseLexer;
@header{
import dartagnan.asserts.*;
import dartagnan.asserts.utils.Op;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.*;
import dartagnan.expression.AConst;
import dartagnan.parsers.utils.ProgramBuilder;
}

@parser::members{
    ProgramBuilder pb;
}

// These rules must be overwritten in child grammars
variableDeclaratorList                      :;
program                                     :;
variableList                                :;
assertionValue returns [IntExprInterface v] :;

// Must be overwritten in child grammars
LitmusLanguage  :   'BaseLitmusLanguage';


main [ProgramBuilder p]
    :    {pb = p;} LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? comment? EOF
    ;

assertionFilter
    :   AssertionFilter a = assertion Semi? {pb.setAssertFilter($a.ass);}
    ;

assertionList
    :   AssertionExists a = assertion Semi? {$a.ass.setType(AbstractAssert.ASSERT_TYPE_EXISTS); pb.setAssert($a.ass);}
    |   AssertionExistsNot a = assertion Semi? {$a.ass.setType(AbstractAssert.ASSERT_TYPE_NOT_EXISTS); pb.setAssert($a.ass);}
    |   AssertionForall a = assertion Semi? {$a.ass = new AssertNot($a.ass); $a.ass.setType(AbstractAssert.ASSERT_TYPE_FORALL); pb.setAssert($a.ass);}
    |   AssertionFinal a = assertion Semi? assertionListExpectationList {$a.ass.setType(AbstractAssert.ASSERT_TYPE_FINAL); pb.setAssert($a.ass);}
    ;

assertion returns [AbstractAssert ass]
    :   LPar a = assertion RPar   { $ass = $a.ass; }
    |   AssertionNot a = assertion    { $ass = new AssertNot($a.ass); }
    |   a1 = assertion AssertionAnd a2 = assertion  { $ass = new AssertCompositeAnd($a1.ass, $a2.ass); }
    |   a1 = assertion AssertionOr a2 = assertion   { $ass = new AssertCompositeOr($a1.ass, $a2.ass); }
    |   v1 = assertionValue op = assertionCompare v2 = assertionValue { $ass = new AssertBasic($v1.v, $op.op, $v2.v); }
    ;

assertionListExpectationList
    :   AssertionWith (assertionListExpectation)+
    ;

assertionListExpectation
    :   AssertionListExpectationTest Colon (AssertionExists | AssertionExistsNot) Semi
    ;

assertionCompare returns [Op op]
    :   (Equals | EqualsEquals) {$op = Op.EQ;}
    |   NotEquals               {$op = Op.NEQ;}
    |   GreaterEquals           {$op = Op.GTE;}
    |   LessEquals              {$op = Op.LTE;}
    |   Less                    {$op = Op.LT;}
    |   Greater                 {$op = Op.GT;}
    ;

threadId returns [String id]
    :   t = ThreadIdentifier {$id = $t.text.replace("P", "");}
    |   t = DigitSequence {$id = $t.text;}
    ;

comment
    :   LPar Ast .*? Ast RPar
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