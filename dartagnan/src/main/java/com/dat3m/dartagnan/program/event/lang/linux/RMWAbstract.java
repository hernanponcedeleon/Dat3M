package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.AbstractMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class RMWAbstract extends AbstractMemoryEvent implements RegWriter {

    protected final Register resultRegister;
    protected Expression value;

    RMWAbstract(Expression address, Register register, Expression value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
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
    public Set<Register.Read> getRegisterReads(){
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public Expression getMemValue(){
        return value;
    }

    @Override
    public void setMemValue(Expression value){
        this.value = value;
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWAbstract(this);
	}
}