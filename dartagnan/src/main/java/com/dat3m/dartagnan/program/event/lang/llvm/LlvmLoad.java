package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.google.common.base.Preconditions;

import static com.dat3m.dartagnan.program.event.Tag.C11.MO_ACQUIRE_RELEASE;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_RELEASE;

public class LlvmLoad extends LoadBase {


    public LlvmLoad(Register register, Expression address, String mo) {
        super(register, address, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
        Preconditions.checkArgument(!mo.equals(MO_RELEASE) && !mo.equals(MO_ACQUIRE_RELEASE),
                getClass().getName() + " cannot have memory order: " + mo);
    }

    private LlvmLoad(LlvmLoad other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return resultRegister + " = llvm_load(*" + address + ", " + mo + ")\t### LLVM";
    }

    @Override
    public LlvmLoad getCopy() {
        return new LlvmLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmLoad(this);
    }
}