package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LlvmFence extends Fence {

    private final String mo;

    public LlvmFence(String mo) {
        super("llvm_fence");
        this.mo = mo;
    }

    private LlvmFence(LlvmFence other){
        super(other);
        this.mo = other.mo;
    }

    @Override
    public String toString() {
        return name + "(" + mo + ")\t### LLVM";
    }

    public String getMo() {
    	return mo;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmFence getCopy(){
        return new LlvmFence(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLlvmFence(this);
	}
}