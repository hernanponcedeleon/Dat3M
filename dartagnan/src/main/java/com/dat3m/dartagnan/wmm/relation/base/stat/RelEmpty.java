package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;

public class RelEmpty extends Definition {

    public RelEmpty(Relation r0) {
        super(r0, RelationNameRepository.EMPTY);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitEmpty(definedRelation);
    }
}
