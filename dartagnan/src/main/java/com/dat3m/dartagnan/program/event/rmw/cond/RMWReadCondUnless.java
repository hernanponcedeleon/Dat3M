package com.dat3m.dartagnan.program.event.rmw.cond;

import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWReadCondUnless extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondUnless(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    @Override
    public void initialise(Context ctx) {
        super.initialise(ctx);
        this.z3Cond = ctx.mkNot(z3Cond);
    }

    @Override
    public RMWReadCondUnless clone() {
        if(clone == null){
            clone = new RMWReadCondUnless(resultRegister.clone(), cmp.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWReadCondUnless)clone;
    }

    @Override
    public String condToString(){
        return "# if not " + resultRegister + " = " + cmp;
    }
}
