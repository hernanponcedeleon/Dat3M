package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class Difference extends Definition {

    private final Relation minuend;
    private final Relation subtrahend;

    public Difference(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s \\ %s");
        minuend = checkNotNull(r1);
        subtrahend = checkNotNull(r2);
    }

    public Relation getMinuend() { return minuend; }
    public Relation getSubtrahend() { return subtrahend; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, minuend, subtrahend);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitDifference(this);
    }
}
