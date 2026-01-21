package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.HashSet;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

/*
    This event dynamically spawns a single thread-local storage object family.
    - Each thread gets an own object, accessible through DynamicThreadLocalGet and DynamicThreadLocalSet.
    - Each thread attempts to pass its object to the destructor at its regular exit.
 */
public final class DynamicThreadLocalCreate extends AbstractEvent implements RegWriter, RegReader {

    private Register key;
    private Expression destructor;

    public DynamicThreadLocalCreate(Register k, Expression d) {
        key = checkNotNull(k);
        destructor = checkNotNull(d);
    }

    private DynamicThreadLocalCreate(DynamicThreadLocalCreate other) {
        super(other);
        key = other.key;
        destructor = other.destructor;
    }

    public Expression getDestructor() { return destructor; }

    @Override public Register getResultRegister() { return key; }

    @Override public void setResultRegister(Register r) { key = checkNotNull(r); }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(destructor, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> transformer) {
        destructor = destructor.accept(transformer);
    }

    @Override
    protected String defaultString() {
        return "%s = DynamicThreadLocalCreate(dtor=%s)".formatted(key, destructor);
    }

    @Override public DynamicThreadLocalCreate getCopy() { return new DynamicThreadLocalCreate(this); }
}
