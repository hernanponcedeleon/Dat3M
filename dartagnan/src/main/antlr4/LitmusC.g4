grammar LitmusC;

import LinuxLexer, C11Lexer, LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.op.*;
import static com.dat3m.dartagnan.program.event.Tag.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? comment? EOF
    ;

variableDeclaratorList
    :   LBrace (globalDeclarator Semi comment?)* RBrace (Semi)?
    ;

globalDeclarator
    :   typeSpecifier? LBracket? varName RBracket? (Equals initConstantValue)?                                                              # globalDeclaratorLocation
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
    :   ( AtomicAddReturn        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_MB;}
        | AtomicAddReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELAXED;}
        | AtomicAddReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicAddReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELEASE;}
        | AtomicSubReturn        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;}
        | AtomicSubReturnRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELAXED;}
        | AtomicSubReturnAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicSubReturnRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELEASE;}
        | AtomicIncReturn        LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_MB;}
        | AtomicIncReturnRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELAXED;}
        | AtomicIncReturnAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicIncReturnRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELEASE;}
        | AtomicDecReturn        LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;}
        | AtomicDecReturnRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELAXED;}
        | AtomicDecReturnAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicDecReturnRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELEASE;})                        # reAtomicOpReturn
    
    |   ( C11AtomicAdd LPar address = re Comma value = re Comma c11Mo RPar {$op = IOpBin.PLUS;}
        | C11AtomicSub LPar address = re Comma value = re Comma c11Mo RPar {$op = IOpBin.MINUS;}
        | C11AtomicOr LPar address = re Comma value = re Comma c11Mo RPar {$op = IOpBin.OR;}
        | C11AtomicXor LPar address = re Comma value = re Comma c11Mo RPar {$op = IOpBin.XOR;}
        | C11AtomicAnd LPar address = re Comma value = re Comma c11Mo RPar {$op = IOpBin.AND;})                               # C11AtomicOp

    |   ( AtomicFetchAdd        LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_MB;}
        | AtomicFetchAddRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELAXED;}
        | AtomicFetchAddAcquire LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchAddRelease LPar value = re Comma address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELEASE;}
        | AtomicFetchSub        LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;}
        | AtomicFetchSubRelaxed LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELAXED;}
        | AtomicFetchSubAcquire LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchSubRelease LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELEASE;}
        | AtomicFetchInc        LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_MB;}
        | AtomicFetchIncRelaxed LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELAXED;}
        | AtomicFetchIncAcquire LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchIncRelease LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_RELEASE;}
        | AtomicFetchDec        LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;}
        | AtomicFetchDecRelaxed LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELAXED;}
        | AtomicFetchDecAcquire LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchDecRelease LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_RELEASE;})                         # reAtomicFetchOp

    |   ( AtomicXchg        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | AtomicXchgRelaxed LPar address = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | AtomicXchgAcquire LPar address = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicXchgRelease LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                # reXchg

    |   ( Xchg        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | XchgRelaxed LPar address = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | XchgAcquire LPar address = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | XchgRelease LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                      # reXchg

    |   ( AtomicCmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | AtomicCmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | AtomicCmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicCmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})              # reCmpXchg

    |   C11AtomicSCAS LPar address = re Comma expectedAdd = re Comma value = re Comma c11Mo Comma c11Mo RPar                       # reC11SCmpXchg
    |   C11AtomicWCAS LPar address = re Comma expectedAdd = re Comma value = re Comma c11Mo Comma c11Mo RPar                       # reC11WCmpXchg

    |   ( CmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | CmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | CmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | CmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                    # reCmpXchg

    |   ( AtomicSubAndTest LPar value = re Comma address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;}
        | AtomicIncAndTest LPar address = re RPar {$op = IOpBin.PLUS; $mo = Linux.MO_MB;}
        | AtomicDecAndTest LPar address = re RPar {$op = IOpBin.MINUS; $mo = Linux.MO_MB;})                                   # reAtomicOpAndTest

    |   AtomicAddUnless LPar address = re Comma value = re Comma cmp = re RPar                                          # reAtomicAddUnless

    |   C11AtomicLoad    LPar address = re Comma c11Mo RPar                                                            # reC11Load

    |   ( AtomicReadAcquire LPar address = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicRead        LPar address = re RPar {$mo = Linux.MO_ONCE;}
        | RcuDereference    LPar Ast? address = re RPar {$mo = Linux.MO_ONCE;}
        | SmpLoadAcquire    LPar address = re RPar {$mo = Linux.MO_ACQUIRE;})                                                 # reLoad

    |   ReadOnce LPar Ast address = re RPar {$mo = Linux.MO_ONCE;}                                                             # reReadOnce
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

    |   ( AtomicSet         LPar address = re Comma value = re RPar {$mo = Linux.MO_ONCE;}
        | AtomicSetRelease  LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;}
        | SmpStoreRelease   LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;}
        | SmpStoreMb        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | RcuAssignPointer  LPar Ast? address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                           # nreStore

    |   WriteOnce LPar Ast address = re Comma value = re RPar {$mo = Linux.MO_ONCE;}                                           # nreWriteOnce

    |   C11AtomicStore    LPar address = re  Comma value = re Comma c11Mo RPar                                          # nreC11Store

    |   Ast? varName Equals re                                                                                          # nreAssignment
    |   typeSpecifier varName (Equals re)?                                                                              # nreRegDeclaration

    |   SpinLock LPar address = re RPar                                                                               # nreSpinLock
    |   SpinUnlock LPar address = re RPar                                                                             # nreSpinUnlock
