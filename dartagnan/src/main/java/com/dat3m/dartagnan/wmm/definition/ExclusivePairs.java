package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class ExclusivePairs extends Definition {

    public ExclusivePairs(Relation r0) {
        super(r0, RelationNameRepository.LXSX);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitExclusivePairs(this);
    }
}
