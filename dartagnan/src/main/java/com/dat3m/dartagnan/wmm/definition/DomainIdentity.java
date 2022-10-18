package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.google.common.base.Preconditions.checkNotNull;

public class DomainIdentity extends Definition {

    private final Relation r1;

    public DomainIdentity(Relation r0, Relation r1) {
        super(r0, "[domain(%s)]");
        this.r1 = checkNotNull(r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitDomainIdentity(definedRelation, r1);
    }

}
