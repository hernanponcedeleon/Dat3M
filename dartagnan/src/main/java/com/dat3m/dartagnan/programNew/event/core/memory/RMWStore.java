package com.dat3m.dartagnan.programNew.event.core.memory;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;

/*
    A RMWStore pairs with a given Load operation to form a RMW operation.
    Unlike RMWStoreExclusive, RMWStore will always form a RMW pair, it will never fail, and it is always atomic.

    TODO: Do we really ever need this if we can always use LL/SC in compilation?
 */
// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class RMWStore extends Store {

    protected Load rmwLoad;

    protected RMWStore(Expression address, Expression value, Load rmwLoad) {
        super(address, value);
        Preconditions.checkArgument(rmwLoad.hasTag(Tag.RMW));
        this.rmwLoad = rmwLoad;
    }
}
