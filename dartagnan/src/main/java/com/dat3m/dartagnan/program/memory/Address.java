package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.HashMap;

import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.google.common.base.Preconditions.checkArgument;

public class Address extends IConst implements ExprInterface, LastValueInterface {

    private final int index;
    private final int size;
    BigInteger value;

    private final HashMap<Integer,IConst> initialValues = new HashMap<>();

    Address(int index, int s) {
        this.index = index;
        size = s;
    }

    public int size() {
        return size;
    }

    public void setInitialValue(int offset, IConst value) {
        initialValues.put(offset,value);
    }

    public IConst getInitialValue(int offset) {
        return initialValues.getOrDefault(offset,IValue.ZERO);
    }

    public IExpr add(int offset) {
        checkArgument(0<=offset && offset<size,"Array out of bounds.");
        return offset == 0 ? this : new IExprBin(this,PLUS,new IValue(BigInteger.valueOf(offset),getPrecision()));
    }

    public Formula getLastMemValueExpr(SolverContext ctx, int offset) {
        checkArgument(0<=offset && offset<size,"Array out of bounds.");
        String name = String.format("last_val_at_memory_%d_%d",index,offset);
        return ctx.getFormulaManager().getIntegerFormulaManager().makeVariable(name);
    }

    @Override
    public BigInteger getValue() {
        return value != null ? value : BigInteger.valueOf(index);
    }

    @Override
    public int getPrecision() {
        return -1;
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
