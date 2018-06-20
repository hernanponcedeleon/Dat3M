grammar Cat;

@header{
package porthosc.languages.parsers;
}

main
    :   identity option* topInstructionList EOF
    ;

identity
    :   STRING
    |   NAME
    ;

option
    :   (WITHCO | WITHOUTCO | WITHINIT | WITHOUTINIT | WITHSC | WITHOUTSC)
    ;

instructionList
    :   //empty string
    |   instruction instructionList
    ;

instructionClause
    :    tagName ARROW instructionList
    ;

instructionClauseList
    :    instructionClause
    |    UNDERSCORE ARROW instructionList
    |    instructionClause ALT instructionClauseList
    ;

topInstructionList
    :   topInstruction
    |   topInstruction topInstructionList
    ;

topInstruction
    :    ENUM varName EQUAL ALT? altTags
    |    instruction
    ;

instruction
    :   letInstruction
    |   matchInstruction
    |   constraintDefinition
    |   showInstruction
    |   unshowInstruction
    |   includeInstruction
    |   procedureInstruction
    |   callInstruction
    |   debugInstruction
    |   forallInstruction
    |   withFromInstruction
	    //Bell file declarations:
    |   INSTRUCTIONS varName LBRAC expressionList RBRAC
    |   DEFAULT varName LBRAC expressionList RBRAC
    ;

matchInstruction
    :   MATCH expression WITH ALT? instructionClauseList END
    ;

letInstruction
    :   LET REC? patternBindingList IN?
    |   LET REC patternBindingList WHEN constraint IN?
    ;

showInstruction
    :   SHOW expression AS varName
    |   SHOW varNameList
    ;

unshowInstruction
    :   UNSHOW varNameList
    ;

includeInstruction
    :   INCLUDE STRING
    ;

procedureInstruction
    :   PROCEDURE REC? varName LPAR formals RPAR EQUAL instructionList END
    |   PROCEDURE REC? varName varName EQUAL instructionList END
    ;

callInstruction
    :   CALL varName simpleExpression asVarName?
    ;

debugInstruction
    :   DEBUG expression
    ;

forallInstruction
    :   FORALL varName IN expression DO instructionList END
    ;

withFromInstruction
    :   WITH varName FROM expression
    ;

altTags
    :   tagName
    |   tagName ALT altTags
    ;

constraintDefinition
    :   checkType? constraint
    ;

constraint
    :   constraintFullName expression asVarName?
    ;

checkType
    :   REQUIRES
    |   FLAG
    ;

asVarName
    :   AS varName
    ;

assertionName
    :   ACYCLIC
    |   IRREFLEXIVE
    |   TESTEMPTY
    ;

constraintFullName
    :   NOT? assertionName
    ;

varNameList
    :   varName
    |   varName COMMA varNameList
    ;

binding
    :    varName EQUAL expression
    |    LPAR formals RPAR EQUAL expression
    ;

patternBinding
    :    binding
    |    varName varName EQUAL expression
    |    varName LPAR formals RPAR EQUAL expression
    ;

patternBindingList
    :    patternBinding
    |    patternBindingList AND patternBinding
    ;

formals
    :   //empty string
    |   varName
    |   varName COMMA formals
    ;

expressionList
    :   //empty string
    |   expression
    |   expression COMMA expressionList
    ;

expression
    :   letExpression
    |   funExpression
    |   tryWithExpression
    |   ifThenElseExpression
    |   matchExpression
    |   baseExpression
    ;

funExpression
    :   FUN varName ARROW expression
    |   FUN LPAR formals RPAR ARROW expression
    ;

tryWithExpression
    :   TRY expression WITH expression
    ;

ifThenElseExpression
    :   IF condition THEN expression ELSE expression
    ;

letExpression
    :   LET REC? patternBindingList IN expression
    ;

matchExpression
    :   MATCH expression WITH ALT? clauseList END
    |   MATCH expression WITH ALT? clauseSet END
    ;

condition
    :   expression EQUAL expression
    |   expression SUBSET expression
    ;

simpleExpression
    :   EMPTY
    |   tagName
    |   LACC args RACC
    |   UNDERSCORE
    |   LPAR RPAR
    |   LPAR tupleArgs RPAR
    |   LPAR expression RPAR
    |   BEGIN expression END
    |   LBRAC expression RBRAC
    ;

