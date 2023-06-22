package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;

import java.util.HashSet;
import java.util.Set;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public class Return extends AbstractEvent implements RegReader {

    protected Expression expression;

    public Return(Expression expression) {
        this.expression = expression;
    }

    protected Return(Return other) {
        super(other);
        this.expression = other.expression;
    }

    public Expression getValue() { return expression; }

    @Override
    protected String defaultString() {
        return String.format("return %s", expression);
    }

    @Override
    public Return getCopy() {
        return new Return(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expression, Register.UsageType.DATA, new HashSet<>());
    }
}
