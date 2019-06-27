grammar LitmusC;

import LinuxLexer, LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.op.*;
import com.dat3m.dartagnan.program.arch.linux.utils.Mo;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
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
    |   typeSpecifier? varName (Equals Ast? (Amp? varName | LPar Amp? varName RPar))?                                   # globalDeclaratorLocationLocation
    |   typeSpecifier? t = threadId Colon n = varName (Equals Ast? (Amp? varName | LPar Amp? varName RPar))?            # globalDeclaratorRegisterLocation
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
    :   ( AtomicAddReturn        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.MB;}
        | AtomicAddReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELAXED;}
        | AtomicAddReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.ACQUIRE;}
        | AtomicAddReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELEASE;}
        | AtomicSubReturn        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;}
        | AtomicSubReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELAXED;}
        | AtomicSubReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.ACQUIRE;}
        | AtomicSubReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELEASE;}
        | AtomicIncReturn        LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.MB;}
        | AtomicIncReturnRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELAXED;}
        | AtomicIncReturnAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.ACQUIRE;}
        | AtomicIncReturnRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELEASE;}
        | AtomicDecReturn        LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;}
        | AtomicDecReturnRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELAXED;}
        | AtomicDecReturnAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.ACQUIRE;}
        | AtomicDecReturnRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELEASE;})                        # reAtomicOpReturn

    |   ( AtomicFetchAdd        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.MB;}
        | AtomicFetchAddRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELAXED;}
        | AtomicFetchAddAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.ACQUIRE;}
        | AtomicFetchAddRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELEASE;}
        | AtomicFetchSub        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;}
        | AtomicFetchSubRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELAXED;}
        | AtomicFetchSubAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.ACQUIRE;}
        | AtomicFetchSubRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELEASE;}
        | AtomicFetchInc        LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.MB;}
        | AtomicFetchIncRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELAXED;}
        | AtomicFetchIncAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.ACQUIRE;}
        | AtomicFetchIncRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.RELEASE;}
        | AtomicFetchDec        LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;}
        | AtomicFetchDecRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELAXED;}
        | AtomicFetchDecAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.ACQUIRE;}
        | AtomicFetchDecRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.RELEASE;})                         # reAtomicFetchOp

    |   ( AtomicXchg        LPar address = re Comma value = re RPar {$mo = Mo.MB;}
        | AtomicXchgRelaxed LPar address = re Comma value = re RPar {$mo = Mo.RELAXED;}
        | AtomicXchgAcquire LPar address = re Comma value = re RPar {$mo = Mo.ACQUIRE;}
        | AtomicXchgRelease LPar address = re Comma value = re RPar {$mo = Mo.RELEASE;})                                # reXchg

    |   ( Xchg        LPar address = re Comma value = re RPar {$mo = Mo.MB;}
        | XchgRelaxed LPar address = re Comma value = re RPar {$mo = Mo.RELAXED;}
        | XchgAcquire LPar address = re Comma value = re RPar {$mo = Mo.ACQUIRE;}
        | XchgRelease LPar address = re Comma value = re RPar {$mo = Mo.RELEASE;})                                      # reXchg

    |   ( AtomicCmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.MB;}
        | AtomicCmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.RELAXED;}
        | AtomicCmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.ACQUIRE;}
        | AtomicCmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.RELEASE;})              # reCmpXchg

    |   ( CmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.MB;}
        | CmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.RELAXED;}
        | CmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.ACQUIRE;}
        | CmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Mo.RELEASE;})                    # reCmpXchg

    |   ( AtomicSubAndTest LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;}
        | AtomicIncAndTest LPar address = re RPar {$op = IOpBin.PLUS; $mo = Mo.MB;}
        | AtomicDecAndTest LPar address = re RPar {$op = IOpBin.MINUS; $mo = Mo.MB;})                                   # reAtomicOpAndTest

    |   AtomicAddUnless LPar address = re Comma value = re Comma cmp = re RPar                                          # reAtomicAddUnless

    |   ( AtomicReadAcquire LPar address = re RPar {$mo = Mo.ACQUIRE;}
        | AtomicRead        LPar address = re RPar {$mo = Mo.RELAXED;}
        | RcuDereference    LPar Ast? address = re RPar {$mo = Mo.RELAXED;}
        | SmpLoadAcquire    LPar address = re RPar {$mo = Mo.ACQUIRE;})                                                 # reLoad

    |   ReadOnce LPar Ast address = re RPar {$mo = "Once";}                                                             # reReadOnce
    |   Ast address = re {$mo = "NA";}                                                                                  # reReadNa

//    |   SpinTrylock LPar address = re RPar                                                                            # reSpinTryLock
//    |   SpiIsLocked LPar address = re RPar                                                                            # reSpinIsLocked

    |   boolConst                                                                                                       # reBoolConst
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

    |   ( AtomicSet         LPar address = re Comma value = re RPar {$mo = Mo.RELAXED;}
        | AtomicSetRelease  LPar address = re Comma value = re RPar {$mo = Mo.RELEASE;}
        | SmpStoreRelease   LPar address = re Comma value = re RPar {$mo = Mo.RELEASE;}
        | SmpStoreMb        LPar address = re Comma value = re RPar {$mo = Mo.MB;}
        | RcuAssignPointer  LPar Ast? address = re Comma value = re RPar {$mo = Mo.RELEASE;})                           # nreStore

    |   WriteOnce LPar Ast address = re Comma value = re RPar {$mo = "Once";}                                           # nreWriteOnce

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
        | FenceSmpMbAfterSpinLock LPar RPar {$name = "After-spinlock";}
        | RcuReadLock LPar RPar {$name = EType.RCU_LOCK;}
        | RcuReadUnlock LPar RPar {$name = EType.RCU_UNLOCK;}
        | (RcuSync | RcuSyncExpedited) LPar RPar {$name = EType.RCU_SYNC;})                                             # nreFence

    ;

variableList
    :   Locations LBracket (threadVariable | varName) (Semi (threadVariable | varName))* Semi? RBracket
    ;

boolConst returns [Boolean value]
    :   True    {$value = true;}
    |   False   {$value = false;}
    ;

opBool returns [BOpBin op]
    :   AmpAmp  {$op = BOpBin.AND;}
    |   BarBar  {$op = BOpBin.OR;}
    ;

opCompare returns [COpBin op]
    :   EqualsEquals    {$op = COpBin.EQ;}
    |   NotEquals       {$op = COpBin.NEQ;}
    |   LessEquals      {$op = COpBin.LTE;}
    |   GreaterEquals   {$op = COpBin.GTE;}
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

threadVariable returns [int tid, String name]
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
    :   constant
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

True
    :   'true'
    ;

False
    :   'false'
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