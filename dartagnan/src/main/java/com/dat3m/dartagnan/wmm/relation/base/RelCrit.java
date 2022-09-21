package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RelCrit extends Definition {

    public RelCrit(Relation r0) {
        super(r0);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitCriticalSections(definedRelation);
    }
}