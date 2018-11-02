grammar LitmusC;

@header{
package dartagnan.parsers;
}

import LinuxLexer, LitmusBase;

variableDeclaratorList
    :   LBrace (globalDeclarator Semi comment?)* RBrace (Semi)?
    ;

globalDeclarator
    :   typeSpecifier? variable (Equals initConstantValue)?                                                             # globalDeclaratorLocation
    |   typeSpecifier? threadVariable (Equals initConstantValue)?                                                       # globalDeclaratorRegister
    |   typeSpecifier? variable (Equals variable)?                                                                      # globalDeclaratorLocationLocation
    |   typeSpecifier? threadVariable (Equals variable)?                                                                # globalDeclaratorRegisterLocation
    ;

program
    :   thread+
    ;

thread
    :   threadId LPar threadArguments? RPar LBrace expression* RBrace
    ;

threadArguments
    :   variableDeclarator (Comma variableDeclarator)*
    ;

expression
    :   seqExpression Semi
    |   ifExpression
    ;

ifExpression
    :   If LPar returnExpression RPar expression elseExpression?
    |   If LPar returnExpression RPar LBrace expression* RBrace elseExpression?
    ;

elseExpression
    :   Else expression
    |   Else LBrace expression* RBrace
    ;

// TODO: Some tests initialize variables without a type specifier, so it makes sence to reduce this to two options
seqExpression
    :   typeSpecifier variable (Equals returnExpression)?                                                               # seqDeclarationReturnExpression
    |   variable Equals returnExpression                                                                                # seqReturnExpression
    |   nonReturnExpression                                                                                             # seqNonReturnExpression
    ;

returnExpression locals [String op, String mo]
    :   ( AtomicAddReturn        LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Mb";}
        | AtomicAddReturnRelaxed LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Relaxed";}
        | AtomicAddReturnAcquire LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Acquire";}
        | AtomicAddReturnRelease LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Release";}
        | AtomicSubReturn        LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Mb";}
        | AtomicSubReturnRelaxed LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Relaxed";}
        | AtomicSubReturnAcquire LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Acquire";}
        | AtomicSubReturnRelease LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Release";}
        | AtomicIncReturn        LPar variable RPar {$op = "+"; $mo = "Mb";}
        | AtomicIncReturnRelaxed LPar variable RPar {$op = "+"; $mo = "Relaxed";}
        | AtomicIncReturnAcquire LPar variable RPar {$op = "+"; $mo = "Acquire";}
        | AtomicIncReturnRelease LPar variable RPar {$op = "+"; $mo = "Release";}
        | AtomicDecReturn        LPar variable RPar {$op = "-"; $mo = "Mb";}
        | AtomicDecReturnRelaxed LPar variable RPar {$op = "-"; $mo = "Relaxed";}
        | AtomicDecReturnAcquire LPar variable RPar {$op = "-"; $mo = "Acquire";}
        | AtomicDecReturnRelease LPar variable RPar {$op = "-"; $mo = "Release";})                                      # reAtomicOpReturn

    |   ( AtomicFetchAdd        LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Mb";}
        | AtomicFetchAddRelaxed LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Relaxed";}
        | AtomicFetchAddAcquire LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Acquire";}
        | AtomicFetchAddRelease LPar returnExpression Comma variable RPar {$op = "+"; $mo = "Release";}
        | AtomicFetchSub        LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Mb";}
        | AtomicFetchSubRelaxed LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Relaxed";}
        | AtomicFetchSubAcquire LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Acquire";}
        | AtomicFetchSubRelease LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Release";}
        | AtomicFetchInc        LPar variable RPar {$op = "+"; $mo = "Mb";}
        | AtomicFetchIncRelaxed LPar variable RPar {$op = "+"; $mo = "Relaxed";}
        | AtomicFetchIncAcquire LPar variable RPar {$op = "+"; $mo = "Acquire";}
        | AtomicFetchIncRelease LPar variable RPar {$op = "+"; $mo = "Release";}
        | AtomicFetchDec        LPar variable RPar {$op = "-"; $mo = "Mb";}
        | AtomicFetchDecRelaxed LPar variable RPar {$op = "-"; $mo = "Relaxed";}
        | AtomicFetchDecAcquire LPar variable RPar {$op = "-"; $mo = "Acquire";}
        | AtomicFetchDecRelease LPar variable RPar {$op = "-"; $mo = "Release";})                                       # reAtomicFetchOp

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

    |   ( AtomicSubAndTest LPar returnExpression Comma variable RPar {$op = "-"; $mo = "Mb";}
        | AtomicIncAndTest LPar variable RPar {$op = "+"; $mo = "Mb";}
        | AtomicDecAndTest LPar variable RPar {$op = "-"; $mo = "Mb";})                                                 # reAtomicOpAndTest

    |   AtomicAddUnless LPar variable Comma returnExpression Comma returnExpression RPar                                # reAtomicAddUnless

    |   ( ReadOnce          LPar variable RPar {$mo = "Relaxed";}
        | AtomicReadAcquire LPar variable RPar {$mo = "Acquire";}
        | AtomicRead        LPar variable RPar {$mo = "Relaxed";}
        | RcuDereference    LPar variable RPar {$mo = "Dereference";}
        | SmpLoadAcquire    LPar variable RPar {$mo = "Acquire";})                                                      # reLoad

