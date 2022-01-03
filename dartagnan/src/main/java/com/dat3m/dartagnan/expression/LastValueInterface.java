package com.dat3m.dartagnan.expression;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

public interface LastValueInterface {

    Formula getLastValueExpr(SolverContext ctx);

}
