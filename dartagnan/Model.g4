grammar Model;
@header{
package dartagnan;
import dartagnan.program.event.Fence;
import dartagnan.program.event.filter.*;
import dartagnan.wmm.axiom.*;
import dartagnan.wmm.relation.*;
import dartagnan.wmm.relation.basic.*;
import dartagnan.wmm.relation.binary.*;
import dartagnan.wmm.relation.unary.*;
import dartagnan.wmm.utils.*;
import dartagnan.wmm.Wmm;

import java.util.List;
import java.util.Set;
import java.util.ArrayList;
import java.util.HashSet;
}
@parser::members
{
    Wmm wmm;
    RelationRepository relationRepository;
    Set<RecursiveRelation> recursiveGroup;
    boolean isRecursive = false;
}

mcm [Wmm w]
    :   { wmm = w; relationRepository = wmm.getRelationRepository(); } (NAME)? definition+ EOF
    ;

definition
    :   axiomDefinition
    |   letDefinition
    |   letRecDefinition
    ;

axiomDefinition returns [Axiom value]
    :   (negate = NOT)? ACYCLIC { isRecursive = false; } e = expression (AS NAME)? {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            wmm.addAxiom(new Acyclic((Relation)$e.value, $negate != null));
        }
    |   (negate = NOT)? IRREFLEXIVE { isRecursive = false; } e = expression (AS NAME)? {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            wmm.addAxiom(new Irreflexive((Relation)$e.value, $negate != null));
        }
    |   (negate = NOT)? EMPTY { isRecursive = false; } e = expression (AS NAME)? {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            wmm.addAxiom(new Empty((Relation)$e.value, $negate != null));
        }
    ;

letDefinition
    :   LET { isRecursive = false; } n = NAME EQ e = expression {
            if($e.value instanceof Relation){
                ((Relation)$e.value).setName($n.text);
                relationRepository.updateRelation((Relation)$e.value);
            } else if ($e.value instanceof FilterAbstract){
                ((FilterAbstract)$e.value).setName($n.text);
                wmm.addFilter((FilterAbstract)$e.value);
            } else {
                throw new RuntimeException("Invalid definition of " + $n.text);
            }
        }
    ;

letRecDefinition
    :   LET REC { isRecursive = true; recursiveGroup = new HashSet<>(); } n = NAME EQ e = expression letRecAndDefinition* {
            Relation relation = relationRepository.getRelation($n.text);
            if(!(relation instanceof RecursiveRelation) || !($e.value instanceof Relation)){
                throw new RuntimeException("Invalid definition of " + $n.text);
            }
            ((RecursiveRelation)relation).setConcreteRelation((Relation)$e.value);
            recursiveGroup.add((RecursiveRelation)relation);
            wmm.addRecursiveGroup(recursiveGroup);
        }
    ;

letRecAndDefinition
    :   AND n = NAME EQ e = expression {
            Relation relation = relationRepository.getRelation($n.text);
            if(!(relation instanceof RecursiveRelation) || !($e.value instanceof Relation)){
                throw new RuntimeException("Invalid definition of " + $n.text);
            }
            ((RecursiveRelation)relation).setConcreteRelation((Relation)$e.value);
            recursiveGroup.add((RecursiveRelation)relation);
        }
    ;

