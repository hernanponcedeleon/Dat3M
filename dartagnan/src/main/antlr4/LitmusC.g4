grammar LitmusC;

import LinuxLexer, C11Lexer, OpenCLLexer, LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.booleans.*;
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
    |   typeSpecifier? t = threadId Colon n = varName (Equals initConstantValue)?                                                           # globalDeclaratorRegister
    |   typeSpecifier? varName (Equals Ast? (Amp? varName | LPar Amp? varName RPar))?                                                       # globalDeclaratorLocationLocation
    |   typeSpecifier? t = threadId Colon n = varName (Equals Ast? (Amp? varName | LPar Amp? varName RPar))?                                # globalDeclaratorRegisterLocation
    |   typeSpecifier? varName LBracket DigitSequence? RBracket (Equals initArray)?                                                         # globalDeclaratorArray
    ;

program
    :   thread+
    ;

thread
    :   threadId (At threadScope)? LPar threadArguments? RPar LBrace expression* RBrace
    ;

threadScope
    :   OpenCLWG scopeID Comma OpenCLDEV scopeID                                                                                            # OpenCLThreadScope
    ;

threadArguments
    :   threadArgument (Comma threadArgument)*
    ;

threadArgument
    :   openCLSpace? pointerTypeSpecifier varName
    ;

expression
    :   nre Semi
    |   ifExpression
    |   whileExpression
    ;

ifExpression
    :   If LPar re RPar expression elseExpression?
    |   If LPar re RPar LBrace expression* RBrace elseExpression?
    ;

elseExpression
    :   Else expression
    |   Else LBrace expression* RBrace
    ;

whileExpression
    :   While LPar re RPar expression
    |   While LPar re RPar LBrace expression* RBrace
    ;

