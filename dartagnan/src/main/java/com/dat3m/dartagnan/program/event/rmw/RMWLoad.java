package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;

public class RMWLoad extends Load implements RegWriter {

    public RMWLoad(Register reg, IExpr address, String atomic) {
        super(reg, address, atomic);
        addFilters(EType.RMW);
    }

    @Override
    public RMWLoad clone() {
        if(clone == null){
            clone = new RMWLoad(resultRegister, address, atomic);
            afterClone();
        }
        return (RMWLoad)clone;
    }
}
