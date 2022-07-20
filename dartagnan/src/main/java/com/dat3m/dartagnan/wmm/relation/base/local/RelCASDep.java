package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CASDEP;;

public class RelCASDep extends StaticRelation {

    public RelCASDep(){
        term = CASDEP;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitCompareAndSwapDependency(this);
    }
}