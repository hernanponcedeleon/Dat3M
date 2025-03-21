package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;

public class ScopedPointerVariable extends ScopedPointer {
    public ScopedPointerVariable(String id, ScopedPointerType pointerType, MemoryObject address) {
        super(id, pointerType, address);
    }

    @Override
    public MemoryObject getAddress() {
        return (MemoryObject) super.getAddress();
    }

    public void setInitialValue(int offset, Expression value) {
        getAddress().setInitialValue(offset, value);
    }
}
