package com.dat3m.dartagnan.expression;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;

public interface LastValueInterface {

    Formula getLastValueExpr(FormulaManager formulaManager);

}
