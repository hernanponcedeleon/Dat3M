package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.linux.utils.Mo;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWFetchOp extends RMWAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public RMWFetchOp(IExpr address, Register register, IExpr value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private RMWFetchOp(RMWFetchOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_fetch_" + op.toLinuxName() + Mo.toText(mo) + "(" + value + ", " + address + ")";
    }

    public IOpBin getOp() {
    	return op;
    }
    
    @Override
    public ExprInterface getMemValue(){
        return value;
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
		return visitor.visit(this);
	}
}