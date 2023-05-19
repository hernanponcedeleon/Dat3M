package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SyncBar extends Definition {
    private final String barBefore;
    private final String barAfter;

    public SyncBar(Relation r) {
        super(r);
        this.barBefore = null;
        this.barAfter = null;
    }

    public SyncBar(Relation r, String barBefore, String barAfter) {
        super(r);
        this.barBefore = barBefore;
        this.barAfter = barAfter;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSyncBarrier(definedRelation, this.barBefore, this.barAfter);
    }

}
