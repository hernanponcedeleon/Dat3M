package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;

public class LKMMLock extends SingleAccessMemoryEvent {

    public LKMMLock(Expression lock) {
        // This event will be compiled to LKMMLockRead + LKMMLockWrite
        // and each of those will be assigned a proper memory ordering
        super(lock, TypeFactory.getInstance().getIntegerType(32), "");
    }

    protected LKMMLock(LKMMLock other) {
        super(other);
    }

    public Expression getLock() {
        return address;
    }

    @Override
    public String defaultString() {
        return String.format("spin_lock(*%s)", address);
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    @Override
    public LKMMLock getCopy() {
        return new LKMMLock(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMLock(this);
    }
}
