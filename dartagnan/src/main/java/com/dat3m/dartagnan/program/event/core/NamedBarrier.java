package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.Set;

public class NamedBarrier extends ControlBarrier implements RegReader {

    private Expression id;
    private Expression quorum;

    public NamedBarrier(String name, String instanceId, Expression id) {
        this(name, instanceId, id, null);
    }

    public NamedBarrier(String name, String instanceId, Expression id, Expression quorum) {
        super(name, instanceId);
        this.id = id;
        this.quorum = quorum;
    }

    private NamedBarrier(NamedBarrier other) {
        super(other);
        this.id = other.id;
        this.quorum = other.quorum;
    }

    public Expression getId() {
        return id;
    }

    public Expression getQuorum() {
        return quorum;
    }

    @Override
    public String defaultString() {
        if (quorum == null) {
            return String.format("%s := barrier(%s, %s)", name, getInstanceId(), id);
        }
        return String.format("%s := barrier(%s, %s, %s)", name, getInstanceId(), id, quorum);
    }

    @Override
    public ControlBarrier getCopy() {
        return new NamedBarrier(this);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.id = id.accept(exprTransformer);
        if (this.quorum != null) {
            this.quorum = quorum.accept(exprTransformer);
        }
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        Set<Register.Read> result = new HashSet<>();
        id.getRegs().forEach(r -> result.add(new Register.Read(r, Register.UsageType.OTHER)));
        if (quorum != null) {
            quorum.getRegs().forEach(r -> result.add(new Register.Read(r, Register.UsageType.OTHER)));
        }
        return result;
    }
}
