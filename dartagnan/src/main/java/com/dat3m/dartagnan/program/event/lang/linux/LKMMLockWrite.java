package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;

import static com.dat3m.dartagnan.program.event.Tag.Linux;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

public class LKMMLockWrite extends RMWStore {

    public LKMMLockWrite(Load lockRead, Expression lock) {
        super(lockRead, lock, ExpressionFactory.getInstance().makeOne(TypeFactory.getInstance().getArchType()));
        addTags(RMW, Linux.LOCK_WRITE, Linux.MO_ONCE);
    }

    @Override
    public String defaultString() {
        return String.format("spin_lock_W(*%s)", address);
    }
}
