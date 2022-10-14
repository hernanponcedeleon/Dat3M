package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class Inverse extends Definition {
    //TODO/Note: We can forward getSMTVar calls
    // to avoid encoding this completely!

    private final Relation r1;

    public Inverse(Relation r0, Relation r1){
        super(r0, r1.getName() + "^-1");
        this.r1 = r1;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitInverse(definedRelation, r1);
    }
}