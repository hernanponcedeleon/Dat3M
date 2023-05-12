package com.dat3m.dartagnan.programNew.event;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.Type;

public record MemoryAccess(Expression address, Type accessType, Mode mode) {
    public enum Mode {
        LOAD, STORE, OTHER;
    }

    public MemoryAccess withAddress(Expression address) {
        return new MemoryAccess(address, accessType, mode);
    }

    public MemoryAccess withType(Type accessType) {
        return new MemoryAccess(address, accessType, mode);
    }

}
