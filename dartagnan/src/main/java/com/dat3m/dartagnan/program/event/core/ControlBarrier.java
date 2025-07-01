package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class ControlBarrier extends GenericVisibleEvent implements BlockingEvent {

    // Identifier of a control barrier instance. Only barriers with the
    // same instanceId can synchronize with each other.
    // For kernel/shader code, barrier events will have the same instanceId
    // iff they are generated from the same dynamic (unrolled) instance of
    // a barrier instruction. In litmus tests, barrier instanceId should be
    // specified explicitly.
    private String instanceId;
    private final String execScope;

    public ControlBarrier(String name, String instanceId, String execScope) {
        super(name, Tag.FENCE);
        this.instanceId = instanceId;
        this.execScope = execScope;
    }

    protected ControlBarrier(ControlBarrier other) {
        super(other);
        this.instanceId = other.instanceId;
        this.execScope = other.execScope;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public String getExecScope() {
        return execScope;
    }

    @Override
    public String defaultString() {
        return String.format("%s := barrier(%s, %s)", name, instanceId, execScope);
    }

    @Override
    public ControlBarrier getCopy() {
        return new ControlBarrier(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitControlBarrier(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        return ctx.getBooleanFormulaManager().implication(ctx.execution(this), ctx.controlFlow(this));
    }
}
