package com.dat3m.dartagnan.program.event.lang.linux.cond;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

public class RMWReadCondCmp extends RMWReadCond implements RegWriter, RegReaderData {

    public RMWReadCondCmp(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, cmp, address, atomic);
    }

    @Override
    public String condToString(){
        return "# if " + resultRegister + " = " + cmp;
    }

}
