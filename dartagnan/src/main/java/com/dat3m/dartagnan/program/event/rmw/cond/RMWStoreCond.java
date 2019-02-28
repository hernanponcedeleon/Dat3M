package com.dat3m.dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

public class RMWStoreCond extends RMWStore implements RegReaderData {

    public RMWStoreCond(RMWReadCond loadEvent, IExpr address, ExprInterface value, String mo) {
        super(loadEvent, address, value, mo);
    }

    private RMWStoreCond(RMWStoreCond other){
        super(other);
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + ((RMWReadCond)loadEvent).condToString();
    }

    @Override
    protected BoolExpr encodeExec(Context ctx){
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), ((RMWReadCond)loadEvent).getCond()), executes(ctx));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWStoreCond mkCopy(){
        return new RMWStoreCond(this);
    }
}
