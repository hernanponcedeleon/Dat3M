package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.Set;

@NoInterface
public abstract class StoreBase extends SingleAddressMemoryEvent {

    protected ExprInterface value;

    public StoreBase(IExpr address, ExprInterface value, String mo) {
        super(address, mo);
        this.value = value;
        addTags(Tag.WRITE);
    }

    protected StoreBase(StoreBase other) {
        super(other);
        this.value = other.value;
    }

    public ExprInterface getMemValue() {
        return value;
    }
    public void setMemValue(ExprInterface value) {
        this.value = value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE);
    }

    @Override
    public String toString() {
        return String.format("store(*%s, %s%s)", address, value, !mo.isEmpty() ? ", " + mo : "");
    }

}