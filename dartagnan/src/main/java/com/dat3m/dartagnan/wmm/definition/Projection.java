package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

public class Projection extends Definition {

    private final Relation r1;

    private final Dimension dimension;

    public enum Dimension { DOMAIN, RANGE }

    public Projection(Relation r0, Relation r1, Dimension dimension) {
        super(Relation.checkIsSet(r0), switch (dimension) { case DOMAIN -> "domain(%s)"; case RANGE -> "range(%s)"; });
        this.r1 = Relation.checkIsRelation(r1);
        this.dimension = dimension;
    }

    public Relation getOperand() { return r1; }

    public Dimension getDimension() { return dimension; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitProjection(this);
    }
}