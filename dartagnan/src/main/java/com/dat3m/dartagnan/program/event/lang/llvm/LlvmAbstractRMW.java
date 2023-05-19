package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class LlvmAbstractRMW extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected ExprInterface value;

    LlvmAbstractRMW(IExpr address, Register register, IExpr value, String mo) {
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
    }

    LlvmAbstractRMW(LlvmAbstractRMW other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs() {
        return value.getRegs();
    }

    @Override
    public ExprInterface getMemValue() {
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
		return visitor.visitLlvmAbstract(this);
	}
}