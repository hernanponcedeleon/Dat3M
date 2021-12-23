package com.dat3m.dartagnan.expression;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public interface ExprInterface {

    Formula toIntFormula(Event e, SolverContext ctx);

    BooleanFormula toBoolFormula(Event e, SolverContext ctx);

    BigInteger getIntValue(Event e, Model model, SolverContext ctx);

    boolean getBoolValue(Event e, Model model, SolverContext ctx);

    ImmutableSet<Register> getRegs();

    default ImmutableSet<Location> getLocs() {
    	return ImmutableSet.of();
    }
    
    int getPrecision();
    
    <T> T visit(ExpressionVisitor<T> visitor);

    //default ExprInterface simplify() { return visit(ExprSimplifier.SIMPLIFIER); }
    
}
