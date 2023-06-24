package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class RMWXchg extends RMWXchgBase {

    public RMWXchg(Expression address, Register register, Expression value, String mo) {
        super(register, address, value, mo);
    }

    private RMWXchg(RMWXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_xchg%s(%s, %s)\t### LKMM",
                resultRegister, Tag.Linux.toText(mo), address, storeValue);
    }

    @Override
    public RMWXchg getCopy() {
        return new RMWXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWXchg(this);
    }
}