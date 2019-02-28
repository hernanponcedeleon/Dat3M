package com.dat3m.dartagnan.program.event.rmw.cond;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWReadCondCmp extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    private RMWReadCondCmp(RMWReadCondCmp other){
        super(other);
    }

    @Override
    public String condToString(){
        return "# if " + resultRegister + " = " + cmp;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWReadCondCmp mkCopy(){
        return new RMWReadCondCmp(this);
    }
}
