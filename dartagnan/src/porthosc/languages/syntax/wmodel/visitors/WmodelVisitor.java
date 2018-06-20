package porthosc.languages.syntax.wmodel.visitors;

import porthosc.languages.syntax.wmodel.operators.WOperatorBinary;
import porthosc.languages.syntax.wmodel.operators.WOperatorUnary;
import porthosc.languages.syntax.wmodel.relations.WRelationProgramOrder;
import porthosc.languages.syntax.wmodel.relations.WRelationReadFrom;
import porthosc.languages.syntax.wmodel.sets.*;


public interface WmodelVisitor<T> {

    // pre-defined sets:

    T visit(WSetMemoryEvents set);

    T visit(WSetWrites set);

    T visit(WSetInitialWrites set);

    T visit(WSetReads set);

    T visit(WSetFenceEvents set);

    T visit(WSetBranchEvents set);


    // --
    // relations:

    T visit(WRelationProgramOrder relation);

    T visit(WRelationReadFrom relation);

    // --
    // operators:

    T visit(WOperatorUnary operator);

    T visit(WOperatorBinary operator);
}
