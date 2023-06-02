package com.dat3m.dartagnan.program.event.arch.lisa;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.RMW;
import static com.dat3m.dartagnan.program.event.Tag.*;

public class RMW extends MemEvent implements RegWriter {

    private final Register resultRegister;
    private final IExpr value;
    

    public RMW(IExpr address, Register register, IExpr value, String mo) {
        super(address, mo);
		this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
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
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
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