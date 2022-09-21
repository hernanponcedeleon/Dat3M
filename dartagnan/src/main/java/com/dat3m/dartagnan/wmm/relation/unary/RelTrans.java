package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class RelTrans extends Definition {

    private final Relation r1;

    public RelTrans(Relation r0, Relation r1) {
        super(r0, r1.getName() + "^+");
        this.r1 = r1;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitTransitiveClosure(definedRelation, r1);
    }
}