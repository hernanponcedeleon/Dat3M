package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWOpResultBase;

public class BPF_RMWOpReturn extends RMWOpResultBase {

    public BPF_RMWOpReturn(Register register, Expression address, IntBinaryOp operator, Expression operand) {
        super(register, address, operator, operand, Tag.BPF.SC);
    }

    protected BPF_RMWOpReturn(BPF_RMWOpReturn other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_fetch_%s(%s, %s)", resultRegister, operator.getName().toLowerCase(), address, operand);
    }

    @Override
    public BPF_RMWOpReturn getCopy(){
        return new BPF_RMWOpReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_RMWOpReturn(this);
    }
}
