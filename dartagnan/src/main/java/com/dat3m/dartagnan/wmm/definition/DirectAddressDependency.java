package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class DirectAddressDependency extends Definition {

    public DirectAddressDependency(Relation r0) {
        super(Relation.checkIsRelation(r0), RelationNameRepository.ADDRDIRECT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitAddressDependency(this);
    }

}
