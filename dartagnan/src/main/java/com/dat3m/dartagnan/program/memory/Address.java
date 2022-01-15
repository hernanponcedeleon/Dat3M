package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

public class Address extends IConst implements ExprInterface, LastValueInterface {

    private final int index;

    Address(int index){
        super(BigInteger.valueOf(index), -1);
        this.index = index;
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
        return toIntFormula(ctx);
    }

    public Formula getLastMemValueExpr(SolverContext ctx){
		String name = "last_val_at_memory_" + index;
		return ctx.getFormulaManager().getIntegerFormulaManager().makeVariable(name);
    }

    @Override
    public BooleanFormula toBoolFormula(Event e, SolverContext ctx){
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

    @Override
    public String toString(){
        return "&mem" + index;
    }

    @Override
    public int hashCode(){
        return index;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return index == ((Address)obj).index;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
