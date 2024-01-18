package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;

/*
    This event is common among ARMv8, RISCV, and PPC.
    It gets compiled down to a pair of RMWStoreExclusive + ExecutionStatus.
 */
public class StoreExclusive extends StoreBase implements RegWriter {

    private Register register;

    public StoreExclusive(Register register, Expression address, Expression value, String mo) {
        super(address, value, mo);
        this.register = register;
        addTags(Tag.EXCL);
    }

    private StoreExclusive(StoreExclusive other) {
        super(other);
        this.register = other.register;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public void setResultRegister(Register reg) { this.register = reg; }

    @Override
    public String defaultString() {
        return register + " <- store(*" + address + ", " + value + (!mo.isEmpty() ? ", " + mo : "") + ")";
    }

    @Override
    public StoreExclusive getCopy() {
        return new StoreExclusive(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitStoreExclusive(this);
    }
}