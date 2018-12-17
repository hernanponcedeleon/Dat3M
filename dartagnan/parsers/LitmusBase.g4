grammar LitmusBase;

import BaseLexer;

@header{
import dartagnan.asserts.*;
import dartagnan.expression.op.COpBin;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.*;
import dartagnan.program.memory.Location;
import dartagnan.expression.IConst;
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


main [ProgramBuilder programBuilder]
@init {
    pb = programBuilder;
}
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? comment? EOF
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
    :   LPar a = assertion RPar { $ass = $a.ass; }
    |   AssertionNot a = assertion { $ass = new AssertNot($a.ass); }
    |   a1 = assertion AssertionAnd a2 = assertion { $ass = new AssertCompositeAnd($a1.ass, $a2.ass); }
    |   a1 = assertion AssertionOr a2 = assertion { $ass = new AssertCompositeOr($a1.ass, $a2.ass); }
    |   v1 = assertionValue op = assertionCompare v2 = assertionValue { $ass = new AssertBasic($v1.v, $op.op, $v2.v instanceof Location ? ((Location)$v2.v).getAddress() : $v2.v); }
    ;

assertionListExpectationList
    :   AssertionWith (assertionListExpectation)+
    ;

assertionListExpectation
    :   AssertionListExpectationTest Colon (AssertionExists | AssertionExistsNot) Semi
    ;

assertionCompare returns [COpBin op]
    :   (Equals | EqualsEquals) {$op = COpBin.EQ;}
    |   NotEquals               {$op = COpBin.NEQ;}
    |   GreaterEquals           {$op = COpBin.GTE;}
    |   LessEquals              {$op = COpBin.LTE;}
    |   Less                    {$op = COpBin.LT;}
    |   Greater                 {$op = COpBin.GT;}
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

// Must be overwritten in child grammars
LitmusLanguage  :   'BaseLitmusLanguage';

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