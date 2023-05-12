package com.dat3m.dartagnan.wmm.definition.Scopes;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SameScope extends Definition {
    public SameScope(Relation r) {
        super(r);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameScope(definedRelation);
    }

}