re locals [IntBinaryOp op, String mo]
    :   ( AtomicAddReturn        LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_MB;}
        | AtomicAddReturnRelaxed LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELAXED;}
        | AtomicAddReturnAcquire LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_ACQUIRE;}
        | AtomicAddReturnRelease LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELEASE;}
        | AtomicSubReturn        LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;}
        | AtomicSubReturnRelaxed LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELAXED;}
        | AtomicSubReturnAcquire LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_ACQUIRE;}
        | AtomicSubReturnRelease LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELEASE;}
        | AtomicIncReturn        LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_MB;}
        | AtomicIncReturnRelaxed LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELAXED;}
        | AtomicIncReturnAcquire LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_ACQUIRE;}
        | AtomicIncReturnRelease LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELEASE;}
        | AtomicDecReturn        LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;}
        | AtomicDecReturnRelaxed LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELAXED;}
        | AtomicDecReturnAcquire LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_ACQUIRE;}
        | AtomicDecReturnRelease LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELEASE;})                                   # reAtomicOpReturn
    
    |   ( C11AtomicAddExplicit LPar address = re Comma value = re Comma c11Mo (Comma openCLScope)? RPar {$op = IntBinaryOp.ADD;}
        | C11AtomicAdd         LPar address = re Comma value = re                                  RPar {$op = IntBinaryOp.ADD;}
        | C11AtomicSubExplicit LPar address = re Comma value = re Comma c11Mo (Comma openCLScope)? RPar {$op = IntBinaryOp.SUB;}
        | C11AtomicSub         LPar address = re Comma value = re                                  RPar {$op = IntBinaryOp.SUB;}
        | C11AtomicOrExplicit  LPar address = re Comma value = re Comma c11Mo (Comma openCLScope)? RPar {$op = IntBinaryOp.OR;}
        | C11AtomicOr          LPar address = re Comma value = re                                  RPar {$op = IntBinaryOp.OR;}
        | C11AtomicXorExplicit LPar address = re Comma value = re Comma c11Mo (Comma openCLScope)? RPar {$op = IntBinaryOp.XOR;}
        | C11AtomicXor         LPar address = re Comma value = re                                  RPar {$op = IntBinaryOp.XOR;}
        | C11AtomicAndExplicit LPar address = re Comma value = re Comma c11Mo (Comma openCLScope)? RPar {$op = IntBinaryOp.AND;}
        | C11AtomicAnd         LPar address = re Comma value = re                                  RPar {$op = IntBinaryOp.AND;})           # C11AtomicOp

    |   ( AtomicFetchAdd        LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_MB;}
        | AtomicFetchAddRelaxed LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELAXED;}
        | AtomicFetchAddAcquire LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchAddRelease LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELEASE;}
        | AtomicFetchSub        LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;}
        | AtomicFetchSubRelaxed LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELAXED;}
        | AtomicFetchSubAcquire LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchSubRelease LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELEASE;}
        | AtomicFetchInc        LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_MB;}
        | AtomicFetchIncRelaxed LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELAXED;}
        | AtomicFetchIncAcquire LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchIncRelease LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_RELEASE;}
        | AtomicFetchDec        LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;}
        | AtomicFetchDecRelaxed LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELAXED;}
        | AtomicFetchDecAcquire LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_ACQUIRE;}
        | AtomicFetchDecRelease LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_RELEASE;})                                    # reAtomicFetchOp

    |   ( AtomicXchg        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | AtomicXchgRelaxed LPar address = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | AtomicXchgAcquire LPar address = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicXchgRelease LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                              # reXchg

    |   ( Xchg        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | XchgRelaxed LPar address = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | XchgAcquire LPar address = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | XchgRelease LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                                    # reXchg

    |   C11AtomicXchg   LPar address = re Comma value = re Comma c11Mo RPar                                             # reC11AtomicXchg

    |   ( AtomicCmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | AtomicCmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | AtomicCmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicCmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                            # reCmpXchg

    |   C11AtomicSCASExplicit LPar address = re Comma expectedAdd = re Comma value = re Comma c11Mo Comma c11Mo (Comma openCLScope)? RPar   # reC11SCmpXchgExplicit
    |   C11AtomicSCAS         LPar address = re Comma expectedAdd = re Comma value = re RPar                                                # reC11SCmpXchg
    |   C11AtomicWCASExplicit LPar address = re Comma expectedAdd = re Comma value = re Comma c11Mo Comma c11Mo (Comma openCLScope)? RPar   # reC11WCmpXchgExplicit
    |   C11AtomicWCAS         LPar address = re Comma expectedAdd = re Comma value = re RPar                                                # reC11WCmpXchg

    |   ( CmpXchg        LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | CmpXchgRelaxed LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELAXED;}
        | CmpXchgAcquire LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_ACQUIRE;}
        | CmpXchgRelease LPar address = re Comma cmp = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                  # reCmpXchg

    |   ( AtomicSubAndTest LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;}
        | AtomicIncAndTest LPar address = re RPar {$op = IntBinaryOp.ADD; $mo = Linux.MO_MB;}
        | AtomicDecAndTest LPar address = re RPar {$op = IntBinaryOp.SUB; $mo = Linux.MO_MB;})                                              # reAtomicOpAndTest

    |   AtomicAddUnless LPar address = re Comma value = re Comma cmp = re RPar                                                              # reAtomicAddUnless

    |   C11AtomicLoadExplicit    LPar address = re Comma c11Mo (Comma openCLScope)? RPar                                                    # reC11LoadExplicit
    |   C11AtomicLoad            LPar address = re RPar                                                                                     # reC11Load

    |   ( AtomicReadAcquire LPar address = re RPar {$mo = Linux.MO_ACQUIRE;}
        | AtomicRead        LPar address = re RPar {$mo = Linux.MO_ONCE;}
        | RcuDereference    LPar Ast? address = re RPar {$mo = Linux.MO_ONCE;}
        | SrcuReadLock      LPar address = re RPar {$mo = Linux.SRCU_LOCK;}
        | SrcuDownRead      LPar address = re RPar {$mo = Linux.SRCU_LOCK;}
        | SmpLoadAcquire    LPar address = re RPar {$mo = Linux.MO_ACQUIRE;})                                                               # reLoad

    |   ReadOnce LPar Ast address = re RPar {$mo = Linux.MO_ONCE;}                                                                          # reReadOnce
    |   Ast address = re {$mo = "NA";}                                                                                                      # reReadNa

//    |   SpinTrylock LPar address = re RPar                                                                                                # reSpinTryLock
//    |   SpiIsLocked LPar address = re RPar                                                                                                # reSpinIsLocked

    |   boolConst                                                                                                                           # reBoolConst
    |   Excl re                                                                                                                             # reOpBoolNot
    |   re opBool re                                                                                                                        # reOpBool
    |   re opCompare re                                                                                                                     # reOpCompare
    |   re opArith re                                                                                                                       # reOpArith

    |   LPar re RPar                                                                                                                        # reParenthesis
    |   cast re                                                                                                                             # reCast
    |   varName                                                                                                                             # reVarName
    |   constant                                                                                                                            # reConst
    ;

nre locals [IntBinaryOp op, String mo, String name]
    :   ( AtomicAdd LPar value = re Comma address = re RPar {$op = IntBinaryOp.ADD;}
        | AtomicSub LPar value = re Comma address = re RPar {$op = IntBinaryOp.SUB;}
        | AtomicInc LPar address = re RPar {$op = IntBinaryOp.ADD;}
        | AtomicDec LPar address = re RPar {$op = IntBinaryOp.SUB;})                                                                        # nreAtomicOp

    |   ( AtomicSet         LPar address = re Comma value = re RPar {$mo = Linux.MO_ONCE;}
        | AtomicSetRelease  LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;}
        | SmpStoreRelease   LPar address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;}
        | SmpStoreMb        LPar address = re Comma value = re RPar {$mo = Linux.MO_MB;}
        | SrcuReadUnlock    LPar address = re Comma value = re RPar {$mo = Linux.SRCU_UNLOCK;}
        | SrcuUpRead        LPar address = re Comma value = re RPar {$mo = Linux.SRCU_UNLOCK;}
        | RcuAssignPointer  LPar Ast? address = re Comma value = re RPar {$mo = Linux.MO_RELEASE;})                                         # nreStore

    |   WriteOnce LPar Ast address = re Comma value = re RPar {$mo = Linux.MO_ONCE;}                                                        # nreWriteOnce

    |   C11AtomicStoreExplicit    LPar address = re  Comma value = re Comma c11Mo (Comma openCLScope)? RPar                                 # nreC11StoreExplicit
    |   C11AtomicStore            LPar address = re  Comma value = re  RPar                                                                 # nreC11Store

    |   Ast? varName Equals re                                                                                                              # nreAssignment
    |   typeSpecifier varName (Equals re)?                                                                                                  # nreRegDeclaration

    |   SpinLock LPar address = re RPar                                                                                                     # nreSpinLock
    |   SpinUnlock LPar address = re RPar                                                                                                   # nreSpinUnlock
