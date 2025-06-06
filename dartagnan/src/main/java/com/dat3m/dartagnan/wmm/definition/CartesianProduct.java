package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

public class CartesianProduct extends Definition {

    private final Relation domain;
    private final Relation range;

    public CartesianProduct(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s*%s");
        domain = r1;
        range = r2;
        r0.checkBinaryRelation();
        r1.checkUnaryRelation();
        r2.checkUnaryRelation();
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
