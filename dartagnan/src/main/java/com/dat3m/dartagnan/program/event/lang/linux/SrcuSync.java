package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

// This event is a MemEvent because it needs to contribute to the loc relation
// (due to let srcu-rscs = ([Srcu-lock] ; pass-cookie ; [Srcu-unlock]) & loc).
public class SrcuSync extends SingleAccessMemoryEvent {

	public SrcuSync(Expression address) {
		super(address, Tag.Linux.SRCU_SYNC);
	}

    @Override
    public String toString() {
        return "synchronize_srcu(" + address + ")\t### LKMM";
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.OTHER);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitSruSync(this);
    }
}
