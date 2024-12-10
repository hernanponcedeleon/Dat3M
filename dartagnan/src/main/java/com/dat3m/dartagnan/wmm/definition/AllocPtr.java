package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.ALLOCPTR;

public class AllocPtr extends Definition {

    public AllocPtr(Relation r) {
        super(r, ALLOCPTR);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitAllocPtr(this);
    }
}
