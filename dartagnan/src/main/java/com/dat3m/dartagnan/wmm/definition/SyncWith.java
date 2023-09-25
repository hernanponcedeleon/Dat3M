package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

/**
 * SyncWith relation specifies that two events come from two threads
 * that are system-synchronizes-with each other.
 */
public class SyncWith extends Definition {

    public SyncWith(Relation r) {
        super(r);
    }
    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSyncWith(definedRelation);
    }

}
