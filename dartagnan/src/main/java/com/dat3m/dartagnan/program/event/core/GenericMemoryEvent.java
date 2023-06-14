package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.MemoryAccess;

import java.util.List;

/*
    This is a generic notion memory event that neither loads nor stores but "abstractly" accesses memory.
    By assigning a distinct tag to instance of this event, one can model abstract memory events like SRCU and hazard pointers.
    In that sense, a GenericMemoryEvent is similar to a Fence that carries an actual address.
 */
public class GenericMemoryEvent extends AbstractMemoryCoreEvent implements MemoryCoreEvent {

    private final String name;

    public GenericMemoryEvent(Expression address, String name) {
        super(address);
        this.name = name;
    }

    protected GenericMemoryEvent(GenericMemoryEvent other) {
        super(other);
        this.name = other.name;
    }

    @Override
    protected String defaultString() {
        return String.format("%s(%s)", name, address);
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }
}

