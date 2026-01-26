package com.dat3m.dartagnan.wmm.axiom;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;

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
    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitEmptiness(this);
    }

    @Override
    public String toString() {
        return (flag ? "flag " : "") + (negated ? "~" : "") + "empty " + rel.getNameOrTerm();
    }
}