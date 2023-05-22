package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.core.Fence;

public class FenceWithId extends Fence {
    private final IExpr fenceID;

    public FenceWithId(String name, IExpr fenceID) {
        super(name);
        this.fenceID = fenceID;
    }

    public IExpr getFenceID() {
        return fenceID;
    }
}
