package com.dat3m.dartagnan.expression;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

public interface LastValueInterface extends ExprInterface {

    Formula getLastValueExpr(SolverContext ctx);

}
