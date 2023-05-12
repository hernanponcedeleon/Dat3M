package com.dat3m.dartagnan.wmm.definition.Scopes;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SameSpecificScope extends Definition {
    private String specificScope;
    public SameSpecificScope(Relation r, String specificScope) {
        super(r);
        this.specificScope = specificScope;

    }
    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameSpecificScope(definedRelation, this.specificScope);
    }
}
