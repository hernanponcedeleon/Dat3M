package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

/*
    WARNING: This class is an implementation detail, i.e., it does NOT provide an interface
    and should ONLY be used to reduce boilerplate code by sharing common code.
 */
public abstract class AbstractMemoryCoreEvent extends AbstractEvent implements MemoryCoreEvent {

    protected IExpr address;
    protected Type accessType;

    // The empty string means no memory order
    public AbstractMemoryCoreEvent(IExpr address) {
        this.address = address;
        this.accessType = TypeFactory.getInstance().getArchType();
        addTags(VISIBLE, MEMORY);
    }

    protected AbstractMemoryCoreEvent(AbstractMemoryCoreEvent other) {
        super(other);
        this.address = other.address;
        this.accessType = other.accessType;
    }

    public IExpr getAddress() { return address; }
    public void setAddress(IExpr address) { this.address = address; }

    public Type getAccessType() { return accessType; }
    public void setAccessType(Type type) { this.accessType = type; }


}

