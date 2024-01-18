package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;
import com.google.common.base.Preconditions;

public class AtomicXchg extends RMWXchgBase {

    public AtomicXchg(Register register, Expression address, Expression value, String mo) {
        super(register, address, value, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
    }

    private AtomicXchg(AtomicXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_exchange(*%s, %s, %s)\t###C11", resultRegister, address, storeValue, mo);
    }

    @Override
    public AtomicXchg getCopy() {
        return new AtomicXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicXchg(this);
    }
}