package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.google.common.collect.ImmutableSet;

public class FenceWithId extends Fence implements RegReaderData {
    private final IExpr fenceID;

    public FenceWithId(String name, IExpr fenceID) {
        super(name);
        this.fenceID = fenceID;
    }

    public IExpr getFenceID() {
        return fenceID;
    }

    @Override
    public ImmutableSet<Register> getDataRegs() {
        return fenceID.getRegs();
    }
}
