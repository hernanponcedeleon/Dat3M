package com.dat3m.dartagnan.asserts;

import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.LastValueInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;

public class AssertBasic extends AbstractAssert {

    private final ExprInterface e1;
    private final ExprInterface e2;
    private final COpBin op;

    public AssertBasic(ExprInterface e1, COpBin op, ExprInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(e1.getLocs()).addAll(e2.getLocs()).build();
    }

    @Override
    public AbstractAssert removeLocAssertions(boolean replaceByTrue) {
        return getLocs().isEmpty() ? this : (replaceByTrue ? new AssertTrue() :  new AssertNot(new AssertTrue()));
    }

    @Override
    public BooleanFormula encode(SolverContext ctx) {
    	Formula f1 = e1 instanceof LastValueInterface ? ((LastValueInterface)e1).getLastValueExpr(ctx) : null;
    	Formula f2 = e2 instanceof LastValueInterface ? ((LastValueInterface)e2).getLastValueExpr(ctx) : null;
    	if(f1 == null || f2 == null) {
    		throw new RuntimeException("AssertBasic can only relate LastValueInterface objects: " + this);
    	}
        return op.encode(f1, f2, ctx);
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
