package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.type.ScopedPointerType;

public class ScopedPointerVariable extends ScopedPointer {
    public ScopedPointerVariable(String id, ScopedPointerType type, MemoryObject address) {
        super(id, type, address);
    }

    @Override
    public MemoryObject getAddress() {
        return (MemoryObject) super.getAddress();
    }
}
