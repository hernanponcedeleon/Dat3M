package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.lang.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWFetchOp extends RMWAbstract {

    private final IOpBin op;

    public RMWFetchOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private RMWFetchOp(RMWFetchOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String defaultString() {
        return resultRegister + " := atomic_fetch_" + op.toLinuxName() + Tag.Linux.toText(mo) + "(" + value + ", " + address + ")\t### LKMM";
    }

    public IOpBin getOp() {
    	return op;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWFetchOp getCopy(){
        return new RMWFetchOp(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWFetchOp(this);
	}
}