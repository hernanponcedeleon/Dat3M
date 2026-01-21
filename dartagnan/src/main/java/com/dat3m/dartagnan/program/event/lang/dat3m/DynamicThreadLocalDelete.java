package com.dat3m.dartagnan.program.event.lang.dat3m;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public class DynamicThreadLocalDelete extends AbstractEvent implements RegReader {

    private Expression key;

    public DynamicThreadLocalDelete(Expression k) {
        key = checkNotNull(k);
    }

    private DynamicThreadLocalDelete(DynamicThreadLocalDelete other) {
        super(other);
        key = other.key;
    }

    public Expression getKey() { return key; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(key, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> transformer) {
        key = key.accept(transformer);
    }

    @Override protected String defaultString() { return "DynamicThreadLocalDelete(%s)".formatted(key); }

    @Override public DynamicThreadLocalDelete getCopy() { return new DynamicThreadLocalDelete(this); }
}
