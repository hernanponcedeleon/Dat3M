grammar Porthos;

import BaseLexer;

@header{
package dartagnan.parsers;
import dartagnan.asserts.*;
import dartagnan.expression.utils.COpBin;
import dartagnan.program.*;
import dartagnan.program.event.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;
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
    :   ThreadT threadId LBrace expression* RBrace
    ;

expression
	:   instruction Semi
	|   While boolExpr LBrace expression* RBrace
    |   If boolExpr Then? LBrace expression* RBrace (Else LBrace expression* RBrace)?
	;

instruction
    :   register LocalOp arithExpr                                                      # instructionLocal
	|   register LoadOp location                                                        # instructionLoad
	|   location StoreOp register                                                       # instructionStore
	|   fence                                                                           # instructionFence
	|   register Equals location Period Load LPar MemoryOrder RPar                      # instructionRead
	|   location Period Store LPar MemoryOrder Comma (register | DigitSequence) RPar    # instructionWrite
	;

arithExpr
    :   arithExpr opArith arithExpr
    |   LPar arithExpr RPar
	|   register
	|   value
	;

boolExpr
    :   boolExpr opBool boolExpr
    |   arithExpr opCompare arithExpr
    |   LPar boolExpr RPar
    |   False
    |   True
    ;

assertionList
    :   AssertionExists assertion Semi?
    |   (Not | Tilde) AssertionExists assertion Semi?
    |   AssertionForall assertion Semi?
    ;

assertion returns [AbstractAssert ass]
    :   LPar a = assertion RPar {$ass = $a.ass;}
    |   Not a = assertion {$ass = new AssertNot($a.ass); }
    |   a1 = assertion And a2 = assertion
    |   a1 = assertion Or a2 = assertion
    |   v1 = assertionValue op = assertionCompare v2 = assertionValue
    ;

assertionValue returns [IntExprInterface v]
    :   location {$v = pb.getOrCreateLocation($location.text);}
    |   threadId Colon register {$v = pb.getOrCreateRegister($threadId.text, $register.text);}
    |   value {$v = new AConst(Integer.parseInt($value.text));}
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

assertionCompare returns [Op op]
    :   (Equals | EqualsEquals) {$op = Op.EQ;}
    |   NotEquals               {$op = Op.NEQ;}
    |   GreaterEquals           {$op = Op.GTE;}
    |   LessEquals              {$op = Op.LTE;}
    |   Less                    {$op = Op.LT;}
    |   Greater                 {$op = Op.GT;}
    ;

opCompare returns [Op op]
    :   EqualsEquals            {$op = Op.EQ;}
    |   NotEquals               {$op = Op.NEQ;}
    |   GreaterEquals           {$op = Op.GTE;}
    |   LessEquals              {$op = Op.LTE;}
    |   Less                    {$op = Op.LT;}
    |   Greater                 {$op = Op.GT;}
    ;

opArith returns [AOpBin op]
    :   Plus                    {$op = AOpBin.PLUS;}
    |   Minus                   {$op = AOpBin.MINUS;}
    |   Ast                     {$op = AOpBin.MULT;}
    |   Slash                   {$op = AOpBin.DIV;}
    |   Amp                     {$op = AOpBin.AND;}
    |   Bar                     {$op = AOpBin.OR;}
    |   Circ                    {$op = AOpBin.XOR;}
    ;

opBool returns [BOpBin op]
    :   And                     {$op = BOpBin.AND;}
    |   Or                      {$op = BOpBin.OR;}
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