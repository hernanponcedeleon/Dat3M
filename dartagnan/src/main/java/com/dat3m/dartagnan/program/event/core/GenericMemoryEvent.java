package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.MemoryAccess;

import java.util.List;

/*
    This is a generic notion of memory event that neither loads nor stores but "abstractly" accesses memory.
    By assigning a distinct tag to instances of this event, one can model abstract memory events like SRCU and hazard pointers.
    In that sense, a GenericMemoryEvent is similar to a Fence that carries an actual address.
 */
public class GenericMemoryEvent extends AbstractMemoryCoreEvent {

    // This is a name for printing only.
    private final String displayName;

    public GenericMemoryEvent(Expression address, String displayName) {
        super(address, TypeFactory.getInstance().getArchType()); // TODO: Maybe a void type would be fine here
        this.displayName = displayName;
    }

    protected GenericMemoryEvent(GenericMemoryEvent other) {
        super(other);
        this.displayName = other.displayName;
    }

    @Override
    protected String defaultString() {
        return String.format("%s(%s)", displayName, address);
    }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }

    @Override
    public GenericMemoryEvent getCopy() {
        return new GenericMemoryEvent(this);
    }
}

