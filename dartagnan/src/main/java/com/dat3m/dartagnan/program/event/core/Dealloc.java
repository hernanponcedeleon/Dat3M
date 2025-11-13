package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;

/// Marks a memory object as no longer usable in the runtime.
/// Accesses to the object, that do not *happen before* this event, usually violate the specification of the program.
/// If this event does not address the object's base, it usually violates the specification of the program.
public final class Dealloc extends Store {

    public Dealloc(Expression a, Expression v) { super(a, v); }

    private Dealloc(Dealloc other) { super(other); }

    @Override protected String defaultString() { return "dealloc(%s)".formatted(address); }

    @Override public Dealloc getCopy() { return new Dealloc(this); }
}
