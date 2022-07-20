package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.wmm.relation.Relation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.LOC;

public class RelLoc extends Relation {

    public RelLoc(){
        term = LOC;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameAddress(this);
    }
}
