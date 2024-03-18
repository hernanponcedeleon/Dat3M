package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_RELEASE;

public class AtomicLoad extends LoadBase {


    public AtomicLoad(Register register, Expression address, String mo) {
        super(register, address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_RELEASE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getName() + " can not have memory order: " + mo);
    }

    private AtomicLoad(AtomicLoad other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_load(*%s, %s)\t### C11", resultRegister, address, mo);
    }

    @Override
    public AtomicLoad getCopy() {
        return new AtomicLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicLoad(this);
    }
}