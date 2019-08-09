package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;

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
    public RMWLoadExclusive getCopy(int bound){
        return new RMWLoadExclusive(this);
    }
}
