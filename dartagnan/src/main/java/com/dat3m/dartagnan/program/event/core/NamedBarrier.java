package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class NamedBarrier extends ControlBarrier implements RegReader {

    // Resource identifier of a control barrier. Only barriers with the
    // same instanceId and the same resourceId can synchronize with each other.
    private Expression resourceId;

    // Minimal number of threads required to reach a control barrier before
    // any thread can proceed. If quorum is null, all threads having a barrier
    // with the same instanceId and the same resourceId must reach the barrier
    // before any of these threads can proceed.
    private Expression quorum;

    public NamedBarrier(String name, String instanceId, String execScope, Expression resourceId) {
        this(name, instanceId, execScope, resourceId, null);
    }

    public NamedBarrier(String name, String instanceId, String execScope, Expression resourceId, Expression quorum) {
        super(name, instanceId, execScope);
        this.resourceId = resourceId;
        this.quorum = quorum;
    }

    private NamedBarrier(NamedBarrier other) {
        super(other);
        this.resourceId = other.resourceId;
        this.quorum = other.quorum;
    }

    public Expression getResourceId() {
        return resourceId;
    }

    public Expression getQuorum() {
        return quorum;
    }

    @Override
    public String defaultString() {
        if (quorum == null) {
            return String.format("%s := barrier(%s, %s, %s)", name, getExecScope(), getInstanceId(), resourceId);
        }
        return String.format("%s := barrier(%s, %s, %s, %s)", name, getExecScope(), getInstanceId(), resourceId, quorum);
    }

    @Override
    public ControlBarrier getCopy() {
        return new NamedBarrier(this);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.resourceId = resourceId.accept(exprTransformer);
        if (this.quorum != null) {
            this.quorum = quorum.accept(exprTransformer);
        }
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final List<Expression> exprs = quorum != null ? List.of(resourceId, quorum) : List.of(resourceId);
        return Register.collectRegisterReads(exprs, Register.UsageType.OTHER, new HashSet<>());
    }
}
