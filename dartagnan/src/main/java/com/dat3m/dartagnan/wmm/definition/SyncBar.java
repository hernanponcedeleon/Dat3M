package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class SyncBar extends Definition {

    public SyncBar(Relation r) {
        super(r, RelationNameRepository.SYNCBAR);
    }
    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSyncBarrier(this);
    }

}
