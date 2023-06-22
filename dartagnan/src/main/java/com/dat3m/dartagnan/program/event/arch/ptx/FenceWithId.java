package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;

import java.util.HashSet;
import java.util.Set;

public class FenceWithId extends Fence implements RegReader {
    private final Expression fenceID;

    public FenceWithId(String name, Expression fenceID) {
        super(name);
        this.fenceID = fenceID;
    }

    public Expression getFenceID() {
        return fenceID;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(fenceID, Register.UsageType.OTHER, new HashSet<>());
    }
}
