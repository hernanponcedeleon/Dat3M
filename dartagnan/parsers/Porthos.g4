grammar Porthos;

import LitmusAssertions;

@header{
import dartagnan.expression.op.*;
}

main
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
	|   constant                                                                                        # arithExprConst
	;

boolExpr
    :   boolExpr opBoolBin boolExpr                                                                     # boolExprBExprBin
    |   opBoolUn boolExpr                                                                               # boolExprBExprUn
    |   arithExpr opCompare arithExpr                                                                   # boolExprAtom
    |   LPar boolExpr RPar                                                                              # boolExprChild
    |   (True | False)                                                                                  # boolExprConst
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

AssertionNot
    :   Not
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

LocalOp
    :   '<-'
    ;

StoreOp
    :   ':='
    ;

LoadOp
    :   '<:-'
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
    |   Excl
    ;