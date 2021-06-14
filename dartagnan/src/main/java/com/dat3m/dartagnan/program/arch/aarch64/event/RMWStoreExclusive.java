package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

public class RMWStoreExclusive extends Store implements RegReaderData {

    protected transient BoolExpr execVar;

    public RMWStoreExclusive(IExpr address, ExprInterface value, String mo, boolean strong){
        super(address, value, mo);
        addFilters(EType.EXCL);
        if(strong) {
        	addFilters(EType.STRONG);
        }
    }

    public RMWStoreExclusive(IExpr address, ExprInterface value, String mo){
        this(address, value, mo, false);
    }

    String toStringBase(){
        return super.toString();
    }

    @Override
    public BoolExpr exec() {
        return is(EType.STRONG) ? cfVar : execVar;
    }

    @Override
    public void initialise(VerificationTask task, Context ctx) {
        super.initialise(task, ctx);
        execVar = ctx.mkBoolConst("exec(" + repr() + ")");
    }

    @Override
    public String toString(){
    	String tag = is(EType.STRONG) ? " strong" : "";
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt" + tag;
    }

    @Override
    protected BoolExpr encodeExec(Context ctx){
        return ctx.mkImplies(execVar, cfVar);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new RuntimeException("RMWStoreExclusive cannot be unrolled: event must be generated during compilation");
    }
}
