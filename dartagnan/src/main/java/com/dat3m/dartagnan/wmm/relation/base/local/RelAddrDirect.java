package com.dat3m.dartagnan.wmm.relation.base.local;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ADDRDIRECT;

public class RelAddrDirect extends BasicRegRelation {

    public RelAddrDirect(){
        term = ADDRDIRECT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitAddressDependency(this);
    }
}
