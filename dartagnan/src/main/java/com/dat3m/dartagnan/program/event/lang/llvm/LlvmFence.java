package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

public class LlvmFence extends Fence {

    private final String mo;

    public LlvmFence(String mo) {
        super("llvm_fence");
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        this.mo = mo;
    }

    private LlvmFence(LlvmFence other) {
        super(other);
        this.mo = other.mo;
    }

    @Override
    public String defaultString() {
        return name + "(" + mo + ")\t### LLVM";
    }

    public String getMo() {
        return mo;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmFence getCopy() {
        return new LlvmFence(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmFence(this);
    }
}