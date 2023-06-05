package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

public class Store extends AbstractMemoryEvent {

    protected ExprInterface value;

    public Store(IExpr address, ExprInterface value, String mo) {
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
    public ExprInterface getMemValue() {
        return value;
    }

    @Override
    public void setMemValue(ExprInterface value) {
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