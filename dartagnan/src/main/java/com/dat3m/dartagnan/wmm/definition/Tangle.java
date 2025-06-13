package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;

public class Tangle extends Definition {

    public Tangle(Relation r0) {
        super(r0, RelationNameRepository.TANGLE);
    }

    @Override
    public <T> T accept(Constraint.Visitor<? extends T> v) {
        return v.visitTangle(this);
    }

}
