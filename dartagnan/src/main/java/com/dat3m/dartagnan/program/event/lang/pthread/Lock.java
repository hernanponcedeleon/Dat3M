package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.StoreBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Lock extends StoreBase {

    private final String name;
    private final Register reg;

    public Lock(String name, Expression address, Register reg) {
        super(address, ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getArchType()), MO_SC);
        this.name = name;
        this.reg = reg;
    }

    private Lock(Lock other) {
        super(other);
        this.name = other.name;
        this.reg = other.reg;
    }

    @Override
    public String defaultString() {
        return "pthread_mutex_lock(&" + name + ")";
    }

    //TODO: Why does this have a ResultRegister without inheriting from RegWriter?
    // Why is this even needed?
    public Register getResultRegister() {
        return reg;
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