package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.EXT;

public class External extends Definition {

    public External(Relation r0) {
        super(r0, EXT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitExternal(this);
    }
}
