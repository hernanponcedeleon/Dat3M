grammar LitmusC;

@header{
package dartagnan;
}

main
    :   header variableDeclaratorList threadList variableList? assertionFilter? assertionList? comment? EOF
    ;

header
    :   'C' ~(LeftBrace)*
    ;

variableDeclaratorList
    :   LeftBrace (globalDeclarator Semi comment?)* RightBrace (Semi)?
    ;

globalDeclarator
    :   typeSpecifier? variable (Assign initConstantValue)?                                                             # globalDeclaratorLocation
    |   typeSpecifier? threadVariable (Assign initConstantValue)?                                                       # globalDeclaratorRegister
    |   typeSpecifier? variable (Assign variable)?                                                                      # globalDeclaratorLocationLocation
    |   typeSpecifier? threadVariable (Assign variable)?                                                                # globalDeclaratorRegisterLocation
    ;

threadList
    :   thread+
    ;

thread
    :   threadIdentifier LeftParen threadArguments? RightParen LeftBrace expression* RightBrace
    ;

threadArguments
    :   variableDeclarator (Comma variableDeclarator)*
    ;

expression
    :   seqExpression Semi
    |   ifExpression
    ;

ifExpression
    :   'if' LeftParen returnExpression RightParen expression elseExpression?
    |   'if' LeftParen returnExpression RightParen LeftBrace expression* RightBrace elseExpression?
    ;

elseExpression
    :   'else' expression
    |   'else' LeftBrace expression* RightBrace
    ;

// TODO: Some tests initialize variables without a type specifier, so it makes sence to reduce this to two options
seqExpression
    :   typeSpecifier variable (Assign returnExpression)?                                                               # seqDeclarationReturnExpression
    |   variable Assign returnExpression                                                                                # seqReturnExpression
    |   nonReturnExpression                                                                                             # seqNonReturnExpression
    ;

