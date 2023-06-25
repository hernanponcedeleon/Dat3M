package com.dat3m.dartagnan.program.event.arch.tso;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.TSO;

public class TSOXchg extends RMWXchgBase {

    public TSOXchg(Expression address, Register register) {
        super(register, address, register, "");
        addTags(TSO.ATOM);
    }

    private TSOXchg(TSOXchg other){
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("xchg(*%s, %s)", address, resultRegister);
    }

    @Override
    public TSOXchg getCopy(){
        return new TSOXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitXchg(this);
    }
}