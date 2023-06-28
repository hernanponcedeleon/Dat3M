package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.LoadBase;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Join extends LoadBase {

    public Join(Register reg, Expression expr) {
        // We will set the correct (C11 or LKMM) acquire tag (or barriers) when the event is compiled
        super(reg, expr, "");
        addTags(Tag.C11.PTHREAD);
    }

    public Join(Join other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return resultRegister + " <- pthread_join(" + getAddress() + ")";
    }

    @Override
    public Join getCopy() {
        return new Join(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitJoin(this);
    }
}