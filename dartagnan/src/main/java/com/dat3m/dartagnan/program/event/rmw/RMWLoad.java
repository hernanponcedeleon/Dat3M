package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;

public class RMWLoad extends Load implements RegWriter {

    public RMWLoad(Register reg, IExpr address, String mo) {
        super(reg, address, mo);
        addFilters(EType.RMW);
    }

    protected RMWLoad(RMWLoad other){
        super(other);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RMWLoad mkCopy(){
        return new RMWLoad(this);
    }
}