//    |   SpinUnlockWait LPar address = re RPar                                                                                             # nreSpinUnlockWait

    |   SrcuSync LPar address = re RPar                                                                                                     # nreSrcuSync

    |   ( FenceSmpMb LPar RPar {$name = Linux.MO_MB;}
        | FenceSmpWMb LPar RPar {$name = Linux.MO_WMB;}
        | FenceSmpRMb LPar RPar {$name = Linux.MO_RMB;}
        | FenceSmpMbBeforeAtomic LPar RPar {$name = Linux.BEFORE_ATOMIC;}
        | FenceSmpMbAfterAtomic LPar RPar {$name = Linux.AFTER_ATOMIC;}
        | FenceSmpMbAfterSpinLock LPar RPar {$name = Linux.AFTER_SPINLOCK;}
        | FenceSmpMbAfterUnlockLock LPar RPar {$name = Linux.AFTER_UNLOCK_LOCK;}
        | FenceSmpMbAfterSrcuReadUnlock LPar RPar {$name = Linux.AFTER_SRCU_READ_UNLOCK;}
        | RcuReadLock LPar RPar {$name = Linux.RCU_LOCK;}
        | RcuReadUnlock LPar RPar {$name = Linux.RCU_UNLOCK;}
        | (RcuSync | RcuSyncExpedited) LPar RPar {$name = Linux.RCU_SYNC;})                                                                 # nreFence

    |   C11AtomicFence LPar c11Mo RPar                                                                                                      # nreC11Fence

    |   OpenCLAtomicFenceWI LPar openCLFenceFlags Comma c11Mo Comma openCLScope RPar                                                         # nreOpenCLFence

    |   barrierId Colon OpenCLBarrier LPar openCLFenceFlags (Comma openCLScope)? RPar                                                        # nreOpenCLBarrier

    ;

