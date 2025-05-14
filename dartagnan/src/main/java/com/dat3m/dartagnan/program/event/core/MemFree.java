package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.HashSet;
import java.util.Set;

public class MemFree extends AbstractEvent implements RegReader {

    private Expression addr;

    public MemFree(Expression addr) {
        this.addr = addr;
        addTags(Tag.VISIBLE, Tag.FREE);
    }

    public Expression getAddress() {
        return addr;
    }

    @Override
    protected String defaultString() {
        return String.format("free(%s)", addr);
    }

    @Override
    public Event getCopy() {
        MemFree other = new MemFree(addr);
        other.setFunction(this.getFunction());
        return other;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(addr, Register.UsageType.ADDR, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        addr = addr.accept(exprTransformer);
    }
}
