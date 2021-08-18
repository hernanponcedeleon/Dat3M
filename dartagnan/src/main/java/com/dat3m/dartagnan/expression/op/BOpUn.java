package com.dat3m.dartagnan.expression.op;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

public enum BOpUn {
    NOT;

    @Override
    public String toString() {
       	return "!";
    }

    public BooleanFormula encode(BooleanFormula e, SolverContext ctx) {
       	return ctx.getFormulaManager().getBooleanFormulaManager().not(e);
    }

    public boolean combine(boolean a){
       	return !a;
    }
}
