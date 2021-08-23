package com.dat3m.dartagnan.program.event.rmw;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class RMWLoadExclusive extends Load implements RegWriter {

    public RMWLoadExclusive(Register reg, IExpr address, String mo) {
        super(reg, address, mo);
        addFilters(EType.EXCL);
    }

    private RMWLoadExclusive(RMWLoadExclusive other){
        super(other);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWLoadExclusive getCopy(){
        return new RMWLoadExclusive(this);
    }
}
