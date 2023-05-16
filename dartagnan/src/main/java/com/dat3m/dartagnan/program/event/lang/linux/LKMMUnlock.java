package com.dat3m.dartagnan.program.event.lang.linux;

import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_RELEASE;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public class LKMMUnlock extends Store {

	public LKMMUnlock(Expression lock) {
		super(lock, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getPointerType()), MO_RELEASE);
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
