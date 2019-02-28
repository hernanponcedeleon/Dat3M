package com.dat3m.dartagnan.program.event.rmw.cond;

import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWReadCondUnless extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String mo) {
        super(reg, cmp, address, mo);
    }

    private RMWReadCondUnless(RMWReadCondUnless other){
        super(other);
    }

    @Override
    public void initialise(Context ctx) {
        super.initialise(ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
    }

    @Override
    public String condToString(){
        return "# if not " + resultRegister + " = " + cmp;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWReadCondUnless mkCopy(){
        return new RMWReadCondUnless(this);
    }
}
