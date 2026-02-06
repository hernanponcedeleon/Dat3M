package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.MemoryAccess;

import java.util.List;

/// Marks a memory object as no longer usable in the runtime.
/// Accesses to the object, that do not *happen before* this event, usually violate the specification of the program.
/// If this event does not address the object's base, it usually violates the specification of the program.
public final class Dealloc extends AbstractMemoryCoreEvent {

    public Dealloc(Expression address, Type accessType) {
        super(address, accessType);
    }

    private Dealloc(Dealloc other) { super(other); }

    @Override
    public List<MemoryAccess> getMemoryAccesses() {
        return List.of(new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER));
    }

    @Override protected String defaultString() { return "dealloc(%s)".formatted(address); }

    @Override public Dealloc getCopy() { return new Dealloc(this); }
}
