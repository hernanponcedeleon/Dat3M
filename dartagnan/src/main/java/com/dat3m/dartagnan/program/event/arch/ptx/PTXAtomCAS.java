package com.dat3m.dartagnan.program.event.arch.ptx;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

public class PTXAtomCAS extends RMWCmpXchgBase {

    public PTXAtomCAS(Register register, Expression address, Expression expectedValue, Expression storeValue, String mo) {
        super(register, address, expectedValue, storeValue, true, mo);
    }

    protected PTXAtomCAS(PTXAtomCAS other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atom_cas_%s(%s, %s, %s)", resultRegister, mo, address, expectedValue, storeValue);
    }

    @Override
    public PTXAtomCAS getCopy(){
        return new PTXAtomCAS(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitPtxAtomCAS(this);
    }

}
