package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class DirectPickDependency extends Definition {

    public DirectPickDependency(Relation definedRelation) {
        super(definedRelation, RelationNameRepository.PICKDIRECT);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitPickDependency(this);
    }
}
