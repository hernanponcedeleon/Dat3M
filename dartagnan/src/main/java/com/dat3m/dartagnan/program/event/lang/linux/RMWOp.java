package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.lang.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWOp extends RMWAbstract {

    private final IOpBin op;

    public RMWOp(Expression address, Register register, Expression value, IOpBin op) {
        super(address, register, value, Tag.Linux.MO_ONCE);
        this.op = op;
        addTags(Tag.Linux.NORETURN);
    }

    private RMWOp(RMWOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String defaultString() {
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