expression returns [Object value]
    :   e1 = expression STAR e2 = expression {
            if(!($e1.value instanceof FilterAbstract) || !($e2.value instanceof FilterAbstract)){
                throw new RuntimeException("Invalid syntax at " + $e1.text + " * " + $e2.text);
            }
            $value = relationRepository.getRelation(RelCartesian.class, (FilterAbstract)$e1.value, (FilterAbstract)$e2.value);
        }
    |   e = expression (POW)? STAR {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            $value = relationRepository.getRelation(RelTransRef.class, (Relation)$e.value);
        }
    |   e = expression (POW)? PLUS {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            $value = relationRepository.getRelation(RelTrans.class, (Relation)$e.value);
        }
    |   e = expression (POW)? INV {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            $value = relationRepository.getRelation(RelInverse.class, (Relation)$e.value);
        }
    |   e = expression OPT {
            if(!($e.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            $value = relationRepository.getRelation(RelUnion.class, relationRepository.getRelation("id"), (Relation)$e.value);
        }
    |   NOT e = expression {
            // TODO: Implementation for relation and filter
            System.out.println("Complement is not implemented");
        }
    |   e1 = expression SEMI e2 = expression {
            if(!($e1.value instanceof Relation) || !($e2.value instanceof Relation)){
                throw new RuntimeException("Invalid syntax at " + $e1.text + " ; " + $e2.text);
            }
            $value = relationRepository.getRelation(RelComposition.class, (Relation)$e1.value, (Relation)$e2.value);
        }
    |   e1 = expression BAR e2 = expression {
            if($e1.value instanceof Relation && $e2.value instanceof Relation){
                $value = relationRepository.getRelation(RelUnion.class, (Relation)$e1.value, (Relation)$e2.value);
            } else if($e1.value instanceof FilterAbstract && $e2.value instanceof FilterAbstract){
                $value = new FilterUnion((FilterAbstract)$e1.value, (FilterAbstract)$e2.value);
            } else {
                throw new RuntimeException("Invalid syntax at " + $e1.text + " | " + $e2.text);
            }
        }
    |   e1 = expression BSLASH e2 = expression {
            if($e1.value instanceof Relation && $e2.value instanceof Relation){
                $value = relationRepository.getRelation(RelMinus.class, (Relation)$e1.value, (Relation)$e2.value);
            } else if($e1.value instanceof FilterAbstract && $e2.value instanceof FilterAbstract){
                $value = new FilterMinus((FilterAbstract)$e1.value, (FilterAbstract)$e2.value);
            } else {
                throw new RuntimeException("Invalid syntax at " + $e1.text + " \\ " + $e2.text);
            }
        }
    |   e1 = expression AMP e2 = expression {
            if($e1.value instanceof Relation && $e2.value instanceof Relation){
                $value = relationRepository.getRelation(RelIntersection.class, (Relation)$e1.value, (Relation)$e2.value);
            } else if($e1.value instanceof FilterAbstract && $e2.value instanceof FilterAbstract){
                $value = new FilterIntersection((FilterAbstract)$e1.value, (FilterAbstract)$e2.value);
            } else {
                throw new RuntimeException("Invalid syntax at " + $e1.text + " & " + $e2.text);
            }
        }
    |   (TOID LPAR e = expression RPAR | LBRAC e = expression RBRAC){
            if(!($e.value instanceof FilterAbstract)){
                throw new RuntimeException("Invalid syntax at " + $e.text);
            }
            $value = relationRepository.getRelation(RelSetIdentity.class, (FilterAbstract)$e.value);
        }
    |   FENCEREL LPAR e = expression RPAR {
            if(!($e.value instanceof FilterAbstract)){
                throw new RuntimeException("Invalid syntax at fencerel(" + $e.text + ")");
            }
            // TODO: In general, this should be a filter (consider fence + MO rel_acq)
            $value = relationRepository.getRelation(RelFencerel.class, $e.text);
        }
    |   LPAR e = expression RPAR {
                $value = $e.value;
            }
    |   n = NAME {
            $value = relationRepository.getRelation($n.text);
            if($value == null){
                $value = wmm.getFilter($n.text);
                if($value == null && isRecursive){
                    $value = relationRepository.getRelation(RecursiveRelation.class, $n.text);
                }
            }
        }
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

NAME    : [A-Za-z0-9\-_]+;

LINE_COMMENT
    :   '//' ~[\n]*
        -> skip
    ;

BLOCK_COMMENT
    :   '(*' (.)*? '*)'
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