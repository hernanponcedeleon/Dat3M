package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class AtomicAbstract extends SingleAccessMemoryEvent implements RegWriter {

    protected final Register resultRegister;
    protected Expression value;

    AtomicAbstract(Expression address, Register register, Expression value, String mo) {
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "Atomic events cannot have empty memory order");
        this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
    }

    AtomicAbstract(AtomicAbstract other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    public Expression getMemValue() {
    	return value;
    }

    public void setMemValue(Expression value){
        this.value = value;
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAtomicAbstract(this);
    }
}