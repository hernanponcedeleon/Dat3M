package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

public interface ExprInterface {

    Formula toIntFormula(Event e, FormulaManager m);

    BooleanFormula toBoolFormula(Event e, FormulaManager m);

    BigInteger getIntValue(Event e, Model model, FormulaManager m);

    boolean getBoolValue(Event e, Model model, FormulaManager m);

    default ImmutableSet<Register> getRegs() {
    	return ImmutableSet.of();
    }

    <T> T visit(ExpressionVisitor<T> visitor);

    //default ExprInterface simplify() { return visit(ExprSimplifier.SIMPLIFIER); }
    
}
