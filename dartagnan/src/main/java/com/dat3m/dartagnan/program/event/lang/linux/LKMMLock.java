package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMLock extends MemEvent {

	public LKMMLock(IExpr lock) {
		// This event will be compiled to LKMMLockRead + LKMMLockWrite 
		// and each of those will be assigned a proper memory ordering
		super(lock, null);
	}

    protected LKMMLock(LKMMLock other){
        super(other);
    }

	public IExpr getLock() {
		return address;
	}
	
	@Override
	public String toString() {
		return String.format("spin_lock(*%s)", address);
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LKMMLock getCopy(){
        return new LKMMLock(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMLock(this);
	}
}
