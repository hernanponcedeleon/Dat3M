package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class Arbitration extends Definition {

    public Arbitration(Relation r) {
        super(r);
    }

    @Override
    public <T> T accept(Constraint.Visitor<? extends T> v) {
        return v.visitArbitration(this);
    }
}
