package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

public class SetIdentity extends Definition {

    private final Relation domain;

    public SetIdentity(Relation r0, Relation r1) {
        super(r0, "[%s]");
        domain = r1;
        r0.checkRelation();
        r1.checkSet();
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
