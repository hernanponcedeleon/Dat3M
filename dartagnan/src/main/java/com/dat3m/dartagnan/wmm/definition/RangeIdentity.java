package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

public class RangeIdentity extends Definition {

    private final Relation r1;

    public RangeIdentity(Relation r0, Relation r1) {
        super(r0, "[range(%s)]");
        this.r1 = checkNotNull(r1);
    }

    public Relation getOperand() { return r1; }

    @Override
    public List<Relation> getConstrainedRelations() {
        return List.of(definedRelation, r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitRangeIdentity(this);
    }
}