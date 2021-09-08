package com.dat3m.dartagnan.asserts;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public class AssertTrue extends AbstractAssert {

    @Override
    public BooleanFormula encode(SolverContext ctx) {
    	// We want the verification to succeed so it should be UNSAT
        return ctx.getFormulaManager().getBooleanFormulaManager().makeFalse();
    }

    @Override
    public AbstractAssert removeLocAssertions(boolean replaceByTrue) {
        return this;
    }

    @Override
    public String toString(){
        return "true";
    }
}
