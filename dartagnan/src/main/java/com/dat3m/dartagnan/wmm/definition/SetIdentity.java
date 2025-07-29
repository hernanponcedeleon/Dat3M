package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

public class SetIdentity extends Definition {

    private final Relation domain;

    public SetIdentity(Relation r0, Relation r1) {
        super(Relation.checkIsRelation(r0), "[%s]");
        domain = Relation.checkIsSet(r1);
    }

    public Relation getDomain() { return domain; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, domain);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSetIdentity(this);
    }
}