returnExpression
    :   'atomic_add_return' LeftParen returnExpression Comma variable RightParen                                        # reAtomicAddReturn
    |   'atomic_add_return_relaxed' LeftParen returnExpression Comma variable RightParen                                # reAtomicAddReturnRelaxed
    |   'atomic_add_return_acquire' LeftParen returnExpression Comma variable RightParen                                # reAtomicAddReturnAcquire
    |   'atomic_add_return_release' LeftParen returnExpression Comma variable RightParen                                # reAtomicAddReturnRelease

    |   'atomic_sub_return' LeftParen returnExpression Comma variable RightParen                                        # reAtomicSubReturn
    |   'atomic_sub_return_relaxed' LeftParen returnExpression Comma variable RightParen                                # reAtomicSubReturnRelaxed
    |   'atomic_sub_return_acquire' LeftParen returnExpression Comma variable RightParen                                # reAtomicSubReturnAcquire
    |   'atomic_sub_return_release' LeftParen returnExpression Comma variable RightParen                                # reAtomicSubReturnRelease

    |   'atomic_inc_return' LeftParen variable RightParen                                                               # reAtomicIncReturn
    |   'atomic_inc_return_relaxed' LeftParen variable RightParen                                                       # reAtomicIncReturnRelaxed
    |   'atomic_inc_return_acquire' LeftParen variable RightParen                                                       # reAtomicIncReturnAcquire
    |   'atomic_inc_return_release' LeftParen variable RightParen                                                       # reAtomicIncReturnRelease

    |   'atomic_dec_return' LeftParen variable RightParen                                                               # reAtomicDecReturn
    |   'atomic_dec_return_relaxed' LeftParen variable RightParen                                                       # reAtomicDecReturnRelaxed
    |   'atomic_dec_return_acquire' LeftParen variable RightParen                                                       # reAtomicDecReturnAcquire
    |   'atomic_dec_return_release' LeftParen variable RightParen                                                       # reAtomicDecReturnRelease

    |   'atomic_fetch_add' LeftParen returnExpression Comma variable RightParen                                         # reAtomicFetchAdd
    |   'atomic_fetch_add_relaxed' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchAddRelaxed
    |   'atomic_fetch_add_acquire' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchAddAcquire
    |   'atomic_fetch_add_release' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchAddRelease

    |   'atomic_fetch_sub' LeftParen returnExpression Comma variable RightParen                                         # reAtomicFetchSub
    |   'atomic_fetch_sub_relaxed' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchSubRelaxed
    |   'atomic_fetch_sub_acquire' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchSubAcquire
    |   'atomic_fetch_sub_release' LeftParen returnExpression Comma variable RightParen                                 # reAtomicFetchSubRelease

    |   'atomic_fetch_inc' LeftParen variable RightParen                                                                # reAtomicFetchInc
    |   'atomic_fetch_inc_relaxed' LeftParen variable RightParen                                                        # reAtomicFetchIncRelaxed
    |   'atomic_fetch_inc_acquire' LeftParen variable RightParen                                                        # reAtomicFetchIncAcquire
    |   'atomic_fetch_inc_release' LeftParen variable RightParen                                                        # reAtomicFetchIncRelease

    |   'atomic_fetch_dec' LeftParen variable RightParen                                                                # reAtomicFetchDec
    |   'atomic_fetch_dec_relaxed' LeftParen variable RightParen                                                        # reAtomicFetchDecRelaxed
    |   'atomic_fetch_dec_acquire' LeftParen variable RightParen                                                        # reAtomicFetchDecAcquire
    |   'atomic_fetch_dec_release' LeftParen variable RightParen                                                        # reAtomicFetchDecRelease

    |   'atomic_xchg' LeftParen variable Comma returnExpression RightParen                                              # reAtomicXchg
    |   'atomic_xchg_relaxed' LeftParen variable Comma returnExpression RightParen                                      # reAtomicXchgRelaxed
    |   'atomic_xchg_acquire' LeftParen variable Comma returnExpression RightParen                                      # reAtomicXchgAcquire
    |   'atomic_xchg_release' LeftParen variable Comma returnExpression RightParen                                      # reAtomicXchgRelease

    |   'xchg' LeftParen variable Comma returnExpression RightParen                                                     # reXchg
    |   'xchg_relaxed' LeftParen variable Comma returnExpression RightParen                                             # reXchgRelaxed
    |   'xchg_acquire' LeftParen variable Comma returnExpression RightParen                                             # reXchgAcquire
    |   'xchg_release' LeftParen variable Comma returnExpression RightParen                                             # reXchgRelease

    |   'atomic_cmpxchg' LeftParen variable Comma returnExpression Comma returnExpression RightParen                    # reAtomicCmpxchg
    |   'atomic_cmpxchg_relaxed' LeftParen variable Comma returnExpression Comma returnExpression RightParen            # reAtomicCmpxchgRelaxed
    |   'atomic_cmpxchg_acquire' LeftParen variable Comma returnExpression Comma returnExpression RightParen            # reAtomicCmpxchgAcquire
    |   'atomic_cmpxchg_release' LeftParen variable Comma returnExpression Comma returnExpression RightParen            # reAtomicCmpxchgRelease

    |   'cmpxchg' LeftParen variable Comma returnExpression Comma returnExpression RightParen                           # reCmpxchg
    |   'cmpxchg_relaxed' LeftParen variable Comma returnExpression Comma returnExpression RightParen                   # reCmpxchgRelaxed
    |   'cmpxchg_acquire' LeftParen variable Comma returnExpression Comma returnExpression RightParen                   # reCmpxchgAcquire
    |   'cmpxchg_release' LeftParen variable Comma returnExpression Comma returnExpression RightParen                   # reCmpxchgRelease

    |   'atomic_add_unless' LeftParen variable Comma returnExpression Comma returnExpression RightParen                 # reAtomicAddUnless
    |   'atomic_sub_and_test' LeftParen returnExpression Comma variable RightParen                                      # reAtomicSubAndTest
    |   'atomic_inc_and_test' LeftParen variable RightParen                                                             # reAtomicIncAndTest
    |   'atomic_dec_and_test' LeftParen variable RightParen                                                             # reAtomicDecAndTest

    |   'READ_ONCE' LeftParen variable RightParen                                                                       # reReadOnce
    |   'atomic_read' LeftParen variable RightParen                                                                     # reAtomicRead
    |   'rcu_dereference' LeftParen variable RightParen                                                                 # reRcuDerefence
    |   'smp_load_acquire' LeftParen variable RightParen                                                                # reSmpLoadAcquire
    |   'atomic_read_acquire' LeftParen variable RightParen                                                             # reAtomicReadAcquire

    |   'spin_trylock' LeftParen variable RightParen                                                                    # reSpinTryLock
    |   'spin_is_locked' LeftParen variable RightParen                                                                  # reSpinIsLocked

    |   returnExpression opCompare returnExpression                                                                     # reOpCompare
    |   returnExpression opArith returnExpression                                                                       # reOpArith

    |   LeftParen returnExpression RightParen                                                                           # reParenthesis
    |   cast returnExpression                                                                                           # reCast
    |   variable                                                                                                        # reVariable
    |   constantValue                                                                                                   # reConst
    ;

