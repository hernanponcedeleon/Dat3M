package com.dat3m.dartagnan.programNew.event.lang;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.dat3m.dartagnan.programNew.event.MemoryAccess;
import com.dat3m.dartagnan.programNew.event.MemoryEvent;

import java.util.List;

/*
    NOTE: A Free gets compiled down to a Store event with
        - constant value (likely 0)
        - a special "free"-tag
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Free extends AbstractEvent implements MemoryEvent {
    protected final MemoryAccess memoryAccess;

    protected Free(Expression address, Type freedType) {
        this.memoryAccess = new MemoryAccess(address, freedType, MemoryAccess.Mode.STORE);
    }

    public Expression getAddress() {
        return memoryAccess.address();
    }
    public Type getFreedType() { return memoryAccess.accessType(); }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(memoryAccess);
    }

}
