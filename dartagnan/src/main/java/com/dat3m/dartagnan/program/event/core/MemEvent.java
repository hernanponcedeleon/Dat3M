package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class MemEvent extends Event {

    protected Expression address;
    protected String mo;

    // The empty string means no memory order 
    public MemEvent(Expression address, String mo) {
        Preconditions.checkNotNull(mo, "The memory ordering cannot be null");
        this.address = address;
        this.mo = mo;
        addTags(VISIBLE, MEMORY);
        if (!mo.isEmpty()) {
            addTags(mo);
        }
    }

    protected MemEvent(MemEvent other) {
        super(other);
        this.address = other.address;
        this.mo = other.mo;
    }

    public Expression getAddress() { return address; }
    public void setAddress(Expression address) { this.address = address; }

    public Expression getMemValue() {
        throw new RuntimeException("MemValue is not available for event " + this.getClass().getName());
    }

    public void setMemValue(Expression value) {
        throw new RuntimeException("SetValue is not available for event " + this.getClass().getName());
    }

    public String getMo() { return mo; }

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

    public boolean canRace() { return mo.isEmpty() || mo.equals(C11.NONATOMIC); }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitMemEvent(this);
    }
}
