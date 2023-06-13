package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMLoad extends Load {

	private String mo;
	public String getMo() { return mo; }

	public LKMMLoad(Register register, Expression address, String mo) {
		super(register, address);
		this.mo = mo;
		tags.add(mo);
	}

	@Override
	public String defaultString() {
		if(mo.equals(Tag.Linux.MO_ONCE)) {
			return resultRegister + " := READ_ONCE(" + address + ")\t### LKMM";
		}
        return super.defaultString();
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMLoad(this);
	}
}
