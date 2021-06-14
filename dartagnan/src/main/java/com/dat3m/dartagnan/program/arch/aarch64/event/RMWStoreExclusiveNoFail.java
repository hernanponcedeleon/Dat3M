package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;

public class RMWStoreExclusiveNoFail extends RMWStoreExclusive implements RegReaderData {

    public RMWStoreExclusiveNoFail(IExpr address, ExprInterface value, String mo){
        super(address, value, mo);
    }

    @Override
    public void initialise(VerificationTask task, Context ctx) {
        super.initialise(task, ctx);
        execVar = ctx.mkBool(true);
    }

    @Override
    public String toString(){
        return String.format("%1$-" + Event.PRINT_PAD_EXTRA + "s", super.toString()) + "# opt with not fail";
    }
}
