package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;

public class Coherence extends Definition {

    public Coherence(Relation r0) {
        super(r0, CO);
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitCoherence(this);
    }
}