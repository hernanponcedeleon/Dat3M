package com.dat3m.dartagnan.program.event.arch;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

public class Xchg extends RMWXchgBase {

    public Xchg(Register register, Expression address, Expression value) {
        super(register, address, value, "");
    }

    private Xchg(Xchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s <- xchg(*%s, %s)", resultRegister, address, storeValue);
    }

    @Override
    public Xchg getCopy(){
        return new Xchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitXchg(this);
    }
}