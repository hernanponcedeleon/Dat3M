package com.dat3m.dartagnan.program.event.arch.bpf;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;

public class BPF_ReleaseStore extends StoreBase {

    public BPF_ReleaseStore(Expression address, Expression value) {
        super(address, value, Tag.BPF.REL);
    }

    protected BPF_ReleaseStore(BPF_ReleaseStore other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("store_release(%s, %s)", address, value);
    }

    @Override
    public BPF_ReleaseStore getCopy(){
        return new BPF_ReleaseStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitBPF_ReleaseStore(this);
    }
}
