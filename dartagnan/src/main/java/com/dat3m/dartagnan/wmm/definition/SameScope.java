package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

public class SameScope extends Definition {
    private final String specificScope;

    public SameScope(Relation r) {
        this(r, null);
    }

    public SameScope(Relation r, String specificScope) {
        super(r);
        this.specificScope = specificScope;
    }

    public String getSpecificScope() { return specificScope; }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSameScope(this);
    }

}
