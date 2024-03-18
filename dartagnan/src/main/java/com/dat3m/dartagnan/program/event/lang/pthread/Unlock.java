package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.StoreBase;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Unlock extends StoreBase {

    private final String name;

    public Unlock(String name, Expression address) {
        super(address, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType()), MO_SC);
        this.name = name;
    }

    private Unlock(Unlock other) {
        super(other);
        this.name = other.name;
    }

    @Override
    public String defaultString() {
        return "pthread_mutex_unlock(&" + name + ")";
    }

    @Override
    public Unlock getCopy() {
        return new Unlock(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitUnlock(this);
    }
}