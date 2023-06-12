package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

@NoInterface
public abstract class LoadBase extends SingleAddressMemoryEvent implements RegWriter {

    protected final Register resultRegister;

    public LoadBase(Register register, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = register;
        addTags(Tag.READ);
    }

    protected LoadBase(LoadBase other) {
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public String toString() {
        final MemoryOrder mo = getMetadata(MemoryOrder.class);
        return String.format("%s = load(*%s%s)", resultRegister, address, mo != null ? ", " + mo.value() : "");
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.LOAD);
    }
}

