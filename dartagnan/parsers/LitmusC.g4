grammar LitmusC;

import LinuxLexer, LitmusAssertions;

@header{
import dartagnan.expression.op.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? comment? EOF
    ;

variableDeclaratorList
    :   LBrace (globalDeclarator Semi comment?)* RBrace (Semi)?
    ;

globalDeclarator
    :   typeSpecifier? varName (Equals initConstantValue)?                                                              # globalDeclaratorLocation
    |   typeSpecifier? t = threadId Colon n = varName (Equals initConstantValue)?                                       # globalDeclaratorRegister
    |   typeSpecifier? varName (Equals Amp? varName)?                                                                   # globalDeclaratorLocationLocation
    |   typeSpecifier? t = threadId Colon n = varName (Equals Amp? varName)?                                            # globalDeclaratorRegisterLocation
    |   typeSpecifier? varName LBracket DigitSequence? RBracket (Equals initArray)?                                     # globalDeclaratorArray
    ;

program
    :   thread+
    ;

thread
    :   threadId LPar threadArguments? RPar LBrace expression* RBrace
    ;

threadArguments
    :   pointerTypeSpecifier varName (Comma pointerTypeSpecifier varName)*
    ;

expression
    :   nre Semi
    |   ifExpression
    |   whileExpression
    ;

whileExpression
    :   While LPar re RPar expression
    |   While LPar re RPar LBrace expression* RBrace
    ;

ifExpression
    :   If LPar re RPar expression elseExpression?
    |   If LPar re RPar LBrace expression* RBrace elseExpression?
    ;

elseExpression
    :   Else expression
    |   Else LBrace expression* RBrace
    ;

re locals [IOpBin op, String mo]
    :   ( AtomicAddReturn        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicAddReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicAddReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicAddReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicSubReturn        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicSubReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicSubReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicSubReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Release";}
        | AtomicIncReturn        LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicIncReturnRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicIncReturnAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicIncReturnRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicDecReturn        LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicDecReturnRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicDecReturnAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicDecReturnRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Release";})                         # reAtomicOpReturn

    |   ( AtomicFetchAdd        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicFetchAddRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicFetchAddAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicFetchAddRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicFetchSub        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicFetchSubRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicFetchSubAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicFetchSubRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Release";}
        | AtomicFetchInc        LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicFetchIncRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicFetchIncAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicFetchIncRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicFetchDec        LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicFetchDecRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicFetchDecAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicFetchDecRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Release";})                          # reAtomicFetchOp

    |   ( AtomicXchg        LPar address = re Comma value = re RPar {$mo = "Mb";}
        | AtomicXchgRelaxed LPar address = re Comma value = re RPar {$mo = "Relaxed";}
        | AtomicXchgAcquire LPar address = re Comma value = re RPar {$mo = "Acquire";}
        | AtomicXchgRelease LPar address = re Comma value = re RPar {$mo = "Release";})                                 # reXchg

    |   ( Xchg        LPar address = re Comma value = re RPar {$mo = "Mb";}
        | XchgRelaxed LPar address = re Comma value = re RPar {$mo = "Relaxed";}
        | XchgAcquire LPar address = re Comma value = re RPar {$mo = "Acquire";}
        | XchgRelease LPar address = re Comma value = re RPar {$mo = "Release";})                                       # reXchg

    |   ( AtomicCmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Mb";}
        | AtomicCmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Relaxed";}
        | AtomicCmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Acquire";}
        | AtomicCmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Release";})               # reCmpXchg

    |   ( CmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Mb";}
        | CmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Relaxed";}
        | CmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Acquire";}
        | CmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = "Release";})                     # reCmpXchg

    |   ( AtomicSubAndTest LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicIncAndTest LPar address = re RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicDecAndTest LPar address = re RPar {$op = IOpBin.MINUS; $mo = "Mb";})                                    # reAtomicOpAndTest

    |   AtomicAddUnless LPar address = re Comma value = re Comma cmp = re RPar                                          # reAtomicAddUnless

    |   ( AtomicReadAcquire LPar address = re RPar {$mo = "Acquire";}
        | AtomicRead        LPar address = re RPar {$mo = "Relaxed";}
        | RcuDereference    LPar Ast? address = re RPar {$mo = "Dereference";}
        | SmpLoadAcquire    LPar address = re RPar {$mo = "Acquire";})                                                  # reLoad

    |   ReadOnce LPar Ast address = re RPar {$mo = "Once";}                                                             # reReadOnce
    |   Ast address = re {$mo = "NA";}                                                                                  # reReadNa

//    |   SpinTrylock LPar address = re RPar                                                                            # reSpinTryLock
//    |   SpiIsLocked LPar address = re RPar                                                                            # reSpinIsLocked

    |   Excl re                                                                                                         # reOpBoolNot
    |   re opBool re                                                                                                    # reOpBool
    |   re opCompare re                                                                                                 # reOpCompare
    |   re opArith re                                                                                                   # reOpArith

    |   LPar re RPar                                                                                                    # reParenthesis
    |   cast re                                                                                                         # reCast
    |   varName                                                                                                         # reVarName
    |   constant                                                                                                        # reConst
    ;

nre locals [IOpBin op, String mo, String name]
    :   ( AtomicAdd LPar value = re Comma address = re RPar {$op = IOpBin.PLUS;}
        | AtomicSub LPar value = re Comma address = re RPar {$op = IOpBin.MINUS;}
        | AtomicInc LPar address = re RPar {$op = IOpBin.PLUS;}
        | AtomicDec LPar address = re RPar {$op = IOpBin.MINUS;})                                                       # nreAtomicOp

    |   ( AtomicSet         LPar address = re Comma value = re RPar {$mo = "Relaxed";}
        | AtomicSetRelease  LPar address = re Comma value = re RPar {$mo = "Release";}
        | SmpStoreRelease   LPar address = re Comma value = re RPar {$mo = "Release";}
        | SmpStoreMb        LPar address = re Comma value = re RPar {$mo = "Mb";}
        | RcuAssignPointer  LPar Ast? address = re Comma value = re RPar {$mo = "Release";})                            # nreStore

    |   WriteOnce LPar Ast address = re Comma value = re RPar {$mo = "Once";}                                           # nreWriteOnce

    |   RcuReadLock LPar RPar                                                                                           # nreRcuReadLock
    |   RcuReadUnlock LPar RPar                                                                                         # nreRcuReadUnlock
    |   ( RcuSync LPar RPar
        | RcuSyncExpedited LPar RPar)                                                                                   # nreSynchronizeRcu

    |   Ast? varName Equals re                                                                                          # nreAssignment
    |   typeSpecifier varName (Equals re)?                                                                              # nreRegDeclaration

//    |   SpinLock LPar address = re RPar                                                                               # nreSpinLock
//    |   SpinUnlock LPar address = re RPar                                                                             # nreSpinUnlock
//    |   SpinUnlockWait LPar address = re RPar                                                                         # nreSpinUnlockWait

    |   ( FenceSmpMb LPar RPar {$name = "Mb";}
        | FenceSmpWMb LPar RPar {$name = "Wmb";}
        | FenceSmpRMb LPar RPar {$name = "Rmb";}
        | FenceSmpMbBeforeAtomic LPar RPar {$name = "Before-atomic";}
        | FenceSmpMbAfterAtomic LPar RPar {$name = "After-atomic";}
        | FenceSmpMbAfterSpinLock LPar RPar {$name = "After-spinlock";})                                                # nreFence
    ;

variableList
    :   Locations LBracket (threadVariable | varName) (Semi (threadVariable | varName))* Semi? RBracket
    ;

opBool returns [BOpBin op]
    :   AmpAmp  {$op = BOpBin.AND;}
    |   BarBar  {$op = BOpBin.OR;}
    ;

opCompare returns [COpBin op]
    :   EqualsEquals    {$op = COpBin.EQ;}
    |   NotEquals       {$op = COpBin.NEQ;}
    |   LessEquals      {$op = COpBin.GTE;}
    |   GreaterEquals   {$op = COpBin.LTE;}
    |   Less            {$op = COpBin.LT;}
    |   Greater         {$op = COpBin.GT;}
    ;

opArith returns [IOpBin op]
    :   Plus    {$op = IOpBin.PLUS;}
    |   Minus   {$op = IOpBin.MINUS;}
    |   Amp     {$op = IOpBin.AND;}
    |   Bar     {$op = IOpBin.OR;}
    |   Circ    {$op = IOpBin.XOR;}
    ;

threadVariable returns [String tid, String name]
    :   t = threadId Colon n = varName  {$tid = $t.id; $name = $n.text;}
    ;

initConstantValue
    :   AtomicInit LPar constant RPar
    |   constant
    ;

initArray
    :   LBrace arrayElement (Comma arrayElement)* RBrace
    ;

arrayElement
    :   DigitSequence
    |   Ast? (Amp? varName | LPar Amp? varName RPar)
    ;

cast
    :   LPar typeSpecifier Ast* RPar
    ;

pointerTypeSpecifier
    :   (Volatile)? basicTypeSpecifier Ast
    |   (Volatile)? atomicTypeSpecifier Ast
    ;

typeSpecifier
    :   (Volatile)? basicTypeSpecifier Ast*
    |   (Volatile)? atomicTypeSpecifier Ast*
    ;

basicTypeSpecifier
    :   Int
    |   IntPtr
    |   Char
    ;

atomicTypeSpecifier
    :   AtomicT
    |   SpinlockT
    ;

varName
    :   Underscore* Identifier (Underscore (Identifier | DigitSequence)*)*
    ;

// Allowed outside of thread body (otherwise might conflict with pointer cast)
comment
    :   LPar Ast .*? Ast RPar
    ;

Locations
    :   'locations'
    ;

While
    :   'while'
    ;

If
    :   'if'
    ;

Else
    :   'else'
    ;

Volatile
    :   'volatile'
    ;

Int
    :   'int'
    ;

IntPtr
    :   'intptr_t'
    ;

Char
    :   'char'
    ;

AtomicT
    :   'atomic_t'
    ;

SpinlockT
    :   'spinlock_t'
    ;

AmpAmp
    :   '&&'
    ;

BarBar
    :   '||'
    ;

LitmusLanguage
    :   'C'
    ;

AssertionNot
    :   Tilde
    |   'not'
    ;

BlockComment
    :   '/*' .*? '*/'
        -> channel(HIDDEN)
    ;

LineComment
    :   '//' .*? Newline
        -> channel(HIDDEN)
    ;