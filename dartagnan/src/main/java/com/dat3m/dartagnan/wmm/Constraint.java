package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface Constraint {

    Collection<? extends Relation> getConstrainedRelations();

    default Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        return Map.of();
    }

    default Map<Relation, RelationAnalysis.ExtendedDelta> computeIncrementalKnowledgeClosure(
            Relation origin,
            Set<Tuple> disabled,
            Set<Tuple> enabled,
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        return Map.of();
    }

    default Map<Relation, Set<Tuple>> getEncodeTupleSets(VerificationTask task, Context analysisContext) {
        return Map.of();
    }

    default BooleanFormula consistent(EncodingContext context) {
        return context.getBooleanFormulaManager().makeTrue();
    }
}
