grammar LitmusC;

@header{
package dartagnan;
}

import LinuxLexer, LitmusBase;

main
    :   LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? comment? EOF
    ;

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

returnExpression locals [String op, String myMo]
    :   ( AtomicAddReturn        LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Mb";}
        | AtomicAddReturnRelaxed LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Relaxed";}
        | AtomicAddReturnAcquire LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Acquire";}
        | AtomicAddReturnRelease LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Release";}
        | AtomicSubReturn        LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Mb";}
        | AtomicSubReturnRelaxed LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Relaxed";}
        | AtomicSubReturnAcquire LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Acquire";}
        | AtomicSubReturnRelease LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Release";}
        | AtomicIncReturn        LPar variable RPar {$op = "+"; $myMo = "Mb";}
        | AtomicIncReturnRelaxed LPar variable RPar {$op = "+"; $myMo = "Relaxed";}
        | AtomicIncReturnAcquire LPar variable RPar {$op = "+"; $myMo = "Acquire";}
        | AtomicIncReturnRelease LPar variable RPar {$op = "+"; $myMo = "Release";}
        | AtomicDecReturn        LPar variable RPar {$op = "-"; $myMo = "Mb";}
        | AtomicDecReturnRelaxed LPar variable RPar {$op = "-"; $myMo = "Relaxed";}
        | AtomicDecReturnAcquire LPar variable RPar {$op = "-"; $myMo = "Acquire";}
        | AtomicDecReturnRelease LPar variable RPar {$op = "-"; $myMo = "Release";})                                    # reAtomicOpReturn

    |   ( AtomicFetchAdd        LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Mb";}
        | AtomicFetchAddRelaxed LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Relaxed";}
        | AtomicFetchAddAcquire LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Acquire";}
        | AtomicFetchAddRelease LPar returnExpression Comma variable RPar {$op = "+"; $myMo = "Release";}
        | AtomicFetchSub        LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Mb";}
        | AtomicFetchSubRelaxed LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Relaxed";}
        | AtomicFetchSubAcquire LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Acquire";}
        | AtomicFetchSubRelease LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Release";}
        | AtomicFetchInc        LPar variable RPar {$op = "+"; $myMo = "Mb";}
        | AtomicFetchIncRelaxed LPar variable RPar {$op = "+"; $myMo = "Relaxed";}
        | AtomicFetchIncAcquire LPar variable RPar {$op = "+"; $myMo = "Acquire";}
        | AtomicFetchIncRelease LPar variable RPar {$op = "+"; $myMo = "Release";}
        | AtomicFetchDec        LPar variable RPar {$op = "-"; $myMo = "Mb";}
        | AtomicFetchDecRelaxed LPar variable RPar {$op = "-"; $myMo = "Relaxed";}
        | AtomicFetchDecAcquire LPar variable RPar {$op = "-"; $myMo = "Acquire";}
        | AtomicFetchDecRelease LPar variable RPar {$op = "-"; $myMo = "Release";})                                     # reAtomicFetchOp

    |   ( AtomicXchg        LPar variable Comma returnExpression RPar {$myMo = "Mb";}
        | AtomicXchgRelaxed LPar variable Comma returnExpression RPar {$myMo = "Relaxed";}
        | AtomicXchgAcquire LPar variable Comma returnExpression RPar {$myMo = "Acquire";}
        | AtomicXchgRelease LPar variable Comma returnExpression RPar {$myMo = "Release";})                             # reXchg

    |   ( Xchg        LPar variable Comma returnExpression RPar {$myMo = "Mb";}
        | XchgRelaxed LPar variable Comma returnExpression RPar {$myMo = "Relaxed";}
        | XchgAcquire LPar variable Comma returnExpression RPar {$myMo = "Acquire";}
        | XchgRelease LPar variable Comma returnExpression RPar {$myMo = "Release";})                                   # reXchg

    |   ( AtomicCmpXchg        LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Mb";}
        | AtomicCmpXchgRelaxed LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Relaxed";}
        | AtomicCmpXchgAcquire LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Acquire";}
        | AtomicCmpXchgRelease LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Release";})   # reCmpXchg

    |   ( CmpXchg        LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Mb";}
        | CmpXchgRelaxed LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Relaxed";}
        | CmpXchgAcquire LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Acquire";}
        | CmpXchgRelease LPar variable Comma returnExpression Comma returnExpression RPar {$myMo = "Release";})         # reCmpXchg

    |   ( AtomicSubAndTest LPar returnExpression Comma variable RPar {$op = "-"; $myMo = "Mb";}
        | AtomicIncAndTest LPar variable RPar {$op = "+"; $myMo = "Mb";}
        | AtomicDecAndTest LPar variable RPar {$op = "-"; $myMo = "Mb";})                                               # reAtomicOpAndTest

    |   AtomicAddUnless LPar variable Comma returnExpression Comma returnExpression RPar                                # reAtomicAddUnless

    |   ( ReadOnce          LPar variable RPar {$myMo = "Relaxed";}
        | AtomicReadAcquire LPar variable RPar {$myMo = "Acquire";}
        | AtomicRead        LPar variable RPar {$myMo = "Relaxed";}
        | RcuDereference    LPar variable RPar {$myMo = "Dereference";}
        | SmpLoadAcquire    LPar variable RPar {$myMo = "Acquire";})                                                    # reLoad

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

nonReturnExpression locals [String op, String myMo, String name]
    :   ( AtomicAdd LPar returnExpression Comma variable RPar {$op = "+";}
        | AtomicSub LPar returnExpression Comma variable RPar {$op = "-";}
        | AtomicInc LPar variable RPar {$op = "+";}
        | AtomicDec LPar variable RPar {$op = "-";})                                                                    # nreAtomicOp

    |   ( WriteOnce         LPar variable Comma returnExpression RPar {$myMo = "Relaxed";}
        | AtomicSet         LPar variable Comma returnExpression RPar {$myMo = "Relaxed";}
        | AtomicSetRelease  LPar variable Comma returnExpression RPar {$myMo = "Release";}
        | SmpStoreRelease   LPar variable Comma returnExpression RPar {$myMo = "Release";}
        | SmpStoreMb        LPar variable Comma returnExpression RPar {$myMo = "Mb";}
        | RcuAssignPointer  LPar variable Comma returnExpression RPar {$myMo = "Release";})                             # nreStore

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

assertionFilter
    :   AssertionFilter assertion Semi?
    ;

assertionValue
    :   variable
    |   threadVariable
    |   constantValue
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

threadVariable
    :   Ast threadVariable
    |   Amp threadVariable
    |   cast threadVariable
    |   threadId Colon varName
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

comment
    :   LPar Ast .*? Ast RPar
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