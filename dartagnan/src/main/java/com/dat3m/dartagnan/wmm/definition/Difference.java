package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.google.common.base.Preconditions.checkNotNull;

public class Difference extends Definition {

    public final Relation superset;
    public final Relation complement;

    public Difference(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s \\ %s");
        superset = checkNotNull(r1);
        complement = checkNotNull(r2);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitDifference(definedRelation, superset, complement);
    }
}