tupleArgs
    :   expression COMMA tupleEnd
    ;

tupleEnd
    :   expression
    |   expression COMMA tupleEnd
    ;

baseExpression
    :   simpleExpression
    |   varNameExpression
    |   baseExpression STAR baseExpression  //todo: mark as non-associative
    |   baseExpression STAR  //todo: mark as non-associative
    |   baseExpression PLUS  //todo: mark as non-associative
    |   baseExpression OPT  //todo: mark as non-associative
    |   baseExpression HAT INV  //todo: mark as non-associative
    |   <assoc=right> baseExpression SEMI baseExpression
    |   <assoc=right> baseExpression UNION baseExpression
    |   <assoc=right> baseExpression PLUSPLUS baseExpression
    |   <assoc=left>  baseExpression DIFF baseExpression
    |   <assoc=right> baseExpression INTER baseExpression
    |   NOT baseExpression  //todo: mark as non-associative
    ;

clauseEmpty
    :   LACC RACC ARROW expression
    ;

clauseElement2
    :   varName PLUSPLUS varName ARROW expression
    ;

clauseElement3
    :   varName UNION varName PLUSPLUS varName ARROW expression
    ;

clauseElement
    :   clauseElement2
    |   clauseElement3
    ;

clauseSet
    :   clauseEmpty ALT clauseElement
    |   clauseElement ALT clauseEmpty
    ;

clause
    :   tagName ARROW expression
    ;

clauseList
    :   clause
    |   UNDERSCORE ARROW expression
    |   clause ALT clauseList
    ;

varNameExpression
    :   varName
    |   <assoc=left> varNameExpression (varName | simpleExpression)
    ;

args
    :   //empty string
    |   expression
    |   expression COMMA args
    ;

varName
    :   NAME
    ;

tagName
    :   '\'' NAME
    ;

LET : 'let';
REC : 'rec';
AND : 'and';
WHEN : 'when';
ACYCLIC : 'acyclic';
IRREFLEXIVE : 'irreflexive';
SHOW : 'show';
UNSHOW : 'unshow';
TESTEMPTY : 'empty';
SUBSET : 'subset';  //jade: a virer
AS : 'as';
FUN : 'fun';
IN : 'in';
REQUIRES : 'undefined_unless';  // jade: deprecated?, indeed but still here !
FLAG : 'flag';

WITHCO      : 'withco';  //jade: a virer
WITHOUTCO   : 'withoutco';  //jade: a virer
WITHINIT    : 'withinit';  //jade: a virer
WITHOUTINIT : 'withoutinit';  //jade: a virer
WITHSC      : 'withsc';  //jade: a virer
WITHOUTSC   : 'withoutsc';  //jade: a virer

INCLUDE : 'include';
BEGIN : 'begin';
END : 'end';
PROCEDURE : 'procedure';
CALL : 'call';
ENUM : 'enum';
DEBUG : 'debug';
MATCH : 'match';
WITH : 'with';
FORALL : 'forall';
FROM : 'from';
DO : 'do';
TRY : 'try';
IF : 'if';
THEN : 'then';
ELSE : 'else';
YIELD : 'yield';
DEFAULT : 'default';
INSTRUCTIONS : 'instructions';
COMPAT : 'compat';

NAME
    : '_'? Alpha (Alpha | Digit | '_' |'.' | '-')* //'\''?
    ;

Digit
    :   [0-9]
    ;

Alpha
    : [a-zA-Z]
    ;

STRING : '"' ~["\\\r\n]* '"';
LPAR : '(';
RPAR : ')';
LACC : '{';
RACC : '}';
LBRAC : '[';
RBRAC : ']';
UNDERSCORE : '_';
EMPTY : '0';
UNION : '|';
ALT : '||';
INTER : '&';
STAR : '*';
NOT : '~';
PLUS : '+';
PLUSPLUS : '++';
HAT : '^';
INV : '-1';
DIFF : '\\';
OPT : '?';
EQUAL : '=';
SEMI : ';';
COMMA : ',';
ARROW : '->';
