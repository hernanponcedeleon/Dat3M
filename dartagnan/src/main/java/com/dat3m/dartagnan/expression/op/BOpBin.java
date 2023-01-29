package com.dat3m.dartagnan.expression.op;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;

public enum BOpBin {
    AND, OR;

    @Override
    public String toString() {
        switch(this){
            case AND:
                return "&&";
            case OR:
                return "||";
        }
        return super.toString();
    }

    public BooleanFormula encode(BooleanFormula e1, BooleanFormula e2, FormulaManager m) {
        BooleanFormulaManager bmgr = m.getBooleanFormulaManager();
		switch(this) {
            case AND:
                return bmgr.and(e1, e2);
            case OR:
                return bmgr.or(e1, e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for BOpBin " + this);
    }

    public boolean combine(boolean a, boolean b){
        switch(this){
            case AND:
                return a && b;
            case OR:
                return a || b;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in BOpBin");
    }
}
