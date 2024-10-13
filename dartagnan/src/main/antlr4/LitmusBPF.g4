grammar LitmusBPF;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.integers.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace variableDeclarator? (Semi variableDeclarator)* Semi? RBrace Semi?
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    |   variableDeclaratorLocationLocation
    ;

variableDeclaratorLocation
    :   typeSpecifier location (Equals constant)?
    ;

variableDeclaratorRegister
    :   threadId Colon register Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location
    ;

variableList
    :   Locations LBracket variable (Semi variable)* Semi? RBracket
    ;

variable
    :   location
    |   threadId Colon register
    ;

typeSpecifier
    :   Int
    ;

uTypeSpecifier
    :   Uetype
    |   Ustype
    |   Uttype
    |   Usftype
    ;

program
    :   threadDeclaratorList instructionList
    ;

threadDeclaratorList
    :   threadId (ThreadSeparator threadId)* Semi
    ;

instructionList
    :   (instructionRow)+
    ;

instructionRow
    :   instruction (ThreadSeparator instruction)* Semi
    ;

instruction
    :
    |   local
    |   load
    |   loadAcquire
    |   store
    |   storeRelease
    |   atomicRMW
    |   atomicFetchRMW
    |   label
    |   jump
    ;

local
    :   register operation? Equals value
    ;

load
    :   register Equals mwt LPar register Add constant RPar
    ;

loadAcquire
    :   register Equals LoadAcquire LPar awt LPar register Add constant RPar RPar
    ;

store
    :   mwt LPar register Add constant RPar Equals value
    ;

storeRelease
    :   StoreRelease LPar awt LPar register Add constant RPar Comma value RPar
    ;

atomicRMW
    :   Lock mwt LPar register Add constant RPar atomicOperation Equals value
    ;

atomicFetchRMW locals [IntBinaryOp op]
    :   register Equals AtomicFetchAdd LPar awt LPar register Add constant RPar Comma value RPar {$op = IntBinaryOp.ADD;}
    |   register Equals AtomicFetchSub LPar awt LPar register Add constant RPar Comma value RPar {$op = IntBinaryOp.SUB;}
    |   register Equals AtomicFetchAnd LPar awt LPar register Add constant RPar Comma value RPar {$op = IntBinaryOp.AND;}
    |   register Equals AtomicFetchOr LPar awt LPar register Add constant RPar Comma value RPar {$op = IntBinaryOp.OR;}
    ;

mwt
    :   Pointer LPar uTypeSpecifier Pointer RPar
    ;

awt
    :   LPar uTypeSpecifier Pointer RPar
    ;

label
    :   Identifier Colon
    ;

jump
    :   If value cond value Goto Identifier
    ;

value
    :   constant
    |   register
    ;

cond returns [IntCmpOp op]
    :   Eq {$op = IntCmpOp.EQ;}
    |   Ne {$op = IntCmpOp.NEQ;}
    |   Ge {$op = IntCmpOp.GTE;}
    |   Le {$op = IntCmpOp.LTE;}
    |   Gt {$op = IntCmpOp.GT;}
    |   Lt {$op = IntCmpOp.LT;}
    ;

operation returns [IntBinaryOp op]
    :   Add {$op = IntBinaryOp.ADD;}
    |   Sub {$op = IntBinaryOp.SUB;}
    |   Mul {$op = IntBinaryOp.MUL;}
    |   Div {$op = IntBinaryOp.DIV;}
    |   Mod {$op = IntBinaryOp.SREM;}
    |   And {$op = IntBinaryOp.AND;}
    |   Or {$op = IntBinaryOp.OR;}
    |   Xor {$op = IntBinaryOp.XOR;}
    |   Lshift {$op = IntBinaryOp.LSHIFT;}
    |   Rshift {$op = IntBinaryOp.RSHIFT;}
    ;

atomicOperation returns [IntBinaryOp op]
    :   Add {$op = IntBinaryOp.ADD;}
    |   Sub {$op = IntBinaryOp.SUB;}
    |   And {$op = IntBinaryOp.AND;}
    |   Or {$op = IntBinaryOp.OR;}
    ;

location
    :   Identifier
    ;

register
    :   Register
    ;

constant
    :   DigitSequence
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

// TODO Order

ThreadSeparator
    :   Bar
    ;

Pointer
    :   Ast
    ;

AtomicFetchAdd
    :   'atomic_fetch_add'
    ;

AtomicFetchSub
    :   'atomic_fetch_sub'
    ;

AtomicFetchAnd
    :   'atomic_fetch_and'
    ;

AtomicFetchOr
    :   'atomic_fetch_or'
    ;

LoadAcquire
    :   'load_acquire'
    ;

StoreRelease
    :   'store_release'
    ;

If
    :   'if'
    ;

Goto
    :   'goto'
    ;

Eq    :   '==';
Ne    :   '!=';
Lt    :   '<';
Gt    :   '>';
Le    :   '<=';
Ge    :   '>=';

Int
    :   'int'
    ;

Lock
    :   'lock'
    ;

Uetype
    :   'u8'
    ;

Ustype
    :   'u16'
    ;

Uttype
    :   'u32'
    ;

Usftype
    :   'u64'
    ;

Add
    :   Plus
    ;

Sub
    :   Minus
    ;

Mul
    :   Ast
    ;

Div
    :   Slash
    ;

Mod
    :   Percent
    ;

And
    :   Amp
    ;

Or
    :   Bar
    ;

Xor
    :   Circ
    ;

Lshift
    :   '<<'
    ;

Rshift
    :   '>>'
    ;

Locations
    :   'locations'
    ;

Register
    :   'r' DigitSequence
    ;

LitmusLanguage
    :   'BPF'
    ;