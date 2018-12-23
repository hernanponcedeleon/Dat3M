grammar Porthos;

import BaseLexer;

@header{
import dartagnan.asserts.*;
import dartagnan.expression.op.*;
import dartagnan.expression.IntExprInterface;
import dartagnan.expression.IConst;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.memory.Location;
}

@parser::members{
ProgramBuilder pb;
}

main [ProgramBuilder programBuilder]
@init {
    pb = programBuilder;
}
    :    variableDeclaratorList program assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace location? (Comma location)* Comma? RBrace
    ;

program
    :   thread+
    ;

thread
    :   ThreadT threadId LBrace expressionSequence RBrace
    ;

expressionSequence
    :   expression*
    ;

expression
	:   instruction Semi                                                                                # expressionInstruction
	|   While boolExpr LBrace expressionSequence RBrace                                                 # expressionWhile
    |   If boolExpr Then? LBrace expressionSequence RBrace (Else LBrace expressionSequence RBrace)?     # expressionIf
	;

instruction
    :   register LocalOp arithExpr                                                                      # instructionLocal
	|   register LoadOp location                                                                        # instructionLoad
	|   location StoreOp arithExpr                                                                      # instructionStore
	|   register Equals location Period Load LPar MemoryOrder RPar                                      # instructionRead
	|   location Period Store LPar MemoryOrder Comma arithExpr RPar                                     # instructionWrite
    |   fence                                                                                           # instructionFence
	;

arithExpr
    :   arithExpr opArith arithExpr                                                                     # arithExprAExpr
    |   LPar arithExpr RPar                                                                             # arithExprChild
	|   register                                                                                        # arithExprRegister
	|   value                                                                                           # arithExprConst
	;

boolExpr
    :   boolExpr opBoolBin boolExpr                                                                     # boolExprBExprBin
    |   opBoolUn boolExpr                                                                               # boolExprBExprUn
    |   arithExpr opCompare arithExpr                                                                   # boolExprAtom
    |   LPar boolExpr RPar                                                                              # boolExprChild
    |   (True | False)                                                                                  # boolExprConst
    ;

assertionList returns [AbstractAssert ass]
    :   AssertionExists a = assertion Semi? {$ass = $a.ass; $ass.setType(AbstractAssert.ASSERT_TYPE_EXISTS);}
    |   (Not | Tilde) AssertionExists a = assertion Semi? {$ass = $a.ass; $ass.setType(AbstractAssert.ASSERT_TYPE_NOT_EXISTS);}
    |   AssertionForall a = assertion Semi? {$ass = $a.ass; $ass.setType(AbstractAssert.ASSERT_TYPE_FORALL);}
    ;

assertion returns [AbstractAssert ass]
    :   LPar a = assertion RPar {$ass = $a.ass;}
    |   Not a = assertion {$ass = new AssertNot($a.ass);}
    |   a1 = assertion And a2 = assertion {$ass = new AssertCompositeAnd($a1.ass, $a2.ass);}
    |   a1 = assertion Or a2 = assertion {$ass = new AssertCompositeOr($a1.ass, $a2.ass);}
    |   v1 = assertionValue op = assertionCompare v2 = assertionValue {$ass = new AssertBasic($v1.v, $op.op, $v2.v instanceof Location ? ((Location)$v2.v).getAddress() : $v2.v);}
    ;

assertionValue returns [IntExprInterface v]
    :   location {$v = pb.getOrCreateLocation($location.text);}
    |   threadId Colon register {$v = pb.getOrCreateRegister($threadId.text, $register.text);}
    |   value {$v = new IConst(Integer.parseInt($value.text));}
    ;

fence
    :   Mfence
    |   Lwsync
    |   Isync
    |   Sync
    ;

location
    :   Identifier
    ;

register
    :   Identifier
    ;

threadId
    :   DigitSequence
    ;

value
    :   DigitSequence
    ;

assertionCompare returns [COpBin op]
    :   (Equals | EqualsEquals) {$op = COpBin.EQ;}
    |   NotEquals               {$op = COpBin.NEQ;}
    |   GreaterEquals           {$op = COpBin.GTE;}
    |   LessEquals              {$op = COpBin.LTE;}
    |   Less                    {$op = COpBin.LT;}
    |   Greater                 {$op = COpBin.GT;}
    ;

opCompare returns [COpBin op]
    :   EqualsEquals            {$op = COpBin.EQ;}
    |   NotEquals               {$op = COpBin.NEQ;}
    |   GreaterEquals           {$op = COpBin.GTE;}
    |   LessEquals              {$op = COpBin.LTE;}
    |   Less                    {$op = COpBin.LT;}
    |   Greater                 {$op = COpBin.GT;}
    ;

opArith returns [IOpBin op]
    :   Plus                    {$op = IOpBin.PLUS;}
    |   Minus                   {$op = IOpBin.MINUS;}
    |   Ast                     {$op = IOpBin.MULT;}
    |   Slash                   {$op = IOpBin.DIV;}
    |   Amp                     {$op = IOpBin.AND;}
    |   Bar                     {$op = IOpBin.OR;}
    |   Circ                    {$op = IOpBin.XOR;}
    ;

opBoolBin returns [BOpBin op]
    :   And                     {$op = BOpBin.AND;}
    |   Or                      {$op = BOpBin.OR;}
    ;

opBoolUn returns [BOpUn op]
    :   Not                     {$op = BOpUn.NOT;}
    ;

ThreadT
    :   'thread t'
    ;

Store
    :   'store'
    ;

Load
    :   'load'
    ;

While
    :   'while'
    ;

If
    :   'if'
    ;

Then
    :   'then'
    ;

Else
    :   'else'
    ;

True
    :   'True'
    |   'true'
    ;

False
    :   'False'
    |   'false'
    ;

Mfence
    :   'mfence'
    ;

Lwsync
    :   'lwsync'
    ;

Isync
    :   'isync'
    ;

Sync
    :   'sync'
    ;

MemoryOrder
    :   '_na'
    |   '_sc'
    |   '_rx'
    |   '_acq'
    |   '_rel'
    |   '_con'
    ;

AssertionExists
    :   'exists'
    ;

AssertionForall
    :   'forall'
    ;

LocalOp
    :   '<-'
    ;

StoreOp
    :   ':='
    ;

LoadOp
    :   '<:-'
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

And
    :   'and'
    |   '&&'
    ;

Or
    :   'or'
    |   '||'
    ;

Not
    :   'not'
    |   '!'
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