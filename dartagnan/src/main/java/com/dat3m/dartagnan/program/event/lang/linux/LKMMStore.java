package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMStore extends Store {

	public LKMMStore(Expression address, Expression value, String mo) {
		super(address, value, mo);
	}

	@Override
    public String toString() {
		if(mo.equals(Tag.Linux.MO_ONCE)) {
			return "STORE_ONCE(" + address + ", " + value + ")\t### LKMM";
		}
        return super.toString();
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMStore(this);
	}
}
