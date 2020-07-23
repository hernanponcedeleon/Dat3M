package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
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
    public BoolExpr encode(Context ctx, boolean bp) {
        return op.encode(e1.getLastValueExpr(ctx, bp), e2.getLastValueExpr(ctx, bp), ctx, bp);
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
