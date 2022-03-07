package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class RMWAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected ExprInterface value;

    RMWAbstract(IExpr address, Register register, ExprInterface value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, RMW, REG_WRITER, REG_READER);
    }

    RMWAbstract(RMWAbstract other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return value.getRegs();
    }

    @Override
    public ExprInterface getMemValue(){
        return value;
    }

    @Override
    public void setMemValue(ExprInterface value){
        this.value = value;
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWAbstract(this);
	}
}