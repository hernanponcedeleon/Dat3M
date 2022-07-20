package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CRIT;

public class RelCrit extends StaticRelation {

    public RelCrit(){
        term = CRIT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitCriticalSections(this);
    }
}