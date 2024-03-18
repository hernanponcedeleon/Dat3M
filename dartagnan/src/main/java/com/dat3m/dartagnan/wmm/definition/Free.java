package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

// A freely defined relation can take any value, i.e., there are no restrictions
// (except that it is guaranteed to be only over visible and executed events).
public class Free extends Definition {

    public Free(Relation r0) {
        super(r0, "__free()");
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFree(this);
    }
}
