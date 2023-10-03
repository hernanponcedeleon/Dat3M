package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class PTXAtomExch extends RMWXchgBase {

    public PTXAtomExch(Register register, Expression address, Expression storeValue, String mo) {
        super(register, address, storeValue, mo);
    }

    protected PTXAtomExch(PTXAtomExch other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atom_exch_%s(%s, %s)", resultRegister, mo, address, storeValue);
    }

    @Override
    public PTXAtomExch getCopy(){
        return new PTXAtomExch(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPtxAtomExch(this);
    }

}
