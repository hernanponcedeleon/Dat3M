package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.INT;

public class Internal extends Definition {

    public Internal(Relation r0) {
        super(r0, INT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInternal(this);
    }
}
