package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;

public class LKMMLoad extends LoadBase {

    public LKMMLoad(Register register, Expression address, String mo) {
        super(register, address, mo);
    }

    private LKMMLoad(LKMMLoad other) {
        super(other);
    }

    @Override
    public String defaultString() {
        if (mo.equals(Tag.Linux.MO_ONCE)) {
            return resultRegister + " = READ_ONCE(" + address + ")";
        }
        return super.defaultString();
    }

    @Override
    public LKMMLoad getCopy() {
        return new LKMMLoad(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMLoad(this);
    }
}
