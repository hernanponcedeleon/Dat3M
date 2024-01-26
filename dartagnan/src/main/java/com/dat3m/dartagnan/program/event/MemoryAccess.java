package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;

public record MemoryAccess(Expression address, Type accessType, Mode mode) {
    public enum Mode {
        LOAD, STORE, RMW, OTHER;
    }

}
