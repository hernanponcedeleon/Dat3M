package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;

public class AtomicStore extends StoreBase {

    public AtomicStore(Expression address, Expression value, String mo){
        super(address, value, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_ACQUIRE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getSimpleName() + " cannot have memory order: " + mo);
    }

    private AtomicStore(AtomicStore other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("atomic_store(*%s, %s, %s)\t### C11", address, value, mo);
    }

    @Override
    public AtomicStore getCopy() {
        return new AtomicStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicStore(this);
    }
}