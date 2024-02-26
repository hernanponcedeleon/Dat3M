package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class Free extends Definition {

    public Free(Relation r0) {
        super(r0, "__free()");
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitFree(this);
    }
}