variableList
    :   Locations LBracket (threadVariable | varName) (Semi (threadVariable | varName))* Semi? RBracket
    ;

boolConst returns [Boolean value]
    :   True    {$value = true;}
    |   False   {$value = false;}
    ;

opBool returns [BoolBinaryOp op]
    :   AmpAmp  {$op = BoolBinaryOp.AND;}
    |   BarBar  {$op = BoolBinaryOp.OR;}
    ;

opCompare returns [IntCmpOp op]
    :   EqualsEquals    {$op = IntCmpOp.EQ;}
    |   NotEquals       {$op = IntCmpOp.NEQ;}
    |   LessEquals      {$op = IntCmpOp.LTE;}
    |   GreaterEquals   {$op = IntCmpOp.GTE;}
    |   Less            {$op = IntCmpOp.LT;}
    |   Greater         {$op = IntCmpOp.GT;}
    ;

opArith returns [IntBinaryOp op]
    :   Plus    {$op = IntBinaryOp.ADD;}
    |   Minus   {$op = IntBinaryOp.SUB;}
    |   Amp     {$op = IntBinaryOp.AND;}
    |   Bar     {$op = IntBinaryOp.OR;}
    |   Circ    {$op = IntBinaryOp.XOR;}
    ;

c11Mo returns [String mo]
    :   MoRelaxed   {$mo = C11.MO_RELAXED;}
    |   MoConsume   {$mo = C11.MO_CONSUME;}
    |   MoAcquire   {$mo = C11.MO_ACQUIRE;}
    |   MoRelease   {$mo = C11.MO_RELEASE;}
    |   MoAcqRel    {$mo = C11.MO_ACQUIRE_RELEASE;}
    |   MoSeqCst    {$mo = C11.MO_SC;}
    ;

openCLSpace returns [String space]
    :   OpenCLGlobalSpace  {$space = OpenCL.GLOBAL_SPACE;}
    |   OpenCLLocalSpace   {$space = OpenCL.LOCAL_SPACE;}
    ;

openCLScope returns [String scope]
    :   OpenCLMemoryScopeWI    {$scope = GPU_SCOPES.WORK_ITEM;}
    |   OpenCLMemoryScopeWG    {$scope = GPU_SCOPES.WORK_GROUP;}
    |   OpenCLMemoryScopeDEV   {$scope = GPU_SCOPES.DEVICE;}
    |   OpenCLMemoryScopeALL   {$scope = GPU_SCOPES.ALL;}
    ;

openCLFenceFlags
    :   openCLFenceFlag Bar openCLFenceFlag
    |   openCLFenceFlag
    ;

openCLFenceFlag returns [String flag]
    :   OpenCLFenceFlagGL    {$flag = OpenCL.GLOBAL_SPACE;}
    |   OpenCLFenceFlagLC    {$flag = OpenCL.LOCAL_SPACE;}
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
    |   Struct structName
    ;

structName
    :   Identifier
    ;

atomicTypeSpecifier
    :   AtomicT
    |   SpinlockT
    ;

varName
    :   Underscore* Identifier (Underscore (Identifier | DigitSequence)*)*
    ;

scopeID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

// Allowed outside of thread body (otherwise might conflict with pointer cast)
comment
    :   LPar Ast .*? Ast RPar
    ;

barrierId returns [int id]
    :   t = BarrierIdentifier {$id = Integer.parseInt($t.text.replace("B", ""));}
    ;

BarrierIdentifier
    :   'B' DigitSequence
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

While
    :   'while'
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

Struct
    :   'struct'
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
