package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.StoreBase;

import static com.dat3m.dartagnan.program.event.Tag.Linux.MO_RELEASE;

public class LKMMUnlock extends StoreBase {

    public LKMMUnlock(Expression lock) {
        super(lock, ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getIntegerType(32)), MO_RELEASE);
        addTags(Tag.Linux.UNLOCK);
    }

    protected LKMMUnlock(LKMMUnlock other) {
        super(other);
    }

    @Override
    public String defaultString() {
        return String.format("spin_unlock(%s)", address);
    }

    @Override
    public LKMMUnlock getCopy() {
        return new LKMMUnlock(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMUnlock(this);
    }
}