nonReturnExpression
    :   'atomic_add' LeftParen returnExpression Comma variable RightParen                                               # nreAtomicAdd
    |   'atomic_sub' LeftParen returnExpression Comma variable RightParen                                               # nreAtomicSub
    |   'atomic_inc' LeftParen variable RightParen                                                                      # nreAtomicInc
    |   'atomic_dec' LeftParen variable RightParen                                                                      # nreAtomicDec

    |   'WRITE_ONCE' LeftParen variable Comma returnExpression RightParen                                               # nreWriteOnce
    |   'atomic_set' LeftParen variable Comma returnExpression RightParen                                               # nreAtomicSet
    |   'smp_store_release' LeftParen variable Comma returnExpression RightParen                                        # nreSmpStoreRelease
    |   'atomic_set_release' LeftParen variable Comma returnExpression RightParen                                       # nreAtomicSetRelease
    |   'rcu_assign_pointer' LeftParen variable Comma returnExpression RightParen                                       # nreRcuAssignPointer
    |   'smp_store_mb' LeftParen variable Comma returnExpression RightParen                                             # nreSmpStoreMb

    |   'smp_mb' LeftParen RightParen                                                                                   # nreSmpMb
    |   'smp_rmb' LeftParen RightParen                                                                                  # nreSmpRmb
    |   'smp_wmb' LeftParen RightParen                                                                                  # nreSmpWmb
    |   'smp_mb__before_atomic' LeftParen RightParen                                                                    # nreSmpMbBeforeAtomic
    |   'smp_mb__after_atomic' LeftParen RightParen                                                                     # nreSmpMbAfterAtomic
    |   'smp_mb__after_spinlock' LeftParen RightParen                                                                   # nreSmpMbAfterSpinlock

    |   'rcu_read_lock' LeftParen RightParen                                                                            # nreRcuReadLock
    |   'rcu_read_unlock' LeftParen RightParen                                                                          # nreRcuReadUnlock
    |   'synchronize_rcu' LeftParen RightParen                                                                          # nreSynchronizeRcu
    |   'synchronize_rcu_expedited' LeftParen RightParen                                                                # nreSynchronizeRcuExpedited

    |   'spin_lock' LeftParen variable RightParen                                                                       # nreSpinLock
    |   'spin_unlock' LeftParen variable RightParen                                                                     # nreSpinUnlock
    |   'spin_unlock_wait' LeftParen variable RightParen                                                                # nreSpinUnlockWait
    ;

variableList
    :   'locations' LeftBracket genericVariable (Semi genericVariable)* Semi? RightBracket
    ;

assertionFilter
    :   AssertionFilter assertion Semi?
    ;

assertionList
    :   (AssertionExists | AssertionExistsNot | AssertionForall) assertion Semi?
    |   AssertionFinal assertion Semi? assertionListExpectationList
    ;

assertion
    :   LeftParen assertion RightParen                                                                                  # assertionParenthesis
    |   Tilde assertion                                                                                                 # assertionNot
    |   assertion AssertionAnd assertion                                                                                # assertionAnd
    |   assertion AssertionOr assertion                                                                                 # assertionOr
    |   variable assertionOp constantValue                                                                              # assertionLocation
    |   variable assertionOp threadVariable                                                                             # assertionLocationRegister
    |   variable assertionOp variable                                                                                   # assertionLocationLocation
    |   threadVariable assertionOp constantValue                                                                        # assertionRegister
    |   threadVariable assertionOp threadVariable                                                                       # assertionRegisterRegister
    |   threadVariable assertionOp variable                                                                             # assertionRegisterLocation
    ;

