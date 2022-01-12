package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

public interface ExprInterface {

    Formula toIntFormula(Event e, SolverContext ctx);

    BooleanFormula toBoolFormula(Event e, SolverContext ctx);

    BigInteger getIntValue(Event e, Model model, SolverContext ctx);

    boolean getBoolValue(Event e, Model model, SolverContext ctx);

    default ImmutableSet<Register> getRegs() {
    	return ImmutableSet.of();
    }

    <T> T visit(ExpressionVisitor<T> visitor);

    //default ExprInterface simplify() { return visit(ExprSimplifier.SIMPLIFIER); }
    
}
