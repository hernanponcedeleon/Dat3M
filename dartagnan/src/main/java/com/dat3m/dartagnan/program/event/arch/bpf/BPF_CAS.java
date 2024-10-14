package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

public class BPF_CAS extends RMWCmpXchgBase {

    public BPF_CAS(Register register, Expression address, Expression expectedValue, Expression storeValue) {
        super(register, address, expectedValue, storeValue, true, "");
    }

    protected BPF_CAS(BPF_CAS other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := cmpxchg(%s, %s, %s)", resultRegister, address, expectedValue, storeValue);
    }

    @Override
    public BPF_CAS getCopy(){
        return new BPF_CAS(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_CAS(this);
    }

}
