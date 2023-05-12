package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;

public class LKMMLoad extends Load {

	public LKMMLoad(Register register, Expression address, String mo) {
		super(register, address, mo);
	}

	@Override
    public String toString() {
		if(mo.equals(Tag.Linux.MO_ONCE)) {
			return resultRegister + " := READ_ONCE(" + address + ")\t### LKMM";
		}
        return super.toString();
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMLoad(this);
	}
}
