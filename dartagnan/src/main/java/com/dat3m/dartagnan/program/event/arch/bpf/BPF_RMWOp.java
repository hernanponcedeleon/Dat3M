package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWOpBase;

public class BPF_RMWOp extends RMWOpBase {

    public BPF_RMWOp(Expression address, IntBinaryOp operator, Expression operand) {
        super(address, operator, operand, "");
    }

    protected BPF_RMWOp(BPF_RMWOp other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("lock (%s) %s= %s", address, operator, operand);
    }

    @Override
    public BPF_RMWOp getCopy(){
        return new BPF_RMWOp(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_RMWOp(this);
    }
}