//    |   SpinTrylock LPar variable RPar                                                                                  # reSpinTryLock
//    |   SpiIsLocked LPar variable RPar                                                                                  # reSpinIsLocked

    |   Excl returnExpression                                                                                           # reOpBoolNot
    |   returnExpression opBool returnExpression                                                                        # reOpBool
    |   returnExpression opCompare returnExpression                                                                     # reOpCompare
    |   returnExpression opArith returnExpression                                                                       # reOpArith

    |   LPar returnExpression RPar                                                                                      # reParenthesis
    |   cast returnExpression                                                                                           # reCast
    |   variable                                                                                                        # reVariable
    |   constantValue                                                                                                   # reConst
    ;

nonReturnExpression locals [String op, String mo, String name]
    :   ( AtomicAdd LPar returnExpression Comma variable RPar {$op = "+";}
        | AtomicSub LPar returnExpression Comma variable RPar {$op = "-";}
        | AtomicInc LPar variable RPar {$op = "+";}
        | AtomicDec LPar variable RPar {$op = "-";})                                                                    # nreAtomicOp

    |   ( WriteOnce         LPar variable Comma returnExpression RPar {$mo = "Relaxed";}
        | AtomicSet         LPar variable Comma returnExpression RPar {$mo = "Relaxed";}
        | AtomicSetRelease  LPar variable Comma returnExpression RPar {$mo = "Release";}
        | SmpStoreRelease   LPar variable Comma returnExpression RPar {$mo = "Release";}
        | SmpStoreMb        LPar variable Comma returnExpression RPar {$mo = "Mb";}
        | RcuAssignPointer  LPar variable Comma returnExpression RPar {$mo = "Release";})                               # nreStore

    |   RcuReadLock LPar RPar                                                                                           # nreRcuReadLock
    |   RcuReadUnlock LPar RPar                                                                                         # nreRcuReadUnlock
    |   ( RcuSync LPar RPar
        | RcuSyncExpedited LPar RPar)                                                                                   # nreSynchronizeRcu

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
    :   Locations LBracket genericVariable (Semi genericVariable)* Semi? RBracket
    ;

assertionValue returns [IntExprInterface v]
    :   l = variable    {$v = pb.getOrCreateLocation($l.text);}
    |   t = threadVariable {$v = pb.getOrCreateRegister($t.tid, $t.name);}
    |   imm = constantValue { $v = new AConst(Integer.parseInt($imm.text)); }
    ;

opBool
    :   AmpAmp
    |   BarBar
    ;

opCompare
    :   EqualsEquals
    |   NotEquals
    |   LessEquals
    |   GreaterEquals
    |   Less
    |   Greater
    ;

opArith
    :   Plus
    |   Minus
    |   Amp
    |   Bar
    ;

variableDeclarator
    :   typeSpecifier variable
    ;

genericVariable
    :   threadVariable
    |   variable
    ;

threadVariable returns [String tid, String name]
    :   Ast v = threadVariable {$tid = $v.tid; $name = $v.name;}
    |   Amp v = threadVariable {$tid = $v.tid; $name = $v.name;}
    |   cast v = threadVariable  {$tid = $v.tid; $name = $v.name;}
    |   t = threadId Colon n = varName  {$tid = $t.id; $name = $n.text;}
    ;

variable
    :   Ast variable
    |   Amp variable
    |   cast variable
    |   varName
    ;

initConstantValue
    :   AtomicInit LPar constantValue RPar
    |   constantValue
    ;

constantValue
    :   DigitSequence
    ;

cast
    :   LPar typeSpecifier Ast* RPar
    ;

typeSpecifier
    :   (Volatile)? basicTypeSpecifier
    |   (Volatile)? atomicTypeSpecifier
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
    :   Underscore? Identifier (Underscore (Identifier | DigitSequence)*)*
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

BlockComment
    :   '/*' .*? '*/'
        -> channel(HIDDEN)
    ;

LineComment
    :   '//' .*? Newline
        -> channel(HIDDEN)
    ;