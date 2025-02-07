package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SameTransaction extends Definition {

    public SameTransaction(Relation relation) {
        super(relation);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitSameTransaction(this);
    }
}
