package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.type.Type;

public record MemoryAccess(IExpr address, Type accessType, Mode mode) {
    public enum Mode {
        LOAD, STORE, OTHER;
    }

    public MemoryAccess withAddress(IExpr address) {
        return new MemoryAccess(address, accessType, mode);
    }

    public MemoryAccess withType(Type accessType) {
        return new MemoryAccess(address, accessType, mode);
    }

}
