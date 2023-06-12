package com.dat3m.dartagnan.prototype.program.event.core.memory;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;

public abstract class AbstractCoreMemoryEvent extends AbstractEvent implements MemoryCoreEvent {

    protected Expression address;
    protected Type accessType;
    protected String memoryOrder;

    protected AbstractCoreMemoryEvent(Expression address, Type type, String mo) {
        this.address = address;
        this.accessType = type;
        this.memoryOrder = mo;
    }

    @Override
    public Expression getAddress() { return address; }
    @Override
    public void setAddress(Expression address) { this.address = address; }

    @Override
    public Type getAccessType() { return accessType; }
    @Override
    public void setAccessType(Type type) { this.accessType = type; }

    @Override
    public String getMo() { return memoryOrder; }
}
