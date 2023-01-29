package com.dat3m.dartagnan.expression.op;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;

public enum BOpUn {
    NOT;

    @Override
    public String toString() {
       	return "!";
    }

    public BooleanFormula encode(BooleanFormula e, FormulaManager m) {
       	return m.getBooleanFormulaManager().not(e);
    }

    public boolean combine(boolean a){
       	return !a;
    }
}
