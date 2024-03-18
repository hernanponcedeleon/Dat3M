package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Emptiness extends Axiom {

    public Emptiness(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Emptiness(Relation rel) {
        super(rel, false, false);
    }

    @Override
    public Map<Relation, RelationAnalysis.ExtendedDelta> computeInitialKnowledgeClosure(
            Map<Relation, RelationAnalysis.Knowledge> knowledgeMap,
            Context analysisContext) {
        return Map.of(rel, new RelationAnalysis.ExtendedDelta(knowledgeMap.get(rel).getMaySet(), EventGraph.empty()));
    }

    @Override
    protected EventGraph getEncodeGraph(Context analysisContext) {
        final RelationAnalysis ra = analysisContext.get(RelationAnalysis.class);
        return ra.getKnowledge(rel).getMaySet();
    }

    @Override
    public List<BooleanFormula> consistent(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        final EncodingContext.EdgeEncoder edge = ctx.edge(rel);
        getEncodeGraph(ctx.getAnalysisContext())
                .apply((e1, e2) -> enc.add(edge.encode(e1, e2)));
        return negated ? List.of(bmgr.or(enc)) : enc.stream().map(bmgr::not).toList();
    }

    @Override
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitEmptiness(this);
    }

    @Override
    public String toString() {
        return (negated ? "~" : "") + "empty " + rel.getNameOrTerm();
    }
}