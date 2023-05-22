package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

/*
    This event is common among ARMv8, RISCV, and PPC.
    It gets compiled down to a pair of RMWStoreExclusive + ExecutionStatus.
 */
public class StoreExclusive extends Store implements RegWriter {

    private final Register register;

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
    public String toString() {
        return register + " <- store(*" + address + ", " + value + (!mo.isEmpty() ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public StoreExclusive getCopy() {
        return new StoreExclusive(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitStoreExclusive(this);
    }
}