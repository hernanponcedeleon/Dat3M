package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.google.common.base.Preconditions.checkNotNull;

public class Composition extends Definition {

    private final Relation front;
    private final Relation back;

    public Composition(Relation r0, Relation r1, Relation r2) {
        super(r0, "%s ; %s");
        front = checkNotNull(r1);
        back = checkNotNull(r2);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitComposition(definedRelation, front, back);
    }

    @Override
    public Composition substitute(Relation p, Relation r) {
        boolean match = definedRelation.equals(p);
        Relation r0 = match ? r : definedRelation;
        return match || front.equals(p) || back.equals(p) ?
                new Composition(r0, front.equals(p) ? r : front, back.equals(p) ? r : back) :
                this;
    }
}