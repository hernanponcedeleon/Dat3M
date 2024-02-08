package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SameLocation extends Definition {

    public SameLocation(Relation r0) {
        super(r0);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameLocation(this);
    }

}
