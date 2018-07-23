grammar LitmusC;

@header{
package dartagnan;
}

main
    :   header declaratorList threadList variableList? assertionFilter? assertionList? bottomComment? EOF
    ;

header
    :   'C' ~(LeftBrace)*
    ;

declaratorList
    :   LeftBrace (globalDeclarator Semi)* RightBrace (Semi)?
    ;

globalDeclarator
    :   genericVariable Assign returnExpression
    |   genericVariableDeclarator Assign returnExpression
    |   genericVariableDeclarator
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
    :   basicExpression Semi
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

basicExpression
    :   variableDeclarator Assign returnExpression
    |   variable Assign returnExpression
    |   variableDeclarator
    |   returnExpression
    |   nonReturnExpression
    ;

returnExpression
    :   'ATOMIC_INIT' LeftParen returnExpression RightParen

    |   'atomic_add_return' LeftParen returnExpression Comma variable RightParen
    |   'atomic_add_unless' LeftParen variable Comma returnExpression Comma returnExpression RightParen
    |   'atomic_cmpxchg' LeftParen variable Comma returnExpression Comma returnExpression RightParen
    |   'atomic_dec_and_test' LeftParen variable RightParen
    |   'atomic_read' LeftParen variable RightParen
    |   'atomic_xchg_release' LeftParen variable Comma returnExpression RightParen

    |   'cmpxchg' LeftParen variable Comma returnExpression Comma returnExpression RightParen
    |   'cmpxchg_acquire' LeftParen variable Comma returnExpression Comma returnExpression RightParen
    |   'xchg' LeftParen variable Comma returnExpression RightParen
    |   'xchg_acquire' LeftParen variable Comma returnExpression RightParen
    |   'xchg_relaxed' LeftParen variable Comma returnExpression RightParen

    |   'smp_load_acquire' LeftParen variable RightParen

    |   'rcu_dereference' LeftParen variable RightParen

    |   'READ_ONCE' LeftParen variable RightParen

    |   'spin_trylock' LeftParen variable RightParen

    |   returnExpression Equal returnExpression
    |   returnExpression NotEqual returnExpression
    |   returnExpression Plus returnExpression
    |   returnExpression Minus returnExpression
    |   returnExpression And returnExpression
    |   returnExpression Or returnExpression

    |   LeftParen returnExpression RightParen
    |   cast returnExpression
    |   variable
    |   constantValue
    ;

nonReturnExpression
    :   'atomic_add' LeftParen returnExpression Comma variable RightParen
    |   'atomic_inc' LeftParen variable RightParen

    |   'smp_store_release' LeftParen variable Comma returnExpression RightParen

    |   'smp_mb' LeftParen RightParen
    |   'smp_mb__before_atomic' LeftParen RightParen
    |   'smp_mb__after_atomic' LeftParen RightParen
    |   'smp_rmb' LeftParen RightParen
    |   'smp_wmb' LeftParen RightParen

    |   'rcu_read_lock' LeftParen RightParen
    |   'rcu_read_unlock' LeftParen RightParen
    |   'rcu_assign_pointer' LeftParen variable Comma returnExpression RightParen
    |   'synchronize_rcu' LeftParen RightParen

    |   'WRITE_ONCE' LeftParen variable Comma returnExpression RightParen

    |   'spin_lock' LeftParen variable RightParen
    |   'spin_unlock' LeftParen variable RightParen
    |   'spin_unlock_wait' LeftParen variable RightParen
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
    :   LeftParen assertion RightParen                                          # assertionParenthesis
    |   assertion AssertionAnd assertion                                        # assertionAnd
    |   assertion AssertionOr assertion                                         # assertionOr
    |   genericVariable (Assign | Equal) (returnExpression | threadVariable)    # assertionEqual
    |   genericVariable NotEqual (returnExpression | threadVariable)            # assertionNotEqual
    |   Tilde assertion                                                         # assertionNot
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

bottomComment
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

LeftShift : '<<';
LessEqual : '<=';
Less : '<';
RightShift : '>>';
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