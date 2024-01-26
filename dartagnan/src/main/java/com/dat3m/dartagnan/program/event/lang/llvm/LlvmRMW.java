package com.dat3m.dartagnan.program.event.lang.llvm;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;
import com.google.common.base.Preconditions;

public class LlvmRMW extends RMWOpResultBase {

    public LlvmRMW(Register register, Expression address, IntBinaryOp op, Expression operand, String mo) {
        super(register, address, op, operand, mo);
        Preconditions.checkArgument(!mo.isEmpty(), "LLVM events cannot have empty memory order");
    }

    private LlvmRMW(LlvmRMW other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := llvm_rmw_%s(*%s, %s, %s)\t### LLVM",
                resultRegister, operator.getName(), address, operand, mo);
    }

    @Override
    public LlvmRMW getCopy() {
        return new LlvmRMW(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLlvmRMW(this);
    }
}