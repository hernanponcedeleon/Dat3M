package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.Store;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

public class RMWStoreExclusive extends Store implements RegReaderData {

    RMWStoreExclusive(IExpr address, ExprInterface value, String mo){
        super(address, value, mo);
        addFilters(EType.EXCL);
    }

    String toStringBase(){
        return super.toString();
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt";
    }

    @Override
    protected BoolExpr encodeExec(Context ctx){
        return ctx.mkImplies(execVar, cfVar);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int unroll(int bound, int nextId, Event predecessor) {
        throw new RuntimeException("RMWStoreExclusive cannot be unrolled: event must be generated during compilation");
    }
}
