package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.types.VoidType;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;

/*
    A GenericMemoryEvent is used as the basis for implementing special (abstract) memory events like
    SRCU and Hazard pointers.
    For now, generic memory events are type-less.
 */
public abstract class GenericMemoryEvent extends AbstractCoreMemoryEvent {

    protected GenericMemoryEvent(Expression address) {
        super(address, VoidType.get(), "");
    }

    @Override
    public MemoryAccess.Mode getAccessMode() {
        return MemoryAccess.Mode.OTHER;
    }
}
