package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.LinkedHashSet;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

// The result register is set to true on success and to false if the key is invalid.
public final class DynamicThreadLocalSet extends AbstractEvent implements RegWriter, RegReader {

    private Register success;
    private Expression key;
    private Expression value;

    public DynamicThreadLocalSet(Register s, Expression k, Expression v) {
        success = checkNotNull(s);
        key = checkNotNull(k);
        value = checkNotNull(v);
    }

    private DynamicThreadLocalSet(DynamicThreadLocalSet other) {
        super(other);
        success = other.success;
        key = other.key;
        value = other.value;
    }

    public Expression getKey() { return key; }

    public Expression getValue() { return value; }

    @Override public Register getResultRegister() { return success; }

    @Override public void setResultRegister(Register r) { success = checkNotNull(r); }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> reads = Register.collectRegisterReads(key, Register.UsageType.OTHER, new LinkedHashSet<>());
        return Register.collectRegisterReads(value, Register.UsageType.OTHER, reads);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> transformer) {
        key = key.accept(transformer);
        value = value.accept(transformer);
    }

    @Override public String defaultString() { return "%s = DynamicThreadLocalSet(%s, %s)".formatted(success, key, value); }

    @Override public DynamicThreadLocalSet getCopy() { return new DynamicThreadLocalSet(this); }
}
