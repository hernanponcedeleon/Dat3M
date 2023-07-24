package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Map;
import java.util.Set;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.collect.Sets.difference;

public final class Assumption implements Constraint {

    private static final Logger logger = LogManager.getLogger(Assumption.class);

    private final Relation rel;
    private final Set<Tuple> may;
    private final Set<Tuple> must;

    public Assumption(Relation relation, Set<Tuple> maySet, Set<Tuple> mustSet) {
        rel = checkNotNull(relation);
        may = checkNotNull(maySet);
        must = checkNotNull(mustSet);
    }

    @Override
    public Set<Relation> getConstrainedRelations() {
        return Set.of(rel);
    }

    @Override
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(Map<Relation, RelationAnalysis.Knowledge> knowledgeMap, Context analysisContext) {
        RelationAnalysis.Knowledge k = knowledgeMap.get(rel);
        Set<Tuple> d = difference(k.getMaySet(), may);
        Set<Tuple> e = difference(must, k.getMustSet());
        if (d.size() + e.size() != 0) {
            logger.info("Assumption disables {} and enables {} at {}", d.size(), e.size(), rel.getNameOrTerm());
        }
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(d, e));
    }
}
