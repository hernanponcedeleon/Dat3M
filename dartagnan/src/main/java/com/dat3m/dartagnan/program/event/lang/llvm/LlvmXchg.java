package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;
import com.google.common.base.Preconditions;

public class LlvmXchg extends RMWXchgBase {

    public LlvmXchg(Register register, Expression address, Expression value, String mo) {
        super(register, address, value, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
    }

    private LlvmXchg(LlvmXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := llvm_xchg(*%s, %s, %s)\t### LLVM",
                resultRegister, address, storeValue, mo);
    }

    @Override
    public LlvmXchg getCopy() {
        return new LlvmXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmXchg(this);
    }
}