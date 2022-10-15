package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.google.common.base.Preconditions.checkNotNull;

public class TransitiveClosure extends Definition {

    private final Relation r1;

    public TransitiveClosure(Relation r0, Relation r1) {
        super(r0, "%s^+");
        this.r1 = checkNotNull(r1);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitTransitiveClosure(definedRelation, r1);
    }

    @Override
    public TransitiveClosure substitute(Relation p, Relation r) {
        boolean match = definedRelation.equals(p);
        Relation r0 = match ? r : definedRelation;
        return match || r1.equals(p) ? new TransitiveClosure(r0, r1.equals(p) ? r : r1) : this;
    }
}