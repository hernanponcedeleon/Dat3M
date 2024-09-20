package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;

public final class Assumption implements Constraint {

    private final Relation rel;
    private final EventGraph may;
    private final EventGraph must;

    public Assumption(Relation relation, EventGraph maySet, EventGraph mustSet) {
        rel = checkNotNull(relation);
        may = checkNotNull(maySet);
        must = checkNotNull(mustSet);
    }

    public Relation getRelation() { return rel; }
    public EventGraph getMaySet() { return may; }
    public EventGraph getMustSet() { return must; }

    @Override
    public Set<Relation> getConstrainedRelations() {
        return Set.of(rel);
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAssumption(this);
    }
}
