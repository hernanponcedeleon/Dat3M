package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class AMOPairs extends Definition {

    public AMOPairs(Relation r0) {
        super(r0, RelationNameRepository.AMO);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAMOPairs(this);
    }
}
