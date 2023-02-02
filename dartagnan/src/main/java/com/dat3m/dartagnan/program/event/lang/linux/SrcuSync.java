package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class SrcuSync extends MemEvent {

	public SrcuSync(IExpr address) {
		super(address, Tag.Linux.SRCU_SYNC);
	}

	@Override
    public String toString() {
        return "synchronize_srcu(" + address + ")\t### LKMM";
    }

    // TODO remove this hack
	@Override
	public ExprInterface getMemValue(){
		return IValue.ZERO;
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitSruSync(this);
	}
}
