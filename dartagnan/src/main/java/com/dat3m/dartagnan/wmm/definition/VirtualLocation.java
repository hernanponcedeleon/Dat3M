package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class VirtualLocation extends Definition {

    public VirtualLocation(Relation r0) {
        super(r0);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitVirtualLocation(definedRelation);
    }

}
