package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Lock extends StoreBase {

    private final String name;

    public Lock(String name, Expression address) {
        super(address, ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getArchType()), MO_SC);
        this.name = name;
    }

    private Lock(Lock other) {
        super(other);
        this.name = other.name;
    }

    @Override
    public String defaultString() {
        return "pthread_mutex_lock(&" + name + ")";
    }

    @Override
    public Lock getCopy() {
        return new Lock(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLock(this);
    }
}