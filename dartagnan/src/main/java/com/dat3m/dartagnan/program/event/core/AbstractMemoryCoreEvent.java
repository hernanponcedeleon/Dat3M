package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.common.NoInterface;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

/*
    This class is similar to SingleAccessMemoryEvent, but without a memory order.
 */
@NoInterface
public abstract class AbstractMemoryCoreEvent extends AbstractEvent implements MemoryCoreEvent {

    protected Expression address;
    protected Type accessType;

    public AbstractMemoryCoreEvent(Expression address) {
        this.address = address;
        this.accessType = TypeFactory.getInstance().getArchType(); // TODO: Add proper typing
        addTags(VISIBLE, MEMORY);
    }

    protected AbstractMemoryCoreEvent(AbstractMemoryCoreEvent other) {
        super(other);
        this.address = other.address;
        this.accessType = other.accessType;
    }

    public Expression getAddress() { return address; }
    public void setAddress(Expression address) { this.address = address; }

    public Type getAccessType() { return accessType; }
    public void setAccessType(Type type) { this.accessType = type; }
}

