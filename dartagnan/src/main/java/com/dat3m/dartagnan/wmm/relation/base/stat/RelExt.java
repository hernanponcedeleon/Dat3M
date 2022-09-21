package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.EXT;

public class RelExt extends Definition {

    public RelExt(Relation r0) {
        super(r0, EXT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitExternal(definedRelation);
    }
}
