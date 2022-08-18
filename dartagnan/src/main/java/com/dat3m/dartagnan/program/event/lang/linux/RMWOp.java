package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWOp extends RMWAbstract {

    private final IOpBin op;

    public RMWOp(IExpr address, Register register, IExpr value, IOpBin op) {
        super(address, register, value, Tag.Linux.MO_ONCE);
        this.op = op;
        addFilters(Tag.Linux.NORETURN);
    }

    private RMWOp(RMWOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return "atomic_" + op.toLinuxName() + "(" + value + ", " + address + ")\t### LKMM";
    }

    public IOpBin getOp() {
    	return op;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOp getCopy(){
        return new RMWOp(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWOp(this);
	}
}