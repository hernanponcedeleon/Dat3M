package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

/*
    WARNING: This class is an implementation detail, i.e., it does NOT provide an interface
    and should ONLY be used to reduce boilerplate code by sharing common code.

    A SingleAddressMemoryEvent may perform multiple memory accesses, but all of them are on the same address
    with the same type.
    This includes simple loads and stores but also RMW events or abstract events like SRCU.
    Complex events like MemCpy access two different addresses and hence are unable to
    reuse the implementation given by this class.
 */
public abstract class SingleAddressMemoryEvent extends AbstractEvent implements MemoryEvent {

    protected IExpr address;
    protected Type accessType;
    protected String mo;

    // The empty string means no memory order 
    public SingleAddressMemoryEvent(IExpr address, String mo) {
        Preconditions.checkNotNull(mo, "The memory ordering cannot be null");
        this.address = address;
        this.mo = mo;
        // TODO: Add proper typing.
        this.accessType = TypeFactory.getInstance().getArchType();
        addTags(VISIBLE, MEMORY);
        if (!mo.isEmpty()) {
            addTags(mo);
        }
    }

    protected SingleAddressMemoryEvent(SingleAddressMemoryEvent other) {
        super(other);
        this.address = other.address;
        this.mo = other.mo;
        this.accessType = other.accessType;
    }

    public IExpr getAddress() { return address; }
    public void setAddress(IExpr address) { this.address = address; }

    public Type getAccessType() { return accessType; }
    public void setAccessType(Type type) { this.accessType = type; }

    @Override
    public String getMo() {
        return mo;
    }

}

