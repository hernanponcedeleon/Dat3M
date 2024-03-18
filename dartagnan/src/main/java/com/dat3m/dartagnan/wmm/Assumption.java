package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.utils.EventGraph.difference;
import static com.google.common.base.Preconditions.checkNotNull;

public final class Assumption implements Constraint {

    private static final Logger logger = LogManager.getLogger(Assumption.class);

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
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(Map<Relation, RelationAnalysis.Knowledge> knowledgeMap, Context analysisContext) {
        RelationAnalysis.Knowledge k = knowledgeMap.get(rel);
        EventGraph d = difference(k.getMaySet(), may);
        EventGraph e = difference(must, k.getMustSet());
        if (d.size() + e.size() != 0) {
            logger.info("Assumption disables {} and enables {} at {}", d.size(), e.size(), rel.getNameOrTerm());
        }
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(d, e));
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitAssumption(this);
    }
}
