grammar Cat;

@header{
import com.dat3m.dartagnan.wmm.axiom.*;
}

mcm
    :   (NAME)? definition+ EOF
    ;

definition
    :   axiomDefinition
    |   letDefinition
    |   letRecDefinition
    |   letParaDefinition
    ;

axiomDefinition locals [Class<?> cls]
    :   (flag = FLAG)? (negate = NOT)? ACYCLIC { $cls = Acyclicity.class; } e = expression (AS NAME)?
    |   (flag = FLAG)? (negate = NOT)? IRREFLEXIVE { $cls = Irreflexivity.class; } e = expression (AS NAME)?
    |   (flag = FLAG)? (negate = NOT)? EMPTY { $cls = Emptiness.class; } e = expression (AS NAME)?
    ;

letParaDefinition
    :   LET n = NAME LPAR p = NAME RPAR EQ e = expression
    ;

letDefinition
    :   LET n = NAME EQ e = expression
    ;

letRecDefinition
    :   LET REC n = NAME EQ e = expression letRecAndDefinition*
    ;

letRecAndDefinition
    :   AND n = NAME EQ e = expression
    ;

expression
    :   e1 = expression STAR e2 = expression                            # exprCartesian
    |   e = expression (POW)? STAR                                      # exprTransRef
    |   e = expression (POW)? PLUS                                      # exprTransitive
    |   e = expression (POW)? INV                                       # exprInverse
    |   e = expression OPT                                              # exprOptional
    |   NOT e = expression                                              # exprComplement
    |   e1 = expression AMP e2 = expression                             # exprIntersection
    |   e1 = expression BSLASH e2 = expression                          # exprMinus
    |   e1 = expression SEMI e2 = expression                            # exprComposition
    |   e1 = expression BAR e2 = expression                             # exprUnion
    |   LBRAC DOMAIN LPAR e = expression RPAR RBRAC                     # exprDomainIdentity
    |   LBRAC RANGE LPAR e = expression RPAR RBRAC                      # exprRangeIdentity
    |   (TOID LPAR e = expression RPAR | LBRAC e = expression RBRAC)    # exprIdentity
    |   FENCEREL LPAR e = expression RPAR                               # exprFencerel
    |   LPAR e = expression RPAR                                        # expr
    |   n = NAME                                                        # exprBasic
    |   call = NEW LPAR RPAR                                            # exprNew
    |   n = NAME LPAR p = expression RPAR                               # exprParametricCall
    ;

LET     :   'let';
REC     :   'rec';
AND     :   'and';
AS      :   'as';
TOID    :   'toid';

ACYCLIC     :   'acyclic';
IRREFLEXIVE :   'irreflexive';
EMPTY       :   'empty';

EQ      :   '=';
STAR    :   '*';
PLUS    :   '+';
OPT     :   '?';
INV     :   '-1';
NOT     :   '~';
AMP     :   '&';
BAR     :   '|';
SEMI    :   ';';
BSLASH  :   '\\';
POW     :   ('^');

LPAR    :   '(';
RPAR    :   ')';
LBRAC   :   '[';
RBRAC   :   ']';

FENCEREL    :   'fencerel';
DOMAIN      :   'domain';
RANGE       :   'range';
NEW         :   'new';

FLAG       :   'flag';

NAME    : [A-Za-z0-9\-_.]+;

LINE_COMMENT
    :   '//' ~[\n]*
        -> skip
    ;

BLOCK_COMMENT
    :   ('(*' (.)*? '*)' | '/*' (.)*? '*/')
        -> skip
    ;

WS
    :   [ \t\r\n]+
        -> skip
    ;

INCLUDE
    :   'include "' .*? '"'
        -> skip
    ;

MODELNAME
    :   '"' .*? '"'
        -> skip
    ;
