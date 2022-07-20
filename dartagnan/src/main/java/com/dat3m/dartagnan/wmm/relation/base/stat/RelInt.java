package com.dat3m.dartagnan.wmm.relation.base.stat;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.INT;

public class RelInt extends StaticRelation {

    public RelInt(){
        term = INT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInternal(this);
    }
}
