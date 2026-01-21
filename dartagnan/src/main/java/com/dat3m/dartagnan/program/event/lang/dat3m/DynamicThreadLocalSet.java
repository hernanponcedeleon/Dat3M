package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public final class DynamicThreadLocalSet extends AbstractEvent implements RegReader {

    private Expression key;
    private Expression value;

    public DynamicThreadLocalSet(Expression k, Expression v) {
        key = checkNotNull(k);
        value = checkNotNull(v);
    }

    private DynamicThreadLocalSet(DynamicThreadLocalSet other) {
        super(other);
        key = other.key;
        value = other.value;
    }

    public Expression getKey() { return key; }

    public Expression getValue() { return value; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> reads = Register.collectRegisterReads(key, Register.UsageType.OTHER, new HashSet<>());
        return Register.collectRegisterReads(value, Register.UsageType.OTHER, reads);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> transformer) {
        key = key.accept(transformer);
        value = value.accept(transformer);
    }

    @Override public String defaultString() { return "DynamicThreadLocalGet(%s, %s)".formatted(key, value); }

    @Override public DynamicThreadLocalSet getCopy() { return new DynamicThreadLocalSet(this); }
}
