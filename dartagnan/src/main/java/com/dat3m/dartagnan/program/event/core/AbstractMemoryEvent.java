package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;

public abstract class AbstractMemoryEvent extends AbstractEvent implements MemoryEvent {

    protected IExpr address;
    protected String mo;

    // The empty string means no memory order 
    public AbstractMemoryEvent(IExpr address, String mo) {
        Preconditions.checkNotNull(mo, "The memory ordering cannot be null");
        this.address = address;
        this.mo = mo;
        addTags(VISIBLE, MEMORY);
        if (!mo.isEmpty()) {
            addTags(mo);
        }
    }

    protected AbstractMemoryEvent(AbstractMemoryEvent other) {
        super(other);
        this.address = other.address;
        this.mo = other.mo;
    }

    @Override
    public IExpr getAddress() {
        return address;
    }

    @Override
    public void setAddress(IExpr address) {
        this.address = address;
    }

    @Override
    public ExprInterface getMemValue() {
        throw new RuntimeException("MemValue is not available for event " + this.getClass().getName());
    }

    @Override
    public void setMemValue(ExprInterface value) {
        throw new RuntimeException("SetValue is not available for event " + this.getClass().getName());
    }

    @Override
    public String getMo() {
        return mo;
    }

    @Override
    public void setMo(String mo) {
        Preconditions.checkNotNull(mo, "The memory ordering cannot be null");
        if (!this.mo.isEmpty()) {
            removeTags(this.mo);
        }
        this.mo = mo;
        // This cannot be merged with the if above, because this.mo was updated
        if (!this.mo.isEmpty()) {
            addTags(mo);
        }
    }

}

