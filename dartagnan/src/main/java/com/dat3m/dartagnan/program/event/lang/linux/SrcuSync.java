package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractMemoryEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class SrcuSync extends AbstractMemoryEvent {

	public SrcuSync(ExprInterface address) {
		super(address, Tag.Linux.SRCU_SYNC);
	}

	@Override
    public String toString() {
        return "synchronize_srcu(" + address + ")\t### LKMM";
    }

    // This event is a MemEvent because it needs to contribute to the loc relation
	// (due to let srcu-rscs = ([Srcu-lock] ; pass-cookie ; [Srcu-unlock]) & loc).
	// However it cannot contribute to the data flow over memory, thus the memValue
	// we assign is irrelevant. However we still need to provide an implementation
	// to be abel to run several analysis / passes. The value below should not affect
	// the alias analysis and the result of passes like constant propagation is 
	// irrelevant because this event does not contribute to any data flow.
	@Override
	public ExprInterface getMemValue(){
		return ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType());
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitSruSync(this);
	}
}
