package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CASDEP;

public class CASDependency extends Definition {

    public CASDependency(Relation r0) {
        super(r0, CASDEP);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitCASDependency(this);
    }
}