package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;

public class BPF_AcquireLoad extends LoadBase {

    public BPF_AcquireLoad(Register register, Expression address) {
        super(register, address, Tag.BPF.ACQ);
    }

    protected BPF_AcquireLoad(BPF_AcquireLoad other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := acquire_load(%s)", resultRegister, address);
    }

    @Override
    public BPF_AcquireLoad getCopy(){
        return new BPF_AcquireLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_AcquireLoad(this);
    }
}
