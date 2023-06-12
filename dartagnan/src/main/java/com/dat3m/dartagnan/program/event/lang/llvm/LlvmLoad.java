package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAddressMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.READ;

public class LlvmLoad extends SingleAddressMemoryEvent implements RegWriter {

    private final Register resultRegister;

    public LlvmLoad(Register register, IExpr address, String mo) {
        super(address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_RELEASE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getName() + " cannot have memory order: " + mo);
        this.resultRegister = register;
        addTags(READ);
    }

    private LlvmLoad(LlvmLoad other) {
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public String toString() {
        return resultRegister + " = llvm_load(*" + address + ", " + mo + ")\t### LLVM";
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.LOAD);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public LlvmLoad getCopy() {
        return new LlvmLoad(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmLoad(this);
    }
}