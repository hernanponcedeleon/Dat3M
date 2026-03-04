package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWCmpXchgBase;

public class CAS extends RMWCmpXchgBase {

    public CAS(Register register, Expression address, Expression cmpVal, Expression value) {
        super(register, address, cmpVal, value, true, "");
    }

    private CAS(CAS other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s = cas(%s, %s, %s)", resultRegister, address, expectedValue, storeValue);
    }

    @Override
    public CAS getCopy(){
        return new CAS(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitCas(this);
    }
}