package com.dat3m.dartagnan.wmm.relation.base.stat;

import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;

public class RelEmpty extends StaticRelation {

    public RelEmpty() {
        term = RelationNameRepository.EMPTY;
    }

    public RelEmpty(String name) {
        super(name);
        term = name;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitEmpty(this);
    }
}
