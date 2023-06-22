package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SyncFence extends Definition {

    public SyncFence(Relation r) {
        super(r);
    }
    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSyncFence(definedRelation);
    }

}
