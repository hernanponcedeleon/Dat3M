package com.dat3m.dartagnan.program.event.rmw.opt;

import com.dat3m.dartagnan.program.utils.EType;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWStoreOptStatus extends Event implements RegWriter {

    private final Register register;
    private final RMWStoreOpt storeEvent;
    private IntExpr regResultExpr;

    public RMWStoreOptStatus(Register register, RMWStoreOpt storeEvent){
        this.register = register;
        this.storeEvent = storeEvent;
        addFilters(EType.ANY, EType.VISIBLE, EType.LOCAL, EType.REG_WRITER);
    }

    private RMWStoreOptStatus(RMWStoreOptStatus other){
        super(other);
        this.register = other.register;
        this.storeEvent = (RMWStoreOpt)other.storeEvent.getCopy();
    }

    @Override
    public void initialise(Context ctx) {
        regResultExpr = register.toZ3IntResult(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return register;
    }

    @Override
    public IntExpr getResultRegisterExpr(){
        return regResultExpr;
    }

    @Override
    public String toString() {
        return register + " <- status(" + storeEvent.toStringBase() + ")";
    }

    @Override
    protected BoolExpr encodeExec(Context ctx){
        BoolExpr enc = ctx.mkAnd(
                ctx.mkImplies(storeEvent.executes(ctx), ctx.mkEq(regResultExpr, new IConst(0).toZ3Int(this, ctx))),
                ctx.mkImplies(ctx.mkNot(storeEvent.executes(ctx)), ctx.mkEq(regResultExpr, new IConst(1).toZ3Int(this, ctx)))
        );
        return ctx.mkAnd(super.encodeExec(ctx), enc);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWStoreOptStatus mkCopy(){
        return new RMWStoreOptStatus(this);
    }
}