assertionOp
    :   (Assign | Equal)                                                                                                # assertionOpEqual
    |   NotEqual                                                                                                        # assertionOpNotEqual
    ;

assertionListExpectationList
    :   'with' (assertionListExpectation)+
    ;

assertionListExpectation
    :   assertionListExpectationTest ':' (AssertionExists | AssertionExistsNot) ';'
    ;

assertionListExpectationTest
    :   'tso'
    |   'cc'
    |   'optic'
    |   'default'
    ;

opCompare
    :   Equal
    |   NotEqual
    |   LessEqual
    |   GreaterEqual
    |   Less
    |   Greater
    ;

opArith
    :   Plus
    |   Minus
    |   And
    |   Or
    ;

genericVariableDeclarator
    :   threadVariableDeclarator
    |   variableDeclarator
    ;

threadVariableDeclarator
    :   typeSpecifier threadVariable
    ;

variableDeclarator
    :   typeSpecifier variable
    ;

genericVariable
    :   threadVariable
    |   variable
    ;

threadVariable
    :   Star threadVariable
    |   And threadVariable
    |   cast threadVariable
    |   threadIdentifier Colon Identifier
    ;

variable
    :   Star variable
    |   And variable
    |   cast variable
    |   Identifier
    ;

threadIdentifier
    :   ThreadIdentifier
    |   DigitSequence
    ;

initConstantValue
    :   'ATOMIC_INIT' LeftParen constantValue RightParen
    |   constantValue
    ;

constantValue
    :   DigitSequence
    ;

cast
    :   LeftParen typeSpecifier Star* RightParen
    ;

typeSpecifier
    :   (Volatile)? basicTypeSpecifier
    |   (Volatile)? atomicTypeSpecifier
    ;

basicTypeSpecifier
    :   'int'
    |   'intptr_t'
    |   'char'
    |   'void'
    ;

atomicTypeSpecifier
    :   'atomic_t'
    |   'spinlock_t'
    ;

comment
    :   LeftParen Star .*? Star RightParen
    ;

Volatile
    :   'volatile'
    ;

AssertionExistsNot
    :   '~exists'
    |   '~ exists'
    |   'exists not'
    ;

AssertionExists
    :   'exists'
    ;

AssertionFinal
    :   'final'
    ;

AssertionForall
    :   'forall'
    ;

AssertionFilter
    :   'filter'
    ;

LeftParen : '(';
RightParen : ')';
LeftBracket : '[';
RightBracket : ']';
LeftBrace : '{';
RightBrace : '}';

LessEqual : '<=';
Less : '<';
GreaterEqual : '>=';
Greater : '>';

Equal : '==';
NotEqual : '!=';
Assign : '=';

PlusPlus : '++';
Plus : '+';
MinusMinus : '--';
Minus : '-';
Div : '/';
Mod : '%';
Star : '*';

AndAnd : '&&';
And : '&';
OrOr : '||';
Or : '|';
Caret : '^';
Not : '!';
Tilde : '~';
AssertionOr : '\\/';
AssertionAnd : '/\\';

Question : '?';
Colon : ':';
Semi : ';';
Comma : ',';
Period : '.';
Quotation : '"';
SingleQuotation : '\'';

ThreadIdentifier
    :   'P' DigitSequence
    ;

Identifier
    :   Nondigit (Nondigit | Digit)*
    ;

DigitSequence
    :   Digit+
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

fragment
Digit
    :   [0-9]
    ;

Whitespace
    :   [ \t]+
        -> channel(HIDDEN)
    ;

LineComment
    :   '//' .*? Newline
        -> channel(HIDDEN)
    ;

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> channel(HIDDEN)
    ;

BlockComment
    :   '/*' .*? '*/'
        -> channel(HIDDEN)
    ;