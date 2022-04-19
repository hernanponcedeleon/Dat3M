package com.dat3m.dartagnan.program.event.arch.lisa;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import static com.dat3m.dartagnan.program.event.Tag.*;

import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

import com.dat3m.dartagnan.expression.IExpr;

public class RMW extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final IExpr value;
    

    public RMW(IExpr address, Register register, IExpr value, String mo) {
        super(address, mo);
		this.resultRegister = register;
        this.value = value;
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, RMW, REG_WRITER, REG_READER);
    }

    private RMW(RMW other){
        super(other);
		this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public String toString() {
        return resultRegister + " := rmw[" + mo + "](" + value + ", " + address + ")";
    }

    public ExprInterface getMemValue(){
        return value;
    }

	@Override
	public ImmutableSet<Register> getDataRegs() {
		return value.getRegs();
	}

	@Override
	public Register getResultRegister() {
		return resultRegister;
	}

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMW getCopy(){
        return new RMW(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMW(this);
	}
}