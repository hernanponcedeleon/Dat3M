package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class ControlBarrier extends GenericVisibleEvent {

    // Identifier of a control barrier instance. Only barriers with the
    // same instanceId can synchronize with each other.
    // For kernel/shader code, barrier events will have the same instanceId
    // iff they are generated from the same dynamic (unrolled) instance of
    // a barrier instruction. In litmus tests, barrier instanceId should be
    // specified explicitly.
    private String instanceId;

    public ControlBarrier(String name, String instanceId) {
        super(name, Tag.FENCE);
        this.instanceId = instanceId;
    }

    protected ControlBarrier(ControlBarrier other) {
        super(other);
        this.instanceId = other.instanceId;
    }

    public void setInstanceId(String instanceId) {
        this.instanceId = instanceId;
    }

    public String getInstanceId() {
        return instanceId;
    }

    @Override
    public String defaultString() {
        return String.format("%s := barrier(%s)", name, instanceId);
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

    @Override
    public boolean cfImpliesExec() {
        return false;
    }
}
