package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SyncWith extends Definition {

    public SyncWith(Relation r) {
        super(r);
    }
    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSyncWith(definedRelation);
    }

}
