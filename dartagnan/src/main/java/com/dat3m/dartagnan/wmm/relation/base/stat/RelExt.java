package com.dat3m.dartagnan.wmm.relation.base.stat;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.EXT;

public class RelExt extends StaticRelation {

    public RelExt(){
        term = EXT;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitExternal(this);
    }
}
