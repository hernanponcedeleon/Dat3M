package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;

public class ScopedPointerVariable extends ScopedPointer {

    public ScopedPointerVariable(String id, String scopeId, Type innerType, MemoryObject address) {
        super(id, scopeId, innerType, address);
    }

    @Override
    public MemoryObject getAddress() {
        return (MemoryObject) super.getAddress();
    }

    public void setInitialValue(int offset, Expression value) {
        getAddress().setInitialValue(offset, value);
    }
}
