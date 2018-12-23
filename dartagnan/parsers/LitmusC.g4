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
    |   typeSpecifier? varName (Equals varName)?                                                                        # globalDeclaratorLocationLocation
    |   typeSpecifier? t = threadId Colon n = varName (Equals varName)?                                                 # globalDeclaratorRegisterLocation
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
    :   nonReturnExpression Semi
    |   ifExpression
    |   whileExpression
    ;

whileExpression
    :   While LPar returnExpression RPar expression
    |   While LPar returnExpression RPar LBrace expression* RBrace
    ;

ifExpression
    :   If LPar returnExpression RPar expression elseExpression?
    |   If LPar returnExpression RPar LBrace expression* RBrace elseExpression?
    ;

elseExpression
    :   Else expression
    |   Else LBrace expression* RBrace
    ;

returnExpression locals [IOpBin op, String mo]
    :   ( AtomicAddReturn        LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicAddReturnRelaxed LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicAddReturnAcquire LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicAddReturnRelease LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicSubReturn        LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicSubReturnRelaxed LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicSubReturnAcquire LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicSubReturnRelease LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Release";}
        | AtomicIncReturn        LPar variable RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicIncReturnRelaxed LPar variable RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicIncReturnAcquire LPar variable RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicIncReturnRelease LPar variable RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicDecReturn        LPar variable RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicDecReturnRelaxed LPar variable RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicDecReturnAcquire LPar variable RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicDecReturnRelease LPar variable RPar {$op = IOpBin.MINUS; $mo = "Release";})                             # reAtomicOpReturn

    |   ( AtomicFetchAdd        LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicFetchAddRelaxed LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicFetchAddAcquire LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicFetchAddRelease LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicFetchSub        LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicFetchSubRelaxed LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicFetchSubAcquire LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicFetchSubRelease LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Release";}
        | AtomicFetchInc        LPar variable RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicFetchIncRelaxed LPar variable RPar {$op = IOpBin.PLUS; $mo = "Relaxed";}
        | AtomicFetchIncAcquire LPar variable RPar {$op = IOpBin.PLUS; $mo = "Acquire";}
        | AtomicFetchIncRelease LPar variable RPar {$op = IOpBin.PLUS; $mo = "Release";}
        | AtomicFetchDec        LPar variable RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicFetchDecRelaxed LPar variable RPar {$op = IOpBin.MINUS; $mo = "Relaxed";}
        | AtomicFetchDecAcquire LPar variable RPar {$op = IOpBin.MINUS; $mo = "Acquire";}
        | AtomicFetchDecRelease LPar variable RPar {$op = IOpBin.MINUS; $mo = "Release";})                              # reAtomicFetchOp

    |   ( AtomicXchg        LPar variable Comma returnExpression RPar {$mo = "Mb";}
        | AtomicXchgRelaxed LPar variable Comma returnExpression RPar {$mo = "Relaxed";}
        | AtomicXchgAcquire LPar variable Comma returnExpression RPar {$mo = "Acquire";}
        | AtomicXchgRelease LPar variable Comma returnExpression RPar {$mo = "Release";})                               # reXchg

    |   ( Xchg        LPar variable Comma returnExpression RPar {$mo = "Mb";}
        | XchgRelaxed LPar variable Comma returnExpression RPar {$mo = "Relaxed";}
        | XchgAcquire LPar variable Comma returnExpression RPar {$mo = "Acquire";}
        | XchgRelease LPar variable Comma returnExpression RPar {$mo = "Release";})                                     # reXchg

    |   ( AtomicCmpXchg        LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Mb";}
        | AtomicCmpXchgRelaxed LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Relaxed";}
        | AtomicCmpXchgAcquire LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Acquire";}
        | AtomicCmpXchgRelease LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Release";})     # reCmpXchg

    |   ( CmpXchg        LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Mb";}
        | CmpXchgRelaxed LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Relaxed";}
        | CmpXchgAcquire LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Acquire";}
        | CmpXchgRelease LPar variable Comma returnExpression Comma returnExpression RPar {$mo = "Release";})           # reCmpXchg

    |   ( AtomicSubAndTest LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS; $mo = "Mb";}
        | AtomicIncAndTest LPar variable RPar {$op = IOpBin.PLUS; $mo = "Mb";}
        | AtomicDecAndTest LPar variable RPar {$op = IOpBin.MINUS; $mo = "Mb";})                                        # reAtomicOpAndTest

    |   AtomicAddUnless LPar variable Comma returnExpression Comma returnExpression RPar                                # reAtomicAddUnless

    |   ( AtomicReadAcquire LPar variable RPar {$mo = "Acquire";}
        | AtomicRead        LPar variable RPar {$mo = "Relaxed";}
        | RcuDereference    LPar Ast? variable RPar {$mo = "Dereference";}
        | SmpLoadAcquire    LPar variable RPar {$mo = "Acquire";})                                                      # reLoad

    |   ReadOnce LPar Ast variable RPar {$mo = "Once";}                                                                 # reReadOnce
    |   Ast variable {$mo = "NA";}                                                                                      # reReadNa

