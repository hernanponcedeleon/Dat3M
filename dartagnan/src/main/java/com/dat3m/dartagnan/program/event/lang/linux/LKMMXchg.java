package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.RMWXchgBase;

public class LKMMXchg extends RMWXchgBase {

    public LKMMXchg(Register register, Expression address, Expression value, String mo) {
        super(register, address, value, mo);
    }

    private LKMMXchg(LKMMXchg other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_xchg%s(%s, %s)\t### LKMM",
                resultRegister, Tag.Linux.toText(mo), address, storeValue);
    }

    @Override
    public LKMMXchg getCopy() {
        return new LKMMXchg(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMXchg(this);
    }
}