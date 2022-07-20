package com.dat3m.dartagnan.program.event.lang.linux;

import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_RELEASE;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMUnlock extends Store {

	public LKMMUnlock(IExpr lock) {
		super(lock, IValue.ZERO, MO_RELEASE);
		addFilters(Tag.Linux.UNLOCK);
	}

    protected LKMMUnlock(LKMMUnlock other){
        super(other);
    }

	@Override
	public String toString() {
		return String.format("spin_unlock(*%s)", address);
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LKMMUnlock getCopy(){
        return new LKMMUnlock(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMUnlock(this);
	}
}
