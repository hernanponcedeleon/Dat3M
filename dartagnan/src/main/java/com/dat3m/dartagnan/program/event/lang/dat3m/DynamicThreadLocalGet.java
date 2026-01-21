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

public final class DynamicThreadLocalGet extends AbstractEvent implements RegWriter, RegReader {

    private Register result;
    private Expression key;

    public DynamicThreadLocalGet(Register r, Expression k) {
        result = checkNotNull(r);
        key = checkNotNull(k);
    }

    private DynamicThreadLocalGet(DynamicThreadLocalGet other) {
        super(other);
        result = other.result;
        key = other.key;
    }

    public Expression getKey() { return key; }

    @Override public Register getResultRegister() { return result; }

    @Override public void setResultRegister(Register r) { result = checkNotNull(r); }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(key, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> transformer) {
        key = key.accept(transformer);
    }

    @Override public String defaultString() { return "%s = DynamicThreadLocalGet(%s)".formatted(result, key); }

    @Override public DynamicThreadLocalGet getCopy() { return new DynamicThreadLocalGet(this); }
}
