package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

public class CartesianProduct extends Definition {

    private final Relation domain;
    private final Relation range;

    public CartesianProduct(Relation r0, Relation r1, Relation r2) {
        super(Relation.checkIsRelation(r0), "%s*%s");
        domain = Relation.checkIsSet(r1);
        range = Relation.checkIsSet(r2);
    }

    public Relation getDomain() { return domain; }

    public Relation getRange() { return range; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, domain, range);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProduct(this);
    }
}
