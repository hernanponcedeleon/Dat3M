package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.ArrayList;
import java.util.List;

public class Emptiness extends Axiom {

    public Emptiness(Relation rel, boolean negated, boolean flag) {
        super(rel, negated, flag);
    }

    public Emptiness(Relation rel) {
        super(rel, false, false);
    }

    @Override
    protected EventGraph getEncodeGraph(Context analysisContext) {
        return analysisContext.get(RelationAnalysis.class).getKnowledge(rel).getMaySet();
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