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

    @Override
    public RMWReadCondCmp clone() {
        if(clone == null){
            clone = new RMWReadCondCmp(resultRegister.clone(), cmp.clone(), address.clone(), atomic);
            afterClone();
        }
        return (RMWReadCondCmp)clone;
    }

    @Override
    public String condToString(){
        return "# if " + resultRegister + " = " + cmp;
    }
}
