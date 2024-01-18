package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class InitLock extends StoreBase {

    private final String name;

    public InitLock(String name, Expression address, Expression value) {
        super(address, value, MO_SC);
        this.name = name;
    }

    private InitLock(InitLock other) {
        super(other);
        this.name = other.name;
    }

    @Override
    public String defaultString() {
        return "pthread_mutex_init(&" + name + ", " + value + ")";
    }

    @Override
    public InitLock getCopy() {
        return new InitLock(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitInitLock(this);
    }
}