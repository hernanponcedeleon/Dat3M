package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class ControlBarrier extends GenericVisibleEvent {
    private String id;

    public ControlBarrier(String id, String name) {
        super(name, Tag.FENCE);
        this.id = id;
    }

    private ControlBarrier(ControlBarrier other) {
        super(other);
        this.id = other.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    @Override
    public String defaultString() {
        return String.format("%s := barrier_id[%s]", name, id);
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
