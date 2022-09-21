package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RelUnion extends Definition {

    private final Relation r1;
    private final Relation r2;

    public RelUnion(Relation r0, Relation r1, Relation r2) {
        super(r0, r1.getName() + " | " + r2.getName());
        this.r1 = r1;
        this.r2 = r2;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitUnion(definedRelation, r1, r2);
    }
}