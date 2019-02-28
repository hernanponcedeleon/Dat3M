package com.dat3m.dartagnan.program.event.rmw.cond;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;

public class FenceCond extends Fence {

    private final RMWReadCond loadEvent;

    public FenceCond (RMWReadCond loadEvent, String name){
        super(name);
        this.loadEvent = loadEvent;
    }

    private FenceCond(FenceCond other){
        super(other);
        this.loadEvent = (RMWReadCond)other.loadEvent.getCopy();
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + loadEvent.condToString();
    }

    @Override
    protected BoolExpr encodeExec(Context ctx){
        return ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(cfVar()), (loadEvent).getCond()), executes(ctx));
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected FenceCond mkCopy(){
        return new FenceCond(this);
    }
}
