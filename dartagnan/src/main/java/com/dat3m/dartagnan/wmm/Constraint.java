package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.Collection;

public interface Constraint {

    Collection<? extends Relation> getConstrainedRelations();
}
