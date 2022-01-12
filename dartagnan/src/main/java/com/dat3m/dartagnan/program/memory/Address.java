package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;

public class Address extends IConst implements ExprInterface, LastValueInterface {

    private final int index;

    Address(int index){
        super(BigInteger.valueOf(index), -1);
        this.index = index;
    }

    public IExpr add(int offset) {
        return offset == 0 ? this : new IExprBin(this,PLUS,new IConst(BigInteger.valueOf(offset),getPrecision()));
    }

    public Formula getLastMemValueExpr(SolverContext ctx, int offset) {
        String name = "last_val_at_memory_" + (index + offset);
        return ctx.getFormulaManager().getIntegerFormulaManager().makeVariable(name);
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
        return toIntFormula(ctx);
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
