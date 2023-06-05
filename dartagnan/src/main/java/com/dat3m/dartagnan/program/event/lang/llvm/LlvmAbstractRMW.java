package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.core.SingleAddressMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class LlvmAbstractRMW extends SingleAddressMemoryEvent implements RegWriter {

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
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public ExprInterface getMemValue() {
        return value;
    }

    @Override
    public void setMemValue(ExprInterface value) {
        this.value = value;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        // TODO: Once we can return multiple MemoryAccesses, we need to add the LOAD here as well.
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.STORE);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmAbstract(this);
    }
}