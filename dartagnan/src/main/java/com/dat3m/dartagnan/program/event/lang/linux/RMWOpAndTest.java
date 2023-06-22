package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.lang.RMWAbstract;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWOpAndTest extends RMWAbstract {

    private final IOpBin op;

    public RMWOpAndTest(Expression address, Register register, Expression value, IOpBin op) {
        super(address, register, value, Tag.Linux.MO_MB);
        this.op = op;
    }

    private RMWOpAndTest(RMWOpAndTest other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String defaultString() {
        return resultRegister + " := atomic_" + op.toLinuxName() + "_and_test(" + value + ", " + address + ")\t### LKMM";
    }

    public IOpBin getOp() {
    	return op;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWOpAndTest getCopy(){
        return new RMWOpAndTest(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWOpAndTest(this);
	}
}