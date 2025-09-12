package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;

public class LKMMStore extends StoreBase {

    public LKMMStore(Expression address, Expression value, String mo) {
        super(address, value, mo);
    }

    private LKMMStore(LKMMStore other) {
        super(other);
    }

    @Override
    public String defaultString() {
        if (mo.equals(Tag.Linux.MO_ONCE)) {
            return "STORE_ONCE(" + address + ", " + value + ")";
        }
        return super.defaultString();
    }

    @Override
    public LKMMStore getCopy() {
        return new LKMMStore(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMStore(this);
    }

}
