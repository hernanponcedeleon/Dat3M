package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.analysis.graphRefinement.logic.Literal;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

/* A core literal should be one of the following
    - An event
    - An rf or co edge
    - An address equality/inequality
*/
public interface CoreLiteral extends Literal<CoreLiteral> {
    BooleanFormula getBooleanFormula(SolverContext ctx);
}

