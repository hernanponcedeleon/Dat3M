package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.program.event.MemoryAccess;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class Store extends AbstractCoreMemoryEvent {
    protected final Expression value;

    protected Store(Expression address, Expression value) {
        super(address, value.getType(), "");
        this.value = value;
    }

    public Expression getValue() {
        return value;
    }

    @Override
    public MemoryAccess.Mode getAccessMode() { return MemoryAccess.Mode.STORE; }
}
