package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.FenceBase;
import com.google.common.base.Preconditions;

public class LlvmFence extends FenceBase {

    public LlvmFence(String mo) {
        super("llvm_fence", mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
    }

    private LlvmFence(LlvmFence other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return name + "(" + mo + ")\t### LLVM";
    }

    @Override
    public LlvmFence getCopy() {
        return new LlvmFence(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmFence(this);
    }
}