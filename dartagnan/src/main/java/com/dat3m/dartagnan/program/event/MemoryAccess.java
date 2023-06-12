package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.type.Type;

public record MemoryAccess(IExpr address, Type accessType, Mode mode) {
    public enum Mode {
        LOAD, STORE, RMW, OTHER;
    }

}