//    |   SpinTrylock LPar variable RPar                                                                                  # reSpinTryLock
//    |   SpiIsLocked LPar variable RPar                                                                                  # reSpinIsLocked

    |   Excl returnExpression                                                                                           # reOpBoolNot
    |   returnExpression opBool returnExpression                                                                        # reOpBool
    |   returnExpression opCompare returnExpression                                                                     # reOpCompare
    |   returnExpression opArith returnExpression                                                                       # reOpArith

    |   LPar returnExpression RPar                                                                                      # reParenthesis
    |   cast returnExpression                                                                                           # reCast
    |   variable                                                                                                        # reVariable
    |   constant                                                                                                        # reConst
    ;

nonReturnExpression locals [IOpBin op, String mo, String name]
    :   ( AtomicAdd LPar returnExpression Comma variable RPar {$op = IOpBin.PLUS;}
        | AtomicSub LPar returnExpression Comma variable RPar {$op = IOpBin.MINUS;}
        | AtomicInc LPar variable RPar {$op = IOpBin.PLUS;}
        | AtomicDec LPar variable RPar {$op = IOpBin.MINUS;})                                                           # nreAtomicOp

    |   ( AtomicSet         LPar variable Comma returnExpression RPar {$mo = "Relaxed";}
        | AtomicSetRelease  LPar variable Comma returnExpression RPar {$mo = "Release";}
        | SmpStoreRelease   LPar variable Comma returnExpression RPar {$mo = "Release";}
        | SmpStoreMb        LPar variable Comma returnExpression RPar {$mo = "Mb";}
        | RcuAssignPointer  LPar Ast? variable Comma returnExpression RPar {$mo = "Release";})                          # nreStore

    |   WriteOnce LPar Ast variable Comma returnExpression RPar {$mo = "Once";}                                         # nreWriteOnce

    |   RcuReadLock LPar RPar                                                                                           # nreRcuReadLock
    |   RcuReadUnlock LPar RPar                                                                                         # nreRcuReadUnlock
    |   ( RcuSync LPar RPar
        | RcuSyncExpedited LPar RPar)                                                                                   # nreSynchronizeRcu

    |   Ast? varName Equals returnExpression                                                                            # nreAssignment
    |   typeSpecifier varName (Equals returnExpression)?                                                                # nreRegDeclaration

//    |   SpinLock LPar variable RPar                                                                                     # nreSpinLock
//    |   SpinUnlock LPar variable RPar                                                                                   # nreSpinUnlock
//    |   SpinUnlockWait LPar variable RPar                                                                               # nreSpinUnlockWait

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

variable
    :   cast variable
    |   varName
    ;

initConstantValue
    :   AtomicInit LPar constant RPar
    |   constant
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