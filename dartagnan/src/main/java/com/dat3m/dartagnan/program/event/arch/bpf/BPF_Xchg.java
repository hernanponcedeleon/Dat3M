package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

public class BPF_Xchg extends RMWXchgBase {

    public BPF_Xchg(Register resultRegister, Expression address, Expression storeValue) {
        super(resultRegister, address, storeValue, "");
    }

    private BPF_Xchg(BPF_Xchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s = xchg(*%s, %s)", resultRegister, address, storeValue);
    }

    @Override
    public BPF_Xchg getCopy(){
        return new BPF_Xchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_Xchg(this);
    }
}