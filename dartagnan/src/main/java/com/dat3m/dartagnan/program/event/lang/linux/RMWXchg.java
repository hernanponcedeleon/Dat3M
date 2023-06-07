package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWXchg extends RMWAbstract {

    public RMWXchg(Expression address, Register register, Expression value, String mo) {
        super(address, register, value, mo);
    }

    private RMWXchg(RMWXchg other){
        super(other);
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_xchg" + Tag.Linux.toText(mo) + "(" + address + ", " + value + ")\t### LKMM";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWXchg getCopy(){
        return new RMWXchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWXchg(this);
	}
}