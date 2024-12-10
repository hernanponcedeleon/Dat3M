package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.ALLOCMEM;

public class AllocMem extends Definition {
    public AllocMem(Relation r) {
        super(r, ALLOCMEM);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitAllocMem(this);
    }
}
