package com.dat3m.dartagnan.wmm.relation.base.local;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.IDD;

public class RelIdd extends BasicRegRelation {

    public RelIdd(){
        term = IDD;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInternalDataDependency(this);
    }
}