//    |   SpinUnlockWait LPar address = re RPar                                                                         # nreSpinUnlockWait

    |   ( FenceSmpMb LPar RPar {$name = Linux.MO_MB;}
        | FenceSmpWMb LPar RPar {$name = Linux.MO_WMB;}
        | FenceSmpRMb LPar RPar {$name = Linux.MO_RMB;}
        | FenceSmpMbBeforeAtomic LPar RPar {$name = Linux.BEFORE_ATOMIC;}
        | FenceSmpMbAfterAtomic LPar RPar {$name = Linux.AFTER_ATOMIC;}
        | FenceSmpMbAfterSpinLock LPar RPar {$name = Linux.AFTER_SPINLOCK;}
        | FenceSmpMbAfterUnlockLock LPar RPar {$name = Linux.AFTER_UNLOCK_LOCK;}
        | RcuReadLock LPar RPar {$name = Linux.RCU_LOCK;}
        | RcuReadUnlock LPar RPar {$name = Linux.RCU_UNLOCK;}
        | (RcuSync | RcuSyncExpedited) LPar RPar {$name = Linux.RCU_SYNC;})                                             # nreFence

    |   C11AtomicFence LPar c11Mo RPar                                                                                  # nreC11Fence

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

c11Mo returns [String mo]
    :   MoRelaxed   {$mo = C11.MO_RELAXED;}
    |   MoConsume   {$mo = C11.MO_CONSUME;}
    |   MoAcquire   {$mo = C11.MO_ACQUIRE;}
    |   MoRelease   {$mo = C11.MO_RELEASE;}
    |   MoAcqRel    {$mo = C11.MO_ACQUIRE_RELEASE;}
    |   MoSeqCst    {$mo = C11.MO_SC;}
    ;

threadVariable returns [int tid, String name]
    :   t = threadId Colon n = varName  {$tid = $t.id; $name = $n.text;}
    ;

initConstantValue
    :   AtomicInit LPar constant RPar
    |   constant
    ;

initArray
    :   LBrace arrayElement* (Comma arrayElement)* RBrace
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
    |   AtomicInt
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

MoRelaxed
    :   'memory_order_relaxed'
    ;

MoConsume
    :   'memory_order_consume'
    ;

MoAcquire
    :   'memory_order_acquire'
    ;

MoRelease
    :   'memory_order_release'
    ;

MoAcqRel
    :   'memory_order_acq_rel'
    ;

MoSeqCst
    :   'memory_order_seq_cst'
    ;

Locations
    :   'locations'
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

AtomicInt
    :   'atomic_int'
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
