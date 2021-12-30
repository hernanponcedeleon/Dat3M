package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;

public class AssertBasic extends AbstractAssert {

    private final LastValueInterface e1;
    private final LastValueInterface e2;
    private final COpBin op;

    public AssertBasic(LastValueInterface e1, COpBin op, LastValueInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(e1.getLocs()).addAll(e2.getLocs()).build();
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
        return op.encode(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx), ctx);
    }

    @Override
    public String toString(){
        return valueToString(e1) + op + valueToString(e2);
    }

    private String valueToString(ExprInterface value){
        if(value instanceof Register){
            return ((Register)value).getThreadId() + ":" + value;
        }
        return value.toString();
    }
}
