package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

public class Store extends AbstractMemoryEvent {

    protected Expression value;

    public Store(Expression address, Expression value, String mo) {
        super(address, mo);
        this.value = value;
        addTags(Tag.WRITE);
    }

    protected Store(Store other) {
        super(other);
        this.value = other.value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public String toString() {
        return "store(*" + address + ", " + value + (!mo.isEmpty() ? ", " + mo : "") + ")";
    }

    @Override
    public Expression getMemValue() {
        return value;
    }

    @Override
    public void setMemValue(Expression value) {
        this.value = value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Store getCopy() {
        return new Store(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitStore(this);
    }
}